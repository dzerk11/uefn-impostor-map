
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Random }

using { ModuleAmongusPlayspace }

gamephase_lobby_log := class(log_channel){}

gamephase_lobby := class(gamephase_class):
    Logger<override>:log = log{Channel:=gamephase_lobby_log, DefaultLevel:=log_level.Debug}

    var WaitingHud<private>:[player]WBP_WaitingToStart = map{}
    @editable
    var AudioPlayerDevices<private>:[]audio_player_device = array{}
    @editable
    var RadioDevices<private>:[]radio_device = array{}
        
    TargetPlayersToStart<private>:int = 10

    Init<override>():void = 
        (super:)Init()

        spawn:
            WaitForPlayers()
 
    WaitForPlayers<private>()<suspends>:void = 
        # if(AudioDevice := AudioPlayerDevices[GetRandomInt(0,AudioPlayerDevices.Length-1)]):
        #     AudioDevice.Play()
        
        if(RadioDevice := AudioPlayerDevices[GetRandomInt(0,RadioDevices.Length-1)]):
            RadioDevice.Play()
        

        race:
            Sleep(20.0)

            loop:
                CurrentAPlayers := GetAPlayers()

                

                if(CurrentAPlayers.Length >= TargetPlayersToStart):
                    break

                Sleep(2.0)
                
        APlayers := GetAPlayers()
        for(Player->Widget:WaitingHud, PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(Widget)

        for(AudioDevice:AudioPlayerDevices):
            AudioDevice.Stop()

        for(RadioDevice:RadioDevices):
            RadioDevice.Stop()

        EventManager.Notify(event_switch_to_game_phase{Gamephase:=gamephase.GameRound})

    OnPlayerAdded<public>(APlayer:amongus_player):void = 
        if(PlayerUI := GetPlayerUI[APlayer.Player]):
            Widget := WBP_WaitingToStart{CurrentPlayers := GetAPlayers().Length, TargetPlayers:=TargetPlayersToStart}
            PlayerUI.AddWidget(Widget)
            if(set WaitingHud[APlayer.Player] = Widget){}

        CurrentAPlayers := GetAPlayers()
        for(Widget:WaitingHud):
            set Widget.CurrentPlayers = CurrentAPlayers.Length

    Dispose<override>():void = 
        (super:)Dispose()

