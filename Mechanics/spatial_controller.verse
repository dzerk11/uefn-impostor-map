
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices } 

using { ModuleAmongusPlayspace }

var SpatialControllers<public>:weak_map(session, spatial_controller) = map{}


Make_spatial_controller<public><constructor>() := spatial_controller:


spatial_controller<public> := class(creative_device):
    
    var PlayerTransform:[player]transform = map{}
    var PlayerViewRotation:[player]rotation = map{}


    OnBegin<override>()<suspends>:void =
        if(set Mechanics.SpatialControllers[GetSession()] = Self):
            Start()


    EventStop<private>:event() = event(){}

    Start<public>():void =
        spawn:
            HandleController()

    HandleController<private>()<suspends>:void = 
        if(EventManager := EventManagers[GetSession()]):
            race:
                EventStop.Await()

                loop:
                    Players := GetPlayspace().GetPlayers()
                    Sleep(0.03)
                    
                    for(Player:Players):

                        if:
                            FNCharacter:fort_character = Player.GetFortCharacter[]
                            # Rotation := FNCharacter.GetViewRotation()
                            Transformation := FNCharacter.GetTransform()
                            Translation := Transformation.Translation
                        then:
                            
                            # Update position
                            if(not PlayerTransform[Player] or Translation <> PlayerTransform[Player].Translation):
                                if(set PlayerTransform[Player] = Transformation):
                                    EventManager.Notify((event_player_position{Data:=Transformation.Translation, Player:=option{Player}}))

                            # Update rotation
                            if(not PlayerViewRotation[Player] or ToString(Transformation.Rotation) <> ToString(PlayerViewRotation[Player])):
                                if(set PlayerViewRotation[Player] = Transformation.Rotation):
                                    EventManager.Notify((event_player_rotation{Data:=Transformation.Rotation, Player:=option{Player}}))

    GetPlayerPosition<public>(Player:player)<transacts><decides>:vector3 = 
        FNCharacter:fort_character = Player.GetFortCharacter[]
        Translation := FNCharacter.GetTransform().Translation

    GetPlayerRotation<public>(Player:player)<transacts><decides>:rotation = 
        FNCharacter:fort_character = Player.GetFortCharacter[]
        Transformation := FNCharacter.GetTransform()
        Transformation.Rotation
                        

                        
        