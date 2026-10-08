# Among Us-style game mode for UEFN

Verse scripts for a social deduction game mode built in Unreal Editor for
Fortnite (UEFN), inspired by Among Us. Crewmates complete tasks around the
map while impostors try to eliminate them without getting caught.

> Unofficial fan project. Not affiliated with or endorsed by Innersloth or
> Epic Games. "Among Us" is a trademark of Innersloth LLC.

## Features

- **Game phases**: lobby, role and color assignment, game round
- **Roles**: crewmates, impostors and ghosts, with role reveal screen
- **Tasks**: multi-stage tasks with dedicated UI widgets (align engine, fuel,
  divert power, transfer data, submit scan, shields, pass code, labyrinth,
  tune signal, reactor numbers, and more) plus a global task bar
- **Sabotages**: lights off, lock doors, communications, oxygen depletion,
  reactor meltdown, with cooldowns and a sabotage banner
- **Impostor mechanics**: kill button, vents with navigation UI, dead bodies
- **Emergency meetings**: button or body report, voting tablet, countdown,
  player reveal
- **Map and cameras**: interactive player map with sabotage buttons,
  security cameras

## Project structure

| Path | Content |
| --- | --- |
| `Gameplay/` | Game phase management (lobby, game round) |
| `ModuleTasks/` | Task and sabotage system: tasks, stages, stage widgets |
| `ModuleEmergencyMeeting/` | Emergency meeting, voting and player reveal |
| `ModuleKillButton/` | Kill button logic for impostors |
| `ModuleVents/` | Vent system and vent navigation widgets |
| `ModuleInteractivePlayerMap/` | Interactive map and sabotage panel |
| `Mechanics/` | Dead bodies, security cameras, spatial controller |
| `Ui/` | UI framework, screens, HUD widgets, localization |
| `Utils/` | Logging, subscriptions and helpers |
| `Config.verse` | Teams, task limits and map locations |
| `event_manager.verse`, `events.verse` | Internal event bus between modules |

## Notes

These files are only the Verse code. Assets the scripts reference (meshes,
materials, textures, cinematic sequences) and the level with its placed
devices are not included.

## License

Copyright (c) 2025 Davide Zattra. All rights reserved.

The code is published for viewing only. It may not be used, copied, modified
or distributed, including in UEFN islands, without written permission. See
[LICENSE](LICENSE).
