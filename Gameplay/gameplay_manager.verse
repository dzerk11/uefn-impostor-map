
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }

using { ModuleAmongusPlayspace }


var GameplayManagers<public>:weak_map(session, gameplay_manager) = map{}


gameplay_manager_log := class(log_channel){}


gameplay_manager<public> := class<final>(creative_device, event_listener):
    Logger<private>:log = log{Channel:=gameplay_manager_log, DefaultLevel:=log_level.Debug}
    
    @editable Lobby<private>:gamephase_lobby = gamephase_lobby{}
    @editable GameRound<private>:gamephase_game_round = gamephase_game_round{}
    @editable EventManager<protected>:event_manager = event_manager{}
    @editable AmongusColorAssigner<private>:amongus_color_assigner = amongus_color_assigner{}
    @editable AmongusClassAssigner<private>:amongus_class_assigner = amongus_class_assigner{}
    @editable TaskManager<private>:ModuleTasks.task_manager = ModuleTasks.task_manager{}
    @editable SpatialController<private>:Mechanics.spatial_controller = Mechanics.spatial_controller{}

    var ActiveGamePhase<private>:gamephase = gamephase.None
    var<private> AmongusPlayers<public>:[player]amongus_player = map{}

    OnBegin<override>()<suspends>:void =
        Logger.Print("Starting gameplay_manager")

        if:
            not GameplayManagers[GetSession()]
            set GameplayManagers[GetSession()] = Self
        Sleep(0.1)

        SwitchGamePhase(gamephase.Lobby)

        SpatialController.Start()

        # Init players
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
        InitPlayers()

        EventManager.Subscribe(event_type.SWITCH_GAME_PHASE, Self)
        

    Update<override>(EventPayload:event_payload):void = 
        case (EventPayload.EventType):
            event_type.SWITCH_GAME_PHASE => if(Event := event_switch_to_game_phase[EventPayload]): 
                SwitchGamePhase(Event.Gamephase)
            _ =>

    InitPlayers():void = 
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player:AllPlayers):
            OnPlayerAdded(Player)

    OnPlayerAdded(Player:player):void = 
        # Initialize player data, only the very first time a player enter the island
        # if: 
            # not PersistentPlayersData[Player]
            # set PersistentPlayersData[Player] = player_profile_data{}

        if(not AmongusPlayers[Player]):
            AmongusPlayer := Make_amongus_player(Player, AmongusColorAssigner, TaskManager, AmongusClassAssigner)
            if(set AmongusPlayers[Player] = AmongusPlayer){}

            if(ActiveGamePhase = gamephase.Lobby):
                Lobby.OnPlayerAdded(AmongusPlayer)


    # --------------- [ SetGamePhase ] --------------- 

    SwitchGamePhase<private>(InGamePhase:gamephase):void = 
        Logger.Print("Switching to game phase: {InGamePhase}..")

        var SwitchResult:logic = false

        case(InGamePhase):
            gamephase.None => "None",
            gamephase.Lobby => set SwitchResult = SetGamePhaseLobby(),
            gamephase.GameRound => set SwitchResult = SetGamePhaseGameRound()

        if (SwitchResult?):
            set ActiveGamePhase = InGamePhase
            Logger.Print("Switching to game phase: {InGamePhase}.. Done")
        else:
            Logger.Print("Was not possible to switch game phase to: {InGamePhase}")

    SetGamePhaseGameRound<private>():logic = 
        GameRound.Init()
        true
        
    SetGamePhaseLobby<private>():logic = 
        Lobby.Init()
        true