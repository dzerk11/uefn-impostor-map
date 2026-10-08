
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

using { Modules.PlayerMap }

widget_player_pointer<public> := class:
    var<private>Canvas<public>:canvas = canvas{}

    # MPointer<private>:m_player_cursor_material = m_player_cursor_material{}

    # Player pointer material
    # PlayerPointer<private>:material_block = material_block:
    #     DefaultImage := m_player_cursor_material{}

    DefaultDesiredSize<public>:vector2

    WidgetPlayerPointer<internal>:texture_block = texture_block:
        DefaultImage := Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_0
    WidgetPlayerPointer2<internal>:texture_block = texture_block:
        DefaultImage := Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_0
        

    Init<public>():void = 
        WidgetPlayerPointer.SetDesiredSize(DefaultDesiredSize)
        WidgetPlayerPointer2.SetDesiredSize(DefaultDesiredSize)
        # PlayerPointer.SetDesiredSize(DefaultDesiredSize)
        # PlayerPointer.SetImage(MPointer)

        Canvas.AddWidget(
            canvas_slot:
                Widget := WidgetPlayerPointer
        )

        
    UpdateRotation<public>(Rotation:rotation):void = 
        # set MPointer.rotation = GetNormalizedYawFromRotation(Rotation)
        # set MPointer.rotation = 0.25
        
        PRotation := RadiansToDegrees(Rotation.GetAxis().Z * Rotation.GetAngle())
        if(-RSlice<PRotation and PRotation<RSlice):             # -22.5 < x < 22.5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_0)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_0)
        else if(RSlice<PRotation and PRotation<3*RSlice):       # 22.5 < x < 67,5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_45)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_45)
        else if(3*RSlice<PRotation and PRotation<5*RSlice):     # 67,5 < x < 112.5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_90)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_90)
        else if(5*RSlice<PRotation and PRotation<7*RSlice):     # 112.5 < x < 157,5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_135)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_135)
        else if(7*RSlice<PRotation and PRotation<9*RSlice):     # 157,5 < x < 202.5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_180)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_180)
        
        else if(-3*RSlice<PRotation and PRotation<-RSlice):     # -67,5 < x < -22.5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_315)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_315)
        else if(-5*RSlice<PRotation and PRotation<-3*RSlice):   # -112.5 < x < -67,5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_270)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_270)
        else if(-7*RSlice<PRotation and PRotation<-5*RSlice):   # -157,5 < x < -112.5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_225)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_225)
        else if(-9*RSlice<PRotation and PRotation<-7*RSlice):    # -202.5 < x < -157,5
            WidgetPlayerPointer.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_180)
            WidgetPlayerPointer2.SetImage(Art.Textures.Icons.PlayerIcons.T_Icons_PlayerArrow_180)

    UpdatePosition<public>(Translation:vector3):void = 
        PlayerPointerCoordinates := Ui.ConvertRealCoordinatesIntoMapRelative(vector2{X := Translation.X, Y := Translation.Y})

        Self.Canvas.AddWidget(
            canvas_slot:
                Anchors := anchors{Minimum := PlayerPointerCoordinates, Maximum := PlayerPointerCoordinates}
                Alignment := vector2{X := 0.5, Y := 0.5}
                SizeToContent := true
                Widget := WidgetPlayerPointer2
        )
        Self.Canvas.RemoveWidget(WidgetPlayerPointer)

        Self.Canvas.AddWidget(
            canvas_slot:
                Anchors := anchors{Minimum := PlayerPointerCoordinates, Maximum := PlayerPointerCoordinates}
                Alignment := vector2{X := 0.5, Y := 0.5}
                SizeToContent := true
                Widget := WidgetPlayerPointer
        )
        Self.Canvas.RemoveWidget(WidgetPlayerPointer2)


    # Helper function to wrap a value between 0.0 and 1.0
    # Wrap01(Value:float):float =
    #     if (Value < 0.0):
    #         Value + 1.0
    #     else if (Value >= 1.0):
    #         Value - 1.0
    #     else:
    #         Value

    # # Returns the yaw component of a rotation normalized between 0.0 and 1.0
    # GetNormalizedYawFromRotation(Rotation:rotation):float =
    #     # GetYawPitchRollDegrees returns an array of 3 floats: [Yaw, Pitch, Roll]
    #     YawPitchRoll := Rotation.GetYawPitchRollDegrees()
    #     if (Yaw := YawPitchRoll[0]):
    #         Normalized := Yaw / 360.0
    #         Wrap01(Normalized)
    #     else:
    #         0.0 # Default to 0.0 if we can't get the yaw
