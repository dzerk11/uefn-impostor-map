
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


# Devices
stage_devices_call_earth_get_remote<public> := class<final><concrete>(stage_devices):
    @editable
    AudioPeopleCalling<public>:audio_player_device = audio_player_device{}
    @editable
    SignalRemoteManager<public>:signal_remote_manager_device = signal_remote_manager_device{}
    @editable
    RemoteGranter<public>:item_granter_device = item_granter_device{}
    @editable
    WifiBoxes<public>:[]creative_prop = array{}
    @editable
    RemoteManagerRemover<public>:item_remover_device = item_remover_device{}


# Constructor
Make_stage_call_earth_get_remote<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_call_earth_get_remote) := stage_call_earth_get_remote:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_call_earth_get_remote<public> := class(stage_base):
    Location<override>:map_locations = map_locations.Cafeteria
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0 
    StageDevices<override>:stage_devices_call_earth_get_remote 
    HideHudOnStart<override>:logic = false

    HandleStage<override>(PlayerStageData:player_stage_data_base)<suspends>:void = 
        # Grant remote and conclude
        StageDevices.RemoteGranter.GrantItem(PlayerStageData.Player)
        SignalPlayerCompletes(PlayerStageData.Player)
