
# using { /Verse.org/Simulation }

# task_event_calltypes<public> := enum:
#     PLAYER_INTERACTS_WITH_BUTTON
#     SIGNAL_SHOW_STAGE_GUI
#     STAGE_COMPLETED
#     TASK_COMPLETED
#     SHOW_STAGE_TO_PLAYER
#     CLOSE_STAGE_GUI
#     ACTIVATE_SABOTAGE
#     NONE

# task_event<public> := class(custom_event):
#     CallType<public>: task_event_calltypes
#     TaskId<public>:int
#     TaskName<public>:task_name = task_name.None
#     StageOrder<public>:int = -1
#     Players<public>:[]player = array{}

# task_event_task_completed<public> := class<final>(task_event):
#     CallType<override>: task_event_calltypes = task_event_calltypes.TASK_COMPLETED

# task_event_close_stage_gui<public> := class<final>(task_event):
#     CallType<override>: task_event_calltypes = task_event_calltypes.CLOSE_STAGE_GUI
#     TaskName<override>:task_name = task_name.None

# task_event_player_interacts_with_button<public> := class<final>(task_event):
#     CallType<override>:task_event_calltypes = task_event_calltypes.PLAYER_INTERACTS_WITH_BUTTON
#     TaskId<override>:int = -1

# task_event_complete_stage<public> := class<final>(task_event):
#     CallType<override>: task_event_calltypes = task_event_calltypes.STAGE_COMPLETED

# task_event_activate_sabotage<public> := class<final>(task_event):
#     CallType<override>: task_event_calltypes = task_event_calltypes.ACTIVATE_SABOTAGE

