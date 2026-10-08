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
using { /Fortnite.com/Characters }

using { Modules.TaskAssets.FixShields }

Make_stage_widget_shields<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_shields, StageController:stage_controller) := stage_widget_shields:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer
    

Make_stage_widget_shields_shield<internal><constructor>(InPosition:vector2) := stage_widget_shields_shield:
    Position := InPosition


stage_widget_shields_shield<public> := class:
    var Status:logic = false

    var Canvas:canvas = canvas{}

    BackgroundColor:texture_block = texture_block:
        DefaultImage := T_ShieldPolygon

    Button:button_quiet = button_quiet{}

    Position<public>:vector2
    Size<public>:vector2 = vector2{X := 232.759995, Y := 195.039993}

    Init<public>():canvas = 
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := Size.X, Bottom := Size.Y}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array:
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 1
                                Widget := BackgroundColor

    TurnOn<public>():void = 
        BackgroundColor.SetImage(T_ShieldPolygon)
        set Status = true

    TurnOff<public>():void = 
        BackgroundColor.SetImage(T_ShieldPolygonRed)
        set Status = false
   

stage_widget_shields<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_shields
    InputMode<override>:ui_input_mode = ui_input_mode.None

    var Shields<private>:[int]stage_widget_shields_shield = map{}
    
    OnDestroy<override>():void = 
        StageDevices.PopupDialogDevice.Hide(Player)

        # ReleaseFromStasis
        if(FNCharacter := Player.GetFortCharacter[]):
            FNCharacter.ReleaseFromStasis()

    OnInit<override>():void =

        Subscriptions.Add(StageDevices.PopupDialogDevice.RespondingButtonEvent.Subscribe(OnClick))

        # if(FNCharacter :=

        set Shields = map:
            0 => Make_stage_widget_shields_shield(vector2{X := -194.460938, Y := -106.540527})
            1 => Make_stage_widget_shields_shield(vector2{X := -194.460938, Y := 109.459473})
            2 => Make_stage_widget_shields_shield(vector2{X := 0.0, Y := 0.0})
            3 => Make_stage_widget_shields_shield(vector2{X := 0.0, Y := -216.0})
            4 => Make_stage_widget_shields_shield(vector2{X := 0.0, Y := 216.0})
            5 => Make_stage_widget_shields_shield(vector2{X := 196.0, Y := -108.0})
            7 => Make_stage_widget_shields_shield(vector2{X := 196.0, Y := 108.0})

        
        for(Shield:Shields):
            Shield.Init()
            Shield.TurnOn()

        # Freeze player
        StasysArgs:stasis_args = stasis_args:
            AllowTurning := false
            AllowFalling := false
            AllowEmotes := false
        if(FNCharacter := Player.GetFortCharacter[]):
            FNCharacter.PutInStasis(StasysArgs)


        RandomShields := Shuffle(for(Shield:Shields){Shield})
        RandomInt := GetRandomInt(2,3)
        for(X := 0..RandomInt, Shield := RandomShields[X]):
            Shield.TurnOff()        

        StageDevices.PopupDialogDevice.Show(Player)

        set Widget = canvas:
            Slots := array:
                
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := WB_ShieldsBg{}

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    SizeToContent := false
                    ZOrder := 1
                    Widget := canvas:
                        Slots := for(Shield:Shields):
                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                Offsets := margin{Left := Shield.Position.X, Top := Shield.Position.Y}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := true
                                ZOrder := 0
                                Widget := Shield.Canvas
        
    CheckCompletion<private>()<decides><transacts>:void =
        for(Shield:Shields):
            Shield.Status?

    OnClick<private>(Agent:agent, ButtonIndex:int):void = 
        Print("premuto l'indice {ButtonIndex}")
        if(EAgent := player[Agent], Player = EAgent):
            if(ButtonIndex = 8):
                # Close button
                SignalPlayerFails()
            else if(Shield := Shields[ButtonIndex]):
                Shield.TurnOn()

                if(CheckCompletion[]):
                    SignalPlayerCompletes()
                    StageDevices.CinematicGlowRods.Stop()
                    StageDevices.CinematicGlowRods.Play()
                    StageDevices.PopupDialogDevice.Hide(Player)
                else:
                    spawn{ShowPopup()}
            else:
                spawn{ShowPopup()}

    ShowPopup<private>()<suspends>:void = 
        StageDevices.PopupDialogDevice.Hide(Player)
        StageDevices.PopupDialogDevice.Show(Player)
        Sleep(0.01)
        StageDevices.PopupDialogDevice.Show(Player)