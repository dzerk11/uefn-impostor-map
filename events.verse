
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

event_type<internal> := enum:
    NONE
    SWITCH_GAME_PHASE
    PLAYER_POSITION
    PLAYER_ROTATION
    PLAYER_TASK_LIST
    # PLAYER_INTERACTS_WITH_STAGE
    SABOTAGE_STATUS_CHANGED
    SABOTAGE_BUTTON_CLICK
    SABOTAGE_COMMS
    SABOTAGE_REMAINING_TIME
    SABOTAGE_COOLDOWN_REMAINING_TIME
    VENT_BUTTON_CLICK
    VENT_STATUS
    RAISE_PLAYER_MESSAGE
    TASK_ADVANCED #could be completed or not
    TASK_STARTED
    STAGE_ENDED
    TASK_COMPLETION #current status
    EMERGENCY_MEETING_STATUS
    INTERACTIVE_PLAYER_MAP_VISIBILITY_CHANGE
    # PLAYER_STAGE_COMPLETED
    PLAYER_STAGE_FAILED
    PLAYER_STAGE_REWARD
    SECURITY_CAMERA_VIEWING_CHANGED
    PLAYER_REVEAL_STATUS_CHANGED

ToString(EventType:event_type):string = 
    case(EventType):
        event_type.NONE => "NONE"
        event_type.SWITCH_GAME_PHASE => "SWITCH_GAME_PHASE"
        event_type.PLAYER_POSITION => "PLAYER_POSITION"
        event_type.PLAYER_ROTATION => "PLAYER_ROTATION"
        event_type.PLAYER_TASK_LIST => "PLAYER_TASK_LIST"
        # event_type.PLAYER_INTERACTS_WITH_STAGE => "PLAYER_INTERACTS_WITH_STAGE"
        event_type.SABOTAGE_STATUS_CHANGED => "SABOTAGE_STATUS_CHANGED"
        event_type.SABOTAGE_REMAINING_TIME => "SABOTAGE_REMAINING_TIME"
        event_type.SABOTAGE_COOLDOWN_REMAINING_TIME => "SABOTAGE_COOLDOWN_REMAINING_TIME"
        event_type.SABOTAGE_BUTTON_CLICK => "SABOTAGE_BUTTON_CLICK"
        event_type.SABOTAGE_COMMS => "SABOTAGE_COMMS"
        event_type.VENT_BUTTON_CLICK => "VENT_BUTTON_CLICK"
        event_type.VENT_STATUS => "VENT_STATUS"
        event_type.RAISE_PLAYER_MESSAGE => "RAISE_PLAYER_MESSAGE"
        event_type.TASK_ADVANCED => "TASK_ADVANCED"
        event_type.TASK_STARTED => "TASK_STARTED"
        event_type.STAGE_ENDED => "STAGE_ENDED"
        event_type.TASK_COMPLETION => "TASK_COMPLETION"
        event_type.EMERGENCY_MEETING_STATUS => "EMERGENCY_MEETING_STATUS"
        event_type.INTERACTIVE_PLAYER_MAP_VISIBILITY_CHANGE => "INTERACTIVE_PLAYER_MAP_VISIBILITY_CHANGE"
        # event_type.PLAYER_STAGE_COMPLETED => "PLAYER_STAGE_COMPLETED"
        event_type.PLAYER_STAGE_FAILED => "PLAYER_STAGE_FAILED"
        event_type.PLAYER_STAGE_REWARD => "PLAYER_STAGE_REWARD"
        event_type.SECURITY_CAMERA_VIEWING_CHANGED => "SECURITY_CAMERA_VIEWING_CHANGED"
        event_type.PLAYER_REVEAL_STATUS_CHANGED => "PLAYER_REVEAL_STATUS_CHANGED"

event_payload<internal> := class:
    EventType<internal>:event_type = event_type.NONE
    Player<internal>:?player = false

event_switch_to_game_phase<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.SWITCH_GAME_PHASE
    Gamephase<public>:Gameplay.gamephase

event_player_position<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.PLAYER_POSITION
    Data<internal>:vector3

event_player_rotation<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.PLAYER_ROTATION
    Data<internal>:rotation

event_player_task_list<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.PLAYER_TASK_LIST
    Data<internal>:[]ModuleTasks.task_info

event_sabotage_status<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.SABOTAGE_STATUS_CHANGED
    Instigator<public>:?player
    SabotageName<internal>:ModuleTasks.task_name
    SabotageStatus<internal>:logic
    # Sabotage<internal>:ModuleTasks.sabotage_data

# event_player_interacts_with_stage<internal> := class<final>(event_payload):
#     EventType<override>:event_type = event_type.PLAYER_INTERACTS_WITH_STAGE
#     TaskName<internal>:ModuleTasks.task_name
#     StageId<internal>:int

event_sabotage_clicked<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.SABOTAGE_BUTTON_CLICK
    TaskId<internal>:int

event_vent_button_clicked<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.VENT_BUTTON_CLICK
    Vent<internal>:ModuleVents.vent_class

event_vent_status<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.VENT_STATUS
    Status<internal>:logic

event_sabotage_comms<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.SABOTAGE_COMMS
    Status<public>:logic

event_sabotage_remaining_time<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.SABOTAGE_REMAINING_TIME
    RemainingTime<public>:float

event_sabotage_cooldown_remaining_time<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.SABOTAGE_COOLDOWN_REMAINING_TIME
    RemainingTime<public>:float
    IsJustStarted<public>:logic = false
    IsJustOver<public>:logic = false

event_raise_player_message<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.RAISE_PLAYER_MESSAGE
    MessageType<public>:Ui.ui_player_message
    TargetPlayers<public>:[]player

event_task_advanced<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.TASK_ADVANCED
    PlayerWhoAdvanced<public>:player
    IsTaskCompleted<public>:logic
    TaskType<public>:ModuleTasks.task_type
    TaskName<public>:ModuleTasks.task_name
    StageId<public>:int

event_task_started<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.TASK_STARTED
    TaskName<public>:ModuleTasks.task_name
    StageId<public>:int
    MaybeWidget<public>:?ModuleTasks.StageWidgets.stage_widget
    HideHudOnStart<public>:logic

event_task_completion<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.TASK_COMPLETION
    StagesCompleted<public>:int
    StagesCompletable<public>:int

event_stage_ended<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.STAGE_ENDED
    TaskName<public>:ModuleTasks.task_name
    StageId<public>:int
    HideHudOnStart<public>:logic

event_emergency_meeting_status<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.EMERGENCY_MEETING_STATUS
    Instigator<public>:?player
    Status<public>:logic

event_interactive_player_map_visibility_change<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.INTERACTIVE_PLAYER_MAP_VISIBILITY_CHANGE
    Status<public>:logic


# Signaled by a stage for task_manager when a player completes a stage
# event_player_stage_completed<internal> := class<final>(event_payload):
#     EventType<override>:event_type = event_type.PLAYER_STAGE_COMPLETED
#     TaskName<public>:ModuleTasks.task_name
#     StageId<public>:int

# Signaled by a stage for task_manager when a player fails a stage
event_player_stage_failed<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.PLAYER_STAGE_FAILED
    TaskName<public>:ModuleTasks.task_name
    StageId<public>:int

# Signaled by a stage for task_manager when a player achieves a reward
event_player_stage_reward<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.PLAYER_STAGE_REWARD
    TaskName<public>:ModuleTasks.task_name
    StageId<public>:int
    RewardType<public>:Utils.award_type

# Signaled when a player starts or stops viewing security cameras
event_security_camera_viewing_changed<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.SECURITY_CAMERA_VIEWING_CHANGED
    IsViewing<public>:logic
    CameraIndex<public>:int

# Signaled when the player reveal cinematic starts
event_player_reveal_status_changed<internal> := class<final>(event_payload):
    EventType<override>:event_type = event_type.PLAYER_REVEAL_STATUS_CHANGED
    Status<public>:logic
    PlayerToReveal<public>:amongus_player
