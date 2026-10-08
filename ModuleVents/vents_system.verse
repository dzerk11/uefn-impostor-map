
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { VentWidgets }

log_vents_system_device := logger_channel

vents_system_device := class(creative_device, event_listener):
    Logger<private>:log = log{Channel:=log_vents_system_device, DefaultLevel:=log_level.Debug}

    @editable EventManager:event_manager = event_manager {}

    @editable VentUpperEngine<private>:vent_class = vent_class:
        VentId := vent_id.UPPER_ENGINE
    @editable VentLowerEngine<private>:vent_class = vent_class:
        VentId := vent_id.LOWER_ENGINE
    @editable VentReactorUpper<private>:vent_class = vent_class:
        VentId := vent_id.REACTOR_UPPER
    @editable VentReactorLower<private>:vent_class = vent_class:
        VentId := vent_id.REACTOR_LOWER
    @editable VentMedbay<private>:vent_class = vent_class:
        VentId := vent_id.MEDBAY
    @editable VentSecurity<private>:vent_class = vent_class:
        VentId := vent_id.SECURITY
    @editable VentElectrical<private>:vent_class = vent_class:
        VentId := vent_id.ELECTRICAL
    @editable VentCafeteria<private>:vent_class = vent_class:
        VentId := vent_id.CAFETERIA
    @editable VentAdmin<private>:vent_class = vent_class:
        VentId := vent_id.ADMIN
    @editable VentHallwayNavigation<private>:vent_class = vent_class:
        VentId := vent_id.HALLWAY_NAVIGATION
    @editable VentNavigationUpper<private>:vent_class = vent_class:
        VentId := vent_id.NAVIGATION_UPPER
    @editable VentNavigationLower<private>:vent_class = vent_class:
        VentId := vent_id.NAVIGATION_LOWER
    @editable VentShields<private>:vent_class = vent_class:
        VentId := vent_id.SHIELDS
    @editable VentWeapons<private>:vent_class = vent_class:
        VentId := vent_id.WEAPONS

    var PlayerWidgets<private>:[agent]?widget_vents = map{}
    var PlayerCloseRequestCancelable<private>:[agent]?custom_cancelable = map{}

    

    Update<override>(EventPayload:event_payload):void = 
        case(EventPayload.EventType):
            event_type.VENT_BUTTON_CLICK => 
                if(Payload := event_vent_button_clicked[EventPayload], Player:=EventPayload.Player?):
                    Payload.Vent.Teleporter.Teleport(Player)
            event_type.EMERGENCY_MEETING_STATUS => 
                if(Payload := event_emergency_meeting_status[EventPayload]):
                    for(Player->Widget:PlayerWidgets):
                        Hide(Player)
            _ => 

    OnBegin<override>():void = 
        VentUpperEngine.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentUpperEngine)
        VentLowerEngine.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentLowerEngine)
        VentReactorUpper.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentReactorUpper)
        VentReactorLower.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentReactorLower)
        VentMedbay.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentMedbay)
        VentSecurity.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentSecurity)
        VentElectrical.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentElectrical)
        VentCafeteria.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentCafeteria)
        VentAdmin.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentAdmin)
        VentHallwayNavigation.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentHallwayNavigation)
        VentNavigationUpper.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentNavigationUpper)
        VentNavigationLower.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentNavigationLower)
        VentShields.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentShields)
        VentWeapons.Button.InteractedWithEvent.SubscribeAgent(OnVentButtonClicked, VentWeapons)

        EventManager.Subscribe(event_type.VENT_BUTTON_CLICK, Self)

    OnVentButtonClicked<private>(Agent:agent, VentInteracted:vent_class):void = 
        Logger.Debug("OnVentClicked")
        if: 
            AmongusPlayer := GetAPlayer[Agent]
            SpatialController := Mechanics.SpatialControllers[GetSession()]
            Position := SpatialController.GetPlayerPosition[AmongusPlayer.Player]
            Rotation := SpatialController.GetPlayerRotation[AmongusPlayer.Player]
            Texture := AmongusChTextures[AmongusPlayer.GetColor()]
        then:
            if(View := PlayerWidgets[Agent]?):
                if(not View.IsVisible[]):
                    Hide(Agent)
            MaybeWidget := MakeWidgetUi(VentInteracted, AmongusPlayer.Player, Rotation, Position, Texture)
            if(Widget := MaybeWidget?):
                Widget.Show()
                CloseRequestCancelable := Widget.EventViewCloseRequested.Subscribe(OnCloseRequested, true)
                if(FortCharacter := AmongusPlayer.Player.GetFortCharacter[]):
                    FortCharacter.Hide()
                    EventManager.Notify(event_vent_status{Player:=option{AmongusPlayer.Player}, Status := true})
                if:
                    set PlayerWidgets[Agent] = MaybeWidget
                    set PlayerCloseRequestCancelable[Agent] = option{CloseRequestCancelable}
            else:
                if:
                    set PlayerWidgets[Agent] = false

    OnCloseRequested<private>(View:Ui.ui_view_verse):void = 
        Hide(View.Player)

    Hide<public>(Agent:agent):void = 
        if(View := PlayerWidgets[Agent]?):
            View.Destroy()
            if(set PlayerWidgets[Agent] = false){}
        if(Canc := PlayerCloseRequestCancelable[Agent]?):
            Canc.Cancel()
            if(set PlayerCloseRequestCancelable[Agent] = false){}

        if(FortCharacter := Agent.GetFortCharacter[], Player := player[Agent]):
            if(APlayer := GetAPlayer[Agent], APlayer.IsGhost?):
            else:
                FortCharacter.Show()
            EventManager.Notify(event_vent_status{Player:=option{Player}, Status := false})


    # HandleUi<private>(AmongusPlayer:ModuleAmongusPlayspace.amongus_player, Widget:widget_vents)<suspends>:void = 
    #     AmongusPlayer.PlayerUi.AddWidget(Widget)
    #     AmongusPlayer.PlayerUi.ShowWidget(Ui.ui_screen_type.VENTS_WIDGET)
    #     AmongusPlayer.PlayerUi.HideWidget(Ui.ui_screen_type.PLAYER_MAP)
    #     # AmongusPlayer.PlayerUi.HideWidget(Ui.ui_screen_type.KILL_BUTTON)
    #     AmongusPlayer.PlayerUi.HideWidget(Ui.ui_screen_type.TASKBAR)
    #     if(FortCharacter := AmongusPlayer.Player.GetFortCharacter[]):
    #         FortCharacter.Hide()
    #     Widget.EventScreenDestroied.Await()
    #     if(FortCharacter := AmongusPlayer.Player.GetFortCharacter[]):
    #         FortCharacter.Show()
    #     AmongusPlayer.PlayerUi.ShowWidget(Ui.ui_screen_type.TASKBAR)
    #     AmongusPlayer.PlayerUi.ShowWidget(Ui.ui_screen_type.PLAYER_MAP)

        



    MakeWidgetUi<private>(VentInteracted:vent_class, Player:player, Rotation:rotation, Position:vector3, Texture:texture):?widget_vents =
        var Output:?widget_vents = false 
        if(VentInteracted.VentId = vent_id.REACTOR_UPPER or VentInteracted.VentId = vent_id.UPPER_ENGINE):
            Widget := Make_widget_vents_reactor_upper(Player, EventManager, Rotation, Position, Texture, VentInteracted, VentReactorUpper, VentUpperEngine)
            set Output = option. Widget
        else if(VentInteracted.VentId = vent_id.REACTOR_LOWER or VentInteracted.VentId = vent_id.LOWER_ENGINE):
            Widget := Make_widget_vents_reactor_lower(Player, EventManager, Rotation, Position, Texture, VentInteracted, VentReactorLower, VentLowerEngine)
            set Output = option. Widget
        else if(VentInteracted.VentId = vent_id.CAFETERIA or VentInteracted.VentId = vent_id.ADMIN or VentInteracted.VentId = vent_id.HALLWAY_NAVIGATION):
            Widget := Make_widget_vents_cafeteria(Player, EventManager, Rotation, Position, Texture, VentInteracted, VentCafeteria, VentHallwayNavigation, VentAdmin)
            set Output = option. Widget
        else if(VentInteracted.VentId = vent_id.SECURITY or VentInteracted.VentId = vent_id.MEDBAY or VentInteracted.VentId = vent_id.ELECTRICAL):
            Widget := Make_widget_vents_security(Player, EventManager, Rotation, Position, Texture, VentInteracted, VentSecurity, VentElectrical, VentMedbay)
            set Output = option. Widget
        else if(VentInteracted.VentId = vent_id.SHIELDS or VentInteracted.VentId = vent_id.NAVIGATION_LOWER):
            Widget := Make_widget_vents_navigation_lower(Player, EventManager, Rotation, Position, Texture, VentInteracted, VentNavigationLower, VentShields)
            set Output = option. Widget
        else if(VentInteracted.VentId = vent_id.WEAPONS or VentInteracted.VentId = vent_id.NAVIGATION_UPPER):
            Widget := Make_widget_vents_navigation_upper(Player, EventManager, Rotation, Position, Texture, VentInteracted, VentNavigationUpper, VentWeapons)
            set Output = option. Widget
        Output