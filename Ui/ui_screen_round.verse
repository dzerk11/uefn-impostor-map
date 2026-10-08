
# using { /UnrealEngine.com/Temporary/Diagnostics }
# using { /UnrealEngine.com/Temporary/UI }
# using { /Verse.org/Simulation }

# using { Widgets }

# Make_ui_screen_round<public><constructor>(InPlayer:player, InTranslator:ModuleLanguage.translator) := ui_screen_round:
#     Make_ui_screen<constructor>(InPlayer, InTranslator)
#     WidgetInteractivePlayerMap := Make_widget_interactive_player_map(InPlayer, InTranslator)
#     WidgetPlayerMap := Make_widget_player_map(InPlayer, InTranslator)
    

# ui_screen_round<public> := class(ui_screen_new):
#     WidgetInteractivePlayerMap<public>:widget_interactive_player_map
#     WidgetPlayerMap<public>:widget_player_map


#     Init<override>():void = 
#         (super:)Init()
#         Print("Init screen round")

#     DrawCanvas<override>():void =
#         (super:)DrawCanvas()
#         WidgetInteractivePlayerMap.Init()
#         WidgetPlayerMap.Init()

#         # WidgetInteractivePlayerMap.Show()
#         # WidgetPlayerMap.Show()

#         set CustomWidgets += array:
#             WidgetInteractivePlayerMap
#             WidgetPlayerMap

#         # WidgetInteractivePlayerMap.AssingToPlayer2()

#     # RemoveCanvas<override>():void = {}

#         # SlotA := WidgetInteractivePlayerMap.MakeSlot()
#         # _Canvas.AddWidget(SlotA)

#         # if(PlayerUI := GetPlayerUI[Self.Player]):
#         #     PlayerUI.AddWidget(_Canvas)

#         # # verde

#         # SlotB := WidgetPlayerMap.MakeSlot()
#         # _Canvas.AddWidget(SlotB)

#         # # blue

#         # if(PlayerUI := GetPlayerUI[Self.Player]):
#         #     PlayerUI.AddWidget(_Canvas)

#         # # blue
#         # if(PlayerUI := GetPlayerUI[Self.Player]):
#         #     PlayerUI.RemoveWidget(_Canvas)
#             # PlayerUI.RemoveWidget(SlotB.Widget)
#             # PlayerUI.RemoveWidget(SlotA.Widget)

#         # _Canvas.AddWidget(SlotB)
#         # # _Canvas.AddWidget(SlotA)

#         # Print("Slots: {_Canvas.Slots.Length}")

#         # _canvas2 := canvas:
#         #     Slots := array:
#         #         SlotA
#         #         SlotB

        