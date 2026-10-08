
gameplay_role<public> := enum:
    Impostor
    Crewmate
    None

# Team indices
TEAM_LOBBY<public>:int = 0
TEAM_IMPOSTOR<public>:int = 1
TEAM_CREWMATE<public>:int = 1
TEAM_GHOST<public>:int = 3
TEAM_REVEAL<public>:int = 61

ToString(In:gameplay_role):string =
    case(In):
        gameplay_role.Impostor => "Impostor"
        gameplay_role.Crewmate => "Crewmate"
        gameplay_role.None => "None"