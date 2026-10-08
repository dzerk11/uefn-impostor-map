
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }

log_task_align_engine := class(log_channel){}

# Devices
task_devices_align_engine<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_align_engine = TaskStages.stage_devices_align_engine{}

        
# Class
task_align_upper_engine<public><final> := class(task_align_engine):
    Name<override>:task_name := task_name.AlignUpperEngine

task_align_lower_engine<public><final> := class(task_align_engine):
    Name<override>:task_name := task_name.AlignLowerEngine

task_align_engine<public> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_align_engine}
    CompletionType<override>:task_completion_type = task_completion_type.Common
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_AlignEngine
    @editable TaskDevices<public>:task_devices_align_engine = task_devices_align_engine{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_align_lower_engine(Logger, Self, TaskDevices.Stage0)




    

