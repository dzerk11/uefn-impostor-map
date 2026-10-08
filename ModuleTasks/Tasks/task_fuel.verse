
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_fuel := class(log_channel){}

# Devices
task_devices_fuel<public> := class<final><concrete>(task_devices_basic):
    @editable
    Stage0<public>:TaskStages.stage_devices_fuel_fill_canister = TaskStages.stage_devices_fuel_fill_canister{}
    @editable
    StageFillLowerEngine<public>:TaskStages.stage_devices_fuel_fill_engine = TaskStages.stage_devices_fuel_fill_engine{}
    @editable
    StageFillUpperEngine<public>:TaskStages.stage_devices_fuel_fill_engine = TaskStages.stage_devices_fuel_fill_engine{}


# Class
task_fuel<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_fuel}
    Name<override>:task_name = task_name.Fuel
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_Fuel
    @editable TaskDevices<public>:task_devices_fuel = task_devices_fuel{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_fuel_fill_canister(Logger, Self, TaskDevices.Stage0)
            TaskStages.Make_stage_fuel_fill_engine(Logger, Self, TaskDevices.StageFillLowerEngine, map_locations.LowerEngine)
            TaskStages.Make_stage_fuel_fill_engine(Logger, Self, TaskDevices.StageFillUpperEngine, map_locations.UpperEngine)

    # Assign player
    AssignPlayer<override>(Player:player):logic =
        if(not Self.IsAssigned[Player]):
            if:
                # Assign to fill canister
                StageFillCanister := Stages[0]
                StageFillCanister.AssignPlayer[Player]

                # Assign to engine
                StageFillEngine := Stages[GetRandomInt(1,2)]
                StageFillEngine.AssignPlayer[Player]

            then:
                Logger.Debug("Player assigned to task: {Name}")
                set PlayersAssigned += array{Player}
                StageFillCanister.SetCompletable(Player)
                true
            else:
                Logger.Warning("Unable to assign player to task {Name} due to stage failures.")
                false
        else:
            Logger.Warning("Unable to assign player to task {Name}. Player already assigned.")
            false
