
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }

using {Modules.EmergencyMeeting}

Make_view_time_left<internal><constructor>(AmongusPlayer:amongus_player) := view_time_left:
    Player := AmongusPlayer.Player

view_time_left<internal> := class(Ui.ui_view_verse):
    View<private>:WBP_CountdownEmergencyMeeting = WBP_CountdownEmergencyMeeting{}

    OnInit<override>():void = 
        set Widget = View  

    OnDestroy<override>():void = {}

    UpdateTime<public>(N:int):void = 
        set View.SecondsLeft = N


    
    
    