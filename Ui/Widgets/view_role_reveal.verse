
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }

using { Art.WidgetBlueprints.RoleReveal }

Make_view_role_reveal<public><constructor>(APlayer:amongus_player) := view_role_reveal:
    APlayer := APlayer
    Player := APlayer.Player

view_role_reveal<public> := class(ui_view_verse):
    APlayer<public>:amongus_player
    InputMode<override>:ui_input_mode = ui_input_mode.None

    OnInit<override>():void = 
        RoleRevealWidget := wbp_role_reveal:
            CharacterIcon := GetCharacterIcon(APlayer.GetColor())
            StartAnimation := true
            IsImpostor := logic{APlayer.IsImpostor[]}

        set Widget = RoleRevealWidget

    OnDestroy<override>():void = {}