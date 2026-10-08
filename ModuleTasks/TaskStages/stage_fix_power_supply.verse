
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_fix_power_supply<public> := class<final><concrete>(stage_devices):


# Constructor
Make_stage_fix_power_supply<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_fix_power_supply) := stage_fix_power_supply:
    Logger := InLogger
    ParentTask := ParentTask
    StageDevices := InStageDevices
    TaskName := ParentTask.Name

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}

# Class
stage_fix_power_supply<public> := class(stage_base):
    Location<override> :map_locations = map_locations.Electrical
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_fix_power_supply

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_crazy_power_supply(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false