
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }


# Devices
stage_devices_call_earth_find_better_signal<public> := class<final><concrete>(stage_devices):
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
Make_stage_call_earth_find_better_signal<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_call_earth_find_better_signal) := stage_call_earth_find_better_signal:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}

    
# Class
stage_call_earth_find_better_signal<public> := class(stage_base):
    Location<override>:map_locations = map_locations.Cafeteria
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 1
    StageDevices<override>:stage_devices_call_earth_find_better_signal
    HideHudOnStart<override>:logic = true

    Init<override>():void = 
        Self.AppendCancelable(StageDevices.SignalRemoteManager.SecondarySignalEvent.Subscribe(SignalPlayerInteracts))
        Self.AppendCancelable(StageDevices.SignalRemoteManager.PrimarySignalEvent.Subscribe(SignalPlayerInteracts))

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_call_earth(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false



