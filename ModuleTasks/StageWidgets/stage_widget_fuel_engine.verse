
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using {/Verse.org/Random}
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Devices }

using { Modules.TaskAssets.Fuel }

Make_stage_widget_fuel_engine<constructor><public>(InLogger:log, Player:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_fuel_fill_engine, StageController:stage_controller) := stage_widget_fuel_engine:
    StageDevices := InStageDevices
    # APlayer := InAPlayer
    StageController := StageController
    Player := Player

stage_widget_fuel_engine<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_fuel_fill_engine

    WidgetStartFillButton<private>:button_quiet = button_quiet:
        DefaultText := MsgStartFill

    WidgetFuelUp<private>:WBP_FuelEngine = WBP_FuelEngine{}

    OnDestroy<override>():void = {}
    
    OnInit<override>():void =
        Subscriptions.Add(WidgetStartFillButton.OnClick().Subscribe(OnClickStartFill))

        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    ZOrder := 0
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := WidgetBackShadow

                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    Widget := WidgetFuelUp

                canvas_slot:
                    ZOrder := 2
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 842.0, Bottom := 768.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array:

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.161319, Y := 0.848786}, Maximum := vector2{X := 0.383625, Y := 0.917816}}
                                SizeToContent := false
                                Widget := WidgetStartFillButton

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.602647, Y := 0.847718}, Maximum := vector2{X := 0.822531, Y := 0.915675}}
                                SizeToContent := false
                                Widget := CreateExitButton()   

    OnClickStartFill<private>(WidgetMessage:widget_message):void = 
        spawn:
            FillupCanister()

    FillupCanister<private>()<suspends>:void = 
        if(not WidgetFuelUp.StartFuelAnimation?):
            set WidgetFuelUp.StartFuelAnimation = true
            WidgetStartFillButton.SetEnabled(false)
            race:
                EventViewDestroyed.Await()
                block:
                    Sleep(6.0)
                    SignalStageCompletedDelayed(0.5)
                    



    

    