
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { /Fortnite.com/Characters }

# Devices
stage_devices_align_engine<public> := class<final><concrete>(stage_devices):
    @editable
    EngineProp<public>:creative_prop = creative_prop{}
    @editable
    CinematicCamera<public>:cinematic_sequence_device = cinematic_sequence_device{}
    

# Constructor
Make_stage_align_upper_engine<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_align_engine) := stage_align_engine:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    Location := map_locations.UpperEngine
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
        EngineTransform := InStageDevices.EngineProp.GetTransform()
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}
    HomeTransform := EngineTransform
        


# Constructor
Make_stage_align_lower_engine<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_align_engine) := stage_align_engine:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    Location := map_locations.LowerEngine
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
        EngineTransform := InStageDevices.EngineProp.GetTransform()
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}
    HomeTransform := EngineTransform

     
# Class
stage_align_engine<public> := class(stage_base):
    AllowMultiPlayer<override>:logic = false
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_align_engine
    HomeTransform<public>:transform
    HideHudOnStart<override>:logic = true


    Init<override>():void = 
        (super:)Init()
        spawn:
            MoveEngineToDefaultPosition()

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_align_engine(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false

    MoveEngineToDefaultPosition<private>()<suspends>:void =
        var RandomInt:int = GetRandomInt(-4, +4)
        if(RandomInt = 0):
            set RandomInt = 3
            
        NewTransform := transform:
            Scale := HomeTransform.Scale, 
            Rotation := HomeTransform.Rotation.ApplyYaw((PiFloat/48.0*RandomInt)), 
            Translation := HomeTransform.Translation

        StageDevices.EngineProp.MoveTo(NewTransform, 0.2)

    HandleStage<override>(PlayerStageData:player_stage_data_base)<suspends>:void = 
        MoveEngineToDefaultPosition()

        if (Character:fort_character = PlayerStageData.Player.GetFortCharacter[]):
            StasysArgs:stasis_args = stasis_args:
                AllowTurning := false
                AllowFalling := true
                AllowEmotes := false
            
            Character.PutInStasis(StasysArgs)

        StageDevices.CinematicCamera.Play(PlayerStageData.Player)
        Sleep(1.0)
        StageDevices.CinematicCamera.Pause(PlayerStageData.Player)

    CleanupStage<override>(PlayerStageData:player_stage_data_base):void = 
        if (Character:fort_character = PlayerStageData.Player.GetFortCharacter[]):
            Character.ReleaseFromStasis()
        StageDevices.CinematicCamera.Stop(PlayerStageData.Player)   