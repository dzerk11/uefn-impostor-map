
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }

tasks_bar_log := class(log_channel){}

tasks_bar<public> := class(creative_device, event_listener, lifecycle):
    Logger<private>:log = log{Channel:=tasks_bar_log, DefaultLevel:=log_level.Debug}

    @editable EventManager<private>:event_manager = event_manager{}
    # @editable HMD_TaskBar<public>:hud_message_device = hud_message_device{}
    @editable CSD_TaskBar<private>:cinematic_sequence_device = cinematic_sequence_device{}

    OnBegin<override>():void = 
        EventManager.Subscribe(event_type.TASK_COMPLETION, Self)
        EventManager.Subscribe(event_type.EMERGENCY_MEETING_STATUS, Self)
        # HMD_TaskBar.SetDisplayTime(0.0)

    Init<override>():void = {}
        # _EventManager.Subscribe(event_type.TASK_COMPLETION, Self)
        # HMD_TaskBar.SetDisplayTime(0.0)

    Dispose<override>():void = 
        # HMD_TaskBar.Hide()
        CSD_TaskBar.Stop()

    Update<override>(EventPayload:event_payload):void = 
        case(EventPayload.EventType):
            event_type.TASK_COMPLETION => 
                if(Payload := event_task_completion[EventPayload]):
                    UpdateValue(Payload.StagesCompleted, Payload.StagesCompletable)
            event_type.EMERGENCY_MEETING_STATUS => 
                if(Payload := event_emergency_meeting_status[EventPayload]):
                    if(Payload.Status?):
                        Hide()
                    else:
                        Show()
            _ =>

    UpdateValue<private>(StagesCompleted:int, StagesCompletable:int):void =
        FloatValue := (StagesCompleted*1.0)/(StagesCompletable*1.0)
        spawn:
            UpdateValueBar(FloatValue)
            
        # spawn:
        #     UpdateText(StagesCompleted, StagesCompletable)

    UpdateValueBar<private>(Value:float)<suspends>:void = 
        FrameTarget := 479.0*Value
        if(Frame := Floor[FrameTarget]):
            CSD_TaskBar.Play()
            CSD_TaskBar.SetPlaybackFrame(Frame)
            Sleep(0.0001)
            CSD_TaskBar.Pause()

    # UpdateText<private>(StagesCompleted:int, StagesCompletable:int)<suspends>:void = 
    #     HMD_TaskBar.SetText(StringToMsg("{StagesCompleted} / {StagesCompletable}"))

    # MakePlayerUiScreen<public>(Player:player):Ui.ui_screen_message_device = 
    #     Ui.ui_screen_message_device:
    #         HudMessageDevice := HMD_TaskBar
    #         Player := Player
    #         ScreenType := Ui.ui_screen_type.TASKBAR


