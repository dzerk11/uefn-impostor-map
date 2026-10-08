
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_crazy_power_supply := class(log_channel){}

# Devices
task_devices_crazyPowerSupply<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_fix_power_supply = TaskStages.stage_devices_fix_power_supply{}


# Class
task_crazy_power_supply<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_crazy_power_supply}
    Name<override>:task_name = task_name.CrazyPowerSupply
    TaskIcon<override>:texture = Art.Textures.TaskIcons.T_TaskIcon_CrazyPowerSupply
    @editable TaskDevices<public>:task_devices_crazyPowerSupply = task_devices_crazyPowerSupply{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_fix_power_supply(Logger, Self, TaskDevices.Stage0)


