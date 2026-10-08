
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_fuel_fill_engine<public> := class<final><concrete>(stage_devices):


# Constructor
Make_stage_fuel_fill_engine<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_fuel_fill_engine, InLocation:map_locations) := stage_fuel_fill_engine:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices
    Location := InLocation

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_fuel_fill_engine<public> := class(stage_base):
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 1
    StageDevices<override>:stage_devices_fuel_fill_engine

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_fuel_engine(Logger, InPlayer, StageId, stage_devices_fuel_fill_engine{}, Self)
            option{UiMade}
        else:
            false
    