using { ModuleTasks }

MsgEmpty<localizes>:message = ""

MsgLocationCafeteria<localizes>:message = "Cafeteria"
MsgLocationComms<localizes>:message = "Communications"
MsgLocationElectrical<localizes>:message = "Electrical"
MsgLocationMedBay<localizes>:message = "MedBay"
MsgLocationSecurity<localizes>:message = "Security"
MsgLocationShields<localizes>:message = "Shields"
MsgLocationWeapons<localizes>:message = "Weapons"
MsgLocationAdmin<localizes>:message = "Admin"
MsgLocationO2<localizes>:message = "O2"
MsgLocationStorage<localizes>:message = "Storage"
MsgLocationUpperEngine<localizes>:message = "Upper Engine"
MsgLocationLowerEngine<localizes>:message = "Lower Engine"
MsgLocationReactor<localizes>:message = "Reactor"
MsgLocationNavigation<localizes>:message = "Navigation"

GetMsgLocation(Location:map_locations):message =
    case(Location):
        map_locations.Cafeteria => MsgLocationCafeteria
        map_locations.Communications => MsgLocationComms
        map_locations.Electrical => MsgLocationElectrical
        map_locations.MedBay => MsgLocationMedBay
        map_locations.Security => MsgLocationSecurity
        map_locations.Shields => MsgLocationShields
        map_locations.Weapons => MsgLocationWeapons
        map_locations.Admin => MsgLocationAdmin
        map_locations.O2 => MsgLocationO2
        map_locations.Storage => MsgLocationStorage
        map_locations.UpperEngine => MsgLocationUpperEngine
        map_locations.LowerEngine => MsgLocationLowerEngine
        map_locations.Reactor => MsgLocationReactor
        map_locations.Navigation => MsgLocationNavigation
        _ => MsgEmpty


MsgTaskAlignUpperEngine<localizes>:message = "Align Upper Engine"
MsgTaskAlignLowerEngine<localizes>:message = "Align Lower Engine"
MsgTaskLabyrinth<localizes>:message = "Labyrinth"
MsgTaskCrazyPowerSupply<localizes>:message = "Crazy Power Supply"
MsgTaskFluidLevels<localizes>:message = "Fluid Levels"
MsgTaskCallEarth<localizes>:message = "Call Earth"
MsgTaskPassCode<localizes>:message = "Pass Code"
MsgTaskPassCodeSecurity<localizes>:message = "Repeat Password"
MsgTaskReactorNumbers<localizes>:message = "Reactor Startup"
MsgTaskTuneSignal<localizes>:message = "Tune Signal"
MsgTaskClearSpace<localizes>:message = "Clear Space"
MsgTaskFuel<localizes>:message = "Fuel"
MsgTaskShields<localizes>:message = "Shields"
MsgTaskSubmitScan<localizes>:message = "Submit Scan"
MsgTaskDivertPower<localizes>:message = "Divert Power"
MsgTaskTransferData<localizes>:message = "Transfer Data"
MsgTaskEmptyGarbage<localizes>:message = "Empty Garbage"
MsgTaskSabotageO2<localizes>:message = "Sabotage O2"
MsgTaskSabotageLockDoors<localizes>:message = "Sabotage Lock Doors"
MsgTaskSabotageReactorFail<localizes>:message = "Sabotage Reactor Fail"
MsgTaskSabotageElectrical<localizes>:message = "Sabotage Electrical"
MsgTaskSabotageComms<localizes>:message = "Sabotage Comms"


MsgSabotageOxygenDepletion<public><localizes>:message = "O2 Flow Compromised"
MsgSabotageReactorMeltdown<public><localizes>:message = "Nuclear Core Overloading"
MsgSabotageLightsOff<public><localizes>:message = "Lighting Systems Down"
MsgSabotageCommunications<public><localizes>:message = "Communications Down"
MsgSabotageDoorsLocked<public><localizes>:message = "Doors locked"

GetMsgSabotageName<public>(SabotageName:ModuleTasks.task_name):message =
    case(SabotageName):
        task_name.SabotageO2 => MsgSabotageOxygenDepletion
        task_name.SabotageReactorFail => MsgSabotageReactorMeltdown
        task_name.SabotageElectrical => MsgSabotageLightsOff
        task_name.SabotageComms => MsgSabotageCommunications
        task_name.SabotageLockDoors => MsgSabotageDoorsLocked
        _ => MsgEmpty

GetMsgTaskName<public>(TaskName:ModuleTasks.task_name):message =
    case(TaskName):
        task_name.AlignUpperEngine => MsgTaskAlignUpperEngine
        task_name.AlignLowerEngine => MsgTaskAlignLowerEngine
        task_name.Labyrinth => MsgTaskLabyrinth
        task_name.CrazyPowerSupply => MsgTaskCrazyPowerSupply
        task_name.FluidLevels => MsgTaskFluidLevels
        task_name.CallEarth => MsgTaskCallEarth
        task_name.PassCode => MsgTaskPassCode
        task_name.PassCodeSecurity => MsgTaskPassCodeSecurity
        task_name.ReactorNumbers => MsgTaskReactorNumbers
        task_name.TuneSignal => MsgTaskTuneSignal
        task_name.ClearSpace => MsgTaskClearSpace
        task_name.Fuel => MsgTaskFuel
        task_name.Shields => MsgTaskShields
        task_name.SubmitScan => MsgTaskSubmitScan
        task_name.DivertPower => MsgTaskDivertPower
        task_name.TransferData => MsgTaskTransferData
        task_name.EmptyGarbage => MsgTaskEmptyGarbage
        task_name.SabotageO2 => MsgTaskSabotageO2
        task_name.SabotageLockDoors => MsgTaskSabotageLockDoors
        task_name.SabotageReactorFail => MsgTaskSabotageReactorFail
        task_name.SabotageElectrical => MsgTaskSabotageElectrical
        task_name.SabotageComms => MsgTaskSabotageComms
        task_name.None => MsgEmpty

MsgColorPink<public><localizes>:message = "Pink"
MsgColorOrange<public><localizes>:message = "Orange"
MsgColorGreen<public><localizes>:message = "Green"
MsgColorLime<public><localizes>:message = "Lime"
MsgColorPurple<public><localizes>:message = "Purple"
MsgColorRed<public><localizes>:message = "Red"
MsgColorCyan<public><localizes>:message = "Cyan"
MsgColorYellow<public><localizes>:message = "Yellow"
MsgColorBrown<public><localizes>:message = "Brown"
MsgColorBlack<public><localizes>:message = "Black"
MsgColorWhite<public><localizes>:message = "White"
MsgColorBlue<public><localizes>:message = "Blue"
MsgColorNone<public><localizes>:message = ""

GetMsgAmongusColor<public>(Color:amongus_color):message =
    case(Color):
        amongus_color.Pink => MsgColorPink
        amongus_color.Orange => MsgColorOrange
        amongus_color.Green => MsgColorGreen
        amongus_color.Lime => MsgColorLime
        amongus_color.Purple => MsgColorPurple
        amongus_color.Red => MsgColorRed
        amongus_color.Cyan => MsgColorCyan
        amongus_color.Yellow => MsgColorYellow
        amongus_color.Brown => MsgColorBrown
        amongus_color.Black => MsgColorBlack
        amongus_color.White => MsgColorWhite
        amongus_color.Blue => MsgColorBlue
        _ => MsgEmpty


MsgRoleImpostor<public><localizes>:message = "Impostor"
MsgRoleCrewmate<public><localizes>:message = "Crewmate"