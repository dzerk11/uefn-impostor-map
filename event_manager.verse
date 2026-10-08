
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }

using { ModuleTasks }

var EventManagers<internal>:weak_map(session, event_manager) = map{}

event_listener<internal> := interface<unique>:
    Update<internal>(EventPayload:event_payload):void


event_manager<internal> := class(creative_device):

    # Emits when sabotage status changes.
    #   isActive (logic): True if sabotage is active.
    #   task (task_name): The name of the affected sabotage task.
    SabotageStatusChanged:custom_subscribable(tuple(logic, task_name)) = custom_subscribable(tuple(logic, task_name)){}

    # Emits when an emergency meeting begins.
    #   player (player): The player that triggered the emergency meeting.
    # EmergencyMeetingStarted:custom_subscribable(void) = custom_subscribable(void){}
    
    # Emits when an emergency meeting ends.
    #   players ([]player): The players that got kicked during the emergency meeting.
    # EmergencyMeetingEnded:custom_subscribable([]player) = custom_subscribable([]player){}
    
    # Emits when all tasks gets cleared when an emergency meeting starts
    EmergencyMeetingTasksCleared:custom_subscribable(void) = custom_subscribable(void){}

    CriticalSabotageTimeout:event() = event(){}
    

    # event_listener = object that expect a notification for an event
    # event_type = type of event that customer is expecting to be notified to
    # ?player = if None, notify customer for all players, if player present notify only for that specific player
    var _listeners<private>:[]tuple(event_type, event_listener, ?player) = array{}

    Subscribe<internal>(EventType:event_type, Listener:event_listener):void = 
        Tuple:tuple(event_type, event_listener, ?player) = (EventType, Listener, false)
        set _listeners += array{Tuple}

    Subscribe<internal>(EventType:event_type, Listener:event_listener, PlayerRelated:player):void = 
        set _listeners += array{(EventType, Listener, option. PlayerRelated)}

    UnSubscribe<internal>(ListenerToRemove:event_listener):void =
        var NewListeners:[]tuple(event_type, event_listener, ?player) = array{}
        Print("_listeners pre: {_listeners.Length}")
        for(_ListenerTuple:_listeners, _ListenerTuple(1)<>ListenerToRemove):
            set NewListeners += array{_ListenerTuple}
        set _listeners = NewListeners
        Print("_listeners after: {_listeners.Length}")
    
    # Allows to notify all players that tracks that informations, filtered by players if required
    Notify<internal>(EventPayload:event_payload):void = 
        # Print("Notify {EventPayload.EventType}")
        for(Tuple:_listeners, EventPayload.EventType = Tuple(0)):
            if(Tuple(2)=false or Tuple(2)=EventPayload.Player):
                Tuple(1).Update(EventPayload)

    OnBegin<override>():void =
        if(set EventManagers[GetSession()] = Self){}


