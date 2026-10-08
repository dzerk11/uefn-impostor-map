
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }

using { ModuleTasks }
using { Modules.PlayerMap }
using { Ui }

MsgEmpty<localizes>: message = ""
MsgExit<localizes>: message = "EXIT"
MsgShowSabotages<localizes>: message = "SABOTAGES"
MsgShowFakeTasks<localizes>: message = "FAKE TASKS"

MsgSabotageTimeLeft<internal><localizes>(Time:int):message = "{Time}s"
MsgSabotageFix<internal><localizes>:message = "Fix the Sabotage"
MsgSabotageFixIn<internal><localizes>(Time:int):message = "Fix the Sabotage in {Time}s"
MsgSabotageActivated<internal><localizes>:message = "Sabotage Activated!"
MsgSabotageActivatedWithTime<internal><localizes>(Time:int):message = "Sabotage Activated: {Time}s!"

MsgSabotageButton<internal><localizes>:message = "Click"



RSlice<public>:float = 22.5

Make_view_interactive_player_map<public><constructor>(APlayer:amongus_player, SpatialController:Mechanics.spatial_controller, TaskManager:task_manager, EventManager:event_manager, SabotageManager:sabotage_manager) := view_interactive_player_map:
    APlayer := APlayer
    Player := APlayer.Player
    SpatialController := SpatialController
    TaskManager := TaskManager
    SabotageManager := SabotageManager
    EventManager := EventManager


view_interactive_player_map<public> := class(Ui.ui_view_verse, event_listener):
    InputMode<override>:ui_input_mode = ui_input_mode.All
    APlayer<public>:amongus_player
    ZOrder<override>:type {_X:int where 0 <= _X, _X <= 2147483647} = 10

    SpatialController<public>:Mechanics.spatial_controller
    TaskManager<public>:task_manager
    SabotageManager<public>:sabotage_manager
    EventManager<public>:event_manager

    var CurrentPage<private>:string = ""

    # Player pointer
    WidgetPlayerPointer<private>:widget_player_pointer = widget_player_pointer:
        DefaultDesiredSize := vector2{X := 48.0, Y := 48.0}

    var CanvasTaskIcons<private>:canvas = canvas{}
    var CanvasSabotageIcons<private>:canvas = canvas{}

    var SabotageElementList<private>:[task_name]ui_widget_interactive_player_map_list_element = map{}
        
    WidgetNoSignal<private>:widget = wbp_map_noise2{}

    NavBtn_Info<private>:button_quiet = button_quiet{}
    NavBtn_Map<private>:button_quiet = button_quiet{}
    NavBtn_Sabotages<private>:button_quiet = button_quiet{}
    NavBtn_Close<private>:button_quiet = button_quiet{}

    var MapPanel:canvas = canvas{}
    var SabotagePanel:canvas = canvas{}
    var InfoPanel:canvas = canvas{}

    # Sabotage buttons
    ButtonOxygenDepletion<private>:button_quiet = button_quiet:
        DefaultText := MsgSabotageButton
    ButtonReactorFail<private>:button_quiet = button_quiet:
        DefaultText := MsgSabotageButton
    ButtonNoComms<private>:button_quiet = button_quiet:
        DefaultText := MsgSabotageButton
    ButtonLockDoors<private>:button_quiet = button_quiet:
        DefaultText := MsgSabotageButton
    ButtonLightsOff<private>:button_quiet = button_quiet:
        DefaultText := MsgSabotageButton

    # Sabotage widget reference
    var MaybeWidgetSabotageMenu<private>:?new.WBP_Menu_Sabotage = false

    OnDestroy<override>():void = {}

    OnInit<override>():void =
        WidgetPlayerPointer.Init()

        Subscriptions.Add(NavBtn_Sabotages.OnClick().SubscribeWidgetMessage(OnNavigation, "Sabotages"))
        Subscriptions.Add(NavBtn_Map.OnClick().SubscribeWidgetMessage(OnNavigation, "Map"))
        Subscriptions.Add(NavBtn_Info.OnClick().SubscribeWidgetMessage(OnNavigation, "Info"))
        Subscriptions.Add(NavBtn_Close.OnClick().SubscribeWidgetMessage(OnNavigation, "Close"))
        EventManager.Subscribe(event_type.PLAYER_POSITION, Self, Player)
        EventManager.Subscribe(event_type.PLAYER_ROTATION, Self, Player)
        EventManager.Subscribe(event_type.PLAYER_TASK_LIST, Self, Player)
        EventManager.Subscribe(event_type.SABOTAGE_STATUS_CHANGED, Self)
        EventManager.Subscribe(event_type.SABOTAGE_COOLDOWN_REMAINING_TIME, Self)

        set Widget = canvas:
            Slots := array:

                # Shadow
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    ZOrder := 0
                    Widget := new.WBP_Menu_Bg{}

                # Main content
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    # Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    # Offsets := margin{Top := 0.0, Left := 0.0, Right := 1920.0, Bottom := 940.0}
                    # Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := canvas:
                        Slots := array:

                            # Info panel
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X:=0.0, Y:=0.0}, Maximum := vector2{X:=1.0, Y:=1.0}}
                                SizeToContent := false
                                ZOrder := 3
                                Widget := MakeInfoPanel()
                                                
                            # Map panel
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X:=0.0, Y:=0.0}, Maximum := vector2{X:=1.0, Y:=1.0}}
                                SizeToContent := false
                                ZOrder := 3
                                Widget := MakeMapPanel()

                            # Sabotage panel
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X:=0.0, Y:=0.0}, Maximum := vector2{X:=1.0, Y:=1.0}}
                                SizeToContent := false
                                ZOrder := 3
                                Widget := MakeSabotagePanel()

                            # Navigation buttons
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                Offsets := margin{Left:= -754.0, Top := 0.0, Right := 112.0, Bottom := 804.0}
                                Alignment := vector2{X:=0.5, Y:=0.5}
                                SizeToContent := false
                                ZOrder := 4
                                Widget := stack_box:
                                    Orientation := orientation.Vertical
                                    Slots := array:

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            VerticalAlignment := vertical_alignment.Top
                                            Padding := margin{Bottom:=16.0}
                                            Widget := canvas:
                                                Slots := array:
                                                    canvas_slot:
                                                        Offsets := margin{Right := 100.0, Bottom := 100.0}
                                                        SizeToContent := false
                                                        Widget := NavBtn_Info

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            VerticalAlignment := vertical_alignment.Top
                                            Padding := margin{Bottom:=16.0}
                                            Widget := canvas:
                                                Slots := array:
                                                    canvas_slot:
                                                        Offsets := margin{Right := 100.0, Bottom := 100.0}
                                                        SizeToContent := false
                                                        Widget := NavBtn_Map
                                            
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            VerticalAlignment := vertical_alignment.Top
                                            Padding := margin{Bottom:=16.0}
                                            Widget := canvas:
                                                Slots := array:
                                                    canvas_slot:
                                                        Offsets := margin{Right := 100.0, Bottom := 100.0}
                                                        SizeToContent := false
                                                        Widget := NavBtn_Sabotages

                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            VerticalAlignment := vertical_alignment.Bottom
                                            Padding := margin{Top:=16.0}
                                            Distribution := option{1.0}
                                            Widget := canvas:
                                                Slots := array:
                                                    canvas_slot:
                                                        Offsets := margin{Right := 100.0, Bottom := 100.0}
                                                        SizeToContent := false
                                                        Widget := NavBtn_Close

                            # Navigation divider
                            # canvas_slot:
                            #     Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                            #     Offsets := margin{Left := -155.85083, Top := 0.0, Right := 4.0, Bottom := 800.0}
                            #     Alignment := vector2{X := 0.5, Y := 0.5}
                            #     SizeToContent := false
                            #     ZOrder := 4
                            #     Widget := button_quiet{}     

        if(Rotation := SpatialController.GetPlayerRotation[Player]):
            WidgetPlayerPointer.UpdateRotation(Rotation)
        if(Position := SpatialController.GetPlayerPosition[Player]):
            WidgetPlayerPointer.UpdatePosition(Position)

        UpdateCanvasTaskIcons(TaskManager.GetPlayerTasksInfo(Player))
        UpdateSabotageRunning()

        if(APlayer.IsImpostor[]):
            InitialCooldown := SabotageManager.GetGlobalCooldownTimeRemaining()
            if(InitialCooldown > 0.0, SabotageWidget := MaybeWidgetSabotageMenu?):
                set SabotageWidget.TimeSabotagesAvailableIn = InitialCooldown
                set SabotageWidget.IsTimeSabotagesAvailableInVisible = true
            UpdateSabotageButtons()
            ShowPage("Sabotages")
        else:
            ShowPage("Map")

        if(PlayerUI := GetPlayerUI[Player]):
            PlayerUI.SetFocus(NavBtn_Close)

    OnNavigation<private>(WidgetMessage:widget_message, Page:string):void =
        if(Player = WidgetMessage.Player):
            if(Page = "Close"):
                EventViewCloseRequested.Signal(Self)
            else:
                ShowPage(Page)

    ShowPage<private>(Page:string):void = 
        InfoPanel.SetVisibility(widget_visibility.Collapsed)
        MapPanel.SetVisibility(widget_visibility.Collapsed)
        SabotagePanel.SetVisibility(widget_visibility.Collapsed)

        NavBtn_Info.SetVisibility(widget_visibility.Visible)
        NavBtn_Map.SetVisibility(widget_visibility.Visible)
        NavBtn_Sabotages.SetVisibility(widget_visibility.Visible)

        case(Page):
            "Info" =>
                set CurrentPage = "Info"
                Print("show info")
                InfoPanel.SetVisibility(widget_visibility.Visible)
                NavBtn_Info.SetVisibility(widget_visibility.Hidden)
            "Map" =>
                set CurrentPage = "Map"
                Print("show Map")
                MapPanel.SetVisibility(widget_visibility.Visible)
                NavBtn_Map.SetVisibility(widget_visibility.Hidden)
            "Sabotages" =>
                set CurrentPage = "Sabotages"
                Print("show sabotages")
                SabotagePanel.SetVisibility(widget_visibility.Visible)
                NavBtn_Sabotages.SetVisibility(widget_visibility.Hidden)
            _ => 

    MakeInfoPanel():widget = 
        set InfoPanel = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    ZOrder := 0
                    Widget := new.WBP_Menu_Info{IsImpostor := logic{APlayer.IsImpostor[]}}

    MakeMapPanel():widget = 
        set MapPanel = canvas:
            Slots := array:
                # Map bg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    ZOrder := 0
                    Widget := new.WBP_Menu_Map{IsImpostor := logic{APlayer.IsImpostor[], SabToastVisibility := false}}

                # Tasks icons
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 20.0, Left := 70.0, Right := 1262.922974, Bottom := 623.494934}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := CanvasTaskIcons

                # Sabotage icons
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 70.0, Right := 1262.922974, Bottom := 623.494934}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 2
                    Widget := CanvasSabotageIcons

                # Player pointer
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 70.0, Right := 1262.922974, Bottom := 623.494934}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 3
                    Widget := WidgetPlayerPointer.Canvas

    MakeSabotagePanel():widget =
        Subscriptions.Add(ButtonOxygenDepletion.OnClick().SubscribeWidgetMessage(OnSabotageButtonClick, task_name.SabotageO2))
        Subscriptions.Add(ButtonReactorFail.OnClick().SubscribeWidgetMessage(OnSabotageButtonClick, task_name.SabotageReactorFail))
        Subscriptions.Add(ButtonNoComms.OnClick().SubscribeWidgetMessage(OnSabotageButtonClick, task_name.SabotageComms))
        Subscriptions.Add(ButtonLockDoors.OnClick().SubscribeWidgetMessage(OnSabotageButtonClick, task_name.SabotageLockDoors))
        Subscriptions.Add(ButtonLightsOff.OnClick().SubscribeWidgetMessage(OnSabotageButtonClick, task_name.SabotageElectrical))

        # Create and store reference to sabotage menu widget
        WidgetSabotageMenu := new.WBP_Menu_Sabotage{}
        set MaybeWidgetSabotageMenu = option{WidgetSabotageMenu}

        set SabotagePanel = canvas:
            Slots := array:
                # Bg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    ZOrder := 0
                    Widget := WidgetSabotageMenu

                # Sabotage buttons
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Right := 1700.0, Bottom := 900.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    # SizeToContent := true
                    ZOrder := 1
                    Widget := canvas:
                        Slots := array:
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                                Offsets := margin{Top := 64.0, Left := 200.0}
                                Alignment := vector2{X := 0.0, Y := 0.5}
                                SizeToContent := true
                                Widget := stack_box:
                                    Orientation := orientation.Horizontal
                                    Slots := array:
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Padding := margin{Right := 8.0}
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := texture_block:
                                                            DefaultImage := Art.Textures.T_Transparent
                                                            DefaultDesiredSize := vector2{X:=276.0, Y:=450.0}
                                                    overlay_slot:
                                                        Padding := margin{Top := 0.0, Left := 48.0, Right := 48.0, Bottom := 48.0}
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Bottom
                                                        Widget := ButtonLockDoors
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Padding := margin{Left := 8.0, Right := 8.0}
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := texture_block:
                                                            DefaultImage := Art.Textures.T_Transparent
                                                            DefaultDesiredSize := vector2{X:=276.0, Y:=450.0}
                                                    overlay_slot:
                                                        Padding := margin{Top := 0.0, Left := 48.0, Right := 48.0, Bottom := 48.0}
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Bottom
                                                        Widget := ButtonLightsOff
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Padding := margin{Left := 8.0, Right := 8.0}
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := texture_block:
                                                            DefaultImage := Art.Textures.T_Transparent
                                                            DefaultDesiredSize := vector2{X:=276.0, Y:=450.0}
                                                    overlay_slot:
                                                        Padding := margin{Top := 0.0, Left := 48.0, Right := 48.0, Bottom := 48.0}
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Bottom
                                                        Widget := ButtonNoComms
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Padding := margin{Left := 8.0, Right := 8.0}
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := texture_block:
                                                            DefaultImage := Art.Textures.T_Transparent
                                                            DefaultDesiredSize := vector2{X:=276.0, Y:=450.0}
                                                    overlay_slot:
                                                        Padding := margin{Top := 0.0, Left := 48.0, Right := 48.0, Bottom := 48.0}
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Bottom
                                                        Widget := ButtonOxygenDepletion
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Padding := margin{Left := 8.0}
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := texture_block:
                                                            DefaultImage := Art.Textures.T_Transparent
                                                            DefaultDesiredSize := vector2{X:=276.0, Y:=450.0}
                                                    overlay_slot:
                                                        Padding := margin{Top := 0.0, Left := 48.0, Right := 48.0, Bottom := 48.0}
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Bottom
                                                        Widget := ButtonReactorFail

    Update<override>(EventPayload:event_payload):void = 
        case(EventPayload.EventType):
            event_type.PLAYER_POSITION => 
                if(Payload := event_player_position[EventPayload]):
                    WidgetPlayerPointer.UpdatePosition(Payload.Data)
            event_type.PLAYER_ROTATION => 
                if(Payload := event_player_rotation[EventPayload]):
                    WidgetPlayerPointer.UpdateRotation(Payload.Data)
            event_type.PLAYER_TASK_LIST => 
                if(Payload := event_player_task_list[EventPayload]):
                    UpdateCanvasTaskIcons(Payload.Data)
            event_type.SABOTAGE_COOLDOWN_REMAINING_TIME =>
                if(Payload := event_sabotage_cooldown_remaining_time[EventPayload]):
                    if(SabotageWidget := MaybeWidgetSabotageMenu?):
                        set SabotageWidget.TimeSabotagesAvailableIn = Payload.RemainingTime
                        set SabotageWidget.IsTimeSabotagesAvailableInVisible = true
                        if(Payload.IsJustOver?):
                            set SabotageWidget.IsTimeSabotagesAvailableInVisible = false
                            UpdateSabotageButtons()
            event_type.SABOTAGE_STATUS_CHANGED =>
                UpdateSabotageRunning()
            _ =>

    UpdateSabotageRunning<private>():void =
        Print("Updating sabotage running state")
        if(SabotageRunning := SabotageManager.GetActiveSabotage[]):
            # Check if comms is on
            if(SabotageRunning.Name = task_name.SabotageComms):
                CanvasTaskIcons.SetVisibility(widget_visibility.Collapsed)
                if(MenuMap:=new.WBP_Menu_Map[MapPanel.Slots[0].Widget]):
                    set MenuMap.IsCommsSabotageEnabled = true
            else:
                CanvasTaskIcons.SetVisibility(widget_visibility.Visible)
                if(MenuMap:=new.WBP_Menu_Map[MapPanel.Slots[0].Widget]):
                    set MenuMap.IsCommsSabotageEnabled = false

            # Update sabotage icon on map
            UpdateCanvasSabotageIcon(SabotageRunning)

            # Show toast
            if(MenuMap := new.WBP_Menu_Map[MapPanel.Slots[0].Widget]):
                set MenuMap.SabToastTitle = Ui.GetMsgSabotageName(SabotageRunning.Name)
                set MenuMap.SabToastText = Ui.GetMsgSabotageName(SabotageRunning.Name)
                set MenuMap.SabToastMaterialIcon = Ui.GetMaterialIcon(SabotageRunning.Name)
                set MenuMap.SabToastVisibility = true

            # Update sabotage buttons state
            UpdateSabotageButtons()

        else:
            # No sabotage running - reset everything
            CanvasSabotageIcons.SetVisibility(widget_visibility.Collapsed)

            # Show task icons (in case they were hidden by comms)
            CanvasTaskIcons.SetVisibility(widget_visibility.Visible)

            # Disable comms sabotage state
            if(MenuMap := new.WBP_Menu_Map[MapPanel.Slots[0].Widget]):
                set MenuMap.IsCommsSabotageEnabled = false

            # Hide toast
            if(W := new.WBP_Menu_Map[MapPanel.Slots[0].Widget]):
                set W.SabToastVisibility = false

            # Update sabotage buttons state
            UpdateSabotageButtons()

    # Track previous button states to avoid redundant updates
    var PreviousButtonStates<private>:[task_name]logic = map{}

    # Update sabotage buttons enabled/disabled state based on each sabotage's actual state
    UpdateSabotageButtons<private>():void =
        # Get the state of all sabotages
        SabotagesState := SabotageManager.GetSabotagesState()

        # Check which sabotage is currently active
        MaybeActiveSabotage := option{SabotageManager.GetActiveSabotageName[]}
        IsSabotageRunning := if(MaybeActiveSabotage?){true}else{false}

        if(SabotageWidget := MaybeWidgetSabotageMenu?):

            # Set the IsSabotageRunning flag on the widget
            set SabotageWidget.IsSabotageRunning = IsSabotageRunning

            # Oxygen Depletion
            CanActivateO2 := if(State := SabotagesState[task_name.SabotageO2]){State}else{false}
            IsSabO2Active := if(ActiveSabotage := MaybeActiveSabotage?, ActiveSabotage = task_name.SabotageO2){true}else{false}
            ButtonOxygenDepletion.SetEnabled(CanActivateO2)
            set SabotageWidget.OpacityOxygenDepletion = if(IsSabO2Active?){1.0}else{if(CanActivateO2?){1.0}else{0.5}}
            set SabotageWidget.IsSabOxygenDepletionActive = IsSabO2Active

            # Reactor Fail
            CanActivateReactor := if(State := SabotagesState[task_name.SabotageReactorFail]){State}else{false}
            IsSabReactorActive := if(ActiveSabotage := MaybeActiveSabotage?, ActiveSabotage = task_name.SabotageReactorFail){true}else{false}
            ButtonReactorFail.SetEnabled(CanActivateReactor)
            set SabotageWidget.OpacityReactorFail = if(IsSabReactorActive?){1.0}else{if(CanActivateReactor?){1.0}else{0.5}}
            set SabotageWidget.IsSabReactorFailActive = IsSabReactorActive

            # Only print if state changed
            if(PrevState := PreviousButtonStates[task_name.SabotageReactorFail], PrevState <> CanActivateReactor):
                Print("Sabotage button reactor: {if(CanActivateReactor?){"enabled"}else{"disabled"}}")
                if(set PreviousButtonStates[task_name.SabotageReactorFail] = CanActivateReactor){}

            # Communications
            CanActivateComms := if(State := SabotagesState[task_name.SabotageComms]){State}else{false}
            IsSabCommsActive := if(ActiveSabotage := MaybeActiveSabotage?, ActiveSabotage = task_name.SabotageComms){true}else{false}
            ButtonNoComms.SetEnabled(CanActivateComms)
            set SabotageWidget.OpacityNoComms = if(IsSabCommsActive?){1.0}else{if(CanActivateComms?){1.0}else{0.5}}
            set SabotageWidget.IsSabNoCommsActive = IsSabCommsActive

            # Lock Doors
            CanActivateDoors := if(State := SabotagesState[task_name.SabotageLockDoors]){State}else{false}
            IsSabDoorsActive := if(ActiveSabotage := MaybeActiveSabotage?, ActiveSabotage = task_name.SabotageLockDoors){true}else{false}
            ButtonLockDoors.SetEnabled(CanActivateDoors)
            set SabotageWidget.OpacityLockDoors = if(IsSabDoorsActive?){1.0}else{if(CanActivateDoors?){1.0}else{0.5}}
            set SabotageWidget.IsSabLockDoorsActive = IsSabDoorsActive

            # Lights Off
            CanActivateLights := if(State := SabotagesState[task_name.SabotageElectrical]){State}else{false}
            IsSabLightsActive := if(ActiveSabotage := MaybeActiveSabotage?, ActiveSabotage = task_name.SabotageElectrical){true}else{false}
            ButtonLightsOff.SetEnabled(CanActivateLights)
            set SabotageWidget.OpacityLightsOff = if(IsSabLightsActive?){1.0}else{if(CanActivateLights?){1.0}else{0.5}}
            set SabotageWidget.IsSabLightsOffActive = IsSabLightsActive
    
    UpdateCanvasTaskIcons<private>(TaskInfoList:[]ModuleTasks.task_info):void =
        var StageIconsSlots:[]canvas_slot = array{}

        IconTint := MakeColorFromHex("FFF")
        IsImpostor := logic{APlayer.IsImpostor[]}

        for(Index->TaskInfo:TaskInfoList):
            CompletableStages := TaskInfo.GetCompletableStages()
            for(CompletableStage:CompletableStages):
                RelativeCoordinates := ConvertRealCoordinatesIntoMapRelative(CompletableStage.Coordinates)
                set StageIconsSlots += array: 
                    canvas_slot:
                        Anchors := anchors{Minimum := RelativeCoordinates, Maximum := RelativeCoordinates}
                        Alignment := vector2{X := 0.5, Y := 0.5}
                        Widget := material_block:
                            DefaultImage := GetMaterialIcon(TaskInfo.TaskName)
                            DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}

        WidgetVisibility := CanvasTaskIcons.GetVisibility()

        MapPanel.RemoveWidget(CanvasTaskIcons)

        set CanvasTaskIcons = canvas:
                Slots := StageIconsSlots

        CanvasTaskIcons.SetVisibility(WidgetVisibility)

        CanvasSlot := canvas_slot:
            Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
            Offsets := margin{Top := 0.0, Left := 70.0, Right := 1262.922974, Bottom := 623.494934}
            Alignment := vector2{X := 0.5, Y := 0.5}
            SizeToContent := false
            ZOrder := 1
            Widget := CanvasTaskIcons

        MapPanel.AddWidget(CanvasSlot)


    # Update canvas sabotage icon - displays the active sabotage on the map
    UpdateCanvasSabotageIcon<private>(Sabotage:sabotage_basic):void =
        var StageIconsSlots:[]canvas_slot = array{}

        IconTint := MakeColorFromHex("FFF")
        IsImpostor := logic{APlayer.IsImpostor[]}

        # Get sabotage info
        SabotageInfo := Sabotage.GetSabotageInfo()

        # Create icon for each sabotage stage
        for(StageInfo:SabotageInfo.StagesInfo):
            RelativeCoordinates := ConvertRealCoordinatesIntoMapRelative(StageInfo.Coordinates)
            set StageIconsSlots += array:
                canvas_slot:
                    Anchors := anchors{Minimum := RelativeCoordinates, Maximum := RelativeCoordinates}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget := material_block:
                                    DefaultImage := GetMaterialIcon(Sabotage.Name)
                                    DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}

                            # Glowing ring material
                            # overlay_slot:
                            #     Widget := material_block:
                            #         DefaultImage := m_test_ring
                            #         DefaultDesiredSize := vector2{X:=110.0, Y:=110.0}
                            #         DefaultTint := MakeColorFromHex("#DA533BFF")

                            # # Base red circle
                            # overlay_slot:
                            #     Widget := texture_block:
                            #         DefaultImage := task_icon_base_red
                            #         DefaultDesiredSize := vector2{X:=70.0, Y:=70.0}

                            # # Sabotage icon on top
                            # overlay_slot:
                            #     Widget := texture_block:
                            #         DefaultImage := GetTexture(SabotageInfo.SabotageName)
                            #         DefaultDesiredSize := vector2{X:=46.0, Y:=46.0}
                            #         DefaultTint := IconTint

                                    
        OldVisibility := CanvasSabotageIcons.GetVisibility()
        
        MapPanel.RemoveWidget(CanvasSabotageIcons)

        set CanvasSabotageIcons = canvas:
            Slots := StageIconsSlots

        CanvasSabotageIcons.SetVisibility(OldVisibility)

        CanvasSlot := canvas_slot:
            Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
            Offsets := margin{Top := 0.0, Left := 70.0, Right := 1262.922974, Bottom := 623.494934}
            Alignment := vector2{X := 0.5, Y := 0.5}
            SizeToContent := false
            ZOrder := 2
            Widget := CanvasSabotageIcons

        MapPanel.AddWidget(CanvasSlot)


    OnSabotageButtonClick<private>(WidgetMessage:widget_message, TaskName:ModuleTasks.task_name):void =
        if(WidgetMessage.Player=Player):
            IsActivated := SabotageManager.StartSabotage(Player, TaskName)
            if(IsActivated?):
                EventViewCloseRequested.Signal(Self)


