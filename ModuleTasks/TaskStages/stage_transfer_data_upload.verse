
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_transfer_data_upload<public> := class<final><concrete>(stage_devices):
    @editable
    SoundDataTransfered<public>:audio_player_device = audio_player_device{}


# Constructor
Make_stage_transfer_data_upload<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_transfer_data_upload) := stage_transfer_data_upload:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_transfer_data_upload<public> := class(stage_base):
    Location<override>:map_locations = map_locations.Admin
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 1
    StageDevices<override>:stage_devices_transfer_data_upload

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_transfer_data_upload(InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false