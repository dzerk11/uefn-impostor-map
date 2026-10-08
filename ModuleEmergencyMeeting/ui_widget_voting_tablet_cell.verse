
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }

using { Modules.EmergencyMeeting }


Make_ui_widget_voting_tablet_cell<constructor><internal>(PlayerData:emergency_meeting_participant) := ui_widget_voting_tablet_cell:
    PlayerData := PlayerData

ui_widget_voting_tablet_cell<internal> := class(Ui.ui_component_base):
    PlayerData<internal>:emergency_meeting_participant

    WidgetVotingDone<private>:material_block = material_block:
        DefaultImage := m_vote_done

    WidgetButton<private>:button_quiet = button_quiet:

    WidgetPlayerImage<internal>:texture_block = texture_block:
        DefaultImage := Art.Textures.Icons.ACharacters.T_chGreen

    WidgetPlayerName<private>:text_block = text_block:
        DefaultTextColor := NamedColors.White
        DefaultOverflowPolicy := text_overflow_policy.Ellipsis

    IconPlayerEliminated<private>:widget = wbp_icon_player_eliminated{}
        
    var WidgetVotes<private>:[]stack_box_slot = array{}

    StackBoxVotesReceived<private>:stack_box = stack_box:
        Orientation := orientation.Horizontal

    var CurrentVotes<private>:int = 0
    
    OnInit<override>():void = 
        WidgetPlayerName.SetText(Ui.AgentToMsg(PlayerData.APlayer.Player))
        WidgetPlayerImage.SetImage(GetCharacterIcon(PlayerData.APlayer.GetColor()))

        IconPlayerEliminated.SetVisibility(widget_visibility.Collapsed)

        WidgetVotingDone.SetVisibility(widget_visibility.Collapsed)

        # if(IsMyself?):
        #     WidgetPlayerName.SetTextColor(NamedColors.SeaGreen)

        # CreateHiddenVotes
        # for(X:=0..4):
        #     Slot := stack_box_slot:
        #         Padding := margin{Top := 5.0, Left := 5.0, Right := 5.0, Bottom := 5.0}
        #         Widget := texture_block:
        #             DefaultImage := Art.Textures.Icons.T_EmergencyMeeting_Cell_Cross
        #     Slot.Widget.SetVisibility(widget_visibility.Collapsed)

        #     set WidgetVotes += array{Slot}

        set Widget = canvas:
            Slots := array:
                canvas_slot:
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 480.0, Bottom := 120.0}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array:

                            # Background portrait
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                SizeToContent := false
                                ZOrder := 0
                                Widget := wbp_emergency_meeting_cell{}

                            # Player icon
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Offsets := margin{Top := 0.0, Left := 90.0, Right := 100.0, Bottom := 100.0}
                                SizeToContent := false
                                ZOrder := 1
                                Widget := WidgetPlayerImage

                            # Player icon eliminated
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Offsets := margin{Top := 0.0, Left := 90.0, Right := 100.0, Bottom := 100.0}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := IconPlayerEliminated

                            # Button over image
                            canvas_slot:
                                 Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Offsets := margin{Top := 0.0, Left := 90.0, Right := 110.0, Bottom := 90.0}
                                SizeToContent := false
                                ZOrder := 3
                                Widget := WidgetButton

                            # Player name
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.367675, Y := 0.33}, Maximum := vector2{X := 0.367675, Y := 0.33}}
                                # Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                Alignment := vector2{X := 0.0, Y := 0.5}
                                SizeToContent := true
                                Widget := WidgetPlayerName
                                ZOrder := 1

                            # Player strikes
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.367675, Y := 0.66}, Maximum := vector2{X := 0.367675, Y := 0.66}}
                                Alignment := vector2{X := 0.0, Y := 0.5}
                                Offsets := margin{Top := 10.0, Left := 0.0}
                                SizeToContent := true
                                ZOrder := 1
                                Widget := StackBoxVotesReceived

                            # Player vote done
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 1.0, Y := 1.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                Alignment := vector2{X := 1.0, Y := 1.0}
                                Offsets := margin{Top := -10.0, Left := -10.0, Right := 32.0, Bottom := 32.0}
                                SizeToContent := false
                                Widget := WidgetVotingDone
                                ZOrder := 1

    GetWidgetButton<public>():button_quiet = 
        return WidgetButton

    DisableButton<public>():void =
        WidgetButton.SetVisibility(widget_visibility.Hidden)
        WidgetButton.SetEnabled(false)

    EnableButton<public>():void = 
        Self.WidgetButton.SetVisibility(widget_visibility.Visible)
        Self.WidgetButton.SetEnabled(true)
    
    SetIsVotable<internal>(Logic:logic):void =
        if(Logic?):
            WidgetButton.SetEnabled(true)
            WidgetButton.SetVisibility(widget_visibility.Visible)
            IconPlayerEliminated.SetVisibility(widget_visibility.Collapsed)
        else:
            WidgetButton.SetEnabled(false)
            WidgetButton.SetVisibility(widget_visibility.Hidden)
            IconPlayerEliminated.SetVisibility(widget_visibility.Visible)

    SetVotingDone<internal>(State:logic):void =
        if(State?):
            WidgetVotingDone.SetVisibility(widget_visibility.Visible)
        else:
            WidgetVotingDone.SetVisibility(widget_visibility.Hidden)

    SetVotes<internal>(VotesReceived:int):void = 
        if(VotesReceived > WidgetVotes.Length):
            for(X := 0..(VotesReceived-WidgetVotes.Length - 1)):
                Slot := stack_box_slot:
                    Widget := material_block:
                        DefaultImage := m_vote

                set WidgetVotes += array{Slot}
                StackBoxVotesReceived.AddWidget(Slot)

        else:
            for(X := VotesReceived..WidgetVotes.Length-1, Slot := WidgetVotes[X], NewSlots := WidgetVotes.RemoveElement[X]):
                set WidgetVotes = NewSlots
                StackBoxVotesReceived.RemoveWidget(Slot.Widget)

