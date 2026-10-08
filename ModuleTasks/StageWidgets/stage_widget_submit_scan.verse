
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
using { /Verse.org }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }

using { ModuleTasks }
using { Modules.TaskAssets.SubmitScan }


Make_stage_widget_submit_scan<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_submit_scan, StageController:stage_controller) := stage_widget_submit_scan:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer
        

stage_widget_submit_scan<public> := class(stage_widget):

    TargetRotationRadians<private>:float = 0.0

    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_submit_scan

    var SubmitScanWidget<private>:WBP_SubmitScan = WBP_SubmitScan{}

    OnInit<override>():void =             
        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    ZOrder := 0
                    SizeToContent := false
                    Widget := WidgetBackShadow

                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    # Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    # Offsets := margin{Top := 0.0, Left := 100.0, Right := 560.0, Bottom := 700.0}
                    # Alignment := vector2{X := 0.0, Y := 0.5}
                    SizeToContent := false
                    Widget := SubmitScanWidget

                canvas_slot:
                    ZOrder := 2
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 100.0, Right := 560.0, Bottom := 700.0}
                    Alignment := vector2{X := 0.0, Y := 0.5}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array:

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                                Offsets := margin{Top := -64.0, Left := 0.0, Right := 250.0, Bottom := 64.0}
                                Alignment := vector2{X := 0.5, Y := 1.0}
                                SizeToContent := false
                                Widget := CreateExitButton()          

    HandleAnimation<public>()<suspends>:void = 
        StageDevices.Teleporter.Teleport(Self.Player)

        if (Character:fort_character = Self.Player.GetFortCharacter[], APlayer := GetAPlayer[Player]):
            StasysArgs:stasis_args = stasis_args:
                AllowTurning := false
                AllowFalling := true
                AllowEmotes := false
            
            Character.PutInStasis(StasysArgs)
            
            # Start cinematic
            StageDevices.CinematicSequence.Stop(Player)
            StageDevices.CinematicSequence.Play(Player)
            Sleep(0.001)
            StageDevices.CinematicSequence.Pause(Player)
            Sleep(2.0)
            StageDevices.CinematicSequence.Play(Player)

            # Start writing
            Sleep(1.0)
            set SubmitScanWidget.Dots = StringToMsg(".")
            set SubmitScanWidget.PlayerName = Ui.AgentToMsg(Self.Player)
            Sleep(2.0)
            set SubmitScanWidget.Dots = StringToMsg(". .")
            set SubmitScanWidget.PlayerColor = Ui.GetMsgAmongusColor(APlayer.GetColor())
            Sleep(2.0)
            set SubmitScanWidget.Dots = StringToMsg(". . .")
            set SubmitScanWidget.PlayerRole = if(APlayer.IsImpostor[]):
                Ui.MsgRoleImpostor
            else:
                Ui.MsgRoleCrewmate
            Sleep(8.0)

            SignalPlayerCompletes()

    ClearAnimation<public>():void =
        if (Character:fort_character = Self.Player.GetFortCharacter[]):
            Character.ReleaseFromStasis()
        StageDevices.CinematicSequence.Stop(Self.Player)
