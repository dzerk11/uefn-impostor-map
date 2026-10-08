
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_labyrinth := class(log_channel){}

# Devices
task_devices_labyrinth<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_labyrinth = TaskStages.stage_devices_labyrinth{}


# Class
task_labyrinth<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_labyrinth}
    Name<override>:task_name = task_name.Labyrinth
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_Labyrinth
    @editable TaskDevices<public>:task_devices_labyrinth = task_devices_labyrinth{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_labyrinth(Logger, Self, TaskDevices.Stage0)
















