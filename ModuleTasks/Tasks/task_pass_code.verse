
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_pass_code := class(log_channel){}

# Devices
task_devices_pass_code<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_pass_code = TaskStages.stage_devices_pass_code{}
    @editable
    Stage1<public>:TaskStages.stage_devices_pass_code = TaskStages.stage_devices_pass_code{}


# Class
task_pass_code<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_pass_code}
    Name<override>:task_name = task_name.PassCode
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_Passcode
    @editable TaskDevices<public>:task_devices_pass_code = task_devices_pass_code{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_pass_code(Logger, Self, TaskDevices.Stage0, 0)
            TaskStages.Make_stage_pass_code(Logger, Self, TaskDevices.Stage1, 1)
