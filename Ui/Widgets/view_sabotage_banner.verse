
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }

using { Modules.SabotageTimeBar }
using { ModuleTasks }

Make_view_sabotage_banner<public><constructor>(APlayer:amongus_player, Sabotage:ModuleTasks.sabotage_basic) := view_sabotage_banner:
    Player := APlayer.Player
    Sabotage := Sabotage

view_sabotage_banner<public> := class(Ui.ui_view_verse):
    InputMode<override>:ui_input_mode = ui_input_mode.None
    ZOrder<override>:type {_X:int where 0 <= _X, _X <= 2147483647} = 7

    Sabotage<public>:ModuleTasks.sabotage_basic

    var WidgetBanner<internal>:WBP_Sabotage = WBP_Sabotage{}

    OnInit<override>():void =
        set WidgetBanner.StartAnimation = true
        set Widget = WidgetBanner

    OnDestroy<override>():void = {}

    # Update the banner with new time and bar width values
    UpdateBanner<public>(TimeLeft:int):void =
        set WidgetBanner.TimeLeft = TimeLeft
        if(TimeLeft <= 5):
            set WidgetBanner.StartCooldown = true