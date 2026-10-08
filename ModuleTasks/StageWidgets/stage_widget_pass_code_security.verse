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

MsgEraseButton<localizes>:message = "Erase"
MsgNumber0<localizes>:message = "0"
MsgNumber1<localizes>:message = "1"
MsgNumber2<localizes>:message = "2"
MsgNumber3<localizes>:message = "3"
MsgNumber4<localizes>:message = "4"
MsgNumber5<localizes>:message = "5"
MsgNumber6<localizes>:message = "6"
MsgNumber7<localizes>:message = "7"
MsgNumber8<localizes>:message = "8"
MsgNumber9<localizes>:message = "9"

Make_stage_widget_pass_code_security<constructor><public>(InLogger:log, InPlayer:player, InStageDevices:ModuleTasks.TaskStages.stage_devices_pass_code_security, StageController:stage_controller) := stage_widget_pass_code_security:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer

stage_widget_pass_code_security<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_pass_code_security

    var PassCodeTarget<private>:string = ""
    var PassCodeInserted<private>:string = ""

    WidgetPasscode<private>:WBP_Passcode3 = WBP_Passcode3{}
        # Digit1 := a1
    #     Digit2 := T_SegmentNumber_0
    #     Digit3 := T_SegmentNumber_0
    #     Digit4 := T_SegmentNumber_0
    #     Digit5 := T_SegmentNumber_0

    WidgetButtonErase<internal>:button_quiet = button_quiet:
        DefaultText := MsgEraseButton

    WidgetButton1<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber1
    WidgetButton2<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber2
    WidgetButton3<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber3
    WidgetButton4<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber4
    WidgetButton5<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber5
    WidgetButton6<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber6
    WidgetButton7<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber7
    WidgetButton8<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber8
    WidgetButton9<internal>:button_quiet = button_quiet:
        DefaultText := MsgNumber9

    WidgetDigit1<private>:texture_block = texture_block:
        DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}
        DefaultImage := Art.Textures.T_Transparent
        DefaultTint := MakeColorFromHex("2BFF00FF")
    WidgetDigit2<private>:texture_block = texture_block:
        DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}
        DefaultImage := Art.Textures.T_Transparent
        DefaultTint := MakeColorFromHex("2BFF00FF")
    WidgetDigit3<private>:texture_block = texture_block:
        DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}
        DefaultImage := Art.Textures.T_Transparent
        DefaultTint := MakeColorFromHex("2BFF00FF")
    WidgetDigit4<private>:texture_block = texture_block:
        DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}
        DefaultImage := Art.Textures.T_Transparent
        DefaultTint := MakeColorFromHex("2BFF00FF")
    WidgetDigit5<private>:texture_block = texture_block:
        DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}
        DefaultImage := Art.Textures.T_Transparent
        DefaultTint := MakeColorFromHex("2BFF00FF")
        
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

        for(X:=0..4):
            Digit := GetRandomInt(1, 9)
            set PassCodeTarget += "{Digit}"
        
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
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := WidgetPasscode
                
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1100.0, Bottom := 907.07692307}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := canvas:
                        Slots := array: 
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                Offsets := margin{Left := 0.0, Top := -199.437195}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := true
                                ZOrder := 2
                                Widget := stack_box:
                                    Orientation := orientation.Horizontal
                                    Slots := array:
                                        stack_box_slot:
                                            # SizeRule := size_rule.Fill
                                            # SizeValue := 1.0
                                            Widget := WidgetDigit1
                                        stack_box_slot:
                                            # SizeRule := size_rule.Fill
                                            # SizeValue := 1.0
                                            Widget := WidgetDigit2
                                        stack_box_slot:
                                            # SizeRule := size_rule.Fill
                                            # SizeValue := 1.0
                                            Widget := WidgetDigit3
                                        stack_box_slot:
                                            # SizeRule := size_rule.Fill
                                            # SizeValue := 1.0
                                            Widget := WidgetDigit4
                                        stack_box_slot:
                                            # SizeRule := size_rule.Fill
                                            # SizeValue := 1.0
                                            Widget := WidgetDigit5

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

        spawn:
            ShowPassCode()


    ShowPassCode<private>()<suspends>:void = 
        WritePasscode(PassCodeTarget)
        WidgetButton1.SetEnabled(false)
        WidgetButton2.SetEnabled(false)
        WidgetButton3.SetEnabled(false)
        WidgetButton4.SetEnabled(false)
        WidgetButton5.SetEnabled(false)
        WidgetButton6.SetEnabled(false)
        WidgetButton7.SetEnabled(false)
        WidgetButton8.SetEnabled(false)
        WidgetButton9.SetEnabled(false)
        WidgetButtonErase.SetEnabled(false)
        Sleep(2.5)
        SetInsertedPassCodeToDefault()
        WidgetButton1.SetEnabled(true)
        WidgetButton2.SetEnabled(true)
        WidgetButton3.SetEnabled(true)
        WidgetButton4.SetEnabled(true)
        WidgetButton5.SetEnabled(true)
        WidgetButton6.SetEnabled(true)
        WidgetButton7.SetEnabled(true)
        WidgetButton8.SetEnabled(true)
        WidgetButton9.SetEnabled(true)
        WidgetButtonErase.SetEnabled(true)

    OnNumpadButtonClick<private>(WidgetMessage:widget_message, Number:int):void = 
        UpdatePassCodeInserted(Number)
        CheckPassCode()

    OnEraseButtonClick<private>(WidgetMessage:widget_message):void = 
        set PassCodeInserted = ""
        WritePasscode("")

    SetInsertedPassCodeToDefault<private>():void =
        set PassCodeInserted = ""
        WritePasscode("")

    UpdatePassCodeInserted<private>(Number:int):void = 
        if(Self.PassCodeInserted.Length<5):
            set PassCodeInserted += "{Number}"
            WritePasscode(PassCodeInserted)

    CheckPassCode<private>():void =
        if(Self.PassCodeInserted = Self.PassCodeTarget):
            SignalPlayerCompletes()

    WritePasscode<private>(Passcode:string):void =
        ClearTextDisplay()
        if(Passcode.Length > 0):
            if(Ch1 := Passcode[0]):
                WidgetDigit1.SetImage(GetSegmentForInt(GetIntForChar(Ch1)))
        if(Passcode.Length > 1):
            if(Ch2 := Passcode[1]):
                WidgetDigit2.SetImage(GetSegmentForInt(GetIntForChar(Ch2)))
        if(Passcode.Length > 2):
            if(Ch3 := Passcode[2]):
                WidgetDigit3.SetImage(GetSegmentForInt(GetIntForChar(Ch3)))
        if(Passcode.Length > 3):
            if(Ch4 := Passcode[3]):
                WidgetDigit4.SetImage(GetSegmentForInt(GetIntForChar(Ch4)))
        if(Passcode.Length > 4):
            if(Ch5 := Passcode[4]):
                WidgetDigit5.SetImage(GetSegmentForInt(GetIntForChar(Ch5)))

    ClearTextDisplay<private>():void =  
        WidgetDigit1.SetImage(GetSegmentForInt(-1))
        WidgetDigit2.SetImage(GetSegmentForInt(-1))
        WidgetDigit3.SetImage(GetSegmentForInt(-1))
        WidgetDigit4.SetImage(GetSegmentForInt(-1))
        WidgetDigit5.SetImage(GetSegmentForInt(-1))
        set WidgetPasscode.Digit1 = Art.Textures.T_Transparent
        set WidgetPasscode.Digit2 = Art.Textures.T_Transparent
        set WidgetPasscode.Digit3 = Art.Textures.T_Transparent
        set WidgetPasscode.Digit4 = Art.Textures.T_Transparent
        set WidgetPasscode.Digit5 = Art.Textures.T_Transparent

    GetSegmentForInt<private>(Number:int):texture =
        case(Number):
            0 => T_SegmentNumber_0
            1 => T_SegmentNumber_1
            2 => T_SegmentNumber_2
            3 => T_SegmentNumber_3
            4 => T_SegmentNumber_4
            5 => T_SegmentNumber_5
            6 => T_SegmentNumber_6
            7 => T_SegmentNumber_7
            8 => T_SegmentNumber_8
            9 => T_SegmentNumber_9
            _ => Art.Textures.T_Transparent

    GetIntForChar<private>(Char:char):int =
        case(Char):
            '0' => 0
            '1' => 1
            '2' => 2
            '3' => 3
            '4' => 4
            '5' => 5
            '6' => 6
            '7' => 7
            '8' => 8
            '9' => 9
            _ => 0
        

    