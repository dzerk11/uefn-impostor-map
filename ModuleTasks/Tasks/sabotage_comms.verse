
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_sabotage_comms := class(log_channel){}

# Devices
task_devices_sabotage_comms<public> := class<final><concrete>(sabotage_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_sabotage_comms = TaskStages.stage_devices_sabotage_comms{}


# Constructor
Make_sabotage_comms<public><constructor>(Devices:Tasks.task_devices_sabotage_comms) := sabotage_comms:
    Devices := Devices

        
# Class
sabotage_comms<public><final> := class(sabotage_basic):
    Logger<override>:log = log{Channel:=log_sabotage_comms}
    Name<override>:task_name = task_name.SabotageComms
    SabotageType<override>:sabotage_type = sabotage_type.NonCritical
    Duration<override>:float = 0.0
    Devices<override>:task_devices_sabotage_comms

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_sabotage_comms(Logger, Self, Devices.Stage0)
