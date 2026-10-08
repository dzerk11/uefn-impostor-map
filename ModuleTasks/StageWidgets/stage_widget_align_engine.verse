
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
using { /Verse.org }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { ModuleTasks }
using { Modules.TaskAssets.AlignEngine }


Make_stage_widget_align_engine<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_align_engine, StageController:stage_controller) := stage_widget_align_engine:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer

stage_widget_align_engine<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_align_engine

    TargetRotationRadians<private>:float = 0.0
    
    LeftButton<private>:button_regular = button_regular:
    RightButton<private>:button_regular = button_regular:
            
    var IsEngineMoving<private>:logic = false
    var IsCompleted<private>:logic = false

    var WidgetAlignEngine<private>:WBP_AlignEngine = WBP_AlignEngine{}

    OnInit<override>():void =
        WidgetBackShadow.SetOpacity(0.4)
        LeftButton.SetText(StringToMsg("◄"))
        RightButton.SetText(StringToMsg("►"))

        Subscriptions.Add(LeftButton.OnClick().Subscribe(MoveEngineToRight))
        Subscriptions.Add(RightButton.OnClick().Subscribe(MoveEngineToLeft))
                                                    
        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    ZOrder := 0
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    SizeToContent := false
                    Widget := WidgetBackShadow

                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    Widget := WidgetAlignEngine

                canvas_slot:
                    ZOrder := 2
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                    Offsets := margin{Top := -64.0, Left := 0.0, Bottom := 100.0, Right := 800.0}
                    Alignment := vector2{X := 0.5, Y := 1.0}
                    SizeToContent := false
                    Widget := overlay:
                        Slots := array:
                            
                            overlay_slot:
                                HorizontalAlignment := horizontal_alignment.Center
                                VerticalAlignment := vertical_alignment.Center
                                Padding := margin{Left:=16.0, Right:=16.0, Top:=16.0, Bottom:=16.0}
                                Widget := stack_box:
                                    Orientation := orientation.Horizontal
                                    Slots := array:

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            VerticalAlignment := vertical_alignment.Center
                                            Padding := margin{Left:=16.0, Right:=16.0, Top:=8.0, Bottom:=8.0}
                                            Widget := LeftButton

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            VerticalAlignment := vertical_alignment.Center
                                            Padding := margin{Left:=16.0, Right:=16.0, Top:=8.0, Bottom:=8.0}
                                            Widget := CreateExitButton()

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            VerticalAlignment := vertical_alignment.Center
                                            Padding := margin{Left:=16.0, Right:=16.0, Top:=8.0, Bottom:=8.0}
                                            Widget := RightButton

                # canvas_slot:
                #     Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                #     Alignment := vector2{X := 0.5, Y := 0.5}
                #     SizeToContent := false
                #     ZOrder := 1
                #     Widget := canvas:
                #         Slots := array{

                #             canvas_slot:
                #                 Anchors := anchors{Minimum := vector2{X := 0.2, Y := 0.5}, Maximum := vector2{X := 0.2, Y := 0.5}}
                #                 Offsets := margin{Top := 0.0, Left := 0.0, Right := 200.0, Bottom := 100.0}
                #                 Alignment := vector2{X := 0.5, Y := 0.5}
                #                 SizeToContent := false
                #                 Widget := LeftButton

                #             canvas_slot:
                #                 Anchors := anchors{Minimum := vector2{X := 0.8, Y := 0.5}, Maximum := vector2{X := 0.8, Y := 0.5}}
                #                 Offsets := margin{Top := 0.0, Left := 0.0, Right := 200.0, Bottom := 100.0}
                #                 Alignment := vector2{X := 0.5, Y := 0.5}
                #                 SizeToContent := false
                #                 Widget := RightButton

                #             canvas_slot:
                #                 Anchors := anchors{Minimum := vector2{X := 0.2, Y := 0.95}, Maximum := vector2{X := 0.8, Y := 0.95}}
                #                 Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 100.0}
                #                 Alignment := vector2{X := 0.5, Y := 1.0}
                #                 SizeToContent := false
                #                 Widget := canvas:
                #                     Slots := array:

                #                         canvas_slot:
                #                             Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                #                             Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                #                             Alignment := vector2{X := 0.5, Y := 0.5}
                #                             SizeToContent := false
                #                             Widget := CreateExitButton()
                #             }

    # Show<override>():void =
    #     (super:)Show()
    #     spawn:
    #         StageHandler()

    # StageHandler()<suspends>:void = 
    #     race:
    #         block:
    #             StartControllingEngine()
    #             Sleep(Inf)
    #         EventViewDestroyed.Await()
    #     StopControllingEngine()       

    # StartControllingEngine<public>()<suspends>:void = 
        

    # StopControllingEngine<private>()<suspends>:void =
    #     if (Character:fort_character = Self.Player.GetFortCharacter[]):
    #         Character.ReleaseFromStasis()
    #     StageDevices.CinematicCamera.Stop(Self.Player)

    MoveEngineToLeft<private>(WidgetMessage:widget_message):void = 
        spawn:
            TrackEngineMove(-PiFloat/48.0)

    MoveEngineToRight<private>(WidgetMessage:widget_message):void = 
        spawn:
            TrackEngineMove(+PiFloat/48.0)

    TrackEngineMove<private>(Offset:float)<suspends>:void =
        LeftButton.SetEnabled(false)
        RightButton.SetEnabled(false)
        if (not IsEngineMoving?):
            set IsEngineMoving = true
            Transform := StageDevices.EngineProp.GetTransform()
            NewTransform := transform:
                Scale := Transform.Scale, 
                Rotation := Transform.Rotation.ApplyYaw(Offset), 
                Translation := Transform.Translation
            
            EngineRotationRadians := Transform.Rotation.GetAxis().Z*Transform.Rotation.GetAngle()
            DiffRotationRadians := EngineRotationRadians - TargetRotationRadians

            if(Offset>0.0 and DiffRotationRadians<=(PiFloat/48.0*4.0) or Offset<0.0 and DiffRotationRadians>=-(PiFloat/48.0*4.0)):
                branch:
                    StageDevices.EngineProp.MoveTo(NewTransform, 0.7)

                Sleep(0.7)
                CheckEnginePosition()

            set IsEngineMoving = false

        if(not IsCompleted?):
            LeftButton.SetEnabled(true)
            RightButton.SetEnabled(true)

    CheckEnginePosition():void = 
        Transform := StageDevices.EngineProp.GetTransform()
        EngineRotationRadians := Transform.Rotation.GetAxis().Z*Transform.Rotation.GetAngle()

        if(EngineRotationRadians>=-TargetRotationRadians*1.05 and EngineRotationRadians<=TargetRotationRadians*1.05):
            set IsCompleted = true
            spawn:
                SignalStageCompletedDelayed(0.5)

    CreateExitButton<override>():widget =
        CloseButton:button_regular = button_regular{}
        CloseButton.SetText(MsgCloseWidgetStage)
        Subscriptions.Add(CloseButton.OnClick().Subscribe(Self.OnCloseButtonClick))
        CloseButton