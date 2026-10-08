
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_shields<public> := class<final><concrete>(stage_devices):
    @editable
    PopupDialogDevice<public>:popup_dialog_device = popup_dialog_device{}
    @editable
    CinematicGlowRods<public>:cinematic_sequence_device = cinematic_sequence_device{}


# Constructor
Make_stage_shields<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_shields) := stage_shields:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}



# Class
stage_shields<public> := class(stage_base):
    Location<override>:map_locations = map_locations.Security
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_shields

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_shields(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false