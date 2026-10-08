
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }

using { ModuleTasks }
using { Modules.Vents }

MsgCloseVents<localizes>:message = "CLOSE"

Make_widget_vents<public><constructor>(InPlayer:player, EventManager:event_manager, InRotation:rotation, InPosition:vector3, InPlayerTexture:texture, VentInteracted:vent_class) := widget_vents:
    Player := InPlayer
    DefaultPlayerPosition := InPosition
    DefaultPlayerRotation := InRotation
    DefaultPlayerTexture := InPlayerTexture
    VentInteracted := VentInteracted
    EventManager := EventManager


widget_vents<public> := class(Ui.ui_view_verse, event_listener):
    
    EventManager<public>:event_manager
    DefaultPlayerPosition<public>:vector3
    DefaultPlayerRotation<public>:rotation
    DefaultPlayerTexture<public>:texture
    VentInteracted<public>:vent_class

    ZOrder<override>:type {_X:int where 0 <= _X, _X <= 2147483647} = 10
    InputMode<override>:ui_input_mode = ui_input_mode.All

    
    BackShadow<private>:color_block = color_block:
        DefaultColor := MakeColorFromHex("000")
        DefaultOpacity := 0.5

    TextureBackgroundVents<public>:texture = T_WidgetVentsReactorUpper

    WidgetMap<protected>:widget = texture_block:
        DefaultImage:= Art.Textures.T_mapSkeld,
        DefaultDesiredSize := vector2{X := 800.0, Y := 400.0}

    ExitButton<private>:button_quiet = button_quiet:
        DefaultText := MsgCloseVents

    var CanvasPlayerPointer<private>:canvas = canvas{}
    WidgetPlayerPointer<internal>:texture_block = texture_block:
        DefaultImage := Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_0
        DefaultDesiredSize := vector2{X := 65.0, Y := 65.0}

    var WidgetVentButtons<public>:[]tuple(text_button_base, float, vent_class) = array{}

    OnDestroy<override>():void = 
        EventManager.UnSubscribe(Self)

    OnInit<override>():void = 
        EventManager.Subscribe(event_type.PLAYER_POSITION, Self, Player)

        CreateVentButtons()

        Subscriptions.Add(ExitButton.OnClick().Subscribe(OnExitClick))

        for(Tuple:WidgetVentButtons):
            if(VentInteracted.VentId=Tuple(2).VentId):
                Tuple(0).SetEnabled(false)
        
            Subscriptions.Add(Tuple(0).OnClick().SubscribeWidgetMessage(OnTeleportButtonClicked, Tuple(2)))

        WidgetPlayerPointer.SetImage(DefaultPlayerTexture)

        set Widget = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := BackShadow

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:=0.0, Y:=0.0}, Maximum := vector2{X:=1.0, Y:=1.0}}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := WBP_Vents:
                        TextureVents := TextureBackgroundVents

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1920.0, Bottom := 1080.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 2
                    Widget := canvas:
                        Slots := array:
                            # canvas_slot:
                            #     Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                            #     Alignment := vector2{X := 0.5, Y := 0.5}
                            #     SizeToContent := false
                            #     ZOrder := 0
                            #     Widget := texture_block:
                            #         DefaultImage := TextureBackgroundVents

                            # Player pointer
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.315338, Y := 0.154923}, Maximum := vector2{X := 0.980465, Y := 0.844811}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 1
                                Widget := CanvasPlayerPointer
                            
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.024689, Y := 0.053108}, Maximum := vector2{X := 0.291783, Y := 0.944081}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := canvas:
                                    Slots := array {
                                        
                                        # Close button
                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.8}, Maximum := vector2{X := 0.5, Y := 0.8}}
                                            Offsets := margin{Top := 0.0, Left := 0.0, Right := 250.0, Bottom := 40.0}
                                            Alignment := vector2{X := 0.5, Y := 0.5}
                                            SizeToContent := false
                                            ZOrder := 0
                                            Widget := ExitButton

                                        } + for(Tuple:WidgetVentButtons):
                                            canvas_slot:
                                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := Tuple(1)}, Maximum := vector2{X := 0.5, Y := Tuple(1)}}
                                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 345.0, Bottom := 50.0}
                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                SizeToContent := false
                                                ZOrder := 3
                                                Widget := Tuple(0)

        UpdatePlayerPosition(DefaultPlayerPosition)
        WidgetPlayerPointer.SetImage(DefaultPlayerTexture)

    OnTeleportButtonClicked<private>(WidgetMessage:widget_message, Vent:vent_class):void = 
        EventManager.Notify(event_vent_button_clicked{Vent:=Vent,Player:=option{WidgetMessage.Player}})

        for(Tuple:WidgetVentButtons):
            if(Vent.VentId=Tuple(2).VentId):
                Tuple(0).SetEnabled(false)
            else:
                Tuple(0).SetEnabled(true)

    CreateVentButtons<protected>():void = {}  

    OnExitClick<internal>(WidgetMessage:widget_message):void = 
        EventViewCloseRequested.Signal(Self)
    
    SignalVentButtonClicked<protected>(VentClicked:vent_class):void = 
        EventManager.Notify(event_vent_button_clicked{Vent:=VentClicked})

    Update<override>(EventPayload:event_payload):void = 
        case(EventPayload.EventType):
            event_type.PLAYER_POSITION => 
                if(Payload := event_player_position[EventPayload]):
                    UpdatePlayerPosition(Payload.Data)
            _ =>

    # Update player position
    UpdatePlayerPosition(Translation:vector3):void = 
        PlayerPointerCoordinates := Ui.ConvertRealCoordinatesIntoMapRelative(vector2{X := Translation.X, Y := Translation.Y})
        CanvasPlayerPointer.RemoveWidget(WidgetPlayerPointer)
        CanvasPlayerPointer.AddWidget(canvas_slot{
            Anchors := anchors{Minimum := PlayerPointerCoordinates, Maximum := PlayerPointerCoordinates}
            Alignment := vector2{X := 0.5, Y := 0.5}
            ZOrder := 2
            SizeToContent := true
            Widget := WidgetPlayerPointer})
        WidgetPlayerPointer.SetVisibility(widget_visibility.Visible)
