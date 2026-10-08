
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_reactor_numbers := class(log_channel){}

# Devices
task_devices_reactor_numbers<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_reactor_numbers = TaskStages.stage_devices_reactor_numbers{}


# Class
task_reactor_numbers<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_reactor_numbers}
    Name<override>:task_name = task_name.ReactorNumbers
    TaskIcon<override>:texture = Art.Textures.TaskIcons.T_TaskIcon_ReactorNumbers
    @editable TaskDevices<public>:task_devices_reactor_numbers = task_devices_reactor_numbers{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_reactor_numbers(Logger, Self, TaskDevices.Stage0)


