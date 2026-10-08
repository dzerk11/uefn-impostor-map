
using { /Fortnite.com/Devices }
using { /Fortnite.com }
using { /Fortnite.com/Teams }
using { /Fortnite.com/Game }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI}

using { ModuleLanguage }

# After you have published the current version of your island, if you make updates to the persistable data,
# any stored data from a previous version of the island must be supported in later versions of the island.

# ModulePersistence<internal> := module:

#     player_profile_data_stats<public> := class<final><persistable>:
#         TotalDeath:int = 0
#         TotalKills:int = 0
#         Rateo:int = 0

#     player_profile_data<public> := class<final><persistable>:
#         Version<public>:int = 0
        # Language<public>:ModuleLanguage.languages = ModuleLanguage.languages.IT

        # Stats:player_profile_data_stats = player_profile_data_stats{}
        # Score:int = 0
        # Rank:int = 0
    
    # GetLanguageFromPlayer(PlayerData:player_profile_data):?languages =
    #     return option{PlayerData.Language}
    
    # Struct<public>:= struct {
    #     Position<public>:int = 0
    # }


