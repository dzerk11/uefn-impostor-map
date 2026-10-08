
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }

task_devices_clear_space_rock<public> := class<final><concrete>:
    @editable
    Manipulator<public>:prop_manipulator_device = prop_manipulator_device{}
    @editable
    var Prop<public>:creative_prop = creative_prop{}
    @editable
    VfxSpawner<public>:?vfx_spawner_device = false
    @editable
    VfxSpawnerExplosion<public>:vfx_spawner_device = vfx_spawner_device{}
    @editable
    IsCoin<public>:logic = false

    var<private> HitsRequired<public>:int = 0
    var<private> HitsReceived<public>:int = 0

    InitHits<public>():void = 
        set HitsRequired = GetRandomInt(4, 15)
        set HitsReceived = 0

    SetNewHitReceived<public>():void = 
        set HitsReceived += 1
        Manipulator.RestoreHealth()

    IsDestroied<public>()<transacts><decides>:void = 
        HitsReceived >= HitsRequired

# Devices
stage_devices_clear_space<public> := class<final><concrete>(stage_devices):
    @editable
    CaptureAreaStartGame<public>:capture_area_device = capture_area_device{}
    @editable
    TeleportPlayerDismounted<public>:teleporter_device = teleporter_device{}
    @editable
    Rocks<public>:[]task_devices_clear_space_rock = array{}
    @editable
    Timer<public>:timer_device = timer_device{}
    @editable
    TriggerToMountTurret<public>:trigger_device = trigger_device{}

# Constructor
Make_stage_clear_space<public><constructor>(InLogger:log, ParentTask:task_basic, InTaskDevices:Tasks.task_devices_clear_space, InStageDevices:stage_devices_clear_space) := stage_clear_space:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices

    let:
        Translation := InStageDevices.CaptureAreaStartGame.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_clear_space<public> := class(stage_base):
    Location<override> :map_locations = map_locations.Weapons
    AllowMultiPlayer<override>:logic = false
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_clear_space

    var PlayerOldTransform<private>:vector3 = vector3{X:=0.0,Y:=0.0,Z:=0.0}
    var RockCancelables:[]cancelable = array{}
    var ClearSpaceView:?StageWidgets.view_clear_space = false

    Init<override>():void = 
        (super:)Init()
        Self.AppendCancelable(StageDevices.CaptureAreaStartGame.AgentEntersEvent.Subscribe(SignalPlayerInteracts))
        Self.AppendCancelable(StageDevices.TeleportPlayerDismounted.TeleportedEvent.Subscribe(OnPlayerDismountedByHimself))
        
        for(Rock:StageDevices.Rocks):
            Rock.Prop.Hide()

    HandleStage<override>(PlayerStageData:player_stage_data_base)<suspends>:void = 
        Player := PlayerStageData.Player
        if(FNCharacter:fort_character = Player.GetFortCharacter[]):
            StageDevices.TeleportPlayerDismounted.Disable()
            set PlayerOldTransform = FNCharacter.GetTransform().Translation

            # Rotate the player to look at the target point BEFORE mounting
            # The turret will teleport them to the correct position when they mount
            RotatePlayer(Player)

            # Small delay to ensure rotation is applied before mounting
            Sleep(0.1)

            # Mount the turret (this will teleport the player automatically)
            StageDevices.TriggerToMountTurret.Trigger(Player)

            # Disable capture area
            StageDevices.CaptureAreaStartGame.Disable()

            # Subscribe to rocks destroy
            
            for(Rock:StageDevices.Rocks):
                Rock.InitHits()

                set RockCancelables += array:
                    Rock.Manipulator.DamagedEvent.SubscribeAgent(OnRockHit, (Rock, PlayerStageData))

                if(VfxSpawner := Rock.VfxSpawner?):
                    VfxSpawner.Disable()

                Rock.Prop.Show()

            # Show clear space widget
            ClearSpaceViewIns := StageWidgets.Make_view_clear_space(Player)
            set ClearSpaceView = option{ClearSpaceViewIns}
            ClearSpaceViewIns.Show()
            ClearSpaceViewIns.UpdateRocksLeftRemaining(Self.CountRocksRemaining())

            # Start countdown
            StageDevices.Timer.Reset(Player)
            StageDevices.Timer.SetMaxDuration(30.0)
            StageDevices.Timer.Start(Player)
            StageDevices.TeleportPlayerDismounted.Enable()
            race:
                block:
                    loop:
                        RemainingTime := StageDevices.Timer.GetActiveDuration(Player)
                        if(SecondsLeft := Floor[RemainingTime]):
                            ClearSpaceViewIns.UpdateSecondsLeft(SecondsLeft)
                        Sleep(0.1)

                block:
                    MaybeAgent := StageDevices.Timer.SuccessEvent.Await()
                    if(Agent := MaybeAgent?, Player_ := player[Agent]):
                        Self.SignalPlayerFails(Player_)

                block:
                    MaybeAgent := StageDevices.Timer.FailureEvent.Await()
                    if(Agent := MaybeAgent?, _Player := player[Agent]):
                        Self.SignalPlayerFails(_Player)

                block:
                    PlayerStageData.EventForceStop.Await()
        else:
            Self.SignalPlayerFails(Player)

    CleanupStage<override>(PlayerStageData:player_stage_data_base):void =
        StageDevices.CaptureAreaStartGame.Enable()

        # Reset stage
        if(ClearSpaceViewIns := ClearSpaceView?):
            ClearSpaceViewIns.Destroy()

        StageDevices.Timer.Reset(PlayerStageData.Player)
        StageDevices.TeleportPlayerDismounted.Disable()

        UnMountPlayer(PlayerStageData.Player, PlayerOldTransform)

        # Reset rocks
        for(RockCancelable:RockCancelables):
            RockCancelable.Cancel()
        set RockCancelables = array{}

        for(Rock:StageDevices.Rocks):
            if(VfxSpawner:=Rock.VfxSpawner?):
                VfxSpawner.Disable()
            
    OnRockHit<private>(Agent:agent, Payload:tuple(task_devices_clear_space_rock, player_stage_data_base)):void = 
        Rock := Payload(0)
        PlayerStageData := Payload(1)

        if(Player := player[Agent]):
            Rock.SetNewHitReceived()

            if(Rock.IsDestroied[]):
                Rock.Prop.Hide()
                # Rock.VfxSpawnerExplosion.Disable()
                Rock.VfxSpawnerExplosion.Enable()
                Rock.VfxSpawnerExplosion.Restart()

                if(VfxSpawner := Rock.VfxSpawner?):
                    spawn:
                        HandleRockVfx(VfxSpawner, PlayerStageData)

                if(ClearSpaceViewIns := ClearSpaceView?):
                    ClearSpaceViewIns.UpdateRocksLeftRemaining(Self.CountRocksRemaining())

                if(CheckAllRocksDestroied[]):
                    Self.SignalPlayerCompletes(Player)

                if(Rock.IsCoin?):
                    SignalPlayerReward(Player, Utils.award_type.Coin)

    CheckAllRocksDestroied<private>()<transacts><decides>:void =
        for(Rock:StageDevices.Rocks, not Rock.IsCoin?):
            Rock.IsDestroied[]

    CountRocksRemaining<private>():int =
        var Count:int = 0
        for(Rock:StageDevices.Rocks, not Rock.IsCoin?, not Rock.IsDestroied[]):
            set Count += 1
        Count

    HandleRockVfx<private>(VfxSpawner:vfx_spawner_device, PlayerStageData:player_stage_data_base)<suspends>:void = 
        race:
            block:
                VfxSpawner.Enable()
                VfxSpawner.Restart()
                Sleep(10.0)
                VfxSpawner.Disable()

            PlayerStageData.EventForceStop.Await()

        VfxSpawner.Disable()

    OnPlayerDismountedByHimself<private>(Agent:agent):void = 
        if(Player := player[Agent]):
            Self.SignalPlayerFails(Player)

    UnMountPlayer<private>(Player:player, OldPosition:vector3):void =
        if:
            Player.IsActive[]
            FNCharacter:fort_character = Player.GetFortCharacter[]
            FNCharacter.TeleportTo[vector3{X:=7086.842133, Y:=-1877.16452, Z:=2250.842984}, FNCharacter.GetViewRotation()]

    RotatePlayer(Player:player) : void =
        if (Character := Player.GetFortCharacter[]):
            # Get current position to keep player where they are
            CurrentPosition := Character.GetTransform().Translation

            # The turret position where player will be mounted 
            TurretPosition := vector3{X := 24115.738378, Y := -25006.007803, Z := 935.978702}

            # Target point to look at
            TargetPoint := vector3{X := 27463.791213, Y := -30695.661391, Z := 725.340009}

            # Calculate direction vector from turret to target
            DeltaForward := TargetPoint.X - TurretPosition.X
            DeltaRight := TargetPoint.Y - TurretPosition.Y
            DeltaUp := TargetPoint.Z - TurretPosition.Z

            # Calculate yaw (rotation around Z-up axis, from +X forward toward +Y right)
            YawRadians := ArcTan(DeltaRight, DeltaForward)

            # Calculate horizontal distance for pitch
            HorizontalDistance := Sqrt((DeltaForward * DeltaForward) + (DeltaRight * DeltaRight))

            # Calculate pitch (rotation to look up/down)
            PitchRadians := ArcTan(DeltaUp, HorizontalDistance)

            # Convert to degrees
            YawDegrees := RadiansToDegrees(YawRadians)
            PitchDegrees := RadiansToDegrees(PitchRadians)

            # Create rotation
            LookAtRotation := MakeRotationFromYawPitchRollDegrees(YawDegrees, PitchDegrees, 0.0)

            # Apply rotation to character at current position
            if (Character.TeleportTo[CurrentPosition, LookAtRotation]):
                Logger.Normal("Player rotated. Yaw: {YawDegrees}, Pitch: {PitchDegrees}")
            else:
                Logger.Normal("Failed to rotate player")


