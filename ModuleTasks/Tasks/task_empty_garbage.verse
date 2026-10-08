
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_empty_garbage := class(log_channel){}

# Devices
task_devices_empty_garbage<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_empty_garbage = TaskStages.stage_devices_empty_garbage{}
    @editable
    Stage1<public>:TaskStages.stage_devices_empty_garbage = TaskStages.stage_devices_empty_garbage{}


# Class
task_empty_garbage<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_empty_garbage}
    Name<override>:task_name = task_name.EmptyGarbage
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_EmptyGarbage
    @editable TaskDevices<public>:task_devices_empty_garbage = task_devices_empty_garbage{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_empty_garbage(Logger, Self, TaskDevices.Stage0)
            TaskStages.Make_stage_empty_garbage(Logger, Self, TaskDevices.Stage1)
