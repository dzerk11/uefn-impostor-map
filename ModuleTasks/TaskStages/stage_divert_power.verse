
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_divert_power<public> := class<final><concrete>(stage_devices):
    @editable
    PopupButtons<public>:popup_dialog_device = popup_dialog_device{}

    
# Constructor
Make_stage_divert_power<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_divert_power) := stage_divert_power:
    Logger := InLogger
    ParentTask := ParentTask    
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_divert_power<public> := class(stage_base):
    Location<override> :map_locations = map_locations.MedBay #TODO
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_divert_power

    Init<override>():void = 
        (super:)Init()

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_divert_power(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false

    