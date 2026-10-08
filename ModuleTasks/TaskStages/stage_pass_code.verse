
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_pass_code<public> := class<final><concrete>(stage_devices):

    
# Constructor
Make_stage_pass_code<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_pass_code, InStageOrder:int) := stage_pass_code:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices
    StageOrder := InStageOrder

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}



# Class
stage_pass_code<public> := class(stage_base):
    Location<override>:map_locations = map_locations.Security
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_pass_code

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_pass_code(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false