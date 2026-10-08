
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


Make_widget_vents_reactor_upper<public><constructor>(InPlayer:player, EventManager:event_manager, InRotation:rotation, InPosition:vector3, InPlayerTexture:texture, VentInteracted:vent_class, InVentReactorUpper:vent_class, InVentUpperEngine:vent_class) := widget_vents_reactor_upper:
    DefaultPlayerPosition := InPosition
    DefaultPlayerRotation := InRotation
    DefaultPlayerTexture := InPlayerTexture
    
    VentReactorUpper := InVentReactorUpper
    VentUpperEngine := InVentUpperEngine
    
    Make_widget_vents<constructor>(InPlayer, EventManager, InRotation, InPosition, InPlayerTexture, VentInteracted)

    
widget_vents_reactor_upper<public> := class(widget_vents):
    VentReactorUpper<public>:vent_class
    VentUpperEngine<public>:vent_class
    TextureBackgroundVents<override>:texture = T_WidgetVentsReactorUpper

    CreateVentButtons<override>():void = 
        ButtonUpperEngine := button_quiet{DefaultText := StringToMsg("Upper Engine")}
        ButtonReactor := button_quiet{DefaultText := StringToMsg("Reactor")}

        set WidgetVentButtons = array:
            (ButtonUpperEngine, 0.241217, VentUpperEngine),
            (ButtonReactor, 0.352474, VentReactorUpper)



        