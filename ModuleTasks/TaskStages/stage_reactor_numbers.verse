
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_reactor_numbers<public> := class<final><concrete>(stage_devices):
    @editable   CSQ_Background<public>:cinematic_sequence_device = cinematic_sequence_device{}    


# Constructor
Make_stage_reactor_numbers<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_reactor_numbers) := stage_reactor_numbers:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}

# Class
stage_reactor_numbers<public> := class(stage_base):
    Location<override> :map_locations = map_locations.Reactor
    AllowMultiPlayer<override>:logic = false
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_reactor_numbers
    HideHudOnStart<override>:logic = true

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_reactor_numbers(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false
        