
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

log_task_basic := class(log_channel){}


Make_task_basic<internal><constructor>(Logger: log) := task_basic:
    Logger := Logger


task_basic<public> := class<unique>():
    Logger<public>:log = log{Channel:=log_task_basic}
    var EventManager<public>:event_manager = event_manager{}

    Name<public>:task_name = task_name.None # Unique task identifier
    CompletionType<public>:task_completion_type = task_completion_type.Solo # Whether the task is shared among users or not
    Type<public>:task_type = task_type.Task # Is it a task or a sabotage
    TaskIcon<public>:texture = Art.Textures.T_Transparent

    var<private> IsInitialized<public>:logic = false
    var<protected> PlayersAssigned<public>:[]player = array{} # Players assigned to this task
    var Stages<internal>:[]stage_base = array{}

    # Initiliaze
    Init<public>():void =
        OnInit()

        for(Index->Stage:Stages):
            Logger.Normal("Init stage: {Name} [{Index}]")
            
            if(CastedIndex := type{_X:int where 0 <= _X}[Index], Stage.SetStageId[CastedIndex]):
                Stage.Init()
            else:
                Logger.Error("Unable to set stage index: TaskName:{Name}, Index:{Index}")
                return

            for(IndicatorIndex -> Indicator:Stage.StageDevices.MapIndicators):
                Transform := Indicator.GetTransform()
                if:
                    set Stage.StageDevices.MapIndicatorsDefaultPositions += array{Transform}
                    Indicator.TeleportTo[transform{Translation:=vector3{X:=10000.0, Y:=10000.0, Z:=10000.0}}]

        set IsInitialized = true

    # Must be implemented in each subtype
    OnInit<protected>():void = {}

    # Check if player is assigned
    IsAssigned<public>(Player:player)<transacts><decides>:void =
        PlayersAssigned.Find[Player]

    # <overrided> Assign player
    AssignPlayer<public>(Player:player):logic =
        if(not Self.IsAssigned[Player]):
            if:
                for(Stage:Stages):
                    Stage.AssignPlayer[Player]
            then:
                set PlayersAssigned += array{Player}

                # Find all stages with the lowest order number
                var InitialStages:[]stage_base = array{}
                var LowestStageOrder:int = 999  # Initialize with a high value to find minimum

                # Find the minimum stage order
                for(Stage:Stages):
                    if(Stage.StageOrder < LowestStageOrder):
                        set LowestStageOrder = Stage.StageOrder

                # Collect all stages at the lowest order level
                if(LowestStageOrder < 999):  # Only if we found a valid order
                    for(Stage:Stages, Stage.StageOrder = LowestStageOrder):
                        set InitialStages += array{Stage}

                # Mark all initial stages as completable
                for(InitialStage:InitialStages):
                    InitialStage.SetCompletable(Player)

                Logger.Debug("Player assigned to task: {Name}")
                return true
            else:
                Logger.Warning("Unable to assign player to task {Name} due to stage failures.")
                return false
        else:
            Logger.Warning("Unable to assign player to task {Name}. Player already assigned.")
        return false

    # Remove player
    RemovePlayer<public>(PlayerToRemove:player):logic =
        if (NewPlayersAssigned := PlayersAssigned.RemoveElement[PlayersAssigned.Find[PlayerToRemove]]):
            for(Stage:Stages):
                Stage.RemovePlayer(PlayerToRemove)
            
            set PlayersAssigned = NewPlayersAssigned
            Logger.Debug("Player removed from {Name}")
            true
        else:
            false

    # Remove all players
    RemoveAllPlayers<public>():void =
        for(Player:PlayersAssigned):
            RemovePlayer(Player)

    # Is player playing any stage
    IsPlaying<public>(Player:player)<transacts><decides>:void =
        var Result:logic = false
        for(Stage:Stages, Stage.IsPlaying[Player]):
            set Result = true
        Result?

    # Start playing
    Start<public>(Player:player, StageId:int):void = 
        Logger.Debug("Starting player stage [{Name}, {StageId}]")
        if(Stage := Stages[StageId]):
            StartResult := Stage.Start(Player)
            if(StartResult = task_module_response.OK):
                # Determine if HUD should be hidden
                HideHud := logic{Stage.HideHudOnStart?}

                if(HideHud?):
                    # Hide hud elements
                    # Self.GetPlayspace().GetHUDController().HideElementsForPlayer(Player,array{
                    #     creative_hud_identifier_all{}
                    # })

                EventManager.Notify(event_task_started{Player:=option{Player}, TaskName:=Name, StageId:=StageId, MaybeWidget:=false, HideHudOnStart:=HideHud})

    # Stop playing at specific stage
    Stop<public>(Player:player, StageId:int):task_module_response = 
        if(Stage := Stages[StageId]):
            # Reset HUD if stage had HideHudOnStart enabled
            # if(Stage.HideHudOnStart?):
            #     Self.GetPlayspace().GetHUDController().ResetElementsForPlayer(Player, array{
            #         creative_hud_identifier_all{}
            #     })
            return Stage.Stop(Player)
        else:
            return task_module_response.STAGE_INDEX_NOT_FOUND

    # Stop player from all stages
    Stop<public>(Player:player):void = 
        for(Stage:Stages):
            Stage.Stop(Player)

    # Stop playing everyone
    Stop<public>():void = 
        for(Stage:Stages, Player:Stage.GetPlayersPlaying()):
            Stage.Stop(Player)
    
    # Has player completed this task
    HasCompleted<internal>(Player:player)<transacts><decides>:void =
        for(Stage:Stages, Stage.IsAssigned[Player], not Stage.HasCompleted[Player]):
            false?

    # Get completion task status among all players: tuple(total tasks completed, total tasks assigned)
    GetCompletion<public>():tuple(int,int) = 
        var Completion:int = 0
        var Completable:int = PlayersAssigned.Length
        for(Player:PlayersAssigned, HasCompleted[Player]):
            set Completion += 1
        (Completion,Completable)

    # Get stages completion for a specific player: tuple(stages completed, stages assigned)
    GetStagesCompletion<public>(Player:player):tuple(int,int) =
        var Completion:int = 0
        var Completable:int = 0
        for(Stage:Stages, Stage.IsAssigned[Player]):
            if(Stage.HasCompleted[Player]):
                set Completion += 1
            set Completable += 1
        (Completion, Completable)

    # Get player task info
    GetPlayerTaskInfo<internal>(Player:player):task_info =
        task_info:
            TaskName := Self.Name
            TaskType := Self.Type
            TaskIcon := Self.TaskIcon
            StagesInfo := for(Stage:Stages, Stage.IsAssigned[Player]){Stage.GetPlayerStageInfo(Player)}
            IsCompleted := logic{Self.HasCompleted[Player]}

    # Advance task by player
    AdvanceTask<internal>(Player:player, StageId:int):task_module_response = 
        var Result:task_module_response = task_module_response.KO
        if(StageToAdvance := Stages[StageId]):
            set Result = StageToAdvance.CompleteStage(Player)
            if(Result = task_module_response.OK_STAGE_COMPLETED):
                # Enable next stage after player completes current stage
                var NextStages:[]stage_base = array{}
                var NextStagesOrder:int = 999  # Initialize with a high value to find minimum

                # First check if there are stages at the same order level
                for(Stage:Stages, StageToAdvance.StageId<>Stage.StageId, StageToAdvance.StageOrder=Stage.StageOrder, Stage.IsAssigned[Player]):
                    Print("There is a stage at the same order level!!")
                    set NextStages += array{Stage}
                    
                # If no stages at the same level, find stages at the next higher order level
                if(NextStages.Length<=0):
                    # Find the minimum order value that is greater than current stage order
                    for(Stage:Stages, StageToAdvance.StageId<>Stage.StageId, Stage.StageOrder>StageToAdvance.StageOrder, Stage.IsAssigned[Player]):
                        if(Stage.StageOrder<NextStagesOrder):
                            set NextStagesOrder = Stage.StageOrder
                    
                    # Now collect all stages at that next order level
                    if(NextStagesOrder<999):  # Only if we found a valid next order
                        for(Stage:Stages, Stage.StageOrder=NextStagesOrder, Stage.IsAssigned[Player]):
                            set NextStages += array{Stage}

                    # Mark the appropriate next stages as completable
                    for(NextStage:NextStages):
                        NextStage.SetCompletable(Player)

                # Signal that player has advanced task
                EventManager.Notify( event_task_advanced {
                    PlayerWhoAdvanced := Player
                    TaskName := Name
                    StageId := StageId
                    IsTaskCompleted := logic{HasCompleted[Player]}
                    TaskType:=Type
                })
                
                if(HasCompleted[Player]):
                    set Result = task_module_response.OK_TASK_COMPLETED

                # Just in case, stop the player from the completed stage
                Stop(Player, StageId)
                    
        else:
            set Result = task_module_response.STAGE_INDEX_NOT_FOUND

        Result
