

using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /Fortnite.com/UI }

using { Modules.PlayerMap.SabotageButtons }


# sabotage_button_struct<public> := struct:
#     Id : int
#     Coordinates : vector2  
#     Location : map_locations
#     TaskName : ModuleTasks.task_name


# GetButtonBackgroundWidget<public>(TaskName:ModuleTasks.task_name, Location:map_locations):widget =
#     case(TaskName):
#         # ModuleTasks.task_name.AlignUpperEngine => T_Icon_AlignEngine
#         # ModuleTasks.task_name.AlignLowerEngine => T_Icon_AlignEngine
#         # ModuleTasks.task_name.Labyrinth => T_Icon_Spaceship
#         # ModuleTasks.task_name.CrazyPowerSupply => T_Icon_Electricity
#         # ModuleTasks.task_name.CallEarth => T_Icon_RadioSignal
#         # ModuleTasks.task_name.PassCode => T_Icon_Passcode
#         # ModuleTasks.task_name.ReactorNumbers => T_Icon_Passcode
#         # ModuleTasks.task_name.ClearSpace => T_Icon_Asteroid
#         # ModuleTasks.task_name.Fuel => T_Icon_FuelCanister
#         # ModuleTasks.task_name.Shields => T_Icon_Shields
#         # ModuleTasks.task_name.SubmitScan => T_Icon_Scan
#         # ModuleTasks.task_name.TransferData => T_Icon_Transfer
#         ModuleTasks.task_name.SabotageO2 => WBP_SabBtn_OxygenDepletion{}
#         ModuleTasks.task_name.SabotageReactorFail => WBP_SabBtn_ReactorFail{}
#         ModuleTasks.task_name.SabotageElectrical => WBP_SabBtn_LightsOff{}
#         ModuleTasks.task_name.SabotageComms => WBP_SabBtn_NoComms{}
#         ModuleTasks.task_name.SabotageLockDoors => 
#             case(Location):
#                 map_locations.UpperEngine => WBP_SabBtn_LockDoorsUpperEngine{}
#                 map_locations.LowerEngine => WBP_SabBtn_LockDoorsLowerEngine{}
#                 map_locations.Cafeteria => WBP_SabBtn_LockDoorsCafeteria{}
#                 map_locations.Storage => WBP_SabBtn_LockDoorsStorage{}
#                 map_locations.Security => WBP_SabBtn_LockDoorsSecurity{}
#                 map_locations.MedBay => WBP_SabBtn_LockDoorsMedbay{}
#                 map_locations.Electrical => WBP_SabBtn_LockDoorsElectrical{}
#                 _ => WBP_SabBtn_LockDoorsLowerEngine{}
#         _ => WBP_SabBtn_LockDoorsLowerEngine{}


# Make_sabotage_button<public><constructor>(Id:int, Coordinates:vector2, Location:map_locations, TaskName:ModuleTasks.task_name, OnSabotageButtonClick:(tuple(int, ModuleTasks.task_name)->void)) := ui_widget_sabotage_button_base:
#     Id := Id
#     TaskName := TaskName
#     Location := Location
#     Coordinates := Coordinates
#     CallbackOnClick := OnSabotageButtonClick
#     IconImage := Ui.GetTexture(TaskName)
    # WidgetBackground := GetButtonBackgroundWidget(TaskName, Location)




# Make_sabotage_btn_lock_doors<internal><constructor>(Coordinates:vector2, Location:map_locations, Id:int, OnSabotageButtonClick:(tuple(int, ModuleTasks.task_name)->void)) := ui_widget_sabotage_map_button_base:
#     TaskName := ModuleTasks.task_name.SabotageLockDoors
#     IconImage := Art.Textures.Icons.MapIcons.T_Icon_LockDoor
#     Coordinates := Coordinates
#     Location := Location
#     Id := Id
#     CallbackOnClick := OnSabotageButtonClick

# Make_sabotage_btn_lock_doors_upper_engine<public><constructor>(Coordinates:vector2, OnSabotageButtonClick:(tuple(int, ModuleTasks.task_name)->void)) := ui_widget_sabotage_map_button_base:
#     Make_sabotage_btn_lock_doors<constructor>(Coordinates, map_locations.UpperEngine, 15, OnSabotageButtonClick)

# Make_sabotage_btn_lock_doors_lower_engine<public><constructor>(Coordinates:vector2, OnSabotageButtonClick:(tuple(int, ModuleTasks.task_name)->void)) := ui_widget_sabotage_map_button_base:
#     Make_sabotage_btn_lock_doors<constructor>(Coordinates, map_locations.LowerEngine, 14, OnSabotageButtonClick)

# Make_sabotage_btn_lock_doors_medbay<public><constructor>(Coordinates:vector2, OnSabotageButtonClick:(tuple(int, ModuleTasks.task_name)->void)) := ui_widget_sabotage_map_button_base:
#     Make_sabotage_btn_lock_doors<constructor>(Coordinates, map_locations.LowerEngine, 14, OnSabotageButtonClick)




    # ui_widget_sabotage_map_button_lock_door{Id:=15, Coordinates:=vector2{X := 0.16, Y := 0.30}, Location :=map_locations.UpperEngine, CallbackOnClick := OnSabotageButtonClick},
    #             ui_widget_sabotage_map_button_lock_door{Id:=14, Coordinates:=vector2{X := 0.16, Y := 0.70}, Location:=map_locations.LowerEngine, CallbackOnClick := OnSabotageButtonClick},
    #             ui_widget_sabotage_map_button_lock_door{Id:=17, Coordinates:=vector2{X := 0.36, Y := 0.37}, Location:=map_locations.MedBay, CallbackOnClick := OnSabotageButtonClick},
    #             ui_widget_sabotage_map_button_lock_door{Id:=12, Coordinates:=vector2{X := 0.535, Y := 0.33}, Location:=map_locations.Cafeteria, CallbackOnClick := OnSabotageButtonClick},
    #             ui_widget_sabotage_map_button_lock_door{Id:=18, Coordinates:=vector2{X := 0.515, Y := 0.8}, Location:=map_locations.Storage, CallbackOnClick := OnSabotageButtonClick},
    #             ui_widget_sabotage_map_button_lock_door{Id:=13, Coordinates:=vector2{X := 0.385, Y := 0.72}, Location:=map_locations.Electrical, CallbackOnClick := OnSabotageButtonClick},
    #             ui_widget_sabotage_map_button_lock_door{Id:=16, Coordinates:=vector2{X := 0.23, Y := 0.50}, Location:=map_locations.Security, CallbackOnClick := OnSabotageButtonClick},
    #             ui_widget_sabotage_map_button_stop_comms{Id:=20, Coordinates:=vector2{X := 0.65, Y := 0.85}, Location:=map_locations.Communications, CallbackOnClick := OnSabotageButtonClick}


# sabotage_map_button_style_enum<internal> := enum:
#     Default
#     Enabled
#     Disabled
#     SabotageRunning
#     Pressed


# sabotage_map_button_style<internal> := class:
#     # BackgroundBox
#     BackgroundBoxSize<public>:tuple(float,float)
#     BackgroundBoxColor<public>:color
#     BackgroundBoxOpacity<public>:type {_X:float where 0.000000 <= _X, _X <= 1.000000}
#     # InnerBox
#     InnerBoxSize<public>:tuple(float,float)
#     InnerBoxColor<public>:color
#     InnerBoxOpacity<public>:type {_X:float where 0.000000 <= _X, _X <= 1.000000}
#     # Icon
#     IconSize<public>:vector2 := vector2{X := 60.0, Y := 60.0}

# sabotage_map_button_style_enabled<internal> := class(sabotage_map_button_style):
#     BackgroundBoxSize<override>:tuple(float,float) = (76.0,76.0)
#     # BackgroundBoxColor := MakeColorFromHex("#f2f2f2")
#     BackgroundBoxColor<override>:color = MakeColorFromHex("#ba3030")
#     # BackgroundBoxColor<override>:color = MakeColorFromHex("#4f4f4f")
#     BackgroundBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.9
#     InnerBoxSize<override>:tuple(float,float) = (68.0,68.0)
#     InnerBoxColor<override>:color = MakeColorFromHex("#000")
#     InnerBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.2

# sabotage_map_button_style_disabled<internal> := class(sabotage_map_button_style):
#     BackgroundBoxSize<override>:tuple(float,float) = (76.0,76.0)
#     BackgroundBoxColor<override>:color = MakeColorFromHex("#ba3030")
#     BackgroundBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.8
#     InnerBoxSize<override>:tuple(float,float) = (68.0,68.0)
#     InnerBoxColor<override>:color = MakeColorFromHex("#fff")
#     InnerBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.6

# sabotage_map_button_style_pressed<internal> := class(sabotage_map_button_style):
#     BackgroundBoxSize<override>:tuple(float,float) = (76.0,76.0)
#     BackgroundBoxColor<override>:color = MakeColorFromHex("#o3k34d")
#     BackgroundBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.8
#     InnerBoxSize<override>:tuple(float,float) = (68.0,68.0)
#     InnerBoxColor<override>:color = MakeColorFromHex("#fff")
#     InnerBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.6

# sabotage_map_button_style_sabotage_running<internal> := class(sabotage_map_button_style):
#     BackgroundBoxSize<override>:tuple(float,float) = (150.0,150.0)
#     BackgroundBoxColor<override>:color = NamedColors.Red
#     BackgroundBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.8
#     InnerBoxSize<override>:tuple(float,float) = (68.0,68.0)
#     InnerBoxColor<override>:color = NamedColors.Red
#     InnerBoxOpacity<override>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.6

# DummyCallbackOnClick<internal>(Id:int, TaskName:ModuleTasks.task_name):void = {}

ui_widget_sabotage_button_base<public> := class():
    Id<public>:int
    TaskName<public>:ModuleTasks.task_name
    IconImage<public>:texture
    IconColor<public>:color := MakeColorFromHex("fff")
    Coordinates<public>:vector2
    Location<public>:map_locations

    CallbackOnClick<public>:(tuple(int, ModuleTasks.task_name)->void)

    var Widget<private>:widget = canvas:

    WidgetIcon<private>:texture_block = texture_block:
        DefaultImage := Art.Textures.T_Transparent
        DefaultDesiredSize := vector2{X:=48.0, Y:=48.0}

    WidgetBackground<public>:widget

    RedBorder<public>:widget = WBP_SabBtn_BorderEnabled{}

    var<private> IsActive<public>:logic = true

    Button<private>:button_quiet = button_quiet{}
    var ButtonSubCancelable<private>:?cancelable = false
    var ButtonSubCancelable2<private>:?cancelable = false

    Init<public>():void =
        WidgetIcon.SetImage(IconImage)
        WidgetIcon.SetTint(IconColor)

        RedBorder.SetVisibility(widget_visibility.Collapsed)

        ButtonWrapped := button:
            Slot := button_slot:
                Widget := overlay:
                    Slots := array:

                        # overlay_slot:
                        #     HorizontalAlignment := horizontal_alignment.Center
                        #     VerticalAlignment := vertical_alignment.Center
                        #     Padding := margin{Top := 18.0, Left := 18.0, Right := 18.0, Bottom := 18.0}
                        #     Widget := WidgetIcon

                        overlay_slot:
                            Padding := margin{Top := 3.0, Left := 3.0, Right := 3.0, Bottom := 3.0}
                            HorizontalAlignment := horizontal_alignment.Fill
                            VerticalAlignment := vertical_alignment.Fill
                            Widget := Button

                        overlay_slot:
                            Padding := margin{Top := 3.0, Left := 3.0, Right := 3.0, Bottom := 3.0}
                            HorizontalAlignment := horizontal_alignment.Fill
                            VerticalAlignment := vertical_alignment.Fill
                            Widget := WidgetBackground

        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 90.0, Bottom := 90.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := ButtonWrapped
                

        
        ButtonSubCancelable_ := Button.OnClick().Subscribe(OnButtonPressed)
        ButtonSubCancelable2_ButtonWrapped := ButtonWrapped.OnClick().Subscribe(OnButtonPressed)
        set ButtonSubCancelable = option{ButtonSubCancelable_}
        set ButtonSubCancelable2 = option{ButtonSubCancelable2_ButtonWrapped}

    Destroy<public>():void = 
        if(ButtonSubCancelable_ := ButtonSubCancelable?):
            ButtonSubCancelable_.Cancel()
        if(ButtonSubCancelable_ := ButtonSubCancelable2?):
            ButtonSubCancelable_.Cancel()
            
    # Hide<public>():void =
    #     Widget.SetVisibility(widget_visibility.Hidden)

    # Show<public>():void =
    #     Widget.SetVisibility(widget_visibility.Visible)

    Disable<public>():void = 
        set IsActive = false
        # Widget.SetEnabled(false)
        # Button.SetEnabled(false)
        # SetStyle(sabotage_map_button_style_enum.Disabled)

    Enable<public>():void = 
        set IsActive = true
        # Widget.SetEnabled(true)
        # Button.SetEnabled(true)
        # SetStyle(sabotage_map_button_style_enum.Enabled)

    SetSabotageActive(State:logic):void =
        if(State?):
            RedBorder.SetVisibility(widget_visibility.Visible)
        else:
            RedBorder.SetVisibility(widget_visibility.Collapsed)

    # PressAnimation<public>():void = 
    #     set IsActive = false
    #     Widget.SetEnabled(false)
    #     Button.SetEnabled(false)
        # SetStyle(sabotage_map_button_style_enum.Pressed)
        # spawn:
        #     ButtonCooldown()
        
    OnButtonPressed<private>(WidgetMessage:widget_message):void = 
        if(IsActive?):
            # PressAnimation()
            WidgetIcon.SetTint(MakeColorFromHex("#656565ff"))
            CallbackOnClick(Self.Id, Self.TaskName) 

    # ButtonCooldown<private>()<suspends>:void =
    #     # SetStyle(sabotage_map_button_style_enum.Pressed)
    #     Sleep(0.3)
    #     Self.Enable()

    # GetWidget<public>():widget = 
        # Widget

    GetCanvasSlot<public>():canvas_slot =
        canvas_slot:
            Anchors := anchors{Minimum := Coordinates, Maximum := Coordinates}
            Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
            Alignment := vector2{X := 0.5, Y := 0.5}
            SizeToContent := true
            ZOrder := 5
            Widget := Widget

    # SetStyle<private>(InStyle:sabotage_map_button_style_enum):void = 

    #     var MaybeStyleToSet:?sabotage_map_button_style = false

    #     case(InStyle):
    #         sabotage_map_button_style_enum.Enabled =>
    #             set MaybeStyleToSet = option{sabotage_map_button_style_enabled{}}

    #         # sabotage_map_button_style_enum.Disabled =>
    #         #     if(not _ActiveStyleName = sabotage_map_button_style_enum.SabotageRunning):
    #         #     set MaybeStyleToSet = option{sabotage_map_button_style_disabled{}}

    #         # sabotage_map_button_style_enum.Pressed =>
    #         #     if(not _ActiveStyleName = sabotage_map_button_style_enum.SabotageRunning):
    #         #         set MaybeStyleToSet = option{sabotage_map_button_style_pressed{}}

    #         sabotage_map_button_style_enum.SabotageRunning => 
    #             set MaybeStyleToSet = option{sabotage_map_button_style_sabotage_running{}}
            
    #         _ =>

    #     if(Style := MaybeStyleToSet?):
    #         set ActiveStyle = Style
    #         set ActiveStyleName = InStyle
    #         WidgetBackgroundBox.SetTint(Style.BackgroundBoxColor)
    #         # _WidgetBackgroundBox.SetOpacity(Style.BackgroundBoxOpacity)
    #         WidgetInnerBox.SetColor(Style.InnerBoxColor)
    #         WidgetInnerBox.SetOpacity(Style.InnerBoxOpacity)

    # ActiveSabotage<public>():void = 
    #     SetStyle(sabotage_map_button_style_enum.SabotageRunning)

    # DeActiveSabotage<public>():void = 
    #     SetStyle(sabotage_map_button_style_enum.Default)





