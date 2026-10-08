
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { ModuleAmongusPlayspace }

gamephase_class_log := class(log_channel){}

gamephase<public> := enum:
    None
    Lobby
    GameRound

ToString<public>(InGamePhase:gamephase):string =
    case (InGamePhase):
        gamephase.None => "None",
        gamephase.Lobby => "Lobby",
        gamephase.GameRound => "GameRound"

gamephase_class<internal> := class(creative_device, lifecycle):
    Logger<protected>:log = log{Channel:=gamephase_class_log, DefaultLevel:=log_level.Debug}
    @editable EventManager<protected>:event_manager = event_manager{}
    
    Dispose<override>():void = {}
    Init<override>():void = {}
    
