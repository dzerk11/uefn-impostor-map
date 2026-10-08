
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Concurrency }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }

dead_bodies_controller<public> := class(creative_device):
    @editable DeadBody_Pink:button_device = button_device{}
    @editable DeadBody_Orange:button_device = button_device{}
    @editable DeadBody_Green:button_device = button_device{}
    @editable DeadBody_Lime:button_device = button_device{}
    @editable DeadBody_Purple:button_device = button_device{}
    @editable DeadBody_Red:button_device = button_device{}
    @editable DeadBody_Cyan:button_device = button_device{}
    @editable DeadBody_Yellow:button_device = button_device{}
    @editable DeadBody_Brown:button_device = button_device{}
    @editable DeadBody_Black:button_device = button_device{}
    @editable DeadBody_White:button_device = button_device{}
    @editable DeadBody_Blue:button_device = button_device{}

    @editable VfxSpawner_Pink:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Orange:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Green:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Lime:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Purple:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Red:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Cyan:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Yellow:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Brown:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Black:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_White:vfx_spawner_device = vfx_spawner_device{}
    @editable VfxSpawner_Blue:vfx_spawner_device = vfx_spawner_device{}

    @editable Ghost_Pink:creative_prop = creative_prop{}
    @editable Ghost_Orange:creative_prop = creative_prop{}
    @editable Ghost_Green:creative_prop = creative_prop{}
    @editable Ghost_Lime:creative_prop = creative_prop{}
    @editable Ghost_Purple:creative_prop = creative_prop{}
    @editable Ghost_Red:creative_prop = creative_prop{}
    @editable Ghost_Cyan:creative_prop = creative_prop{}
    @editable Ghost_Yellow:creative_prop = creative_prop{}
    @editable Ghost_Brown:creative_prop = creative_prop{}
    @editable Ghost_Black:creative_prop = creative_prop{}
    @editable Ghost_White:creative_prop = creative_prop{}
    @editable Ghost_Blue:creative_prop = creative_prop{}

    var<private>DeadBodies<public>:[amongus_color]button_device = map{}
    var<private>VfxSpawners<public>:[amongus_color]vfx_spawner_device = map{}
    var<private>DeadBodiesDefaultPosition<public>:[amongus_color]transform = map{}
    var<private>Cancelables<public>:[amongus_color]cancelable = map{}

    var<private>Ghosts<public>:[amongus_color]creative_prop = map{}
    var<private>GhostDefaultPositions<private>:[amongus_color]transform = map{}
    var<private>GhostCancelEvents<private>:[amongus_color]event() = map{}

    EventBodyReported<public>:custom_subscribable(tuple(agent, amongus_color)) = custom_subscribable(tuple(agent, amongus_color)){}


    OnBegin<override>():void = 
        set DeadBodies = map:
            amongus_color.Pink => DeadBody_Pink
            amongus_color.Orange => DeadBody_Orange
            amongus_color.Green => DeadBody_Green
            amongus_color.Lime => DeadBody_Lime
            amongus_color.Purple => DeadBody_Purple
            amongus_color.Red => DeadBody_Red
            amongus_color.Cyan => DeadBody_Cyan
            amongus_color.Yellow => DeadBody_Yellow
            amongus_color.Brown => DeadBody_Brown
            amongus_color.Black => DeadBody_Black
            amongus_color.White => DeadBody_White
            amongus_color.Blue => DeadBody_Blue

        set VfxSpawners = map:
            amongus_color.Pink => VfxSpawner_Pink
            amongus_color.Orange => VfxSpawner_Orange
            amongus_color.Green => VfxSpawner_Green
            amongus_color.Lime => VfxSpawner_Lime
            amongus_color.Purple => VfxSpawner_Purple
            amongus_color.Red => VfxSpawner_Red
            amongus_color.Cyan => VfxSpawner_Cyan
            amongus_color.Yellow => VfxSpawner_Yellow
            amongus_color.Brown => VfxSpawner_Brown
            amongus_color.Black => VfxSpawner_Black
            amongus_color.White => VfxSpawner_White
            amongus_color.Blue => VfxSpawner_Blue

        set Ghosts = map:
            amongus_color.Pink => Ghost_Pink
            amongus_color.Orange => Ghost_Orange
            amongus_color.Green => Ghost_Green
            amongus_color.Lime => Ghost_Lime
            amongus_color.Purple => Ghost_Purple
            amongus_color.Red => Ghost_Red
            amongus_color.Cyan => Ghost_Cyan
            amongus_color.Yellow => Ghost_Yellow
            amongus_color.Brown => Ghost_Brown
            amongus_color.Black => Ghost_Black
            amongus_color.White => Ghost_White
            amongus_color.Blue => Ghost_Blue

        for(DeadBodyColor->Button:DeadBodies):
            Transform := Button.GetTransform()
            if(set DeadBodiesDefaultPosition[DeadBodyColor] = Transform){}

        for(GhostColor->Ghost:Ghosts):
            GhostTransform := Ghost.GetTransform()
            if(set GhostDefaultPositions[GhostColor] = GhostTransform){}

        for(Vfx:VfxSpawners):
            Vfx.Disable()
            Vfx.Enable()

    BringIn<public>(Color:amongus_color, Transform:transform, ?Enabled:logic=true):void = 
        if:
            Button := DeadBodies[Color]
            Button.TeleportTo[Transform]
            VfxSpawner := VfxSpawners[Color]
            VfxSpawner.TeleportTo[Transform]
        then:
            if(Enabled?):
                Button.InteractedWithEvent.SubscribeAgent(_OnInteract, Color)
                Button.Enable()
            else:
                Button.Disable()
                
            spawn:
                PlayEffects(VfxSpawner)

    Dispose<public>(Color:amongus_color):void = 
        if:
            Button := DeadBodies[Color]
            Transform := DeadBodiesDefaultPosition[Color]
            # Cancelable := Cancelables[Color]
            VfxSpawner := VfxSpawners[Color]
            Button.TeleportTo[Transform]
        then:
            # Cancelable.Cancel()
            VfxSpawner.Disable()
            Print("disposed!")


    _OnInteract<public>(Agent:agent, Model:amongus_color):void = 
        EventBodyReported.Signal(Agent, Model)
        Dispose(Model)

    SpawnGhost<public>(Color:amongus_color, Player:player):void =
        # Stop existing ghost loop if any
        if(ExistingEvent := GhostCancelEvents[Color]):
            ExistingEvent.Signal()
        if(Ghost := Ghosts[Color]):
            CancelEvent := event(){}
            if(set GhostCancelEvents[Color] = CancelEvent){}
            spawn:
                GhostTrackLoop(Ghost, Player, CancelEvent)

    DisposeGhost<public>(Color:amongus_color):void =
        if(CancelEvent := GhostCancelEvents[Color]):
            CancelEvent.Signal()
        if:
            Ghost := Ghosts[Color]
            DefaultPos := GhostDefaultPositions[Color]
            Ghost.TeleportTo[DefaultPos]

    GhostTrackLoop<private>(Ghost:creative_prop, Player:player, CancelEvent:event())<suspends>:void =
        if(FortCharacter := Player.GetFortCharacter[]):
            FortCharacter.Hide()
            race:
                CancelEvent.Await()
                block:
                    VelocityScale := 7.0
                    FloatAmplitude := 10.0
                    FloatSpeed := 2.0 * 3.141593 / 90.0 # Full sine cycle every ~3s at 30fps
                    var FloatTime:float = 0.0
                    loop:
                        set FloatTime += FloatSpeed
                        FloatOffset := (Sin(FloatTime) + 1.0) * FloatAmplitude

                        Transform := FortCharacter.GetTransform()
                        CurrentPosition := Transform.Translation
                        ViewRotation := FortCharacter.GetViewRotation()
                        Forward := ViewRotation.GetLocalForward()

                        # GetLinearVelocity ritorna /Verse.org/SpatialMath vector3
                        # Forward = X, Left = -Y, Up = Z
                        Velocity := FortCharacter.GetLinearVelocity()

                        OffsetPosition := vector3:
                            X := CurrentPosition.X + Velocity.Forward * VelocityScale
                            Y := CurrentPosition.Y - Velocity.Left * VelocityScale
                            Z := CurrentPosition.Z + FloatOffset

                        if:
                            Ghost.TeleportTo[transform{Translation := OffsetPosition, Rotation := Transform.Rotation}]
                        Sleep(0.0)
            FortCharacter.Show()

    PlayEffects<private>(Vfx:vfx_spawner_device)<suspends>:void =
        Vfx.Disable()
        Sleep(0.0)
        Vfx.Enable()
        Sleep(1.0)