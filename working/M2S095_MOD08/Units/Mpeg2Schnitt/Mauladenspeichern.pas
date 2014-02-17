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

unit Mauladenspeichern;

interface

USES Classes, SysUtils, Graphics, StrUtils, IniFiles, AllgFunktionen, DatenTypen, Sprachen;

TYPE
  TArbeitsumgebung = CLASS
    Dateiname : STRING;
// ------------ Allgemein --------------------------------
    Indexdateienloeschen : Boolean;
    Protokollerstellen : Boolean;
    Protokollstartende : Boolean;
    festeFramerateverwenden : Boolean;
    festeframerateverwendengeaendert: Boolean;
    festeFramerate : Real;
    SequenzEndeignorieren : Boolean;
    nachSchneidenbeenden : Boolean;
    SchiebereglerPosbeibehalten : Boolean;
    Hinweisanzeigedauer : Integer;
    Beendenanzeigedauer : Integer;
    ProgrammFensterMaximized : Boolean;
    ProgrammFensterLinks : Integer;
    ProgrammFensterOben : Integer;
    ProgrammFensterBreite : Integer;
    ProgrammFensterHoehe : Integer;
    Videoanzeigefaktor : Real;
// ------------ Projekt -----------------------------------
    Dateilistegeaendert,
    Schnittlistegeaendert,
    Kapitellistegeaendert,
    Markenlistegeaendert,
    Effektgeaendert,
    Schneidensetztzurueck : Boolean;
    letzteProjekte : TStringList;
    letzteVerzeichnisse : TStringList;
// ------------ Oberfläche --------------------------------
    DateienfensterSichtbar : Boolean;
    DateienfensterHoehe : Integer;
    AudiooffsetfensterSichtbar : Boolean;
    AudiooffsetfensterHoehe : Integer;
    ListenfensterBreite : Integer;
    ListenfensterLinks : Boolean;
    DateienimListenfenster : Boolean;
    ZweiVideofenster : Boolean;
    SchnitteTabPos : Integer;
    KapitelTabPos : Integer;
    MarkenTabPos : Integer;
    InfoTabPos : Integer;
    DateienTabPos : Integer;
    Bilderverwenden : Integer;
    Bilderdatei : STRING;
    Bilderdateigeaendert : Boolean;
    SchiebereglerMarkerPosition : Integer;
    SchiebereglerMarkeranzeigen : Boolean;
    Tastenfensterzentrieren : Boolean;
    MenueTastenbedienung : Boolean;
    TasteEndelinks : Boolean;
    TasteEnderechts : Boolean;
    HauptfensterSchriftart : STRING;
    TastenfensterSchriftart : STRING;
    AnzeigefensterSchriftart : STRING;
    DialogeSchriftart : STRING;
    HauptfensterSchriftgroesse : Integer;
    TastenfensterSchriftgroesse : Integer;
    AnzeigefensterSchriftgroesse : Integer;
    DialogeSchriftgroesse : Integer;
    TastenFetteSchrift : Boolean;
// ------------ Verzeichnisse --------------------------------
    VideoAudioVerzeichnis : STRING;
    VideoAudioVerzeichnisspeichern : Boolean;
    ZielVerzeichnis : STRING;
    ZielVerzeichnisspeichern : Boolean;
    ProjektVerzeichnis : STRING;
    ProjektVerzeichnisspeichern : Boolean;
    KapitelVerzeichnis : STRING;
    KapitelVerzeichnisspeichern : Boolean;
    VorschauVerzeichnis : STRING;
    ZwischenVerzeichnis : STRING;
// ------------ Dateinamen/Endungen --------------------------------
    Projektdateiname : STRING;
    Projektdateidialogunterdruecken : Boolean;
    ZielDateiname : STRING;
    Zieldateidialogunterdruecken : Boolean;
    Kapiteldateiname : STRING;
    ProjektdateieneinzelnFormat : STRING;
    SchnittpunkteeinzelnFormat : STRING;
    DateiendungenVideo : STRING;
    StandardEndungenVideo : STRING;
    DateiendungenAudio : STRING;
    StandardEndungenAudio : STRING;
    StandardEndungenPCM : STRING;
    StandardEndungenMP2 : STRING;
    StandardEndungenAC3 : STRING;
    AudioTrennzeichen : STRING;
    DateiendungenKapitel : STRING;
    StandardEndungenKapitel : STRING;
    StandardEndungenverwenden : Boolean;
    VideoAudiooeffnenFilterIndex : Integer;
// ------------ Anzeige/Wiedergabe -----------------------
    Videograudarstellen : Boolean;
    keinVideo : Boolean;
    Hauptfensteranpassen : Boolean;
    Videoanzeigegroesse : Boolean;
    Videohintergrundfarbe : TColor;
    Videohintergrundfarbeakt : TColor;
    letztesVideoanzeigen : Boolean;
    Tempo1beiPause : Boolean;
    AudioFehleranzeigen : Boolean;
    keinAudio : Boolean;
    MCIPlayer : Boolean;
    DSPlayer : Boolean;
    AudioGraphName : STRING;
// ------------ Video- und Audioschnitt -------------
    IndexDateierstellen : Boolean;
    Kapiteldateierstellen : Boolean;
    Ausgabebenutzen : Boolean;
    Speicherplatzpruefen : Boolean;
    Framegenauschneiden : Boolean;
    Timecodekorrigieren : Boolean;
    Bitratekorrigieren : Boolean;
    maxGOPLaengeverwenden : Boolean;
    D2VDateierstellen : Boolean;
    IDXDateierstellen : Boolean;
    ZusammenhaengendeSchnitteberechnen : Boolean;
    BitrateersterHeader : Integer;
    festeBitrate : Integer;
    AspectratioersterHeader : Integer;
    AspectratioOffset : Integer;
    maxGOPLaenge : Integer;
    minAnfang : Integer;
    minEnde : Integer;
    leereAudioframesMpegliste : TStringList;
    leereAudioframesAC3liste : TStringList;
    leereAudioframesPCMliste : TStringList;
// ------------ Schnittliste -------------
    SchnittpunktTrennzeichen : STRING;
    SchnittpunktFormat : STRING;
    SchnittpunktAnfangbild : Boolean;
    SchnittpunktEndebild : Boolean;
    SchnittpunktBildbreite : Integer;
    SchnittpunktberechnenFarbe : TColor;
    SchnittpunktnichtberechnenFarbe : TColor;
    Schnittpunkteinfuegen : Integer;
// ------------ Kapitelliste -------------
    SchnittlistenFormatuebernehmen : Boolean;
    KapitelFormat : STRING;
    KapitelTrennzeile1 : STRING;
    KapitelTrennzeile2 : STRING;
    KapitelTrennzeile3 : STRING;
    KapitelTrennzeile4 : STRING;
    KapitellistenVGFarbe : TColor;
    KapitellistenHGFarbe : TColor;
    KapitellistenMarkierungVGFarbe : TColor;
    KapitellistenMarkierungHGFarbe : TColor;
    KapitellistenVerschiebeVGFarbe : TColor;
    KapitellistenVerschiebeHGFarbe : TColor;
    Kapiteleinfuegen : Integer;
    KapitellisteSpaltenbreite1 : Integer;
    KapitellisteSpaltenbreite2 : Integer;
    KapitellisteSpaltenbreite3 : Integer;
    KapitellisteSpaltenbreite4 : Integer;
// ------------ Markenliste -------------
    MarkenFormat : STRING;
    Markenlistebearbeiten : Boolean;
    Markeneinfuegen : Integer;
    Formatliste : TStringList;
// ------------ Listenimport ----------------
    SchnittImportTrennzeichenliste : TStringList;
    SchnittImportZeitTrennzeichenliste : TStringList;
    SchnittlistenimportFormatuebernehmen1 : Boolean;
    KapitelImportTrennzeichenliste : TStringList;
    KapitelImportZeitTrennzeichenliste : TStringList;
    SchnittlistenimportFormatuebernehmen2 : Boolean;
    MarkenImportTrennzeichenliste : TStringList;
    MarkenImportZeitTrennzeichenliste : TStringList;
// ------------ Listenexport ----------------
    SchnittExportOffset : Integer;
    SchnittExportFormat : STRING;
    SchnittlistenexportFormatuebernehmen1 : Boolean;
    KapitelExportOffset : Integer;
    KapitelExportFormat : STRING;
    SchnittlistenexportFormatuebernehmen2 : Boolean;
    MarkenExportOffset : Integer;
    MarkenExportFormat : STRING;
// ------------ Tastenbelegung -------------
    Tasten : ARRAY[0..46] OF Integer;
    InfofensterTasten : Boolean;
    SchnittlisteTasten : Boolean;
    KapitellisteTasten : Boolean;
    MarkenlisteTasten : Boolean;
    DateienfensterTasten : Boolean;
    Schrittweite1 : Integer;
    Schrittweite2 : Integer;
    Schrittweite3 : Integer;
    Schrittweite4 : Integer;
// ------------ Navigation -----------------
    Abspielzeit : Integer;
    Scrollrad : Integer;
    VAextra : Boolean;
    OutSchnittanzeigen : Boolean;
    KlickStartStop : Boolean;
    DoppelklickMaximieren : Boolean;
    Videoeigenschaftenaktualisieren : Boolean;
    Audioeigenschaftenaktualisieren : Boolean;
// ------------ Vorschau --------------------
    Vorschaudauer1 : Integer;
    Vorschaudauer2 : Integer;
    Vorschauerweitern : Boolean;
    VorschaudauerPlus : Integer;
    VorschauImmerberechnen : Boolean;
    Vorschaudateienloeschen : Boolean;
// ------------ Ein-/Ausgabeprogramme --------------------
    Demuxerdatei : STRING;
    Encoderdatei : STRING;
    Ausgabedatei : STRING;
// ------------ Effekte --------------------
    VideoEffektverzeichnis,
    AudioEffektverzeichnis,
    Effektvorgabedatei,
    Videoeffektvorgabe,
    Audioeffektvorgabe : STRING;
    VideoEffekte : TStringList;
    AudioEffekte : TStringList;
    Videoeffektvorgaben : TStringList;
    Audioeffektvorgaben : TStringList;
    Vorgabeeffekteverwenden : Boolean;
// ------------ Grobansicht ----------------
    GrobansichtFensterSichtbar : Boolean;
    GrobansichtFensterMaximized : Boolean;
    GrobansichtFensterLinks : Integer;
    GrobansichtFensterOben : Integer;
    GrobansichtFensterBreite : Integer;
    GrobansichtFensterHoehe : Integer;
    GrobansichtFensterRahmen : Boolean;
    GrobansichtFensterVordergrund : Boolean;
    GrobansichtFensterSchnellstartleiste : Boolean;
    GrobansichtFarbeWerbung : Integer;
    GrobansichtFarbeFilm : Integer;
    GrobansichtFarbeAktiv : Integer;
    GrobansichtSchritt : Integer;
    GrobansichtBildweite : Integer;
// ------------ Binäre Suche ---------------
    BinaereSucheFensterSichtbar : Boolean;
    BinaereSucheFensterLinks : Integer;
    BinaereSucheFensterOben : Integer;
    BinaereSucheFensterBreite : Integer;
    BinaereSucheFensterHoehe : Integer;
    BinaereSucheFensterRahmen : Boolean;
    BinaereSucheFensterVordergrund : Boolean;
// ------------ SchnittTool ----------------
    SchnittToolFensterMaximized : Boolean;
    SchnittToolFensterLinks : Integer;
    SchnittToolFensterOben : Integer;
    SchnittToolFensterBreite : Integer;
    SchnittToolFensterHoehe : Integer;
    SchnittToolProtokollSplitterPos : Integer;
// ------------ eigene Variablen ------------
//    IniFile : TIniFile;
    MauVersion : Integer;
    ApplikationsName : STRING;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROCEDURE Arbeitsumgebungladen(Name: STRING = '');
    PROCEDURE Arbeitsumgebungspeichern(Name: STRING = '');
    PROCEDURE ProgrammPositionspeichern(Name: STRING = '');
    PROCEDURE SchnittToolPositionspeichern(Name: STRING = '');
//    PROCEDURE ExterneProgrammeladen(Name: STRING);
//    PROCEDURE ExterneProgrammespeichern(Name: STRING);
    PROCEDURE Effekteladen(Name: STRING; EffektListe: TStrings);
    PROCEDURE Effektvorgabeladen(Name: STRING);
    PROCEDURE Effektvorgabespeichern(Name: STRING);
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  END;

VAR Arbeitsumgebung : TArbeitsumgebung;

implementation

CONSTRUCTOR TArbeitsumgebung.Create;
BEGIN
  INHERITED;
// ------------ Allgemein --------------------------------
  Protokollerstellen := False;
  Protokollstartende := False;
  festeFramerateverwenden := False;
  festeframerateverwendengeaendert:= False;
  ProgrammFensterMaximized := False;
  ProgrammFensterLinks := -1;
  ProgrammFensterOben := -1;
  ProgrammFensterBreite := -1;
  ProgrammFensterHoehe := -1;
  Videoanzeigefaktor := 0;
// ------------ Projekt -----------------------------------
  letzteProjekte := TStringList.Create;
  letzteVerzeichnisse := TStringList.Create;
// ------------ Oberfläche --------------------------------
  Bilderdateigeaendert := True;
// ------------ Listenformat ------------------------
  Formatliste := TStringList.Create;
// ------------ Kapitelliste -------------
  KapitellisteSpaltenbreite1 := 11;
  KapitellisteSpaltenbreite2 := 11;
  KapitellisteSpaltenbreite3 := 80;
  KapitellisteSpaltenbreite4 := 80;
// ------------ Listenimport ------------------------
  SchnittImportTrennzeichenliste := TStringList.Create;
  SchnittImportZeitTrennzeichenliste := TStringList.Create;
  KapitelImportTrennzeichenliste := TStringList.Create;
  KapitelImportZeitTrennzeichenliste := TStringList.Create;
  MarkenImportTrennzeichenliste := TStringList.Create;
  MarkenImportZeitTrennzeichenliste := TStringList.Create;
// ------------ Video- und Audioschnitt -------------
  leereAudioframesMpegliste := TStringList.Create;
  leereAudioframesAC3liste := TStringList.Create;
  leereAudioframesPCMliste := TStringList.Create;
// ------------ Effekte --------------------
  VideoEffekte := TStringList.Create;
  AudioEffekte := TStringList.Create;
  VideoEffekte.Add(WortkeinEffekt);
  AudioEffekte.Add(WortkeinEffekt);
  Videoeffektvorgaben := TStringList.Create;
  Audioeffektvorgaben := TStringList.Create;
END;

DESTRUCTOR TArbeitsumgebung.Destroy;
BEGIN
// ------------ Projekt -----------------------------------
  letzteProjekte.Free;
  letzteProjekte := NIL;
  letzteVerzeichnisse.Free;
  letzteVerzeichnisse := NIL;
// ------------ Listenformat ------------------------
  Formatliste.Free;
  Formatliste := NIL;
// ------------ Listenimport ------------------------
  SchnittImportTrennzeichenliste.Free;
  SchnittImportTrennzeichenliste := NIL;
  SchnittImportZeitTrennzeichenliste.Free;
  SchnittImportZeitTrennzeichenliste := NIL;
  KapitelImportTrennzeichenliste.Free;
  KapitelImportTrennzeichenliste := NIL;
  KapitelImportZeitTrennzeichenliste.Free;
  KapitelImportZeitTrennzeichenliste := NIL;
  MarkenImportTrennzeichenliste.Free;
  MarkenImportTrennzeichenliste := NIL;
  MarkenImportZeitTrennzeichenliste.Free;
  MarkenImportZeitTrennzeichenliste := NIL;
// ------------ Video- und Audioschnitt -------------
  leereAudioframesMpegliste.Free;
  leereAudioframesMpegliste := NIL;
  leereAudioframesAC3liste.Free;
  leereAudioframesAC3liste := NIL;
  leereAudioframesPCMliste.Free;
  leereAudioframesPCMliste := NIL;
// ------------ Effekte --------------------
  StringListe_loeschen(VideoEffekte);
  VideoEffekte.Free;
  VideoEffekte := NIL;
  StringListe_loeschen(AudioEffekte);
  AudioEffekte.Free;
  AudioEffekte := NIL;
  StringListe_loeschen(Videoeffektvorgaben);
  Videoeffektvorgaben.Free;
  Videoeffektvorgaben := NIL;
  StringListe_loeschen(Audioeffektvorgaben);
  Audioeffektvorgaben.Free;
  Audioeffektvorgaben := NIL;
  INHERITED;
END;

PROCEDURE TArbeitsumgebung.Arbeitsumgebungladen(Name: STRING = '');

VAR IniFile : TIniFile;
    I,
    HInteger,
    Version : Integer;
    HString : STRING;

BEGIN
  IF Name <> '' THEN
    Dateiname := Name;
  IniFile := TIniFile.Create(Dateiname);
  TRY
    Version := IniFile.ReadInteger('Allgemein', 'ArbeitsumgebungsVersion', 0);
// zuerst werden Variablen in der aktuellen Form geladen
// ------------ Allgemein --------------------------------
    Indexdateienloeschen := IniFile.ReadBool('Allgemein', 'Indexdateien_loeschen', False);
    festeFramerate := IniFile.ReadFloat('Allgemein', 'festeFramerate', 25);
    SequenzEndeignorieren := IniFile.ReadBool('Allgemein', 'SequenzEnde_ignorieren', True);
    nachSchneidenbeenden := IniFile.ReadBool('Allgemein', 'nach_Schneiden_beenden', False);
    SchiebereglerPosbeibehalten := IniFile.ReadBool('Allgemein', 'Schiebereglerposition_beibehalten', True);
    Hinweisanzeigedauer := IniFile.ReadInteger('Allgemein', 'Hinweisanzeigedauer', 2);
    Beendenanzeigedauer := IniFile.ReadInteger('Allgemein', 'Beendenanzeigedauer', 0);
    ProgrammFensterMaximized := IniFile.ReadBool('Allgemein', 'ProgrammMaximized', False);
    ProgrammFensterLinks := IniFile.ReadInteger('Allgemein', 'ProgrammLinks', -1);
    ProgrammFensterOben := IniFile.ReadInteger('Allgemein', 'ProgrammOben', -1);
    ProgrammFensterBreite := IniFile.ReadInteger('Allgemein', 'ProgrammBreite', -1);
    ProgrammFensterHoehe := IniFile.ReadInteger('Allgemein', 'ProgrammHoehe', -1);
    Videoanzeigefaktor := IniFile.ReadFloat('Allgemein', 'Videoanzeigefaktor', 0);
// ------------ Projekt -----------------------------------
    Dateilistegeaendert := IniFile.ReadBool('Projekt', 'Dateilistegeaendert', True);
    Schnittlistegeaendert := IniFile.ReadBool('Projekt', 'Schnittlistegeaendert', True);
    Kapitellistegeaendert := IniFile.ReadBool('Projekt', 'Kapitellistegeaendert', True);
    Markenlistegeaendert := IniFile.ReadBool('Projekt', 'Markenlistegeaendert', False);
    Effektgeaendert := IniFile.ReadBool('Projekt', 'Effektgeaendert', True);
    Schneidensetztzurueck := IniFile.ReadBool('Projekt', 'Schneidensetztzurueck', False);
    letzteProjekte.Clear;
    I := 0;
    WHILE IniFile.ValueExists('Projekt', 'Projekt' + IntToStr(I)) DO
    BEGIN
      letzteProjekte.Add(IniFile.ReadString('Projekt', 'Projekt' + IntToStr(I), ''));
      Inc(I);
    END;
    letzteVerzeichnisse.Clear;
    I := 0;
    WHILE IniFile.ValueExists('Projekt', 'Verzeichnisse' + IntToStr(I)) DO
    BEGIN
      letzteVerzeichnisse.Add(IniFile.ReadString('Projekt', 'Verzeichnisse' + IntToStr(I), ''));
      Inc(I);
    END;
// ------------ Oberfläche --------------------------------
    DateienfensterSichtbar := IniFile.ReadBool('Oberflaeche', 'DateienfensterSichtbar', True);
    DateienfensterHoehe := IniFile.ReadInteger('Oberflaeche', 'DateienfensterHoehe', 0);
    AudiooffsetfensterSichtbar := IniFile.ReadBool('Oberflaeche', 'AudiooffsetfensterSichtbar', False);
    AudiooffsetfensterHoehe := IniFile.ReadInteger('Oberflaeche', 'AudiooffsetfensterHoehe', 110);
    ListenfensterBreite := IniFile.ReadInteger('Oberflaeche', 'ListenfensterBreite', 0);
    ListenfensterLinks := IniFile.ReadBool('Oberflaeche', 'ListenfensterLinks', False);
    DateienimListenfenster := IniFile.ReadBool('Oberflaeche', 'DateienimListenfenster', False);
    ZweiVideofenster := IniFile.ReadBool('Oberflaeche', 'ZweiVideofenster', False);
    SchnitteTabPos := IniFile.ReadInteger('Oberflaeche', 'SchnitteTabPos', 0);
    KapitelTabPos := IniFile.ReadInteger('Oberflaeche', 'KapitelTabPos', 1);
    MarkenTabPos := IniFile.ReadInteger('Oberflaeche', 'MarkenTabPos', 2);
    InfoTabPos := IniFile.ReadInteger('Oberflaeche', 'InfoTabPos', 3);
    DateienTabPos := IniFile.ReadInteger('Oberflaeche', 'DateienTabPos', 4);
    Bilderverwenden := IniFile.ReadInteger('Oberflaeche', 'Symboleverwenden', 1);
    Bilderdatei := absolutPathAppl(IniFile.ReadString('Oberflaeche', 'Bilderdatei', ''), ApplikationsName, False);
    SchiebereglerMarkerPosition := IniFile.ReadInteger('Oberflaeche', 'SchiebereglerMarkerPosition', 5000);
    SchiebereglerMarkeranzeigen := IniFile.ReadBool('Oberflaeche', 'SchiebereglerMarkeranzeigen', True);
    Tastenfensterzentrieren := IniFile.ReadBool('Oberflaeche', 'Tastenfensterzentrieren', False);
    MenueTastenbedienung := IniFile.ReadBool('Oberflaeche', 'MenueTastenbedienung', False);
    TasteEndelinks := IniFile.ReadBool('Oberflaeche', 'TasteEndelinks', False);
    TasteEnderechts := IniFile.ReadBool('Oberflaeche', 'TasteEnderechts', True);
    HauptfensterSchriftart := IniFile.ReadString('Oberflaeche', 'HauptfensterSchriftart', 'Tahoma');
    TastenfensterSchriftart := IniFile.ReadString('Oberflaeche', 'TastenfensterSchriftart', 'Tahoma');
    AnzeigefensterSchriftart := IniFile.ReadString('Oberflaeche', 'AnzeigefensterSchriftart', 'Tahoma');
    DialogeSchriftart := IniFile.ReadString('Oberflaeche', 'DialogeSchriftart', 'Tahoma');
    HauptfensterSchriftgroesse := IniFile.ReadInteger('Oberflaeche', 'HauptfensterSchriftgroesse', 9);
    TastenfensterSchriftgroesse := IniFile.ReadInteger('Oberflaeche', 'TastenfensterSchriftgroesse', 9);
    AnzeigefensterSchriftgroesse := IniFile.ReadInteger('Oberflaeche', 'AnzeigefensterSchriftgroesse', 9);
    DialogeSchriftgroesse := IniFile.ReadInteger('Oberflaeche', 'DialogeSchriftgroesse', 9);
    TastenFetteSchrift := IniFile.ReadBool('Oberflaeche', 'TastenFetteSchrift', True);
// ------------ Verzeichnisse --------------------------------
    VideoAudioVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Verzeichnisse', 'VideoAudioVerzeichnis', ''), ApplikationsName, False));
    VideoAudioVerzeichnisspeichern := IniFile.ReadBool('Verzeichnisse', 'VideoAudioVerzeichnisspeichern', True);
    ZielVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Verzeichnisse', 'ZielVerzeichnis', ''), ApplikationsName, False));
    ZielVerzeichnisspeichern := IniFile.ReadBool('Verzeichnisse', 'ZielVerzeichnisspeichern', True);
    ProjektVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Verzeichnisse', 'ProjektVerzeichnis', 'Projekte'), ApplikationsName, True));
    ProjektVerzeichnisspeichern := IniFile.ReadBool('Verzeichnisse', 'ProjektVerzeichnisspeichern', True);
    KapitelVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Verzeichnisse', 'KapitelVerzeichnis', ''), ApplikationsName, False));
    KapitelVerzeichnisspeichern := IniFile.ReadBool('Verzeichnisse', 'KapitelVerzeichnisspeichern', True);
    VorschauVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Verzeichnisse', 'VorschauVerzeichnis', 'Vorschau'), ApplikationsName, True));
    ZwischenVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Verzeichnisse', 'ZwischenVerzeichnis', 'Temp'), ApplikationsName, True));
// ------------ Dateinamen/Endungen --------------------------------
    Projektdateiname := IniFile.ReadString('Dateinamen_Endungen', 'ProjektDateiname', '');
    Projektdateidialogunterdruecken := IniFile.ReadBool('Dateinamen_Endungen', 'Projektdateidialogunterdruecken', False);
    ZielDateiname := IniFile.ReadString('Dateinamen_Endungen', 'ZielDateiname', '');
    Zieldateidialogunterdruecken := IniFile.ReadBool('Dateinamen_Endungen', 'Zieldateidialogunterdruecken', False);
    Kapiteldateiname := IniFile.ReadString('Dateinamen_Endungen', 'KapitelDateiname', '');
    ProjektdateieneinzelnFormat := IniFile.ReadString('Dateinamen_Endungen', 'ProjektdateieneinzelnFormat', '$FileName#-$Number; Format=NNN#');
    SchnittpunkteeinzelnFormat := IniFile.ReadString('Dateinamen_Endungen', 'SchnittpunkteeinzelnFormat', '$FileName#-$Number; Format=NNN#');
    DateiendungenVideo := IniFile.ReadString('Dateinamen_Endungen', 'Videodateiendungen', '*.mpv;*.m2v');
    StandardEndungenVideo := IniFile.ReadString('Dateinamen_Endungen', 'VideoStandardendungen', '.mpv');
    DateiendungenAudio := IniFile.ReadString('Dateinamen_Endungen', 'Audiodateiendungen', '*.mp2;*.mpa;*.ac3');
    StandardEndungenAudio := IniFile.ReadString('Dateinamen_Endungen', 'AudioStandardendungen', '.mp2');
    StandardEndungenPCM := IniFile.ReadString('Dateinamen_Endungen', 'WAVStandardendungen', '.wav');
    StandardEndungenMP2 := IniFile.ReadString('Dateinamen_Endungen', 'MpegStandardendungen', '.mp2');
    StandardEndungenAC3 := IniFile.ReadString('Dateinamen_Endungen', 'AC3Standardendungen', '.ac3');
    AudioTrennzeichen := IniFile.ReadString('Dateinamen_Endungen', 'AudioTrennzeichen', '');
    DateiendungenKapitel := IniFile.ReadString('Dateinamen_Endungen', 'Kapiteldateiendungen', '*.txt;*.chp;*.kap;*.eds_chpt');
    StandardEndungenKapitel := IniFile.ReadString('Dateinamen_Endungen', 'KapitelStandardendungen', '.kap');
    StandardEndungenverwenden := IniFile.ReadBool('Dateinamen_Endungen', 'Standardendungenverwenden', False);
    VideoAudiooeffnenFilterIndex := IniFile.ReadInteger('Dateinamen_Endungen', 'VideoAudiooeffnenFilterIndex', 1);
// ------------ Anzeige/Wiedergabe -----------------------
    VideoGraudarstellen := IniFile.ReadBool('Anzeige_Wiedergabe', 'Video_Grau_darstellen', True);
    keinVideo := IniFile.ReadBool('Anzeige_Wiedergabe', 'kein_Video_abspielen', False);
    Hauptfensteranpassen := IniFile.ReadBool('Anzeige_Wiedergabe', 'Hauptfensteranpassen', False);
    Videoanzeigegroesse := IniFile.ReadBool('Anzeige_Wiedergabe', 'V_Anzeigegroesse_fest', True);
    Videohintergrundfarbe := IniFile.ReadInteger('Anzeige_Wiedergabe', 'Videohintergrundfarbe', -16777194);
    Videohintergrundfarbeakt := IniFile.ReadInteger('Anzeige_Wiedergabe', 'aktVideofensterhintergrundfarbe', -16777194);
    letztesVideoanzeigen := IniFile.ReadBool('Anzeige_Wiedergabe', 'letztes_Video_anzeigen', True);
    Tempo1beiPause := IniFile.ReadBool('Anzeige_Wiedergabe', 'Tempo1_bei_Pause', False);
    AudioFehleranzeigen := IniFile.ReadBool('Anzeige_Wiedergabe', 'Audiofehler_anzeigen', False);
    keinAudio := IniFile.ReadBool('Anzeige_Wiedergabe', 'kein_Audio_abspielen', False);
    MCIPlayer := IniFile.ReadBool('Anzeige_Wiedergabe', 'MCI-Schnittstelle', False);
    DSPlayer := IniFile.ReadBool('Anzeige_Wiedergabe', 'DS-Schnittstelle', True);
    AudioGraphName := absolutPathAppl(IniFile.ReadString('Anzeige_Wiedergabe', 'AudioGraphName', ''), ApplikationsName, False);
// ------------ Video- und Audioschnitt -------------
    IndexDateierstellen := IniFile.ReadBool('SchnittOptionen', 'IndexDateierstellen', True);
    Kapiteldateierstellen := IniFile.ReadBool('SchnittOptionen', 'Kapiteldatei_erstellen', False);
    Ausgabebenutzen := IniFile.ReadBool('SchnittOptionen', 'Ausgabebenutzen', False);
    Speicherplatzpruefen := IniFile.ReadBool('SchnittOptionen', 'Speicherplatzpruefen', True);
    Framegenauschneiden := IniFile.ReadBool('Videoschnitt', 'Framegenauschneiden', True);
//    Framegenauschneiden := True;
    Timecodekorrigieren := IniFile.ReadBool('Videoschnitt', 'Timecode_korrigieren', True);
    Bitratekorrigieren := IniFile.ReadBool('Videoschnitt', 'Bitrate_korrigieren', False);
    maxGOPLaengeverwenden := IniFile.ReadBool('Videoschnitt', 'max_GOPLaenge_verwenden', False);
    D2VDateierstellen := IniFile.ReadBool('Videoschnitt', 'D2VDateierstellen', False);
    IDXDateierstellen := IniFile.ReadBool('Videoschnitt', 'IDXDateierstellen', False);
    ZusammenhaengendeSchnitteberechnen := IniFile.ReadBool('Videoschnitt', 'ZusammenhaengendeSchnitteberechnen', False);
    BitrateersterHeader := IniFile.ReadInteger('Videoschnitt', 'BitrateersterHeader', 0);
    festeBitrate := IniFile.ReadInteger('Videoschnitt', 'feste_Bitrate', 0);
    AspectratioersterHeader := IniFile.ReadInteger('Videoschnitt', 'AspectratioersterHeader', 0);
    AspectratioOffset := IniFile.ReadInteger('Videoschnitt', 'AspectratioOffset', 0);
    maxGOPLaenge := IniFile.ReadInteger('Videoschnitt', 'maxGOPGroesse', 0);
    minAnfang := IniFile.ReadInteger('Videoschnitt', 'minAnfang', 0);
    minEnde := IniFile.ReadInteger('Videoschnitt', 'minEnde', 0);
    leereAudioframesMpegliste.Clear;
    I := 0;
    REPEAT
      HString := IniFile.ReadString('Audioschnitt', 'leere_MpegAudioframes-' + IntToStr(I), 'letzter');
      IF HString <> 'letzter' THEN
        leereAudioframesMpegliste.Add(absolutPathAppl(HString, ApplikationsName, False));
      Inc(I);
    UNTIL HString = 'letzter';
    IF leereAudioframesMpegliste.Count = 0 THEN
    BEGIN
      leereAudioframesMpegliste.Add('Audioframes\StilleFrame-stereo-192.mp2');
      leereAudioframesMpegliste.Add('Audioframes\StilleFrame-stereo-192-crc.mp2');
    END;
    leereAudioframesAC3liste.Clear;
    I := 0;
    REPEAT
      HString := IniFile.ReadString('Audioschnitt', 'leere_AC3Audioframes-' + IntToStr(I), 'letzter');
      IF HString <> 'letzter' THEN
        leereAudioframesAC3liste.Add(absolutPathAppl(HString, ApplikationsName, False));
      Inc(I);
    UNTIL HString = 'letzter';
    IF leereAudioframesAC3liste.Count = 0 THEN
    BEGIN
      leereAudioframesAC3liste.Add('Audioframes\Stilleframe-20-256.ac3');
      leereAudioframesAC3liste.Add('Audioframes\Stilleframe-20-384.ac3');
      leereAudioframesAC3liste.Add('Audioframes\Stilleframe-20-448.ac3');
      leereAudioframesAC3liste.Add('Audioframes\Stilleframe-51-448.ac3');
    END;
    leereAudioframesPCMliste.Clear;
    I := 0;
    REPEAT
      HString := IniFile.ReadString('Audioschnitt', 'leere_PCMAudioframes-' + IntToStr(I), 'letzter');
      IF HString <> 'letzter' THEN
        leereAudioframesPCMliste.Add(absolutPathAppl(HString, ApplikationsName, False));
      Inc(I);
    UNTIL HString = 'letzter';
// ------------ Schnittliste -------------
    SchnittpunktFormat := IniFile.ReadString('SchnittlistenFormat', 'Zahlenformat', 'hh:mm:ss.ff');
    SchnittpunktTrennzeichen := IniFile.ReadString('SchnittlistenFormat', 'Trennzeichen', ' -- ');
    SchnittpunktAnfangbild := IniFile.ReadBool('SchnittlistenFormat', 'Anfangbild', False);
    SchnittpunktEndebild := IniFile.ReadBool('SchnittlistenFormat', 'Endebild', False);
    SchnittpunktBildbreite := IniFile.ReadInteger('SchnittlistenFormat', 'Bildbreite', 80);
    SchnittpunktberechnenFarbe := IniFile.ReadInteger('SchnittlistenFormat', 'Farbe_berechnen', 128);
    SchnittpunktnichtberechnenFarbe := IniFile.ReadInteger('SchnittlistenFormat', 'Farbe_nichtberechnen', 32768);
    Schnittpunkteinfuegen := IniFile.ReadInteger('SchnittlistenFormat', 'Einfuegen', 0);
// ------------ Kapitelliste -------------
    SchnittlistenFormatuebernehmen := IniFile.ReadBool('KapitellistenFormat', 'SchnittlistenFormatuebernehmen', False);
    IF SchnittlistenFormatuebernehmen THEN
      KapitelFormat := SchnittpunktFormat
    ELSE
      KapitelFormat := IniFile.ReadString('KapitellistenFormat', 'Zahlenformat', 'hh:mm:ss.mss');
    KapitelTrennzeile1 := IniFile.ReadString('KapitellistenFormat', 'Trennzeile1', '--');
    KapitelTrennzeile2 := IniFile.ReadString('KapitellistenFormat', 'Trennzeile2', '--');
    KapitelTrennzeile3 := IniFile.ReadString('KapitellistenFormat', 'Trennzeile3', '---------------');
    KapitelTrennzeile4 := IniFile.ReadString('KapitellistenFormat', 'Trennzeile4', 'Trennzeile');
    KapitellistenVGFarbe := IniFile.ReadInteger('KapitellistenFormat', 'VordergrundFarbe', 0);
    KapitellistenHGFarbe := IniFile.ReadInteger('KapitellistenFormat', 'HintergrundFarbe', 12632256);
    KapitellistenMarkierungVGFarbe := IniFile.ReadInteger('KapitellistenFormat', 'MarkierungVGFarbe', 16777215);
    KapitellistenMarkierungHGFarbe := IniFile.ReadInteger('KapitellistenFormat', 'MarkierungHGFarbe', 16711680);
    KapitellistenVerschiebeVGFarbe := IniFile.ReadInteger('KapitellistenFormat', 'VerschiebeVGFarbe', 128);
    KapitellistenVerschiebeHGFarbe := IniFile.ReadInteger('KapitellistenFormat', 'VerschiebeHGFarbe', 12632256);
    Kapiteleinfuegen := IniFile.ReadInteger('KapitellistenFormat', 'Einfuegen', 0);
    KapitellisteSpaltenbreite1 := IniFile.ReadInteger('KapitellistenFormat', 'Spaltenbreite1', 11);
    KapitellisteSpaltenbreite2 := IniFile.ReadInteger('KapitellistenFormat', 'Spaltenbreite2', 11);
    KapitellisteSpaltenbreite3 := IniFile.ReadInteger('KapitellistenFormat', 'Spaltenbreite3', 80);
    KapitellisteSpaltenbreite4 := IniFile.ReadInteger('KapitellistenFormat', 'Spaltenbreite4', 80);
// ------------ Markenliste -------------
    MarkenFormat := IniFile.ReadString('MarkenlistenFormat', 'Zahlenformat', 'hh:mm:ss.mss');
    Markenlistebearbeiten := IniFile.ReadBool('MarkenlistenFormat', 'Liste_bearbeiten', True);
    Markeneinfuegen := IniFile.ReadInteger('MarkenlistenFormat', 'Einfuegen', 0);
// ------------ Listenimport -------------
    SchnittlistenimportFormatuebernehmen1 := IniFile.ReadBool('Listenimport', 'SchnittlistenimportFormatKapiteluebernehmen', False);
    SchnittlistenimportFormatuebernehmen2 := IniFile.ReadBool('Listenimport', 'SchnittlistenimportFormatMarkenuebernehmen', False);
    SchnittImportTrennzeichenliste.Clear;
    I := 0;
    REPEAT
      HString := IniFile.ReadString('Listenimport', 'SchnittTrennzeichen-' + IntToStr(I), 'letzter');
      IF HString <> 'letzter' THEN
        SchnittImportTrennzeichenliste.Add(AnsiReplaceText(HString, '~', ' '));
      Inc(I);
    UNTIL HString = 'letzter';
    SchnittImportZeitTrennzeichenliste.Clear;
    I := 0;
    REPEAT
      HString := IniFile.ReadString('Listenimport', 'SchnittZeitTrennzeichen-' + IntToStr(I), 'letzter');
      IF HString <> 'letzter' THEN
        SchnittImportZeitTrennzeichenliste.Add(AnsiReplaceText(HString, '~', ' '));
      Inc(I);
    UNTIL HString = 'letzter';
    IF SchnittlistenimportFormatuebernehmen1 THEN
    BEGIN
      KapitelImportTrennzeichenliste.Assign(SchnittImportTrennzeichenliste);
      KapitelImportZeitTrennzeichenliste.Assign(SchnittImportZeitTrennzeichenliste);
    END
    ELSE
    BEGIN
      KapitelImportTrennzeichenliste.Clear;
      I := 0;
      REPEAT
        HString := IniFile.ReadString('Listenimport', 'KapitelTrennzeichen-' + IntToStr(I), 'letzter');
        IF HString <> 'letzter' THEN
          KapitelImportTrennzeichenliste.Add(AnsiReplaceText(HString, '~', ' '));
        Inc(I);
      UNTIL HString = 'letzter';
      KapitelImportZeitTrennzeichenliste.Clear;
      I := 0;
      REPEAT
        HString := IniFile.ReadString('Listenimport', 'KapitelZeitTrennzeichen-' + IntToStr(I), 'letzter');
        IF HString <> 'letzter' THEN
          KapitelImportZeitTrennzeichenliste.Add(AnsiReplaceText(HString, '~', ' '));
        Inc(I);
      UNTIL HString = 'letzter';
    END;
    IF SchnittlistenimportFormatuebernehmen2 THEN
    BEGIN
      MarkenImportTrennzeichenliste.Assign(SchnittImportTrennzeichenliste);
      MarkenImportZeitTrennzeichenliste.Assign(SchnittImportZeitTrennzeichenliste);
    END
    ELSE
    BEGIN
      MarkenImportTrennzeichenliste.Clear;
      I := 0;
      REPEAT
        HString := IniFile.ReadString('Listenimport', 'MarkenTrennzeichen-' + IntToStr(I), 'letzter');
        IF HString <> 'letzter' THEN
          MarkenImportTrennzeichenliste.Add(AnsiReplaceText(HString, '~', ' '));
        Inc(I);
      UNTIL HString = 'letzter';
      MarkenImportZeitTrennzeichenliste.Clear;
      I := 0;
      REPEAT
        HString := IniFile.ReadString('Listenimport', 'MarkenZeitTrennzeichen-' + IntToStr(I), 'letzter');
        IF HString <> 'letzter' THEN
          MarkenImportZeitTrennzeichenliste.Add(AnsiReplaceText(HString, '~', ' '));
        Inc(I);
      UNTIL HString = 'letzter';
    END;
// ------------ Listenexport -------------
    SchnittlistenexportFormatuebernehmen1 := IniFile.ReadBool('ListenExport', 'SchnittlistenexportFormatKapiteluebernehmen', False);
    SchnittlistenexportFormatuebernehmen2 := IniFile.ReadBool('ListenExport', 'SchnittlistenexportFormatMarkenuebernehmen', False);
    SchnittExportFormat := IniFile.ReadString('ListenExport', 'Schnittexport_Format', 'hh:mm:ss.ff');
    SchnittExportOffset := IniFile.ReadInteger('ListenExport', 'Schnittexport_Offset', 0);
    IF SchnittlistenexportFormatuebernehmen1 THEN
    BEGIN
      KapitelExportFormat := SchnittExportFormat;
      KapitelExportOffset := SchnittExportOffset;
    END
    ELSE
    BEGIN
      KapitelExportFormat := IniFile.ReadString('ListenExport', 'Kapitelexport_Format', 'hh:mm:ss.mss');
      KapitelExportOffset := IniFile.ReadInteger('ListenExport', 'Kapitelexport_Offset', 0);
    END;
    IF SchnittlistenexportFormatuebernehmen2 THEN
    BEGIN
      MarkenExportFormat := SchnittExportFormat;
      MarkenExportOffset := SchnittExportOffset;
    END
    ELSE
    BEGIN
      MarkenExportFormat := IniFile.ReadString('ListenExport', 'Markenexport_Format', 'hh:mm:ss.mss');
      MarkenExportOffset := IniFile.ReadInteger('ListenExport', 'Markenexport_Offset', 0);
    END;
// ------------ Tastenbelegung -------------------------------
    I := 1;
    REPEAT
      HInteger := IniFile.ReadInteger('Tastenbelegung', 'Taste-' + IntToStr(I), -1);
      IF HInteger > -1 THEN
        Tasten[I] := HInteger;
      Inc(I);
    UNTIL (HInteger = -1) OR (I > High(Tasten));
    InfofensterTasten := IniFile.ReadBool('Tastenbelegung', 'InfofensterTasten', False);
    SchnittlisteTasten := IniFile.ReadBool('Tastenbelegung', 'SchnittlisteTasten', False);
    KapitellisteTasten := IniFile.ReadBool('Tastenbelegung', 'KapitellisteTasten', True);
    MarkenlisteTasten := IniFile.ReadBool('Tastenbelegung', 'MarkenlisteTasten', True);
    DateienfensterTasten := IniFile.ReadBool('Tastenbelegung', 'DateienfensterTasten', False);
    Schrittweite1 := IniFile.ReadInteger('Tastenbelegung', 'Schrittweite1', 10);
    Schrittweite2 := IniFile.ReadInteger('Tastenbelegung', 'Schrittweite2', 20);
    Schrittweite3 := IniFile.ReadInteger('Tastenbelegung', 'Schrittweite3', 100);
    Schrittweite4 := IniFile.ReadInteger('Tastenbelegung', 'Schrittweite4', 200);
// ------------ Navigation -------------
    Abspielzeit := IniFile.ReadInteger('Navigation', 'Abspielzeit', 2);
    Scrollrad := IniFile.ReadInteger('Navigation', 'Scrollrad', 0);
    VAextra := IniFile.ReadBool('Navigation', 'VAextra', False);
    OutSchnittanzeigen := IniFile.ReadBool('Navigation', 'OutSchnittanzeigen', False);
    KlickStartStop := IniFile.ReadBool('Navigation', 'KlickStartStop', True);
    DoppelklickMaximieren := IniFile.ReadBool('Navigation', 'DoppelklickMaximieren', False);
    Videoeigenschaftenaktualisieren := IniFile.ReadBool('Navigation', 'Videoeigenschaftenaktualisieren', False);
    Audioeigenschaftenaktualisieren := IniFile.ReadBool('Navigation', 'Audioeigenschaftenaktualisieren', False);
// ------------ Vorschau --------------------
    IF IniFile.ValueExists('Vorschau', 'Vorschaudauer') THEN
    BEGIN
      Vorschaudauer1 := IniFile.ReadInteger('Vorschau', 'Vorschaudauer', 5);
      Vorschaudauer2 := Vorschaudauer1;
    END
    ELSE
    BEGIN
      Vorschaudauer1 := IniFile.ReadInteger('Vorschau', 'Vorschaudauer1', 5);
      Vorschaudauer2 := IniFile.ReadInteger('Vorschau', 'Vorschaudauer2', 5);
    END;
    Vorschauerweitern := IniFile.ReadBool('Vorschau', 'Vorschauerweitern', False);
    VorschaudauerPlus := IniFile.ReadInteger('Vorschau', 'VorschaudauerPlus', 1);
    VorschauImmerberechnen := IniFile.ReadBool('Vorschau', 'Vorschau_immer_berechnen', False);
    Vorschaudateienloeschen := IniFile.ReadBool('Vorschau', 'Vorschaudateien_loeschen', False);
// ------------ Ein-/Ausgabeprogramme --------------------
    Demuxerdatei := absolutPathAppl(IniFile.ReadString('Demuxer', 'Demuxerdatei', ''), ApplikationsName, False);
    Encoderdatei := absolutPathAppl(IniFile.ReadString('Encoder', 'Encoderdatei', 'Encoder\EncoderHC.prg'), ApplikationsName, False);
    Ausgabedatei := absolutPathAppl(IniFile.ReadString('Ausgabe', 'Ausgabedatei', 'Muxen\muxen_mit_mplex_DVDAuthor.prg'), ApplikationsName, False);
// ------------ Effekte --------------------
    VideoEffektverzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Effekte', 'VideoEffektverzeichnis', 'Videoeffekt'), ApplikationsName, True));
    AudioEffektverzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Effekte', 'AudioEffektverzeichnis', 'Audioeffekt'), ApplikationsName, True));
    Effektvorgabedatei := absolutPathAppl(IniFile.ReadString('Effekte', 'Effektvorgabedatei', 'Effektvorgabe.eff'), ApplikationsName, False);
    Videoeffektvorgabe := IniFile.ReadString('Effekte', 'Videoeffektvorgabe', '');
    Audioeffektvorgabe := IniFile.ReadString('Effekte', 'Audioeffektvorgabe', '');
    Vorgabeeffekteverwenden := IniFile.ReadBool('Effekte', 'Vorgabeeffekteverwenden', False);
// ------------ Grobansicht ----------------
    GrobansichtFensterSichtbar := IniFile.ReadBool('Grobansicht', 'GrobansichtSichtbar', False);
    GrobansichtFensterMaximized := IniFile.ReadBool('Grobansicht', 'GrobansichtMaximized', False);
    GrobansichtFensterLinks := IniFile.ReadInteger('Grobansicht', 'GrobansichtLinks', 0);
    GrobansichtFensterOben := IniFile.ReadInteger('Grobansicht', 'GrobansichtOben', 0);
    GrobansichtFensterBreite := IniFile.ReadInteger('Grobansicht', 'GrobansichtBreite', 800);
    GrobansichtFensterHoehe := IniFile.ReadInteger('Grobansicht', 'GrobansichtHoehe', 560);
    GrobansichtFensterRahmen := IniFile.ReadBool('Grobansicht', 'GrobansichtRahmen', True);
    GrobansichtFensterVordergrund := IniFile.ReadBool('Grobansicht', 'GrobansichtimVordergrund', False);
    GrobansichtFensterSchnellstartleiste := IniFile.ReadBool('Grobansicht', 'GrobansichtSchnellstartleiste', True);
    GrobansichtFarbeWerbung := IniFile.ReadInteger('Grobansicht', 'GrobansichtFarbeWerbung', 255);
    GrobansichtFarbeFilm := IniFile.ReadInteger('Grobansicht', 'GrobansichtFarbeFilm', 32768);
    GrobansichtFarbeAktiv := IniFile.ReadInteger('Grobansicht', 'GrobansichtFarbeAktiv', 8388608);
    GrobansichtSchritt := IniFile.ReadInteger('Grobansicht', 'GrobansichtSchritt', 3000);
    GrobansichtBildweite := IniFile.ReadInteger('Grobansicht', 'GrobansichtBildweite', 80);
// ------------ Binäre Suche ---------------
    BinaereSucheFensterSichtbar := IniFile.ReadBool('BinaereSuche', 'BinaereSucheSichtbar', False);
    BinaereSucheFensterLinks := IniFile.ReadInteger('BinaereSuche', 'BinaereSucheLinks', 0);
    BinaereSucheFensterOben := IniFile.ReadInteger('BinaereSuche', 'BinaereSucheOben', 0);
    BinaereSucheFensterBreite := IniFile.ReadInteger('BinaereSuche', 'BinaereSucheBreite', 210);
    BinaereSucheFensterHoehe := IniFile.ReadInteger('BinaereSuche', 'BinaereSucheHoehe', 84);
    BinaereSucheFensterRahmen := IniFile.ReadBool('BinaereSuche', 'BinaereSucheRahmen', False);
    BinaereSucheFensterVordergrund := IniFile.ReadBool('BinaereSuche', 'BinaereSucheimVordergrund', False);
// ------------ SchnittTool ----------------
    SchnittToolFensterMaximized := IniFile.ReadBool('SchnittTool', 'SchnittToolMaximized', False);
    SchnittToolFensterLinks := IniFile.ReadInteger('SchnittTool', 'SchnittToolLinks', -1);
    SchnittToolFensterOben := IniFile.ReadInteger('SchnittTool', 'SchnittToolOben', -1);
    SchnittToolFensterBreite := IniFile.ReadInteger('SchnittTool', 'SchnittToolBreite', -1);
    SchnittToolFensterHoehe := IniFile.ReadInteger('SchnittTool', 'SchnittToolHoehe', -1);
    SchnittToolProtokollSplitterPos := IniFile.ReadInteger('SchnittTool', 'SchnittToolSplitterPos', 256);
    IF Version < 1 THEN                                               // alte Versionen werden hier angepasst
    BEGIN
// ------------ Allgemein --------------------------------
// ------------ Verzeichnisse --------------------------------
      IF NOT IniFile.SectionExists('Verzeichnisse') THEN              // alte "Maudatei", neu ab V 0.6l-c
      BEGIN
        VideoAudioVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Allgemein', 'VideoAudioVerzeichnis', ''), ApplikationsName, True));
        VideoAudioVerzeichnisspeichern := IniFile.ReadBool('Allgemein', 'VideoAudioVerzeichnisspeichern', True);
        ZielVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Allgemein', 'ZielVerzeichnis', ''), ApplikationsName, True));
        ZielVerzeichnisspeichern := IniFile.ReadBool('Allgemein', 'ZielVerzeichnisspeichern', True);
        ProjektVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Allgemein', 'ProjektVerzeichnis', 'Projekte'), ApplikationsName, True));
        ProjektVerzeichnisspeichern := IniFile.ReadBool('Allgemein', 'ProjektVerzeichnisspeichern', True);
        KapitelVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Allgemein', 'KapitelVerzeichnis', ''), ApplikationsName, True));
        KapitelVerzeichnisspeichern := IniFile.ReadBool('Allgemein', 'KapitelVerzeichnisspeichern', True);
        VorschauVerzeichnis := mitPathtrennzeichen(absolutPathAppl(IniFile.ReadString('Allgemein', 'VorschauVerzeichnis', 'Vorschau'), ApplikationsName, True));
      END;
// ------------ Dateinamen/Endungen --------------------------------
      ZielDateiname := IniFile.ReadString('Dateinamen_Endungen', 'ZielDateiname', '$alt#');
      IF NOT IniFile.SectionExists('Dateinamen_Endungen') THEN
      BEGIN
        ZielDateiname := IniFile.ReadString('Allgemein', 'ZielDateiname', '');
        IF ZielDateiname <> '' THEN
          Zieldateidialogunterdruecken := True
        ELSE
          Zieldateidialogunterdruecken := False;
        ProjektdateieneinzelnFormat := '';
        FOR I := 1 TO IniFile.ReadInteger('Allgemein', 'Projekt_min_Stellen', 3) DO
          ProjektdateieneinzelnFormat := ProjektdateieneinzelnFormat + 'N';
        ProjektdateieneinzelnFormat := '$Number; Format=' + ProjektdateieneinzelnFormat + '#';
        IF IniFile.ReadBool('Allgemein', 'Projekt_Zahl_am_Anfang', False) THEN
          ProjektdateieneinzelnFormat := ProjektdateieneinzelnFormat +
                                         AnsiReplaceText(IniFile.ReadString('Allgemein', 'Projekt_TrennZeichen', ''), '~', ' ') +
                                         '$FileName#'
        ELSE
          ProjektdateieneinzelnFormat := '$FileName#' +
                                         AnsiReplaceText(IniFile.ReadString('Allgemein', 'Projekt_TrennZeichen', ''), '~', ' ') +
                                         ProjektdateieneinzelnFormat;
        SchnittpunkteeinzelnFormat := '';
        FOR I := 1 TO IniFile.ReadInteger('Allgemein', 'Datei_min_Stellen', 3) DO
          SchnittpunkteeinzelnFormat := SchnittpunkteeinzelnFormat + 'N';
        SchnittpunkteeinzelnFormat := '$Number; Format=' + SchnittpunkteeinzelnFormat + '#';
        IF IniFile.ReadBool('Allgemein', 'Datei_Zahl_am_Anfang', False) THEN
          SchnittpunkteeinzelnFormat := SchnittpunkteeinzelnFormat +
                                        AnsiReplaceText(IniFile.ReadString('Allgemein', 'Datei_TrennZeichen', ''), '~', ' ') +
                                        '$FileName#'
        ELSE
          SchnittpunkteeinzelnFormat := '$FileName#' +
                                        AnsiReplaceText(IniFile.ReadString('Allgemein', 'Datei_TrennZeichen', ''), '~', ' ') +
                                        SchnittpunkteeinzelnFormat;
        DateiendungenVideo := IniFile.ReadString('Allgemein', 'Videodateiendungen', '*.mpv;*.m2v');
        DateiendungenVideo := Copy(DateiendungenVideo, Pos('|', DateiendungenVideo) + 1, Length(DateiendungenVideo));       // alte Inidateien angleichen
        StandardEndungenVideo := IniFile.ReadString('Allgemein', 'VideoStandardendungen', '.mpv');
        DateiendungenAudio := IniFile.ReadString('Allgemein', 'Audiodateiendungen', '*.mp2;*.mpa;*.ac3');
        DateiendungenAudio := Copy(DateiendungenAudio, Pos('|', DateiendungenAudio) + 1, Length(DateiendungenAudio));       // alte Inidateien angleichen
        StandardEndungenAudio := IniFile.ReadString('Allgemein', 'AudioStandardendungen', '.mp2');
        StandardEndungenPCM := IniFile.ReadString('Allgemein', 'WAVStandardendungen', '.wav');
        StandardEndungenMP2 := IniFile.ReadString('Allgemein', 'MpegStandardendungen', '.mp2');
        StandardEndungenAC3 := IniFile.ReadString('Allgemein', 'AC3Standardendungen', '.ac3');
        StandardEndungenverwenden := IniFile.ReadBool('Allgemein', 'Standardendungenverwenden', False);
        AudioTrennzeichen := IniFile.ReadString('Allgemein', 'AudioTrennzeichen', '');
      END;
// ------------ Anzeige/Wiedergabe -----------------------
      VideoGraudarstellen := IniFile.ReadBool('Allgemein', 'Video_Grau_darstellen', True);
      letztesVideoanzeigen := IniFile.ReadBool('Allgemein', 'letztes_Video_anzeigen', True);
      Hauptfensteranpassen := IniFile.ReadBool('Allgemein', 'Hauptfensteranpassen', False);
      Videoanzeigegroesse := IniFile.ReadBool('Allgemein', 'V_Anzeigegroesse_fest',True);
      AudioFehleranzeigen := IniFile.ReadBool('Allgemein', 'Audiofehler_anzeigen', False);
      keinAudio := IniFile.ReadBool('Allgemein', 'kein_Audio_abspielen', False);
      MCIPlayer := IniFile.ReadBool('Allgemein', 'MCI-Schnittstelle', False);
      DSPlayer := IniFile.ReadBool('Allgemein', 'DS-Schnittstelle', True);
      AudioGraphName := absolutPathAppl(IniFile.ReadString('Allgemein', 'AudioGraphName', ''), ApplikationsName, False);
// ------------ Video- und Audioschnitt -------------
      IF NOT IniFile.SectionExists('SchnittOptionen') THEN                    // alte "Maudatei", neu ab V 0.6l-c
      BEGIN
        IndexDateierstellen := IniFile.ReadBool('Allgemein', 'IndexDateierstellen', True);
        Kapiteldateierstellen := IniFile.ReadBool('Allgemein', 'Kapiteldatei_erstellen', False);
        Ausgabebenutzen := IniFile.ReadBool('Allgemein', 'Ausgabebenutzen', False);
      END;
      IF NOT IniFile.SectionExists('Videoschnitt') THEN                       // alte "Maudatei", neu ab V 0.6l-c
      BEGIN
        Framegenauschneiden := IniFile.ReadBool('Allgemein', 'Framegenauschneiden', False);
        Timecodekorrigieren := IniFile.ReadBool('Allgemein', 'Timecode_korrigieren', True);
        D2VDateierstellen := IniFile.ReadBool('Allgemein', 'D2VDateierstellen', False);
        IF IniFile.ReadBool('Allgemein', 'feste_Bitrate_im_ersten_Header', False) THEN
          BitrateersterHeader := 4
        ELSE
          IF IniFile.ReadBool('Allgemein', 'Bitrate_korrigieren', True) THEN
            BitrateersterHeader := 1
          ELSE
            BitrateersterHeader := 0;
        festeBitrate := IniFile.ReadInteger('Allgemein', 'feste_Bitrate', 0);
      END;
// ------------ Listenformat -------------
      IF IniFile.SectionExists('ListenFormat') THEN
      BEGIN
        IF IniFile.ValueExists('ListenFormat', 'Schnittpunkt_Trennzeichen1') THEN // alte "Maudatei vor V 0.6m-9
        BEGIN
          SchnittpunktFormat := IniFile.ReadString('ListenFormat', 'Schnittpunkt_Format', 'hh:mm:ss.ff');
          SchnittpunktTrennzeichen := IniFile.ReadString('ListenFormat', 'Schnittpunkt_Trennzeichen1', ' -- ');
        END
        ELSE
        BEGIN                                                                     // alte "Maudatei vor V 0.6m-7e
          SchnittpunktFormat := AnsiReplaceText(IniFile.ReadString('ListenFormat', 'Schnittpunkt_Format', 'hh:mm:ss.ff'), '~', ' ');
          SchnittpunktTrennzeichen := AnsiReplaceText(IniFile.ReadString('ListenFormat', 'Schnittpunkt_Trennzeichen', ' -- '), '~', ' ');
        END;
        SchnittpunktberechnenFarbe := IniFile.ReadInteger('ListenFormat', 'Schnittpunktfarbe_berechnen', 128);
        SchnittpunktnichtberechnenFarbe := IniFile.ReadInteger('ListenFormat', 'Schnittpunktfarbe_nichtberechnen', 32768);
      END
      ELSE                                                                        // alte "Maudatei", neu ab V 0.6l-c
      BEGIN
        SchnittpunktTrennzeichen := AnsiReplaceText(IniFile.ReadString('Allgemein', 'Schnittpunkt_Trennzeichen', '~--~'), '~', ' ');
        IF IniFile.ReadBool('Allgemein', 'SchnittpunktFormat1', False) THEN
          SchnittpunktFormat := 'F'
        ELSE
          IF IniFile.ReadBool('Allgemein', 'SchnittpunktFormat2', False) THEN
            SchnittpunktFormat := 'hh:mm:ss.ff'
          ELSE
            IF IniFile.ReadBool('Allgemein', 'SchnittpunktFormat3', False) THEN
              SchnittpunktFormat := 'hh:mm:ss.mss'
            ELSE
              SchnittpunktFormat := 'hh:mm:ss.ff';
      END;
      IF IniFile.SectionExists('ListenFormat') THEN
      BEGIN
        SchnittlistenFormatuebernehmen := IniFile.ReadBool('ListenFormat', 'SchnittlistenFormatuebernehmen', False);
        IF SchnittlistenFormatuebernehmen THEN
          KapitelFormat := SchnittpunktFormat
        ELSE
          IF IniFile.ValueExists('ListenFormat', 'Kapitel_Format-0') THEN         // alte "Maudatei vor V 0.6m-7e
            KapitelFormat := AnsiReplaceText(IniFile.ReadString('ListenFormat', 'Kapitel_Format-0', 'hh:mm:ss.mss'), '~', ' ')
          ELSE
          BEGIN                                                                   // alte "Maudatei vor V 0.6m-9
            KapitelFormat := IniFile.ReadString('ListenFormat', 'Kapitel_Format', 'hh:mm:ss.mss');
            KapitelTrennzeile1 := IniFile.ReadString('ListenFormat', 'KapitelTrennzeile1', '--');
            KapitelTrennzeile2 := IniFile.ReadString('ListenFormat', 'KapitelTrennzeile2', '--');
            KapitelTrennzeile3 := IniFile.ReadString('ListenFormat', 'KapitelTrennzeile3', '---------------');
            KapitelTrennzeile4 := IniFile.ReadString('ListenFormat', 'KapitelTrennzeile4', 'Trennzeile');
            KapitellistenVGFarbe := IniFile.ReadInteger('ListenFormat', 'KapitellistenVGFarbe', 0);
            KapitellistenHGFarbe := IniFile.ReadInteger('ListenFormat', 'KapitellistenHGFarbe', 12632256);
            KapitellistenMarkierungVGFarbe := IniFile.ReadInteger('ListenFormat', 'KapitellistenMarkierungVGFarbe', 16777215);
            KapitellistenMarkierungHGFarbe := IniFile.ReadInteger('ListenFormat', 'KapitellistenMarkierungHGFarbe', 16711680);
            KapitellistenVerschiebeVGFarbe := IniFile.ReadInteger('ListenFormat', 'KapitellistenVerschiebeVGFarbe', 128);
            KapitellistenVerschiebeHGFarbe := IniFile.ReadInteger('ListenFormat', 'KapitellistenVerschiebeHGFarbe', 12632256);
            KapitellisteSpaltenbreite1 := IniFile.ReadInteger('ListenFormat', 'KapitellisteSpaltenbreite1', 11);
            KapitellisteSpaltenbreite2 := IniFile.ReadInteger('ListenFormat', 'KapitellisteSpaltenbreite2', 11);
            KapitellisteSpaltenbreite3 := IniFile.ReadInteger('ListenFormat', 'KapitellisteSpaltenbreite3', 80);
            KapitellisteSpaltenbreite4 := IniFile.ReadInteger('ListenFormat', 'KapitellisteSpaltenbreite4', 80);
          END;
      END
      ELSE
      BEGIN                                                                       // alte "Maudatei", neu ab V 0.6l-c
        IF IniFile.ReadBool('Allgemein', 'KapitelFormat2', False) THEN
          KapitelFormat := 'hh:mm:ss.ff'
        ELSE
          IF IniFile.ReadBool('Allgemein', 'KapitelFormat3', False) THEN
            KapitelFormat := 'hh:mm:ss.mss'
          ELSE
            IF IniFile.ReadBool('Allgemein', 'KapitelFormat1', True) THEN
              KapitelFormat := 'F'
            ELSE
              KapitelFormat := 'hh:mm:ss.mss';
      END;
      IF IniFile.SectionExists('ListenFormat') THEN
      BEGIN                                                                       // alte "Maudatei vor V 0.6m-9
        MarkenFormat := IniFile.ReadString('ListenFormat', 'Marken_Format', 'hh:mm:ss.mss');
        Markenlistebearbeiten := IniFile.ReadBool('ListenFormat', 'Markenliste_bearbeiten', True);
        Markeneinfuegen := IniFile.ReadInteger('ListenFormat', 'Markeneinfuegen', 0);
      END;
// ------------ Listenimport -------------
      IF NOT IniFile.SectionExists('ListenImport') THEN
      BEGIN
        SchnittImportTrennzeichenliste.Clear;
        SchnittImportTrennzeichenliste.Add(' ');
        SchnittImportZeitTrennzeichenliste.Clear;
        SchnittImportZeitTrennzeichenliste.Add(':');
        SchnittImportZeitTrennzeichenliste.Add('.');
        KapitelImportTrennzeichenliste.Clear;
        KapitelImportTrennzeichenliste.Add(' ');
        KapitelImportZeitTrennzeichenliste.Clear;
        KapitelImportZeitTrennzeichenliste.Add(':');
        KapitelImportZeitTrennzeichenliste.Add('.');
        MarkenImportTrennzeichenliste.Clear;
        MarkenImportTrennzeichenliste.Add(' ');
        MarkenImportTrennzeichenliste.Add(';');
        MarkenImportZeitTrennzeichenliste.Clear;
        MarkenImportZeitTrennzeichenliste.Add(':');
        MarkenImportZeitTrennzeichenliste.Add('.');
      END;
// ------------ Listenexport -------------
      IF NOT IniFile.ValueExists('ListenExport', 'Schnittexport_Format') THEN   // alte "Maudatei", neu ab V 0.6m-7e
        SchnittExportFormat := SchnittpunktFormat;
      IF IniFile.SectionExists('ListenExport') THEN
      BEGIN
        IF IniFile.ValueExists('ListenExport', 'Kapitelexport_Format-0') THEN   // neue Formateinstellung ab V 0.6m-7c
        BEGIN
          HString := AnsiReplaceText(IniFile.ReadString('ListenExport', 'Kapitelexport_Trennzeichen', '   '), '~', ' ');
          KapitelExportFormat := '';
          I := 0;
          WHILE IniFile.ValueExists('ListenExport', 'Kapitelexport_Format-' + IntToStr(I)) DO
          BEGIN
            IF KapitelExportFormat <> '' THEN
              KapitelExportFormat := KapitelExportFormat + HString;
            KapitelExportFormat := KapitelExportFormat + AnsiReplaceText(IniFile.ReadString('Listenexport', 'Kapitelexport_Format-' + IntToStr(I), ''), '~', ' ');
            Inc(I);
          END;
        END;
        IF IniFile.ValueExists('ListenExport', 'KapitelOffset') THEN            // neue Formateinstellung ab V 0.6m-7c
          KapitelExportOffset := IniFile.ReadInteger('ListenExport', 'KapitelOffset', 0);
      END
      ELSE
      BEGIN                                                                     // alte "Maudatei", neu ab V 0.6l-c
        KapitelExportFormat := '';
        HString := AnsiReplaceText(IniFile.ReadString('Allgemein', 'Kapitel_TrennZeichen', '   '), '~', ' ');
        IF IniFile.ReadBool('Allgemein', 'KapitelFormat2', False) THEN
          KapitelExportFormat := 'hh:mm:ss.ff';
        IF IniFile.ReadBool('Allgemein', 'KapitelFormat3', False) THEN
        BEGIN
          IF KapitelExportFormat <> '' THEN
            KapitelExportFormat := KapitelExportFormat + HString;
          KapitelExportFormat := KapitelExportFormat + 'hh:mm:ss.mss';
        END;
        IF IniFile.ReadBool('Allgemein', 'KapitelFormat1', True) THEN
        BEGIN
          IF KapitelExportFormat <> '' THEN
            KapitelExportFormat := KapitelExportFormat + HString;
          KapitelExportFormat := KapitelExportFormat + 'F'
        END;
        IF KapitelExportFormat = '' THEN
          KapitelExportFormat := 'hh:mm:ss.mss';
        KapitelExportOffset := IniFile.ReadInteger('Allgemein', 'KapitelOffset', 0);
      END;
// ------------ Tastenbelegung -------------------------------
      IF IniFile.ReadInteger('Tastenbelegung', 'Taste-1', -1) = -1 THEN // alte "Maudatei", neu ab V 0.6l-c
      BEGIN
        Tasten[1] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'Schrittweite1Taste', 'Umschalt'));
        Tasten[2] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'Schrittweite2Taste', 'Steuer'));
        Tasten[3] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'Schrittweite3Taste', 'Alt'));
        Tasten[4] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'Schrittweite4Taste', 'AltGr'));
        Tasten[5] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'ScrollInTaste', 'I'));
        Tasten[6] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'ScrollOutTaste', 'O'));
        Tasten[7] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'PlayTaste', 'Leer'));
        Tasten[8] := 0;
        Tasten[9] := 0;
        Tasten[10] := 0;
        Tasten[11] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'BildvorTaste', 'nachRechts'));
        Tasten[12] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'BildzurueckTaste', 'nachLinks'));
        Tasten[13] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'NaechstesInTaste', 'BildnachUnten'));
        Tasten[14] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'VorherigesInTaste', 'BildnachOben'));
        Tasten[15] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'NaechstesOutTaste', 'nachUnten'));
        Tasten[16] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'VorherigesOutTaste', 'nachOben'));
        Tasten[17] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'GehezuInTaste', 'Einfügen'));
        Tasten[18] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'GehezuOutTaste', 'Entfernen'));
        Tasten[19] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'GehezumAnfangTaste', 'Pos1'));
        Tasten[20] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'GehezumEndeTaste', 'Ende'));
        Tasten[21] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'InSchnittTaste', 'NumEinfügen'));
        Tasten[22] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'OutSchnittTaste', 'NumEntfernen'));
        Tasten[23] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'AendernTaste', '#'));
        Tasten[24] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'NeuTaste', 'Enter'));
        Tasten[25] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'SchneidenTaste', 's'));
        Tasten[26] := 0;
        Tasten[27] := 0;
        Tasten[28] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'VideoAudiooeffnenTaste', 'F3'));
        Tasten[29] := 0;
        Tasten[30] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'ProjektneuTaste', 'F5'));
        Tasten[31] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'ProjektladenTaste', 'F6'));
        Tasten[32] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'ProjektspeichernTaste', 'F7'));
        Tasten[33] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'ProjektspeichernunterTaste', 'F8'));
        Tasten[34] := TastenNummerausName(IniFile.ReadString('Tastenbelegung', 'ProgrammEndeTaste', 'F4'));
        Tasten[35] := 0;
        Tasten[36] := 0;
        Tasten[37] := 0;
        Tasten[38] := 0;
        Tasten[39] := 0;
        Tasten[40] := 0;
        Tasten[41] := 0;
        Tasten[42] := 0;
        Tasten[43] := 0;
        Tasten[44] := TastenNummerausName('w');
        Tasten[45] := TastenNummerausName('f');
      END;
      IF NOT IniFile.ValueExists('Tastenbelegung', 'Schrittweite1') THEN
      BEGIN
        Schrittweite1 := IniFile.ReadInteger('Allgemein', 'Schrittweite1', 10);
        Schrittweite2 := IniFile.ReadInteger('Allgemein', 'Schrittweite2', 20);
        Schrittweite3 := IniFile.ReadInteger('Allgemein', 'Schrittweite3', 100);
        Schrittweite4 := IniFile.ReadInteger('Allgemein', 'Schrittweite4', 200);
      END;
// ------------ Navigation -------------
// ------------ Vorschau --------------------
      IF NOT IniFile.SectionExists('Vorschau') THEN                     // alte "Maudatei", neu ab V 0.6l-c
      BEGIN
        Vorschaudauer1 := IniFile.ReadInteger('Allgemein', 'Vorschaudauer', 5);
        Vorschaudauer2 := Round(Vorschaudauer1 / 2);
        Vorschaudauer1 := Vorschaudauer2;
        VorschauImmerberechnen := IniFile.ReadBool('Allgemein', 'Vorschau_immer_berechnen', False);
      END;
// ------------ Ein-/Ausgabeprogramme --------------------
// ------------ Effekte --------------------
    END;
    IF Version = 1 THEN
      IF IniFile.ReadBool('Videoschnitt', 'feste_Bitrate_im_ersten_Header', False) THEN
        BitrateersterHeader := 4
      ELSE
        IF IniFile.ReadBool('Videoschnitt', 'Bitrate_korrigieren', True) THEN
          BitrateersterHeader := 1
        ELSE
          BitrateersterHeader := 0;
// ------------ Inidatei freigeben ---------------------------
  FINALLY
    IniFile.Free;
  END;
  IF VideoEffektverzeichnis <> '' THEN
    Effekteladen(VideoEffektverzeichnis, VideoEffekte);
  IF AudioEffektverzeichnis <> '' THEN
    Effekteladen(AudioEffektverzeichnis, AudioEffekte);
  IF Effektvorgabedatei <> '' THEN
    Effektvorgabeladen(Effektvorgabedatei);
END;

PROCEDURE TArbeitsumgebung.Arbeitsumgebungspeichern(Name: STRING = '');

VAR IniFile : TIniFile;
    I : Integer;

BEGIN
  IF Name <> '' THEN
    Dateiname := Name;
  IniFile := TIniFile.Create(Dateiname);
  TRY
// ------------ Allgemein --------------------------------
    IniFile.WriteInteger('Allgemein', 'ArbeitsumgebungsVersion', 2);
    IniFile.WriteBool('Allgemein', 'Indexdateien_loeschen', Indexdateienloeschen);
    IniFile.WriteFloat('Allgemein', 'festeFramerate', festeFramerate);
    IniFile.WriteBool('Allgemein', 'SequenzEnde_ignorieren', SequenzEndeignorieren);
    IniFile.WriteBool('Allgemein', 'nach_Schneiden_beenden', nachSchneidenbeenden);
    IniFile.WriteBool('Allgemein', 'Schiebereglerposition_beibehalten', SchiebereglerPosbeibehalten);
    IniFile.WriteInteger('Allgemein', 'Hinweisanzeigedauer', Hinweisanzeigedauer);
    IniFile.WriteInteger('Allgemein', 'Beendenanzeigedauer', Beendenanzeigedauer);
    IniFile.WriteFloat('Allgemein', 'Videoanzeigefaktor', Videoanzeigefaktor);
  //  IniFile.WriteBool('Allgemein', 'NurAudioSpeichern', nurAudiospeichern);
// ------------ Projekt -----------------------------------
    IniFile.WriteBool('Projekt', 'Dateilistegeaendert', Dateilistegeaendert);
    IniFile.WriteBool('Projekt', 'Schnittlistegeaendert', Schnittlistegeaendert);
    IniFile.WriteBool('Projekt', 'Kapitellistegeaendert', Kapitellistegeaendert);
    IniFile.WriteBool('Projekt', 'Markenlistegeaendert', Markenlistegeaendert);
    IniFile.WriteBool('Projekt', 'Effektgeaendert', Effektgeaendert);
    IniFile.WriteBool('Projekt', 'Schneidensetztzurueck', Schneidensetztzurueck);
    FOR I := 0 TO letzteProjekte.Count - 1 DO
      IniFile.WriteString('Projekt', 'Projekt' + IntToStr(I), letzteProjekte.Strings[I]);
    FOR I := 0 TO letzteVerzeichnisse.Count - 1 DO
      IniFile.WriteString('Projekt', 'Verzeichnisse' + IntToStr(I), letzteVerzeichnisse.Strings[I]);
// ------------ Oberfläche --------------------------------
    IniFile.WriteBool('Oberflaeche', 'DateienfensterSichtbar', DateienfensterSichtbar);
    IniFile.WriteInteger('Oberflaeche', 'DateienfensterHoehe', DateienfensterHoehe);
    IniFile.WriteBool('Oberflaeche', 'AudiooffsetfensterSichtbar', AudiooffsetfensterSichtbar);
    IniFile.WriteInteger('Oberflaeche', 'AudiooffsetfensterHoehe', AudiooffsetfensterHoehe);
    IniFile.WriteInteger('Oberflaeche', 'ListenfensterBreite', ListenfensterBreite);
    IniFile.WriteBool('Oberflaeche', 'ListenfensterLinks', ListenfensterLinks);
    IniFile.WriteBool('Oberflaeche', 'DateienimListenfenster', DateienimListenfenster);
    IniFile.WriteBool('Oberflaeche', 'ZweiVideofenster', ZweiVideofenster);
    IniFile.WriteInteger('Oberflaeche', 'SchnitteTabPos', SchnitteTabPos);
    IniFile.WriteInteger('Oberflaeche', 'KapitelTabPos', KapitelTabPos);
    IniFile.WriteInteger('Oberflaeche', 'MarkenTabPos', MarkenTabPos);
    IniFile.WriteInteger('Oberflaeche', 'InfoTabPos', InfoTabPos);
    IniFile.WriteInteger('Oberflaeche', 'DateienTabPos', DateienTabPos);
    IniFile.WriteInteger('Oberflaeche', 'Symboleverwenden', Bilderverwenden);
    IniFile.WriteString('Oberflaeche', 'Bilderdatei', '"' + relativPathAppl(Bilderdatei, ApplikationsName) + '"');
    IniFile.WriteInteger('Oberflaeche', 'SchiebereglerMarkerPosition', SchiebereglerMarkerPosition);
    IniFile.WriteBool('Oberflaeche', 'SchiebereglerMarkeranzeigen', SchiebereglerMarkeranzeigen);
    IniFile.WriteBool('Oberflaeche', 'Tastenfensterzentrieren', Tastenfensterzentrieren);
    IniFile.WriteBool('Oberflaeche', 'MenueTastenbedienung', MenueTastenbedienung);
    IniFile.WriteBool('Oberflaeche', 'TasteEndelinks', TasteEndelinks);
    IniFile.WriteBool('Oberflaeche', 'TasteEnderechts', TasteEnderechts);
    IniFile.WriteString('Oberflaeche', 'HauptfensterSchriftart', HauptfensterSchriftart);
    IniFile.WriteString('Oberflaeche', 'TastenfensterSchriftart', TastenfensterSchriftart);
    IniFile.WriteString('Oberflaeche', 'AnzeigefensterSchriftart', AnzeigefensterSchriftart);
    IniFile.WriteString('Oberflaeche', 'DialogeSchriftart', DialogeSchriftart);
    IniFile.WriteInteger('Oberflaeche', 'HauptfensterSchriftgroesse', HauptfensterSchriftgroesse);
    IniFile.WriteInteger('Oberflaeche', 'TastenfensterSchriftgroesse', TastenfensterSchriftgroesse);
    IniFile.WriteInteger('Oberflaeche', 'AnzeigefensterSchriftgroesse', AnzeigefensterSchriftgroesse);
    IniFile.WriteInteger('Oberflaeche', 'DialogeSchriftgroesse', DialogeSchriftgroesse);
    IniFile.WriteBool('Oberflaeche', 'TastenFetteSchrift', TastenFetteSchrift);
// ------------ Verzeichnisse --------------------------------
    IniFile.EraseSection('Verzeichnisse');
    IniFile.WriteString('Verzeichnisse', 'VideoAudioVerzeichnis', '"' + relativPathAppl(VideoAudioVerzeichnis, ApplikationsName) + '"');
    IniFile.WriteBool('Verzeichnisse', 'VideoAudioVerzeichnisspeichern', VideoAudioVerzeichnisspeichern);
    IniFile.WriteString('Verzeichnisse', 'ZielVerzeichnis', '"' + relativPathAppl(ZielVerzeichnis, ApplikationsName) + '"');
    IniFile.WriteBool('Verzeichnisse', 'ZielVerzeichnisspeichern', ZielVerzeichnisspeichern);
    IniFile.WriteString('Verzeichnisse', 'ProjektVerzeichnis', '"' + relativPathAppl(ProjektVerzeichnis, ApplikationsName) + '"');
    IniFile.WriteBool('Verzeichnisse', 'ProjektVerzeichnisspeichern', ProjektVerzeichnisspeichern);
    IniFile.WriteString('Verzeichnisse', 'KapitelVerzeichnis', '"' + relativPathAppl(KapitelVerzeichnis, ApplikationsName) + '"');
    IniFile.WriteBool('Verzeichnisse', 'KapitelVerzeichnisspeichern', KapitelVerzeichnisspeichern);
    IniFile.WriteString('Verzeichnisse', 'VorschauVerzeichnis', '"' + relativPathAppl(VorschauVerzeichnis, ApplikationsName) + '"');
    IniFile.WriteString('Verzeichnisse', 'ZwischenVerzeichnis', '"' + relativPathAppl(ZwischenVerzeichnis, ApplikationsName) + '"');
// ------------ Dateinamen/Endungen --------------------------------
    IniFile.EraseSection('Dateinamen_Endungen');
    IniFile.WriteString('Dateinamen_Endungen', 'ProjektDateiname', '"' + Projektdateiname + '"');
    IniFile.WriteBool('Dateinamen_Endungen', 'Projektdateidialogunterdruecken', Projektdateidialogunterdruecken);
    IniFile.WriteString('Dateinamen_Endungen', 'ZielDateiname', '"' + ZielDateiname + '"');
    IniFile.WriteBool('Dateinamen_Endungen', 'Zieldateidialogunterdruecken', Zieldateidialogunterdruecken);
    IniFile.WriteString('Dateinamen_Endungen', 'KapitelDateiname', '"' + Kapiteldateiname + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'ProjektdateieneinzelnFormat', '"' + ProjektdateieneinzelnFormat + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'SchnittpunkteeinzelnFormat', '"' + SchnittpunkteeinzelnFormat + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'Videodateiendungen', '"' + DateiendungenVideo + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'VideoStandardendungen', '"' + StandardEndungenVideo + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'Audiodateiendungen', '"' + DateiendungenAudio + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'AudioStandardendungen', '"' + StandardEndungenAudio + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'WAVStandardendungen', '"' + StandardEndungenPCM + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'MpegStandardendungen', '"' + StandardEndungenMP2 + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'AC3Standardendungen', '"' + StandardEndungenAC3 + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'AudioTrennzeichen', '"' + AudioTrennzeichen + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'Kapiteldateiendungen', '"' + DateiendungenKapitel + '"');
    IniFile.WriteString('Dateinamen_Endungen', 'KapitelStandardendungen', '"' + StandardEndungenKapitel + '"');
    IniFile.WriteBool('Dateinamen_Endungen', 'Standardendungenverwenden', StandardEndungenverwenden);
    IniFile.WriteInteger('Dateinamen_Endungen', 'VideoAudiooeffnenFilterIndex', VideoAudiooeffnenFilterIndex);
// ------------ Anzeige/Wiedergabe -----------------------
    IniFile.EraseSection('Anzeige_Wiedergabe');
    IniFile.WriteBool('Anzeige_Wiedergabe', 'Video_Grau_darstellen', VideoGraudarstellen);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'kein_Video_abspielen', keinVideo);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'Hauptfensteranpassen', Hauptfensteranpassen);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'V_Anzeigegroesse_fest',Videoanzeigegroesse);
    IniFile.WriteInteger('Anzeige_Wiedergabe', 'Videohintergrundfarbe', Videohintergrundfarbe);
    IniFile.WriteInteger('Anzeige_Wiedergabe', 'aktVideofensterhintergrundfarbe', Videohintergrundfarbeakt);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'letztes_Video_anzeigen', letztesVideoanzeigen);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'Tempo1_bei_Pause', Tempo1beiPause);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'Audiofehler_anzeigen', AudioFehleranzeigen);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'kein_Audio_abspielen', keinAudio);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'MCI-Schnittstelle', MCIPlayer);
    IniFile.WriteBool('Anzeige_Wiedergabe', 'DS-Schnittstelle', DSPlayer);
    IniFile.WriteString('Anzeige_Wiedergabe', 'AudioGraphName', '"' + relativPathAppl(AudioGraphName, ApplikationsName) + '"');
// ------------ Video- und Audioschnitt -------------
    IniFile.EraseSection('SchnittOptionen');
    IniFile.EraseSection('Videoschnitt');
    IniFile.EraseSection('Audioschnitt');
    IniFile.WriteBool('SchnittOptionen', 'IndexDateierstellen', IndexDateierstellen);
    IniFile.WriteBool('SchnittOptionen', 'Kapiteldatei_erstellen', Kapiteldateierstellen);
    IniFile.WriteBool('SchnittOptionen', 'Ausgabebenutzen', Ausgabebenutzen);
    IniFile.WriteBool('SchnittOptionen', 'Speicherplatzpruefen', Speicherplatzpruefen);
    IniFile.WriteBool('Videoschnitt', 'Framegenauschneiden', Framegenauschneiden);
    IniFile.WriteBool('Videoschnitt', 'Timecode_korrigieren', Timecodekorrigieren);
    IniFile.WriteBool('Videoschnitt', 'Bitrate_korrigieren', Bitratekorrigieren);
    IniFile.WriteBool('Videoschnitt', 'max_GOPLaenge_verwenden', maxGOPLaengeverwenden);
    IniFile.WriteBool('Videoschnitt', 'D2VDateierstellen', D2VDateierstellen);
    IniFile.WriteBool('Videoschnitt', 'IDXDateierstellen', IDXDateierstellen);
    IniFile.WriteBool('Videoschnitt', 'ZusammenhaengendeSchnitteberechnen', ZusammenhaengendeSchnitteberechnen);
    IniFile.WriteInteger('Videoschnitt', 'BitrateersterHeader', BitrateersterHeader);
    IniFile.WriteInteger('Videoschnitt', 'feste_Bitrate', festeBitrate);
    IniFile.WriteInteger('Videoschnitt', 'AspectratioersterHeader', AspectratioersterHeader);
    IniFile.WriteInteger('Videoschnitt', 'AspectratioOffset', AspectratioOffset);
    IniFile.WriteInteger('Videoschnitt', 'maxGOPGroesse', maxGOPLaenge);
    IniFile.WriteInteger('Videoschnitt', 'minAnfang', minAnfang);
    IniFile.WriteInteger('Videoschnitt', 'minEnde', minEnde);
    FOR I := 0 TO leereAudioframesMpegliste.Count - 1 DO
      IniFile.WriteString('Audioschnitt', 'leere_MpegAudioframes-' + IntToStr(I), '"' + relativPathAppl(leereAudioframesMpegliste.Strings[I], ApplikationsName) + '"');
    FOR I := 0 TO leereAudioframesAC3liste.Count - 1 DO
      IniFile.WriteString('Audioschnitt', 'leere_AC3Audioframes-' + IntToStr(I), '"' + relativPathAppl(leereAudioframesAC3liste.Strings[I], ApplikationsName) + '"');
    FOR I := 0 TO leereAudioframesPCMliste.Count - 1 DO
      IniFile.WriteString('Audioschnitt', 'leere_PCMAudioframes-' + IntToStr(I), '"' + relativPathAppl(leereAudioframesPCMliste.Strings[I], ApplikationsName) + '"');
// ------------ Listenformat -------------
    IniFile.EraseSection('ListenFormat');
// ------------ Schnittliste -------------
    IniFile.EraseSection('SchnittlistenFormat');
    IniFile.WriteString('SchnittlistenFormat', 'Zahlenformat', '"' + SchnittpunktFormat + '"');
    IniFile.WriteString('SchnittlistenFormat', 'Trennzeichen', '"' + SchnittpunktTrennzeichen + '"');
    IniFile.WriteBool('SchnittlistenFormat', 'Anfangbild', SchnittpunktAnfangbild);
    IniFile.WriteBool('SchnittlistenFormat', 'Endebild', SchnittpunktEndebild);
    IniFile.WriteInteger('SchnittlistenFormat', 'Bildbreite', SchnittpunktBildbreite);
    IniFile.WriteInteger('SchnittlistenFormat', 'Farbe_berechnen', SchnittpunktberechnenFarbe);
    IniFile.WriteInteger('SchnittlistenFormat', 'Farbe_nichtberechnen', SchnittpunktnichtberechnenFarbe);
    IniFile.WriteInteger('SchnittlistenFormat', 'Einfuegen', Schnittpunkteinfuegen);
// ------------ Kapitelliste -------------
    IniFile.EraseSection('KapitellistenFormat');
    IniFile.WriteBool('KapitellistenFormat', 'SchnittlistenFormatuebernehmen', SchnittlistenFormatuebernehmen);
    IniFile.WriteString('KapitellistenFormat', 'Zahlenformat', '"' + KapitelFormat + '"');
    IniFile.WriteString('KapitellistenFormat', 'Trennzeile1', '"' + KapitelTrennzeile1 + '"');
    IniFile.WriteString('KapitellistenFormat', 'Trennzeile2', '"' + KapitelTrennzeile2 + '"');
    IniFile.WriteString('KapitellistenFormat', 'Trennzeile3', '"' + KapitelTrennzeile3 + '"');
    IniFile.WriteString('KapitellistenFormat', 'Trennzeile4', '"' + KapitelTrennzeile4 + '"');
    IniFile.WriteInteger('KapitellistenFormat', 'VordergrundFarbe', KapitellistenVGFarbe);
    IniFile.WriteInteger('KapitellistenFormat', 'HintergrundFarbe', KapitellistenHGFarbe);
    IniFile.WriteInteger('KapitellistenFormat', 'MarkierungVGFarbe', KapitellistenMarkierungVGFarbe);
    IniFile.WriteInteger('KapitellistenFormat', 'MarkierungHGFarbe', KapitellistenMarkierungHGFarbe);
    IniFile.WriteInteger('KapitellistenFormat', 'VerschiebeVGFarbe', KapitellistenVerschiebeVGFarbe);
    IniFile.WriteInteger('KapitellistenFormat', 'VerschiebeHGFarbe', KapitellistenVerschiebeHGFarbe);
    IniFile.WriteInteger('KapitellistenFormat', 'Einfuegen', Kapiteleinfuegen);
    IniFile.WriteInteger('KapitellistenFormat', 'Spaltenbreite1', KapitellisteSpaltenbreite1);
    IniFile.WriteInteger('KapitellistenFormat', 'Spaltenbreite2', KapitellisteSpaltenbreite2);
    IniFile.WriteInteger('KapitellistenFormat', 'Spaltenbreite3', KapitellisteSpaltenbreite3);
    IniFile.WriteInteger('KapitellistenFormat', 'Spaltenbreite4', KapitellisteSpaltenbreite4);
// ------------ Markenliste -------------
    IniFile.EraseSection('MarkenlistenFormat');
    IniFile.WriteString('MarkenlistenFormat', 'Zahlenformat', '"' + MarkenFormat + '"');
    IniFile.WriteBool('MarkenlistenFormat', 'Liste_bearbeiten', Markenlistebearbeiten);
    IniFile.WriteInteger('MarkenlistenFormat', 'Einfuegen', Markeneinfuegen);
// ------------ Listenimport -------------
    IniFile.EraseSection('Listenimport');
    IniFile.WriteBool('Listenimport', 'SchnittlistenimportFormatKapiteluebernehmen', SchnittlistenimportFormatuebernehmen1);
    IniFile.WriteBool('Listenimport', 'SchnittlistenimportFormatMarkenuebernehmen', SchnittlistenimportFormatuebernehmen2);
    FOR I := 0 TO SchnittImportTrennzeichenliste.Count - 1 DO
      IniFile.WriteString('Listenimport', 'SchnittTrennzeichen-' + IntToStr(I), '"' + SchnittImportTrennzeichenliste.Strings[I] + '"');
    FOR I := 0 TO SchnittImportZeitTrennzeichenliste.Count - 1 DO
      IniFile.WriteString('Listenimport', 'SchnittZeitTrennzeichen-' + IntToStr(I), '"' + SchnittImportZeitTrennzeichenliste.Strings[I] + '"');
    FOR I := 0 TO KapitelImportTrennzeichenliste.Count - 1 DO
      IniFile.WriteString('Listenimport', 'KapitelTrennzeichen-' + IntToStr(I), '"' + KapitelImportTrennzeichenliste.Strings[I] + '"');
    FOR I := 0 TO KapitelImportZeitTrennzeichenliste.Count - 1 DO
      IniFile.WriteString('Listenimport', 'KapitelZeitTrennzeichen-' + IntToStr(I), '"' + KapitelImportZeitTrennzeichenliste.Strings[I] + '"');
    FOR I := 0 TO MarkenImportTrennzeichenliste.Count - 1 DO
      IniFile.WriteString('Listenimport', 'MarkenTrennzeichen-' + IntToStr(I), '"' + MarkenImportTrennzeichenliste.Strings[I] + '"');
    FOR I := 0 TO MarkenImportZeitTrennzeichenliste.Count - 1 DO
      IniFile.WriteString('Listenimport', 'MarkenZeitTrennzeichen-' + IntToStr(I), '"' + MarkenImportZeitTrennzeichenliste.Strings[I] + '"');
// ------------ Listenexport -------------
    IniFile.EraseSection('Listenexport');
    IniFile.WriteBool('Listenexport', 'SchnittlistenexportFormatKapiteluebernehmen', SchnittlistenexportFormatuebernehmen1);
    IniFile.WriteBool('Listenexport', 'SchnittlistenexportFormatMarkenuebernehmen', SchnittlistenexportFormatuebernehmen2);
    IniFile.WriteString('Listenexport', 'Schnittexport_Format', '"' + SchnittExportFormat + '"');
    IniFile.WriteInteger('Listenexport', 'Schnittexport_Offset', SchnittExportOffset);
    IniFile.WriteString('Listenexport', 'Kapitelexport_Format', '"' + KapitelExportFormat + '"');
    IniFile.WriteInteger('Listenexport', 'Kapitelexport_Offset', KapitelExportOffset);
    IniFile.WriteString('Listenexport', 'Markenexport_Format', '"' + MarkenExportFormat + '"');
    IniFile.WriteInteger('Listenexport', 'Markenexport_Offset', MarkenExportOffset);
// ------------ Tastenbelegung -------------------------------
    IniFile.EraseSection('Tastenbelegung');
    FOR  I := Low(Tasten) + 1 TO High(Tasten) DO
      IniFile.WriteInteger('Tastenbelegung', 'Taste-' + IntToStr(I), Tasten[I]);
    IniFile.WriteBool('Tastenbelegung', 'InfofensterTasten', InfofensterTasten);
    IniFile.WriteBool('Tastenbelegung', 'SchnittlisteTasten', SchnittlisteTasten);
    IniFile.WriteBool('Tastenbelegung', 'KapitellisteTasten', KapitellisteTasten);
    IniFile.WriteBool('Tastenbelegung', 'MarkenlisteTasten', MarkenlisteTasten);
    IniFile.WriteBool('Tastenbelegung', 'DateienfensterTasten', DateienfensterTasten);
    IniFile.WriteInteger('Tastenbelegung', 'Schrittweite1', Schrittweite1);
    IniFile.WriteInteger('Tastenbelegung', 'Schrittweite2', Schrittweite2);
    IniFile.WriteInteger('Tastenbelegung', 'Schrittweite3', Schrittweite3);
    IniFile.WriteInteger('Tastenbelegung', 'Schrittweite4', Schrittweite4);
// ------------ Navigation -----------------
    IniFile.EraseSection('Navigation');
    IniFile.WriteInteger('Navigation', 'Abspielzeit', Abspielzeit);
    IniFile.WriteInteger('Navigation', 'Scrollrad', Scrollrad);
    IniFile.WriteBool('Navigation', 'VAextra', VAextra);
    IniFile.WriteBool('Navigation', 'OutSchnittanzeigen', OutSchnittanzeigen);
    IniFile.WriteBool('Navigation', 'KlickStartStop', KlickStartStop);
    IniFile.WriteBool('Navigation', 'DoppelklickMaximieren', DoppelklickMaximieren);
    IniFile.WriteBool('Navigation', 'Videoeigenschaftenaktualisieren', Videoeigenschaftenaktualisieren);
    IniFile.WriteBool('Navigation', 'Audioeigenschaftenaktualisieren', Audioeigenschaftenaktualisieren);
// ------------ Vorschau --------------------
    IniFile.EraseSection('Vorschau');
    IniFile.WriteInteger('Vorschau', 'Vorschaudauer1', Vorschaudauer1);
    IniFile.WriteInteger('Vorschau', 'Vorschaudauer2', Vorschaudauer2);
    IniFile.WriteBool('Vorschau', 'Vorschauerweitern', Vorschauerweitern);
    IniFile.WriteInteger('Vorschau', 'VorschaudauerPlus', VorschaudauerPlus);
    IniFile.WriteBool('Vorschau', 'Vorschau_immer_berechnen', VorschauImmerberechnen);
    IniFile.WriteBool('Vorschau', 'Vorschaudateien_loeschen', Vorschaudateienloeschen);
// ------------ Ein-/Ausgabeprogramme --------------------
    IniFile.EraseSection('Ausgabe');
    IniFile.WriteString('Demuxer', 'Demuxerdatei', '"' + relativPathAppl(Demuxerdatei, ApplikationsName) + '"');
    IniFile.WriteString('Encoder', 'Encoderdatei', '"' + relativPathAppl(Encoderdatei, ApplikationsName) + '"');
    IniFile.WriteString('Ausgabe', 'Ausgabedatei', '"' + relativPathAppl(Ausgabedatei, ApplikationsName) + '"');
// ------------ Effekte --------------------
    IniFile.EraseSection('Effekte');
    IniFile.WriteString('Effekte', 'VideoEffektverzeichnis', '"' + relativPathAppl(VideoEffektverzeichnis, ApplikationsName) + '"');
    IniFile.WriteString('Effekte', 'AudioEffektverzeichnis', '"' + relativPathAppl(AudioEffektverzeichnis, ApplikationsName) + '"');
    IniFile.WriteString('Effekte', 'Effektvorgabedatei', '"' + relativPathAppl(Effektvorgabedatei, ApplikationsName) + '"');
    IniFile.WriteString('Effekte', 'Videoeffektvorgabe', Videoeffektvorgabe);
    IniFile.WriteString('Effekte', 'Audioeffektvorgabe', Audioeffektvorgabe);
    IniFile.WriteBool('Effekte', 'Vorgabeeffekteverwenden', Vorgabeeffekteverwenden);
// ------------ Grobansicht ----------------
    IniFile.WriteInteger('Grobansicht', 'GrobansichtFarbeWerbung', GrobansichtFarbeWerbung);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtFarbeFilm', GrobansichtFarbeFilm);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtFarbeAktiv', GrobansichtFarbeAktiv);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtSchritt', GrobansichtSchritt);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtBildweite', GrobansichtBildweite);
// ------------ Inidatei freigeben ---------------------------
  FINALLY
    IniFile.Free;
  END;
  IF Effektvorgabedatei <> '' THEN
    Effektvorgabespeichern(Effektvorgabedatei);
END;

PROCEDURE TArbeitsumgebung.ProgrammPositionspeichern;

VAR IniFile : TIniFile;

BEGIN
  IniFile := TIniFile.Create(Dateiname);
  TRY
// ------------ Hauptprogramm ---------------------------
    IniFile.WriteBool('Allgemein', 'ProgrammMaximized', ProgrammFensterMaximized);
    IniFile.WriteInteger('Allgemein', 'ProgrammLinks', ProgrammFensterLinks);
    IniFile.WriteInteger('Allgemein', 'ProgrammOben', ProgrammFensterOben);
    IniFile.WriteInteger('Allgemein', 'ProgrammBreite', ProgrammFensterBreite);
    IniFile.WriteInteger('Allgemein', 'ProgrammHoehe', ProgrammFensterHoehe);
// ------------ Grobansicht ----------------
    IniFile.WriteBool('Grobansicht', 'GrobansichtSichtbar', GrobansichtFensterSichtbar);
    IniFile.WriteBool('Grobansicht', 'GrobansichtMaximized', GrobansichtFensterMaximized);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtLinks', GrobansichtFensterLinks);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtOben', GrobansichtFensterOben);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtBreite', GrobansichtFensterBreite);
    IniFile.WriteInteger('Grobansicht', 'GrobansichtHoehe', GrobansichtFensterHoehe);
    IniFile.WriteBool('Grobansicht', 'GrobansichtRahmen', GrobansichtFensterRahmen);
    IniFile.WriteBool('Grobansicht', 'GrobansichtimVordergrund', GrobansichtFensterVordergrund);
    IniFile.WriteBool('Grobansicht', 'GrobansichtSchnellstartleiste', GrobansichtFensterSchnellstartleiste);
// ------------ Binäre Suche ---------------
    IniFile.WriteBool('BinaereSuche', 'BinaereSucheSichtbar', BinaereSucheFensterSichtbar);
    IniFile.WriteInteger('BinaereSuche', 'BinaereSucheLinks', BinaereSucheFensterLinks);
    IniFile.WriteInteger('BinaereSuche', 'BinaereSucheOben', BinaereSucheFensterOben);
    IniFile.WriteInteger('BinaereSuche', 'BinaereSucheBreite', BinaereSucheFensterBreite);
    IniFile.WriteInteger('BinaereSuche', 'BinaereSucheHoehe', BinaereSucheFensterHoehe);
    IniFile.WriteBool('BinaereSuche', 'BinaereSucheRahmen', BinaereSucheFensterRahmen);
    IniFile.WriteBool('BinaereSuche', 'BinaereSucheimVordergrund', BinaereSucheFensterVordergrund);
  FINALLY
    IniFile.Free;
  END;
END;

PROCEDURE TArbeitsumgebung.SchnittToolPositionspeichern;

VAR IniFile : TIniFile;

BEGIN
  IniFile := TIniFile.Create(Dateiname);
  TRY
// ------------ SchnittTool ----------------
    IniFile.WriteBool('SchnittTool', 'SchnittToolMaximized', SchnittToolFensterMaximized);
    IniFile.WriteInteger('SchnittTool', 'SchnittToolLinks', SchnittToolFensterLinks);
    IniFile.WriteInteger('SchnittTool', 'SchnittToolOben', SchnittToolFensterOben);
    IniFile.WriteInteger('SchnittTool', 'SchnittToolBreite', SchnittToolFensterBreite);
    IniFile.WriteInteger('SchnittTool', 'SchnittToolHoehe', SchnittToolFensterHoehe);
    IniFile.WriteInteger('SchnittTool', 'SchnittToolSplitterPos', SchnittToolProtokollSplitterPos);
  FINALLY
    IniFile.Free;
  END;
END;

{PROCEDURE TArbeitsumgebung.ExterneProgrammeladen(Name: STRING);

VAR I : Integer;
//    Version : Integer;
    HString : STRING;
    AusgabeDaten : TProgramme;
    IniFile : TIniFile;

PROCEDURE AusgabeDatenLesen(AusgabeDaten: TAusgabeDaten; AbschnittName, EffektName: STRING);
BEGIN
  IF Assigned(AusgabeDaten) THEN
  BEGIN
    AusgabeDaten.EffektName := EffektName;
    AusgabeDaten.ProgrammName := absolutPathAppl(IniFile.ReadString(AbschnittName, 'Programmname', ''), ApplikationsName, False);
    AusgabeDaten.ProgrammParameter := IniFile.ReadString(AbschnittName, 'ProgrammParameter', '');
    AusgabeDaten.Parameter := IniFile.ReadString(AbschnittName, 'Parameter', '');
    AusgabeDaten.OrginalparameterDatei := absolutPathAppl(IniFile.ReadString(AbschnittName, 'ParameterDatei', ''), ApplikationsName, False);
    AusgabeDaten.ParameterDateiName := absolutPathAppl(IniFile.ReadString(AbschnittName, 'ParameterDateiName', ''), ApplikationsName, False);
  END;
END;

BEGIN
  IniFile := TIniFile.Create(Name);
//  Version := IniFile.ReadInteger('Allgemein', 'extProgrammeVersion', 1);
  Stringliste_loeschen(DemuxerListe);
  DemuxerListe.Add(WortkeineAusgabe);
  DemuxerIndex := IniFile.ReadInteger('Demuxer', 'Index', 0);
  I := 0;
  REPEAT
    HString := IniFile.ReadString('Demuxer' + '-' + IntToStr(I), 'Name', 'letzter');
    IF HString <> 'letzter' THEN
    BEGIN
      AusgabeDaten := TProgramme.Create;
      AusgabeDatenLesen(AusgabeDaten.Programmdaten, 'Demuxer' + '-' + IntToStr(I), HString);
      DemuxerListe.AddObject(HString, AusgabeDaten);
    END;
    Inc(I);
  UNTIL HString = 'letzter';
  IF DemuxerIndex > DemuxerListe.Count - 1 THEN
    DemuxerIndex := 0;
  Stringliste_loeschen(EncoderListe);
  EncoderListe.Add(WortkeineAusgabe);
  EncoderIndex := IniFile.ReadInteger('Encoder', 'Index', 0);
  I := 0;
  REPEAT
    HString := IniFile.ReadString('Encoder' + '-' + IntToStr(I), 'Name', 'letzter');
    IF HString <> 'letzter' THEN
    BEGIN
      AusgabeDaten := TProgramme.Create;
      AusgabeDatenLesen(AusgabeDaten.Programmdaten, 'Encoder' + '-' + IntToStr(I), HString);
      EncoderListe.AddObject(HString, AusgabeDaten);
    END;
    Inc(I);
  UNTIL HString = 'letzter';
  IF EncoderIndex > EncoderListe.Count - 1 THEN
    EncoderIndex := 0;
  Stringliste_loeschen(MuxerListe);
  MuxerListe.Add(WortkeineAusgabe);
  MuxerIndex := IniFile.ReadInteger('Muxer', 'Index', 0);
  I := 0;
  REPEAT
    HString := IniFile.ReadString('Muxer' + '-' + IntToStr(I), 'Name', 'letzter');
    IF HString <> 'letzter' THEN
    BEGIN
      AusgabeDaten := TProgramme.Create;
      AusgabeDatenLesen(AusgabeDaten.Programmdaten, 'Muxer' + '-' + IntToStr(I), HString);
      MuxerListe.AddObject(HString, AusgabeDaten);
    END;
    Inc(I);
  UNTIL HString = 'letzter';
  IF MuxerIndex > MuxerListe.Count - 1 THEN
    MuxerIndex := 0;
  IniFile.Free;
END;

PROCEDURE TArbeitsumgebung.ExterneProgrammespeichern(Name: STRING);

VAR I, J : Integer;
    AusgabeDaten : TProgramme;
    IniFile : TIniFile;

PROCEDURE AusgabeDatenSchreiben(AusgabeDaten: TAusgabeDaten; AbschnittName: STRING);
BEGIN
  IF Assigned(AusgabeDaten) THEN
  BEGIN
    IniFile.WriteString(AbschnittName, 'Name', '"' + AusgabeDaten.EffektName + '"');
    IniFile.WriteString(AbschnittName, 'Programmname', '"' + relativPathAppl(AusgabeDaten.ProgrammName, ApplikationsName) + '"');
    IniFile.WriteString(AbschnittName, 'ProgrammParameter', '"' + AusgabeDaten.ProgrammParameter + '"');
    IniFile.WriteString(AbschnittName, 'Parameter', '"' + AusgabeDaten.Parameter + '"');
    IniFile.WriteString(AbschnittName, 'ParameterDatei', '"' + relativPathAppl(AusgabeDaten.OrginalparameterDatei, ApplikationsName) + '"');
    IniFile.WriteString(AbschnittName, 'ParameterDateiName', '"' + relativPathAppl(AusgabeDaten.ParameterDateiName, ApplikationsName) + '"');
  END;
END;

BEGIN
  IF FileExists(Name) THEN
    DeleteFile(Name);
  IF NOT FileExists(Name) THEN
  BEGIN
    IniFile := TIniFile.Create(Name);
    IniFile.WriteInteger('Allgemein', 'extProgrammeVersion', 1);
    IniFile.WriteInteger('Demuxer', 'Index', DemuxerIndex);
    I := 1;
    J := 0;
    WHILE I < DemuxerListe.Count DO
    BEGIN
      AusgabeDaten := TProgramme(DemuxerListe.Objects[I]);
      IF Assigned(AusgabeDaten) THEN
      BEGIN
        AusgabeDatenSchreiben(AusgabeDaten.Programmdaten, 'Demuxer' + '-' + IntToStr(J));
        Inc(J);
      END;
      Inc(I);
    END;
    IniFile.WriteInteger('Encoder', 'Index', EncoderIndex);
    I := 1;
    J := 0;
    WHILE I < EncoderListe.Count DO
    BEGIN
      AusgabeDaten := TProgramme(EncoderListe.Objects[I]);
      IF Assigned(AusgabeDaten) THEN
      BEGIN
        AusgabeDatenSchreiben(AusgabeDaten.Programmdaten, 'Encoder' + '-' + IntToStr(J));
        Inc(J);
      END;
      Inc(I);
    END;
    IniFile.WriteInteger('Muxer', 'Index', MuxerIndex);
    I := 1;
    J := 0;
    WHILE I < MuxerListe.Count DO
    BEGIN
      AusgabeDaten := TProgramme(MuxerListe.Objects[I]);
      IF Assigned(AusgabeDaten) THEN
      BEGIN
        AusgabeDatenSchreiben(AusgabeDaten.Programmdaten, 'Muxer' + '-' + IntToStr(J));
        Inc(J);
      END;
      Inc(I);
    END;
    IniFile.Free;
  END;
END;     }

PROCEDURE TArbeitsumgebung.Effekteladen(Name: STRING; EffektListe: TStrings);

VAR Suche : TSearchRec;
    I : Integer;
    Effektdatei: TStringList;
    Dateieintrag : TDateiListeneintrag;

BEGIN
  Stringliste_loeschen(EffektListe);
  EffektListe.Add(WortkeinEffekt);
  Effektdatei := TStringList.Create;
  TRY
    IF FindFirst(Name + '*.eff', faAnyFile, Suche) = 0 THEN
    BEGIN
      REPEAT
        Effektdatei.Clear;
        Effektdatei.LoadFromFile(Name + Suche.Name);
        FOR I := 0 TO Effektdatei.Count - 1 DO
        BEGIN
          IF Pos('[', Effektdatei.Strings[I]) = 1 THEN
          BEGIN
            Dateieintrag := TDateiListeneintrag.Create;
            Dateieintrag.Name := Copy(Effektdatei.Strings[I], 2, Length(Effektdatei.Strings[I]) - 2);
            Dateieintrag.Dateiname := Name + Suche.Name;
            EffektListe.AddObject(Dateieintrag.Name, Dateieintrag);
          END;
        END;
      UNTIL FindNext(Suche) <> 0;
      FindClose(Suche);
    END;
  FINALLY
    Effektdatei.Free;
  END;
END;

PROCEDURE TArbeitsumgebung.Effektvorgabeladen(Name: STRING);

VAR I : Integer;
//    Version : Integer;
    HString : STRING;
//    EffektVideoDaten : TEffektVideoDaten;
//    EffektAudioDaten : TEffektAudioDaten;
    EffektvorgabeDaten : TEffektEintrag;
    IniFile : TIniFile;

PROCEDURE  EffektDatenLesen(EffektDaten: TAusgabeDaten; Effekt, Anhang, EffektName: STRING);
BEGIN
  IF Assigned(EffektDaten) THEN
  BEGIN
    EffektDaten.EffektName := EffektName;
    EffektDaten.ProgrammName := absolutPathAppl(IniFile.ReadString(Effekt, 'Programmname' + Anhang, ''), ApplikationsName, False);
    EffektDaten.ProgrammParameter := IniFile.ReadString(Effekt, 'ProgrammParameter' + Anhang, '');
    EffektDaten.Parameter := IniFile.ReadString(Effekt, 'Parameter' + Anhang, '');
    EffektDaten.OrginalparameterDatei := absolutPathAppl(IniFile.ReadString(Effekt, 'ParameterDatei' + Anhang, ''), ApplikationsName, False);
    EffektDaten.ParameterDateiName := absolutPathAppl(IniFile.ReadString(Effekt, 'ParameterDateiName' + Anhang, ''), ApplikationsName, False);
  END;
END;

PROCEDURE  EffektvorgabeDatenLesen(EffektvorgabeDaten: TEffektEintrag; Effekt: STRING);
BEGIN
  IF Assigned(EffektvorgabeDaten) THEN
  BEGIN
    EffektvorgabeDaten.AnfangEffektName := IniFile.ReadString(Effekt, 'AnfangEffektName', '');
    EffektvorgabeDaten.AnfangLaenge := IniFile.ReadInteger(Effekt, 'AnfangLaenge', 0);
    EffektvorgabeDaten.AnfangEffektParameter := IniFile.ReadString(Effekt, 'AnfangEffektParameter', '');
    EffektvorgabeDaten.EndeEffektName := IniFile.ReadString(Effekt, 'EndeEffektName', '');
    EffektvorgabeDaten.EndeLaenge := IniFile.ReadInteger(Effekt, 'EndeLaenge', 0);
    EffektvorgabeDaten.EndeEffektParameter := IniFile.ReadString(Effekt, 'EndeEffektParameter', '');
  END;
END;

BEGIN
  IniFile := TIniFile.Create(Name);
//  Version := IniFile.ReadInteger('Allgemein', 'EffekteVersion', 1);
{  Stringliste_loeschen(VideoEffekte);
  VideoEffekte.Add(WortkeinEffekt);
  I := 0;
  REPEAT
    HString := IniFile.ReadString('Videoeffekt-' + IntToStr(I), 'Effektname', 'letzter');
    IF HString <> 'letzter' THEN
    BEGIN
      EffektVideoDaten := TEffektVideoDaten.Create;
      EffektVideoDaten.EffektEinstellungen := IniFile.ReadString('Videoeffekt-' + IntToStr(I), 'EffektEinstellungen', '');
      EffektDatenLesen(EffektVideoDaten.VideoEffekt, 'Videoeffekt-' + IntToStr(I), '', HString);
      VideoEffekte.AddObject(HString, EffektVideoDaten);
    END;
    Inc(I);
  UNTIL HString = 'letzter';
  Stringliste_loeschen(AudioEffekte);
  AudioEffekte.Add(WortkeinEffekt);
  I := 0;
  REPEAT
    HString := IniFile.ReadString('Audioeffekt-' + IntToStr(I), 'Effektname', 'letzter');
    IF HString <> 'letzter' THEN
    BEGIN
      EffektAudioDaten := TEffektAudioDaten.Create;
      EffektAudioDaten.EffektEinstellungen := IniFile.ReadString('Audioeffekt-' + IntToStr(I), 'EffektEinstellungen', '');
      EffektAudioDaten.alleAudiotypengleich := IniFile.ReadBool('Audioeffekt-' + IntToStr(I), 'alle_Audiotypen_gleich', False);
      IF EffektAudioDaten.alleAudiotypengleich THEN
      BEGIN
        EffektDatenLesen(EffektAudioDaten.AudioEffektPCM, 'Audioeffekt-' + IntToStr(I), '', HString);
        EffektDatenLesen(EffektAudioDaten.AudioEffektMp2, 'Audioeffekt-' + IntToStr(I), '', HString);
        EffektDatenLesen(EffektAudioDaten.AudioEffektAC3, 'Audioeffekt-' + IntToStr(I), '', HString);
      END
      ELSE
      BEGIN
        EffektDatenLesen(EffektAudioDaten.AudioEffektPCM, 'Audioeffekt-' + IntToStr(I), 'PCM', HString);
        EffektDatenLesen(EffektAudioDaten.AudioEffektMp2, 'Audioeffekt-' + IntToStr(I), 'MP2', HString);
        EffektDatenLesen(EffektAudioDaten.AudioEffektAC3, 'Audioeffekt-' + IntToStr(I), 'AC3', HString);
      END;
      AudioEffekte.AddObject(HString, EffektAudioDaten);
    END;
    Inc(I);
  UNTIL HString = 'letzter';  }
  Stringliste_loeschen(Videoeffektvorgaben);
  I := 0;
  WHILE IniFile.SectionExists('Videoeffektvorgabe-' + IntToStr(I)) DO
  BEGIN
    EffektvorgabeDaten := TEffektEintrag.Create;
    EffektvorgabeDatenLesen(EffektvorgabeDaten, 'Videoeffektvorgabe-' + IntToStr(I));
    HString := IniFile.ReadString('Videoeffektvorgabe-' + IntToStr(I), 'Effektvorgabename', '');
    Videoeffektvorgaben.AddObject(HString, EffektvorgabeDaten);
    Inc(I);
  END;
  Stringliste_loeschen(Audioeffektvorgaben);
  I := 0;
  WHILE IniFile.SectionExists('Audioeffektvorgabe-' + IntToStr(I)) DO
  BEGIN
    EffektvorgabeDaten := TEffektEintrag.Create;
    EffektvorgabeDatenLesen(EffektvorgabeDaten, 'Audioeffektvorgabe-' + IntToStr(I));
    HString := IniFile.ReadString('Audioeffektvorgabe-' + IntToStr(I), 'Effektvorgabename', '');
    Audioeffektvorgaben.AddObject(HString, EffektvorgabeDaten);
    Inc(I);
  END;
  IniFile.Free;
END;

PROCEDURE TArbeitsumgebung.Effektvorgabespeichern(Name: STRING);

VAR I, J : Integer;
//    EffektVideoDaten : TEffektVideoDaten;
//    EffektAudioDaten : TEffektAudioDaten;
    EffektvorgabeDaten : TEffektEintrag;
    IniFile : TIniFile;

PROCEDURE  EffektDatenSchreiben(EffektDaten: TAusgabeDaten; Effekt, Anhang: STRING; Namenschreiben: Boolean);
BEGIN
  IF Assigned(EffektDaten) THEN
  BEGIN
    IF Namenschreiben THEN
      IniFile.WriteString(Effekt, 'Effektname', '"' + EffektDaten.EffektName + '"');
    IniFile.WriteString(Effekt, 'Programmname' + Anhang, '"' + relativPathAppl(EffektDaten.ProgrammName, ApplikationsName) + '"');
    IniFile.WriteString(Effekt, 'ProgrammParameter' + Anhang, '"' + EffektDaten.ProgrammParameter + '"');
    IniFile.WriteString(Effekt, 'Parameter' + Anhang, '"' + EffektDaten.Parameter + '"');
    IniFile.WriteString(Effekt, 'ParameterDatei' + Anhang, '"' + relativPathAppl(EffektDaten.OrginalparameterDatei, ApplikationsName) + '"');
    IniFile.WriteString(Effekt, 'ParameterDateiName' + Anhang, '"' + relativPathAppl(EffektDaten.ParameterDateiName, ApplikationsName) + '"');
  END;
END;

PROCEDURE  EffektvorgabeDatenSchreiben(EffektvorgabeDaten : TEffektEintrag; Effekt: STRING);
BEGIN
  IF Assigned(EffektvorgabeDaten) THEN
  BEGIN
    IniFile.WriteString(Effekt, 'AnfangEffektName', '"' + EffektvorgabeDaten.AnfangEffektName + '"');
    IniFile.WriteInteger(Effekt, 'AnfangLaenge', EffektvorgabeDaten.AnfangLaenge);
    IniFile.WriteString(Effekt, 'AnfangEffektParameter', '"' + EffektvorgabeDaten.AnfangEffektParameter + '"');
    IniFile.WriteString(Effekt, 'EndeEffektName', '"' + EffektvorgabeDaten.EndeEffektName + '"');
    IniFile.WriteInteger(Effekt, 'EndeLaenge', EffektvorgabeDaten.EndeLaenge);
    IniFile.WriteString(Effekt, 'EndeEffektParameter', '"' + EffektvorgabeDaten.EndeEffektParameter + '"');
  END;
END;

BEGIN
  IF FileExists(Name) THEN
    DeleteFile(Name);
  IF NOT FileExists(Name) THEN
  BEGIN
    IniFile := TIniFile.Create(Name);
    IniFile.WriteInteger('Allgemein', 'EffektvorgabeVersion', 1);
{    I := 1;
    J := 0;
    WHILE I < VideoEffekte.Count DO
    BEGIN
      EffektVideoDaten := TEffektVideoDaten(VideoEffekte.Objects[I]);
      IF Assigned(EffektVideoDaten) THEN
      BEGIN
        IniFile.WriteString('Videoeffekt-' + IntToStr(J), 'EffektEinstellungen', '"' + EffektVideoDaten.EffektEinstellungen + '"');
        EffektDatenSchreiben(EffektVideoDaten.VideoEffekt, 'Videoeffekt-' + IntToStr(J), '', True);
        Inc(J);
      END;
      Inc(I);
    END;
    I := 1;
    J := 0;
    WHILE I < AudioEffekte.Count DO
    BEGIN
      EffektAudioDaten := TEffektAudioDaten(AudioEffekte.Objects[I]);
      IF Assigned(EffektAudioDaten) THEN
      BEGIN
        IniFile.WriteBool('Audioeffekt-' + IntToStr(J), 'alle_Audiotypen_gleich', EffektAudioDaten.alleAudiotypengleich);
        IniFile.WriteString('Audioeffekt-' + IntToStr(J), 'EffektEinstellungen', '"' + EffektAudioDaten.EffektEinstellungen + '"');
        IF EffektAudioDaten.alleAudiotypengleich THEN
          EffektDatenSchreiben(EffektAudioDaten.AudioEffektPCM, 'Audioeffekt-' + IntToStr(J), '', True)
        ELSE
        BEGIN
          EffektDatenSchreiben(EffektAudioDaten.AudioEffektPCM, 'Audioeffekt-' + IntToStr(J), 'PCM', True);
          EffektDatenSchreiben(EffektAudioDaten.AudioEffektMp2, 'Audioeffekt-' + IntToStr(J), 'MP2', False);
          EffektDatenSchreiben(EffektAudioDaten.AudioEffektAC3, 'Audioeffekt-' + IntToStr(J), 'AC3', False);
        END;
        Inc(J);
      END;
      Inc(I);
    END;     }
    I := 0;
    J := 0;
    WHILE I < Videoeffektvorgaben.Count DO
    BEGIN
      EffektvorgabeDaten := TEffektEintrag(Videoeffektvorgaben.Objects[I]);
      IF Assigned(EffektvorgabeDaten) THEN
      BEGIN
        IniFile.WriteString('Videoeffektvorgabe-' + IntToStr(J), 'Effektvorgabename', '"' + Videoeffektvorgaben.Strings[I] + '"');
        EffektvorgabeDatenSchreiben(EffektvorgabeDaten, 'Videoeffektvorgabe-' + IntToStr(J));
        Inc(J);
      END;
      Inc(I);
    END;
    I := 0;
    J := 0;
    WHILE I < Audioeffektvorgaben.Count DO
    BEGIN
      EffektvorgabeDaten := TEffektEintrag(Audioeffektvorgaben.Objects[I]);
      IF Assigned(EffektvorgabeDaten) THEN
      BEGIN
        IniFile.WriteString('Audioeffektvorgabe-' + IntToStr(J), 'Effektvorgabename', '"' + Audioeffektvorgaben.Strings[I] + '"');
        EffektvorgabeDatenSchreiben(EffektvorgabeDaten, 'Audioeffektvorgabe-' + IntToStr(J));
        Inc(J);
      END;
      Inc(I);
    END;     
    IniFile.Free;
  END;
END;

PROCEDURE TArbeitsumgebung.Spracheaendern(Spracheladen: TSprachen);
BEGIN
  IF VideoEffekte.Count > 0 THEN
    VideoEffekte[0] := WortkeinEffekt;
  IF AudioEffekte.Count > 0 THEN
    AudioEffekte[0] := WortkeinEffekt;
END;

end.
