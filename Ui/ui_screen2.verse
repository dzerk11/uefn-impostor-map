
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }

Make_ui_screen<public><constructor>(InPlayer:player):= ui_screen_new:
    Player := InPlayer

ui_screen_new<public> := class:
    _Logger<private>:log = log{Channel := logger_channel, DefaultLevel := log_level.Normal}
    Player<public>:player
    
    var _Canvas:canvas = canvas{}
    var CustomWidgets<protected>:[]ui_custom_widget = array{}


    Init<public>():void = {}

    DrawCanvas<public>():void = {}

    RemoveCanvas<public>():void = 
        if(PlayerUI := GetPlayerUI[Self.Player]):
            PlayerUI.RemoveWidget(_Canvas)

    Destroy<public>():void = 
        Self.RemoveCanvas()
        for(CWidget:CustomWidgets):
            CWidget.Destroy()

