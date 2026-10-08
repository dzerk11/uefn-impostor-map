
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_sabotage_comms<public> := class<final><concrete>(stage_devices):
    @editable CSD_PostProcess<public>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable MapControllerNoisy<public>:map_controller_device = map_controller_device{}


# Constructor
Make_stage_sabotage_comms<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_sabotage_comms) := stage_sabotage_comms:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}
    

# Class
stage_sabotage_comms<public> := class(sabotage_stage_base):
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    Location<override>:map_locations = map_locations.Communications
    StageDevices<override>:stage_devices_sabotage_comms
    EventStopCinematic:event() = event(){}

    Init<override>():void =
        (super:)Init()
        OnSabotageStopped()

    OnSabotageStarted<override>():void = 
        Print("comms started")
        StageDevices.TaskPanel.Enable()
        
        spawn:
            HandleCinematic()

        StageDevices.MapControllerNoisy.Enable()
        for(APlayer:GetAPlayersRound()):
            StageDevices.MapControllerNoisy.Activate(APlayer.Player)

        Print("comms started end")

    OnSabotageStopped<override>():void = 
        Print("comms stopped")
        EventStopCinematic.Signal()
        StageDevices.TaskPanel.Disable()
        StageDevices.MapControllerNoisy.Disable()

        for(APlayer:GetAPlayersRound()):
            StageDevices.MapControllerNoisy.Deactivate(APlayer.Player)
        
        Print("comms stopped end")

    HandleCinematic<private>()<suspends>:void =
        race:
            block:
                StageDevices.CSD_PostProcess.SetPlaybackFrame(0)
                for(APlayer:GetAPlayersRound()):
                    StageDevices.CSD_PostProcess.Play(APlayer.Player)
                Sleep(5.0)
                for(APlayer:GetAPlayersRound()):
                    StageDevices.CSD_PostProcess.Pause(APlayer.Player)
                Sleep(Inf)

            EventStopCinematic.Await()

        StageDevices.CSD_PostProcess.SetPlaybackFrame(55)
        for(APlayer:GetAPlayersRound()):
            StageDevices.CSD_PostProcess.Play(APlayer.Player)

        

    SignalPlayerInteracts<override>(Agent:agent):void = 
        (super:)SignalPlayerInteracts(Agent)
        if(Player := player[Agent]):
            SignalPlayerCompletes(Player)
