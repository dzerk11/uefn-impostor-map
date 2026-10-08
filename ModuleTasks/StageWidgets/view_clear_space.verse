
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }

using {Modules.TaskAssets.ClearSpace}

Make_view_clear_space<public><constructor>(Player:player) := view_clear_space:
    Player := Player

view_clear_space<public> := class(Ui.ui_view_verse):
    InputMode<override>:ui_input_mode = ui_input_mode.None
    ZOrder<override>:type {_X:int where 0 <= _X, _X <= 2147483647} = 10

    ClearSpaceWidget<private>:WBP_ClearSpace = WBP_ClearSpace{}

    OnInit<override>():void =
        set Widget = ClearSpaceWidget

    OnDestroy<override>():void = {}

    UpdateSecondsLeft<public>(Seconds:int):void =
        FormattedTime := if(Seconds < 10):
            "0{Seconds}"
        else:
            "{Seconds}"
        set ClearSpaceWidget.SecondsLeft = StringToMsg(FormattedTime)

    UpdateRocksLeftRemaining<public>(RocksLeft:int):void =
        if(RocksLeft=0):
            set ClearSpaceWidget.OpacityAst1 = 0.3
            set ClearSpaceWidget.OpacityAst2 = 0.3
            set ClearSpaceWidget.OpacityAst3 = 0.3
            set ClearSpaceWidget.OpacityAst4 = 0.3
            set ClearSpaceWidget.OpacityAst5 = 0.3
        else if(RocksLeft=1):
            set ClearSpaceWidget.OpacityAst1 = 1.0
            set ClearSpaceWidget.OpacityAst2 = 0.3
            set ClearSpaceWidget.OpacityAst3 = 0.3
            set ClearSpaceWidget.OpacityAst4 = 0.3
            set ClearSpaceWidget.OpacityAst5 = 0.3
        else if(RocksLeft=2):
            set ClearSpaceWidget.OpacityAst1 = 1.0
            set ClearSpaceWidget.OpacityAst2 = 1.0
            set ClearSpaceWidget.OpacityAst3 = 0.3
            set ClearSpaceWidget.OpacityAst4 = 0.3
            set ClearSpaceWidget.OpacityAst5 = 0.3
        else if(RocksLeft=3):
            set ClearSpaceWidget.OpacityAst1 = 1.0
            set ClearSpaceWidget.OpacityAst2 = 1.0
            set ClearSpaceWidget.OpacityAst3 = 1.0
            set ClearSpaceWidget.OpacityAst4 = 0.3
            set ClearSpaceWidget.OpacityAst5 = 0.3
        else if(RocksLeft=4):
            set ClearSpaceWidget.OpacityAst1 = 1.0
            set ClearSpaceWidget.OpacityAst2 = 1.0
            set ClearSpaceWidget.OpacityAst3 = 1.0
            set ClearSpaceWidget.OpacityAst4 = 1.0
            set ClearSpaceWidget.OpacityAst5 = 0.3
        else:
            set ClearSpaceWidget.OpacityAst1 = 1.0
            set ClearSpaceWidget.OpacityAst2 = 1.0
            set ClearSpaceWidget.OpacityAst3 = 1.0
            set ClearSpaceWidget.OpacityAst4 = 1.0
            set ClearSpaceWidget.OpacityAst5 = 1.0
