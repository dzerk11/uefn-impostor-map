
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

MsgExit<localizes>: message = "EXIT"

Make_ui_widget_base_interactive<public><constructor>(InPlayer:player) := ui_widget_base_interactive:
    Make_ui_widget_base<constructor>(InPlayer, custom_logger{})

Make_ui_widget_base_interactive<public><constructor>(InPlayer:player, InLogger:custom_logger) := ui_widget_base_interactive:
    Make_ui_widget_base<constructor>(InPlayer, InLogger)


ui_widget_base_interactive<public> := class(ui_widget_base):

    # --------------- [ DATA ] ---------------

    var _InputMode<override>:ui_input_mode = ui_input_mode.All
    var _MaybeWidgetCloseButton<protected>:?button_quiet = false

    EventCloseButtonClicked<public>:custom_subscribable(player_widget_struct) = custom_subscribable(player_widget_struct){}



    # --------------- [ METHODS ] ---------------

    Hide<override>():void =
        (super:)Hide()
        _RemoveToPlayer()

    Destroy<override>():void = 
        (super:)Destroy()

    CreateExitButton<protected>():widget =
        CloseButton:button_quiet = button_quiet{}
        CloseButton.SetText(MsgExit)
        Self.AppendNewCancelable(CloseButton.OnClick().Subscribe(Self.OnCloseButtonClick))
        set Self._MaybeWidgetCloseButton = option{CloseButton}
        CloseButton
            
    OnCloseButtonClick<protected>(Message : widget_message):void = 
        SignalCloseButton()

    GetCloseButton<protected>()<transacts><decides>:button_quiet = 
        _MaybeWidgetCloseButton?

    SignalCloseButton<protected>():void = 
        Destroy()
        EventCloseButtonClicked.Signal(player_widget_struct{Widget:=Self, Player:=Self.Player})  
    