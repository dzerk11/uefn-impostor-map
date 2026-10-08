
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_sabotage_electrical := class(log_channel){}

# Devices
task_devices_sabotage_electrical<public> := class<final><concrete>(sabotage_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_sabotage_electrical = TaskStages.stage_devices_sabotage_electrical{}


# Constructor
Make_sabotage_electrical<public><constructor>(Devices:Tasks.task_devices_sabotage_electrical) := sabotage_electrical:
    Devices := Devices


# Class
sabotage_electrical<public><final> := class(sabotage_basic):
    Logger<override>:log = log{Channel:=log_sabotage_electrical}
    Name<override>:task_name = task_name.SabotageElectrical
    SabotageType<override>:sabotage_type = sabotage_type.NonCritical
    Duration<override>:float = 0.0
    Devices<override>:task_devices_sabotage_electrical

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_sabotage_lights_off(Logger, Self, Devices.Stage0, 0)
    
    
