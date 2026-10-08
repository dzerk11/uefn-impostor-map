
using { /Verse.org/Simulation }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

using {Modules.SecurityCamera}

Make_ui_widget_security_cam_view<public><constructor>(InPlayer:player, InLogger:custom_logger, InCbCloseButton:(tuple(player,view_security_cam_view))->void, InCbChangeCamera:type{_(:player,:logic)<suspends>:void}) := view_security_cam_view:
    CbBtnClose := InCbCloseButton
    CbChangeCamera := InCbChangeCamera
    Player := InPlayer

view_security_cam_view<public> := class(ui_view_verse):
    InputMode<override>:ui_input_mode = ui_input_mode.All

    WidgetBtnClose<private>:button_quiet = button_quiet:
    WidgetBtnNext<private>:button_quiet = button_quiet:
    WidgetBtnPrevious<private>:button_quiet = button_quiet:

    CbBtnClose<public>:(tuple(player,view_security_cam_view))->void
    CbChangeCamera<public>:type{_(:player,:logic)<suspends>:void}

    OnInit<override>():void = 
        Subscriptions.Add(WidgetBtnClose.OnClick().Subscribe(OnClickCloseButton))
        Subscriptions.Add(WidgetBtnNext.OnClick().Subscribe(OnClickNextButton))
        Subscriptions.Add(WidgetBtnPrevious.OnClick().Subscribe(OnClickPreviousButton))

        set Widget = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    ZOrder := 1
                    Widget := WBP_SecurityCamera{}

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=0.350069,Y:=0.888889}, Maximum := vector2{X := 0.350069, Y := 0.888889}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 120.0, Bottom := 120.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 3
                    Widget := WidgetBtnPrevious

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.888889}, Maximum := vector2{X := 0.5, Y := 0.888889}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 410.0, Bottom := 120.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 3
                    Widget := WidgetBtnClose

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=0.649913,Y:=0.888889}, Maximum := vector2{X := 0.649913, Y := 0.888889}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 120.0, Bottom := 120.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 3
                    Widget := WidgetBtnNext

    OnDestroy<override>():void = {}

    OnClickCloseButton<internal>(WidgetMessage:widget_message):void = 
        CbBtnClose(WidgetMessage.Player, Self)

    OnClickNextButton<private>(WidgetMessage:widget_message):void = 
        spawn:
            CbChangeCamera(WidgetMessage.Player, true)

    OnClickPreviousButton<private>(WidgetMessage:widget_message):void = 
        spawn:
            CbChangeCamera(WidgetMessage.Player, false)







    
    
    
        
    
            
