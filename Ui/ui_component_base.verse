
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }

# Base component with automatic lifecycle management
ui_component_base<public> := class<abstract>(ui_component_interface):

    var Subscriptions<protected>:Utils.subscription_manager = Utils.subscription_manager{}
    var _isInitialized<private>:logic = false
    var _isDestroyed<private>:logic = false
    var<protected> Widget<public>:widget = canvas{}

    DestroyRequest<public>:custom_subscribable(ui_component_base) = custom_subscribable(ui_component_base){}
    
    # Safe initialization and cleanup
    Init<override><final>():void =
        # Print("Init component")
        if(not _isInitialized?):
            set _isInitialized = true
            OnInit()
    
    # Safe destruction
    Destroy<override><final>():void =
        # Print("Destroy component")
        if(not _isDestroyed?):
            set _isDestroyed = true
            OnDestroy()
            Subscriptions.CancelAll()

    # Lifecycle hooks - override these in derived classes
    OnInit<protected>():void =
        Print("OnInit not implemented in base class, should be overridden in derived classes")

    OnDestroy<protected>():void = 
        Print("OnDestroy not implemented in base class, should be overridden in derived classes")


    IsInitialized<override>()<decides><transacts>:void = _isInitialized?

    GetWidget<override>():widget = Widget


