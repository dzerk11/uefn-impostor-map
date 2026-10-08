
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }

Make_ui_custom_widget<public><constructor>(InPlayer:player) := ui_custom_widget:
    Player := InPlayer
    
ui_custom_widget<public> := class:

    Player<public>:player

    InputMode<protected>:ui_input_mode = ui_input_mode.None

    var _MaybeWidgetCanvas<private>:?canvas = false
    var _Cancelables<protected>:[]cancelable = array{}

    # Create widget
    Init<public>():void = 
        if(not IsCreated[]):
            SetWidgetCanvas(_MakeCanvas())


    # Make canvas, used inside create
    _MakeCanvas<protected>():canvas = {canvas{}}


    # Assign widget to player if not already assigned
    AssingToPlayer<protected>():void =
        if(WidgetCanvas := GetWidgetCanvas[], PlayerUI := GetPlayerUI[Self.Player]):
            PlayerUI.AddWidget(WidgetCanvas, player_ui_slot{InputMode:=Self.InputMode})

    # Remove widget
    RemoveToPlayer<protected>():void = 
        if(WidgetCanvas := GetWidgetCanvas[], PlayerUI := GetPlayerUI[Self.Player]):
            PlayerUI.RemoveWidget(WidgetCanvas)

    # Show widget to player
    Show<public>():void = 
        if (WidgetCanvas := GetWidgetCanvas[]):
            if(IsAssigned[]):
                WidgetCanvas.SetVisibility(widget_visibility.Visible)
            else:
                AssingToPlayer()
                WidgetCanvas.SetVisibility(widget_visibility.Visible)

    # Hide widget visualization, it does not remove it from player ui
    Hide<public>():void = 
        if (WidgetCanvas := GetWidgetCanvas[], IsAssigned[]):
            WidgetCanvas.SetVisibility(widget_visibility.Hidden)

    Collapse<public>():void = 
        _CancelSubscriptions()
        if (WidgetCanvas := GetWidgetCanvas[], IsAssigned[]):
            WidgetCanvas.SetVisibility(widget_visibility.Collapsed)

    # Destroy widget
    Destroy<public>():void = 
        if(Canvas := GetWidgetCanvas[], PlayerUI := GetPlayerUI[Self.Player]):
            Self.Hide()
            PlayerUI.RemoveWidget(Canvas)
            set _MaybeWidgetCanvas = false

    IsAssigned<public>()<decides><transacts>:void = 
        WidgetCanvas := GetWidgetCanvas[]
        WidgetCanvas.GetRootWidget[]

    IsCreated<public>()<decides><transacts>:void = 
        Self._MaybeWidgetCanvas?

    GetWidgetCanvas<public>()<decides><transacts>:canvas =
        Self._MaybeWidgetCanvas?
    
    SetWidgetCanvas<protected>(WidgetCanvas:canvas):void =
        set Self._MaybeWidgetCanvas = option{WidgetCanvas}

    SetWidgetCanvas<protected>(MaybeWidgetCanvas:?canvas):void =
        set Self._MaybeWidgetCanvas = MaybeWidgetCanvas


    # Cancel every subscription, used before Destroy
    _CancelSubscriptions<protected>():void = 
        for(Cancelable:_Cancelables):
            Cancelable.Cancel()

    SetSubscriptions<protected>():void = {}
    AppendNewCancelable<protected>(Cancelable:cancelable):void = 
        set Self._Cancelables += array{Cancelable}

