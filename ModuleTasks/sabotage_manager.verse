
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }

using { Modules.SabotageTimeBar }
using { Ui.Widgets }

SabotagesCategory<public><localizes>:message := "SabotageDevices"


log_sabotage_manager := class(log_channel){}


sabotage_manager<public> := class(creative_device, event_listener):
    Logger<private>:log = log{Channel:=log_sabotage_manager, DefaultLevel:=log_level.Normal}

    @editable EventManager<private>:event_manager = event_manager{}

    @editable{Categories := array{SabotagesCategory}} DevicesLockDoors : Tasks.task_devices_sabotage_lock_doors = Tasks.task_devices_sabotage_lock_doors{}
    @editable{Categories := array{SabotagesCategory}} DevicesReactorFail : Tasks.task_devices_sabotage_reactor_fail = Tasks.task_devices_sabotage_reactor_fail{}
    @editable{Categories := array{SabotagesCategory}} DevicesOxygenDepletion:Tasks.task_devices_sabotage_oxygen_depletion = Tasks.task_devices_sabotage_oxygen_depletion{}
    @editable{Categories := array{SabotagesCategory}} DevicesComms:Tasks.task_devices_sabotage_comms = Tasks.task_devices_sabotage_comms{}
    @editable{Categories := array{SabotagesCategory}} DevicesLightsOff:Tasks.task_devices_sabotage_electrical = Tasks.task_devices_sabotage_electrical{}

    @editable CSQ_SabotageBar<private>:cinematic_sequence_device = cinematic_sequence_device{}

    var Sabotages<private>:[task_name]sabotage_basic = map{}

    # Track sabotage banner views for each player
    var SabotageBannerViews<private>:[player]Ui.Widgets.view_sabotage_banner = map{}

    # Track global sabotage cooldown
    var GlobalCooldownEndTime<private>:float = 0.0

    Init<public>():void =
        set Sabotages = map:
            task_name.SabotageO2 => Tasks.Make_sabotage_oxygen_depletion(DevicesOxygenDepletion),
            task_name.SabotageReactorFail => Tasks.Make_sabotage_reactor_fail(DevicesReactorFail),
            task_name.SabotageElectrical => Tasks.Make_sabotage_electrical(DevicesLightsOff),
            task_name.SabotageComms => Tasks.Make_sabotage_comms(DevicesComms),
            task_name.SabotageLockDoors => Tasks.Make_sabotage_lock_doors(DevicesLockDoors)

        for(Sabotage:Sabotages):
            set Sabotage.EventManager = EventManager
            Sabotage.Init()
            Sabotage.Enable()
            Sabotage.EventCooldownEnded.Subscribe(OnSabotageButtonCooldownEnd, false)

            for(Stage:Sabotage.Stages, Player:GetAPlayersRound()):
                Stage.DisableMapIndicator(Player.Player)

        # Subscribe to shared stage events
        EventManager.Subscribe(event_type.TASK_ADVANCED, Self)
        EventManager.Subscribe(event_type.EMERGENCY_MEETING_STATUS, Self)

    Update<override>(EventPayload:event_payload):void =
        case(EventPayload.EventType):
            event_type.TASK_ADVANCED =>
                if(Payload := event_task_advanced[EventPayload], Sabotage := Sabotages[Payload.TaskName], Payload.IsTaskCompleted?):
                    Logger.Debug("Task completed sabotage stage [{Payload.TaskName}, {Payload.StageId}]")
                    Sabotage.EventSabotageResolved.Signal()

            event_type.EMERGENCY_MEETING_STATUS =>
                if(Payload := event_emergency_meeting_status[EventPayload], Player := Payload.Player?):
                    if(Payload.Status?):
                        StopActiveSabotage()

            #         # Sabotage.IsTaskCompleted

            # event_type.PLAYER_STAGE_FAILED =>
            #     if(Payload := event_player_stage_failed[EventPayload], Sabotage := Sabotages[Payload.TaskName], Player := Payload.Player?):
            #         Logger.Debug("Player failed sabotage stage [{Payload.TaskName}, {Payload.StageId}]")
            _ =>

    # IsSabotageRunning<public>()<transacts><decides>:void =
    #     _RunningSabotage?

    # IsSabotageCoolingDown<public>()<transacts><decides>:void = 
    #     _SabotageCooldownTimeLeft > 0.0

    # GetSabotageCooldown<public>()<transacts><decides>:float = 
    #     IsSabotageCoolingDown[]
    #     _SabotageCooldownTimeLeft

    # # Stop player playing at specific task and stage
    # StopPlaying<public>(Player:player, TaskName:task_name, StageId:int):task_module_response =
    #     if(Task := GetTask[TaskName]):
    #         if(HasTask[Player, TaskName]):
    #             return Task.Stop(Player, StageId)
    #         else:
    #             return task_module_response.PLAYER_NOT_ASSIGNED
    #     else:
    #         return task_module_response.TASK_INDEX_NOT_FOUND
            
    # # Stop player playing at everything
    # StopPlaying<public>(Player:player):void =
    #     for(PlayerTask:GetPlayerTasks[Player]):
    #         PlayerTask.Stop(Player)

    # # Stop players at playing
    # StopPlaying<public>():void =
    #     for(TaskName -> Task:AllTasks):
    #         Task.Stop()

    HideMapIndicators<public>(Players:[]player):void = 
        # Nascondo gli indicatori
        for(TaskName -> Task:Sabotages):
            set Task.EventManager = EventManager
            Task.Init()
            Print("disable task indicators..")
            for(Stage:Task.Stages, Player:Players):
                Stage.DisableMapIndicator(Player)
                Print("disable")



    # Returns the single active sabotage, if any
    GetActiveSabotage<public>()<transacts><decides>:sabotage_basic =
        var ActiveSabotage:?sabotage_basic = false
        for(Sabotage:Sabotages, Sabotage.IsActive[]):
            set ActiveSabotage = option{Sabotage}
        ActiveSabotage?

    # Returns the name of the active sabotage, if any
    GetActiveSabotageName<public>()<transacts><decides>:task_name =
        Sabotage := GetActiveSabotage[]
        Sabotage.Name

    # Returns true if any sabotage is currently active
    IsSabotageActive<public>()<transacts><decides>:void =
        GetActiveSabotage[]

    # Get the current global cooldown time remaining (0.0 if no cooldown)
    GetGlobalCooldownTimeRemaining<public>()<transacts>:float =
        TimeRemaining := GlobalCooldownEndTime - GetSecondsSinceEpoch()
        if(TimeRemaining > 0.0):
            TimeRemaining
        else:
            0.0

    # Get the state of all sabotages (enabled, not in cooldown, no sabotage active, no global cooldown)
    GetSabotagesState<public>()<transacts>:[task_name]logic =
        # If any sabotage is active, all buttons should be disabled
        if(IsSabotageActive[]):
            map:
                task_name.SabotageO2 => false
                task_name.SabotageReactorFail => false
                task_name.SabotageComms => false
                task_name.SabotageLockDoors => false
                task_name.SabotageElectrical => false
        # If global cooldown is active, all buttons should be disabled
        else if(GetGlobalCooldownTimeRemaining() > 0.0):
            map:
                task_name.SabotageO2 => false
                task_name.SabotageReactorFail => false
                task_name.SabotageComms => false
                task_name.SabotageLockDoors => false
                task_name.SabotageElectrical => false
        else:
            map:
                task_name.SabotageO2 => GetSabotageState(task_name.SabotageO2)
                task_name.SabotageReactorFail => GetSabotageState(task_name.SabotageReactorFail)
                task_name.SabotageComms => GetSabotageState(task_name.SabotageComms)
                task_name.SabotageLockDoors => GetSabotageState(task_name.SabotageLockDoors)
                task_name.SabotageElectrical => GetSabotageState(task_name.SabotageElectrical)

    # Helper function to get the state of a single sabotage
    GetSabotageState<private>(SabotageName:task_name)<transacts>:logic =
        for(Sabotage:Sabotages, Sabotage.Name = SabotageName):
            return logic:
                Sabotage.IsEnabled[]
                not Sabotage.IsCoolingDown[]
        false

    # Check if this sabotage can be started - only allow one sabotage at a time
    CanStartSabotage<public>(SabotageName:task_name)<transacts><decides>:void =
        # Only allow starting if NO other sabotages are active
        not IsSabotageActive[]

    StartSabotage<public>(Instigator:player, TaskName:task_name):logic =
        Logger.Normal("Trying to start sabotage {TaskName}..")

        # Check if this sabotage can be started based on mutual exclusion rules
        if(not CanStartSabotage[TaskName]):
            Logger.Normal("Cannot start sabotage {TaskName} due to mutual exclusion rules")
            return false

        if(SabotageToStart := Sabotages[TaskName]):
            MaybeStarted := SabotageToStart.StartSabotage()

            if(MaybeStarted?):
                spawn:
                    HandleSabotage(SabotageToStart, Instigator)
                return true

        return false

    HandleSabotage<private>(Sabotage:sabotage_basic, Instigator:player)<suspends>:void = 

        # Setup sabotage bar (only for non-door sabotages that have timers)
        if(Sabotage.Name <> task_name.SabotageLockDoors and Sabotage.Duration > 0.0):
            CSQ_SabotageBar.SetPlayRate(40.0/Sabotage.Duration)
            CSQ_SabotageBar.Play()

            # Show banner to all players
            ShowSabotageBanner(Sabotage)

        # Signal sabotage started
        EventManager.SabotageStatusChanged.Signal((true, Sabotage.Name))
        EventManager.Notify(event_sabotage_status{Instigator:=option{Instigator}, SabotageStatus:=true, SabotageName:=Sabotage.Name})

        for(TmpSabotage:Sabotages, TmpSabotage.Name <> Sabotage.Name):
            TmpSabotage.Disable()

        race:
            block:
                # Sabotage resolved in time
                Sabotage.EventSabotageResolved.Await()
                Logger.Print("Sabotage resolved!")
            
            block:
                # Sabotage time expired
                if(Sabotage.Duration=0.0):
                    Logger.Print("Sabotage.Duration is 0")
                    Sleep(Inf)
                else:
                    Logger.Print("Sleeping for sabotage duration: {Sabotage.Duration}")
                    Sleep(Sabotage.Duration)
                    
                    if(Sabotage.SabotageType = sabotage_type.Critical):
                        Logger.Print("Critical sabotage lost")
                        EventManager.CriticalSabotageTimeout.Signal()
                        # TODO Impostors win
            
            block:
                # Wait for stopping
                Sabotage.EventSabotageStopped.Await()
            
            block:
                # If the emergency meeting start, abrupt sabotage. Only on report bodies. 
                # Normal emergency meeting cannot start during sabotages
                if(Sabotage.CanBeStoppedByEmergencyMeeting?, EM := ModuleEmergencyMeeting.GetEmergencyMeeting[]):
                    EM.EventMeetingStarted.Await()
                else:
                    Sleep(Inf)
                    
            block:
                # Timer updates
                loop:
                    Sleep(0.3)
                    if(TimeRemaining := Sabotage.GetTimeRemaining[]):
                        EventManager.Notify(event_sabotage_remaining_time{RemainingTime:=TimeRemaining})
                        UpdateSabotageBanner(TimeRemaining, Sabotage)

        # Stop sabotage, if not already stopped
        Sabotage.StopSabotage()
        CSQ_SabotageBar.Stop()

        # Hide banner from all players
        HideSabotageBanner()

        # Start cooldown for the sabotage that just ended
        Sabotage.StartCooldown()

        # Start a short anti-spam cooldown on all other sabotages (e.g., 15 seconds)
        GlobalCooldownDuration:float = 15.0
        # for(TmpSabotage:Sabotages, TmpSabotage.Name <> Sabotage.Name):
        #     TmpSabotage.StartCooldown(?CooldownTime := GlobalCooldownDuration)

        # Start global cooldown timer update loop
        spawn:
            StartGlobalCooldownTimer(GlobalCooldownDuration)

        # Enable all other sabotages (not in cooldown)
        for(TmpSabotage:Sabotages, not TmpSabotage.IsCoolingDown[]):
            TmpSabotage.Enable()

        # Notify subs
        EventManager.SabotageStatusChanged.Signal((false, Sabotage.Name))
        EventManager.Notify(event_sabotage_status{Instigator:=false, SabotageStatus:=false, SabotageName:=Sabotage.Name})
        
        
    # Start and manage the global sabotage cooldown timer for all impostor UIs
    StartGlobalCooldownTimer<private>(Duration:float)<suspends>:void =
        StartTime := GetSecondsSinceEpoch()
        set GlobalCooldownEndTime = StartTime + Duration

        # Notify that cooldown started with initial duration
        EventManager.Notify(event_sabotage_cooldown_remaining_time{RemainingTime := Duration, IsJustStarted := true})

        loop:
            TimeElapsed := GetSecondsSinceEpoch() - StartTime
            TimeRemaining := Duration - TimeElapsed

            if(TimeRemaining <= 0.0):
                # Cooldown finished, set to 0 and exit
                set GlobalCooldownEndTime = 0.0
                EventManager.Notify(event_sabotage_cooldown_remaining_time{RemainingTime := 0.0, IsJustOver := true})
                break

            # Notify all listeners (impostor UIs) with the time remaining
            EventManager.Notify(event_sabotage_cooldown_remaining_time{RemainingTime := TimeRemaining})

            Sleep(0.2)  # Update 3 times per second

    # Stop the currently active sabotage (if any)
    StopActiveSabotage<public>():void =
        if(ActiveSabotage := GetActiveSabotage[]):
            ActiveSabotage.StopSabotage()

    # Start global cooldown (typically called at game start)
    StartGlobalCooldown<public>(Duration:float):void =
        spawn:
            StartGlobalCooldownTimer(Duration)

    OnSabotageButtonCooldownEnd<public>(Sabotage:sabotage_basic):void =
        Logger.Debug("OnSabotageButtonCooldownEnd")
        # Only enable the sabotage button if no other sabotage is currently active
        if(IsSabotageActive[]):
            Sabotage.Disable()
        else:
            Sabotage.Enable()

    # Show sabotage banner to all players
    ShowSabotageBanner<private>(Sabotage:sabotage_basic):void =
        for(APlayer:GetAPlayers()):
            BannerView := Ui.Widgets.Make_view_sabotage_banner(APlayer, Sabotage)
            BannerView.Show()
            if(set SabotageBannerViews[APlayer.Player] = BannerView){}

    # Update sabotage banner for all players
    UpdateSabotageBanner<private>(TimeLeft:float, Sabotage:sabotage_basic):void =
        if(Time:=Ceil[TimeLeft]):
            for(Player -> BannerView : SabotageBannerViews):
                BannerView.UpdateBanner(Time)

    # Hide sabotage banner from all players
    HideSabotageBanner<private>():void =
        for(Player -> BannerView : SabotageBannerViews):
            BannerView.Destroy()

        set SabotageBannerViews = map{}

    # Not the best but it's an easy way to extract the stages completion for the sabotage
    GetSabotageStagesCompletion<public>(Player:player):?tuple(int,int) =
        if(Sabotage:=GetActiveSabotage[]):
            StagesCompletion := Sabotage.GetStagesCompletion(Player)
            option{StagesCompletion}
        false

    
    