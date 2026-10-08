
# using { /UnrealEngine.com/Temporary/UI }
# using { /Fortnite.com/UI }
# using { /UnrealEngine.com/Temporary/SpatialMath }

# Dummy_OnSabotageButtonClick<internal>(ButtonId:int, TaskName:ModuleTasks.task_name):void = {}


# widget_interactive_player_map_sabotage_buttons<public> := class:

#     var<private>Canvas<public>:canvas = canvas{}

#     var<private> _WidgetSabotageButtons<private>:[int]SabotageMap.ui_widget_sabotage_map_button_base = map{}

#     var<private> AreSabotageButtonsEnabled<public>:logic = false
#     var<private> AreSabotageButtonsVisible<public>:logic = false

#     var _OnSabotageButtonClick<private>:tuple(int,ModuleTasks.task_name)->void = Dummy_OnSabotageButtonClick



#     SetSabotageButtonCallback<public>(Callback:tuple(int,ModuleTasks.task_name)->void):void = 
#         set _OnSabotageButtonClick = Callback

#     SetVisibility<public>(Visibility:widget_visibility):void = 
#         case(Visibility):
#             widget_visibility.Visible => 
#                 Canvas.SetVisibility(Visibility)
#                 for(WidgetSabotageButton:_WidgetSabotageButtons):
#                     WidgetSabotageButton.Show()
#                 set AreSabotageButtonsVisible = true

#             widget_visibility.Hidden => 
#                 Canvas.SetVisibility(Visibility)
#                 for(WidgetSabotageButton:_WidgetSabotageButtons):
#                     WidgetSabotageButton.Hide()
#                 set AreSabotageButtonsVisible = false

#             widget_visibility.Collapsed => 
#                 Canvas.SetVisibility(Visibility)
#                 for(WidgetSabotageButton:_WidgetSabotageButtons):
#                     WidgetSabotageButton.Hide()
#                 set AreSabotageButtonsVisible = false

#     EnableAllSabotageButtons<public>():void =
#         set AreSabotageButtonsEnabled = true
#         for(Widget:_WidgetSabotageButtons):
#             Widget.Enable()
        
#     DisableAllSabotageButtons<public>():void =
#         set AreSabotageButtonsEnabled = false
#         for(Widget:_WidgetSabotageButtons):
#             Widget.Disable()

#     ColorSabotage<public>(Id:int):void = 
#         if(SabotageButton := _WidgetSabotageButtons[Id]):
#             # SabotageButton.ActiveSabotage()


#     Init<public>():void = 

#         # Init sabotage buttons and create canvas
#         # set _WidgetSabotageButtons = map:
#         #     19 => ui_widget_sabotage_map_button_eletrical{Id:=19, Coordinates:=vector2{X := 0.4, Y := 0.56}, Location:=map_locations.Electrical},
#         #     11 => ui_widget_sabotage_map_button_reactor_fail{Id:=11, Coordinates:=vector2{X := 0.095, Y := 0.5}, Location:=map_locations.Reactor},
#         #     10 => ui_widget_sabotage_map_button_o2{Id:=10, Coordinates:=vector2{X := 0.66, Y := 0.41}, Location:=map_locations.O2},
#         #     15 => ui_widget_sabotage_map_button_lock_door{Id:=15, Coordinates:=vector2{X := 0.16, Y := 0.30}, Location :=map_locations.UpperEngine},
#         #     14 => ui_widget_sabotage_map_button_lock_door{Id:=14, Coordinates:=vector2{X := 0.16, Y := 0.70}, Location:=map_locations.LowerEngine},
#         #     17 => ui_widget_sabotage_map_button_lock_door{Id:=17, Coordinates:=vector2{X := 0.36, Y := 0.37}, Location:=map_locations.MedBay},
#         #     12 => ui_widget_sabotage_map_button_lock_door{Id:=12, Coordinates:=vector2{X := 0.535, Y := 0.33}, Location:=map_locations.Cafeteria},
#         #     18 => ui_widget_sabotage_map_button_lock_door{Id:=18, Coordinates:=vector2{X := 0.515, Y := 0.8}, Location:=map_locations.Storage},
#         #     13 => ui_widget_sabotage_map_button_lock_door{Id:=13, Coordinates:=vector2{X := 0.385, Y := 0.72}, Location:=map_locations.Electrical},
#         #     16 => ui_widget_sabotage_map_button_lock_door{Id:=16, Coordinates:=vector2{X := 0.23, Y := 0.50}, Location:=map_locations.Security},
#         #     20 => ui_widget_sabotage_map_button_stop_comms{Id:=20, Coordinates:=vector2{X := 0.65, Y := 0.85}, Location:=map_locations.Communications}
        
        
#         for(Widget:_WidgetSabotageButtons):
#             Widget.Init()
#             # set Widget.CallbackOnClick = Self._OnSabotageButtonClick

#         set Canvas = canvas:
#             Slots := for(SabotageButton:_WidgetSabotageButtons):
#                 SabotageButton.Show()
#                 SabotageButton.GetCanvasSlot()

#         set AreSabotageButtonsVisible = true