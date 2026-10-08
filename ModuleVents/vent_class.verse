
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

vent_class <public> := class<concrete><final>:
    @editable VentId<public>:vent_id = vent_id.NONE
    @editable Button<public>:button_device = button_device{}
    @editable Teleporter<public>:teleporter_device = teleporter_device{}