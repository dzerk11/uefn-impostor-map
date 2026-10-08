
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Verse.org/Assets }
using { /Verse.org/Random }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_clear_space := class(log_channel){}

# Devices
task_devices_clear_space<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_clear_space = TaskStages.stage_devices_clear_space{}

# Class
task_clear_space<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_clear_space}
    Name<override>:task_name = task_name.ClearSpace
    TaskIcon<override>:texture = Art.Textures.TaskIcons.T_TaskIcon_ClearSpace
    CompletionType<override>:task_completion_type = task_completion_type.Solo
    @editable TaskDevices<public>:task_devices_clear_space = task_devices_clear_space{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_clear_space(Logger, Self, TaskDevices, TaskDevices.Stage0)

