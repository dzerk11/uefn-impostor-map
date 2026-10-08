
using { /Verse.org/Concurrency }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_custom_subscribable := class(log_channel){}

custom_cancelable<public> := class<unique>:
    var Canceled : logic = false

    CancelEvent : event() = event(){}

    Cancel():void =
        set Canceled = true
        CancelEvent.Signal()

custom_subscribable<public>(t:type) := class<public>(awaitable(t)):

    InnerEvent : event(t) = event(t){}

    Logger<private>:log = log{Channel:=log_custom_subscribable}

    Subscribe(Callback:type {__(:t):void}, CancelAfterUsage:logic):custom_cancelable=
        Cancelable := custom_cancelable{}
        spawn{_WaitForEvent(Callback, Cancelable, CancelAfterUsage)}

        Cancelable

    _WaitForEvent(Callback:type {__(:t):void}, Cancelable: custom_cancelable, CancelAfterUsage:logic)<suspends>:void=
        race:
            # Wait for payload to be sent
            loop:
                Payload := InnerEvent.Await()

                # Just in case
                if(not Cancelable.Canceled?):
                    Callback((Payload))
                    if(CancelAfterUsage?):
                        Logger.Debug("Removing thread")
                        break
                else:
                    break # Just in case


            # Cancelable got canceled
            Cancelable.CancelEvent.Await()

    
    Signal<public>(Payload:t):void =
        InnerEvent.Signal(Payload)

    Await<override>()<suspends>:t=
        InnerEvent.Await()

custom_subscribable_empty<public> := class<public>(awaitable()):

    InnerEvent : event() = event(){}

    Subscribe(Callback:type {__():void}):custom_cancelable=
        Cancelable := custom_cancelable{}
        spawn{_WaitForEvent(Callback, Cancelable)}

        Cancelable

    _WaitForEvent(Callback:type {__():void}, Cancelable: custom_cancelable)<suspends>:void=
        race:
            # Wait for payload to be sent
            loop:
                Payload := InnerEvent.Await()

                # Just in case
                if(not Cancelable.Canceled?):
                    Callback(Payload)
                else:
                    break # Just in case

            # Cancelable got canceled
            Cancelable.CancelEvent.Await()

    
    Signal<public>():void =
        InnerEvent.Signal()

    Await<override>()<suspends>:void=
        InnerEvent.Await()







