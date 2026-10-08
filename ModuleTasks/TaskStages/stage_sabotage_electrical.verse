
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_sabotage_electrical<public> := class<final><concrete>(stage_devices):
    @editable CSD_PostProcessingDark<public>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable Switches<public>:[]switch_device = array{}
    @editable Teleporter<public>:teleporter_device = teleporter_device{}
    @editable MutatorZone<public>:mutator_zone_device = mutator_zone_device{}
    @editable BarrierDevice<public>:barrier_device = barrier_device{}


# Constructor
Make_stage_sabotage_lights_off<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_sabotage_electrical, InStageOrder:int) := stage_sabotage_lights_off:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices
    StageOrder := InStageOrder
    let:
        Translation := vector2{X:=-2974.873736,Y:=4365.548283}
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_sabotage_lights_off<public> := class(sabotage_stage_base):
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    Location<override>:map_locations = map_locations.Electrical
    StageDevices<override>:stage_devices_sabotage_electrical
    HideHudOnStart<override>:logic = false

    EventStopCinematic<private>:event() = event(){}
    var PlayersAffected<private>:[]amongus_player = array{}

    Init<override>():void = 
        (super:)Init()
        EventStopCinematic.Signal()
        StageDevices.MutatorZone.Disable()
        StageDevices.BarrierDevice.Enable()
        AppendCancelable(StageDevices.MutatorZone.AgentEntersEvent.Subscribe(OnPlayerEntersArea))
        AppendCancelable(StageDevices.MutatorZone.AgentExitsEvent.Subscribe(OnPlayerExitsArea))

        for(Switch:StageDevices.Switches):
            AppendCancelable(Switch.TurnedOnEvent.Subscribe(OnSwitchChangesStage))
            AppendCancelable(Switch.TurnedOffEvent.Subscribe(OnSwitchChangesStage))
            Switch.SetState(true)
            Switch.Disable()

    OnSabotageStarted<override>():void = 
        for(Switch:StageDevices.Switches):
            Switch.SetState(true)
            Switch.Enable()
            
        RandomSwitches := Shuffle(StageDevices.Switches)
        RandomNumbers := Shuffle(array{0,1,2,3,4})
        NumberOfSwitchesToToggleOff := GetRandomInt(2,4)
        for(X:=0..NumberOfSwitchesToToggleOff):
            if(Switch := RandomSwitches[X]):
                Switch.SetState(false)

        StageDevices.MutatorZone.Enable()
        StageDevices.BarrierDevice.Disable()

        set PlayersAffected = GetAPlayers(gameplay_role.Crewmate) + GetAPlayers(gameplay_role.Impostor)

        spawn:
            HandleCinematic()

    OnSabotageStopped<override>():void =
        EventStopCinematic.Signal()

        for(Switch:StageDevices.Switches):
            Switch.SetState(true)
            Switch.Disable()
        
        for(Agent:StageDevices.MutatorZone.GetAgentsInVolume(), Player:=player[Agent]):
            StageDevices.Teleporter.Teleport(Player)

        StageDevices.MutatorZone.Disable()
        StageDevices.BarrierDevice.Enable()
        
    HandleCinematic()<suspends>:void = 
        race:
            EventStopCinematic.Await()

            block:
                for(APlayerAffected:PlayersAffected):
                    StageDevices.CSD_PostProcessingDark.Play(APlayerAffected.Player)

                Sleep(30.0)

                for(APlayerAffected:PlayersAffected):
                    StageDevices.CSD_PostProcessingDark.Pause(APlayerAffected.Player)

                Sleep(Inf)

        for(APlayerAffected:PlayersAffected):
            StageDevices.CSD_PostProcessingDark.SetPlaybackFrame(55)
            StageDevices.CSD_PostProcessingDark.Play(APlayerAffected.Player)

        set PlayersAffected = array{}
            
    OnSwitchChangesStage(Agent:agent):void = 
        Print("OnSwitchChangesStage")
        if(Player := player[Agent]):
            if(not IsPlaying[Player]):
                SignalPlayerInteracts(Player)
            
            for(Switch:StageDevices.Switches, not Switch.GetCurrentState[]):
                return

            SignalPlayerCompletes(Player)

    OnPlayerEntersArea(Agent:agent):void = 
        if(Player := player[Agent]):
            SignalPlayerInteracts(Player)

    OnPlayerExitsArea(Agent:agent):void = 
        if(Player := player[Agent]):
            SignalPlayerFails(Player)

        

