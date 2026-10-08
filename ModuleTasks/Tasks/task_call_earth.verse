
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_call_earth := class(log_channel){}


# Devices
task_devices_call_earth<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_call_earth_get_remote = TaskStages.stage_devices_call_earth_get_remote{}
    @editable
    Stage1<public>:TaskStages.stage_devices_call_earth_find_better_signal = TaskStages.stage_devices_call_earth_find_better_signal{}


# Class
task_call_earth<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_call_earth}
    Name<override>:task_name = task_name.CallEarth
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_CallEarth
    @editable TaskDevices<public>:task_devices_call_earth = task_devices_call_earth{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_call_earth_get_remote(Logger, Self, TaskDevices.Stage0)
            TaskStages.Make_stage_call_earth_find_better_signal(Logger, Self, TaskDevices.Stage1)

    





