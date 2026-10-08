
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_kill_button_device := class(log_channel){}

kill_button_device<public> := class(creative_device):
    Logger<private>:log = log{Channel:=log_kill_button_device, DefaultLevel:=log_level.Debug}

    EventKillButton<public>:custom_subscribable(tuple(player,player)) = custom_subscribable(tuple(player,player)){}
    
    @editable # Input trigger to detect player left click
    IT_TriggerFire<private>:input_trigger_device = input_trigger_device{}
    
    @editable # {Temp} Audio player for player kill
    AP_PlayerKilled<private>:audio_player_device = audio_player_device{}
    
    @editable # {Temp} HUD - Crewmate eliminated!
    HM_CrewmateEliminated<private>:hud_message_device = hud_message_device{}
    
    @editable # Player devices
    PlayerDevices<public>:[]kill_button_player_devices = array{}

    # Players indexed
    var PlayersIndexed<private>:[]?player = array:
        false
        false
        false
        false
        false

    var PlayerSlots<private>:[int]kill_button_logic_player_slot = map{}

    OnBegin<override>():void = 
        IT_TriggerFire.PressedEvent.Subscribe(OnInputTriggerFire)
        
    Start<public>():void =
        for(Impostor:GetAPlayers(gameplay_role.Impostor)):
            AddPlayer(Impostor.Player)
            ShowPlayerIcon()
        StartCooldownForPlayers()

    Disable<public>():void =
        HidePlayerIcon()

    Enable<public>():void =
        ShowPlayerIcon()

    StartCooldownForPlayers<public>():void =
        for(Slot:PlayerSlots):
            Slot.StartCooldown()

    # Add player to index
    AddPlayer<public>(Player:player):void =

        # Search if player not already inside
        if(not PlayersIndexed.Find[option{Player}]):

            # Search empty index
            var Inserted:logic = false
            for(Index->MaybePlayer:PlayersIndexed):
                if: 
                    not Inserted?
                    MaybePlayer=false
                    set PlayersIndexed[Index] = option{Player}

                    PlayerSlot := kill_button_logic_player_slot:
                        Devices := PlayerDevices[Index]
                        Impostor := Player

                    set PlayerSlots[Index] = PlayerSlot
                    set Inserted = true

    # Remove player from index
    RemovePlayer<public>(Player:player):void =
        if(Index := PlayersIndexed.Find[option{Player}]):
            if(Slot := GetPlayerSlot[Player]):
                IT_TriggerFire.Unregister(Player)
                Slot.Stop()
                var NewMap:[int]kill_button_logic_player_slot = map{}
                for (Key->SlotTmp:PlayerSlots, Key<>Index):
                    set NewMap = ConcatenateMaps(NewMap, map{Key=>SlotTmp})
                set PlayerSlots = NewMap

            if:
                set PlayersIndexed[Index] = false

    # Get player index
    GetPlayerIndex<public>(Player:player)<transacts><decides>:int = 
        Index := PlayersIndexed.Find[option{Player}]

    # Get player slot
    GetPlayerSlot<public>(Player:player)<transacts><decides>:kill_button_logic_player_slot = 
        PlayerSlots[GetPlayerIndex[Player]]

    # Show player hud icon to player (skip ghosts)
    ShowPlayerIcon<public>(Player:player):void =
        if(APlayer := GetAPlayer[Player], APlayer.IsGhost?):
            return
        if(PlayerSlot := GetPlayerSlot[Player]):
            IT_TriggerFire.Register(Player)
            PlayerSlot.Show()

    # Show player hud icon to every player
    ShowPlayerIcon<public>():void =
        for(Slot:PlayerSlots):
            ShowPlayerIcon(Slot.Impostor)

    # Hide player hud icon to player
    HidePlayerIcon<public>(Player:player):void =
        if(PlayerSlot := GetPlayerSlot[Player]):
            IT_TriggerFire.Unregister(Player)
            PlayerSlot.Hide()

    # Hide player hud icon to every player
    HidePlayerIcon<public>():void =
        for(Slot:PlayerSlots):
            HidePlayerIcon(Slot.Impostor) 

    # Input trigger event
    OnInputTriggerFire<private>(Agent:agent):void =
        Logger.Print("Input (fire)..")

        if(Player := player[Agent], APlayer := GetAPlayer[Player], not APlayer.IsGhost?):
            if(Slot := GetPlayerSlot[Player]):
                # Check if slot is not in cooldown and has a target
                if(not Slot.IsCoolingDown[], TargetPlayer := Slot.GetTargetPlayer[]):
                    EventKillButton.Signal(Player, TargetPlayer)
                else:
                    Slot.SetIconWiggle()

    PlayKillAnimation<public>(Player:player):void =
        if(Slot := GetPlayerSlot[Player]):
            AP_PlayerKilled.Play(Player)
            HM_CrewmateEliminated.Show(Player)
            Slot.StartCooldown()
