
using { /Fortnite.com/UI }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }

using { Modules.TaskAssets.DivertPower }

Make_stage_widget_divert_power<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_divert_power, StageController:stage_controller) := stage_widget_divert_power:
    StageDevices := InStageDevices
    Player := InPlayer
    StageController := StageController


stage_widget_divert_power_led_button := class:
    var State:logic = false
    Offsets:margin

    TextureBlock:texture_block = texture_block:
        DefaultImage := T_DivertPower1_LedOff
        DefaultDesiredSize := vector2{X:=120.0, Y:=120.0}

    SetState(Value:logic):void = 
        set Self.State = Value
        if(Value?):
            TextureBlock.SetImage(T_DivertPower_LedOn)
        else:
            TextureBlock.SetImage(T_DivertPower1_LedOff)


stage_widget_divert_power<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_divert_power
    InputMode<override>:ui_input_mode = ui_input_mode.None

    var Buttons<private>:[int]stage_widget_divert_power_led_button = map{}
    
    OnDestroy<override>():void = 
        StageDevices.PopupButtons.Hide(Player)

        # ReleaseFromStasis
        if(FNCharacter := Player.GetFortCharacter[]):
            FNCharacter.ReleaseFromStasis()

    OnInit<override>():void =
        Subscriptions.Add(StageDevices.PopupButtons.RespondingButtonEvent.Subscribe(OnClick))

        set Buttons = map:
            0 => stage_widget_divert_power_led_button{Offsets := margin{Left := 461.239227, Top := 80.0}}
            1 => stage_widget_divert_power_led_button{Offsets := margin{Left := 461.239227, Top := 220.0}}
            2 => stage_widget_divert_power_led_button{Offsets := margin{Left := 460.0, Top := 360.0}}
            3 => stage_widget_divert_power_led_button{Offsets := margin{Left := 460.0, Top := 500.0}}
            4 => stage_widget_divert_power_led_button{Offsets := margin{Left := 988.0, Top := 80.0}}
            5 => stage_widget_divert_power_led_button{Offsets := margin{Left := 988.0, Top := 220.0}}
            6 => stage_widget_divert_power_led_button{Offsets := margin{Left := 988.0, Top := 364.0}}
            7 => stage_widget_divert_power_led_button{Offsets := margin{Left := 988.0, Top := 500.0}}
        
        for(Button:Buttons):
            Button.SetState(true)

        # Freeze player
        StasysArgs:stasis_args = stasis_args:
            AllowTurning := false
            AllowFalling := false
            AllowEmotes := false
        if(FNCharacter := Player.GetFortCharacter[]):
            FNCharacter.PutInStasis(StasysArgs)

        TmpArray := Shuffle(for(Index->Button:Buttons){Index})
        if(Button:=Buttons[TmpArray[0]]):
            Button.SetState(false)

        StageDevices.PopupButtons.Show(Player)

        set Widget = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := WBP_DivertPower1{}

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Bottom := 700.0, Right := 1200.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := canvas:
                        Slots := for(Button:Buttons):
                            canvas_slot:
                                Offsets := Button.Offsets
                                Widget := Button.TextureBlock

    CheckCompletion<private>()<decides><transacts>:void =
        for(Button:Buttons):
            Button.State?

    OnClick<private>(Agent:agent, ButtonIndex:int):void = 
        Print("premuto l'indice {ButtonIndex}")
        if(EAgent := player[Agent], Player = EAgent):
            if(ButtonIndex = 11):
                SignalPlayerFails()

            else if(Button := Buttons[ButtonIndex]):
                Button.SetState(true)
                if(CheckCompletion[]):
                    SignalPlayerCompletes()
                    StageDevices.PopupButtons.Hide(Player)
                else:
                    spawn{ShowPopup()}
            
            else:
                spawn{ShowPopup()}

    ShowPopup<private>()<suspends>:void = 
        StageDevices.PopupButtons.Hide(Player)
        StageDevices.PopupButtons.Show(Player)
        Sleep(0.01)
        StageDevices.PopupButtons.Show(Player)
       
