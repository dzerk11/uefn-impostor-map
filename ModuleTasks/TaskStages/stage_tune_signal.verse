
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Devices
stage_devices_tune_signal<public> := class<final><concrete>(stage_devices):
    @editable
    SoundDataTransfered<public>:audio_player_device = audio_player_device{}
    @editable
    SkilledInteraction<public>:skilled_interaction_device = skilled_interaction_device{}


# Constructor
Make_stage_tune_signal<public><constructor>(InLogger:log, ParentTask:task_basic, InStageDevices:stage_devices_tune_signal) := stage_tune_signal:
    Logger := InLogger
    ParentTask := ParentTask
    TaskName := ParentTask.Name
    StageDevices := InStageDevices
    
    let:
        Translation := InStageDevices.TaskPanel.GetTransform().Translation
    Coordinates := vector2{X:=Translation.X, Y:=Translation.Y}


# Class
stage_tune_signal<public> := class(stage_base):
    Location<override> :map_locations = map_locations.Cafeteria
    AllowMultiPlayer<override>:logic = true
    StageOrder<override>:int = 0
    StageDevices<override>:stage_devices_tune_signal

    HandleStage<override>(PlayerStageData:player_stage_data_base)<suspends>:void = {}
        # if:
        #     StageDevices.SkilledInteraction.BeginInteraction[PlayerStageData.Player]
        # then:
        #     race:
        #         block:
        #             StageDevices.SkilledInteraction.InteractionCanceledEvent.Await()
        #             SignalPlayerFails(PlayerStageData.Player)
        #         block:
        #             StageDevices.SkilledInteraction.InteractionFailedEvent.Await()
        #             SignalPlayerFails(PlayerStageData.Player)
        #         block:
        #             StageDevices.SkilledInteraction.InteractionSucceededEvent.Await()
        #             SignalPlayerCompletes(PlayerStageData.Player)

        #         StageEvents.EventPlayerStageFailed.Await()

        # if:
        #     StageDevices.SkilledInteraction.EndInteraction[PlayerStageData.Player]

                