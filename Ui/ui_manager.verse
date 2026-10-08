
# using { /Fortnite.com/UI }
# using { /Fortnite.com/Devices }
# using { /Verse.org/Simulation }
# using { /UnrealEngine.com/Temporary/Diagnostics }

# using { ModuleAmongusPlayspace }
# using { Widgets }
# using { InteractivePlayerMap }


# log_ui_manager := class(log_channel){}


# ui_manager<public> := class(creative_device, event_listener):

#     @editable EventManager<private>:event_manager = event_manager{}
#     @editable AmongusPlayspace<private>:amongus_playspace = amongus_playspace{}
#     @editable TaskBar<private>:tasks_bar = tasks_bar{}
#     @editable TaskManager<private>:ModuleTasks.task_manager = ModuleTasks.task_manager{}
#     @editable KillButton<private>:Mechanics.kill_button_logic = Mechanics.kill_button_logic{}
#     @editable SpatialController<private>:Mechanics.spatial_controller = Mechanics.spatial_controller{}
#     # var InteractiveMap<private>:[player]view_interactive_player_map = map{}

#     var PlayerViews<private>:[agent][view_name]ui_view_interface = map{}

    

#     # Show stage completed
#     @editable HMD_StageCompleted<private>:hud_message_device = hud_message_device{}

#     # Show stage not assigned
#     @editable HMD_StageNotAssigned<private>:hud_message_device = hud_message_device{}

#     # Show stage not completable now
#     @editable HMD_StageNotCompletableNow<private>:hud_message_device = hud_message_device{}

#     # Show stage already completed
#     @editable HMD_StageAlreadyCompleted<private>:hud_message_device = hud_message_device{}

#     # You're an Impostor
#     @editable UiImpostorBanner<private>:hud_message_device = hud_message_device{}

#     # You're a crewmate
#     @editable UiCrewmateBanner<private>:hud_message_device = hud_message_device{}

#     @editable CS_RoundTaskView<private>:class_and_team_selector_device = class_and_team_selector_device{}
#     @editable CS_RoundView<private>:class_and_team_selector_device = class_and_team_selector_device{}

#     # Sabotage
#     @editable CSQ_SabotageBar<private>:cinematic_sequence_device = cinematic_sequence_device{}
#     @editable CSQ_SabotageRedScreen<private>:cinematic_sequence_device = cinematic_sequence_device{}
#     @editable HMD_SabotageBar<private>:hud_message_device = hud_message_device{}

#     @editable Input_InteractivePlayerMap<private>:input_trigger_device = input_trigger_device{}

    
#     Logger<private>:log = log{Channel:=log_ui_manager, DefaultLevel:=log_level.Debug}

#     OnBegin<override>()<suspends>:void = 
#         # EventManager.EmergencyMeetingStarted.Subscribe(_OnEmergencyMeetingStarted, false)
#         EventManager.Subscribe(event_type.TASK_STARTED, Self)
#         EventManager.Subscribe(event_type.TASK_ADVANCED, Self)
#         EventManager.Subscribe(event_type.STAGE_ENDED, Self)
#         EventManager.Subscribe(event_type.RAISE_PLAYER_MESSAGE, Self)
#         EventManager.Subscribe(event_type.SWITCH_GAME_PHASE, Self)
#         EventManager.Subscribe(event_type.SABOTAGE_STATUS_CHANGED, Self)
#         Input_InteractivePlayerMap.PressedEvent.Subscribe(ShowInteractivePlayerMap)

#     Update<override>(EventPayload:event_payload):void = 
#         case(EventPayload.EventType):

#             event_type.SWITCH_GAME_PHASE => 
#                 if(Payload := event_switch_to_game_phase[EventPayload]):
#                     if(Payload.Gamephase = Gameplay.gamephase.GameRound):
#                         TaskBar.HMD_TaskBar.Show()

#             event_type.TASK_ADVANCED => 
#                 if(Payload := event_task_advanced[EventPayload]):
#                     HMD_StageCompleted.Show(Payload.PlayerWhoAdvanced)
#                     if(Payload.IsTaskCompleted?):
#                         for(Player:Payload.PlayersWhoGotAdvanced):
#                             spawn{RemoveTaskWidget(Player, 0.0)}
#                             if(Player<>Payload.PlayerWhoAdvanced):
#                                 # Task completed by another player
#                     else:

#             event_type.STAGE_ENDED =>
#                 if(Payload := event_stage_ended[EventPayload], Player := Payload.Player?):
#                     spawn{RemoveTaskWidget(Player, 0.0)}
                
#             event_type.RAISE_PLAYER_MESSAGE =>
#                 if(Payload := event_raise_player_message[EventPayload]):
#                     for(Player:Payload.TargetPlayers):
#                         case(Payload.MessageType):
#                             ui_player_message.TASK_NOT_ASSIGNED => HMD_StageNotAssigned.Show(Player)
#                             ui_player_message.STAGE_NOT_COMPLETABLE_YET => HMD_StageNotCompletableNow.Show(Player)
#                             ui_player_message.STAGE_ALREADY_DONE => HMD_StageAlreadyCompleted.Show(Player)
#                             ui_player_message.STAGE_IN_USE_BY_ANOTHER_PLAYER => ""
#                             ui_player_message.STAGE_ALREADY_COMPLETED => ""
#                             # _ =>

#             event_type.TASK_STARTED =>
#                 if(Payload := event_task_started[EventPayload], Player := Payload.Player?):
#                     if(StageWidget := Payload.MaybeWidget?):
#                         ShowTaskWidget(Player, StageWidget)

#             event_type.SABOTAGE_STATUS_CHANGED =>
#                 if(Payload := event_sabotage_status[EventPayload]):
#                     if(Payload.SabotageStatus?):
#                         if(Instigator:=Payload.Instigator?):
#                             HideInteractivePlayerMap(Instigator)
                        
#                         HMD_SabotageBar.Show()
#                         SabotageTitle:string = ToUpperCase(ModuleTasks.ToString(Payload.SabotageName))
#                         HMD_SabotageBar.SetText(StringToMsg(SabotageTitle))

#                         if(SabotageData := TaskManager.GetSabotageData[]):
#                             if(SabotageData.TimeLeft>0.0):
#                                 if(SabotageData.SabotageType = ModuleTasks.sabotage_type.Critical):
#                                     CSQ_SabotageRedScreen.Play()
#                     else:
#                         HMD_SabotageBar.Hide()
#                         CSQ_SabotageRedScreen.Stop()
                        

                    
#             _ => 



#     # GetView<public>(Agent:agent, ViewName:view_name):?ui_view_interface =
#     #     if(OldView := PlayerViews[Agent][ViewName]):
#     #         return option{OldView}
#     #     else:
#     #         case(ViewName):
#     #             Ui.InteractivePlayerMap.Make_view_interactive_player_map(APlayer, SpatialController, TaskManager)
#     #             _ => 

        

#     Show<public>(Agent:agent, ViewName:view_name):void = 
#         if(APlayer := AmongusPlayspace.GetPlayer[Agent]):
#             case(ViewName):
#                 view_name.PLAYER_MAP_INTERACTIVE => 
#                     Map := Ui.InteractivePlayerMap.Make_view_interactive_player_map(APlayer, SpatialController, TaskManager)
#                     Map.Show()
#                     if(set PlayerViews[APlayer.Player][view_name.PLAYER_MAP_INTERACTIVE] = Map){}
#                     else:
#                         Map.Destroy()

#                 _ =>

#     Hide<public>(Agent:agent, ViewName:view_name):void = 
#         if(APlayer := GetAPlayer[Agent]):
#             case(ViewName):
#                 view_name.PLAYER_MAP_INTERACTIVE => 
#                     if(Map := PlayerViews[Agent][ViewName]):
#                         Map.Destroy()
#                         if(APlayer.RoleComponent.IsRole[gameplay_role.Impostor]):
#                             KillButton.HidePlayerIcon(APlayer.Player)

#                 view_name.EMERGENCY_MEETING_VOTING_TABLET =>
#                     if(Tablet := PlayerViews[Agent][ViewName]):
#                         Tablet.Destroy()

                
                        

#                 _ =>



# #     # Interactive Player Map
# #     ShowInteractivePlayerMap<public>(Agent:agent):void = 
# #         if:
# #             Player := player[Agent]
# #             not InteractiveMap[Player].IsVisible[]
# #             APlayer := _AmongusPlayspace.GetPlayer[Player]
# #             Position := _SpatialController.GetPlayerPosition[Player]
# #             Rotation := _SpatialController.GetPlayerRotation[Player]
# #         then:
# #             Role := APlayer.RoleComponent.Role
# #             PlayerTasks := _TaskManager.GetPlayerTasksInfo(Player) 
# #             SabotageRunning:?tuple(ModuleTasks.task_name, int) = option{_TaskManager.GetRunningSabotage[]}
# #             Map := Ui.InteractivePlayerMap.Make_view_interactive_player_map(APlayer, Rotation, Position, PlayerTasks, SabotageRunning)
# #             if:
# #                 # set PlayerViews[Player][ui_screen_type.PLAYER_MAP_INTERACTIVE] = Map
# #                 set InteractiveMap[Player] = Map
# #             then:
# #                 Map.Show()
# #                 Map.EventViewDestroyRequested.Subscribe(OnViewDestroyRequest, true)
# #                 # APlayer.PlayerUi.ShowWidget(Ui.ui_screen_type.PLAYER_MAP_INTERACTIVE)
# #                 # APlayer.PlayerUi.HideWidget(Ui.ui_screen_type.PLAYER_MAP)
# #                 # APlayer.PlayerUi.HideWidget(Ui.ui_screen_type.TASKBAR)
# #                 _KillButton.HidePlayerIcon(Player)
                
# #             # race:
# #             #     Map.EventViewDestroyed.Await()

# #             #     Map.ExitButton.OnClick().Await()

# #             # HideInteractivePlayerMap(Player)

# #     OnViewDestroyRequest(Vieww:ui_view_interface):void = 
# #         Vieww.Destroy()


# #     HideInteractivePlayerMap<public>(Player:player):void =
# #         if(APlayer := _AmongusPlayspace.GetPlayer[Player]):
# #             APlayer.PlayerUi.RemoveWidget(Ui.ui_screen_type.PLAYER_MAP_INTERACTIVE)
# #             APlayer.PlayerUi.ShowWidget(Ui.ui_screen_type.PLAYER_MAP)
# #             APlayer.PlayerUi.ShowWidget(Ui.ui_screen_type.TASKBAR)
# #             _KillButton.ShowPlayerIcon(Player)

# #     # _HandleInteractivePlayerMap<private>(Player:player)<suspends>:void = 
# #     #     if: 
# #     #         APlayer := _AmongusPlayspace.GetPlayer[Player]
# #     #         Position := _SpatialController.GetPlayerPosition[Player]
# #     #         Rotation := _SpatialController.GetPlayerRotation[Player]
# #     #     then:
# #     #         Role := APlayer.RoleComponent.Role
# #     #         PlayerTasks := _TaskManager.GetPlayerTasksInfo(Player) 
# #     #         SabotageRunning:?tuple(ModuleTasks.task_name, int) = option{_TaskManager.GetRunningSabotage[]}
# #     #         Map := Ui.InteractivePlayerMap.Make_view_interactive_player_map(APlayer, Rotation, Position, PlayerTasks, SabotageRunning)
# #     #         Map.Show()
# #     #         # APlayer.PlayerUi.AddWidget(Map)
# #     #         APlayer.PlayerUi.ShowWidget(Ui.ui_screen_type.PLAYER_MAP_INTERACTIVE)
# #     #         APlayer.PlayerUi.HideWidget(Ui.ui_screen_type.PLAYER_MAP)
# #     #         APlayer.PlayerUi.HideWidget(Ui.ui_screen_type.TASKBAR)
# #     #         _KillButton.HidePlayerIcon(Player)
            
# #     #         race:
# #     #             Map.EventViewDestroyed.Await()

# #     #             Map.ExitButton.OnClick().Await()

# #     #         HideInteractivePlayerMap(Player)
                

# #     # Task widgets

# #     ShowTaskWidget<public>(Player:player, StageWidget:Widgets.StageWidgets.stage_widget):void = 
# #         if(AmongusPlayer := _AmongusPlayspace.GetPlayer[Player]):
# #             # Hide hud elements
# #             _KillButton.HidePlayerIcon(Player)
# #             AmongusPlayer.PlayerUi.HideWidget(Ui.ui_screen_type.KILLBUTTON)
# #             AmongusPlayer.PlayerUi.HideWidget(Ui.ui_screen_type.PLAYER_MAP)
# #             CS_RoundTaskView.ChangeClass(Player)

# #             # Show stage widget
# #             AmongusPlayer.PlayerUi.AddWidget(StageWidget)
# #             AmongusPlayer.PlayerUi.ShowWidget(ui_screen_type.TASK_WIDGET)

# #     RemoveTaskWidget<private>(Player:player, DelaySeconds:float)<suspends>:void =
# #         if(AmongusPlayer := _AmongusPlayspace.GetPlayer[Player]):
# #             # Wait for the specified delay
# #             Sleep(DelaySeconds)
            
# #             # Clean up only if player is still active (might have disconnected)
# #             if(AmongusPlayer.Player.IsActive[]):
                
# #                 # Clean up task UI
# #                 AmongusPlayer.PlayerUi.RemoveWidget(ui_screen_type.TASK_WIDGET)
                
# #                 # Reset UI to normal game state
# #                 AmongusPlayer.PlayerUi.SetScene(Ui.ui_screen_scene.ROUND)
# #                 CS_RoundView.ChangeClass(Player)



