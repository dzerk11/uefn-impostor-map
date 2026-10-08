
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { Modules.TaskAssets.SabotageReactorFail }

log_sabotage_reactor_fail := class(log_channel){}

# Devices
task_devices_sabotage_reactor_fail<public> := class<final><concrete>(sabotage_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_sabotage_reactor_fail = TaskStages.stage_devices_sabotage_reactor_fail{}
    @editable
    Stage1<public>:TaskStages.stage_devices_sabotage_reactor_fail = TaskStages.stage_devices_sabotage_reactor_fail{}
    @editable
    ReactorGlow<public>:creative_prop = creative_prop{}


# Constructor
Make_sabotage_reactor_fail<public><constructor>(Devices:Tasks.task_devices_sabotage_reactor_fail) := sabotage_reactor_fail:
    Devices := Devices

        
# Class
sabotage_reactor_fail<public><final> := class(sabotage_basic):
    Logger<override>:log = log{Channel:=log_sabotage_reactor_fail}
    Name<override>:task_name = task_name.SabotageReactorFail
    SabotageType<override>:sabotage_type = sabotage_type.Critical
    Devices<override>:task_devices_sabotage_reactor_fail = task_devices_sabotage_reactor_fail{}
    Duration<override>:float = 40.0

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_sabotage_reactor_fail(Logger, Self, Devices.Stage0, 0)
            TaskStages.Make_stage_sabotage_reactor_fail(Logger, Self, Devices.Stage1, 0)

        for(Index->Stage:GetStagesTyped()):
            Stage.StageDevices.AreaCaptureDevice.FirstAgentEntersEvent.SubscribeAgent(FirstAgentEntersAreaCapture, Index)

    OnSabotageStarted<override>():void = 
        Devices.ReactorGlow.SetMaterial(T_ReactorGlowRed)
        
    OnSabotageStopped<override>():void =
        Devices.ReactorGlow.SetMaterial(T_ReactorGlow)

    GetStagesTyped<private>()<transacts>:[]TaskStages.stage_sabotage_reactor_fail =
        for(Stage:Stages, TypedStage:=TaskStages.stage_sabotage_reactor_fail[Stage]):
            TypedStage

    FirstAgentEntersAreaCapture<private>(Agent:agent, StageNumber:int):void =
        CheckPlayersOnPosition()

    CheckPlayersOnPosition<private>():void =
        for(Stage:GetStagesTyped(), Stage.StageDevices.AreaCaptureDevice.GetAgentsInVolume().Length<=0):
            return
            
        for(Stage:GetStagesTyped(), AgentInVolume:Stage.StageDevices.AreaCaptureDevice.GetAgentsInVolume(), PlayerInVolume:=player[AgentInVolume]):
            Start(PlayerInVolume, Stage.StageId)
            AdvanceTask(PlayerInVolume, Stage.StageId)

        EventSabotageResolved.Signal()


    
