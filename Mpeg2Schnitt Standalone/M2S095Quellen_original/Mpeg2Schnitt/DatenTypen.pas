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

unit DatenTypen;

interface

USES Classes, ComCtrls, Graphics;

TYPE
  TListe = CLASS(TList)     // TList gibt den Speicher seiner Objecte nicht frei
    PROCEDURE Loeschen;     // gibt den Speicher aller Einträge frei und leert die Liste
    PROCEDURE LoeschenX(Nr: Integer);  // gibt den Speicher des Eintrages X frei und entfernt ihn aus der Liste
    DESTRUCTOR Destroy; OVERRIDE;
  END;

  TAusgabeDaten = CLASS
    EffektName : STRING;
    ProgrammName : STRING;
    ProgrammParameter : STRING;
    Parameter : STRING;
    OrginalparameterDatei : STRING;
    ParameterDateiName : STRING;
  END;

  TEffektVideoDaten = CLASS
    EffektEinstellungen : STRING;
    VideoEffekt : TAusgabeDaten;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
  END;

  TEffektAudioDaten = CLASS
    EffektEinstellungen : STRING;
    AudioEffektMp2 : TAusgabeDaten;
    AudioEffektAC3 : TAusgabeDaten;
    AudioEffektPCM : TAusgabeDaten;
    alleAudiotypengleich : Boolean;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
  END;

  TProgramme = CLASS
    Programmdaten : TAusgabeDaten;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
  END;

  TEffektEintrag = CLASS
    AnfangEffektName : STRING;
    AnfangEffektDateiname : STRING;
//    AnfangEffektPosition : Integer;
    AnfangLaenge : Integer;
    AnfangEffektParameter : STRING;
    EndeEffektName : STRING;
    EndeEffektDateiname : STRING;
//    EndeEffektPosition : Integer;
    EndeLaenge : Integer;
    EndeEffektParameter : STRING;
  END;

  TDateiListeneintrag = CLASS
    Name : STRING;
    Dateiname : STRING;
  END;

  TSchnittpunkt = CLASS
    VideoName : STRING;
    AudioName : STRING;
    Videoknoten : TTreeNode;
    Audioknoten : TTreeNode;
    Anfang : Int64;
    Anfangberechnen : Byte;   //  Bit 0 = 0 : Bit 1 ungültig
                              //  Bit 0 = 1 : Bit 1 gültig
                              //  Bit 1 = 0 : Schnittpunktanfang ist ein I-Frame
                              //  Bit 1 = 1 : Schnittpunktanfang ist kein I-Frame
                              //  Bit 2 = 0 : Schnittpunktanfang passt nicht zum vorherigen Schnittpunkt
                              //  Bit 2 = 1 : Schnittpunktanfang passt zum vorherigen Schnittpunkt
                              //  Bit 7 = 0 : Schnittpunktanfang beim Schnitt eventuell framgenau berechnen
                              //  Bit 7 = 1 : Schnittpunktanfang beim Schnitt nicht framegenau berechnen sondern eventuell gültiges Bild suchen
    Ende : Int64;
    Endeberechnen : Byte;     // wie Anfangberechnen
    VideoGroesse : Int64;
    AudioGroesse : Int64;
    Framerate : Real;
    Audiooffset : Integer;
    VideoListe,
    VideoIndexListe,
    AudioListe : TListe;
    VideoEffekt : TEffektEintrag;
    AudioEffekt : TEffektEintrag;
    AnfangsBild : TBitmap;
    EndeBild : TBitmap;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
  END;

  TKapitelEintrag = CLASS
    Kapitel : Int64;
    Videoknoten : TTreeNode;
    Audioknoten : TTreeNode;
    BilderproSek : Real;
  END;

implementation

// ++++++++++++++++++Typen+++++++++++++++++++++++++++++++

PROCEDURE TListe.Loeschen;

VAR I : Integer;
    Eintrag : TObject;

BEGIN
  IF Count > 0 THEN
    FOR I := 0 TO Count - 1 DO
    BEGIN
      Eintrag := Items[I];
      Eintrag.Free;
    END;
  Clear;
  Capacity := Count;
END;

PROCEDURE TListe.LoeschenX(Nr: Integer);

VAR Eintrag : TObject;

BEGIN
  IF (Nr > - 1) AND (Nr < Count - 1) THEN
  BEGIN
    Eintrag := Items[Nr];
    Eintrag.Free;
 //   Delete[Nr];
  END;
END;

DESTRUCTOR TListe.Destroy;
BEGIN
  Loeschen;
  INHERITED Destroy;
END;

CONSTRUCTOR TEffektVideoDaten.Create;
BEGIN
  INHERITED;
  VideoEffekt := TAusgabeDaten.Create;
END;

DESTRUCTOR TEffektVideoDaten.Destroy;
BEGIN
  VideoEffekt.Free;
  INHERITED;
END;

CONSTRUCTOR TEffektAudioDaten.Create;
BEGIN
  INHERITED;
  AudioEffektMp2 := TAusgabeDaten.Create;
  AudioEffektAC3 := TAusgabeDaten.Create;
  AudioEffektPCM := TAusgabeDaten.Create;
END;

DESTRUCTOR TEffektAudioDaten.Destroy;
BEGIN
  AudioEffektMp2.Free;
  AudioEffektAC3.Free;
  AudioEffektPCM.Free;
  INHERITED;
END;

CONSTRUCTOR TProgramme.Create;
BEGIN
  INHERITED;
  Programmdaten := TAusgabeDaten.Create;
END;

DESTRUCTOR TProgramme.Destroy;
BEGIN
  Programmdaten.Free;
  INHERITED;
END;

CONSTRUCTOR TSchnittpunkt.Create;
BEGIN
  INHERITED Create;
  Anfang := -1;
  Anfangberechnen := 0;
  Ende := -1;
  Endeberechnen := 0;
  VideoListe := NIL;
  VideoIndexListe := NIL;
  AudioListe := NIL;
  VideoEffekt := TEffektEintrag.Create;
  AudioEffekt := TEffektEintrag.Create;
  AnfangsBild := TBitmap.Create;
  EndeBild := TBitmap.Create;
END;

DESTRUCTOR TSchnittpunkt.Destroy;
BEGIN
  VideoEffekt.Free;
  AudioEffekt.Free;
  AnfangsBild.Free;
  EndeBild.Free;
  INHERITED Destroy;
END;

end.
 