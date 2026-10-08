
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }

using { ModuleAmongusPlayspace }

emergency_meeting_log := class(log_channel){}

var EmergencyMeetings<public>:weak_map(session, emergency_meeting_device) = map{}

GetEmergencyMeeting<public>()<decides><transacts>:emergency_meeting_device =
    EmergencyMeetings[GetSession()]

emergency_meeting_source<public> := enum:
    ReportBody
    EmergencyButton

emergency_meeting_device<public> := class(creative_device, event_listener):
    Logger<private>:log = log{Channel:=emergency_meeting_log, DefaultLevel:=log_level.Debug}
    Subscriptions<private>:Utils.subscription_manager = Utils.subscription_manager{}
    
    # Devices
    @editable EventManager<private>:event_manager = event_manager{}
    @editable TimerDevice<private>:timer_device = timer_device{}
    @editable InputTriggerHarvest<private>:input_trigger_device = input_trigger_device{}
    @editable RoomTeleporters<private>:[]teleporter_device = array{}
    @editable AudioEmergencyCallout<private>:audio_player_device = audio_player_device{}
    @editable CountdownDevice<private>:emergency_meeting_countdown_device = emergency_meeting_countdown_device{}
    @editable PlayerRevealDevice<private>:player_reveal_device = player_reveal_device{}
    @editable RadioDevicesBackgroundMusic<private>:[]radio_device = array{}
    @editable PlayerVotedVfx<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable PlayerVotedVfxClear<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable SphereAroundTable<private>:creative_prop = creative_prop{}

    # Events
    EventPlayerVoted<public>:custom_subscribable(tuple(player, int)) = custom_subscribable(tuple(player, int)){}
    EventForceStop<private>:event() = event(){}
    EventVotationCompleted<private>:event() = event(){}
    EventMeetingEnded<public>:event() = event(){}
    
    EventMeetingStarted<public>:custom_subscribable(tuple(?player, emergency_meeting_source)) = custom_subscribable(tuple(?player, emergency_meeting_source)){}
    
    # Data
    var<private> IsRunning<public>:logic = false 
    var<private> Participants<internal>:[]emergency_meeting_participant = array{}
    var<private> ParticipantsMapped<internal>:[player]emergency_meeting_participant = map{}
    var ViewCallout<private>:[amongus_player]view_emergency_callout = map{}
    var ViewCountdown<private>:[amongus_player]view_time_left = map{}

    OnBegin<override>():void = 
        if:
            not EmergencyMeetings[GetSession()]
            set EmergencyMeetings[GetSession()] = Self
    
        InputTriggerHarvest.Disable()
        SphereAroundTable.Hide()

    Start<public>(Instigator:?player, Source:emergency_meeting_source):logic = 
        if(not IsRunning?):
            # if(TaskManager := ModuleTasks.GetTaskManager[], SabotageManagerDevice.GetActiveSabotageNames[], Source <> emergency_meeting_source.ReportBody):
            #     return false
            spawn:
                Handler(Instigator, Source)
            true
        else:
            false

    Stop<public>(?Instigator:?player = false):void = 
        if(IsRunning?):
            EventForceStop.Signal()
            
            for(Participant:Participants):
                PlayerVotedVfxClear.Pickup(Participant.APlayer.Player)

                if:
                    FNCharacter := Participant.APlayer.Player.GetFortCharacter[]
                    Rotation := FNCharacter.GetViewRotation()
                    FNCharacter.TeleportTo[Participant.OldTranslation, Rotation]

                if(Widget := Participant.Widget?):
                    Widget.Destroy()

                if(View := ViewCountdown[Participant.APlayer]):
                    View.Destroy()


            for(View:ViewCallout):
                View.Destroy()

            for(View:ViewCountdown):
                View.Destroy()
    
            set Participants = array{}
            set ParticipantsMapped = map{}
            set ViewCallout = map{}
    
            TimerDevice.Reset()
            InputTriggerHarvest.Disable()
            SphereAroundTable.Hide()

            for(AudioDevice:RadioDevicesBackgroundMusic):
                AudioDevice.Stop()
                AudioDevice.UnregisterAll()
            
            set IsRunning = false
            EventManager.Notify(event_emergency_meeting_status{Instigator:=Instigator, Status:=false})
            EventManager.UnSubscribe(Self)
            EventMeetingEnded.Signal()
            CountdownDevice.Reset()

    Handler<private>(Instigator:?player, Source:emergency_meeting_source)<suspends>:void = 
        set IsRunning = true
        EventManager.Subscribe(event_type.SABOTAGE_STATUS_CHANGED, Self)
        Subscriptions.Add(InputTriggerHarvest.PressedEvent.Subscribe(OnInputTriggerHarverPressedEvent))

        EventManager.Notify(event_emergency_meeting_status{Status:=true, Instigator:=Instigator})
        EventMeetingStarted.Signal((Instigator, Source))
        CountdownDevice.Disable()
        Sleep(0.3)
        
        # Load players
        AmongusPlayers := GetAPlayersRound()

        var VotesReceived:[player]int = map{}
        for(APlayer:AmongusPlayers, set VotesReceived[APlayer.Player] = 0):
            Widget := Make_view_emergency_callout(APlayer, if(Source = emergency_meeting_source.ReportBody){true}else{false})
            if(set ViewCallout[APlayer] = Widget):
                Widget.Show()

            ViewTimeLeft := Make_view_time_left(APlayer)
            ViewTimeLeft.UpdateTime(60)
            if(set ViewCountdown[APlayer] = ViewTimeLeft):
                ViewTimeLeft.Show()
        
        AudioEmergencyCallout.Enable()
        AudioEmergencyCallout.Play()

        Sleep(1.0)

        SphereAroundTable.Show()

        # Teleport players
        for(Index->APlayer:AmongusPlayers):
            Player := APlayer.Player
            if:
                FNCharacter:fort_character = Player.GetFortCharacter[]
                FNCharacterTranslation := FNCharacter.GetTransform().Translation
                Rotation := FNCharacter.GetViewRotation()
            then:
                NewParticipant := emergency_meeting_participant{
                    APlayer := APlayer
                    OldTranslation := FNCharacterTranslation
                    CanBeVoted := logic{not APlayer.IsGhost?}
                    CanVote := logic{not APlayer.IsGhost?}
                }

                if(set ParticipantsMapped[Player] = NewParticipant):
                    set Participants += array{NewParticipant}

                if(RoomTeleporter := RoomTeleporters[Index]):
                    RoomTeleporter.Teleport(APlayer.Player)
                else:
                    Logger.Error(Message:="Emergency meeting handler: unable to teleport player")    
            else:
                Logger.Error(Message:="Emergency meeting handler: unable to initialize player")

        if(AudioDevice := RadioDevicesBackgroundMusic[GetRandomInt(0, RadioDevicesBackgroundMusic.Length-1)]):
            for(Participant:Participants):
                AudioDevice.Register(Participant.APlayer.Player)
                AudioDevice.Play()

        Sleep(4.0)
        for(View:ViewCallout):
            View.Destroy()

        AudioEmergencyCallout.Stop()
        AudioEmergencyCallout.Disable()

        InputTriggerHarvest.Enable()

        # Push data
        for(Participant:Participants, Widget := Participant.Widget?):
            Widget.SetCells(Participants)
            Widget.Show()

        # Start countdown
        TimerDevice.Start()
        TimerDevice.SetActiveDuration(60.0)

        # Wait game
        race:
            # Just to update time left
            loop:
                Sleep(1.0)
                if(TimeLeft := Ceil[TimerDevice.GetActiveDuration()]):
                    UpdateTimeLeft(TimeLeft)

                    for(View:ViewCountdown):
                        View.UpdateTime(Ceil(TimeLeft))

            # Wait completion
            block:
                race:
                    # Timer ended check who won
                    block:
                        TimerDevice.SuccessEvent.Await()
                        # Print("time is over! let's see..")

                    # All player completed before end of time
                    block:
                        Sleep(Inf)
                        EventVotationCompleted.Await()
                        Print("All players voted before end of time")

            EventForceStop.Await()

            # Time out for safety
            Sleep(50.0)

        # Change scene
        InputTriggerHarvest.Disable()
        for(AudioDevice:RadioDevicesBackgroundMusic):
            AudioDevice.Stop()
            AudioDevice.UnregisterAll()
        for(View:ViewCountdown):
            View.Destroy()
        for(View:ViewCountdown):
            View.Destroy()
        for(Participant:Participants, Widget := Participant.Widget?):
            Widget.Destroy()
        
        # Draw most voted partecipant
        MostVotedParticipants := DrawMostVotedPlayer()

        if(MostVotedParticipants.Length = 0):
            Print("nessun player da eliminare")
        else if(MostVotedParticipants.Length = 1, MostVotedParticipant := MostVotedParticipants[0]):
            PlayerRevealDevice.PlayAnimation(MostVotedParticipant.APlayer.Player)
        else:
            Print("elimina {MostVotedParticipants.Length} players")
            Print("draw")

        # Emergency is ended
        Stop()
        
    Update<override>(EventPayload:event_payload):void = 
        case(EventPayload.EventType):
            event_type.SABOTAGE_STATUS_CHANGED => 
                if(Payload := event_sabotage_status[EventPayload]):
                    if(Payload.SabotageStatus?):
                        # Stop players from calling emergency by button, they can still do it by reporting bodies
                    else:
                        # Restore players from calling emergency by button, they can still do it by reporting bodies
            _ =>    
                Logger.Print(Message:="emergency meeting handler: event not handled", ?Level:=log_level.Error)

    UpdateTimeLeft<private>(Time:int):void = 
        for(Participant:Participants, Widget := Participant.Widget?):
            Widget.UpdateTimeLeft(Time)

    GetTimeLeft<internal>():int = 
        if(TimeLeft := Ceil[TimerDevice.GetActiveDuration()]):
            TimeLeft
        else:
            0

    OnPlayerVote<internal>(VoterPlayer:player, VotedPlayer:player):void = 
        Logger.Debug("OnPlayerVote")

        if(VoterParticipant := ParticipantsMapped[VoterPlayer], TargetParticipant  := ParticipantsMapped[VotedPlayer]):
            # Check if player can vote
            if(not VoterParticipant.CanVote?):
                Logger.Warning("Player cannot vote")
                return

            # Check if target can be voted for
            if(not TargetParticipant.CanBeVoted?):
                Logger.Warning("Target cannot be voted for")
                return

            # Remove previous vote
            if:
                PreviousVoteTarget := VoterParticipant.HasVoted?
                PreviousTargetParticipant  := ParticipantsMapped[PreviousVoteTarget]
                PreviousTargetUpdatedVotes := PreviousTargetParticipant.VotesReceived.RemoveElement[PreviousTargetParticipant.VotesReceived.Find[VoterPlayer]]
            then:
                set VoterParticipant.HasVoted = false
                set PreviousTargetParticipant.VotesReceived = PreviousTargetUpdatedVotes

                Print("Setting old votes")
                for(Participant:Participants, Widget := Participant.Widget?):
                    Widget.SetVotes(PreviousVoteTarget, PreviousTargetUpdatedVotes.Length)

            # Assign new vote
            set TargetParticipant.VotesReceived += array{VoterPlayer}
            set VoterParticipant.HasVoted = option{VotedPlayer}
            PlayerVotedVfx.Pickup(VoterPlayer)
            
            # Update widget: player who has voted and votes received
            Print("Setting new votes")
            for(Participant:Participants, Widget := Participant.Widget?):
                Widget.SetVotes(VotedPlayer, TargetParticipant.VotesReceived.Length)
                Widget.SetVotingDone(VoterPlayer, true)

            spawn:
                CloseTableAfterVote(VoterParticipant)

    CloseTableAfterVote<private>(Partecipant:emergency_meeting_participant)<suspends>:void = 
        if(Tablet := Partecipant.Widget?):
            Sleep(1.0)
            Tablet.Hide()
            Tablet.Destroy()

    # HasEveryoneVoted<private>()<transacts><decides>:void = 
    #     for(Participant:Participants):
    #         if(Participant.CanVote?, not Participant.HasVoted?):
    #             false? 

    OnInputTriggerHarverPressedEvent<private>(Agent:agent):void = 
        if (Player := player[Agent], Participant := ParticipantsMapped[Player]):
            if(OldWidget := Participant.Widget?):
                OldWidget.Destroy()
            
            Widget := Make_ui_widget_voting_tablet(Logger, Participant.APlayer, Self)
            Widget.Show()
            set Participant.Widget = option{Widget}

    DrawMostVotedPlayer<private>():[]emergency_meeting_participant =
        var MostVotedParticipants:[]emergency_meeting_participant = array{}
        var MaxVotesReceived:int = 0

        for(Participant:Participants, Participant.CanBeVoted?):
            if(Participant.VotesReceived.Length > MaxVotesReceived):
                set MaxVotesReceived = Participant.VotesReceived.Length
                set MostVotedParticipants = array{Participant}

            else if(Participant.VotesReceived.Length = MaxVotesReceived, MaxVotesReceived > 0):
                set MostVotedParticipants += array{Participant}

        MostVotedParticipants

    RestartCountdownButton<public>():void = 
        CountdownDevice.Reset()

    


    


    
        