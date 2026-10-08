
using { /Fortnite.com/UI }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

Make_stage_widget_tune_signal_tuner<constructor><internal>() := stage_widget_tune_signal_tuner:
    let:
        var TempTarget:float = GetRandomFloat(10.0, 100.0)
    
    Target := TempTarget

stage_widget_tune_signal_tuner<internal> := class: 
    Widget<internal>:slider_regular = slider_regular:
        DefaultValue := 0.0
        DefaultMinValue := 0.0
        DefaultMaxValue := 100.0

    Target<internal>:float

    GetTuningValue<internal>():float = 
        WidValue:float = Widget.GetValue()
        var TargetDistance:float = Target - WidValue
        if(TargetDistance<0.0):
            set TargetDistance = -TargetDistance

        TuningValue := 100.0 - TargetDistance


Make_stage_widget_tune_signal<constructor><public>(InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_tune_signal, StageController:stage_controller) := stage_widget_tune_signal:
    StageDevices := InStageDevices
    Player := InPlayer
    StageController := StageController

stage_widget_tune_signal<public> := class(stage_widget):
    
    WidgetSliderTotal<private>:slider_regular = slider_regular:
        DefaultValue := 0.0
        DefaultMinValue := 0.0
        DefaultMaxValue := 100.0

    WidgetBackgroundBox<private>:color_block = color_block:
        DefaultColor := NamedColors.Gray
        DefaultDesiredSize := vector2{X := 800.0, Y := 800.0}

    var TunerWidgets<private>:[]stage_widget_tune_signal_tuner = array{}

    OnInit<override>():void =

        KeyPad := 30.0
        
        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    SizeToContent := false
                    Widget := WidgetBackShadow

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.15, Y := 0.15}, Maximum := vector2{X := 0.85, Y := 0.85}}
                    # Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array:
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Widget := Self.WidgetBackgroundBox

                            canvas_slot:
                                # Anchors := anchors{Minimum := vector2{X := 0.25, Y := 0.25}, Maximum := vector2{X := 0.75, Y := 0.75}}
                                Anchors := anchors{Minimum := vector2{X := 0.2, Y := 0.2}, Maximum := vector2{X := 0.8, Y := 0.8}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Widget := canvas:
                                    Slots := array:

                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.1, Y := 0.2}, Maximum := vector2{X := 0.9, Y := 0.2}}
                                            # Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                            Alignment := vector2{X := 0.5, Y := 0.5}
                                            ZOrder := 0
                                            Widget := WidgetSliderTotal

                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.1}, Maximum := vector2{X := 1.0, Y := 0.3}}
                                            # Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                            Alignment := vector2{X := 0.5, Y := 0.5}
                                            ZOrder := 1
                                            Widget := color_block:
                                                DefaultColor := NamedColors.White
                                                DefaultOpacity := 0.0
                                                # DefaultDesiredSize := vector2{X := 0.0, Y := 200.0}

                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 1.0, Y := 0.5}}
                                            # Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                            Alignment := vector2{X := 0.5, Y := 0.5}
                                            Widget:= stack_box:
                                                Orientation := orientation.Horizontal
                                                Slots := for (X := 0..2):
                                                    SignalTuner := Make_stage_widget_tune_signal_tuner()
                                                    set TunerWidgets += array{SignalTuner}

                                                    SignalTuner.Widget.OnValueChanged().SubscribeWidgetMessage(OnValueChange,X)
                                        
                                                    stack_box_slot:
                                                        Widget := SignalTuner.Widget
                                                        Padding := margin{Top := 0.0, Left := 25.0, Right := 25.0, Bottom := 0.0}

        CalculateTotalValue()

    OnValueChange<private>(WidgetMessage:widget_message, Id:int):void = 
        CalculateTotalValue()

    CalculateTotalValue<private>(): void =

        var Final:float = 0.0
        for(Tuner:Self.TunerWidgets):
            set Final += (Tuner.GetTuningValue() * 0.4)

        WidgetSliderTotal.SetValue(Final)

        if (Final >= 95.0):
            SignalPlayerCompletes()