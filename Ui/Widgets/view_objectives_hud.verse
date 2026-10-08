
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }

using { ModuleTasks }
using { Modules.ObjectivesHud }

MsgTasksQuantity<internal><localizes>(Completed:int, Total:int):message = "{Completed}/{Total}"

Make_view_objectives_hud<public><constructor>(APlayer:amongus_player, TaskManager:task_manager, SabotageManager:sabotage_manager, EventManager:event_manager) := view_objectives_hud:
    APlayer := APlayer
    Player := APlayer.Player
    TaskManager := TaskManager
    SabotageManager := SabotageManager
    EventManager := EventManager

view_objectives_hud<public> := class(Ui.ui_view_verse, event_listener):
    InputMode<override>:ui_input_mode = ui_input_mode.None
    ZOrder<override>:type {_X:int where 0 <= _X, _X <= 2147483647} = 5

    APlayer<public>:amongus_player
    TaskManager<public>:task_manager
    SabotageManager<public>:sabotage_manager
    EventManager<public>:event_manager

    var TasksCompleted<private>:int = 0
    var TasksToComplete<private>:int = 0

    var ObjectivesWidgetTasks<private>:[task_name]WBP_ObjectiveElement = map{}
    ObjectivesWidgetSabotage<private>:WBP_ObjectiveElementSabotage = WBP_ObjectiveElementSabotage{}
    StackBoxElements<private>:stack_box = stack_box:
        Orientation := orientation.Vertical

    WidgetStageCompleted<private>:WBP_StageAdvanced = WBP_StageAdvanced{}

    OnInit<override>():void =
        # Subscribe to events
        EventManager.Subscribe(event_type.TASK_COMPLETION, Self)
        EventManager.Subscribe(event_type.SABOTAGE_STATUS_CHANGED, Self)
        EventManager.Subscribe(event_type.TASK_STARTED, Self, Player)
        EventManager.Subscribe(event_type.STAGE_ENDED, Self, Player)
        EventManager.Subscribe(event_type.SECURITY_CAMERA_VIEWING_CHANGED, Self, Player)

        # Initilaze sabotage stats
        if(ActiveSabotage := SabotageManager.GetActiveSabotage[]):
            UpdateSabotageStats(ActiveSabotage.Name)
            ObjectivesWidgetSabotage.SetVisibility(widget_visibility.Visible)
        else:
            ObjectivesWidgetSabotage.SetVisibility(widget_visibility.Collapsed)

        StackBoxElements.AddWidget(stack_box_slot{
            HorizontalAlignment := horizontal_alignment.Fill
            Padding := margin{Top := 4.0, Bottom := 4.0}
            Widget := ObjectivesWidgetSabotage})

        StackBoxElements.AddWidget(stack_box_slot{
            HorizontalAlignment := horizontal_alignment.Fill
            Padding := margin{Top := 4.0, Bottom := 4.0}
            Widget := WidgetStageCompleted
        })

        WidgetStageCompleted.SetVisibility(widget_visibility.Collapsed)

        # Initialize task stats
        UpdateTaskStats(TaskManager.GetPlayerTasksInfo(Player))

        # Set the widget
        set Widget = canvas:
            Slots := array:
                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum:=vector2{X:=0.0, Y:=0.0}, Maximum:=vector2{X:=0.0, Y:=0.0}}
                    Offsets := margin{Left := 32.0, Top := 200.0, Right := 380.0, Bottom := 500.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent := false
                    Widget := StackBoxElements
                        # stack_box:
                        # Orientation := orientation.Vertical
                        # Slots := array{
                        #     stack_box_slot:
                        #         Padding := margin{Top := 0.0, Bottom := 8.0}
                        #         Widget := ObjectivesWidgetSabotage
                        # } + for(Widgett:ObjectivesWidgetTasks):
                        #     stack_box_slot:
                        #         Padding := margin{Top := 4.0, Bottom := 4.0}
                        #         Widget := Widgett

    OnDestroy<override>():void =
        EventManager.UnSubscribe(Self)

    Update<override>(EventPayload:event_payload):void =
        case(EventPayload.EventType):
            event_type.PLAYER_TASK_LIST =>
                if(Payload := event_player_task_list[EventPayload]):
                    UpdateTaskStats(Payload.Data)
            event_type.TASK_COMPLETION =>
                if(Payload := event_task_completion[EventPayload]):
                    UpdateTaskStats(TaskManager.GetPlayerTasksInfo(Player))
                    spawn{AAA()}
            event_type.SABOTAGE_STATUS_CHANGED =>
                if(Payload := event_sabotage_status[EventPayload]):
                    if(Payload.SabotageStatus?):
                        UpdateSabotageStats(Payload.SabotageName)
                        ObjectivesWidgetSabotage.SetVisibility(widget_visibility.Visible)
                    else:
                        ObjectivesWidgetSabotage.SetVisibility(widget_visibility.Collapsed)
            event_type.TASK_STARTED =>
                if(Payload := event_task_started[EventPayload]):
                    if(Payload.HideHudOnStart?):
                        Hide()
            event_type.STAGE_ENDED =>
                if(Payload := event_stage_ended[EventPayload]):
                    if(Payload.HideHudOnStart?):
                        Show()
            event_type.SECURITY_CAMERA_VIEWING_CHANGED =>
                if(Payload := event_security_camera_viewing_changed[EventPayload]):
                    if(Payload.IsViewing?):
                        Hide()
                    else:
                        Show()
            # event_type.EMERGENCY_MEETING_STATUS =>
            #     if(Payload := event_emergency_meeting_status[EventPayload]):
            #         if(Payload.Status?):
            #             Hide()
            #         else:
            #             Show()
            _ =>

    UpdateTaskStats<private>(TasksInfo:[]task_info):void =
        for(TaskInfo:TasksInfo):
            if(Widgett := ObjectivesWidgetTasks[TaskInfo.TaskName]):
                set Widgett.StagesCompleted = TaskInfo.GetStagesCompleted().Length
                set Widgett.StagesToComplete = TaskInfo.StagesInfo.Length
                set Widgett.AreStageNumbersVisible = logic{TaskInfo.StagesInfo.Length > 1}

                if(TaskInfo.IsCompleted?):
                    Widgett.SetVisibility(widget_visibility.Collapsed)
            else:
                Widgett := WBP_ObjectiveElement:
                    Name := Ui.GetMsgTaskName(TaskInfo.TaskName)
                    Icon := GetMaterialIcon(TaskInfo.TaskName)
                    IsImpostor := logic{APlayer.IsImpostor[]}
                    StagesCompleted := TaskInfo.GetStagesCompleted().Length
                    StagesToComplete := TaskInfo.StagesInfo.Length
                    AreStageNumbersVisible := logic{TaskInfo.StagesInfo.Length > 1}
                if(set ObjectivesWidgetTasks[TaskInfo.TaskName] = Widgett):
                    StackBoxElements.AddWidget(stack_box_slot{
                        HorizontalAlignment := horizontal_alignment.Fill
                        Padding := margin{Top := 4.0, Bottom := 4.0}
                        Widget := Widgett})

    UpdateSabotageStats<private>(ActiveSabotage:task_name):void =
        set ObjectivesWidgetSabotage.Icon = GetMaterialIcon(ActiveSabotage)
        set ObjectivesWidgetSabotage.Name = Ui.GetMsgSabotageName(ActiveSabotage)
        
        MaybeStagesCompletion := SabotageManager.GetSabotageStagesCompletion(Player)
        if(StagesCompletion := MaybeStagesCompletion?, StagesCompletion(1)>1):
            set ObjectivesWidgetSabotage.AreStageNumbersVisible = true
            set ObjectivesWidgetSabotage.StagesCompleted = StagesCompletion(0)
            set ObjectivesWidgetSabotage.StagesToComplete = StagesCompletion(1)
        else:
            false

    AAA<private>()<suspends>:void = 
        WidgetStageCompleted.SetVisibility(widget_visibility.Visible)
        Sleep(3.0)
        WidgetStageCompleted.SetVisibility(widget_visibility.Collapsed)
