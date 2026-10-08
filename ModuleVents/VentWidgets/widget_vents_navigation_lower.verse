
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

Make_widget_vents_navigation_lower<public><constructor>(InPlayer:player, EventManager:event_manager, InRotation:rotation, InPosition:vector3, InPlayerTexture:texture, VentInteracted:vent_class, InVentNavigationLower:vent_class, InVentShields:vent_class) := widget_vents_navigation_lower:
    DefaultPlayerPosition := InPosition
    DefaultPlayerRotation := InRotation
    DefaultPlayerTexture := InPlayerTexture
    
    VentNavigationLower := InVentNavigationLower
    VentShields := InVentShields
    
    Make_widget_vents<constructor>(InPlayer, EventManager, InRotation, InPosition, InPlayerTexture, VentInteracted)
    

widget_vents_navigation_lower<public> := class(widget_vents):
    VentNavigationLower<public>:vent_class
    VentShields<public>:vent_class
    TextureBackgroundVents<override>:texture = T_WidgetVentsNavigationLower

    CreateVentButtons<override>():void = 
        ButtonNavigationLower := button_quiet{DefaultText := StringToMsg("Navigation")}
        ButtonShields := button_quiet{DefaultText := StringToMsg("Shields")}

        set WidgetVentButtons = array:
            (ButtonNavigationLower, 0.241217, VentNavigationLower),
            (ButtonShields, 0.352474, VentShields)


    

