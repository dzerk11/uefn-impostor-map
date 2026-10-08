
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }

using { ModuleTasks }
using { Modules.Vents }

Make_widget_vents_reactor_lower<public><constructor>(InPlayer:player, EventManager:event_manager, InRotation:rotation, InPosition:vector3, InPlayerTexture:texture, VentInteracted:vent_class, InVentReactorLower:vent_class, InVentLowerEngine:vent_class) := widget_vents_reactor_lower:
    DefaultPlayerPosition := InPosition
    DefaultPlayerRotation := InRotation
    DefaultPlayerTexture := InPlayerTexture
    
    VentReactorLower := InVentReactorLower
    VentLowerEngine := InVentLowerEngine
    
    Make_widget_vents<constructor>(InPlayer, EventManager, InRotation, InPosition, InPlayerTexture, VentInteracted)

    
widget_vents_reactor_lower<public> := class(widget_vents):
    VentReactorLower<public>:vent_class
    VentLowerEngine<public>:vent_class
    TextureBackgroundVents<override>:texture = T_WidgetVentsReactorLower

    CreateVentButtons<override>():void = 
        ButtonReactorLower := button_quiet{DefaultText := StringToMsg("Reactor")}
        ButtonLowerEngine := button_quiet{DefaultText := StringToMsg("Lower Engine")}

        set WidgetVentButtons = array:
            (ButtonReactorLower, 0.241217, VentReactorLower),
            (ButtonLowerEngine, 0.352474, VentLowerEngine)


    

