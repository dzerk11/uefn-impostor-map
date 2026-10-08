# using { /UnrealEngine.com/Temporary/UI }
# using { /UnrealEngine.com/Temporary/SpatialMath }
# using { /Fortnite.com/UI }
# using { /Verse.org/Simulation }
# using { /Verse.org/Colors }

# using { ModuleTasks }
# using { SabotageMap }
# using { Ui }

# # Localized messages
# MsgNextSabotage<localizes>:message = "Next sabotage available in: "

# # Main sabotage panel component
# ui_sabotage_panel<public> := class(Ui.ui_component_base):
#     # Dependencies
#     APlayer<public>:amongus_player
#     TaskManager<public>:task_manager
#     EventManager<public>:event_manager
    
#     # UI Elements
#     var CanvasSabotageButtons<private>:canvas = canvas{}
#     var StackBoxSabotages<private>:Ui.stack_box_wrapper = Ui.stack_box_wrapper:
#         Orientation := orientation.Vertical
    
#     var SabotageButtonCollection<private>:[]ui_widget_sabotage_map_button_base = array{}
#     # var SabotageToast<private>:?sabotage_toast = false
#     # var CanvasSabotageToast<private>:canvas = canvas{}
    
#     WidgetBtnToggleSabotages<public>:button_regular = button_regular:
#         DefaultText := MsgShowFakeTasks
    
#     LabelNextSabotageCooldown<private>:text_block = text_block:
#         DefaultTextColor := NamedColors.White
    
#     var SabotageElementList<private>:[task_name]ui_widget_interactive_player_map_list_element = map{}
#     var AreSabotageButtonsVisible<private>:logic = false
    
#     # Events
#     SabotageButtonClicked<public>:event(tuple(int, task_name)) = event(tuple(int, task_name)){}
    
#     # Initialize the sabotage panel
#     OnInit<override>():void =
#         if(not APlayer.IsImpostor[]):
#             HideAll()
#             return
            
#         InitializeSabotageButtons()
#         # UpdateStackBoxSabotages()
#         StackBoxSabotages.Init()
        
#         # Check for running sabotage
#         if(SabotageRunning := TaskManager.GetRunningSabotage[]):
#             ColorActiveSabotage(SabotageRunning(0), SabotageRunning(1))
#             ShowSabotageToast(SabotageRunning(0))
    
#     # Initialize sabotage buttons with their positions
#     InitializeSabotageButtons<private>():void =
#         set SabotageButtonCollection = array:
#             ui_widget_sabotage_map_button_eletrical:
#                 Id:=19
#                 Coordinates:=vector2{X := 0.4, Y := 0.56}
#                 Location:=map_locations.Electrical
#             ui_widget_sabotage_map_button_reactor_fail:
#                 Id:=11
#                 Coordinates:=vector2{X := 0.095, Y := 0.5}
#                 Location:=map_locations.Reactor
#             ui_widget_sabotage_map_button_o2:
#                 Id:=10
#                 Coordinates:=vector2{X := 0.66, Y := 0.41}
#                 Location:=map_locations.O2
#             ui_widget_sabotage_map_button_lock_door:
#                 Id:=15
#                 Coordinates:=vector2{X := 0.16, Y := 0.30}
#                 Location:=map_locations.UpperEngine
#             ui_widget_sabotage_map_button_lock_door:
#                 Id:=14
#                 Coordinates:=vector2{X := 0.16, Y := 0.70}
#                 Location:=map_locations.LowerEngine
#             ui_widget_sabotage_map_button_lock_door:
#                 Id:=17
#                 Coordinates:=vector2{X := 0.36, Y := 0.37}
#                 Location:=map_locations.MedBay
#             ui_widget_sabotage_map_button_lock_door:
#                 Id:=12
#                 Coordinates:=vector2{X := 0.535, Y := 0.33}
#                 Location:=map_locations.Cafeteria
#             ui_widget_sabotage_map_button_lock_door:
#                 Id:=18
#                 Coordinates:=vector2{X := 0.515, Y := 0.8}
#                 Location:=map_locations.Storage
#             ui_widget_sabotage_map_button_lock_door:
#                 Id:=13
#                 Coordinates:=vector2{X := 0.385, Y := 0.72}
#                 Location:=map_locations.Electrical
#             ui_widget_sabotage_map_button_lock_door:
#                 Id:=16
#                 Coordinates:=vector2{X := 0.23, Y := 0.50}
#                 Location:=map_locations.Security
#             ui_widget_sabotage_map_button_stop_comms:
#                 Id:=20
#                 Coordinates:=vector2{X := 0.65, Y := 0.85}
#                 Location:=map_locations.Communications
        
#         # Initialize button canvas
#         set CanvasSabotageButtons = canvas:
#             Slots := for(SabotageButton:SabotageButtonCollection):
#                 SabotageButton.Init()
#                 SabotageButton.Show()
#                 # Connect button click event
#                 # spawn{HandleSabotageButtonClick(SabotageButton)}
#                 SabotageButton.GetCanvasSlot()
    
#     # Handle individual sabotage button clicks
#     # HandleSabotageButtonClick<private>(Button:ui_widget_sabotage_map_button_base)<suspends>:void =
#     #     loop:
#     #         Button.Clicked.Await()
#     #         SabotageButtonClicked.Signal((Button.Id, Button.GetTaskName()))
#     #         EventManager.Notify(event_sabotage_clicked{Player:=option{Player}, TaskId:=Button.Id})
    
#     # Update the sabotage list display
#     UpdateStackBoxSabotages<private>():void =
#         var SabotagesList:[]stack_box_slot = array{}
#         var RowSlots:[]stack_box_slot = array{}
        
#         IconTint := MakeColorFromHex("FFF")
        
#         Sabotages := array:
#             task_name.SabotageReactorFail
#             task_name.SabotageElectrical
#             task_name.SabotageComms
#             task_name.SabotageO2
#             task_name.SabotageLockDoors
        
#         RowDistribution := GetRowDistribution(Sabotages.Length)
        
#         var SabotageIndex:int = 0
#         for(RowSize:RowDistribution):
#             var CurrentRowSlots:[]stack_box_slot = array{}
            
#             for(I := 0..RowSize - 1):
#                 if(SabotageIndex < Sabotages.Length, Sabotage := Sabotages[SabotageIndex]):
                    
#                     SabotageSlot := stack_box_slot:
#                         Padding := margin{Left:=8.0, Top:=2.0, Right:=8.0, Bottom:=2.0}
#                         HorizontalAlignment := horizontal_alignment.Center
#                         VerticalAlignment := vertical_alignment.Center
#                         Widget := texture_block:
#                             DefaultImage := Ui.GetTexture(Sabotage)
#                             DefaultDesiredSize := vector2{X:=60.0, Y:=60.0}
#                             DefaultTint := IconTint
                    
#                     set CurrentRowSlots += array{SabotageSlot}
#                     set SabotageIndex += 1
            
#             if(CurrentRowSlots.Length > 0):
#                 RowSlot := stack_box_slot:
#                     HorizontalAlignment := horizontal_alignment.Center
#                     VerticalAlignment := vertical_alignment.Center
#                     Widget := stack_box:
#                         Orientation := orientation.Horizontal
#                         Slots := CurrentRowSlots
                
#                 set RowSlots += array{RowSlot}
        
#         SabotagesContainer := stack_box:
#             Orientation := orientation.Vertical
#             Slots := RowSlots
        
#         StackBoxSabotages.Update(
#             array:
#                 stack_box_slot:
#                     Padding := margin{Bottom := 8.0}
#                     HorizontalAlignment := horizontal_alignment.Center
#                     VerticalAlignment := vertical_alignment.Center
#                     Widget := wbp_title_sabotages{}
                
#                 stack_box_slot:
#                     HorizontalAlignment := horizontal_alignment.Fill
#                     VerticalAlignment := vertical_alignment.Fill
#                     Widget := SabotagesContainer
#         )
    
#     # Toggle sabotage panel visibility
#     ToggleVisibility<public>():logic =
#         if(AreSabotageButtonsVisible?):
#             Hide()
#             return false
#         else:
#             Show()
#             return true
    
#     # Show sabotage panel
#     Show<public>():void =
#         WidgetBtnToggleSabotages.SetText(MsgShowFakeTasks)
#         CanvasSabotageButtons.SetVisibility(widget_visibility.Visible)
#         StackBoxSabotages.Canvas.SetVisibility(widget_visibility.Visible)
#         set AreSabotageButtonsVisible = true
    
#     # Hide sabotage panel
#     Hide<public>():void =
#         WidgetBtnToggleSabotages.SetText(MsgShowSabotages)
#         CanvasSabotageButtons.SetVisibility(widget_visibility.Hidden)
#         StackBoxSabotages.Canvas.SetVisibility(widget_visibility.Collapsed)
#         set AreSabotageButtonsVisible = false
    
#     # Hide all sabotage elements
#     HideAll<private>():void =
#         WidgetBtnToggleSabotages.SetVisibility(widget_visibility.Collapsed)
#         CanvasSabotageButtons.SetVisibility(widget_visibility.Collapsed)
#         StackBoxSabotages.Canvas.SetVisibility(widget_visibility.Collapsed)
    
#     # Show sabotage toast notification
#     ShowSabotageToast<public>(Sabotage:task_name, PlayerRole:player_role):void =
#         # Remove old toast
#         if(OldToast := SabotageToast?):
#             CanvasSabotageToast.RemoveWidget(OldToast.Widget)
#             OldToast.Destroy()
        
#         if(Sabotage <> task_name.SabotageLockDoors):
#             Toast := sabotage_toast{PlayerRole := PlayerRole, Sabotage := Sabotage}
#             Toast.Init()
#             set SabotageToast = option{Toast}
#             CanvasSabotageToast.AddWidget(
#                 canvas_slot:
#                     Widget := Toast.Widget
#             )
    
#     # Update sabotage cooldown display
#     UpdateCooldown<public>(TimeLeft:float):void =
#         if(TimeInteger:int = Floor[TimeLeft]):
#             Msg := MsgNextSabotage + "{TimeInteger}s."
#             LabelNextSabotageCooldown.SetText(StringToMsg(Msg))
#             LabelNextSabotageCooldown.SetVisibility(widget_visibility.Visible)
    
#     # Color active sabotage
#     ColorActiveSabotage<public>(SabotageName:task_name, SabotageId:int):void =
#         if(El := SabotageElementList[SabotageName]):
#             El.Icon.SetTint(MakeColorFromHex("f73e3e"))
        
#         # Color the button as well
#         for(Button:SabotageButtonCollection):
#             if(Button.Id = SabotageId):
#                 Button.SetActive(true)
    
#     # Remove color from sabotage
#     RemoveColorActiveSabotage<public>(SabotageName:task_name, SabotageId:int):void =
#         if(El := SabotageElementList[SabotageName]):
#             El.Icon.SetTint(NamedColors.White)
        
#         # Reset button color
#         for(Button:SabotageButtonCollection):
#             if(Button.Id = SabotageId):
#                 Button.SetActive(false)
    
#     # Update toast time left
#     UpdateToastTimeLeft<public>(SecondsLeft:int):void =
#         if(Toast := SabotageToast?):
#             Toast.UpdateTimeLeft(SecondsLeft)
    
#     # Handle sabotage status change
#     OnSabotageStatusChanged<public>(IsActive:logic, SabotageName:task_name, SabotageId:int):void =
#         if(IsActive?):
#             ColorActiveSabotage(SabotageName, SabotageId)
#             if(IsImpostor?):
#                 ShowSabotageToast(SabotageName, player_role.Impostor)
#             else:
#                 ShowSabotageToast(SabotageName, player_role.Crewmate)
#         else:
#             RemoveColorActiveSabotage(SabotageName, SabotageId)
#             CanvasSabotageToast.SetVisibility(widget_visibility.Hidden)
    
#     # Get row distribution for layout
#     GetRowDistribution<private>(TotalItems:int, ?RowDifference:int=1):[]int =
#         if(TotalItems <= 3):
#             array{TotalItems}
#         else:
#             if(Mod[TotalItems - RowDifference, 2] = 0):
#                 SecondRow := Floor((TotalItems - RowDifference) / 2 or 0)
#                 FirstRow := SecondRow + RowDifference
#                 array{FirstRow, SecondRow}
#             else:
#                 SecondRow := Floor((TotalItems - RowDifference - 1) / 2 or 0)
#                 FirstRow := SecondRow + RowDifference + 1
#                 array{FirstRow, SecondRow}
    
#     # Get the main canvas for integration
#     GetCanvas<public>():canvas = Canvas
    
#     # Get the sabotage buttons canvas
#     GetSabotageButtonsCanvas<public>():canvas = CanvasSabotageButtons
    
#     # Get the sabotage list canvas
#     GetSabotageListCanvas<public>():canvas = StackBoxSabotages.Canvas
    
#     # Get the toast canvas
#     GetToastCanvas<public>():canvas = CanvasSabotageToast