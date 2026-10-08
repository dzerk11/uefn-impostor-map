# using { /Fortnite.com }
# using { /Fortnite.com/UI }
# using { /Fortnite.com/Characters }
# using { /Verse.org/Simulation }
# using { /Verse.org/Colors }
# using { /Verse.org/Assets }
# using { /UnrealEngine.com/Temporary/UI}
# using { /UnrealEngine.com/Temporary/SpatialMath }

# 


# Make_widget_player_map<public><constructor>(InPlayer:player, InDefaultSabotageRunning:?ModuleTasks.task_info) := widget_player_map:
#     Make_ui_widget_base<constructor>(InPlayer)
#     DefaultSabotageRunning := InDefaultSabotageRunning



# widget_player_map<public> := class(ui_widget_base):
#     ScreenType<override>:ui_screen_type = ui_screen_type.PLAYER_MAP

#     DefaultSabotageRunning<public>:?ModuleTasks.task_info

#     # Widget map
#     _WidgetMap<private>:widget = texture_block:
#         DefaultImage:= Art.Textures.T_mapSkeld_90

#     # Player pointer
#     _WidgetPlayerPointer:widget_player_pointer = widget_player_pointer:
#         DefaultDesiredSize := vector2{X := 32.0, Y := 32.0}

#     # Task icons
#     var _CanvasTaskIcons<private>:canvas = canvas{}
#     var _CanvasSabotageIcons<private>:canvas = canvas{}


#     Show<override>():void = 
#         {}

#     CanvasNoSignal<private>:canvas = canvas:
#         Slots := array:
#             canvas_slot:
#                 ZOrder := 1
#                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                 Widget := texture_block:
#                     DefaultImage := Art.Textures.T_MapNoSignal

#             canvas_slot:
#                 ZOrder := 2
#                 Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
#                 Offsets := margin{Top := 0.0, Left := 0.0, Right := 200.0, Bottom := 50.0}
#                 SizeToContent := false
#                 Alignment := vector2{X := 0.5, Y := 0.5}
#                 Widget := color_block:
#                     DefaultColor := NamedColors.Black

#             canvas_slot:
#                 ZOrder := 3
#                 Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
#                 Alignment := vector2{X := 0.5, Y := 0.5}
#                 Widget := text_block:
#                     DefaultTextColor := NamedColors.White
#                     DefaultText := TextNoSignal

    

#     # --------------- [ METHODS ] ---------------

#     _MakeCanvas<override>():canvas = 
#         _WidgetPlayerPointer.Init()

#         canvas:
#             Slots := array:
#                 canvas_slot:
#                     ZOrder := 1
#                     Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 0.0}}
#                     Offsets := margin{Top := 20.0, Left := -20.0, Right := 630.0, Bottom := 350.0}
#                     Alignment := vector2{X := 1.0, Y := 0.0}
#                     SizeToContent := false
#                     Widget := canvas:
#                         Slots := array:

#                             # Map slot
#                             canvas_slot:
#                                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                                 Alignment := vector2{X := 0.5, Y := 0.5}
#                                 SizeToContent := false
#                                 ZOrder := 0
#                                 Widget := _WidgetMap

#                             # Task Icons slot
#                             canvas_slot:
#                                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                                 Alignment := vector2{X := 0.5, Y := 0.5}
#                                 SizeToContent := false
#                                 ZOrder := 1
#                                 Widget := _CanvasTaskIcons

#                             # Task Icons slot
#                             canvas_slot:
#                                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                                 Alignment := vector2{X := 0.5, Y := 0.5}
#                                 SizeToContent := false
#                                 ZOrder := 1
#                                 Widget := _CanvasSabotageIcons

#                             # No signal noise
#                             canvas_slot:
#                                 ZOrder := 2
#                                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                                 Widget := CanvasNoSignal

#                             # Player slot
#                             canvas_slot:
#                                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                                 Alignment := vector2{X := 0.5, Y := 0.5}
#                                 SizeToContent := false
#                                 ZOrder := 3
#                                 Widget := _WidgetPlayerPointer.Canvas

#     Init<override>():void =
#         (super:)Init()
#         if(SabotageRunning := DefaultSabotageRunning?, SabotageRunning.TaskName = ModuleTasks.task_name.SabotageComms):
#             UpdateNoSignalNoise(true)
#         else:
#             UpdateNoSignalNoise(false)

#         if(EventManager := EventManagers[GetSession()]):
#             EventManager.Subscribe(event_type.PLAYER_POSITION, Self, Player)
#             EventManager.Subscribe(event_type.PLAYER_ROTATION, Self, Player)
#             EventManager.Subscribe(event_type.PLAYER_TASK_LIST, Self, Player)
#             EventManager.Subscribe(event_type.SABOTAGE_STATUS_CHANGED, Self)

#         spawn{HandleUpdate()}

#     # Show<override>():void =
#     #     (super:)Show()

#     #     if:
#     #         SpatialController := Mechanics.SpatialControllers[GetSession()]
#     #         Position := SpatialController.GetPlayerPosition[Player]
#     #         Rotation := SpatialController.GetPlayerRotation[Player]
#     #     then:
#     #         _WidgetPlayerPointer.UpdatePosition(Position)
#     #         _WidgetPlayerPointer.UpdateRotation(Rotation)

#     #     if:
#     #         TaskManager := ModuleTasks.TaskManagers[GetSession()]
#     #     then:
#     #         UpdateStageIconsSlots(TaskManager.GetPlayerTasksInfo(Player))


#     Destroy<override>():void = 
#         (super:)Destroy()
#         if(EventManager := EventManagers[GetSession()]):
#             EventManager.UnSubscribe(Self)


#     Update<override>(EventPayload:event_payload):void = 
#         case(EventPayload.EventType):
#             event_type.PLAYER_POSITION => 
#                 if(Payload := event_player_position[EventPayload]):
#                     _WidgetPlayerPointer.UpdatePosition(Payload.Data)
#             event_type.PLAYER_ROTATION => 
#                 if(Payload := event_player_rotation[EventPayload]):
#                     _WidgetPlayerPointer.UpdateRotation(Payload.Data)
#             event_type.PLAYER_TASK_LIST => 
#                 if(Payload := event_player_task_list[EventPayload]):
#                     UpdateStageIconsSlots(Payload.Data)
#             # event_type.SABOTAGE_STATUS => 
#             #     if(Payload := event_sabotage_status[EventPayload]):
#                     # if(Payload.SabotageStatus?):
#                     #     # _CanvasTaskIcons.SetVisibility(widget_visibility.Hidden)
#                     #     # _CanvasSabotageIcons.SetVisibility(widget_visibility.Visible)
#                     #     # UpdateStageSabotageIcons(array{Payload.Sabotage})
#                     # else:
#                     #     _CanvasTaskIcons.SetVisibility(widget_visibility.Visible)
#                     #     _CanvasSabotageIcons.SetVisibility(widget_visibility.Hidden)

#                     # if(Payload.Sabotage.TaskName = ModuleTasks.task_name.SabotageComms):
#                     #     if(Payload.SabotageStatus?):
#                     #         UpdateNoSignalNoise(true)
#                     #     else:
#                     #         UpdateNoSignalNoise(false)

#             _ =>


#     HandleUpdate<private>()<suspends>:void = 
#         if(EventManager := EventManagers[GetSession()]):
#             race:

#                 block:
#                     Self.EventScreenDestroied.Await()

#                 block:
#                     Payload := EventManager.SabotageStatusChanged.Await()
#                     if(Payload(1) = ModuleTasks.task_name.SabotageComms):
#                         if(Payload(0)?):
#                             UpdateNoSignalNoise(true)
#                         else:
#                             UpdateNoSignalNoise(false)


#     UpdateNoSignalNoise<public>(Status:logic):void = 
#         if(Status?):
#             CanvasNoSignal.SetVisibility(widget_visibility.Visible)
#             _CanvasTaskIcons.SetVisibility(widget_visibility.Collapsed)
#             _WidgetPlayerPointer.Canvas.SetVisibility(widget_visibility.Collapsed)
#         else:
#             CanvasNoSignal.SetVisibility(widget_visibility.Collapsed)
#             _CanvasTaskIcons.SetVisibility(widget_visibility.Visible)
#             _WidgetPlayerPointer.Canvas.SetVisibility(widget_visibility.Visible)



#     # Show stage icon slots 
#     UpdateStageIconsSlots<public>(TaskInfoList:[]ModuleTasks.task_info):void =
#         # set CurrentTasks = TaskInfoList
#         Print("UpdateStageIconsSlots: {TaskInfoList.Length}")

#         var TempTaskList:[]ModuleTasks.task_info = array{}

#         # Check if there is a sabotage
#         var HasSabotages:logic = false
#         for(Task:TaskInfoList, Task.TaskType=ModuleTasks.task_type.Sabotage, not Task.TaskName = ModuleTasks.task_name.SabotageLockDoors):
#             set HasSabotages = true

#         if(HasSabotages?):
#             for(Task:TaskInfoList, Task.TaskType=ModuleTasks.task_type.Sabotage):
#                 set TempTaskList += array{Task}
#             Print("UpdateStageIconsSlots sabotages to show: {TempTaskList.Length}")
#         else:
#             for(Task:TaskInfoList, Task.TaskType=ModuleTasks.task_type.Task):
#                 set TempTaskList += array{Task}

#             Print("UpdateStageIconsSlots tasks to show: {TempTaskList.Length}")

#         var StageIconsSlots:[]canvas_slot = array{}
#         for(Index->TaskInfo:TempTaskList):
#             CompletableStages := TaskInfo.GetCompletableStages()

#             for(CompletableStage:CompletableStages):
#                 RelativeCoordinates := ConvertRealCoordinatesIntoMapRelative(CompletableStage.Coordinates)
#                 set StageIconsSlots += array: 

#                     canvas_slot:
#                         Anchors := anchors{Minimum := RelativeCoordinates, Maximum := RelativeCoordinates}
#                         Offsets := margin{Top := 2.0, Left := 2.0, Right := 40.0, Bottom := 40.0}
#                         Alignment := vector2{X := 0.5, Y := 0.5}
#                         SizeToContent := false
#                         ZOrder := 9
#                         Widget := texture_block:
#                             DefaultImage := if(TaskInfo.TaskType = ModuleTasks.task_type.Task){TaskInfo.TaskIcon}else{Art.Textures.Icons.T_Icon_Warning_glowing}
#                             DefaultTint := NamedColors.Black

#                     canvas_slot:
#                         Anchors := anchors{Minimum := RelativeCoordinates, Maximum := RelativeCoordinates}
#                         Offsets := margin{Top := 0.0, Left := 0.0, Right := 40.0, Bottom := 40.0}
#                         Alignment := vector2{X := 0.5, Y := 0.5}
#                         SizeToContent := false
#                         ZOrder := 10
#                         Widget := texture_block:
#                             DefaultImage := if(TaskInfo.TaskType = ModuleTasks.task_type.Task){TaskInfo.TaskIcon}else{Art.Textures.Icons.T_Icon_Warning_glowing}
#                             DefaultTint := TaskInfo.TaskIconColor
          
#         if(ParentWidget := _CanvasTaskIcons.GetParentWidget[], CanvasParent := canvas[ParentWidget]):

#             OldVisibility := _CanvasSabotageIcons.GetVisibility()

#             CanvasParent.RemoveWidget(_CanvasTaskIcons)
#             set _CanvasTaskIcons = canvas:
#                 Slots := StageIconsSlots

#             # _CanvasTaskIcons.SetVisibility(OldVisibility)

#             CanvasParent.AddWidget(
#                 canvas_slot:
#                     Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                     Alignment := vector2{X := 0.5, Y := 0.5}
#                     SizeToContent := false
#                     Widget := _CanvasTaskIcons
#             )
#             Print("UpdateStageIconsSlots done: {StageIconsSlots.Length}")


#     # # # Show stage icon slots 
#     # UpdateStageSabotageIcons<public>(SabotageInfoList:[]ModuleTasks.task_info):void =
#     #     # set CurrentTasks = SabotageInfoList

#     #     var TempTaskList:[]ModuleTasks.task_info = array{}

#     #     # Check if there is a sabotage
#     #     var HasSabotages:logic = false
#     #     for(Task:SabotageInfoList, Task.TaskType=ModuleTasks.task_type.Sabotage):
#     #         set HasSabotages = true

#     #     if(HasSabotages?):
#     #         for(Task:SabotageInfoList, Task.TaskType=ModuleTasks.task_type.Sabotage):
#     #             set TempTaskList += array{Task}

#     #     var StageIconsSlots:[]canvas_slot = array{}
#     #     for(Index->TaskInfo:TempTaskList):
#     #         CompletableStages := TaskInfo.GetCompletableStages()

#     #         for(CompletableStage:CompletableStages):
#     #             RelativeCoordinates := ConvertRealCoordinatesIntoMapRelative(CompletableStage.Coordinates)
#     #             set StageIconsSlots += array: 

#     #                 canvas_slot:
#     #                     Anchors := anchors{Minimum := RelativeCoordinates, Maximum := RelativeCoordinates}
#     #                     Offsets := margin{Top := 2.0, Left := 2.0, Right := 40.0, Bottom := 40.0}
#     #                     Alignment := vector2{X := 0.5, Y := 0.5}
#     #                     SizeToContent := false
#     #                     ZOrder := 9
#     #                     Widget := texture_block:
#     #                         DefaultImage := TaskInfo.TaskIcon
#     #                         DefaultTint := NamedColors.Black

#     #                 canvas_slot:
#     #                     Anchors := anchors{Minimum := RelativeCoordinates, Maximum := RelativeCoordinates}
#     #                     Offsets := margin{Top := 0.0, Left := 0.0, Right := 40.0, Bottom := 40.0}
#     #                     Alignment := vector2{X := 0.5, Y := 0.5}
#     #                     SizeToContent := false
#     #                     ZOrder := 10
#     #                     Widget := texture_block:
#     #                         DefaultImage := TaskInfo.TaskIcon
#     #                         DefaultTint := TaskInfo.TaskIconColor
          
#     #     if(ParentWidget := _CanvasSabotageIcons.GetParentWidget[], CanvasParent := canvas[ParentWidget]):
#     #         CanvasParent.RemoveWidget(_CanvasSabotageIcons)
#     #         set _CanvasSabotageIcons = canvas:
#     #             Slots := StageIconsSlots
#     #         CanvasParent.AddWidget(
#     #             canvas_slot:
#     #                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#     #                 Alignment := vector2{X := 0.5, Y := 0.5}
#     #                 SizeToContent := false
#     #                 Widget := _CanvasSabotageIcons
#     #         )
                