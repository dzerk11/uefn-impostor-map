
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using {/Verse.org/Random}
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { Modules.TaskAssets.ReactorNumbers }

MsgCloseButtonX<public><localizes>:message = "X"

Make_stage_widget_reactor_numbers<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_reactor_numbers, StageController:stage_controller) := stage_widget_reactor_numbers:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer


stage_widget_reactor_numbers<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_reactor_numbers
    OrderedNumbers<private>:[]int = array{1,2,3,4,5,6,7,8,9,10}

    var ButtonTuples<private>:[]tuple(int, button_quiet, texture_block) = array{}
    var IndexLastNumberClicked<private>:int = -1
    CCloseButton<private>:button_loud = button_loud:
        DefaultText := MsgCloseButtonX

    OnInit<override>():void =
        Numbers := Shuffle(OrderedNumbers)
        
        for(Index->Number:Numbers):
            Button := button_quiet:
                DefaultText := StringToMsg("{Number}")
            Tuple := (
                Number,
                Button, 
                texture_block:
                    DefaultImage := Art.Textures.T_RoundedButton
            )
            Subscriptions.Add(Button.OnClick().SubscribeWidgetMessage(OnNumberButtonClick, Tuple))
            set ButtonTuples += array{Tuple}

        var ButtonSlots:[]stack_box_slot = array{}
        var StartSlice:int = 0

        Subscriptions.Add(CCloseButton.OnClick().Subscribe(OnCloseButtonClick))

        loop:
            EndSlice := StartSlice+5
            if(Sliced := ButtonTuples.Slice[StartSlice, EndSlice]):
                set StartSlice = EndSlice
                set ButtonSlots += array:   
                    stack_box_slot:
                        VerticalAlignment := vertical_alignment.Fill
                        HorizontalAlignment := horizontal_alignment.Fill
                        Distribution := option{1.0}
                        # Padding := margin{Top:=20.0, Left:=5.0, Right:=5.0, Bottom:=20.0}
                        Widget := stack_box:
                            Orientation := orientation.Horizontal
                            Slots := for(Element:Sliced):
                                Slot := stack_box_slot:
                                    VerticalAlignment := vertical_alignment.Fill
                                    HorizontalAlignment := horizontal_alignment.Fill
                                    Distribution := option{1.0}
                                    Padding := margin{Top:=28.0, Left:=28.0, Right:=28.0, Bottom:=28.0}
                                    Widget := canvas:
                                        Slots := array:
                                            canvas_slot:
                                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 110.0, Bottom := 110.0}
                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                ZOrder := 0
                                                SizeToContent := false
                                                Widget := canvas:
                                                    Slots := array:
                                                        canvas_slot:
                                                            Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                                            ZOrder := 0
                                                            Widget := Element(2)
                                                        # canvas_slot:
                                                        #     Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                                        #     Offsets := margin{Top := -1.0, Left := -1.0, Right := -1.0, Bottom := -1.0}
                                                        #     SizeToContent := false
                                                        #     ZOrder := 1
                                                        #     Widget := texture_block:
                                                        #         DefaultImage := Art.Textures.T_RoundedButton_Border3px
                                                        canvas_slot:
                                                            Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                                            ZOrder := 2
                                                            Widget := Element(1)
            else:
                break


        set Widget = canvas:
            Slots := array:
                canvas_slot:
                    ZOrder := 0
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    Widget := WBP_ReactorNumbers{}
                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1400.0, Bottom := 560.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array: 

                            canvas_slot:
                                ZOrder := 0
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := true
                                Widget := stack_box:
                                    Orientation := orientation.Vertical
                                    Slots := ButtonSlots

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 0.0}}
                                Offsets := margin{Top := 64.0, Left := -64.0, Right := 100.0, Bottom := 100.0}
                                Alignment := vector2{X := 1.0, Y := 0.0}
                                SizeToContent := false
                                ZOrder := 0
                                Widget := canvas:
                                    Slots := array:

                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                            SizeToContent := false
                                            Widget := CCloseButton
                                                    
    Show<override>():void = 
        (super:)Show()
        Task := spawn:
            HandleCinematic()

    Hide<override>():void =
        StageDevices.CSQ_Background.Stop(Player)
        (super:)Hide()
        
    HandleCinematic<private>()<suspends>:void = 
        if:
            FNCharacter := Player.GetFortCharacter[]
            Translation := FNCharacter.GetTransform().Translation
        then:
            StageDevices.CSQ_Background.SetPlaybackFrame(0)
            StageDevices.CSQ_Background.Play(Player)
            Widget.SetVisibility(widget_visibility.Hidden)
            sync:
                block:
                    Sleep(3.0)
                    StageDevices.CSQ_Background.Pause(Player)
                block:
                    Sleep(2.5)
                    Widget.SetVisibility(widget_visibility.Visible)
       
    OnNumberButtonClick<private>(WidgetMessage:widget_message, Tuple:tuple(int, button_quiet, texture_block)):void = 
        spawn:
            OnNumberButtonClickHandler(WidgetMessage, Tuple)

    OnNumberButtonClickHandler<private>(WidgetMessage:widget_message, Tuple:tuple(int, button_quiet, texture_block))<suspends>:void = 
        if(OrderedNumbers[IndexLastNumberClicked+1]=Tuple(0)):
            set IndexLastNumberClicked += 1
            Tuple(2).SetTint(MakeColorFromHex("#00ff00"))

            if(OrderedNumbers[IndexLastNumberClicked]=OrderedNumbers[OrderedNumbers.Length-1]):
                # if(CloseButton := GetCloseButton[], ParentCanvas := CloseButton.GetParentWidget[]):
                #     ParentCanvas.SetEnabled(false)
                # for(ButtonTuple:ButtonTuples, ParentCanvas := ButtonTuple(1).GetParentWidget[]):
                #     ParentCanvas.SetEnabled(false)
                SignalStageCompletedDelayed(0.5)

        else:
            Tuple(2).SetTint(MakeColorFromHex("#ff0000"))

            # if(CloseButton := GetCloseButton[], ParentCanvas := CloseButton.GetParentWidget[]):
            #     ParentCanvas.SetEnabled(false)
            # for(ButtonTuple:ButtonTuples, ParentCanvas := ButtonTuple(1).GetParentWidget[]):
            #     ParentCanvas.SetEnabled(false)
            
            SignalStageFailedDelayed(1.0)

