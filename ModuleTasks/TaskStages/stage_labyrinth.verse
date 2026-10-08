
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_labyrinth<public> := class<final><concrete>(stage_devices):


# Constructor
Make_stage_labyrinth<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_labyrinth) := stage_labyrinth:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_labyrinth<public> := class(stage_base):
    Location<override> :map_locations = map_locations.Navigation
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_labyrinth 

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_labyrinth(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false