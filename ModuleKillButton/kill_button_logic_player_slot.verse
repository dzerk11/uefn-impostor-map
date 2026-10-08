
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Verse.org/Concurrency }

kill_button_logic_player_slot_status<internal> := enum:
    Inactive
    Active
    Cooldown


kill_button_logic_player_slot<public> := class():
    Devices<public>:kill_button_player_devices
    Impostor<public>:player

    # Icon animation frame constants
    FRAME_INACTIVE<private>:int = 0
    FRAME_ACTIVE<private>:int = 60
    FRAME_COOLDOWN<private>:int = 120
    FRAME_MAX<private>:int = 899

    # Cooldown duration constant
    COOLDOWN_DURATION<private>:float = 30.0

    var TargetPlayer<private>:?player = false

    var TaskPolling<private>:?task(void) = false
    var TaskCooldown<private>:?task(void) = false

    var<private> IsVisible<public>:logic = false

    EventForceStopPolling<private>:event() = event(){}
    EventCancelCooldown<private>:event() = event(){}

    Start<public>():void =
        if(not IsPolling[]):
            Task := spawn{HandlePolling()}
            set TaskPolling = option{Task}

    Stop<public>():void =
        EventForceStopPolling.Signal()
        EventCancelCooldown.Signal()
        Devices.CSQ_KillIconState.Stop(Impostor)
        Devices.CSQ_KillIconWiggle.Stop(Impostor)

    IsPolling<public>()<transacts><decides>:void =
        TaskPolling?

    HandlePolling<private>()<suspends>:void =
        EventForceStopPolling.Signal()
        SetIconFrame(FRAME_INACTIVE)

        race:
            EventForceStopPolling.Await()

            block:
                if (ImCharacter := Impostor.GetFortCharacter[]):
                    loop:
                        Sleep(0.01)

                        # Impostor camera
                        ImCameraTranslation := ImCharacter.GetViewLocation()
                        ImCameraRotation := ImCharacter.GetViewRotation()
                        ImCameraForwardVector := ImCameraRotation.GetLocalForward()

                        # Impostor position
                        ImTranslation := ImCharacter.GetTransform().Translation

                        # Find closest killable player
                        var MaybeClosestPlayer:?tuple(player, float) = false

                        # Get all living crewmates (not ghosts, not impostors)
                        for(APlayer:GetAPlayersRound(), not APlayer.IsGhost?, not APlayer.IsImpostor[], CmCharacter := APlayer.Player.GetFortCharacter[]):
                            CmTranslation := CmCharacter.GetTransform().Translation

                            # Euclidean distance between players
                            DistanceFromPlayer := Distance(ImTranslation, CmTranslation)

                            # Player is close enough (450 units)
                            if (DistanceFromPlayer < 450.0):

                                DistanceCameraToPlayer := vector3:
                                    X := CmTranslation.X - ImCameraTranslation.X
                                    Y := CmTranslation.Y - ImCameraTranslation.Y
                                    Z := CmTranslation.Z - ImCameraTranslation.Z

                                if(NormImCameraForwardVector := ImCameraForwardVector.MakeUnitVector[], NormPlayersDistanceVector := DistanceCameraToPlayer.MakeUnitVector[]):

                                    # Check if Impostor is looking at player (dot product > 0.97)
                                    DotProd := DotProduct(NormPlayersDistanceVector, NormImCameraForwardVector)
                                    if (DotProd > 0.97):
                                        if (ClosestPlayer := MaybeClosestPlayer?):
                                            if(ClosestPlayer(1) > DistanceFromPlayer):
                                                set MaybeClosestPlayer = option{(APlayer.Player, DistanceFromPlayer)}
                                        else:
                                            set MaybeClosestPlayer = option{(APlayer.Player, DistanceFromPlayer)}

                        if(ClosestPlayer := MaybeClosestPlayer?):
                            CurrentStatus := GetStatus()
                            if(CurrentStatus = kill_button_logic_player_slot_status.Inactive):
                                SetTargetPlayer(ClosestPlayer(0))
                                SetIconFrame(FRAME_ACTIVE)
                            else if(CurrentStatus = kill_button_logic_player_slot_status.Active):
                                SetTargetPlayer(ClosestPlayer(0))

                        else:
                            CurrentStatus := GetStatus()
                            if(CurrentStatus = kill_button_logic_player_slot_status.Inactive):
                                RemoveTargetPlayer()
                            else if(CurrentStatus = kill_button_logic_player_slot_status.Active):
                                RemoveTargetPlayer()
                                SetIconFrame(FRAME_INACTIVE)

        Devices.CSQ_KillIconState.Pause(Impostor)
        set TaskPolling = false

    Show<public>():void =
        if(not IsVisible?):
            Devices.HMD_KillIcon.Show(Impostor)
            set IsVisible = true

    Hide<public>():void =
        if(IsVisible?):
            Devices.HMD_KillIcon.Hide(Impostor)
            set IsVisible = false

    GetStatus<private>():kill_button_logic_player_slot_status =
        CurrentFrame := Devices.CSQ_KillIconState.GetPlaybackFrame()

        if(CurrentFrame>=FRAME_ACTIVE and CurrentFrame<FRAME_COOLDOWN):
            kill_button_logic_player_slot_status.Active
        else if (CurrentFrame>FRAME_INACTIVE and CurrentFrame<FRAME_ACTIVE):
            kill_button_logic_player_slot_status.Inactive
        else if (CurrentFrame>=FRAME_COOLDOWN and CurrentFrame<=FRAME_MAX):
            kill_button_logic_player_slot_status.Cooldown
        else :
            kill_button_logic_player_slot_status.Inactive

    IsCoolingDown<public>()<transacts><decides>:void =
        TaskCooldown?

    StartCooldown<public>(?Duration:float=COOLDOWN_DURATION):void =
        Task := spawn{HandleCooldown(Duration)}
        set TaskCooldown = option{Task}

    HandleCooldown<private>(Duration:float)<suspends>:void =
        Print("Starting cooldown: {Duration} seconds")
        EventCancelCooldown.Signal()
        EventForceStopPolling.Signal()

        race:
            EventCancelCooldown.Await()
            block:
                SetIconFrame(FRAME_COOLDOWN)

                NormalizedPlayRate := (FRAME_MAX - FRAME_COOLDOWN)*1.0 / (COOLDOWN_DURATION * 30.0)
                Devices.CSQ_KillIconState.SetPlayRate(NormalizedPlayRate)
                Devices.CSQ_KillIconState.Play(Impostor)

                Sleep(Duration)
                Print("Cooldown expired")

                TaskPollingInstance := spawn{HandlePolling()}
                set TaskPolling = option{TaskPollingInstance}

        set TaskCooldown = false

    # Helper: Set icon frame and pause
    SetIconFrame<private>(Frame:int)<suspends>:void =
        Devices.CSQ_KillIconState.Play(Impostor)
        Sleep(0.0)
        Devices.CSQ_KillIconState.SetPlaybackFrame(Frame)
        Devices.CSQ_KillIconState.Pause(Impostor)

    SetTargetPlayer<public>(InPlayer:player):void =
        set Self.TargetPlayer = option{InPlayer}

    GetTargetPlayer<public>()<transacts><decides>:player =
        Self.TargetPlayer?

    RemoveTargetPlayer<private>():void =
        set Self.TargetPlayer = false

    SetIconWiggle<public>():void =
        Devices.CSQ_KillIconWiggle.Play()
