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

unit Sprachen;

interface

USES IniFiles,             // Inidateien
     SysUtils,             // z.B. ExtractFilePath
     Classes,              // z.B. TStringList
     StrUtils,             // AnsiReplaceText
     AllgFunktionen,       // algemeine Funktionen
     DatenTypen;           // Datentypen
 
TYPE TSprachen = CLASS
     PRIVATE
       Sprachdatei : TIniFile;
       FVerzeichnisName : STRING;
       FSprachdateiName : STRING;
       FDateischliessen : Boolean;
       FSprache : STRING;
       PROCEDURE IniDateioeffnen;
       PROCEDURE IniDateischliessen;
       PROCEDURE Dateischliessenschreiben(Schliessen: Boolean);
     PUBLIC
       CONSTRUCTOR Create;
       DESTRUCTOR Destroy; OVERRIDE;
       PROCEDURE Sprachenlesen(SprachenListe: TStringList);
       FUNCTION Schluesselwortvorhanden(Wort: STRING): Boolean;
       FUNCTION Spracheintraglesen(Eintrag: STRING): STRING;
       PROCEDURE Sprachelesen(Liste: TStringList);
       PROPERTY VerzeichnisName : STRING READ FVerzeichnisName WRITE FVerzeichnisName;
       PROPERTY SprachdateiName : STRING READ FSprachdateiName WRITE FSprachdateiName;
       PROPERTY Sprache : STRING READ FSprache WRITE FSprache;
       PROPERTY Dateischliessen : Boolean READ FDateischliessen WRITE Dateischliessenschreiben;
     END;

FUNCTION Sprachobjekterzeugen(Sprachverzeichnis1, Sprachdateiname1, aktuelleSprache1: STRING; Dateischliessen1: Boolean): TSprachen;
PROCEDURE Sprachobjektfreigeben(VAR Sprachobjekt : TSprachen);
FUNCTION Schluesselwortvorhanden(Spracheladen1: TSprachen; Wort: STRING): Boolean;
FUNCTION Wortlesen(Spracheladen1: TSprachen; Wort, Defaultwort: STRING): STRING;
FUNCTION Meldunglesen(Spracheladen1: TSprachen; Meldung, Text1, DefaultMeldung: STRING): STRING;
PROCEDURE SprachenlisteCreate;
PROCEDURE SprachenlisteDestroy;
PROCEDURE Spracheaendern(Spracheladen: TSprachen);

VAR Spracheladen : TSprachen = NIL;
    SprachenListe : TStringList = NIL;
    aktuelleSprache : STRING;
    Sprachverzeichnis : STRING;
    Sprachdateiname : STRING;
// ------- oft benötigte Wörter ---------
    WortVersion : STRING;
    WortProjekt : STRING;
    WortPlay : STRING;
    WortPause : STRING;
    WortVideo : STRING;
    WortAudio : STRING;
    WortkeinEffekt : STRING;
    WortProgrammversion : STRING;
    WortProtokollbegin : STRING;
    WortProtokollende : STRING;
    WortUebernehmen : STRING;
    WortGehezuIn : STRING;
    WortGehezuOUT : STRING;

implementation

FUNCTION Sprachobjekterzeugen(Sprachverzeichnis1, Sprachdateiname1, aktuelleSprache1: STRING; Dateischliessen1: Boolean): TSprachen;
BEGIN
  Result := TSprachen.Create;
  IF Sprachverzeichnis1 = '' THEN
    Result.FVerzeichnisName := Sprachverzeichnis
  ELSE
    Result.FVerzeichnisName := Sprachverzeichnis1;
  IF Sprachdateiname1 = '' THEN
    Result.SprachdateiName := Sprachdateiname
  ELSE
    Result.SprachdateiName := Sprachdateiname1;
  IF aktuelleSprache1 = '' THEN
    Result.Sprache := aktuelleSprache
  ELSE
    Result.Sprache := aktuelleSprache1;
  Result.Dateischliessen := Dateischliessen1;
END;

PROCEDURE Sprachobjektfreigeben(VAR Sprachobjekt : TSprachen);
BEGIN
  Sprachobjekt.Free;
  Sprachobjekt := NIL;
END;

FUNCTION Schluesselwortvorhanden(Spracheladen1: TSprachen; Wort: STRING): Boolean;

VAR Sprachobjektloeschen : Boolean;

BEGIN
  IF NOT Assigned(Spracheladen1) THEN
  BEGIN
    Spracheladen1 := Sprachobjekterzeugen('', '', '', False);
    Sprachobjektloeschen := True;
  END
  ELSE
  BEGIN
    Sprachobjektloeschen := False;
  END;
  TRY
    Result := Spracheladen1.Schluesselwortvorhanden(Wort);
  FINALLY
    IF Sprachobjektloeschen THEN
    BEGIN
      Spracheladen1.Free;
    END;
  END;
END;

FUNCTION Wortlesen(Spracheladen1: TSprachen; Wort, Defaultwort: STRING): STRING;

VAR Sprachobjektloeschen : Boolean;

BEGIN
  IF NOT Assigned(Spracheladen1) THEN
  BEGIN
    Spracheladen1 := Sprachobjekterzeugen('', '', '', False);
    Sprachobjektloeschen := True;
  END
  ELSE
  BEGIN
    Sprachobjektloeschen := False;
  END;
  TRY
    Result := AnsiReplaceText(Spracheladen1.Spracheintraglesen(Wort), '~', ' ');
    IF Result = '' THEN
      Result := Defaultwort;
  FINALLY
    IF Sprachobjektloeschen THEN
    BEGIN
      Spracheladen1.Free;
    END;
  END;
END;

FUNCTION Meldunglesen(Spracheladen1: TSprachen; Meldung, Text1, DefaultMeldung: STRING): STRING;
BEGIN
  Result := Wortlesen(Spracheladen1, Meldung, DefaultMeldung);
  Result := AnsiReplaceText(Result, '$Text1#', Text1);
END;

CONSTRUCTOR TSprachen.Create;
BEGIN
  INHERITED;
  FDateischliessen := True;
END;

DESTRUCTOR TSprachen.Destroy;
BEGIN
  IF Assigned(Sprachdatei) THEN
    Sprachdatei.Free;
  INHERITED;
END;

PROCEDURE TSprachen.IniDateioeffnen;
BEGIN
  IF Assigned(Sprachdatei) THEN
    IF NOT (Sprachdatei.FileName = FVerzeichnisName + FSprachdateiName) THEN
    BEGIN
      Sprachdatei.Free;
      Sprachdatei := NIL;
    END;
  IF NOT Assigned(Sprachdatei) THEN
    IF FileExists(FVerzeichnisName + FSprachdateiName) THEN
      Sprachdatei := TIniFile.Create(FVerzeichnisName + FSprachdateiName);
END;


PROCEDURE TSprachen.Dateischliessenschreiben(Schliessen: Boolean);
BEGIN
  FDateischliessen := Schliessen;
  IniDateischliessen;
END;

PROCEDURE TSprachen.IniDateischliessen;
BEGIN
  IF FDateischliessen THEN
  BEGIN
    IF Assigned(Sprachdatei) THEN
    BEGIN
      Sprachdatei.Free;
      Sprachdatei := NIL;
    END;
  END;
END;

PROCEDURE TSprachen.Sprachenlesen(SprachenListe: TStringList);

VAR Suche : TSearchRec;
    I : Integer;
    SprachListe: TStringList;
    Spracheintrag : TDateiListeneintrag;

BEGIN
  SprachListe:= TStringList.Create;
  TRY
    IF FindFirst(FVerzeichnisName + '*.spr', faAnyFile, Suche) = 0 THEN
    BEGIN
      REPEAT
        FSprachdateiName := Suche.Name;
        SprachListe.Clear;
        IniDateioeffnen;
        IF Assigned(Sprachdatei) THEN
          Sprachdatei.ReadSections(SprachListe);
        IniDateischliessen;
        FOR I := 0 TO SprachListe.Count - 1 DO
        BEGIN
          Spracheintrag := TDateiListeneintrag.Create;
          Spracheintrag.Name := SprachListe.Strings[I];
          Spracheintrag.Dateiname := Suche.Name;
          SprachenListe.AddObject(SprachListe.Strings[I], Spracheintrag);
        END;
      UNTIL FindNext(Suche) <> 0;
      FindClose(Suche);
    END;
  FINALLY
    SprachListe.Free;
  END;
END;

FUNCTION TSprachen.Schluesselwortvorhanden(Wort: STRING): Boolean;
BEGIN
  IniDateioeffnen;
  IF Assigned(Sprachdatei) THEN
    IF FSprache = '' THEN
      Result := False
    ELSE
//      Result := Sprachdatei.ValueExists(FSprache, Wort)
      Result := NOT (Sprachdatei.ReadString(FSprache, Wort, '$letzter#') = '$letzter#')
  ELSE
    Result := False;
  IniDateischliessen;
END;

FUNCTION TSprachen.Spracheintraglesen(Eintrag: STRING): STRING;
BEGIN
  IniDateioeffnen;
  IF Assigned(Sprachdatei) THEN
    IF FSprache = '' THEN
      Result := ''
    ELSE
      Result := Sprachdatei.ReadString(FSprache, Eintrag, '')
  ELSE
    Result := '';
  IniDateischliessen;
END;

PROCEDURE TSprachen.Sprachelesen(Liste: TStringList);
BEGIN
  IniDateioeffnen;
  IF Assigned(Sprachdatei) THEN
    IF FSprache <> '' THEN
      Sprachdatei.ReadSectionValues(FSprache, Liste);
  IniDateischliessen;
END;

PROCEDURE SprachenlisteCreate;

VAR Spracheladenfreigeben : Boolean;

BEGIN
  SprachenlisteDestroy;
  SprachenListe := TStringList.Create;
  IF NOT Assigned(Spracheladen) THEN
  BEGIN
    Spracheladen := Sprachobjekterzeugen('', '', '', False);
    Spracheladenfreigeben := True;
  END
  ELSE
    Spracheladenfreigeben := False;
  TRY
    Spracheladen.Sprachenlesen(SprachenListe);
  FINALLY
    IF Spracheladenfreigeben THEN
      Sprachobjektfreigeben(Spracheladen);
  END;
END;

PROCEDURE SprachenlisteDestroy;
BEGIN
  IF Assigned(SprachenListe) THEN
  BEGIN
    Stringliste_loeschen(SprachenListe);
    SprachenListe.Free;
    SprachenListe := NIL;
  END;
END;

PROCEDURE Spracheaendern(Spracheladen: TSprachen);
BEGIN
  WortVersion := Wortlesen(Spracheladen, 'Version', 'Version');
  WortProjekt := Wortlesen(Spracheladen, 'Projekt', 'Projekt');
  WortPlay := Wortlesen(Spracheladen, 'Play', 'Play');
  WortPause := Wortlesen(Spracheladen, 'Pause', 'Pause');
  WortVideo := Wortlesen(Spracheladen, 'Video', 'Video');
  WortAudio := Wortlesen(Spracheladen, 'Audio', 'Audio');
  WortkeinEffekt := Wortlesen(Spracheladen, 'keinEffekt', 'kein Effekt');
  WortProgrammversion := Wortlesen(Spracheladen, 'Programmversion', 'Programmversion');
  WortProtokollbegin := Wortlesen(Spracheladen, 'Protokollbeginn', 'Protokollbeginn');
  WortProtokollende := Wortlesen(Spracheladen, 'Protokollende', 'Protokollende');
  WortUebernehmen := Wortlesen(Spracheladen, 'SchnittUebernehmen', 'übernehmen:');
  WortGehezuIn := Wortlesen(Spracheladen, 'GehezuIn', '-->');
  WortGehezuOUT := Wortlesen(Spracheladen, 'GehezuOUT', '-->');
END;

end.
