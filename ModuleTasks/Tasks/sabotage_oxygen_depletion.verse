
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_sabotage_oxygen_depletion := class(log_channel){}

# Devices
task_devices_sabotage_oxygen_depletion<public> := class<final><concrete>(sabotage_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_sabotage_oxygen_depletion = TaskStages.stage_devices_sabotage_oxygen_depletion{}
    @editable
    Stage1<public>:TaskStages.stage_devices_sabotage_oxygen_depletion = TaskStages.stage_devices_sabotage_oxygen_depletion{}


# Constructor
Make_sabotage_oxygen_depletion<public><constructor>(Devices:Tasks.task_devices_sabotage_oxygen_depletion) := sabotage_oxygen_depletion:
    Devices := Devices


# Class
sabotage_oxygen_depletion<public><final> := class(sabotage_basic):
    Logger<override>:log = log{Channel:=log_sabotage_oxygen_depletion}
    Name<override>:task_name = task_name.SabotageO2
    SabotageType<override>:sabotage_type = sabotage_type.Critical
    Duration<override>:float = 45.0
    Devices<override>:task_devices_sabotage_oxygen_depletion = task_devices_sabotage_oxygen_depletion{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_sabotage_oxygen_depletion(Logger, Self, Devices.Stage0, 0, map_locations.O2)
            TaskStages.Make_stage_sabotage_oxygen_depletion(Logger, Self, Devices.Stage1, 0, map_locations.Admin)

    OnSabotageStarted<override>():void = 
        if(StageDevices0 := TaskStages.stage_devices_sabotage_oxygen_depletion[Stages[0].StageDevices]):
            StageDevices0.Light.TurnOff()
            StageDevices0.LightDevice.SetMaterial(Art.Materials.MI_DeviceLight_Off, ?Index:=1)
        if(StageDevices1 := TaskStages.stage_devices_sabotage_oxygen_depletion[Stages[1].StageDevices]):
            StageDevices1.Light.TurnOff()
            StageDevices1.LightDevice.SetMaterial(Art.Materials.MI_DeviceLight_Off, ?Index:=1)

    OnSabotageStopped<override>():void = 
        if(StageDevices0 := TaskStages.stage_devices_sabotage_oxygen_depletion[Stages[0].StageDevices]):
            StageDevices0.Light.TurnOff()
            StageDevices0.LightDevice.SetMaterial(Art.Materials.MI_DeviceLight_Disabled, ?Index:=1)
        if(StageDevices1 := TaskStages.stage_devices_sabotage_oxygen_depletion[Stages[1].StageDevices]):
            StageDevices1.Light.TurnOff()
            StageDevices1.LightDevice.SetMaterial(Art.Materials.MI_DeviceLight_Disabled, ?Index:=1)
