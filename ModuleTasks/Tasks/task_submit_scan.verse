
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_submit_scan := class(log_channel){}

# Devices
task_devices_submit_scan<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_submit_scan = TaskStages.stage_devices_submit_scan{}


# Class
task_submit_scan<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_submit_scan}
    Name<override>:task_name = task_name.SubmitScan
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_SubmitScan
    @editable TaskDevices<public>:task_devices_submit_scan = task_devices_submit_scan{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_submit_scan(Logger, Self, TaskDevices.Stage0)
