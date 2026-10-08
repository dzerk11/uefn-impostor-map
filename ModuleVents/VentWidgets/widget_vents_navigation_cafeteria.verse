
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

Make_widget_vents_cafeteria<public><constructor>(InPlayer:player, EventManager:event_manager, InRotation:rotation, InPosition:vector3, InPlayerTexture:texture, VentInteracted:vent_class, InVentCafeteria:vent_class, InVentHallwayNavigation:vent_class, InVentAdmin:vent_class) := widget_vents_cafeteria:
    DefaultPlayerPosition := InPosition
    DefaultPlayerRotation := InRotation
    DefaultPlayerTexture := InPlayerTexture
    
    VentCafeteria := InVentCafeteria
    VentHallwayNavigation := InVentHallwayNavigation
    VentAdmin := InVentAdmin

    Make_widget_vents<constructor>(InPlayer, EventManager, InRotation, InPosition, InPlayerTexture, VentInteracted)


widget_vents_cafeteria<public> := class(widget_vents):
    VentCafeteria<public>:vent_class
    VentHallwayNavigation<public>:vent_class
    VentAdmin<public>:vent_class

    TextureBackgroundVents<override>:texture = T_WidgetVentsCafeteria

    CreateVentButtons<override>():void = 
        ButtonCafeteria := button_quiet{DefaultText := StringToMsg("Cafeteria")}
        ButtonHallwayNavigation := button_quiet{DefaultText := StringToMsg("Hallway Nav")}
        ButtonAdmin := button_quiet{DefaultText := StringToMsg("Admin")}

        set WidgetVentButtons = array:
            (ButtonCafeteria, 0.241217, VentCafeteria),
            (ButtonHallwayNavigation, 0.352474, VentHallwayNavigation),
            (ButtonAdmin, 0.46382, VentAdmin)


    

