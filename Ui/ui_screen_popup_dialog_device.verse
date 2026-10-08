
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }


Make_ui_screen_popup_dialog_device<public><constructor>(InPlayer:player, InLogger:custom_logger, InPopupDialogDevice:popup_dialog_device) := ui_screen_popup_dialog_device:
    Player := InPlayer
    Logger := InLogger
    PopupDialogDevice := InPopupDialogDevice


ui_screen_popup_dialog_device<public> := class(ui_screen):

    PopupDialogDevice<public>:popup_dialog_device

    # Show widget to player
    Show<override>():void = 
        PopupDialogDevice.Show(Player)
        (super:)Show()

    # Hide widget 
    Hide<override>():void = 
        PopupDialogDevice.Hide(Player)
        (super:)Hide()
        Print("hided")

    Destroy<override>():void =
        Self.Hide()
        EventScreenDestroied.Signal(Self)
        _CancelSubscriptions()