unit SchnittToolHauptfenster;

interface

uses
  Windows, Messages, Forms, Controls, Menus, Dialogs, Grids, StdCtrls,
  ComCtrls, Buttons, ExtCtrls, Types, {$Warnings Off}FileCtrl{$Warnings On}, StrUtils, Classes, SysUtils,
  IniFiles, ToolWin, DateUtils, ShellApi,
  Mpeg2Unit, Ueber, WinEnde, AllgFunktionen,
  ProtokollUnit, AllgVariablen, DatenTypen,
  DateienUnit, SchnittUnit, KapitelUnit, ProjektUnit, MarkenUnit,
  SchneidenUnit, Mauladenspeichern, Sprachen, Alphablend, Skins,
  Kommandozeile, DateinamenUnit, AusgabeDatenTypen, ScriptUnit,
  AudioschnittUnit,
  VideoHeaderUnit, Math, DateiStreamUnit, XPMan, VideoschnittUnit;   // zum testen


TYPE
  THauptprogramm = class(TForm)
  // Hauptmenü
    Hauptmenue: TMainMenu;
    Linie1: TMenuItem;
    Linie2: TMenuItem;
    Datei: TMenuItem;
    ProjekteinfuegenMenuItem: TMenuItem;
    ProjektentfernenMenuItem: TMenuItem;
    ProgrammEnde: TMenuItem;
    Aktionen: TMenuItem;
    ProjektSchneidenMenuItem: TMenuItem;
    ProjekteschneidenMenuItem: TMenuItem;
    AbbrechenMenuItem: TMenuItem;
    RechnerausschaltenMenuItem: TMenuItem;
    Optionen: TMenuItem;
    ProgrammschliessenMenuItem: TMenuItem;
    StoppenMenuItem: TMenuItem;
    Hilfe: TMenuItem;
  // Popupmenü
    MenueProjektfenster: TPopupMenu;
    ProjekteinfuegenMenuItem1: TMenuItem;
    ProjektentfernenMenuItem1: TMenuItem;
    ProjekteneueinlesenMenuItem: TMenuItem;
    N1: TMenuItem;
    ZielverzeichniswaehlenMenuItem: TMenuItem;
    BenutzerZiel: TMenuItem;
    Tastenpanel: TPanel;
  // Projektlisten
    Dateien: TTreeView;
    Schnittliste: TListBox;
    Kapitelliste: TStringGrid;
    Markenliste: TMemo;
    Hilfe1: TMenuItem;
    Lizenz: TMenuItem;
    Ueber: TMenuItem;
    Protokoll: TMenuItem;
    ProtokollEinMenuItem: TMenuItem;
    ProtokolllevelMenuItem: TMenuItem;
    aendereZahlEdit: TEdit;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ProjekteinfuegenBtn: TSpeedButton;
    ProjektentfernenBtn: TSpeedButton;
    ProgrammEndeBtn: TSpeedButton;
    ProjektSchneidenBtn: TSpeedButton;
    ProjekteSchneidenBtn: TSpeedButton;
    AbbrechenBtn: TSpeedButton;
    StoppenBtn: TSpeedButton;
    ProgrammschliessenBtn: TSpeedButton;
    RechnerausschaltenBtn: TSpeedButton;
    HilfeBtn: TSpeedButton;
    Projektgroesse_: TLabel;
    aktDateigroesse: TLabel;
    Zeit_: TLabel;
    ZeitDatei: TLabel;
    Restzeit_: TLabel;
    RestzeitDatei: TLabel;
    Gesamtezeit_: TLabel;
    GesamtzeitDatei: TLabel;
    GesamtzeitGesamt: TLabel;
    Gesamtezeit_1: TLabel;
    RestzeitGesamt: TLabel;
    Restzeit_1: TLabel;
    ZeitGesamt: TLabel;
    Zeit_1: TLabel;
    Gesamtgroesse: TLabel;
    Gesamtgroesse_: TLabel;
    Fortschrittgesamt: TProgressBar;
    FortschrittDatei: TProgressBar;
    HauptfensterPanel: TPanel;
    ProtokollMemo: TMemo;
    ProtokollSplitter: TSplitter;
    ProjektGrid: TStringGrid;
    EigenschaftenPanel: TPanel;
    Zieldateiname_: TLabel;
    ZieldateinameBtn: TSpeedButton;
    Projektdatei_: TLabel;
    ProjektdateiLabel: TLabel;
    OKTaste: TBitBtn;
    AbbrechenTaste: TBitBtn;
    ZieldateinameEdit: TEdit;
    ProtokollspeichernMenuItem: TMenuItem;
    Trennlinie1: TMenuItem;
    Protokolllevel1MenuItem: TMenuItem;
    Protokolllevel2MenuItem: TMenuItem;
    Protokolllevel3MenuItem: TMenuItem;
    Protokolllevel4MenuItem: TMenuItem;
    Trennlinie2: TMenuItem;
    MenuProtokollfenster: TPopupMenu;
    ProtokollspeichernMenuItem1: TMenuItem;
    MenuItem4: TMenuItem;
    ProtokollKopierenMenuItem: TMenuItem;
    ProtokollLoeschenMenuItem: TMenuItem;
    Protokolllevel0MenuItem: TMenuItem;
    TestBtn1: TButton;
    TestBtn2: TButton;
    ToolButton5: TToolButton;
    Button1: TButton;
    EinstellungenGroupBox: TGroupBox;
    IDDerstellenBox: TCheckBox;
    D2VerstellenBox: TCheckBox;
    IDXerstellenBox: TCheckBox;
    KapitelerstellenBox: TCheckBox;
    TimecodekorrigierenBox: TCheckBox;
    BitratekorrigierenBox: TCheckBox;
    SchnittpunkteeinzelnBox: TCheckBox;
    framegenauSchneidenBox: TCheckBox;
    AusgabenutzenBox: TCheckBox;
    maxGOPLaengeBox: TCheckBox;
    Bitrateim1Header: TComboBox;
    nurAudioBox: TCheckBox;
    ScripteGroupBox: TGroupBox;
    EncoderdateiEdit: TEdit;
    AusgabedateiEdit: TEdit;
    AusgabedateiBtn: TSpeedButton;
    EncoderdateiBtn: TSpeedButton;
    OptionenEncoder_: TLabel;
    OptionenAusgabePr_: TLabel;
    AspectRatio1Header: TComboBox;
  // SchnittTool
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  // Hauptmenü
    procedure ProjekteinfuegenMenuItemClick(Sender: TObject);
    procedure ProjektentfernenMenuItemClick(Sender: TObject);
    procedure ProgrammEndeClick(Sender: TObject);
    procedure AktionenClick(Sender: TObject);
    procedure ProjektSchneidenMenuItemClick(Sender: TObject);
    procedure ProjekteSchneidenMenuItemClick(Sender: TObject);
    procedure AbbrechenMenuItemClick(Sender: TObject);
    procedure StoppenMenuItemClick(Sender: TObject);
    procedure ProtokollEinMenuItemClick(Sender: TObject);
    procedure ProtokollClick(Sender: TObject);
    procedure Protokolllevel0MenuItemClick(Sender: TObject);
    procedure ProgrammschliessenMenuItemClick(Sender: TObject);
    procedure RechnerausschaltenMenuItemClick(Sender: TObject);
    procedure LizenzClick(Sender: TObject);
    procedure UeberClick(Sender: TObject);
  // Popupmenü
    procedure MenueProjektfensterPopup(Sender: TObject);
    procedure ProjekteneueinlesenMenuItemClick(Sender: TObject);
    procedure ZielverzeichniswaehlenMenuItemClick(Sender: TObject);
    procedure BenutzerZielClick(Sender: TObject);
  // Projektfenster
    procedure ProjektGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ProjektGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure ProjektGridClick(Sender: TObject);
    procedure ProjektGridDblClick(Sender: TObject);
    procedure aendereZahlEditExit(Sender: TObject);
    procedure aendereZahlEditKeyPress(Sender: TObject; var Key: Char);
    procedure Hilfe1Click(Sender: TObject);
    procedure HilfeClick(Sender: TObject);
    procedure EigenschaftenBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure DateiClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure Protokolllevel1MenuItemClick(Sender: TObject);
    procedure Protokolllevel2MenuItemClick(Sender: TObject);
    procedure Protokolllevel3MenuItemClick(Sender: TObject);
    procedure Protokolllevel4MenuItemClick(Sender: TObject);
    procedure ProtokollspeichernMenuItemClick(Sender: TObject);
    procedure ProtokollKopierenMenuItemClick(Sender: TObject);
    procedure ProtokollLoeschenMenuItemClick(Sender: TObject);
    procedure OptionenClick(Sender: TObject);
    procedure ProtokollSplitterCanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);
    procedure FormResize(Sender: TObject);
    procedure TestBtn1Click(Sender: TObject);
    procedure TestBtn2Click(Sender: TObject);
    procedure maxGOPLaengeBoxClick(Sender: TObject);
    procedure Bitrateim1HeaderCloseUp(Sender: TObject);
    procedure Bitrateim1HeaderSelect(Sender: TObject);
    procedure AspectRatio1HeaderCloseUp(Sender: TObject);
    procedure AspectRatio1HeaderSelect(Sender: TObject);
  private
    { Private-Deklarationen }
    BenutzerZielVerzeichnis : STRING;
  // Initialisieren/Beenden
    Starten : Boolean;
    einProjekt : Boolean;
    ProgrammPosition : TRect;
  // Fortschritt
    AnfangszeitDatei : TDateTime;
    AnfangszeitGesamt : TDateTime;
    PositionProjekte : Int64;                   // Position der Projektverarbeitung für die Fortschrittsanzeige
    EndwertProjekte : Int64;                    // der Endwert der Fortschrittsanzeige für alle Projekte zusammen
    neuerWert : Integer;
    alterWert : Integer;
    Aktualisierungszyklus : Integer;
    naechsteAktualisierung : TDateTime;
  // Schneiden
    Anhalten : Boolean;
    Laeuft : Boolean;
  // Projektfenster
    MeineSpalte : Integer;
    MeineZeile : Integer;
    pNameSpalte : Byte;
    aAnzahlSpalte : Byte;
    sAnzahlSpalte : Byte;
    pGroesseSpalte : Byte;
    zielSpalte : Byte;
    pOptionenSpalte : Byte;
    statusSpalte : Byte;
{    iddGrSpalte : Byte;
    d2vSpalte : Byte;
    KapSpalte : Byte;
    AusgSpalte : Byte;
    nurAudioSpalte : Byte;
    tcSpalte : Byte;
    brSpalte : Byte;
    festeBrSpalte : Byte; }
    fehlerSpalte : Byte;
 {   vGrSpalte : Byte;
    aGrSpalte : Byte;
    iddSpalte : Byte;
    aTrennSpalte : Byte;
    projektSpalte : Byte;
    mauSpalte : Byte;
    AusgabeSpalte : Byte;
    EffektSpalte : Byte;
    MuxerSpalte : Byte;   }
    WortFertig,
    WortNicht_bereit,
    WortWarte,
    WortVerarbeite,
    WortUeberspringen,
    WortFehlercode,
    WortFehler,
    WortJa,
    WortNein : STRING;
    test,
    test2 : Boolean;                                // zum testen
  // Projekteigenschaften
//    ersterVideoname : STRING;
  // Initialisieren/Beenden
    PROCEDURE Arbeitsumgebung_lesen;
    PROCEDURE Fensterpositionmerken;
    PROCEDURE Nachrichten(var Msg: TMsg; var Handled: Boolean);
  // Projektfenster
    PROCEDURE aendereStatus(Zeile: Integer);
    FUNCTION  DateiinListe(Dateiname: STRING): Boolean;
//    FUNCTION  Videodateiname_von(Projektdatei: STRING): STRING;
    FUNCTION  Projektgroesse(Zeile: Integer): Int64;
    PROCEDURE ZielVerzeichnisAendern(Anfang, Ende: Integer; Eintrag : String);
    PROCEDURE Projekteigenschaftenanzeigen(Zeile: Integer);
    PROCEDURE Projekteigenschaftenuebernehmen(Zeile: Integer);
    FUNCTION ProjektOptionenzuStr(ProjektInfoObj: TProjektInfo): STRING;
    PROCEDURE Markierungsetzen(Zeile: Integer = -1);
    FUNCTION  ProjektAuswerten(Dateiname, Projektname : STRING; Zeile : Integer): Integer;
    PROCEDURE Zellenfuellen(DateienListe: TStrings; Projektname: STRING = 'kein Projekt');
    PROCEDURE Zeilenentfernen(Anfang, Ende: Integer);
    PROCEDURE Projektfenster_Spracheaendern(Spracheladen: TSprachen);
  // Anzeige
    FUNCTION GroessezuStr(Groesse: Int64): STRING;
    PROCEDURE GesamtGroesseBerechnen(Groesse: Int64);
    PROCEDURE GesamtGroesseneuBerechnen(Anfang: Integer = -1; Ende: Integer = -1);
  // Schneiden
    PROCEDURE ProjekteSchneiden(Anfang: Integer = -1; Ende: Integer = -1);
  // Fortschritt
    PROCEDURE Fortschrittzuruecksetzen;
    PROCEDURE GesamtFortschrittzuruecksetzen;
  // Tastenbilder
    PROCEDURE ErsetzeSpeedButtons;
    PROCEDURE SymbolMapping74(skin: TSkinFactory; Mode: Integer);
    PROCEDURE TastenbeschriftungVerbergen(Taste: TSpeedButton);
 //   PROCEDURE TastenbeschriftungAusrichten(Taste: TSpeedButton; Margin1, Spacing1, Margin2, Spacing2: Integer);
    PROCEDURE Tastenbeschriftunganpassen;
    FUNCTION LadeIconTemplate(Mode: Integer; DateiName : STRING): Integer;
  // Sprachen
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  public
    { Public-Deklarationen }
  // Initialisieren/Beenden
    keineOberflaeche : Boolean;
  // Fortschritt
    Endwert : Int64;
  // Initialisieren
    PROCEDURE Initialisieren;
  // Fortschritt
    FUNCTION Fortschrittsanzeige(Fortschritt: Int64): Boolean;
    FUNCTION Textanzeige(Meldung: Integer; Text: STRING): Boolean;
    PROCEDURE Spracheeinlesen;
  end;

var
  Hauptprogramm: THauptprogramm;

implementation

{$R *.DFM}
{$R SchnittToolSymbole.RES}

// Funktionen

FUNCTION getBool(BoolString, WortJa: STRING): BOOLEAN;
BEGIN
  IF BoolString = WortJa THEN
    Result := True
  ELSE
    Result := False;
END;

FUNCTION getString(StringBool: BOOLEAN; WortJa, WortNein: STRING): STRING;
BEGIN
  IF StringBool THEN
    Result := WortJa
  ELSE
    Result := WortNein;
END;

// SchnittTool

procedure THauptprogramm.FormCreate(Sender: TObject);

VAR IniFile : TIniFile;

begin
  Anhalten := False;
//  nichtBeenden := False;
  Laeuft := False;
  Starten := False;
  keineOberflaeche := False;
  einProjekt := False;
//  Abbrechen.Enabled := false;
  Application.OnMessage := Nachrichten;
  DragAcceptFiles(ProjektGrid.Handle, True);
  DateienUnit.Dateiliste := Dateien;
  SchnittUnit.Schnittliste := Schnittliste;
  KapitelUnit.Kapitelliste := Kapitelliste;
  ProtokollUnit.Protokollfenster := ProtokollMemo;
  ErsetzeSpeedButtons;
// Projektfenster
  pNameSpalte    :=  0;
  aAnzahlSpalte  :=  1;
  sAnzahlSpalte  :=  2;
  pGroesseSpalte :=  3;
  zielSpalte     :=  4;
  pOptionenSpalte:=  5;
  statusSpalte   :=  6;
{
  iddSpalte      :=  6;
  d2vSpalte      :=  7;
  KapSpalte      :=  8;
  AusgSpalte     :=  9;
  nurAudioSpalte := 10;
  tcSpalte       := 11;
  brSpalte       := 12;
  festeBrSpalte  := 13; }
  fehlerSpalte   := 7;
 {
  vGrSpalte      := 15;
  aGrSpalte      := 16;
  aTrennSpalte   := 17;
  projektSpalte  := 18;
  mauSpalte      := 19;
  AusgabeSpalte  := 20;
  EffektSpalte   := 21;
  MuxerSpalte    := 22;

  ProjektGrid.ColWidths[vGrSpalte]     := -1;                                   // interne VideoGroessen
  ProjektGrid.ColWidths[aGrSpalte]     := -1;                                   // interne AudioGroessen
  ProjektGrid.ColWidths[iddGrSpalte]   := -1;                                   // interne Groessen für idd lesen und IDD erstellen vorm schneiden
  ProjektGrid.ColWidths[aTrennSpalte]  := -1;                                   // Audiotrennzeichen
  ProjektGrid.ColWidths[projektSpalte] := -1;                                   // Projekt
  ProjektGrid.ColWidths[mauSpalte]     := -1;                                   // verwendete Arbeitsumgebung
  ProjektGrid.ColWidths[AusgabeSpalte] := -1;                                   // Ausgabedatei
  ProjektGrid.ColWidths[EffektSpalte]  := -1;                                   // Effektdatei
  ProjektGrid.ColWidths[MuxerSpalte]   := -1;   }                                // Muxerindex
  ProjektGrid.ColWidths[pnameSpalte]   := 132;
  ProjektGrid.ColWidths[aAnzahlSpalte] := 20;
  ProjektGrid.ColWidths[sAnzahlSpalte] := 20;
  ProjektGrid.ColWidths[pGroesseSpalte]:= 60;
  ProjektGrid.ColWidths[zielSpalte]    := 250;
  ProjektGrid.ColWidths[statusSpalte]  := 70;
  ProjektGrid.ColWidths[pOptionenSpalte]:= 70;
{  ProjektGrid.ColWidths[iddSpalte]     := 30;
  ProjektGrid.ColWidths[d2vSpalte]     := 30;
  ProjektGrid.ColWidths[KapSpalte]     := 32;
  ProjektGrid.ColWidths[AusgSpalte]    := 30;
  ProjektGrid.ColWidths[nurAudioSpalte]:= 30;                                   // Nur Audio schneiden
  ProjektGrid.ColWidths[tcSpalte]      := 30;                                   // Timecode korrigieren
  ProjektGrid.ColWidths[brSpalte]      := 30;                                   // Bitrate_korrigieren
  ProjektGrid.ColWidths[festeBrSpalte] := 70;   }                                // feste Bitrate im ersten Header
  ProjektGrid.ColWidths[fehlerSpalte]  := 300;                                  // Fehlermeldungen
// Fortschrittsanzeige
  naechsteAktualisierung := incMilliSecond(Time,1000);
  Aktualisierungszyklus := 1000;
  Endwert := 100;
// Inidatei laden
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\Mpeg2Schnitt.ini');
  TRY
    Sprachen.aktuelleSprache := IniFile.ReadString('Allgemein', 'aktuelleSprache', '');
    Sprachen.Sprachverzeichnis := absolutPathAppl(IniFile.ReadString('Allgemein', 'Sprachverzeichnis', ''), Application.ExeName, True);
    Sprachen.Sprachdateiname := IniFile.ReadString('Allgemein', 'Sprachdatei', '');
  FINALLY
    IniFile.Free;
  END;
end;

procedure THauptprogramm.FormShow(Sender: TObject);
begin
  ProjektGridClick(Sender);
  Font.Name := ArbeitsumgebungObj.HauptfensterSchriftart;
  Font.Size := ArbeitsumgebungObj.HauptfensterSchriftgroesse;
  ProtokollMemo.Font.Size := ArbeitsumgebungObj.HauptfensterSchriftgroesse;
end;

procedure THauptprogramm.FormActivate(Sender: TObject);
begin
  IF einProjekt THEN
  BEGIN
//    ProgrammschliessenBtn.Enabled := False;
//    RechnerausschaltenBtn.Enabled := False;
//    ProgrammschliessenBtn.Down := True;
//    ProgrammschliessenMenuItem.Checked := True;
    MeineZeile := 1;
    Projekteigenschaftenanzeigen(1);
  END;  
  IF Starten THEN
  BEGIN
    ProjekteSchneiden;
    Starten := False;
  END;
end;

procedure THauptprogramm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IF laeuft THEN
    CanClose := False
  ELSE
    CanClose := True;  
end;

procedure THauptprogramm.FormClose(Sender: TObject; var Action: TCloseAction);

VAR I : Integer;

begin
  ProtokollUnit.Protokoll_schreiben(WortProtokollende);
  ProtokollUnit.Protokoll_schliessen;
  Fensterpositionmerken;
  ArbeitsumgebungObj.SchnittToolPositionspeichern(ArbeitsumgebungObj.Dateiname);
  FOR I := 1 TO ProjektGrid.RowCount - 1 DO
    IF Assigned(ProjektGrid.Objects[I, pOptionenSpalte]) THEN
      ProjektGrid.Objects[I, pOptionenSpalte].Free;
  ArbeitsumgebungObj.Free;
  ArbeitsumgebungObj := NIL;
end;

// Hauptmenü

procedure THauptprogramm.DateiClick(Sender: TObject);
begin
  IF EigenschaftenPanel.Visible THEN
  BEGIN
    ProjekteinfuegenMenuItem.Enabled := False;
    ProjektentfernenMenuItem.Enabled := False;
  END
  ELSE
  BEGIN
    ProjekteinfuegenMenuItem.Enabled := True;
    IF Laeuft THEN
      ProjektentfernenMenuItem.Enabled := False
    ELSE
      ProjektentfernenMenuItem.Enabled := True;
  END;
end;

procedure THauptprogramm.ProjekteinfuegenMenuItemClick(Sender: TObject);

VAR Projektoeffnen : TOpenDialog;
    DateiNamenListe : TStringList;

begin
  Projektoeffnen := TOpenDialog.Create(Self);
  TRY
    Projektoeffnen.Options := [ofHideReadOnly,ofAllowMultiSelect,ofPathMustExist,ofFileMustExist,ofEnableSizing];
    Projektoeffnen.Title := Wortlesen(NIL, 'Dialog24', 'Mpeg2Schnitt Projektdatei einfügen');
    Projektoeffnen.Filter := Wortlesen(NIL, 'Dialog23', 'Mpeg2Schnitt Projektdateien') + '|*.m2e';
    Projektoeffnen.DefaultExt := 'm2e';
    Projektoeffnen.FileName := '';
    Projektoeffnen.InitialDir := ArbeitsumgebungObj.ProjektVerzeichnis;
    IF Projektoeffnen.Execute THEN
    BEGIN
      DateiNamenListe := TStringList.Create;
      TRY
        DateiNamenListe.Assign(Projektoeffnen.Files);
        DateiNamenListe.Sort;
        Zellenfuellen(DateiNamenListe);
      FINALLY
        DateiNamenListe.Free;
      END;
    END;
  FINALLY
    Projektoeffnen.Free;
  END;
end;

procedure THauptprogramm.ProgrammEndeClick(Sender: TObject);
begin
  Close;
end;

procedure THauptprogramm.AktionenClick(Sender: TObject);
begin
  IF laeuft THEN
  BEGIN
    ProjektSchneidenMenuItem.Enabled := False;
    ProjekteschneidenMenuItem.Enabled := False;
    AbbrechenMenuItem.Enabled := True;
    StoppenMenuItem.Enabled := True;
  END
  ELSE
  BEGIN
    IF EigenschaftenPanel.Visible THEN
    BEGIN
      ProjektSchneidenMenuItem.Enabled := False;
      ProjekteschneidenMenuItem.Enabled := False;
    END
    ELSE
    BEGIN
      ProjektSchneidenMenuItem.Enabled := True;
      ProjekteschneidenMenuItem.Enabled := True;
    END;
    AbbrechenMenuItem.Enabled := False;
    StoppenMenuItem.Enabled := False;
  END;
end;

procedure THauptprogramm.ProjektSchneidenMenuItemClick(Sender: TObject);

VAR Markierung : TGridRect;

begin
  Markierung := ProjektGrid.Selection;
  ProjekteSchneiden(Markierung.Top, Markierung.Bottom);
end;

procedure THauptprogramm.ProjekteschneidenMenuItemClick(Sender: TObject);
begin
  ProjekteSchneiden;
end;

procedure THauptprogramm.AbbrechenMenuItemClick(Sender: TObject);
begin
  Anhalten := True;
end;

procedure THauptprogramm.StoppenMenuItemClick(Sender: TObject);
begin
  IF laeuft THEN
    StoppenMenuItem.Checked := NOT StoppenMenuItem.Checked;
  StoppenBtn.Down := StoppenMenuItem.Checked;
end;

procedure THauptprogramm.ProtokollClick(Sender: TObject);
begin
  ProtokollEinMenuItem.Checked := ArbeitsumgebungObj.Protokollerstellen;
//  ProtokollLevelMenuItem.Caption := KopiereVonBis(ProtokollLevelMenuItem.Caption, '', ' -', False, True) +
//                                    ' ' + IntToStr(ProtokollUnit.ProtokollLevel);
  CASE ProtokollUnit.ProtokollLevel OF
    0 : Protokolllevel0MenuItem.Checked := True;
    1 : Protokolllevel1MenuItem.Checked := True;
    2 : Protokolllevel2MenuItem.Checked := True;
    3 : Protokolllevel3MenuItem.Checked := True;
    4 : Protokolllevel4MenuItem.Checked := True;
  END;
end;

procedure THauptprogramm.ProtokollspeichernMenuItemClick(Sender: TObject);

VAR Speichern : TSaveDialog;

begin
  Speichern := TSaveDialog.Create(Self);
  TRY
    Speichern.InitialDir := ExtractFilePath(Application.ExeName);
    Speichern.FileName := 'Protokoll';
    Speichern.DefaultExt := 'txt';
    Speichern.Options := [ofPathMustExist, ofEnableSizing];
    IF Speichern.Execute THEN
      ProtokollMemo.Lines.SaveToFile(Speichern.FileName);
  FINALLY
    Speichern.Free;
  END;
end;

procedure THauptprogramm.Protokolllevel0MenuItemClick(Sender: TObject);
begin
  ProtokollUnit.ProtokollLevel := 0;
end;

procedure THauptprogramm.Protokolllevel1MenuItemClick(Sender: TObject);
begin
  ProtokollUnit.ProtokollLevel := 1;
end;

procedure THauptprogramm.Protokolllevel2MenuItemClick(Sender: TObject);
begin
  ProtokollUnit.ProtokollLevel := 2;
end;

procedure THauptprogramm.Protokolllevel3MenuItemClick(Sender: TObject);
begin
  ProtokollUnit.ProtokollLevel := 3;
end;

procedure THauptprogramm.Protokolllevel4MenuItemClick(Sender: TObject);
begin
  ProtokollUnit.ProtokollLevel := 4;
end;

procedure THauptprogramm.ProtokollEinMenuItemClick(Sender: TObject);
begin
  ProtokollEinMenuItem.Checked := NOT ProtokollEinMenuItem.Checked;
  ArbeitsumgebungObj.Protokollerstellen := ProtokollEinMenuItem.Checked;
  ProtokollUnit.Protokoll_starten_beenden(Ueberfenster.VersionNr);
end;

procedure THauptprogramm.OptionenClick(Sender: TObject);
begin
  IF einProjekt THEN
  BEGIN
//    ProgrammschliessenMenuItem.Enabled := False;
//    RechnerausschaltenMenuItem.Enabled := False;
  END
  ELSE
  BEGIN
    ProgrammschliessenMenuItem.Enabled := True;
    RechnerausschaltenMenuItem.Enabled := True;
  END;
end;

procedure THauptprogramm.ProgrammschliessenMenuItemClick(Sender: TObject);
begin
  ProgrammschliessenMenuItem.Checked := NOT ProgrammschliessenMenuItem.Checked;
  ProgrammschliessenBtn.Down := ProgrammschliessenMenuItem.Checked;
end;

procedure THauptprogramm.RechnerausschaltenMenuItemClick(Sender: TObject);
begin
  RechnerausschaltenMenuItem.Checked := NOT RechnerausschaltenMenuItem.Checked;
  RechnerausschaltenBtn.Down := RechnerausschaltenMenuItem.Checked;
end;

procedure THauptprogramm.HilfeClick(Sender: TObject);
begin
  IF FileExists(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.chm') OR
     FileExists(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.htm') OR
     FileExists(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.html') THEN
    Hilfe1.Enabled := True
  ELSE
    Hilfe1.Enabled := False;
end;

procedure THauptprogramm.Hilfe1Click(Sender: TObject);
begin
  IF FileExists(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.chm') THEN
    ShellExecute(Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.chm'), '', '', SW_SHOWNORMAL)
  ELSE
    IF FileExists(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.htm') THEN
      ShellExecute(Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.htm'), '', '', SW_SHOWNORMAL)
    ELSE
      IF FileExists(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.html') THEN
        ShellExecute(Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.html'), '', '', SW_SHOWNORMAL);
end;

procedure THauptprogramm.LizenzClick(Sender: TObject);
begin
  UeberFenster.Lizenzanzeigen := True;
  UeberFenster.ShowModal;
end;

procedure THauptprogramm.UeberClick(Sender: TObject);
begin
  UeberFenster.Lizenzanzeigen := False;
  UeberFenster.ShowModal;
end;

// Popupmenü

procedure THauptprogramm.MenueProjektfensterPopup(Sender: TObject);
begin
  IF laeuft THEN
  BEGIN
    ProjektentfernenMenuItem1.Enabled := False;
    ProjekteneueinlesenMenuItem.Enabled := False;
  END
  ELSE
  BEGIN
    ProjektentfernenMenuItem1.Enabled := True;
    ProjekteneueinlesenMenuItem.Enabled := True;
  END;
end;

procedure THauptprogramm.ProjektentfernenMenuItemClick(Sender: TObject);

VAR Markierung : TGridRect;

begin
  Markierung := ProjektGrid.Selection;
  Zeilenentfernen(Markierung.Top, Markierung.Bottom);
end;

procedure THauptprogramm.ProjekteneueinlesenMenuItemClick(Sender: TObject);

VAR I : Integer;
    DateiNamenListe : TStringList;

begin
   DateiNamenListe := TStringList.Create;
   TRY
     FOR I := 1 TO ProjektGrid.RowCount - 1 DO
     BEGIN
       IF Assigned(ProjektGrid.Objects[pOptionenSpalte, I]) THEN
         DateinamenListe.Add(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname);
     END;
     Zeilenentfernen(1, ProjektGrid.RowCount - 1);
     Zellenfuellen(DateiNamenListe);
   FINALLY
     DateiNamenListe.Free;
   END;
end;

procedure THauptprogramm.ZielverzeichniswaehlenMenuItemClick(Sender: TObject);

VAR Verzeichnis : STRING;

begin
  IF SelectDirectory(Wortlesen(NIL, 'Dialog103', 'Verzeichnis suchen'), '', Verzeichnis) THEN
  BEGIN
    BenutzerZiel.Caption := mitPathtrennzeichen(Verzeichnis);
    BenutzerZielVerzeichnis := mitPathtrennzeichen(Verzeichnis);
    BenutzerZiel.Enabled := True;
  END
end;

procedure THauptprogramm.BenutzerZielClick(Sender: TObject);

VAR Markierung : TGridRect;

begin
  Markierung := ProjektGrid.Selection;
  ZielverzeichnisAendern(Markierung.Top, Markierung.Bottom, BenutzerZielVerzeichnis);
end;

procedure THauptprogramm.ProtokollKopierenMenuItemClick(Sender: TObject);
begin
  ProtokollMemo.CopyToClipboard;
end;

procedure THauptprogramm.ProtokollLoeschenMenuItemClick(Sender: TObject);
begin
  ProtokollMemo.Clear;
  ProtokollUnit.Protokoll_Leerzeile_einfuegen;
  ProtokollUnit.Protokoll_schreiben(Ueberfenster.VersionNr);
end;

// Projektfenster

procedure THauptprogramm.ProjektGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  Hauptprogramm.ProjektGrid.MouseToCell(X,Y,MeineSpalte,MeineZeile);
  IF MeineZeile > 0 THEN
  BEGIN
    IF ProjektGrid.Cells[pNameSpalte, MeineZeile] <> '' THEN
    BEGIN
      IF MeineSpalte = zielSpalte THEN
        ProjektGrid.Hint := ProjektGrid.Cells[MeineSpalte, MeineZeile]
      ELSE
        IF MeineSpalte = pnameSpalte THEN
        BEGIN
          IF Assigned(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]) THEN
            ProjektGrid.Hint := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).Dateiname;
        END
        ELSE
          IF MeineSpalte = pOptionenSpalte THEN
          BEGIN
            ProjektGrid.Hint := Meldunglesen(NIL, 'Meldung340', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).IndexDateierstellen, WortJa, WortNein), 'Indexdateien erstellen: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung341', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).D2VDateierstellen, WortJa, WortNein), 'D2V-Datei erstellen: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung342', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).IDXDateierstellen, WortJa, WortNein), 'IDX-Datei erstellen: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung343', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).KapitelDateierstellen, WortJa, WortNein), 'Kapiteldatei erstellen: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung344', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).Timecodekorrigieren, WortJa, WortNein), 'Timecode korrigieren: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung345', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).Bitratekorrigieren, WortJa, WortNein), 'Bitrate korrigieren: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung346', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).nurAudioschneiden, WortJa, WortNein), 'nur Audio schneiden: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung347', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).Schnittpunkteeinzelnschneiden, WortJa, WortNein), 'Schnitte einzeln schneiden: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung348', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).Framegenauschneiden, WortJa, WortNein), 'framegenau schneiden: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung349', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).Ausgabebenutzen, WortJa, WortNein), 'Nachbearbeitung: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung350', Bitrateim1Header.Items[TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).BitrateersterHeader], 'Bitrate im 1. Sequenzheader: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung351', AspectRatio1Header.Items[TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).AspectratioersterHeader], 'Aspectratio im 1. Sequenzheader: $Text1#') + Chr(13) +
                                Meldunglesen(NIL, 'Meldung352', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).Ausgabebenutzen, WortJa, WortNein), 'maximale GOP-Größe verwenden: $Text1#');
          END
          ELSE
            IF MeineSpalte = statusSpalte THEN
              ProjektGrid.Hint := ProjektGrid.Cells[fehlerSpalte, MeineZeile]
            ELSE
              ProjektGrid.Hint := '';
    END;
  END
  ELSE
    IF MeineSpalte = aAnzahlSpalte THEN
      ProjektGrid.Hint := Wortlesen(NIL, 'Audioanzahl_Hint', 'Anzahl der Audiospuren')
    ELSE
      IF MeineSpalte = sAnzahlSpalte THEN
        ProjektGrid.Hint := Wortlesen(NIL, 'Schnittanzahl_Hint', 'Anzahl der Schnitte')
      ELSE
        IF MeineSpalte = pGroesseSpalte THEN
          ProjektGrid.Hint := Wortlesen(NIL, 'Projektgroesse_Hint', 'Grösse des gesamten Projektes')
        ELSE
  {        IF MeineSpalte = iddSpalte THEN
            ProjektGrid.Hint := Wortlesen(NIL, 'Indexdateien_erstellen_Hint', 'Indexdateien erstellen')
          ELSE
            IF MeineSpalte = d2vSpalte THEN
              ProjektGrid.Hint := Wortlesen(NIL, 'D2V-Datei_erstellen_Hint', 'D2V-Datei erstellen')
            ELSE
              IF MeineSpalte = KapSpalte THEN
                ProjektGrid.Hint := Wortlesen(NIL, 'Kapiteldatei_erstellen_Hint', 'Kapiteldatei erstellen')
              ELSE
                IF MeineSpalte = AusgSpalte THEN
                  ProjektGrid.Hint := Wortlesen(NIL, 'Ausgabe_benutzen_Hint', 'Ausgabe benutzen (muxen)')
                ELSE
                  IF MeineSpalte = nurAudioSpalte THEN
                    ProjektGrid.Hint := Wortlesen(NIL, 'Nur_Audio_schneiden_Hint', 'Nur Audio schneiden')
                  ELSE
                    IF MeineSpalte = tcSpalte THEN
                      ProjektGrid.Hint := Wortlesen(NIL, 'Timecode_korrigieren_Hint', 'Timecode der Videodatei korrigieren')
                    ELSE
                      IF MeineSpalte = brSpalte THEN
                        ProjektGrid.Hint := Wortlesen(NIL, 'Bitrate_korrigieren_Hint', 'Bitrate im ersten Header der Videodatei korrigieren')
                      ELSE
                        IF MeineSpalte = festeBrSpalte THEN
                          ProjektGrid.Hint := Wortlesen(NIL, 'Feste_Bitrate_Hint', 'Feste Bitrate in den ersten Header der Videodatei eintragen (0 bedeutet keine Bitragte eintragen)')
                        ELSE    }
                          ProjektGrid.Hint := '';
end;

procedure THauptprogramm.ProjektGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  { Farben }
  IF ACol=statusSpalte THEN
  BEGIN
    IF ProjektGrid.Cells[ACol,ARow] = WortNicht_bereit THEN
      ProjektGrid.Canvas.Font.Color := $000000FF
    ELSE
    IF ProjektGrid.Cells[ACol,ARow] = WortFehler THEN
      ProjektGrid.Canvas.Font.Color := $000000FF
    ELSE
    IF ProjektGrid.Cells[ACol,ARow] = WortFertig THEN
      ProjektGrid.Canvas.Font.Color := $00008000;
  END;
  { Text ausrichten }
  ProjektGrid.Canvas.FillRect(Rect);
  IF (ARow > 0) AND ((Acol = zielSpalte) OR (Acol = pnameSpalte)) THEN
    DrawText(ProjektGrid.Canvas.Handle, PChar(ProjektGrid.Cells[ACol,ARow]), StrLen(PChar(ProjektGrid.Cells[ACol,ARow])), Rect,DT_BOTTOM OR DT_SINGLELINE OR DT_RIGHT)
  ELSE
    DrawText(ProjektGrid.Canvas.Handle, PChar(ProjektGrid.Cells[ACol,ARow]), StrLen(PChar(ProjektGrid.Cells[ACol,ARow])), Rect,DT_BOTTOM OR DT_SINGLELINE OR DT_CENTER);
end;

procedure THauptprogramm.ProjektGridClick(Sender: TObject);
begin
  Markierungsetzen;
end;

procedure THauptprogramm.ProjektGridDblClick(Sender: TObject);
begin
  IF (MeineSpalte >= 0) AND
     (MeineZeile > 0) THEN
    IF (MeineSpalte = statusSpalte) THEN
      aendereStatus(MeineZeile)
    ELSE
      Projekteigenschaftenanzeigen(MeineZeile)
  ELSE
    ProjekteinfuegenMenuItemClick(Sender);    
end;

procedure THauptprogramm.EigenschaftenBtnClick(Sender: TObject);

VAR Abbrechen : Boolean;

FUNCTION DateiueberschreibenAbfrage: Integer;
BEGIN
  IF Dateien_vorhanden(ZieldateinameEdit.Text,
                       ArbeitsumgebungObj.DateiendungenVideo,
                       ArbeitsumgebungObj.DateiendungenAudio,
                       nurAudioBox.Checked) THEN
    Result := Nachrichtenfenster(Wortlesen(NIL, 'Meldung6', 'Die Datei(en) sind schon vorhanden. Überschreiben?'),
                                 Wortlesen(NIL, 'Warnung', 'Warnung'), MB_YESNOCANCEL, MB_ICONWARNING)
  ELSE
    Result := IDYES;
END;

begin
  IF einProjekt THEN
  BEGIN
    IF Sender = OKTaste THEN
    BEGIN
      IF DateiueberschreibenAbfrage = IDYES THEN
      BEGIN
        Projekteigenschaftenuebernehmen(1);
        ProjekteSchneiden(1, 1);
      END;
    END  
    ELSE
      IF Laeuft THEN
        Anhalten := True
      ELSE
      BEGIN
        Close;
      END;
  END
  ELSE
  BEGIN
    IF Sender = OKTaste THEN
      CASE DateiueberschreibenAbfrage OF
        IDNO : Abbrechen := False;
        IDCANCEL : Abbrechen := True;
      ELSE
        Projekteigenschaftenuebernehmen(MeineZeile);
        Abbrechen := True;
      END
    ELSE
      Abbrechen := True;
    IF Abbrechen THEN
    BEGIN
      ProtokollMemo.Height := ArbeitsumgebungObj.SchnittToolProtokollSplitterPos;
      ProjekteinfuegenBtn.Enabled := True;
      ProjektentfernenBtn.Enabled := True;
      IF NOT Laeuft THEN
      BEGIN
        ProjektSchneidenBtn.Enabled := True;
        ProjekteSchneidenBtn.Enabled := True;
      END;
      EigenschaftenPanel.Visible := False;
      ProjektGrid.Visible := True;
    END;
  END;
end;

procedure THauptprogramm.EditKeyPress(Sender: TObject; var Key: Char);
begin
  IF Key = Chr(13) THEN
  BEGIN
    EditBtnClick(Sender);
    Key := Chr(0);
  END;  
end;

procedure THauptprogramm.EditBtnClick(Sender: TObject);

VAR Dateioeffnen : TOpenDialog;
    ZielDateisuchen : TSaveDialog;
//    Abbrechen : Boolean;

begin
  IF (Sender = ZieldateinameEdit) OR (Sender = ZieldateinameBtn) THEN
  BEGIN
    ZielDateisuchen := TSaveDialog.Create(self);
    TRY
      ZielDateisuchen.Options := [ofHideReadOnly, ofPathMustExist, ofEnableSizing];
      IF nurAudioBox.Checked THEN
      BEGIN
        ZielDateisuchen.Title := Wortlesen(NIL, 'Dialog16', 'Name der Audiodatei');
        ZielDateisuchen.Filter := Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio;
      END
      ELSE
      BEGIN
        ZielDateisuchen.Title := Wortlesen(NIL, 'Dialog13', 'Name der MPEG-2 Videodatei');
//        ZielDateisuchen.Filter := Wortlesen(NIL, 'Dialog12', 'MPEG-2 Videodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo;
        ZielDateisuchen.Filter := Wortlesen(NIL, 'Dialog18', 'Video/Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo + ';' + ArbeitsumgebungObj.DateiendungenAudio;
      END;
      ZielDateisuchen.DefaultExt := '';
      ZielDateisuchen.InitialDir := ExtractFilePath(ZieldateinameEdit.Text);
      ZielDateisuchen.FileName := ExtractFileName(ZieldateinameEdit.Text);

      IF ZielDateisuchen.InitialDir = '' THEN
        ZielDateisuchen.InitialDir := Verzeichnisnamenbilden(ArbeitsumgebungObj.ZielVerzeichnis,
                                                             TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, meineZeile]).Videoname,
                                                             TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, meineZeile]).Dateiname,
                                                             TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, meineZeile]).Projektname);
      ZielDateisuchen.InitialDir := Verzeichnissuchen(ZielDateisuchen.InitialDir);
      IF ZielDateisuchen.FileName = '' THEN
        ZielDateisuchen.FileName := Dateinamenbilden(ArbeitsumgebungObj.ZielDateiname,
                                                     TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, meineZeile]).Videoname,
                                                     TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, meineZeile]).Dateiname,
                                                     TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, meineZeile]).Projektname,
                                                     SchnittpunkteeinzelnBox.Checked);
      WHILE Dateien_vorhanden(mitPathtrennzeichen(ZielDateisuchen.InitialDir) + ZielDateisuchen.FileName,
                              ArbeitsumgebungObj.DateiendungenVideo, ArbeitsumgebungObj.DateiendungenAudio, nurAudioBox.Checked) DO
        ZielDateisuchen.FileName := DateinamePlusEins(ZielDateisuchen.FileName, ArbeitsumgebungObj.SchnittpunkteeinzelnFormat{'$FileName#$Number;Format=N#'});
{      Abbrechen := True;
      REPEAT
        IF ZielDateisuchen.Execute THEN
        BEGIN
          IF Dateien_vorhanden(ZielDateisuchen.FileName,
                               ArbeitsumgebungObj.DateiendungenVideo,
                               ArbeitsumgebungObj.DateiendungenAudio,
                               nurAudioBox.Checked) THEN
          BEGIN
            CASE Nachrichtenfenster(Wortlesen(NIL, 'Meldung6', 'Die Datei(en) sind schon vorhanden. Überschreiben?'),
                                    Wortlesen(NIL, 'Warnung', 'Warnung'), MB_YESNOCANCEL, MB_ICONWARNING) OF
              IDYES   : BEGIN ZieldateinameEdit.Text := ZielDateisuchen.FileName; Abbrechen := True; END;
              IDNO : Abbrechen := False;
              IDCANCEL : Abbrechen := True;
            END;
          END
          ELSE
          BEGIN
            Abbrechen := True;
            ZieldateinameEdit.Text := ZielDateisuchen.FileName;
          END;
        END
        ELSE
          Abbrechen := True;
      UNTIL Abbrechen;   }
      IF ZielDateisuchen.Execute THEN
        ZieldateinameEdit.Text := ZielDateisuchen.FileName;
    FINALLY
      ZielDateisuchen.Free;
    END;
  END
  ELSE
  BEGIN
    Dateioeffnen := TOpenDialog.Create(Self);
    TRY
      Dateioeffnen.Options := [ofHideReadOnly,ofPathMustExist,ofFileMustExist,ofEnableSizing];
      Dateioeffnen.Title := Wortlesen(NIL, 'Dialog101', 'Datei suchen');
      Dateioeffnen.Filter := Wortlesen(NIL, 'Dialog115', 'Ausgabedateien') + '|*.prg';
      Dateioeffnen.DefaultExt := 'prg';
      IF (Sender = EncoderdateiEdit) OR (Sender = EncoderdateiBtn) THEN
      BEGIN
        Dateioeffnen.FileName := absolutPathAppl(EncoderdateiEdit.Text, Application.ExeName, False);
        IF Dateioeffnen.FileName = '' THEN
          Dateioeffnen.FileName := ArbeitsumgebungObj.Encoderdatei;
        IF Dateioeffnen.Execute THEN
          EncoderdateiEdit.Text := relativPathAppl(Dateioeffnen.FileName, Application.ExeName);
      END
      ELSE
        IF (Sender = AusgabedateiEdit) OR (Sender = AusgabedateiBtn) THEN
        BEGIN
          Dateioeffnen.FileName := absolutPathAppl(AusgabedateiEdit.Text, Application.ExeName, False);
          IF Dateioeffnen.FileName = '' THEN
            Dateioeffnen.FileName := ArbeitsumgebungObj.Ausgabedatei;
          IF Dateioeffnen.Execute THEN
            AusgabedateiEdit.Text := relativPathAppl(Dateioeffnen.FileName, Application.ExeName);
        END;
    FINALLY
      Dateioeffnen.Free;
    END;
  END;
end;

procedure THauptprogramm.Bitrateim1HeaderCloseUp(Sender: TObject);
begin
  IF Bitrateim1Header.ItemIndex = 4 THEN
  BEGIN
    Bitrateim1Header.Style := csDropDown;
    Bitrateim1Header.Text := Bitrateim1Header.Items[4] + ': ' + IntToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).festeBitrate);
    Bitrateim1Header.SetFocus;
  END
  ELSE
    Bitrateim1Header.Style := csDropDownList;
end;

procedure THauptprogramm.Bitrateim1HeaderSelect(Sender: TObject);
begin
  IF Bitrateim1Header.ItemIndex < 4 THEN
    Bitrateim1Header.Style := csDropDownList;
end;

procedure THauptprogramm.AspectRatio1HeaderCloseUp(Sender: TObject);
begin
  IF AspectRatio1Header.ItemIndex = 6 THEN
  BEGIN
    AspectRatio1Header.Style := csDropDown;
    AspectRatio1Header.Text := AspectRatio1Header.Items[6] + ': ' + IntToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, MeineZeile]).AspectratioOffset);
    AspectRatio1Header.SetFocus;
  END
  ELSE
    AspectRatio1Header.Style := csDropDownList;
end;

procedure THauptprogramm.AspectRatio1HeaderSelect(Sender: TObject);
begin
  IF AspectRatio1Header.ItemIndex < 6 THEN
    AspectRatio1Header.Style := csDropDownList;
end;

procedure THauptprogramm.maxGOPLaengeBoxClick(Sender: TObject);
begin
//  maxGOPLaengeEdit.Enabled := maxGOPLaengeBox.Checked;
end;

procedure THauptprogramm.aendereZahlEditExit(Sender: TObject);

{VAR Erg : Integer;
    Spalte : Integer;    }

begin
{  aendereZahlEdit.Visible := False;
  Erg := StrToIntDef(aendereZahlEdit.Text, -1);
  IF Erg > -1 THEN
  BEGIN
    Spalte := ProjektGrid.MouseCoord(aendereZahlEdit.Left, aendereZahlEdit.Top).Y;
    ProjektGrid.Cells[festeBrSpalte, Spalte] := aendereZahlEdit.Text;
  END;
  aendereZahlEdit.Text := '';  }
end;

procedure THauptprogramm.aendereZahlEditKeyPress(Sender: TObject; var Key: Char);
begin
  IF Key = Chr(13) THEN
  BEGIN
    ProjektGrid.SetFocus;
    Key := Chr(0);
  END;
end;

procedure THauptprogramm.ProtokollSplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin
  IF EigenschaftenPanel.Visible THEN
    Accept := False;
end;

procedure THauptprogramm.FormResize(Sender: TObject);
begin
  IF EigenschaftenPanel.Visible THEN
  BEGIN
    ProtokollMemo.Height := ClientHeight - ToolBar.Height - 216 -
                            ProtokollSplitter.Height - Tastenpanel.Height;
  END; 
end;

// Programmfunktionen
// Initialisieren/Beenden

PROCEDURE THauptprogramm.Initialisieren;

VAR Erg : Integer;
    Projektliste : TStringList;
    ProjektInfo : TProjektInfo;
    IniFile : TIniFile;
    StandardINI : STRING;

BEGIN
  ScriptUnit.AnzeigeListe := TStringList(ProtokollMemo.Lines);
  Hauptprogramm.Caption := UeberFenster.VersionNr;
// Inidatei laden
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\Mpeg2Schnitt.ini');
  TRY
    UeberFenster.Lizensiert := IniFile.ReadBool('Allgemein', 'Lizenzakzeptiert', False);
    StandardINI := absolutPathAppl(IniFile.ReadString('Arbeitsumgebungen', 'Arbeitsumgebung-' +
                   IntToStr(IniFile.ReadInteger('Arbeitsumgebungen', 'aktive_Arbeitsumgebung', 0)),
                   'Standard.mau'), Application.ExeName, False);
  FINALLY
    IniFile.Free;
  END;
// Arbeitsumgebung
  ArbeitsumgebungObj.ApplikationsName := Application.ExeName;
  ArbeitsumgebungObj.Arbeitsumgebungladen(StandardINI);
  IF ArbeitsumgebungObj.Zielverzeichnis <> '' THEN
  BEGIN
    BenutzerZielVerzeichnis := ArbeitsumgebungObj.Zielverzeichnis;
    BenutzerZiel.Caption := ArbeitsumgebungObj.Zielverzeichnis;
    BenutzerZiel.Enabled := True;
  END;
// Tastenbilder
  LadeIconTemplate(ArbeitsumgebungObj.Bilderverwenden, ArbeitsumgebungObj.Bilderdatei);
// Protokoll
  ProtokollDateiname(ExtractFilePath(Application.ExeName) + 'Protokoll-' + UeberFenster.VersionName + '.txt');
  ProtokollUnit.Protokoll_Leerzeile_einfuegen;
  ProtokollUnit.Protokoll_schreiben(Ueberfenster.VersionNr);
// Kommandozeile
  Projektliste := TStringList.Create;
  ProjektInfo := TProjektInfo.Create;
  //  ProjektInfofuellen;
  TRY
    Erg := Parameterlesen(Projektliste, ProjektInfo, ProgrammPosition);
    IF (Erg AND 1) = 0 THEN
      Zellenfuellen(Projektliste, ProjektInfo.Projektname)
    ELSE
      ;                                        // Kommandozeilenschnitt
    IF (Erg AND 4) = 4 THEN
    BEGIN
      ProgrammschliessenMenuItem.Checked := True;
      ProgrammschliessenBtn.Down := True;
    END;
    IF (Erg AND 8) = 8 THEN
    BEGIN
      RechnerausschaltenMenuItem.Checked := True;
      RechnerausschaltenBtn.Down := True;
    END;
  FINALLY
    Projektliste.Free;
    ProjektInfo.Free;    // vorerst !!!
  END;
  IF (Erg AND 2) = 2 THEN
    Starten := True;
  IF (Erg AND 32) = 32 THEN
    einProjekt := True;
  IF (Erg AND 16) = 16 THEN
  BEGIN
    keineOberflaeche := True;
    ProjekteSchneiden;
  END
  ELSE
    Arbeitsumgebung_lesen;
END;

PROCEDURE THauptprogramm.Arbeitsumgebung_lesen;
BEGIN
  IF (ProgrammPosition.Left = -1) OR (ProgrammPosition.Top = -1) OR
     (ProgrammPosition.Right = -1) OR (ProgrammPosition.Bottom = -1) THEN
    IF (ArbeitsumgebungObj.SchnittToolFensterBreite = -1) AND
       (ArbeitsumgebungObj.SchnittToolFensterHoehe = -1) THEN
       SetBounds(Trunc((Screen.WorkAreaWidth - 700) / 2), Trunc((Screen.WorkAreaHeight - 570) / 2),
                 700, 570)
    ELSE
      SetBounds(ArbeitsumgebungObj.SchnittToolFensterLinks, ArbeitsumgebungObj.SchnittToolFensterOben,
                ArbeitsumgebungObj.SchnittToolFensterBreite, ArbeitsumgebungObj.SchnittToolFensterHoehe)
  ELSE
    SetBounds(ProgrammPosition.Left, ProgrammPosition.Top,
              ProgrammPosition.Right, ProgrammPosition.Bottom);
  IF ArbeitsumgebungObj.SchnittToolFensterMaximized THEN
    WindowState := wsMaximized
  ELSE
    WindowState := wsNormal;
  ProtokollMemo.Height := ArbeitsumgebungObj.SchnittToolProtokollSplitterPos;
END;

PROCEDURE THauptprogramm.Fensterpositionmerken;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    IF WindowState = wsNormal	 THEN
    BEGIN
      ArbeitsumgebungObj.SchnittToolFensterLinks := Left;
      ArbeitsumgebungObj.SchnittToolFensterOben := Top;
      ArbeitsumgebungObj.SchnittToolFensterBreite := Width;
      ArbeitsumgebungObj.SchnittToolFensterHoehe := Height;
    END;
    ArbeitsumgebungObj.SchnittToolFensterMaximized := WindowState = wsMaximized;
    IF ProjektGrid.Visible THEN
      ArbeitsumgebungObj.SchnittToolProtokollSplitterPos := ProtokollMemo.Height;
  END;
END;

PROCEDURE THauptprogramm.Nachrichten(var Msg: TMsg; var Handled: Boolean);

VAR I, Anzahl, Groesse: Integer;
    Dateiname: PChar;
    DateinamenListe: TStringList;

BEGIN
  IF Msg.message = WM_DROPFILES THEN
  BEGIN
    Handled := True;
    DateinamenListe := TStringList.Create;
    TRY
      Anzahl := DragQueryFile(Msg.WParam, $FFFFFFFF, NIL, 255);
      FOR I := 0 TO (Anzahl - 1) DO
      BEGIN
        Groesse := DragQueryFile(Msg.WParam, I , NIL, 0) + 1;
        Dateiname:= StrAlloc(Groesse);
        DragQueryFile(Msg.WParam,I , Dateiname, Groesse);
        DateinamenListe.Add(Dateiname);
        StrDispose(Dateiname);
      END;
      Zellenfuellen(DateinamenListe);
    FINALLY
      DateinamenListe.Free;
    END;
    DragFinish(Msg.WParam);
  END;
END;

// Projektfenster

PROCEDURE THauptprogramm.aendereStatus(Zeile: Integer);
BEGIN
  IF Projektgrid.Cells[statusSpalte, Zeile] = WortWarte THEN
  BEGIN
    Projektgrid.Cells[statusSpalte, Zeile] := WortUeberspringen;
    GesamtGroesseBerechnen(- Projektgroesse(Zeile));
  END
  ELSE
    IF (Projektgrid.Cells[statusSpalte, Zeile] = WortUeberspringen) OR
       (Projektgrid.Cells[statusSpalte, Zeile] = WortFertig) OR
       (Projektgrid.Cells[statusSpalte, Zeile] = WortFehler) THEN
    BEGIN
      Projektgrid.Cells[statusSpalte, Zeile] := WortWarte;
      Projektgrid.Cells[fehlerSpalte, Zeile] := '';
      GesamtGroesseBerechnen(Projektgroesse(Zeile));
    END;
END;

FUNCTION THauptprogramm.DateiinListe(Dateiname: STRING): Boolean;

VAR I : Integer;

BEGIN
  Result := False;
  FOR I := 1 TO ProjektGrid.RowCount -1 DO
    IF Assigned(ProjektGrid.Objects[pOptionenSpalte, I]) THEN
      IF UpperCase(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname) = UpperCase(Dateiname) THEN
        Result := True;
END;

{FUNCTION THauptprogramm.Videodateiname_von(Projektdatei: STRING): STRING;

VAR IniDatei : TIniFile;
    J : Integer;

BEGIN
  IniDatei := TIniFile.Create(Projektdatei);
  TRY
    Result := IniDatei.ReadString('Dateiknoten-' +
              IniDatei.ReadString('Schnittpunkt-0', 'Videoknoten', '1'), 'Videodatei', '');
    J := 0;
    WHILE (Result = '') AND (J > -1) DO
    BEGIN
      Inc(J);
      IF IniDatei.ValueExists('Dateiknoten-' +
                              IniDatei.ReadString('Schnittpunkt-0', 'Audioknoten', '1'),
                              'Audiodatei-' + IntToStr(J)) THEN
        Result := IniDatei.ReadString('Dateiknoten-' +
                              IniDatei.ReadString('Schnittpunkt-0', 'Audioknoten', '1'),
                              'Audiodatei-' + IntToStr(J), '')
      ELSE
        J := -1;
    END;
  FINALLY
    IniDatei.Free;
  END;
END;}

FUNCTION THauptprogramm.Projektgroesse(Zeile: Integer): Int64;
BEGIN
  IF Assigned(ProjektGrid.Objects[pOptionenSpalte, Zeile]) THEN
    IF TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).nurAudioschneiden THEN
      Result := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).AudioGroesse
    ELSE
      Result := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).VideoGroesse +
                TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).AudioGroesse
  ELSE
    Result := 0;
END;

PROCEDURE THauptprogramm.ZielverzeichnisAendern(Anfang, Ende: Integer; Eintrag : String);

VAR I : Integer;
    HString : STRING;

BEGIN
  FOR I := Anfang TO Ende DO
  BEGIN
    IF Assigned(ProjektGrid.Objects[pOptionenSpalte, I]) AND
       (TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname <> '') THEN
    BEGIN
{      HString := VariablenersetzenText(Eintrag,
                                      ['$Videodirectory#', ExtractFilePath(Videodateiname_von(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname)),
                                       '$Projectdirectory#', ExtractFilePath(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname)]);
      HString := VariablenentfernenText(HString);
      IF HString = '' THEN
        HString := ExtractFilePath(Videodateiname_von(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname));}
      HString := Eintrag;
      TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Zieldateiname := mitPathtrennzeichen(HString) + ExtractFileName(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname);
      ProjektGrid.Cells[zielSpalte, I] := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Zieldateiname;
//      ProjektGrid.Cells[statusSpalte, I] := WortWarte;
//      ProjektGrid.Cells[fehlerSpalte, I] := '';
//      GesamtGroesseBerechnen(Projektgroesse(I));
    END;
  END;
END;

PROCEDURE THauptprogramm.Projekteigenschaftenanzeigen(Zeile: Integer);
BEGIN
  IF (Projektgrid.Cells[statusSpalte, Zeile] <> WortVerarbeite) AND
     Assigned(ProjektGrid.Objects[pOptionenSpalte, Zeile]) AND
     (TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Dateiname <> '') THEN
  BEGIN
    ArbeitsumgebungObj.SchnittToolProtokollSplitterPos := ProtokollMemo.Height;
    IF ProjektGrid.Height <> 216 THEN
    BEGIN
      EigenschaftenPanel.Height := 216;
      ProtokollMemo.Height := ClientHeight - ToolBar.Height - EigenschaftenPanel.Height -
                              ProtokollSplitter.Height - Tastenpanel.Height;
    END;
    ProjekteinfuegenBtn.Enabled := False;
    ProjektentfernenBtn.Enabled := False;
    ProjektSchneidenBtn.Enabled := False;
    ProjekteSchneidenBtn.Enabled := False;
    IF TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Projektname = 'kein Projekt' THEN
      ProjektdateiLabel.Caption := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Dateiname
    ELSE
      ProjektdateiLabel.Caption := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Projektname;
    ZieldateinameEdit.Text := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Zieldateiname;
    IDDerstellenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).IndexDateierstellen;
    D2VerstellenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).D2VDateierstellen;
    IDXerstellenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).IDXDateierstellen;
    KapitelerstellenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).KapitelDateierstellen;
    nurAudioBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).nurAudioschneiden;
    AusgabenutzenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Ausgabebenutzen;
    SchnittpunkteeinzelnBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Schnittpunkteeinzelnschneiden;
    framegenauSchneidenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Framegenauschneiden;
    TimecodekorrigierenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Timecodekorrigieren;
    BitratekorrigierenBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Bitratekorrigieren;
    Bitrateim1Header.ItemIndex := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).BitrateersterHeader;
    IF Bitrateim1Header.ItemIndex = 4 THEN
    BEGIN
      Bitrateim1Header.Style := csDropDown;
      Bitrateim1Header.Text := Bitrateim1Header.Items[4] + ': ' + IntToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).festeBitrate);
    END;
    AspectRatio1Header.ItemIndex := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).AspectratioersterHeader;
    IF AspectRatio1Header.ItemIndex = 6 THEN
    BEGIN
      AspectRatio1Header.Style := csDropDown;
      AspectRatio1Header.Text := AspectRatio1Header.Items[6] + ': ' + IntToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).AspectratioOffset);
    END;
    EncoderdateiEdit.Text := relativPathAppl(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Encoderdatei, Application.ExeName);
    AusgabedateiEdit.Text := relativPathAppl(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Ausgabedatei, Application.ExeName);
//    maxGOPLaengeEdit.Text := IntToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).maxGOPLaenge);
    maxGOPLaengeBox.Checked := TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).maxGOPLaengeverwenden;
    ProjektGrid.Visible := False;
    EigenschaftenPanel.Visible := True;
    OKTaste.SetFocus;
  END
  ELSE
  BEGIN
    ProjektdateiLabel.Caption := '';
    ZieldateinameEdit.Text := '';
    EncoderdateiEdit.Text := '';
    AusgabedateiEdit.Text := '';
  END;
END;

PROCEDURE THauptprogramm.Projekteigenschaftenuebernehmen(Zeile: Integer);
BEGIN
  IF (Projektgrid.Cells[statusSpalte, Zeile] <> WortVerarbeite) AND
     Assigned(ProjektGrid.Objects[pOptionenSpalte, Zeile]) THEN
  BEGIN
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Zieldateiname := ZieldateinameEdit.Text;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).IndexDateierstellen := IDDerstellenBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).D2VDateierstellen := D2VerstellenBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).IDXDateierstellen := IDXerstellenBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).KapitelDateierstellen := KapitelerstellenBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).nurAudioschneiden := nurAudioBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Ausgabebenutzen := AusgabenutzenBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Schnittpunkteeinzelnschneiden := SchnittpunkteeinzelnBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Framegenauschneiden := framegenauSchneidenBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Timecodekorrigieren := TimecodekorrigierenBox.Checked;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Bitratekorrigieren := BitratekorrigierenBox.Checked;
    IF (Bitrateim1Header.ItemIndex > -1) AND
       (Bitrateim1Header.ItemIndex < 4) THEN
      TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).BitrateersterHeader := Bitrateim1Header.ItemIndex
    ELSE
    BEGIN
      TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).festeBitrate := StrToIntDef(KopiereVonBis(Bitrateim1Header.Text,': ',''), 0);
      TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).BitrateersterHeader := 4;
    END;
    IF (AspectRatio1Header.ItemIndex > -1) AND
       (AspectRatio1Header.ItemIndex < 6) THEN
      TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).AspectratioersterHeader := AspectRatio1Header.ItemIndex
    ELSE
    BEGIN
      TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).AspectratioOffset := StrToIntDef(KopiereVonBis(AspectRatio1Header.Text,': ',''), 0);
      TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).AspectratioersterHeader := 6;
    END;
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Encoderdatei := absolutPathAppl(EncoderdateiEdit.Text, Application.ExeName, False);
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).Ausgabedatei := absolutPathAppl(AusgabedateiEdit.Text, Application.ExeName, False);
//    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).maxGOPLaenge := StrToIntDef(maxGOPLaengeEdit.Text, 0);
    TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]).maxGOPLaengeverwenden := maxGOPLaengeBox.Checked;
    ProjektGrid.Cells[pOptionenSpalte, Zeile] := ProjektOptionenzuStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Zeile]));
    ProjektGrid.Cells[ZielSpalte, Zeile] := ZieldateinameEdit.Text;
    ProjektGrid.Cells[pGroesseSpalte, Zeile]  := GroessezuStr(Projektgroesse(Zeile));
    GesamtGroesseneuBerechnen;
  END;
END;

FUNCTION THauptprogramm.ProjektOptionenzuStr(ProjektInfoObj: TProjektInfo): STRING;

FUNCTION Trennzeicheneinfuegen(Text: STRING): STRING;
BEGIN
  IF Text > '' THEN
    Result := Text + ', '
  ELSE
    Result := '';
END;

BEGIN
  Result := '';
  IF ProjektInfoObj.IndexDateierstellen THEN
    Result := Wortlesen(Spracheladen, 'Indexdateien_erstellen', 'IDD');
  IF ProjektInfoObj.D2VDateierstellen THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'D2V-Datei_erstellen', 'D2V');
  IF ProjektInfoObj.IDXDateierstellen THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'IDX-Datei_erstellen', 'IDX');
  IF ProjektInfoObj.KapitelDateierstellen THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'Kapiteldatei_erstellen', 'Kap');
  IF ProjektInfoObj.Timecodekorrigieren THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'Timecode_aendern', 'Tc');
  IF ProjektInfoObj.Bitratekorrigieren THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'Bitrate_aendern', 'Br');
  IF ProjektInfoObj.nurAudioschneiden THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'Nur_Audio_schneiden', 'nA');
  IF ProjektInfoObj.Schnittpunkteeinzelnschneiden THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'Schnittpunkteeinzeln', 'Se');
  IF ProjektInfoObj.Framegenauschneiden THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'Framegenauschneiden', 'fg');
  IF ProjektInfoObj.Ausgabebenutzen THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'Ausgabe_benutzen', 'Nb');
  IF ProjektInfoObj.BitrateersterHeader > 0 THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'ersterHeader', 'eH');
  IF ProjektInfoObj.maxGOPLaengeverwenden THEN
    Result := Trennzeicheneinfuegen(Result) + Wortlesen(Spracheladen, 'maxGOPLaenge', 'mG');
END;

PROCEDURE THauptprogramm.Markierungsetzen(Zeile: Integer = -1);

VAR Selektion : TGridRect;

BEGIN
  IF Zeile = -1 THEN
    Selektion := ProjektGrid.Selection
  ELSE
  BEGIN
    Selektion.Top := Zeile;
    Selektion.Bottom := Zeile;
  END;
  Selektion.Left := 0;
  Selektion.Right := ProjektGrid.ColCount - 1;
  ProjektGrid.Selection := Selektion;
END;

FUNCTION THauptprogramm.ProjektAuswerten(Dateiname, Projektname : STRING; Zeile : Integer): Integer;

VAR {VideoGroesse,
    AudioGroesse : Int64;
    AudioSpuren,
    SchnittAnzahl,
    feste_Bitrate,
    AusgabeIndex : Integer;
    IniDatei,
    Zielverzeichnis,
    Zieldateiname,
    Videoname,
    AudioTrennzeichen,
    Ausgabedatei,
    Effektdatei : STRING;
    Timecodekorrigieren,
    Bitratekorrigieren,
    IndexDateierstellen,
    D2VDateierstellen,
    KapitelDateierstellen,
    nurAudioschneiden,
    Ausgabebenutzen : Boolean; }
    ProjektInfoObj : TProjektInfo;

BEGIN
  Result := 0;
  ProjektInfoObj := TProjektInfo.Create;
  TRY
    ProjektInfoObj.Dateiname := Dateiname;
    ProjektInfoObj.Projektname := Projektname;
    Result := ProjektInformationen({Dateiname,
                                   AudioSpuren, SchnittAnzahl,
                                   VideoGroesse, AudioGroesse,
                                   IniDatei, Zielverzeichnis, Zieldateiname,
                                   Videoname, AudioTrennzeichen,
                                   Ausgabedatei, Effektdatei,
                                   BilderProSek, feste_Bitrate, AusgabeIndex,
                                   Timecodekorrigieren, Bitratekorrigieren,
                                   IndexDateierstellen, D2VDateierstellen,
                                   KapitelDateierstellen, nurAudioschneiden,
                                   Ausgabebenutzen,} ProjektInfoObj);
    IF Result = 0 THEN
    BEGIN
{      Zielverzeichnis := VariablenersetzenText(absolutPathAppl(Zielverzeichnis, Application.ExeName, False),
                                              ['$Videodirectory#', ExtractFileDir(Videoname),
                                               '$Projectdirectory#', ExtractFileDir(DateiName)]);
      Zieldateiname   := VariablenersetzenText(Zieldateiname,
                                              ['$Videoname#', ExtractFileName(ChangeFileExt(Videoname, '')),
                                               '$Projectname#', ExtractFileName(ChangeFileExt(DateiName, ''))]);
      Zielverzeichnis := VariablenentfernenText(Zielverzeichnis);
      Zieldateiname   := VariablenentfernenText(Zieldateiname);
      IF Zielverzeichnis = '' THEN
        Zielverzeichnis := ExtractFilePath(Videoname);
      IF Zieldateiname = '' THEN
        Zieldateiname := ExtractFileName(ChangeFileExt(DateiName, ''));
      ProjektGrid.Cells[zielSpalte, Zeile]    := mitPathtrennzeichen(Zielverzeichnis) + Zieldateiname;
      WHILE Dateien_vorhanden(ProjektGrid.Cells[zielSpalte, Zeile], ArbeitsumgebungObj.DateiendungenVideo,
                           ArbeitsumgebungObj.DateiendungenAudio, nurAudioschneiden) DO
        ProjektGrid.Cells[zielSpalte, Zeile] := DateinamePlusEins(ProjektGrid.Cells[zielSpalte, Zeile],
                                                ArbeitsumgebungObj.SchnittpunkteeinzelnFormat);
      ProjektGrid.Cells[aAnzahlSpalte, Zeile] := IntToStr(AudioSpuren);
      ProjektGrid.Cells[sAnzahlSpalte, Zeile] := IntToStr(SchnittAnzahl);
      ProjektGrid.Cells[vGrSpalte, Zeile]     := IntToStr(VideoGroesse);
      ProjektGrid.Cells[aGrSpalte, Zeile]     := IntToStr(AudioGroesse);
      ProjektGrid.Cells[pGroesseSpalte, Zeile]:= GroessezuStr(VideoGroesse + Audiogroesse);
      ProjektGrid.Cells[iddSpalte, Zeile]     := getString(IndexDateierstellen, WortJa, WortNein);
      ProjektGrid.Cells[d2vSpalte, Zeile]     := getString(D2VDateierstellen, WortJa, WortNein);
      ProjektGrid.Cells[KapSpalte, Zeile]     := getString(KapitelDateierstellen, WortJa, WortNein);
      ProjektGrid.Cells[AusgSpalte, Zeile]    := getString(Ausgabebenutzen, WortJa, WortNein);
      ProjektGrid.Cells[nurAudioSpalte, Zeile]:= getString(nurAudioschneiden, WortJa, WortNein);
      ProjektGrid.Cells[tcSpalte, Zeile]      := getString(Timecodekorrigieren, WortJa, WortNein);
      ProjektGrid.Cells[brSpalte, Zeile]      := getString(Bitratekorrigieren, WortJa, WortNein);
      ProjektGrid.Cells[festeBrSpalte,Zeile]  := IntToStr(feste_Bitrate);
      ProjektGrid.Cells[aTrennSpalte, Zeile]  := AudioTrennzeichen;
      ProjektGrid.Cells[mauSpalte, Zeile]     := IniDatei;
      ProjektGrid.Cells[fehlerSpalte, Zeile]  := '';
      ProjektGrid.Cells[AusgabeSpalte,Zeile]  := absolutPathAppl(Ausgabedatei, Application.ExeName, False);
      ProjektGrid.Cells[EffektSpalte,Zeile]   := absolutPathAppl(Effektdatei, Application.ExeName, False);
      ProjektGrid.Cells[MuxerSpalte, Zeile]   := IntToStr(AusgabeIndex);
      IF ProjektGrid.Cells[zielSpalte, Zeile] = '' THEN
      BEGIN
        ProjektGrid.Cells[statusSpalte, Zeile] := WortNicht_bereit;
        ProjektGrid.Cells[fehlerSpalte, Zeile] := Wortlesen(NIL, 'Meldung321', 'Ziel nicht definiert');
      END
      ELSE
      BEGIN
        ProjektGrid.Cells[statusSpalte, Zeile] := WortWarte;
        GesamtGroesseBerechnen(Projektgroesse(Zeile));
      END; }
      ProjektGrid.Cells[pNameSpalte, Zeile] := ' ' + extractFilename(Dateiname);
      WHILE Dateien_vorhanden(ProjektInfoObj.Zieldateiname, ArbeitsumgebungObj.DateiendungenVideo,
                              ArbeitsumgebungObj.DateiendungenAudio, ProjektInfoObj.nurAudioschneiden) DO
        ProjektInfoObj.Zieldateiname := DateinamePlusEins(ProjektInfoObj.Zieldateiname,
                              ArbeitsumgebungObj.SchnittpunkteeinzelnFormat);
      ProjektGrid.Objects[pOptionenSpalte, Zeile] := ProjektInfoObj;
      ProjektGrid.Cells[zielSpalte, Zeile]      := ProjektInfoObj.Zieldateiname;
      ProjektGrid.Cells[aAnzahlSpalte, Zeile]   := IntToStr(ProjektInfoObj.AudioSpuren);
      ProjektGrid.Cells[sAnzahlSpalte, Zeile]   := IntToStr(ProjektInfoObj.SchnittAnzahl);
      ProjektGrid.Cells[pGroesseSpalte, Zeile]  := GroessezuStr(Projektgroesse(Zeile));
      ProjektGrid.Cells[pOptionenSpalte, Zeile] := ProjektOptionenzuStr(ProjektInfoObj);
      ProjektGrid.Cells[fehlerSpalte, Zeile]  := '';
      IF ProjektInfoObj.Zieldateiname = '' THEN
      BEGIN
        ProjektGrid.Cells[statusSpalte, Zeile] := WortNicht_bereit;
        ProjektGrid.Cells[fehlerSpalte, Zeile] := Wortlesen(NIL, 'Meldung321', 'Ziel nicht definiert');
      END
      ELSE
      BEGIN
        ProjektGrid.Cells[statusSpalte, Zeile] := WortWarte;
        GesamtGroesseBerechnen(Projektgroesse(Zeile));
      END;
      ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung301', Dateiname, 'Projekt $Text1# hinzugefügt.'), 2);
    END;
  FINALLY
    IF Result < 0 THEN
      ProjektInfoObj.Free;
  END;
END;

PROCEDURE THauptprogramm.Zellenfuellen(DateienListe: TStrings; Projektname: STRING = 'kein Projekt');

VAR I, Erg : Integer;
    Text : STRING;

PROCEDURE Fehlerschreiben(Fehlertext: STRING);
BEGIN
  IF Text <> '' THEN
    Text := Text + Chr(13);
  Text := Text + Fehlertext;
END;

BEGIN
  Text := '';
  FOR I := 0 TO DateienListe.Count -1 DO
    IF NOT DateiinListe(DateienListe.Strings[I]) THEN
    BEGIN
      IF ProjektGrid.Cells[pNameSpalte, ProjektGrid.RowCount - 1] <> '' THEN
        ProjektGrid.RowCount := ProjektGrid.RowCount + 1;                       // wenn nötig neue Zeile anhängen
      ProjektGrid.LeftCol := 0;
//      Markierungsetzen(ProjektGrid.RowCount - 1);
      Erg := ProjektAuswerten(DateienListe.Strings[I], Projektname, ProjektGrid.RowCount - 1);
      IF Erg = 0 THEN
      BEGIN
 //       ProjektGrid.Cells[projektSpalte, ProjektGrid.RowCount - 1] := DateienListe.Strings[I];
 //       ProjektGrid.Cells[pNameSpalte, ProjektGrid.RowCount - 1] := ' ' + extractFilename(DateienListe.Strings[I]);
      END
      ELSE
      BEGIN
        IF ProjektGrid.RowCount > 2 THEN
          ProjektGrid.RowCount := ProjektGrid.RowCount - 1;                     // letzte Zeile entfernen
        CASE Erg OF
         -1 : Fehlerschreiben(Meldunglesen(NIL, 'Meldung322', DateienListe.Strings[I], 'Der Dateityp $Text1# wird nicht unterstützt.'));
         -2 : Fehlerschreiben(Meldunglesen(NIL, 'Meldung323', DateienListe.Strings[I], 'Die Datei $Text1# existiert nicht.'));
         -3 : Fehlerschreiben(Meldunglesen(NIL, 'Meldung324', DateienListe.Strings[I], 'Die ProjektDatei $Text1# hat nicht die nötige Versionsnummer (mindestens Vers. 3)!'));
         -4 : Fehlerschreiben(Meldunglesen(NIL, 'Meldung325', DateienListe.Strings[I], 'Die ProjektDatei $Text1# enthält keinen Schnittpunkt und wird nicht geladen!'));
     -5, -6 : Fehlerschreiben(Meldunglesen(NIL, 'Meldung326', DateienListe.Strings[I], 'Die ProjektDatei $Text1# enthält kein Video und kein Audio und wird nicht geladen!'));
        END;
      END;
    END;
  IF Text <> '' THEN
    ProtokollUnit.Protokoll_schreiben(Text, 1);
END;

PROCEDURE THauptprogramm.Zeilenentfernen(Anfang, Ende: Integer);

VAR I : Integer;
    Anzahl : Integer;

BEGIN
  IF NOT Laeuft THEN
  BEGIN
    FOR I := Anfang TO Ende DO
    BEGIN
      IF Assigned(ProjektGrid.Objects[pOptionenSpalte, I]) THEN
      BEGIN
        IF (TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname <> '') THEN
          ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung302', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, I]).Dateiname, 'Projekt $Text1# entfernt.'), 2);
        ProjektGrid.Objects[pOptionenSpalte, I].Free;                           // ProjektInfoObjekt löschen
        ProjektGrid.Objects[pOptionenSpalte, I] := NIL;                         // und Zeiger löschen
      END;
      IF ProjektGrid.Cells[statusSpalte, I] = WortWarte THEN
        GesamtGroesseBerechnen(- Projektgroesse(I));
    END;
    Anzahl := ProjektGrid.RowCount - (Ende + 1);
    FOR I := 0 TO Anzahl - 1 DO
      ProjektGrid.Rows[Anfang + I] := ProjektGrid.Rows[Ende + I + 1];           // Zeilen die nach den zu löschenden Zeilen liegen nach vorn verschieben
    IF ProjektGrid.RowCount - (Ende - Anfang + 1) < 2 THEN                      // wurden alle Zeilen glöscht muß die 2. Zeile geleert werden
    BEGIN
      FOR I := 0 TO ProjektGrid.ColCount - 1 DO
        ProjektGrid.Cells[I, 1] := '';                                          // Felder der Zeile leeren
    END;
    IF (ProjektGrid.RowCount - (Ende - Anfang + 1)) < 2 THEN
      ProjektGrid.Rowcount := 2                                                 // alle Zeilen wurden gelöscht
    ELSE
      ProjektGrid.RowCount := ProjektGrid.RowCount - (Ende - Anfang + 1);       // die übrig gebliebenen Zeile entfernen
    ProjektGrid.LeftCol := 0;
  //  Markierungsetzen(ProjektGrid.RowCount - 1);                                   // Markierung auf die letzte Zeile setzen
  END;


// die folgende Funktion funktioniert bringt aber während der Verarbeitung
// von Projekten den Zeilenzähler durcheinander
{  FOR I := Anfang TO Ende DO
  BEGIN
    IF Projektgrid.Cells[statusSpalte, Anfang] <> WortVerarbeite THEN           // das gerade berarbeitete Projekt darf nicht gelöscht werden
    BEGIN
      IF Assigned(ProjektGrid.Objects[pOptionenSpalte, Anfang]) THEN
      BEGIN
        IF (TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Anfang]).Dateiname <> '') THEN
          ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung302', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Anfang]).Dateiname, 'Projekt $Text1# entfernt.'), 2);
        ProjektGrid.Objects[pOptionenSpalte, Anfang].Free;                      // ProjektInfoObjekt löschen
        ProjektGrid.Objects[pOptionenSpalte, Anfang] := NIL;                    // und Zeiger löschen
      END;
      IF ProjektGrid.Cells[statusSpalte, Anfang] = WortWarte THEN
        GesamtGroesseBerechnen(- Projektgroesse(I));
      FOR J := Anfang TO ProjektGrid.RowCount - 2 DO
        ProjektGrid.Rows[J] := ProjektGrid.Rows[J + 1];                         // Zeilen die nach der zu löschenden Zeile liegen nach vorn verschieben
      IF ProjektGrid.RowCount > 2 THEN
        ProjektGrid.RowCount := ProjektGrid.RowCount - 1                        // letzte Zeile löschen
      ELSE
        FOR J := 0 TO ProjektGrid.ColCount - 1 DO
          ProjektGrid.Cells[J, 1] := '';                                        // Felder der Zeile leeren
    END
    ELSE
      Inc(Anfang);
  END;
  ProjektGrid.LeftCol := 0; }
END;

PROCEDURE THauptprogramm.Projektfenster_Spracheaendern(Spracheladen: TSprachen);
BEGIN
  ProjektGrid.Cells[pNameSpalte,0]     := Wortlesen(Spracheladen, 'Projekt', 'Projekt');
  ProjektGrid.Cells[aAnzahlSpalte,0]   := Wortlesen(Spracheladen, 'Audioanzahl', 'A');
  ProjektGrid.Cells[sAnzahlSpalte,0]   := Wortlesen(Spracheladen, 'Schnittanzahl', 'S');
  ProjektGrid.Cells[pGroesseSpalte,0]  := Wortlesen(Spracheladen, 'Groesse', 'Größe');
  ProjektGrid.Cells[zielSpalte,0]      := Wortlesen(Spracheladen, 'Ziel', 'Ziel');
  ProjektGrid.Cells[statusSpalte,0]    := Wortlesen(Spracheladen, 'Status', 'Status');
  ProjektGrid.Cells[pOptionenSpalte,0] := Wortlesen(Spracheladen, 'Optionen', 'Optionen');
{  ProjektGrid.Cells[iddSpalte,0]     := Wortlesen(Spracheladen, 'Indexdateien_erstellen', 'IDD');
  ProjektGrid.Cells[d2vSpalte,0]     := Wortlesen(Spracheladen, 'D2V-Datei_erstellen', 'D2V');
  ProjektGrid.Cells[KapSpalte,0]     := Wortlesen(Spracheladen, 'Kapiteldatei_erstellen', 'Kap.');
  ProjektGrid.Cells[AusgSpalte,0]    := Wortlesen(Spracheladen, 'Ausgabe_benutzen', 'Asg.');
  ProjektGrid.Cells[nurAudioSpalte,0]:= Wortlesen(Spracheladen, 'Nur_Audio_schneiden', 'nurA');
  ProjektGrid.Cells[tcSpalte,0]      := Wortlesen(Spracheladen, 'Timecode_aendern', 'TC');
  ProjektGrid.Cells[brSpalte,0]      := Wortlesen(Spracheladen, 'Bitrate_aendern', 'BR');
  ProjektGrid.Cells[festeBrSpalte,0] := Wortlesen(Spracheladen, 'Bitrate', 'Bitrate');   }
  ProjektGrid.Cells[fehlerSpalte,0]  := Wortlesen(Spracheladen, 'Fehler', 'Fehler');
  WortFehler                         := Wortlesen(Spracheladen, 'Fehler', 'Fehler');
  WortFehlercode                     := Wortlesen(Spracheladen, 'Fehlercode', 'Fehlercode');
  WortFertig                         := Wortlesen(Spracheladen, 'Fertig', 'Fertig');
  WortNicht_bereit                   := Wortlesen(Spracheladen, 'Nicht_bereit', 'Nicht bereit');
  WortWarte                          := Wortlesen(Spracheladen, 'Warte', 'Warte');
  WortVerarbeite                     := Wortlesen(Spracheladen, 'Verarbeite', 'Verarb.');
  WortUeberspringen                  := Wortlesen(Spracheladen, 'Ueberspringen', 'Uebersp.');
  WortJa                             := Wortlesen(Spracheladen, 'Ja', 'Ja');
  WortNein                           := Wortlesen(Spracheladen, 'Nein', 'Nein');
END;

// Anzeige

FUNCTION THauptprogramm.GroessezuStr(Groesse: Int64): STRING;

VAR GroesseReal : Double;

BEGIN
  GroesseReal := Groesse / (1024 * 1024);
  Str(GroesseReal :2:2, Result);
  Result := Result + ' MB';
END;

PROCEDURE THauptprogramm.GesamtGroesseBerechnen(Groesse: Int64);
BEGIN
  EndwertProjekte := EndwertProjekte + Groesse;
  Gesamtgroesse.Caption := GroessezuStr(EndwertProjekte);
END;

PROCEDURE THauptprogramm.GesamtGroesseneuBerechnen(Anfang: Integer = -1; Ende: Integer = -1);

VAR I : Integer;

BEGIN
  EndwertProjekte := 0;
  IF Anfang < 0 THEN
    Anfang := 1;
  IF Ende < 1 THEN
    Ende := ProjektGrid.RowCount - 1;
  FOR I := Anfang TO Ende DO
    IF (ProjektGrid.Cells[statusSpalte, I] = WortWarte) THEN
      EndwertProjekte := EndwertProjekte + Projektgroesse(I);
  Gesamtgroesse.Caption := GroessezuStr(EndwertProjekte);
END;

// Schneiden

PROCEDURE THauptprogramm.ProjekteSchneiden(Anfang: Integer = -1; Ende: Integer = -1);

VAR Z, Erg : Integer;
    nichtBeenden : Boolean;
    Projektdatei : TStringList;
//    AusgabeObj : TAusgabe;
//    EffekteObj : TEffekte;

BEGIN
  IF (Assigned(ProjektGrid.Objects[pOptionenSpalte, ProjektGrid.RowCount - 1]) AND
     (TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, ProjektGrid.RowCount - 1]).Dateiname = '')) OR
     (NOT Assigned(ProjektGrid.Objects[pOptionenSpalte, ProjektGrid.RowCount - 1])) THEN
    exit;                                                                      // keine Projekte geladen
  IF NOT Laeuft THEN
  BEGIN
    Laeuft := True;
    TRY
      nichtBeenden := False;
      StoppenMenuItem.Checked := False;
      StoppenBtn.Down := False;
      ProjektentfernenBtn.Enabled := False;
      ProjektSchneidenBtn.Enabled := False;
      ProjekteSchneidenBtn.Enabled := False;
      AbbrechenBtn.Enabled := True;
      IF NOT einProjekt THEN
        StoppenBtn.Enabled := True
      ELSE
        OKTaste.Enabled := False;
      SchneidenUnit.Endwert := @Endwert;
      SchneidenUnit.Fortschrittsanzeige := Fortschrittsanzeige;
      SchneidenUnit.Textanzeige := Textanzeige;
      GesamtFortschrittzuruecksetzen;
      GesamtGroesseneuBerechnen(Anfang, Ende);
      PositionProjekte := 0;
      AnfangszeitGesamt := Time;
      IF Anfang < 1 THEN
        Anfang := 1;
      IF Ende < 1 THEN
        Ende := ProjektGrid.RowCount - 1;
      Z := Anfang;
//      AusgabeObj := TAusgabe.Create;
//      EffekteObj := TEffekte.Create;
      TRY
        WHILE (NOT StoppenBtn.Down) AND
              (Z < Ende + 1) DO
        BEGIN
          Markierungsetzen(Z);                                                  // aktuelle Zeile markieren
          IF {einProjekt OR }                                                     // im einProjektmodus ist die Statuszeile nicht interessant
            (ProjektGrid.Cells[statusSpalte,Z] = WortWarte) THEN
          BEGIN
            aktDateigroesse.Caption := ProjektGrid.Cells[pGroesseSpalte, Z];    // aktuelle Projektgröße anzeigen
            Fortschrittzuruecksetzen;
            ProjektGrid.Cells[fehlerSpalte,Z] := '';                            // Fehlerspalte löschen
            ProjektGrid.Cells[statusSpalte,Z] := WortVerarbeite;
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung331', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname, 'Starte Verarbeitung des Projektes $Text1#'), 2);
            ProtokollUnit.Protokoll_schreiben(Wortlesen(NIL, 'Meldung332', 'Projekteigenschaften:'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung333', GroessezuStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).VideoGroesse), 'Grösse der Videodatei ca. $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung334', GroessezuStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).AudioGroesse), 'Grösse der Audiodatei(en) ca. $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung348', FloatToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).BilderProSek), 'Bilder/Sek.: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung335', IntToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).AudioSpuren), 'Anzahl der Audiodateien: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung336', IntToStr(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).SchnittAnzahl), 'Anzahl der Schnitte: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung337', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Zieldateiname, 'Zielverzeichnis/Dateiname: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung340', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).IndexDateierstellen, WortJa, WortNein), 'Indexdateien erstellen: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung341', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).D2VDateierstellen, WortJa, WortNein), 'D2V-Datei erstellen: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung342', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).IDXDateierstellen, WortJa, WortNein), 'IDX-Datei erstellen: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung343', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).KapitelDateierstellen, WortJa, WortNein), 'Kapiteldatei erstellen: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung344', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Timecodekorrigieren, WortJa, WortNein), 'Timecode korrigieren: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung345', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Bitratekorrigieren, WortJa, WortNein), 'Bitrate korrigieren: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung346', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).nurAudioschneiden, WortJa, WortNein), 'nur Audio schneiden: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung347', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Schnittpunkteeinzelnschneiden, WortJa, WortNein), 'Schnitte einzeln schneiden: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung348', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Framegenauschneiden, WortJa, WortNein), 'framegenau Schneiden: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung349', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Ausgabebenutzen, WortJa, WortNein), 'Nachbearbeitung: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung350', Bitrateim1Header.Items[TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).BitrateersterHeader], 'Bitrate im 1. Sequenzheader: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung351', AspectRatio1Header.Items[TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).BitrateersterHeader], 'Bitrate im 1. Sequenzheader: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung352', getString(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Ausgabebenutzen, WortJa, WortNein), 'maximale GOP-Größe verwenden: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung353', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Encoderdatei, 'Encoderscript: $Text1#'), 3);
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung354', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Ausgabedatei, 'Nachbearbeitungsscript: $Text1#'), 3);
            AnfangszeitDatei := Time;
            DateienUnit.Loeschen;
            SchnittUnit.Loeschen;
            KapitelUnit.Loeschen;
            MarkenUnit.Loeschen;
  {          test := True;                            // zum Testen
            test2 := False;
            WHILE test DO
              Application.ProcessMessages;
            IF test2 THEN
              Erg := -99999
            ELSE
              Erg := 0;   }
            Erg := ProjektUnit.Projektladen(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname);
            IF Erg > -1 THEN
            BEGIN
              SchneidenUnit.Schnittpunkteeinzelnschneiden := False;
              SchneidenUnit.MarkierteSchnittpunkte := False;
              SchneidenUnit.nurAudioschneiden := False;
              Erg := SchneidenUnit.Schneiden(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]));
              IF Erg < 0 THEN
                Erg := Erg - 100000;
            END;
            Projektdatei := TStringList.Create;
            TRY
              Projektdatei.LoadFromFile(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname);
              IF LeftStr(Projektdatei.Strings[Projektdatei.Count - 2], 14) = 'Zieldateiname=' THEN
              BEGIN
                Projektdatei.Delete(Projektdatei.Count - 1);
                Projektdatei.Delete(Projektdatei.Count - 1);
              END;
              Projektdatei.Add('Zieldateiname="' + TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Zieldateiname + '"');
              Projektdatei.Add('Fehlernummer=' + IntToStr(Erg));
              Projektdatei.SaveToFile(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname);
            FINALLY
              Projektdatei.Free;
            END;
            IF Erg < 0 THEN
            BEGIN
              IF NOT einProjekt THEN
                ProjektGrid.Cells[statusSpalte, Z] := WortFehler
              ELSE
                ProjektGrid.Cells[statusSpalte, Z] := WortWarte;
              ProjektGrid.Cells[FehlerSpalte, Z] := WortFehlercode + ': ' + IntToStr(Erg);
              nichtBeenden := True;
              CASE Erg OF                           // bestimmte Fehler auswerten und ins Protokoll schreiben
                -123456 : ProtokollUnit.Protokoll_schreiben(ProjektGrid.Cells[FehlerSpalte, Z] + '; ' + Meldunglesen(NIL, 'Meldung303', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname, 'Projekt $Text1# abgebrochen durch Benutzer.'), 2);
              ELSE
                ProtokollUnit.Protokoll_schreiben(WortFehlercode + ': ' + IntToStr(Erg), 1);
              END;
            END
            ELSE
            BEGIN
              IF NOT einProjekt THEN
                ProjektGrid.Cells[statusSpalte, Z] := WortFertig
              ELSE
                ProjektGrid.Cells[statusSpalte, Z] := WortWarte;
              ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung304', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname, 'Projekt $Text1# erfolgreich verarbeitet.'), 2);
            END;
            PositionProjekte := PositionProjekte + Projektgroesse(Z);
//            Inc(Z);
  {          IF Erg < 0 THEN
            BEGIN
              ProtokollUnit.Protokoll_schreiben(WortFehlercode + ': ' + IntToStr(Erg), 1);
              ProjektGrid.Cells[statusSpalte, Z] := WortFehler;
              ProjektGrid.Cells[FehlerSpalte, Z] := WortFehlercode + ': ' + IntToStr(Erg);
              nichtBeenden := True;
              PositionProjekte := PositionProjekte + Projektgroesse(Z);
              Inc(Z);
              Continue;
            END;
            SchneidenUnit.Schnittpunkteeinzelnschneiden := False;
            SchneidenUnit.MarkierteSchnittpunkte := False;
            SchneidenUnit.nurAudioschneiden := False;
  //          Erg := SchneidenUnit.Schneiden(TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]));
            Erg := 0;
            IF Erg < 0 THEN
            BEGIN
              Erg := Erg - 100000;
              ProjektGrid.Cells[statusSpalte, Z] := WortFehler;
              ProjektGrid.Cells[FehlerSpalte, Z] := WortFehlercode + ': ' + IntToStr(Erg);
              CASE Erg OF                           // bstimmte Fehler auswerten und ins Protokoll schreiben
                -123456 : ProtokollUnit.Protokoll_schreiben(ProjektGrid.Cells[FehlerSpalte, Z] + '; ' + Meldunglesen(NIL, 'Meldung303', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname, 'Projekt $Text1# abgebrochen durch Benutzer.'), 2);
              ELSE
                ProtokollUnit.Protokoll_schreiben(WortFehlercode + ': ' + IntToStr(Erg), 1);
              END;
              nichtBeenden := True;
              PositionProjekte := PositionProjekte + Projektgroesse(Z);
              Inc(Z);
              Continue;
            END;   }
  {          IF angehalten THEN
            BEGIN
              ProjektGrid.Cells[statusSpalte, Z] := WortFehler;
              ProjektGrid.Cells[FehlerSpalte, Z] := Meldunglesen(NIL, 'Meldung303', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname, 'Projekt $Text1# abgebrochen durch Benutzer.');
              ProtokollUnit.Protokoll_schreiben('Projekt ' + TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname + ' abgebrochen durch Benutzer.', 2);
              PositionProjekte := PositionProjekte + Projektgroesse(Z);
              angehalten := False;
              Inc(Z);
              Continue;
            END;  }
  {          ProjektGrid.Cells[statusSpalte, Z] := WortFertig;
            ProtokollUnit.Protokoll_schreiben(Meldunglesen(NIL, 'Meldung304', TProjektInfo(ProjektGrid.Objects[pOptionenSpalte, Z]).Dateiname, 'Projekt $Text1# erfolgreich verarbeitet.'), 2);
            PositionProjekte := PositionProjekte + Projektgroesse(Z);
            Inc(Z);    }
          END;
          Inc(Z);
        END;
      FINALLY
//        AusgabeObj.Free;
//        EffekteObj.Free;
      END;
      IF NOT einProjekt THEN
      BEGIN
        ProjektentfernenBtn.Enabled := True;
        ProjektSchneidenBtn.Enabled := True;
        ProjekteSchneidenBtn.Enabled := True;
      END
      ELSE
        OKTaste.Enabled := True;
      AbbrechenBtn.Enabled := False;
      StoppenBtn.Enabled := False;
      aktDateigroesse.Caption := '0 MB';
      Fortschrittzuruecksetzen;
//      IF NOT einProjekt THEN
        GesamtGroesseneuBerechnen;
//      GesamtFortschrittzuruecksetzen;
      IF StoppenBtn.Down THEN
      BEGIN
        StoppenMenuItem.Checked := False;
        StoppenBtn.Down := False;
        nichtBeenden := True;
        ProtokollUnit.Protokoll_schreiben(Wortlesen(NIL, 'Meldung305', 'Stapelverarbeitung angehalten.'), 2);
      END
      ELSE
      BEGIN
        ProtokollUnit.Protokoll_schreiben(Wortlesen(NIL, 'Meldung306', 'Stapelverarbeitung abgeschlossen.'), 2);
      END;
    FINALLY
      Laeuft := False;
    END;
    IF RechnerausschaltenMenuItem.Checked AND (NOT nichtBeenden) THEN
    BEGIN
      ProtokollUnit.Protokoll_schreiben(Wortlesen(NIL, 'Meldung308', 'Der Rechner wird heruntergefahren.'), 2);
      ProtokollUnit.Protokoll_schreiben(WortProtokollende);
      ProtokollUnit.Protokoll_schliessen;
      WindowsBeenden(EWX_SHUTDOWN);
    END
    ELSE
      IF ProgrammschliessenMenuItem.Checked AND (NOT nichtBeenden) THEN
      BEGIN
        ProtokollUnit.Protokoll_schreiben(Wortlesen(NIL, 'Meldung307', 'Das Programm wird beendet.'), 2);
        Close;
      END;
  END
  ELSE
  BEGIN
  END;
END;

// Fortschritt

PROCEDURE THauptprogramm.Fortschrittzuruecksetzen;
BEGIN
  alterWert := 0;
  FortschrittDatei.Position := 0;
  FortschrittDatei.Update;
  ZeitDatei.Caption := '00:00:00';
  GesamtzeitDatei.Caption := '00:00:00';
  RestzeitDatei.Caption := '00:00:00';
END;

PROCEDURE THauptprogramm.GesamtFortschrittzuruecksetzen;
BEGIN
  Fortschrittgesamt.Position := 0;
  Fortschrittgesamt.Update;
  ZeitGesamt.Caption := '00:00:00';
  RestzeitGesamt.Caption := '00:00:00';
  GesamtzeitGesamt.Caption := '00:00:00';
END;

FUNCTION THauptprogramm.Fortschrittsanzeige(Fortschritt: Int64): Boolean;

VAR aktuelleZeit,
    gesamteZeit : TDateTime;

BEGIN
  Result := Anhalten;
  Anhalten := False;
  IF Fortschritt > 0 THEN
  BEGIN
    IF Endwert > 0 THEN
      neuerWert := Round(Fortschritt * 100 / Endwert)
    ELSE
      neuerWert  := 0;
    IF (neuerWert > alterWert) OR (Time > naechsteAktualisierung) THEN
    BEGIN
      alterWert := neuerWert;
      FortschrittDatei.Position := neuerWert;
      FortschrittDatei.Update;
      aktuelleZeit := Time - AnfangszeitDatei;
      gesamteZeit := aktuelleZeit * Endwert / Fortschritt;
      ZeitDatei.Caption := FormatDateTime('hh:nn:ss', aktuelleZeit);
      GesamtzeitDatei.Caption := FormatDateTime('hh:nn:ss', gesamteZeit);
      RestzeitDatei.Caption := FormatDateTime('hh:nn:ss', gesamteZeit - aktuelleZeit);
  //   GesamtFortschrittsanzeige
      IF EndwertProjekte > 0 THEN
        Fortschrittgesamt.Position := Round((PositionProjekte + Fortschritt) * 100 / EndwertProjekte);
      Fortschrittgesamt.Update;
      aktuelleZeit := Time - AnfangszeitGesamt;
      gesamteZeit := aktuelleZeit * EndwertProjekte / (PositionProjekte + Fortschritt);
      ZeitGesamt.Caption := FormatDateTime('hh:nn:ss', aktuelleZeit);
      GesamtzeitGesamt.Caption := FormatDateTime('hh:nn:ss', gesamteZeit);
      RestzeitGesamt.Caption := FormatDateTime('hh:nn:ss', gesamteZeit - aktuelleZeit);
      naechsteAktualisierung := incMilliSecond(Time, Aktualisierungszyklus);
    END;
    Application.ProcessMessages;
  END;
END;

FUNCTION THauptprogramm.Textanzeige(Meldung: Integer; Text: STRING): Boolean;
BEGIN
  Result := Anhalten;
  Anhalten := False;
  CASE Meldung OF
    1 : Text := Meldunglesen(NIL, 'Fortschritt1', Text, 'Datei $Text1# analysieren.');
    2 : Text := Meldunglesen(NIL, 'Fortschritt2', Text, 'Indexdatei $Text1# einlesen.');
    3 : Text := Meldunglesen(NIL, 'Fortschritt3', Text, 'Indexdatei $Text1# schreiben.');
    4 : Text := Meldunglesen(NIL, 'Fortschritt4', Text, 'Schnitt $Text1# kopieren.');
  END;
  ProtokollUnit.Protokoll_schreiben(Text, 2);
  Application.ProcessMessages;
END;

// Tastenbilder

procedure THauptprogramm.ErsetzeSpeedButtons;
begin
  ProjekteinfuegenBtn := TAlphaSpeedBtn.Create(Self).Replace(ProjekteinfuegenBtn);
  ProjektentfernenBtn := TAlphaSpeedBtn.Create(Self).Replace(ProjektentfernenBtn);
  ProgrammEndeBtn := TAlphaSpeedBtn.Create(Self).Replace(ProgrammEndeBtn);
  ProjektSchneidenBtn := TAlphaSpeedBtn.Create(Self).Replace(ProjektSchneidenBtn);
  ProjekteSchneidenBtn := TAlphaSpeedBtn.Create(Self).Replace(ProjekteSchneidenBtn);
  AbbrechenBtn := TAlphaSpeedBtn.Create(Self).Replace(AbbrechenBtn);
  StoppenBtn := TAlphaSpeedBtn.Create(Self).Replace(StoppenBtn);
  ProgrammschliessenBtn := TAlphaSpeedBtn.Create(Self).Replace(ProgrammschliessenBtn);
  RechnerausschaltenBtn := TAlphaSpeedBtn.Create(Self).Replace(RechnerausschaltenBtn);
  HilfeBtn := TAlphaSpeedBtn.Create(Self).Replace(HilfeBtn);
end;

procedure THauptprogramm.SymbolMapping74(skin: TSkinFactory; Mode: Integer);
begin
  IF Mode = 2 THEN
    skin.Row := Rect(297, 0, 0, 0);
  skin.AddToMapping(POINT(26, 26), 12);
  skin.MappingDone;
end;

procedure THauptprogramm.TastenbeschriftungVerbergen(Taste: TSpeedButton);
begin
  if TAlphaSpeedBtn(Taste).Glyph <> nil then
    TAlphaSpeedBtn(Taste).CaptionHidden := True;
end;
{
procedure THauptprogramm.TastenbeschriftungAusrichten(Taste: TSpeedButton; Margin1, Spacing1, Margin2, Spacing2: Integer);
begin
  if TAlphaSpeedBtn(Taste).Glyph = nil then begin
    Taste.Margin := Margin2;
    Taste.Spacing := Spacing2;
  end else begin
    Taste.Margin := Margin1;
    Taste.Spacing := Spacing1;
  end;
end;
}
procedure THauptprogramm.Tastenbeschriftunganpassen;
begin
  TastenbeschriftungVerbergen(ProjekteinfuegenBtn);
  TastenbeschriftungVerbergen(ProjektentfernenBtn);
  TastenbeschriftungVerbergen(ProgrammEndeBtn);
  TastenbeschriftungVerbergen(ProjektSchneidenBtn);
  TastenbeschriftungVerbergen(ProjekteSchneidenBtn);
  TastenbeschriftungVerbergen(AbbrechenBtn);
  TastenbeschriftungVerbergen(StoppenBtn);
  TastenbeschriftungVerbergen(ProgrammschliessenBtn);
  TastenbeschriftungVerbergen(RechnerausschaltenBtn);
  TastenbeschriftungVerbergen(HilfeBtn);
end;

// Wenn die Datei die in Dateinamen übergeben wird nicht
// existiert, dann wird der 'default' set geladen.
function THauptprogramm.LadeIconTemplate(Mode: Integer; DateiName : STRING): Integer;
var
  skin: TSkinFactory;
begin
  skin := nil;
  if Mode > 0 then begin
    if Mode = 2 then begin
      Result := 0;                                                   // Symbole aus Datei
      try
        skin := TSkinFactory.Create(DateiName);
      except
        skin := nil;
        Result := -2;
        Mode := 1;                                                   // Symboldatei laden fehlgeschlagen
      end
    end else
      Result := -3;                                                  // Defaultsymbole
    if skin = nil then                                               // default Symbol-Set laden
      skin := TSkinFactory.CreateFromResource('SchnittToolSymbole');
  end else
    Result := -1;                                                    // keine Symbole

  if skin = nil then begin
    TAlphaSpeedBtn(ProjekteinfuegenBtn).Glyph := nil;
    TAlphaSpeedBtn(ProjektentfernenBtn).Glyph := nil;
    TAlphaSpeedBtn(ProgrammEndeBtn).Glyph := nil;
    TAlphaSpeedBtn(ProjektSchneidenBtn).Glyph := nil;
    TAlphaSpeedBtn(ProjekteSchneidenBtn).Glyph := nil;
    TAlphaSpeedBtn(AbbrechenBtn).Glyph := nil;
    TAlphaSpeedBtn(StoppenBtn).Glyph := nil;
    TAlphaSpeedBtn(ProgrammschliessenBtn).Glyph := nil;
    TAlphaSpeedBtn(RechnerausschaltenBtn).Glyph := nil;
    TAlphaSpeedBtn(HilfeBtn).Glyph := nil;
  end else begin
    SymbolMapping74(skin, Mode);
    skin.Premultiply;                // darf nicht beim einladen gemacht werden, sonst funktioniert das Update nicht mehr richtig.
    TAlphaSpeedBtn(ProjekteinfuegenBtn).Glyph := skin.GetBitmap(0);
    TAlphaSpeedBtn(ProjektentfernenBtn).Glyph := skin.GetBitmap(1);
    TAlphaSpeedBtn(ProgrammEndeBtn).Glyph := skin.GetBitmap(2);
    TAlphaSpeedBtn(ProjektSchneidenBtn).Glyph := skin.GetBitmap(3);
    TAlphaSpeedBtn(ProjekteSchneidenBtn).Glyph := skin.GetBitmap(4);
    TAlphaSpeedBtn(AbbrechenBtn).Glyph := skin.GetBitmap(5);
    TAlphaSpeedBtn(StoppenBtn).Glyph := skin.GetBitmap(6);
    TAlphaSpeedBtn(ProgrammschliessenBtn).Glyph := skin.GetBitmap([7, 8]);
    TAlphaSpeedBtn(RechnerausschaltenBtn).Glyph := skin.GetBitmap([9, 10]);
    TAlphaSpeedBtn(HilfeBtn).Glyph := skin.GetBitmap(11);
  end;
  Tastenbeschriftunganpassen;
end;

// Sprachen

PROCEDURE THauptprogramm.Spracheeinlesen;

VAR Sprachobjektloeschen : Boolean;

BEGIN
  IF NOT Assigned(Spracheladen) THEN
  BEGIN
    Spracheladen := Sprachobjekterzeugen('', '', '', False);
    Sprachobjektloeschen := True;
  END
  ELSE
    Sprachobjektloeschen := False;
  TRY
    Sprachen.Spracheaendern(Spracheladen);
    Spracheaendern(Spracheladen);
    IF Assigned(Ueberfenster) THEN
      Ueberfenster.Spracheaendern(Spracheladen);
//    IF Assigned(ArbeitsumgebungFenster) THEN
//      ArbeitsumgebungFenster.Spracheaendern(Spracheladen);
//    IF Assigned(OptionenFenster) THEN
//      OptionenFenster.Spracheaendern(Spracheladen);
//    IF Assigned(ArbeitsumgebungObj) THEN
//      ArbeitsumgebungObj.Spracheaendern(Spracheladen);
  FINALLY
    IF Sprachobjektloeschen THEN
      Sprachobjektfreigeben(Spracheladen);
  END;
END;

PROCEDURE THauptprogramm.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

{FUNCTION Komponentenname(Komponente: TComponent): STRING;

VAR Position : Integer;

BEGIN
  Position := PosX(['1', '2', '3', '4', '5', '6', '7', '8', '9'], Komponente.Name, 0, True, True);
  IF Position = 0 THEN
    Result := Komponente.Name
  ELSE
    Result := LeftStr(Komponente.Name, Position);
END;}

BEGIN
  Caption := UeberFenster.VersionNr;
  FOR I := 0 TO ComponentCount - 1 DO
  BEGIN
    Komponente := Components[I];
    IF Komponente IS TAlphaSpeedBtn THEN      // in der Unit AlphaBlend
    BEGIN
      TAlphaSpeedBtn(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TAlphaSpeedBtn(Komponente).Caption);
      TAlphaSpeedBtn(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TAlphaSpeedBtn(Komponente).Hint);
    END
    ELSE  
    IF Komponente IS TSpeedButton THEN        // in der Unit Buttons
    BEGIN
      TSpeedButton(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TSpeedButton(Komponente).Caption);
      TSpeedButton(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TSpeedButton(Komponente).Hint);
//      ProtokollMemo.Lines.Add(Komponente.Name);
    END
    ELSE
    IF Komponente IS TBitBtn THEN             // in der Unit Buttons
    BEGIN
      TBitBtn(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TBitBtn(Komponente).Caption);
      TBitBtn(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TBitBtn(Komponente).Hint);
    END
    ELSE
{    IF Komponente IS TButton THEN             // in der Unit StdCtrls
    BEGIN
      TButton(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TButton(Komponente).Caption);
      TButton(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TButton(Komponente).Hint);
    END
    ELSE   }
    IF Komponente IS TCheckBox THEN           // in der Unit StdCtrls
    BEGIN
      TCheckBox(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TCheckBox(Komponente).Caption);
      TCheckBox(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TCheckBox(Komponente).Hint);
    END
    ELSE
{    IF Komponente IS TRadioButton THEN
    BEGIN
      TRadioButton(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TRadioButton(Komponente).Caption);
      TRadioButton(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TRadioButton(Komponente).Hint);
    END
    ELSE   }
    IF Komponente IS TLabel THEN              // in der Unit StdCtrls
    BEGIN
      TLabel(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TLabel(Komponente).Caption);
      TLabel(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TLabel(Komponente).Hint);
//      ProtokollMemo.Lines.Add(Komponente.Name);
    END
    ELSE
    IF Komponente IS TMenuItem THEN           // in der Unit Menus
    BEGIN
      IF Komponente.Name <> '' THEN
      BEGIN
        TMenuItem(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TMenuItem(Komponente).Caption);
        TMenuItem(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TMenuItem(Komponente).Hint);
//      ProtokollMemo.Lines.Add(Komponente.Name);
      END;
    END
    ELSE
{    IF Komponente IS TGroupBox THEN           // in der Unit StdCtrls
    BEGIN
      TGroupBox(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TGroupBox(Komponente).Caption);
      TGroupBox(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TGroupBox(Komponente).Hint);
    END
    ELSE
    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      TTabSheet(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TTabSheet(Komponente).Caption);
      TTabSheet(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TTabSheet(Komponente).Hint);
    END;
    IF Komponente IS TPanel THEN              // in der Unit ExtCtrls
    BEGIN
      TPanel(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TPanel(Komponente).Caption);
      TPanel(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TPanel(Komponente).Hint);
    END;
    IF Komponente IS TAction THEN             // in der Unit ActnList
    BEGIN
      TAction(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TAction(Komponente).Caption);
      TAction(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TAction(Komponente).Hint);
    END
    ELSE
    IF Komponente IS TTrackBar THEN           // in der Unit ComCtrls
    BEGIN
      TTrackBar(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TTrackBar(Komponente).Hint);
    END
    ELSE }
    IF Komponente IS TEdit THEN               // in der Unit StdCtrls
    BEGIN
      TEdit(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TEdit(Komponente).Hint);
    END
    ELSE
    IF Komponente IS TComboBox THEN           // in der Unit StdCtrls
    BEGIN
      TComboBox(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TComboBox(Komponente).Hint);
    END;
  END;
  Bitrateim1Header.Items[0] := Wortlesen(Spracheladen, 'nichtaendern', 'Bitrate nicht ändern');
  Bitrateim1Header.Items[1] := Wortlesen(Spracheladen, 'vomOrginal', 'Bitrate vom Orginal');
  Bitrateim1Header.Items[2] := Wortlesen(Spracheladen, 'durchschnittlich', 'durchschnl. Bitrate');
  Bitrateim1Header.Items[3] := Wortlesen(Spracheladen, 'maximale', 'maximale Bitrate');
  Bitrateim1Header.Items[4] := Wortlesen(Spracheladen, 'festeBitrate', 'feste Bitrate');
  AspectRatio1Header.Items[0] := Wortlesen(Spracheladen, 'ARnichtaendern', 'Aspectratio nicht ändern');
  AspectRatio1Header.Items[1] := Wortlesen(Spracheladen, 'ARvomOrginal', 'Aspectratio vom Orginal');
  AspectRatio1Header.Items[2] := Wortlesen(Spracheladen, 'Aspectratio1/1', 'Aspectratio 1/1');
  AspectRatio1Header.Items[3] := Wortlesen(Spracheladen, 'Aspectratio3/4', 'Aspectratio 3/4');
  AspectRatio1Header.Items[4] := Wortlesen(Spracheladen, 'Aspectratio9/16', 'Aspectratio 9/16');
  AspectRatio1Header.Items[5] := Wortlesen(Spracheladen, 'Aspectratio1/2,21', 'Aspectratio 1/2,21');
  AspectRatio1Header.Items[6] := Wortlesen(Spracheladen, 'Aspectrationach', 'Aspectratio nach');
  Projektfenster_Spracheaendern(Spracheladen);
END;

procedure THauptprogramm.TestBtn1Click(Sender: TObject);
begin
  test := False;
end;

procedure THauptprogramm.TestBtn2Click(Sender: TObject);
begin
  test2 := True;
end;

end.

