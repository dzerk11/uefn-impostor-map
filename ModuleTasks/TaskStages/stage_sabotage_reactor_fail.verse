
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { Modules.TaskAssets.SabotageReactorFail }


# Devices
stage_devices_sabotage_reactor_fail<public> := class<final><concrete>(stage_devices):
    @editable
    AreaCaptureDevice<public>:capture_area_device = capture_area_device{}
    @editable
    Screen<public>:creative_prop = creative_prop{}


# Constructor
Make_stage_sabotage_reactor_fail<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_sabotage_reactor_fail, InStageOrder:int) := stage_sabotage_reactor_fail:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageOrder := InStageOrder
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.AreaCaptureDevice.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_sabotage_reactor_fail<public> := class(sabotage_stage_base):
    Location<override>:map_locations = map_locations.Reactor
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    
    StageDevices<override>:stage_devices_sabotage_reactor_fail

    # var IsAreaOccupied<private>:logic = false

    Init<override>():void = 
        (super:)Init()
        # Self.AppendCancelable(StageDevices.AreaCaptureDevice.AgentEntersEvent.Subscribe(OnPlayerEntersArea))
        # Self.AppendCancelable(StageDevices.AreaCaptureDevice.AgentExitsEvent.Subscribe(OnPlayerExitsArea))
        Self.AppendCancelable(StageDevices.AreaCaptureDevice.FirstAgentEntersEvent.Subscribe(OnFirstAgentEnters))
        Self.AppendCancelable(StageDevices.AreaCaptureDevice.LastAgentExitsEvent.Subscribe(OnLastAgentExits))
        OnSabotageStopped()

    OnSabotageStarted<override>():void = 
        StageDevices.AreaCaptureDevice.Enable()
        StageDevices.TaskPanel.Enable()
        if:
            Transform := StageDevices.AreaCaptureDevice.GetTransform()
            NewTransform := transform:
                Scale := Transform.Scale
                Rotation := Transform.Rotation
                Translation := vector3{X:=Transform.Translation.X,Y:=Transform.Translation.Y,Z:=2014.349253}
            StageDevices.AreaCaptureDevice.TeleportTo[Transform]

        StageDevices.Screen.SetMaterial(MI_ReactorScreenRed)

    OnSabotageStopped<override>():void =
        StageDevices.TaskPanel.Disable()
        StageDevices.AreaCaptureDevice.Disable()
        if:
            Transform := StageDevices.AreaCaptureDevice.GetTransform()
            NewTransform := transform:
                Scale := Transform.Scale
                Rotation := Transform.Rotation
                Translation := vector3{X:=Transform.Translation.X,Y:=Transform.Translation.Y,Z:=1660.0}
            StageDevices.AreaCaptureDevice.TeleportTo[Transform]
        
        StageDevices.Screen.SetMaterial(MI_ReactorScreenWhite)

    # ResolveSabotage<public>(Player:player):void =
    #     SignalPlayerCompletes(Player)

    # SetAreaOccupation<public>(IsOccupied:logic):void = 
    #     set IsAreaOccupied = IsOccupied

    OnFirstAgentEnters<private>(Agent:agent):void = 
        if(Player := player[Agent]):
            StageDevices.Screen.SetMaterial(MI_ReactorScreenGreen)

    OnLastAgentExits<private>(Agent:agent):void = 
        if(Player := player[Agent]):
            StageDevices.Screen.SetMaterial(MI_ReactorScreenRed)


    # IsAreaOccupied<public>()<transacts><decides>:void = 
    #     IsAreaOccupied?
    
    # OnPlayerEntersArea<private>(Agent:agent):void = 
    #     if(Task := sabotage_reactor_fail[ParentTask]):

            
    #     if(Player := player[Agent]):
    #         # SignalPlayerInteracts(Player)
    #         StageDevices.Screen.SetMaterial(MI_ReactorScreenGreen)

    # OnPlayerExitsArea<private>(Agent:agent):void = 
    #     if(Player := player[Agent]):
    #         # SignalPlayerFails(Player)
    #         StageDevices.Screen.SetMaterial(MI_ReactorScreenRed)