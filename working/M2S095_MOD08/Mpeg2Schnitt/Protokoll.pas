{-----------------------------------------------------------------------------------
Diese Unit ist Teil des Programms Mpeg2Schnitt.

Das Programm Mpeg2Schnitt ist ein einfaches Schnittprogramm (nur harte Schnitte) für
Mpeg2Video-Dateien und Mpeg2- und AC3Ton-Dateien.

Copyright (C) 2003  Martin Dienert
 Homepage: http:www.mdienert.de/mpeg2schnitt/
 E-Mail:   m.dienert@gmx.de

This program is free software; you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program;
if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.


Auf Deutsch: 
Dieses Programm ist freie Software. Sie können es unter den Bedingungen
der GNU General Public License, wie von der Free Software Foundation veröffentlicht,
weitergeben und/oder modifizieren, entweder gemäß Version 2 der Lizenz oder
(nach Ihrer Option) jeder späteren Version.

Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen
sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE
oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK. Details finden Sie in der
GNU General Public License.

Sie sollten eine Kopie der GNU General Public License zusammen mit diesem Programm erhalten haben.
Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.

--------------------------------------------------------------------------------------}

unit Protokoll;

interface

USES SysUtils, Classes,    // Standardunits
     Sprachen,             // für Sprachunterstützung
     AllgVariablen;      // Optionen

PROCEDURE ProtokollDateiname(Name: STRING);

PROCEDURE Protokoll_starten_beenden(VersionNr: STRING);

PROCEDURE Protokoll_schliessen;

PROCEDURE Protokoll_Leerzeile_einfuegen;

PROCEDURE Protokoll_schreiben(Text: STRING);

PROCEDURE ProtokollText_schreiben(TextListe: TStrings);

VAR Datei_schliessen : Boolean = False;

implementation

VAR DateiHandle : Integer = -1;
    ProtokollName : STRING = 'Protokoll.txt';
    Protokollerstellen : Boolean = False;

PROCEDURE ProtokollDateiname(Name: STRING);
BEGIN
  ProtokollName := Name;
END;

PROCEDURE Protokoll_starten_beenden(VersionNr: STRING);
BEGIN
  IF ArbeitsumgebungObj.Protokollerstellen THEN
  BEGIN
    Protokoll_Leerzeile_einfuegen;
    Protokoll_schreiben(VersionNr);
    Protokoll_schreiben(WortProtokollbegin);
  END
  ELSE
  BEGIN
    Protokoll_schreiben(WortProtokollende);
    Protokoll_schliessen;
  END;
END;

PROCEDURE Protokoll_schliessen;
BEGIN
  IF DateiHandle > -1 THEN
  BEGIN
    FileClose(DateiHandle);
    DateiHandle := -1;
  END;
END;

PROCEDURE Protokoll_Leerzeile_einfuegen;

VAR Text : STRING;

BEGIN
  IF ArbeitsumgebungObj.Protokollerstellen THEN
  BEGIN
    IF DateiHandle < 0 THEN
    BEGIN
      IF FileExists(ProtokollName) THEN
        DateiHandle := FileOpen(ProtokollName, fmOpenWrite)
      ELSE
        DateiHandle := FileCreate(ProtokollName);
    END;
    Text := Chr(13) + Chr(10);
    FileSeek(DateiHandle, 0, 2);
    FileWrite(DateiHandle, Text[1], Length(Text));
    IF Datei_schliessen THEN
      IF DateiHandle > -1 THEN
      BEGIN
        FileClose(DateiHandle);
        DateiHandle := -1;
      END;
  END;
END;

PROCEDURE Protokoll_schreiben(Text: STRING);
BEGIN
  IF ArbeitsumgebungObj.Protokollerstellen THEN
  BEGIN
    IF DateiHandle < 0 THEN
    BEGIN
      IF FileExists(ProtokollName) THEN
        DateiHandle := FileOpen(ProtokollName, fmOpenWrite)
      ELSE
        DateiHandle := FileCreate(ProtokollName);
    END;
    Text := DateTimeToStr(Now) + '  :  ' + Text + Chr(13) + Chr(10);
    FileSeek(DateiHandle, 0, 2);
    FileWrite(DateiHandle, Text[1], Length(Text));
    IF Datei_schliessen THEN
      IF DateiHandle > -1 THEN
      BEGIN
        FileClose(DateiHandle);
        DateiHandle := -1;
      END;
  END;
END;

PROCEDURE ProtokollText_schreiben(TextListe: TStrings);

VAR Text : STRING;
    I : Integer;

BEGIN
  IF ArbeitsumgebungObj.Protokollerstellen THEN
  BEGIN
    IF DateiHandle < 0 THEN
    BEGIN
      IF FileExists(ProtokollName) THEN
        DateiHandle := FileOpen(ProtokollName, fmOpenWrite)
      ELSE
        DateiHandle := FileCreate(ProtokollName);
    END;
    FileSeek(DateiHandle, 0, 2);
    FOR I := 0 TO TextListe.Count -1 DO
    BEGIN
      IF I = 0 THEN
        Text := DateTimeToStr(Now)
      ELSE
        Text := StringOfChar(' ', Length(DateTimeToStr(Now)));
      Text := TextListe.Strings[I] + Chr(13) + Chr(10);
      FileWrite(DateiHandle, Text[1], Length(Text));
    END;
    IF Datei_schliessen THEN
      IF DateiHandle > -1 THEN
      BEGIN
        FileClose(DateiHandle);
        DateiHandle := -1;
      END;
  END;
END;

end.
