
player_task_list<public>:=class:
    var StageDataList:[]player_stage_data_base = array{}
    
    AddTask(Task:player_stage_data_base):void = 
        set StageDataList += array{Task}

    RemoveTask(Task:player_stage_data_base):void = 
        set StageDataList += array{Task}
