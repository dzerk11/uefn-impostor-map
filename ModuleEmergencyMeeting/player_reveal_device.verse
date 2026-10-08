
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/FortPlayerUtilities }

using {Modules.EmergencyMeeting}

player_reveal_device<public> := class(creative_device):

    @editable EventManager:event_manager = event_manager{}
    @editable DeadBodiesController<private>:Mechanics.dead_bodies_controller = Mechanics.dead_bodies_controller{}
    
    @editable RevealPlayerSequence<public>:cinematic_sequence_device = cinematic_sequence_device{}
    @editable Teleporter<private>:teleporter_device = teleporter_device{}

    var WidgetReveal<private>:[player]WBP_EM_Kick2 = map{}

    Play<public>(AgentToReveal:agent):void = 
        spawn:
            PlayAnimation(AgentToReveal)

    PlayAnimation<public>(AgentToReveal:agent)<suspends>:void =
        if:
            PlayerToReveal := player[AgentToReveal]
            APlayerToReveal := GetAPlayer[PlayerToReveal]
            FortCharacterToReveal := PlayerToReveal.GetFortCharacter[]
        then:
            APlayerToReveal.SetGhost()
            Sleep(0.0)
            EventManager.Notify(event_player_reveal_status_changed{PlayerToReveal := APlayerToReveal, Status := true})
            PlayersRound := GetAPlayersRound()
            RevealPlayerSequence.Play()
            Sleep(0.0)
            Teleporter.Teleport(PlayerToReveal)
            FortCharacterToReveal.PutInStasis(stasis_args{AllowTurning:=false, AllowFalling:=true, AllowEmotes:=true})
            Sleep(1.0)

            Playspace := GetPlayspace()
            TeamCollection := Playspace.GetTeamCollection()
            Teams := TeamCollection.GetTeams()
            for(APlayer:PlayersRound, Team:=Teams[TEAM_REVEAL], TeamCollection.AddToTeam[APlayer.Player, Team]):

            for(APlayer:GetAPlayers(), PlayerUI := GetPlayerUI[APlayer.Player]):
                Widget := WBP_EM_Kick2:
                    PlayerName := Ui.AgentToMsg(AgentToReveal)
                    PlayerIcon := GetCharacterIcon(APlayerToReveal.GetColor())
                    ImpostorsRemaining := 2
                    VotedByGreen := true
                    VotedByOrange := true
                    VotedByBlack := true
                    VotedByBlue := true
                    VotedByWhite := true
                    VotedByPink := true

                if(set WidgetReveal[APlayer.Player] = Widget):
                    PlayerUI.AddWidget(Widget, player_ui_slot{InputMode:=ui_input_mode.None, ZOrder:=300})

                Self.GetPlayspace().GetHUDController().HideElementsForPlayer(APlayer.Player, array{
                    creative_hud_identifier_all{}
                })

            Sleep(4.5)
            
            # spawn body
            if:
                DeadBodyModel := DeadBodiesController.DeadBodies[amongus_color.Pink]
                DeadBodyTransform := DeadBodyModel.GetTransform()
                PlayerToKillTransform := FortCharacterToReveal.GetTransform()
                PlayerToKillRotation := FortCharacterToReveal.GetViewRotation()
                NewDeadBodyTransform := transform:
                    Scale := vector3{X:=0.20,Y:=0.20, Z:=0.20}
                    Rotation := PlayerToKillTransform.Rotation
                    Translation := PlayerToKillTransform.Translation + vector3{X:=0.0, Y:=0.0, Z:=-0.0}
            then:
                Color := APlayerToReveal.GetColor()
                DeadBodiesController.BringIn(Color, NewDeadBodyTransform, ?Enabled:=false)
                FortCharacterToReveal.Hide()
                
            
            Sleep(8.0)

            for(Player -> Widget : WidgetReveal, PlayerUI := GetPlayerUI[Player]):
                PlayerUI.RemoveWidget(Widget)

                Self.GetPlayspace().GetHUDController().ResetElementsForPlayer(Player, array{
                    creative_hud_identifier_all{}
                })

            FortCharacterToReveal.Show()
            FortCharacterToReveal.ReleaseFromStasis()
            RevealPlayerSequence.Stop()
            DeadBodiesController.Dispose(APlayerToReveal.GetColor())

            if(TeamCrewmates := Teams[TEAM_CREWMATE], TeamImpostor:=Teams[TEAM_IMPOSTOR], TeamGhosts := Teams[TEAM_GHOST]):
                for(APlayer:PlayersRound):
                    if(APlayer.IsGhost?):
                        if(TeamCollection.AddToTeam[APlayer.Player, TeamGhosts]){}
                    else if(APlayer.IsImpostor[]):
                        if(TeamCollection.AddToTeam[APlayer.Player,TeamImpostor]){}
                    else:
                        if(TeamCollection.AddToTeam[APlayer.Player,TeamCrewmates]){}

            EventManager.Notify(event_player_reveal_status_changed{PlayerToReveal := APlayerToReveal, Status := false})

        


