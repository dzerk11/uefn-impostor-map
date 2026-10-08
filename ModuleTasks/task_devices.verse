
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

task_devices_basic<public> := class<concrete>{}

sabotage_devices_basic<public> := class<concrete>(task_devices_basic):
    @editable SequenceCooldown<public>:cinematic_sequence_device = cinematic_sequence_device{}

task_devices<public> := class<concrete>:
    @editable    SabotageOxygenDepletion<public>:Tasks.task_devices_sabotage_oxygen_depletion = Tasks.task_devices_sabotage_oxygen_depletion{}
    @editable    SabotageReactorFail<public>:Tasks.task_devices_sabotage_reactor_fail = Tasks.task_devices_sabotage_reactor_fail{}
    @editable    SabotageLockDoors<public>:Tasks.task_devices_sabotage_lock_doors = Tasks.task_devices_sabotage_lock_doors{}
    @editable    SabotageComms<public>:Tasks.task_devices_sabotage_comms = Tasks.task_devices_sabotage_comms{}
    @editable    SabotageElectrical<public>:Tasks.task_devices_sabotage_electrical = Tasks.task_devices_sabotage_electrical{}
    @editable    PassCode<public>:Tasks.task_devices_pass_code = Tasks.task_devices_pass_code{}
    @editable    FluidLevels<public>:task_devices_basic = task_devices_basic{}
    @editable    TuneSignal<public>:Tasks.task_devices_tune_signal = Tasks.task_devices_tune_signal{}
    @editable    CrazyPowerSupply<public>:Tasks.task_devices_crazyPowerSupply = Tasks.task_devices_crazyPowerSupply{}
    @editable    Fuel<public>:Tasks.task_devices_fuel = Tasks.task_devices_fuel{}
    @editable    Shields<public>:Tasks.task_devices_shields = Tasks.task_devices_shields{}
    @editable    DivertPower<public>:Tasks.task_devices_divert_power = Tasks.task_devices_divert_power{}
    @editable    SubmitScan<public>:Tasks.task_devices_submit_scan = Tasks.task_devices_submit_scan{}
    @editable    ReactorNumbers<public>:Tasks.task_devices_reactor_numbers = Tasks.task_devices_reactor_numbers{}
    @editable    CallEarth<public>:Tasks.task_devices_call_earth = Tasks.task_devices_call_earth{}
    @editable    Labyrinth<public>:Tasks.task_devices_labyrinth = Tasks.task_devices_labyrinth{}
    @editable    ClearSpace<public>:Tasks.task_devices_clear_space = Tasks.task_devices_clear_space{}
    @editable    TransferData<public>:Tasks.task_devices_transfer_data = Tasks.task_devices_transfer_data{}
    @editable    AlignUpperEngine<public>:Tasks.task_devices_align_engine = Tasks.task_devices_align_engine{}
    @editable    AlignLowerEngine<public>:Tasks.task_devices_align_engine = Tasks.task_devices_align_engine{}
    @editable    AccoladeMedium<public>:accolades_device = accolades_device{}
    
    