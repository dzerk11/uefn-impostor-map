
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Random }
using { /Fortnite.com/UI }

security_camera_devices<public> := struct<concrete>:
    @editable
    SequencerCameraMotion<public>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable
    SequencerCameraView<public>:cinematic_sequence_device = cinematic_sequence_device{}


security_camera_manager<public> := class(creative_device):

    Logger<private>:custom_logger = custom_logger{}
    @editable
    EventManager<private>:event_manager = event_manager{}

    @editable
    CameraDevices<public>:[]security_camera_devices = array:
        security_camera_devices{}
        security_camera_devices{}
        security_camera_devices{}

    @editable 
    SecurityCameraButton<private>:button_device = button_device{}

    var PlayerCurrentIndex<private>:[player]int = map{}
    var PlayerWidgets<private>:[player]?Ui.Widgets.view_security_cam_view = map{}

    OnBegin<override>()<suspends>:void =
        SecurityCameraButton.InteractedWithEvent.Subscribe(OnButtonPressed)
        for(Sc:CameraDevices):
            Sc.SequencerCameraMotion.Play()

    OnButtonPressed<private>(Agent:agent):void =
        if(Player := player[Agent]):
            Show(Player)

    Show<public>(Player:player, ?CameraIndex:int = -1):void =
        # If already viewing, switch camera
        if(Widget := PlayerWidgets[Player]?):
            if(CameraIndex >= 0):
                SwitchCamera(Player, CameraIndex)
            return

        # Determine which camera to show
        var IndexToShow:int = CameraIndex
        if(CameraIndex < 0):
            if(CurrentIndex := PlayerCurrentIndex[Player]):
                set IndexToShow = CurrentIndex
            else:
                set IndexToShow = GetRandomInt(0, CameraDevices.Length - 1)

        # Hide HUD
        Self.GetPlayspace().GetHUDController().HideElementsForPlayer(Player, array{
            creative_hud_identifier_all{}
        })

        # Start camera view
        if(CameraObj := CameraDevices[IndexToShow], set PlayerCurrentIndex[Player] = IndexToShow):
            CameraObj.SequencerCameraView.Play(Player)

            # Create and show widget
            NewWidget := Ui.Widgets.Make_ui_widget_security_cam_view(Player, Logger, OnCloseRequested, OnCameraChangeRequested)

            if(set PlayerWidgets[Player] = option{NewWidget}):
                NewWidget.Show()

                # Signal that player started viewing
                EventManager.Notify(event_security_camera_viewing_changed{
                    Player := option{Player}
                    IsViewing := true
                    CameraIndex := IndexToShow
                })

    HideAll<public>():void =
        for(Player->Widget:PlayerWidgets, Widget?):
            Hide(Player)

    Hide<public>(Player:player):void =
        if(Widget := PlayerWidgets[Player]?):
            # Stop all cameras
            for(CameraObject:CameraDevices):
                CameraObject.SequencerCameraView.Stop(Player)

            Widget.Destroy()

            if(set PlayerWidgets[Player] = false){}

            # Reset HUD
            Self.GetPlayspace().GetHUDController().ResetElementsForPlayer(Player, array{
                creative_hud_identifier_all{}
            })

            # Signal that player stopped viewing
            if(CurrentIndex := PlayerCurrentIndex[Player]):
                EventManager.Notify(event_security_camera_viewing_changed{
                    Player := option{Player}
                    IsViewing := false
                    CameraIndex := CurrentIndex
                })

    OnCloseRequested<private>(ClosedBy:tuple(player, Ui.Widgets.view_security_cam_view)):void =
        Hide(ClosedBy(0))

    OnCameraChangeRequested<private>(Player:player, CameraDirection:logic)<suspends>:void =
        if(CurrentIndex := PlayerCurrentIndex[Player]):
            if(CameraDirection?, NextIndex := Mod[CurrentIndex + 1, CameraDevices.Length]):
                SwitchCamera(Player, NextIndex)
            else if(PrevIndex := Mod[CurrentIndex - 1 + CameraDevices.Length, CameraDevices.Length]):
                SwitchCamera(Player, PrevIndex)

    SwitchCamera<private>(Player:player, CameraIndex:int):void =

        # Update index
        if(set PlayerCurrentIndex[Player] = CameraIndex):
            # Start new camera
            # spawn:
            #     PlaySequencerView(Player, CameraIndex)

            if(CameraObj := CameraDevices[CameraIndex]):
                CameraObj.SequencerCameraView.Play(Player)

        # Stop current cameras
        for(Index->CameraObject:CameraDevices, Index <> CameraIndex):
            CameraObject.SequencerCameraView.Stop(Player)

    # PlaySequencerView<private>(Player:player, CameraIndex:int)<suspends>:void =
    #     if(CameraObject := CameraDevices[CameraIndex]):
    #         for(X:=0..30):
    #             CameraObject.SequencerCameraView.Play(Player)
    #             Sleep(0.0)

