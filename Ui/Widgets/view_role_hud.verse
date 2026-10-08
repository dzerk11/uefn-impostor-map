
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }

Make_view_role_hud<public><constructor>(APlayer:amongus_player) := view_role_hud:
    APlayer := APlayer
    Player := APlayer.Player

view_role_hud<public> := class(Ui.ui_view_verse):
    InputMode<override>:ui_input_mode = ui_input_mode.None
    ZOrder<override>:type {_X:int where 0 <= _X, _X <= 2147483647} = 5
    APlayer<public>:amongus_player

    OnInit<override>():void =
        set Widget = Art.WidgetBlueprints.WBP_Role:
            IsImpostor := logic{APlayer.IsImpostor[]}
            PlayerIcon := GetCharacterIcon(APlayer.GetColor())

    OnDestroy<override>():void = {}
