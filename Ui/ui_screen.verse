

using { /Verse.org/Simulation }

Make_ui_screen<public><constructor>(InPlayer:player, InLogger:custom_logger) := ui_screen:
    Player := InPlayer
    Logger := InLogger


ui_screen<public> := class<unique>(event_listener):

    Logger<public>:custom_logger = custom_logger{}
    Player<public>:player
    # ScreenType<public>:ui_screen_type = ui_screen_type.NONE

    EventScreenDestroied<public>:custom_subscribable(ui_screen) = custom_subscribable(ui_screen){}
    EventScreenShowed<public>:custom_subscribable(ui_screen) = custom_subscribable(ui_screen){}
    EventScreenHided<public>:custom_subscribable(ui_screen) = custom_subscribable(ui_screen){}

    var _Cancelables<protected>:[]cancelable = array{}
    var _IsInitialized<private>:logic = false
    var _IsVisible<private>:logic = false

    Init<public>():void = 
        set _IsInitialized = true

    Show<public>():void = 
        if(not IsInitialized[]):
            Init()
        if(IsInitialized[], not _IsVisible?):
            set _IsVisible = true
            EventScreenShowed.Signal(Self)

    Hide<public>():void =
        set _IsVisible = false
        # if(EventManager := EventManagers[GetSession()]):
        #     EventManager.UnSubscribe(Self)
        EventScreenHided.Signal(Self)

    Destroy<public>():void = 
        if:
            _IsInitialized?
        then:
            set _IsInitialized = false
            Hide()
            _CancelSubscriptions()
            EventScreenDestroied.Signal(Self)
            # Print("Widget destroied")

    IsVisible<public>()<transacts><decides>:void =
        _IsVisible?

    IsInitialized<public>()<transacts><decides>:void =
        _IsInitialized?

    Update<override>(EventPayload:event_payload):void = {}


    # Cancel every subscription, used before Destroy
    _CancelSubscriptions<protected>():void = 
        for(Cancelable:_Cancelables):
            Cancelable.Cancel()
        if(EventManager := EventManagers[GetSession()]):
            EventManager.UnSubscribe(Self)

    SetSubscriptions<protected>():void = {}

    AppendNewCancelable<protected>(Cancelable:cancelable):void = 
        set Self._Cancelables += array{Cancelable}




