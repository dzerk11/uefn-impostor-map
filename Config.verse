using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/SpatialMath }

# --------------- [ Configuration - Teams ] ---------------

teamName<public> := enum:
    Lobby 
    Crewmates 
    Impostors
    Ghosts
    NONE

TeamIndexes<public>: [teamName]int = map{
    teamName.Lobby => 1,
    teamName.Crewmates => 2,
    teamName.Impostors => 3,
    teamName.Ghosts => 4
}

ToString<public>(TeamName: teamName):string =
    case(TeamName):
        teamName.Lobby => "Lobby"
        teamName.Crewmates => "Crewmates"
        teamName.Impostors => "Impostors"
        _ => "Undefined"



ImpostorsRateo<public>: int = 5;

# --------------- [ Configuration - Tasks ] ---------------

MAX_COMMON_TASKS<public>: int = 10;
MAX_SINGLE_TASKS<public>: int = 10;

map_locations<public> := enum:
    None
    Admin
    Cafeteria
    Communications
    Electrical
    LowerEngine
    MedBay
    Navigation
    O2
    Reactor
    Security
    Shields
    Storage
    UpperEngine
    Weapons





# --------------- [ Configuration - Map ] ---------------

