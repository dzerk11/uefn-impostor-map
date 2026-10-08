
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_divert_power := class(log_channel){}

# Devices
task_devices_divert_power<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_divert_power = TaskStages.stage_devices_divert_power{}


# Class
task_divert_power<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_divert_power}
    Name<override>:task_name = task_name.DivertPower
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_DivertPower
    @editable TaskDevices<public>:task_devices_divert_power = task_devices_divert_power{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_divert_power(Logger, Self, TaskDevices.Stage0)