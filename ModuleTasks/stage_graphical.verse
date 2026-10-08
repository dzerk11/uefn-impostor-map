
# using { /Verse.org/Simulation }


# stage_graphical<public> := class(stage_base):
#     var PlayerUis<private>:[player]?StageWidgets.stage_widget = map{}

#     OnStop<override>(Player:player, StageEvents:stage_events):void =
#         if(set PlayerUis[Player] = false){}

#     MakeUi<internal>(InPlayer:player):?StageWidgets.stage_widget =
#         false

#     SetStageUi<protected>(InPlayer:player, StageWidget:StageWidgets.stage_widget):void = 
#         if(set PlayerUis[InPlayer] = option{StageWidget}){}

#     GetStageUi<public>(Player:player)<transacts><decides>:StageWidgets.stage_widget = 
#         PlayerUis[Player]?