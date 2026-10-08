
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath }
using {/Verse.org/Random}
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Devices }

using { Modules.TaskAssets.Labyrinth }

# 0 - wall
# 1 - floor
# 2 - end
# 3 - trap
# 4 - coin
# 5 - 
# 6 - player facing top
# 7 - player facing left
# 8 - player facing bottom
# 9 - player facing right


StageWidgetLabyrinth_MapIntToBlockType<internal>:[int]stage_widget_labyrinth_block_types = map:
    0 => stage_widget_labyrinth_block_types.Wall
    1 => stage_widget_labyrinth_block_types.Floor_
    2 => stage_widget_labyrinth_block_types.End
    3 => stage_widget_labyrinth_block_types.Trap
    4 => stage_widget_labyrinth_block_types.Coin
    6 => stage_widget_labyrinth_block_types.SpaceshipNorth
    7 => stage_widget_labyrinth_block_types.SpaceshipWest
    8 => stage_widget_labyrinth_block_types.SpaceshipSouth
    9 => stage_widget_labyrinth_block_types.SpaceshipEast


StageWidgetLabyrinth_MapBlockTypeToDirection<internal>:[stage_widget_labyrinth_block_types]cardinal_direction = map:
    stage_widget_labyrinth_block_types.SpaceshipNorth => cardinal_direction.North
    stage_widget_labyrinth_block_types.SpaceshipWest => cardinal_direction.West
    stage_widget_labyrinth_block_types.SpaceshipSouth => cardinal_direction.South
    stage_widget_labyrinth_block_types.SpaceshipEast => cardinal_direction.East


StageWidgetLabyrinth_DirectionToBlockType<internal>:[cardinal_direction]stage_widget_labyrinth_block_types = map:
    cardinal_direction.North => stage_widget_labyrinth_block_types.SpaceshipNorth
    cardinal_direction.West => stage_widget_labyrinth_block_types.SpaceshipWest 
    cardinal_direction.South => stage_widget_labyrinth_block_types.SpaceshipSouth
    cardinal_direction.East => stage_widget_labyrinth_block_types.SpaceshipEast


StageWidgetLabyrinthModels<internal>:[int][][]int = map:
    0 => array:
        array{0,0,0,0,0,0,0,0}
        array{0,4,3,0,0,3,0,0}
        array{0,1,1,1,1,1,0,0}
        array{0,0,1,3,0,1,0,0}
        array{0,0,1,0,1,1,0,0}
        array{0,9,1,0,1,0,0,0}
        array{0,0,0,0,1,1,2,0}
        array{0,0,0,0,0,0,0,0}
    1 => array:
        array{0,0,0,0,0,0,0,0}
        array{0,0,0,1,0,3,0,0}
        array{0,0,3,1,1,1,4,0}
        array{0,0,0,1,0,1,3,0}
        array{0,0,0,1,0,1,0,0}
        array{0,9,1,1,0,1,0,0}
        array{0,0,0,0,2,1,3,0}
        array{0,0,0,0,0,0,0,0}
    2 => array:
        array{0,0,0,0,0,0,0,0}
        array{0,0,1,1,2,0,0,0}
        array{0,0,1,3,0,0,0,0}
        array{0,3,1,1,1,1,0,0}
        array{0,1,1,0,0,1,0,0}
        array{0,1,3,0,1,1,1,0}
        array{0,4,0,0,6,0,0,0}
        array{0,0,0,0,0,0,0,0}
    3 => array:
        array{0,0,0,0,0,0,0,0}
        array{0,3,1,1,1,1,7,0}
        array{0,0,1,0,0,0,0,0}
        array{0,1,1,0,0,0,0,0}
        array{0,1,3,1,1,1,3,0}
        array{0,1,1,1,0,1,0,0}
        array{0,4,0,0,0,2,0,0}
        array{0,0,0,0,0,0,0,0}


stage_widget_labyrinth_block_types<internal> := enum:
    Wall
    Floor_
    End
    Trap
    Coin
    SpaceshipNorth
    SpaceshipWest
    SpaceshipSouth
    SpaceshipEast

stage_widget_labyrinth_spaceship_position<internal> := struct:
    X<public>:int
    Y<public>:int
    CardinalDirection<public>:cardinal_direction


TexturesAsteroids<internal>:[]texture = array:
    T_icon_asteroid1
    T_icon_asteroid2


stage_widget_labyrinth_block<internal> := class:
    
    Background<private>:texture_block = texture_block:
        DefaultImage := Art.Textures.T_Transparent
        DefaultDesiredSize := vector2{X := 75.0, Y := 75.0}

    Icon<private>:texture_block = texture_block:
        DefaultImage := Art.Textures.T_Transparent
        DefaultDesiredSize := vector2{X := 64.0, Y := 64.0}

    var Type<internal>:stage_widget_labyrinth_block_types = stage_widget_labyrinth_block_types.Floor_

    GetBackground<internal>():texture_block = 
        Background

    GetIcon<internal>():texture_block = 
        Icon

    SetBlockColor<internal>(BlockType:stage_widget_labyrinth_block_types):void = 
        case(BlockType):
            stage_widget_labyrinth_block_types.Wall => 
                set Type = stage_widget_labyrinth_block_types.Wall
                Background.SetImage(Art.Textures.T_Transparent)
                RandomInt := GetRandomInt(0, TexturesAsteroids.Length-1)
                if(WallTexture:=TexturesAsteroids[RandomInt]):
                    Icon.SetImage(WallTexture)

            stage_widget_labyrinth_block_types.Floor_ => 
                set Type = stage_widget_labyrinth_block_types.Floor_
                Background.SetImage(Art.Textures.T_Transparent)
                Icon.SetImage(Art.Textures.T_Transparent)

            stage_widget_labyrinth_block_types.End => 
                set Type = stage_widget_labyrinth_block_types.End
                Background.SetImage(Art.Textures.T_Transparent)
                # Background.SetTint(NamedColors.PaleGreen)
                Icon.SetImage(T_icon_planet)

            stage_widget_labyrinth_block_types.Trap => 
                set Type = stage_widget_labyrinth_block_types.Trap
                Background.SetImage(Art.Textures.T_Transparent)
                # Background.SetTint(NamedColors.Tomato)
                Icon.SetImage(T_icon_alien)

            stage_widget_labyrinth_block_types.Coin => 
                set Type = stage_widget_labyrinth_block_types.Coin
                Background.SetImage(Art.Textures.T_Transparent)
                Icon.SetImage(T_icon_coin)

            stage_widget_labyrinth_block_types.SpaceshipNorth => 
                set Type = stage_widget_labyrinth_block_types.SpaceshipNorth
                Background.SetImage(Art.Textures.T_Transparent)
                Icon.SetImage(T_icon_spaceship_top)
                
            stage_widget_labyrinth_block_types.SpaceshipWest => 
                set Type = stage_widget_labyrinth_block_types.SpaceshipWest
                Background.SetImage(Art.Textures.T_Transparent)
                Icon.SetImage(T_icon_spaceship_left)
                
            stage_widget_labyrinth_block_types.SpaceshipSouth => 
                set Type = stage_widget_labyrinth_block_types.SpaceshipSouth
                Background.SetImage(Art.Textures.T_Transparent)
                Icon.SetImage(T_icon_spaceship_bottom)
                
            stage_widget_labyrinth_block_types.SpaceshipEast => 
                set Type = stage_widget_labyrinth_block_types.SpaceshipEast
                Background.SetImage(Art.Textures.T_Transparent)
                Icon.SetImage(T_icon_spaceship_right)
 

Make_stage_widget_labyrinth<constructor><public>(InLogger:log, InPlayer:player, InStageOrder:int, InStageDevices:ModuleTasks.TaskStages.stage_devices_labyrinth, StageController:stage_controller) := stage_widget_labyrinth:
    StageDevices := InStageDevices
    StageController := StageController
    Player := InPlayer
    BlockModel := GetRandomInt(0,StageWidgetLabyrinthModels.Length-1)

stage_widget_labyrinth<public> := class(stage_widget):
    StageDevices<override>:ModuleTasks.TaskStages.stage_devices_labyrinth
    BlockModel<public>:int
        
    var WidgetDirectionalButtons<private>:[]tuple(text_button_base, cardinal_direction, string, float) = array:

    var Blocks<private>:[][]stage_widget_labyrinth_block = array{}

    var SpaceshipPosition<private>:stage_widget_labyrinth_spaceship_position = stage_widget_labyrinth_spaceship_position:
        X:=-1
        Y:=-1
        CardinalDirection:=cardinal_direction.North

    OnInit<override>():void =
        CreateBlocks()
        
        # I have to create them here due to a bug, tuple inside array are shared by players
        set WidgetDirectionalButtons = array:
            (button_quiet{}, cardinal_direction.North, "▲", 0.356)
            (button_quiet{}, cardinal_direction.East,"►", 0.447948)
            (button_quiet{}, cardinal_direction.West,"◄", 0.54732)
            (button_quiet{}, cardinal_direction.South,"▼", 0.643416)
                                                    
        set Widget = canvas:
            Slots := array:

                canvas_slot:
                    ZOrder := 0
                    SizeToContent := false
                    Widget := WidgetBackShadow

                canvas_slot:
                    ZOrder := 1
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    Widget := WBP_Labyrinth{}

                canvas_slot:
                    ZOrder := 2
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 1300.0, Bottom := 1000.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := canvas:
                        Slots := array{

                            canvas_slot:
                                Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                                Offsets := margin{Top := 0.0, Left := -95.0, Right := 850.0, Bottom := 850.0}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                ZOrder := 0
                                Widget := canvas:
                                    Slots := array:

                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.55}, Maximum := vector2{X := 0.5, Y := 0.55}}
                                            Alignment := vector2{X := 0.5, Y := 0.5}
                                            SizeToContent := true
                                            Widget := stack_box:
                                                Orientation := orientation.Vertical
                                                Slots := 
                                                    for (RowIndex -> Row : Blocks):
                                                        var StackBoxWidgetsRow:[]stack_box_slot = array{}

                                                        for(BlockIndex -> Block : Row):
                                                            set StackBoxWidgetsRow += array:
                                                                stack_box_slot:
                                                                    HorizontalAlignment:=horizontal_alignment.Fill
                                                                    VerticalAlignment:=vertical_alignment.Center
                                                                    Padding:=margin{Top := 2.0, Left := 2.0, Right := 2.0, Bottom := 2.0}
                                                                    Widget:= overlay:
                                                                        Slots:=array:
                                                                            overlay_slot:
                                                                                Widget := Block.GetBackground()
                                                                            overlay_slot:
                                                                                Widget := Block.GetIcon()
                                                                
                                                        stack_box_slot:
                                                            HorizontalAlignment := horizontal_alignment.Center
                                                            VerticalAlignment := vertical_alignment.Center
                                                            Padding := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                                            Widget := stack_box:
                                                                Orientation := orientation.Horizontal
                                                                Slots := StackBoxWidgetsRow

                            canvas_slot:
                                ZOrder := 1
                                Anchors := anchors{Minimum := vector2{X := 0.87345, Y := 0.834941}, Maximum := vector2{X := 0.87345, Y := 0.834941}}
                                Offsets := margin{Top := -0.667334, Left := 1.835169, Right := 188.135727, Bottom := 91.279373}
                                Alignment := vector2{X := 0.5, Y := 0.5}
                                SizeToContent := false
                                Widget := canvas:
                                    Slots := array:
                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                            Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                            Alignment := vector2{X := 0.5, Y := 0.5}
                                            SizeToContent := false
                                            Widget := CreateExitButton()

                            } + for(Index->WidgetTuple:WidgetDirectionalButtons):
                                WidgetTuple(0).SetText(StringToMsg(WidgetTuple(2)))
                                Cancelable:= WidgetTuple(0).OnClick().SubscribeWidgetMessage(OnButtonDirectionClick,WidgetTuple(1))
                                Subscriptions.Add(Cancelable)
                                
                                canvas_slot:
                                    ZOrder := 1
                                    Anchors := anchors{Minimum := vector2{X := 0.873811, Y := WidgetTuple(3)}, Maximum := vector2{X := 0.873811, Y := WidgetTuple(3)}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 75.0, Bottom := 66.5}
                                    Alignment := vector2{X := 0.5, Y := 0.5}
                                    SizeToContent := false
                                    Widget := canvas:
                                        Slots := array:
                                            canvas_slot:
                                                Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                                                Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                SizeToContent := false
                                                Widget := WidgetTuple(0)

    CreateBlocks<private>():void = 
        if(Model := StageWidgetLabyrinthModels[BlockModel]):
            for(RowIndex->Row : Model):
                var NewRow:[]stage_widget_labyrinth_block = array{}
                for(ColumnIndex -> IndexBlockType : Model[RowIndex]):
                    if(BlockType := StageWidgetLabyrinth_MapIntToBlockType[IndexBlockType]):

                        if(CardinalDirection:=StageWidgetLabyrinth_MapBlockTypeToDirection[BlockType]):
                            set SpaceshipPosition = stage_widget_labyrinth_spaceship_position:
                                X := ColumnIndex
                                Y := RowIndex
                                CardinalDirection := CardinalDirection

                        Block := stage_widget_labyrinth_block{}
                        Block.SetBlockColor(BlockType)

                        set NewRow += array:
                            Block

                set Blocks += array{NewRow}

    MoveSpaceshipTo<private>(CardinalDirection:cardinal_direction):void = 

        # Old player block
        if(Block:=Blocks[SpaceshipPosition.Y][SpaceshipPosition.X]):
            var NewCoordinatesX:int = -1
            var NewCoordinatesY:int = -1

            case(CardinalDirection):
                cardinal_direction.North => 
                    set NewCoordinatesX = SpaceshipPosition.X
                    set NewCoordinatesY = SpaceshipPosition.Y - 1

                cardinal_direction.East => 
                    set NewCoordinatesX = SpaceshipPosition.X + 1
                    set NewCoordinatesY = SpaceshipPosition.Y

                cardinal_direction.South => 
                    set NewCoordinatesX = SpaceshipPosition.X
                    set NewCoordinatesY = SpaceshipPosition.Y + 1

                cardinal_direction.West => 
                    set NewCoordinatesX = SpaceshipPosition.X - 1
                    set NewCoordinatesY = SpaceshipPosition.Y
            
            if(NextBlock := Blocks[NewCoordinatesY][NewCoordinatesX]):
                if(NewSpaceshipType := StageWidgetLabyrinth_DirectionToBlockType[CardinalDirection]):
                    if(NextBlock.Type = stage_widget_labyrinth_block_types.Floor_):
                        # move spaceship here
                        NextBlock.SetBlockColor(NewSpaceshipType)
                        # remove spaceship from last block
                        Block.SetBlockColor(stage_widget_labyrinth_block_types.Floor_)
                        # update spaceship position
                        set SpaceshipPosition = stage_widget_labyrinth_spaceship_position:
                            X := NewCoordinatesX
                            Y := NewCoordinatesY
                            CardinalDirection := CardinalDirection

                    else if(NextBlock.Type = stage_widget_labyrinth_block_types.End):
                        # move spaceship here
                        NextBlock.SetBlockColor(NewSpaceshipType)
                        # remove spaceship from last block
                        Block.SetBlockColor(stage_widget_labyrinth_block_types.Floor_)
                        # update spaceship position
                        set SpaceshipPosition = stage_widget_labyrinth_spaceship_position:
                            X := NewCoordinatesX
                            Y := NewCoordinatesY
                            CardinalDirection := CardinalDirection

                        SignalPlayerCompletes()

                    else if(NextBlock.Type = stage_widget_labyrinth_block_types.Trap):
                        # move spaceship here
                        NextBlock.SetBlockColor(NewSpaceshipType)
                        # remove spaceship from last block
                        Block.SetBlockColor(stage_widget_labyrinth_block_types.Floor_)
                        # update spaceship position
                        set SpaceshipPosition = stage_widget_labyrinth_spaceship_position:
                            X := NewCoordinatesX
                            Y := NewCoordinatesY
                            CardinalDirection := CardinalDirection

                        SignalPlayerFails()

                    else if(NextBlock.Type = stage_widget_labyrinth_block_types.Coin):
                        # move spaceship here
                        NextBlock.SetBlockColor(NewSpaceshipType)
                        # remove spaceship from last block
                        Block.SetBlockColor(stage_widget_labyrinth_block_types.Floor_)
                        # update spaceship position
                        set SpaceshipPosition = stage_widget_labyrinth_spaceship_position:
                            X := NewCoordinatesX
                            Y := NewCoordinatesY
                            CardinalDirection := CardinalDirection

                        SignalPlayerReward(Utils.award_type.Coin)

                    else:
                        # Print("play sound")
                        Block.SetBlockColor(NewSpaceshipType)

    OnButtonDirectionClick<private>(WidgetMessage:widget_message, CardinalDirection:cardinal_direction):void = 
        # Print("{CardinalDirection}")
        MoveSpaceshipTo(CardinalDirection)
        case(CardinalDirection):
            cardinal_direction.North => 
            cardinal_direction.South => 
            cardinal_direction.East => 
            cardinal_direction.West => 


    
