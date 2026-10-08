
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { ModuleLanguage }
using { Modules.EmergencyMeeting }
using { EmergencyMeeting }

MsgEmConfirmVote<localizes>:message = "CONFIRM VOTE"
MsgEmCloseTablet<localizes>:message = "CLOSE"
MsgEmSkipVote<localizes>:message = "Skip"
MsgEmTabletTitle<localizes>:message = "EMERGENCY MEETING: Vote for a suspect!"
MsgEmTabletTitleVoted<localizes>:message = "EMERGENCY MEETING: Suspect voted, well done."
MsgEmTabletTimeLeft<localizes>(Value:int):message = "{Value}"


log_ui_widget_voting_tablet := class(log_channel){}


Make_ui_widget_voting_tablet<internal><constructor>(Logger:log, APlayer:amongus_player, EmergencyMeetingDevice:emergency_meeting_device) := ui_widget_voting_tablet:
    Logger := Logger
    APlayer := APlayer
    Player := APlayer.Player
    EmergencyMeetingDevice := EmergencyMeetingDevice


ui_widget_voting_tablet<internal> := class(Ui.ui_view_verse):
    InputMode<override>:ui_input_mode = ui_input_mode.All
    Logger<internal>:log
    APlayer<internal>:amongus_player
    EmergencyMeetingDevice<internal>:emergency_meeting_device

    BgButtonConfirmVote<private>:wbp_emergency_meeting_confirm_vote_red = wbp_emergency_meeting_confirm_vote_red{}

    ButtonConfirmVote<private>:button_quiet = button_quiet:
        DefaultText := MsgEmConfirmVote

    ButtonExit<private>:button_quiet = button_quiet:
        DefaultText := MsgEmCloseTablet

    LabelTimeLeft<private>:text_block = text_block:
        DefaultJustification := text_justification.Right
        DefaultTextColor := MakeColorFromHex("#FFF")

    CellsContainer<private>:stack_box = stack_box:
        Orientation := orientation.Vertical
        
    var MaybeSelectedCell<private>:?ui_widget_voting_tablet_cell = false
    var Cells<private>:[player]ui_widget_voting_tablet_cell = map{}
    var CellsTemp<private>:[]ui_widget_voting_tablet_cell = array{}

    OnInit<override>():void = 
        # Set subscriptions
        Subscriptions.Add(ButtonConfirmVote.OnClick().Subscribe(OnButtonConfirmVoteClick))
        Subscriptions.Add(ButtonExit.OnClick().Subscribe(OnExitClick))

        # Default hidden
        # ButtonConfirmVote.SetEnabled(false)
        BgButtonConfirmVote.SetVisibility(widget_visibility.Hidden)

        UpdateTimeLeft(EmergencyMeetingDevice.GetTimeLeft())
        SetCells(EmergencyMeetingDevice.Participants)

        set Widget = canvas:
            Slots := array:

                # Shadow
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := color_block:
                        DefaultColor := MakeColorFromHex("#1c1c1c")
                        DefaultOpacity := 0.6

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1800.0, Bottom := 1000.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := canvas:
                        Slots := array:
                            # Tablet bg
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                # Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 0
                                Widget := wbp_emergency_meeting{}

                            # Time left
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.873322, Y := 0.152576}, Maximum := vector2{X := 0.873322, Y := 0.152576}}
                                Offsets := margin{Top := 0.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := true
                                ZOrder := 2
                                Widget := LabelTimeLeft

                            # Vote button
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                                Offsets := margin{Left := -350.0, Top := -120.0, Right := 600.0, Bottom := 70.0}
                                Alignment := vector2{X := 0.5, Y := 1.0}
                                SizeToContent := false
                                ZOrder := 1
                                Widget := BgButtonConfirmVote

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                                Offsets := margin{Left := -350.0, Top := -120.0, Right := 600.0, Bottom := 70.0}
                                Alignment := vector2{X := 0.5, Y := 1.0}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := ButtonConfirmVote

                            # Exit button
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                                Offsets := margin{Left := 350.0, Top := -120.0, Right := 600.0, Bottom := 70.0}
                                Alignment := vector2{X := 0.5, Y := 1.0}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := ButtonExit

                            # Cells container
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.24}, Maximum := vector2{X := 0.5, Y := 0.24}}
                                Offsets := margin{Top := 0.0, Left := 6.0, Right := 1500.0, Bottom := 550.0}
                                Alignment := vector2{X := 0.5, Y := 0.0}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := CellsContainer
                                        

    OnDestroy<override>():void = {}

    OnButtonConfirmVoteClick<private>(WidgetMessage:widget_message):void =
        # Ghosts can view the tablet but cannot vote
        if(APlayer.IsGhost?):
            return
        if(SelectedCell := MaybeSelectedCell?):
            EmergencyMeetingDevice.OnPlayerVote(APlayer.Player, SelectedCell.PlayerData.APlayer.Player)

            for(Cell:CellsTemp):
                Cell.DisableButton()

            # ButtonConfirmVote.SetEnabled(false)

    SetVotes<internal>(PlayerVoted:player, TimesVoted:int):void = 
        if(Cell:=Cells[PlayerVoted]):
            Cell.SetVotes(TimesVoted)

    SetCells<internal>(PlayersData:[]emergency_meeting_participant):void = 
        var Rows:[]stack_box = array{}
        var CurrentRow:stack_box = stack_box:
            Orientation := orientation.Horizontal
        var CurrentRowSlots:[]stack_box_slot = array{}
        var CellsInCurrentRow:int = 0
        
        # Create cells and organize them into rows
        for(PlayerData:PlayersData):
            # for(X := 0..7):
                Cell := Make_ui_widget_voting_tablet_cell(PlayerData)
                Cell.Init()
                Cell.SetIsVotable(PlayerData.CanBeVoted)
                Cell.SetVotes(PlayerData.VotesReceived.Length)
                Cell.SetVotingDone(logic{PlayerData.HasVoted?})
                if(set Cells[PlayerData.APlayer.Player] = Cell):
                    Subscriptions.Add(Cell.GetWidgetButton().OnClick().SubscribeWidgetMessage(OnButtonCellClick, Cell))

                
                
                # Add cell to current row
                CellSlot := stack_box_slot:
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Distribution := option{1.0}
                    Padding := margin{Top := 5.0, Left := 5.0, Right := 5.0, Bottom := 5.0}
                    Widget := Cell.Widget
                
                set CurrentRowSlots += array{CellSlot}
                set CellsInCurrentRow += 1
                
                # Check if we need to start a new row (max 3 cells per row)
                if(CellsInCurrentRow >= 3):
                    # Finalize current row
                    set CurrentRow = stack_box:
                        Orientation := orientation.Horizontal
                        Slots := CurrentRowSlots
                    
                    set Rows += array{CurrentRow}
                    
                    # Reset for next row
                    set CurrentRowSlots = array{}
                    set CellsInCurrentRow = 0
        
        # Add remaining cells if any
        if(CellsInCurrentRow > 0):
            set CurrentRow = stack_box:
                Orientation := orientation.Horizontal
                Slots := CurrentRowSlots
            
            set Rows += array{CurrentRow}
        
        # Create row slots for the main container
        var RowSlots:[]stack_box_slot = array{}
        for(Row:Rows):
            RowSlot := stack_box_slot:
                HorizontalAlignment := horizontal_alignment.Left
                VerticalAlignment := vertical_alignment.Top
                Distribution := option{1.0}
                # Padding := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                Widget := Row
            
            set RowSlots += array{RowSlot}

            CellsContainer.AddWidget(RowSlot)

    OnButtonCellClick<private>(WidgetMessage:widget_message, Cell:ui_widget_voting_tablet_cell):void =
        # Ghosts can view the tablet but cannot select cells
        if(APlayer.IsGhost?):
            return

        if(LastClickedCell := MaybeSelectedCell?):
            LastClickedCell.EnableButton()

        Cell.DisableButton()
        set MaybeSelectedCell = option{Cell}

        # _ButtonConfirmVote.SetVisibility(widget_visibility.Visible)
        # ButtonConfirmVote.SetEnabled(true)
        BgButtonConfirmVote.SetVisibility(widget_visibility.Visible)

    # _OnButtonSkipVoteClick<private>(WidgetMessage:widget_message):void = 
    #     Print("skip vote")

    # SetVotes<public>(PlayersVoted:[int]int):void = 
    #     for(TargetPlayerId->VotesReceived:PlayersVoted):
    #         Print("{TargetPlayerId} -> {VotesReceived}")
    #         if(PlayerCell := Self.Cells[TargetPlayerId]):
    #             PlayerCell.SetVotes(VotesReceived)

    SetVotingDone<public>(PlayerWhoVoted:player, State:logic):void =
        if(Cell := Cells[PlayerWhoVoted]):
            Cell.SetVotingDone(State)

    UpdateTimeLeft<public>(Time:int):void = 
        LabelTimeLeft.SetText(MsgEmTabletTimeLeft(Time))

    OnExitClick<private>(WidgetMessage:widget_message):void = 
        Self.Destroy()


    
    
    