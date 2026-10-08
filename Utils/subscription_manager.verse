
# Automatic subscription management
subscription_manager<public> := class:
    var _cancelables<private>:[]cancelable = array{}
    var _ccancelables<private>:[]custom_cancelable = array{}
    # var _event_cancelables<private>:[]Events.Watchables.event_cancelable = array{}
    
    Add<public>(Sub:cancelable):void =
        set _cancelables += array{Sub}
    
    # Add<public>(Sub:custom_cancelable, ?Dull:void={}):void =
    #     set _ccancelables += array{Sub}

    AddCancelable<public>(Sub:custom_cancelable):void =
        set _ccancelables += array{Sub}
        
    # Add<public>(Sub:Events.Watchables.event_cancelable, ?Dull:void={}, ?Dull2:void={}):void =
    #     set _event_cancelables += array{Sub}
    
    CancelAll<public>():void =
        for(Sub:_cancelables):
            Sub.Cancel()
        for(Sub:_ccancelables):
            Sub.Cancel()
        # for(Sub:_event_cancelables):
        #     Sub.Cancel()
        set _cancelables = array{}
        set _ccancelables = array{}
        # set _event_cancelables = array{}