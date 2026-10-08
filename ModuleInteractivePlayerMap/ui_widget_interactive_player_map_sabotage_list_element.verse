

using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }



Make_ui_widget_interactive_player_map_list_element_task<constructor><public>(InTaskName:ModuleTasks.task_name, InTaskId:int, InIcon:texture, InLocation:message, InColor:color, TaskCompletion:string) := ui_widget_interactive_player_map_list_element:
    let:
        _Icon := texture_block:
            DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}
            DefaultImage := InIcon
            DefaultTint := InColor
        
        _Name := text_block:
            DefaultText := Ui.GetMsgTaskName(InTaskName)
            DefaultTextColor := NamedColors.White

        _Location := text_block:
            DefaultText := InLocation
            DefaultTextOpacity := 0.9
            DefaultTextColor := NamedColors.DarkGray

        _Completion := text_block:
            DefaultText := StringToMsg(TaskCompletion)
            DefaultTextColor := NamedColors.White

    Icon := _Icon
    Name := _Name
    Location := _Location
    Completion := _Completion

    Widget := stack_box:
        Orientation := orientation.Horizontal
        Slots := array:

            stack_box_slot:
                VerticalAlignment := vertical_alignment.Center
                HorizontalAlignment := horizontal_alignment.Left
                Padding := margin{Left := 0.0, Top := 8.0, Right := 16.0, Bottom := 8.0}
                Widget := _Icon

            stack_box_slot:
                VerticalAlignment := vertical_alignment.Center
                HorizontalAlignment := horizontal_alignment.Left
                Widget := overlay:
                    Slots := array:

                        overlay_slot:
                            HorizontalAlignment := horizontal_alignment.Left
                            VerticalAlignment := vertical_alignment.Top
                            Padding := margin{Bottom:=32.0}
                            Widget := _Name

                        overlay_slot:
                            HorizontalAlignment := horizontal_alignment.Left
                            VerticalAlignment := vertical_alignment.Bottom
                            Padding := margin{Left:=16.0, Top:=32.0}
                            Widget := _Location

            stack_box_slot:
                VerticalAlignment := vertical_alignment.Center
                HorizontalAlignment := horizontal_alignment.Right
                Distribution := option{1.0}
                Widget := _Completion


Make_ui_widget_interactive_player_map_list_element_sabotage<constructor><public>(InTaskName:ModuleTasks.task_name, InTaskNameStringified:string, InTaskId:int, InIcon:texture, InLocation:string, InColor:color) := ui_widget_interactive_player_map_list_element:
    let:
        _Icon := texture_block:
            DefaultDesiredSize := vector2{X:=80.0, Y:=80.0}
            DefaultImage := InIcon
            DefaultTint := InColor
        
        _Name := text_block:
            DefaultText := StringToMsg(InTaskNameStringified)
            DefaultTextColor := NamedColors.White

        _Location := text_block:
            DefaultText := StringToMsg(InLocation)
            DefaultTextOpacity := 0.9
            DefaultTextColor := NamedColors.DarkGray

    Icon := _Icon
    Name := _Name
    Location := _Location

    Widget := stack_box:
        Orientation := orientation.Horizontal
        Slots := array:

            stack_box_slot:
                VerticalAlignment := vertical_alignment.Center
                HorizontalAlignment := horizontal_alignment.Left
                Padding := margin{Left := 0.0, Top := 8.0, Right := 16.0, Bottom := 8.0}
                Widget := _Icon

            stack_box_slot:
                VerticalAlignment := vertical_alignment.Center
                HorizontalAlignment := horizontal_alignment.Left
                Widget := overlay:
                    Slots := array:

                        overlay_slot:
                            HorizontalAlignment := horizontal_alignment.Left
                            VerticalAlignment := vertical_alignment.Top
                            Padding := margin{Bottom:=32.0}
                            Widget := _Name

                        overlay_slot:
                            HorizontalAlignment := horizontal_alignment.Left
                            VerticalAlignment := vertical_alignment.Bottom
                            Padding := margin{Left:=16.0, Top:=32.0}
                            Widget := _Location


ui_widget_interactive_player_map_list_element<public> := class:
    Widget<public>:widget
    Icon<public>:texture_block
    Name<public>:text_block
    Location<public>:text_block
    Completion<public>:text_block = text_block{}
    