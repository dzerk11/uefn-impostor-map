
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/UI }

interactive_player_map_device<public> := class(creative_device, event_listener):

    @editable SpatialController:Mechanics.spatial_controller = Mechanics.spatial_controller{}
    @editable TaskManager:ModuleTasks.task_manager = ModuleTasks.task_manager{}
    @editable SabotageManager:ModuleTasks.sabotage_manager = ModuleTasks.sabotage_manager{}
    @editable EventManager:event_manager = event_manager{}
    @editable Input_InteractivePlayerMap<private>:input_trigger_device = input_trigger_device{}

    var PlayerWidgets<private>:[player]?view_interactive_player_map = map{}
    var PlayerCloseRequestCancelable<private>:[player]?custom_cancelable = map{}

    OnBegin<override>()<suspends>:void = 
        Input_InteractivePlayerMap.PressedEvent.Subscribe(OnTriggerPressed)
        Disable()
        
    Update<override>(EventPayload:event_payload):void = 
        case(EventPayload.EventType):

            event_type.EMERGENCY_MEETING_STATUS => 
                if(Payload := event_emergency_meeting_status[EventPayload]):
                    if(Payload.Status?):
                        Disable()
                    else:
                        Enable()

            # event_type.SWITCH_GAME_PHASE => 
            #     Print("here")
            #     if(Payload := event_switch_to_game_phase[EventPayload]):
            #         if(Payload.Gamephase = Gameplay.gamephase.GameRound):
            #             Enable()
            #         else:
            #             Disable()
            _ =>

    Show<public>(Player:player):void =
        if(View := PlayerWidgets[Player]?):
            if(not View.IsVisible[]):
                Hide(Player)

        if(APlayer := GetAPlayer[Player]):
            View := Make_view_interactive_player_map(APlayer, SpatialController, TaskManager, EventManager, SabotageManager)
            CloseRequestCancelable := View.EventViewCloseRequested.Subscribe(OnCloseRequested, true)

            if(set PlayerWidgets[Player] = option{View}, set PlayerCloseRequestCancelable[Player] = option{CloseRequestCancelable}):
                Input_InteractivePlayerMap.Unregister(Player)
                View.Show()
                EventManager.Notify(event_interactive_player_map_visibility_change{Status:=true, Player:=option{Player}})

                # DefaultHudElements<private>(Player:player):void =
        # Logger.Print("DefaultHudElements")
                Playspace := Self.GetPlayspace()
                HudController := Playspace.GetHUDController()
                ElementsToHide:[]hud_element_identifier = array:
                    creative_hud_identifier_all{}
                    creative_hud_identifier_build_menu{}
                    creative_hud_identifier_crafting_resources{}
                    creative_hud_identifier_elimination_counter{}
                    creative_hud_identifier_equipped_item{}
                    creative_hud_identifier_experience_level{}
                    creative_hud_identifier_experience_supercharged{}
                    creative_hud_identifier_experience_ui{}
                    creative_hud_identifier_health{}
                    creative_hud_identifier_health_numbers{}
                    creative_hud_identifier_hud_info{}
                    # creative_hud_identifier_interaction_prompts{}
                    creative_hud_identifier_map_prompts{}
                    creative_hud_identifier_mimimap{}
                    creative_hud_identifier_minimap{}
                    creative_hud_identifier_pickup_stream{}
                    creative_hud_identifier_player_count{}
                    # creative_hud_identifier_player_inventory{}
                    creative_hud_identifier_round_info{}
                    creative_hud_identifier_round_timer{}
                    creative_hud_identifier_shield_numbers{}
                    creative_hud_identifier_shileds{}
                    creative_hud_identifier_shields{}
                    creative_hud_identifier_storm_notifications{}
                    creative_hud_identifier_storm_timer{}
                    creative_hud_identifier_team_info{}
                    player_hud_identifier_all{}
                    # hud_identifier_world_resource_wood{}
                    # hud_identifier_world_resource_stone{}
                    # hud_identifier_world_resource_metal{}
                    # hud_identifier_world_resource_permanite{}
                    # hud_identifier_world_resource_gold_currency{}
                    # hud_identifier_world_resource_ingredient{}
            
        # HudController.ResetElementsForPlayer(Player, ElementsToHide)
                # HudController.HideElementsForPlayer(Player,ElementsToHide)

        # HudController.HideElements(array{creative_hud_identifier_all{}})
        # HudController.ShowElements(array{ 
        #     creative_hud_identifier_mimimap{},
        #     creative_hud_identifier_minimap{},
        #     creative_hud_identifier_player_inventory{},
        #     creative_hud_identifier_interaction_prompts{}
        # })
        # HudController.ResetElementsForPlayer(Player, array{creative_hud_identifier_all{}})
        # HudController.ShowElementsForPlayer(Player, array{creative_hud_identifier_all{}})
        # HudController.HideElementsForPlayer(Player, array{creative_hud_identifier_mimimap{}})
        # HudController.ShowElementsForPlayer(Player, array{creative_hud_identifier_mimimap{}})

    Hide<public>(Player:player):void =
        if(View := PlayerWidgets[Player]?):
            Input_InteractivePlayerMap.Register(Player)
            View.Destroy()
            EventManager.Notify(event_interactive_player_map_visibility_change{Status:=false, Player:=option{Player}})
            if(set PlayerWidgets[Player] = false){}
        if(Canc := PlayerCloseRequestCancelable[Player]?):
            Canc.Cancel()
            if(set PlayerCloseRequestCancelable[Player] = false){}

    Disable<public>():void = 
        Input_InteractivePlayerMap.Disable()
        for(Player->Widget:PlayerWidgets):
            Hide(Player)

        set PlayerWidgets = map{}

        EventManager.UnSubscribe(Self)

    Enable<public>():void =
        Input_InteractivePlayerMap.Enable()
        for(APlayer:GetAPlayers()):
            Input_InteractivePlayerMap.Register(APlayer.Player)
        EventManager.Subscribe(event_type.EMERGENCY_MEETING_STATUS, Self)
        EventManager.Subscribe(event_type.SWITCH_GAME_PHASE, Self)
        
    OnTriggerPressed<private>(Agent:agent):void = 
        if(Player := player[Agent]):
            Show(Player)

    OnCloseRequested<private>(View:Ui.ui_view_verse):void =
        Hide(View.Player)