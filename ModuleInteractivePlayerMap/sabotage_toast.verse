
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { Modules.PlayerMap }

# MsgSabotageTimeLeft<internal><localizes>(Time:int):message = "{Time}s"
# MsgSabotageFix<internal><localizes>:message = "Fix the Sabotage"
# MsgSabotageFixIn<internal><localizes>(Time:int):message = "Fix the Sabotage in {Time}s"
# MsgSabotageActivated<internal><localizes>:message = "Sabotage Activated!"
# MsgSabotageActivatedWithTime<internal><localizes>(Time:int):message = "Sabotage Activated: {Time}s!"

# MsgSabotageOxygenDepletion<internal><localizes>:message = "O2 Flow Compromised"
# MsgSabotageReactorMeltdown<internal><localizes>:message = "Nuclear Core Overloading"
# MsgSabotageLightsOff<internal><localizes>:message = "Lighting Systems Down"
# MsgSabotageCommunications<internal><localizes>:message = "Communications Down"
# MsgSabotageDoorsLocked<internal><localizes>:message = "Doors locked"

sabotage_toast<internal> := class(Ui.ui_component_base):
    APlayer<internal>:amongus_player
    Sabotage<internal>:ModuleTasks.task_name
    TextSabotageTimeLeft<private>:text_block = text_block:
        DefaultTextColor := NamedColors.White
        DefaultText := MsgSabotageFix
        DefaultTextSize := 24.0

    OnInit<override>():void = 
        UpdateTimeLeft(0)

        set Widget = canvas:
                Slots := array:
                    # canvas_slot:
                    #     Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    #     ZOrder := 0
                    #     SizeToContent := false
                    #     Widget := wbp_toast_bg{}
        
                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.5}, Maximum := vector2{X := 1.0, Y := 0.5}}
                        Alignment := vector2{X := 1.0, Y := 0.5}
                        ZOrder := 0
                        Widget := stack_box:
                            Orientation := orientation.Horizontal
                            Slots := array:
        
                                # Pulsing icon
                                stack_box_slot:
                                    Padding := margin{Left := 16.0, Top := 16.0, Right := 12.0, Bottom := 16.0}
                                    HorizontalAlignment := horizontal_alignment.Fill
                                    VerticalAlignment := vertical_alignment.Center
                                    Widget := 
                                        overlay:
                                            Slots := array:
                                                overlay_slot:
                                                    Widget := WBP_SabotageActiveIcon{}
                                                overlay_slot:
                                                    Widget := texture_block:
                                                        DefaultDesiredSize := vector2{X:=46.0, Y:=46.0}
                                                        DefaultImage := Ui.GetTexture(Sabotage)
        
                                stack_box_slot:
                                    HorizontalAlignment := horizontal_alignment.Left
                                    VerticalAlignment := vertical_alignment.Center
                                    Widget := stack_box:
                                        Orientation := orientation.Vertical
                                        Slots := array:

                                            stack_box_slot:
                                                HorizontalAlignment := horizontal_alignment.Left
                                                VerticalAlignment := vertical_alignment.Center
                                                Widget := text_block:
                                                    DefaultTextSize := 1.0
                                                    DefaultTextColor := NamedColors.White
                                                    DefaultText := Ui.GetMsgSabotageName(Sabotage)

                                            stack_box_slot:
                                                HorizontalAlignment := horizontal_alignment.Left
                                                VerticalAlignment := vertical_alignment.Center
                                                Widget := TextSabotageTimeLeft

                                # stack_box_slot:
                                #     HorizontalAlignment := horizontal_alignment.Fill
                                #     VerticalAlignment := vertical_alignment.Center
                                #     Widget := if(PlayerRole = gameplay_role.Impostor){
                                #         wbp_toast_sabotage_impostors{}
                                #     } else {
                                #         # wbp_toast_sabotage_crewmates{}
                                #         if(Sabotage = ModuleTasks.task_name.SabotageReactorFail or Sabotage = ModuleTasks.task_name.SabotageO2):
                                #             text_block:
                                #                 DefaultText := MsgSabotageFixIn
                                #         else:
                                #             text_block:
                                #                 DefaultText := MsgSabotageFix
                                #     }
        
                                # stack_box_slot:
                                #     Padding := margin{Left := 6.0}
                                #     HorizontalAlignment := horizontal_alignment.Fill
                                #     VerticalAlignment := vertical_alignment.Center
                                #     Widget := TextSabotageTimeLeft
        
                                # stack_box_slot:
                                #     Padding := margin{Right := 16.0}
                                #     HorizontalAlignment := horizontal_alignment.Fill
                                #     VerticalAlignment := vertical_alignment.Center
                                #     Widget := text_block:
                                #         DefaultText := MsgEmpty 

    UpdateTimeLeft<public>(TimeLeft:int):void =
        if(APlayer.IsImpostor[]){
            if(Sabotage = ModuleTasks.task_name.SabotageReactorFail or Sabotage = ModuleTasks.task_name.SabotageO2):
                TextSabotageTimeLeft.SetText(MsgSabotageActivatedWithTime(TimeLeft))
            else:
                TextSabotageTimeLeft.SetText(MsgSabotageActivated)
        } else {
            if(Sabotage = ModuleTasks.task_name.SabotageReactorFail or Sabotage = ModuleTasks.task_name.SabotageO2):
                TextSabotageTimeLeft.SetText(MsgSabotageFixIn(TimeLeft))
            else:
                TextSabotageTimeLeft.SetText(MsgSabotageFix)
        }