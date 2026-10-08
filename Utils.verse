using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
 
# SubscribeAgent
(Listenable : listenable(agent)).SubscribeAgent(OutputFunc : tuple(agent, t)->void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_agent(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)
 
wrapper_agent(t : type) := class():
    ExtraData : t;
    OutputFunc : tuple(agent, t) -> void
    InputFunc(Agent : agent):void = OutputFunc(Agent, ExtraData)


# SubscribeWidgetMessage
(Listenable : listenable(widget_message)).SubscribeWidgetMessage(OutputFunc : tuple(widget_message, t)->void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_widget_message(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)
    
wrapper_widget_message(t : type) := class():
    ExtraData : t;
    OutputFunc : tuple(widget_message, t) -> void
    InputFunc(WidgetMessage : widget_message):void = OutputFunc(WidgetMessage, ExtraData)

    
# SubscribeEmpty
(Listenable : listenable(tuple())).SubscribeEmpty(OutputFunc : t -> void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_empty(t) {ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)

wrapper_empty(t : type) := 
    class:
        ExtraData : t
        OutputFunc : t -> void
        InputFunc():void = OutputFunc(ExtraData)



(InString:string).Substring(Start:int, End:int):string =
    if(Start<0):
        return "" #StringIndexOutOfBoundsException(Start)
    
    SubLength := InString.Length - Start
    if(SubLength<0):
        return "" #StringIndexOutOfBoundsException(SubLength)
    
    if(Start=0, End=InString.Length):
        return InString
    else:
        var NewString:string = ""
        for(Index := Start..End, Character:[]char=array{InString[Index]}):
            set NewString = NewString + Character
        NewString


(Array:[]int).Join(Separator:string):string = 
    var String:string = ""
    for(Integer:Array):
        set String += "{Integer}" + Separator

    String


# Localizable message to display as text in the UI
TextForMyUI<localizes>: message = "Option"

# Utilities
StringToMsg<public><localizes>(String:string):message = "{String}"
MsgToString(Message:message):string = Localize(Message)

amongus_listener<public>(t:type) := interface<unique>:
    Update<public>(Data:t):void



(Logger:log).Error(Text:string):void =
    Logger.Print(Text, ?Level:=log_level.Error)

(Logger:log).Debug(Text:string):void =
    Logger.Print(Text, ?Level:=log_level.Debug)

(Logger:log).Warning(Text:string):void =
    Logger.Print(Text, ?Level:=log_level.Warning)

(Logger:log).Normal(Text:string):void =
    Logger.Print(Text, ?Level:=log_level.Normal)
                    
                    
logger_channel := class(log_channel){}

Make_custom_logger<constructor><public>():= custom_logger:


custom_logger<public> := class:
    Logger<protected>:log = log{Channel:=logger_channel, DefaultLevel:=log_level.Normal}

    var _IsLoggerEnabled<protected>:logic = true
    var _IsLoggerEnabled_Debug<protected>:logic = true
    var _IsLoggerEnabled_Verbose<protected>:logic = true
    var _IsEnableLogger_Normal<protected>:logic = true
    var _IsEnableLogger_Warning<protected>:logic = true
    var _IsEnableLogger_Error<protected>:logic = true

    Debug<internal>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsLoggerEnabled_Debug?):
            Logger.Print(Text, ?Level:=log_level.Debug)

    Verbose<internal>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsLoggerEnabled_Verbose?):
            Logger.Print(Text, ?Level:=log_level.Verbose)

    Normal<internal>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsEnableLogger_Normal?):
            Logger.Print(Text, ?Level:=log_level.Normal)

    Warning<internal>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsEnableLogger_Warning?):
            Logger.Print(Text, ?Level:=log_level.Warning)

    Error<internal>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsEnableLogger_Error?):
            Logger.Print(Text, ?Level:=log_level.Error)

    CallStack<internal>():void = 
        if(_IsLoggerEnabled?):
            Logger.PrintCallStack()

    EnableLogger<internal>():void =
        set _IsLoggerEnabled = true






(ExampleMap:[comparable]type).RemoveKeyFromMap(ElementToRemove:comparable):[comparable]type=
    var NewMap:[comparable]type = map{}
    # Concatenate Keys from ExampleMap into NewMap, excluding ElementToRemove
    for (Key -> Value : ExampleMap, Key <> ElementToRemove):
        set NewMap = ConcatenateMaps(NewMap, map{Key => Value})
    return NewMap

(ExampleMap:[player]any).RemovePlayerFromMap(ElementToRemove:player):[player]any=
    var NewMap:[player]any = map{}
    # Concatenate Keys from ExampleMap into NewMap, excluding ElementToRemove
    for (Key -> Value : ExampleMap, Key <> ElementToRemove):
        set NewMap = ConcatenateMaps(NewMap, map{Key => Value})
    return NewMap




cardinal_direction<public> := enum:
    North
    South
    East
    West

ToString<public>(CardinalDirection:cardinal_direction):string =
    case(CardinalDirection):
        cardinal_direction.North => "North"
        cardinal_direction.South => "South"
        cardinal_direction.East => "East"
        cardinal_direction.West => "West"

# ToString<public>(Logic:logic):string = 
#     if(Logic?):
#         "true"
#     else:
#         "false"


(Logic:logic).ToString():string = 
    if(Logic?):
        return "true"
    else:
        return "false"





ToUpperCase<public>(Input:string):string =
    var Result:string = ""
    for (Char : Input):
        case (Char):
            'a' => set Result += "A"
            'b' => set Result += "B"
            'c' => set Result += "C"
            'd' => set Result += "D"
            'e' => set Result += "E"
            'f' => set Result += "F"
            'g' => set Result += "G"
            'h' => set Result += "H"
            'i' => set Result += "I"
            'j' => set Result += "J"
            'k' => set Result += "K"
            'l' => set Result += "L"
            'm' => set Result += "M"
            'n' => set Result += "N"
            'o' => set Result += "O"
            'p' => set Result += "P"
            'q' => set Result += "Q"
            'r' => set Result += "R"
            's' => set Result += "S"
            't' => set Result += "T"
            'u' => set Result += "U"
            'v' => set Result += "V"
            'w' => set Result += "W"
            'x' => set Result += "X"
            'y' => set Result += "Y"
            'z' => set Result += "Z"
            # For characters that are already uppercase or non-alphabetic, just add them as is
            _ => set Result += array:
                Char
    Result
        
        

