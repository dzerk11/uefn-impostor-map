
using { /Verse.org/Simulation }

using { ModuleLanguage }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/SpatialMath }


task_completion_type<public> := enum:
    Common
    Solo

task_type<public> := enum:
    Task
    Sabotage

sabotage_type<public> := enum:
    Critical # Red screen, lose game
    NonCritical # Custom screen if available, doesnt lose game, might resolve by itself

ToString<public>(TaskCompletionType: task_completion_type):string =
    case(TaskCompletionType):
        task_completion_type.Solo => "Solo"
        task_completion_type.Common => "Common"

task_duration<public> := enum:
    None
    Short
    Long

task_name<public> := enum :
    AlignUpperEngine
    AlignLowerEngine
    Labyrinth
    CrazyPowerSupply
    FluidLevels
    CallEarth
    PassCode
    PassCodeSecurity
    ReactorNumbers
    TuneSignal
    ClearSpace
    Fuel
    Shields
    SubmitScan
    DivertPower
    TransferData
    EmptyGarbage
    SabotageO2
    SabotageLockDoors
    SabotageReactorFail
    SabotageElectrical
    SabotageComms
    None

ToString<public>(InTaskName: task_name):string =
    case(InTaskName):
        task_name.Labyrinth => "Labyrinth"
        task_name.CrazyPowerSupply => "CrazyPowerSupply"
        task_name.ReactorNumbers => "ReactorNumbers"
        task_name.FluidLevels => "FluidLevels"
        task_name.PassCode => "PassCode"
        task_name.PassCodeSecurity => "PassCodeSecurity"
        task_name.CallEarth => "CallEarth"
        task_name.AlignUpperEngine => "Align upper engine"
        task_name.AlignLowerEngine => "Align lower engine"
        task_name.TuneSignal => "TuneSignal"
        task_name.ClearSpace => "ClearSpace"
        task_name.Fuel => "Fuel up"
        task_name.Shields => "Shields"
        task_name.SubmitScan => "Submit scan"
        task_name.DivertPower => "Divert power"
        task_name.TransferData => "Transfer data"
        task_name.EmptyGarbage => "Empty garbage"
        task_name.SabotageO2 => "Sabotage O2"
        task_name.SabotageLockDoors => "Sabotage Lock Doors"
        task_name.SabotageReactorFail => "Sabotage Reactor Fail"
        task_name.SabotageElectrical => "Sabotage Electrical"
        task_name.SabotageComms => "Sabotage Comms"
        task_name.None => "None"



# Devices struct
show_task_buttons<public> := struct<concrete>:
    @editable
    Button<public>:?button_device = option{button_device{}}
    @editable
    TaskName<public>:?task_name = false

stage_info<public> := class:
    StageId<public>:int
    StageOrder<public>:int
    Location<public>:map_locations
    IsCompleted<public>:logic
    Coordinates<public>:vector2

sabotage_stage_info<public> := class:
    StageId<public>:int
    Location<public>:map_locations
    Coordinates<public>:vector2

sabotage_info<public> := class:
    SabotageName<public>:task_name
    StagesInfo<public>:[]sabotage_stage_info

    GetStages<public>():[]sabotage_stage_info =
        StagesInfo
