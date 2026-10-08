
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# Interface for providing and managing player classes
amongus_class_provider<public> := interface:
    GetPlayerClass<public>(Agent:agent)<reads>:int
    ChangePlayerClass<public>(Agent:agent, ClassIndex:int):void

# Main class assigner device that manages player class selection
amongus_class_assigner<public> := class(creative_device, amongus_class_provider):

    # Array of class and team selector devices indexed by class number
    # Index 0 = no class, Index 1 = Class 1, etc.
    @editable ClassSelectors<private>:[]class_and_team_selector_device = array{}

    # Tracks which class each player is assigned to
    var PlayerClasses<private>:[agent]int = map{}

    # Get the class index for a specific agent
    GetPlayerClass<override>(Agent:agent)<reads>:int =
        PlayerClasses[Agent] or -1

    # Changes the player's actual class in the game
    ChangePlayerClass<override>(Agent:agent, ClassIndex:int):void =
        if(ClassSelector := ClassSelectors[ClassIndex], set PlayerClasses[Agent] = ClassIndex):
            # Use the specific class selector to change the player's class
            ClassSelector.ChangeClass(Agent)
            Print("switching to class: {ClassIndex}")


