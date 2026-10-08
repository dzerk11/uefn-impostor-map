
using { /UnrealEngine.com/Temporary/Diagnostics }

clog_channel := class(log_channel){}


Make_clog_channel<public><constructor>(?Channel:subtype(log_channel)):= clog:
    Logger:= log{Channel:=Channel}


clog<public> := class:
    Logger<public>:log = log{Channel:=clog_channel}

    var _IsLoggerEnabled<private>:logic = true
    var _IsLoggerEnabled_Debug<private>:logic = true
    var _IsLoggerEnabled_Verbose<private>:logic = true
    var _IsEnableLogger_Normal<private>:logic = true
    var _IsEnableLogger_Warning<private>:logic = true
    var _IsEnableLogger_Error<private>:logic = true

    Debug<public>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsLoggerEnabled_Debug?):
            Logger.Print(Text, ?Level:=log_level.Debug)

    Verbose<public>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsLoggerEnabled_Verbose?):
            Logger.Print(Text, ?Level:=log_level.Verbose)

    Normal<public>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsEnableLogger_Normal?):
            Logger.Print(Text, ?Level:=log_level.Normal)

    Warning<public>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsEnableLogger_Warning?):
            Logger.Print(Text, ?Level:=log_level.Warning)

    Error<public>(Text:string):void = 
        if(_IsLoggerEnabled?, _IsEnableLogger_Error?):
            Logger.Print(Text, ?Level:=log_level.Error)

    CallStack<public>():void = 
        if(_IsLoggerEnabled?):
            Logger.PrintCallStack()

    EnableLogger<public>():void =
        set _IsLoggerEnabled = true

    DisableLogger<public>():void =
        set _IsLoggerEnabled = false

    SetEnableDebug<public>(enabled:logic):void =
        set _IsLoggerEnabled_Debug = enabled

    SetEnableVerbose<public>(enabled:logic):void =
        set _IsLoggerEnabled_Verbose = enabled

    SetEnableNormal<public>(enabled:logic):void =
        set _IsEnableLogger_Normal = enabled

    SetEnableWarning<public>(enabled:logic):void =
        set _IsEnableLogger_Warning = enabled

    SetEnableError<public>(enabled:logic):void =
        set _IsEnableLogger_Error = enabled
    