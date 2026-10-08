
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

Make_widget_vents_security<public><constructor>(InPlayer:player, EventManager:event_manager, InRotation:rotation, InPosition:vector3, InPlayerTexture:texture, VentInteracted:vent_class, InVentSecurity:vent_class, InVentElectrical:vent_class, InVentMedBay:vent_class) := widget_vents_security:
    DefaultPlayerPosition := InPosition
    DefaultPlayerRotation := InRotation
    DefaultPlayerTexture := InPlayerTexture
    
    VentSecurity := InVentSecurity
    VentElectrical := InVentElectrical
    VentMedBay := InVentMedBay
    
    Make_widget_vents<constructor>(InPlayer, EventManager, InRotation, InPosition, InPlayerTexture, VentInteracted)

    
widget_vents_security<public> := class(widget_vents):
    VentSecurity<public>:vent_class
    VentElectrical<public>:vent_class
    VentMedBay<public>:vent_class

    TextureBackgroundVents<override>:texture = T_WidgetVentsSecurity

    CreateVentButtons<override>():void = 
        ButtonSecurity := button_quiet{DefaultText := StringToMsg("Security")}
        ButtonElectrical := button_quiet{DefaultText := StringToMsg("Electrical")}
        ButtonMedBay := button_quiet{DefaultText := StringToMsg("MedBay")}

        set WidgetVentButtons = array:
            (ButtonMedBay, 0.241217, VentMedBay),
            (ButtonSecurity, 0.352474, VentSecurity),
            (ButtonElectrical, 0.46382, VentElectrical)


    

