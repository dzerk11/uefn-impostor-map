
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_sabotage_lock_door := class(log_channel){}


task_devices_sabotage_lock_doors<public> := class<final><concrete>(sabotage_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_sabotage_lock_doors = TaskStages.stage_devices_sabotage_lock_doors{}


Make_sabotage_lock_doors<public><constructor>(Devices:task_devices_sabotage_lock_doors) := sabotage_lock_doors:
    Devices := Devices


sabotage_lock_doors<public><final> := class(sabotage_basic):
    Logger<override>:log = log{Channel:=log_sabotage_lock_door}
    Name<override>:task_name = task_name.SabotageLockDoors
    SabotageType<override>:sabotage_type = sabotage_type.NonCritical
    Duration<override>:float = 20.0
    SabotageCooldownTime<override>:float = 30.0
    Devices<override>:task_devices_sabotage_lock_doors

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_sabotage_lock_doors(Logger, Self, Devices.Stage0, 0, map_locations.None)

    OnSabotageStarted<override>():void =
        for(Sequence:Devices.Stage0.LS_Doors):
            Sequence.Play()

    OnSabotageStopped<override>():void = 
        for(Sequence:Devices.Stage0.LS_Doors):
            Sequence.GoToEndAndStop()
            Sequence.SetPlaybackFrame(0)
    
