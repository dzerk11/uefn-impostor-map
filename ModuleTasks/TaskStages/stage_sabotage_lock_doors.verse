
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_sabotage_lock_doors<public> := class<final><concrete>(stage_devices):
    @editable
    LS_Doors<public>:[]cinematic_sequence_device = array{}


# Constructor
Make_stage_sabotage_lock_doors<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_sabotage_lock_doors, InStageOrder:int, InLocation:map_locations) := stage_sabotage_lock_doors:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices
    StageOrder := InStageOrder

    Coordinates := vector2{X:=0.0, Y:=0.0}

    Location := InLocation

# Class
stage_sabotage_lock_doors<public> := class(sabotage_stage_base):
    AllowMultiPlayer<override>:logic = false
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_sabotage_lock_doors

    

