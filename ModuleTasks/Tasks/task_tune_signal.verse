
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_tune_signal := class(log_channel){}

# Devices
task_devices_tune_signal<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_tune_signal = TaskStages.stage_devices_tune_signal{}


# Class
task_tune_signal<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_tune_signal}
    Name<override>:task_name = task_name.TuneSignal
    # TaskIcon<override>:texture := Art.Textures.Icons.MapIcons.T_Icon_Transfer
    @editable TaskDevices<public>:task_devices_tune_signal = task_devices_tune_signal{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_tune_signal(Logger, Self, TaskDevices.Stage0)