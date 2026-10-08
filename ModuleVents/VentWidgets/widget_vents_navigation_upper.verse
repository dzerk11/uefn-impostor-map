
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

Make_widget_vents_navigation_upper<public><constructor>(InPlayer:player, EventManager:event_manager, InRotation:rotation, InPosition:vector3, InPlayerTexture:texture, VentInteracted:vent_class, InVentNavigationUpper:vent_class, InVentWeapons:vent_class) := widget_vents_navigation_upper:
    DefaultPlayerPosition := InPosition
    DefaultPlayerRotation := InRotation
    DefaultPlayerTexture := InPlayerTexture
    
    VentNavigationUpper := InVentNavigationUpper
    VentWeapons := InVentWeapons
    
    Make_widget_vents<constructor>(InPlayer, EventManager, InRotation, InPosition, InPlayerTexture, VentInteracted)

    
widget_vents_navigation_upper<public> := class(widget_vents):
    VentNavigationUpper<public>:vent_class
    VentWeapons<public>:vent_class
    TextureBackgroundVents<override>:texture = T_WidgetVentsNavigationUpper

    CreateVentButtons<override>():void = 
        ButtonNavigationUpper := button_quiet{DefaultText := StringToMsg("Navigation")}
        ButtonWeapons := button_quiet{DefaultText := StringToMsg("Weapons")}

        set WidgetVentButtons = array:
            (ButtonWeapons, 0.241217, VentWeapons),
            (ButtonNavigationUpper, 0.352474, VentNavigationUpper)


    

