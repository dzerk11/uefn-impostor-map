
using { /Fortnite.com/Devices }


ui_screen_message_device<public> := class(ui_screen):

    HudMessageDevice<public>:hud_message_device

    # Show widget to player
    Show<override>():void = 
        HudMessageDevice.Show(Player)
        (super:)Show()

    # Hide widget 
    Hide<override>():void = 
        HudMessageDevice.Hide(Player)
        (super:)Hide()

    Destroy<override>():void =
        Self.Hide()
        EventScreenDestroied.Signal(Self)
        _CancelSubscriptions()