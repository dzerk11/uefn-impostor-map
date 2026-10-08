
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

kill_button_player_devices<public> := class<concrete>:
    @editable
    CSQ_KillIconState<public>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable
    CSQ_KillIconWiggle<public>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable
    HMD_KillIcon<public>:hud_message_device = hud_message_device{}

    var _StateCinematicLock<private>:logic = false

    IsCinematicStateLocked<public>()<decides><transacts>:void = 
        _StateCinematicLock?

    LockCinematicState<public>()<decides><transacts>:void = 
        not IsCinematicStateLocked[]
        set _StateCinematicLock = true

    UnLockCinematicState<public>():void = 
        set _StateCinematicLock = false