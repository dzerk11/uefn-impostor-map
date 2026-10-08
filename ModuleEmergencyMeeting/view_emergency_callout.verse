
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }

using { Modules.EmergencyMeeting }

Make_view_emergency_callout<public><constructor>(APlayer:amongus_player, IsBodyReported:logic) := view_emergency_callout:
    APlayer := APlayer
    Player := APlayer.Player
    IsBodyReported := IsBodyReported

view_emergency_callout<public> := class(Ui.ui_view_verse):
    APlayer<public>:amongus_player
    InputMode<override>:ui_input_mode = ui_input_mode.All
    IsBodyReported<public>:logic

    OnInit<override>():void = 
        Banner := wbp_emergency_meeting_banner:
            StartAnimation := true
            IsBodyReported := IsBodyReported
        set Widget = Banner

    OnDestroy<override>():void = {}