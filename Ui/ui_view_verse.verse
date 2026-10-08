

using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }

ui_view_verse<public> := class<abstract>(ui_view_interface):
    Player<public>:player

    EventViewDestroyed<public>:custom_subscribable(ui_view_interface) = custom_subscribable(ui_view_interface){}
    EventViewCloseRequested<public>:custom_subscribable(ui_view_verse) = custom_subscribable(ui_view_verse){}
    EventViewShown<public>:custom_subscribable(ui_view_interface) = custom_subscribable(ui_view_interface){}
    EventViewHidden<public>:custom_subscribable(ui_view_interface) = custom_subscribable(ui_view_interface){}

    Subscriptions<protected>:Utils.subscription_manager = Utils.subscription_manager{}
    var _IsInitialized<private>:logic = false
    var _IsVisible<private>:logic = false
    
    InputMode<public>:ui_input_mode = ui_input_mode.None
    ZOrder<protected>:type {_X:int where 0 <= _X, _X <= 2147483647} = 10
    var Widget<protected>:widget = canvas{}

    Init<override>():void = 
        OnInit()
        set _IsInitialized = true

    Show<override>():void = 
        if(not IsInitialized[]):
            Init()
        if(IsInitialized[], not IsVisible[], PlayerUI := GetPlayerUI[Self.Player]):
            PlayerUI.AddWidget(Widget, player_ui_slot{InputMode:=Self.InputMode, ZOrder:=ZOrder})
            Widget.SetVisibility(widget_visibility.Visible)
            Widget.SetEnabled(true)
            set _IsVisible = true
            EventViewShown.Signal(Self)

    Hide<override>():void =
        Widget.SetVisibility(widget_visibility.Collapsed)
        set _IsVisible = false
        EventViewHidden.Signal(Self)

    Destroy<override><final>():void = 
        if(_IsInitialized?, PlayerUI := GetPlayerUI[Self.Player]):
            set _IsInitialized = false
            Hide()
            PlayerUI.RemoveWidget(Widget)
            OnDestroy()
            Subscriptions.CancelAll()
            EventViewDestroyed.Signal(Self)

    # Lifecycle hooks - override these in derived classes
    OnInit<protected>():void
    OnDestroy<protected>():void

    IsVisible<override>()<transacts><decides>:void =
        _IsVisible?

    IsInitialized<override>()<transacts><decides>:void =
        _IsInitialized?

    




    # var Subscriptions<protected>:subscription_manager = subscription_manager{}
    # var _isInitialized<private>:logic = false
    # var _isDestroyed<private>:logic = false
    # var<protected> Widget<public>:canvas = canvas{}

    # DestroyRequest<public>:csub(ui_component_base) = csub(ui_component_base){}
    
    # # Safe initialization and cleanup - final methods
    # Init<override><final>():void =
    #     Print("Init component")
    #     if(not _isInitialized?):
    #         set _isInitialized = true
    #         OnInit()
    
    # Destroy<override><final>():void =
    #     Print("Destroy component")
    #     if(not _isDestroyed?):
    #         set _isDestroyed = true
    #         OnDestroy()
    #         Subscriptions.CancelAll()

    # # Lifecycle hooks - override these in derived classes
    # OnInit<protected>():void
    # OnDestroy<protected>():void

    # IsInitialized<override>()<decides><transacts>:void = _isInitialized?

