
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_sabotage_oxygen_depletion<public> := class<final><concrete>(stage_devices):
    @editable Light<public>:customizable_light_device = customizable_light_device{}
    @editable LightDevice<public>:creative_prop = creative_prop{}


# Constructor
Make_stage_sabotage_oxygen_depletion<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_sabotage_oxygen_depletion, InStageOrder:int, InLocation:map_locations) := stage_sabotage_oxygen_depletion:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices
    StageOrder := InStageOrder
    Location := InLocation

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_sabotage_oxygen_depletion<public> := class(sabotage_stage_base):
    Location<override>:map_locations
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_sabotage_oxygen_depletion

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_sabotage_o2(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false

    Init<override>():void =
        (super:)Init()
        OnSabotageStopped()

    OnSabotageStarted<override>():void = 
        StageDevices.TaskPanel.Enable()
        StageDevices.Light.TurnOff()
        StageDevices.LightDevice.SetMaterial(Art.Materials.MI_DeviceLight_Off, ?Index:=1)

    OnSabotageStopped<override>():void = 
        StageDevices.TaskPanel.Disable()
        StageDevices.Light.TurnOff()
        StageDevices.LightDevice.SetMaterial(Art.Materials.MI_DeviceLight_Disabled, ?Index:=1)


