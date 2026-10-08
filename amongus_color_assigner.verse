
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/Diagnostics }

amongus_color_provider<public> := interface:
    GetColor<public>(Agent:agent)<reads>:amongus_color
    # AssignColor<public>(Agent:agent, Color:amongus_color):void
    AssignColor<public>(Agent:agent, Number:int):amongus_color
    ShowColor<public>(Agent:agent):void
    HideColor<public>(Agent:agent):void

amongus_color_assigner<public> := class(creative_device, amongus_color_provider):

    # Used to remove current powerup
    @editable
    VfxClear<private>:visual_effect_powerup_device = visual_effect_powerup_device{}

    # Powerups
    @editable
    VfxPink<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxOrange<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxGreen<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxLime<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxPurple<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxRed<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxCyan<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxYellow<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxBrown<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxBlack<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxWhite<private>:visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable
    VfxBlue<private>:visual_effect_powerup_device = visual_effect_powerup_device{}

    var AmongusModels<private>:[amongus_color]visual_effect_powerup_device = map{}

    var PlayerColors<private>:[agent]amongus_color = map{}

    NumberToColor<private>:[int]amongus_color = map:
        1 => amongus_color.Yellow
        2 => amongus_color.White
        3 => amongus_color.Red
        4 => amongus_color.Purple
        5 => amongus_color.Pink
        6 => amongus_color.Orange
        7 => amongus_color.Lime
        8 => amongus_color.Green
        9 => amongus_color.Cyan
        10 => amongus_color.Brown
        11 => amongus_color.Blue
        12 => amongus_color.Black
    
    OnBegin<override>()<suspends>:void =
        set AmongusModels = map:
            amongus_color.Pink => VfxPink
            amongus_color.Orange => VfxOrange
            amongus_color.Green => VfxGreen
            amongus_color.Lime => VfxLime
            amongus_color.Purple => VfxPurple
            amongus_color.Red => VfxRed
            amongus_color.Cyan => VfxCyan
            amongus_color.Yellow => VfxYellow
            amongus_color.Brown => VfxBrown
            amongus_color.Black => VfxBlack
            amongus_color.White => VfxWhite
            amongus_color.Blue => VfxBlue

    AssignColor<override>(Agent:agent, Number:int):amongus_color =
        if(Color := NumberToColor[Number], set PlayerColors[Agent] = Color):
            Print("AssignColor: Number={Number} -> Color={Color}")
            return Color
        else:
            Print("AssignColor: Number={Number} -> FAILED (no color found)")
            amongus_color.None

    GetColor<override>(Agent:agent)<reads>:amongus_color = 
        PlayerColors[Agent] or amongus_color.None

    ShowColor<override>(Agent:agent):void =
        PlayerColor := PlayerColors[Agent] or amongus_color.None
        Print("ShowColor: PlayerColor={PlayerColor}, AmongusModels.Length={AmongusModels.Length}")
        if(Vfx := AmongusModels[PlayerColor]):
            Print("ShowColor: Found VFX for {PlayerColor}, calling Pickup")
            Vfx.Pickup(Agent)
        else:
            Print("ShowColor: No VFX found for {PlayerColor}, calling HideColor")
            HideColor(Agent)

    HideColor<override>(Agent:agent):void = 
        VfxClear.Pickup(Agent)


