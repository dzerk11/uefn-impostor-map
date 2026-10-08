
using { /Verse.org/Simulation }


player_stage_data_base<public>:=class:
    TaskName<public>:task_name
    StageId<public>:int
    Player<public>:player
    var HasCompleted:logic = false
    var IsPlaying:logic = false
    var IsCompletable:logic = false
    var StageWidget:?StageWidgets.stage_widget = false
    EventForceStop<public>:event() = event(){}



