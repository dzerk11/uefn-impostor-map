
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_shields := class(log_channel){}

# Devices
task_devices_shields<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_shields = TaskStages.stage_devices_shields{}


# Class
task_shields<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_shields}
    Name<override>:task_name = task_name.Shields
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_Shields
    @editable TaskDevices<public>:task_devices_shields = task_devices_shields{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_shields(Logger, Self, TaskDevices.Stage0)
