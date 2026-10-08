
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_fuel_fill_canister<public> := class<final><concrete>(stage_devices):


# Constructor
Make_stage_fuel_fill_canister<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_fuel_fill_canister) := stage_fuel_fill_canister:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_fuel_fill_canister<public> := class(stage_base):
    Location<override> :map_locations = map_locations.Storage
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_fuel_fill_canister

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_fuel(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false

    