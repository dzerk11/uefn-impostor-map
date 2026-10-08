
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_task_upload_transfer_data := class(log_channel){}


# Devices
task_devices_transfer_data<public> := class<final><concrete>(task_devices_basic):  
    @editable
    DownloadWeapons<public>:TaskStages.stage_devices_transfer_data_download = TaskStages.stage_devices_transfer_data_download{}
    @editable
    DownloadCafeteria<public>:TaskStages.stage_devices_transfer_data_download = TaskStages.stage_devices_transfer_data_download{}
    @editable
    DownloadElectrical<public>:TaskStages.stage_devices_transfer_data_download = TaskStages.stage_devices_transfer_data_download{}
    @editable
    DownloadNavigation<public>:TaskStages.stage_devices_transfer_data_download = TaskStages.stage_devices_transfer_data_download{}
    @editable
    DownloadCommunications<public>:TaskStages.stage_devices_transfer_data_download = TaskStages.stage_devices_transfer_data_download{}
    @editable
    Upload<public>:TaskStages.stage_devices_transfer_data_upload = TaskStages.stage_devices_transfer_data_upload{}


# Class
task_upload_transfer_data<public><final> := class(task_basic):
    Logger<override>:log = log{Channel:=log_task_upload_transfer_data}
    Name<override>:task_name = task_name.TransferData
    TaskIcon<override>:texture := Art.Textures.TaskIcons.T_TaskIcon_TransferData
    @editable TaskDevices<public>:task_devices_transfer_data = task_devices_transfer_data{}

    OnInit<override>():void =
        set Stages = array:
            TaskStages.Make_stage_transfer_data_download(Logger, Self, TaskDevices.DownloadWeapons, map_locations.Weapons)
            TaskStages.Make_stage_transfer_data_download(Logger, Self, TaskDevices.DownloadCafeteria, map_locations.Cafeteria)
            TaskStages.Make_stage_transfer_data_download(Logger, Self, TaskDevices.DownloadElectrical, map_locations.Electrical)
            TaskStages.Make_stage_transfer_data_download(Logger, Self, TaskDevices.DownloadNavigation, map_locations.Navigation)
            TaskStages.Make_stage_transfer_data_download(Logger, Self, TaskDevices.DownloadCommunications, map_locations.Communications)
            TaskStages.Make_stage_transfer_data_upload(Logger, Self, TaskDevices.Upload)

    # Assign player
    AssignPlayer<override>(Player:player):logic =
        if(not Self.IsAssigned[Player]):
            if:
                # Assign to download
                StageDownload := Stages[GetRandomInt(0,4)]
                StageDownload.AssignPlayer[Player]

                # Assign to upload
                StageUpload := Stages[5]
                StageUpload.AssignPlayer[Player]

            then:
                Logger.Debug("Player assigned to task: {Name}")
                set PlayersAssigned += array{Player}
                StageDownload.SetCompletable(Player)
                true
            else:
                Logger.Warning("Unable to assign player to task {Name} due to stage failures.")
                false
        else:
            Logger.Warning("Unable to assign player to task {Name}. Player already assigned.")
            false