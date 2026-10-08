
using { /Verse.org/Assets }
using { /Verse.org/Colors }

task_info<public> := class:
    TaskName<public>:task_name
    TaskType<public>:task_type
    TaskIcon<public>:texture
    StagesInfo<public>:[]stage_info
    IsCompleted<public>:logic

    GetStagesCompleted<public>():[]stage_info = 
        for(StageInfo:Self.StagesInfo, StageInfo.IsCompleted?):
            StageInfo

    GetCompletableStages<public>():[]stage_info =
        var CompletableStages:[]stage_info = array{}
        var StageOrderCompletable:int = 9999
        for(StageInfo:Self.StagesInfo, not StageInfo.IsCompleted?):
            if(StageOrderCompletable > StageInfo.StageOrder):
                set StageOrderCompletable = StageInfo.StageOrder
                set CompletableStages = array:
                    StageInfo
            else if(StageOrderCompletable = StageInfo.StageOrder):
                set CompletableStages += array:
                    StageInfo

        CompletableStages

