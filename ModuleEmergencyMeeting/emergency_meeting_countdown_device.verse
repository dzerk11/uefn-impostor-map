
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

emergency_meeting_countdown_device := class(creative_device):

    @editable ScoreManager:score_manager_device = score_manager_device{}
    @editable Button:button_device = button_device{}
    @editable Cover:creative_prop = creative_prop{}
    @editable IconClickable:creative_prop = creative_prop{}

    ForceStop<private>:event() = event(){}

    var CountdownStartedAt:float = 0.0
    Target:float = 40.0

    OnBegin<override>():void = 
        spawn:
            HandleCountdown()

    HandleCountdown<private>()<suspends>:void = 
        set CountdownStartedAt = GetSecondsSinceEpoch()
        EndAt := CountdownStartedAt + Target
        Button.Disable()
        Cover.Show()
        ScoreManager.Enable()
        IconClickable.Hide()

        race:
            ForceStop.Await()

            loop:
                RemainingTime := EndAt - GetSecondsSinceEpoch()

                if(Rounded := Ceil[RemainingTime]):
                    ScoreManager.SetScoreAward(Rounded)

                if(RemainingTime<=0.0):
                    ScoreManager.SetScoreAward(0)
                    ScoreManager.Disable()
                    Button.Enable()
                    Cover.Hide()
                    IconClickable.Show()
                    break

                Sleep(0.1)

    IsCountdownEnd<public>()<transacts><decides>:void =
        CountdownStartedAt + Target < GetSecondsSinceEpoch()

    Reset<public>():void = 
        ForceStop.Signal()
        spawn:
            HandleCountdown()

    Disable<public>():void = 
        IconClickable.Hide()
        Button.Disable()
        ScoreManager.Disable()