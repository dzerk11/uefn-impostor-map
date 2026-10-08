
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using {/Verse.org/Random}
using { /Verse.org }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { Modules.TaskAssets.CallEarth }

MsgCallButton<localizes>:message = "CALL"

Make_stage_widget_call_earth<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_call_earth_find_better_signal, StageController:stage_controller) := stage_widget_call_earth:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer

stage_widget_call_earth<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_call_earth_find_better_signal

    WidgetBackgroundTexture<private>:texture_block = texture_block:
        DefaultImage := T_CallEarth_signal0
        DefaultDesiredSize := vector2{X := 1300.0, Y := 1000.0}

    HelpText<private>:text_block = text_block:
        DefaultTextColor := NamedColors.White
        DefaultShadowColor := NamedColors.Black
        DefaultShadowOffset := option{vector2{X:=1.0,Y:=1.0}}
        DefaultShadowOpacity := 1.0
        
    CallButton:button_quiet = button_quiet:
        DefaultText := MsgCallButton
    
    var WifiReachable<private>:logic = false

    OnInit<override>():void =
        Subscriptions.Add(CallButton.OnClick().Subscribe(OnCallButtonClick))

        if (FortCharacter:fort_character = Self.Player.GetFortCharacter[]):
            PlayerTransformation := FortCharacter.GetTransform()
            PlayerTranslation := PlayerTransformation.Translation

            var MinDistance:float = Inf
            Distances := for(WifiBox:StageDevices.WifiBoxes):
                WifiTranslation := WifiBox.GetTransform()
                PlayerDistanceFromWifi := DistanceXY(WifiTranslation.Translation, PlayerTranslation)
                if(MinDistance>PlayerDistanceFromWifi):
                    set MinDistance = PlayerDistanceFromWifi

            set Widget = canvas:
                Slots := array:

                    canvas_slot:
                        SizeToContent := false
                        Widget := WidgetBackShadow

                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                        Offsets := margin{Top := 0.0, Left := 0.0, Right := 1300.0, Bottom := 1000.0}
                        Alignment := vector2{X := 0.5, Y := 1.0}
                        SizeToContent := false
                        ZOrder := 1
                        Widget := canvas:
                            Slots := array{

                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1300.0, Bottom := 1000.0}
                                    Alignment := vector2{X := 0.5, Y := 0.5}
                                    SizeToContent := false
                                    ZOrder := 0
                                    Widget := WidgetBackgroundTexture

                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                    Alignment := vector2{X := 0.5, Y := 0.5}
                                    SizeToContent := true
                                    ZOrder := 1
                                    Widget := HelpText

                                canvas_slot:
                                    ZOrder := 2
                                    Anchors := anchors{Minimum := vector2{X := 0.316274, Y := 0.796582}, Maximum := vector2{X := 0.498456, Y := 0.863803}}
                                    SizeToContent := false
                                    Widget := CallButton

                                canvas_slot:
                                    ZOrder := 2
                                    Anchors := anchors{Minimum := vector2{X := 0.535526, Y := 0.796582}, Maximum := vector2{X := 0.717577, Y := 0.863803}}
                                    SizeToContent := false
                                    Widget := CreateExitButton()

                                }

            if(MinDistance<=1500.0):
                WidgetBackgroundTexture.SetImage(T_CallEarth_signal2)
                set WifiReachable = true
            else if (MinDistance<=5000.0):
                WidgetBackgroundTexture.SetImage(T_CallEarth_signal1)
                CallButton.SetEnabled(false)
            else:
                WidgetBackgroundTexture.SetImage(T_CallEarth_signal0)
                CallButton.SetEnabled(false)

    OnCallButtonClick<private>(WidgetMessage:widget_message):void = 
        if(WifiReachable?):
            spawn:
                StartCall()

    StartCall<private>()<suspends>:void = 
        race:
            MakeCall()
            EventViewDestroyed.Await()
        
        StageDevices.AudioPeopleCalling.Stop(Self.Player)

    MakeCall<private>()<suspends>:void = 
        TotalTime := 6.0
        StageDevices.AudioPeopleCalling.Play(Self.Player)
        Self.CallButton.SetEnabled(false)
        
        TimeGap := TotalTime / (3.0)
        for(X:=0..3):
            case (X):
                0 => WidgetBackgroundTexture.SetImage(T_CallEarth_calling0)
                1 => WidgetBackgroundTexture.SetImage(T_CallEarth_calling1)
                2 => WidgetBackgroundTexture.SetImage(T_CallEarth_calling2)
                3 => WidgetBackgroundTexture.SetImage(T_CallEarth_calling3)
                _ =>

            Sleep(TimeGap)

        StageDevices.RemoteManagerRemover.Remove(Player)
        SignalPlayerCompletes()