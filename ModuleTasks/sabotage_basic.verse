
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }

SabBtnFrameClickable:int = 120
SabBtnFrameDisabled:int = 0
SabBtnFrameStartCooldown:int = 12
SabBtnFrameEndCooldown:int = 120

sabotage_state<public> := enum:
    Disabled      # Button is disabled, cannot be clicked
    CoolingDown   # Button is in cooldown, shows timer animation
    Enabled       # Button is enabled and ready to be clicked
    Active        # Sabotage is currently running

sabotage_basic<public> := class(task_basic):
    Duration<public>:float = 10.0
    SabotageType<public>:sabotage_type = sabotage_type.NonCritical
    SabotageCooldownTime<public>:float = 60.0
    CanBeStoppedByEmergencyMeeting<public>:logic = false
    Devices<public>:sabotage_devices_basic = sabotage_devices_basic{}

    var<public> State:sabotage_state = sabotage_state.Disabled

    var<private> CooldownStartedAt:float = 0.0
    var<private> SabotageStartedAt:float = 0.0
    var<private> CurrentCooldownDuration:float = 0.0

    # EventActivated<public>:event() = event(){}
    # EventTimeout<public>:event() = event(){}
    # EventStopped<public>:event() = event(){}
    # EventPaused<public>:event() = event(){}
    # EventResolved<public>:event() = event(){}
    EventSabotageResolved<public>:event() = event(){}
    EventSabotageStopped<public>:event() = event(){}
    EventCooldownEnded<public>:custom_subscribable(sabotage_basic) = custom_subscribable(sabotage_basic){}
    EventCooldownCancelled<private>:event() = event(){}

    # Get time remaining in the sabotage
    GetTimeRemaining<public>()<transacts><decides>:float =
        State = sabotage_state.Active
        ElapsedTime := GetSecondsSinceEpoch() - SabotageStartedAt
        Duration - ElapsedTime

    # Initialize sabotage
    Init<override>():void =
        (super:)Init()
        Enable()

    # Get sabotage info for displaying on map
    GetSabotageInfo<public>()<transacts>:sabotage_info =
        sabotage_info:
            SabotageName := Name
            StagesInfo := for(Stage:Stages):
                sabotage_stage_info:
                    StageId := Stage.StageId
                    Location := Stage.Location
                    Coordinates := Stage.Coordinates

    # Activate sabotage
    StartSabotage<public>():logic =
        Logger.Normal("Starting sabotage: {Name}")

        if(not IsInitialized?):
            Logger.Error("Unable to activate sabotage if not initialized priorly.")
            return false

        if(State = sabotage_state.Active):
            Logger.Error("Unable to activate sabotage, sabotage already running!")
            return false

        if(State <> sabotage_state.Enabled):
            Logger.Error("Unable to activate sabotage, sabotage not enabled!")
            return false

        set State = sabotage_state.Active
        set SabotageStartedAt = GetSecondsSinceEpoch()
        OnSabotageStarted()

        Devices.SequenceCooldown.Play()
        Devices.SequenceCooldown.SetPlaybackFrame(SabBtnFrameDisabled)
        Devices.SequenceCooldown.Pause()

        Print("StartSabotage: Assigning players for {Name}")
        for(APlayer:GetAPlayersRound()):
            AssignPlayer(APlayer.Player)

        Print("StartSabotage: Calling OnSabotageStarted for {Name} stages")
        for(Stage:Stages, SabotageStage:=sabotage_stage_base[Stage]):
            SabotageStage.OnSabotageStarted()

        return true

    OnSabotageStarted<protected>():void = { }

    # Stop sabotage
    StopSabotage<public>():void =
        if(State = sabotage_state.Active):
            set State = sabotage_state.Disabled
            set SabotageStartedAt = 0.0
            OnSabotageStopped()

            for(Stage:Stages, SabotageStage:=sabotage_stage_base[Stage]):
                SabotageStage.OnSabotageStopped()

            RemoveAllPlayers()

    OnSabotageStopped<protected>():void = {}

    # Disable the sabotage from being clicked or activated
    Disable<public>():void =
        if(State <> sabotage_state.Disabled):
            Devices.SequenceCooldown.Play()
            Devices.SequenceCooldown.SetPlaybackFrame(SabBtnFrameDisabled)
            Devices.SequenceCooldown.Pause()
            set State = sabotage_state.Disabled

    # Enable the sabotage from being clicked or activated
    Enable<public>():void =
        if(State <> sabotage_state.Enabled):
            Devices.SequenceCooldown.Play()
            Devices.SequenceCooldown.SetPlaybackFrame(SabBtnFrameClickable)
            Devices.SequenceCooldown.Pause()
            set State = sabotage_state.Enabled

    # Start the cooldown for this sabotage
    # CooldownTime defaults to SabotageCooldownTime if not specified
    # If already cooling down, cancels the current one and starts a new one if the new duration is longer
    StartCooldown<public>(?CooldownTime:float = SabotageCooldownTime):void =
        if(State = sabotage_state.CoolingDown):
            # Already cooling down - only restart if new duration is longer
            TimeRemaining := (CooldownStartedAt + CurrentCooldownDuration) - GetSecondsSinceEpoch()
            if(CooldownTime > TimeRemaining):
                # New cooldown is longer, cancel current and start new one
                EventCooldownCancelled.Signal()
                # Wait a frame to let the old coroutine die
                spawn {HandleCooldown(CooldownTime)}
        else:
            # Not cooling down, start new cooldown
            set State = sabotage_state.CoolingDown
            spawn {HandleCooldown(CooldownTime)}

    HandleCooldown<private>(CooldownTime:float)<suspends>:void =
        Logger.Normal("Cooling down sabotage {Name} for {CooldownTime} seconds.")
        set CooldownStartedAt = GetSecondsSinceEpoch()
        set CurrentCooldownDuration = CooldownTime

        # Show cooldown animation
        # tot 120 frames
        # frame 0 = 1.0
        # frame 1 = 0.0
        # frame 120 = 1.0
        Devices.SequenceCooldown.Play()
        Sleep(0.0)
        Devices.SequenceCooldown.SetPlaybackFrame(SabBtnFrameStartCooldown)
        Devices.SequenceCooldown.SetPlayRate((SabBtnFrameEndCooldown-SabBtnFrameStartCooldown)*1.0/12.0/CooldownTime)

        # Wait for cooldown to finish or be cancelled
        race:
            block:
                # Cooldown is over
                Sleep(CooldownTime)
            block:
                # Cooldown was cancelled
                EventCooldownCancelled.Await()
                # Exit early without triggering EventCooldownEnded
                set CooldownStartedAt = 0.0
                set CurrentCooldownDuration = 0.0
                set State = sabotage_state.Disabled
                return

        # Cooldown completed normally
        set CooldownStartedAt = 0.0
        set CurrentCooldownDuration = 0.0

        Enable()

        # Notify that cooldown ended
        EventCooldownEnded.Signal(Self)

    IsCoolingDown<public>()<decides><transacts>:void =
        State = sabotage_state.CoolingDown

    IsEnabled<public>()<decides><transacts>:void =
        State = sabotage_state.Enabled

    IsActive<public>()<decides><transacts>:void =
        State = sabotage_state.Active


    