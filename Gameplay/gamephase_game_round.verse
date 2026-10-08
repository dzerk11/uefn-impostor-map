
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /Fortnite.com/Game }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Verse.org/Colors }

using { ModuleTasks }
using { ModuleKillButton }
using { Mechanics }
using { ModuleAmongusModel }
using { ModuleAmongusPlayspace }
using { ModuleEmergencyMeeting }
using { Modules.SabotageTimeBar }
using { Ui }
using { Ui.Widgets }
using { ModuleUtils }



var GameRounds<public>:weak_map(session, gamephase_game_round) = map{}


gamephase_game_round_log := class(log_channel){}


gamephase_game_round<public> := class(gamephase_class, event_listener):

    Logger<override>:log = log{Channel:=gamephase_game_round_log, DefaultLevel:=log_level.Debug}

    @editable TaskManagerDevice<private>:task_manager = task_manager{}
    @editable SabotageManagerDevice<private>:sabotage_manager = sabotage_manager{}
    @editable EmergencyMeetingDevice<private>:emergency_meeting_device = emergency_meeting_device{}
    @editable KillButton<private>:kill_button_device = kill_button_device{}
    @editable DeadBodiesController<private>:dead_bodies_controller = dead_bodies_controller{}
    @editable InteractivePlayerMap<private>:ModuleInteractivePlayerMap.interactive_player_map_device = ModuleInteractivePlayerMap.interactive_player_map_device{}
    @editable AmongusColorAssigner<private>:amongus_color_assigner = amongus_color_assigner{}
    @editable SecurityCameraManager<private>:security_camera_manager = security_camera_manager{}
    @editable Bo<private>:player_reveal_device = player_reveal_device{}

    @editable EmergencyMeetingButton<private>:button_device = button_device{}

    @editable TeleportersAroundTable<private>:[]teleporter_device = array{}

    @editable HudControllerLobby:hud_controller_device = hud_controller_device{}
    @editable HudControllerRound:hud_controller_device = hud_controller_device{}
    @editable HudControllerShowRole:hud_controller_device = hud_controller_device{}

    @editable FadeTransition<private>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable MutatorZoneTable<private>:mutator_zone_device = mutator_zone_device{}

    var ViewTaskbar<private>:[player]view_taskbar = map{}
    var ViewObjectivesHud<private>:[player]view_objectives_hud = map{}
    var ViewRoleHud<private>:[player]view_role_hud = map{}

    # --------------- [ Methods ] ---------------

    Init<override>():void = 
        (super:)Init()

        if:
            not GameRounds[GetSession()]
            set GameRounds[GetSession()] = Self

        TaskManagerDevice.Init()
        SabotageManagerDevice.Init()

        EmergencyMeetingButton.InteractedWithEvent.Subscribe(OnPlayerReportEmergencyMeeting)
        KillButton.EventKillButton.Subscribe(OnKillButtonEvent, false)
        DeadBodiesController.EventBodyReported.Subscribe(OnPlayerReportBody, false)
        EventManager.Subscribe(event_type.SABOTAGE_BUTTON_CLICK, Self)
        EventManager.Subscribe(event_type.TASK_STARTED, Self)
        EventManager.Subscribe(event_type.STAGE_ENDED, Self)
        EventManager.Subscribe(event_type.INTERACTIVE_PLAYER_MAP_VISIBILITY_CHANGE, Self)
        EventManager.Subscribe(event_type.EMERGENCY_MEETING_STATUS, Self)
        EventManager.Subscribe(event_type.PLAYER_REVEAL_STATUS_CHANGED, Self)
        EventManager.Subscribe(event_type.SECURITY_CAMERA_VIEWING_CHANGED, Self)

        spawn:
            Start()

    Dispose<override>():void = 
        TaskManagerDevice.Dispose()
        EmergencyMeetingDevice.Stop()

    Start<public>()<suspends>:void =
        APlayers := GetAPlayers()
        Players := for(APlayer:APlayers){APlayer.Player}
        Playspace := GetPlayspace()
        TeamCollection := Playspace.GetTeamCollection()
        Teams := TeamCollection.GetTeams()

        # Assign random unique number (1-12) to each player
        # TODO Test each one 
        var AvailableNumbers:[]int = array{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        # var AvailableNumbers:[]int = array{1}
        set AvailableNumbers = Shuffle(AvailableNumbers)
        for(Index -> APlayer:APlayers):
            APlayer.SetPlayerState(amongus_player_state.InGame)
            if(RandomNumber := AvailableNumbers[Index]):
                APlayer.SetNumber(RandomNumber)
                APlayer.ChangeClass(RandomNumber + 19)
                APlayer.ShowColor()
        
        # Split teams
        SeparatePlayersIntoTeams(APlayers)

        # Assign tasks
        SabotageManagerDevice.HideMapIndicators(Players)
        TaskManagerDevice.HideMapIndicators(Players)
        TaskManagerDevice.AssignTasksToPlayers(Players)

        # Freeze players
        MutatorZoneTable.Enable()
        StasysArgs:stasis_args = stasis_args:
            AllowTurning := false
            AllowFalling := false
            AllowEmotes := false
        for(APlayer:APlayers, FNCharacter := APlayer.Player.GetFortCharacter[]):
            FNCharacter.PutInStasis(StasysArgs)

        # Show role reveal
        FadeTransition.Play()
        Sleep(0.9)
        HudControllerShowRole.Enable()
        var RoleRevealWidgets:[amongus_player]view_role_reveal = map{}
        for(APlayer:APlayers):
            View := Make_view_role_reveal(APlayer)
            if(set RoleRevealWidgets[APlayer] = View):
                View.Show()

        # Teleport players in cafeteria
        for(Index -> APlayer:APlayers):
            if(Teleporter := TeleportersAroundTable[Index]):
                Teleporter.Teleport(APlayer.Player)
        
        # End: Show role reveal
        Sleep(8.0)
        FadeTransition.Stop()
        FadeTransition.SetPlaybackFrame(0)
        FadeTransition.Play()
        FadeTransition.StoppedEvent.Await()

        for(APlayer->View:RoleRevealWidgets):
            View.Destroy()

        # View taskbar
        for(APlayer:APlayers):
            View := Make_view_taskbar(APlayer, TaskManagerDevice, EventManager)
            if(set ViewTaskbar[APlayer.Player] = View):
                View.Show()
            else:
                View.Destroy()

        KillButton.Start()
        InteractivePlayerMap.Enable()
        HudControllerRound.Enable()
        HudControllerLobby.Disable()
        HudControllerShowRole.Disable()

        # ReleaseFromStasis
        for(APlayer:APlayers, FNCharacter := APlayer.Player.GetFortCharacter[]):
            FNCharacter.ReleaseFromStasis()
        MutatorZoneTable.Disable()

        # Show color index
        # for(APlayer:APlayers):
        #     AmongusColorAssigner.ShowColor(APlayer.Player)

        # Show role HUD to all players
        for(APlayer:APlayers):
            RoleHudView := Widgets.Make_view_role_hud(APlayer)
            if(set ViewRoleHud[APlayer.Player] = RoleHudView):
                RoleHudView.Show()
            else:
                RoleHudView.Destroy()

        # Show objectives HUD to all players
        for(APlayer:APlayers):
            ObjectivesHudView := Widgets.Make_view_objectives_hud(APlayer, TaskManagerDevice, SabotageManagerDevice, EventManager)
            if(set ViewObjectivesHud[APlayer.Player] = ObjectivesHudView):
                ObjectivesHudView.Show()
            else:
                ObjectivesHudView.Destroy()

        # Start initial global sabotage cooldown (15 seconds)
        SabotageManagerDevice.StartGlobalCooldown(15.0)
        EmergencyMeetingDevice.RestartCountdownButton()

        # Temp Debug - spawn ghost for first player
        # if(APlayer := APlayers[0]):
        #     APlayer.SetGhost()
        #     if(GhostTeam := Teams[TEAM_GHOST], TeamCollection.AddToTeam[APlayer.Player, GhostTeam]){}
        #     KillButton.RemovePlayer(APlayer.Player)
        #     Color := APlayer.GetColor()
        #     DeadBodiesController.SpawnGhost(Color, APlayer.Player)
            
        
        # for(APlayer:APlayers, Team := Teams[19], TeamCollection.AddToTeam[APlayer.Player, Team]):
            # Assign player to team 20

        # if(APlayer:=APlayers[0]):
        #     Bo.Play(APlayer.Player)

        # loop:
        #     Sleep(5.0)

        #     # Show color index
        #     for(APlayer:APlayers):
        #         AmongusColorAssigner.HideColor(APlayer.Player)

        #     Sleep(5.0)

        #     # Show color index
        #     for(APlayer:APlayers):
        #         AmongusColorAssigner.ShowColor(APlayer.Player)


    Update<override>(EventPayload:event_payload):void =
        case(EventPayload.EventType):
            event_type.TASK_STARTED =>
                if(Payload := event_task_started[EventPayload], Player := Payload.Player?):
                    # InteractivePlayerMap.Hide(Player)
                    if(Payload.HideHudOnStart?):
                        Print("hide hud on start")
                        KillButton.HidePlayerIcon(Player)

            event_type.STAGE_ENDED =>
                if(Payload := event_stage_ended[EventPayload], Player := Payload.Player?):
                    if(APlayer := GetAPlayer[Player]):
                        if(APlayer.IsImpostor[]):
                            KillButton.ShowPlayerIcon(Player)
            
            event_type.INTERACTIVE_PLAYER_MAP_VISIBILITY_CHANGE =>
                if(Payload := event_interactive_player_map_visibility_change[EventPayload], Player := Payload.Player?):
                    if(Payload.Status?):
                        KillButton.HidePlayerIcon(Player)
                    else:
                        if(APlayer := GetAPlayer[Player]):
                            if(APlayer.IsImpostor[]):
                                KillButton.ShowPlayerIcon(Player)

            event_type.SECURITY_CAMERA_VIEWING_CHANGED =>
                if(Payload := event_security_camera_viewing_changed[EventPayload], Player := Payload.Player?):
                    if(Payload.IsViewing?):
                        if(View:=ViewObjectivesHud[Player]):
                            View.Hide()
                        if(View:=ViewRoleHud[Player]):
                            View.Hide()
                        KillButton.HidePlayerIcon(Player)
                        Self.GetPlayspace().GetHUDController().HideElementsForPlayer(Player, array{
                            creative_hud_identifier_all{}
                        })
                    else:
                        if(View:=ViewObjectivesHud[Player]):
                            View.Show()
                        if(View:=ViewRoleHud[Player]):
                            View.Show()
                        if(APlayer := GetAPlayer[Player]):
                            if(APlayer.IsImpostor[]):
                                KillButton.ShowPlayerIcon(Player)
                        Self.GetPlayspace().GetHUDController().ResetElementsForPlayer(Player, array{
                            creative_hud_identifier_all{}
                        })

            event_type.EMERGENCY_MEETING_STATUS =>
                if(Payload := event_emergency_meeting_status[EventPayload]):
                    if(Payload.Status?):
                        # for(View:ViewObjectivesHud):
                        #     View.Hide()
                        SecurityCameraManager.HideAll()
                        TaskManagerDevice.StopPlaying()
                        InteractivePlayerMap.Disable()
                        # TaskManagerDevice.Stop()
                        # for(View:ViewRoleHud):
                        #     View.Hide()
                        # for(View:ViewTaskbar):
                        #     View.Hide()
                        # for(APlayer:GetAPlayersRound()):
                        #     Self.GetPlayspace().GetHUDController().HideElementsForPlayer(APlayer.Player, array{
                        #         creative_hud_identifier_all{}
                        #     })
                        MutatorZoneTable.Enable()
                    else:
                        StopEmergencyMeeting()
                        KillButton.ShowPlayerIcon()
                        InteractivePlayerMap.Enable()
                        for(View:ViewObjectivesHud):
                            View.Show()
                        for(View:ViewRoleHud):
                            View.Show()
                        for(View:ViewTaskbar):
                            View.Show()
                        MutatorZoneTable.Disable()
                            
            event_type.PLAYER_REVEAL_STATUS_CHANGED =>
                if(Payload := event_player_reveal_status_changed[EventPayload]):
                    if(Payload.Status?):
                        KillButton.HidePlayerIcon()
                        InteractivePlayerMap.Disable()
                        for(View:ViewObjectivesHud):
                            View.Hide()
                        for(View:ViewRoleHud):
                            View.Hide()
                        for(View:ViewTaskbar):
                            View.Hide()
                        Payload.PlayerToReveal.HideColor()
                        for(APlayer:GetAPlayersRound()):
                            Self.GetPlayspace().GetHUDController().HideElementsForPlayer(APlayer.Player, array{
                                creative_hud_identifier_all{}
                            })
                    else:
                        # Remove ghost impostor from kill button system
                        if(Payload.PlayerToReveal.IsImpostor[]):
                            KillButton.RemovePlayer(Payload.PlayerToReveal.Player)
                        KillButton.ShowPlayerIcon()
                        InteractivePlayerMap.Enable()
                        for(View:ViewObjectivesHud):
                            View.Show()
                        for(View:ViewRoleHud):
                            View.Show()
                        for(View:ViewTaskbar):
                            View.Show()

                        spawn:
                            Saaa(Payload.PlayerToReveal)

                        # Teleport players in cafeteria
                        APlayers := GetAPlayersRound()
                        for(Index -> APlayer:APlayers):
                            if(Teleporter := TeleportersAroundTable[Index]):
                                Teleporter.Teleport(APlayer.Player)

                        for(APlayer:GetAPlayersRound()):
                            Self.GetPlayspace().GetHUDController().ResetElementsForPlayer(APlayer.Player, array{
                                creative_hud_identifier_all{}
                            })

            _ =>

    Saaa<public>(APlayer:amongus_player)<suspends>:void =
        Sleep(1.0)
        APlayer.ShowColor()
        spawn{ShowEliminatedWidget(APlayer.Player)}

    OnKillButtonEvent<private>(Impostor:player, PlayerToKill:player):void =
        if:
            AImpostor := GetAPlayer[Impostor]
            Victim := GetAPlayer[PlayerToKill]
            VictimCharacter := PlayerToKill.GetFortCharacter[]
        then:
            KillButton.PlayKillAnimation(Impostor)

            # Spawn dead body at victim location
            VictimTransform := VictimCharacter.GetTransform()
            VictimColor := Victim.GetColor()
            NewDeadBodyTransform := transform:
                Scale := vector3{X:=0.25, Y:=0.25, Z:=0.25}
                Rotation := VictimTransform.Rotation
                Translation := VictimTransform.Translation
            DeadBodiesController.BringIn(VictimColor, NewDeadBodyTransform)

            # Mark victim as ghost and move to ghost team
            Victim.SetGhost()
            GhostPlayspace := GetPlayspace()
            GhostTeamCollection := GhostPlayspace.GetTeamCollection()
            GhostTeams := GhostTeamCollection.GetTeams()
            if(GhostTeam := GhostTeams[TEAM_GHOST], GhostTeamCollection.AddToTeam[PlayerToKill, GhostTeam]){}
            DeadBodiesController.SpawnGhost(VictimColor, PlayerToKill)
            spawn{ShowEliminatedWidget(PlayerToKill)}

            # Check win condition (only count living players)
            Impostors := for(AP:GetAPlayers(gameplay_role.Impostor), not AP.IsGhost?):
                AP
            Crewmates := for(AP:GetAPlayers(gameplay_role.Crewmate), not AP.IsGhost?):
                AP
            if(Crewmates.Length <= Impostors.Length):
                Print("Game won by impostors")
                


    ShowEliminatedWidget<private>(Player:player)<suspends>:void =
        if(PlayerUI := GetPlayerUI[Player]):
            Widget := Modules.WBP_Eliminated{}
            WidgetCanvas := canvas:
                Slots := array:
                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                        Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                        SizeToContent := false
                        Widget := Widget
            PlayerUI.AddWidget(WidgetCanvas, player_ui_slot{InputMode := ui_input_mode.None, ZOrder := 100})
            set Widget.Start = true
            Sleep(3.0)
            PlayerUI.RemoveWidget(WidgetCanvas)

    SeparatePlayersIntoTeams<private>(APlayers:[]amongus_player):void =
        var NumberOfImpostors:int = 0
        Playspace := GetPlayspace()
        TeamCollection := Playspace.GetTeamCollection()
        Teams := TeamCollection.GetTeams()

        if:
            # Calculate number of impostors needed
            TmpNumberOfImpostors:int = Ceil[(APlayers.Length*1.0) / (ImpostorsRateo*1.0)]
            set NumberOfImpostors = TmpNumberOfImpostors
            NumberOfImpostors
            TeamImpostor := Teams[TEAM_IMPOSTOR]
            TeamCrewmates := Teams[TEAM_CREWMATE]

        then:
            Logger.Print("Number of impostors to generate {NumberOfImpostors}")
            var TempImpostorsCounter:int = 0
            var CrewmateIndex:int = 0  # Crewmates start at index 0 (class 1)
            var ImpostorIndex:int = 12  # Impostors start at index 12 (class 13)

            for(APlayer:APlayers):
                if(TempImpostorsCounter < NumberOfImpostors, TeamCollection.AddToTeam[APlayer.Player, TeamImpostor]):
                    # Impostors
                    APlayer.SetRole(gameplay_role.Impostor)

                    # APlayer.ChangeClass(ImpostorIndex)
                    set ImpostorIndex += 1
                    set TempImpostorsCounter += 1
                else if(TeamCollection.AddToTeam[APlayer.Player, TeamCrewmates]):
                    # Crewmates
                    APlayer.SetRole(gameplay_role.Crewmate)
                    # APlayer.ChangeClass(CrewmateIndex)
                    set CrewmateIndex += 1
                else:
                    Logger.Error("Unable to assign player to team")

        else Logger.Print("Unable to generate impostors", ?Level:=log_level.Error)
            # Restarta il game todo

    OnPlayerReportEmergencyMeeting<private>(Agent:agent):void =
        if(not EmergencyMeetingDevice.IsRunning?, not SabotageManagerDevice.IsSabotageActive[]):
            spawn{StartEmergencyMeeting(Agent, "Emergency meeting")}

    OnPlayerReportBody<private>(Agent:agent, BodyReported:amongus_color):void =
        if(not EmergencyMeetingDevice.IsRunning?):
            if(SabotageManagerDevice.IsSabotageActive[]):
                SabotageManagerDevice.StopActiveSabotage()
            spawn:
                StartEmergencyMeeting(Agent, "Dead body")

    StartEmergencyMeeting<private>(Agent:agent, Reason:string)<suspends>:void = 
        if(Reason = "Emergency meeting"):
            Logger.Print("Emergency meeting called!")
        else if(Reason = "Dead body"):
            Logger.Print("Dead body found!")

        IsStarted := EmergencyMeetingDevice.Start(false, emergency_meeting_source.ReportBody)
        if(IsStarted?):
            # Stops others mechanics
            TaskManagerDevice.StopPlaying()
            InteractivePlayerMap.Disable()
            KillButton.Disable() 
            
        
            # Get players interested
            APlayers := GetAPlayers()

            # Clear current players activities
            # for(AmongusPlayer:Players):
            #     AmongusPlayer.PlayerUi.HideWidget(ui_screen_type.PLAYER_MAP_INTERACTIVE)
            #     AmongusPlayer.PlayerUi.HideWidget(ui_screen_type.PLAYER_MAP)

            # for(AmongusPlayer:Players):
                # show animation todo

            EmergencyMeetingDevice.EventMeetingEnded.Await()
            # StopEmergencyMeeting()
            KillButton.ShowPlayerIcon()
            InteractivePlayerMap.Enable()
            # for(AmongusPlayer:Players):
            #     AmongusPlayer.PlayerUi.ShowWidget(ui_screen_type.PLAYER_MAP)

    StopEmergencyMeeting<private>():void = 
        KillButton.Enable()
        # InputTriggerHarvest.Enable()    

        
        

        # Teleport player to emergency room
        # Put player in stasys
        # Enable input trigger to open ui
        # Move players to team if needed
        # Enable subscriptions to buttons
        # Wait 30 seconds

        # Se pareggio skippa
        # Se non ci sono abbastanza voti skippa
        # Se giocatore da uccidere, animazione per tutti

        # Riporta tutti nella posizione scorsa



    # OnSecondarySignalEvent(Agent:agent):void = 
    #     _Logger.Debug("RemoteManager: Secondary clicked")
        # # ObjectiveDevice.Hide()
        # # ObjectiveDevice.Destroy(Agent)
        # if (Player:=player[Agent]):
        #     # AssignPlayerToTeam(Player, teamName.Lobby)

        #     ## TODO
        #     _UiManager.ShowInteractivePlayerMap(array{Player},teamName.Impostors)

    # OnPrimarySignalEvent(Agent:agent):void = 
    #     _Logger.Debug("RemoteManager: Primary clicked")

        # if (Player:=player[Agent], FNCharacter:fort_character = Player.GetFortCharacter[]):
        #     Rotation := FNCharacter.GetViewRotation()
        #     Transformation := FNCharacter.GetTransform()
        #     Translation := Transformation.Translation

        #     PlayerDistance := Distance(Translation, PillarCoordinates)
        #     # Print("distanza:{PlayersDistance}")

        #     if (PlayerDistance<=500.0):
        #         Sequencer.Play(Agent)


        # Sequencer.Play(Agent)
        # MessageDevice_temp.Show(Agent)
        # ObjectiveDevice.Show()
        # if (Player:=player[Agent]):
        #     AssignPlayerToTeam(Player, teamName.Crewmates)

