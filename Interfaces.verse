
lifecycle<public> := interface:
    Init<public>(): void
    Dispose<public>(): void

runnable<public> := interface:
    Start<public>():void
    Stop<public>():void
    Handle<protected>()<suspends>:void