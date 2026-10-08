using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }

Make_stack_box_wrapper<public><constructor>(InOrientation:orientation) := stack_box_wrapper:
    Orientation := InOrientation
    

stack_box_wrapper <public> := class:
    Canvas<public>:canvas = canvas{}

    var StackBox<public>:stack_box = stack_box:
        Orientation := orientation.Horizontal

    Orientation<public>:orientation = orientation.Horizontal

    

    Init<public>():void = 
        set StackBox = stack_box:
            Orientation := Orientation

        Canvas.AddWidget(canvas_slot{
            Anchors := anchors{Minimum := vector2{X:=0.0, Y:=0.0}, Maximum := vector2{X:=1.0, Y:=1.0}}
            Widget := StackBox
        })

    # Add a new child slot to the stack box. Slots are added at the end.
    AddWidget<public>(Slot:stack_box_slot):void = {}

    # Removes a slot containing the given widget
    RemoveWidget<public>(Widget:widget):void = {}

    # Replace old slots with current ones
    Update<public>(Slots:[]stack_box_slot):void = 
        WidgetVisibility := StackBox.GetVisibility()

        Self.Canvas.RemoveWidget(StackBox)

        set StackBox = stack_box:
            Orientation := Orientation
            Slots := Slots

        StackBox.SetVisibility(WidgetVisibility)

        Self.Canvas.AddWidget(canvas_slot{
            Anchors := anchors{Minimum := vector2{X:=0.0, Y:=0.0}, Maximum := vector2{X:=1.0, Y:=1.0}}
            Widget := StackBox
            })

