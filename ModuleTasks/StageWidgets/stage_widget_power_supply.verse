# using { /Fortnite.com }
using { /Fortnite.com/UI }
# using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using {/Verse.org/Random}
using { /Verse.org }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { Modules.TaskAssets.CrazyPowerSupply }

stage_widget_crazy_power_supply_slider_direction<internal> := enum:
    Left
    Right


stage_widget_crazy_power_supply_slider<internal> := class():
    var Container<private>:canvas = canvas{}

    WidgetSlider<private>:slider_regular = slider_regular:
        DefaultMinValue:=0.0
        DefaultMaxValue:=100.0

    WidgetTarget<private>:texture_block = texture_block:
        DefaultImage := T_PowerSupply_Rectangle
        DefaultDesiredSize := vector2{X:=94.0, Y:=77.113258}

    Speed<internal>:float = 1.0
    Step<internal>:float = 3.0
    var Direction<private>:stage_widget_crazy_power_supply_slider_direction = stage_widget_crazy_power_supply_slider_direction.Left

    EventStopRunning<private>:event() = event(){}
    
    var Stop<public>:logic = false
    var Completed<public>:logic = false

    var RandomTarget<private>:float = 0.0

    # Create widget canvas and run slider
    Create<public>():void = 
        set RandomTarget = GetRandomFloat(0.1,0.9)

        TmpCanvas := canvas:
            Slots := array:
                canvas_slot:
                    ZOrder := 0
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 450.0, Bottom := 50.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := WidgetSlider

                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum := vector2{X := RandomTarget, Y := 0.5}, Maximum := vector2{X := RandomTarget, Y := 0.5}}
                    # Offsets := margin{Top := 0.0, Left := 0.0, Right := 50.0, Bottom := 100.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := true
                    Widget := WidgetTarget

        WidgetSlider.SetEnabled(false)

        RandomInt := Random.GetRandomInt(0, 1)
        if(RandomInt=0):
            set Direction = stage_widget_crazy_power_supply_slider_direction.Left
        else:
            set Direction = stage_widget_crazy_power_supply_slider_direction.Right

        spawn:
            ChangeSliderValues()

        set Container = TmpCanvas

    # Run slider values
    ChangeSliderValues<private>()<suspends>:void = 
        race:
            loop:
                Sleep(Speed)
                var NewValue:float = 0.0
                Value := WidgetSlider.GetValue()
                
                if(Direction = stage_widget_crazy_power_supply_slider_direction.Left):
                    set NewValue = Value - Step
                else:
                    set NewValue = Value + Step

                if(NewValue>100.0):
                    set NewValue = 100.0
                    set Direction = stage_widget_crazy_power_supply_slider_direction.Left
                else if(NewValue<0.0):
                    set NewValue = 0.0
                    set Direction = stage_widget_crazy_power_supply_slider_direction.Right

                WidgetSlider.SetValue(NewValue)

            EventStopRunning.Await()

    # Return widget canvas
    GetWidget<public>():canvas = 
        return Container

    # Stop widget slider from running and return result
    StopRunning<public>():logic = 
        EventStopRunning.Signal()
        set Stop = true
        var Output:logic = false

        MinTarget := RandomTarget*100.0-10.0
        MaxTarget := RandomTarget*100.0+10.0
        
        Value:float = WidgetSlider.GetValue()
        if(Value>=MinTarget and Value<=MaxTarget):
            set Completed = true
            set Output = true
        Output


Make_stage_widget_crazy_power_supply<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_fix_power_supply, StageController:stage_controller) := stage_widget_crazy_power_supply:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer
    

stage_widget_crazy_power_supply<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_fix_power_supply

    WidgetBackgroundBox<private>:texture_block = texture_block:
        DefaultImage := T_powerSupply_bg

    var WidgetSliders<private>:[]tuple(stage_widget_crazy_power_supply_slider,vector2) = array:
    var WidgetButtons<private>:[]tuple(text_button_base,anchors) = array:

    var ButtonCancelables<private>:[]cancelable = array{}
    var PowerSupplyWidget<private>:WBP_PowerSupply = WBP_PowerSupply{}

    OnInit<override>():void =

        set WidgetSliders = array:
            (stage_widget_crazy_power_supply_slider{Speed:=0.01, Step:=1.0}, vector2{X:=0.5200, Y:=0.23796})
            (stage_widget_crazy_power_supply_slider{Speed:=0.01, Step:=2.0}, vector2{X:=0.5200, Y:=0.417251})
            (stage_widget_crazy_power_supply_slider{Speed:=0.01, Step:=3.0}, vector2{X:=0.5200, Y:=0.598408})

        set WidgetButtons = array:
            (button_quiet{DefaultText:=StringToMsg("STOP!")}, anchors{Minimum:=vector2{X:=0.090617,Y:=0.199055}, Maximum:=vector2{X:=0.210018, Y:=0.274685}})
            (button_quiet{DefaultText:=StringToMsg("STOP!")}, anchors{Minimum:=vector2{X:=0.090617,Y:=0.379031}, Maximum:=vector2{X:=0.210018, Y:=0.454828}})
            (button_quiet{DefaultText:=StringToMsg("STOP!")}, anchors{Minimum:=vector2{X:=0.090617,Y:=0.559257}, Maximum:=vector2{X:=0.210018, Y:=0.635238}})

        var ContainerWidgets:[]canvas_slot = array{}

        for(X := 0..2, WidgetSlider := WidgetSliders[X], WidgetButton := WidgetButtons[X]):
            WidgetSlider(0).Create()

            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := WidgetSlider(1), Maximum := WidgetSlider(1)}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 450.0, Bottom := 50.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array:
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 10
                                Widget := WidgetSlider(0).GetWidget()

                canvas_slot:
                    ZOrder := 1
                    Anchors := WidgetButton(1)
                    SizeToContent := false
                    Widget := WidgetButton(0)

            ButtonCancelable := WidgetButton(0).OnClick().SubscribeWidgetMessage(OnButtonClick, X)
            set ButtonCancelables += array{ButtonCancelable}
            set ContainerWidgets += Slots

        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    ZOrder := 0
                    SizeToContent := false
                    Widget := WidgetBackShadow

                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    Widget := block:
                        set PowerSupplyWidget = WBP_PowerSupply:
                            Target1X := 437.0
                            Target2X := 637.0
                            Target3X := 820.0
                            IsVisibleLed1 := false
                            IsVisibleLed2 := false
                            IsVisibleLed3 := false
                        PowerSupplyWidget

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1300.0, Bottom := 1000.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 2
                    Widget := canvas:
                        Slots := array{

                            # canvas_slot:
                            #     Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                            #     Offsets := margin{Top := 0.0, Left := 0.0, Right := 1300.0, Bottom := 1000.0}
                            #     Alignment := vector2{X := 0.5, Y := 0.5}
                            #     SizeToContent := false
                            #     ZOrder := 0
                            #     Widget:= WidgetBackgroundBox

                            # canvas_slot:
                            #     Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.1}, Maximum := vector2{X := 0.5, Y := 0.1}}
                            #     # Offsets := margin{Top := 0.0, Left := 0.0, Right := 100.0, Bottom := 50.0}
                            #     Alignment := vector2{X := 0.5, Y := 0.5}
                            #     SizeToContent := true
                            #     ZOrder := 1
                            #     Widget:= text_block:
                            #         DefaultText:=StringToMsg("The generator went crazy. Fix it!")
                            #         DefaultTextColor:=NamedColors.Black

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.090617, Y := 0.804191}, Maximum := vector2{X := 0.210018, Y := 0.880545}}
                                SizeToContent := false
                                ZOrder := 1
                                Widget := CreateExitButton()

                            } + ContainerWidgets
    
    OnButtonClick<private>(WidgetMessage:widget_message, Number:int):void =
        if(WidgetSlider := WidgetSliders[Number]):
            SliderResult := WidgetSlider(0).StopRunning()

            if(not SliderResult?):
                spawn:
                    SignalStageFailedDelayed(0.5)
            else:
                # Update LED visibility based on which button was clicked
                if(Number = 0):
                    set PowerSupplyWidget.IsVisibleLed1 = true
                else if(Number = 1):
                    set PowerSupplyWidget.IsVisibleLed2 = true
                else if(Number = 2):
                    set PowerSupplyWidget.IsVisibleLed3 = true

        if(Cancelable := ButtonCancelables[Number]):
            Cancelable.Cancel()

        CheckIfAllCompleted()


    CheckIfAllCompleted<private>():void =
        var AllCompleted:logic = true
        for(Slider:WidgetSliders):
            if(not Slider(0).Completed?):
                set AllCompleted = false
                return

        if(AllCompleted?):
            spawn:
                SignalStageCompletedDelayed(0.5)
