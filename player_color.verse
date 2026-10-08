
using { /Verse.org/Assets }

using { Art.AmongusCharacters3D.ominibellini }
using { Art.Textures.Icons.ACharacters }

amongus_color<public>:=enum:
    None
    Pink
    Orange
    Green
    Lime
    Purple
    Red
    Cyan
    Yellow
    Brown
    Black
    White
    Blue

ToString<public>(Color:amongus_color):string =
    AmongusColorsMapped[Color] or ""

AmongusColorsMapped<public>:[amongus_color]string = map:
    amongus_color.Pink => "Pink"
    amongus_color.Orange => "Orange"
    amongus_color.Green => "Green"
    amongus_color.Lime => "Lime"
    amongus_color.Purple => "Purple"
    amongus_color.Red => "Red"
    amongus_color.Cyan => "Cyan"
    amongus_color.Yellow => "Yellow"
    amongus_color.Brown => "Brown"
    amongus_color.Black => "Black"
    amongus_color.White => "White"
    amongus_color.Blue => "Blue"
    amongus_color.None => "None"

GetCharacterIcon<public>(AmongusColor:amongus_color)<transacts>:texture =
    AmongusChTextures[AmongusColor] or T_chBlack

AmongusChTextures<public>:[amongus_color]texture = map:
    amongus_color.Pink => T_chPink
    amongus_color.Orange => T_chOrange
    amongus_color.Green => T_chGreen
    amongus_color.Lime => T_chLime
    amongus_color.Purple => T_chPurple
    amongus_color.Red => T_chRed
    amongus_color.Cyan => T_chCyan
    amongus_color.Yellow => T_chYellow
    amongus_color.Brown => T_chBrown
    amongus_color.Black => T_chBlack
    amongus_color.Blue => T_chBlue
    amongus_color.White => T_chWhite
    amongus_color.None => T_chBlack

AmongusChMeshes<public>:[amongus_color]mesh = map:
    amongus_color.Pink => StaticMeshamongss
    amongus_color.Orange => StaticMeshamongss1
    amongus_color.Green => StaticMeshamongss3
    amongus_color.Lime => StaticMeshamongss2
    amongus_color.Purple => StaticMeshamongss4
    amongus_color.Red => StaticMeshamongss5
    amongus_color.Cyan => StaticMeshamongss6
    amongus_color.Yellow => StaticMeshamongss7
    amongus_color.Brown => StaticMeshamongss8
    amongus_color.Black => StaticMeshamongss9
    amongus_color.White => StaticMeshamongss9 # TODO
    amongus_color.Blue => StaticMeshamongss9 # TODO

