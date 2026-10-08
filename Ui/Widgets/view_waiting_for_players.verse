
# using { /UnrealEngine.com/Temporary/UI }
# using { /UnrealEngine.com/Temporary/SpatialMath }

# using { Modules.TaskBar }
# using { ModuleTasks }

# Make_view_taskbar<public><constructor>(APlayer:amongus_player, TaskManager:task_manager, EventManager:event_manager) := view_taskbar:
#     APlayer := APlayer
#     Player := APlayer.Player
#     TaskManager := TaskManager
#     EventManager := EventManager

# view_taskbar<public> := class(ui_view_verse, event_listener):
#     APlayer<public>:amongus_player
#     TaskManager<public>:task_manager
#     EventManager<public>:event_manager

#     # The widget instance - created once
#     WaitingHud<private>:WBP_WaitingToStart = WBP_WaitingToStart{}

#     OnInit<override>():void =
#         # Subscribe to task completion events
#         EventManager.Subscribe(event_type.TASK_COMPLETION, Self)

#         # Set the widget
#         set Widget = canvas:
#             Slots := array:
#                 canvas_slot:
#                     Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
#                     ZOrder := 0
#                     Widget := TaskbarWidget

#         # Update widget with initial values
#         UpdateWidget()

#     OnDestroy<override>():void =
#         EventManager.UnSubscribe(Self)

#     Update<override>(EventPayload:event_payload):void =
#         case(EventPayload.EventType):
#             event_type.TASK_COMPLETION =>
#                 if(Payload := event_task_completion[EventPayload]):
#                     UpdateWidget()
#             _ =>

#     UpdateWidget<private>():void =
#         Completion := TaskManager.GetTasksCompletion()
#         set TaskbarWidget.TasksCompleted = Completion(0)
#         set TaskbarWidget.TasksToComplete = Completion(1)
