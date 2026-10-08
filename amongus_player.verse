

using { /Verse.org/Simulation }

using { ModuleAmongusModel }
using { ModuleTasks }


GetAPlayer<internal>(Agent:agent)<transacts><decides>:amongus_player = 
    Gameplay.GameplayManagers[GetSession()].AmongusPlayers[player[Agent]]

GetAPlayers<internal>()<reads>:[]amongus_player = 
    if(GR := Gameplay.GameplayManagers[GetSession()]):
        for(APlayer:GR.AmongusPlayers){APlayer}
    else:
        array{}

GetAPlayers<internal>(Role:gameplay_role)<reads>:[]amongus_player = 
    for(APlayer:GetAPlayers(), Role = APlayer.Role):
        APlayer

GetAPlayersRound<internal>()<reads>:[]amongus_player = 
    for(APlayer:GetAPlayers(), APlayer.PlayerState = amongus_player_state.InGame):
        APlayer

GetAPlayersByRoles<internal>(Roles:[]gameplay_role)<reads>:[]amongus_player = 
    for(APlayer:GetAPlayers(), Roles.Find[APlayer.Role]):
        APlayer


Make_amongus_player<internal><constructor>(Player:player, ColorProvider:amongus_color_provider, TaskProvider:task_provider, ClassProvider:amongus_class_provider):= amongus_player:
    Player := Player
    ColorProvider := ColorProvider
    TaskProvider := TaskProvider
    ClassProvider := ClassProvider

amongus_player<internal> := class<unique>():
    Player<public>:player
    ColorProvider<internal>:amongus_color_provider = amongus_color_assigner{}
    TaskProvider<internal>:task_provider = task_manager{}
    ClassProvider<internal>:amongus_class_provider = amongus_class_assigner{}
    var<private> PlayerState<public>:amongus_player_state = amongus_player_state.Lobby
    var<private> Role<public>:gameplay_role = gameplay_role.None
    var<private> Number<public>:int = -1
    var<private> IsGhost<public>:logic = false

    SetRole<public>(RoleToAssign:gameplay_role):void = 
        set Role = RoleToAssign

    SetNumber<public>(N:int):void = 
        set Number = N
        ColorProvider.AssignColor(Player, Number)

    GetColor<public>()<reads>:amongus_color = 
        ColorProvider.GetColor(Self.Player)

    SetPlayerState<public>(State:amongus_player_state):void = 
        set PlayerState = State

    GetTasksInfo<public>():[]task_info =
        TaskProvider.GetPlayerTasksInfo(Self.Player)

    GetPlayerClass<public>()<reads>:int =
        ClassProvider.GetPlayerClass(Self.Player)

    ChangeClass<public>(ClassIndex:int):void =
        ClassProvider.ChangePlayerClass(Self.Player, ClassIndex)

    # GetPlayerTeam<public>()<reads>:int =
    #     # ClassProvider.GetPlayerClass(Self.Player)
    #     20

    ShowColor<public>():void =
        ColorProvider.ShowColor(Player)

    HideColor<public>():void =
        ColorProvider.HideColor(Player)

    # ChangeTeam<public>(ClassIndex:int):void =
    #     ClassProvider.ChangePlayerClass(Self.Player, ClassIndex)

    var PlayerModelId<internal>:int = -1

    SetGhost<public>():void =
        set IsGhost = true

    IsImpostor<public>()<transacts><decides>:void =
        Role = gameplay_role.Impostor


amongus_player_state<public> := enum:
    Lobby
    InGame



