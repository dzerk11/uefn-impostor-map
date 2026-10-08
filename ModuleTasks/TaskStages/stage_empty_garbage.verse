
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }

# Devices
stage_devices_empty_garbage<public> := class<final><concrete>(stage_devices):
    @editable
    CSD_AnimationEmptyGarbage<public>:cinematic_sequence_device = cinematic_sequence_device{}
    

# Constructor
Make_stage_empty_garbage<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_empty_garbage) := stage_empty_garbage:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_empty_garbage<public> := class(stage_base):
    Location<override>:map_locations = map_locations.Cafeteria
    AllowMultiPlayer<override>:logic = false
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_empty_garbage
    HideHudOnStart<override>:logic = false

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget = false

    HandleStage<override>(PlayerStageData:player_stage_data_base)<suspends>:void = 
        if:
            FNCharacter:fort_character = PlayerStageData.Player.GetFortCharacter[]
        then:
            StageDevices.TaskPanel.Disable()
            StageDevices.CSD_AnimationEmptyGarbage.SetPlaybackFrame(0)
            StageDevices.CSD_AnimationEmptyGarbage.Play(PlayerStageData.Player)
            
            StageDevices.CSD_AnimationEmptyGarbage.StoppedEvent.Await()
            Self.SignalPlayerCompletes(PlayerStageData.Player)

                
    CleanupStage<override>(PlayerStageData:player_stage_data_base):void =
        StageDevices.TaskPanel.Enable()
        StageDevices.CSD_AnimationEmptyGarbage.Stop(PlayerStageData.Player)
        StageDevices.CSD_AnimationEmptyGarbage.SetPlaybackFrame(0)
        
