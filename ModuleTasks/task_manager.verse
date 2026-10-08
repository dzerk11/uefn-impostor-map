using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Concurrency }

using { ModuleAmongusPlayspace }
using { ModuleLanguage }
using { Tasks }


task_provider<public> := interface:
    GetPlayerTasksInfo<public>(Player:player):[]task_info

    
log_task_manager := class(log_channel){}


var TaskManagers<public>:weak_map(session, task_manager) = map{}


GetTaskManager<public>()<decides><transacts>:task_manager =
    TaskManagers[GetSession()]


TasksCategory<public><localizes>:message := "Tasks"


task_manager<public> := class(creative_device, event_listener, lifecycle, task_provider):
    Logger<private>:log = log{Channel:=log_task_manager, DefaultLevel:=log_level.Normal}
    NumberOfTasksPerPlayer:type {_X:int where _X >= 0} = 150
    MaxPendingTasksPerPlayer:type {_X:int where _X >= 0} = 3

    @editable {Categories:=array{TasksCategory}} PassCode<public>:task_pass_code = task_pass_code{}
    @editable {Categories:=array{TasksCategory}} PassCodeSecurity<public>:task_pass_code_security = task_pass_code_security{}
    @editable {Categories:=array{TasksCategory}} TuneSignal<public>:task_tune_signal = task_tune_signal{}
    @editable {Categories:=array{TasksCategory}} CrazyPowerSupply<public>:task_crazy_power_supply = task_crazy_power_supply{}
    @editable {Categories:=array{TasksCategory}} Fuel<public>:task_fuel = task_fuel{}
    @editable {Categories:=array{TasksCategory}} Shields<public>:task_shields = task_shields{}
    @editable {Categories:=array{TasksCategory}} DivertPower<public>:task_divert_power = task_divert_power{}
    @editable {Categories:=array{TasksCategory}} SubmitScan<public>:task_submit_scan = task_submit_scan{}
    @editable {Categories:=array{TasksCategory}} ReactorNumbers<public>:task_reactor_numbers = task_reactor_numbers{}
    @editable {Categories:=array{TasksCategory}} CallEarth<public>:task_call_earth = task_call_earth{}
    @editable {Categories:=array{TasksCategory}} Labyrinth<public>:task_labyrinth = task_labyrinth{}
    @editable {Categories:=array{TasksCategory}} ClearSpace<public>:task_clear_space = task_clear_space{}
    @editable {Categories:=array{TasksCategory}} TransferData<public>:task_upload_transfer_data = task_upload_transfer_data{}
    @editable {Categories:=array{TasksCategory}} AlignUpperEngine<public>:task_align_upper_engine = task_align_upper_engine{}
    @editable {Categories:=array{TasksCategory}} AlignLowerEngine<public>:task_align_lower_engine = task_align_lower_engine{}
    @editable {Categories:=array{TasksCategory}} EmptyGarbage<public>:task_empty_garbage = task_empty_garbage{}

    @editable EventManager<private>:event_manager = event_manager{}
    @editable TaskBar<private>:tasks_bar = tasks_bar{}

    @editable SoundStageCompleted<private>:audio_player_device = audio_player_device{}
    
    var AllTasks<private>:[task_name]task_basic = map{}
    var PlayerTasksMap<private>:[player][]task_name = map{}
    var PlayerTaskCoins<private>:[player][task_name]logic = map{}

    # Task completion tracking
    var TasksCompleted<public>:int = 0
    var TasksToWin<public>:int = 0

    Init<override>():void = 
        Logger.Normal("Initializing task manager")
        if:
            not TaskManagers[GetSession()]
            set TaskManagers[GetSession()] = Self

        # Initialize all tasks
        set AllTasks = map:
            # task_name.PassCode => PassCode
            task_name.PassCodeSecurity => PassCodeSecurity
            # task_name.TuneSignal => TuneSignal
            task_name.CrazyPowerSupply => CrazyPowerSupply
            task_name.Fuel => Fuel
            task_name.Shields => Shields
            task_name.DivertPower => DivertPower
            task_name.SubmitScan => SubmitScan
            task_name.ReactorNumbers => ReactorNumbers
            task_name.CallEarth => CallEarth
            task_name.Labyrinth => Labyrinth
            task_name.ClearSpace => ClearSpace
            task_name.TransferData => TransferData
            task_name.AlignUpperEngine => AlignUpperEngine
            task_name.AlignLowerEngine => AlignLowerEngine
            task_name.EmptyGarbage => EmptyGarbage

        # Subscribe to events
        EventManager.Subscribe(event_type.TASK_ADVANCED, Self)
        EventManager.Subscribe(event_type.PLAYER_STAGE_REWARD, Self)
        EventManager.Subscribe(event_type.EMERGENCY_MEETING_STATUS, Self)

        # Init tasks
        for(TaskName -> Task:AllTasks):
            set Task.EventManager = EventManager
            Task.Init()
            
    Dispose<override>():void =
        Logger.Normal("Disposing task manager")
        EventManager.UnSubscribe(Self)

    Update<override>(EventPayload:event_payload):void =
        case(EventPayload.EventType):
            event_type.TASK_ADVANCED =>
                if(Payload := event_task_advanced[EventPayload], AllTasks[Payload.TaskName]):
                    if(Payload.IsTaskCompleted?):
                        set TasksCompleted += 1
                        Logger.Print("Task completed! Total: {TasksCompleted}/{TasksToWin}")
                        SoundStageCompleted.Play(Payload.PlayerWhoAdvanced)
                        AssignTasksToPlayers(array{Payload.PlayerWhoAdvanced})

                        # Check if crewmates won
                        if(HaveCrewmatesWon[]):
                            Logger.Print("Crewmates won by completing tasks!")
                            # TODO: Notify game end event

                    # Signal player task list update
                    EventManager.Notify( event_player_task_list {
                        Data := GetPlayerTasksInfo(Payload.PlayerWhoAdvanced)
                        Player := option{Payload.PlayerWhoAdvanced}
                    })

                    # Signal overall tasks completion
                    EventManager.Notify( event_task_completion {
                        StagesCompletable := TasksToWin
                        StagesCompleted := TasksCompleted
                    })

            event_type.EMERGENCY_MEETING_STATUS =>
                if(Payload := event_emergency_meeting_status[EventPayload]):
                    if(Payload.Status?):
                        StopPlaying()
                        for(Task:AllTasks, Stage:Task.Stages):
                            Stage.StageDevices.Beacon.Disable()
                    else:
                        for(Task:AllTasks, Stage:Task.Stages):
                            Stage.StageDevices.Beacon.Disable()

            event_type.PLAYER_STAGE_REWARD =>
                if(Payload := event_player_stage_reward[EventPayload], AllTasks[Payload.TaskName], Player := Payload.Player?):
                    OnRewardPlayer(Player, Payload.TaskName, Payload.StageId, Payload.RewardType)
                    Logger.Debug("PLAYER_STAGE_REWARD event received for {Payload.TaskName}, {Payload.StageId}")

            _ =>

    # Get all tasks assigned to a player
    GetPlayerTasks<public>(Player:player)<reads>:[]task_basic =
        for(TaskName:PlayerTasksMap[Player], Task:=AllTasks[TaskName]):
            Task

    # Get a task by its name
    GetTask<public>(TaskName:task_name)<transacts><decides>:task_basic =
        AllTasks[TaskName]

    # Check if player has such task or not
    HasTask<private>(Player:player, TaskName:task_name)<transacts><decides>:void =
        PlayerTasksMap[Player].Find[TaskName]

    # Make player play a task
    PlayTask<public>(Player:player, TaskName:task_name, StageId:int):void = 
        if(Task := AllTasks[TaskName]):
            Task.Start(Player, 0)
            
    # Stop player playing at everything
    StopPlaying<public>(Player:player):void =
        for(PlayerTask:GetPlayerTasks(Player)):
            PlayerTask.Stop(Player)

    # Stop players at playing
    StopPlaying<public>():void =
        for(TaskName -> Task:AllTasks):
            Task.Stop()

    # Disable task indicators
    HideMapIndicators<public>(Players:[]player):void = 
        for(TaskName -> Task:AllTasks):
            for(Stage:Task.Stages, Player:Players):
                Stage.DisableMapIndicator(Player)

    # Assign tasks to ensure player has MaxPendingTasksPerPlayer incomplete tasks
    AssignTasksToPlayers<public>(Players:[]player):void =
        Logger.Print("[AssignTasksToPlayers] Starting assigning tasks...")
        var AllAvailableTasks:[]task_basic = for(TaskName -> Task:AllTasks){Task}

        # Assign tasks to players
        for(Player:Players):
            set AllAvailableTasks = Shuffle(AllAvailableTasks)
            CurrentPlayerTasks := GetPlayerTasks(Player)

            # Count incomplete tasks
            IncompleteCount := for(CurrentTask:CurrentPlayerTasks, not CurrentTask.HasCompleted[Player]){CurrentTask}.Length

            Print("Incomplete tasks for player: {IncompleteCount}")

            # Calculate how many tasks we need to assign
            TasksToAssign := Max(0, MaxPendingTasksPerPlayer - IncompleteCount)

            Print("Tasks to assign to player: {TasksToAssign}")

            if(TasksToAssign > 0):
                CurrentPlayerTaskNames := PlayerTasksMap[Player] or array{}

                # Find tasks not yet assigned to this player
                TasksNotOwned:[]task_basic = for(Task:AllAvailableTasks, not CurrentPlayerTaskNames.Find[Task.Name]):
                    Task

                # Assign the calculated number of tasks
                var NewTaskNames:[]task_name = CurrentPlayerTaskNames
                TasksAssigned := Min(TasksToAssign, TasksNotOwned.Length)

                for(I := 0..TasksAssigned - 1):
                    if(NewTask := TasksNotOwned[I]):
                        IsAssigned := NewTask.AssignPlayer(Player)
                        if(IsAssigned?):
                            Logger.Print("Player assigned to: {NewTask.Name}")
                            set NewTaskNames += array{NewTask.Name}
                        else:
                            Logger.Print("Unable to assign task {NewTask.Name} to player", ?Level:=log_level.Error)

                # Update player's task map once
                if(set PlayerTasksMap[Player] = NewTaskNames){}

            # Notify player of updated task list
            EventManager.Notify(event_player_task_list{Player:=option{Player}, Data:=GetPlayerTasksInfo(Player)})

        # Signal overall tasks completion
        Completion := GetTasksCompletion()
        EventManager.Notify( event_task_completion {
            StagesCompletable := Completion(1)
            StagesCompleted := Completion(0)
        })
    

    GetPlayerTasksInfo<override>(Player:player):[]task_info =
        # Loop player tasks, filter only task
        for(Task:GetPlayerTasks(Player)):
            Task.GetPlayerTaskInfo(Player)

    AdvanceTask<public>(Player:player, TaskName:task_name, StageId:int):task_module_response =
        var Result:task_module_response = task_module_response.KO
        if(Task := GetTask[TaskName]):
            if(HasTask[Player, TaskName]):
                set Result = Task.AdvanceTask(Player, StageId)
            else:
                set Result = task_module_response.PLAYER_NOT_ASSIGNED
                Logger.Error("Unable to advance task if player doesn't own it.")
        else:
            set Result = task_module_response.TASK_INDEX_NOT_FOUND
            Logger.Error("Unable to advance task that doesn't exist.")

        Result

    OnRewardPlayer<public>(Player:player, TaskName:task_name, StageId:int, RewardType:Utils.award_type):void =
        Logger.Normal("OnRewardPlayer")
        case(RewardType):
            Utils.award_type.Medium =>
                # TaskDevices := GetTask[TaskId]
                # if(TaskDevices):
                #     TaskDevices.RewardPlayer(Player, StageId, RewardType)
            Utils.award_type.Coin =>
                if(not PlayerTaskCoins[Player][TaskName]?, set PlayerTaskCoins[Player][TaskName] = true):
                    Logger.Normal("Rewarding player with coin for task {TaskName}")
                    # EventManager.Notify(event_reward_player_coins{TargetPlayers:=array{Player}, Coins:=1})
                
            _ =>

    GetTasksCompletion<public>():tuple(int,int) =
        var CompletedCount:int = 0
        var TotalCount:int = 0
        for(Task:AllTasks):
            TaskCompletion := Task.GetCompletion()
            set CompletedCount += TaskCompletion(0)
            set TotalCount += TaskCompletion(1)
        (CompletedCount, TotalCount)

    # Initialize the target tasks to win based on number of crewmates
    # 6 tasks per crewmate
    InitTasksToWin<public>(NumCrewmates:int):void =
        set TasksToWin = 6 * NumCrewmates
        Logger.Print("Tasks to win initialized: {TasksToWin} ({NumCrewmates} crewmates)")

    # Call when a crewmate leaves the game
    # Reduces TasksToWin by 6 and adjusts TasksCompleted to maintain the same completion percentage
    OnCrewmateLeft<public>():void =
        if(TasksToWin > 0):
            # Calculate new target
            NewTasksToWin := Max(TasksToWin - 6, 0)

            # Adjust completed to maintain same percentage
            # Formula: NewCompleted = TasksCompleted * (NewTasksToWin / TasksToWin)
            if(NewTasksToWin > 0, NewCompleted := Floor[TasksCompleted * 1.0 * (NewTasksToWin * 1.0 / (TasksToWin * 1.0))]):
                set TasksCompleted = NewCompleted
            else:
                set TasksCompleted = 0

            OldTasksToWin := TasksToWin
            set TasksToWin = NewTasksToWin

            Logger.Print("Crewmate left. Tasks: {TasksCompleted}/{TasksToWin} (was {OldTasksToWin})")

            # Update UI
            EventManager.Notify( event_task_completion {
                StagesCompletable := TasksToWin
                StagesCompleted := TasksCompleted
            })

            # Check if crewmates won after adjustment
            if(HaveCrewmatesWon[]):
                Logger.Print("Crewmates won by completing tasks!")
                # TODO: Notify game end event

    # Check if crewmates have won by completing enough tasks
    HaveCrewmatesWon<public>()<decides><transacts>:void =
        TasksCompleted >= TasksToWin
        TasksToWin > 0

