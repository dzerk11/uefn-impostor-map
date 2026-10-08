
# using { /Fortnite.com/UI }
# using { /Verse.org/Simulation }
# using { /UnrealEngine.com/Temporary/UI}
# using { /Fortnite.com/Devices }
# using { /UnrealEngine.com/Temporary/Diagnostics }

# using { ModuleLanguage }
# using { Widgets }
# using { Widgets.StageWidgets }
# using { /UnrealEngine.com/Temporary/SpatialMath }
# using { /Verse.org/Colors }


# Make_player_ui_controller<public><constructor>(InPlayer:player) := player_ui_controller:
#     _Player := InPlayer

view_name<public>:= enum:
    NONE
    PLAYER_MAP
    PLAYER_MAP_INTERACTIVE
    KILLBUTTON
    TASKBAR
    SECURITY_CAMERA_VIEW
    TASK_WIDGET
    VENTS_WIDGET
    EMERGENCY_MEETING_VOTING_TABLET


# # ui_screen_scene<public>:= enum:
# #     NONE
# #     ROUND
# #     ROUND_TASK
# #     ROUND_EMERGENCY_MEETING
# #     ROUND_INTERACTIVE_PLAYER_MAP
# #     ROUND_SECURITY_CAMERA

# # SceneMap<public>:[ui_screen_scene][]ui_screen_type = map:
# #     ui_screen_scene.NONE => array:
        
# #     ui_screen_scene.ROUND => array:
# #         ui_screen_type.PLAYER_MAP
# #         ui_screen_type.KILLBUTTON
# #         ui_screen_type.TASKBAR

# #     ui_screen_scene.ROUND_SECURITY_CAMERA => array:
# #         ui_screen_type.SECURITY_CAMERA_VIEW

# #     ui_screen_scene.ROUND_TASK => array:
# #         ui_screen_type.PLAYER_MAP
# #         ui_screen_type.TASKBAR
# #         ui_screen_type.TASK_WIDGET

# #     ui_screen_scene.ROUND_EMERGENCY_MEETING => array:
# #         ui_screen_type.EMERGENCY_MEETING_VOTING_TABLET
        



# player_ui_controller<public><final> := class:
#     _Logger<internal>:custom_logger = custom_logger{}
#     _Translator<internal>:translator = translator{}
#     _Player<public>:player

#     # WidgetPlayerMap<public>:ui_widget_player_map
#     # WidgetInteractivePlayerMap<public>:ui_widget_interactive_player_map
#     # WidgetPlayerTask<public>:?stage_widget = false
#     # WidgetCamera<public>:?ui_widget_security_cam_view = false
#     # var ScreenNew<public>:ui_screen_new

#     var _Screens<private>:[]ui_screen = array{}
#     var _ScreensCancelables<private>:[ui_screen][]custom_cancelable = map{}

#     ShowWidget<public>(ScreenType:ui_screen_type):void = 
#         for(Screen:_Screens, ScreenType = Screen.ScreenType):
#             Screen.Show()

#     ShowWidgets<public>(ScreenTypes:[]ui_screen_type):void = 
#         for(Screen:_Screens, ScreenTypes.Find[Screen.ScreenType]):
#             Screen.Show()

#     AddWidget<public>(ScreenToAdd:ui_screen):void = 
#         # Remove old widget if already assigned
#         RemoveWidget(ScreenToAdd.ScreenType)

#         # Add new widget
#         set _Screens += array{ScreenToAdd}

#         # Track widget destroy
#         Cancelable := ScreenToAdd.EventScreenDestroied.Subscribe(_OnScreenSelfDestroied, true)
#         if(set _ScreensCancelables[ScreenToAdd] = array{Cancelable}):
#             Print("tracking autodestroy")
            

#     RemoveWidget<private>(Widget:ui_screen):void = 
#         _ClearsUpSubscriptions(Widget)
#         if(_Screens.RemoveElement[_Screens.Find[Widget]]):
#             Widget.Destroy()

#     RemoveWidget<public>(ScreenTypeToRemove:ui_screen_type):void = 
#         var IndexesToRemove:[]int = array{}
#         var NewScreens:[]ui_screen = array{}
#         for(Index->OldScreen:_Screens):
#             if(ScreenTypeToRemove = OldScreen.ScreenType):
#                 Print("Rimuovo vecchio widget")
#                 _ClearsUpSubscriptions(OldScreen)
#                 OldScreen.Destroy()
#             else:
#                 set NewScreens += array{OldScreen}

#         set _Screens = NewScreens

#     RemoveAll<public>():void =
#         for(Widget:_Screens):
#             Widget.Destroy()
#         set _Screens = array{}

#     GetScreen<public>(ScreenType:ui_screen_type)<transacts><decides>:ui_screen =
#         var MaybeScreen:?ui_screen = false
#         for(Screen:_Screens, ScreenType = Screen.ScreenType): 
#             set MaybeScreen = option{Screen}
#         MaybeScreen?

#     HideWidget<public>(ScreenType:ui_screen_type):void = 
#         for(Index->Screen:_Screens, ScreenType = Screen.ScreenType):
#             Screen.Hide()

#     # SetScene<public>(SceneType:ui_screen_scene):void = 
#     #     if(ScreenTypeArray := SceneMap[SceneType]):
#     #         Print("setting ui scene: {_Screens.Length} old screens")
#     #         var ScreenTypeArrayLeft:[]ui_screen_type = ScreenTypeArray

#     #         for(PlayerScreen:_Screens):
#     #             if:
#     #                 Pos := ScreenTypeArrayLeft.Find[PlayerScreen.ScreenType]
#     #                 NewScreenTypeArrayLeft := ScreenTypeArrayLeft.RemoveElement[Pos]
#     #             then: 
#     #                 PlayerScreen.Show()
#     #                 Print("scene show")
#     #                 set ScreenTypeArrayLeft = NewScreenTypeArrayLeft
#     #             else:
#     #                 PlayerScreen.Hide()

#     #         Print("setting ui scene: {_Screens.Length} new screens")


#     _OnScreenSelfDestroied<private>(Widget:ui_screen):void = 
#         _Logger.Normal("_OnScreenSelfDestroied")
#         RemoveWidget(Widget)

#     _ClearsUpSubscriptions<private>(Widget:ui_screen):void =
#         var NewMap:[ui_screen][]custom_cancelable = map{}

#         for(WidgetIndexed->Cancelables:_ScreensCancelables):
#             if(WidgetIndexed = Widget):
#                 for(Cancelable:Cancelables):
#                     Cancelable.Cancel()
#                     Print("stopped autodestroy tracking")
#             else:
#                 if:
#                     set NewMap[WidgetIndexed] = Cancelables

#         set _ScreensCancelables = NewMap



