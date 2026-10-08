
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }

emergency_meeting_participant<internal> := class:
    APlayer<internal>:amongus_player
    OldTranslation<internal>:vector3 = vector3{}
    CanBeVoted<internal>:logic
    CanVote<internal>:logic
    var Widget<internal>:?ui_widget_voting_tablet = false

    var HasVoted<internal>:?player = false
    var VotesReceived<internal>:[]player = array{}





        