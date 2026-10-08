
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_transfer_data_download<public> := class<final><concrete>(stage_devices):
    @editable
    SoundDataTransfered<public>:audio_player_device = audio_player_device{}


# Constructor
Make_stage_transfer_data_download<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_transfer_data_download, InLocation:map_locations) := stage_transfer_data_download:
    Logger := InLogger
    ParentTask := ParentTask
    Location := InLocation
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_transfer_data_download<public> := class(stage_base):
    StageOrder<override>:int = 0
    AllowMultiPlayer<override>:logic = true
    StageDevices<override>:stage_devices_transfer_data_download

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_transfer_data_download(InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false