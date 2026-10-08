# using { /Fortnite.com }
using { /Fortnite.com/UI }
# using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using {/Verse.org/Random}
using { /UnrealEngine.com/Temporary/Diagnostics }

using { Modules.TaskAssets.PassCode }

Make_stage_widget_pass_code<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_pass_code, StageController:stage_controller) := stage_widget_pass_code:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer

    let:
        var TempPassCode :[]int = array{}
    block:
        PassCodeLength := 4
        for(X:=0..PassCodeLength):
            Digit := GetRandomInt(1, 9)
            set TempPassCode += array{Digit}

    PassCodeTarget := TempPassCode

    WidgetButton1 := button_quiet:
        DefaultText:=StringToMsg("1")
    WidgetButton2 := button_quiet:
        DefaultText:=StringToMsg("2")
    WidgetButton3 := button_quiet:
        DefaultText:=StringToMsg("3")
    WidgetButton4 := button_quiet:
        DefaultText:=StringToMsg("4")
    WidgetButton5 := button_quiet:
        DefaultText:=StringToMsg("5")
    WidgetButton6 := button_quiet:
        DefaultText:=StringToMsg("6")
    WidgetButton7 := button_quiet:
        DefaultText:=StringToMsg("7")
    WidgetButton8 := button_quiet:
        DefaultText:=StringToMsg("8")
    WidgetButton9 := button_quiet:
        DefaultText:=StringToMsg("9")

    WidgetPassCode := text_block:
        DefaultJustification := text_justification.Center
    WidgetPassCodeInserted := text_block:
        DefaultJustification := text_justification.Center
    

stage_widget_pass_code<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_pass_code

    PassCodeTarget<internal>:[]int = array{}

    var PassCodeInserted<private>:[]int = array{}

    WidgetBackground<private>:texture_block = texture_block:
        DefaultImage := T_passCode_background
        DefaultDesiredSize := vector2{X := 1300.0, Y := 1000.0}

    WidgetButton1<internal>:button_quiet = button_quiet{}
    WidgetButton2<internal>:button_quiet = button_quiet{}
    WidgetButton3<internal>:button_quiet = button_quiet{}
    WidgetButton4<internal>:button_quiet = button_quiet{}
    WidgetButton5<internal>:button_quiet = button_quiet{}
    WidgetButton6<internal>:button_quiet = button_quiet{}
    WidgetButton7<internal>:button_quiet = button_quiet{}
    WidgetButton8<internal>:button_quiet = button_quiet{}
    WidgetButton9<internal>:button_quiet = button_quiet{}

    WidgetPassCode<public>:text_block
    WidgetPassCodeInserted<public>:text_block

    WidgetButtonErase<internal>:button_quiet = button_quiet{}

    OnInit<override>():void =
        Subscriptions.Add(WidgetButton1.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 1))
        Subscriptions.Add(WidgetButton2.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 2))
        Subscriptions.Add(WidgetButton3.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 3))
        Subscriptions.Add(WidgetButton4.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 4))
        Subscriptions.Add(WidgetButton5.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 5))
        Subscriptions.Add(WidgetButton6.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 6))
        Subscriptions.Add(WidgetButton7.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 7))
        Subscriptions.Add(WidgetButton8.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 8))
        Subscriptions.Add(WidgetButton9.OnClick().SubscribeWidgetMessage(OnNumpadButtonClick, 9))
        Subscriptions.Add(WidgetButtonErase.OnClick().Subscribe(OnEraseButtonClick))

        # WidgetPassCode.SetText(StringToMsg("{Self._Translator.GetText(ModuleLanguage.text_reference.hud_passCode_description, _Player)} {PassCodeTarget.Join(" ")}."))
        # WidgetPassCode.SetText(StringToMsg("{Self._Translator.GetText(ModuleLanguage.text_reference.hud_passCode_description, _Player)} {PassCodeTarget.Join(" ")}."))

        WidgetPassCode.SetText(StringToMsg("{Self.PassCodeTarget.Join(" ")}"))
        WidgetPassCodeInserted.SetText(PassCodeToMessage(PassCodeInserted))

        WidgetButtonErase.SetText(StringToMsg("Erase"))
        
        X1 := 0.378805
        X2 := 0.504
        X3 := 0.63412

        Y1 := 0.467151
        Y2 := 0.599954
        Y3 := 0.729441

        NumpadButtonWidth := 110.0
        NumpadButtonHeight := 90.0

        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    SizeToContent := false
                    Widget := WidgetBackShadow
                
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1100.0, Bottom := 907.07692307}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := canvas:
                        Slots := array: 

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                # Offsets := margin{Top := 0.0, Left := 0.0, Right := 1300.0, Bottom := 1072.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 1
                                Widget := Self.WidgetBackground

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X1, Y := Y1}, Maximum := vector2{X := X1, Y := Y1}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton1

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X2, Y := Y1}, Maximum := vector2{X := X2, Y := Y1}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton2

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X3, Y := Y1}, Maximum := vector2{X := X3, Y := Y1}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton3

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X1, Y := Y2}, Maximum := vector2{X := X1, Y := Y2}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton4

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X2, Y := Y2}, Maximum := vector2{X := X2, Y := Y2}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton5

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X3, Y := Y2}, Maximum := vector2{X := X3, Y := Y2}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton6

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X1, Y := Y3}, Maximum := vector2{X := X1, Y := Y3}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton7

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X2, Y := Y3}, Maximum := vector2{X := X2, Y := Y3}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton8

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := X3, Y := Y3}, Maximum := vector2{X := X3, Y := Y3}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := NumpadButtonWidth, Bottom := NumpadButtonHeight}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := Self.WidgetButton9

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.4145, Y := 0.849164}, Maximum := vector2{X := 0.4145, Y := 0.849164}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 190.0, Bottom := 70.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := WidgetButtonErase

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.603607, Y := 0.849164}, Maximum := vector2{X := 0.603607, Y := 0.849164}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 190.0, Bottom := 70.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := CreateExitButton()

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.499384, Y := 0.255123}, Maximum := vector2{X := 0.499384, Y := 0.255123}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 556.796814, Bottom := 50.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := text_block:
                                    DefaultJustification := text_justification.Center
                                    DefaultText := StringToMsg("Repeat The Following Code:")

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.41839, Y := 0.309041}, Maximum := vector2{X := 0.41839, Y := 0.309041}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 165.0, Bottom := 50.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := WidgetPassCode

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.58161, Y := 0.309041}, Maximum := vector2{X := 0.58161, Y := 0.309041}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 165.0, Bottom := 50.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := WidgetPassCodeInserted

    OnNumpadButtonClick<private>(WidgetMessage:widget_message, Number:int):void =
        UpdatePassCodeInserted(Number)
        CheckPassCode()

    OnEraseButtonClick<private>(WidgetMessage:widget_message):void =
        set PassCodeInserted = array{}
        WidgetPassCodeInserted.SetText(PassCodeToMessage(PassCodeInserted))

    SetInsertedPassCodeToDefault<private>():void =
        set PassCodeInserted += array{}
        WidgetPassCodeInserted.SetText(PassCodeToMessage(PassCodeInserted))

    UpdatePassCodeInserted<private>(Number:int):void = 
        if(Self.PassCodeInserted.Length<5):
            set PassCodeInserted += array{Number}
            WidgetPassCodeInserted.SetText(PassCodeToMessage(PassCodeInserted))

    PassCodeToMessage<private>(Code:[]int):message =
        var StringToReturn:string = ""
        set StringToReturn += Code.Join(" ")

        for(X:=0..(5-Code.Length-1)):
            set StringToReturn += " _ "

        StringToMsg(StringToReturn)

    CheckPassCode<private>():void =
        if(Self.PassCodeInserted = Self.PassCodeTarget):
            SignalPlayerCompletes()
        else if(Self.PassCodeInserted.Length>=Self.PassCodeTarget.Length):
            SignalPlayerFails()

    