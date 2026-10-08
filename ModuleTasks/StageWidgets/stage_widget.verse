
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Fortnite.com/UI }

# Make_stage_widget<public><constructor>(InLogger:custom_logger, InPlayer:player, InTaskId:int, InStageId:int, InStageEvents:ModuleTasks.stage_events, InStageDevices:ModuleTasks.stage_devices) := stage_widget:
    # Make_ui_widget_base_interactive<constructor>(InPlayer, InTranslator, InLogger)
    # TaskId := InTaskId
    # StageId := InStageId
    # StageEvents := InStageEvents
    # StageDevices := InStageDevices

MsgCloseWidgetStage<localizes>:message = "CLOSE"

stage_widget<public> := class<abstract>(Ui.ui_view_verse):
    StageId<public>:int = -1
    StageDevices<public>:stage_devices
    StageController<public>: stage_controller

    ZOrder<override>:type {_X:int where 0 <= _X, _X <= 2147483647} = 10
    InputMode<override>:ui_input_mode = ui_input_mode.All

    WidgetBackShadow<protected>:color_block = color_block:
        DefaultColor := MakeColorFromHex("#1c1c1c")
        DefaultOpacity := 0.6

    SignalPlayerCompletes<protected>():void = 
        StageController.SignalPlayerCompletes(Player)

    SignalPlayerFails<protected>():void =
        StageController.SignalPlayerFails(Player)

    SignalPlayerReward<protected>(RewardType:Utils.award_type):void = 
        StageController.SignalPlayerReward(Player, RewardType)

    SignalStageCompletedDelayed<protected>(SleepTime:float)<suspends>:void = 
        Sleep(SleepTime)
        SignalPlayerCompletes()

    SignalStageFailedDelayed<protected>(SleepTime:float)<suspends>:void = 
        Sleep(SleepTime)
        SignalPlayerFails()

    CreateExitButton<protected>():widget =
        CloseButton:button_quiet = button_quiet{}
        CloseButton.SetText(MsgCloseWidgetStage)
        Subscriptions.Add(CloseButton.OnClick().Subscribe(Self.OnCloseButtonClick))
        CloseButton

    OnCloseButtonClick<protected>(WidgetMessage:widget_message):void = 
        SignalPlayerFails()
        # In case
        Self.Destroy()

    OnDestroy<override>():void = { Print("OnDestroy widget stage") }
    OnInit<override>():void = {}



    
