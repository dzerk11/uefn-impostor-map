
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Simulation }
using { ModuleAmongusModel }
using { Art.Textures.TaskIcons }
using { ModuleTasks }
# using { Modules.PlayerMap.Icons } 
using { Modules.ObjectiveIcons }

AgentToMsg<public><localizes>(Agent:agent):message="{Agent}"

MapCoordinatesMin:vector2 = vector2{X:=-10697.952912,Y:=-4961.641944}
MapCoordinatesMax:vector2 = vector2{X:=13466.047088,Y:=8750.358056}

DeltaMap_X:float = MapCoordinatesMax.X - MapCoordinatesMin.X
DeltaMap_Y:float = MapCoordinatesMax.Y - MapCoordinatesMin.Y

ConvertRealCoordinatesIntoMapRelative<public>(RealCoordinates:vector2):vector2 = 
    var X:float = (RealCoordinates.X - MapCoordinatesMin.X)/DeltaMap_X
    var Y:float = (RealCoordinates.Y - MapCoordinatesMin.Y)/DeltaMap_Y
    vector2{X:=X, Y:=Y}


GetTexture<public>(TaskName:task_name):texture =
    case(TaskName):
        task_name.AlignUpperEngine => T_TaskIcon_AlignEngine
        task_name.AlignLowerEngine => T_TaskIcon_AlignEngine
        task_name.Labyrinth => T_TaskIcon_Labyrinth
        task_name.CrazyPowerSupply => T_TaskIcon_CrazyPowerSupply
        task_name.CallEarth => T_TaskIcon_CallEarth
        task_name.PassCode => T_TaskIcon_Passcode
        task_name.ReactorNumbers => T_TaskIcon_ReactorNumbers
        task_name.ClearSpace => T_TaskIcon_ClearSpace
        task_name.Fuel => T_TaskIcon_Fuel
        task_name.Shields => T_TaskIcon_Shields
        task_name.SubmitScan => T_TaskIcon_SubmitScan
        task_name.TransferData => T_TaskIcon_TransferData
        task_name.EmptyGarbage => T_TaskIcon_EmptyGarbage
        task_name.DivertPower => T_TaskIcon_DivertPower
        # task_name.TuneSignal => T_TaskIcon_RadioSignal
        # task_name.FluidLevels => T_TaskIcon_FuelCaniste
        task_name.SabotageO2 => T_TaskIcon_OxygenDepletion
        task_name.SabotageReactorFail => T_TaskIcon_ReactorFail
        task_name.SabotageElectrical => T_TaskIcon_LightsOff
        task_name.SabotageComms => T_TaskIcon_NoComms
        task_name.SabotageLockDoors => T_TaskIcon_DoorsLocked
        _ => Art.Textures.T_Transparent

GetMaterialIcon<public>(TaskName:task_name):material =
    case(TaskName):
        task_name.AlignUpperEngine => MI_TaskIcon_AlignEngine
        task_name.AlignLowerEngine => MI_TaskIcon_AlignEngine
        task_name.Labyrinth => MI_TaskIcon_Labyrinth
        task_name.CrazyPowerSupply => MI_TaskIcon_CrazyPowerSupply
        task_name.CallEarth => MI_TaskIcon_CallEarth
        task_name.PassCode => MI_TaskIcon_Passcode
        task_name.ReactorNumbers => MI_TaskIcon_ReactorNumbers
        task_name.ClearSpace => MI_TaskIcon_ClearSpace
        task_name.Fuel => MI_TaskIcon_Fuel
        task_name.Shields => MI_TaskIcon_Shields
        task_name.SubmitScan => MI_TaskIcon_SubmitScan
        task_name.TransferData => MI_TaskIcon_TransferData
        task_name.EmptyGarbage => MI_TaskIcon_EmptyGarbage
        task_name.DivertPower => MI_TaskIcon_DivertPower
        task_name.SabotageO2 => Modules.PlayerMap.Icons.MI_SabotageIcon_OxygenDepletion
        task_name.SabotageReactorFail => Modules.PlayerMap.Icons.MI_SabotageIcon_ReactorFail
        task_name.SabotageElectrical => Modules.PlayerMap.Icons.MI_SabotageIcon_LightsOff
        task_name.SabotageComms => Modules.PlayerMap.Icons.MI_SabotageIcon_NoComms
        task_name.SabotageLockDoors => Modules.PlayerMap.Icons.MI_SabotageIcon_LockDoors
        _ => M_TaskIcon

# GetMaterial<public>(TaskName:task_name, IsImpostor:logic):material =
#     if(IsImpostor?):
#         case(TaskName):
#             task_name.AlignUpperEngine => MI_FakeTaskIcon_AlignEngine
#             task_name.AlignLowerEngine => MI_FakeTaskIcon_AlignEngine
#             task_name.Labyrinth => MI_FakeTaskIcon_Labyrinth
#             task_name.CrazyPowerSupply => MI_FakeTaskIcon_CrazyPowerSupply
#             task_name.CallEarth => MI_FakeTaskIcon_CallEarth
#             task_name.PassCode => MI_FakeTaskIcon_Passcode
#             task_name.ReactorNumbers => MI_FakeTaskIcon_Passcode
#             task_name.ClearSpace => MI_FakeTaskIcon_ClearSpace
#             task_name.Fuel => MI_FakeTaskIcon_Fuel
#             task_name.Shields => MI_FakeTaskIcon_Shields
#             task_name.SubmitScan => MI_FakeTaskIcon_SubmitScan
#             task_name.TransferData => MI_FakeTaskIcon_TransferData
#             task_name.EmptyGarbage => MI_FakeTaskIcon_EmptyGarbage
#             task_name.DivertPower => MI_FakeTaskIcon_DivertPower
#             task_name.SabotageO2 => MI_SabotageIcon_OxygenDepletion
#             task_name.SabotageReactorFail => MI_SabotageIcon_ReactorFail
#             task_name.SabotageElectrical => MI_SabotageIcon_LightsOff
#             task_name.SabotageComms => MI_SabotageIcon_NoComms
#             task_name.SabotageLockDoors => MI_SabotageIcon_LockDoors
#             _ => M_TaskIcon
#     else:
#         case(TaskName):
#             task_name.AlignUpperEngine => MI_TaskIcon_AlignEngine
#             task_name.AlignLowerEngine => MI_TaskIcon_AlignEngine
#             task_name.Labyrinth => MI_TaskIcon_Labyrinth
#             task_name.CrazyPowerSupply => MI_TaskIcon_CrazyPowerSupply
#             task_name.CallEarth => MI_TaskIcon_CallEarth
#             task_name.PassCode => MI_TaskIcon_Passcode
#             task_name.ReactorNumbers => MI_TaskIcon_Passcode
#             task_name.ClearSpace => MI_TaskIcon_ClearSpace
#             task_name.Fuel => MI_TaskIcon_Fuel
#             task_name.Shields => MI_TaskIcon_Shields
#             task_name.SubmitScan => MI_TaskIcon_SubmitScan
#             task_name.TransferData => MI_TaskIcon_TransferData
#             task_name.EmptyGarbage => MI_TaskIcon_EmptyGarbage
#             task_name.DivertPower => MI_TaskIcon_DivertPower
#             task_name.SabotageO2 => MI_SabotageIcon_OxygenDepletion
#             task_name.SabotageReactorFail => MI_SabotageIcon_ReactorFail
#             task_name.SabotageElectrical => MI_SabotageIcon_LightsOff
#             task_name.SabotageComms => MI_SabotageIcon_NoComms
#             task_name.SabotageLockDoors => MI_SabotageIcon_LockDoors
#             _ => M_TaskIcon


# GetMaterialIcon<public>(TaskName:task_name):material = 
#     case(TaskName):
#         task_name.AlignUpperEngine => Art.Materials.UI_Icons.MI_MapIcon_Engine
#         task_name.AlignLowerEngine => Art.Materials.UI_Icons.MI_MapIcon_Engine
#         task_name.Labyrinth => Art.Materials.UI_Icons.MI_MapIcon_Labyrinth
#         task_name.CrazyPowerSupply => Art.Materials.UI_Icons.MI_MapIcon_Electrical
#         # task_name.FluidLevels => Art.Materials.UI_Icons.MI_MapIcon_CallEarth2
#         task_name.CallEarth => Art.Materials.UI_Icons.MI_MapIcon_CallEarth2
#         task_name.PassCode => Art.Materials.UI_Icons.MI_MapIcon_PassCode
#         task_name.ReactorNumbers => Art.Materials.UI_Icons.MI_MapIcon_ReactorNumbers
#         # task_name.TuneSignal => Art.Materials.UI_Icons.MI_MapIcon_CallEarth2
#         task_name.ClearSpace => Art.Materials.UI_Icons.MI_MapIcon_ClearSpace
#         task_name.Fuel => Art.Materials.UI_Icons.MI_MapIcon_Fuel
#         task_name.Shields => Art.Materials.UI_Icons.MI_MapIcon_Shields
#         task_name.SubmitScan => Art.Materials.UI_Icons.MI_MapIcon_SubmitScan
#         task_name.TransferData => Art.Materials.UI_Icons.MI_MapIcon_TransferData
#         task_name.SabotageO2 => Art.Materials.UI_Icons.MI_MapIcon_SabotageO2
#         # task_name.SabotageLockDoors => Art.Materials.UI_Icons.MI_MapIcon_CallEarth2
#         task_name.SabotageReactorFail => Art.Materials.UI_Icons.MI_MapIcon_SabotageReactor
#         task_name.SabotageElectrical => Art.Materials.UI_Icons.MI_MapIcon_SabotageLightsOff
#         task_name.SabotageComms => Art.Materials.UI_Icons.MI_MapIcon_SabotageComms
#         _ => Art.Materials.UI_Icons.M_MapIcon