
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_submit_scan<public> := class<final><concrete>(stage_devices):
    @editable
    CaptureArea<public>:capture_area_device = capture_area_device{}
    @editable
    CinematicSequence<public>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable
    Teleporter<public>:teleporter_device = teleporter_device{}

    
# Constructor
Make_stage_submit_scan<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_submit_scan) := stage_submit_scan:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.CaptureArea.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_submit_scan<public> := class(stage_base):
    Location<override> :map_locations = map_locations.MedBay
    AllowMultiPlayer<override>:logic = false
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_submit_scan

    Init<override>():void = 
        (super:)Init()
        Self.AppendCancelable(StageDevices.CaptureArea.AgentEntersEvent.Subscribe(SignalPlayerInteracts))

    MakeUi<override>(InPlayer:player):?StageWidgets.stage_widget =
        if(PlayerStageData := GetPlayerStageData[InPlayer]):
            UiMade := StageWidgets.Make_stage_widget_submit_scan(Logger, InPlayer, StageId, StageDevices, Self)
            option{UiMade}
        else:
            false

    HandleStage<override>(PlayerStageData:player_stage_data_base)<suspends>:void = 
        if(Widget := StageWidgets.stage_widget_submit_scan[PlayerStageData.StageWidget?]):
            Widget.HandleAnimation()

    CleanupStage<override>(PlayerStageData:player_stage_data_base):void = 
        if(Widget := StageWidgets.stage_widget_submit_scan[PlayerStageData.StageWidget?]):
            Widget.ClearAnimation()