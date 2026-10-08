
using { /Fortnite.com/UI }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

using { Modules.TaskAssets.TransferData }


Make_stage_widget_transfer_data_upload<constructor><public>(InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_transfer_data_upload, StageController:stage_controller) := stage_widget_transfer_data_upload:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer

stage_widget_transfer_data_upload<public> := class(stage_widget):

    StageDevices<override>:TaskStages.stage_devices_transfer_data_upload

    WidgetProgressBar<private>:color_block = color_block:
        DefaultColor := MakeColorFromHex("9ae662")
        DefaultDesiredSize := vector2{X := 0.0, Y := 0.0}

    WidgetProgressBarBg<private>:color_block = color_block:
        DefaultColor := MakeColorFromHex("5d8b3c")
        DefaultDesiredSize := vector2{X := 0.0, Y := 0.0}

    WidgetBlackFilter<private>:color_block = color_block:
        DefaultColor := NamedColors.Black
        DefaultOpacity := 0.5

    WidgetFlashDrive<private>:texture_block = texture_block:
        DefaultImage := T_TransferData_FlashDrive

    WidgetTaskBackground<private>:texture_block = texture_block:
        DefaultImage := T_TransferData_1a
        
    WidgetUploadButton<private>:button_quiet = button_quiet{}
    
    WidgetRemoveFlashdriveButton<private>:button_quiet = button_quiet{}

    OnInit<override>():void =
        
        WidgetUploadButton.SetText(StringToMsg("UPLOAD DATA"))
        Subscriptions.Add(WidgetUploadButton.OnClick().Subscribe(OnUploadButtonClick))

        WidgetRemoveFlashdriveButton.SetText(StringToMsg("REMOVE PEN DRIVE"))
        Subscriptions.Add(WidgetRemoveFlashdriveButton.OnClick().Subscribe(OnRemoveFlashdriveButtonClick))

        WidgetRemoveFlashdriveButton.SetEnabled(false)
        WidgetRemoveFlashdriveButton.SetVisibility(widget_visibility.Hidden)
        
        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    SizeToContent := false
                    Widget := WidgetBackShadow

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1495.0, Bottom := 1150.0}
                    Alignment := vector2{X := 0.5, Y := 1.0}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := canvas:
                        Slots := array:
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.330287, Y := 0.670919}, Maximum := vector2{X := 0.681235, Y := 0.698871}}
                                Alignment := vector2{X := 0.0, Y := 0.0}
                                SizeToContent := false
                                ZOrder := 2
                                Widget := WidgetProgressBarBg
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.330287, Y := 0.670919}, Maximum := vector2{X := 0.330287, Y := 0.670919}}
                                # Offsets := margin{Top := 0.0, Left := 0.0, Right := 50.0, Bottom := 50.0}
                                Alignment := vector2{X := 0.0, Y := 0.0}
                                SizeToContent := true
                                ZOrder := 3
                                Widget := WidgetProgressBar
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 1495.0, Bottom := 1150.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 4
                                Widget := WidgetTaskBackground
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.2157, Y := 0.213469}, Maximum := vector2{X := 0.784222, Y := 0.788269}}
                                # Offsets := margin{Top := 0.0, Left := 0.0, Right := 1495.0, Bottom := 1150.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 5
                                Widget := WidgetBlackFilter
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.39}, Maximum := vector2{X := 0.5, Y := 0.39}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 200.0, Bottom := 50.0}
                                SizeToContent := true
                                ZOrder := 6
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Widget := WidgetUploadButton
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.39}, Maximum := vector2{X := 0.5, Y := 0.39}}
                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 200.0, Bottom := 50.0}
                                SizeToContent := true
                                ZOrder := 6
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Widget := WidgetRemoveFlashdriveButton
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.776397, Y := 0.738412}, Maximum := vector2{X := 0.994943, Y := 0.83712}}
                                Offsets := margin{Top := 0.0, Left := 143.286499, Right := -143.286499, Bottom := 0.0}
                                ZOrder := 7
                                SizeToContent := false
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Widget := WidgetFlashDrive
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.356512, Y := 0.924105}, Maximum := vector2{X := 0.643421, Y := 0.974736}}
                                ZOrder := 8
                                SizeToContent := false
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                Widget := CreateExitButton()

    OnUploadButtonClick<private>(WidgetMessage:widget_message):void = 
        spawn:
            StartUpload()

    OnRemoveFlashdriveButtonClick<private>(WidgetMessage:widget_message):void = 
        WidgetTaskBackground.SetImage(T_TransferData_4)
        WidgetFlashDrive.SetVisibility(widget_visibility.Visible)
        WidgetRemoveFlashdriveButton.SetEnabled(false)
        WidgetRemoveFlashdriveButton.SetVisibility(widget_visibility.Hidden)

        spawn:
            SignalStageCompletedDelayed(1.0)

    StartUpload<private>()<suspends>:void = 
        race:
            TransferData()
            # StageEvents.EventPlayerFails.Await()
            # StageEvents.EventPlayerCompletes.Await()
            EventViewDestroyed.Await()

    TransferData<private>()<suspends>:void = 
        WidgetUploadButton.SetEnabled(false)
        WidgetUploadButton.SetVisibility(widget_visibility.Hidden)
        WidgetBlackFilter.SetVisibility(widget_visibility.Hidden)
        WidgetTaskBackground.SetImage(T_TransferData_1b)
        WidgetFlashDrive.SetVisibility(widget_visibility.Hidden)
        Sleep(0.2)

        TotalTime := 6.0
        TotalDivisions := 150
        
        TimeGap := TotalTime / (TotalDivisions*1.0)

        if(FrameChange1 := Floor[(TotalDivisions*0.3)], FrameChange2 := Floor[TotalDivisions*0.8]):
            for(X:=1..TotalDivisions):
                Width := 530.0*((X*1.0)/(TotalDivisions*1.0))
                WidgetProgressBar.SetDesiredSize(vector2{X:=Width, Y:=50.0})

                if(X=FrameChange1):
                    WidgetTaskBackground.SetImage(T_TransferData_2)
                else if(X=FrameChange2):
                    WidgetTaskBackground.SetImage(T_TransferData_3)

                Sleep(TimeGap)

        WidgetBlackFilter.SetVisibility(widget_visibility.Visible)      
        WidgetRemoveFlashdriveButton.SetEnabled(true)
        WidgetRemoveFlashdriveButton.SetVisibility(widget_visibility.Visible)

        StageDevices.SoundDataTransfered.Play(Player)
                    
        

        