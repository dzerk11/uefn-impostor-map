
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }

stage_devices<public> := class:
    @editable   TaskPanel<public>:button_device = button_device{}
    @editable   MapIndicators<public>:[]map_indicator_device = array{}
    @editable   Beacon<public>:beacon_device = beacon_device{}
    var   MapIndicatorsDefaultPositions<public>:[]transform = array{}