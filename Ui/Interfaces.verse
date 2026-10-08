
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }

# Base lifecycle interface for all UI components
ui_lifecycle<public> := interface:
    Init<public>():void
    Destroy<public>():void
    IsInitialized<public>()<decides><transacts>:void

# Interface for components that can be shown/hidden
ui_displayable<public> := interface:
    Show<public>():void
    Hide<public>():void
    IsVisible<public>()<decides><transacts>:void

# Combined interface for views
ui_view_interface<public> := interface<unique>(ui_lifecycle, ui_displayable):
    # GetWidget<public>():canvas

# For reusable components that don't handle their own display
ui_component_interface<public> := interface(ui_lifecycle):
    GetWidget<public>():widget


# 
ui_view_controller<public> := interface:
    Show<public>(Agent:agent):void
    Hide<public>(Agent:agent):void
    IsVisible<public>(Agent:agent)<decides><transacts>:void
