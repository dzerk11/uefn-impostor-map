
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_pass_code_security := class(log_channel){}

# Devices
task_devices_pass_code_security<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_pass_code_security = TaskStages.stage_devices_pass_code_security{}


# Class
task_pass_code_security<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_pass_code_security}
    Name<override>:task_name = task_name.PassCodeSecurity
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_Passcode
    @editable TaskDevices<public>:task_devices_pass_code_security = task_devices_pass_code_security{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_pass_code_security(Logger, Self, TaskDevices.Stage0, 0)