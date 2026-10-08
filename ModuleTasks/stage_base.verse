
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }

stage_controller<public> := interface:
    Start<internal>(Player:player):task_module_response
    Stop<internal>(Player:player):task_module_response
    SignalPlayerCompletes<internal>(Player:player):void
    SignalPlayerFails<internal>(Player:player):void
    SignalPlayerReward<internal>(Player:player, RewardType:Utils.award_type):void

stage_base<internal>:= class(stage_controller):
    Logger<internal>:log
    ParentTask<internal>:task_basic
    
    Location<public>:map_locations
    Coordinates<public>:vector2
    AllowMultiPlayer<public>:logic
    HideHudOnStart<public>:logic = true

    TaskName<public>:task_name
    var<private> StageId<internal>:int = -1
    StageOrder<public>:int

    StageDevices<public>:stage_devices

    var PlayersStageData<private>:[player]player_stage_data_base = map{}

    var _Cancelables<private>:[]cancelable = array{}
    var _CustomCancelables<private>:[]custom_cancelable = array{}
    # Subscriptions<private>:Utils.subscription_manager = Utils.subscription_manager{}


    SetStageId<public>(InStageId:type {_X:int where _X >= 0})<decides><transacts>:void = 
        set StageId = InStageId

    GetPlayerStageData<internal>(Player:player)<transacts><decides>:player_stage_data_base =
        PlayersStageData[Player]

    # Get players that are playing this stage
    GetPlayersPlaying<public>()<reads>:[]player = 
        for(Player->PlayerData:PlayersStageData, PlayerData.IsPlaying?):
            Player

    # Get players that have completed this stage
    GetPlayersCompleted<public>():[]player = 
        for(Player->PlayerData:PlayersStageData, PlayerData.HasCompleted?):
            Player

    # Get if player has completed the stage
    HasCompleted<public>(Player:player)<transacts><decides>:void =
        PlayerStageData := GetPlayerStageData[Player]
        PlayerStageData.HasCompleted?

    # Get if every player has completed the stage
    HasEveryOneCompleted<public>()<transacts><decides>:void =
        var Result:logic = true
        for(Player->PlayerStageData:PlayersStageData, not PlayerStageData.HasCompleted?):
            set Result = false
        Result?

    # Get if player is assigned
    IsAssigned<internal>(Player:player)<decides><transacts>:void =
        PlayersStageData[Player]
        
    # Get if player can complete this stage
    IsCompletable<public>(Player:player)<transacts><decides>:void =
        PlayerStageData := GetPlayerStageData[Player]
        PlayerStageData.IsCompletable?

    # Get if player is playing
    IsPlaying<public>(Player:player)<transacts><decides>:void =
        PlayerStageData := GetPlayerStageData[Player]
        PlayerStageData.IsPlaying?

    # Get if player is playing by stage data    
    IsPlaying<internal>(PlayerStageData:player_stage_data_base)<transacts><decides>:void =
        PlayerStageData.IsPlaying?

    # <overridable> Initialize
    Init<public>():void = 
        Self.AppendCancelable(StageDevices.TaskPanel.InteractedWithEvent.Subscribe(SignalPlayerInteracts))

    # <overridable> Dispose stage
    # Dispose<public>():void = 
    #     for(Cancelable:_Cancelables):
    #         Cancelable.Cancel()

    #     for(Cancelable:_CustomCancelables):
    #         Cancelable.Cancel()
            
    #     for(Player -> StageData:PlayersStageData):
    #         Stop(Player)
    #         RemovePlayer(Player)

    #     EventStageDisposed.Signal()
    #     Logger.Normal("Disposed stage: [{TaskName}]-[{StageId}]")

    ClearCancelables<protected>():void = 
        for(Cancelable:_Cancelables):
            Cancelable.Cancel()
        set _Cancelables = array{}

        for(Cancelable:_CustomCancelables):
            Cancelable.Cancel()
        set _CustomCancelables = array{}

    AppendCancelable<protected>(Cancelable:cancelable):void = 
        set _Cancelables += array{Cancelable}

    AppendCustomCancelable<protected>(Cancelable:custom_cancelable):void = 
        set _CustomCancelables += array{Cancelable}

    # Assign player to the stage
    AssignPlayer<public>(Player:player)<transacts><decides>:void =
        not IsAssigned[Player]
        StageData := player_stage_data_base{Player := Player, TaskName := TaskName, StageId := StageId}
        set PlayersStageData[Player] = StageData
        
    # Remove player to the stage
    RemovePlayer<public>(Player:player):logic = 
        if (IsAssigned[Player]):
            Stop(Player)
            var NewMap:[player]player_stage_data_base = map{}
            for (Key -> Value : PlayersStageData, Key <> Player):
                set NewMap = ConcatenateMaps(NewMap, map{Key => Value})
            set PlayersStageData = NewMap
            # Logger.Debug("Player removed from {TaskName} - {StageId}")
            DisableMapIndicator(Player)
            true
        else:
            false

    # Start stage for a player
    Start<override>(Player:player):task_module_response = 
        if(PlayerStageData := GetPlayerStageData[Player]):
            if(not PlayerStageData.HasCompleted?):
                if(not PlayerStageData.IsPlaying?):
                    if(PlayerStageData.IsCompletable?):

                        # Get all players that are playing
                        PlayersPlaying := Self.GetPlayersPlaying()

                        # If stage allows multiplayer, start
                        # If stage doesn't allow multiplayer, but no one is playing, start
                        if(AllowMultiPlayer? or (not AllowMultiPlayer?, PlayersPlaying.Length=0)):
                            spawn{ExecuteStage(PlayerStageData)}
                            Logger.Debug("task_module_response.OK")
                            return task_module_response.OK
                        else:
                            Logger.Debug("task_module_response.ANOTHER_PLAYER_IS_PLAYING")
                            return task_module_response.ANOTHER_PLAYER_IS_PLAYING
                    else:
                        Logger.Debug("task_module_response.STAGE_NOT_COMPLETABLE_YET")
                        return task_module_response.STAGE_NOT_COMPLETABLE_YET
                else:
                    Logger.Debug("task_module_response.PLAYER_IS_ALREADY_PLAYING_STAGE")
                    return task_module_response.PLAYER_IS_ALREADY_PLAYING_STAGE
            else:
                Logger.Debug("task_module_response.STAGE_ALREADY_COMPLETED_BY_PLAYER")
                return task_module_response.STAGE_ALREADY_COMPLETED_BY_PLAYER
        else:
            Logger.Debug("task_module_response.MISSING_PLAYER_STAGE_DATA")
            return task_module_response.MISSING_PLAYER_STAGE_DATA

    ExecuteStage<public>(PlayerStageData:player_stage_data_base)<suspends>:void =
        # Mark player as actively playing
        set PlayerStageData.IsPlaying = true
        
        # Initialize and show UI widget if available
        MaybeStageWidget := MakeUi(PlayerStageData.Player)
        set PlayerStageData.StageWidget = MaybeStageWidget
        if(StageWidget := MaybeStageWidget?):
            StageWidget.Show()

        # Run the minigame logic with cancellation support
        # Either HandleStage completes naturally, or EventPlayerEnded cancels it
        race:
            PlayerStageData.EventForceStop.Await()
            block:
                HandleStage(PlayerStageData)
                Sleep(Inf)

        # Cleanup stage-specific resources (teleport player, disable devices, etc.)
        CleanupStage(PlayerStageData)
        Logger.Print("Cleaned up stage: [{TaskName}]-[{StageId}]]")

        # Destroy UI widget
        if(StageWidget := PlayerStageData.StageWidget?):
            StageWidget.Destroy()
            set PlayerStageData.StageWidget = false

        # Mark player as no longer playing
        set PlayerStageData.IsPlaying = false

        if(EventManager := EventManagers[GetSession()]):
            EventManager.Notify(event_stage_ended{Player:=option{PlayerStageData.Player}, TaskName:=TaskName, StageId:=StageId, HideHudOnStart:=HideHudOnStart})

    # {overridable} Handle the stage logic for a player 
    HandleStage<protected>(PlayerStageData:player_stage_data_base)<suspends>:void = 
        {}

    # {overridable} Cleanup stage after player finishes or is stopped
    CleanupStage<protected>(PlayerStageData:player_stage_data_base):void = {}

    # Make this stage completable for a player
    SetCompletable<public>(Player:player):void =
        Logger.Print("setting completable [{TaskName},{StageId}]")
        if(PlayerStageData := GetPlayerStageData[Player]):
            EnableMapIndicator(Player)
            set PlayerStageData.IsCompletable = true

    # Stop all players from playing this stage
    Stop<public>():void = 
        for(Player->PlayerStageData:PlayersStageData):
            Stop(Player)
        
    # Stop a player from playing this stage
    Stop<override>(Player:player):task_module_response = 
        if(PlayerStageData := GetPlayerStageData[Player]):
            if(PlayerStageData.IsPlaying?):
                PlayerStageData.EventForceStop.Signal()
                return task_module_response.OK
            else:
                return task_module_response.PLAYER_IS_NOT_PLAYING_STAGE
        else:
            return task_module_response.MISSING_PLAYER_STAGE_DATA

    # Complete stage for all players
    CompleteStage<public>():void = 
        for(Player->PlayerStageData:PlayersStageData):
            CompleteStage(Player)
            
    # Complete stage for player
    CompleteStage<public>(Player:player):task_module_response = 
        if(PlayerStageData := GetPlayerStageData[Player]):
            if(not PlayerStageData.HasCompleted?):
                if(PlayerStageData.IsCompletable?):
                    Logger.Print("Player completed stage [{TaskName}]-[{StageId}]")
                    set PlayerStageData.HasCompleted = true
                    DisableMapIndicator(Player)

                    PlayerStageData.EventForceStop.Signal()
                    
                    task_module_response.OK_STAGE_COMPLETED
                else:
                    task_module_response.STAGE_NOT_COMPLETABLE_YET
            else:
                task_module_response.STAGE_ALREADY_COMPLETED_BY_PLAYER
        else:
            task_module_response.MISSING_PLAYER_STAGE_DATA

    MakeUi<protected>(InPlayer:player):?StageWidgets.stage_widget =
        false
            
    # Get completion stage status: tuple(player that has completed, total players)
    GetCompletion():tuple(int,int) = 
        var NPlayersThatHasCompleted:int = 0
        var NTotalPlayers:int = 0
        for(Player->PlayerStageData:PlayersStageData):
            set NTotalPlayers += 1
            if(PlayerStageData.HasCompleted?):
                set NPlayersThatHasCompleted += 1
        
        (NPlayersThatHasCompleted,NTotalPlayers)

    # Get player stage info based on player
    GetPlayerStageInfo<internal>(Player:player):stage_info =
        stage_info:
            StageId := Self.StageId
            StageOrder := Self.StageOrder
            Location := Self.Location
            Coordinates := Self.Coordinates
            IsCompleted := logic{Self.HasCompleted[Player]}

    # Get generic stage info
    GetStageInfo<internal>():stage_info =
        stage_info:
            StageId := Self.StageId
            StageOrder := Self.StageOrder
            Location := Self.Location
            Coordinates := Self.Coordinates
            IsCompleted := if(Self.HasEveryOneCompleted[]){true}else{false}

    # --- Player signals (requests)

    SignalPlayerInteracts<protected>(Agent:agent):void =
        if(Player := player[Agent]):
            ParentTask.Start(Player, StageId)

    SignalPlayerCompletes<override>(Player:player):void =
        ParentTask.AdvanceTask(Player, StageId)

    SignalPlayerFails<override>(Player:player):void =
        ParentTask.Stop(Player, StageId)

    SignalPlayerReward<override>(Player:player, RewardType:Utils.award_type):void =
        # ParentTask.RewardPlayer(Player, StageId, RewardType)
        if(EventManager := EventManagers[GetSession()]):
            EventManager.Notify(event_player_stage_reward{Player:=option{Player}, TaskName:=TaskName, StageId:=StageId, RewardType:=RewardType})
    
    DisableMapIndicator<public>(Player:player):void =
        StageDevices.Beacon.RemoveFromShowList(Player)
        if:
            APlayer := GetAPlayer[Player]
            MapIndicator := StageDevices.MapIndicators[APlayer.Number-1]
            Position := transform{Translation:=vector3{X:=722000.395277, Y:=-14699.749432, Z:=2110.206737}}
            MapIndicator.TeleportTo[Position]
        then:
            Logger.Normal("Map Indicator Moved out")

    EnableMapIndicator<public>(Player:player):void =
        Print("EnableMapIndicator called for [{TaskName},{StageId}]")
        StageDevices.Beacon.AddToShowList(Player)
        if:
            APlayer := GetAPlayer[Player]
            MapIndicator := StageDevices.MapIndicators[APlayer.Number-1]
            Position := StageDevices.MapIndicatorsDefaultPositions[APlayer.Number-1]
            MapIndicator.TeleportTo[Position]
        then:
            Logger.Normal("Map Indicator Moved in for [{TaskName},{StageId}]")

        
