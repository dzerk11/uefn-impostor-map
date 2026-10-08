
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }

Make_ui_widget_base<public><constructor>(InPlayer:player) := ui_widget_base:
    Player := InPlayer
    Logger := custom_logger{}

Make_ui_widget_base<public><constructor>(InPlayer:player, InLogger:custom_logger) := ui_widget_base:
    Player := InPlayer
    Logger := InLogger


ToString<public>(WidgetVisibility:widget_visibility):string =
    case (WidgetVisibility):
        widget_visibility.Visible => "Visible",
        widget_visibility.Collapsed => "Collapsed",
        widget_visibility.Hidden => "Hidden"



ui_widget_base<public> := class(ui_screen):

    MakeSlot<public>():canvas_slot = 
        canvas_slot:
            SizeToContent := false
            Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
            Widget := color_block:
                DefaultColor := NamedColors.Green

    # --------------- [ VARIABLES ] ---------------
    
    var _InputMode<internal>:ui_input_mode = ui_input_mode.None
    var _IsAssigned<private>:logic = false

    var _MaybeWidgetContainer<private>:?canvas = false

    WidgetGrayBackgroundSlot<protected>:canvas_slot = canvas_slot:
        Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
        Alignment := vector2{X := 0.5, Y := 0.5}
        SizeToContent := false
        ZOrder := 0
        Widget := color_block:
            DefaultColor := MakeColorFromHex("#1c1c1c")
            DefaultOpacity := 0.6



    # --------------- [ METHODS ] ---------------

    # Create widget
    Init<override>():void = 
        (super:)Init()
        if(not IsCreated[]):
            SetWidgetContainer(_MakeCanvas())
            

    # Make canvas, used inside create
    _MakeCanvas<protected>():canvas = {canvas{}}


    # Assign widget to player if not already assigned
    _AssingToPlayer<protected>():void =
        if(not IsAssigned[], WidgetContainer:=GetWidgetContainer[], PlayerUI := GetPlayerUI[Self.Player]):
            PlayerUI.AddWidget(WidgetContainer, player_ui_slot{InputMode:=Self._InputMode})
            set _IsAssigned = true

    # Remove widget to player if assigned
    _RemoveToPlayer<protected>():void = 
        if(_IsAssigned?, WidgetContainer:=GetWidgetContainer[], PlayerUI := GetPlayerUI[Self.Player]):
            PlayerUI.RemoveWidget(WidgetContainer)
            set _IsAssigned = false


    # Show widget to player
    Show<override>():void = 
        if(not IsCreated[]):
            Init()
        
        if(IsCreated[]):
            _AssingToPlayer()

            if(WidgetContainer:=GetWidgetContainer[]):
                WidgetContainer.SetVisibility(widget_visibility.Visible)
                WidgetContainer.SetEnabled(true)
                (super:)Show()

    # Hide widget visualization, it does not remove it from player ui
    Hide<override>():void = 
        if(WidgetContainer:=GetWidgetContainer[]):
            WidgetContainer.SetVisibility(widget_visibility.Collapsed)
            (super:)Hide()

    # Destroy widget
    Destroy<override>():void = 
        (super:)Destroy()
        if(Container:=GetWidgetContainer[], PlayerUI := GetPlayerUI[Self.Player]):
            PlayerUI.RemoveWidget(Container)
            set _MaybeWidgetContainer = false

    IsAssigned<public>()<decides><transacts>:void = 
        Self._IsAssigned?

    IsCreated<public>()<decides><transacts>:void = 
        Self._MaybeWidgetContainer?

    GetWidgetContainer<protected>()<decides><transacts>:canvas =
        Self._MaybeWidgetContainer?
    
    SetWidgetContainer<protected>(WidgetContainer:canvas):void =
        set Self._MaybeWidgetContainer = option{WidgetContainer}

    SetWidgetContainer<protected>(MaybeWidgetContainer:?canvas):void =
        set Self._MaybeWidgetContainer = MaybeWidgetContainer

    

            

    