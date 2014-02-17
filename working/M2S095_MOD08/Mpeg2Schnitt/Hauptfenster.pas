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

unit Hauptfenster;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MPlayer, ExtCtrls, StdCtrls, ComCtrls, Buttons, Mpeg2Unit, Menus, IniFiles,
  StrUtils,   ActnList, ImgList,
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
  ProjectX, DVD,
{******************************************************************************}
  Fortschritt, Mpeg2Fenster, Mpeg2decoder, Ueber, DirectDraw, Math,
  AppEvnts, DateUtils, Grids, Audioplay, Protokoll, Schnittsuche,
  AllgFunktionen,           // allgemeine Funktionen
  AllgVariablen,            // allgemeine Variablen
  ShellApi,                 // für Drag and Drop
  Sprachen,                 // Sprachdaten laden
  Textanzeigefenster,       // zum Anzeigen von Text
  Dateipuffer,              // zum kopieren eines Audioframes
  Hinweis,                  // für das Hinweisfenster
  Optfenster,               // Optionenfenster
  Arbeitsumgebung,          // Arbeitsumgebungsfenster
  Efffenster,               // Effektfenster
  Ausgfenster,              // Datenbearbeitung
  Clipbrd,                  // Clipboard
  DatenTypen,               // Typdefinitionen
  //GridListe,                // Gitteliste für Schnitt- und Kapitelliste
  XPMan,                    // XP Manifest sorgt für XP typischen Aussehen des Formulars
  AlphaBlend,               // Tasten mit Alphaüberblendung
  Skins,                    // Skinverwaltung
  UndoRedo,                 // Undo / Redo Funktionen
  ThemeHandling,            // Abschalten von Styles für Komponenten
  binaereSuche,             // digitale Suche
  FilmGrobAnsicht;          // Grobansicht

type
  TZeitCode = RECORD
    Stunde : Byte;
    Minute : Byte;
    Sekunde : Byte;
    Bilder : Word;
    Bilder_mSek : Boolean;
  END;

  TDateieintrag = CLASS
  PRIVATE
    Name : STRING;
  END;

  TDateieintragAudio = CLASS(TDateieintrag)
  PRIVATE
    Audiooffset : Integer;
  END;

  TKapitelEintrag = CLASS
  PRIVATE
    Kapitel : Int64;
    Videoknoten : TTreeNode;
    Audioknoten : TTreeNode;
    BilderproSek : Real;
  END;

  TAnzeigeflaeche = CLASS(TWinControl)
  PRIVATE
    PROCEDURE WMPaint(var Message: TWMPaint); message WM_PAINT;
  END;

  TMpegEdit = class(TForm)
    Audioplayer: TMediaPlayer;
    Oeffnen: TOpenDialog;
    Hauptmenue: TMainMenu;
    Datei: TMenuItem;
    Optionen: TMenuItem;
    Speichern: TSaveDialog;
    DateienMenue: TPopupMenu;
    Dateiloeschen: TMenuItem;
    SchnittlisteMenue: TPopupMenu;
    Anzeige: TPanel;
    aktuellerBildtyp: TLabel;
    Videoposition: TLabel;
    Audioposition: TLabel;
    Videolaenge: TLabel;
    Audiolaenge: TLabel;
    Videodatei: TLabel;
    Audiodatei: TLabel;
    ProjektLaden: TMenuItem;
    Projektspeichern_: TMenuItem;
    ProgrammEnde: TMenuItem;
    ProjektNeu: TMenuItem;
    Hilfemenu: TMenuItem;
    Schieberegler: TTrackBar;
    Video_Audio_oeffnen: TMenuItem;
    VideoAudiooeffnen: TMenuItem;
    Dateihinzufuegen: TMenuItem;
    Indexerstellen: TMenuItem;
    Schnittlisteloeschen: TMenuItem;
    Arbeitsumgebungenmenue: TMenuItem;
    Anzeigefenstermenue: TPopupMenu;
    Vollbild: TMenuItem;
    EinszuEins: TMenuItem;
    EinszuZwei: TMenuItem;
    EinszuVier: TMenuItem;
    Videoanzeigegroesse1: TMenuItem;
    Trennlinie3: TMenuItem;
    Maximal: TMenuItem;
    Doppelt: TMenuItem;
    Trennlinie4: TMenuItem;
    EinsFuenfzuEins: TMenuItem;
    EinszuEinsFuenf: TMenuItem;
    Trennlinie2: TMenuItem;
    Stop1: TMenuItem;
    BildNr: TLabel;
    Listen: TPageControl;
    SchnittlistenTab: TTabSheet;
    MarkenlistenTab: TTabSheet;
    Schnittliste: TListBox;
    Trennlinie5: TMenuItem;
    ProjektNeu1: TMenuItem;
    ProjektLaden1: TMenuItem;
    Projektspeichern1: TMenuItem;
    Projektspeichernunter1: TMenuItem;
    ProjektspeichernPlus1: TMenuItem;
    Trennlinie6: TMenuItem;
    Schnittpunkteeinzelnspeichern1: TMenuItem;
    MarkierteSchnittpunktespeichern1: TMenuItem;
    Trennlinie7: TMenuItem;
    Markierungenaufheben1: TMenuItem;
    MarkierteSchnittpunkteloeschen: TMenuItem;
    MarkierteSchnittpunktespeichern: TMenuItem;
    Schnittpunkteeinzelnspeichern: TMenuItem;
    Projektspeichern: TMenuItem;
    Projektspeichernunter: TMenuItem;
    ProjektspeichernPlus: TMenuItem;
    Trennlinie8: TMenuItem;
    Projektspeichernspezial: TMenuItem;
    Projektspeichernspezial1: TMenuItem;
    Vorschaumenue: TPopupMenu;
    Vorschau_neu: TMenuItem;
    MarkenListe: TMemo;
    Sprachmenue: TMenuItem;
    ProjektEinfuegen: TMenuItem;
    ProjektEinfuegen1: TMenuItem;
    Trennlinie12: TMenuItem;
    Schnittpunktformatanpassen: TMenuItem;
    Schnittlisteimportieren: TMenuItem;
    ListenImportseiteMenuItem: TMenuItem;
    ListenExportseiteMenuItem: TMenuItem;
    KapiteltastenMenue: TPopupMenu;
    Kapitelaendern: TMenuItem;
    Trennlinie15: TMenuItem;
    SchnittlistenFormatseiteMenuItem: TMenuItem;
    SchnittlistenFormatseiteMenuItem1: TMenuItem;
    Datei_hinzufuegen: TMenuItem;
    VideoAudioSchnittseite: TMenuItem;
    TastenbelegungSeite: TMenuItem;
    Trennlinie17: TMenuItem;
    SchnittpktAnfangkopieren: TMenuItem;
    NavigationsSeite: TMenuItem;
    ZusatzFunktionenmenue: TMenuItem;
    Schnittesuchen: TMenuItem;
    aktAudioFramespeichern: TMenuItem;
    aktuellesBildspeichern: TMenuItem;
    aktuellesBildkopieren: TMenuItem;
    Trennlinie19: TMenuItem;
    AudioEffekt: TMenuItem;
    VorschauSeite: TMenuItem;
    EffekteSeite: TMenuItem;
    VideoEffekt: TMenuItem;
    Verzeichnisseite: TMenuItem;
    DateinamenEndungenseite: TMenuItem;
    AusgabeSeite: TMenuItem;
    Allgemeinseite: TMenuItem;
    Wiedergabeseite: TMenuItem;
    Vorschau_beenden: TMenuItem;
    KapitellistenTab: TTabSheet;
    KapitelListeGrid: TStringGrid;
    KapitelnameEdit: TEdit;
    KapitellistePopupMenu: TPopupMenu;
    KapitelListeimportierenMenuItem: TMenuItem;
    KapitelListeexportierenMenuItem: TMenuItem;
    KapitelexportierenMenuItem: TMenuItem;
    Trennlinie16: TMenuItem;
    KapitelloeschenMenuItem: TMenuItem;
    KapitelListeloeschenMenuItem: TMenuItem;
    Trennlinie20: TMenuItem;
    KapitelListeMarkierungenaufhebenMenuItem: TMenuItem;
    MenuItem24: TMenuItem;
    KapitelListeZeitformataendernMenuItem: TMenuItem;
    KapitellistenFormatseiteMenuItem1: TMenuItem;
    KapitelausschneidenMenuItem: TMenuItem;
    KapitelkopierenMenuItem: TMenuItem;
    KapiteleinfuegenMenuItem: TMenuItem;
    MarkenListePopupMenu: TPopupMenu;
    MarkenListeimportierenMenuItem: TMenuItem;
    MarkenListeexportierenMenuItem: TMenuItem;
    Trennlinie9: TMenuItem;
    MarkeloeschenMenuItem: TMenuItem;
    MarkenListeloeschenMenuItem: TMenuItem;
    Trennlinie10: TMenuItem;
    MarkenListeMarkierungenaufhebenMenuItem: TMenuItem;
    Trennlinie11: TMenuItem;
    MarkenListeZeitformataendernMenuItem: TMenuItem;
    MarkenlistenFormatseiteMenuItem1: TMenuItem;
    Trennlinie13: TMenuItem;
    MarkenListeRueckgaengigMenuItem: TMenuItem;
    MarkenListeAusschneidenMenuItem: TMenuItem;
    MarkenListeKopierenMenuItem: TMenuItem;
    MarkenListeEinfuegenMenuItem: TMenuItem;
    MarkenListeMarkierungLoeschenMenuItem: TMenuItem;
    Trennlinie14: TMenuItem;
    KapitelverschiebenMenuItem: TMenuItem;
    Trennlinie25: TMenuItem;
    KapitelListeTrennzeileeinfuegenMenuItem: TMenuItem;
    MarkenListeladenMenuItem: TMenuItem;
    MarkenListespeichernMenuItem: TMenuItem;
    MarkenexportierenMenuItem: TMenuItem;
    MarkentastePopupMenu: TPopupMenu;
    MarkeaendernMenuItem: TMenuItem;
    KapiteleinfuegenClpbrdMenuItem: TMenuItem;
    aktVideoknotenNr_: TLabel;
    aktAudioknotenNr_: TLabel;
    Arbeitsumgebungenbearbeiten: TMenuItem;
    Trennlinie21: TMenuItem;
    Trennlinie22: TMenuItem;
    Trennlinie23: TMenuItem;
    KapitellistenFormatseiteMenuItem: TMenuItem;
    MarkenlistenFormatseiteMenuItem: TMenuItem;
    MarkenlisteSchnittpunkteimportierenMenuItem: TMenuItem;
    MarkenListeberechnenexportierenMenuItem: TMenuItem;
    MarkenberechnenexportierenMenuItem: TMenuItem;
    Trennlinie24: TMenuItem;
    KapitelListeSchnitteimportierenMenuItem: TMenuItem;
    KapitelListeberechnenexportierenMenuItem: TMenuItem;
    KapitelberechnenexportierenMenuItem: TMenuItem;
    Audiooffsetms: TLabel;
    AudiooffsetBilder: TLabel;
    Trennlinie26: TMenuItem;
    NurIFrames: TMenuItem;
    keinVideo: TMenuItem;
    InformationenTab: TTabSheet;
    Informationen: TMemo;
    AudioSkewPanel: TPanel;
    AS10th_: TLabel;
    AS1000th_: TLabel;
    AS1000thms_: TLabel;
    AS10thms_: TLabel;
    AS1000th: TTrackBar;
    AS10th: TTrackBar;
    GrobPanel: TPanel;
    Grob1: TLabel;
    Grob2: TLabel;
    FeinPanel: TPanel;
    Fein1: TLabel;
    Fein2: TLabel;
    SymbolleistePanel: TPanel;
    ProjektNeuBtn: TSpeedButton;
    ProjektLadenBtn: TSpeedButton;
    BtnVideoAdd: TSpeedButton;
    Audiooffset_: TLabel;
    AudioOffsetEdit: TEdit;
    AudioOffsetms_: TLabel;
    Bearbeiten: TMenuItem;
    RueckgaengigMenuIntem: TMenuItem;
    WiederherstellenMenuItem: TMenuItem;
    SchnittuebernehmenPanel: TPanel;
    SchnitteinfuegenvorMarkierungBtn: TSpeedButton;
    SchnitteinfuegennachMarkierungBtn: TSpeedButton;
    SchnitteinfuegenamEndeBtn: TSpeedButton;
    SchnittaendernBtn: TSpeedButton;
    Pos0Panel: TPanel;
    Pos0Btn: TSpeedButton;
    EndePanel: TPanel;
    EndeBtn: TSpeedButton;
    ProjektSpeichernBtn: TSpeedButton;
    AllgemeinPopupMenu: TPopupMenu;
    HauptActionList: TActionList;
    VideoAudiooeffnenAction: TAction;
    DateihinzufuegenAction: TAction;
    DateiaendernAction: TAction;
    ProjektneuAction: TAction;
    ProjektspeichernAction: TAction;
    ProjektspeichernunterAction: TAction;
    ProjektspeichernpluseinsAction: TAction;
    ProjektspeichernspezialAction: TAction;
    ProjektladenAction: TAction;
    Projektspeichern2: TMenuItem;
    Projektspeichernunter2: TMenuItem;
    Projektspeichernplus2: TMenuItem;
    Projektladen2: TMenuItem;
    Projektneu2: TMenuItem;
    AudiooffseteinPanel: TPanel;
    DateifenstereinPanel: TPanel;
    AudiooffsetfensterausBtn: TSpeedButton;
    Audiooffsetein_: TLabel;
    Dateifensterein_: TLabel;
    DateienfensterausPanel: TPanel;
    DateienfensterausBtn: TSpeedButton;
    Dateien: TTreeView;
    Dateienfensteraus_: TLabel;
    ProjekteinfuegenAction: TAction;
    Projekteinfuegen2: TMenuItem;
    Dateiaendern: TMenuItem;
    MarkevorhereinfuegenMenuItem: TMenuItem;
    MarkenachhereinfuegenMenuItem: TMenuItem;
    MarkeamEndeeinfuegenMenuItem: TMenuItem;
    KapitelvorhereinfuegenMenuItem: TMenuItem;
    KapitelnachhereinfuegenMenuItem: TMenuItem;
    KapitelamEndeeinfuegenMenuItem: TMenuItem;
    Hilfe: TMenuItem;
    Ueber: TMenuItem;
    Lizenz: TMenuItem;
    SchnittpktEndekopieren: TMenuItem;
    DummyPopupMenu: TPopupMenu;
    SchiebereglermittePanel: TPanel;
    SchiebereglermitteImage: TImage;
    Oberflaechenseite: TMenuItem;
    TastenGrundPanel: TPanel;
    DateienTab: TTabSheet;
    InfoPopupMenu: TPopupMenu;
    InfoAktualisierenMenuItem: TMenuItem;
    Trennlinie27: TMenuItem;
    InfoRueckgaengigMenuItem: TMenuItem;
    InfoAusschneidenMenuItem: TMenuItem;
    InfoKopierenMenuItem: TMenuItem;
    InfoEinfuegenMenuItem: TMenuItem;
    InfoLoeschenMenuItem: TMenuItem;
    ListenTrennPanel: TPanel;
    ListenTrennXPanel: TPanel;
    DateienTrennPanel: TPanel;
    DateienTrennXPanel: TPanel;
    TastenPanel: TPanel;
    Play: TSpeedButton;
    Spieleab: TSpeedButton;
    Spielebis: TSpeedButton;
    VorherigesI: TSpeedButton;
    NaechstesI: TSpeedButton;
    CutIn: TSpeedButton;
    GehezuIn: TSpeedButton;
    VorherigesP: TSpeedButton;
    NaechstesP: TSpeedButton;
    CutOut: TSpeedButton;
    GehezuOut: TSpeedButton;
    Schnittuebernehmen: TSpeedButton;
    SchrittVor: TSpeedButton;
    SchrittZurueck: TSpeedButton;
    Kapitel: TSpeedButton;
    Marke: TSpeedButton;
    Video_: TLabel;
    VideoGr: TLabel;
    AudioGr: TLabel;
    GesamtGr: TLabel;
    Gesamt_: TLabel;
    Audio_: TLabel;
    Gesamtzeit_: TLabel;
    GesamtZeit: TLabel;
    Reserve: TSpeedButton;
    Vorschau: TSpeedButton;
    Schnittpunkteeinzelnschneiden: TSpeedButton;
    MarkierteSchnittpunkte: TSpeedButton;
    nurAudiospeichern: TSpeedButton;
    Schneiden: TSpeedButton;
    TempoPlusBtn: TSpeedButton;
    TempoMinusBtn: TSpeedButton;
    Tempoanzeige_: TLabel;
    TastenTrenner1Panel: TPanel;
    TastenTrenner2Panel: TPanel;
    TastenTrenner3Panel: TPanel;
    TastenTrenner4Panel: TPanel;
    SchnitteausDateienMenuItem: TMenuItem;
    EndePanel1: TPanel;
    EndeBtn1: TSpeedButton;
    Fenstermenue: TMenuItem;
    binaereSucheMenue: TMenuItem;
    GrobansichtMenuItem: TMenuItem;
    FilmGrobansichtMenuItem: TMenuItem;
    AudiooffsetMenuItem: TMenuItem;
    ZweiFensterMenuItem: TMenuItem;
    VideoImage: TImage;
    StandbildPositionZeit: TLabel;
    StandbildPositionFrame: TLabel;
    CutPopupMenu: TPopupMenu;
    CutItemIndex: TMenuItem;
    SchnittToolItemIndex: TMenuItem;
    Cut1ItemIndex: TMenuItem;
    GrobansichtSeite: TMenuItem;
    letzteProjekte: TMenuItem;
    letztesProjekt: TMenuItem;
    letzteProjekte2: TMenuItem;
    letztesProjekt2: TMenuItem;
    VideoAudioPopupMenu: TPopupMenu;
    Video_Audio_oeffnen1: TMenuItem;
    Datei_hinzufuegen1: TMenuItem;
    letzteVerzeichnisse1: TMenuItem;
    letztesVerzeichnis1: TMenuItem;
    letzteVerzeichnisse: TMenuItem;
    letztesVerzeichnis: TMenuItem;
    Trennlinie28: TMenuItem;
    GOPssuchenMenuItem: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Video_oeffnenClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NaechstesIClick(Sender: TObject);
    procedure VorherigesIClick(Sender: TObject);
    procedure VorherigesPClick(Sender: TObject);
    procedure NaechstesPClick(Sender: TObject);
    procedure CutInClick(Sender: TObject);
    procedure CutOutClick(Sender: TObject);
    procedure SchnittListeDblClick(Sender: TObject);
    procedure GehezuInClick(Sender: TObject);
    procedure GehezuOutClick(Sender: TObject);
    procedure SchneidenClick(Sender: TObject);
    procedure DateiloeschenClick(Sender: TObject);
    procedure DateienClick(Sender: TObject);
    procedure SchnittListeClick(Sender: TObject);
    procedure ProjektspeichernClick(Sender: TObject);
    procedure ProjektLadenClick(Sender: TObject);
    procedure ProjektNeuClick(Sender: TObject);
    procedure ProgrammEndeClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ProjektspeichernunterClick(Sender: TObject);
    procedure IndexerstellenClick(Sender: TObject);
    procedure DateihinzufuegenClick(Sender: TObject);
    procedure SchnittlisteloeschenClick(Sender: TObject);
    procedure SchnittpunkteinfuegenClick(Sender: TObject);
    procedure VollbildClick(Sender: TObject);
    procedure EinszuEinsClick(Sender: TObject);
    procedure EinszuZweiClick(Sender: TObject);
    procedure EinszuVierClick(Sender: TObject);
    procedure MaximalClick(Sender: TObject);
    procedure DoppeltClick(Sender: TObject);
    procedure DateienfensterMenuePopup(Sender: TObject);
    procedure EinsFuenfzuEinsClick(Sender: TObject);
    procedure EinszuEinsFuenfClick(Sender: TObject);
    procedure ProjektspeichernPlusClick(Sender: TObject);
    procedure MarkierungaufhebenClick(Sender: TObject);
    procedure SchnittListeStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SchnittListeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SchnittListeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SchnittListeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure SchnittListeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SchnittpunkteeinzelnspeichernClick(Sender: TObject);
    procedure MarkierteSchnittpunktespeichernClick(Sender: TObject);
    procedure ProjektspeichernspezialClick(Sender: TObject);
    procedure MarkierteSchnittpunkteloeschenClick(Sender: TObject);
    procedure VorschauClick(Sender: TObject);
    procedure VorschaumenuePopup(Sender: TObject);
    procedure Vorschau_neuClick(Sender: TObject);
    procedure MarkenListeexportierenMenuItemClick(Sender: TObject);
    procedure MarkenListeimportierenMenuItemClick(Sender: TObject);
    procedure MarkenListeDblClick(Sender: TObject);
    procedure MarkenListeloeschenMenuItemClick(Sender: TObject);
    procedure MarkenListePopupMenuPopup(Sender: TObject);
    procedure SchnittlisteMenuePopup(Sender: TObject);
    procedure Projektspeichern_Click(Sender: TObject);
    procedure SchnittesuchenClick(Sender: TObject);
    procedure SchrittVorClick(Sender: TObject);
    procedure SchrittZurueckClick(Sender: TObject);
    procedure MarkenListeZeitformataendernMenuItemClick(Sender: TObject);
    procedure ProjektEinfuegenClick(Sender: TObject);
    procedure DateiClick(Sender: TObject);
    procedure aktAudioFramespeichernClick(Sender: TObject);
    procedure SchnittpunktformatanpassenClick(Sender: TObject);
    procedure MarkenListeClick(Sender: TObject);
    procedure MarkeloeschenMenuItemClick(Sender: TObject);
    procedure SchnittlisteimportierenClick(Sender: TObject);
    procedure OptionenfensterClick(Sender: TObject);
    procedure KapitelaendernClick(Sender: TObject);
    procedure KapiteltastenMenuePopup(Sender: TObject);
    procedure MarkenListeMarkierungenaufhebenMenuItemClick(Sender: TObject);
    procedure KapitelClick(Sender: TObject);
    procedure SchnittlisteDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure DateienEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure DateienEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure OffseteingabeEnter(Sender: TObject);
    procedure SpielebisClick(Sender: TObject);
    procedure SpieleabClick(Sender: TObject);
    procedure AnzeigeflaecheClick(Sender: TObject);
    procedure AnzeigeflaecheDblClick(Sender: TObject);
    procedure SchnittpktAnfangkopierenClick(Sender: TObject);
    procedure MarkenListeEnter(Sender: TObject);
    procedure MarkenListeExit(Sender: TObject);
    procedure MarkenListeRueckgaengigMenuItemClick(Sender: TObject);
    procedure MarkenListeAusschneidenMenuItemClick(Sender: TObject);
    procedure MarkenListeKopierenMenuItemClick(Sender: TObject);
    procedure MarkenListeEinfuegenMenuItemClick(Sender: TObject);
    procedure MarkenListeMarkierungLoeschenMenuItemClick(Sender: TObject);
    procedure ZusatzFunktionenmenueClick(Sender: TObject);
    procedure aktuellesBildspeichernClick(Sender: TObject);
    procedure aktuellesBildkopierenClick(Sender: TObject);
    procedure AudioEffektClick(Sender: TObject);
    procedure VideoEffektClick(Sender: TObject);
    procedure AnzeigefenstermenuePopup(Sender: TObject);
    procedure Videoanzeigegroesse1Click(Sender: TObject);
    procedure ArbeitsumgebungenMenueClick(Sender: TObject);
    procedure Vorschau_beendenClick(Sender: TObject);
    procedure KapitelListeGridDblClick(Sender: TObject);
    procedure KapitelnameEditKeyPress(Sender: TObject; var Key: Char);
    procedure KapitelnameEditExit(Sender: TObject);
    procedure KapitelListeGridEnter(Sender: TObject);
    procedure KapitelListeGridClick(Sender: TObject);
    procedure KapitelListeGridDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure KapitelListeGridDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure KapitelListeGridEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure KapitelListeGridStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure KapitelverschiebenMenuItemClick(Sender: TObject);
    procedure KapitelListeGridExit(Sender: TObject);
    procedure KapitelnameEditEnter(Sender: TObject);
    procedure KapitelListeGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure KapitelListeGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure KapitelloeschenMenuItemClick(Sender: TObject);
    procedure KapitelListeloeschenMenuItemClick(Sender: TObject);
    procedure KapitelausschneidenMenuItemClick(Sender: TObject);
    procedure KapitelkopierenMenuItemClick(Sender: TObject);
    procedure KapiteleinfuegenMenuItemClick(Sender: TObject);
    procedure KapitellistePopupMenuPopup(Sender: TObject);
    procedure KapitelListeMarkierungenaufhebenMenuItemClick(Sender: TObject);
    procedure KapitelListeTrennzeileeinfuegenMenuItemClick(Sender: TObject);
    procedure KapitelListeimportierenMenuItemClick(Sender: TObject);
    procedure KapitelListeexportierenMenuItemClick(Sender: TObject);
    procedure KapitelexportierenMenuItemClick(Sender: TObject);
    procedure KapitelListeZeitformataendernMenuItemClick(Sender: TObject);
    procedure KapitelListeGridDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure MarkenListeladenMenuItemClick(Sender: TObject);
    procedure MarkenListespeichernMenuItemClick(Sender: TObject);
    procedure MarkenexportierenMenuItemClick(Sender: TObject);
    procedure MarkeClick(Sender: TObject);
    procedure MarkeaendernMenuItemClick(Sender: TObject);
    procedure MarkentastePopupMenuPopup(Sender: TObject);
    procedure MarkenListeChange(Sender: TObject);
    procedure DateienEnter(Sender: TObject);
    procedure DateienExit(Sender: TObject);
    procedure InformationenEnter(Sender: TObject);
    procedure InformationenExit(Sender: TObject);
    procedure SchnittlisteEnter(Sender: TObject);
    procedure SchnittlisteExit(Sender: TObject);
    procedure KapiteleinfuegenClpbrdMenuItemClick(Sender: TObject);
    procedure DateienDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DateienDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DateienEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure DateienStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure DateienKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArbeitsumgebungenbearbeitenClick(Sender: TObject);
    procedure SprachenMenueClick(Sender: TObject);
    procedure MarkenlisteSchnittpunkteimportierenMenuItemClick(
      Sender: TObject);
    procedure MarkenListeberechnenexportierenMenuItemClick(
      Sender: TObject);
    procedure MarkenberechnenexportierenMenuItemClick(Sender: TObject);
    procedure KapitelListeSchnitteimportierenMenuItemClick(
      Sender: TObject);
    procedure KapitelberechnenexportierenMenuItemClick(Sender: TObject);
    procedure NurIFramesClick(Sender: TObject);
    procedure keinVideoClick(Sender: TObject);
    procedure ASChange(Sender: TObject);
    procedure AudioOffsetEditExit(Sender: TObject);
    procedure AudioOffsetEditKeyPress(Sender: TObject; var Key: Char);
    procedure AudioOffsetEditEnter(Sender: TObject);
    procedure Pos0BtnClick(Sender: TObject);
    procedure EndeBtnClick(Sender: TObject);
    procedure BearbeitenClick(Sender: TObject);
    procedure RueckgaengigMenuIntemClick(Sender: TObject);
    procedure WiederherstellenMenuItemClick(Sender: TObject);
    procedure SchnittuebernehmenMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SchnitteinfuegenvorMarkierungBtnClick(Sender: TObject);
    procedure SchnitteinfuegenamEndeBtnClick(Sender: TObject);
    procedure SchnittaendernBtnClick(Sender: TObject);
    procedure SchnitteinfuegennachMarkierungBtnClick(Sender: TObject);
    procedure DateienlisteEinAusBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SchnittlisteMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SchnittoptionenClick(Sender: TObject);
    procedure AudiooffsetfensterausBtnClick(Sender: TObject);
    procedure Dateifensterein_Click(Sender: TObject);
    procedure Audiooffsetein_Click(Sender: TObject);
    procedure Dateifensterein_MouseEnter(Sender: TObject);
    procedure Dateifensterein_MouseLeave(Sender: TObject);
    procedure Audiooffsetein_MouseEnter(Sender: TObject);
    procedure Audiooffsetein_MouseLeave(Sender: TObject);
    procedure DateienfensterausBtnClick(Sender: TObject);
    procedure AllgemeinPopupMenuPopup(Sender: TObject);
    procedure DateiaendernClick(Sender: TObject);
    procedure MarkevorhereinfuegenMenuItemClick(Sender: TObject);
    procedure MarkenachhereinfuegenMenuItemClick(Sender: TObject);
    procedure MarkeamEndeeinfuegenMenuItemClick(Sender: TObject);
    procedure KapitelvorhereinfuegenMenuItemClick(Sender: TObject);
    procedure KapitelnachhereinfuegenMenuItemClick(Sender: TObject);
    procedure KapitelamEndeeinfuegenMenuItemClick(Sender: TObject);
    procedure AnzeigeClick(Sender: TObject);
    procedure VAGroessePanelClick(Sender: TObject);
    procedure VorschauSchneidenPanelClick(Sender: TObject);
    procedure AudioSkewPanelClick(Sender: TObject);
    procedure UeberClick(Sender: TObject);
    procedure HilfeClick(Sender: TObject);
    procedure HilfemenuClick(Sender: TObject);
    procedure SchnittpktEndekopierenClick(Sender: TObject);
    procedure AudiooffsetfensterkleinBtnClick(Sender: TObject);
    procedure ListenverschiebePanelMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ListenverschiebePanelMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DateienTrennPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DateienTrennPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SchiebereglerEnter(Sender: TObject);
    procedure ListenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TempoPlusBtnClick(Sender: TObject);
    procedure TempoMinusBtnClick(Sender: TObject);
    procedure Tempoanzeige_Click(Sender: TObject);
    procedure InfoRueckgaengigMenuItemClick(Sender: TObject);
    procedure InfoAusschneidenMenuItemClick(Sender: TObject);
    procedure InfoKopierenMenuItemClick(Sender: TObject);
    procedure InfoEinfuegenMenuItemClick(Sender: TObject);
    procedure InfoLoeschenMenuItemClick(Sender: TObject);
    procedure InfoAktualisierenMenuItemClick(Sender: TObject);
    procedure InfoPopupMenuPopup(Sender: TObject);
    procedure ListenTrennPanelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DateienTrennPanelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SchnitteausDateienMenuItemClick(Sender: TObject);
    procedure binaereSucheMenueClick(Sender: TObject);
    procedure FenstermenueClick(Sender: TObject);
    procedure GrobansichtMenuItemClick(Sender: TObject);
    procedure FilmGrobansichtMenuItemClick(Sender: TObject);
    procedure ZweiFensterMenuItemClick(Sender: TObject);
    procedure StandbildPositionZeitDblClick(Sender: TObject);
    procedure SchnittToolItemIndexClick(Sender: TObject);
    procedure Cut1ItemIndexClick(Sender: TObject);
    procedure letzteProjekteClick(Sender: TObject);
    procedure letztesProjektClick(Sender: TObject);
    procedure letzteVerzeichnisseClick(Sender: TObject);
    procedure letztesVerzeichnisClick(Sender: TObject);
    procedure GOPssuchenMenuItemClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Player : Byte;
    VideoListe,
    IndexListe,
    AudioListe : TListe;
    PositionIn,
    PositionOut : Int64;
    aktVideodatei,
    aktAudiodatei : STRING;
    aktVideoKnoten,
    aktAudioKnoten : TTreeNode;
    Schiebereglerfaktor : Real;
    SchiebereglerMax : Int64;
    SchiebereglerPosition : Int64;
    StandBildPosition : Int64;
    SchiebereglerPosition_merken,
    SpieleVonBisPosition : Int64;
    SequenzHeader : TSequenzHeader;
    BildHeader : TBildHeader;
    AudioHeader : TAudioHeader;
//    Bilderzahl : Int64;
    Audiozahl : Int64;
    Schrittweite : Integer;
    Dateilistegeaendert : Boolean;
    Schnittlistegeaendert : Boolean;
    Kapitellistegeaendert : Boolean;
    Effektgeaendert : Boolean;
    Markenlistegeaendert : Boolean;
//    Bildlaenge,
//    BilderProSek : Real;
    Tastegedrueckt : Integer;
    Schnittpunktbewegen,
    SchnittpunktbewegenCount : Integer;
    DateienListeDragDrop : Boolean;
    KapitelListeDragDrop : Boolean;
    KapitelListeKopieren : Boolean;
    KapitelkopierenListe : TListe;
    Audiooffset : PInteger;
    AudiooffsetNull : Integer;
    Projektname : STRING;
    VorschauListe,
    VorschauIndexListe,
    VorschauAudioListe : TListe;
    VorschauSequenzHeader : TSequenzHeader;
    VorschauBildHeader : TBildHeader;
    VorschauAudioHeader : TAudioHeader;
    VorschauVideoknoten,
    VorschauAudioknoten,
    Vorschauknoten : TTreeNode;
    VorschauDateiname1,
    VorschauDateiname2 : STRING;
    VorschauPositionOut,
    VorschauPositionIn : Int64;
    Vorschauneuberechnen : Boolean;
    VorschauPosition : Integer;
    VorschauSchiebereglerMarkerPosition : Integer;
    Anzeigeflaeche : TAnzeigeflaeche;
    Bildflaeche : TAnzeigeflaeche;
    FensterStyle : LongInt;
    ZielDateinameCLaktiv : Boolean;
    ZielDateinameCL : STRING;
    FramegenauschneidenCLaktiv : Boolean;
    FramegenauschneidenCL : Boolean;
    gleichSchneidenCL : Boolean;
    nachSchneidenbeendenCL : Boolean;
    nachSchneidenbeendet : Boolean;
    letztesVideoanzeigenCLaktiv : Boolean;
    letztesVideoanzeigenCL : Boolean;
    aktArbeitsumgebungCLaktiv : Boolean;
    Infofensteraktiv,
    Schnittlisteaktiv,
    Kapitellisteaktiv,
    Markenlisteaktiv,
    Dateienfensteraktiv,
    SchnittlistenEditaktiv,
    KapitellistenEditaktiv,
    DateienfensterEditaktiv,
    OffsetEditaktiv{,
    Dialogaktiv }: Boolean;
    Mausposition : TPoint;
    Dateienfensterhoehe : Integer;
    AudioTimer : TTimer;
    AbspielModus : Boolean;
    SchiebereglerMarkerPosition : Integer;
    ListenTabIndex : Integer;
    VideoGroesse,              // global für "Speicherplatz_pruefen"
    AudioGroesse : Int64;
    GrosseGOPs,                // Dateieigenschaften
    Videodateilaenge,
    Bitrate : STRING;
    PROCEDURE AudioTimerTimer(Sender: TObject);
    PROCEDURE Parameterlesen;
    FUNCTION Ereignisbearbeiten: Boolean;
    FUNCTION Schnittpunktmoeglich(Pos: Int64): Integer;
    PROCEDURE Cutmoeglich(Pos: Int64);
    PROCEDURE Bildeinpassen(Faktor: Real);
    FUNCTION Schnitteinfuegenmoeglich: Boolean;
    FUNCTION Schnittaendernmoeglich: Boolean;
    FUNCTION SchnitteinfMarkmoeglich: Boolean;
    FUNCTION Schneidenmoeglich: Boolean;
    FUNCTION Vorschaumoeglich: Boolean;
    FUNCTION VideoDateiaktualisieren(VideoName: STRING; Liste, IndexListe: TListe;
                                     SequenzHeader: TSequenzHeader; BildHeader: TBildHeader): Integer;
    FUNCTION Audiodateiaktualisieren(AudioName: STRING; AudioListe: TListe;
                                     AudioHeader: TAudioHeader): Integer;
    PROCEDURE Schiebereglerlaenge_einstellen;
    PROCEDURE Schieberegleraktualisieren;
    FUNCTION Schnittpunktfuellen(Schnitt : TSchnittpunkt; Videoknoten, Audioknoten: TTreeNode; PositionIn, PositionOut: Int64; BilderProsek: Real; Liste, IndexListe: TListe): Integer;
    PROCEDURE Schnittpunktaendern;
    FUNCTION Schnitteinfuegen(Listenpunkt: TSchnittpunkt; Text: STRING; Art: Integer): Integer;
    PROCEDURE Schnittpunkteinfuegen(Art: Integer);
    PROCEDURE SchnittpunktListeeinfuegen_akt(SchnittpunktListe: TListe);
    PROCEDURE Schnittpunktanzeigeloeschen;
    PROCEDURE Schnittpunktanzeigekorrigieren;
    FUNCTION SchnittgroesseberechnenVideoaktiv(Liste, IndexListe: TListe; Anfangsbild, Endbild: Int64): Int64;
    FUNCTION SchnittgroesseberechnenVideo(Videoname: STRING; Anfangsbild, Endbild: Int64): Int64;
    FUNCTION SchnittgroesseberechnenVideo_Knoten(Knoten: TTreeNode; Anfangsbild, Endbild: Int64; HListe: TListe = NIL; HIndexListe: TListe = NIL): Int64;
    FUNCTION SchnittgroesseberechnenVideo_akt(Anfangsbild, Endbild: Int64): Int64;
    PROCEDURE SchnittgroesseNeuberechnenVideo(Knoten: TTreeNode);
    FUNCTION SchnittgroesseberechnenAudioaktiv(AudioHeader : TAudioHeader; Anfangsbild, Endbild: Int64; Bildlaenge: Real): Int64;
    FUNCTION SchnittgroesseberechnenAudio(Audioname: STRING; Anfangsbild, Endbild: Int64; Bildlaenge: Real): Int64;
    FUNCTION SchnittgroesseberechnenAudio_Knoten(Knoten: TTreeNode; Anfangsbild, Endbild: Int64; Framerate: Real): Int64;
    FUNCTION SchnittgroesseberechnenAudio_akt(Anfangsbild, Endbild: Int64): Int64;
    PROCEDURE SchnittgroesseNeuberechnenAudio(Knoten: TTreeNode);
    PROCEDURE SchnittgroesseNeuberechnenAudiokomplett;
    PROCEDURE Dateigroesse;
    FUNCTION Schnittpunktevorhanden(Knoten: TTreeNode): Integer;
    PROCEDURE Schnittpunkteloeschen(Knoten: TTreeNode);
    PROCEDURE Schnittpunkt_loeschen(SchnittPkt: Integer);
    PROCEDURE Schnittpunkt_kopieren(Quelle, Ziel: TSchnittpunkt);
    PROCEDURE SchnittListe_loeschen;
    PROCEDURE SchnittListeFormat;
    FUNCTION SchnittlisteersteZeile: Integer;
    FUNCTION SchnittlisteletzteZeile: Integer;
    FUNCTION Audioplayerlaeuft: Boolean;
    FUNCTION AudioplayerPositionPlusOffset: Int64;
    PROCEDURE Positionsanzeige(VAR Position: Int64);
//    PROCEDURE AbspielenStoppen;
    PROCEDURE Anzeigeaktualisieren(Pos: Int64);
    PROCEDURE GehezuVideoPosition(Position: Int64);
    PROCEDURE SetzeAbspielModus(Modus: Boolean = False);
    PROCEDURE PlayerPause;
    PROCEDURE Pause;
    PROCEDURE PlayerStart;
    PROCEDURE Abspielen;
    PROCEDURE Stoppen;
    PROCEDURE AbspielenClick;
    PROCEDURE Abspielengedrueckt;
    PROCEDURE Spielebisgedrueckt;
    PROCEDURE Spieleabgedrueckt;
    PROCEDURE Temposetzen(Mode: Integer);
    PROCEDURE Videodateieigenschaften;
    PROCEDURE Eigenschaftenanzeigen;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
//    PROCEDURE AlleNachrichten(var Msg: TMsg; var Handled: Boolean);
{******************************************************************************}
    PROCEDURE AudioOffsetAnzeige_aendern;
    PROCEDURE AudiooffsetNeu(Offset: PInteger);
    PROCEDURE AudiooffsetAus;
    PROCEDURE KnotenpunktDatenloeschen(Knoten: TTreenode);
    PROCEDURE Dateienlisteloeschen;
    FUNCTION DateienlisteneintragAudio_vorhandenKnoten(Knoten: TTreeNode; Audioname : STRING): Boolean;
    FUNCTION DateienlisteneintragAudio_suchenKnoten(Knoten: TTreeNode; Audioname : STRING): TTreeNode;
    FUNCTION DateienlisteHauptknotenNr(Knoten: TTReeNode; Knotenzahl: Boolean = False): Integer;
    PROCEDURE DateienlisteHauptknotenNrneuschreiben;
    FUNCTION DateienlisteKnotenStrukturerzeugen(Knotenname : STRING): TTReeNode;
    PROCEDURE DateienlisteKnotenerzeugenAudio;
    FUNCTION DateienlisteEintrageinfuegenVideo(Knoten: TTreeNode; Videoname : STRING): TTReeNode;
    FUNCTION ExtractAudioendungSpur(Spur: Integer; Liste: TStrings): STRING;
    FUNCTION ExtractVideoendungSpur(Liste: TStrings): STRING;
    FUNCTION DateienlisteEintrageinfuegenAudio(Knoten: TTreeNode; Audioname : STRING; Audiooffset: Integer; Spur: Integer = -1): TTReeNode;
    FUNCTION aktAudiospursuchen(Knoten: TTreeNode; Standard: Boolean = True): Integer;
    FUNCTION AktivenAudioknotensuchen(Knoten: TTreeNode): TTreeNode;
    FUNCTION DateigeoeffnetVideo(Knoten: TTreeNode): Boolean;
    FUNCTION DateigeoeffnetAudio(Knoten: TTreeNode; Spur: Integer): Boolean;
    FUNCTION KnotenhatDaten(Knoten: TTreeNode): Boolean;
    FUNCTION KnotenDatengleich(Knoten1, Knoten2: TTreeNode): Boolean;
    FUNCTION KnotenDatengleichVideo(Knoten1, Knoten2: TTreeNode): Boolean;
    FUNCTION KnotenDatengleichAudio(Knoten1, Knoten2: TTreeNode): Boolean;
    FUNCTION KnotenDateigleich(Knoten1, Knoten2: TTreeNode): Integer;
    FUNCTION DateilisteaktualisierenVideo(Videoknoten: TTreeNode; Listebehalten: Boolean; Positioneinstellen: Boolean = True): Integer;
    FUNCTION DateilisteaktualisierenAudio(Audioknoten: TTreeNode; Listebehalten: Boolean; Positioneinstellen: Boolean = True): Integer;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
//    FUNCTION Dateilisteaktualisieren(Knoten: TTreeNode; Positioneinstellen: Boolean = True): Integer;
{******************************************************************************}
    PROCEDURE Videoeinschalten;
    PROCEDURE Videoausschalten;
    PROCEDURE Videoumschalten;
    PROCEDURE nurIFramesabspielen;
    FUNCTION DateinameausKnoten(Knoten1, Knoten2: TTreeNode): STRING;
    FUNCTION KnotennameausKnoten(Knoten1, Knoten2: TTreeNode): STRING;
    FUNCTION AudioDateitypelesen(Audiodatei: STRING): Byte;
    FUNCTION DateienlisteVideopruefen(Liste: TStrings): Integer;
    FUNCTION DateienlisteAudiopruefen(Liste: TStrings): Integer;
    FUNCTION Videoliste_fuellen(SchnittpunktListe: TStrings): Integer;
    FUNCTION Audioliste_fuellen(SchnittpunktListe: TStrings; Spur: Integer): Integer;
    FUNCTION Audioendungszaehler(SchnittpunktListe: TStrings; Audiozaehler: Integer): Integer;
    FUNCTION Dateinamenliste: STRING;
    FUNCTION Knotenadresse(Knotenindex: Integer): TTreeNode;
    FUNCTION GleichenKnotensuchen(Knoten: TTreeNode): TTreeNode;
    PROCEDURE SchnittpunktBildereinfuegen(Schnittpunkt: TSchnittpunkt; VAR HVideoname: STRING; HListe, HIndexliste: TListe);
    FUNCTION Projektdateieinfuegen(Name: STRING; aktDateien_anzeigen, Projekt_einfuegen: Boolean): Integer;
    FUNCTION Projekteinfuegen_anzeigen(Name: STRING; aktDateien_anzeigen: Boolean): Integer;
    PROCEDURE ProjektinDateispeichern(Name: STRING; SchnittpunktListe: TStrings; Alle: Boolean; Vorschau : Integer = -1);
    PROCEDURE Projektmerken(Name: STRING);
    PROCEDURE Verzeichnismerken(Name: STRING);
    PROCEDURE Projektgeaendert_setzen(Modus: Integer);
    FUNCTION Projekt_geaendert: Boolean;
    FUNCTION Projekt_geaendertX: Boolean;
    PROCEDURE Projektgeaendert_zuruecksetzen;
    FUNCTION BMPBildlesen(Position: Int64; Weite: Integer; Positionwiederherstellen, IFrame: Boolean): TBitmap;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
//    PROCEDURE SchiebereglerPosition_setzen(Pos: Int64; verwendeUndo: Boolean = False);
{******************************************************************************}
    PROCEDURE SchiebereglerPosition_setzen_Stop_Start(Pos: Int64; verwendeUndo: Boolean = False);
    PROCEDURE SchiebereglerMax_setzen(Pos: Int64);
    PROCEDURE SchiebereglerSelStart_setzen(Pos: Int64);
    PROCEDURE SchiebereglerSelEnd_setzen(Pos: Int64);
    PROCEDURE Tastenbeschriftung(Taste: TSpeedButton; Teil1, Teil2: STRING);
    PROCEDURE SetSelectionLength;
    PROCEDURE SetPositionIn(Pos: Int64; verwendeUndo: Boolean = False);
    PROCEDURE SetPositionOut(Pos: Int64; verwendeUndo: Boolean = False);
    PROCEDURE Wiederherstellen(Sender: TObject);
    PROCEDURE Minimieren(Sender: TObject);
    PROCEDURE Arbeitsumgebung_aktivClick(Sender: TObject);
    FUNCTION ExtractAudioendung(Name: STRING; Dateiname: Boolean = False): STRING;
    PROCEDURE Fenstergroesse(Links, Oben, Breite, Hoehe: Integer);
    PROCEDURE Fenstergroesseanpassen(Faktor: Real);
    FUNCTION LaufwerksInfo(Laufwerk: Char): Integer;
    FUNCTION Speicherplatz_pruefen(Name: STRING; SchnittpunktListe: TStrings): Boolean;
    FUNCTION ListeSchneidenVideo(Name: STRING; SchnittpunktListe: TStrings; MuxListe: TStrings): Integer;
    FUNCTION ListeSchneidenAudio(Name: STRING; Spur: Integer; SchnittpunktListe: TStrings; MuxListe: TStrings): Integer;
    PROCEDURE ListeSchneiden(Name: STRING; SchnittpunktListe: TStrings; MuxListe: TStrings);
    FUNCTION Videodateieinfuegen(Dateiname: STRING): Integer;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
//    FUNCTION Dateilisteeinfuegen(Dateinamen: TStringList): Integer;
{******************************************************************************}
    PROCEDURE Video_oeffnen(Verzeichnis: STRING; Video: Boolean = False; Audio: Boolean = False);
    FUNCTION AudiodateieinfuegenKnoten(Knotenpunkt: TTreenode; Dateiname: STRING): Integer;
    FUNCTION Audiodateieinfuegen(Dateiname: STRING): Integer;
    PROCEDURE Drag_Drop(var Msg: TMsg);
    PROCEDURE Ausgabe(AusgabeListe, KapitelListe: TStrings);
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
    PROCEDURE SpracheeinlesenClick(Sender: TObject);
    FUNCTION SchnittpunkteinfuegenCL(SchnittpunktIn, SchnittpunktOut: STRING): Integer;
    PROCEDURE VideoBildanzeigesetzen;
    PROCEDURE SchnittlisteHauptknotenNrneuschreiben;
    FUNCTION SchnittpunktFormatberechnen(Anfang, Ende: Integer; BilderProsek: Real): STRING;
    PROCEDURE aktAudiodateiloeschen;
    PROCEDURE aktVideodateiloeschen;
    PROCEDURE aktDateienloeschen;
    FUNCTION Schnittliste_importieren(Name: STRING): Integer;
    FUNCTION Schnittpunktanzeige_berechnen(Index1, Index2: Integer): Integer;
    FUNCTION Schnittpunktberechnen(Schnittpunkt: TSchnittpunkt;  IndexListe: TListe): Integer;
    PROCEDURE Arbeitsumgebung_lesen;
    PROCEDURE Rueckgabeparameter_lesen;
    FUNCTION Dateinamebilden(Verzeichnis, Dateiname: STRING; QuellVerzeichnisverwenden: Boolean = False; KapitelListeverwenden: Boolean = False): STRING;
    FUNCTION Projekt_speichern(Dateiname: STRING): Integer;
    FUNCTION Projekt_speichernneu: Integer;
    FUNCTION Projekt_speichernunter: Integer;
    PROCEDURE Vorschaubeenden;
    PROCEDURE Vorschauknotenloeschen;
    PROCEDURE Effektkopieren(Audio: Boolean);
    FUNCTION Textlaengeberechnen(Text: STRING; Breite: Integer): STRING;
    PROCEDURE SchiebereglerMarkersetzen(Position: Integer);
    PROCEDURE Fenstereinstellen;
    PROCEDURE Fensterpositionmerken;
    PROCEDURE Fensteranzeigemerken;
    PROCEDURE Kapitelspaltenbreitemerken;
    PROCEDURE Fortschrittsfensteranzeigen;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
//    PROCEDURE Fortschrittsfensterverbergen;
{******************************************************************************}
    PROCEDURE ListeTabIndexspeichern;
    PROCEDURE Infoaktualisieren;
    PROCEDURE InfoaktualisierenVideo;
    PROCEDURE InfoaktualisierenAudio;
    PROCEDURE AllesEinAusschalten(Ein: Boolean = True);
// ------- Dateienliste ---------------
    PROCEDURE DateienListeInit;
    FUNCTION DateienListeAudioKnotenverschiebenKnoten(Quelle, Ziel: Integer; Knoten: TTreeNode): Integer;
    FUNCTION DateienListeAudioKnotenverschieben(Quelle, Ziel: Integer): Integer;
// ------- Kapitelliste ---------------
    PROCEDURE KapitelListeInit;
    PROCEDURE KapitelListeFormat;
    PROCEDURE KapitelListeSpracheaendern(Spracheladen: TSprachen);
    PROCEDURE KapitelListeFormatspeichern;
    PROCEDURE KapitelListeClose;
    PROCEDURE KapitelListeVerschiebemodus(aktiv: Boolean);
    PROCEDURE KapitelListeZeilenberechnen;
    FUNCTION Kapiteleintragkopieren(Kapiteleintrag : TKapiteleintrag): TKapiteleintrag;
    PROCEDURE KapitelkopierenListeloeschen;
    PROCEDURE KapitelkopierenListekopieren(Anfang, Ende: Integer);
    PROCEDURE KapitelListekopierenClipboard;
    PROCEDURE KapitelListeeinfuegenClipboard;
    FUNCTION KapitelListeEinfuegePosition: Integer;
    FUNCTION KapitelListeZeileverschieben(Quelle, Ziel: Integer): Integer;
    FUNCTION KapitelListeZeilenverschieben(Quelle, Ziel, Anzahl: Integer): Integer;
    FUNCTION KapitelListeZeileKopieren(Quelle, Ziel: Integer): Integer;
    FUNCTION KapitelListeZeilenKopieren(Quelle, Ziel, Anzahl: Integer): Integer;
    FUNCTION KapitelListeZeileeinfuegen(Zeile: TStrings; Position: Integer; Datenkopieren: Boolean): Integer;
    FUNCTION KapitelListeZeileeinfuegen1(Kapitel, Position: Integer; BilderProSek: Real; VideoKnoten, AudioKnoten: TTreeNode; Kapitelname: STRING): Integer;
    FUNCTION KapitelListeZeileneinfuegen(Zeilen: TListe; Position: Integer; Datenkopieren: Boolean): Integer;
    FUNCTION KapitelListeZeileaendern1(Kapitel, Position: Integer; BilderProSek: Real; VideoKnoten, AudioKnoten: TTreeNode; Kapitelname: STRING): Integer;
    FUNCTION KapitelListeTrennzeileeinfuegen(Position: Integer; Name: STRING): Integer;
    FUNCTION KapitelListeZeilenloeschen(Anfang, Ende: Integer): Integer;
    PROCEDURE KapitelListeloeschen;
    FUNCTION KapitelListeMarkierungsetzen(Links, Oben, Rechts, Unten: Integer): Integer;
    FUNCTION KapitelListeMarkierungPlus(Anzahl: Integer): Integer;
    FUNCTION KapitelListeKapitelexportieren(Dateiname: STRING; Anfang, Ende: Integer): Integer;
    FUNCTION KapitellisteKapitelimportieren(Name: STRING; Position: Integer): Integer;
    PROCEDURE KapitellisteHauptknotenNrneuschreiben;
    FUNCTION KapitelEintraegevorhanden(Knoten: TTreeNode): Integer;
    PROCEDURE KapitelEintraegeloeschen(Knoten: TTreeNode);
    FUNCTION KapitelListeSchnittpunkteimportieren(Position: Integer): Integer;
    FUNCTION KapitellisteKapitelberechnen(Name: STRING; Anfang, Ende: Integer; SchnittpunktListe, Liste: TStrings): Integer;
    FUNCTION KapitellisteListespeichern(Name: STRING; Liste: TStrings): Integer;
// ------- Markenliste ---------------
    FUNCTION TextfenstermarkierteZeile(Textfenster: TMemo): Integer;
    PROCEDURE TextfensterSelektbereich(Textfenster: TMemo; VAR Anfang, Ende: Integer);
    PROCEDURE MarkenlisteZeileeinfuegenPosition(Position: Integer; Text: STRING);
    PROCEDURE MarkenlisteZeileeinfuegennachMarkierung(Text: STRING);
    PROCEDURE MarkenlisteZeileeinfuegen(Text: STRING);
    FUNCTION MarkenListeMarkenimportieren(Dateiname: STRING; Position: Integer): Integer;
    FUNCTION MarkenListeMarkenexportieren(Dateiname: STRING; Liste: TStrings; Anfang, Ende: Integer): Integer;
    FUNCTION MarkenListeSchnittpunkteimportieren(Position: Integer): Integer;
    FUNCTION MarkenListeMarkenberechnen(Anfang, Ende: Integer; Liste: TStrings): Integer;
// ------- Audiooffsetfenster ---------------
    PROCEDURE AudioOffsetfensterAnzeige_aendern;
    PROCEDURE AudioOffsetfensterRegler_aendern;
// ------- Tastenbilder laden ---------------
    procedure ErsetzeSpeedButtons;
    function LadeIconTemplate(Mode: Integer; DateiName : STRING): Integer;
    procedure SymbolMapping74(skin:TSkinFactory);
//    function SymbolVorlagenUpdaten(skin: TSkinFactory; const Dateiname: String): TSkinFactory;
{THU051004}
//    procedure LeereVorlageErzeugen;   // erzeugt M2SSymbolSetTempl.bmp
{---------}    
    procedure TastenbeschriftungVerbergen(Taste: TSpeedButton);
    procedure TastenbeschriftungAusrichten(Taste: TSpeedButton; Margin1, Spacing1, Margin2, Spacing2: Integer);
    procedure Tastenbeschriftunganpassen;
// ------- Paneltasten -----------------
    PROCEDURE Panelaktivieren(Panel: TPanel; Aktive: Boolean);
    PROCEDURE LangeGOPsuchen(Anfang, Ende: Int64; VAR Frame1, Frame2: Int64; maxGOPLaenge: Integer);
  public
    { Public-Deklarationen }
    Lizenz_akzeptiert : Boolean;
    PROCEDURE Spracheeinlesen;
    PROCEDURE Kommandozeile;
    PROCEDURE Optionenlesen;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
    PROCEDURE AlleNachrichten(var Msg: TMsg; var Handled: Boolean);
    PROCEDURE Fortschrittsfensterverbergen;
    PROCEDURE SchiebereglerPosition_setzen(Pos: Int64; verwendeUndo: Boolean = False);
    FUNCTION Dateilisteeinfuegen(Dateinamen: TStringList): Integer;
    FUNCTION Dateilisteaktualisieren(Knoten: TTreeNode; Positioneinstellen: Boolean = True): Integer;
{******************************************************************************}
  end;

const
  crDragPl = 5;

var
  MpegEdit: TMpegEdit;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
{$I MpegEditFormCreate.inc}
{******************************************************************************}

implementation

{$R *.DFM}

// -------------------------- allgemeine Funktionen/Proceduren ---------------------------------

FUNCTION FramesToZeit(Frames: Int64; BilderProSek: Real): TZeitCode;
BEGIN
  IF BilderProSek < 1 THEN
    BilderProSek := 25;
  WITH Result DO
  BEGIN
    IF Frames < 0 THEN
    BEGIN
      Stunde := 0;
      Minute := 0;
      Sekunde := 0;
      Bilder := 1000;
    END
    ELSE
    BEGIN
      Stunde := Trunc(Frames / (3600 * BilderProSek));
      Minute := Trunc((Frames - Stunde * 3600 * BilderProSek) / (60 * BilderProSek));
      Sekunde := Trunc((Frames - Stunde * 3600 * BilderProSek - Minute * 60 * BilderProSek) / BilderProSek);
      Bilder := Round(Frames - Stunde * 3600 * BilderProSek - Minute * 60 * BilderProSek - Sekunde * BilderProSek);
    END;
    Bilder_mSek := False;
  END;
END;

FUNCTION ZeitToFrames(Zeit: TZeitCode; BilderProSek: Real): Int64;
BEGIN
  IF BilderProSek < 1 THEN
    BilderProSek := 25;
  WITH Zeit DO
  BEGIN
    IF Bilder < 1000 THEN
    BEGIN
      Result := Round(Stunde * 3600 * BilderProSek +
                      Minute * 60 * BilderProSek +
                      Sekunde * BilderProSek);
      IF Bilder_mSek THEN
        Result := Result + Round(Bilder / (1000 / BilderProSek))
      ELSE
        Result := Result + Bilder;
    END
    ELSE
      Result := -1;
  END;
END;

FUNCTION mSekToZeit(mSek: Int64): TZeitCode;
BEGIN
  WITH Result DO
  BEGIN
    IF mSek < 0 THEN
    BEGIN
      Stunde := 0;
      Minute := 0;
      Sekunde := 0;
      Bilder := 1000;
    END
    ELSE
    BEGIN
      Stunde := Trunc(mSek / 3600000);
      Minute := Trunc((mSek - Stunde * 3600000) / 60000);
      Sekunde := Trunc((mSek - Stunde * 3600000 - Minute * 60000) / 1000);
      Bilder := mSek - Stunde * 3600000 - Minute * 60000 - Sekunde * 1000;
      Bilder_mSek := True;
    END;
  END;
END;

FUNCTION ZeitTomSek(Zeit: TZeitCode; BilderProSek: Real): Int64;
BEGIN
  IF BilderProSek < 1 THEN
    BilderProSek := 25;
  WITH Zeit DO
  BEGIN
    IF Bilder < 1000 THEN
    BEGIN
      RESULT := Stunde * 3600000 +
                Minute * 60000 +
                Sekunde * 1000;
      IF Bilder_mSek THEN
        Result := Result + Bilder
      ELSE
        Result := Result + Bilder * Round(1000 / BilderProSek);
    END
    ELSE
      Result := -1;
  END;
END;

FUNCTION ZeitToStr(Zeit: TZeitCode): STRING;

VAR HString : STRING;

BEGIN
  WITH Zeit DO
  BEGIN
    IF Zeit.Bilder < 1000 THEN
    BEGIN
      HString := IntToStr(Stunde);
      IF Stunde < 10 THEN
        HString := '0' + HString;
      Result := HString + ':';
      HString := IntToStr(Minute);
      IF Minute < 10 THEN
        HString := '0' + HString;
      Result := Result + HString + ':';
      HString := IntToStr(Sekunde);
      IF Sekunde < 10 THEN
        HString := '0' + HString;
      Result := Result + HString + ':';
      HString := IntToStr(Bilder);
      IF Bilder < 10 THEN
        HString := '0' + HString;
      IF Bilder_mSek THEN
        IF Bilder < 100 THEN
          Hstring := '0' + HString;
      Result := Result + HString;
    END
    ELSE
      Result := 'Fehler';
  END;
END;

FUNCTION StrToZeit(Zeile: STRING): TZeitCode;
BEGIN
  WITH Result DO
  BEGIN
    IF ((Length(Zeile) = 11) OR (Length(Zeile) = 12)) AND (Pos(':', Zeile) > 0) THEN
    BEGIN
      Stunde := StrToIntDef(LeftStr(Zeile, 2), 255);
      IF Stunde < 255 THEN
      BEGIN
        Minute := StrToIntDef(Copy(Zeile, 4, 2), 255);
        IF Minute < 255 THEN
        BEGIN
          Sekunde := StrToIntDef(Copy(Zeile, 7, 2), 255);
          IF Sekunde < 255 THEN
          BEGIN
            IF Length(Zeile) = 11 THEN
            BEGIN
              Bilder_mSek := False;
              Bilder := StrToIntDef(Copy(Zeile, 10, 2), 1000)
            END
            ELSE
            BEGIN
              Bilder_mSek := True;
              Bilder := StrToIntDef(Copy(Zeile, 10, 3), 1000);
            END;
            IF Bilder = 1000 THEN
            BEGIN
              Sekunde := 0;
              Minute := 0;
              Stunde := 0;
            END;
          END
          ELSE
          BEGIN
            Bilder := 1000;
            Sekunde := 0;
            Minute := 0;
            Stunde := 0;
          END;
        END
        ELSE
        BEGIN
          Bilder := 1000;
          Sekunde := 0;
          Minute := 0;
          Stunde := 0;
        END;
      END
      ELSE
      BEGIN
        Bilder := 1000;
        Sekunde := 0;
        Minute := 0;
        Stunde := 0;
      END;
    END
    ELSE
    BEGIN
      Bilder := 1000;
      Sekunde := 0;
      Minute := 0;
      Stunde := 0;
    END;
  END;
END;

FUNCTION BildTypausListe(Liste: TList; Pos: Int64): Char;

VAR Eintrag : TBildIndex;

BEGIN
  IF (Pos > -1) AND (Pos < Liste.Count) THEN
  BEGIN
    Eintrag := Liste.Items[Pos];
    CASE Eintrag.Bildtyp OF
      1 : Result := 'I';
      2 : Result := 'P';
      3 : Result := 'B';
    ELSE
      Result := '?';
    END;
  END
  ELSE
    Result := '?';
END;

// ------------------------- Applikation-Nachrichtenverarbeitung -------------------------------

PROCEDURE TAnzeigeflaeche.WMPaint(var Message: TWMPaint);
BEGIN
  INHERITED;
  Bild_aktualisieren;
END;

PROCEDURE TMpegEdit.Drag_Drop(var Msg: TMsg);

VAR I, Anzahl, Groesse: integer;
    Dateiname: PChar;
    Text : STRING;
    DateinamenListe: TStringList;

begin
  INHERITED;
  Text := '';
  DateinamenListe := TStringList.Create;
  TRY
    Anzahl := DragQueryFile(Msg.WParam, $FFFFFFFF, NIL, 255);
    FOR I := 0 TO (Anzahl - 1) DO
    BEGIN
      Groesse := DragQueryFile(Msg.WParam, I , NIL, 0) + 1;
      Dateiname:= StrAlloc(Groesse);
      DragQueryFile(Msg.WParam,I , Dateiname, Groesse);
      IF (Pos(UpperCase(ExtractFileExt(Dateiname)), UpperCase(ArbeitsumgebungObj.DateiendungenVideo)) > 0) OR
         (Pos(UpperCase(ExtractFileExt(Dateiname)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) > 0) THEN
      BEGIN
        IF Msg.HWnd = Dateien.Handle THEN
          DateinamenListe.Add(Dateiname);
      END
      ELSE
        IF UpperCase(ExtractFileExt(Dateiname)) = '.M2E' THEN
        BEGIN
          IF (Msg.HWnd = Dateien.Handle) OR (Msg.HWnd = Schnittliste.Handle) THEN
            Projekteinfuegen_anzeigen(Dateiname, True);
        END
        ELSE
        BEGIN
          IF Text <> '' THEN
            Text := Text + Chr(13);
          Text := Text + Meldunglesen(NIL, 'Meldung111', Dateiname, 'Der Dateityp $Text1# wird nicht unterstützt.');
        END;
      StrDispose(Dateiname);
    END;
    IF DateinamenListe.Count > 0 THEN
    BEGIN
      Dateilisteeinfuegen(DateinamenListe);
      IF (ArbeitsumgebungObj.letztesVideoanzeigen AND (NOT letztesVideoanzeigenCLaktiv)) OR
         (letztesVideoanzeigenCL AND letztesVideoanzeigenCLaktiv) THEN
      BEGIN
//        Fortschrittsfensteranzeigen;
        TRY
          IF ArbeitsumgebungObj.SchiebereglerPosbeibehalten THEN
            Dateilisteaktualisieren(Dateien.Selected)
          ELSE
          BEGIN
            Dateilisteaktualisieren(Dateien.Selected, False);
            SchiebereglerPosition_setzen(0);
          END;
        FINALLY
          Fortschrittsfensterverbergen;
        END;
        Schnittpunktanzeigeloeschen;
      END;
    END;
  FINALLY
    DateinamenListe.Free;
  END;
  DragFinish(Msg.WParam);
  IF Text <> '' THEN
    Meldungsfenster(Text, Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//    MessageDlg(Text, mtWarning, [mbOK], 0);
end;

FUNCTION TMpegEdit.Ereignisbearbeiten: Boolean;
BEGIN
  Result := (Infofensteraktiv AND ArbeitsumgebungObj.InfofensterTasten) OR
            (Schnittlisteaktiv AND ArbeitsumgebungObj.SchnittlisteTasten) OR
            (Kapitellisteaktiv AND ArbeitsumgebungObj.KapitellisteTasten) OR
            (Markenlisteaktiv AND ArbeitsumgebungObj.MarkenlisteTasten) OR
            (Dateienfensteraktiv AND ArbeitsumgebungObj.DateienfensterTasten) OR
            SchnittlistenEditaktiv OR
            KapitellistenEditaktiv OR
            DateienfensterEditaktiv OR
            OffsetEditaktiv OR
            Dialogaktiv;
  Result := NOT Result;
//  Result := False;
END;

PROCEDURE TMpegEdit.AlleNachrichten(var Msg: TMsg; var Handled: Boolean);

VAR IndexFrame : Int64;
    I : Integer;

BEGIN
{Q: übergeben der Bearbeitung von KeyEvents an Control, wenn Target das
 AudioOffsetEdit ist und wenn bestimmte Tasten gedrückt werden}
{  if (Msg.hwnd = AudioOffsetEdit.Handle) AND
    ((Msg.message = WM_KeyDown) or (Msg.message = WM_KeyUp)) THEN
    if Msg.wParam IN
      [48..57,187,189,  // 0-9, +, -
       VK_NUMPAD0..VK_NUMPAD9,
       VK_BACK,VK_RETURN,VK_ESCAPE,VK_END,VK_HOME,VK_LEFT,VK_RIGHT,VK_INSERT,
       VK_DELETE,VK_ADD,VK_SUBTRACT
      ] THEN exit; // Nachrichtenbehandlung vom EditControl  }
{---------}
  IF Ereignisbearbeiten THEN
  BEGIN
    IF ((Msg.message = WM_LBUTTONDOWN) OR
        (Msg.message = WM_RBUTTONDOWN) OR
        (Msg.message = WM_MBUTTONDOWN)) AND
       (SchnittuebernehmenPanel.Visible = True) THEN
      SchnittuebernehmenPanel.Visible := False;
    IF (Msg.message = WM_KeyDown) OR (Msg.message = WM_SysKeyDown) OR
       (Msg.message = WM_KeyUp) OR (Msg.message = WM_SysKeyUp) THEN
    BEGIN
      IF SchnittuebernehmenPanel.Visible = True THEN
        SchnittuebernehmenPanel.Visible := False;
      IF (Msg.message = WM_KeyDown) AND (Msg.wParam = 18) THEN
        Msg.wParam := 15;
      IF (Msg.message = WM_KeyDown) OR (Msg.message = WM_SysKeyDown) THEN
      BEGIN
        I := Low(ArbeitsumgebungObj.Tasten) + 1;
        WHILE I < High(ArbeitsumgebungObj.Tasten) + 1 DO
        BEGIN
          IF Msg.wParam = ArbeitsumgebungObj.Tasten[I] THEN
          BEGIN
            CASE I OF
              1 : Schrittweite := ArbeitsumgebungObj.Schrittweite1;
              2 : Schrittweite := ArbeitsumgebungObj.Schrittweite2;
              3 : Schrittweite := ArbeitsumgebungObj.Schrittweite3;
              4 : Schrittweite := ArbeitsumgebungObj.Schrittweite4;
   5, 6, 41, 42 : IF Tastegedrueckt = -1 THEN
                    Tastegedrueckt := ArbeitsumgebungObj.Tasten[I];
              7 : Abspielengedrueckt;
              8 : Stoppen;
              9 : Spieleabgedrueckt;
             10 : Spielebisgedrueckt;
             11 : SchrittVor.Click;
             12 : SchrittZurueck.Click;
             13 : NaechstesI.Click;
             14 : VorherigesI.Click;
             15 : NaechstesP.Click;
             16 : VorherigesP.Click;
             17 : GehezuIn.Click;
             18 : GehezuOut.Click;
             19 : SchiebereglerPosition_setzen(0, True);
             20 : SchiebereglerPosition_setzen(SchiebereglerMax, True);
             21 : CutIn.Click;
             22 : CutOut.Click;
             23 : SchnittaendernBtn.Click;
             24 : Schnittuebernehmen.Click;
             25 : Schneiden.Click;
             26 : Kapitel.Click;
             27 : Vorschau.Click;
             28 : Video_Audio_oeffnen.Click;
             29 : Datei_hinzufuegen.Click;
             30 : ProjektNeu.Click;
             31 : ProjektLaden.Click;
             32 : ProjektSpeichern.Click;
             33 : ProjektSpeichernUnter.Click;
             34 : ProgrammEnde.Click;
             35 : Schnittpunkteeinzelnschneiden.Down := NOT Schnittpunkteeinzelnschneiden.Down;
             36 : MarkierteSchnittpunkte.Down := NOT MarkierteSchnittpunkte.Down;
             37 : nurAudiospeichern.Down := NOT nurAudiospeichern.Down;
             38 : Marke.Click;
             39 : Videoumschalten;
             40 : nurIFramesabspielen;
             43 : Infoaktualisieren;
             44 : FilmGrobAnsichtFrm.binaereSucheKlick(2);
             45 : FilmGrobAnsichtFrm.binaereSucheKlick(1);
             46 : IF Tastegedrueckt = -1 THEN
                  BEGIN
                    Tastegedrueckt := ArbeitsumgebungObj.Tasten[I];
                    Schnittliste.Repaint;
                  END;
            END;
//            Handled := True;
            I := High(ArbeitsumgebungObj.Tasten) + 1;
          END;
          Inc(I);
        END;
      END;
      IF (Msg.message = WM_KeyUp) OR (Msg.message = WM_SysKeyUp) THEN
      BEGIN
        I := Low(ArbeitsumgebungObj.Tasten) + 1;
        WHILE I < High(ArbeitsumgebungObj.Tasten) + 1 DO
        BEGIN
          IF Msg.wParam = ArbeitsumgebungObj.Tasten[I] THEN
          BEGIN
            CASE I OF
              1, 2, 3, 4 : Schrittweite := 1;
            5, 6, 41, 42 : Tastegedrueckt := -1;
                      46 : BEGIN
                             Tastegedrueckt := -1;
                             Schnittliste.Repaint;
                           END;
            END;
//            Handled := True;
            I := High(ArbeitsumgebungObj.Tasten) + 1;
          END;
          Inc(I);
        END;
      END;
      Handled := True;
      IF ArbeitsumgebungObj.MenueTastenbedienung AND
         (Msg.wParam = 18) THEN
        Handled := False;                       // Menüsteuerung per Tastatur
    END;
  END
  ELSE
    Optionenfenster.Tasten_weiterleiten(Msg, Handled);
  IF (Msg.hwnd = Schieberegler.Handle) THEN
  BEGIN
    IF (Msg.message = WM_MouseMove) AND (Msg.wParam = 1) THEN
    BEGIN
      IndexFrame := Round((Msg.pt.X - Schieberegler.ClientOrigin.X - 11)
                         * SchiebereglerMax / (Schieberegler.Width - 23));
      SchiebereglerPosition_setzen(IndexFrame, False);
      Handled := True;
    END;
    IF Msg.message = WM_LBUTTONDOWN THEN
    BEGIN
//      IF (VideoabspielerMode = mpPlaying) OR (TAbspielMode(AudioplayerMode) = mpPlaying) THEN
      IF Play.Down THEN
      BEGIN
        AbspielModus := False;
        PlayerPause;
      END;
      IndexFrame := Round((Msg.pt.X - Schieberegler.ClientOrigin.X - 11)
                         * SchiebereglerMax / (Schieberegler.Width - 23));
      IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[5] THEN
        IndexFrame := Bildsuchen(1, IndexFrame, IndexListe);
      IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[6] THEN
        IndexFrame := Bildsuchen(2, IndexFrame, IndexListe);
      SchiebereglerPosition_setzen(IndexFrame, True);                         // mit Undo
//      Handled := True;
    END;
    IF Msg.message = WM_LBUTTONUP THEN
    BEGIN
      IF Play.Down THEN
      BEGIN
        AbspielModus := True;
        PlayerStart;
        CutIn.Enabled := False;
        CutOut.Enabled := False;
      END;
    END;
    IF Msg.message = WM_LBUTTONDBLCLK THEN
      Handled := True;
  END;
  IF (Msg.hwnd = SchiebereglermittePanel.Handle) THEN
  BEGIN
    IF (Msg.message = WM_MouseMove) AND (Msg.wParam = 1) AND (NOT Assigned(Vorschauknoten)) THEN
    BEGIN
      IndexFrame := MpegEdit.ScreenToClient(Msg.pt).X - 7;                      //  7 = Schiebereglermarkerbreite / 2
      IF IndexFrame < (Schieberegler.Left + 4) THEN                             //  4 = Abstand des Schiebereglerzeigers zum Rand + 7
        IndexFrame := Schieberegler.Left + 4;
      IF IndexFrame > (Schieberegler.Left + Schieberegler.Width - 15 - 4) THEN  // 15 = Schiebereglermarkerbreite
        IndexFrame := Schieberegler.Left + Schieberegler.Width - 15 - 4;
      SchiebereglermittePanel.Left := IndexFrame;
      SchiebereglerMarkerPosition := Round((SchiebereglermittePanel.Left - Schieberegler.Left - 4) *
                                     10000 / (Schieberegler.Width - 15 - 4 - 4));
      Handled := True;
    END;
  END;
  IF Msg.message = WM_DROPFILES THEN
  BEGIN
    Handled := True;
    Drag_Drop(Msg);
  END;
END;

PROCEDURE TMpegEdit.Wiederherstellen(Sender: TObject);
BEGIN
  IF NOT Fortschrittsfenster.Visible THEN
  BEGIN
    Fortschrittsfenster.Show;
    Fortschrittsfenster.Hide;
  END;  
  Fortschrittsfenster.WindowState := wsNormal;
END;

PROCEDURE TMpegEdit.Minimieren(Sender: TObject);
BEGIN
  Fortschrittsfenster.WindowState := wsMinimized;
END;

// --------------------------- Formular Funktionen/Proceduren ----------------------------------

// Q: wird nach FormCreate aufgerufen, erst dann sind die Handles gültig.
procedure TMpegEdit.FormShow(Sender: TObject);
var
  uxTheme: TUxTheme;
begin
  uxTheme := TUxTheme.Create;
  uxTheme.DisableWindowTheme(Listen.Handle);
  uxTheme.DisableWindowTheme(Schieberegler.Handle);
  uxTheme.Free;
end;

procedure TMpegEdit.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crDragPl] := LoadCursor(HInstance, 'CRDRAG+');
  Anzeigeflaeche := TAnzeigeflaeche.Create(Self);
  Anzeigeflaeche.OnClick := AnzeigeflaecheClick;
  Anzeigeflaeche.OnDblClick := AnzeigeflaecheDblClick;
  Anzeigeflaeche.PopupMenu := Anzeigefenstermenue;
  Anzeigeflaeche.Parent := Self;
  AnzeigefensterHandle := Anzeigeflaeche.Handle;
  Anzeigeflaeche.SetZOrder(False);
//  Anzeigeflaeche.BevelOuter := bvLowered;
//  Anzeigeflaeche.BevelEdges := [beLeft, beTop, beRight, beBottom];
//  Anzeigeflaeche.BevelKind := bkFlat;
//  Anzeigeflaeche.BevelWidth := 1;
  Bildflaeche := TAnzeigeflaeche.Create(Self);
  Bildflaeche.OnClick := AnzeigeflaecheClick;
  Bildflaeche.PopupMenu := Anzeigefenstermenue;
  Bildflaeche.Parent := Self;
  Bildflaeche.SetZOrder(False);
  Bildflaeche.Visible := False;
  StandbildPositionZeit.Parent := Bildflaeche;
  StandbildPositionFrame.Parent := Bildflaeche;
  VideoImage.Parent := Bildflaeche;
  VideoImage.OnClick := AnzeigeflaecheClick;
  VideoListe := TListe.Create;
  IndexListe := TListe.Create;
  AudioListe := TListe.Create;
  SequenzHeader := TSequenzHeader.Create;
  SequenzHeader.Seitenverhaeltnis := 2;
  BildHeader := TBildHeader.Create;
  AudioHeader := TAudioHeader.Create;
  AudioTimer := TTimer.Create(Self);
  AudioTimer.Enabled := False;
  AudioTimer.Interval := 100;
  AudioTimer.OnTimer := AudioTimerTimer;
  Schrittweite := 1;
  Tastegedrueckt := -1;
  BilderProSek := 25;
  AudiooffsetAus;
  Schiebereglerfaktor := 1;
  SchiebereglerMax := 1000;
  SchiebereglerPosition := 0;
  PositionIn := -1;
  PositionOut := -1;
  SpieleVonBisPosition := -1;
  SchiebereglerPosition_merken := -1;
  Schieberegler.SelStart := Schieberegler.Max;
  Schieberegler.SelEnd := 0;
  ProtokollDateiname(ExtractFilePath(Application.ExeName) + 'Protokoll.txt');
  Dateilistegeaendert := False;
  Schnittlistegeaendert := False;
  Kapitellistegeaendert := False;
  Effektgeaendert := False;
  Markenlistegeaendert := False;
  Schnittpunktbewegen := - 1;
  VorschauDateiname1 := '';
  VorschauDateiname2 := '';
  VorschauPositionOut := 0;
  VorschauPositionIn := 0;
  VorschauListe := NIL;
  VorschauAudioListe := NIL;
  Fenster := MpegEdit;
  VideoPositionuebergeben := Positionsanzeige;
  Audioplayersynchronisieren := Audioplayerlaeuft;
  AudioplayerPositionholen := AudioplayerPositionPlusOffset;
  Mpeg2Fenster.Framefehleranzeige := BildNr;
  nachSchneidenbeendet := False;
  Dateienfensterhoehe := 65;
  Application.OnMessage := AlleNachrichten;
  Application.OnRestore := Wiederherstellen;
  Application.OnMinimize := Minimieren;
  DragAcceptFiles(Dateien.Handle, True);
  DragAcceptFiles(Schnittliste.Handle, True);
  ArbeitsumgebungCreate;
  SprachenlisteCreate;
  WortUebernehmen := Schnittuebernehmen.Caption;
  WortGehezuIn := GehezuIn.Caption;
  WortGehezuOUT := GehezuOUT.Caption;
  ListenTabIndex := -1;
  Mpeg2Fenster.Tempo := 1;
  ErsetzeSpeedButtons;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
{$I MpegEditFormCreate2.inc}
{******************************************************************************}
  Programmschliessen := False;
  IF NOT (GetDeviceCaps(Canvas.Handle,BITSPIXEL) IN [16, 24, 32]) THEN
  BEGIN
    Meldungsfenster(Wortlesen(NIL, 'Meldung71', 'Die Bildschirmeinstellungen müssen auf 16, 24 oder 32 Bit Farbtiefe gestellt werden. (Truecolor)') + CHR(13) +
                    Wortlesen(NIL, 'Meldung72', 'Das Anzeigefenster wird schwarz bleiben.'),
                    Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//    ShowMessage(Wortlesen(NIL, 'Meldung71', 'Die Bildschirmeinstellungen müssen auf 16, 24 oder 32 Bit Farbtiefe gestellt werden. (Truecolor)') + CHR(13) +
//                Wortlesen(NIL, 'Meldung72', 'Das Anzeigefenster wird schwarz bleiben.'));
  END;
END;

PROCEDURE TMpegEdit.Parameterlesen;

VAR I, Erg : Integer;
    Text,
    HString,
    SchnittpunktI : STRING;
    Audioknoten : TTreeNode;

FUNCTION BilderproSekVideosetzen(Videoname: STRING): Real;

VAR MpegHeader : TMpeg2Header;
    SequenzHeader : TSequenzHeader;
    BildHeader : TBildHeader;

BEGIN
  MpegHeader:= TMpeg2Header.Create;
  SequenzHeader := TSequenzHeader.Create;
  BildHeader := TBildHeader.Create;
  TRY
    IF MpegHeader.Dateioeffnen(VideoName) THEN
    BEGIN
      MpegHeader.DateiInformationLesen(SequenzHeader, BildHeader);
      IF ArbeitsumgebungObj.FesteFramerateverwenden THEN
        Result := ArbeitsumgebungObj.FesteFramerate
      ELSE
        Result := BilderProSekausSeqHeaderFramerate(SequenzHeader.Framerate);
    END
    ELSE
      Result := 25;
  FINALLY
    MpegHeader.Free;
    SequenzHeader.Free;
    BildHeader.Free;
  END;
END;

FUNCTION BilderproSekAudiosetzen(Audioname: STRING): Real;

VAR MpegAudio : TMpegAudio;
    AudioHeader : TAudioHeader;

BEGIN
  MpegAudio := TMpegAudio.Create;
  AudioHeader := TAudioHeader.Create;
  TRY
    Result := 25;
    IF (MpegAudio.Dateioeffnen(AudioName) = 0) AND
       (MpegAudio.DateiInformationLesen(AudioHeader) > -2) AND
       (AudioHeader.Framezeit > 0) THEN
      Result := 1000 / AudioHeader.Framezeit;
  FINALLY
    MpegAudio.Free;
    AudioHeader.Free;
  END;
END;

BEGIN
  SchnittpunktI := '';
  ZielDateinameCLaktiv := False;
  FramegenauschneidenCLaktiv := False;
  gleichSchneidenCL := False;
  nachSchneidenbeendenCL := False;
  letztesVideoanzeigenCLaktiv := False;
  aktArbeitsumgebungCLaktiv := False;
  Audioknoten := NIL;
  IF ParamCount > 0 THEN               // Übergabeparameter vorhanden
  BEGIN
    I := 1;
    WHILE I < ParamCount + 1 DO
    BEGIN
      IF UpperCase(LeftStr(ParamStr(I), 2)) = '/Z' THEN
      BEGIN
        ZielDateinameCLaktiv := True;
        ZielDateinameCL := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
        IF ZielDateinameCL = '' THEN
        BEGIN
          Inc(I);
          ZielDateinameCL := ParamStr(I);
        END;
      END
      ELSE
        IF UpperCase(ParamStr(I)) = '/+F' THEN
        BEGIN
          FramegenauschneidenCLaktiv := True;
          FramegenauschneidenCL := True;
        END
        ELSE
          IF UpperCase(ParamStr(I)) = '/-F' THEN
          BEGIN
            FramegenauschneidenCLaktiv := True;
            FramegenauschneidenCL := False;
          END
          ELSE
            IF UpperCase(ParamStr(I)) = '/+V' THEN
            BEGIN
              letztesVideoanzeigenCLaktiv := True;
              letztesVideoanzeigenCL := True;
            END
            ELSE
              IF UpperCase(ParamStr(I)) = '/-V' THEN
              BEGIN
                letztesVideoanzeigenCLaktiv := True;
                letztesVideoanzeigenCL := False;
              END
              ELSE
                IF UpperCase(ParamStr(I)) = '/S' THEN
                  gleichSchneidenCL := True
                ELSE
                  IF UpperCase(ParamStr(I)) = '/E' THEN
                  BEGIN
                    nachSchneidenbeendenCL := True;
                  END
                  ELSE
                    IF UpperCase(LeftStr(ParamStr(I), 2)) = '/R' THEN
                    BEGIN
                      IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                      BEGIN
                        Inc(I);
                        TRY
                          BilderProSek := StrToFloat(ParamStr(I));
                        EXCEPT
                          BilderProSek := 25;
                        END;
                      END
                      ELSE
                      BEGIN
                        TRY
                          BilderProSek := StrToFloat(RightStr(ParamStr(I), Length(ParamStr(I)) - 2));
                        EXCEPT
                          BilderProSek := 25;
                        END;
                      END;
                      IF BilderProSek > 0 THEN
                        Bildlaenge := 1000 / BilderProSek
                      ELSE
                        Bildlaenge := 40;
                    END
                    ELSE
                      IF UpperCase(LeftStr(ParamStr(I), 2)) = '/L' THEN
                      BEGIN
                        IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                        BEGIN
                          Inc(I);
                          TRY
                            Bildlaenge := StrToFloat(ParamStr(I));
                          EXCEPT
                            Bildlaenge := 40;
                          END;
                        END
                        ELSE
                        BEGIN
                          TRY
                            Bildlaenge := StrToFloat(RightStr(ParamStr(I), Length(ParamStr(I)) - 2));
                          EXCEPT
                            Bildlaenge := 40;
                          END;
                        END;
                        IF Bildlaenge > 0 THEN
                          BilderProSek := 1000 / Bildlaenge
                        ELSE
                          BilderProSek := 25;
                      END
                      ELSE
                        IF UpperCase(LeftStr(ParamStr(I), 2)) = '/I' THEN
                        BEGIN
                          IF SchnittpunktI <> '' THEN
                            SchnittpunkteinfuegenCL(SchnittpunktI, '');
                          SchnittpunktI := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                          IF SchnittpunktI = '' THEN
                          BEGIN
                            Inc(I);
                            SchnittpunktI := ParamStr(I);
                          END;
                        END
                        ELSE
                          IF UpperCase(LeftStr(ParamStr(I), 2)) = '/O' THEN
                          BEGIN
                            IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                            BEGIN
                              Inc(I);
                              SchnittpunkteinfuegenCL(SchnittpunktI, ParamStr(I));
                            END
                            ELSE
                              SchnittpunkteinfuegenCL(SchnittpunktI, RightStr(ParamStr(I), Length(ParamStr(I)) - 2));
                            SchnittpunktI := '';
                          END
                          ELSE
                            IF UpperCase(LeftStr(ParamStr(I), 2)) = '/A' THEN
                            BEGIN
                              IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                              BEGIN
                                Inc(I);
                                HString := ParamStr(I);
                              END
                              ELSE
                                HString := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                              IF Assigned(Audioknoten) AND
                                 Assigned(Audioknoten.Data) THEN
                                TDateieintragAudio(Audioknoten.Data).Audiooffset := StrToIntDef(HString, 0);
                            END
                            ELSE
                              IF UpperCase(LeftStr(ParamStr(I), 2)) = '/H' THEN
                              BEGIN
                                IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                                BEGIN
                                  Inc(I);
                                  HString := ParamStr(I);
                                END
                                ELSE
                                  HString := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                                Erg := AudiodateieinfuegenKnoten(Dateien.Selected, HString);
                                IF Erg = -2 THEN
                                BEGIN
                                  IF Text <> '' THEN
                                    Text := Text + Chr(13);
                                  Text := Text + Meldunglesen(NIL, 'Meldung111', HString, 'Der Dateityp $Text1# wird nicht unterstützt.');
                                END
                                ELSE
                                  Audioknoten := DateienlisteneintragAudio_suchenKnoten(Dateien.Selected, HString);
                              END
                              ELSE
                                IF Projekteinfuegen_anzeigen(ParamStr(I), True) < 0 THEN
                                BEGIN
                                  Erg := ArbeitsumgebungladenName(ParamStr(I));
                                  Arbeitsumgebung_lesen;
                                  IF Erg > -2 THEN
                                  BEGIN
                                    aktArbeitsumgebungCLaktiv := True;
                                    aktArbeitsumgebung := Erg
                                  END
                                  ELSE
                                  BEGIN
                                      Erg := Videodateieinfuegen(ParamStr(I));
                                      IF Erg = -1 THEN
                                      BEGIN
                                        Erg := Audiodateieinfuegen(ParamStr(I));
                                        IF Erg = 0 THEN
                                        BEGIN
                                          Audioknoten := DateienlisteneintragAudio_suchenKnoten(Dateien.Selected, ParamStr(I));
                                          BilderproSek := BilderproSekAudiosetzen(ParamStr(I));
                                        END;
                                      END
                                      ELSE
                                      BEGIN
                                        Audioknoten := NIL;
                                        BilderproSek := BilderproSekVideosetzen(ParamStr(I));
                                      END;
                                    IF Erg = 0 THEN

                                    IF Erg = -1 THEN
                                    BEGIN
                                      IF Text <> '' THEN
                                        Text := Text + Chr(13);
                                      Text := Text + Meldunglesen(NIL, 'Meldung111', ParamStr(I), 'Der Dateityp $Text1# wird nicht unterstützt.');
                                    END
                                    ELSE
                                      Projektgeaendert_setzen(1);
                                  END;
                                END;
      Inc(I);
    END;
    IF SchnittpunktI <> '' THEN
      SchnittpunkteinfuegenCL(SchnittpunktI, '');
    IF Text <> '' THEN
      Protokoll_schreiben(Text);
  END;
end;

procedure TMpegEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

VAR Erg : Integer;

begin
  CanClose := True;
  SchnittListe.ItemIndex := -1;
  Vorschau_beenden.Click;
  IF VideoabspielerMode = mpPlaying THEN
    Pause;
  IF (VideoabspielerMode = mpPlaying) OR
     Assigned(Vorschauknoten) THEN
    CanClose := False
  ELSE
    IF Projekt_geaendertX AND (NOT nachSchneidenbeendet) THEN
    BEGIN
      Erg := Nachrichtenfenster(Wortlesen(NIL, 'Meldung92', 'Soll das Projekt gespeichert werden?'),
                                Wortlesen(NIL, 'Frage', 'Frage'), MB_YESNOCANCEL, MB_ICONQUESTION);
//      Erg := Application.MessageBox(PChar(Wortlesen(NIL, 'Meldung92', 'Soll das Projekt gespeichert werden?')),
//                                    PChar(Wortlesen(NIL, 'Frage', 'Frage')), MB_YESNOCANCEL);
      CASE Erg OF
        IDYES : BEGIN
                  IF Projekt_speichern(Projektname) < 0 THEN
                    IF Projekt_speichernneu < 0 THEN
                    BEGIN
                      IF Projekt_speichernunter < 0 THEN
                        CanClose := False;
                    END
                    ELSE
                      Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Projektname, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, True, True)
                  ELSE
                    Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Projektname, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, True, True);
                END;
        IDCANCEL : CanClose := False;
      END; 
    END;
end;

procedure TMpegEdit.FormClose(Sender: TObject; var Action: TCloseAction);

VAR I : Integer;
    Knotenpunkt : TTreeNode;
    Dateieintrag : TDateieintrag;
    Audiodateieintrag : TDateieintragAudio;


begin
  IF Assigned(ArbeitsumgebungObj) THEN                                   // ist das ArbeitsumgebungObjekt nicht vorhanden wurde die Funktion schon ausgeführt
  BEGIN
    Programmschliessen := True;
    IF ArbeitsumgebungObj.Indexdateienloeschen THEN                      // Indexdateien löschen
      FOR I := 0 TO Dateien.Items.Count - 1 DO
      BEGIN
        Knotenpunkt := Dateien.Items[I];                                 // Knoten aus DateienListe laden
        IF Knotenpunkt.Level > 0 THEN                                    // nur Knoten der 2. Ebene behandeln
          IF Knotenpunkt.Parent.IndexOf(Knotenpunkt) = 0 THEN
          BEGIN
            Dateieintrag := TDateieintrag(Knotenpunkt.Data);
            IF Assigned(Dateieintrag) THEN
              DeleteFile(ChangeFileExt(Dateieintrag.Name, '.idd'));      // Videoindexdatei des Hauptknotens löschen
          END
          ELSE
          BEGIN
            Audiodateieintrag := TDateieintragAudio(Knotenpunkt.Data);
            IF Assigned(Audiodateieintrag) THEN
              DeleteFile(Audiodateieintrag.Name + '.idd');               // Audioindexdateien löschen
          END;
      END;
  {    FOR I := 0 TO Dateien.Items.Count - 1 DO
      BEGIN
        Knotenpunkt := Dateien.Items[I];                                 // Knoten aus DateienListe laden
        IF Knotenpunkt.Level = 0 THEN                                    // nur Knoten der 1. Ebene (mit Videodaten) behandeln
        BEGIN
          IF Knotenpunkt.HasChildren THEN                                // hat der Knoten Unterknoten (Audiodateien)
          BEGIN
            FOR J := 0 TO Knotenpunkt.Count - 1 DO                       // dann alle Unterknoten
            BEGIN
              Unterknoten := Knotenpunkt.Item[J];                        // durchlaufen und die
              Audiodateieintrag := TDateieintragAudio(Unterknoten.Data);
              DeleteFile(Audiodateieintrag.Name + '.idd');               // Audioindexdateien löschen
            END;
          END;
          Dateieintrag := TDateieintrag(Knotenpunkt.Data);
          DeleteFile(ChangeFileExt(Dateieintrag.Name, '.idd'));          // Videoindexdatei des Hauptknotens löschen
        END;
      END;  }
    IF ArbeitsumgebungObj.Vorschaudateienloeschen THEN
    BEGIN
      IF Assigned(Vorschauknoten) THEN
      BEGIN
        DateilisteaktualisierenVideo(NIL, False);
        DateilisteaktualisierenAudio(NIL, False);
        Vorschauknotenloeschen;
      END;
      IF NOT Variablevorhanden(ArbeitsumgebungObj.VorschauVerzeichnis) THEN
        Dateienloeschen(ArbeitsumgebungObj.VorschauVerzeichnis + 'Vorschau-*.*');
    END;
    Fensterpositionmerken;
    Fensteranzeigemerken;
    KapitelListeFormatspeichern;
    ListeTabIndexspeichern;
    FilmGrobAnsichtFrm.Fensterpositionmerken;
    binaereSucheForm.Fensterpositionmerken;
    IF NOT aktArbeitsumgebungCLaktiv THEN
    BEGIN
      IF aktArbeitsumgebungbeiEndespeichern THEN
        Arbeitsumgebungspeichern(aktArbeitsumgebung);
      Arbeitsumgebungenspeichern(ChangeFileExt(Application.ExeName, '.ini'));
    END;
    Dateienlisteloeschen;
    Videoabspieler_freigeben;
    AudioplayerClose;
    VideoListe.Loeschen;
    VideoListe.Free;
    VideoListe := NIL;
    IndexListe.Loeschen;
    IndexListe.Free;
    IndexListe := NIL;
    AudioListe.Loeschen;
    AudioListe.Free;
    AudioListe := NIL;
    KapitelListeClose;
    SequenzHeader.Free;
    SequenzHeader := NIL;
    BildHeader.Free;
    BildHeader := NIL;
    AudioHeader.Free;
    AudioHeader := NIL;
    Application.OnMessage := NIL;
    Hinweisanzeigen(Wortlesen(NIL, 'Meldung95', 'Das Programm wird geschlossen.'), ArbeitsumgebungObj.Beendenanzeigedauer, True, False);
    Protokoll_schreiben(Wortlesen(NIL, 'Protokollende','Protokollende'));
    Protokoll_schliessen;
    SprachenlisteDestroy;
    ArbeitsumgebungDestroy;
  END;  
end;

PROCEDURE TMpegEdit.Optionenlesen;
BEGIN
  IF BeiStartStandardladen THEN
    Arbeitsumgebungladen(0)
  ELSE
    Arbeitsumgebungladen(aktArbeitsumgebung);
  DateienlisteInit;
  KapitelListeInit;
//  binaereSucheForm.OnPositionsetzen := SchiebereglerPosition_setzen;
  FilmGrobAnsichtFrm.OnPositionsetzen := SchiebereglerPosition_setzen;
  FilmGrobAnsichtFrm.OnBildzuBitmap := BMPBildlesen;
  Arbeitsumgebung_lesen;
  Show;
END;

PROCEDURE TMpegEdit.Arbeitsumgebung_lesen;
BEGIN
  WindowState := wsNormal;
  IF (ArbeitsumgebungObj.ProgrammFensterBreite = -1) AND
     (ArbeitsumgebungObj.ProgrammFensterHoehe = -1) THEN
     SetBounds(Trunc((Screen.WorkAreaWidth - 800) / 2), Trunc((Screen.WorkAreaHeight - 570) / 2),
               800, 570)
  ELSE
    SetBounds(ArbeitsumgebungObj.ProgrammFensterLinks, ArbeitsumgebungObj.ProgrammFensterOben,
              ArbeitsumgebungObj.ProgrammFensterBreite, ArbeitsumgebungObj.ProgrammFensterHoehe);
  IF ArbeitsumgebungObj.ProgrammFensterMaximized THEN
    WindowState := wsMaximized;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 0 THEN
    Maximal.Checked := True
  ELSE
    Fenstergroesseanpassen(ArbeitsumgebungObj.Videoanzeigefaktor);
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 0.5 THEN
    Doppelt.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 0.75 THEN
    EinsFuenfzuEins.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 1 THEN
    EinszuEins.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 1.5 THEN
    EinszuEinsFuenf.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 2 THEN
    EinszuZwei.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 4 THEN
    EinszuVier.Checked := True;
  ArbeitsumgebungObj.Bilderdateigeaendert := True;             // Tastensymbole neu laden
  FilmGrobAnsichtFrm.Fensterpositionsetzen;
  binaereSucheForm.Fensterpositionsetzen;
  IF ArbeitsumgebungObj.ZweiVideofenster <> ZweiFensterMenuItem.Checked THEN
    ZweiFensterMenuItem.Click;
  Rueckgabeparameter_lesen;
  Listen.ActivePageIndex := 0;
END;

PROCEDURE TMpegEdit.Rueckgabeparameter_lesen;
BEGIN
// -------------- Rückgabeparameter des Optionenfensters ---------------------------
  Markenliste.ReadOnly := NOT ArbeitsumgebungObj.Markenlistebearbeiten;
  IF ArbeitsumgebungObj.VideoGraudarstellen THEN
    VideoFarbeeinstellen(VideoFormatGray8)
  ELSE
    VideoFarbeeinstellen(VideoFormatRGB24);
  IF ArbeitsumgebungObj.keinVideo THEN
    Videoausschalten
  ELSE
    Videoeinschalten;
  Audioplay.Fehleranzeigen := ArbeitsumgebungObj.AudioFehleranzeigen;
  Audioplay.GraphName := ArbeitsumgebungObj.AudioGraphName;
  IF ArbeitsumgebungObj.keinAudio AND Audioplayer_OK THEN
  BEGIN
    AudioplayerClose;
    Player := Player AND $FD;                                  // Bit 1 auf 0 setzen
    Audioposition.Caption := '00:00:00:000';
  END;
  IF ArbeitsumgebungObj.MCIPlayer AND (NOT(Audioplayer_OK AND (NOT DirectShowverwenden))) THEN
  BEGIN
    AudioplayerClose;
    Player := Player AND $FD;                                  // Bit 1 auf 0 setzen
    Audioposition.Caption := '00:00:00:000';
    AudioplayerMCI_erzeugen(Audioplayer);
    IF aktAudiodatei <> '' THEN
    BEGIN
      IF AudioplayerOeffnen(aktAudiodatei) THEN
        Player := Player OR 2;                                 // Bit 1 auf 1 setzen
      SchiebereglerPosition_setzen(0);
      Schieberegleraktualisieren;
    END;
  END;
  IF ArbeitsumgebungObj.DSPlayer AND (NOT(Audioplayer_OK AND DirectShowverwenden)) THEN
  BEGIN
    AudioplayerClose;
    Player := Player AND $FD;                                  // Bit 1 auf 0 setzen
    Audioposition.Caption := '00:00:00:000';
    AudioplayerDS_erzeugen;
    IF aktAudiodatei <> '' THEN
    BEGIN
      IF AudioplayerOeffnen(aktAudiodatei) THEN
        Player := Player OR 2;                                 // Bit 1 auf 1 setzen
      SchiebereglerPosition_setzen(0);
      Schieberegleraktualisieren;
    END;
  END;
  KapitelListeFormat;
  IF ArbeitsumgebungObj.Protokollstartende THEN
    Protokoll_starten_beenden(UeberFenster.VersionNr);
  IF ArbeitsumgebungObj.festeframerateverwendengeaendert THEN
  BEGIN
    IF SchnittListe.Items.Count > 0 THEN
      Meldungsfenster(Wortlesen(NIL, 'Meldung46', 'Die Schnitte müssen neu gesetzt werden!'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung46', 'Die Schnitte müssen neu gesetzt werden!'));
    SchiebereglerPosition_setzen(0);
    Schiebereglerlaenge_einstellen;
    Videolaenge.Caption := ZeitToStr(FramesToZeit(Bilderzahl, BilderProSek));
  END;
{  WindowState := wsNormal;
  IF (ArbeitsumgebungObj.ProgrammFensterBreite = -1) AND
     (ArbeitsumgebungObj.ProgrammFensterHoehe = -1) THEN
     SetBounds(Trunc((Screen.WorkAreaWidth - 800) / 2), Trunc((Screen.WorkAreaHeight - 600) / 2),
               800, 600)
  ELSE
    SetBounds(ArbeitsumgebungObj.ProgrammFensterLinks, ArbeitsumgebungObj.ProgrammFensterOben,
              ArbeitsumgebungObj.ProgrammFensterBreite, ArbeitsumgebungObj.ProgrammFensterHoehe);
  IF ArbeitsumgebungObj.ProgrammFensterMaximized THEN
    WindowState := wsMaximized;  }
  AudioSkewPanel.Visible := ArbeitsumgebungObj.AudiooffsetfensterSichtbar;
  AudioSkewPanel.Height := ArbeitsumgebungObj.AudiooffsetfensterHoehe;
  IF AudioSkewPanel.Height <> 30 THEN
    AudioSkewPanel.Height := 110;
  AudiooffseteinPanel.Visible := NOT AudioSkewPanel.Visible;
  SchiebereglermittePanel.Visible := ArbeitsumgebungObj.SchiebereglerMarkeranzeigen;
  SchiebereglerMarkerPosition := ArbeitsumgebungObj.SchiebereglerMarkerPosition;
  SchnittlistenTab.PageIndex := ArbeitsumgebungObj.SchnitteTabPos;
  KapitellistenTab.PageIndex := ArbeitsumgebungObj.KapitelTabPos;
  MarkenlistenTab.PageIndex := ArbeitsumgebungObj.MarkenTabPos;
  InformationenTab.PageIndex := ArbeitsumgebungObj.InfoTabPos;
  DateienTab.PageIndex := ArbeitsumgebungObj.DateienTabPos;
  IF ArbeitsumgebungObj.DateienimListenfenster THEN
  BEGIN
    DateienTab.TabVisible := True;
    Dateien.Parent := DateienTab;
    DateienfensterausPanel.Visible := False;
    DateifenstereinPanel.Visible := False;
  END
  ELSE
  BEGIN
    DateienfensterausPanel.Visible := ArbeitsumgebungObj.DateienfensterSichtbar;
    DateifenstereinPanel.Visible := NOT DateienfensterausPanel.Visible;
    Dateien.Parent := DateienfensterausPanel;
    DateienTab.TabVisible := False;
    DateienTab.PageIndex := Listen.PageCount - 1;
  END;
  DateienTrennPanel.Visible := DateienfensterausPanel.Visible;
  Fenstereinstellen;
{  IF ArbeitsumgebungObj.Videoanzeigefaktor = 0 THEN
    Maximal.Checked := True
  ELSE
    Fenstergroesseanpassen(ArbeitsumgebungObj.Videoanzeigefaktor);
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 0.5 THEN
    Doppelt.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 0.75 THEN
    EinsFuenfzuEins.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 1 THEN
    EinszuEins.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 1.5 THEN
    EinszuEinsFuenf.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 2 THEN
    EinszuZwei.Checked := True;
  IF ArbeitsumgebungObj.Videoanzeigefaktor = 4 THEN
    EinszuVier.Checked := True;  }
  IF ArbeitsumgebungObj.Bilderdateigeaendert THEN
    LadeIconTemplate(ArbeitsumgebungObj.Bilderverwenden, ArbeitsumgebungObj.Bilderdatei);
  IF Anzeigeflaeche.Visible = Bildflaeche.Visible THEN
    Anzeigeflaeche.Color := ArbeitsumgebungObj.Videohintergrundfarbeakt
  ELSE
    Anzeigeflaeche.Color := ArbeitsumgebungObj.Videohintergrundfarbe;
  Bildflaeche.Color := ArbeitsumgebungObj.Videohintergrundfarbe;
  Font.Name := ArbeitsumgebungObj.HauptfensterSchriftart;
  Font.Size := ArbeitsumgebungObj.HauptfensterSchriftgroesse;
  TastenPanel.Font.Name := ArbeitsumgebungObj.TastenfensterSchriftart;
  TastenPanel.Font.Size := ArbeitsumgebungObj.TastenfensterSchriftgroesse;
  SchnittuebernehmenPanel.Font.Name := ArbeitsumgebungObj.TastenfensterSchriftart;
  SchnittuebernehmenPanel.Font.Size := ArbeitsumgebungObj.TastenfensterSchriftgroesse;
  SymbolleistePanel.Font.Name := ArbeitsumgebungObj.TastenfensterSchriftart;
  SymbolleistePanel.Font.Size := ArbeitsumgebungObj.TastenfensterSchriftgroesse;
  BtnVideoAdd.Font.Name := ArbeitsumgebungObj.TastenfensterSchriftart;
  BtnVideoAdd.Font.Size := ArbeitsumgebungObj.TastenfensterSchriftgroesse;
  Anzeige.Font.Name := ArbeitsumgebungObj.AnzeigefensterSchriftart;
  Anzeige.Font.Size := ArbeitsumgebungObj.AnzeigefensterSchriftgroesse;
  IF ArbeitsumgebungObj.TastenFetteSchrift THEN
  BEGIN
    TastenPanel.Font.Style := [fsBold];
    SchnittuebernehmenPanel.Font.Style := [fsBold];
    SymbolleistePanel.Font.Style := [fsBold];
    BtnVideoAdd.Font.Style := [fsBold];
  END
  ELSE
  BEGIN
    TastenPanel.Font.Style := [];
    SchnittuebernehmenPanel.Font.Style := [];
    SymbolleistePanel.Font.Style := [];
    BtnVideoAdd.Font.Style := [];
  END;
  Schnittliste.ItemHeight := 16;
  SchnittListeFormat;
END;

procedure TMpegEdit.SprachenMenueClick(Sender: TObject);

VAR I : Integer;
    Menuepunkt : TMenuItem;

begin
  Pause;
  WHILE Sprachmenue.Count > 1 DO
  BEGIN
    Sprachmenue.Items[1].Free;
  END;
  FOR I := 0 TO SprachenListe.Count - 1 DO
    IF Assigned(SprachenListe.Objects[I]) THEN
    BEGIN
      Menuepunkt := TMenuItem.Create(Self);
      Menuepunkt.Caption := TDateiListeneintrag(SprachenListe.Objects[I]).Name;
      Menuepunkt.RadioItem := True;
      Menuepunkt.GroupIndex := 1;
      Menuepunkt.OnClick := SpracheeinlesenClick;
      Sprachmenue.Add(Menuepunkt);
      IF aktuelleSprache = TDateiListeneintrag(SprachenListe.Objects[I]).Name THEN
        Menuepunkt.Checked := True;
    END;
end;

PROCEDURE TMpegEdit.SpracheeinlesenClick(Sender: TObject);

VAR I : Integer;

BEGIN
  IF NOT TMenuItem(Sender).Checked THEN
  BEGIN
    I := TMenuItem(Sender).MenuIndex - 1;
    IF (I < SprachenListe.Count) THEN
      IF  FileExists(Sprachverzeichnis + TDateiListeneintrag(SprachenListe.Objects[I]).Dateiname) THEN
      BEGIN
        aktuelleSprache := TDateiListeneintrag(SprachenListe.Objects[I]).Name;
        Sprachdateiname := TDateiListeneintrag(SprachenListe.Objects[I]).Dateiname;
        Spracheeinlesen;
      END;
  END;
END;

PROCEDURE TMpegEdit.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Caption := UeberFenster.VersionNr;
  IF Projektname <> '' THEN
    Caption := Caption + '   ' + WortProjekt + ': ' + Projektname;
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
    END
    ELSE
    IF Komponente IS TBitBtn THEN             // in der Unit Buttons
    BEGIN
      TBitBtn(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TBitBtn(Komponente).Caption);
      TBitBtn(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TBitBtn(Komponente).Hint);
    END
    ELSE
    IF Komponente IS TButton THEN             // in der Unit StdCtrls
    BEGIN
      TButton(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TButton(Komponente).Caption);
      TButton(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TButton(Komponente).Hint);
    END
    ELSE
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
    END
    ELSE
    IF Komponente IS TMenuItem THEN           // in der Unit Menus
    BEGIN
      IF Komponente.Name <> '' THEN
      BEGIN
        TMenuItem(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TMenuItem(Komponente).Caption);
        TMenuItem(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TMenuItem(Komponente).Hint);
      END;
    END
    ELSE
    IF Komponente IS TGroupBox THEN           // in der Unit StdCtrls
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
    ELSE
    IF Komponente IS TEdit THEN               // in der Unit StdCtrls
    BEGIN
      TEdit(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TEdit(Komponente).Hint);
    END;
  END;
  Eigenschaftenanzeigen;
  SetPositionIn(PositionIn);
  SetPositionOut(PositionOut);
  SetSelectionLength;
END;

PROCEDURE TMpegEdit.Spracheeinlesen;

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
    IF Assigned(SchnittsucheFenster) THEN
      SchnittsucheFenster.Spracheaendern(Spracheladen);
    IF Assigned(Fortschrittsfenster) THEN
      Fortschrittsfenster.Spracheaendern(Spracheladen);
    IF Assigned(ArbeitsumgebungFenster) THEN
      ArbeitsumgebungFenster.Spracheaendern(Spracheladen);
    IF Assigned(OptionenFenster) THEN
      OptionenFenster.Spracheaendern(Spracheladen);
    IF Assigned(Effektfenster) THEN
      Effektfenster.Spracheaendern(Spracheladen);
    IF Assigned(Ausgabefenster) THEN
      Ausgabefenster.Spracheaendern(Spracheladen);
    IF Assigned(FilmGrobAnsichtFrm) THEN
      FilmGrobAnsichtFrm.Spracheaendern(Spracheladen);
    IF Assigned(ArbeitsumgebungObj) THEN
      ArbeitsumgebungObj.Spracheaendern(Spracheladen);
    KapitelListeSpracheaendern(Spracheladen);
  FINALLY
    IF Sprachobjektloeschen THEN
      Sprachobjektfreigeben(Spracheladen);
  END;
{******************************************************************************}
//Patch: Mpeg2Schnitt Extension MOD by Lostech (www.lostech.de.vu)
  ProjectXForm.AktualisiereProjectXSprache;
  DVDForm.AktualisiereDVDSprache;
{******************************************************************************}
END;

procedure TMpegEdit.ArbeitsumgebungenMenueClick(Sender: TObject);

VAR Menuepunkt : TMenuItem;
    I : Integer;

begin
  Pause;
  WHILE Arbeitsumgebungenmenue.Count > 2 DO
  BEGIN
    Arbeitsumgebungenmenue.Items[2].Free;
  END;
  FOR I := 0 TO ArbeitsumgebungenListe.Count - 1 DO
    IF Assigned(ArbeitsumgebungenListe.Objects[I]) THEN
    BEGIN
      Menuepunkt := TMenuItem.Create(Self);
      Menuepunkt.Caption := TDateiListeneintrag(ArbeitsumgebungenListe.Objects[I]).Name;
      Menuepunkt.RadioItem := True;
      Menuepunkt.GroupIndex := 2;
      Menuepunkt.OnClick := Arbeitsumgebung_aktivClick;
      Arbeitsumgebungenmenue.Add(Menuepunkt);
      IF aktArbeitsumgebung = I THEN
        Arbeitsumgebungenmenue.Items[I + 2].Checked := True;
    END;
end;

procedure TMpegEdit.ArbeitsumgebungenbearbeitenClick(Sender: TObject);
begin
  Fensterpositionmerken;
  Fensteranzeigemerken;
  Kapitelspaltenbreitemerken;
  FilmGrobAnsichtFrm.Fensterpositionmerken;
  binaereSucheForm.Fensterpositionmerken;
  Dialogaktiv := True;
  IF ArbeitsumgebungFenster.ShowModal = mrOk THEN
  BEGIN
    ZielDateinameCLaktiv := False;
    FramegenauschneidenCLaktiv := False;
    nachSchneidenbeendenCL := False;
    letztesVideoanzeigenCLaktiv := False;
    aktArbeitsumgebungCLaktiv := False;
    Arbeitsumgebung_lesen;
  END;
  Dialogaktiv := False;
end;

PROCEDURE TMpegEdit.Arbeitsumgebung_aktivClick(Sender: TObject);

VAR I : Integer;

BEGIN
  IF NOT TMenuItem(Sender).Checked THEN
  BEGIN
    I := TMenuItem(Sender).MenuIndex - 2;
    IF (I < ArbeitsumgebungenListe.Count) THEN
      IF (FileExists(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[I]).Dateiname) OR
         (I = 0)) THEN
      BEGIN
        Fensterpositionmerken;
        Fensteranzeigemerken;
        Kapitelspaltenbreitemerken;
        FilmGrobAnsichtFrm.Fensterpositionmerken;
        binaereSucheForm.Fensterpositionmerken;
        aktArbeitsumgebungspeichern;
        Arbeitsumgebungladen(I);
        Arbeitsumgebung_lesen;
        ZielDateinameCLaktiv := False;
        FramegenauschneidenCLaktiv := False;
        nachSchneidenbeendenCL := False;
        letztesVideoanzeigenCLaktiv := False;
        aktArbeitsumgebungCLaktiv := False;
      END
      ELSE
        Meldungsfenster(Meldunglesen(NIL, 'Meldung105', TMenuItem(Sender).Caption, 'Die angewählte Arbeitsumgebung "$Text1#" existiert nicht.') + Chr(13) +
                        Wortlesen(NIL, 'Meldung106', 'Bitte die Arbeitsumgebung aus der Liste löschen.'),
                        Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//        Showmessage(Meldunglesen(NIL, 'Meldung105', TMenuItem(Sender).Caption, 'Die angewählte Arbeitsumgebung "$Text1#" existiert nicht.') + Chr(13) +
//                    Wortlesen(NIL, 'Meldung106', 'Bitte die Arbeitsumgebung aus der Liste löschen.'));
  END;
END;

// ------------------------- Dateienliste Funktionen/Proceduren --------------------------------

PROCEDURE TMpegEdit.KnotenpunktDatenloeschen(Knoten: TTreenode);

VAR Unterknoten : TTreenode;
    I : Integer;

BEGIN
  IF Knoten.HasChildren THEN                         // hat der Knoten Unterknoten
    FOR I := 0 TO Knoten.Count - 1 DO                // dann alle Unterkoten durchlaufen
    BEGIN
      Unterknoten := Knoten.Item[I];
      KnotenpunktDatenloeschen(Unterknoten);         // Procedure rekursiv aufrufen
    END;
  IF Assigned(Knoten.Data) THEN                      // ist ein Datenobjekt vorhanden
  BEGIN
    TObject(Knoten.Data).Free;                       // dann freigeben und
    Knoten.Data := NIL;                              // mit NIL kennzeichnen
    Knoten.Text := LeftStr(Knoten.Text, Pos(' -> ', Knoten.Text) + 3);
    IF Knoten.Parent <> VorschauKnoten THEN
    BEGIN
      IF Knoten = aktVideoknoten THEN
      BEGIN
        DateilisteaktualisierenVideo(Knoten, False);
        Schnittpunktanzeigeloeschen;
      END;
      IF (Knoten = aktAudioknoten) THEN
      BEGIN
        DateilisteaktualisierenAudio(Knoten, False);
        Schnittpunktanzeigeloeschen;
      END;
    END;
    IF Assigned(VorschauVideoknoten) AND (Knoten = VorschauVideoknoten) THEN
    BEGIN
      IF Assigned(VorschauListe) THEN
      BEGIN
        VorschauListe.Loeschen;
        VorschauListe.Free;
        VorschauListe := NIL;
      END;
      IF Assigned(VorschauIndexListe) THEN
      BEGIN
        VorschauIndexListe.Loeschen;
        VorschauIndexListe.Free;
        VorschauIndexListe := NIL;
      END;
      IF Assigned(VorschauSequenzHeader) THEN
      BEGIN
        VorschauSequenzHeader.Free;
        VorschauSequenzHeader := NIL;
      END;
      IF Assigned(VorschauBildHeader) THEN
      BEGIN
        VorschauBildHeader.Free;
        VorschauBildHeader := NIL;
      END;
      VorschauVideoknoten := NIL;
    END;
    IF Assigned(VorschauAudioknoten) AND (Knoten = VorschauAudioknoten) THEN
    BEGIN
      IF Assigned(VorschauAudioListe) THEN
      BEGIN
        VorschauAudioListe.Loeschen;
        VorschauAudioListe.Free;
        VorschauAudioListe := NIL;
      END;
      IF Assigned(VorschauAudioHeader) THEN
      BEGIN
        VorschauAudioHeader.Free;
        VorschauAudioHeader := NIL;
      END;
      VorschauAudioknoten := NIL;
    END;
  END;
END;

PROCEDURE TMpegEdit.Dateienlisteloeschen;

VAR Knotenpunkt : TTreenode;
    I : Integer;

BEGIN
  FOR I := 0 TO Dateien.Items.Count - 1 DO                             // alle Knoten durchlaufen
  BEGIN
    Knotenpunkt := Dateien.Items[I];
    IF Knotenpunkt.Level = 0 THEN                                      // und die Datenobjekte löschen
      KnotenpunktDatenloeschen(Knotenpunkt);
  END;
  aktVideoknoten := NIL;
  aktVideoknotenNr_.Caption := '00';
  aktAudioknoten := NIL;
  aktAudioknotenNr_.Caption := '00';
  Dateien.Items.Clear;                                                 // alle Knoten löschen
  VorschauKnoten := NIL;
  Projektgeaendert_zuruecksetzen;
END;

FUNCTION TMpegEdit.DateienlisteneintragAudio_vorhandenKnoten(Knoten: TTreeNode; Audioname : STRING): Boolean;
BEGIN
  IF DateienlisteneintragAudio_suchenKnoten(Knoten, Audioname) = NIL THEN
    Result := False
  ELSE
    Result := True;
END;

FUNCTION TMpegEdit.DateienlisteneintragAudio_suchenKnoten(Knoten: TTreeNode; Audioname : STRING): TTreeNode;

VAR I : Integer;
    Audiodateieintrag : TDateieintragAudio;
    Knotenzahl : Integer;

BEGIN
  I := 0;
  Result := NIL;
  IF Assigned(Knoten) THEN
    Knotenzahl := Knoten.Count
  ELSE
    Knotenzahl := Dateien.Items.Count;
  WHILE I < Knotenzahl DO
  BEGIN
    IF Assigned(Knoten) THEN
      Result := Knoten.Item[I]
    ELSE
      Result := Dateien.Items[I];
    IF Result.Level > 0 THEN
    BEGIN
      Audiodateieintrag := TDateieintragAudio(Result.Data);
      IF Assigned(Audiodateieintrag) THEN
        IF Audiodateieintrag.Name = Audioname THEN
          I := Knotenzahl;
    END;
    Inc(I);
  END;
  IF I = Knotenzahl THEN
    Result := NIL;
END;

FUNCTION TMpegEdit.DateienlisteHauptknotenNr(Knoten: TTReeNode; Knotenzahl: Boolean = False): Integer;

VAR I : Integer;

BEGIN
  I := 0;
  Result := 0;
  IF Assigned(Knoten) OR
     Knotenzahl THEN
    WHILE I < Dateien.Items.Count DO
    BEGIN
      IF Dateien.Items[I].Level = 0 THEN
        Inc(Result);
      IF Dateien.Items[I] = Knoten THEN
        I := Dateien.Items.Count
      ELSE
        Inc(I);
    END;
END;

PROCEDURE TMpegEdit.DateienlisteHauptknotenNrneuschreiben;

VAR I, Position : Integer;

BEGIN
  I := 0;
  WHILE I < Dateien.Items.Count DO
  BEGIN
    IF Dateien.Items[I].Level = 0 THEN
    BEGIN
     Position := Pos(' ', Dateien.Items[I].Text);
      IF Position > 0 THEN
        IF StrToIntDef(LeftStr(Dateien.Items[I].Text, Position - 1), 0) > 0 THEN
          Dateien.Items[I].Text := IntToStrFmt(DateienlisteHauptknotenNr(Dateien.Items[I]), 2) + RightStr(Dateien.Items[I].Text, Length(Dateien.Items[I].Text) - Position + 1)
        ELSE
          Dateien.Items[I].Text := IntToStrFmt(DateienlisteHauptknotenNr(Dateien.Items[I]), 2) + ' ' + Dateien.Items[I].Text
      ELSE
        Dateien.Items[I].Text := IntToStrFmt(DateienlisteHauptknotenNr(Dateien.Items[I]), 2) + ' ' + Dateien.Items[I].Text;
    END;
    Inc(I);
  END;
END;

FUNCTION TMpegEdit.DateienlisteKnotenStrukturerzeugen(Knotenname : STRING): TTReeNode;

VAR I : Integer;

BEGIN
  Result := Dateien.Items.Add(NIL, IntToStrFmt(DateienlisteHauptknotenNr(NIL, True) + 1, 2) + ' ' + ChangeFileExt(ExtractFileName(Knotenname), ''));
  Dateien.Items.AddChild(Result, WortVideo + ' -> ');
  FOR I := Result.Count TO Dateien.Items[0].Count - 1 DO
    Dateien.Items.AddChild(Result, WortAudio + ' ' + IntToStr(I) + ' -> ');
END;

PROCEDURE TMpegEdit.DateienlisteKnotenerzeugenAudio;

VAR I : Integer;

BEGIN
  I := 0;
  WHILE I < Dateien.Items.Count DO
  BEGIN
    IF Dateien.Items[I].Level = 0 THEN
      Dateien.Items.AddChild(Dateien.Items[I], WortAudio + ' ' + IntToStr(Dateien.Items[I].Count) + ' -> ');
    Inc(I);
  END;
END;

FUNCTION TMpegEdit.DateienlisteEintrageinfuegenVideo(Knoten: TTreeNode; Videoname : STRING): TTReeNode;

VAR Dateieintrag : TDateieintrag;

BEGIN
  Result := NIL;
  IF NOT Assigned(Knoten) THEN
    Knoten := DateienlisteKnotenStrukturerzeugen(Videoname);
  IF Knoten.Level > 0 THEN
    Knoten := Knoten.Parent;
  Dateieintrag := TDateieintrag.Create;
  Dateieintrag.Name := Videoname;
  IF Knoten.HasChildren THEN
  BEGIN
    Result := Knoten.Item[0];
    Result.Text := Knoten.Item[0].Text + Videoname;
    Result.Data := Dateieintrag;
  END;
END;

FUNCTION TMpegEdit.ExtractAudioendungSpur(Spur: Integer; Liste: TStrings): STRING;

VAR I, J : Integer;
    gefunden : Boolean;

BEGIN
  Result := '';
  gefunden := False;
  I := 0;
  WHILE (I < Dateien.Items.Count) AND (NOT gefunden) DO     // Dateienliste durchsuchen
  BEGIN
    IF Dateien.Items[I].Level = 0 THEN                      // nur Knoten der ersten Ebene betrachten
    BEGIN
      IF Assigned(Liste) THEN                               // ist eine Liste übergeben worden
      BEGIN
        J := 0;
        WHILE (J < Liste.Count) AND (NOT gefunden) DO       // prüfen ob der Knoten in der Liste ist
        BEGIN
          IF Assigned(Liste.Objects[J]) THEN
            IF TSchnittpunkt(Liste.Objects[J]).Audioknoten = Dateien.Items[I] THEN
              gefunden := True;
          Inc(J);
        END;
      END
      ELSE                                                  // wurde keine Liste übergeben
        gefunden := True;                                   // sind alle Knoten betrachten
      IF gefunden THEN                                      // ist der Knoten zu betrachten,
        IF Spur < Dateien.Items[I].Count THEN               // hat genug Unterknoten
          IF Assigned(Dateien.Items[I].Item[Spur].Data) THEN  // und hat Daten
            Result := ExtractAudioendung(TDateieintragAudio(Dateien.Items[I].Item[Spur].Data).Name)
          ELSE                                              // die Endung extrahieren, gefunden bleibt True
            gefunden := False                               // der Knoten hat keine Daten, weitersuchen
        ELSE
          gefunden := False;                                // der Knoten hat zu wenig Unterknoten, weitersuchen
    END;
    Inc(I);
  END;
  IF NOT gefunden THEN                                      // keine Daten in den betrachteten Knoten dieser Spur
    Result := '$leer#';
END;

FUNCTION TMpegEdit.ExtractVideoendungSpur(Liste: TStrings): STRING;

VAR I, J : Integer;
    gefunden : Boolean;

BEGIN
  Result := '';
  gefunden := False;
  I := 0;
  WHILE (I < Dateien.Items.Count) AND (NOT gefunden) DO     // Dateienliste durchsuchen
  BEGIN
    IF Dateien.Items[I].Level = 0 THEN                      // nur Knoten der ersten Ebene betrachten
    BEGIN
      IF Assigned(Liste) THEN                               // ist eine Liste übergeben worden
      BEGIN
        J := 0;
        WHILE (J < Liste.Count) AND (NOT gefunden) DO       // prüfen ob der Knoten in der Liste ist
        BEGIN
          IF Assigned(Liste.Objects[J]) THEN
            IF TSchnittpunkt(Liste.Objects[J]).Videoknoten = Dateien.Items[I] THEN
              gefunden := True;
          Inc(J);
        END;
      END
      ELSE                                                  // wurde keine Liste übergeben
        gefunden := True;                                   // sind alle Knoten betrachten
      IF gefunden THEN                                      // ist der Knoten zu betrachten,
        IF Dateien.Items[I].HasChildren THEN                // hat genug Unterknoten
          IF Assigned(Dateien.Items[I].Item[0].Data) THEN   // und hat Daten
            Result := ExtractFileExt(TDateieintrag(Dateien.Items[I].Item[0].Data).Name)
          ELSE                                              // die Endung extrahieren, gefunden bleibt True
            gefunden := False                               // der Knoten hat keine Daten, weitersuchen
        ELSE
          gefunden := False;                                // der Knoten hat zu wenig Unterknoten, weitersuchen
    END;
    Inc(I);
  END;
  IF NOT gefunden THEN                                      // keine Daten in den betrachteten Knoten dieser Spur
    Result := '$leer#';
END;

FUNCTION TMpegEdit.DateienlisteEintrageinfuegenAudio(Knoten: TTreeNode; Audioname : STRING; Audiooffset: Integer; Spur: Integer = -1): TTreeNode;

VAR Audiodateieintrag : TDateieintragAudio;
    I : Integer;

FUNCTION NeuenKnoteneinfuegen(Knoten: TTreeNode; KnotenName: STRING; Daten: TDateieintragAudio): TTreeNode;
BEGIN
  Result := Dateien.Items.InsertObject(Knoten, Knoten.Text + KnotenName, Daten);
  KnotenpunktDatenloeschen(Knoten);
  Dateien.Items.Delete(Knoten);
  SchnittgroesseneuberechnenAudio(Result);
  IF Knoten = aktAudioknoten THEN                                               // der aktive Audioknoten wird ersetzt
  BEGIN
    TRY
      Dateilisteaktualisieren(Result);                                          // Anzeige aktualisieren
    FINALLY
      Fortschrittsfensterverbergen;
    END;
    Schnittpunktanzeigekorrigieren;
  END;
END;

BEGIN
  Result := NIL;
  IF NOT Assigned(Knoten) THEN
    Knoten := DateienlisteKnotenStrukturerzeugen(Audioname);
  IF Knoten.Level > 0 THEN
    Knoten := Knoten.Parent;
  Audiodateieintrag  :=  TDateieintragAudio.Create;
  Audiodateieintrag.Name := Audioname;
  Audiodateieintrag.Audiooffset := Audiooffset;
  IF Spur < 0 THEN
  BEGIN
    I := 1;
    WHILE (I < Knoten.Count) AND (NOT Assigned(Result)) DO
    BEGIN                         // passenden Audioknoten suchen
      IF (NOT Assigned(Knoten.Item[I].Data)) AND
         (ExtractAudioendung(Audioname) = ExtractAudioendungSpur(I, NIL)) THEN
        BEGIN
 //         Result := Knoten.Item[I];
 //         Result.Text := Result.Text + Audioname;
 //         Result.Data := Audiodateieintrag;
          Result := NeuenKnoteneinfuegen(Knoten.Item[I], Audioname, Audiodateieintrag);
        END;
      Inc(I);
    END;
  END
  ELSE
  BEGIN
    WHILE Spur > Knoten.Count - 1 DO
      DateienlisteKnotenerzeugenAudio;
 //   Result := Knoten.Item[Spur];
 //   Result.Text := Result.Text + Audioname;
 //   Result.Data := Audiodateieintrag;
    Result := NeuenKnoteneinfuegen(Knoten.Item[Spur], Audioname, Audiodateieintrag);
  END;
  IF NOT Assigned(Result) THEN  // keinen passenden Audioknoten gefunden, neuen erzeugen
  BEGIN
    DateienlisteKnotenerzeugenAudio;
 //   Result := Knoten.Item[Knoten.Count - 1];
 //   Result.Text := Result.Text + Audioname;
 //   Result.Data := Audiodateieintrag;
    Result := NeuenKnoteneinfuegen(Knoten.Item[Knoten.Count - 1], Audioname, Audiodateieintrag);
  END;
END;

FUNCTION TMpegEdit.aktAudiospursuchen(Knoten: TTreeNode; Standard: Boolean = True): Integer;

VAR I : Integer;

BEGIN
  Result := -1;
  IF (Assigned(Knoten)) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    IF Assigned(aktAudioknoten) AND
       (aktAudioknoten.Level > 0) THEN
        Result := aktAudioknoten.Parent.IndexOf(aktAudioknoten);
    IF Standard AND (Result < 0) THEN               // keine aktive Audiospur gefunden
    BEGIN
      I := 1;
      WHILE (I < Knoten.Count) AND (Result < 0) DO  // Audioknoten mit Standardendung suchen
      BEGIN
        IF Assigned(Knoten.Item[I]) AND
           Assigned(Knoten.Item[I].Data) THEN
            IF ExtractFileExt(TDateieintragAudio(Knoten.Item[I].Data).Name) = ArbeitsumgebungObj.StandardEndungenAudio THEN
              Result := I;
        Inc(I);
      END;
    END;
  END;
END;  

FUNCTION TMpegEdit.AktivenAudioknotensuchen(Knoten: TTreeNode): TTreeNode;

VAR I : Integer;

BEGIN
  Result := NIL;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    I := aktAudiospursuchen(Knoten);
    IF I < 0 THEN
      IF Knoten.Count > 1 THEN
        I := 1;
    IF (I > -1) AND                             // Audiospur gefunden
       (I < Knoten.Count) THEN
      Result := Knoten.Item[I]
    ELSE
      Result := NIL;                            // keine Audioknoten vorhanden
  END;
END;

FUNCTION TMpegEdit.DateigeoeffnetVideo(Knoten: TTreeNode): Boolean;
BEGIN
  Result := False;
  IF Assigned(Knoten) THEN
  BEGIN
    IF (Knoten.Level = 0) AND Knoten.HasChildren THEN
      Knoten := Knoten.Item[0]
    ELSE
      Knoten := NIL;
    IF Assigned(Knoten) AND Assigned(Knoten.Data) AND
       Assigned(aktVideoknoten) AND Assigned(aktVideoknoten.Data) THEN
      IF TDateieintrag(Knoten.Data).Name =  TDateieintrag(aktVideoknoten.Data).Name THEN
        Result := True;
  END;
END;

FUNCTION TMpegEdit.DateigeoeffnetAudio(Knoten: TTreeNode; Spur: Integer): Boolean;
BEGIN
  Result := False;
  IF Assigned(Knoten) THEN
  BEGIN
    IF (Knoten.Level = 0) AND (Knoten.Count > Spur) THEN
      Knoten := Knoten.Item[Spur]
    ELSE
      Knoten := NIL;
    IF Assigned(Knoten) AND Assigned(Knoten.Data) AND
       Assigned(aktAudioknoten) AND Assigned(aktAudioknoten.Data) THEN
      IF TDateieintragAudio(Knoten.Data).Name =  TDateieintragAudio(aktAudioknoten.Data).Name THEN
        Result := True;
  END;
END;

FUNCTION TMpegEdit.KnotenhatDaten(Knoten: TTreeNode): Boolean;
BEGIN
  IF Assigned(Knoten) AND (Knoten.Level > 0) AND
     Assigned(Knoten.Data) THEN
    Result := True
  ELSE
    Result := False;
END;

FUNCTION TMpegEdit.KnotenDatengleich(Knoten1, Knoten2: TTreeNode): Boolean;
BEGIN
  IF Knoten1 <> Knoten2 THEN                  // beide Knoten sind unterschiedlich
    IF (Assigned(Knoten1) AND (Knoten1.Level = 0)) OR
       (Assigned(Knoten2) AND (Knoten2.Level = 0)) THEN
      Result := False                         // nur Knoten des Levels 1 werden bearbeitet
                                              // !!! DAS ERGEBNIS IST UNBESTIMMT !!!
    ELSE
      IF Assigned(Knoten1) AND Assigned(Knoten2) THEN
        IF Assigned(Knoten1.Data) AND Assigned(Knoten2.Data) THEN
          IF TDateieintrag(Knoten1.Data).Name = TDateieintrag(Knoten2.Data).Name THEN
            Result := True                    // die Dateien sind gleich
          ELSE
            Result := False                   // die Dateien sind verschieden
        ELSE
          IF Assigned(Knoten1.Data) OR Assigned(Knoten2.Data) THEN
            Result := False                   // nur ein Knoten hat Datei
          ELSE
            Result := True                    // beide Knoten haben keine Daten
      ELSE
        IF Assigned(Knoten1) THEN             // nur Knoten1 ist vorhanden
          IF Assigned(Knoten1.Data) THEN
            Result := False                   // nur Knoten1 hat Daten
          ELSE
            Result := True                    // Knoten1 hat keine Daten und Knoten2 ist nicht vorhanden
        ELSE
          IF Assigned(Knoten2) THEN           // nur Knoten2 ist vorhanden
            IF Assigned(Knoten2.Data) THEN
              Result := False                 // nur Knoten2 hat Daten
            ELSE
              Result := True                  // Knoten2 hat keine Daten und Knoten1 ist nicht vorhanden
          ELSE
            Result := True                    // beide Knoten sind leer
  ELSE
    Result := True;                           // beide Knoten sind gleich
END;

FUNCTION TMpegEdit.KnotenDatengleichVideo(Knoten1, Knoten2: TTreeNode): Boolean;
BEGIN
  IF Assigned(Knoten1) THEN
    IF Knoten1.Level > 0 THEN           // es wurde ein Knoten höherer Ebene übergeben
      Knoten1 := Knoten1.Parent;
  IF Assigned(Knoten2) THEN
    IF Knoten2.Level > 0 THEN           // es wurde ein Knoten höherer Ebene übergeben
      Knoten2 := Knoten2.Parent;
  IF Knoten1 <> Knoten2 THEN            // beide Knoten sind gleich
    IF (Assigned(Knoten1) AND (NOT Knoten1.HasChildren)) OR
       (Assigned(Knoten2) AND (NOT Knoten2.HasChildren)) THEN
      Result := False                   // existierende Knoten müssen Unterknoten haben
                                        // !!! DAS ERGEBNIS IST UNBESTIMMT !!!
    ELSE
      IF Assigned(Knoten1) AND Assigned(Knoten2) THEN   // beide Knoten existieren
        Result := KnotenDatengleich(Knoten1.Item[0], Knoten2.Item[0])
      ELSE
        IF Assigned(Knoten1) THEN
          IF KnotenhatDaten(Knoten1.Item[0]) THEN
            Result := False             // nur Knoten1 hat Daten
          ELSE
            Result := True              // Knoten1 hat keine Daten und Knoten2 ist nicht vorhanden
        ELSE
          IF Assigned(Knoten2) THEN
            IF KnotenhatDaten(Knoten2.Item[0]) THEN
              Result := False           // nur Knoten2 hat Daten
            ELSE
              Result := True            // Knoten2 hat keine Daten und Knoten1 ist nicht vorhanden
          ELSE
            Result := True              // beide Knoten sind leer
  ELSE
    Result := True;                     // beide Knoten sind gleich
END;

FUNCTION TMpegEdit.KnotenDatengleichAudio(Knoten1, Knoten2: TTreeNode): Boolean;

VAR I : Integer;

BEGIN
  IF Assigned(Knoten1) THEN
    IF Knoten1.Level > 0 THEN           // es wurde ein Knoten höherer Ebene übergeben
      Knoten1 := Knoten1.Parent;
  IF Assigned(Knoten2) THEN
    IF Knoten2.Level > 0 THEN           // es wurde ein Knoten höherer Ebene übergeben
      Knoten2 := Knoten2.Parent;
  IF Knoten1 <> Knoten2 THEN            // beide Knoten sind gleich
    IF (Assigned(Knoten1) AND (NOT Knoten1.HasChildren)) OR
       (Assigned(Knoten2) AND (NOT Knoten2.HasChildren)) THEN
      Result := False                   // existierende Knoten müssen Unterknoten haben
                                        // !!! DAS ERGEBNIS IST UNBESTIMMT !!!
    ELSE
      IF Assigned(Knoten1) AND Assigned(Knoten2) THEN   // beide Knoten existieren
        IF Knoten1.Count = Knoten2.Count THEN
        BEGIN
          Result := True;               // beide Knoten haben die gleiche Anzahl Unterknoten
          FOR I := 1 TO Knoten1.Count - 1 DO
            IF NOT KnotenDatengleich(Knoten1.Item[I], Knoten2.Item[I]) THEN
              Result := False;          // mindestens ein Unterknotenpaar ist unterschiedlich
        END
        ELSE
          Result := False               // beide Knoten haben eine unterschiedliche Anzahl Unterknoten
      ELSE
        IF Assigned(Knoten1) THEN
        BEGIN
          Result := True;               // Knoten1 hat keine Daten und Knoten2 ist nicht vorhanden
          FOR I := 1 TO Knoten1.Count - 1 DO
            IF KnotenhatDaten(Knoten1.Item[I]) THEN
              Result := False;          // mindestens ein Unterknoten von Knoten1 hat Daten
        END
        ELSE
          IF Assigned(Knoten2) THEN
          BEGIN
            Result := True;             // Knoten2 hat keine Daten und Knoten1 ist nicht vorhanden
            FOR I := 1 TO Knoten2.Count - 1 DO
              IF KnotenhatDaten(Knoten2.Item[I]) THEN
                Result := False;        // mindestens ein Unterknoten von Knoten2 hat Daten
          END
          ELSE
            Result := True              // beide Knoten sind leer
  ELSE
    Result := True;                     // beide Knoten sind gleich
END;

FUNCTION TMpegEdit.KnotenDateigleich(Knoten1, Knoten2: TTreeNode): Integer;
BEGIN
  IF Assigned(Knoten1) AND Assigned(Knoten2) THEN
    IF Knoten1 <> Knoten2 THEN
      IF Assigned(Knoten1.Data) AND Assigned(Knoten2.Data) THEN
        IF TDateieintrag(Knoten1.Data).Name <> TDateieintrag(Knoten2.Data).Name THEN
          Result := -2                 // die Dateien sind unterschiedlich
        ELSE
          Result := 2                  // beide Knoten verweisen auf die selbe Datei
      ELSE
        IF Assigned(Knoten1.Data) OR Assigned(Knoten2.Data) THEN
          Result := -2                 // nur ein Knoten hat Daten
        ELSE
          Result := 1                  // beide Knoten haben keine Datei
    ELSE
      IF Assigned(Knoten1.Data) THEN
        Result := 0                    // beide Knoten sind gleich
      ELSE
        Result := 5                    // beide Knoten sind gleich, haben aber keine Daten
  ELSE
    IF Assigned(Knoten1) OR Assigned(Knoten2) THEN
      IF Assigned(Knoten1) THEN
        IF Assigned(Knoten1.Data) THEN
          Result := -3                 // Knoten1 hat Daten, Knoten2 ist NIL
        ELSE
          Result := 3                  // Knoten1 hat keine Daten, Knoten2 ist NIL
      ELSE
        IF Assigned(Knoten2.Data) THEN
          Result := -4                 // Knoten2 hat Daten, Knoten1 ist NIL
        ELSE
          Result := 4                  // Knoten2 hat keine Daten, Knoten1 ist NIL
    ELSE
      Result := -1;                    // beide Knoten NIL
END;

FUNCTION TMpegEdit.DateilisteaktualisierenVideo(Videoknoten: TTreeNode; Listebehalten: Boolean; Positioneinstellen: Boolean = True): Integer;

VAR Erg : Integer;
    SchiebereglerPosition_merken : Integer;

BEGIN
  Result := 0;
  IF Assigned(Videoknoten) THEN
    IF Videoknoten.Level = 0 THEN           // es wurde ein Knoten erster Ebene übergeben
      IF Videoknoten.HasChildren THEN
        Videoknoten := Videoknoten.Item[0]  // in Videoknoten ändern
      ELSE
        Videoknoten := NIL;                 // kein Videoknoten vorhanden
  Erg := Knotendateigleich(Videoknoten, aktVideoknoten);
  IF (Erg < -1) OR (Erg = 5) THEN
  BEGIN
    Pause;
    SchiebereglerPosition_merken := SchiebereglerPosition;
    aktVideodateiloeschen;
    IF NOT Listebehalten THEN
    BEGIN
      VideoListe.Loeschen;
      IndexListe.Loeschen;
      SequenzHeader.Framerate := 0;
      BildHeader.BildTyp := 0;
    END;
    aktVideoKnoten := Videoknoten;
    IF ((NOT Assigned(Videoknoten)) OR
       (Assigned(Videoknoten) AND (Videoknoten.Parent <> Vorschauknoten))) AND
//        Assigned(VorschauVideoknoten) THEN
        Assigned(VorschauListe) THEN           // Vorschau ist (war) aktiv
    BEGIN
      Erg := Knotendateigleich(Videoknoten, VorschauVideoknoten);
      IF (Erg = 2) OR (Erg = 0) THEN
      BEGIN
        VideoListe.Free;
        VideoListe := VorschauListe;
        IndexListe.Free;
        IndexListe := VorschauIndexListe;
        SequenzHeader.Free;
        SequenzHeader := VorschauSequenzHeader;
        BildHeader.Free;
        BildHeader := VorschauBildHeader;
      END
      ELSE
      BEGIN
        VorschauListe.Loeschen;
        VorschauListe.Free;
        VorschauIndexListe.Loeschen;
        VorschauIndexListe.Free;
        VorschauSequenzHeader.Free;
        VorschauBildHeader.Free;
      END;
      VorschauListe := NIL;
      VorschauVideoknoten := NIL;
//      Vorschauknotenloeschen;
      SchiebereglerPosition_merken := VorschauPosition;
    END;
    aktVideoknotenNr_.Caption := IntToStrFmt(DateienlisteHauptknotenNr(aktVideoknoten), 2);
    IF Assigned(Videoknoten) AND Assigned(Videoknoten.Data) THEN     // Videodaten vorhanden
    BEGIN
      IF VideoListe.Count = 0 THEN
        Fortschrittsfensteranzeigen;
      IF VideoDateiaktualisieren(TDateieintrag(Videoknoten.Data).Name, VideoListe, IndexListe, SequenzHeader, BildHeader) < 0 THEN
        Result := -1;
    END;
    Schiebereglerlaenge_einstellen;
//    IF (SchiebereglerPosition_merken < SchiebereglerMax) AND       // wird in der Funktion SchiebereglerPosition_setzen erledigt
//       (SchiebereglerPosition_merken < Indexliste.Count) THEN
    IF Positioneinstellen THEN
      SchiebereglerPosition_setzen(SchiebereglerPosition_merken);
//    ELSE
//      SchiebereglerPosition_setzen(0);
    SetPositionIn(PositionIn);
    SetPositionOut(PositionOut);
    Videodateieigenschaften;
  END
  ELSE
  BEGIN
    aktVideoKnoten := Videoknoten;
    aktVideoknotenNr_.Caption := IntToStrFmt(DateienlisteHauptknotenNr(aktVideoknoten), 2);
  END;
END;

FUNCTION TMpegEdit.DateilisteaktualisierenAudio(Audioknoten: TTreeNode; Listebehalten: Boolean; Positioneinstellen: Boolean = True): Integer;

VAR Erg : Integer;
    SchiebereglerPosition_merken : Integer;

BEGIN
  Result := 0;
  IF Assigned(Audioknoten) THEN
    IF Audioknoten.Level = 0 THEN
      Audioknoten := AktivenAudioknotensuchen(Audioknoten);
  Erg := Knotendateigleich(Audioknoten, aktAudioknoten);
  IF (Erg < -1) OR (Erg = 5) THEN
  BEGIN
    Pause;
    SchiebereglerPosition_merken := SchiebereglerPosition;
    aktAudiodateiloeschen;
    IF NOT Listebehalten THEN
    BEGIN
      AudioListe.Loeschen;
      AudioHeader.Framelaenge := 0;
    END;
    aktAudioKnoten := Audioknoten;
    IF ((NOT Assigned(Audioknoten)) OR
       (Assigned(Audioknoten) AND (Audioknoten.Parent <> Vorschauknoten))) AND
//        Assigned(VorschauAudioknoten) THEN
        Assigned(VorschauAudioListe) THEN      // Vorschau ist (war) aktiv
    BEGIN
      Erg := Knotendateigleich(Audioknoten, VorschauAudioknoten);
      IF (Erg = 2) OR (Erg = 0) THEN
      BEGIN
        AudioListe.Free;
        AudioListe := VorschauAudioListe;
        AudioHeader.Free;
        AudioHeader := VorschauAudioHeader;
      END
      ELSE
      BEGIN
        VorschauAudioListe.Loeschen;
        VorschauAudioListe.Free;
        VorschauAudioHeader.Free;
      END;
      VorschauAudioListe := NIL;
      VorschauAudioknoten := NIL;
//      Vorschauknotenloeschen;
      SchiebereglerPosition_merken := VorschauPosition;
    END;
    aktAudioknotenNr_.Caption := IntToStrFmt(DateienlisteHauptknotenNr(aktAudioknoten), 2);
    IF Assigned(Audioknoten) AND Assigned(Audioknoten.Data) THEN     // Audiodaten vorhanden
    BEGIN
      IF AudioListe.Count = 0 THEN
        Fortschrittsfensteranzeigen;
      IF Audiodateiaktualisieren(TDateieintragAudio(Audioknoten.Data).Name, AudioListe, AudioHeader) < 0 THEN
        Result := -1;
      AudiooffsetNeu(@(TDateieintragAudio(Audioknoten.Data).Audiooffset));   // Audiooffset setzen
    END;
    Schiebereglerlaenge_einstellen;
//    IF (SchiebereglerPosition_merken < SchiebereglerMax) AND       // wird in der Funktion SchiebereglerPosition_setzen erledigt
//       (SchiebereglerPosition_merken < Indexliste.Count) THEN
    IF Positioneinstellen THEN
      SchiebereglerPosition_setzen(SchiebereglerPosition_merken);
//    ELSE
//      SchiebereglerPosition_setzen(0);
    SetPositionIn(PositionIn);
    SetPositionOut(PositionOut);
    Eigenschaftenanzeigen;
  END
  ELSE
  BEGIN
    aktAudioKnoten := Audioknoten;
    IF Assigned(aktAudioknoten) THEN
      IF Assigned(Audioknoten.Data) THEN
        AudiooffsetNeu(@(TDateieintragAudio(Audioknoten.Data).Audiooffset))   // Audiooffset setzen
      ELSE
        AudiooffsetAus
    ELSE
      AudiooffsetAus;
    aktAudioknotenNr_.Caption := IntToStrFmt(DateienlisteHauptknotenNr(aktAudioknoten), 2);
    Schiebereglerlaenge_einstellen;
    SchiebereglerPosition_setzen(SchiebereglerPosition);
  END;
END;

FUNCTION TMpegEdit.Dateilisteaktualisieren(Knoten: TTreeNode; Positioneinstellen: Boolean = True): Integer;

VAR Videoknoten : TTreeNode;
    Audioknoten : TTreeNode;

BEGIN
  Audioknoten := NIL;
  Videoknoten := NIL;
  IF Assigned(Knoten) THEN
  BEGIN
    Result := 0;
    IF Assigned(VorschauKnoten) AND               // Vorschau ist aktiv
       (Knoten.Level > 0) THEN                    // Video und Audio muß geändert werden
      Knoten := Knoten.Parent;
    IF Knoten.Level > 0 THEN
    BEGIN
      IF Knoten.Parent.IndexOf(Knoten) = 0 THEN
        Videoknoten := Knoten                     // Knoten ist ein Videoknoten
      ELSE
        Audioknoten := Knoten;                    // Knoten ist ein Audioknoten
    END
    ELSE
    BEGIN
      IF Knoten.HasChildren THEN
        Videoknoten := Knoten.Item[0];
      Audioknoten := AktivenAudioknotensuchen(Videoknoten);
    END;
//    Fortschrittsfensteranzeigen;
//    TRY
      IF Assigned(Videoknoten) THEN
        Result := DateilisteaktualisierenVideo(Videoknoten, False, Positioneinstellen) * 2;
      IF Assigned(Audioknoten) THEN
        Result := Result + DateilisteaktualisierenAudio(Audioknoten, False, Positioneinstellen) * 4;
//    FINALLY
//      Fortschrittsfensterverbergen;
//    END;
    IF Assigned(VorschauKnoten) AND (Knoten <> VorschauKnoten) THEN
      Vorschauknotenloeschen;
    IF Result < 0 THEN
      Dateien.ClearSelection(False);              // Datei öffnen fehlgeschlagen
    SetUndo(nil);                                 // UndoObject entfernen
  END
  ELSE
    Result := -1;                                 // kein Knoten übergeben
END;

FUNCTION TMpegEdit.VideoDateiaktualisieren(VideoName: STRING; Liste, IndexListe: TListe;
                                   SequenzHeader: TSequenzHeader; BildHeader: TBildHeader): Integer;

VAR MpegHeader : TMpeg2Header;

BEGIN
  IF NOT Videoabspieler_OK THEN
  BEGIN
    IF VideoName <> '' THEN
      IF Assigned(Liste) THEN
        IF Assigned(IndexListe) THEN
          IF Assigned(SequenzHeader) THEN
            IF Assigned(BildHeader) THEN
            BEGIN
              Result := 0;
              IF (Liste.Count = 0) OR (IndexListe.Count = 0) THEN
              BEGIN
//                Fortschrittsfensteranzeigen;
                MpegHeader:= TMpeg2Header.Create;
                MpegHeader.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
                MpegHeader.Textanzeige := Fortschrittsfenster.Textanzeige;
                MpegHeader.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
                MpegHeader.SequenzEndeIgnorieren := ArbeitsumgebungObj.SequenzEndeignorieren;
                Protokoll_schreiben(Meldunglesen(NIL, 'Meldung113', Videoname, 'Die Datei $Text1# öffnen.' ));
                IF MpegHeader.Dateioeffnen(VideoName) THEN
                BEGIN
                  Protokoll_schreiben(Meldunglesen(NIL, 'Meldung115', Videoname, 'Die Datei $Text1# ist geöffnet.'));
                  Protokoll_schreiben(Meldunglesen(NIL, 'Meldung130', Videoname, 'Dateiinformationen aus der Datei $Text1# lesen.'));
                  MpegHeader.DateiInformationLesen(SequenzHeader, BildHeader);
                  IF NOT((SequenzHeader.Framerate = 0) OR (BildHeader.BildTyp = 0)) THEN
                  BEGIN
                    Protokoll_schreiben(Meldunglesen(NIL, 'Meldung129', Videoname, 'Indexliste aus der Datei $Text1# erstellen.'));
                    MpegHeader.Listeerzeugen(Liste, IndexListe);
                    IF Liste.Count = 0 THEN
                    BEGIN
                      Protokoll_schreiben(Wortlesen(NIL, 'Meldung11', 'Es wurde keine Indexliste erstellt.'));
                      Result := -3;
                    END
                    ELSE
                    BEGIN
                      Protokoll_schreiben(Wortlesen(NIL, 'Meldung12', 'Indexliste erstellen beendet.'));
                      Result := 0;
                    END;
                  END
                  ELSE
                  BEGIN
                    Protokoll_schreiben(Wortlesen(NIL, 'Meldung24', 'Der erste Sequenz- oder Bildheader ist fehlerhaft.')+ ' ' + Wortlesen(NIL, 'Meldung13', 'Es wird keine Indexliste erzeugt.'));
                    Meldungsfenster(Wortlesen(NIL, 'Meldung24', 'Der erste Sequenz- oder Bildheader ist fehlerhaft.')+ Chr(13) +
                                    Wortlesen(NIL, 'Meldung13', 'Es wird keine Indexliste erzeugt.'),
                                    Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//                    ShowMessage(Wortlesen(NIL, 'Meldung24', 'Der erste Sequenz- oder Bildheader ist fehlerhaft.')+ Chr(13) +
//                                Wortlesen(NIL, 'Meldung13', 'Es wird keine Indexliste erzeugt.'));
                    Result := -2;
                  END;
                END
                ELSE
                BEGIN
                  SequenzHeader.Framerate := 0;
                  BildHeader.BildTyp := 0;
                  Protokoll_schreiben(Meldunglesen(NIL, 'Meldung114', Videoname, 'Die Datei $Text1# läßt sich nicht öffnen.'));
                  Meldungsfenster(Meldunglesen(NIL, 'Meldung114', Videoname, 'Die Datei $Text1# läßt sich nicht öffnen.'));
                  Result := -1;
                END;
                MpegHeader.Free;
//                Fortschrittsfensterverbergen;
              END;
              IF Result = 0 THEN
                IF (Liste.Count > 0) AND (IndexListe.Count > 0) THEN
                BEGIN
                  Videodatei.Caption := Textlaengeberechnen(VideoName, Anzeige.Width - 300);
                  Videodatei.Hint := VideoName;
                  aktVideodatei := VideoName;                  // wird übergangsweise noch benötigt
                  Bilderzahl := Indexliste.Count;              // Videolänge
                  IF ArbeitsumgebungObj.FesteFramerateverwenden THEN
                  BEGIN
                    BilderProSek := ArbeitsumgebungObj.FesteFramerate;
                    Bildlaenge := 1000 / BilderProSek;
                  END
                  ELSE
                  BEGIN
                    Bildlaenge := BildlaengeausSeqHeaderFramerate(SequenzHeader.Framerate);
                    BilderProSek := BilderProSekausSeqHeaderFramerate(SequenzHeader.Framerate);
                  END;
                  IF NOT ArbeitsumgebungObj.keinVideo THEN
                  BEGIN
                    IF Videoabspieler_erzeugen THEN
                    BEGIN
                      Bildeinpassen(ArbeitsumgebungObj.Videoanzeigefaktor);
                      Protokoll_schreiben(Wortlesen(NIL, 'Meldung33', 'Videoplayer öffnen war erfolgreich.'));
                      IF Videodatei_laden(VideoName, Liste, IndexListe) THEN
                      BEGIN
                        Player := Player OR 1;                                    // Bit 0 auf 1 setzen
                        Videolaenge.Caption := ZeitToStr(FramesToZeit(Bilderzahl, BilderProSek));
                        Protokoll_schreiben(Wortlesen(NIL, 'Meldung26', 'Die Datei ist geladen und wird wiedergegeben.'));
                      END
                      ELSE
                      BEGIN
                        Protokoll_schreiben(Wortlesen(NIL, 'Meldung27', 'Die Datei konnte nicht geladen werden.'));
                        Result := -7;
                      END;
                    END
                    ELSE
                    BEGIN
                      Protokoll_schreiben(Wortlesen(NIL, 'Meldung32', 'Videoplayer öffnen ist fehlgeschlagen.'));
                      Result := -6;
                    END;
                  END
                  ELSE
                  BEGIN
                    Protokoll_schreiben(Wortlesen(NIL, 'Meldung36', 'Kein Video abspielen vom Benutzer angewählt.'));
//                    Result := -8;
                  END;
                END
                ELSE
                  Result := -5                // keine Liste erstellt
              ELSE
                Result := -4;                 // Fehler beim Liste erstellen
            END
            ELSE
              Result := -3                    // kein Bildheader übergeben
          ELSE
            Result := -3                      // kein Sequenzheader übergeben
        ELSE
          Result := -3                        // keine IndexListe übergeben
      ELSE
        Result := -3                          // keine Liste übergeben
    ELSE
      Result := -2;                           // kein Videoname übergeben
  END
  ELSE
    Result := -1;                             // Videoabspieler ist noch aktiv
END;

PROCEDURE TMpegEdit.Schiebereglerlaenge_einstellen;
BEGIN
  IF ArbeitsumgebungObj.FesteFramerateverwenden THEN
  BEGIN
    BilderProSek := ArbeitsumgebungObj.FesteFramerate;
    Bildlaenge := 1000 / BilderProSek;
  END
  ELSE
    IF Assigned(aktVideoKnoten) AND
       Assigned(aktVideoKnoten.Data)THEN
    BEGIN
      IF Assigned(SequenzHeader) THEN
      BEGIN
        Bildlaenge := BildlaengeausSeqHeaderFramerate(SequenzHeader.Framerate);
        BilderProSek := BilderProSekausSeqHeaderFramerate(SequenzHeader.Framerate);
      END;
    END
    ELSE
    BEGIN
      IF Assigned(AudioHeader) THEN
      BEGIN
        Bildlaenge := AudioHeader.Framezeit;
        IF Bildlaenge > 0 THEN
          BilderProSek := 1000 / Bildlaenge
        ELSE
          BilderProSek := 0;
      END;
    END;
  CASE (Player AND $03) OF
    1 : Player := Player AND $FB;                          // nur Video vorhanden  --> Bit 2 auf 0 setzen
    2 : Player := Player OR 4;                             // nur Audio vorhanden  --> Bit 2 auf 1 setzen
    3 : BEGIN                                              // Video und Audio vorhanden
          IF Bilderzahl >= Trunc((Audiozahl + Audiooffset^) / Bildlaenge) THEN
            Player := Player AND $FB                       // Bit 2 auf 0 setzen
          ELSE
            Player := Player OR 4;                         // Bit 2 auf 1 setzen
        END;
  ELSE
    Player := 0;
    SchiebereglerMax_setzen(1000);
  END;
  IF (Player AND $04) = 4 THEN                             // Audio länger
    IF Bildlaenge > 0 THEN
      IF Assigned(Audiooffset) THEN
        SchiebereglerMax_setzen(Trunc((Audiozahl + Audiooffset^) / Bildlaenge) - 1)
      ELSE
        SchiebereglerMax_setzen(Trunc((Audiozahl) / Bildlaenge) - 1)
    ELSE
      SchiebereglerMax_setzen(0)
  ELSE
    IF (Player AND $05) = 1 THEN                           // Video länger
      SchiebereglerMax_setzen(Bilderzahl - 1);
END;

FUNCTION TMpegEdit.Audiodateiaktualisieren(AudioName: STRING; AudioListe: TListe; AudioHeader: TAudioHeader): Integer;

VAR MpegAudio : TMpegAudio;
    AudioVersatz : Integer;

BEGIN
  IF NOT Audioplayer_OK THEN
    IF AudioName <> '' THEN
      IF Assigned(AudioListe) THEN
        IF Assigned(AudioHeader) THEN
        BEGIN
          Result := 0;
          IF AudioListe.Count = 0 THEN
          BEGIN
//            Fortschrittsfensteranzeigen;
            MpegAudio:= TMpegAudio.Create;
            MpegAudio.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
            MpegAudio.Textanzeige := Fortschrittsfenster.Textanzeige;
            MpegAudio.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
            Protokoll_schreiben(Meldunglesen(NIL, 'Meldung113', Audioname, 'Die Datei $Text1# öffnen.' ));
            Result := MpegAudio.Dateioeffnen(AudioName);
            IF Result = 0 THEN
            BEGIN
              Protokoll_schreiben(Meldunglesen(NIL, 'Meldung115', Audioname, 'Die Datei $Text1# ist geöffnet.'));
              Protokoll_schreiben(Meldunglesen(NIL, 'Meldung130', Audioname, 'Dateiinformationen aus der Datei $Text1# lesen.'));
              Result := MpegAudio.DateiInformationLesen(AudioHeader);
              IF Result > -2 THEN
              BEGIN
                Protokoll_schreiben(Meldunglesen(NIL, 'Meldung129', Audioname, 'Indexliste aus der Datei $Text1# erstellen.'));
                Result := MpegAudio.Listeerzeugen(AudioListe, NIL, AudioVersatz);
                IF ((Result = 0) OR (Result = 1)) AND (AudioListe.Count > 0) THEN
                  Protokoll_schreiben(Wortlesen(NIL, 'Meldung12', 'Indexliste erstellen beendet.'))
                ELSE
                  Protokoll_schreiben(Wortlesen(NIL, 'Meldung11', 'Es wurde keine Indexliste erstellt.') + ' ' +
                                      Wortlesen(NIL, 'Fehlercode', 'Fehlercode') + ': ' + IntToStr(Result));
              END
              ELSE
              BEGIN
                Protokoll_schreiben(Wortlesen(NIL, 'Meldung25', 'Der erste Audioheader ist fehlerhaft.') + ' ' +
                                    Wortlesen(NIL, 'Meldung13', 'Es wird keine Indexliste erzeugt.') + ' ' +
                                    Wortlesen(NIL, 'Fehlercode', 'Fehlercode') + ': ' + IntToStr(Result));
              END;
            END
            ELSE
            BEGIN
              AudioHeader.Framelaenge := 0;
              CASE Result OF
                -2 : Protokoll_schreiben(Meldunglesen(NIL, 'Meldung112', Audioname, 'Die Datei $Text1# existiert nicht.'));
                -1 : Protokoll_schreiben(Meldunglesen(NIL, 'Meldung114', Audioname, 'Die Datei $Text1# läßt sich nicht öffnen.'));
              END;
              Meldungsfenster(Meldunglesen(NIL, 'Meldung114', Audioname, 'Die Datei $Text1# läßt sich nicht öffnen.'));
            END;
            MpegAudio.Free;
//            Fortschrittsfensterverbergen;
          END;
          IF ((Result = 0) OR (Result = 1)) THEN
            IF AudioListe.Count > 0 THEN
            BEGIN
              IF Assigned(aktVideoKnoten) THEN
              BEGIN
                IF NOT Assigned(aktVideoKnoten.Data) THEN
                BEGIN
                  Bildlaenge := AudioHeader.Framezeit;
                  IF Bildlaenge > 0 THEN
                    BilderProSek := 1000 / Bildlaenge;
                END;
              END
              ELSE
              BEGIN
                Bildlaenge := AudioHeader.Framezeit;
                IF Bildlaenge > 0 THEN
                  BilderProSek := 1000 / Bildlaenge;
              END;
              Audiodatei.Caption := Textlaengeberechnen(AudioName, Anzeige.Width - 300);
              Audiodatei.Hint := AudioName;
              aktAudiodatei := AudioName;                    // wird übergangsweise noch benötigt
              Audiozahl := Trunc((AudioListe.Count - 1) * Audioheader.Framezeit);  // Audiolänge in ms
              IF NOT ArbeitsumgebungObj.keinAudio THEN
              BEGIN
                IF ArbeitsumgebungObj.MCIPlayer THEN
                  Protokoll_schreiben(Wortlesen(NIL, 'Meldung29', 'MCI Schnittstelle verwenden vom Benutzer angewählt.'))
                ELSE
                  Protokoll_schreiben(Wortlesen(NIL, 'Meldung30', 'Direct Show Schnittstelle verwenden vom Benutzer angewählt.'));
                IF AudioplayerOeffnen(AudioName) THEN
                BEGIN
                  Player := Player OR 2;                          // Bit 1 auf 1 setzen
                  Audiolaenge.Caption := ZeitToStr(mSekToZeit(Audiozahl));
                  Protokoll_schreiben(Wortlesen(NIL, 'Meldung35', 'Audioplayer öffnen war erfolgreich.'));
                END
                ELSE
                BEGIN
                  Protokoll_schreiben(Wortlesen(NIL, 'Meldung34', 'Audioplayer öffnen ist fehlgeschlagen.'));
                  Result := -6;      // Audiodatei zum Abspielen öffnen ist fehlgeschlagen
                END;
              END
              ELSE
                Protokoll_schreiben(Wortlesen(NIL, 'Meldung31', 'Kein Audio abspielen vom Benutzer angewählt.'));
            END
            ELSE
              Result := -5           // keine Liste erstellt
          ELSE
            Result := -4;            // Fehler beim Liste erstellen
        END
        ELSE
          Result := -3               // kein Audioheader übergeben
      ELSE
        Result := -3                 // keine AudioListe übergeben
    ELSE
      Result := -2                   // kein Audioname übergeben
  ELSE
    Result := -1;                    // Audioabspieler ist noch aktiv
END;

PROCEDURE TMpegEdit.Videoeinschalten;
BEGIN
  IF NOT Videoabspieler_OK THEN
  BEGIN
    IF Assigned(aktVideoknoten) AND Assigned(aktVideoknoten.Data) THEN   // Videodaten vorhanden
    BEGIN
//      Fortschrittsfensteranzeigen;
      TRY
        VideoDateiaktualisieren(TDateieintrag(aktVideoknoten.Data).Name, VideoListe, IndexListe, SequenzHeader, BildHeader);
      FINALLY
        Fortschrittsfensterverbergen;
      END;
      Schiebereglerlaenge_einstellen;
      SchiebereglerPosition_setzen(SchiebereglerPosition);
    END;
  END;
END;

PROCEDURE TMpegEdit.Videoausschalten;
BEGIN
  IF Videoabspieler_OK THEN
  BEGIN
    Videoabspieler_freigeben;
    Player := Player AND $FE;                                  // Bit 0 auf 0 setzen
    Videoposition.Caption := '00:00:00:00';
    Schiebereglerlaenge_einstellen;
  END;
END;

PROCEDURE TMpegEdit.Videoumschalten;
BEGIN
  Pause;
  IF Videoabspieler_OK THEN
    Videoausschalten
  ELSE
    Videoeinschalten;
END;

PROCEDURE TMpegEdit.nurIFramesabspielen;
BEGIN
  Mpeg2Fenster.NurIFrames := NOT Mpeg2Fenster.NurIFrames;
END;

FUNCTION TMpegEdit.DateinameausKnoten(Knoten1, Knoten2: TTreeNode): STRING;

VAR I : Integer;

BEGIN
  Result := '';
  IF Assigned(Knoten1) AND
     Knoten1.HasChildren AND
     Assigned(Knoten1.Item[0]) AND
     Assigned(Knoten1.Item[0].Data) AND
     (TDateieintrag(Knoten1.Item[0].Data).Name <> '') THEN     // Knoten1 ist vorhanden und hat Daten
    Result := TDateieintrag(Knoten1.Item[0].Data).Name
  ELSE
    IF Assigned(Knoten2) THEN
    BEGIN
      I := 1;
      WHILE I < Knoten2.Count DO
      BEGIN
        IF Assigned(Knoten2.Item[I]) AND
           Assigned(Knoten2.Item[I].Data) THEN                 // Knoten2 ist vorhanden und hat Daten
        BEGIN
          Result := TDateieintragAudio(Knoten2.Item[I].Data).Name;
          I := Knoten2.Count;                                  // vorzeitiger Schleifenabbruch
        END;
        Inc(I);
      END;
    END;
END;

FUNCTION TMpegEdit.KnotennameausKnoten(Knoten1, Knoten2: TTreeNode): STRING;
BEGIN
  Result := '';
  IF Assigned(Knoten1) THEN
  BEGIN
    IF Knoten1.Level > 0 THEN
      Knoten1 := Knoten1.Parent;
    IF Knoten1.Text <> '' THEN
      Result := Knoten1.Text;
  END;
  IF (Result = '') AND
     Assigned(Knoten2) THEN
  BEGIN
    IF Knoten2.Level > 0 THEN
      Knoten2 := Knoten2.Parent;
    Result := Knoten2.Text;
  END;
END;

FUNCTION TMpegEdit.AudioDateitypelesen(Audiodatei: STRING): Byte;

VAR MpegAudio : TMpegAudio;

BEGIN
  MpegAudio := TMpegAudio.Create;
  TRY
    MpegAudio.Dateioeffnen(Audiodatei);
    Result := MpegAudio.AudioDateiType;
  FINALLY
    MpegAudio.Free;
  END;
END;

FUNCTION TMpegEdit.DateienlisteVideopruefen(Liste: TStrings): Integer;

VAR I, J, K, L : Integer;
    gefunden : Boolean;

BEGIN
  K := 0;
  L := 0;
  I := 0;
  WHILE I < Dateien.Items.Count DO
  BEGIN
    IF Dateien.Items[I].Level = 0 THEN                      // nur Knoten der ersten Ebene betrachten
    BEGIN
      IF Assigned(Liste) THEN                               // ist eine Liste übergeben worden
      BEGIN
        gefunden := False;
        J := 0;
        WHILE (J < Liste.Count) AND (NOT gefunden) DO       // prüfen ob der Knoten in der Liste ist
        BEGIN
          IF Assigned(Liste.Objects[J]) THEN
            IF TSchnittpunkt(Liste.Objects[J]).Videoknoten = Dateien.Items[I] THEN
              gefunden := True;
          Inc(J);
        END;
      END
      ELSE                                                  // wurde keine Liste übergeben
        gefunden := True;                                   // sind alle Knoten betrachten
      IF gefunden THEN                                      // der Knoten ist zu betrachten
      BEGIN
        Inc(K);                                             // Knotenzähler
        IF Dateien.Items[I].HasChildren THEN
          IF Assigned(Dateien.Items[I].Item[0].Data) THEN
            Inc(L);                                         // Videodaten vorhanden
      END;
    END;
    Inc(I);
  END;
  IF (L > 0) AND ( L< K) THEN
    Result := -1                                            // mindestens ein Videoknoten hat keine Daten
  ELSE
    IF L = K THEN
      Result := 1                                           // alle Knoten haben Daten
    ELSE
      Result := 0;                                          // kein Knoten hat Daten
END;

FUNCTION TMpegEdit.DateienlisteAudiopruefen(Liste: TStrings): Integer;

VAR I, J, K : Integer;
    DateiTyp : Byte;
    MpegAudio : TMpegAudio;
    gefunden : Boolean;

BEGIN
  Result := 0;
  IF Dateien.Items.Count > 1 THEN                                 // mehr als ein Eintrag in der Dateienliste
  BEGIN
    MpegAudio := TMpegAudio.Create;
    TRY
      Result := Dateien.Items[0].Count - 1;
      I := 1;
      WHILE (I < Dateien.Items[0].Count) AND (Result > - 1) DO    // Schleife durchläuft die Spuren
      BEGIN
        Dateityp := 0;
        J := 0;
        WHILE (J < Dateien.Items.Count) AND (Result > - 1) DO     // Schleife durchläuft die Knoten
        BEGIN
          IF Dateien.Items[J].Level = 0 THEN                      // nur Knoten der ersten Ebene betrachten
          BEGIN
            IF Assigned(Liste) THEN                               // ist eine Liste übergeben worden
            BEGIN
              K := 0;
              gefunden := False;
              WHILE (K < Liste.Count) AND (NOT gefunden) DO       // prüfen ob der Knoten in der Liste ist
              BEGIN
                IF Assigned(Liste.Objects[K]) THEN
                  IF TSchnittpunkt(Liste.Objects[K]).Audioknoten = Dateien.Items[J] THEN
                    gefunden := True;
                Inc(K);
              END;
            END
            ELSE                                                  // wurde keine Liste übergeben
              gefunden := True;                                   // sind alle Knoten betrachten
            IF gefunden THEN                                      // ist der Knoten zu betrachten
            BEGIN
              IF Assigned(Dateien.Items[J].Item[I].Data) THEN
                IF MpegAudio.Dateioeffnen(TDateieintragAudio(Dateien.Items[J].Item[I].Data).Name) = 0 THEN
                BEGIN
                  IF DateiTyp = 0 THEN
                    DateiTyp := MpegAudio.AudioDateiType
                  ELSE
                    IF DateiTyp <> MpegAudio.AudioDateiType THEN
                      Result := -1;                               // Audiodateitypen stimmen nicht überein
                END
                ELSE
                  Result := -2;                                   // Audiodatei läßt sich nicht öffnen
            END;
          END;
          Inc(J);
        END;
        Inc(I);
      END;
    FINALLY
      MpegAudio.Free;
    END;
  END;
END;

FUNCTION TMpegEdit.Videoliste_fuellen(SchnittpunktListe: TStrings): Integer;

VAR I, J : Integer;
    Schnittpunkt : TSchnittpunkt;

BEGIN
  J := 0;
  FOR I := 0 TO SchnittpunktListe.Count - 1 DO
  BEGIN
    Schnittpunkt := TSchnittpunkt(SchnittpunktListe.Objects[I]);
    IF Assigned(Schnittpunkt.Videoknoten) AND
       Schnittpunkt.Videoknoten.HasChildren AND
       Assigned(Schnittpunkt.Videoknoten[0].Data) THEN
    BEGIN
      Schnittpunkt.VideoName := TDateieintrag(Schnittpunkt.Videoknoten[0].Data).Name;
      IF Assigned(aktVideoknoten) AND Assigned(aktVideoknoten.Data) THEN
        IF Schnittpunkt.VideoName = TDateieintrag(aktVideoknoten.Data).Name THEN
      BEGIN
        Schnittpunkt.VideoListe := VideoListe;
        Schnittpunkt.VideoIndexListe := IndexListe;
      END
      ELSE
      BEGIN
        Schnittpunkt.VideoListe := NIL;
        Schnittpunkt.VideoIndexListe := NIL;
      END;
      Inc(J);
    END
    ELSE
    BEGIN
      Schnittpunkt.VideoName := '';
      Schnittpunkt.VideoListe := NIL;
      Schnittpunkt.VideoIndexListe := NIL;
    END;
  END;
  IF J > 0 THEN
    Result := 0                              // mindestens ein Schnittpunkt hat eine Videodatei
  ELSE
    Result := -1;                            // kein Schnittpunkt hat eine Videodatei
END;

FUNCTION TMpegEdit.ExtractAudioendung(Name: STRING; Dateiname: Boolean = False): STRING;

VAR PosPunkt,
    PosBackslash,
    PosTrennzeichen : Integer;

BEGIN
  PosPunkt := PosX('.', Name, Length(Name), True);
  IF PosPunkt = 0 THEN
    PosPunkt := Length(Name) + 1;
  PosBackslash := PosX('\', Name, PosPunkt - 1, True);
  IF ArbeitsumgebungObj.AudioTrennzeichen = '' THEN
    PosTrennzeichen := PosPunkt
  ELSE
    PosTrennzeichen := PosX(ArbeitsumgebungObj.AudioTrennzeichen, Name, PosPunkt - 1, True);
  IF PosTrennzeichen < PosBackslash + 1 THEN
    PosTrennzeichen := PosPunkt;
  IF Dateiname THEN
    Result := Copy(Name, 1, PosTrennzeichen - 1)
  ELSE
    Result := Copy(Name, PosTrennzeichen, Length(Name) + 1 - PosTrennzeichen);
END;

FUNCTION TMpegEdit.Audioliste_fuellen(SchnittpunktListe: TStrings; Spur: Integer): Integer;

VAR I, J : Integer;
    Schnittpunkt : TSchnittpunkt;

BEGIN
  J := 0;
  FOR I := 0 TO SchnittpunktListe.Count - 1 DO
  BEGIN
    Schnittpunkt := TSchnittpunkt(SchnittpunktListe.Objects[I]);
    IF Assigned(Schnittpunkt.Audioknoten) AND
       (Spur < Schnittpunkt.Audioknoten.Count) AND
       Assigned(Schnittpunkt.Audioknoten[Spur].Data) THEN
    BEGIN
      Schnittpunkt.AudioName := TDateieintragAudio(Schnittpunkt.Audioknoten[Spur].Data).Name;
      Schnittpunkt.Audiooffset := TDateieintragAudio(Schnittpunkt.Audioknoten[Spur].Data).Audiooffset;
      IF Assigned(aktAudioknoten) AND Assigned(aktAudioknoten.Data) THEN
        IF Schnittpunkt.AudioName = TDateieintragAudio(aktAudioknoten.Data).Name THEN
          Schnittpunkt.AudioListe := AudioListe
        ELSE
          Schnittpunkt.AudioListe := NIL;
      Inc(J);
    END
    ELSE
    BEGIN
      Schnittpunkt.AudioName := '';
      Schnittpunkt.Audiooffset := 0;
      Schnittpunkt.AudioListe := NIL;
    END;
  END;
  IF J > 0 THEN
    Result := 0                              // mindestens ein Schnittpunkt hat eine Audiodatei
  ELSE
    Result := -1;                            // kein Schnittpunkt hat eine Audiodatei
END;

FUNCTION TMpegEdit.Audioendungszaehler(SchnittpunktListe: TStrings; Audiozaehler: Integer): Integer;

VAR I,
    Endunggleich : Integer;
    Endung : STRING;

BEGIN
  IF Dateien.Items.Count > 0 THEN
  BEGIN
    Endung := ExtractAudioendungSpur(Audiozaehler, SchnittpunktListe);
    IF Endung <> '$leer#' THEN
    BEGIN
      Result := 0;
      Endunggleich := 0;
      FOR I := 1 TO Dateien.Items[0].Count - 1 DO
      BEGIN
        IF Endung = ExtractAudioendungSpur(I, SchnittpunktListe) THEN
        BEGIN
          Inc(Endunggleich);
          IF I = Audiozaehler THEN
            Result := Endunggleich;
        END;
      END;
      IF Endunggleich = 1 THEN
        Result := 0;
    END
    ELSE
      Result := -2;         // in dieser Spur der Schnittliste sind keine Audiodateien
  END
  ELSE
    Result := -1;           // Dateienliste leer
END;

FUNCTION TMpegEdit.Dateinamenliste: STRING;

VAR I : Integer;
    Knoten : TTreeNode;
    Dateieintrag : TDateieintrag;
//    AudioDateieintrag : TDateieintragAudio;

BEGIN
  I := 0;
  WHILE I < Dateien.Items.Count DO
  BEGIN
    Knoten := Dateien.Items[I];
    IF Knoten.Level > 0 THEN
    BEGIN
      Dateieintrag := TDateieintrag(Knoten.Data);
      IF Assigned(Dateieintrag) THEN
        Result := Result + '"' + Dateieintrag.Name + '" ';
    END;
    Inc(I);
  END;
  Result := TrimRight(Result);
END;

FUNCTION TreenodeSortieren(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;

BEGIN
  Result := CompareText(ExtractFileExt(Node1.Text), ExtractFileExt(Node2.Text));
  IF Result = 0 THEN
    Result := CompareText(Node1.Text, Node2.Text);
  IF Data = 1 THEN
    Result := Result * - 1;
END;

FUNCTION TMpegEdit.Videodateieinfuegen(Dateiname: STRING): Integer;

VAR Knotenpunkt : TTreeNode;
    Suche : TSearchRec;
    Name : STRING;
    Verzeichnis : STRING;

BEGIN
  IF Pos(UpperCase(ExtractFileExt(Dateiname)), UpperCase(ArbeitsumgebungObj.DateiendungenVideo)) > 0 THEN
  BEGIN
    Result := 0;
    Knotenpunkt := DateienlisteEintrageinfuegenVideo(NIL, Dateiname);
    IF Assigned(Knotenpunkt) THEN
    BEGIN
      Knotenpunkt := Knotenpunkt.Parent;
      Dateien.Selected := Knotenpunkt;                // den neu eingefügten Knoten selektieren
      Name := ChangeFileExt(Dateiname, '.*');
      Verzeichnis := ExtractFilePath(Dateiname);
      IF FindFirst(Name, faAnyFile, Suche) = 0 THEN   // zugehörige Audiodateien einfügen
      BEGIN
        REPEAT
          AudiodateieinfuegenKnoten(Knotenpunkt, Verzeichnis + Suche.Name);
        UNTIL FindNext(Suche) <> 0;
        FindClose(Suche);
      END;
      IF NOT (ArbeitsumgebungObj.Audiotrennzeichen = '') THEN // zugehörige Audiodateien (unter Beachtungn des Audiotrennzeichens) einfügen
      BEGIN
        Name := ChangeFileExt(Dateiname, ArbeitsumgebungObj.Audiotrennzeichen + '*');
        IF FindFirst(Name, faAnyFile, Suche) = 0 THEN
        BEGIN
          REPEAT
            AudiodateieinfuegenKnoten(Knotenpunkt, Verzeichnis + Suche.Name);
          UNTIL FindNext(Suche) <> 0;
          FindClose(Suche);
        END;
        Name := ExtractAudioendung(Dateiname, True) + ArbeitsumgebungObj.Audiotrennzeichen + '*';
        IF FindFirst(Name, faAnyFile, Suche) = 0 THEN
        BEGIN
          REPEAT
            AudiodateieinfuegenKnoten(Knotenpunkt, Verzeichnis + Suche.Name);
          UNTIL FindNext(Suche) <> 0;
          FindClose(Suche);
        END;
      END;
    END
    ELSE
      Result := - 3;                           // Knoten kann nicht erzeugt werden
  END
  ELSE
    Result := - 1;                             // falsche Videoendung
END;

FUNCTION TMpegEdit.AudiodateieinfuegenKnoten(Knotenpunkt: TTreenode; Dateiname: STRING): Integer;

VAR Unterknoten : TTreeNode;

BEGIN
  IF Assigned(Knotenpunkt) THEN
  BEGIN
    IF Knotenpunkt.Level > 0 THEN
      Knotenpunkt := Knotenpunkt.Parent;
    IF Pos(UpperCase(ExtractFileExt(Dateiname)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) > 0 THEN
      IF NOT DateienlisteneintragAudio_vorhandenKnoten(Knotenpunkt, Dateiname) THEN
      BEGIN
        Unterknoten := DateienlisteEintrageinfuegenAudio(Knotenpunkt, Dateiname, 0);
        IF Assigned(Unterknoten) THEN
          Result := 0
        ELSE
          Result := - 4;                       // Audioknoten kann nicht erzeugt werden
      END
      ELSE
        Result := - 3                          // Datei ist schon in der Liste vorhanden
    ELSE
      Result := - 2;                           // falsche Audioendung
  END
  ELSE
    Result := - 1;                             // keinen Knoten übergeben
END;

FUNCTION TMpegEdit.Audiodateieinfuegen(Dateiname: STRING): Integer;

VAR Knotenpunkt : TTreeNode;
    Suche : TSearchRec;
    Name : STRING;
    Verzeichnis : STRING;

BEGIN
  IF Pos(UpperCase(ExtractFileExt(Dateiname)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) > 0 THEN
  BEGIN
    Result := 0;
    Knotenpunkt := DateienlisteEintrageinfuegenAudio(NIL, Dateiname, 0).Parent;
    IF Assigned(Knotenpunkt) THEN
    BEGIN
      Dateien.Selected := Knotenpunkt;                // den neu eingefügten Knoten selektieren
      Name := ChangeFileExt(Dateiname, '.*');
      Verzeichnis := ExtractFilePath(Dateiname);
      IF FindFirst(Name, faAnyFile, Suche) = 0 THEN   // zugehörige Audiodateien einfügen
      BEGIN
        REPEAT
          AudiodateieinfuegenKnoten(Knotenpunkt, Verzeichnis + Suche.Name);
        UNTIL FindNext(Suche) <> 0;
        FindClose(Suche);
      END;
      IF NOT (ArbeitsumgebungObj.Audiotrennzeichen = '') THEN  // zugehörige Audiodateien (unter Beachtungn des Audiotrennzeichens) einfügen
      BEGIN
        Name := ChangeFileExt(Dateiname, ArbeitsumgebungObj.Audiotrennzeichen + '*');
        Verzeichnis := ExtractFilePath(Dateiname);
        IF FindFirst(Name, faAnyFile, Suche) = 0 THEN
        BEGIN
          REPEAT
            AudiodateieinfuegenKnoten(Knotenpunkt, Verzeichnis + Suche.Name);
          UNTIL FindNext(Suche) <> 0;
          FindClose(Suche);
        END;
        Name := ExtractAudioendung(Dateiname, True) + ArbeitsumgebungObj.Audiotrennzeichen + '*';
        IF FindFirst(Name, faAnyFile, Suche) = 0 THEN
        BEGIN
          REPEAT
            AudiodateieinfuegenKnoten(Knotenpunkt, Verzeichnis + Suche.Name);
          UNTIL FindNext(Suche) <> 0;
          FindClose(Suche);
        END;
      END;
    END
    ELSE
      Result := - 3;                           // Knoten kann nicht erzeugt werden
  END
  ELSE
    Result := - 1;                             // falsche Audioendung
END;

FUNCTION TMpegEdit.Dateilisteeinfuegen(Dateinamen: TStringList): Integer;

VAR I, Erg : Integer;
    Text : STRING;

BEGIN
  Result := 0;
  FOR I := 0 TO Dateinamen.Count -1 DO
  BEGIN
      Erg := Videodateieinfuegen(Dateinamen[I]);
      IF Erg = -1 THEN
        Erg := Audiodateieinfuegen(Dateinamen[I]);
    IF Erg = -1 THEN
    BEGIN
      IF Text <> '' THEN
        Text := Text + Chr(13);
      Text := Text + Meldunglesen(NIL, 'Meldung111', Dateinamen[I], 'Der Dateityp $Text1# wird nicht unterstützt.');
    END
    ELSE
      Projektgeaendert_setzen(1);
  END;
  IF Text <> '' THEN
    Meldungsfenster(Text,Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//    MessageDlg(Text, mtWarning, [mbOK], 0);
END;

PROCEDURE TMpegEdit.Video_oeffnen(Verzeichnis: STRING; Video: Boolean = False; Audio: Boolean = False);

VAR DateiNamenListe : TStringList;
    Text : STRING;

BEGIN
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Text := '';
  Oeffnen.Title := Wortlesen(NIL, 'Dialog17', 'Video/Audiodatei öffnen');
  Oeffnen.Filter := Wortlesen(NIL, 'Dialog18', 'Video/Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo + ';' + ArbeitsumgebungObj.DateiendungenAudio + '|' +
                    Wortlesen(NIL, 'Dialog12', 'MPEG-2 Videodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo + '|' +
                    Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio;
  Oeffnen.FilterIndex := ArbeitsumgebungObj.VideoAudiooeffnenFilterIndex;
  Oeffnen.DefaultExt := '';
  Oeffnen.FileName := '';
  Oeffnen.InitialDir := Verzeichnissuchen(Verzeichnis);
  IF Oeffnen.Execute THEN
  BEGIN
    Vorschau_beenden.Click;
    IF ArbeitsumgebungObj.VideoAudioVerzeichnisspeichern THEN
      ArbeitsumgebungObj.VideoAudioVerzeichnis := ExtractFilePath(Oeffnen.FileName);
    ArbeitsumgebungObj.VideoAudiooeffnenFilterIndex := Oeffnen.FilterIndex;
    DateiNamenListe := TStringList.Create;
    DateiNamenListe.Assign(Oeffnen.Files);
    DateiNamenListe.Sort;
    Dateilisteeinfuegen(DateiNamenListe);
    DateiNamenListe.Free;
    IF (ArbeitsumgebungObj.letztesVideoanzeigen AND (NOT letztesVideoanzeigenCLaktiv)) OR
       (letztesVideoanzeigenCL AND letztesVideoanzeigenCLaktiv) THEN
    BEGIN
//      Fortschrittsfensteranzeigen;
      TRY
        IF ArbeitsumgebungObj.SchiebereglerPosbeibehalten THEN
          Dateilisteaktualisieren(Dateien.Selected)
        ELSE
        BEGIN
          Dateilisteaktualisieren(Dateien.Selected, False);
          SchiebereglerPosition_setzen(0);
        END;
        Verzeichnismerken(ExtractFileDir(Oeffnen.FileName));
      FINALLY
        Fortschrittsfensterverbergen;
      END;
      Schnittpunktanzeigeloeschen;
    END;
    Listen.ActivePage := InformationenTab;
  END;
  IF Enabled AND DateienfensterausPanel.Visible THEN
    Dateien.SetFocus;
END;

procedure TMpegEdit.Video_oeffnenClick(Sender: TObject);
begin
  Video_oeffnen(ArbeitsumgebungObj.VideoAudioVerzeichnis);
end;

// ------------------------ Bedienelemente Funktionen/Proceduren -------------------------------

PROCEDURE TMpegEdit.Anzeigeaktualisieren(Pos: Int64);

VAR Zeit : TZeitCode;

BEGIN
//  IF (VideoabspielerMode <> mpPlaying) AND (TAbspielMode(AudioplayerMode) <> mpPlaying) THEN
  IF NOT AbspielModus THEN
  BEGIN
    IF ((Player AND $01) = 1) AND                            // Video vorhanden?
       (IndexListe.Count > 0) THEN                           // Liste vorhanden
    BEGIN
      IF Pos < IndexListe.Count THEN
      BEGIN
        GehezuVideoPosition(Pos);
        Zeit := FramesToZeit(Pos, BilderProSek);
        aktuellerBildtyp.Caption := BildTypausListe(IndexListe, Pos);
        BildNr.Caption := IntToStr(Pos);
      END
      ELSE
      BEGIN
        GehezuVideoPosition(IndexListe.Count - 1);
        Zeit := FramesToZeit(IndexListe.Count - 1, BilderProSek);
        aktuellerBildtyp.Caption := BildTypausListe(IndexListe, IndexListe.Count - 1);
        IF (Player AND $04) = 0 THEN
          BildNr.Caption := IntToStr(IndexListe.Count - 1);
      END;
      Videoposition.Caption := ZeitToStr(Zeit);
    END
    ELSE
    BEGIN
      Videoposition.Caption := '00:00:00:00';
    END;
    IF ((Player AND $02) = 2) AND                             // Audio vorhanden?
       (AudioListe.Count > 0) THEN
    BEGIN
      IF Round(Pos * Bildlaenge - Audiooffset^) > -1 THEN
      BEGIN
        IF Round(Pos * Bildlaenge - Audiooffset^) < Audiozahl THEN
        BEGIN
          AudioplayerPosition_setzen(Round(Pos * Bildlaenge - Audiooffset^));
          Zeit := mSekToZeit(Round(Pos * Bildlaenge - Audiooffset^));
          BildNr.Caption := IntToStr(Pos);
        END
        ELSE
        BEGIN
          AudioplayerPosition_setzen(Round((Round(Audiozahl / Bildlaenge) - 1) * Bildlaenge));
          Zeit := mSekToZeit(Round((Round(Audiozahl / Bildlaenge) - 1) * Bildlaenge));
          IF (Player AND $04) = 4 THEN
            BildNr.Caption := IntToStr(Round(Audiozahl / Bildlaenge) - 1);
        END;
      END
      ELSE
      BEGIN
        AudioplayerPosition_setzen(0);
        Zeit := mSekToZeit(0);
      END;
      Audioposition.Caption := ZeitToStr(Zeit);
    END
    ELSE
    BEGIN
      Audioposition.Caption := '00:00:00:000';
    END;
    Cutmoeglich(Pos);
  END;
END;

FUNCTION TMpegEdit.Audioplayerlaeuft: Boolean;
BEGIN
  IF (Player AND $02) = 2 THEN                             // Audio vorhanden?
    IF (TAbspielmode(AudioPlayerMode) = mpPlaying) THEN
      Result := True
    ELSE
      Result := False
  ELSE
    Result := False;
END;

FUNCTION TMpegEdit.AudioplayerPositionPlusOffset: Int64;
BEGIN
  IF Audioplayerlaeuft THEN
  BEGIN
    Result := AudioplayerPosition_holen;
    IF (Result > -1) AND
      Assigned(Audiooffset) THEN
      Result := Result + Audiooffset^;
  END
  ELSE
    Result := -2;
END;

PROCEDURE TMpegEdit.Positionsanzeige(VAR Position: Int64);

//VAR Audioplayerposition : Integer;
PROCEDURE Pause(Stoppen: Boolean = False);
BEGIN
  SetzeAbspielModus(False);                                // Oberfläche auf Pause/Stop einstellen
  AudioTimer.Enabled := False;
  IF (Player AND $01) = 1 THEN                             // Video vorhanden?
    VideoEnde;
    // VideoPause darf nicht verwendet werden damit der Abspielthread zuende laufen kann
  IF (Player AND $02) = 2 THEN                             // Audio vorhanden?
    AudioplayerStop;
  IF ArbeitsumgebungObj.Tempo1beiPause THEN
    Temposetzen(3);
  SpieleVonBisPosition := -1;
  IF Stoppen THEN
  BEGIN
    SchiebereglerPosition_setzen(0, True);
    SchiebereglerPosition_merken := -1;
  END
  ELSE
    IF (SchiebereglerPosition > 0) AND (SchiebereglerPosition_merken > -1) THEN
      SchiebereglerPosition_setzen(SchiebereglerPosition_merken)
    ELSE
      IF (Player AND $04) = 0 THEN
        SchiebereglerPosition_setzen(VideoBildPosition)
      ELSE
        IF Bildlaenge > 0 THEN
          SchiebereglerPosition_setzen(Round((AudioplayerPosition_holen + Audiooffset^)  / Bildlaenge))
        ELSE
          SchiebereglerPosition_setzen(0);
END;

begin
  SchiebereglerPosition_setzen(Position);
  BildNr.Caption := IntToStr(SchiebereglerPosition);
  IF (SpieleVonBisPosition > -1) AND
     (SchiebereglerPosition > SpieleVonBisPosition - 1) THEN
    Pause;
  IF SchiebereglerPosition > SchiebereglerMax - 1 THEN
    IF Assigned(Vorschauknoten) THEN
      Pause(True)
    ELSE
      Pause;
  IF ((Player AND $01) = 1) THEN                           // Video vorhanden?
  BEGIN
    Videoposition.Caption := ZeitToStr(FramesToZeit(VideoBildPosition, BilderProSek));
    IF (VideoabspielerMode = mpPlaying) AND (Position > IndexListe.Count - 2) THEN
      VideoEnde;                                           // Video anhalten
      // VideoPause darf nicht verwendet werden damit der Abspielthread zuende laufen kann
  END;
  IF (Player AND $02) = 2 THEN                             // Audio vorhanden?
  BEGIN
    Audioposition.Caption := ZeitToStr(mSekToZeit(AudioplayerPosition_holen));
    IF (TAbspielmode(AudioPlayerMode) = mpPlaying) AND (Position > Round((Audiozahl + Audiooffset^) / Bildlaenge) - 2) THEN
      AudioPlayerPause;               // Audio anhalten
    IF (NOT (TAbspielmode(AudioPlayerMode) = mpPlaying)) AND
       (AbspielModus) AND
       (VideoabspielerMode = mpPlaying) AND
       (Position < Round((Audiozahl + Audiooffset^) / Bildlaenge) - 1) AND
       (Position * Bildlaenge >= Audiooffset^) AND
       (Tempo = 1) THEN
      AudioPlayerPlay;                                     // Audioplayer starten wenn das Ende eines positiven Audiooffsets erreicht ist
  END;
{  Audioplayerposition := Round(AudioplayerPositionPlusOffset / Bildlaenge) - Position;
  IF Audioplayerposition > 0 THEN
    IF Audioplayerposition > 3 THEN
      BildNr.Font.Color := clFuchsia
    ELSE
      BildNr.Font.Color := clRed
  ELSE
    BildNr.Font.Color := clWindowText;
  IF (VideoabspielerMode <> mpPlaying) OR (TAbspielMode(AudioplayerMode) <> mpPlaying) THEN
    BildNr.Font.Color := clWindowText; }
end;
{
PROCEDURE TMpegEdit.Positionsanzeige(VAR Position: DWord);

VAR Videosync, AudioSync, AufAudiowarten : Boolean;
    BildanzeigeZeit : Integer;
    Audioplayerposition : Integer;

begin
  IF (VideoabspielerMode = mpPlaying) OR (TAbspielMode(AudioplayerMode) = mpPlaying) THEN
  BEGIN
    SchiebereglerPosition_setzen(Position);
    BildNr.Caption := IntToStr(SchiebereglerPosition);
    IF (SpieleVonBisPosition > -1) AND
       (SchiebereglerPosition > SpieleVonBisPosition - 1) THEN
      Pause;
    IF SchiebereglerPosition > SchiebereglerMax - 1 THEN
      IF Assigned(Vorschauknoten) THEN
        Stoppen
      ELSE
        Pause;
    VideoSync := False;
    AudioSync := False;
//    IF (VideoabspielerMode = mpPlaying) OR (TAbspielMode(AudioplayerMode) = mpPlaying) THEN
//    BEGIN
      IF ((Player AND $01) = 1) THEN                           // Video vorhanden?
      BEGIN
        Videoposition.Caption := ZeitToStr(FramesToZeit(VideoBildPosition, BilderProSek));
        IF Integer(Position) > IndexListe.Count - 2 THEN
          VideoPause;        }             // Video anhalten
//        BildNr.Caption := IntToStr({VideoBild}Position);
  {      IF (NOT (VideoabspielerMode = mpPlaying)) AND (SchiebereglerPosition < IndexListe.Count) THEN
        BEGIN
          aktuellerBildtyp.Caption := BildTypausListe(IndexListe, SchiebereglerPosition);
          BildNr.Caption := IntToStr(SchiebereglerPosition);
          Cutmoeglich(SchiebereglerPosition);
        END;   }
{        IF VideoabspielerMode = mpPlaying THEN
          VideoSync := True;
      END;
      BildanzeigeZeit := Round(Bildlaenge * (Position - StartBild));
      IF (Player AND $02) = 2 THEN                             // Audio vorhanden?
      BEGIN
        Audioposition.Caption := ZeitToStr(mSekToZeit(AudioplayerPosition_holen));
//        IF NOT ((Player AND $01) = 1) THEN                     // kein Video vorhanden
//          BildNr.Caption := IntToStr(SchiebereglerPosition);
        IF (NOT (TAbspielmode(AudioPlayerMode) = mpPlaying)) AND
           (VideoabspielerMode = mpPlaying) AND
           (Position * Bildlaenge >= Audiooffset^) THEN
          AudioPlayerPlay;                                     // Audioplayer starten wenn das Ende eines positiven Audiooffsets erreicht ist
        IF TAbspielmode(AudioPlayerMode) = mpPlaying THEN
          AudioSync := True;
      END;
      IF Videosync AND AudioSync THEN
      BEGIN
        REPEAT                                // Video und Audio synchronisieren
          AufAudiowarten := (Position * Bildlaenge) < AudioplayerPosition_holen + Audiooffset^;
          IF (BildanzeigeZeit + 5) < MilliSecondsBetween(StartZeit, Time) THEN
            AufAudiowarten := True;           // Schleife zwangsweise verlassen
        UNTIL AufAudiowarten;
        Audioplayerposition := Round((AudioplayerPosition_holen + Audiooffset^) / Bildlaenge)- Position;
        IF Audioplayerposition > 0 THEN
        BEGIN
          IF Bilder_weiter(Audioplayerposition) THEN
            BildNr.Font.Color := clRed
          ELSE
            BildNr.Font.Color := clWindowText;
        END
        ELSE
          BildNr.Font.Color := clWindowText;
      END
      ELSE
        IF Videosync THEN
        BEGIN
          REPEAT                                // Video und Anzeigezeit eines Bildes synchronisieren
            AufAudiowarten := BildanzeigeZeit < MilliSecondsBetween(StartZeit, Time);
          UNTIL AufAudiowarten;
          BildNr.Font.Color := clWindowText;
        END
        ELSE
          IF Audiosync THEN
          BEGIN
            BildNr.Font.Color := clWindowText;
          END;     }

{      REPEAT                                // Video und Audio synchronisieren
        IF AudioSync THEN                   // auf Audio warten oder
          AufAudiowarten := (Position * Bildlaenge) < AudioplayerPosition_holen + Audiooffset^
        ELSE                                // Zeit bis zum nächsten Bild warten
          AufAudiowarten := BildanzeigeZeit < MilliSecondsBetween(StartZeit, Time);
        IF (BildanzeigeZeit + 5) < MilliSecondsBetween(StartZeit, Time) THEN
          AufAudiowarten := True;           // Schleife zwangsweise verlassen
      UNTIL AufAudiowarten;
      IF AudioSync THEN
      BEGIN
        Audioplayerposition := Round((AudioplayerPosition_holen + Audiooffset^) / Bildlaenge)- Position;
        IF Audioplayerposition > 0 THEN
        BEGIN
          IF Bilder_weiter(Audioplayerposition) THEN
            BildNr.Font.Color := clRed
          ELSE
            BildNr.Font.Color := clWindowText;
        END
        ELSE
          BildNr.Font.Color := clWindowText;
      END;    }
//    END;
//  END;
//end;

FUNCTION TMpegEdit.Textlaengeberechnen(Text: STRING; Breite: Integer): STRING;

VAR TextLaenge : Integer;

BEGIN
  TextLaenge := Round(Breite / 7);         // 6.1 durch Versuche ermittelt
  IF Length(Text) > TextLaenge + 2 THEN
  BEGIN
    Text := ExtractFileName(Text);
    IF Length(Text) > TextLaenge + 2 THEN
      Text := Copy(Text, 1, TextLaenge - Length(ExtractFileExt(Text))) + '..' + ExtractFileExt(Text);
  END;
  Result := Text;
END;

PROCEDURE TMpegEdit.SchiebereglerMarkersetzen(Position: Integer);
BEGIN
  IF Position < 0 THEN
    Position := 0;                                                      // minimale Markerposition
  IF Position > 10000 THEN
    Position := 10000;                                                  // maximale Markerposition
  SchiebereglerMarkerPosition := Position;
  SchiebereglermittePanel.Left := Round(Position *                      // Markerposition
                                  (Schieberegler.Width - 15 - 4 - 4) /  // Schiebereglerlänge (schiebbarer Bereich)
                                  10000) +                              // maximale Markerposition
                                  Schieberegler.Left + 4;               // linkeste Position des Schiebereglermarker
END;

PROCEDURE TMpegEdit.Fenstereinstellen;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    IF ArbeitsumgebungObj.ListenfensterBreite > ClientWidth - 500 THEN
      Listen.Width := ClientWidth - 500                    // maximale Breite des Listenfensters
    ELSE
      IF ArbeitsumgebungObj.ListenfensterBreite < 215 THEN
        Listen.Width := 215                                // minimale Breite des Listenfensters
      ELSE
        Listen.Width := ArbeitsumgebungObj.ListenfensterBreite;
    IF ArbeitsumgebungObj.DateienfensterHoehe > ClientHeight - 250 THEN
      DateienfensterausPanel.Height := ClientHeight - 250  // maximale Höhe des Dateinefensters
    ELSE
      IF ArbeitsumgebungObj.DateienfensterHoehe = 0 THEN
        DateienfensterausPanel.Height := 80
      ELSE                                                 // Standardhöhe des Dateinefensters
        IF ArbeitsumgebungObj.DateienfensterHoehe < 42 THEN
          DateienfensterausPanel.Height := 42              // minimale Höhe des Dateinefensters
        ELSE
          DateienfensterausPanel.Height := ArbeitsumgebungObj.DateienfensterHoehe;
    IF ArbeitsumgebungObj.ListenfensterLinks THEN
    BEGIN
      Listen.Left := 0;
      ListenTrennPanel.Left := Listen.Width - 3;
    END
    ELSE
    BEGIN
      Listen.Left := ClientWidth - Listen.Width;
      ListenTrennPanel.Left := Listen.Left;
    END;
    IF ArbeitsumgebungObj.Tastenfensterzentrieren THEN
    BEGIN
      TastenPanel.Width := 791;
      TastenPanel.Left := Round((ClientWidth - TastenPanel.Width) / 2) + 1;
    END
    ELSE
    BEGIN
      TastenPanel.Left := 1;
      TastenPanel.Width := ClientWidth - 1;
    END;
    IF ArbeitsumgebungObj.TasteEndelinks THEN
    BEGIN
      EndePanel1.Visible := True;
      Schieberegler.Left := 30;
    END
    ELSE
    BEGIN
      EndePanel1.Visible := False;
      Schieberegler.Left := 12;
    END;
    IF  ArbeitsumgebungObj.TasteEnderechts THEN
    BEGIN
      EndePanel.Visible := True;
      Schieberegler.Width := ClientWidth - Schieberegler.Left - 12;
    END
    ELSE
    BEGIN
      EndePanel.Visible := False;
      Schieberegler.Width := ClientWidth - Schieberegler.Left;
    END;
  END
  ELSE
  BEGIN
    DateienfensterausPanel.Height := 80 - 3;
    Listen.Width := 215;
    Listen.Left := ClientWidth - Listen.Width;
    TastenPanel.Left := 1;
    TastenPanel.Width := ClientWidth - 1;
    ListenTrennPanel.Left := Listen.Left;
  END;
  ListenTrennPanel.Height := Schieberegler.Top;
  SchnittuebernehmenPanel.Left := TastenPanel.Left + 249;
//  IF AudioOffsetfensterEin.Checked THEN
  AudioSkewPanel.Top := Schieberegler.Top - AudioSkewPanel.Height;
  AudioSkewPanel.Left := Listen.Left;
  AudioSkewPanel.Width := Listen.Width;
  IF AudioSkewPanel.Visible THEN
    Listen.Height := AudioSkewPanel.Top - 2
  ELSE
    Listen.Height := AudiooffseteinPanel.Top - 2;
  IF Listen.Left = 0 THEN
  BEGIN
    DateienfensterausPanel.Left := Listen.Width;
    DateienfensterausPanel.Width := ClientWidth - DateienfensterausPanel.Left;
  END
  ELSE
  BEGIN
    DateienfensterausPanel.Left := 0;
    DateienfensterausPanel.Width := Listen.Left;
  END;
  DateienfensterausPanel.Top := Schieberegler.Top - DateienfensterausPanel.Height;
  DateienTrennPanel.Left := DateienfensterausPanel.Left;
  DateienTrennPanel.Width := DateienfensterausPanel.Width;
  DateienTrennPanel.Top := DateienfensterausPanel.Top - 3;
  Anzeige.Left := DateienfensterausPanel.Left;
  IF DateienfensterausPanel.Visible THEN
    Anzeige.Top := DateienTrennPanel.Top - Anzeige.Height
  ELSE
    IF DateifenstereinPanel.Visible THEN
      Anzeige.Top := DateifenstereinPanel.Top - Anzeige.Height
    ELSE
      Anzeige.Top := Schieberegler.Top - Anzeige.Height;
  IF DateienfensterausPanel.Width > 500 + SymbolleistePanel.Width THEN
  BEGIN
    Anzeige.Width := DateienfensterausPanel.Width - SymbolleistePanel.Width;
    SymbolleistePanel.Left := Anzeige.Left + Anzeige.Width;
    SymbolleistePanel.Top := Anzeige.Top;
    SymbolleistePanel.Visible := True;
  END
  ELSE
  BEGIN
    SymbolleistePanel.Visible := False;
    Anzeige.Width := DateienfensterausPanel.Width;
  END;
  Anzeigeflaeche.Top := 0;
//  Anzeigeflaeche.Left := DateienfensterausPanel.Left;
//  Anzeigeflaeche.Width := DateienfensterausPanel.Width;
  Anzeigeflaeche.Height := Anzeige.Top;
  Bildflaeche.Top := 0;
  Bildflaeche.Height := Anzeige.Top;
  IF Bildflaeche.Visible = Anzeigeflaeche.Visible THEN
  BEGIN
    IF Anzeigeflaeche.Left >= Bildflaeche.Left THEN
    BEGIN
      Anzeigeflaeche.Left := DateienfensterausPanel.Left + DateienfensterausPanel.Width DIV 2;
      Bildflaeche.Left := DateienfensterausPanel.Left;
    END
    ELSE
    BEGIN
      Anzeigeflaeche.Left := DateienfensterausPanel.Left;
      Bildflaeche.Left := DateienfensterausPanel.Left + DateienfensterausPanel.Width DIV 2;
    END;
    Anzeigeflaeche.Width := DateienfensterausPanel.Width DIV 2;
    Bildflaeche.Width := DateienfensterausPanel.Width DIV 2;
    StandbildPositionZeit.Top := Bildflaeche.Height - 20;
    StandbildPositionFrame.Top := StandbildPositionZeit.Top;
    StandbildPositionZeit.Left := Bildflaeche.Width DIV 2 - 64;
    StandbildPositionFrame.Left := StandbildPositionZeit.Left + 80;
  END
  ELSE
  BEGIN
    Anzeigeflaeche.Left := DateienfensterausPanel.Left;
    Anzeigeflaeche.Width := DateienfensterausPanel.Width;
//    Bildflaeche.Left := DateienfensterausPanel.Left + 10;
//    Bildflaeche.Width := DateienfensterausPanel.Width DIV 2;
  END;
//  Schieberegler.Width := ClientWidth - 24;                                         // Schiebereglerbreite
//  SymbolleistePanel.Left := Listen.Left;
//  SymbolleistePanel.Width := Listen.Width;
  AudiooffseteinPanel.Left := Listen.Left;
  AudiooffseteinPanel.Width := Listen.Width;
  DateifenstereinPanel.Left := DateienfensterausPanel.Left;
  DateifenstereinPanel.Width := DateienfensterausPanel.Width;
  SchiebereglerMarkersetzen(SchiebereglerMarkerPosition);
  Audioplayer.Top := ClientHeight - 50;
  IF Assigned(ArbeitsumgebungObj) THEN
    Bildeinpassen(ArbeitsumgebungObj.Videoanzeigefaktor);
END;

procedure TMpegEdit.FormResize(Sender: TObject);
begin
  Fenstereinstellen;
  IF Assigned(aktAudioknoten) AND
     Assigned(aktAudioknoten.Data) THEN
    Audiodatei.Caption := Textlaengeberechnen(TDateieintragAudio(aktAudioknoten.Data).Name, Anzeige.Width - 300);
  IF Assigned(aktVideoknoten) AND
     Assigned(aktVideoknoten.Data) THEN
    Videodatei.Caption := Textlaengeberechnen(TDateieintrag(aktVideoknoten.Data).Name, Anzeige.Width - 300);
  KapitelListeZeilenberechnen;
end;

PROCEDURE TMpegEdit.Fensterpositionmerken;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    IF WindowState = wsNormal	 THEN
    BEGIN
      ArbeitsumgebungObj.ProgrammFensterLinks := Left;
      ArbeitsumgebungObj.ProgrammFensterOben := Top;
      ArbeitsumgebungObj.ProgrammFensterBreite := Width;
      ArbeitsumgebungObj.ProgrammFensterHoehe := Height;
    END;
    ArbeitsumgebungObj.ProgrammFensterMaximized := WindowState = wsMaximized;
  END;
END;

PROCEDURE TMpegEdit.Fensteranzeigemerken;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
//    IF NOT (DateienfensterausPanel.Visible OR DateifenstereinPanel.Visible) THEN
//      ArbeitsumgebungObj.DateienfensterSichtbar := DateienfensterausPanel.Visible;
    ArbeitsumgebungObj.AudiooffsetfensterSichtbar := AudioSkewPanel.Visible;
    ArbeitsumgebungObj.AudiooffsetfensterHoehe := AudioSkewPanel.Height;
    ArbeitsumgebungObj.SchiebereglerMarkerPosition := SchiebereglerMarkerPosition;
    ArbeitsumgebungObj.ZweiVideofenster := ZweiFensterMenuItem.Checked;
  END;
END;

PROCEDURE TMpegEdit.Kapitelspaltenbreitemerken;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    ArbeitsumgebungObj.KapitellisteSpaltenbreite1 := KapitelListeGrid.ColWidths[0];
    ArbeitsumgebungObj.KapitellisteSpaltenbreite2 := KapitelListeGrid.ColWidths[1];
    ArbeitsumgebungObj.KapitellisteSpaltenbreite3 := KapitelListeGrid.ColWidths[2];
    ArbeitsumgebungObj.KapitellisteSpaltenbreite4 := KapitelListeGrid.ColWidths[3];
  END;
END;

PROCEDURE TMpegEdit.SetzeAbspielModus(Modus: Boolean = False);
BEGIN
  AbspielModus := Modus;
  IF Modus THEN
  BEGIN
    TAlphaSpeedBtn(Play).Caption := WortPause;
    CutIn.Enabled := False;
    CutOut.Enabled := False;
    Kapitel.Enabled := False;
    TAlphaSpeedBtn(Kapitel).ActiveGlyph := 0;
    aktuellerBildtyp.Enabled := False;
    IF Spieleab.Down OR Spielebis.Down THEN
    BEGIN
      VorherigesI.Enabled := False;
      NaechstesI.Enabled := False;
      VorherigesP.Enabled := False;
      NaechstesP.Enabled := False;
      SchrittZurueck.Enabled := False;
      SchrittVor.Enabled := False;
    END;
//    GehezuIn.Enabled := False;
//    GehezuOut.Enabled := False;
    SchnittUebernehmen.Enabled := False;
    BtnVideoAdd.Enabled := False;
    Schneiden.Enabled := False;
//    Vorschau.Enabled := False;
  END
  ELSE
  BEGIN
    SpieleAb.Down := False;
    SpieleBis.Down := False;
    Play.Down := False;
    TAlphaSpeedBtn(Play).Caption := WortPlay;
//    Kapitel.Enabled := True;
    aktuellerBildtyp.Enabled := True;
    VorherigesI.Enabled := True;
    NaechstesI.Enabled := True;
    VorherigesP.Enabled := True;
    NaechstesP.Enabled := True;
    SchrittZurueck.Enabled :=True;
    SchrittVor.Enabled := True;
    Spielebis.Enabled := True;
    Spieleab.Enabled := True;
    Play.Enabled := True;
    IF NOT Assigned(VorschauKnoten) THEN
    BEGIN
//      IF PositionIn > -1 THEN
//        GehezuIn.Enabled := True;
//      IF PositionOut > -1 THEN
//        GehezuOut.Enabled := True;
      SchnittUebernehmen.Enabled := Schnitteinfuegenmoeglich;
    END;
    BtnVideoAdd.Enabled := True;
    Schneiden.Enabled := Schneidenmoeglich;
//    Vorschau.Enabled := True;
  END;
END;

PROCEDURE TMpegEdit.PlayerPause;
BEGIN
  AudioTimer.Enabled := False;
  IF (Player AND $01) = 1 THEN                             // Video vorhanden?
    VideoPause;
  IF (Player AND $02) = 2 THEN                             // Audio vorhanden?
    AudioplayerStop;
END;

PROCEDURE TMpegEdit.Pause;
BEGIN
  IF (VideoabspielerMode = mpPlaying) OR (TAbspielMode(AudioplayerMode) = mpPlaying) THEN
  BEGIN
    SetzeAbspielModus(False);                                // Oberfläche auf Pause/Stop einstellen
    PlayerPause;
    IF ArbeitsumgebungObj.Tempo1beiPause THEN
      Temposetzen(0);
    SpieleVonBisPosition := -1;
    IF (SchiebereglerPosition > 0) AND (SchiebereglerPosition_merken > -1) THEN
      SchiebereglerPosition_setzen(SchiebereglerPosition_merken)
    ELSE
      IF (Player AND $04) = 0 THEN
        SchiebereglerPosition_setzen(VideoBildPosition)
      ELSE
        IF Bildlaenge > 0 THEN
          SchiebereglerPosition_setzen(Round((AudioplayerPosition_holen + Audiooffset^)  / Bildlaenge))
        ELSE
          SchiebereglerPosition_setzen(0);
  END;
END;

PROCEDURE TMpegEdit.PlayerStart;
BEGIN
  IF (Player AND $02) = 2 THEN                             // Audio vorhanden?
  BEGIN
    IF (SchiebereglerPosition * Bildlaenge >= Audiooffset^) AND
       (Tempo = 1) THEN
      AudioplayerPlay;
    AudioTimer.Enabled := True;
  END;
  IF (Player AND $01) = 1 THEN                             // Video vorhanden?
    VideoPlay;                                             // muß am Ende der Funktion stehen da eine Schleife beginnt
END;

PROCEDURE TMpegEdit.Abspielen;
BEGIN
  SetzeAbspielModus((Player AND $03) <> 0);                // Oberfläche auf Abspielen einstellen
  PlayerStart;
END;

PROCEDURE TMpegEdit.Stoppen;
BEGIN
  SetzeAbspielModus(False);                                // Oberfläche auf Pause/Stop einstellen
  AudioTimer.Enabled := False;
  IF (Player AND $01) = 1 THEN                             // Video vorhanden?
  BEGIN
    VideoPause;
    Cutmoeglich(0);
  END;
  IF (Player AND $02) = 2 THEN                             // Audio vorhanden?
    AudioplayerStop;
  SchiebereglerPosition_setzen(0, True);
  SpieleVonBisPosition := -1;
  SchiebereglerPosition_merken := -1;
END;

PROCEDURE TMpegEdit.AbspielenClick;

VAR Mode : TAbspielmode;

begin
  IF (Player AND $04) = 0 THEN                             // Video oder Audio?
    Mode := VideoabspielerMode
  ELSE
    Mode := TAbspielmode(AudioplayerMode);
  CASE Mode OF
    mpStopped : Abspielen;
    mpPlaying : Pause;
    mpPaused  : Abspielen;
    mpNotReady: SetzeAbspielModus(False);
  END;
end;

procedure TMpegEdit.PlayClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Play.Down THEN
  BEGIN
    SpieleAb.Enabled:=False;
    SpieleBis.Enabled:=False;
    IF PositionOUT > Schiebereglerposition THEN
      SpieleVonBisPosition := PositionOUT;
    SchiebereglerPosition_merken := -1;
  END;
  AbspielenClick;
end;

PROCEDURE TMpegEdit.Abspielengedrueckt;
BEGIN
  IF Spielebis.Down THEN
    Spielebisgedrueckt
  ELSE
    IF Spieleab.Down THEN
      Spieleabgedrueckt
    ELSE
    BEGIN
      Play.Down := NOT Play.Down;
      Play.Click;
    END;
END;

procedure TMpegEdit.SpielebisClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Spielebis.Down then                                   // Spielebis Mode ist nicht aktiv
  BEGIN
    Play.Enabled := False;
    SpieleAb.Enabled := False;
    SchiebereglerPosition_merken := SchiebereglerPosition;
    SpieleVonBisPosition := SchiebereglerPosition;
    SchiebereglerPosition_setzen(SpieleVonBisPosition - Round(ArbeitsumgebungObj.Abspielzeit * BilderProSek));
  END;
  AbspielenClick;
end;

PROCEDURE TMpegEdit.Spielebisgedrueckt;
BEGIN
  IF Spielebis.Enabled THEN
  BEGIN
    Spielebis.Down := NOT Spielebis.Down;
    Spielebis.Click;
  END;
END;

procedure TMpegEdit.SpieleabClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Spieleab.Down then                                    // Spielebis Mode ist nicht aktiv
  BEGIN
    Play.Enabled := False;
    Spielebis.Enabled := False;
    SchiebereglerPosition_merken := SchiebereglerPosition;
    SpieleVonBisPosition := SchiebereglerPosition + Round(ArbeitsumgebungObj.Abspielzeit * BilderProSek);
  END;
  AbspielenClick;
end;

PROCEDURE TMpegEdit.Spieleabgedrueckt;
BEGIN
  IF Spieleab.Enabled THEN
  BEGIN
    Spieleab.Down := NOT Spieleab.Down;
    Spieleab.Click;
  END;  
END;

procedure TMpegEdit.AnzeigeflaecheClick(Sender: TObject);

VAR BMP: TBitMap;
    HBildPosition : Int64;

begin
  IF ((Sender = BildFlaeche) OR (Sender = VideoImage)) AND
     (NOT (VideoabspielerMode = mpPlaying)) THEN
  BEGIN
    Anzeigeflaeche.Visible := False;
    Bildflaeche.Visible := False;
    IF Anzeigeflaeche.Left > BildFlaeche.Left THEN
    BEGIN
      Anzeigeflaeche.Left := DateienfensterausPanel.Left;
      Bildflaeche.Left := DateienfensterausPanel.Left + DateienfensterausPanel.Width DIV 2;
    END
    ELSE
    BEGIN
      Anzeigeflaeche.Left := DateienfensterausPanel.Left + DateienfensterausPanel.Width DIV 2;
      Bildflaeche.Left := DateienfensterausPanel.Left;
    END;
    BMP := BMPBildlesen(-2, -2, False, False);
    IF Assigned(BMP) THEN
    BEGIN
      TRY
        VideoImage.Picture.Assign(BMP);
      FINALLY
        BMP.Free;
      END;
    END;
    HBildPosition := SchiebereglerPosition;
    SchiebereglerPosition_setzen(StandBildPosition, False);
    StandBildPosition := HBildPosition;
    StandBildPositionFrame.Caption := IntToStr(StandBildPosition);
    StandBildPositionZeit.Caption := ZeitToStr(FramesToZeit(StandBildPosition, BilderProSek));
    Fenstereinstellen;
    Anzeigeflaeche.Visible := True;
    Bildflaeche.Visible := True;
  END
  ELSE
    IF ArbeitsumgebungObj.KlickStartStop THEN
      Abspielengedrueckt;
end;

procedure TMpegEdit.AnzeigeflaecheDblClick(Sender: TObject);
begin
  IF ArbeitsumgebungObj.DoppelklickMaximieren THEN
    VollbildClick(Sender)
end;

procedure TMpegEdit.StopClick(Sender: TObject);
begin
  Stoppen;
end;

PROCEDURE TMpegEdit.Temposetzen(Mode: Integer);

VAR Videospielt : Boolean;

BEGIN
  IF (VideoabspielerMode = mpPlaying) AND (Mode < 3) THEN
  BEGIN
    Videospielt := True;
    VideoPause;
    IF (Tempo = 1) AND
       (TAbspielMode(AudioplayerMode) = mpPlaying) THEN
      AudioplayerStop;
  END
  ELSE
    Videospielt := False;
  CASE Mode OF
    0, 3: Tempo := 1;
    1: IF Tempo < 32 THEN
         Tempo := Tempo * 2;
    2: IF Tempo > 0.25 THEN
         Tempo := Tempo / 2;
  END;
  IF Videospielt THEN
  BEGIN
    IF (Tempo = 1) AND
       ((Player AND $02) = 2) AND
       (VideoBildPosition * Bildlaenge >= Audiooffset^) THEN
    BEGIN
      AudioplayerPosition_setzen(Round(VideoBildPosition * Bildlaenge - Audiooffset^));
      AudioplayerPlay;
    END;
    VideoPlay;
  END;
  IF Tempo > 0.9 THEN
    Tempoanzeige_.Caption := FloatToStrF(Tempo, ffFixed, 5, 0)
  ELSE
    Tempoanzeige_.Caption := FloatToStrF(Tempo, ffFixed, 5, 2);
END;

procedure TMpegEdit.TempoPlusBtnClick(Sender: TObject);
begin
  Temposetzen(1);
end;

procedure TMpegEdit.TempoMinusBtnClick(Sender: TObject);
begin
  Temposetzen(2);
end;

procedure TMpegEdit.Tempoanzeige_Click(Sender: TObject);
begin
  Temposetzen(0);
end;

procedure TMpegEdit.Pos0BtnClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Stoppen;
end;

procedure TMpegEdit.EndeBtnClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Pause;
  SchiebereglerPosition_setzen(SchiebereglerMax, True);
end;

procedure TMpegEdit.VorherigesIClick(Sender: TObject);

VAR I : Int64;
    J : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Assigned(IndexListe) THEN
    IF IndexListe.Count > 0 THEN
    BEGIN
      I := SchiebereglerPosition;
      J := 0;
      WHILE (J < Schrittweite) AND (I > -1) DO
      BEGIN
        I := VorherigesBild(1, I - 1, IndexListe);
        Inc(J);
      END;
      IF I < 0 THEN                           // erstes Bild suchen
        I := NaechstesBild(1, 0, IndexListe);
      IF I > SchiebereglerPosition THEN       // Bild liegt vor der aktuellen Position
        I := SchiebereglerPosition;
      SchiebereglerPosition_setzen_Stop_Start(I);
    END;
end;

procedure TMpegEdit.NaechstesIClick(Sender: TObject);

VAR I : Int64;
    J : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Assigned(IndexListe) THEN
    IF IndexListe.Count > 0 THEN
    BEGIN
      I := SchiebereglerPosition;
      J := 0;
      WHILE (J < Schrittweite) AND (I > -1) DO
      BEGIN
        I := NaechstesBild(1, I + 1, IndexListe);
        Inc(J);
      END;
      IF I < 0 THEN                           // letztes Bild suchen
        I := VorherigesBild(1, IndexListe.Count - 1, IndexListe);
      IF I < SchiebereglerPosition THEN       // Bild liegt vor der aktuellen Position
        I := SchiebereglerPosition;
      SchiebereglerPosition_setzen_Stop_Start(I);
    END;
end;

procedure TMpegEdit.VorherigesPClick(Sender: TObject);

VAR I : Int64;
    J : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Assigned(IndexListe) THEN
    IF IndexListe.Count > 0 THEN
    BEGIN
      I := SchiebereglerPosition;
      J := 0;
      WHILE (J < Schrittweite) AND (I > -1) DO
      BEGIN
        I := VorherigesBild(2, I - 1, IndexListe);
        Inc(J);
      END;
      IF I < 0 THEN                           // erstes Bild suchen
        I := NaechstesBild(2, 0, IndexListe);
      IF I > SchiebereglerPosition THEN       // Bild liegt vor der aktuellen Position
        I := SchiebereglerPosition;
      SchiebereglerPosition_setzen_Stop_Start(I);
    END;
end;

procedure TMpegEdit.NaechstesPClick(Sender: TObject);

VAR I : Int64;
    J : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Assigned(IndexListe) THEN
    IF IndexListe.Count > 0 THEN
    BEGIN
      I := SchiebereglerPosition;
      J := 0;
      WHILE (J < Schrittweite) AND (I > -1) DO
      BEGIN
        I := NaechstesBild(2, I + 1, IndexListe);
        Inc(J);
      END;
      IF I < 0 THEN                           // letztes Bild suchen
        I := VorherigesBild(2, IndexListe.Count - 1, IndexListe);
      IF I < SchiebereglerPosition THEN       // Bild liegt vor der aktuellen Position
        I := SchiebereglerPosition;
      SchiebereglerPosition_setzen_Stop_Start(I);
    END;  
end;

FUNCTION TMpegEdit.Schnittpunktmoeglich(Pos: Int64): Integer;

VAR Listenpunkt : TBildIndex;

BEGIN
  IF NOT Assigned(Vorschauknoten) THEN
    IF ((Player AND $01) = 1) AND                               // Video vorhanden
       (NOT nurAudiospeichern.Down) THEN                        // nur Audio speichern ist aktiviert --> als wenn kein Video da wär
      IF Assigned(IndexListe) THEN
        IF (Pos > -1) AND
           (Pos < IndexListe.Count) THEN
        BEGIN
          Listenpunkt := IndexListe[Pos];
          IF Listenpunkt.BildTyp = 1 THEN
            Result := 1                                         // I-Frame
          ELSE
            IF Listenpunkt.BildTyp = 2 THEN
              Result := 2                                       // P-Frame
            ELSE
              Result := 3;                                      // B-Frame
        END
        ELSE
          Result := -3                                          // Video außerhalb der Liste
      ELSE
        Result := -2                                            // keine Indexliste vorhanden
    ELSE
      IF (Player AND $02) = 2 THEN                              // Audio vorhanden
        Result := 0                                             // Audio schneiden möglich
      ELSE
        Result := -4                                            // nichts zum Schneiden da
  ELSE
    Result := -1;                                               // Vorschau ist aktiv
END;

PROCEDURE TMpegEdit.Cutmoeglich(Pos: Int64);

VAR Erg : Integer;

BEGIN
  Erg := Schnittpunktmoeglich(Pos);
  IF Erg < 0 THEN
  BEGIN
    CutIn.Enabled := False;
    CutOut.Enabled := False;
    TAlphaSpeedBtn(CutIn).ActiveGlyph := 0;
    TAlphaSpeedBtn(CutOut).ActiveGlyph := 0;
    Kapitel.Enabled := False;
  END
  ELSE
  BEGIN
    CutIn.Enabled := True;
    CutOut.Enabled := True;
    Kapitel.Enabled := True;
    IF Erg < 2 THEN
    BEGIN
      CutIn.Font.Color := clWindowText;
      TAlphaSpeedBtn(CutIn).ActiveGlyph := 0;
      Kapitel.Font.Color := clWindowText;
      TAlphaSpeedBtn(Kapitel).ActiveGlyph := 0;
//      Kapitel.Enabled := True;
    END
    ELSE
    BEGIN
      CutIn.Font.Color := clRed;
      TAlphaSpeedBtn(CutIn).ActiveGlyph := 2;
      Kapitel.Font.Color := clRed;
      TAlphaSpeedBtn(Kapitel).ActiveGlyph := 2;
//      Kapitel.Enabled := False;
    END;
    IF Erg < 3 THEN
    BEGIN
      CutOut.Font.Color := clWindowText;
      TAlphaSpeedBtn(CutOut).ActiveGlyph := 0;
    END
    ELSE
    BEGIN
      CutOut.Font.Color := clRed;
      TAlphaSpeedBtn(CutOut).ActiveGlyph := 2;
    END;
  END;
END;

PROCEDURE TMpegEdit.GehezuVideoPosition(Position: Int64);

VAR Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
    I : DWord;

BEGIN
  IF Position = VideoBildPosition THEN
    Exit;
  I := Position;
  IndexListenpunkt := IndexListe.Items[I];
  WHILE (I > 0)  AND (IndexListenpunkt.BildTyp <> 1) DO
  BEGIN
    Dec(I);
    IndexListenpunkt := IndexListe.Items[I];
  END;
  Listenpunkt := VideoListe[IndexListenpunkt.BildIndex];       // I-Frame
  IF Listenpunkt.HeaderTyp = BildStartCode THEN
    BildPosition(I, Position, Listenpunkt.Adresse);
END;

PROCEDURE TMpegEdit.Bildeinpassen(Faktor: Real);

VAR Seitenverhaeltnis : Real;
    Anzeigefaktor : Real;
    Bildhoehe : Integer;

BEGIN
  Refresh;
  Seitenverhaeltnis := 3 / 4;
  Bildhoehe := 576;
  IF (NOT (Sequenzheader = NIL)) AND (NOT(Sequenzheader.Framerate = 0)) THEN
  BEGIN
    CASE Sequenzheader.Seitenverhaeltnis OF
      1: Seitenverhaeltnis := 1;
      2: Seitenverhaeltnis := 3 / 4;
      3: Seitenverhaeltnis := 9 / 16;
      4: Seitenverhaeltnis := 1 / 2.21;
    END;
    Bildhoehe := Sequenzheader.BildHoehe;
  END;
//  IF (Anzeigeflaeche.Height / Anzeigeflaeche.Width) > Seitenverhaeltnis THEN  // Videofenster zu Schmal
//    Anzeigefaktor := (Bildhoehe / Seitenverhaeltnis) / Anzeigeflaeche.Width
//  ELSE                                                                  // Videofenster zu breit
//    Anzeigefaktor := (Bildhoehe ) / Anzeigeflaeche.Height;
{  IF VideoImage.Visible THEN                                              // Zweifensterbetrieb
    IF (Anzeigeflaeche.Height / ((Anzeigeflaeche.Width DIV 2) - 5)) > Seitenverhaeltnis THEN  // Videofenster zu Schmal
      Anzeigefaktor := (Bildhoehe / Seitenverhaeltnis) / ((Anzeigeflaeche.Width DIV 2) - 5)
    ELSE                                                                  // Videofenster zu breit
      Anzeigefaktor := (Bildhoehe ) / Anzeigeflaeche.Height
  ELSE   }
  IF Anzeigeflaeche.Visible = Bildflaeche.Visible THEN                    // zwei Videofenster
    IF ((Anzeigeflaeche.Height - 26) / (Anzeigeflaeche.Width - 6)) > Seitenverhaeltnis THEN  // Videofenster zu Schmal
      Anzeigefaktor := (Bildhoehe / Seitenverhaeltnis) / (Anzeigeflaeche.Width - 6)
    ELSE                                                                  // Videofenster zu breit
      Anzeigefaktor := Bildhoehe / (Anzeigeflaeche.Height - 26)
  ELSE                                                                    // ein Videofenster
    IF (Anzeigeflaeche.Height / Anzeigeflaeche.Width) > Seitenverhaeltnis THEN  // Videofenster zu Schmal
      Anzeigefaktor := (Bildhoehe / Seitenverhaeltnis) / Anzeigeflaeche.Width
    ELSE                                                                  // Videofenster zu breit
      Anzeigefaktor := Bildhoehe / Anzeigeflaeche.Height;
  IF NOT (Faktor = 0) THEN
    IF Faktor > Anzeigefaktor THEN
      Anzeigefaktor := Faktor;
  IF ArbeitsumgebungObj.Videoanzeigegroesse THEN
  BEGIN
    IF (Anzeigefaktor > 0.25) AND (Anzeigefaktor < 0.5) THEN
      Anzeigefaktor := 0.5;
    IF (Anzeigefaktor > 0.5) AND (Anzeigefaktor < 0.75) THEN
      Anzeigefaktor := 0.75;
    IF (Anzeigefaktor > 0.75) AND (Anzeigefaktor < 1) THEN
      Anzeigefaktor := 1;
    IF (Anzeigefaktor > 1) AND (Anzeigefaktor < 1.5) THEN
      Anzeigefaktor := 1.5;
    IF (Anzeigefaktor > 1.5) AND (Anzeigefaktor < 2) THEN
      Anzeigefaktor := 2;
    IF (Anzeigefaktor > 2) AND (Anzeigefaktor < 3) THEN
      Anzeigefaktor := 3;
    IF (Anzeigefaktor > 3) AND (Anzeigefaktor < 4) THEN
      Anzeigefaktor := 4;
  END;
  AnzeigefensterBreite := Round((Bildhoehe / Seitenverhaeltnis) / Anzeigefaktor);
  AnzeigefensterHoehe := Round(Bildhoehe / Anzeigefaktor);
//  AnzeigefensterX := Anzeigeflaeche.Left + Round((Anzeigeflaeche.Width - AnzeigefensterBreite) / 2);
//  AnzeigefensterY := Anzeigeflaeche.Top + Round((Anzeigeflaeche.Height - AnzeigefensterHoehe) / 2);
{  IF VideoImage.Visible THEN                                              // Zweifensterbetrieb
  BEGIN
    AnzeigefensterX := Anzeigeflaeche.Left + (Anzeigeflaeche.Width DIV 2) + (((Anzeigeflaeche.Width DIV 2) - AnzeigefensterBreite) DIV 2);
    VideoImage.Width := AnzeigefensterBreite;
    VideoImage.Left := ((Anzeigeflaeche.Width DIV 2) - AnzeigefensterBreite) DIV 2;
    VideoImage.Height := AnzeigefensterHoehe;
    VideoImage.Top := (Anzeigeflaeche.Height - AnzeigefensterHoehe) DIV 2;
  END
  ELSE }
  AnzeigefensterX := Anzeigeflaeche.Left + ((Anzeigeflaeche.Width - AnzeigefensterBreite) DIV 2);
  VideoImage.Width := AnzeigefensterBreite;
  VideoImage.Left := (Bildflaeche.Width - AnzeigefensterBreite) DIV 2;
  VideoImage.Height := AnzeigefensterHoehe;
  IF Anzeigeflaeche.Visible = Bildflaeche.Visible THEN                     // zwei Videofenster
  BEGIN
    AnzeigefensterY := Anzeigeflaeche.Top + ((Anzeigeflaeche.Height - AnzeigefensterHoehe) DIV 2) - 10;
    VideoImage.Top := (Bildflaeche.Height - AnzeigefensterHoehe) DIV 2 - 10;
  END
  ELSE
  BEGIN                                                                    // ein Videofenster
    AnzeigefensterY := Anzeigeflaeche.Top + ((Anzeigeflaeche.Height - AnzeigefensterHoehe) DIV 2);
    VideoImage.Top := (Bildflaeche.Height - AnzeigefensterHoehe) DIV 2;
  END;
  Anzeigeflaeche.Repaint;
  Bildflaeche.Repaint;
END;

FUNCTION TMpegEdit.Schnitteinfuegenmoeglich: Boolean;
BEGIN
  Result := ( NOT AbspielModus) AND
            (PositionOut + 1 > PositionIn) AND
            (PositionIn > -1) AND
            (NOT Assigned(Vorschauknoten));
END;

FUNCTION TMpegEdit.Schnittaendernmoeglich: Boolean;
BEGIN
  Result :=  Schnitteinfuegenmoeglich AND
            (SchnittListe.ItemIndex > - 1) AND
            (SchnittListe.SelCount = 1) AND
            (Listen.ActivePage = SchnittlistenTab);
END;

FUNCTION TMpegEdit.SchnitteinfMarkmoeglich: Boolean;
BEGIN
  Result :=  Schnitteinfuegenmoeglich AND
            (SchnittListe.SelCount > 0);
END;

FUNCTION TMpegEdit.Schneidenmoeglich: Boolean;
BEGIN
  Result := (SchnittListe.Items.Count > 0) AND
            ((NOT MarkierteSchnittpunkte.Down) OR
            (SchnittListe.SelCount > 0));
END;

FUNCTION TMpegEdit.Vorschaumoeglich: Boolean;

VAR I, J : Integer;

BEGIN
  I := 0;
  WHILE (I < SchnittListe.Items.Count) AND (NOT SchnittListe.Selected[I]) DO
    Inc(I);
  J := I + 1;
  WHILE (J < SchnittListe.Items.Count) AND (NOT SchnittListe.Selected[J]) DO
    Inc(J);
  Result := (SchnittListe.Items.Count > 1) AND
            ((SchnittListe.SelCount = 1) OR
            (SchnittListe.SelCount = 2)) AND
            ({(MarkierteSchnittpunkte.Down) OR  }
            (SchnittListe.SelCount = 1) OR
            (I + 1 = J));
END;

{Q: gemeinsamer Teil von SetPositionIn/SetPositionOut}
procedure TMpegEdit.Tastenbeschriftung(Taste: TSpeedButton; Teil1, Teil2: String);
begin
  IF TAlphaSpeedBtn(Taste).Glyph = nil then begin
    if Taste is TAlphaSpeedBtn then
      TAlphaSpeedBtn(Taste).Caption := Teil1 + '  ' + Teil2
    else
      Taste.Caption := Teil1 + ' ' + Teil2
  end else begin
    if Taste is TAlphaSpeedBtn then
      TAlphaSpeedBtn(Taste).Caption := Teil2
    else
      Taste.Caption := Teil2
  end;
end;

PROCEDURE TMpegEdit.SetSelectionLength;
BEGIN
  Schnittuebernehmen.Enabled := Schnitteinfuegenmoeglich;
  IF Schnittuebernehmen.Enabled THEN
  BEGIN
    IF (GehezuIn.Font.Color = clRed) OR (GehezuOut.Font.Color = clRed) THEN
      SchnittUebernehmen.Font.Color := clRed
    ELSE
      SchnittUebernehmen.Font.Color := clWindowText;
    Tastenbeschriftung(SchnittUebernehmen, WortUebernehmen, BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, PositionOut - PositionIn + 1, BilderProsek));
  END
  ELSE
  BEGIN
    SchnittUebernehmen.Font.Color := clWindowText;
    Tastenbeschriftung(SchnittUebernehmen, WortUebernehmen, '__:__:__:__');
  END;
END;

{Q: erledigt alles was beim setzen von PositionIn geändert werden muß}
PROCEDURE TMpegEdit.SetPositionIn(Pos: Int64; verwendeUndo: Boolean = False);

VAR Erg : Integer;

BEGIN
  IF verwendeUndo THEN
    SetUndo(TLongIntUndo.Create(WortLesen(NIL, 'Meldung502','Setze In Cut'),
            SetPositionIn, PositionIn, Pos));
  PositionIn := Pos;
  IF PositionIn < 0 THEN
  BEGIN                                         // Schnittpunkt gelöscht
    SchiebereglerSelStart_setzen(0);
    GehezuIn.Font.Color := clWindowText;
    Tastenbeschriftung(GehezuIn, WortGehezuIn, '__:__:__:__');
    GehezuIn.Enabled := False;
  END
  ELSE
  BEGIN
    Erg := Schnittpunktmoeglich(PositionIn);
    IF (Erg > -1) AND (Erg < 2) THEN
      GehezuIn.Font.Color := clWindowText
    ELSE
      GehezuIn.Font.Color := clRed;
    SchiebereglerSelStart_setzen(PositionIn);
    Tastenbeschriftung(GehezuIn, WortGehezuIn, BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, PositionIn, BilderProsek));
    GehezuIn.Enabled := True;
  END;
  SetSelectionLength;
END;

{Q: erledigt alles was beim setzen von PositionOut geändert werden muß}
PROCEDURE TMpegEdit.SetPositionOut(Pos: Int64; verwendeUndo: Boolean = False);

VAR Erg : Integer;

BEGIN
  IF verwendeUndo THEN
    SetUndo(TLongIntUndo.Create(WortLesen(NIL, 'Meldung503','Setze Out Cut'),
            SetPositionOut, PositionOut, Pos));
  PositionOut := Pos;
  IF PositionOut < 0 THEN
  BEGIN                                         // Schnittpunkt gelöscht
    SchiebereglerSelEnd_setzen(0);
    GehezuOut.Font.Color := clWindowText;
    Tastenbeschriftung(GehezuOut, WortGehezuOut, '__:__:__:__');
    GehezuOut.Enabled := False;
  END
  ELSE
  BEGIN
    Erg := Schnittpunktmoeglich(PositionOut);
    IF (Erg > -1) AND (Erg < 3) THEN
      GehezuOut.Font.Color := clWindowText
    ELSE
      GehezuOut.Font.Color := clRed;
    IF PositionIn = -1 THEN
      SchiebereglerSelStart_setzen(PositionOut + 1);
    SchiebereglerSelEnd_setzen(PositionOut);
    Tastenbeschriftung(GehezuOut, WortGehezuOut, BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, PositionOUT, BilderProsek));
    GehezuOut.Enabled := True;
  END;
  SetSelectionLength;
END;

procedure TMpegEdit.CutInClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF CutIn.Enabled AND (PositionIn <> SchiebereglerPosition) THEN
  BEGIN
    SetPositionIn(SchiebereglerPosition, True);            // Q
  END;
end;

procedure TMpegEdit.CutOutClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF CutOut.Enabled AND (PositionOut <> SchiebereglerPosition) THEN
  BEGIN
    SetPositionOut(SchiebereglerPosition, True);  // Q: PositionOut/In sollte besser ein Property sein
    IF ArbeitsumgebungObj.OutSchnittanzeigen THEN
      VideoBildanzeigesetzen;
  END;
end;

PROCEDURE TMpegEdit.VideoBildanzeigesetzen;

VAR BMP: TBitMap;

BEGIN
  IF ZweiFensterMenuItem.Checked THEN
  BEGIN
    BMP := BMPBildlesen(-2, -2, True, False);
    IF Assigned(BMP) THEN
    BEGIN
      TRY
        VideoImage.Picture.Assign(BMP);
      FINALLY
        BMP.Free;
      END;
    END;
    StandBildPosition := SchiebereglerPosition;
    StandBildPositionFrame.Caption := IntToStr(StandBildPosition);
    StandBildPositionZeit.Caption := ZeitToStr(FramesToZeit(StandBildPosition, BilderProSek));
  END;  
END;

PROCEDURE TMpegEdit.SchnittlisteHauptknotenNrneuschreiben;
BEGIN
  Schnittliste.Repaint;
END;

FUNCTION TMpegEdit.SchnittpunktFormatberechnen(Anfang, Ende: Integer; BilderProsek: Real): STRING;
BEGIN
  Result := ' ' + IntToStrFmt(DateienlisteHauptknotenNr(aktVideoknoten), 2) +
            ' ' + IntToStrFmt(DateienlisteHauptknotenNr(aktAudioknoten), 2) +
            ArbeitsumgebungObj.SchnittpunktTrennzeichen +
            BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, Anfang, BilderProsek) +
            ArbeitsumgebungObj.SchnittpunktTrennzeichen +
            BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, Ende, BilderProsek);
END;

FUNCTION TMpegEdit.Schnittpunktfuellen(Schnitt : TSchnittpunkt;
                                       Videoknoten, Audioknoten: TTreeNode;
                                       PositionIn, PositionOut: Int64;
                                       BilderProsek: Real;
                                       Liste, IndexListe: TListe): Integer;

VAR Videogroesse,
    Audiogroesse : Int64;
    BMP : TBitmap;

BEGIN
  Result := 0;
  IF (PositionIn < PositionOut + 1) AND (PositionIn > -1) THEN
  BEGIN
    IF Assigned(Schnitt) THEN
    BEGIN
      Videogroesse := SchnittgroesseberechnenVideo_Knoten(Videoknoten, PositionIn, PositionOut, Liste, IndexListe);
      IF Videogroesse < 0 THEN
        Videogroesse := 0;
      Audiogroesse := SchnittgroesseberechnenAudio_Knoten(AudioKnoten, PositionIn, PositionOut, BilderProsek);
      IF Audiogroesse < 0 THEN
        Audiogroesse := 0;
      IF Assigned(VideoKnoten) THEN
        IF VideoKnoten.Level > 0 THEN
          Schnitt.Videoknoten := VideoKnoten.Parent
        ELSE
          Schnitt.Videoknoten := VideoKnoten
      ELSE
        Schnitt.Videoknoten := NIL;
      IF Assigned(AudioKnoten) THEN
        IF AudioKnoten.Level > 0 THEN
          Schnitt.Audioknoten := AudioKnoten.Parent
        ELSE
          Schnitt.Audioknoten := AudioKnoten
      ELSE
        Schnitt.Audioknoten := NIL;
      Schnitt.Anfang := PositionIn;
      Schnitt.Ende := PositionOut;
      Schnitt.VideoGroesse := Videogroesse;
      Schnitt.AudioGroesse := Audiogroesse;
      Schnitt.Framerate := BilderProsek;
      IF Assigned(Schnitt.Videoknoten) AND
         Schnitt.Videoknoten.HasChildren AND
         Assigned(Schnitt.Videoknoten.Item[0].Data) THEN
      BEGIN
        BMP := BMPBildlesen1(TDateieintrag(Schnitt.Videoknoten.Item[0].Data).Name,
                             Liste, IndexListe,
                             Schnitt.Anfang, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False);
        IF Assigned(BMP) THEN
        BEGIN
          TRY
            Schnitt.AnfangsBild.Assign(BMP);
          FINALLY
            BMP.Free;
          END;
        END;
        BMP := BMPBildlesen1(TDateieintrag(Schnitt.Videoknoten.Item[0].Data).Name,
                             Liste, IndexListe,
                             Schnitt.Ende, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False);
        IF Assigned(BMP) THEN
        BEGIN
          TRY
            Schnitt.EndeBild.Assign(BMP);
          FINALLY
            BMP.Free;
          END;
        END;
      END;
      Schnittpunktberechnen(Schnitt, IndexListe);
    END
    ELSE
      Result := -2
  END
  ELSE
    Result := -1;
END;

PROCEDURE TMpegEdit.Schnittpunktaendern;

VAR Listenpunkt : TSchnittpunkt;
    Videogroesse,
    Audiogroesse : Int64;
    Schnittselektiert : Boolean;
    BMP : TBitmap;

BEGIN
  IF (PositionIn < PositionOut + 1) AND (PositionIn > -1) AND (PositionOut > -1) THEN
  BEGIN
    IF Schnittliste.ItemIndex > -1 THEN
    BEGIN
      Videogroesse := SchnittgroesseberechnenVideo_akt(PositionIn, PositionOut);
      Audiogroesse := SchnittgroesseberechnenAudio_akt(PositionIn, PositionOut);
      IF (Videogroesse > -1) AND (Audiogroesse > -1) THEN
      BEGIN
        Listenpunkt := TSchnittpunkt(SchnittListe.Items.Objects[Schnittliste.ItemIndex]);
        Listenpunkt.VideoName := aktVideodatei;
        IF aktVideodatei = '' THEN
          Listenpunkt.AudioName := aktAudiodatei;
        IF Assigned(aktVideoKnoten) THEN
          IF aktVideoKnoten.Level > 0 THEN
            Listenpunkt.Videoknoten := aktVideoKnoten.Parent
          ELSE
            Listenpunkt.Videoknoten := aktVideoKnoten
        ELSE
          Listenpunkt.Videoknoten := NIL;
        IF Assigned(aktAudioKnoten) THEN
          IF aktAudioKnoten.Level > 0 THEN
            Listenpunkt.Audioknoten := aktAudioKnoten.Parent
          ELSE
            Listenpunkt.Audioknoten := aktAudioKnoten
        ELSE
          Listenpunkt.Audioknoten := NIL;
        Listenpunkt.Anfang := PositionIn;
        Listenpunkt.Ende := PositionOut;
        Listenpunkt.VideoGroesse := Videogroesse;
        Listenpunkt.AudioGroesse := Audiogroesse;
        Listenpunkt.Framerate := BilderProsek;
        IF ArbeitsumgebungObj.SchnittpunktAnfangbild OR ArbeitsumgebungObj.SchnittpunktEndebild THEN
        BEGIN
          BMP := BMPBildlesen(PositionIn, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False);
          IF Assigned(BMP) THEN
          BEGIN
            TRY
              Listenpunkt.AnfangsBild.Assign(BMP);
            FINALLY
              BMP.Free;
            END;
          END;
          BMP := BMPBildlesen(PositionOut, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False);
          IF Assigned(BMP) THEN
          BEGIN
            TRY
              Listenpunkt.EndeBild.Assign(BMP);
            FINALLY
              BMP.Free;
            END;
          END;
        END;
        Schnittpunktberechnen(Listenpunkt, IndexListe);
        Schnittpunktanzeige_berechnen(Schnittliste.ItemIndex, Schnittliste.ItemIndex);
        Schnittselektiert := SchnittListe.Selected[Schnittliste.ItemIndex];
        SchnittListe.Items.Strings[Schnittliste.ItemIndex] := SchnittpunktFormatberechnen(PositionIn, PositionOut, BilderProsek);
        SchnittListe.Selected[Schnittliste.ItemIndex] := Schnittselektiert;  // wird sonst auf False gesetzt
        Dateigroesse;
        Schnittpunktanzeigeloeschen;
        Projektgeaendert_setzen(2);
      END;
    END;
  END;
END;

FUNCTION TMpegEdit.Schnitteinfuegen(Listenpunkt: TSchnittpunkt; Text: STRING; Art: Integer): Integer;

VAR ListenIndex : Integer;

BEGIN
  CASE Art OF
    0 : BEGIN                                                                   // vor der Markierung
          ListenIndex := SchnittlisteersteZeile;
          IF ListenIndex < 0 THEN
            Result := SchnittListe.Items.AddObject(Text, Listenpunkt)
          ELSE
          BEGIN
            SchnittListe.Items.InsertObject(ListenIndex, Text, Listenpunkt);
            Result := ListenIndex;
          END;
        END;
    1 : BEGIN                                                                   // nach der Markierung
          ListenIndex := SchnittlisteletzteZeile;
          IF ListenIndex < 0 THEN
            Result := SchnittListe.Items.AddObject(Text, Listenpunkt)
          ELSE
          BEGIN
            IF ListenIndex = SchnittListe.Count - 1 THEN
              Result := SchnittListe.Items.AddObject(Text, Listenpunkt)
            ELSE
            BEGIN
              Inc(ListenIndex);
              SchnittListe.Items.InsertObject(ListenIndex, Text, Listenpunkt);
              Result := ListenIndex;
            END;
            SchnittListe.Selected[ListenIndex] := True;
            Dec(ListenIndex);
            WHILE (ListenIndex > -1) AND SchnittListe.Selected[ListenIndex] DO
              Dec(ListenIndex);
            Inc(ListenIndex);
            SchnittListe.Selected[ListenIndex] := False;
          END;
        END;
  ELSE                                                                          // am Ende
    Result := SchnittListe.Items.AddObject(Text, Listenpunkt);
  END;
END;

PROCEDURE TMpegEdit.Schnittpunkteinfuegen(Art: Integer);

VAR Listenpunkt : TSchnittpunkt;
    SchnittOK : Boolean;

BEGIN
  IF (PositionIn < PositionOut + 1) AND (PositionIn > -1) AND (PositionOut > -1) THEN
    SchnittOK := True
  ELSE
    SchnittOK := False;
  // überprüfen!!!!
  IF SchnittOK THEN
    IF (aktVideodatei = '') OR
       ((VideoListe.Count > 0) AND (IndexListe.Count > 0) AND (PositionIn < IndexListe.Count) AND (PositionOut < IndexListe.Count)) THEN
      SchnittOK := True
    ELSE
      SchnittOK := False;
  IF SchnittOK THEN
    IF ((aktAudiodatei = '') OR
       (Audioheader.Framelaenge > 0)) AND (PositionIn < PositionOut +  1) AND (PositionIn > -1) AND (PositionOut > -1) THEN
      SchnittOK := True
    ELSE
      SchnittOK := False;
  IF SchnittOK THEN
  BEGIN
    Listenpunkt := TSchnittpunkt.Create;
    SchnittListe.ItemIndex := Schnitteinfuegen(Listenpunkt, '', Art);
    Schnittpunktaendern;
    IF SchnittListe.Items.Strings[SchnittListe.ItemIndex] = '' THEN
    BEGIN
      Listenpunkt := TSchnittpunkt(SchnittListe.Items.Objects[SchnittListe.ItemIndex]);
      SchnittListe.Items.Delete(SchnittListe.ItemIndex);
      IF Assigned(Listenpunkt) THEN
        Listenpunkt.Free;
    END;
    Schneiden.Enabled := Schneidenmoeglich;
    Vorschau.Enabled := Vorschaumoeglich;
  END;
END;

FUNCTION TMpegEdit.Schnittpunktberechnen(Schnittpunkt: TSchnittpunkt;  IndexListe: TListe): Integer;
BEGIN
  Result := 0;
  IF (Schnittpunkt.Anfang > -1) AND (Schnittpunkt.Anfang < IndexListe.Count)  THEN
    IF TBildIndex(IndexListe.Items[Schnittpunkt.Anfang]).BildTyp > 1 THEN
      Schnittpunkt.Anfangberechnen := 3      // neu berechnen
    ELSE
      Schnittpunkt.Anfangberechnen := 1      // nicht berechnen
  ELSE
  BEGIN
    Schnittpunkt.Anfangberechnen := 0;       // noch nicht gesetzt
    Result := -1;           // Schnittpunktanfang außerhalb der Liste
  END;
  IF (Schnittpunkt.Ende > -1) AND (Schnittpunkt.Ende < IndexListe.Count)  THEN
    IF TBildIndex(IndexListe.Items[Schnittpunkt.Ende]).BildTyp > 2 THEN
      Schnittpunkt.Endeberechnen := 3        // neu berechnen
    ELSE
      Schnittpunkt.Endeberechnen := 1        // nicht berechnen
  ELSE
  BEGIN
    Schnittpunkt.Endeberechnen := 0;         // noch nicht gesetzt
    Result := Result -2;    // Schnittpunktende außerhalb der Liste
  END;
END;

FUNCTION TMpegEdit.Schnittpunktanzeige_berechnen(Index1, Index2: Integer): Integer;

VAR Schnittpunkt1,
    Schnittpunkt2,
    Schnittpunkt3,
    Schnittpunkt4 : TSchnittpunkt;

FUNCTION Videodateivergleich(Knoten1, Knoten2: TTreeNode): Boolean;
BEGIN
  IF Assigned(Knoten1) AND Assigned(Knoten2) AND
     Knoten1.HasChildren AND Knoten2.HasChildren AND
     Assigned(Knoten1[0].Data) AND Assigned(Knoten2[0].Data)THEN
    IF Knoten1 = Knoten2 THEN
      Result := True
    ELSE
      IF TDateieintrag(Knoten1[0].Data).Name = TDateieintrag(Knoten2[0].Data).Name THEN
        Result := True
      ELSE
        Result := False
  ELSE
    Result := False;
END;

BEGIN
  Result := 0;
  IF (Index1 > -1) AND (Index1 < Schnittliste.Items.Count) THEN
    Schnittpunkt2 := Schnittliste.Items.Objects[Index1] AS TSchnittpunkt
  ELSE
  BEGIN
    Schnittpunkt2 := NIL;
    Index1 := -1;
    Result := -1;              // Index1 außerhalb der Schnittliste
  END;
  IF Index1 > 0 THEN
    Schnittpunkt1 := Schnittliste.Items.Objects[Index1 - 1] AS TSchnittpunkt
  ELSE
    Schnittpunkt1 := NIL;
  IF (Index2 > -1) AND (Index2 < Schnittliste.Items.Count) THEN
    Schnittpunkt3 := Schnittliste.Items.Objects[Index2] AS TSchnittpunkt
  ELSE
  BEGIN
    Schnittpunkt3 := NIL;
    Index2 := Schnittliste.Items.Count;
    Result := Result - 2;      // Index2 außerhalb der Schnittliste
  END;
  IF (Index2 + 1) < Schnittliste.Items.Count THEN
    Schnittpunkt4 := Schnittliste.Items.Objects[Index2 + 1] AS TSchnittpunkt
  ELSE
    Schnittpunkt4 := NIL;
  IF Assigned(Schnittpunkt1) AND Assigned(Schnittpunkt2) THEN
    IF Videodateivergleich(Schnittpunkt1.Videoknoten, Schnittpunkt2.Videoknoten) AND
       (Schnittpunkt1.Ende = (Schnittpunkt2.Anfang - 1)) THEN
    BEGIN                // nichts berechnen da Schnittpunkte zusammengehören
      Schnittpunkt1.Endeberechnen := (Schnittpunkt1.Endeberechnen AND $3) + 4;
      Schnittpunkt2.Anfangberechnen := (Schnittpunkt2.Anfangberechnen AND $3) + 4;
    END
    ELSE
    BEGIN                // Orginalzustand herstellen da die Schnittpunkte nicht zusammengehören
      Schnittpunkt1.Endeberechnen := (Schnittpunkt1.Endeberechnen AND $3);
      Schnittpunkt2.Anfangberechnen := (Schnittpunkt2.Anfangberechnen AND $3);
    END
  ELSE
    IF Assigned(Schnittpunkt2) THEN  // Orginalzustand herstellen da es keinen ersten Schnittpunkt gibt
      Schnittpunkt2.Anfangberechnen := (Schnittpunkt2.Anfangberechnen AND $3);
  IF Assigned(Schnittpunkt3) AND Assigned(Schnittpunkt4) THEN
    IF Videodateivergleich(Schnittpunkt3.Videoknoten, Schnittpunkt4.Videoknoten) AND
       (Schnittpunkt3.Ende = (Schnittpunkt4.Anfang - 1)) THEN
    BEGIN                // nichts berechnen da Schnittpunkte zusammengehören
      Schnittpunkt3.Endeberechnen := (Schnittpunkt3.Endeberechnen AND $3) + 4;
      Schnittpunkt4.Anfangberechnen := (Schnittpunkt4.Anfangberechnen AND $3) + 4;
    END
    ELSE
    BEGIN                // Orginalzustand herstellen da die Schnittpunkte nicht zusammengehören
      Schnittpunkt3.Endeberechnen := (Schnittpunkt3.Endeberechnen AND $3);
      Schnittpunkt4.Anfangberechnen := (Schnittpunkt4.Anfangberechnen AND $3);
    END
  ELSE
    IF Assigned(Schnittpunkt3) THEN  // Orginalzustand herstellen da es keinen lezten Schnittpunkt gibt
      Schnittpunkt3.Endeberechnen := (Schnittpunkt3.Endeberechnen AND $3);
END;

PROCEDURE TMpegEdit.SchnittpunktListeeinfuegen_akt(SchnittpunktListe: TListe);

VAR I,
    ListenIndex : Integer;
    Schnittpunkt : TSchnittpunkt;
    VideoGroesse,
    AudioGroesse : Int64;
    Schnittselektiert : Boolean;

BEGIN
  IF SchnittpunktListe.Count > 0 THEN
  BEGIN
    FOR I := 0 TO SchnittpunktListe.Count - 1 DO
    BEGIN
      Schnittpunkt := TSchnittpunkt(SchnittpunktListe.Items[I]);
      VideoGroesse := SchnittgroesseberechnenVideo_akt(Schnittpunkt.Anfang, Schnittpunkt.Ende);
      AudioGroesse := SchnittgroesseberechnenAudio_akt(Schnittpunkt.Anfang, Schnittpunkt.Ende);
      IF (Videogroesse > -1) AND (Audiogroesse > -1) THEN
      BEGIN
        Schnittpunkt.VideoName := aktVideodatei;
        IF aktVideodatei = '' THEN
          Schnittpunkt.AudioName := aktAudiodatei;
        IF Assigned(aktVideoKnoten) THEN
          IF aktVideoKnoten.Level > 0 THEN
            Schnittpunkt.Videoknoten := aktVideoKnoten.Parent
          ELSE
            Schnittpunkt.Videoknoten := aktVideoKnoten
        ELSE
          Schnittpunkt.Videoknoten := NIL;
        IF Assigned(aktAudioKnoten) THEN
          IF aktAudioKnoten.Level > 0 THEN
            Schnittpunkt.Audioknoten := aktAudioKnoten.Parent
          ELSE
            Schnittpunkt.Audioknoten := aktAudioKnoten
        ELSE
          Schnittpunkt.Audioknoten := NIL;
        Schnittpunkt.Framerate := BilderProsek;
        Schnittpunkt.VideoGroesse := VideoGroesse;
        Schnittpunkt.AudioGroesse := AudioGroesse;
        ListenIndex := Schnitteinfuegen(Schnittpunkt, '', ArbeitsumgebungObj.Schnittpunkteinfuegen);
        Schnittpunktberechnen(Schnittpunkt, IndexListe);
        Schnittpunktanzeige_berechnen(ListenIndex, ListenIndex);
        Schnittselektiert := SchnittListe.Selected[ListenIndex];
        SchnittListe.Items[ListenIndex] := SchnittpunktFormatberechnen(Schnittpunkt.Anfang, Schnittpunkt.Ende, Schnittpunkt.Framerate);
        SchnittListe.Selected[ListenIndex] := Schnittselektiert;  // wird sonst auf False gesetzt
      END
      ELSE
        Schnittpunkt.Free;
      SchnittpunktListe.Items[I] := NIL;
    END;
    Dateigroesse;
    Schnittpunktanzeigeloeschen;
    Schneiden.Enabled := Schneidenmoeglich;
    Vorschau.Enabled := Vorschaumoeglich;
    Projektgeaendert_setzen(2);
  END;
END;

PROCEDURE TMpegEdit.Schnittpunktanzeigeloeschen;
BEGIN
  SetPositionIn(-1);                                                     // Q
  SetPositionOut(-1);
END;

PROCEDURE TMpegEdit.Schnittpunktanzeigekorrigieren;
BEGIN
  IF (PositionIn > SchiebereglerMax) OR          // Schnittpunkte dürfen nicht größer als der Schieberegler sein
     ((Indexliste.Count > 0) AND                 // Video vorhanden
     (PositionIn > Indexliste.Count)) THEN       // Schnittpunkte dürfen nicht größer als das Video sein
    Schnittpunktanzeigeloeschen
  ELSE
    IF (PositionOut > SchiebereglerMax) THEN     // Out-Schnittpunkte dürfen nicht größer als der Schieberegler sein
      IF Indexliste.Count = 0 THEN               // kein Video vorhanden
        SetPositionOut(SchiebereglerMax)
      ELSE
        IF (PositionOut > Indexliste.Count - 1) AND
           (Indexliste.Count < SchiebereglerMax) THEN // Out-Schnittpunkte dürfen nicht größer als das Video sein
          SetPositionOut(Indexliste.Count - 1)
        ELSE
          SetPositionOut(SchiebereglerMax);
END;

procedure TMpegEdit.SchnittpunkteinfuegenClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
{  IF SchnittuebernehmenPanel.Visible THEN
  BEGIN
    AufblendeTimerfreigeben;
    SchnittuebernehmenPanel.Visible := False;
  END
  ELSE  }
    IF Schnittuebernehmen.Enabled THEN
    BEGIN
      Listen.ActivePage := SchnittlistenTab;
      Schnittpunkteinfuegen(ArbeitsumgebungObj.Schnittpunkteinfuegen);
    END;
end;

procedure TMpegEdit.SchnittuebernehmenMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Button = mbRight THEN
    IF SchnittuebernehmenPanel.Visible THEN
    BEGIN
      SchnittuebernehmenPanel.Visible := False;
    END
    ELSE
//      IF AufblendeTimererzeugen(SchnittuebernehmenPanel) THEN
      BEGIN
{        SchnitteinfuegenvorMarkierungBtn.Font.Style := [];
        SchnitteinfuegennachMarkierungBtn.Font.Style := [];
        SchnitteinfuegenamEndeBtn.Font.Style := [];
        CASE ArbeitsumgebungObj.Schnittpunkteinfuegen OF
          0 : SchnitteinfuegenvorMarkierungBtn.Font.Style := [fsBold];
          1 : SchnitteinfuegennachMarkierungBtn.Font.Style := [fsBold];
          2 : SchnitteinfuegenamEndeBtn.Font.Style := [fsBold];
        END;    }
        SchnittuebernehmenPanel.Visible := True;
        SchnitteinfuegenvorMarkierungBtn.Enabled := SchnitteinfMarkmoeglich;
        SchnitteinfuegennachMarkierungBtn.Enabled := SchnitteinfMarkmoeglich;
        SchnittaendernBtn.Enabled := Schnittaendernmoeglich;
      END;
end;

procedure TMpegEdit.SchnitteinfuegenvorMarkierungBtnClick(Sender: TObject);
begin
  IF SchnitteinfuegenvorMarkierungBtn.Enabled THEN
  BEGIN
    SchnittuebernehmenPanel.Visible := False;
    Listen.ActivePage := SchnittlistenTab;
    Schnittpunkteinfuegen(0);
  END;
end;

procedure TMpegEdit.SchnitteinfuegennachMarkierungBtnClick(
  Sender: TObject);
begin
  IF SchnitteinfuegennachMarkierungBtn.Enabled THEN
  BEGIN
    SchnittuebernehmenPanel.Visible := False;
    Listen.ActivePage := SchnittlistenTab;
    Schnittpunkteinfuegen(1);
  END;

end;

procedure TMpegEdit.SchnitteinfuegenamEndeBtnClick(Sender: TObject);
begin
  IF SchnitteinfuegenamEndeBtn.Enabled THEN
  BEGIN
    SchnittuebernehmenPanel.Visible := False;
    Listen.ActivePage := SchnittlistenTab;
    Schnittpunkteinfuegen(2);
  END;

end;

procedure TMpegEdit.SchnittaendernBtnClick(Sender: TObject);
begin
  IF SchnitteinfuegenvorMarkierungBtn.Enabled THEN
  BEGIN
    SchnittuebernehmenPanel.Visible := False;
    Listen.ActivePage := SchnittlistenTab;
    Schnittpunktaendern;
  END;

end;

// ------------------------ Schnittlisten Funktionen/Proceduren --------------------------------

procedure TMpegEdit.SchnittListeDblClick(Sender: TObject);

VAR Listenpunkt : TSchnittpunkt;

begin
  IF SchnittListe.ItemIndex > - 1 THEN
  BEGIN
    Listenpunkt := TSchnittpunkt(SchnittListe.Items.Objects[SchnittListe.ItemIndex]);
    IF Assigned(Listenpunkt) THEN
    BEGIN
//      Fortschrittsfensteranzeigen;
      TRY
        IF (DateilisteaktualisierenVideo(Listenpunkt.Videoknoten, False, False) = 0) AND
           (DateilisteaktualisierenAudio(Listenpunkt.Audioknoten, False, False) = 0) THEN
        BEGIN
          Vorschauknotenloeschen;
          IF Listenpunkt.Anfang < 0 THEN
            SetPositionIn(0)
          ELSE
            SetPositionIn(Listenpunkt.Anfang);
          IF Listenpunkt.Ende > SchiebereglerMax THEN
            SetPositionOut(SchiebereglerMax)
          ELSE
            SetPositionOut(Listenpunkt.Ende);
          Schnittpunktanzeigekorrigieren;
          SchiebereglerPosition_setzen(PositionIn);
        END;
      FINALLY
        Fortschrittsfensterverbergen;            // bei einem Fehler soll das Fortschrittsfenster dennoch verborgen werden
      END;  
    END;
  END;
end;

procedure TMpegEdit.GehezuInClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF (PositionIn = -1)  AND (SchiebereglerPosition > 0) THEN
    SchiebereglerPosition_setzen_Stop_Start(0, True)
  ELSE
    IF SchiebereglerPosition <> PositionIn THEN
      SchiebereglerPosition_setzen_Stop_Start(PositionIn, True);
end;

procedure TMpegEdit.GehezuOutClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF (PositionOut = -1) AND (SchiebereglerPosition < SchiebereglerMax) THEN
    SchiebereglerPosition_setzen_Stop_Start(SchiebereglerMax, True)
  ELSE
    IF SchiebereglerPosition <> PositionOut THEN
      SchiebereglerPosition_setzen_Stop_Start(PositionOut, True);
end;

FUNCTION TMpegEdit.LaufwerksInfo(Laufwerk: Char): Integer;

VAR Root: array[0..20] of Char;
    FileSysName, VolName: array[0..255] of Char;
    SerialNum, MaxCLength, FileSysFlag: DWORD;

BEGIN
  Root := 'C:\';
  Root[0] := Laufwerk;
  GetVolumeInformation(Root, VolName, 255, @SerialNum, MaxCLength, FileSysFlag, FileSysName, 255);
  IF FileSysName = 'FAT' THEN
    Result := 1
  ELSE
    IF FileSysName = 'FAT32' THEN
      Result := 2
    ELSE
      IF FileSysName = 'NTSC' THEN
        Result := 3
      ELSE
        Result := -1;
END;

FUNCTION TMpegEdit.Speicherplatz_pruefen(Name: STRING; SchnittpunktListe: TStrings): Boolean;

VAR I : Integer;
//    Schnittpunkt : TSchnittpunkt;
//    VGroesse, AGroesse,
    Laufwerk : Int64;

BEGIN
  Result := True;
// ------------ Größe der Audio- und Videodatei errechnen ---------------------
{  VGroesse := 0;
  AGroesse := 0;
  FOR I := 0 TO SchnittpunktListe.Count - 1 DO
  BEGIN
    Schnittpunkt := TSchnittpunkt(SchnittpunktListe.Objects[I]);
    VGroesse := VGroesse + Schnittpunkt.VideoGroesse;
    AGroesse := AGroesse + Schnittpunkt.AudioGroesse;
//    Groesse := Groesse + Schnittpunkt.VideoGroesse + Schnittpunkt.AudioGroesse;
  END;  }  // es werden die globalen Größevariablen verwendet
  Protokoll_schreiben('Die Gesamtgröße der Dateien beträgt ' + IntToStr(VideoGroesse + AudioGroesse) + ' Bytes.');
// ------------ freien Speicherplatz prüfen -----------------------------------
  Laufwerk := Diskfree(Byte(Ord(Uppercase(Name)[1])-64));
  IF Laufwerk > -1 THEN
  BEGIN
    IF Laufwerk < VideoGroesse + AudioGroesse THEN
    BEGIN
      Protokoll_schreiben(Wortlesen(NIL, 'Meldung81', 'Auf dem ausgewähltem Laufwerk ist nicht genug Platz zum Erzeugen der Video- und Audiodateien.'));
      IF Nachrichtenfenster(Wortlesen(NIL, 'Meldung81', 'Auf dem ausgewähltem Laufwerk ist nicht genug Platz zum Erzeugen der Video- und Audiodateien.') + CHR(13) +
                            Wortlesen(NIL, 'Meldung91', 'Vorgang abbrechen?'),
                            Wortlesen(NIL, 'Hinweis', 'Hinweis'), MB_YESNO, MB_ICONINFORMATION) = IDNO THEN
  //    IF MessageDlg(Wortlesen(NIL, 'Meldung81', 'Auf dem ausgewähltem Laufwerk ist nicht genug Platz zum Erzeugen der Video- und Audiodateien.') + CHR(13) +
  //                  Wortlesen(NIL, 'Meldung91', 'Vorgang abbrechen?'),
  //                  mtInformation,[mbYes, mbNo], 0) = mrNo THEN
        Protokoll_schreiben(Wortlesen(NIL, 'Meldung23', 'Der Anwender hat den Vorgang nicht abgebrochen.'))
      ELSE
      BEGIN
        Protokoll_schreiben(Wortlesen(NIL, 'Meldung22', 'Der Anwender hat den Vorgang abgebrochen.'));
        Result := False;
      END;
    END;
    IF Result THEN
    BEGIN
      I := LaufwerksInfo(Name[1]);
      IF (I > -1) AND (I < 3) AND
         ((VideoGroesse > 4294967295) OR (AudioGroesse > 4294967295)) THEN     // 4 GByte -1
      BEGIN
        Protokoll_schreiben(Wortlesen(NIL, 'Meldung86', 'Eine Datei größer 4 GByte soll auf ein FAT(32) Laufwerk geschrieben werden.'));
        IF Nachrichtenfenster(Wortlesen(NIL, 'Meldung86', 'Eine Datei größer 4 GByte soll auf ein FAT(32) Laufwerk geschrieben werden.') + CHR(13) +
                              Wortlesen(NIL, 'Meldung91', 'Vorgang abbrechen?'),
                              Wortlesen(NIL, 'Hinweis', 'Hinweis'), MB_YESNO, MB_ICONINFORMATION) = IDNO THEN
          Protokoll_schreiben(Wortlesen(NIL, 'Meldung23', 'Der Anwender hat den Vorgang nicht abgebrochen.'))
        ELSE
        BEGIN
          Protokoll_schreiben(Wortlesen(NIL, 'Meldung22', 'Der Anwender hat den Vorgang abgebrochen.'));
          Result := False;
        END;
      END;
    END;
  END
  ELSE
    Result := True;
END;

FUNCTION TMpegEdit.ListeSchneidenVideo(Name: STRING; SchnittpunktListe: TStrings; MuxListe: TStrings): Integer;

VAR Videoschnitt : TVideoschnitt;
    DateiEndung : STRING;
    I : Integer;

BEGIN
  Result := 0;
  IF Videoliste_fuellen(SchnittpunktListe) = 0 THEN
  BEGIN
    IF Pos(UpperCase(ExtractFileExt(Name)), UpperCase(ArbeitsumgebungObj.DateiendungenVideo)) = 0 THEN
    BEGIN
      DateiEndung := ExtractVideoendungSpur(SchnittpunktListe);
      IF ArbeitsumgebungObj.StandardEndungenverwenden AND (ArbeitsumgebungObj.StandardEndungenVideo <> '') THEN
        DateiEndung := ArbeitsumgebungObj.StandardEndungenVideo;
      Name := Name + DateiEndung;
    END;
    FOR I := 0 TO SchnittpunktListe.Count - 1 DO
      IF Name = TSchnittpunkt(SchnittpunktListe.Objects[I]).VideoName THEN
        Result := -2;
    IF Result = 0 THEN
    BEGIN
      Protokoll_schreiben(Meldunglesen(NIL, 'Meldung125', Name, 'Die Videodaten werden in der Datei $Text1# gespeichert.'));
//    Fortschrittsfensteranzeigen;
//    TRY
      Videoschnitt := TVideoschnitt.Create;
      Videoschnitt.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
      Videoschnitt.Textanzeige := Fortschrittsfenster.Textanzeige;
      Videoschnitt.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
      Videoschnitt.Timecode_korrigieren :=  ArbeitsumgebungObj.Timecodekorrigieren;
      Videoschnitt.Bitrate_korrigieren := ArbeitsumgebungObj.BitrateersterHeader > 0;
      IF ArbeitsumgebungObj.BitrateersterHeader = 4 THEN
        Videoschnitt.festeBitrate := ArbeitsumgebungObj.festeBitrate
      ELSE
        Videoschnitt.festeBitrate := 0;
      Videoschnitt.IndexDatei_erstellen := ArbeitsumgebungObj.IndexDateierstellen;
      Videoschnitt.D2VDatei_erstellen := ArbeitsumgebungObj.D2VDateierstellen;
      IF FramegenauschneidenCLaktiv THEN
        Videoschnitt.Framegenau_schneiden := FramegenauschneidenCL
      ELSE
        Videoschnitt.Framegenau_schneiden := ArbeitsumgebungObj.Framegenauschneiden;
      Videoschnitt.Zieldateioeffnen(Name);
      Videoschnitt.Schneiden(SchnittpunktListe);
      Protokoll_schreiben(Meldunglesen(NIL, 'Meldung128', Name, 'Das Schneiden der Datei $Text1# ist beendet.'));
      Videoschnitt.Free;
//    FINALLY
//      Fortschrittsfensterverbergen;
//    END;
      IF Assigned(MuxListe) THEN
        MuxListe.Add('VideoFile=' + Name);
    END;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.ListeSchneidenAudio(Name: STRING; Spur: Integer; SchnittpunktListe: TStrings; MuxListe: TStrings): Integer;

VAR Audioschnitt : TAudioschnitt;
    DateiEndung : STRING;
    Nummerieren,
    I : Integer;

BEGIN
  Result := 0;
  IF Audioliste_fuellen(SchnittpunktListe, Spur) = 0 THEN
  BEGIN
    IF Pos(UpperCase(ExtractFileExt(Name)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) = 0 THEN
    BEGIN
      DateiEndung := ExtractAudioendungSpur(Spur, SchnittpunktListe);
      IF ArbeitsumgebungObj.StandardEndungenverwenden THEN
        CASE AudioDateitypelesen(TSchnittpunkt(SchnittpunktListe.Objects[0]).Audioname) OF
          1 : IF ArbeitsumgebungObj.StandardEndungenPCM <> '' THEN DateiEndung := ArbeitsumgebungObj.StandardEndungenPCM;
          2 : IF ArbeitsumgebungObj.StandardEndungenMP2 <> '' THEN DateiEndung := ArbeitsumgebungObj.StandardEndungenMP2;
          3 : IF ArbeitsumgebungObj.StandardEndungenAC3 <> '' THEN DateiEndung := ArbeitsumgebungObj.StandardEndungenAC3;
        END;
    END
    ELSE
    BEGIN
      Dateiendung := ExtractFileExt(Name);
      Name := ChangeFileExt(Name, '');
    END;
    Nummerieren := Audioendungszaehler(SchnittpunktListe, Spur);
    IF Nummerieren > 0 THEN
      Name := Name + IntToStr(Nummerieren) + DateiEndung
    ELSE
      Name := Name + DateiEndung;
    FOR I := 0 TO SchnittpunktListe.Count - 1 DO
      IF Name = TSchnittpunkt(SchnittpunktListe.Objects[I]).AudioName THEN
        Result := -2;
    IF Result = 0 THEN
    BEGIN
      Protokoll_schreiben(Meldunglesen(NIL, 'Meldung126', Name, 'Die Audiodaten werden in der Datei $Text1# gespeichert.'));
//    Fortschrittsfensteranzeigen;
//    TRY
      Audioschnitt := TAudioschnitt.Create;
      Audioschnitt.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
      Audioschnitt.Textanzeige := Fortschrittsfenster.Textanzeige;
      Audioschnitt.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
      Audioschnitt.IndexDatei_erstellen := ArbeitsumgebungObj.IndexDateierstellen;
      Audioschnitt.leereAudioframesMpeg := ArbeitsumgebungObj.leereAudioframesMpegliste;
      Audioschnitt.leereAudioframesAC3 := ArbeitsumgebungObj.leereAudioframesAC3liste;
      Audioschnitt.leereAudioframesPCM := ArbeitsumgebungObj.leereAudioframesPCMliste;
      Audioschnitt.AudioEffekte := ArbeitsumgebungObj.AudioEffekte;
      Audioschnitt.Zwischenverzeichnis := ArbeitsumgebungObj.ZwischenVerzeichnis;
      Audioschnitt.Zieldateioeffnen(Name);
      Audioschnitt.Schneiden(SchnittpunktListe);
      Protokoll_schreiben(Meldunglesen(NIL, 'Meldung128', Name, 'Das Schneiden der Datei $Text1# ist beendet.'));
      Audioschnitt.Free;
//    FINALLY
//      Fortschrittsfensterverbergen;
//    END;
      IF Assigned(MuxListe) THEN
        MuxListe.Add('AudioFile' + IntToStr(Spur) + '=' + Name);
    END;
  END
  ELSE
    Result := -1;
END;

PROCEDURE TMpegEdit.ListeSchneiden(Name: STRING; SchnittpunktListe: TStrings; MuxListe: TStrings);

VAR Audioanzahl,
    Fehlernummer : Integer;

BEGIN
  IF DateienlisteVideopruefen(SchnittpunktListe) < 0 THEN
    Fehlernummer := -1
  ELSE
    Fehlernummer := 0;
  Audioanzahl := DateienlisteAudiopruefen(SchnittpunktListe);
  IF Audioanzahl < 0 THEN
    Fehlernummer := Fehlernummer + -2;
  IF Fehlernummer > -1 THEN
  BEGIN
    Verzeichniserstellen(ArbeitsumgebungObj.ZwischenVerzeichnis);
// ------------ Videodatei(en) schneiden --------------------------------------
    IF NOT nurAudiospeichern.Down THEN
      IF ListeSchneidenVideo(Name, SchnittpunktListe, MuxListe) < -1 THEN
        Fehlernummer := Fehlernummer + -4;
    IF Pos(UpperCase(ExtractFileExt(Name)), UpperCase(ArbeitsumgebungObj.DateiendungenVideo)) > 0 THEN    // Videoendung entfernen
      Name := ChangeFileExt(Name, '');
// ------------ Audiodatei(en) schneiden --------------------------------------
    Protokoll_schreiben(Meldunglesen(NIL, 'Meldung127', IntTostr(Audioanzahl), 'Es wird(werden) $Text1# Audiodatei(en) erzeugt.'));
    IF Audioanzahl > 1 THEN
      IF Pos(UpperCase(ExtractFileExt(Name)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) > 0 THEN  // Audioendung entfernen
        Name := ChangeFileExt(Name, '');
    WHILE Audioanzahl > 0 DO
    BEGIN
      IF Fehlernummer + ListeSchneidenAudio(Name, Audioanzahl, SchnittpunktListe, MuxListe) < -1 THEN
        Fehlernummer := Fehlernummer + -8;
      Dec(Audioanzahl);
    END;
  END;
  IF Fehlernummer < 0 THEN
  BEGIN
    Protokoll_schreiben(Wortlesen(NIL, 'Meldung141', 'Fehler beim Schneiden.') + ' ' +
                        Wortlesen(NIL, 'Fehlercode', 'Fehlercode') + ': ' + IntToStr(Fehlernummer));
    Meldungsfenster(Wortlesen(NIL, 'Meldung141', 'Fehler beim Schneiden.') + ' ' +
                    Wortlesen(NIL, 'Fehlercode', 'Fehlercode') + ': ' + IntToStr(Fehlernummer),
                    Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//    ShowMessage(Wortlesen(NIL, 'Meldung141', 'Fehler beim Schneiden.') + ' ' +
//                Wortlesen(NIL, 'Fehlercode', 'Fehlercode') + ': ' + IntToStr(Fehlernummer));
  END;
END;

PROCEDURE TMpegEdit.Schnittpunkt_kopieren(Quelle, Ziel: TSchnittpunkt);

PROCEDURE EffektKopieren(Quelle, Ziel: TEffektEintrag);
BEGIN
  IF Assigned(Quelle) AND Assigned(Ziel) THEN
  BEGIN
    Ziel.AnfangEffektName := Quelle.AnfangEffektName;
    Ziel.AnfangEffektDateiname := Quelle.AnfangEffektDateiname;
//    Ziel.AnfangEffektPosition := Quelle.AnfangEffektPosition;
    Ziel.AnfangLaenge := Quelle.AnfangLaenge;
    Ziel.AnfangEffektParameter := Quelle.AnfangEffektParameter;
    Ziel.EndeEffektName := Quelle.EndeEffektName;
    Ziel.EndeEffektDateiname := Quelle.EndeEffektDateiname;
//    Ziel.EndeEffektPosition := Quelle.EndeEffektPosition;
    Ziel.EndeLaenge := Quelle.EndeLaenge;
    Ziel.EndeEffektParameter := Quelle.EndeEffektParameter;
  END;
END;

BEGIN
  Ziel.Videoknoten := Quelle.Videoknoten;
  Ziel.Audioknoten := Quelle.Audioknoten;
  Ziel.Anfang := Quelle.Anfang;
  Ziel.Anfangberechnen := Quelle.Anfangberechnen;
  Ziel.Ende := Quelle.Ende;
  Ziel.Endeberechnen := Quelle.Endeberechnen;
  Ziel.VideoGroesse := Quelle.VideoGroesse;
  Ziel.AudioGroesse := Quelle.AudioGroesse;
  Ziel.Framerate := Quelle.Framerate;
  Ziel.Audiooffset := Quelle.Audiooffset;
  Ziel.VideoListe := Quelle.VideoListe;
  Ziel.VideoIndexListe := Quelle.VideoIndexListe;
  Ziel.AudioListe := Quelle.AudioListe;
  EffektKopieren(Quelle.VideoEffekt, Ziel.VideoEffekt);
  EffektKopieren(Quelle.AudioEffekt, Ziel.AudioEffekt);
END;

procedure TMpegEdit.StandbildPositionZeitDblClick(Sender: TObject);
begin
  SchiebereglerPosition_setzen(StandBildPosition, True);
end;

PROCEDURE TMpegEdit.AllesEinAusschalten(Ein: Boolean = True);

VAR I : Integer;

BEGIN
    FOR I := 0 TO Mpegedit.ComponentCount -1 DO
    BEGIN
      IF Mpegedit.Components[I] IS TControl THEN
        TControl(Mpegedit.Components[I]).Enabled := Ein;
      IF Mpegedit.Components[I] IS TMenuItem THEN
        TMenuItem(Mpegedit.Components[I]).Enabled := Ein;
    END;
    IF Ein THEN
    BEGIN
      CutIn.Enabled := NOT Assigned(VorschauKnoten);
      CutOut.Enabled := NOT Assigned(VorschauKnoten);
      GehezuIn.Enabled := (NOT Assigned(VorschauKnoten)) AND (PositionIn > -1);
      GehezuOut.Enabled := (NOT Assigned(VorschauKnoten)) AND (PositionOut > -1);
      SchnittUebernehmen.Enabled := Schnitteinfuegenmoeglich;
      Vorschau.Enabled := Vorschaumoeglich;
      Screen.Cursor := crDefault;
    END
    ELSE
      Screen.Cursor := crAppStart;
    Dialogaktiv := NOT Ein;
END;

procedure TMpegEdit.SchneidenClick(Sender: TObject);

VAR SchiebereglerPositionmerken : Int64;
    Dateiname,
    HString : STRING;
    Erg, I : Integer;
    Schnittpunkt : TSchnittpunkt;
    SchnittpunktListe,
    Projektdatei : TStringList;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Schneiden.Enabled THEN
  BEGIN
    SchnittpunktListe := TStringList.Create;
    TRY
      FOR I := 0 TO SchnittListe.Items.Count -1 DO                              // temporäre Schnittliste erstellen
        IF (NOT MarkierteSchnittpunkte.Down) OR SchnittListe.Selected[I] THEN
        BEGIN
          Schnittpunkt := TSchnittpunkt.Create;
          Schnittpunkt_kopieren(TSchnittpunkt(SchnittListe.Items.Objects[I]), Schnittpunkt);
          SchnittpunktListe.AddObject('', Schnittpunkt);
        END;
      IF SchnittpunktListe.Count > 0 THEN
      BEGIN                                                                     // Schnittliste hat Daten
        SchiebereglerPositionmerken := SchiebereglerPosition;
        Protokoll_schreiben(Wortlesen(NIL, 'Meldung21','Taste Schneiden angeklickt.'));
        IF (Player AND $01) = 1 THEN                                            // Video vorhanden?
        BEGIN
//          Videodatei_freigeben;
          IF Mpeg2Decoder_OK THEN
            CloseMPEG2File;
          Protokoll_schreiben(Meldunglesen(NIL, 'Meldung116', aktVideodatei, 'Die Datei $Text1# freigegeben.'));
        END;
        IF (Player AND $02) = 2 THEN                                            // Audio vorhanden?
        BEGIN
          AudioPlayerClose;
          Protokoll_schreiben(Meldunglesen(NIL, 'Meldung116', aktAudiodatei, 'Die Datei $Text1# freigegeben.'));
        END;
        Verzeichniserstellen(ArbeitsumgebungObj.ZwischenVerzeichnis);
        DateiName := ArbeitsumgebungObj.ZwischenVerzeichnis + 'TempCutProject.m2e';
        IF FileExists(DateiName) THEN
          DeleteFile(DateiName);
        ProjektinDateispeichern(DateiName, SchnittpunktListe, False);
        AllesEinAusschalten(False);
        HString := ExtractFilePath(Application.ExeName) + 'SchnittTool.exe';    // SchnittTool
        HString := HString + ' /oP "' + DateiName + '"';                        // ein Projekt Modus und tempoärer Projektname
        IF Projektname = '' THEN
          HString := HString + ' /Pn "_"'                                       // kein Projektname vorhanden
        ELSE
          HString := HString + ' /Pn "' + Projektname + '"';                    // Projektname des geladenen Projektes
        IF ArbeitsumgebungObj.Zieldateidialogunterdruecken THEN
          HString := HString + ' /C';                                           // sofort Schneiden
        HString := HString + ' /E';                                             // SchnittTool nach dem Schnitt schließen
        IF Assigned(ArbeitsumgebungObj) THEN
        BEGIN
          HString := HString + ' /PP "';                                        // SchnittToolgröße und Position (ProgrammPosition)
          IF ArbeitsumgebungObj.SchnittToolFensterBreite > Width THEN
            IF ArbeitsumgebungObj.SchnittToolFensterHoehe > Height THEN
              HString := HString + IntToStr(Left) + ', ' + IntToStr(Top) + ', ' + IntToStr(Width) + ', ' + IntToStr(Height) + '"'
            ELSE
              HString := HString + IntToStr(Left) + ', ' +
                                   IntToStr((Height - ArbeitsumgebungObj.SchnittToolFensterHoehe) DIV 2 + Top) + ', ' +
                                   IntToStr(Width) + ', ' +
                                   IntToStr(ArbeitsumgebungObj.SchnittToolFensterHoehe) + '"'
          ELSE
            IF ArbeitsumgebungObj.SchnittToolFensterHoehe > Height THEN
              HString := HString + IntToStr((Width - ArbeitsumgebungObj.SchnittToolFensterBreite) DIV 2 + Left) + ', ' +
                                   IntToStr(Top) + ', ' +
                                   IntToStr(ArbeitsumgebungObj.SchnittToolFensterBreite) + ', ' +
                                   IntToStr(Height) + '"'
            ELSE
              HString := HString + IntToStr((Width - ArbeitsumgebungObj.SchnittToolFensterBreite) DIV 2 + Left) + ', ' +
                                   IntToStr((Height - ArbeitsumgebungObj.SchnittToolFensterHoehe) DIV 2 + Top) + ', ' +
                                   IntToStr(ArbeitsumgebungObj.SchnittToolFensterBreite) + ', ' +
                                   IntToStr(ArbeitsumgebungObj.SchnittToolFensterHoehe) + '"';
        END;
        IF Unterprogramm_starten(HString, Programmschliessen, True) THEN        // SchnittTool aufrufen
        BEGIN                                                                   // SchnittTool erfolgreich aufgerufen
          Projektdatei := TStringList.Create;
          TRY
            Projektdatei.LoadFromFile(DateiName);
            IF LeftStr(Projektdatei.Strings[Projektdatei.Count - 2], 14) = 'Zieldateiname=' THEN
            BEGIN
              IF Assigned(ArbeitsumgebungObj) AND
                 ArbeitsumgebungObj.ZielVerzeichnisspeichern THEN
                  ArbeitsumgebungObj.ZielVerzeichnis := ExtractFilePath(OhneGaensefuesschen(Trim(KopiereVonBis(Projektdatei.Strings[Projektdatei.Count - 2], '=', ''))));
              Verzeichnismerken(ExtractFileDir(OhneGaensefuesschen(Trim(KopiereVonBis(Projektdatei.Strings[Projektdatei.Count - 2], '=', '')))));
            END;
            IF LeftStr(Projektdatei.Strings[Projektdatei.Count - 1], 13) = 'Fehlernummer=' THEN
              Erg := StrToIntDef(KopiereVonBis(Projektdatei.Strings[Projektdatei.Count - 1], '=', ''), -3)
            ELSE
              Erg := -2;                                                        // Schnitt wurde nicht ausgeführt
          FINALLY
            Projektdatei.Free;
          END;
        END
        ELSE
          Erg := -1;                                                            // Fehler beim aufrufen des SchnittTools
        BringToFront;
        AllesEinAusschalten;
        IF Assigned(ArbeitsumgebungObj) AND
          (NOT Programmschliessen) THEN                                         // Programm darf nicht beendet sein
        BEGIN
          IF (NOT (ArbeitsumgebungObj.nachSchneidenbeenden OR                   // nach dem Schneiden schliessen darf nicht aktiviert sein
              nachSchneidenbeendenCL) OR
             (Erg < 0)) THEN                                                    // Abbruch des Schneidens oder Fehler beim schneiden
          BEGIN
            IF Assigned(aktVideoknoten) AND
               Assigned(aktVideoknoten.Data) THEN
//              IF Videodatei_laden(TDateieintrag(aktVideoknoten.Data).Name, VideoListe, IndexListe) THEN
              IF OpenMPEG2File(PChar(TDateieintrag(aktVideoknoten.Data).Name)) THEN
              BEGIN
                Protokoll_schreiben(Meldunglesen(NIL, 'Meldung117', TDateieintrag(aktVideoknoten.Data).Name, 'Die Datei $Text1# ist zur Wiedergabe geöffnet.'));
                VideoBildPosition := 0;                                // ist nötig da sonst keine Veränderung
                SchiebereglerPosition_setzen(SchiebereglerPositionmerken);
              END
              ELSE
              BEGIN
                Protokoll_schreiben(Meldunglesen(NIL, 'Meldung118', TDateieintrag(aktVideoknoten.Data).Name, 'Die Datei $Text1# zur Wiedergabe öffnen ist fehlgeschlagen.'));
                SchiebereglerPosition_setzen(0);
              END;
            IF Assigned(aktAudioknoten) AND
               Assigned(aktAudioknoten.Data) THEN
              IF AudioplayerOeffnen(TDateieintragAudio(aktAudioknoten.Data).Name) THEN
              BEGIN
                Protokoll_schreiben(Meldunglesen(NIL, 'Meldung117', TDateieintragAudio(aktAudioknoten.Data).Name, 'Die Datei $Text1# ist zur Wiedergabe geöffnet.'));
                SchiebereglerPosition_setzen(SchiebereglerPositionmerken);
              END
              ELSE
              BEGIN
                Protokoll_schreiben(Meldunglesen(NIL, 'Meldung118', TDateieintragAudio(aktAudioknoten.Data).Name, 'Die Datei $Text1# zur Wiedergabe öffnen ist fehlgeschlagen.'));
                SchiebereglerPosition_setzen(0);
              END;
          END
          ELSE
          BEGIN
            nachSchneidenbeendet := True;
            Close;
          END;
        END;
        Stringliste_loeschen(SchnittpunktListe);
      END;
    FINALLY
      SchnittpunktListe.Free;
    END;
  END;
end;

procedure TMpegEdit.SchnittToolItemIndexClick(Sender: TObject);
begin
  //
end;

procedure TMpegEdit.Cut1ItemIndexClick(Sender: TObject);

VAR I : Integer;
    SchnittpunktListe: TStringList;
    Schnittpunkt : TSchnittpunkt;
    MuxListe : TStringList;
    KapitelListe : TStringList;
    NeuerName : STRING;
    Videodatei_freigegeben,
    Audiodatei_freigegeben : Boolean;
    SchiebereglerPositionmerken : Int64;

FUNCTION DateispeichernDialog(Liste: TStrings; nurAudio: Boolean): STRING;

VAR DialogTaste : Word;
    HQuelldateiname,
    HQuellVerzeichnis,
    HProjektname,
    HProjektVerzeichnis : STRING;
    Abbrechen : Boolean;

FUNCTION Dateien_vorhanden(Name: STRING; nurAudio: Boolean): Boolean;

VAR Anfang, Ende: Integer;

BEGIN
  Result := False;
  IF NOT nurAudio THEN
  BEGIN
    IF Pos(UpperCase(ExtractFileExt(Name)), UpperCase(ArbeitsumgebungObj.DateiendungenVideo)) = 0 THEN
    BEGIN
      Anfang := 2;
      Ende := Pos(';', ArbeitsumgebungObj.DateiendungenVideo + ';');
      WHILE (Ende > Anfang) AND (NOT Result) DO
      BEGIN
        Result := FileExists(Name + Copy(ArbeitsumgebungObj.DateiendungenVideo, Anfang, Ende - Anfang));
        Anfang := Ende + 2;
        Ende  := PosX(';', ArbeitsumgebungObj.DateiendungenVideo + ';', Anfang, False);
      END;
    END
    ELSE
      Result := FileExists(Name);
  END;
  IF NOT Result THEN
  BEGIN
    IF Pos(UpperCase(ExtractFileExt(Name)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) = 0 THEN
    BEGIN
      Anfang := 2;
      Ende := Pos(';', ArbeitsumgebungObj.DateiendungenAudio + ';');
      WHILE (Ende > Anfang) AND (NOT Result) DO
      BEGIN
        Result := FileExists(Name + Copy(ArbeitsumgebungObj.DateiendungenAudio, Anfang, Ende - Anfang));
        Anfang := Ende + 2;
        Ende  := PosX(';', ArbeitsumgebungObj.DateiendungenAudio + ';', Anfang, False);
      END;
    END
    ELSE
      Result := FileExists(Name);
  END;
END;

BEGIN
  Speichern.Options := [ofHideReadOnly, {ofPathMustExist, }ofEnableSizing];
  IF nurAudio THEN
  BEGIN
    Speichern.Title := Wortlesen(NIL, 'Dialog16', 'Name der Audiodatei');
    Speichern.Filter := Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio;
  END
  ELSE
  BEGIN
    Speichern.Title := Wortlesen(NIL, 'Dialog13', 'Name der MPEG-2 Videodatei');
    Speichern.Filter := Wortlesen(NIL, 'Dialog12', 'MPEG-2 Videodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo;
  END;
  Speichern.DefaultExt := '';
  IF Assigned(Liste) AND
     (Liste.Count > 0) AND
     Assigned(Liste.Objects[0]) THEN                 // mindestens ein Schnitt in der Liste vorhanden
    HQuelldateiname := DateinameausKnoten(TSchnittpunkt(Liste.Objects[0]).Videoknoten, TSchnittpunkt(Liste.Objects[0]).Audioknoten)
  ELSE                                               // Dateiname mit Verzeichnis der ersten Video- oder Audiodatei
    HQuelldateiname := '';                           // keine Datei vorhanden (dürfte nie passieren)
  HQuellVerzeichnis := ExtractFilePath(HQuelldateiname); // Verzeichnis der ersten Video- oder Audiodatei
  HQuelldateiname := ExtractFilename(ChangeFileExt(HQuelldateiname, '')); // Dateiname der ersten Video- oder Audiodatei
  IF Projektname = '' THEN
  BEGIN
    HProjektname := HQuelldateiname;                 // ist kein Projektname vorhanden wird der Quelldateiname genommen
    HProjektVerzeichnis := '';
  END
  ELSE
  BEGIN
    HProjektname := ExtractFilename(ChangeFileExt(Projektname, '')); // Projektname
    HProjektVerzeichnis := ExtractFilePath(Projektname);             // Verzeichnis in dem das Projekt gespeichert ist
  END;
  IF ZielDateinameCLaktiv THEN
  BEGIN
    Speichern.InitialDir := ExtractFilePath(ZielDateinameCL); // beim Aufruf von der CL kann ein Zieldateiname übergeben werden
    Speichern.FileName := ExtractFilename(ChangeFileExt(ZielDateinameCL, ''));
  END
  ELSE
  BEGIN
    Speichern.InitialDir := ArbeitsumgebungObj.ZielVerzeichnis;
    Speichern.FileName := ArbeitsumgebungObj.ZielDateiname;
  END;
  Speichern.InitialDir := VariablenersetzenText(Speichern.InitialDir, ['$VideoDirectory#', HQuellVerzeichnis, '$ProjectDirectory#', HProjektVerzeichnis,
                                                                       '$VideoName#', HQuelldateiname, '$ProjectName#', HProjektname]);
  Speichern.InitialDir := VariablenentfernenText(Speichern.InitialDir);
  Speichern.InitialDir := doppeltePathtrennzeichen(Speichern.InitialDir);
  IF Speichern.InitialDir = '\' THEN
    Speichern.InitialDir := '';
  Speichern.FileName := VariablenersetzenText(Speichern.FileName, ['$VideoName#', HQuelldateiname, '$ProjectName#', HProjektname]);
  Speichern.FileName := VariablenentfernenText(Speichern.FileName);
  IF Speichern.FileName = '' THEN                    // ist kein Zieldateiname definiert
    Speichern.FileName := HProjektname;              // wird der Projektname bzw. der Quelldateiname genommen
  IF Schnittpunkteeinzelnschneiden.Down THEN
    Speichern.FileName := DateinamePlusEins(Speichern.FileName, ArbeitsumgebungObj.SchnittpunkteeinzelnFormat, True);
//  IF Dateien_vorhanden(mitPathtrennzeichen(Speichern.InitialDir) + Speichern.FileName, nurAudio) THEN
//    Speichern.FileName := ChangeFileExt(Speichern.FileName, '') + '-Cut' + ExtractFileExt(Speichern.FileName);
  WHILE Dateien_vorhanden(mitPathtrennzeichen(Speichern.InitialDir) + Speichern.FileName, nurAudio) DO
    Speichern.FileName := DateinamePlusEins(Speichern.FileName, ArbeitsumgebungObj.SchnittpunkteeinzelnFormat{'$FileName#$Number;Format=N#'});
  Abbrechen := False;
  WHILE NOT Abbrechen DO
  BEGIN
    IF ArbeitsumgebungObj.Zieldateidialogunterdruecken OR
       ZielDateinameCLaktiv THEN
    BEGIN
      Abbrechen := True;
      Result := mitPathtrennzeichen(Speichern.InitialDir) + Speichern.FileName;
    END
    ELSE
    BEGIN
//      Speichern.InitialDir := Verzeichnissuchen(Speichern.InitialDir);
      Verzeichniserstellen(Speichern.InitialDir);
      IF Speichern.Execute THEN
      BEGIN
        IF Dateien_vorhanden(Speichern.FileName, nurAudio) THEN
        BEGIN
          DialogTaste :=  Nachrichtenfenster(Wortlesen(NIL, 'Meldung6', 'Die Datei(en) sind schon vorhanden. Überschreiben?'),
                                             Wortlesen(NIL, 'Warnung', 'Warnung'), MB_YESNOCANCEL, MB_ICONWARNING);
          CASE DialogTaste OF
            IDYES   : BEGIN Result := Speichern.FileName; Abbrechen := True; END;
            IDNO : Abbrechen := False;
            IDCANCEL : BEGIN Result := '$abbrechen#'; Abbrechen := True; END;
          END;
{          DialogTaste := MessageDlg(Wortlesen(NIL, 'Meldung6', 'Die Datei(en) sind schon vorhanden. Überschreiben?'),
                                    mtWarning, [mbYes, mbRetry, mbAbort], 0);
          CASE DialogTaste OF
            mrYes   : BEGIN Result := Speichern.FileName; Abbrechen := True; END;
            mrRetry : Abbrechen := False;
            mrAbort : BEGIN Result := '$abbrechen#'; Abbrechen := True; END;
          END;  }
        END
        ELSE
        BEGIN
          Abbrechen := True;
          Result := Speichern.FileName;
          IF ArbeitsumgebungObj.ZielVerzeichnisspeichern THEN
            ArbeitsumgebungObj.ZielVerzeichnis := ExtractFilePath(Result);
        END;
      END
      ELSE
      BEGIN
        Abbrechen := True;
        Result := '$abbrechen#';
      END;
    END;
  END;
  IF (Result <> '$abbrechen#') AND (Result <> '') THEN
  BEGIN
    Verzeichniserstellen(ExtractFilePath(Result));
    IF Projekt_geaendertX AND
       ArbeitsumgebungObj.nachSchneidenbeenden AND
       (NOT nachSchneidenbeendenCL) THEN
      IF Nachrichtenfenster(Wortlesen(NIL, 'Meldung92','Soll das Projekt gespeichert werden?'),
                            Wortlesen(NIL, 'Frage', 'Frage'), MB_YESNO, MB_ICONQUESTION) = IDYES THEN
 //     IF MessageDlg(Wortlesen(NIL, 'Meldung92','Soll das Projekt gespeichert werden?'),
 //                   mtConfirmation, [mbYes, mbNo], 0) = mrYes THEN
        Projektspeichern.Click;
  END;
END;

PROCEDURE aktDateien_freigeben(Liste: TStrings);

VAR I : Integer;

BEGIN
  I := 0;
  WHILE I < Liste.Count DO
  BEGIN
    IF Assigned(Liste.Objects[I]) AND
       Assigned(aktVideoknoten) AND
       ((TSchnittpunkt(Liste.Objects[I]).Videoknoten = aktVideoknoten) OR
       (TSchnittpunkt(Liste.Objects[I]).Videoknoten = aktVideoknoten.Parent)) THEN
    BEGIN
      Stoppen;
      IF (Player AND $01) = 1 THEN                       // Video vorhanden?
      BEGIN
        Videodatei_freigeben;
        Videodatei_freigegeben := True;
        Protokoll_schreiben(Meldunglesen(NIL, 'Meldung116', aktVideodatei, 'Die Datei $Text1# freigegeben.'));
      END;
    END;
    IF Assigned(Liste.Objects[I]) AND
       Assigned(aktAudioknoten) AND
       ((TSchnittpunkt(Liste.Objects[I]).Audioknoten = aktAudioknoten) OR
       (TSchnittpunkt(Liste.Objects[I]).Audioknoten = aktAudioknoten.Parent)) THEN
    BEGIN
      IF (Player AND $02) = 2 THEN                       // Audio vorhanden?
      BEGIN
        AudioPlayerClose;
        Audiodatei_freigegeben := True;
        Protokoll_schreiben(Meldunglesen(NIL, 'Meldung116', aktAudiodatei, 'Die Datei $Text1# freigegeben.'));
      END;
    END;
    Inc(I);
  END;
END;

PROCEDURE aktDateien_laden;

VAR Fehler : Boolean;

BEGIN
  Fehler := False;
  IF Videodatei_freigegeben THEN
  BEGIN
    IF Assigned(aktVideoknoten) AND
       Assigned(aktVideoknoten.Data) THEN
      IF Videodatei_laden(TDateieintrag(aktVideoknoten.Data).Name, VideoListe, IndexListe) THEN
        Protokoll_schreiben(Meldunglesen(NIL, 'Meldung117', aktVideodatei, 'Die Datei $Text1# ist zur Wiedergabe geöffnet.'))
      ELSE
      BEGIN
        Fehler := True;
        Protokoll_schreiben(Meldunglesen(NIL, 'Meldung118', aktVideodatei, 'Die Datei $Text1# zur Wiedergabe öffnen ist fehlgeschlagen.'));
      END;
  END;
  IF Audiodatei_freigegeben THEN
  BEGIN
    IF Assigned(aktAudioknoten) AND
       Assigned(aktAudioknoten.Data) THEN
      IF AudioplayerOeffnen(TDateieintragAudio(aktAudioknoten.Data).Name) THEN
        Protokoll_schreiben(Meldunglesen(NIL, 'Meldung117', aktAudiodatei, 'Die Datei $Text1# ist zur Wiedergabe geöffnet.'))
      ELSE
      BEGIN
        Fehler := True;
        Protokoll_schreiben(Meldunglesen(NIL, 'Meldung118', aktAudiodatei, 'Die Datei $Text1# zur Wiedergabe öffnen ist fehlgeschlagen.'));
      END;
  END;
  IF Fehler THEN
    SchiebereglerPosition_setzen(0)
  ELSE
    SchiebereglerPosition_setzen(SchiebereglerPositionmerken);
END;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Schneiden.Enabled THEN
  BEGIN
    Videodatei_freigegeben := False;
    Audiodatei_freigegeben := False;
    NeuerName := '';
    SchiebereglerPositionmerken := SchiebereglerPosition;
    Protokoll_schreiben(Wortlesen(NIL, 'Meldung21','Taste Schneiden angeklickt.'));
    SchnittpunktListe := TStringList.Create;
    MuxListe := TStringList.Create;
    KapitelListe := TStringList.Create;
    TRY
      IF Schnittpunkteeinzelnschneiden.Down THEN
      BEGIN
        I := 0;
        TRY
          WHILE (I < SchnittListe.Items.Count) AND
                (NeuerName <> '$abbrechen#') DO
          BEGIN
            IF (NOT MarkierteSchnittpunkte.Down) OR SchnittListe.Selected[I] THEN
            BEGIN
              Schnittpunkt := TSchnittpunkt.Create;
              Schnittpunkt_kopieren(TSchnittpunkt(SchnittListe.Items.Objects[I]), Schnittpunkt);
              SchnittpunktListe.AddObject('', Schnittpunkt);
              IF NeuerName = '' THEN              // im ersten Durchlauf Dateispeichern Dialog aufrufen
              BEGIN
                NeuerName := DateispeichernDialog(SchnittpunktListe, ((DateienlisteVideopruefen(SchnittpunktListe) = 0) OR nurAudiospeichern.Down));
                IF NeuerName <> '$abbrechen#' THEN
                BEGIN
                END;
              END;
              IF NeuerName <> '$abbrechen#' THEN
              BEGIN
                IF Speicherplatz_pruefen(NeuerName, SchnittpunktListe) THEN
                BEGIN
                  Vorschau_beenden.Click;
                  Fortschrittsfensteranzeigen;
                  aktDateien_freigeben(SchnittpunktListe);
                  ListeSchneiden(NeuerName, SchnittpunktListe, MuxListe);
                  KapitellisteKapitelberechnen(NeuerName, -1, -1, SchnittpunktListe, KapitelListe);
                  IF ArbeitsumgebungObj.Kapiteldateierstellen THEN
                    KapitellisteListespeichern(ChangeFileExt(NeuerName, ArbeitsumgebungObj.StandardEndungenKapitel), KapitelListe);
                  IF ArbeitsumgebungObj.Schneidensetztzurueck THEN
                    Projektgeaendert_zuruecksetzen;
                END;
                NeuerName := DateinamePlusEins(NeuerName, ArbeitsumgebungObj.SchnittpunkteeinzelnFormat);
              END;
              Stringliste_loeschen(SchnittpunktListe);
           END;
            Inc(I);
          END;
        FINALLY
          Fortschrittsfensterverbergen;
        END;
      END
      ELSE
      BEGIN
        FOR I := 0 TO SchnittListe.Items.Count -1 DO
          IF (NOT MarkierteSchnittpunkte.Down) OR SchnittListe.Selected[I] THEN
          BEGIN
            Schnittpunkt := TSchnittpunkt.Create;
            Schnittpunkt_kopieren(TSchnittpunkt(SchnittListe.Items.Objects[I]), Schnittpunkt);
            SchnittpunktListe.AddObject('', Schnittpunkt);
          END;
        IF SchnittpunktListe.Count > 0 THEN
        BEGIN
          NeuerName := DateispeichernDialog(SchnittpunktListe, ((DateienlisteVideopruefen(SchnittpunktListe) = 0) OR nurAudiospeichern.Down));
          TRY
            IF (NeuerName <> '$abbrechen#') AND
               (NeuerName <> '') THEN
              IF Speicherplatz_pruefen(NeuerName, SchnittpunktListe) THEN
              BEGIN
                Vorschau_beenden.Click;
                Fortschrittsfensteranzeigen;
                aktDateien_freigeben(SchnittpunktListe);
                ListeSchneiden(NeuerName, SchnittpunktListe, MuxListe);
                KapitellisteKapitelberechnen(NeuerName, -1, -1, SchnittpunktListe, KapitelListe);
                IF ArbeitsumgebungObj.Kapiteldateierstellen THEN
                  KapitellisteListespeichern(ChangeFileExt(NeuerName, ArbeitsumgebungObj.StandardEndungenKapitel), KapitelListe);
                IF ArbeitsumgebungObj.Schneidensetztzurueck THEN
                  Projektgeaendert_zuruecksetzen;
              END;
          FINALLY
            Fortschrittsfensterverbergen;
          END;
        END;
      END;
      Ausgabe(MuxListe, KapitelListe);
    FINALLY
      Stringliste_loeschen(SchnittpunktListe);
      SchnittpunktListe.Free;
      MuxListe.Free;
      KapitelListe.Free;
    END;
  END;
  IF (NOT (ArbeitsumgebungObj.nachSchneidenbeenden OR nachSchneidenbeendenCL)) OR
     (NeuerName = '$abbrechen#') THEN
    aktDateien_laden
  ELSE
  BEGIN
    nachSchneidenbeendet := True;
    Close;
  END;
end;

PROCEDURE TMpegEdit.aktAudiodateiloeschen;
BEGIN
  AudioPlayerClose;
  Player := Player AND $FD;                            // Bit 1 auf 0 setzen
  AudiooffsetAus;
  Audiolaenge.Caption := '00:00:00:000';
  aktAudiodatei := '';
  Audiodatei.Caption := '???';
  Eigenschaftenanzeigen;
END;

PROCEDURE TMpegEdit.aktVideodateiloeschen;
BEGIN
  Videoabspieler_freigeben;
  Anzeigeflaeche.Refresh;
  Player := Player AND $FE;                            // Bit 0 auf 0 setzen
  Videolaenge.Caption := '00:00:00:00';
  Videoposition.Caption := '00:00:00:00';
  aktVideodatei := '';
  Videodatei.Caption := '???';
  aktuellerBildtyp.Caption := 'X';
  BildNr.Caption := '0';
  Videodateieigenschaften;
END;

PROCEDURE TMpegEdit.aktDateienloeschen;
BEGIN
  Stoppen;
  aktVideodateiloeschen;
  VideoListe.Loeschen;
  IndexListe.Loeschen;
  SequenzHeader.Framerate := 0;
  BildHeader.BildTyp := 0;
  aktAudiodateiloeschen;
  AudioListe.Loeschen;
  AudioHeader.Framelaenge := 0;
  Player := Player AND $FB;                            // Bit 2 auf 0 setzen
  Schnittpunktanzeigeloeschen;
END;

procedure TMpegEdit.DateiloeschenClick(Sender: TObject);

VAR Knoten : TTreeNode;
    I, J : Integer;

begin
  IF Assigned(Dateien.Selected) THEN
  BEGIN
    Knoten := Dateien.Selected;
    IF Knoten.Level > 0 THEN
    BEGIN
      J := 0;
      FOR I := 0 TO Knoten.Parent.Count -1 DO
        IF Assigned(Knoten.Parent.Item[I].Data) THEN
          Inc(J);
      IF J > 1 THEN                 // mehr als ein Eintrag mit Daten vorhanden
      BEGIN
        KnotenpunktDatenloeschen(Knoten);
        Knoten := NIL;
      END
      ELSE
        Knoten := Knoten.Parent;    // nur ein Eintrag mit Daten vorhanden, der ganze Knoten ist überflüssig
    END;
    IF Assigned(Knoten) THEN        // Knoten zum löschen vorhanden
    BEGIN
      I := Schnittpunktevorhanden(Knoten);
      J := KapitelEintraegevorhanden(Knoten);
      IF I + J > 0 THEN
        IF NOT(Nachrichtenfenster(Meldunglesen(NIL, 'Meldung44', IntToStr(I + J), 'Von dieser Datei sind $Text1# Einträge in den Schnitt- und Kapitellisten vorhanden.') + Chr(13) +
                                  Wortlesen(NIL, 'Meldung45', 'Sollen die Einträge aus den Listen entfernt werden?'),
                                  Wortlesen(NIL, 'Frage', 'Frage'), MB_YESNO, MB_ICONQUESTION) = IDYES) THEN
//        IF NOT(MessageDlg(Meldunglesen(NIL, 'Meldung44', IntToStr(I + J), 'Von dieser Datei sind $Text1# Einträge in den Schnitt- und Kapitellisten vorhanden.') + Chr(13) +
//                          Wortlesen(NIL, 'Meldung45', 'Sollen die Einträge aus den Listen entfernt werden?'),
//                          mtConfirmation, [mbYes, mbCancel], 0) = mrYes) THEN
          Exit;
      Schnittpunkteloeschen(Knoten);
      KapitelEintraegeloeschen(Knoten);
      KnotenpunktDatenloeschen(Knoten);
      IF Knoten.HasChildren THEN
        IF Knoten.Item[0] = aktVideoknoten THEN
          aktVideoknoten := NIL;
      FOR I := 1 TO Knoten.Count - 1 DO
        IF Knoten.Item[I] = aktAudioknoten THEN
          aktAudioknoten := NIL;
      IF Knoten = Vorschauknoten THEN
        Vorschauknoten := NIL;
      Dateien.Items.Delete(Knoten);
      Schneiden.Enabled := Schneidenmoeglich;
      Vorschau.Enabled := Vorschaumoeglich;
      DateienlisteHauptknotenNrneuschreiben;
      SchnittlisteHauptknotenNrneuschreiben;
      KapitellisteHauptknotenNrneuschreiben;
    END;
    IF Dateien.Items.Count > 0 THEN      // unnötige Knotenpunkte (alle Knoten einer Zeile ohne Daten) löschen
    BEGIN
      I := 1;
      WHILE I < Dateien.Items[0].Count DO              // Unterknotenschleife
      BEGIN
        J := 0;
        WHILE J < Dateien.Items.Count DO               // Hauptknotenschleife
        BEGIN
          Knoten := Dateien.Items[J];
          IF Knoten.Level = 0 THEN
            IF I < Knoten.Count THEN
              IF Assigned(Knoten.Item[I].Data) THEN
                J := Dateien.Items.Count;
          Inc(J);
        END;
        IF J = Dateien.Items.Count THEN                // komplette Spur hat keine Daten und ist überflüssig
        BEGIN
          J := 0;
          WHILE J < Dateien.Items.Count DO             // Hauptknotenschleife zum löschen
          BEGIN
            Knoten := Dateien.Items[J];
            IF Knoten.Level = 0 THEN
            BEGIN
              IF I < Knoten.Count THEN
              BEGIN
                IF Knoten.Item[I] = aktAudioknoten THEN
                  aktAudioknoten := NIL;
                Knoten.Item[I].Delete;
              END;
              IF I < Knoten.Count THEN
                 Knoten.Item[I].Text := WortAudio + ' ' + IntToStr(I) + RightStr(Knoten.Item[I].Text, Length(Knoten.Item[I].Text)- Pos(' -> ',Knoten.Item[I].Text) + 1);
            END;
            Inc(J);
          END;
        END
        ELSE
          Inc(I);
      END;
      Projektgeaendert_setzen(1);
    END
    ELSE
      Projektgeaendert_zuruecksetzen;
    aktVideoknotenNr_.Caption := IntToStrFmt(DateienlisteHauptknotenNr(aktVideoknoten), 2);
    aktAudioknotenNr_.Caption := IntToStrFmt(DateienlisteHauptknotenNr(aktAudioknoten), 2);
    SchnittgroesseNeuberechnenAudiokomplett;
  END;
end;

PROCEDURE TMpegEdit.Videodateieigenschaften;

VAR HInt : Integer;
    Frame1, Frame2 : Int64;

BEGIN
  IF Assigned(VideoListe) AND Assigned(IndexListe) AND
     (VideoListe.Count > 0) THEN
  BEGIN
    HInt := 0;
    IF ArbeitsumgebungObj.maxGOPLaenge > 0 THEN
    BEGIN
      Frame2 := -1;
      REPEAT
        LangeGOPsuchen(Frame2 + 1, IndexListe.Count - 1, Frame1, Frame2, ArbeitsumgebungObj.maxGOPLaenge);
        IF Frame1 < Frame2 THEN
          Inc(HInt);
      UNTIL Frame1 = Frame2;
    END;
    GrosseGOPs := IntToStr(HInt);
    Videodateilaenge := FloatToStr(RoundTo((THeaderklein(VideoListe.Items[VideoListe.Count - 1]).Adresse + 4) /
                                      1048576, -1));
    Bitrate := FloatToStr(RoundTo((THeaderklein(VideoListe.Items[VideoListe.Count - 1]).Adresse + 4) * 8 /
                                      IndexListe.Count *
                                      BilderProSekausSeqHeaderFramerate(SequenzHeader.Framerate), 0));
  END
  ELSE
  BEGIN
    GrosseGOPs := '';
    Videodateilaenge := '';
    Bitrate := '';
  END;
  Eigenschaftenanzeigen;
END;

PROCEDURE TMpegEdit.Eigenschaftenanzeigen;

VAR TextListe : TStringList;
    Text : STRING;
    HByte : Byte;

BEGIN
  TextListe := TStringList.Create;
  TRY
    IF NOT (SequenzHeader.Framerate = 0) THEN
    BEGIN
      IF Assigned(VideoListe) AND Assigned(IndexListe) THEN
      BEGIN
        Text := WortVideodateigroesse + ': ' + Videodateilaenge + ' MB';
        TextListe.Add(Text);
        Text := WortVideobitrate + ': ' + Bitrate + ' ' + WortBitProSek;
        TextListe.Add(Text);
        Text := '------------------------------------';
        TextListe.Add(Text);
        IF ArbeitsumgebungObj.maxGOPLaenge > 0 THEN
        BEGIN
          TextListe.Add(WortGOPs + ' > ' + IntToStr(ArbeitsumgebungObj.maxGOPLaenge) + ' ' + WortBilder + ': ' + GrosseGOPs);
          TextListe.Add(Text);
        END;
      END;
      Text := WortSequenzheader + ':';
      TextListe.Add(Text);
      Text := WortBildbreite + ': ' + IntToStr(SequenzHeader.BildBreite);
      TextListe.Add(Text);
      Text := WortBildhoehe + ': ' + IntToStr(SequenzHeader.BildHoehe);
      TextListe.Add(Text);
      Text := WortSeitenverhaeltnis;
      CASE SequenzHeader.Seitenverhaeltnis OF
        1: Text := Text + ': 1/1';
        2: Text := Text + ': 4/3';
        3: Text := Text + ': 16/9';
        4: Text := Text + ': 2.21/1';
      ELSE
        Text := Text + ' ' + Wortunbekannt;
      END;
      TextListe.Add(Text);
      Text := WortFramerate;
      CASE SequenzHeader.Framerate OF
        1: Text := Text + ': 23,976 ';
        2: Text := Text + ': 24 ';
        3: Text := Text + ': 25 ';
        4: Text := Text + ': 29,97 ';
        5: Text := Text + ': 30 ';
        6: Text := Text + ': 50 ';
        7: Text := Text + ': 59,94 ';
        8: Text := Text + ': 60 ';
      ELSE
        Text := Text + ' ' + Wortunbekannt;
      END;
      IF (SequenzHeader.Framerate > 0) AND (SequenzHeader.Framerate < 9) THEN
        Text := Text + WortBilderProSek;
      TextListe.Add(Text);
      Text := WortBitrate + ': ' + FloatToStr(SequenzHeader.Bitrate) + ' ' + WortBitProSek;
      TextListe.Add(Text);
      Text := WortVBV_Puffer + ': ' + IntToStr(SequenzHeader.VBVPuffer * 2) + ' kB';
      TextListe.Add(Text);
      Text := WortProfil_Level + ': ';
      HByte := (SequenzHeader.ProfilLevel AND $70) SHR 4;
      CASE HByte OF
        1: Text := Text + WortHigh;
        2: Text := Text + WortSpatiallyScalable;
        3: Text := Text + WortSNRScalable;
        4: Text := Text + WortMain;
        5: Text := Text + WortSimple;
      ELSE
        Text := Text + Wortunbek;
      END;
      HByte := SequenzHeader.ProfilLevel AND $0F;
      Text := Text + '/';
      CASE HByte OF
        4: Text := Text + WortHigh;
        6: Text := Text + WortHigh + ' 1440';
        8: Text := Text + WortMain;
        10: Text := Text + WortLow;
      ELSE
        Text := Text + Wortunbek;
      END;
      TextListe.Add(Text);
      IF SequenzHeader.Progressive THEN
      BEGIN
        Text := WortprogressiveSequenz;
        TextListe.Add(Text);
      END;
      Text := WortFarbformat;
      CASE SequenzHeader.ChromaFormat OF
        1: Text := Text + ': 4:2:0';
        2: Text := Text + ': 4:2:2';
        3: Text := Text + ': 4:4:4';
      ELSE
        Text := Text + ' ' + Wortunbekannt;
      END;
      TextListe.Add(Text);
      Text := WortLowDelay;
      IF SequenzHeader.LowDelay THEN
        Text := Text + ': ' + WortJa
      ELSE
        Text := Text + ': ' + WortNein;
      TextListe.Add(Text);
      Text := '------------------------------------';
      TextListe.Add(Text);
    END;
    IF NOT (BildHeader.BildTyp = 0) THEN
    BEGIN
      Text := WortBildheader + ':';
      TextListe.Add(Text);
      Text := WortBildtyp;
      CASE BildHeader.BildTyp OF
        1: Text := Text + ': I-';
        2: Text := Text + ': P-';
        3: Text := Text + ': B-';
      ELSE
        Text := Text + ' ' + Wortunbekannt;
      END;
      IF (BildHeader.BildTyp > 0) AND (BildHeader.BildTyp < 4) THEN
        Text := Text + WortBild;
      TextListe.Add(Text);
      Text := WortDCPrezision;
      CASE BildHeader.IntraDCPre OF
        0: Text := Text + ': 8';
        1: Text := Text + ': 9';
        2: Text := Text + ': 10';
        3: Text := Text + ': 11';
      ELSE
        Text := Text + ' ' + Wortunbekannt;
      END;
      TextListe.Add(Text);
      Text := WortBildStruktur;
      CASE BildHeader.BildStruktur OF
        1: Text := Text + ': ' + WortOben;
        2: Text := Text + ': ' + WortUnten;
        3: Text := Text + ': ' + WortBild;
      ELSE
        Text := Text + ' ' + Wortunbekannt;
      END;
      TextListe.Add(Text);
      Text := WortoberstesBildzuerst;
      IF BildHeader.OberstesFeldzuerst THEN
        Text := Text + ': ' + WortJa
      ELSE
        Text := Text + ': ' + WortNein;
      TextListe.Add(Text);
    // Weitere Informationen müssen erst erforscht werden
      Text := '------------------------------------';
      TextListe.Add(Text);
    END;
    IF NOT (AudioHeader.Framelaenge = 0) THEN
    BEGIN
      Text := WortAudioinformationen + ':';
      TextListe.Add(Text);
      CASE AudioHeader.Audiotyp OF
        2 : BEGIN
          Text := WortMpeg;
          CASE AudioHeader.Version OF
            1: Text := Text + ' 2,5';
            2: Text := Text + ' 2';
            3: Text := Text + ' 1';
          ELSE
            Text := Text + ' ' + Wortunbek;
          END;
          Text := Text + ', ' + WortLayer;
          CASE AudioHeader.Layer OF
            1: Text := Text + ' 3';
            2: Text := Text + ' 2';
            3: Text := Text + ' 1';
          ELSE
            Text := Text + ' ' + Wortunbek;
          END;
          TextListe.Add(Text);
          Text := WortBitrate + ': ' + IntToStr(AudioHeader.Bitrateberechnet) + ' ' + WortKbitProSek;
          TextListe.Add(Text);
          Text := WortSamplerate + ': ' + IntToStr(AudioHeader.Samplerateberechnet) + ' ' + WortHz;
          TextListe.Add(Text);
          Text := WortKanalModus;
          CASE AudioHeader.Mode OF
            0: Text := Text + ': ' + WortStereo;
            1: Text := Text + ': ' + WortJointStereo;
            2: Text := Text + ': ' + WortZweiKanal;
            3: Text := Text + ': ' + WortEinKanal;
          ELSE
            Text := Text + ' ' + Wortunbekannt;
          END;
          TextListe.Add(Text);
        END;
        3 : BEGIN
          Text := WortAC3_Ton;
          TextListe.Add(Text);
          Text := WortBitrate + ': ' + IntToStr(AudioHeader.Bitrateberechnet) + ' ' + WortKbitProSek;
          TextListe.Add(Text);
          Text := WortSamplerate + ': ' + IntToStr(AudioHeader.Samplerateberechnet) + ' ' + WortHz;
          TextListe.Add(Text);
          CASE AudioHeader.Mode OF
            0: Text := WortStreamModus0;
            1: Text := WortStreamModus1;
            2: Text := WortStreamModus2;
            3: Text := WortStreamModus3;
            4: Text := WortStreamModus4;
            5: Text := WortStreamModus5;
            6: Text := WortStreamModus6;
            7: Text := WortStreamModus7;
            8: Text := WortStreamModus8;
          ELSE
            Text := WortStreamModus + ' ' + Wortunbekannt;
          END;
          TextListe.Add(Text);
          CASE AudioHeader.ModeErweiterung OF
            0: Text := WortCodeModus0;
            1: Text := WortCodeModus1;
            2: Text := WortCodeModus2;
            3: Text := WortCodeModus3;
            4: Text := WortCodeModus4;
            5: Text := WortCodeModus5;
            6: Text := WortCodeModus6;
            7: Text := WortCodeModus7;
          ELSE
            Text := WortCodeModus + ' ' + Wortunbekannt;
          END;
          TextListe.Add(Text);
          IF (AudioHeader.ModeErweiterung = 2) AND (AudioHeader.Emphasis = 32) THEN
          BEGIN
            Text := WortDolbySurround;
            TextListe.Add(Text);
          END;
          IF AudioHeader.Copyright THEN
          BEGIN
            Text := WortLFE;
            TextListe.Add(Text);
          END;
        END;
      END;
      Text := WortFramelaenge + ': ' + IntToStr(AudioHeader.Framelaenge) + ' Byte';
      TextListe.Add(Text);
      Text := WortFramedauer + ': ' + FloatToStr(AudioHeader.Framezeit) + ' ms';
      TextListe.Add(Text);
    END;
    IF  CompareStr(TextListe.Text, Informationen.Lines.Text) <> 0 THEN
      Informationen.Lines.Assign(TextListe);
  FINALLY
    TextListe.Free;
  END;
  Informationen.SelStart := 1;          // Cursor an den Textanfang setzen, dadurch ist der erste Teil des Fensters zu sehen
  Informationen.SelLength := 0;
END;

{PROCEDURE TMpegEdit.Dateieigenschaften;

VAR Text : STRING;
    HByte : Byte;
    Sprachobjektloeschen : Boolean;
    HInt : Integer;
    Frame1, Frame2 : Int64;

BEGIN
//Informationen.Invalidate;
  Informationen.Clear;
  IF NOT ((SequenzHeader.Framerate = 0) AND
          (BildHeader.BildTyp = 0) AND
          (AudioHeader.Framelaenge = 0)) THEN
  BEGIN
    IF NOT Assigned(Spracheladen) THEN
    BEGIN
      Spracheladen := Sprachobjekterzeugen(Sprachverzeichnis, Sprachdateiname, aktuelleSprache, False);
      Sprachobjektloeschen := True;
    END
    ELSE
      Sprachobjektloeschen := False;
    TRY
      IF NOT (SequenzHeader.Framerate = 0) THEN
      BEGIN
        IF Assigned(VideoListe) AND Assigned(IndexListe) THEN
        BEGIN
          HInt := 0;
          IF ArbeitsumgebungObj.maxGOPLaenge > 0 THEN
          BEGIN
            Frame2 := -1;
            REPEAT
              LangeGOPsuchen(Frame2 + 1, IndexListe.Count - 1, Frame1, Frame2, ArbeitsumgebungObj.maxGOPLaenge);
              IF Frame1 < Frame2 THEN
                Inc(HInt);
            UNTIL Frame1 = Frame2;
          END;
          Text := Wortlesen(Spracheladen, 'Videodateigroesse', 'Videodateigröße') + ': ';
          Text := Text + FloatToStr(RoundTo((THeaderklein(VideoListe.Items[VideoListe.Count - 1]).Adresse + 4) /
                                            1048576, -1)) + ' MB';
          Informationen.Lines.Add(Text);
          Text := Wortlesen(Spracheladen, 'Videobitrate', 'Videobitrate') + ': ';
          Text := Text + FloatToStr(RoundTo((THeaderklein(VideoListe.Items[VideoListe.Count - 1]).Adresse + 4) * 8 /
                                            IndexListe.Count *
                                            BilderProSekausSeqHeaderFramerate(SequenzHeader.Framerate), 0)) +
                                            ' ' + Wortlesen(Spracheladen, 'bit/s', 'bit/s');
          Informationen.Lines.Add(Text);
          Text := '------------------------------------';
          Informationen.Lines.Add(Text);
          IF ArbeitsumgebungObj.maxGOPLaenge > 0 THEN
          BEGIN
            Informationen.Lines.Add(Wortlesen(Spracheladen, 'GOPs', 'GOPs') + ' > ' + IntToStr(ArbeitsumgebungObj.maxGOPLaenge) + ' ' + Wortlesen(Spracheladen, 'Bilder', 'Bilder') + ': ' + IntToStr(HInt));
            Informationen.Lines.Add(Text);
          END;
        END;
        Text := Wortlesen(Spracheladen, 'Sequenzheader', 'Sequenzheader') + ':';
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'Bildbreite', 'Bildbreite') + ': ' + IntToStr(SequenzHeader.BildBreite);
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'Bildhöhe', 'Bildhöhe') + ': ' + IntToStr(SequenzHeader.BildHoehe);
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'Seitenverhältnis', 'Seitenverhältnis');
        CASE SequenzHeader.Seitenverhaeltnis OF
          1: Text := Text + ': 1/1';
          2: Text := Text + ': 3/4';
          3: Text := Text + ': 9/16';
          4: Text := Text + ': 1/2.21';
        ELSE
          Text := Text + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
        END;
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'Framerate', 'Framerate');
        CASE SequenzHeader.Framerate OF
          1: Text := Text + ': 23,976 ';
          2: Text := Text + ': 24 ';
          3: Text := Text + ': 25 ';
          4: Text := Text + ': 29,97 ';
          5: Text := Text + ': 30 ';
          6: Text := Text + ': 50 ';
          7: Text := Text + ': 59,94 ';
          8: Text := Text + ': 60 ';
        ELSE
          Text := Text + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
        END;
        IF (SequenzHeader.Framerate > 0) AND (SequenzHeader.Framerate < 9) THEN
          Text := Text + Wortlesen(Spracheladen, 'Bilder/sek', 'Bilder/sek.');
        Informationen.Lines.Add(Text);
//        Text := Wortlesen(Spracheladen, 'Bitrate', 'Bitrate') + ': ' + FloatToStr(RoundTo(SequenzHeader.Bitrate / 1000000, -3)) + ' ' + Wortlesen(Spracheladen, 'Mbit/s', 'Mbit/s');
        Text := Wortlesen(Spracheladen, 'Bitrate', 'Bitrate') + ': ' + FloatToStr(SequenzHeader.Bitrate) + ' ' + Wortlesen(Spracheladen, 'bit/s', 'bit/s');
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'VBV-Puffer', 'VBV-Puffer') + ': ' + IntToStr(SequenzHeader.VBVPuffer * 2) + ' kB';
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'Profil/Level', 'Profil/Level') + ': ';
        HByte := (SequenzHeader.ProfilLevel AND $70) SHR 4;
        CASE HByte OF
          1: Text := Text + Wortlesen(Spracheladen, 'High', 'High');
          2: Text := Text + Wortlesen(Spracheladen, 'SpatiallyScalable', 'Spatially Scalable');
          3: Text := Text + Wortlesen(Spracheladen, 'SNRScalable', 'SNR Scalable');
          4: Text := Text + Wortlesen(Spracheladen, 'Main', 'Main');
          5: Text := Text + Wortlesen(Spracheladen, 'Simple', 'Simple');
        ELSE
          Text := Text + Wortlesen(Spracheladen, 'unbek', 'unbek.');
        END;
        HByte := SequenzHeader.ProfilLevel AND $0F;
        Text := Text + '/';
        CASE HByte OF
          4: Text := Text + Wortlesen(Spracheladen, 'High', 'High');
          6: Text := Text + Wortlesen(Spracheladen, 'High', 'High') + ' 1440';
          8: Text := Text + Wortlesen(Spracheladen, 'Main', 'Main');
          10: Text := Text + Wortlesen(Spracheladen, 'Low', 'Low');
        ELSE
          Text := Text + Wortlesen(Spracheladen, 'unbek', 'unbek.');
        END;
        Informationen.Lines.Add(Text);
        IF SequenzHeader.Progressive THEN
        BEGIN
          Text := Wortlesen(Spracheladen, 'progressiveSequenz', 'progressive Sequenz');
          Informationen.Lines.Add(Text);
        END;
        Text := Wortlesen(Spracheladen, 'Farbformat', 'Farbformat');
        CASE SequenzHeader.ChromaFormat OF
          1: Text := Text + ': 4:2:0';
          2: Text := Text + ': 4:2:2';
          3: Text := Text + ': 4:4:4';
        ELSE
          Text := Text + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
        END;
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'LowDelay', 'Low Delay');
        IF SequenzHeader.LowDelay THEN
          Text := Text + ': ' + Wortlesen(Spracheladen, 'Ja', 'Ja')
        ELSE
          Text := Text + ': ' + Wortlesen(Spracheladen, 'Nein', 'Nein');
        Informationen.Lines.Add(Text);
        Text := '------------------------------------';
        Informationen.Lines.Add(Text);
      END;
      IF NOT (BildHeader.BildTyp = 0) THEN
      BEGIN
        Text := Wortlesen(Spracheladen, 'Bildheader', 'Bildheader') + ':';
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'Bildtyp', 'Bildtyp');
        CASE BildHeader.BildTyp OF
          1: Text := Text + ': I-';
          2: Text := Text + ': P-';
          3: Text := Text + ': B-';
        ELSE
          Text := Text + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
        END;
        IF (BildHeader.BildTyp > 0) AND (BildHeader.BildTyp < 4) THEN
          Text := Text + Wortlesen(Spracheladen, 'Bild', 'Bild');
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'DCPrezision', 'DC Prezision');
        CASE BildHeader.IntraDCPre OF
          0: Text := Text + ': 8';
          1: Text := Text + ': 9';
          2: Text := Text + ': 10';
          3: Text := Text + ': 11';
        ELSE
          Text := Text + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
        END;
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'BildStruktur', 'Bild Struktur');
        CASE BildHeader.BildStruktur OF
          1: Text := Text + ': ' + Wortlesen(Spracheladen, 'Oben', 'Oben');
          2: Text := Text + ': ' + Wortlesen(Spracheladen, 'Unten', 'Unten');
          3: Text := Text + ': ' + Wortlesen(Spracheladen, 'Bild', 'Bild');
        ELSE
          Text := Text + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
        END;
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'oberstesBildzuerst', 'oberstes Bild zuerst');
        IF BildHeader.OberstesFeldzuerst THEN
          Text := Text + ': ' + Wortlesen(Spracheladen, 'Ja', 'Ja')
        ELSE
          Text := Text + ': ' + Wortlesen(Spracheladen, 'Nein', 'Nein');
        Informationen.Lines.Add(Text);
      // Weitere Informationen müssen erst erforscht werden
        Text := '------------------------------------';
        Informationen.Lines.Add(Text);
      END;
      IF NOT (AudioHeader.Framelaenge = 0) THEN
      BEGIN
        Text := Wortlesen(Spracheladen, 'Audioinformationen', 'Audioinformationen') + ':';
        Informationen.Lines.Add(Text);
        CASE AudioHeader.Audiotyp OF
          2 : BEGIN
            Text := Wortlesen(Spracheladen, 'Mpeg', 'Mpeg');
            CASE AudioHeader.Version OF
              1: Text := Text + ' 2,5';
              2: Text := Text + ' 2';
              3: Text := Text + ' 1';
            ELSE
              Text := Text + ' ' + Wortlesen(Spracheladen, 'unbek', 'unbek.');
            END;
            Text := Text + ', ' + Wortlesen(Spracheladen, 'Layer', 'Layer');
            CASE AudioHeader.Layer OF
              1: Text := Text + ' 3';
              2: Text := Text + ' 2';
              3: Text := Text + ' 1';
            ELSE
              Text := Text + ' ' + Wortlesen(Spracheladen, 'unbek', 'unbek.');
            END;
            Informationen.Lines.Add(Text);
            Text := Wortlesen(Spracheladen, 'Bitrate', 'Bitrate') + ': ' + IntToStr(AudioHeader.Bitrateberechnet) + ' ' + Wortlesen(Spracheladen, 'Kbit/s', 'kbit/s');
            Informationen.Lines.Add(Text);
            Text := Wortlesen(Spracheladen, 'Samplerate', 'Samplerate') + ': ' + IntToStr(AudioHeader.Samplerateberechnet) + ' ' + Wortlesen(Spracheladen, 'Hz', 'Hz');
            Informationen.Lines.Add(Text);
            Text := Wortlesen(Spracheladen, 'KanalModus', 'Kanal Modus');
            CASE AudioHeader.Mode OF
              0: Text := Text + ': ' + Wortlesen(Spracheladen, 'Stereo', 'Stereo');
              1: Text := Text + ': ' + Wortlesen(Spracheladen, 'JointStereo', 'Joint Stereo');
              2: Text := Text + ': ' + Wortlesen(Spracheladen, 'ZweiKanal', 'Zwei Kanal');
              3: Text := Text + ': ' + Wortlesen(Spracheladen, 'EinKanal', 'Ein Kanal');
            ELSE
              Text := Text + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
            END;
            Informationen.Lines.Add(Text);
          END;
          3 : BEGIN
            Text := Wortlesen(Spracheladen, 'AC3-Ton', 'AC3-Ton');
            Informationen.Lines.Add(Text);
            Text := Wortlesen(Spracheladen, 'Bitrate', 'Bitrate') + ': ' + IntToStr(AudioHeader.Bitrateberechnet) + ' ' + Wortlesen(Spracheladen, 'Kbit/s', 'kbit/s');
            Informationen.Lines.Add(Text);
            Text := Wortlesen(Spracheladen, 'Samplerate', 'Samplerate') + ': ' + IntToStr(AudioHeader.Samplerateberechnet) + ' ' + Wortlesen(Spracheladen, 'Hz', 'Hz');
            Informationen.Lines.Add(Text);
            CASE AudioHeader.Mode OF
              0: Text := Wortlesen(Spracheladen, 'StreamModus0', 'Complete Main (CM)');
              1: Text := Wortlesen(Spracheladen, 'StreamModus1', 'Music and Effects (ME)');
              2: Text := Wortlesen(Spracheladen, 'StreamModus2', 'Visually Impaired (VI)');
              3: Text := Wortlesen(Spracheladen, 'StreamModus3', 'Hearing Impaired (HI)');
              4: Text := Wortlesen(Spracheladen, 'StreamModus4', 'Dialogue (D)');
              5: Text := Wortlesen(Spracheladen, 'StreamModus5', 'Commentary (C)');
              6: Text := Wortlesen(Spracheladen, 'StreamModus6', 'Emergency (E)');
              7: Text := Wortlesen(Spracheladen, 'StreamModus7', 'Voice Over (VO)');
              8: Text := Wortlesen(Spracheladen, 'StreamModus8', 'Karaoke');
            ELSE
              Text := Wortlesen(Spracheladen, 'StreamModus', 'Stream Mode') + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
            END;
            Informationen.Lines.Add(Text);
            CASE AudioHeader.ModeErweiterung OF
              0: Text := Wortlesen(Spracheladen, 'CodeModus0', '1+1 - Ch1, Ch2');
              1: Text := Wortlesen(Spracheladen, 'CodeModus1', '1/0 - C');
              2: Text := Wortlesen(Spracheladen, 'CodeModus2', '2/0 - L, R');
              3: Text := Wortlesen(Spracheladen, 'CodeModus3', '3/0 - L, C, R');
              4: Text := Wortlesen(Spracheladen, 'CodeModus4', '2/1 - L, R, S');
              5: Text := Wortlesen(Spracheladen, 'CodeModus5', '3/1 - L, C, R, S');
              6: Text := Wortlesen(Spracheladen, 'CodeModus6', '2/2 - L, R, SL, SR');
              7: Text := Wortlesen(Spracheladen, 'CodeModus7', '3/2 - L, C, R, SL, SR');
            ELSE
              Text := Wortlesen(Spracheladen, 'CodeModus', 'Coding Mode') + ' ' + Wortlesen(Spracheladen, 'unbekannt', 'unbekannt');
            END;
            Informationen.Lines.Add(Text);
            IF (AudioHeader.ModeErweiterung = 2) AND (AudioHeader.Emphasis = 32) THEN
            BEGIN
              Text := Wortlesen(Spracheladen, 'DolbySurround', 'DolbySurround');
              Informationen.Lines.Add(Text);
            END;
            IF AudioHeader.Copyright THEN
            BEGIN
              Text := Wortlesen(Spracheladen, 'LFE', 'Low Frequency Effects');
              Informationen.Lines.Add(Text);
            END;
          END;
        END;
        Text := Wortlesen(Spracheladen, 'Framelaenge', 'Framelänge') + ': ' + IntToStr(AudioHeader.Framelaenge) + ' Byte';
        Informationen.Lines.Add(Text);
        Text := Wortlesen(Spracheladen, 'Framedauer', 'Framedauer') + ': ' + FloatToStr(AudioHeader.Framezeit) + ' ms';
        Informationen.Lines.Add(Text);
      END;
    FINALLY
      IF Sprachobjektloeschen THEN
        Sprachobjektfreigeben(Spracheladen);;
    END;
  END;
  Informationen.SelStart := 1;          // Cursor an den Textanfang setzen, dadurch ist der erste Teil des Fensters zu sehen
  Informationen.SelLength := 0;
END; }

procedure TMpegEdit.DateienClick(Sender: TObject);

VAR Knoten : TTreeNode;

begin
  Knoten := Dateien.Selected;
  IF Assigned(Knoten) THEN
  BEGIN
//    Fortschrittsfensteranzeigen;
    TRY
      IF Knoten.Level = 0 THEN
      BEGIN
        IF ArbeitsumgebungObj.SchiebereglerPosbeibehalten THEN
          Dateilisteaktualisieren(Knoten)
        ELSE
        BEGIN
          Dateilisteaktualisieren(Knoten, False);
          SchiebereglerPosition_setzen(0);
        END;
        Schnittpunktanzeigeloeschen;
      END
      ELSE
      BEGIN
        Dateilisteaktualisieren(Knoten);
        IF (NOT ArbeitsumgebungObj.VAextra) AND
           (((Knoten.Parent.IndexOf(Knoten) = 0) AND
             (NOT Assigned(aktAudioknoten) OR (aktAudioknoten.Parent <> Knoten.Parent))) OR
            ((Knoten.Parent.IndexOf(Knoten) > 0) AND
             (NOT Assigned(aktVideoknoten) OR (aktVideoknoten.Parent <> Knoten.Parent)))) THEN
        BEGIN
          IF ArbeitsumgebungObj.SchiebereglerPosbeibehalten THEN
            Dateilisteaktualisieren(Knoten.Parent)
          ELSE
          BEGIN
            Dateilisteaktualisieren(Knoten.Parent, False);
            SchiebereglerPosition_setzen(0);
          END;
          Schnittpunktanzeigeloeschen;
        END;
        Schnittpunktanzeigekorrigieren;
      END;
    FINALLY
      Fortschrittsfensterverbergen;
    END;
  END;
end;

procedure TMpegEdit.DateienEnter(Sender: TObject);
begin
  Dateienfensteraktiv := True;
end;

procedure TMpegEdit.DateienExit(Sender: TObject);
begin
  DateienfensterEditaktiv := False;
  Dateienfensteraktiv := False;
end;

procedure TMpegEdit.DateienEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
begin
  DateienfensterEditaktiv := True;
end;

procedure TMpegEdit.DateienEdited(Sender: TObject; Node: TTreeNode; var S: String);

VAR I, Position : Integer;

begin
  IF Node.Level > 0 THEN
  BEGIN
    I := Node.Parent.IndexOf(Node);
    IF I = 0 THEN
    BEGIN
      IF NOT(Pos(WortVideo + ' -> ', S) = 1) THEN
        S := WortVideo + ' -> ' + S;
    END
    ELSE
    BEGIN
      IF NOT(Pos(WortAudio + ' ' + IntToStr(I) + ' -> ', S) = 1) THEN
        S := WortAudio + ' ' + IntToStr(I) + ' -> ' + S;
    END;
  END
  ELSE
  BEGIN
    Position := Pos(' ', S);
    IF Position > 0 THEN
      IF StrToIntDef(LeftStr(S, Position - 1), 0) = DateienlisteHauptknotenNr(Node) THEN
        S := IntToStrFmt(DateienlisteHauptknotenNr(Node), 2) + RightStr(S, Length(S) - Position + 1)
      ELSE
        S := IntToStrFmt(DateienlisteHauptknotenNr(Node), 2) + ' ' + TrimLeft(S)
    ELSE
      S := IntToStrFmt(DateienlisteHauptknotenNr(Node), 2) + ' ' + TrimLeft(S);
  END;
  DateienfensterEditaktiv := False;
end;

procedure TMpegEdit.InformationenEnter(Sender: TObject);
begin
  Infofensteraktiv := True;
end;

procedure TMpegEdit.InformationenExit(Sender: TObject);
begin
  Infofensteraktiv := False;
end;

procedure TMpegEdit.SchnittListeClick(Sender: TObject);

VAR Knoten : TTreeNode;
    Index : Integer;

begin
  Knoten := NIL;
  Index := SchnittListe.ItemIndex;
  IF (Index > -1) AND (Index < SchnittListe.Items.Count) THEN
  BEGIN
    IF Assigned(TSchnittpunkt(SchnittListe.Items.Objects[Index]).Videoknoten) AND
       TSchnittpunkt(SchnittListe.Items.Objects[Index]).Videoknoten.HasChildren AND
       Assigned(TSchnittpunkt(SchnittListe.Items.Objects[Index]).Videoknoten.Item[0].Data) THEN
      Knoten := TSchnittpunkt(SchnittListe.Items.Objects[Index]).Videoknoten
    ELSE
      IF Assigned(TSchnittpunkt(SchnittListe.Items.Objects[Index]).Audioknoten) THEN
        Knoten := TSchnittpunkt(SchnittListe.Items.Objects[Index]).Audioknoten;
    IF Assigned(Knoten) THEN
      Dateien.Selected := Knoten;
  END;
end;

procedure TMpegEdit.DateienfensterMenuePopup(Sender: TObject);
begin
  Pause;
  IF Dateien.Items.Count > 0 THEN
  BEGIN
    IF NOT Assigned(VorschauKnoten) THEN
{    IF Assigned(Dateien.Selected) AND
       ((Dateien.Selected.Level > 0) OR
       (Dateien.Selected <> VorschauKnoten)) AND
       ((Dateien.Selected.Level = 0) OR
       (Dateien.Selected.Parent <> VorschauKnoten)) THEN   }
    BEGIN
      IF Dateien.Selected.Level = 0 THEN
        Dateiaendern.Enabled := False
      ELSE
        Dateiaendern.Enabled := True;
      Dateihinzufuegen.Enabled := True;
      Dateiloeschen.Enabled := True;
    END
    ELSE
    BEGIN
      Dateiaendern.Enabled := False;
      Dateihinzufuegen.Enabled := False;
      Dateiloeschen.Enabled := False;
    END;
  END
  ELSE
  BEGIN
    Dateiaendern.Enabled := False;
    Dateihinzufuegen.Enabled := False;
    Dateiloeschen.Enabled := False;
  END;
end;

procedure TMpegEdit.AnzeigefenstermenuePopup(Sender: TObject);
begin
//  Pause;
  Videoanzeigegroesse1.Checked := ArbeitsumgebungObj.Videoanzeigegroesse;
  IF Mpeg2Fenster.NurIFrames THEN
    NurIFrames.Checked := True
  ELSE
    NurIFrames.Checked := False;
  IF Videoabspieler_OK THEN
    keinVideo.Checked := False
  ELSE
    keinVideo.Checked := True;
end;

procedure TMpegEdit.Videoanzeigegroesse1Click(Sender: TObject);
begin
  ArbeitsumgebungObj.Videoanzeigegroesse := NOT ArbeitsumgebungObj.Videoanzeigegroesse;
  Maximal.Click;
end;

procedure TMpegEdit.NurIFramesClick(Sender: TObject);
begin
  Mpeg2Fenster.NurIFrames := NOT Mpeg2Fenster.NurIFrames;
end;

procedure TMpegEdit.keinVideoClick(Sender: TObject);
begin
  Pause;
  IF Videoabspieler_OK THEN
    Videoausschalten
  ELSE
    Videoeinschalten;
end;

PROCEDURE TMpegEdit.Schnittpunkt_loeschen(SchnittPkt: Integer);
BEGIN
  SchnittListe.Items.Objects[SchnittPkt].Free;
  SchnittListe.Items.Delete(SchnittPkt);
END;

procedure TMpegEdit.MarkierteSchnittpunkteloeschenClick(Sender: TObject);

VAR I : Integer;

begin
  IF SchnittListe.SelCount > 0 THEN
  BEGIN
    I := 0;
    WHILE I < SchnittListe.Items.Count DO
      IF SchnittListe.Selected[I] THEN
      BEGIN
        Schnittpunkt_loeschen(I);
        IF I < SchnittListe.Items.Count THEN
          Schnittpunktanzeige_berechnen(I, -1)
        ELSE
          IF I > 0 THEN
            Schnittpunktanzeige_berechnen(-1, I - 1);
      END
      ELSE
        Inc(I);
    SchnittListe.ItemIndex := - 1;
    Schneiden.Enabled := Schneidenmoeglich;
    Vorschau.Enabled := Vorschaumoeglich;
    Projektgeaendert_setzen(2);
    Dateigroesse;
  END;
end;

PROCEDURE TMpegEdit.SchnittListe_loeschen;

VAR I : Integer;

BEGIN
  FOR I := 0 TO SchnittListe.Items.Count -1 DO
    TSchnittpunkt(SchnittListe.Items.Objects[I]).Free;
  SchnittListe.Clear;
  SchnittListe.ItemHeight := 10;
  SchnittListe.ItemIndex := - 1;
END;

procedure TMpegEdit.SchnittlisteloeschenClick(Sender: TObject);
begin
  IF Nachrichtenfenster(Wortlesen(NIL, 'Meldung41', 'Soll wirklich die gesamte Schnittliste gelöscht werden?'),
                        Wortlesen(NIL, 'Frage', 'Frage'), MB_YESNO, MB_ICONQUESTION) = IDYES THEN
//  IF MessageDlg(Wortlesen(NIL, 'Meldung41', 'Soll wirklich die gesamte Schnittliste gelöscht werden?'), mtConfirmation, [mbYes, mbNo], 0) = mrYes THEN
  BEGIN
    SchnittListe_loeschen;
    Projektgeaendert_setzen(2);
    Schneiden.Enabled := False;
    Dateigroesse;
  END;
end;

// ---------------------------- Menue Funktionen/Proceduren -----------------------------------

PROCEDURE TMpegEdit.Projektgeaendert_setzen(Modus: Integer);
BEGIN
  CASE Modus OF
    1 : Dateilistegeaendert := True;
    2 : Schnittlistegeaendert := True;
    3 : Kapitellistegeaendert := True;
    4 : Effektgeaendert := True;
    5 : Markenlistegeaendert := True;
  ELSE
    Dateilistegeaendert := True;
    Schnittlistegeaendert := True;
    Kapitellistegeaendert := True;
    Effektgeaendert := True;
    Markenlistegeaendert := True;
  END;
  IF Projekt_geaendert THEN
    ProjektSpeichernBtn.Enabled := True
  ELSE
    ProjektSpeichernBtn.Enabled := False;
END;

FUNCTION TMpegEdit.Projekt_geaendert: Boolean;
BEGIN
  Result := (Dateien.Items.Count > 0) AND
            (Dateilistegeaendert OR
             Schnittlistegeaendert OR
             Kapitellistegeaendert OR
             Effektgeaendert OR
             Markenlistegeaendert);
END;

FUNCTION TMpegEdit.Projekt_geaendertX: Boolean;
BEGIN
  Result := ((Dateilistegeaendert AND ArbeitsumgebungObj.Dateilistegeaendert AND (Dateien.Items.Count > 0)) OR
            (Schnittlistegeaendert AND ArbeitsumgebungObj.Schnittlistegeaendert AND (Schnittliste.Items.Count > 0)) OR
            (Kapitellistegeaendert AND ArbeitsumgebungObj.Kapitellistegeaendert AND (KapitellisteGrid.Tag > 1)) OR
            (Effektgeaendert AND ArbeitsumgebungObj.Effektgeaendert AND (Schnittliste.Items.Count > 0)) OR
            (Markenlistegeaendert AND ArbeitsumgebungObj.Markenlistegeaendert AND (Markenliste.Lines.Count > 0)));
END;

PROCEDURE TMpegEdit.Projektgeaendert_zuruecksetzen;
BEGIN
  Dateilistegeaendert := False;
  Schnittlistegeaendert := False;
  Kapitellistegeaendert := False;
  Effektgeaendert := False;
  Markenlistegeaendert := False;
  ProjektSpeichernBtn.Enabled := False;
END;

PROCEDURE TMpegEdit.ProjektinDateispeichern(Name: STRING; SchnittpunktListe: TStrings; Alle: Boolean; Vorschau : Integer = -1);

VAR IniFile : TIniFile;
    I, J, K, L : Integer;
    Schnittpunkt : TSchnittpunkt;
    Kapiteleintrag : TKapiteleintrag;
    Knotenpunkt,
    Unterknoten : TTreeNode;

FUNCTION Knotennummer(Knoten: TTreeNode): Integer;

VAR K, I : Integer;

BEGIN
  Result := 0;
  IF Assigned(Knoten) THEN
    IF Knoten.Level = 0 THEN
    BEGIN
      K := 0;
      I := 0;
      WHILE I < Dateien.Items.Count DO             // Videoliste durchgehen
      BEGIN
        IF Dateien.Items[I].Level = 0 THEN         // nur Knoten der ersten Ebene beachten
        BEGIN
          IF Alle OR
            (Schnittpunktevorhanden(Dateien.Items[I]) > 0) OR
            (KapitelEintraegevorhanden(Dateien.Items[I]) > 0) THEN
            Inc(K);                                // Knotenzähler
          IF Dateien.Items[I] = Knoten THEN
          BEGIN
            Result := K;                           // Knoten gefunden
            I := Dateien.Items.Count;
          END;
        END;
        Inc(I);
      END;
    END
    ELSE
    BEGIN
      K := Knotennummer(Knoten.Parent);            // Index des Hauptknotens * 1000 +
      Result := K * 1000 + Knoten.Parent.IndexOf(Knoten); // Index des Unterknotens
    END;
END;

BEGIN
  IniFile := TIniFile.Create(Name);
  TRY
    IniFile.WriteInteger('Allgemein', 'Version', 4);
    IF aktArbeitsumgebung < ArbeitsumgebungenListe.Count THEN
      IniFile.WriteString('Allgemein', 'Ini-Datei', '"' + relativPathAppl(ArbeitsumgebungenListe[aktArbeitsumgebung], Application.ExeName) + '"');
    IF Vorschau = -1 THEN
    BEGIN
      IniFile.WriteString('Allgemein', 'Zielverzeichnis', '"' + relativPathAppl(ArbeitsumgebungObj.ZielVerzeichnis, Application.ExeName) + '"');
      IniFile.WriteString('Allgemein', 'Zieldateiname', '"' + ArbeitsumgebungObj.ZielDateiname + '"');
      IniFile.WriteBool('Allgemein', 'IndexDateierstellen', ArbeitsumgebungObj.IndexDateierstellen);
    END
    ELSE
    BEGIN
//      IniFile.WriteString('Allgemein', 'Zielverzeichnis', '"' + ExtractFilePath(Name) + '"');
//      IniFile.WriteString('Allgemein', 'Zieldateiname', '"' + ChangeFileExt(ExtractFileName(Name), '') + '"');
      IniFile.WriteString('Allgemein', 'Zielverzeichnis', '"$Projectdirectory#"');
      IniFile.WriteString('Allgemein', 'Zieldateiname', '"$Projectname#"');
      IniFile.WriteBool('Allgemein', 'IndexDateierstellen', True);
    END;
    IniFile.WriteString('Allgemein', 'Tempverzeichnis', '"' + relativPathAppl(ArbeitsumgebungObj.ZwischenVerzeichnis, Application.ExeName) + '"');
    IniFile.WriteString('Allgemein', 'Demuxerdatei', '"' + relativPathAppl(ArbeitsumgebungObj.Demuxerdatei, Application.ExeName) + '"');
    IniFile.WriteString('Allgemein', 'Encoderdatei', '"' + relativPathAppl(ArbeitsumgebungObj.Encoderdatei, Application.ExeName) + '"');
    IniFile.WriteString('Allgemein', 'Ausgabedatei', '"' + relativPathAppl(ArbeitsumgebungObj.Ausgabedatei, Application.ExeName) + '"');
    IniFile.WriteBool('Allgemein', 'Timecode_korrigieren', ArbeitsumgebungObj.Timecodekorrigieren);
    IniFile.WriteBool('Allgemein', 'Bitrate_korrigieren', ArbeitsumgebungObj.Bitratekorrigieren);
    IniFile.WriteBool('Allgemein', 'D2VDateierstellen', ArbeitsumgebungObj.D2VDateierstellen);
    IniFile.WriteBool('Allgemein', 'IDXDateierstellen', ArbeitsumgebungObj.IDXDateierstellen);
    IniFile.WriteBool('Allgemein', 'Kapiteldateierstellen', ArbeitsumgebungObj.Kapiteldateierstellen);
    IniFile.WriteString('Allgemein', 'AudioTrennzeichen', '"' + ArbeitsumgebungObj.AudioTrennzeichen + '"');
    IniFile.WriteInteger('Allgemein', 'BitrateersterHeader', ArbeitsumgebungObj.BitrateersterHeader);
    IniFile.WriteInteger('Allgemein', 'feste_Bitrate', ArbeitsumgebungObj.festeBitrate);
    IniFile.WriteInteger('Allgemein', 'AspectratioersterHeader', ArbeitsumgebungObj.AspectratioersterHeader);
    IniFile.WriteInteger('Allgemein', 'AspectratioOffset', ArbeitsumgebungObj.AspectratioOffset);
    IniFile.WriteBool('Allgemein', 'maxGOPLaenge_verwenden', ArbeitsumgebungObj.maxGOPLaengeverwenden);
    IniFile.WriteBool('Allgemein', 'Ausgabebenutzen', ArbeitsumgebungObj.Ausgabebenutzen);
    IniFile.WriteBool('Allgemein', 'Framegenauschneiden', ArbeitsumgebungObj.Framegenauschneiden);
    IniFile.WriteBool('Allgemein', 'Schnittpunkteeinzelnschneiden', Schnittpunkteeinzelnschneiden.Down);
    IniFile.WriteBool('Allgemein', 'nurAudioschneiden', nurAudiospeichern.Down);
    IniFile.WriteBool('Allgemein', 'ZusammenhaengendeSchnitteberechnen', ArbeitsumgebungObj.ZusammenhaengendeSchnitteberechnen);
    IniFile.WriteInteger('Allgemein', 'aktVideoknoten', Knotennummer(aktVideoknoten)); // aktiven AudioEintrag speichern
    IniFile.WriteInteger('Allgemein', 'aktAudioknoten', Knotennummer(aktAudioknoten)); // aktiven VideoEintrag speichern
    K := 1;
    FOR I := 0 TO Dateien.Items.Count - 1 DO                   // Dateiliste speichern
    BEGIN
      Knotenpunkt := Dateien.Items[I];
      IF (Knotenpunkt.Level = 0) AND                           // nur Knoten der ersten Ebene beachten
         (Knotenpunkt <> Vorschauknoten) THEN                  // Vorschauknoten nicht mitspeichern
        IF Alle OR
          (Schnittpunktevorhanden(Knotenpunkt) > 0) OR
          (KapitelEintraegevorhanden(Knotenpunkt) > 0) THEN
          IF Knotenpunkt.HasChildren THEN
          BEGIN
            IniFile.WriteString('Dateiknoten-' + IntToStr(K), 'Knotenname', '"' + Knotenpunkt.Text + '"');
            IF (Vorschau = -1) OR (Vorschau = 0) THEN
            BEGIN
              Unterknoten := Knotenpunkt.Item[0];
              IniFile.WriteString('Dateiknoten-' + IntToStr(K), 'Videoname', '"' + Unterknoten.Text + '"');
              IF Assigned(Unterknoten.Data) THEN
                IniFile.WriteString('Dateiknoten-' + IntToStr(K), 'Videodatei', '"' + TDateieintrag(Unterknoten.Data).Name + '"')
              ELSE
                IniFile.WriteString('Dateiknoten-' + IntToStr(K), 'Videodatei', '');
            END;
            L := 1;
            FOR J := 1 TO Knotenpunkt.Count - 1 DO                      // dann alle Unterkoten durchlaufen
              IF (Vorschau = -1) OR (J = Vorschau) THEN
              BEGIN
                Unterknoten := Knotenpunkt.Item[J];
                IniFile.WriteString('Dateiknoten-' + IntToStr(K), 'Audioname-' + IntToStr(L), '"' + Unterknoten.Text + '"');
                IF Assigned(Unterknoten.Data) THEN
                BEGIN
                  IniFile.WriteString('Dateiknoten-' + IntToStr(K), 'Audiodatei-' + IntToStr(L), '"' + TDateieintragAudio(Unterknoten.Data).Name + '"');
                  IniFile.WriteInteger('Dateiknoten-' + IntToStr(K), 'Audiooffset-' + IntToStr(L), TDateieintragAudio(Unterknoten.Data).Audiooffset);
                END
                ELSE
                BEGIN
                  IniFile.WriteString('Dateiknoten-' + IntToStr(K), 'Audiodatei-' + IntToStr(L), '');
                  IniFile.WriteInteger('Dateiknoten-' + IntToStr(K), 'Audiooffset-' + IntToStr(L), 0);
                END;
                Inc(L);
              END;
            Inc(K);
          END;
    END;
    FOR I := 0 TO SchnittpunktListe.Count - 1 DO
    BEGIN
      Schnittpunkt := TSchnittpunkt(SchnittpunktListe.Objects[I]);
      IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'Schnittpunktname', '"' + Schnittpunktliste.Strings[I] + '"');
      IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'Videoknoten', Knotennummer(Schnittpunkt.Videoknoten));
      IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'Audioknoten', Knotennummer(Schnittpunkt.Audioknoten));
      IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'Anfang', Schnittpunkt.Anfang);
      IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'Ende', Schnittpunkt.Ende);
      IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'Anfangberechnen', (Schnittpunkt.Anfangberechnen AND $83));
      IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'Endeberechnen', (Schnittpunkt.Endeberechnen AND $83));
      IF (Vorschau = -1) OR (Vorschau = 0) THEN
        IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoGroesse', IntToStr(Schnittpunkt.VideoGroesse))
      ELSE
        IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoGroesse', '0');
      IF (Vorschau = -1) OR (Vorschau > 0) THEN
        IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioGroesse', IntToStr(Schnittpunkt.AudioGroesse))
      ELSE
        IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioGroesse', '0');
      IniFile.WriteFloat('Schnittpunkt-' + IntToStr(I), 'Framerate', Schnittpunkt.Framerate);
      IF Assigned(Schnittpunkt.VideoEffekt) THEN
      BEGIN
        IF Schnittpunkt.VideoEffekt.AnfangEffektName <> '' THEN
        BEGIN
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangEffekt', '"' + Schnittpunkt.VideoEffekt.AnfangEffektName + '"');
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangEffektdatei', '"' + relativPathAppl(Schnittpunkt.VideoEffekt.AnfangEffektDateiname, Application.ExeName) + '"');
          IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'VideoAnfangLaenge', Schnittpunkt.VideoEffekt.AnfangLaenge);
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangParameter', '"' + Schnittpunkt.VideoEffekt.AnfangEffektParameter + '"');
        END;
        IF Schnittpunkt.VideoEffekt.EndeEffektName <> '' THEN
        BEGIN
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoEndeEffekt', '"' + Schnittpunkt.VideoEffekt.EndeEffektName + '"');
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoEndeEffektdatei', '"' + relativPathAppl(Schnittpunkt.VideoEffekt.EndeEffektDateiname, Application.ExeName) + '"');
          IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'VideoEndeLaenge', Schnittpunkt.VideoEffekt.EndeLaenge);
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'VideoEndeParameter', '"' + Schnittpunkt.VideoEffekt.EndeEffektParameter + '"');
        END;
      END;
      IF Assigned(Schnittpunkt.AudioEffekt) THEN
      BEGIN
        IF Schnittpunkt.AudioEffekt.AnfangEffektName <> '' THEN
        BEGIN
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangEffekt', '"' + Schnittpunkt.AudioEffekt.AnfangEffektName + '"');
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangEffektdatei', '"' + relativPathAppl(Schnittpunkt.AudioEffekt.AnfangEffektDateiname, Application.ExeName) + '"');
          IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'AudioAnfangLaenge', Schnittpunkt.AudioEffekt.AnfangLaenge);
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangParameter', '"' + Schnittpunkt.AudioEffekt.AnfangEffektParameter + '"');
        END;
        IF Schnittpunkt.AudioEffekt.EndeEffektName <> '' THEN
        BEGIN
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioEndeEffekt', '"' + Schnittpunkt.AudioEffekt.EndeEffektName + '"');
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioEndeEffektdatei', '"' + relativPathAppl(Schnittpunkt.AudioEffekt.EndeEffektDateiname, Application.ExeName) + '"');
          IniFile.WriteInteger('Schnittpunkt-' + IntToStr(I), 'AudioEndeLaenge', Schnittpunkt.AudioEffekt.EndeLaenge);
          IniFile.WriteString('Schnittpunkt-' + IntToStr(I), 'AudioEndeParameter', '"' + Schnittpunkt.AudioEffekt.EndeEffektParameter + '"');
        END;
      END;
    END;
    IF Vorschau = -1 THEN
    BEGIN                                                        // keine Vorschauberechnung
      FOR I := 1 TO KapitelListeGrid.Tag - 1 DO
      BEGIN
        Kapiteleintrag := TKapiteleintrag(KapitelListeGrid.Objects[2, I]);
        IniFile.WriteString('Kapitel-' + IntToStr(I), 'Kapitelname', KapitelListeGrid.Cells[3, I]);
        IF Assigned(Kapiteleintrag) THEN
        BEGIN
          IniFile.WriteInteger('Kapitel-' + IntToStr(I), 'Videoknoten', Knotennummer(Kapiteleintrag.Videoknoten));
          IniFile.WriteInteger('Kapitel-' + IntToStr(I), 'Audioknoten', Knotennummer(Kapiteleintrag.Audioknoten));
          IniFile.WriteInteger('Kapitel-' + IntToStr(I), 'Kapitelposition', Kapiteleintrag.Kapitel);
          IniFile.WriteFloat('Kapitel-' + IntToStr(I), 'Framerate', Kapiteleintrag.BilderProSek);
        END
        ELSE
          IniFile.WriteInteger('Kapitel-' + IntToStr(I), 'Kapitelposition', -1);
      END;
      FOR I := 0 TO MarkenListe.Lines.Count - 1 DO
        IniFile.WriteString('Marke-' + IntToStr(I), 'Markenzeile', '"' + MarkenListe.Lines.Strings[I] + '"');
    END;
  FINALLY
    IniFile.Free;
  END;
END;

PROCEDURE TMpegEdit.Projektmerken(Name: STRING);

VAR I : Integer;

BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    I := ArbeitsumgebungObj.letzteProjekte.Count;
    WHILE I > 0 DO
    BEGIN
      IF ArbeitsumgebungObj.letzteProjekte.Strings[I - 1] = Name THEN
        ArbeitsumgebungObj.letzteProjekte.Delete(I - 1);
      Dec(I);
    END;
    IF ArbeitsumgebungObj.letzteProjekte.Count > 9 THEN
      ArbeitsumgebungObj.letzteProjekte.Delete(0);
    ArbeitsumgebungObj.letzteProjekte.Add(Name);
  END;
END;   

PROCEDURE TMpegEdit.Verzeichnismerken(Name: STRING);

VAR I : Integer;

BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    I := ArbeitsumgebungObj.letzteVerzeichnisse.Count;
    WHILE I > 0 DO
    BEGIN
      IF ArbeitsumgebungObj.letzteVerzeichnisse.Strings[I - 1] = Name THEN
        ArbeitsumgebungObj.letzteVerzeichnisse.Delete(I - 1);
      Dec(I);
    END;
    IF ArbeitsumgebungObj.letzteVerzeichnisse.Count > 9 THEN
      ArbeitsumgebungObj.letzteVerzeichnisse.Delete(0);
    ArbeitsumgebungObj.letzteVerzeichnisse.Add(Name);
  END;
END;

{FUNCTION TMpegEdit.Projektnamebilden: STRING;

VAR HQuelldateiname,
    HQuellVerzeichnis,
    HProjektname,
    HProjektVerzeichnis,
    HVerzeichnis,
    HDateiname : STRING;

BEGIN
  IF Assigned(SchnittListe) AND
     (SchnittListe.Count > 0) AND
     Assigned(SchnittListe.Items.Objects[0]) THEN          // mindestens ein Schnitt in der Liste vorhanden
    HQuelldateiname := DateinameausKnoten(TSchnittpunkt(SchnittListe.Items.Objects[0]).Videoknoten, TSchnittpunkt(SchnittListe.Items.Objects[0]).Audioknoten)
  ELSE                                                     // Dateiname mit Verzeichnis der ersten Video- oder Audiodatei
    HQuelldateiname := ExtractFilePath(Application.ExeName) + 'Project1'; // keine Datei vorhanden
  HQuellVerzeichnis := ExtractFilePath(HQuelldateiname);   // Verzeichnis der ersten Video- oder Audiodatei
  HQuelldateiname := ExtractFilename(ChangeFileExt(HQuelldateiname, '')); // Dateiname der ersten Video- oder Audiodatei
  IF Projektname = '' THEN
  BEGIN
    HProjektname := HQuelldateiname;                       // ist kein Projektname vorhanden wird der Quelldateiname genommen
    HProjektVerzeichnis := ExtractFilePath(Application.ExeName);
  END
  ELSE
  BEGIN
    HProjektname := ExtractFilename(ChangeFileExt(Projektname, '')); // Projektname
    HProjektVerzeichnis := ExtractFilePath(Projektname);             // Verzeichnis in dem das Projekt gespeichert ist
  END;
  HVerzeichnis := VariablenersetzenText(ArbeitsumgebungObj.ProjektVerzeichnis, ['$VideoDirectory#', HQuellVerzeichnis, '$ProjectDirectory#', HProjektVerzeichnis,
                                                                                '$VideoName#', HQuelldateiname, '$ProjectName#', HProjektname]);
  HVerzeichnis := VariablenentfernenText(HVerzeichnis);
  IF HVerzeichnis = '\' THEN
    HVerzeichnis := HProjektVerzeichnis;
  HDateiname := VariablenersetzenText(ArbeitsumgebungObj.ProjektDateiname, ['$VideoName#', HQuelldateiname, '$ProjectName#', HProjektname]);
  HDateiname := VariablenentfernenText(HDateiname);
  IF HDateiname = '' THEN
    HDateiname := HProjektname;
  Result := mitPathtrennzeichen(HVerzeichnis) + HDateiname;
  Result := doppeltePathtrennzeichen(Result);
END;   }

FUNCTION TMpegEdit.Dateinamebilden(Verzeichnis, Dateiname: STRING; QuellVerzeichnisverwenden: Boolean = False; KapitelListeverwenden: Boolean = False): STRING;

VAR HQuelldateiname,
    HQuellVerzeichnis,
    HProjektname,
    HProjektVerzeichnis,
    HVerzeichnis,
    HDateiname : STRING;
    I : Integer;

BEGIN
  IF KapitelListeverwenden THEN
  BEGIN
    HQuelldateiname := ExtractFilePath(Application.ExeName) + 'Project1';  // keine Datei vorhanden
    I := 1;                                                 // ersten Kapiteleintrag mit Daten suchen
    WHILE I < KapitelListeGrid.Tag DO
    BEGIN
      IF Assigned(KapitelListeGrid.Objects[2, I]) THEN
      BEGIN
        HQuelldateiname := DateinameausKnoten(TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Videoknoten, TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Audioknoten);
        I := KapitelListeGrid.Tag;
      END;
      Inc(I);
    END;
  END
  ELSE
    IF Assigned(SchnittListe) AND
       (SchnittListe.Count > 0) AND
       Assigned(SchnittListe.Items.Objects[0]) THEN          // mindestens ein Schnitt in der SchnittListe vorhanden
      HQuelldateiname := DateinameausKnoten(TSchnittpunkt(SchnittListe.Items.Objects[0]).Videoknoten, TSchnittpunkt(SchnittListe.Items.Objects[0]).Audioknoten)
    ELSE                                                     // Dateiname mit Verzeichnis der ersten Video- oder Audiodatei
      HQuelldateiname := ExtractFilePath(Application.ExeName) + 'Project1'; // keine Datei vorhanden
  HQuellVerzeichnis := ExtractFilePath(HQuelldateiname);   // Verzeichnis der ersten Video- oder Audiodatei
  HQuelldateiname := ExtractFilename(ChangeFileExt(HQuelldateiname, '')); // Dateiname der ersten Video- oder Audiodatei
  IF Projektname = '' THEN
  BEGIN
    HProjektname := HQuelldateiname;                       // ist kein Projektname vorhanden wird der Quelldateiname genommen
    IF QuellVerzeichnisverwenden THEN
      HProjektVerzeichnis := HQuellVerzeichnis
    ELSE
      HProjektVerzeichnis := ExtractFilePath(Application.ExeName);
  END
  ELSE
  BEGIN
    HProjektname := ExtractFilename(ChangeFileExt(Projektname, '')); // Projektname
    HProjektVerzeichnis := ExtractFilePath(Projektname);             // Verzeichnis in dem das Projekt gespeichert ist
  END;
  HVerzeichnis := VariablenersetzenText(Verzeichnis, ['$VideoDirectory#', HQuellVerzeichnis, '$ProjectDirectory#', HProjektVerzeichnis,
                                                      '$VideoName#', HQuelldateiname, '$ProjectName#', HProjektname]);
  HVerzeichnis := VariablenentfernenText(HVerzeichnis);
  IF (HVerzeichnis = '\') OR (HVerzeichnis = '') THEN
    HVerzeichnis := HProjektVerzeichnis;
  HDateiname := VariablenersetzenText(Dateiname, ['$VideoName#', HQuelldateiname, '$ProjectName#', HProjektname]);
  HDateiname := VariablenentfernenText(HDateiname);
  IF HDateiname = '' THEN
    HDateiname := HProjektname;
  Result := mitPathtrennzeichen(HVerzeichnis) + HDateiname;
  Result := doppeltePathtrennzeichen(Result);
END;

FUNCTION TMpegEdit.Projekt_speichern(DateiName: STRING): Integer;
BEGIN
  Result := 0;
  IF DateiName <> '' THEN
  BEGIN
    IF FileExists(DateiName) THEN
      IF NOT DeleteFile(DateiName) THEN
      BEGIN
        Meldungsfenster(Meldunglesen(NIL, 'Meldung119', DateiName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                        Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//        ShowMessage(Meldunglesen(NIL, 'Meldung119', Projektname, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
        Result := -2;         // Projektdatei läßt sich nicht löschen
      END;
    IF Result = 0 THEN
    BEGIN
      ProjektinDateispeichern(DateiName, SchnittListe.Items, True);
      Projektmerken(DateiName);
      Projektname := DateiName;
      Caption := UeberFenster.VersionNr + '   ' + WortProjekt + ': ' + Projektname;
      Projektgeaendert_zuruecksetzen;
    END;
  END
  ELSE
    Result := -1;             // keine Projektname vorhanden
END;

FUNCTION TMpegEdit.Projekt_speichernneu: Integer;

VAR Dateiname : STRING;

BEGIN
  IF (Projektname = '') AND
     ArbeitsumgebungObj.Projektdateidialogunterdruecken THEN
  BEGIN
    Dateiname := Dateinamebilden(ArbeitsumgebungObj.ProjektVerzeichnis, ArbeitsumgebungObj.Projektdateiname);
    IF ExtractFileExt(Dateiname) = '' THEN
      Dateiname := Dateiname + '.m2e';
    Verzeichniserstellen(ExtractFilePath(Dateiname));
    Result := Projekt_speichern(Dateiname);
  END
  ELSE
    Result := -3;
END;

FUNCTION TMpegEdit.Projekt_speichernunter: Integer;
BEGIN
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, {ofPathMustExist, }ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog21', 'Mpeg2Schnitt Projektdatei speichern');
  Speichern.Filter := Wortlesen(NIL, 'Dialog23', 'Mpeg2Schnitt Projektdateien') + '|*.m2e';
  Speichern.DefaultExt := 'm2e';
  Speichern.FileName := Dateinamebilden(ArbeitsumgebungObj.ProjektVerzeichnis, ArbeitsumgebungObj.Projektdateiname);
  Speichern.InitialDir := ExtractFilePath(Speichern.FileName);
//  Speichern.InitialDir := Verzeichnissuchen(Speichern.InitialDir);
  Verzeichniserstellen(Speichern.InitialDir);
  Speichern.FileName := ExtractFileName(Speichern.FileName);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.ProjektVerzeichnisspeichern THEN
      ArbeitsumgebungObj.ProjektVerzeichnis := ExtractFilePath(Speichern.FileName);
    Verzeichniserstellen(ExtractFilePath(Speichern.FileName));
    Result := Projekt_speichern(Speichern.FileName);
//    IF Result > -1 THEN
//      Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Projektname, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
  END
  ELSE
    Result := -3;       // Anwender hat abgebrochen
END;

procedure TMpegEdit.ProjektspeichernClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Projekt_speichern(Projektname) < 0 THEN
    IF Projekt_speichernneu < 0 THEN
      Projekt_speichernunter
    ELSE
      Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Projektname, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True)
  ELSE
    Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Projektname, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
end;

procedure TMpegEdit.ProjektspeichernunterClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Projekt_speichernunter;
end;

procedure TMpegEdit.ProjektspeichernPlusClick(Sender: TObject);

VAR Anhalten : Boolean;
    NeuerName : STRING;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Projektname <> '' THEN
  BEGIN
    Anhalten := False;
    NeuerName := DateinamePlusEins(Projektname, ArbeitsumgebungObj.ProjektdateieneinzelnFormat);
    WHILE FileExists(NeuerName) AND NOT Anhalten DO
    BEGIN
      IF Nachrichtenfenster(Meldunglesen(NIL, 'Meldung93', NeuerName, 'Das Projekt $Text1# existiert schon.') + Chr(13) +
                            Wortlesen(NIL, 'Meldung94', 'Soll die nächtse Zahl probiert werden?.'),
                            Wortlesen(NIL, 'Frage', 'Frage'), MB_YESNO, MB_ICONQUESTION) = IDNO THEN
//      IF MessageDlg(Meldunglesen(NIL, 'Meldung93', NeuerName, 'Das Projekt $Text1# existiert schon.') + Chr(13) +
//                    Wortlesen(NIL, 'Meldung94', 'Soll die nächtse Zahl probiert werden?.'),
//                    mtConfirmation, [mbYes, mbNo], 0) = mrNo THEN
        Anhalten := True
      ELSE
        NeuerName := DateinamePlusEins(NeuerName, ArbeitsumgebungObj.ProjektdateieneinzelnFormat);
    END;
    IF Anhalten THEN
    BEGIN
      Projekt_speichernunter;
    END
    ELSE
    BEGIN
      ProjektinDateispeichern(NeuerName, SchnittListe.Items, True);
      Projektmerken(NeuerName);
      Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', NeuerName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      Projektgeaendert_zuruecksetzen;
    END;
  END
  ELSE
    Projekt_speichernunter;
end;

procedure TMpegEdit.SchnittpunkteeinzelnspeichernClick(Sender: TObject);
begin
  Schnittpunkteeinzelnspeichern.Checked := NOT Schnittpunkteeinzelnspeichern.Checked;
  Schnittpunkteeinzelnspeichern1.Checked := Schnittpunkteeinzelnspeichern.Checked;
end;

procedure TMpegEdit.MarkierteSchnittpunktespeichernClick(Sender: TObject);
begin
  MarkierteSchnittpunktespeichern.Checked := NOT MarkierteSchnittpunktespeichern.Checked;
  MarkierteSchnittpunktespeichern1.Checked := MarkierteSchnittpunktespeichern.Checked;
end;

procedure TMpegEdit.ProjektspeichernspezialClick(Sender: TObject);

VAR ProjektListe : TStringList;
    I : Integer;
    NeuerName : STRING;

begin
  IF (SchnittListe.SelCount > 0) OR (NOT MarkierteSchnittpunktespeichern.Checked) THEN
  BEGIN
    Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, {ofPathMustExist, }ofEnableSizing];
    Speichern.Title := Wortlesen(NIL, 'Dialog21', 'Mpeg2Schnitt Projektdatei speichern');
    Speichern.Filter := Wortlesen(NIL, 'Dialog23', 'Mpeg2Schnitt Projektdateien') + '|*.m2e';
    Speichern.DefaultExt := 'm2e';
    Speichern.FileName := Dateinamebilden(ArbeitsumgebungObj.ProjektVerzeichnis, ArbeitsumgebungObj.Projektdateiname);
    I := 0;
    IF ArbeitsumgebungObj.Projektdateidialogunterdruecken THEN
    BEGIN
      IF ExtractFileExt(Speichern.FileName) = '' THEN
        Speichern.FileName := Speichern.FileName + '.m2e';
    END
    ELSE
      Verzeichniserstellen(ExtractFilePath(Speichern.FileName));
      IF Speichern.Execute THEN
      BEGIN
        IF ArbeitsumgebungObj.ProjektVerzeichnisspeichern THEN
          ArbeitsumgebungObj.ProjektVerzeichnis := ExtractFilePath(Speichern.FileName);
      END
      ELSE
        I := -1;                                 // Anwender hat abgebrochen
    IF I = 0 THEN
    BEGIN
      Verzeichniserstellen(ExtractFilePath(Speichern.FileName));
      IF Schnittpunkteeinzelnspeichern.Checked THEN
      BEGIN
        ProjektListe := TStringList.Create;
        NeuerName := Speichern.FileName;
        FOR I := 0 TO SchnittListe.Items.Count - 1 DO
          IF (NOT MarkierteSchnittpunktespeichern.Checked) OR SchnittListe.Selected[I] THEN
          BEGIN
            ProjektListe.AddObject('', TSchnittpunkt(SchnittListe.Items.Objects[I]));
            IF FileExists(NeuerName) THEN
              IF DeleteFile(NeuerName) THEN
                ProjektinDateispeichern(NeuerName, ProjektListe, False)
              ELSE
                Meldungsfenster(Meldunglesen(NIL, 'Meldung119', NeuerName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                                Wortlesen(NIL, 'Hinweis', 'Hinweis'))
//                ShowMessage(Meldunglesen(NIL, 'Meldung119', NeuerName, 'Die Datei $Text1# konnte nicht überschrieben werden.'))
            ELSE
              ProjektinDateispeichern(NeuerName, ProjektListe, False);
            ProjektListe.Clear;
            NeuerName := DateinamePlusEins(NeuerName, ArbeitsumgebungObj.ProjektdateieneinzelnFormat);
          END;
//        Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName + '...', 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
        ProjektListe.Free;
      END
      ELSE
      BEGIN
        ProjektListe := TStringList.Create;
        FOR I := 0 TO SchnittListe.Items.Count - 1 DO
          IF (NOT MarkierteSchnittpunktespeichern.Checked) OR SchnittListe.Selected[I] THEN
          BEGIN
            ProjektListe.AddObject('', TSchnittpunkt(SchnittListe.Items.Objects[I]));
          END;
        IF FileExists(Speichern.FileName) THEN
          IF DeleteFile(Speichern.FileName) THEN
          BEGIN
            ProjektinDateispeichern(Speichern.FileName, ProjektListe, False);
            Projektmerken(Speichern.FileName);
          END
          ELSE
            Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                            Wortlesen(NIL, 'Hinweis', 'Hinweis'))
//            ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'))
        ELSE
        BEGIN
          ProjektinDateispeichern(Speichern.FileName, ProjektListe, False);
          Projektmerken(Speichern.FileName);
        END;
//        Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
        ProjektListe.Free;
      END;
    END;
  END
  ELSE
    Meldungsfenster(Wortlesen(NIL, 'Meldung42', 'Es sind keine Einträge in der Schnittliste markiert.'),
                    Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//    ShowMessage(Wortlesen(NIL, 'Meldung42', 'Es sind keine Einträge in der Schnittliste markiert.'));
end;

procedure TMpegEdit.MarkierungaufhebenClick(Sender: TObject);
begin
  SchnittListe.ClearSelection;
  SchnittListe.ItemIndex := -1;
end;

FUNCTION TMpegEdit.Knotenadresse(Knotenindex: Integer): TTreeNode;

VAR K, I : Integer;
    Knoten : TTreeNode;

BEGIN
  Result := NIL;
  IF Knotenindex > 0 THEN
    IF Knotenindex < 1000 THEN
    BEGIN
      K := 0;
      I := 0;
      WHILE I < Dateien.Items.Count DO
      BEGIN
        IF Dateien.Items[I].Level = 0 THEN
        BEGIN
          Inc(K);
          IF K = Knotenindex THEN
            Result := Dateien.Items[I];
        END;
        Inc(I);
      END
    END
    ELSE
    BEGIN
      Knoten := Knotenadresse(Knotenindex DIV 1000);
      IF Assigned(Knoten) THEN
      BEGIN
        K := Knotenindex MOD 1000;
        IF K < Knoten.Count THEN
          Result := Knoten.Item[K];
      END;
    END;
END;

FUNCTION TMpegEdit.GleichenKnotensuchen(Knoten: TTreeNode): TTreeNode;

VAR I, J : Integer;

BEGIN
  Result := NIL;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    I := 0;
    WHILE (I < Dateien.Items.Count) AND (NOT Assigned(Result)) DO        // durchläuft alle Knoten
    BEGIN
      IF (Dateien.Items[I] <> Knoten) AND                                // den übergebenen Knoten ausschließen
         (Dateien.Items[I].Level = 0) AND                                // nur Knoten der ersten Ebene betrachten
         (Dateien.Items[I].Count = Knoten.Count) THEN                    // Knoten müssen die gleichen Anzahl Unterknoten haben
      BEGIN
        J := 0;
        WHILE J < Dateien.Items[I].Count DO                              // durchläuft alle Unterknoten
        BEGIN
          IF Assigned(Dateien.Items[I].Item[J].Data) AND Assigned(Knoten.Item[J].Data) THEN
          BEGIN                                                          // beide Knoten haben Daten
            IF J = 0 THEN
            BEGIN                                                        // Videoknoten
              IF TDateiEintrag(Dateien.Items[I].Item[J].Data).Name <> TDateiEintrag(Knoten.Item[J].Data).Name THEN
                J := Dateien.Items[I].Count;                             // Videodateinamen sind ungleich
            END
            ELSE
            BEGIN
              IF TDateiEintragAudio(Dateien.Items[I].Item[J].Data).Name <> TDateiEintragAudio(Knoten.Item[J].Data).Name THEN
                J := Dateien.Items[I].Count                              // Audiodateinamen sind ungleich
              ELSE
                IF TDateiEintragAudio(Dateien.Items[I].Item[J].Data).Audiooffset <> TDateiEintragAudio(Knoten.Item[J].Data).Audiooffset THEN
                  J := Dateien.Items[I].Count;                           // Audiooffset ist nicht gleich
            END;
          END
          ELSE
            IF Assigned(Dateien.Items[I].Item[J].Data) OR Assigned(Knoten.Item[J].Data) THEN
              J := Dateien.Items[I].Count;                               // nur ein Knoten hat Daten
          Inc(J);
        END;
        IF J = Dateien.Items[I].Count THEN
        BEGIN                                                            // gleichen Knoten gefunden
          Result := Dateien.Items[I];                                    // gefundenen Knoten zurückgeben
          KnotenpunktDatenloeschen(Knoten);                              // übergebenen Knoten löschen
          IF Knoten = VorschauKnoten THEN
            VorschauKnoten := NIL;
          Dateien.Items.Delete(Knoten);
        END;
      END;
      Inc(I);
    END;
    IF NOT Assigned(Result) THEN
      Result := Knoten;                                                  // keinen gleichen Knoten gefunden
  END;
END;

PROCEDURE TMpegEdit.SchnittpunktBildereinfuegen(Schnittpunkt: TSchnittpunkt; VAR HVideoname: STRING; HListe, HIndexliste: TListe);

VAR BMP : TBitmap;
    MpegHeader : TMpeg2Header;

BEGIN
  IF Assigned(Schnittpunkt) AND Assigned(Schnittpunkt.Videoknoten) AND Schnittpunkt.Videoknoten.HasChildren AND Assigned(Schnittpunkt.Videoknoten.Item[0].Data) THEN
  BEGIN
    IF aktVideoknoten.Parent = Schnittpunkt.Videoknoten THEN
      BMP := BMPBildlesen(Schnittpunkt.Anfang, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False)
    ELSE
    BEGIN
      IF NOT (HVideoname = TDateieintrag(Schnittpunkt.Videoknoten.Item[0].Data).Name) THEN
      BEGIN
        HVideoname := TDateieintrag(Schnittpunkt.Videoknoten.Item[0].Data).Name;
        Fortschrittsfensteranzeigen;                       // Fortschrittsfenster anzeigen
        MpegHeader := TMpeg2Header.Create;                 // notwendige Objekte erzeugen
        TRY
          MpegHeader.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
          MpegHeader.Textanzeige := Fortschrittsfenster.Textanzeige;
          MpegHeader.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
          MpegHeader.SequenzEndeIgnorieren := ArbeitsumgebungObj.SequenzEndeignorieren;
          IF MpegHeader.Dateioeffnen(HVideoname) THEN
            MpegHeader.Listeerzeugen(HListe, HIndexListe); // Liste einlesen
        FINALLY
          MpegHeader.Free;
        END;
        Fortschrittsfensterverbergen;                      // Fortschrittsfenster verbergen
      END;
      BMP := BMPBildlesen1(HVideoname, HListe, HIndexListe,
                           Schnittpunkt.Anfang, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False);
    END;
    IF Assigned(BMP) THEN
    BEGIN
      TRY
        Schnittpunkt.AnfangsBild.Assign(BMP);
      FINALLY
        BMP.Free;
      END;
    END;
    IF aktVideoknoten.Parent = Schnittpunkt.Videoknoten THEN
      BMP := BMPBildlesen(Schnittpunkt.Ende, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False)
    ELSE
      BMP := BMPBildlesen1(HVideoname, HListe, HIndexListe,
                           Schnittpunkt.Ende, ArbeitsumgebungObj.SchnittpunktBildbreite, True, False);
    IF Assigned(BMP) THEN
    BEGIN
      TRY
        Schnittpunkt.EndeBild.Assign(BMP);
      FINALLY
        BMP.Free;
      END;
    END;
  END;
END;

FUNCTION TMpegEdit.Projektdateieinfuegen(Name: STRING; aktDateien_anzeigen, Projekt_einfuegen: Boolean): Integer;

VAR IniFile : TIniFile;
    I, J,
    IniVersion,
    ListenIndex,
    Kapitel,
    aktVideoIndex,
    aktAudioIndex,
//    aktPosition,
    Audiooffset : Integer;
    aktEintrag : STRING;
    Schnittpunkt : TSchnittpunkt;
    Knotenpunkt,
    Videoknoten,
    Audioknoten : TTreeNode;
    Knotenliste : TList;
    HListe,
    HIndexliste : TListe;
    HString,
    VerzeichnisAlt,
    VerzeichnisNeu,
    HVideoname : STRING;
    SchleifenEnde1,
    SchleifenEnde2,
    Schnittselektiert : Boolean;

FUNCTION ListeneintragVideo_suchen(Liste: TList; Videoname : STRING): TTreeNode;

VAR I : Integer;
    Knoten : TTreeNode;

BEGIN
  I := 0;
  Result := NIL;
  IF Assigned(Liste) THEN
  BEGIN
    WHILE (I < Liste.Count) AND (NOT Assigned(Result)) DO
    BEGIN
      IF Assigned(Liste[I]) THEN
      BEGIN
        Knoten := TTreeNode(Liste[I]);
        IF Knoten.HasChildren THEN
          IF Assigned(Knoten.Item[0].Data) THEN
            IF TDateieintrag(Knoten.Item[0].Data).Name = Videoname THEN
              Result := Knoten;
      END;
      Inc(I);
    END;
  END;
END;

FUNCTION ListeneintragAudio_suchen(Liste: TList; Audioname : STRING): TTreeNode;

VAR I, J : Integer;
    Knoten : TTreeNode;

BEGIN
  I := 0;
  Result := NIL;
  IF Assigned(Liste) THEN
  BEGIN
    WHILE (I < Liste.Count) AND (NOT Assigned(Result)) DO
    BEGIN
      IF Assigned(Liste[I]) THEN
      BEGIN
        Knoten := TTreeNode(Liste[I]);
        J := 1;
        WHILE (J < Knoten.Count) AND (NOT Assigned(Result)) DO
        BEGIN
          IF Assigned(Knoten.Item[J].Data) THEN
            IF TDateieintragAudio(Knoten.Item[J].Data).Name = Audioname THEN
              Result := Knoten;
          Inc(J);
        END;
      END;
      Inc(I);
    END;
  END;
END;

FUNCTION Dateiexistiertnicht(Dateiname, Filter: STRING): STRING;
BEGIN
  IF (VerzeichnisNeu <> '') AND                                    // gemerktes Verzeichnis vorhanden
     (VerzeichnisAlt = ExtractFilePath(Dateiname)) AND             // altes gemerktes Verzeichnis entspricht dem Dateiverzeichnis
     FileExists(VerzeichnisNeu + ExtractFileName(Dateiname)) THEN  // Datei existiert im neuen Verzeichnis
    Result := VerzeichnisNeu + ExtractFileName(Dateiname)
  ELSE
    IF Nachrichtenfenster(Meldunglesen(NIL, 'Meldung112', HString, 'Die Datei $Text1# existiert nicht.') + Chr(13) +
                          Wortlesen(NIL, 'Meldung136', 'Soll die Datei gesucht werden?'),
                          Wortlesen(NIL, 'Frage', 'Hinweis'),
                          MB_YESNO, MB_ICONQUESTION) = IDYES THEN
    BEGIN
      Oeffnen.FileName := ExtractFileName(Dateiname);
      Oeffnen.InitialDir := Verzeichnissuchen(ExtractFilePath(Dateiname));
      Oeffnen.Filter := Filter;
      IF Oeffnen.Execute THEN
      BEGIN
        Result := Oeffnen.FileName;
        VerzeichnisAlt := ExtractFilePath(Dateiname);
        VerzeichnisNeu := ExtractFilePath(Result);
        Projektgeaendert_setzen(0);
      END
      ELSE
        Result := '';
    END
    ELSE
      Result := '';
END;

BEGIN
  // Projektdateiversion 3 wurde mit der Programmversion 0.6m im September 2004 eingeführt
  Result := 0;
  IF FileExists(Name) AND (UpperCase(ExtractFileExt(Name)) = '.M2E') THEN
  BEGIN
    IniFile := TIniFile.Create(Name);
    Knotenliste := TList.Create;
    TRY
      Knotenliste.Add(NIL);
      VerzeichnisNeu := '';
      IniVersion := IniFile.ReadInteger('Allgemein', 'Version', 0);
      IF IniVersion > 1 THEN                               // Dateienliste ist vorhanden
      BEGIN
        IF IniVersion < 3 THEN                             // ab V 3 neue Projektstruktur
        BEGIN
          aktEintrag := IniFile.ReadString('Dateiliste', 'aktEintrag', '');
          aktVideoIndex := 0;
          aktAudioIndex := 0;
        END
        ELSE
        BEGIN
          aktEintrag := '';
          aktVideoIndex := IniFile.ReadInteger('Allgemein', 'aktVideoknoten', 0);
          aktAudioIndex := IniFile.ReadInteger('Allgemein', 'aktAudioknoten', 0);
//          aktPosition := IniFile.ReadInteger('Allgemein', 'aktSchiebereglerPosition', 50);
        END;
        I := 1;
        TRY
          REPEAT                                             // Dateienliste auslesen
            SchleifenEnde1 := True;
            Knotenpunkt := NIL;
            IF IniVersion < 3 THEN                           // ab V 3 neue Projektstruktur
              HString := IniFile.ReadString('Dateiliste-' + IntToStr(I - 1), 'Video', 'letzter')
            ELSE
              HString := IniFile.ReadString('Dateiknoten-' + IntToStr(I), 'Videodatei', 'letzter');
            IF (HString <> 'letzter') AND (HString <> '') THEN // Videodatei vorhanden
            BEGIN
              SchleifenEnde1 := False;
              IF FileExists(HString) THEN                    // Videodatei existiert
                Knotenpunkt := DateienlisteEintrageinfuegenVideo(NIL, HString)
              ELSE
              BEGIN
                HString := Dateiexistiertnicht(HString, Wortlesen(NIL, 'Dialog12', 'MPEG-2 Videodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo);
                IF HString <> '' THEN
                  Knotenpunkt := DateienlisteEintrageinfuegenVideo(NIL, HString)
                ELSE
                  Meldungsfenster({Meldunglesen(NIL, 'Meldung112', HString, 'Die Datei $Text1# existiert nicht.') + Chr(13) +}
                                Wortlesen(NIL, 'Meldung4', 'Die entsprechende Datei wird aus der Dateienliste entfernt.'),
                                Wortlesen(NIL, 'Hinweis', 'Hinweis'));
  //              ShowMessage(Meldunglesen(NIL, 'Meldung112', HString, 'Die Datei $Text1# existiert nicht.') + Chr(13) +
  //                          Wortlesen(NIL, 'Meldung4', 'Die entsprechende Datei wird aus der Dateienliste entfernt.'));
              END;
              IF Assigned(Knotenpunkt) THEN
                IF IniVersion < 3 THEN                       // ab V 3 neue Projektstruktur
                BEGIN
                  IF (aktEintrag = HString) AND aktDateien_anzeigen THEN
                    aktVideoIndex := I * 1000;
                  IF Knotenpunkt.Level > 0 THEN
                    Knotenpunkt := Knotenpunkt.Parent;
                END
                ELSE
                BEGIN
                  HString := IniFile.ReadString('Dateiknoten-' + IntToStr(I), 'Videoname', WortVideo + ' -> ' + HString);
                  IF HString <> '' THEN
                    IF Pos(VerzeichnisAlt, HString) > 0 THEN
                      Knotenpunkt.Text := Copy(HString, 1, Pos(VerzeichnisAlt, HString) - 1) +
                                          VerzeichnisNeu +
                                          Copy(HString, Pos(VerzeichnisAlt, HString) + Length(VerzeichnisAlt), Length(HString))
                    ELSE
                      Knotenpunkt.Text := HString;
                  IF Knotenpunkt.Level > 0 THEN
                    Knotenpunkt := Knotenpunkt.Parent;
                END;
            END;
            J := 1;
            REPEAT
              SchleifenEnde2 := True;
              IF IniVersion < 3 THEN                         // ab V 3 neue Projektstruktur
              BEGIN
                HString := IniFile.ReadString('Dateiliste-' + IntToStr(I - 1), 'Audio-' + IntToStr(J - 1), 'letzter');
                Audiooffset := IniFile.ReadInteger('Dateiliste-' + IntToStr(I - 1), 'Audiooffset-' + IntToStr(J - 1), 0);
              END
              ELSE
              BEGIN
                HString := IniFile.ReadString('Dateiknoten-' + IntToStr(I), 'Audiodatei-' + IntToStr(J), 'letzter');
                Audiooffset := IniFile.ReadInteger('Dateiknoten-' + IntToStr(I), 'Audiooffset-' + IntToStr(J), 0);
              END;
              IF HString <> 'letzter' THEN
              BEGIN
                SchleifenEnde1 := False;
                SchleifenEnde2 := False;
                IF FileExists(HString) THEN                  // Audiodatei existiert oder Knoten ist leer
                  Knotenpunkt := DateienlisteEintrageinfuegenAudio(Knotenpunkt, HString, Audiooffset, J)
                ELSE
                  IF HString <> '' THEN
                  BEGIN
                    HString := Dateiexistiertnicht(HString, Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio);
                    IF HString <> '' THEN
                      Knotenpunkt := DateienlisteEintrageinfuegenAudio(Knotenpunkt, HString, Audiooffset, J)
                    ELSE
                      Meldungsfenster({Meldunglesen(NIL, 'Meldung112', HString, 'Die Datei $Text1# existiert nicht.') + Chr(13) +}
                                    Wortlesen(NIL, 'Meldung4', 'Die entsprechende Datei wird aus der Dateienliste entfernt.'),
                                    Wortlesen(NIL, 'Hinweis', 'Hinweis'));
  //                  ShowMessage(Meldunglesen(NIL, 'Meldung112', HString, 'Die Datei $Text1# existiert nicht.') + Chr(13) +
  //                              Wortlesen(NIL, 'Meldung4', 'Die entsprechende Datei wird aus der Dateienliste entfernt.'));
                  END;
                IF Assigned(Knotenpunkt) THEN
                  IF IniVersion < 3 THEN                     // ab V 3 neue Projektstruktur
                  BEGIN
                    IF (ChangeFileExt(aktEintrag, ArbeitsumgebungObj.StandardEndungenAudio) = HString) AND aktDateien_anzeigen THEN
                      aktAudioIndex := I * 1000 + Knotenpunkt.Parent.IndexOf(Knotenpunkt);
                    IF Knotenpunkt.Level > 0 THEN
                      Knotenpunkt := Knotenpunkt.Parent;
                  END
                  ELSE
                  BEGIN
                    HString := IniFile.ReadString('Dateiknoten-' + IntToStr(I), 'Audioname-' + IntToStr(J), '');
                    IF HString <> '' THEN
                      IF Pos(VerzeichnisAlt, HString) > 0 THEN
                        Knotenpunkt.Text := Copy(HString, 1, Pos(VerzeichnisAlt, HString) - 1) +
                                            VerzeichnisNeu +
                                            Copy(HString, Pos(VerzeichnisAlt, HString) + Length(VerzeichnisAlt), Length(HString))
                      ELSE
                        Knotenpunkt.Text := HString;
                    IF Knotenpunkt.Level > 0 THEN
                      Knotenpunkt := Knotenpunkt.Parent;
                  END;
              END;
              Inc(J);
            UNTIL SchleifenEnde2;
            IF Assigned(Knotenpunkt) THEN
            BEGIN
              HString := IniFile.ReadString('Dateiknoten-' + IntToStr(I), 'Knotenname', 'letzter');
              IF HString <> 'letzter' THEN
                Knotenpunkt.Text := HString;
              IF Projekt_einfuegen THEN
                Knotenpunkt := GleichenKnotensuchen(Knotenpunkt);
              IF (I * 1000 = aktVideoIndex) AND
                 Knotenpunkt.HasChildren THEN
              BEGIN
                IF aktDateien_anzeigen THEN
                BEGIN
//                  Fortschrittsfensteranzeigen;
                  DateilisteaktualisierenVideo(Knotenpunkt.Item[0], False)
//                  Schnittpunktanzeigekorrigieren;
                END;
//                Dateien.Selected := Knotenpunkt;
              END;
              IF (I = aktAudioIndex DIV 1000) AND
                 aktDateien_anzeigen AND
                 (aktAudioIndex Mod 1000 < Knotenpunkt.Count) THEN
              BEGIN
//                Fortschrittsfensteranzeigen;
                DateilisteaktualisierenAudio(Knotenpunkt.Item[aktAudioIndex Mod 1000], False);
//                Schnittpunktanzeigekorrigieren;
              END;
//              IF aktDateien_anzeigen THEN
//                SchiebereglerPosition_setzen(aktPosition);
            END;
            Knotenliste.Add(Knotenpunkt);
            Inc(I);
          UNTIL SchleifenEnde1;
        FINALLY
          Fortschrittsfensterverbergen;
        END;
        DateienlisteHauptknotenNrneuschreiben;
        HListe := TListe.Create;
        HIndexliste := TListe.Create;
        TRY
          HVideoname := '';
          I := 0;
          REPEAT
            SchleifenEnde1 := True;
            Videoknoten := NIL;
            Audioknoten := NIL;
            IF IniVersion < 3 THEN                           // ab V 3 neue Projektstruktur
            BEGIN
              HString := IniFile.ReadString('Schnittpunkt' + IntToStr(I), 'Video', 'letzter');
              IF HString <> 'letzter' THEN
              BEGIN
                IF HString = '' THEN
                BEGIN
                  HString := IniFile.ReadString('Schnittpunkt' + IntToStr(I), 'Audio', '');
                  IF HString <> '' THEN
                    Videoknoten := ListeneintragAudio_suchen(Knotenliste, HString)
                  ELSE
                    Videoknoten := NIL;
                END
                ELSE
                  Videoknoten := ListeneintragVideo_suchen(Knotenliste, HString);
                IF Assigned(Videoknoten) THEN
                  IF Videoknoten.Level > 0 THEN
                    Videoknoten := Videoknoten.Parent;
                Audioknoten := Videoknoten;
                SchleifenEnde1 := False;
              END;
            END
            ELSE
            BEGIN
              HString := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'Schnittpunktname', 'letzter');
              IF HString <> 'letzter' THEN
              BEGIN
                J := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Videoknoten', 0);
                IF J < Knotenliste.Count THEN
                  Videoknoten := Knotenliste.Items[J]
                ELSE
                  Videoknoten := NIL;
                J := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Audioknoten', 0);
                IF J < Knotenliste.Count THEN
                  Audioknoten := Knotenliste.Items[J]
                ELSE
                  Audioknoten := NIL;
                SchleifenEnde1 := False;
              END;
            END;
            IF Assigned(Videoknoten) OR Assigned(Audioknoten)  THEN
            BEGIN
              Schnittpunkt := TSchnittpunkt.Create;
              Schnittpunkt.Videoknoten := Videoknoten;
              Schnittpunkt.Audioknoten := Audioknoten;
              IF IniVersion < 3 THEN
              BEGIN
                Schnittpunkt.Anfang := IniFile.ReadInteger('Schnittpunkt' + IntToStr(I), 'Anfang', 0);;
                Schnittpunkt.Ende := IniFile.ReadInteger('Schnittpunkt' + IntToStr(I), 'Ende', 0);;
                Schnittpunkt.Anfangberechnen := IniFile.ReadInteger('Schnittpunkt' + IntToStr(I), 'Anfangberechnen', 0);
                Schnittpunkt.Endeberechnen := IniFile.ReadInteger('Schnittpunkt' + IntToStr(I), 'Endeberechnen', 0);
                Schnittpunkt.VideoGroesse := StrToInt64Def(IniFile.ReadString('Schnittpunkt' + IntToStr(I), 'VideoGroesse', '0'), 0);
                Schnittpunkt.AudioGroesse := StrToInt64Def(IniFile.ReadString('Schnittpunkt' + IntToStr(I), 'AudioGroesse', '0'), 0);
                Schnittpunkt.Framerate := IniFile.ReadFloat('Schnittpunkt' + IntToStr(I), 'Framerate', 25);;
              END
              ELSE
              BEGIN
                Schnittpunkt.Anfang := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Anfang', 0);;
                Schnittpunkt.Ende := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Ende', 0);;
                Schnittpunkt.Anfangberechnen := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Anfangberechnen', 0);
                Schnittpunkt.Endeberechnen := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Endeberechnen', 0);
                Schnittpunkt.VideoGroesse := StrToInt64Def(IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoGroesse', '0'), 0);
                Schnittpunkt.AudioGroesse := StrToInt64Def(IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioGroesse', '0'), 0);
                Schnittpunkt.Framerate := IniFile.ReadFloat('Schnittpunkt-' + IntToStr(I), 'Framerate', 25);
  //              Schnittpunkt.AudioEffekt.AnfangEffektPosition := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'AnfangEffekt', 0);
  //              Schnittpunkt.AudioEffekt.AnfangLaenge := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'AnfangLaenge', 0);
  //              Schnittpunkt.AudioEffekt.AnfangEffektParameter := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AnfangParameter', '');
  //              Schnittpunkt.AudioEffekt.EndeEffektPosition := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'EndeEffekt', 0);
  //              Schnittpunkt.AudioEffekt.EndeLaenge := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'EndeLaenge', 0);
  //              Schnittpunkt.AudioEffekt.EndeEffektParameter := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'EndeParameter', '');
              END;
              IF IniVersion > 3 THEN        // ab Version 0.9 neuer Effektaufbau
              BEGIN
                Schnittpunkt.VideoEffekt.AnfangEffektName := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangEffekt', '');
                Schnittpunkt.VideoEffekt.AnfangEffektDateiname := absolutPathAppl(IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangEffektdatei', ''), Application.ExeName, False);
                Schnittpunkt.VideoEffekt.AnfangLaenge := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'VideoAnfangLaenge', 0);
                Schnittpunkt.VideoEffekt.AnfangEffektParameter := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangParameter', '');
                Schnittpunkt.VideoEffekt.EndeEffektName := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoEndeEffekt', '');
                Schnittpunkt.VideoEffekt.EndeEffektDateiname := absolutPathAppl(IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoEndeEffektdatei', ''), Application.ExeName, False);
                Schnittpunkt.VideoEffekt.EndeLaenge := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'VideoEndeLaenge', 0);
                Schnittpunkt.VideoEffekt.EndeEffektParameter := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoEndeParameter', '');
                Schnittpunkt.AudioEffekt.AnfangEffektName := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangEffekt', '');
                Schnittpunkt.AudioEffekt.AnfangEffektDateiname := absolutPathAppl(IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangEffektdatei', ''), Application.ExeName, False);
                Schnittpunkt.AudioEffekt.AnfangLaenge := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'AudioAnfangLaenge', 0);
                Schnittpunkt.AudioEffekt.AnfangEffektParameter := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangParameter', '');
                Schnittpunkt.AudioEffekt.EndeEffektName := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioEndeEffekt', '');
                Schnittpunkt.AudioEffekt.EndeEffektDateiname := absolutPathAppl(IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioEndeEffektdatei', ''), Application.ExeName, False);
                Schnittpunkt.AudioEffekt.EndeLaenge := IniFile.ReadInteger('Schnittpunkt-' + IntToStr(I), 'AudioEndeLaenge', 0);
                Schnittpunkt.AudioEffekt.EndeEffektParameter := IniFile.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioEndeParameter', '');
              END;
              ListenIndex := Schnitteinfuegen(Schnittpunkt, '', ArbeitsumgebungObj.Schnittpunkteinfuegen);
              IF ArbeitsumgebungObj.SchnittpunktAnfangbild OR ArbeitsumgebungObj.SchnittpunktEndebild THEN
                SchnittpunktBildereinfuegen(Schnittpunkt, HVideoname, HListe, HIndexliste);
              Schnittpunktanzeige_berechnen(ListenIndex, ListenIndex);
              IF HString <> 'letzter' THEN
              BEGIN
                Schnittselektiert := SchnittListe.Selected[ListenIndex];
                SchnittListe.Items.Strings[ListenIndex] := SchnittpunktFormatberechnen(Schnittpunkt.Anfang, Schnittpunkt.Ende, Schnittpunkt.Framerate);
                SchnittListe.Selected[ListenIndex] := Schnittselektiert;  // wird sonst auf False gesetzt
              END;
            END
            ELSE
              IF HString <> 'letzter' THEN
                Protokoll_schreiben(Meldunglesen(NIL, 'Meldung133', HString, 'Der Dateilisteneintrag $Text1# existiert nicht.') + Chr(13) +
                                    Wortlesen(NIL, 'Meldung47', 'Der Schnitt wird aus der Schnittliste entfernt.'));
            Inc(I);
          UNTIL SchleifenEnde1;
        FINALLY
          HListe.Free;
          HIndexliste.Free;
        END;
        ListenIndex := KapitelListeGrid.Selection.Top;
        I := 1;
        REPEAT
          SchleifenEnde1 := True;
          HString := IniFile.ReadString('Kapitel-' + IntToStr(I), 'Kapitelname', 'letzter');
          IF HString <> 'letzter' THEN
          BEGIN
            J := IniFile.ReadInteger('Kapitel-' + IntToStr(I), 'Videoknoten', 0);
            IF J < Knotenliste.Count THEN
              Videoknoten := Knotenliste.Items[J]
            ELSE
              Videoknoten := NIL;
            J := IniFile.ReadInteger('Kapitel-' + IntToStr(I), 'Audioknoten', 0);
            IF J < Knotenliste.Count THEN
              Audioknoten := Knotenliste.Items[J]
            ELSE
              Audioknoten := NIL;
            Kapitel := IniFile.ReadInteger('Kapitel-' + IntToStr(I), 'Kapitelposition', -1);
            SchleifenEnde1 := False;
            IF Kapitel > -1 THEN
              IF Assigned(Videoknoten) OR Assigned(Audioknoten) THEN
              BEGIN
                IF KapitelListeZeileeinfuegen1(Kapitel, ListenIndex, IniFile.ReadFloat('Kapitel-' + IntToStr(I), 'Framerate', 25), VideoKnoten, AudioKnoten, HString) = 0 THEN
                  Inc(ListenIndex);
              END
              ELSE
              BEGIN
                IF HString <> 'letzter' THEN
                  Protokoll_schreiben(Meldunglesen(NIL, 'Meldung133', HString, 'Der Dateilisteneintrag $Text1# existiert nicht.') + Chr(13) +
                                      Wortlesen(NIL, 'Meldung48', 'Das Kapitel wird aus der Kapitelliste entfernt.'));
              END
            ELSE
              IF KapitelListeTrennzeileeinfuegen(ListenIndex, HString) = 0 THEN
                Inc(ListenIndex);
          END;
          Inc(I);
        UNTIL SchleifenEnde1;
        KapitelListeMarkierungPlus(ListenIndex - KapitelListeGrid.Selection.Top);
        ListenIndex := TextfenstermarkierteZeile(MarkenListe);
        I := 0;
        REPEAT
          SchleifenEnde1 := True;
          HString := IniFile.ReadString('Marke-' + IntToStr(I), 'Markenzeile', 'letzter');
          IF HString <> 'letzter' THEN
          BEGIN
            MarkenListe.Lines.Insert(ListenIndex, HString);
            Inc(ListenIndex);
            SchleifenEnde1 := False;
          END;
          Inc(I);
        UNTIL SchleifenEnde1;
      END;
    FINALLY
      IniFile.Free;
      Knotenliste.Free;
    END;
    Schneiden.Enabled := Schneidenmoeglich;
    Vorschau.Enabled := Vorschaumoeglich;
    Dateigroesse;
    Schnittliste.ItemIndex := -1;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.Projekteinfuegen_anzeigen(Name: STRING; aktDateien_anzeigen: Boolean): Integer;
BEGIN
  IF Projektname = '' THEN
  BEGIN
    Projektgeaendert_zuruecksetzen;
    Result := Projektdateieinfuegen(Name, ((ArbeitsumgebungObj.letztesVideoanzeigen AND (NOT letztesVideoanzeigenCLaktiv)) OR
                                           (letztesVideoanzeigenCL AND letztesVideoanzeigenCLaktiv)) AND
                                            aktDateien_anzeigen, False);
    IF Result > -1 THEN
    BEGIN
      Projektname := Name;
      Caption := UeberFenster.VersionNr + '   ' + WortProjekt + ': ' + Projektname;
    END;
  END
  ELSE
  BEGIN
    Result := Projektdateieinfuegen(Name, False, True);
    IF Result > -1 THEN
      Projektgeaendert_setzen(0);
  END;
  Projektmerken(Name);
END;

procedure TMpegEdit.ProjektEinfuegenClick(Sender: TObject);
begin
  Oeffnen.Title := Wortlesen(NIL, 'Dialog24', 'Mpeg2Schnitt Projektdatei einfügen');
  Oeffnen.Filter := Wortlesen(NIL, 'Dialog23', 'Mpeg2Schnitt Projektdateien') + '|*.m2e';
  Oeffnen.DefaultExt := 'm2e';
  Oeffnen.FileName := '';
  Oeffnen.InitialDir := ExtractFilePath(Dateinamebilden(ArbeitsumgebungObj.ProjektVerzeichnis, ArbeitsumgebungObj.Projektdateiname));
  Oeffnen.InitialDir := Verzeichnissuchen(Oeffnen.InitialDir);
//  Oeffnen.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.ProjektVerzeichnis);
  IF Oeffnen.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.ProjektVerzeichnisspeichern THEN
      ArbeitsumgebungObj.ProjektVerzeichnis := ExtractFilePath(Oeffnen.FileName);
    Projekteinfuegen_anzeigen(Oeffnen.FileName, False);
  END;
end;

procedure TMpegEdit.ProjektLadenClick(Sender: TObject);

VAR Erg : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Erg := IDNO;
  IF Projekt_geaendertX THEN
    Erg := Nachrichtenfenster(Wortlesen(NIL, 'Meldung92', 'Soll das Projekt gespeichert werden?'),
                              Wortlesen(NIL, 'Frage', 'Frage'), MB_YESNOCANCEL, MB_ICONQUESTION);
//    Erg := Application.MessageBox(PChar(Wortlesen(NIL, 'Meldung92', 'Soll das Projekt gespeichert werden?')),
//                              PChar( Wortlesen(NIL, 'Frage', 'Frage')), MB_YESNOCANCEL);
  IF Erg <> IDCANCEL THEN
  BEGIN
    IF Erg = IDYES THEN
      Projektspeichern.Click;
    Oeffnen.Title := Wortlesen(NIL, 'Dialog22', 'Mpeg2Schnitt Projektdatei öffnen');
    Oeffnen.Filter := Wortlesen(NIL, 'Dialog23', 'Mpeg2Schnitt Projektdateien') + '|*.m2e';
    Oeffnen.DefaultExt := 'm2e';
    Oeffnen.FileName := '';
    Oeffnen.InitialDir := ExtractFilePath(Dateinamebilden(ArbeitsumgebungObj.ProjektVerzeichnis, ArbeitsumgebungObj.Projektdateiname));
    Oeffnen.InitialDir := Verzeichnissuchen(Oeffnen.InitialDir);
//    Oeffnen.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.ProjektVerzeichnis);
    IF Oeffnen.Execute THEN
    BEGIN
      IF ArbeitsumgebungObj.ProjektVerzeichnisspeichern THEN
        ArbeitsumgebungObj.ProjektVerzeichnis := ExtractFilePath(Oeffnen.FileName);
      SchnittListe_loeschen;
      Schneiden.Enabled := False;
      Dateienlisteloeschen;
      KapitelListeloeschen;
      MarkenListe.Clear;
      Schnittpunktanzeigeloeschen;
      Projektname := '';
      Projekteinfuegen_anzeigen(Oeffnen.FileName, True);
    END;
  END;
end;

procedure TMpegEdit.letztesProjektClick(Sender: TObject);

VAR Name : STRING;

begin
  IF (TMenuItem(Sender).MenuIndex) < ArbeitsumgebungObj.letzteProjekte.Count THEN
  BEGIN
    Name := ArbeitsumgebungObj.letzteProjekte.Strings[ArbeitsumgebungObj.letzteProjekte.Count - TMenuItem(Sender).MenuIndex - 1];
    IF (Name <> Projektname) AND FileExists(Name) THEN
    BEGIN
      IF ArbeitsumgebungObj.ProjektVerzeichnisspeichern THEN
        ArbeitsumgebungObj.ProjektVerzeichnis := ExtractFilePath(Name);
      SchnittListe_loeschen;
      Schneiden.Enabled := False;
      Dateienlisteloeschen;
      KapitelListeloeschen;
      MarkenListe.Clear;
      Schnittpunktanzeigeloeschen;
      Projektname := '';
      Projekteinfuegen_anzeigen(Name, True);
    END;
  END;
end;

procedure TMpegEdit.letztesVerzeichnisClick(Sender: TObject);

VAR Name : STRING;

begin
  IF (TMenuItem(Sender).MenuIndex) < ArbeitsumgebungObj.letzteVerzeichnisse.Count THEN
  BEGIN
    Name := ArbeitsumgebungObj.letzteVerzeichnisse.Strings[ArbeitsumgebungObj.letzteVerzeichnisse.Count - TMenuItem(Sender).MenuIndex - 1];
    IF DirectoryExists(Name) THEN
    BEGIN
      Video_oeffnen(mitPathtrennzeichen(Name));
    END;
  END;
end;

procedure TMpegEdit.letzteProjekteClick(Sender: TObject);

VAR I : Integer;
    Menuepunkt : TMenuItem;

begin
  WHILE TMenuItem(Sender).Count > 1 DO
  BEGIN
    TMenuItem(Sender).Items[1].Free;
  END;
  IF ArbeitsumgebungObj.letzteProjekte.Count > 0 THEN
    TMenuItem(Sender).Items[0].Caption := ArbeitsumgebungObj.letzteProjekte.Strings[ArbeitsumgebungObj.letzteProjekte.Count - 1]
  ELSE
    TMenuItem(Sender).Items[0].Caption := '-----';
  I := ArbeitsumgebungObj.letzteProjekte.Count - 1;
  WHILE I > 0 DO
  BEGIN
    Menuepunkt := TMenuItem.Create(TMenuItem(Sender));
    Menuepunkt.Caption := ArbeitsumgebungObj.letzteProjekte.Strings[I - 1];
    Menuepunkt.OnClick := letztesProjektClick;
    Menuepunkt.AutoHotkeys := maManual;
    TMenuItem(Sender).Add(Menuepunkt);
    Dec(I);
  END;
end;

procedure TMpegEdit.letzteVerzeichnisseClick(Sender: TObject);

VAR I : Integer;
    Menuepunkt : TMenuItem;

begin
  WHILE TMenuItem(Sender).Count > 1 DO
  BEGIN
    TMenuItem(Sender).Items[1].Free;
  END;
  IF ArbeitsumgebungObj.letzteVerzeichnisse.Count > 0 THEN
    TMenuItem(Sender).Items[0].Caption := ArbeitsumgebungObj.letzteVerzeichnisse.Strings[ArbeitsumgebungObj.letzteVerzeichnisse.Count - 1]
  ELSE
    TMenuItem(Sender).Items[0].Caption := '-----';
  I := ArbeitsumgebungObj.letzteVerzeichnisse.Count - 1;
  WHILE I > 0 DO
  BEGIN
    Menuepunkt := TMenuItem.Create(TMenuItem(Sender));
    Menuepunkt.Caption := ArbeitsumgebungObj.letzteVerzeichnisse.Strings[I - 1];
    Menuepunkt.OnClick := letztesVerzeichnisClick;
    Menuepunkt.AutoHotkeys := maManual;
    TMenuItem(Sender).Add(Menuepunkt);
    Dec(I);
  END;
end;

procedure TMpegEdit.ProjektNeuClick(Sender: TObject);

VAR Erg : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Erg := IDNO;
  IF Projekt_geaendertX THEN
    Erg := Nachrichtenfenster(Wortlesen(NIL, 'Meldung92', 'Soll das Projekt gespeichert werden?'),
                              Wortlesen(NIL, 'Frage', 'Frage'), MB_YESNOCANCEL, MB_ICONQUESTION);
//    Erg := Application.MessageBox(PChar(Wortlesen(NIL, 'Meldung92', 'Soll das Projekt gespeichert werden?')),
//                              PChar(Wortlesen(NIL, 'Frage', 'Frage')), MB_YESNOCANCEL);
  IF Erg <> IDCANCEL THEN
  BEGIN
    IF Erg = IDYES THEN
      Projektspeichern.Click;
    Stoppen;
    SchnittListe_loeschen;
    Schneiden.Enabled := False;
    Dateienlisteloeschen;                              // alle Knoten und Daten löschen
    KapitelListeloeschen;
    MarkenListe.Clear;
    AudiooffsetAus;
    Schnittpunktanzeigeloeschen;
    Informationen.Clear;
    Projektname := '';
    SchiebereglerPosition_setzen(0);
    Dateigroesse;
    Caption := UeberFenster.VersionNr;
  END;
end;

procedure TMpegEdit.ProgrammEndeClick(Sender: TObject);
begin
  Close;
end;

procedure TMpegEdit.AllgemeinPopupMenuPopup(Sender: TObject);
begin
  IF NOT Assigned(Vorschauknoten) THEN
  BEGIN
    Projektneu2.Enabled := True;
    Projektladen2.Enabled := True;
    IF ((Dateien.Items.Count > 0) OR
        (Schnittliste.Items.Count > 0) OR
        (KapitelListeGrid.Tag > 1)) THEN
    BEGIN
      IF Projekt_geaendert THEN
        Projektspeichern2.Enabled := True
      ELSE
        Projektspeichern2.Enabled := False;
      Projektspeichernunter2.Enabled := True;
      ProjektspeichernPlus2.Enabled := True;
    END
    ELSE
    BEGIN
      Projektspeichern2.Enabled := False;
      Projektspeichernunter2.Enabled := False;
      ProjektspeichernPlus2.Enabled := False;
    END;
    IF (Schnittliste.Items.Count > 0) OR (KapitelListeGrid.Tag > 1) THEN
      ProjektEinfuegen2.Enabled := True
    ELSE
      ProjektEinfuegen2.Enabled := False;
  END
  ELSE
  BEGIN
    Projektneu2.Enabled := False;
    Projektladen2.Enabled := False;
    Projektspeichern2.Enabled := False;
    Projektspeichernunter2.Enabled := False;
    ProjektspeichernPlus2.Enabled := False;
    ProjektEinfuegen2.Enabled := False;
  END;
end;

// --------------------------- Dateigröße Funktionen/Proceduren ----------------------------------

FUNCTION TMpegEdit.SchnittgroesseberechnenVideoaktiv(Liste, IndexListe: TListe; Anfangsbild, Endbild: Int64): Int64;
BEGIN
  IF Endbild > IndexListe.Count -1 THEN
    Endbild := IndexListe.Count - 1;      // wird nur Audio geschnitte kann der Ton länger sein
  IF Assigned(Liste) AND Assigned(Indexliste) THEN
    IF (Liste.Count > 0) AND (IndexListe.Count > 0) THEN
      IF (Anfangsbild < Endbild +  1) AND (Anfangsbild > -1) AND (Anfangsbild < IndexListe.Count) AND
         (Endbild > -1) AND (Endbild < IndexListe.Count) THEN
        Result := THeaderklein(Liste.Items[TBildIndex(IndexListe.Items[Endbild]).BildIndex + 1]).Adresse -
                  THeaderklein(Liste.Items[TBildIndex(IndexListe.Items[Anfangsbild]).BildIndex - 2]).Adresse
      ELSE
        Result := -3                      // Schnittpunkte ungültig
    ELSE
      Result := -2                        // Listen leer
  ELSE
    Result := -1;                         // keine Listen
END;

FUNCTION TMpegEdit.SchnittgroesseberechnenVideo(Videoname: STRING; Anfangsbild, Endbild: Int64): Int64;

VAR MpegHeader : TMpeg2Header;
    Liste1,
    IndexListe1 : TListe;

BEGIN
  MpegHeader:= TMpeg2Header.Create;
  TRY
    Liste1 := TListe.Create;
    IndexListe1 := TListe.Create;
    TRY
      MpegHeader.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
      MpegHeader.Textanzeige := Fortschrittsfenster.Textanzeige;
      MpegHeader.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
      MpegHeader.SequenzEndeIgnorieren := ArbeitsumgebungObj.SequenzEndeignorieren;
      IF MpegHeader.Dateioeffnen(VideoName) THEN
      BEGIN
        Fortschrittsfensteranzeigen;
        TRY
          MpegHeader.Listeerzeugen(Liste1, IndexListe1);
        FINALLY
          Fortschrittsfensterverbergen;
        END;
        IF Liste1.Count > 0 THEN
          Result := SchnittgroesseberechnenVideoaktiv(Liste1, IndexListe1, Anfangsbild, Endbild)
        ELSE
          Result := -2;     // Liste läßt sich nicht erzeugen
      END
      ELSE
        Result := -1;       // Datei läßt sich nicht öffnen
    FINALLY
      Liste1.Loeschen;
      Liste1.Free;
      IndexListe1.Loeschen;
      IndexListe1.Free;
    END;
  FINALLY
    MpegHeader.Free;
  END;
END;
{
FUNCTION TMpegEdit.SchnittgroesseberechnenVideo_Knoten(Knoten: TTreeNode; Anfangsbild, Endbild: LongInt): Int64;

VAR Unterknoten : TTreeNode;
    Groesse : Int64;

BEGIN
  Result := 0;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    IF Knoten.HasChildren THEN
    BEGIN
      Unterknoten := Knoten.Item[0];
      IF Assigned(Unterknoten) THEN
      BEGIN
        IF Assigned(Unterknoten.Data) THEN
        BEGIN
          IF Unterknoten = aktVideoknoten THEN
            Groesse := SchnittgroesseberechnenVideoaktiv(VideoListe, IndexListe, Anfangsbild, Endbild)
          ELSE
            Groesse := SchnittgroesseberechnenVideo(TDateieintrag(Unterknoten.Data).Name, Anfangsbild, Endbild);
        END
        ELSE
          Groesse := 0;
        IF Groesse < 0 THEN
        BEGIN
          Meldungsfenster(Meldunglesen(NIL, 'Meldung131', TDateieintrag(Unterknoten.Data).Name, 'Fehler im ersten Header der Audiodatei $Text1#.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung131', TDateieintrag(Unterknoten.Data).Name, 'Fehler im ersten Header der Audiodatei $Text1#.'));
          Result := Groesse;              // Fehlernummer weitergeben
        END
        ELSE
          Result := Groesse;              // Videogröße übergeben
      END;
    END;
  END
  ELSE
    Result := -5;                       // kein Knoten übergeben
END;   }

FUNCTION TMpegEdit.SchnittgroesseberechnenVideo_Knoten(Knoten: TTreeNode; Anfangsbild, Endbild: Int64; HListe: TListe = NIL; HIndexListe: TListe = NIL): Int64;

VAR Unterknoten : TTreeNode;
    Groesse : Int64;

BEGIN
  Result := 0;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    IF Knoten.HasChildren THEN
    BEGIN
      Unterknoten := Knoten.Item[0];
      IF Assigned(Unterknoten) THEN
      BEGIN
        IF Assigned(Unterknoten.Data) THEN
        BEGIN
          IF Unterknoten = aktVideoknoten THEN
            Groesse := SchnittgroesseberechnenVideoaktiv(VideoListe, IndexListe, Anfangsbild, Endbild)
          ELSE
            IF Assigned(HListe) AND Assigned(HIndexListe) THEN
              Groesse := SchnittgroesseberechnenVideoaktiv(HListe, HIndexListe, Anfangsbild, Endbild)
            ELSE
              Groesse := SchnittgroesseberechnenVideo(TDateieintrag(Unterknoten.Data).Name, Anfangsbild, Endbild);
        END
        ELSE
          Groesse := 0;
        IF Groesse < 0 THEN
        BEGIN
          Meldungsfenster(Meldunglesen(NIL, 'Meldung131', TDateieintrag(Unterknoten.Data).Name, 'Fehler im ersten Header der Audiodatei $Text1#.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung131', TDateieintrag(Unterknoten.Data).Name, 'Fehler im ersten Header der Audiodatei $Text1#.'));
          Result := Groesse;              // Fehlernummer weitergeben
        END
        ELSE
          Result := Groesse;              // Videogröße übergeben
      END;
    END;
  END
  ELSE
    Result := -5;                       // kein Knoten übergeben
END;

FUNCTION TMpegEdit.SchnittgroesseberechnenVideo_akt(Anfangsbild, Endbild: Int64): Int64;
BEGIN
{  IF aktVideodatei = '' THEN
    Result := 0
  ELSE
    Result := SchnittgroesseberechnenVideoaktiv(VideoListe, IndexListe, Anfangsbild, Endbild);  }
  IF Assigned(aktVideoKnoten) THEN
    Result := SchnittgroesseberechnenVideo_Knoten(aktVideoKnoten, Anfangsbild, Endbild)
  ELSE
    Result := 0;
END;

PROCEDURE TMpegEdit.SchnittgroesseNeuberechnenVideo(Knoten: TTreeNode);

VAR I : Integer;
    Listenpunkt : TSchnittpunkt;

BEGIN
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    FOR I := 0 TO SchnittListe.Items.Count - 1 DO
    BEGIN
      Listenpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
      IF Listenpunkt.Videoknoten = Knoten THEN
        Listenpunkt.VideoGroesse := SchnittgroesseberechnenVideo_Knoten(Knoten, Listenpunkt.Anfang, Listenpunkt.Ende);
    END;
    Dateigroesse;
  END;
END;

FUNCTION TMpegEdit.SchnittgroesseberechnenAudioaktiv(AudioHeader : TAudioHeader; Anfangsbild, Endbild: Int64; Bildlaenge: Real): Int64;
BEGIN
  IF Assigned(AudioHeader) THEN
    IF Audioheader.Framelaenge > 0 THEN
      IF (Anfangsbild < Endbild +  1) AND (Anfangsbild > -1) AND (Endbild > -1) THEN
        Result := (Round((Endbild - Anfangsbild + 1) * Bildlaenge / Audioheader.Framezeit) * Audioheader.Framelaenge)
      ELSE
        Result := -3                      // Schnittpunkte ungültig
    ELSE
      Result := -2                        // ungültiger Audioheader
  ELSE
    Result := -1;                         // kein Audioheader
END;

FUNCTION TMpegEdit.SchnittgroesseberechnenAudio(Audioname: STRING; Anfangsbild, Endbild: Int64; Bildlaenge: Real): Int64;

VAR MpegAudio : TMpegAudio;
    HAudioHeader : TAudioHeader;

BEGIN
  IF Assigned(aktAudioknoten) AND Assigned(aktAudioknoten.Data) AND
     (TDateieintragAudio(aktAudioknoten.Data).Name = Audioname) THEN
    Result := SchnittgroesseberechnenAudioaktiv(AudioHeader, Anfangsbild, Endbild, Bildlaenge)
  ELSE
  BEGIN
    MpegAudio:= TMpegAudio.Create;
    TRY
      HAudioHeader := TAudioHeader.Create;
      TRY
        MpegAudio.Dateioeffnen(Audioname);
        MpegAudio.DateiInformationLesen(HAudioHeader);
        Result := SchnittgroesseberechnenAudioaktiv(HAudioHeader, Anfangsbild, Endbild, Bildlaenge);
      FINALLY
        HAudioHeader.Free;
      END;
    FINALLY
      MpegAudio.Free;
    END;
  END;
END;

FUNCTION TMpegEdit.SchnittgroesseberechnenAudio_Knoten(Knoten: TTreeNode; Anfangsbild, Endbild: Int64; Framerate: Real): Int64;

VAR Unterknoten : TTreeNode;
    I{, J }: Integer;
    Groesse : Int64;
    Bildlaenge : Real;

BEGIN
  Result := 0;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    Bildlaenge := 1000 / Framerate;
    I := 1;
    WHILE (I < Knoten.Count) AND (Result > -1) DO
    BEGIN
      Unterknoten := Knoten.Item[I];
      IF Assigned(Unterknoten) THEN
      BEGIN
        IF Assigned(Unterknoten.Data) THEN
          Groesse := SchnittgroesseberechnenAudio(TDateieintragAudio(Unterknoten.Data).Name, Anfangsbild, Endbild, Bildlaenge)
        ELSE
        BEGIN
//          J := 0;
          Groesse := 0;
    {      WHILE (J < Dateien.Items.Count) AND (Groesse > -1) DO  // Audiodatei in der aktuellen Spur suchen
          BEGIN
            IF I < Dateien.Items[J].Count THEN
            BEGIN
              Unterknoten := Dateien.Items[J].Item[I];
              IF Assigned(Unterknoten) THEN
                IF Assigned(Unterknoten.Data) THEN
                BEGIN
                  Groesse := SchnittgroesseberechnenAudio(TDateieintragAudio(Unterknoten.Data).Name, Anfangsbild, Endbild, Bildlaenge);
                  J := Dateien.Items.Count;
                END;
            END;
            Inc(J);
          END;   }
        END;
        IF Groesse < 0 THEN
        BEGIN
          Meldungsfenster(Meldunglesen(NIL, 'Meldung131', TDateieintragAudio(Unterknoten.Data).Name, 'Fehler im ersten Header der Audiodatei $Text1#.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung131', TDateieintragAudio(Unterknoten.Data).Name, 'Fehler im ersten Header der Audiodatei $Text1#.'));
          Result := Groesse;              // Fehlernummer weitergeben
        END
        ELSE
          Result := Result + Groesse;     // Audiogrößen addieren
      END;
      Inc(I);
    END;
  END
  ELSE
    Result := -5;                         // kein Knoten übergeben
END;

FUNCTION TMpegEdit.SchnittgroesseberechnenAudio_akt(Anfangsbild, Endbild: Int64): Int64;
BEGIN
  IF Assigned(aktAudioknoten) THEN
    Result := SchnittgroesseberechnenAudio_Knoten(aktAudioknoten, Anfangsbild, Endbild, BilderProSek)
  Else
//    IF Assigned(aktVideoknoten) THEN
//      Result := SchnittgroesseberechnenAudio_Knoten(aktVideoknoten, Anfangsbild, Endbild, BilderProSek)
//    ELSE
      Result := 0;
END;

PROCEDURE TMpegEdit.SchnittgroesseNeuberechnenAudio(Knoten: TTreeNode);

VAR I : Integer;
    Listenpunkt : TSchnittpunkt;

BEGIN
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    FOR I := 0 TO SchnittListe.Items.Count - 1 DO
    BEGIN
      Listenpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
      IF Listenpunkt.Audioknoten = Knoten THEN
        Listenpunkt.AudioGroesse := SchnittgroesseberechnenAudio_Knoten(Knoten, Listenpunkt.Anfang, Listenpunkt.Ende, Listenpunkt.Framerate);
    END;
    Dateigroesse;
  END;
END;

PROCEDURE TMpegEdit.SchnittgroesseNeuberechnenAudiokomplett;

VAR I : Integer;
    Listenpunkt : TSchnittpunkt;

BEGIN
  FOR I := 0 TO SchnittListe.Items.Count - 1 DO
  BEGIN
    Listenpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
    IF Assigned(Listenpunkt.Audioknoten) THEN
      Listenpunkt.AudioGroesse := SchnittgroesseberechnenAudio_Knoten(Listenpunkt.Audioknoten, Listenpunkt.Anfang, Listenpunkt.Ende, Listenpunkt.Framerate);
  END;
  Dateigroesse;
END;

FUNCTION TMpegEdit.Schnittpunktevorhanden(Knoten: TTreeNode): Integer;

VAR I : Integer;

BEGIN
  Result := 0;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    I := 0;
    WHILE I < SchnittListe.Items.Count DO
    BEGIN
      IF Assigned(SchnittListe.Items.Objects[I]) AND
         ((Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Videoknoten) OR
         (Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Videoknoten.Parent) OR
         (Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Audioknoten) OR
         (Assigned(TSchnittpunkt(SchnittListe.Items.Objects[I]).Audioknoten) AND      // Audioknoten sind nicht immer vorhanden
         (Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Audioknoten.Parent))) THEN
        Inc(Result);
      Inc(I);
    END;
  END;
END;

PROCEDURE TMpegEdit.Schnittpunkteloeschen(Knoten: TTreeNode);

VAR I : Integer;

BEGIN
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    I := 0;
    WHILE I < SchnittListe.Items.Count DO
    BEGIN
      IF Assigned(SchnittListe.Items.Objects[I]) AND
         ((Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Videoknoten) OR
         (Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Videoknoten.Parent) OR
         (Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Audioknoten) OR
         (Assigned(TSchnittpunkt(SchnittListe.Items.Objects[I]).Audioknoten) AND      // Audioknoten sind nicht immer vorhanden
         (Knoten = TSchnittpunkt(SchnittListe.Items.Objects[I]).Audioknoten.Parent))) THEN
      BEGIN
        Schnittpunkt_loeschen(I);
        IF I < SchnittListe.Items.Count THEN
          Schnittpunktanzeige_berechnen(I, -1)
        ELSE
          IF I > 0 THEN
            Schnittpunktanzeige_berechnen(-1, I - 1);
      END      
      ELSE
        Inc(I);
    END;
  END;
END;

PROCEDURE TMpegEdit.Dateigroesse;

VAR I : Integer;
    Schnittpunkt : TSchnittpunkt;
    Groesse,
//    VideoGroesse,              // global für "Speicherplatz_pruefen"
//    AudioGroesse,
    HAudioGroesse : Int64;
    GesamtGrReal,
    AudioGrReal,
    VideoGrReal : Real;
    Laenge,
    HLaenge : Int64;
    Einheit : STRING;

BEGIN
  VideoGroesse := 0;
  AudioGroesse := 0;
  HAudioGroesse := 0;
  Laenge := 0;
  HLaenge := 0;
  FOR I := 0 TO SchnittListe.Items.Count - 1 DO                    
  BEGIN
    IF (NOT MarkierteSchnittpunkte.Down) OR
       SchnittListe.Selected[I] THEN
    BEGIN
      Schnittpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
      IF Schnittpunkt.AudioGroesse > 0 THEN
      BEGIN
        HAudioGroesse := Schnittpunkt.AudioGroesse;
        HLaenge := Schnittpunkt.Ende - Schnittpunkt.Anfang + 1;
      END;
    END;
  END;
  FOR I := 0 TO SchnittListe.Items.Count - 1 DO
  BEGIN
    IF (NOT MarkierteSchnittpunkte.Down) OR
       SchnittListe.Selected[I] THEN
    BEGIN
      Schnittpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
      IF NOT nurAudiospeichern.Down THEN
        VideoGroesse := VideoGroesse + Schnittpunkt.VideoGroesse;
      IF Schnittpunkt.AudioGroesse > 0 THEN
        AudioGroesse := AudioGroesse + Schnittpunkt.AudioGroesse
      ELSE
        IF (HLaenge > 0) AND (HAudioGroesse > 0) THEN
          AudioGroesse := AudioGroesse +
                          Round((Schnittpunkt.Ende - Schnittpunkt.Anfang + 1) *
                          HAudioGroesse / HLaenge);
      Laenge := Laenge + Schnittpunkt.Ende - Schnittpunkt.Anfang + 1;
    END;
  END;
  Groesse := VideoGroesse + AudioGroesse;
  Einheit := 'MB';
  VideoGrReal := VideoGroesse / 1048576;
  VideoGr.Caption := FloatToStrF(VideoGrReal, ffNumber, 8, 2) + ' ' + Einheit;
  IF Laenge > 0 THEN
    VideoGr.Hint := FloatToStrF(VideoGroesse * 8 / Laenge * BilderProSek / 1000000, ffNumber, 8, 3) + ' ' + Wortlesen(Spracheladen, 'Mbit/s', 'Mbit/s')
  ELSE
    VideoGr.Hint := '';
  AudioGrReal := AudioGroesse / 1048576;
  AudioGr.Caption := FloatToStrF(AudioGrReal, ffNumber, 8, 2) + ' ' + Einheit;
  GesamtGrReal := Groesse / 1048576;
  GesamtGr.Caption := FloatToStrF(GesamtGrReal, ffNumber, 8, 2) + ' ' + Einheit;
  GesamtZeit.Caption := ZeitToStr(FramesToZeit(Laenge, BilderProSek));
END;

procedure TMpegEdit.FenstermenueClick(Sender: TObject);
begin
//  binaereSucheMenue.Checked := binaereSucheForm.Active;
//  GrobansichtMenue.Checked := FilmGrobAnsichtFrm.Visible;
end;

procedure TMpegEdit.binaereSucheMenueClick(Sender: TObject);
begin
//  binaereSucheMenue.Checked := NOT binaereSucheMenue.Checked;
//  IF binaereSucheMenue.Checked THEN
    binaereSucheForm.Show
//  ELSE
//    binaereSucheForm.Hide;
end;

procedure TMpegEdit.GrobansichtMenuItemClick(Sender: TObject);
begin
//  GrobansichtMenue.Checked := NOT GrobansichtMenue.Checked;
//  IF GrobansichtMenue.Checked THEN
    FilmGrobAnsichtFrm.Show
//  ELSE
//    FilmGrobAnsichtFrm.Hide;
end;

procedure TMpegEdit.HilfemenuClick(Sender: TObject);
begin
  IF FileExists(ChangeFileExt(Application.ExeName, '.chm')) OR
     FileExists(ChangeFileExt(Application.ExeName, '.htm')) OR
     FileExists(ChangeFileExt(Application.ExeName, '.html')) THEN
    Hilfe.Enabled := True
  ELSE
    Hilfe.Enabled := False;
end;

procedure TMpegEdit.HilfeClick(Sender: TObject);
begin
  IF FileExists(ChangeFileExt(Application.ExeName, '.chm')) THEN
    ShellExecute(Handle, 'open', PChar(ChangeFileExt(Application.ExeName, '.chm')), '', '', SW_SHOWNORMAL)
  ELSE
    IF FileExists(ChangeFileExt(Application.ExeName, '.htm')) THEN
      ShellExecute(Handle, 'open', PChar(ChangeFileExt(Application.ExeName, '.htm')), '', '', SW_SHOWNORMAL)
    ELSE
      IF FileExists(ChangeFileExt(Application.ExeName, '.html')) THEN
        ShellExecute(Handle, 'open', PChar(ChangeFileExt(Application.ExeName, '.html')), '', '', SW_SHOWNORMAL);
end;

procedure TMpegEdit.UeberClick(Sender: TObject);
begin
//  Pause;
  Dialogaktiv := True;
  IF Sender = Ueber THEN
    UeberFenster.Lizenzanzeigen := False
  ELSE
    UeberFenster.Lizenzanzeigen := True;
  UeberFenster.ShowModal;
  Dialogaktiv := False;
end;

procedure TMpegEdit.SchnittoptionenClick(Sender: TObject);
begin
  Dateigroesse;
  Schneiden.Enabled := Schneidenmoeglich;
  Vorschau.Enabled := Vorschaumoeglich;
end;

// ----------------------------- Maus Funktionen/Proceduren ------------------------------------

procedure TMpegEdit.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

VAR Diff : Integer;
    I : Integer;

begin
  Diff := 0;
  IF WheelDelta < 0 THEN
    Diff := - Schrittweite;
  IF WheelDelta > 0 THEN
    Diff := Schrittweite;
  IF (ArbeitsumgebungObj.Scrollrad = 1) OR
     (Tastegedrueckt = ArbeitsumgebungObj.Tasten[41]) THEN
  BEGIN
    IF Assigned(Audiooffset) AND (Audiooffset <> @AudiooffsetNull) THEN
    BEGIN
      Audiooffset^ := Audiooffset^ + Diff;
      AudioOffsetAnzeige_aendern;
      AudioOffsetfensterAnzeige_aendern;
    END;
  END
  ELSE
    IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[42] THEN
    BEGIN
      IF Diff < 0 THEN
        Temposetzen(1)
      ELSE
        Temposetzen(2);
    END
    ELSE
      IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[5] THEN
      BEGIN
        I := VideoBildPosition;
        IF Diff < 0 THEN
          I := NaechstesBild(1, I + 1, IndexListe)
        ELSE
          I := VorherigesBild(1, I - 1, IndexListe);
        IF I > -1 THEN
          SchiebereglerPosition_setzen(I);
      END
      ELSE
      IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[6] THEN
      BEGIN
        I := VideoBildPosition;
        IF Diff < 0 THEN
          I := NaechstesBild(2, I + 1, IndexListe)
        ELSE
          I := VorherigesBild(2, I - 1, IndexListe);
        IF I > -1 THEN
          SchiebereglerPosition_setzen(I);
      END
      ELSE
        SchiebereglerPosition_setzen(SchiebereglerPosition - Diff);
  Handled := True;
end;

PROCEDURE TMpegEdit.SchiebereglerPosition_setzen_Stop_Start(Pos: Int64; verwendeUndo: Boolean = False);
BEGIN
  IF AbspielModus THEN
  BEGIN
    AbspielModus := False;
    PlayerPause;
 //   WHILE TAbspielmode(AudioPlayer.Mode) = mpPlaying DO
 //     Application.ProcessMessages;                // warten bis der Audioplayer fertig ist
    SchiebereglerPosition_setzen(Pos, verwendeUndo);
    AbspielModus := True;
    PlayerStart;
    CutIn.Enabled := False;
    CutOut.Enabled := False;
  END
  ELSE
    SchiebereglerPosition_setzen(Pos, verwendeUndo);
END;

procedure TMpegEdit.SchrittVorClick(Sender: TObject);

VAR I, J, T : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  I := SchiebereglerPosition;
  J := 0;
  T := 0;
  IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[5] THEN
    T := 1;
  IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[6] THEN
    T := 2;
  IF T > 0 THEN
  BEGIN
    WHILE (J < Schrittweite) AND (I > -1) DO
    BEGIN
      I := NaechstesBild(T, I + 1, IndexListe);
      Inc(J);
    END;
    IF I < 0 THEN                           // letztes Bild suchen
      I := VorherigesBild(T, IndexListe.Count - 1, IndexListe);
    IF I < SchiebereglerPosition THEN       // Bild liegt vor der aktuellen Position
      I := SchiebereglerPosition;
  END
  ELSE
    I := SchiebereglerPosition + Schrittweite;
  SchiebereglerPosition_setzen_Stop_Start(I);
end;

procedure TMpegEdit.SchrittZurueckClick(Sender: TObject);

VAR I, J, T : Integer;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  I := SchiebereglerPosition;
  J := 0;
  T := 0;
  IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[5] THEN
    T := 1;
  IF Tastegedrueckt = ArbeitsumgebungObj.Tasten[6] THEN
    T := 2;
  IF T > 0 THEN
  BEGIN
    WHILE (J < Schrittweite) AND (I > -1) DO
    BEGIN
      I := VorherigesBild(T, I - 1, IndexListe);
      Inc(J);
    END;
    IF I < 0 THEN                           // ersten Bild suchen
      I := NaechstesBild(T, 0, IndexListe);
    IF I > SchiebereglerPosition THEN       // Bild liegt hinter der aktuellen Position
      I := SchiebereglerPosition;
  END
  ELSE
    I := SchiebereglerPosition - Schrittweite;
  SchiebereglerPosition_setzen_Stop_Start(I);
end;

procedure TMpegEdit.SchnittListeStartDrag(Sender: TObject;
  var DragObject: TDragObject);

VAR I, J : Integer;

begin
  Schnittpunktbewegen := -1;
  I := 0;
  WHILE (I < SchnittListe.Items.Count) AND (Schnittpunktbewegen < 0) DO
  BEGIN
    IF SchnittListe.Selected[I] THEN
      Schnittpunktbewegen := I;              // erster markierter Eintrag
    Inc(I);
  END;
  J := -1;
  I := SchnittListe.Items.Count - 1;
  WHILE (I > - 1) AND (J < 0) DO
  BEGIN
    IF SchnittListe.Selected[I] THEN
      J := I;
    Dec(I);
  END;
  IF (J - Schnittpunktbewegen + 1) = SchnittListe.SelCount THEN   // nur zusammenhängende Eintrage
    SchnittpunktbewegenCount := SchnittListe.SelCount    // Anzahl markierter Eintrage
  ELSE
  BEGIN
    Schnittpunktbewegen := -1;
    SchnittpunktbewegenCount := -1;
  END;
end;

procedure TMpegEdit.SchnittListeDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);

VAR Punkt : TPoint;
    Ziel : Integer;

begin
  Accept := False;
  IF (Source = SchnittListe) AND (Schnittpunktbewegen > - 1) THEN
  BEGIN
    Punkt.x:= x;
    Punkt.y:= y;
    Ziel := SchnittListe.ItemAtPos(Punkt, True);
    SchnittListe.itemindex:= Ziel ;
    IF Ziel > -1 THEN
    BEGIN
      IF NOT SchnittListe.Selected[Ziel] THEN
        Accept := True;
    END;
  END;
end;

procedure TMpegEdit.SchnittListeDragDrop(Sender, Source: TObject; X,
  Y: Integer);

VAR I, J : Integer;

begin
  J := SchnittListe.ItemIndex;
  IF (Source = SchnittListe) AND (Schnittpunktbewegen > - 1) THEN
  BEGIN
    IF Schnittpunktbewegen < SchnittListe.ItemIndex THEN
    BEGIN
      FOR I := 1 TO SchnittpunktbewegenCount DO
      BEGIN
        SchnittListe.Items.Move(Schnittpunktbewegen, J);
        SchnittListe.Selected[J] := True;
      END;
      Schnittpunktanzeige_berechnen(Schnittpunktbewegen, -1);
      Schnittpunktanzeige_berechnen(J - SchnittpunktbewegenCount + 1, J);
    END
    ELSE
    BEGIN
      FOR I := 1 TO SchnittpunktbewegenCount DO
      BEGIN
        SchnittListe.Items.Move(Schnittpunktbewegen + SchnittpunktbewegenCount - 1, J);
        SchnittListe.Selected[J] := True;
      END;
      Schnittpunktanzeige_berechnen(J, J + SchnittpunktbewegenCount - 1);
      Schnittpunktanzeige_berechnen(-1, Schnittpunktbewegen + SchnittpunktbewegenCount - 1);
    END;
    Schnittliste.Repaint;
    Projektgeaendert_setzen(2);
    Schnittpunktbewegen := -1;
    SchnittpunktbewegenCount := -1;
  END;
end;

procedure TMpegEdit.SchnittListeEndDrag(Sender, Target: TObject; X,
  Y: Integer);

VAR I : Integer;

begin
  FOR I := 1 TO SchnittpunktbewegenCount DO
  BEGIN
    SchnittListe.Selected[Schnittpunktbewegen] := True;
    Inc(Schnittpunktbewegen);
  END;
  Schnittpunktbewegen := -1;
  SchnittpunktbewegenCount := -1;
end;

procedure TMpegEdit.SchnittlisteEnter(Sender: TObject);
begin
  Schnittlisteaktiv := True;
end;

procedure TMpegEdit.SchnittlisteExit(Sender: TObject);
begin
  Schnittlisteaktiv := False;
end;

procedure TMpegEdit.SchnittlisteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF NOT(ssDouble	IN Shift) AND                                 // bei einem Doppelclick darf die Funktion nicht ausgeführt werden
     NOT(ssShift IN Shift) AND                                  // nur wenn keine Zusatztaste gedrückt ist Funktion ausführen
     NOT(ssCtrl IN Shift) AND
     (Button = mbLeft) THEN
  BEGIN
    IF SchnittListe.ItemAtPos(Point(x,y), True) = -1 THEN
    BEGIN
      SchnittListe.ClearSelection;
      SchnittListe.ItemIndex := -1;
    END
    ELSE
      Schnittliste.BeginDrag(False);
  END;
{  Dateigroesse;                                                 // ist die Shifttaste gedrückt werden die markierten Einträge nicht richtig ausgewertet
  Schneiden.Enabled := Schneidenmoeglich;                        // deshalb sind diese Funktionen in der Funktion "SchnittListeMouseUp" untergebracht
  Vorschau.Enabled := Vorschaumoeglich;  }
end;

procedure TMpegEdit.SchnittListeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

//VAR Punkt : TPoint;

begin
  IF Button = mbLeft THEN
  BEGIN
    IF Schnittliste.Dragging THEN
      Schnittliste.EndDrag(True);
{    Punkt.x:= x;
    Punkt.y:= y;
    IF SchnittListe.ItemAtPos(Punkt, True) = -1 THEN
    BEGIN
      SchnittListe.ClearSelection;
      SchnittListe.ItemIndex := -1;
    END;
    Schneiden.Enabled := Schneidenmoeglich;    }
  END;
  Dateigroesse;
  Schneiden.Enabled := Schneidenmoeglich;
  Vorschau.Enabled := Vorschaumoeglich;
end;

procedure TMpegEdit.OffseteingabeEnter(Sender: TObject);
begin
  OffsetEditaktiv := True;
end;

procedure TMpegEdit.SchnittpktAnfangkopierenClick(Sender: TObject);

//VAR Knoten : TTreeNode;
//    I : Integer;

begin
  IF Schnittliste.ItemIndex > -1 THEN
  BEGIN
    Clipboard.AsText := BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat,
                        TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).Anfang,
                        TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).Framerate);
  END;
{  IF Schnittliste.ItemIndex > -1 THEN
  BEGIN
    IF Assigned(aktAudioknoten) THEN
    BEGIN
      IF aktAudioknoten.Level > 0 THEN
        Knoten := aktAudioknoten.Parent
      ELSE
        Knoten := aktAudioknoten;
      FOR I := 1 TO Knoten.Count - 1 DO
        IF Assigned(Knoten[I].Data) THEN
        BEGIN
          TDateieintragAudio(Knoten[I].Data).Audiooffset := Round(TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).Anfang * Bildlaenge);
          Projektgeaendert_setzen(1);
        END;
      IF Assigned(Audiooffset) THEN
      BEGIN
        AudioOffsetAnzeige_aendern;
        AudioOffsetfensterAnzeige_aendern;
        Schiebereglerlaenge_einstellen;
        SchiebereglerPosition_setzen(SchiebereglerPosition);
      END;
    END;
  END; }
end;

procedure TMpegEdit.SchnittpktEndekopierenClick(Sender: TObject);
begin
  IF Schnittliste.ItemIndex > -1 THEN
  BEGIN
    Clipboard.AsText := BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat,
                        TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).Ende,
                        TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).Framerate);
  END;
end;

PROCEDURE TMpegEdit.AudioTimerTimer(Sender: TObject);

VAR Position : Int64;

begin
  IF (NOT(VideoabspielerMode = mpPlaying)) AND (TAbspielMode(AudioplayerMode) = mpPlaying) THEN
  BEGIN
    Position := Trunc((AudioplayerPosition_holen + Audiooffset^) / Bildlaenge);
    Positionsanzeige(Position);
  END;
end;

PROCEDURE TMpegEdit.AudioOffsetAnzeige_aendern;
BEGIN
  IF Assigned(Audiooffset) AND (Audiooffset <> @AudiooffsetNull) THEN
  BEGIN
    Audiooffsetms.Caption := BildnummerInZeitStr('N', Audiooffset^, BilderProSek);
    AudiooffsetBilder.Caption := IntToStr(Round(Audiooffset^ * BilderProSek / 1000));
  END
  ELSE
  BEGIN
    Audiooffsetms.Caption := 'X';
    AudiooffsetBilder.Caption := 'X';
  END;
END;

PROCEDURE TMpegEdit.AudiooffsetNeu(Offset: PInteger);
BEGIN
  Audiooffset := Offset;
  IF NOT Assigned(Audiooffset) THEN
    Audiooffset := @AudiooffsetNull;
  AudioOffsetAnzeige_aendern;
  AudioOffsetfensterAnzeige_aendern;
END;

PROCEDURE TMpegEdit.AudiooffsetAus;
BEGIN
  AudiooffsetNull := 0;
  Audiooffset := @AudiooffsetNull;
  AudioOffsetAnzeige_aendern;
  AudioOffsetfensterAnzeige_aendern;
END;

procedure TMpegEdit.IndexerstellenClick(Sender: TObject);
begin
  aktDateienloeschen;
  IF NOT Unterprogramm_starten(ExtractFilePath(Application.ExeName) + 'Index.exe ' + Dateinamenliste) THEN
    Meldungsfenster(Meldunglesen(NIL, 'Meldung114', 'Index.exe ', 'Die Datei $Text1# läßt sich nicht öffnen.') + Chr(13) +
                    Meldunglesen(NIL, 'Meldung120', ExtractFilePath(Application.ExeName), 'Die Datei muß im Verzeichnis $Text1# liegen.'),
                    Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//    Showmessage(Meldunglesen(NIL, 'Meldung114', 'Index.exe ', 'Die Datei $Text1# läßt sich nicht öffnen.') + Chr(13) +
//                Meldunglesen(NIL, 'Meldung120', ExtractFilePath(Application.ExeName), 'Die Datei muß im Verzeichnis $Text1# liegen.'));
end;

procedure TMpegEdit.DateihinzufuegenClick(Sender: TObject);

VAR Knotenpunkt : TTreeNode;
//    Knoten : TTreeNode;
    I, Erg : Integer;
    Text : STRING;
//    HString : STRING;
//    Eintrag : Pointer;

begin
  Knotenpunkt := Dateien.Selected;
  IF Assigned(Knotenpunkt) THEN
  BEGIN
{    IF Knotenpunkt.Level > 0 THEN
      IF Knotenpunkt.Parent.IndexOf(Knotenpunkt) = 0 THEN      // Videoknoten
      BEGIN
        Oeffnen.Title := Wortlesen(NIL, 'Dialog11', 'MPEG-2 Videodatei öffnen');
        Oeffnen.Filter := Wortlesen(NIL, 'Dialog12', 'MPEG-2 Videodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo;
        Oeffnen.DefaultExt := ArbeitsumgebungObj.StandardEndungenVideo;
      END
      ELSE                                                     // Audioknoten
      BEGIN
        Oeffnen.Title := Wortlesen(NIL, 'Dialog14', 'Audiodatei öffnen');
        Oeffnen.Filter := Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio;
        Oeffnen.DefaultExt := ArbeitsumgebungObj.StandardEndungenAudio;
      END
    ELSE
    BEGIN  }
      Oeffnen.Title := Wortlesen(NIL, 'Dialog14', 'Audiodatei öffnen');
      Oeffnen.Filter := Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio;
      Oeffnen.DefaultExt := Copy(ArbeitsumgebungObj.StandardEndungenAudio, 2, Length(ArbeitsumgebungObj.StandardEndungenAudio) - 1);
//    END;
    Text := '';
    Oeffnen.FileName := '';
    Oeffnen.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.VideoAudioVerzeichnis);
    IF Oeffnen.Execute THEN
    BEGIN
      IF ArbeitsumgebungObj.VideoAudioVerzeichnisspeichern THEN
        ArbeitsumgebungObj.VideoAudioVerzeichnis := ExtractFilePath(Oeffnen.FileName);
      IF Knotenpunkt.Level > 0 THEN
        Knotenpunkt := Knotenpunkt.Parent;        // Hauptknoten
//      IF Knotenpunkt.Level = 0 THEN
//      BEGIN
        FOR I := 0 TO Oeffnen.Files.Count -1 DO
        BEGIN
          Erg := AudiodateieinfuegenKnoten(Knotenpunkt, Oeffnen.Files[I]);
          IF Erg = 0 THEN
          BEGIN
            SchnittgroesseNeuberechnenAudiokomplett;
            Projektgeaendert_setzen(1);
          END;
          IF Erg = -2 THEN
          BEGIN
            IF Text <> '' THEN
              Text := Text + Chr(13);
            Text := Text + Meldunglesen(NIL, 'Meldung111', Oeffnen.Files[I], 'Der Dateityp $Text1# wird nicht unterstützt.');
          END;
          IF Erg = -3 THEN
          BEGIN
            IF Text <> '' THEN
              Text := Text + Chr(13);
            Text := Text + Meldunglesen(NIL, 'Meldung121', Oeffnen.Files[I], 'Die Datei $Text1# ist schon vorhanden.');
          END;
        END;
        Verzeichnismerken(ExtractFileDir(Oeffnen.FileName));
        IF (NOT Assigned(aktAudioknoten)) AND
           Assigned(aktVideoknoten) AND
           (aktVideoknoten.Parent = Knotenpunkt) THEN
        BEGIN
          TRY
            Dateilisteaktualisieren(Knotenpunkt);
          FINALLY
            Fortschrittsfensterverbergen;
          END;
          Schnittpunktanzeigekorrigieren;
        END;
{      END
      ELSE
      BEGIN
        I := Knotenpunkt.Parent.IndexOf(Knotenpunkt);
        IF I = 0 THEN                                            // Videoknoten
        BEGIN
          IF Pos(UpperCase(ExtractFileExt(Oeffnen.FileName)), UpperCase(ArbeitsumgebungObj.DateiendungenVideo)) > 0 THEN
          BEGIN
            Eintrag := TDateieintrag.Create;
            TDateieintrag(Eintrag).Name := Oeffnen.FileName;
            HString := WortVideo + ' -> ' + Oeffnen.FileName;
          END
          ELSE
            Eintrag := NIL;
        END
        ELSE                                                     // Audioknoten
        BEGIN
          IF Pos(UpperCase(ExtractFileExt(Oeffnen.FileName)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) > 0 THEN
          BEGIN
            Eintrag := TDateieintragAudio.Create;
            TDateieintragAudio(Eintrag).Name := Oeffnen.FileName;
            TDateieintragAudio(Eintrag).Audiooffset := 0;
            HString := WortAudio + ' ' + IntToStr(I) + ' -> ' + Oeffnen.FileName;
          END
          ELSE
            Eintrag := NIL;
        END;
        IF Assigned(Eintrag) THEN
        BEGIN
          Knoten := Dateien.Items.InsertObject(Knotenpunkt, HString, Eintrag);
          IF ((Knotenpunkt = aktVideoknoten) OR
             (Knotenpunkt = aktAudioknoten)) THEN
          BEGIN
            Dateilisteaktualisieren(Knoten);
            Schnittpunktanzeigeloeschen;
          END;
          KnotenpunktDatenloeschen(Knotenpunkt);
          Dateien.Items.Delete(Knotenpunkt);
          IF I = 0 THEN                                            // Videoknoten
            SchnittgroesseneuberechnenVideo(Knoten)
          ELSE                                                     // Audioknoten
            SchnittgroesseneuberechnenAudio(Knoten);
          Projektgeaendert_setzen(1);
        END
        ELSE
        BEGIN
          IF Text <> '' THEN
            Text := Text + Chr(13);
          Text := Text + Meldunglesen(NIL, 'Meldung111', Oeffnen.FileName, 'Der Dateityp $Text1# wird nicht unterstützt.');
        END;
      END; }
      IF Text <> '' THEN
        Meldungsfenster(Text, Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      Showmessage(Text);
    END;
//    IF DateienfensterausPanel.Visible THEN
//      Dateien.SetFocus;
  END;
end;

procedure TMpegEdit.DateiaendernClick(Sender: TObject);

VAR Knotenpunkt,
    Knoten : TTreeNode;
    I : Integer;
    HString : STRING;
    Eintrag : Pointer;

begin
  Knotenpunkt := Dateien.Selected;
  IF Assigned(Knotenpunkt) THEN
  BEGIN
    IF Knotenpunkt.Level > 0 THEN
    BEGIN
      IF Knotenpunkt.Parent.IndexOf(Knotenpunkt) = 0 THEN      // Videoknoten
      BEGIN
        Oeffnen.Title := Wortlesen(NIL, 'Dialog11', 'MPEG-2 Videodatei öffnen');
        Oeffnen.Filter := Wortlesen(NIL, 'Dialog12', 'MPEG-2 Videodateien') + '|' + ArbeitsumgebungObj.DateiendungenVideo;
        Oeffnen.DefaultExt := Copy(ArbeitsumgebungObj.StandardEndungenVideo, 2, Length(ArbeitsumgebungObj.StandardEndungenVideo) - 1);
      END
      ELSE                                                     // Audioknoten
      BEGIN
        Oeffnen.Title := Wortlesen(NIL, 'Dialog14', 'Audiodatei öffnen');
        Oeffnen.Filter := Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio;
        Oeffnen.DefaultExt := Copy(ArbeitsumgebungObj.StandardEndungenAudio, 2, Length(ArbeitsumgebungObj.StandardEndungenAudio) - 1);
      END;
      Oeffnen.FileName := '';
      Oeffnen.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.VideoAudioVerzeichnis);
      IF Oeffnen.Execute THEN
      BEGIN
        IF ArbeitsumgebungObj.VideoAudioVerzeichnisspeichern THEN
          ArbeitsumgebungObj.VideoAudioVerzeichnis := ExtractFilePath(Oeffnen.FileName);
        I := Knotenpunkt.Parent.IndexOf(Knotenpunkt);
        IF I = 0 THEN                                            // Videoknoten
        BEGIN
          IF Pos(UpperCase(ExtractFileExt(Oeffnen.FileName)), UpperCase(ArbeitsumgebungObj.DateiendungenVideo)) > 0 THEN
          BEGIN
            Eintrag := TDateieintrag.Create;
            TDateieintrag(Eintrag).Name := Oeffnen.FileName;
            HString := WortVideo + ' -> ' + Oeffnen.FileName;
          END
          ELSE
            Eintrag := NIL;
        END
        ELSE                                                     // Audioknoten
        BEGIN
          IF Pos(UpperCase(ExtractFileExt(Oeffnen.FileName)), UpperCase(ArbeitsumgebungObj.DateiendungenAudio)) > 0 THEN
          BEGIN
            Eintrag := TDateieintragAudio.Create;
            TDateieintragAudio(Eintrag).Name := Oeffnen.FileName;
            TDateieintragAudio(Eintrag).Audiooffset := 0;
            HString := WortAudio + ' ' + IntToStr(I) + ' -> ' + Oeffnen.FileName;
          END
          ELSE
            Eintrag := NIL;
        END;
        IF Assigned(Eintrag) THEN
        BEGIN
          Knoten := Dateien.Items.InsertObject(Knotenpunkt, HString, Eintrag);
          Dateien.Select(Knoten);
          IF ((Knotenpunkt = aktVideoknoten) OR
             (Knotenpunkt = aktAudioknoten)) THEN
          BEGIN
//            Fortschrittsfensteranzeigen;
            TRY
              Dateilisteaktualisieren(Knoten);
            FINALLY
              Fortschrittsfensterverbergen;
            END;
            Schnittpunktanzeigekorrigieren;
          END;
          KnotenpunktDatenloeschen(Knotenpunkt);
          Dateien.Items.Delete(Knotenpunkt);
          IF I = 0 THEN                                            // Videoknoten
            SchnittgroesseneuberechnenVideo(Knoten)
          ELSE                                                     // Audioknoten
            SchnittgroesseneuberechnenAudio(Knoten);
          Projektgeaendert_setzen(1);
        END
        ELSE
          Meldungsfenster(Meldunglesen(NIL, 'Meldung111', Oeffnen.FileName, 'Der Dateityp $Text1# wird nicht unterstützt.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          Showmessage(Meldunglesen(NIL, 'Meldung111', Oeffnen.FileName, 'Der Dateityp $Text1# wird nicht unterstützt.'));
      END;
    END;
    IF Enabled AND DateienfensterausPanel.Visible THEN             // falls die Funktion über Hotkey aufgerufen wurde
      Dateien.SetFocus;
  END;
end;

FUNCTION TMpegEdit.BMPBildlesen(Position: Int64; Weite: Integer; Positionwiederherstellen, IFrame: Boolean): TBitmap;
BEGIN
  Result := Mpeg2Fenster.BMPBildlesen(Position, Weite, Positionwiederherstellen, IFrame);
END;

PROCEDURE TMpegEdit.SchiebereglerPosition_setzen(Pos: Int64; verwendeUndo: Boolean = False);
BEGIN
  IF verwendeUndo THEN                                                          // Q
  BEGIN
      SetUndo(TLongIntUndo.Create(WortLesen(NIL,'Meldung501','Setze Schieberegler'),
                                  SchiebereglerPosition_setzen, SchiebereglerPosition, Pos))
  END;
  SchiebereglerPosition := Pos;
  IF SchiebereglerPosition > SchiebereglerMax THEN
    SchiebereglerPosition := SchiebereglerMax;
  IF SchiebereglerPosition < 0 THEN
    SchiebereglerPosition := 0;
  Schieberegler.Position := Round(SchiebereglerPosition / Schiebereglerfaktor);
  IF NOT AbspielModus THEN
  BEGIN
    IF ArbeitsumgebungObj.Videoeigenschaftenaktualisieren THEN
      InfoaktualisierenVideo;
    IF ArbeitsumgebungObj.Audioeigenschaftenaktualisieren THEN
      InfoaktualisierenAudio;
    Anzeigeaktualisieren(SchiebereglerPosition);
    IF ArbeitsumgebungObj.Videoeigenschaftenaktualisieren OR
       ArbeitsumgebungObj.Audioeigenschaftenaktualisieren THEN
      Eigenschaftenanzeigen;
  END
  ELSE
    Anzeigeaktualisieren(SchiebereglerPosition);
END;

PROCEDURE TMpegEdit.SchiebereglerMax_setzen(Pos: Int64);
BEGIN
  SchiebereglerMax := Pos;
//  IF Pos > 4294967295 THEN
//    Schiebereglerfaktor := Trunc(Pos / 4294967296) + 1
//  IF Pos > 10000 THEN
  IF Pos > Schieberegler.Width - 26 THEN
//    Schiebereglerfaktor := Trunc(Pos / 10000) + 1
//    Schiebereglerfaktor := Round(Pos / 10000)
    Schiebereglerfaktor := Pos / (Schieberegler.Width - 26)
  ELSE
    Schiebereglerfaktor := 1;
  Schieberegler.Max := Round(Pos / Schiebereglerfaktor);
END;

PROCEDURE TMpegEdit.SchiebereglerSelStart_setzen(Pos: Int64);
BEGIN
  Pos := Trunc(Pos / Schiebereglerfaktor);
  IF Pos > Schieberegler.Max THEN
    Pos := Schieberegler.Max;
  Schieberegler.SelStart := Pos;
  IF (Schieberegler.SelEnd = Schieberegler.SelStart + 1) AND
     (Schieberegler.SelStart + 1 < Schieberegler.Max) THEN
    Schieberegler.SelEnd := Schieberegler.SelStart + 2;
END;

PROCEDURE TMpegEdit.SchiebereglerSelEnd_setzen(Pos: Int64);
BEGIN
  IF Trunc(Pos / Schiebereglerfaktor) * Schiebereglerfaktor = Pos THEN
    Pos := Trunc(Pos / Schiebereglerfaktor)
  ELSE
    Pos := Trunc(Pos / Schiebereglerfaktor) + 1;
  IF Pos = Schieberegler.SelStart + 1 THEN
    Pos := Schieberegler.SelStart + 2;
  IF Pos > Schieberegler.Max THEN
    Pos := Schieberegler.Max;
  Schieberegler.SelEnd := Pos;
END;

PROCEDURE TMpegEdit.Schieberegleraktualisieren;
BEGIN
  CASE (Player AND $03) OF
    1 : Player := Player AND $FB;                          // nur Video vorhanden  --> Bit 2 auf 0 setzen
    2 : Player := Player OR 4;                             // nur Audio vorhanden  --> Bit 2 auf 1 setzen
    3 : BEGIN                                              // Video und Audio vorhanden
          IF Bilderzahl >= Trunc((Audiozahl + Audiooffset^) / Bildlaenge) THEN
            Player := Player AND $FB                       // Bit 2 auf 0 setzen
          ELSE
            Player := Player OR 4;                         // Bit 2 auf 1 setzen
        END;
  ELSE
    Player := 0;
    SchiebereglerMax_setzen(1000);
  END;
  IF (Player AND $04) = 4 THEN                             // Audio länger
    SchiebereglerMax_setzen(Trunc((Audiozahl + Audiooffset^) / Bildlaenge) - 1);
  IF (Player AND $05) = 1 THEN                             // Video länger
    SchiebereglerMax_setzen(Bilderzahl - 1);
END;

procedure TMpegEdit.VollbildClick(Sender: TObject);
begin
  IF Vollbild.Checked THEN
  BEGIN
    Vollbild.Checked := False;
    WindowState := wsNormal;
    SetWindowLong(Handle, GWL_Style, GetWindowLong(Handle, GWL_Style) OR FensterStyle AND WS_Caption); // Fensterleiste einblenden
    Menu := Hauptmenue;
    IF ZweiFensterMenuItem.Checked THEN
      Anzeigeflaeche.BevelKind := bkFlat;
    Anzeigeflaeche.Color := ArbeitsumgebungObj.Videohintergrundfarbe;
    Anzeigeflaeche.SetZOrder(False);
    Bildeinpassen(ArbeitsumgebungObj.Videoanzeigefaktor);
  END
  ELSE
  BEGIN
    Vollbild.Checked := True;
    Anzeigeflaeche.SetZOrder(True);
    FensterStyle := GetWindowLong(Handle, GWL_Style);
    Menu := NIL;                       // Menü ausblenden
    SetWindowLong(Handle, GWL_Style, FensterStyle AND NOT WS_Caption); // keine Fensterleiste
    WindowState := wsMaximized;        // Fenster auf maximale Größe
    Anzeigeflaeche.BevelKind := bkNone;
    Anzeigeflaeche.Color := clBlack;
    Anzeigeflaeche.Top := 0;
    Anzeigeflaeche.Left := 0;
    Anzeigeflaeche.Width := ClientWidth;
    Anzeigeflaeche.Height := ClientHeight;
    Maximal.Click;
  END;
end;

PROCEDURE TMpegEdit.Fenstergroesse(Links, Oben, Breite, Hoehe: Integer);
BEGIN
  IF WindowState <> wsMaximized THEN
  BEGIN
    IF Breite < 800 THEN
      Breite := 800;
    IF Hoehe < 600 THEN
      Hoehe := 600;
    IF Breite > Screen.Width THEN
      Breite := Screen.Width;
    IF Hoehe > Screen.Height THEN
      Hoehe := Screen.Height;
    IF Links < 0 THEN
      Links := 0;
    IF Oben < 0 THEN
      Oben := 0;
    IF Links + Breite > Screen.Width THEN
      Links := Screen.Width - Breite;
    IF Oben + Hoehe > Screen.Height THEN
      Oben := Screen.Height - Hoehe;
    IF NOT((Links = Left) AND (Oben = Top) AND (Breite = Width) AND (Hoehe = Height)) THEN
      SetBounds(Links, Oben, Breite, Hoehe);
  END;
END;

PROCEDURE TMpegEdit.Fenstergroesseanpassen(Faktor: Real);

VAR Rand,
    Randoben,
    FensterBreiteNeu,
    FensterHoeheNeu : Integer;
    Seitenverhaeltnis : Real;

BEGIN
  IF (NOT (Faktor = 0)) AND
     (NOT (Sequenzheader = NIL)) AND (NOT(Sequenzheader.Framerate = 0)) AND
     (NOT Vollbild.Checked) THEN
  BEGIN
    CASE Sequenzheader.Seitenverhaeltnis OF
      1: Seitenverhaeltnis := 1;
      2: Seitenverhaeltnis := 3 / 4;
      3: Seitenverhaeltnis := 9 / 16;
      4: Seitenverhaeltnis := 1 / 2.21;
      ELSE
        Seitenverhaeltnis := 3 / 4;
    END;
    Rand := Round((Width - ClientWidth) / 2);
    Randoben := Height - ClientHeight - Rand;
    FensterBreiteNeu := Round((Sequenzheader.BildHoehe / Seitenverhaeltnis) / Faktor) + Listen.Width + Rand + Rand;
    FensterHoeheNeu := Round(Sequenzheader.BildHoehe / Faktor) + ClientHeight - Anzeige.Top + Rand + Randoben;
    IF ArbeitsumgebungObj.Hauptfensteranpassen THEN
      Fenstergroesse(Left, Top, FensterBreiteNeu, FensterHoeheNeu)
    ELSE
      IF (Width < FensterBreiteNeu) OR (Height < FensterHoeheNeu) THEN
      BEGIN
        IF Width > FensterBreiteNeu THEN
          FensterBreiteNeu := Width;
        IF Height > FensterHoeheNeu THEN
          FensterHoeheNeu := Height;
        Fenstergroesse(Left, Top, FensterBreiteNeu, FensterHoeheNeu);
      END;
  END;
END;

procedure TMpegEdit.DoppeltClick(Sender: TObject);
begin
  Doppelt.Checked := True;
  ArbeitsumgebungObj.Videoanzeigefaktor := 0.5;
  Fenstergroesseanpassen(0.5);
  Bildeinpassen(0.5);
end;

procedure TMpegEdit.EinsFuenfzuEinsClick(Sender: TObject);
begin
  EinsFuenfzuEins.Checked := True;
  ArbeitsumgebungObj.Videoanzeigefaktor := 0.75;
  Fenstergroesseanpassen(0.75);
  Bildeinpassen(0.75);
end;

procedure TMpegEdit.EinszuEinsClick(Sender: TObject);
begin
  EinszuEins.Checked := True;
  ArbeitsumgebungObj.Videoanzeigefaktor := 1;
  Fenstergroesseanpassen(1);
  Bildeinpassen(1);
end;

procedure TMpegEdit.EinszuEinsFuenfClick(Sender: TObject);
begin
  EinszuEinsFuenf.Checked := True;
  ArbeitsumgebungObj.Videoanzeigefaktor := 1.5;
  Fenstergroesseanpassen(1.5);
  Bildeinpassen(1.5);
end;

procedure TMpegEdit.EinszuZweiClick(Sender: TObject);
begin
  EinszuZwei.Checked := True;
  ArbeitsumgebungObj.Videoanzeigefaktor := 2;
  Fenstergroesseanpassen(2);
  Bildeinpassen(2);
end;

procedure TMpegEdit.EinszuVierClick(Sender: TObject);
begin
  EinszuVier.Checked := True;
  ArbeitsumgebungObj.Videoanzeigefaktor := 4;
  Fenstergroesseanpassen(4);
  Bildeinpassen(4);
end;

procedure TMpegEdit.MaximalClick(Sender: TObject);
begin
  Maximal.Checked := True;
  ArbeitsumgebungObj.Videoanzeigefaktor := 0;
  Bildeinpassen(0);
end;

PROCEDURE TMpegEdit.Vorschauknotenloeschen;

VAR I : Integer;

BEGIN
  IF Assigned(Vorschauknoten) THEN
  BEGIN
    KnotenpunktDatenloeschen(Vorschauknoten);            // Vorschaudateien löschen
    IF Vorschauknoten.HasChildren THEN
      IF Vorschauknoten.Item[0] = aktVideoknoten THEN
        aktVideoknoten := NIL;
    FOR I := 1 TO Vorschauknoten.Count - 1 DO
      IF Vorschauknoten.Item[I] = aktAudioknoten THEN
        aktAudioknoten := NIL;
    Dateien.Items.Delete(Vorschauknoten);                // Vorschauknoten löschen
    DateienlisteHauptknotenNrneuschreiben;
    Vorschauknoten := NIL;
//    SchiebereglermittePanel.Visible := False;
    Vorschau.Down := FALSE;
    Cutmoeglich(Schiebereglerposition);
    SetPositionIn(VorschauPositionIn);
    SetPositionOut(VorschauPositionOut);
    Marke.Enabled := True;
    ProjektNeuBtn.Enabled := True;
    ProjektLadenBtn.Enabled := True;
    ProjektSpeichernBtn.Enabled := Projekt_geaendert;
    SchiebereglerMarkersetzen(VorschauSchiebereglerMarkerPosition);
  END;
END;

PROCEDURE TMpegEdit.Vorschaubeenden;
BEGIN
  IF Assigned(Vorschauknoten) THEN
  BEGIN
    Pause;
    TRY
      DateilisteaktualisierenVideo(VorschauVideoknoten, False);
      DateilisteaktualisierenAudio(VorschauAudioknoten, False);
    FINALLY
      Fortschrittsfensterverbergen;
    END;
    Vorschauknotenloeschen;
    Protokoll_schreiben('Vorschau beendet');
  END;
END;

procedure TMpegEdit.VorschauClick(Sender: TObject);

VAR I, Fehlernummer,
    aktSpur, HInteger1 : Integer;
    Schnittpunkt,
    Schnittpunktneu : TSchnittpunkt;
    Selektion_gefunden : Boolean;
    VorschauSchnittliste : TStringList;
    HString1, HString2,
    VideoProjekt,
    AudioProjekt : STRING;
    HVideoliste,
    HIndexliste,
    ZVideoListe,
    ZIndexListe : TListe;
    HListenname : STRING;

FUNCTION Schnittanpassen(Schnittpunkt: TSchnittpunkt; Anfang: Boolean = True): Int64;

VAR MpegHeader : TMpeg2Header;
    Videoknoten : TTreeNode;

BEGIN
  IF Anfang THEN
    Result := Schnittpunkt.Anfang                                               // Result auf alten Wert setzen
  ELSE
    Result := Schnittpunkt.Ende;
  IF Assigned(Schnittpunkt) AND Assigned(Schnittpunkt.Videoknoten) THEN
  BEGIN
    IF (Schnittpunkt.Videoknoten.Level = 0) THEN
      IF Schnittpunkt.Videoknoten.HasChildren THEN
        Videoknoten := Schnittpunkt.Videoknoten.Item[0]
      ELSE
        Videoknoten := NIL
    ELSE
      Videoknoten := Schnittpunkt.Videoknoten;
    IF Assigned(Videoknoten) AND Assigned(Videoknoten.Data) THEN
    BEGIN
      IF Assigned(aktVideoknoten) AND Assigned(aktVideoknoten.Data) AND
        (TDateieintrag(Videoknoten.Data).Name = TDateieintrag(aktVideoknoten.Data).Name) THEN
        BEGIN
          ZVideoListe := VideoListe;
          ZIndexListe := Indexliste;
        END
        ELSE
        BEGIN
          ZVideoListe := HVideoListe;
          ZIndexListe := HIndexliste;
          IF (TDateieintrag(Videoknoten.Data).Name <> '') AND
             (TDateieintrag(Videoknoten.Data).Name <> HListenname) THEN
          BEGIN
            HVideoListe.Loeschen;
            HIndexListe.Loeschen;
            HListenname := '';
            MpegHeader := TMpeg2Header.Create;
            TRY
              IF MpegHeader.Dateioeffnen(TDateieintrag(Videoknoten.Data).Name) THEN
              BEGIN
                MpegHeader.Listeerzeugen(HVideoListe, HIndexListe);
                HListenname := TDateieintrag(Videoknoten.Data).Name;
              END;
            FINALLY
              MpegHeader.Free;
            END;
          END;
        END;
      IF ZIndexListe.Count > 0 THEN
        IF Anfang THEN
          Result := VorherigesBild(1, Schnittpunkt.Anfang, ZIndexListe)
        ELSE
          Result := NaechstesBild(2, Schnittpunkt.Ende, ZIndexListe);
    END;
  END;
END;

FUNCTION aktiverAudioname(Schnittpunkt: TSchnittpunkt): STRING;

VAR Audioknoten : TTreeNode;
    Spur: Integer;

BEGIN
  Result := '';
  IF Assigned(Schnittpunkt) AND Assigned(Schnittpunkt.Audioknoten) THEN
  BEGIN
    IF (Schnittpunkt.Audioknoten.Level = 0) THEN
    BEGIN
      Spur := aktAudiospursuchen(Schnittpunkt.Audioknoten, False);
      IF (Spur > 0) AND
         (Schnittpunkt.Audioknoten.Count > Spur) THEN
        Audioknoten := Schnittpunkt.Audioknoten.Item[Spur]
      ELSE
        Audioknoten := NIL;
    END
    ELSE
      Audioknoten := Schnittpunkt.Audioknoten;
    IF Assigned(Audioknoten) AND Assigned(Audioknoten.Data) THEN
      Result := TDateieintragAudio(Audioknoten.Data).Name;
  END;
END;

FUNCTION Dateinamenbilden(Verzeichnis: STRING; Knoten1, Knoten2: TTreeNode;
                          Spur, Anfang1, Ende1, Anfang2, Ende2: Integer): STRING;

VAR HInteger : Integer;
    Dateivorhanden : Boolean;
    Dateiname1,
    Dateiname2,
    Dateiendung : STRING;

BEGIN
  Result := '';
  IF Spur > -1 THEN
  BEGIN
    Dateivorhanden := False;
    IF Assigned(Knoten1) AND (Knoten1.Count > Spur) AND Assigned(Knoten1.Item[Spur].Data) THEN
    BEGIN
      Dateiname1 := ExtractFileName(TDateieintrag(Knoten1.Item[Spur].Data).Name);
      IF Spur = 0 THEN
        Dateiendung := ExtractFileExt(TDateieintrag(Knoten1.Item[Spur].Data).Name)
      ELSE
        Dateiendung := ExtractAudioendung(TDateieintragAudio(Knoten1.Item[Spur].Data).Name);
      IF Dateiname1 <> '' THEN
        Dateivorhanden := True;                                                 // Video1 vorhanden
    END
    ELSE
      Dateiname1 := 'LeerDatei';
    IF Assigned(Knoten2) AND (Knoten2.Count > Spur) AND Assigned(Knoten2.Item[Spur].Data) THEN
    BEGIN
      Dateiname2 := ExtractFileName(TDateieintrag(Knoten2.Item[Spur].Data).Name);
      IF NOT Dateivorhanden THEN
        IF Spur = 0 THEN
          Dateiendung := ExtractFileExt(TDateieintrag(Knoten2.Item[Spur].Data).Name)
        ELSE
          Dateiendung := ExtractAudioendung(TDateieintragAudio(Knoten2.Item[Spur].Data).Name);
      IF Dateiname2 <> '' THEN
        Dateivorhanden := True;                                                 // Video2 vorhanden
    END
    ELSE
      Dateiname2 := 'LeerDatei';
    IF Dateivorhanden THEN                                                      // Datei(en) vorhanden
    BEGIN
      HInteger := Trunc((200 - 15 - Length(Verzeichnis) -                       // 15 Zeichen = Vorschau und 7 x "-"
                         Length(IntToStr(Anfang1)) - Length(IntToStr(Ende1)) -
                         Length(IntToStr(Anfang2)) - Length(IntToStr(Ende2))) / 2);
      Result := Verzeichnis + 'Vorschau-' + RightStr(Dateiname1, HInteger) + '-' +
                IntToStr(Anfang1) + '-' + IntToStr(Ende1) + '--' +
                RightStr(Dateiname2, HInteger) + '-' +
                IntToStr(Anfang2) + '-' + IntToStr(Ende2) + Dateiendung;
    END;
  END;
END;

FUNCTION Projektpruefen(VAR Projektname: STRING): Integer;

VAR Projektdatei : TStringList;

BEGIN
  IF FileExists(Projektname + '.m2e') THEN
  BEGIN
    Projektdatei := TStringList.Create;
    TRY
      Projektdatei.LoadFromFile(Projektname + '.m2e');
      IF (Projektdatei.Count > 0) AND
         (LeftStr(Projektdatei.Strings[Projektdatei.Count - 1], 13) = 'Fehlernummer=') THEN
      BEGIN
        Result := StrToIntDef(KopiereVonBis(Projektdatei.Strings[Projektdatei.Count - 1], '=', ''), -3);
        IF Result > -1 THEN
          IF (Projektdatei.Count > 1) AND
             (LeftStr(Projektdatei.Strings[Projektdatei.Count - 2], 14) = 'Zieldateiname=') THEN
            Projektname := OhneGaensefuesschen(KopiereVonBis(Projektdatei.Strings[Projektdatei.Count - 2], '=', ''))
          ELSE
            Result := -4;
      END
      ELSE
        Result := -2;                                               // Schnitt wurde nicht ausgeführt
    FINALLY
      Projektdatei.Free;
    END;
  END
  ELSE
    Result := -1;
END;

begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  IF Assigned(Vorschauknoten) THEN                      // Vorschau aktiv
  BEGIN
    Vorschaubeenden;                                    // altes Video und Audio zur Anzeige bringen
  END
  ELSE
  BEGIN
    Vorschau.Enabled := False;
    TRY
      Pause;
      Fehlernummer := 0;
      IF (Schnittliste.SelCount > 0) AND (Schnittliste.Items.Count > 1) THEN  // In der Schnittliste muß es mindestens zwei Einträge und eine Markierung geben.
      BEGIN
        Protokoll_schreiben('neue Vorschau erstellen');
//        VorschauIDD_erzeugen := ArbeitsumgebungObj.IndexDateierstellen; // IndexDateierstellen merken
//        ArbeitsumgebungObj.IndexDateierstellen := True;
        HListenname := '';
        VorschauSchnittliste := TStringList.Create;          // Schnittliste erzeugen
        HVideoliste := TListe.Create;                        // Hilfslisten erzeugen
        HIndexliste := TListe.Create;
        TRY
          Selektion_gefunden := False;
          I := 0;
          WHILE (I < Schnittliste.Items.Count) AND (NOT Selektion_gefunden) DO
          BEGIN                                              // erste Markierung suchen
            IF Schnittliste.Selected[I] THEN
              Selektion_gefunden := True
            ELSE
              Inc(I);
          END;
          IF (I = Schnittliste.Items.Count - 1) THEN         // Ist der letzte Eintrag markiert wird
            Dec(I);                                          // beim vorletzten angefangen.
          Schnittpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
          Schnittpunktneu := TSchnittpunkt.Create;           // Neuen Schnittpunkt erzeugen,
          Schnittpunkt_kopieren(Schnittpunkt, Schnittpunktneu);
          IF Schnittpunktneu.VideoEffekt.EndeLaenge > Schnittpunktneu.AudioEffekt.EndeLaenge THEN
            HInteger1 := Schnittpunktneu.VideoEffekt.EndeLaenge  // den längeren Effekt merken
          ELSE
            HInteger1 := Schnittpunktneu.AudioEffekt.EndeLaenge;
          IF ArbeitsumgebungObj.Vorschauerweitern AND
             ((HInteger1 + ArbeitsumgebungObj.VorschaudauerPlus * 1000) >
              (ArbeitsumgebungObj.Vorschaudauer1 * 1000)) THEN
            Schnittpunktneu.Anfang := Schnittpunkt.Ende -
                                      Round(((HInteger1 / 1000) +
                                      ArbeitsumgebungObj.VorschaudauerPlus) *
                                      Schnittpunkt.Framerate) // neuen Anfangspunkt berechnen
          ELSE
            Schnittpunktneu.Anfang := Schnittpunkt.Ende -
                                      Round(ArbeitsumgebungObj.Vorschaudauer1 *
                                      Schnittpunkt.Framerate); // neuen Anfangspunkt berechnen
          IF NOT ArbeitsumgebungObj.Vorschauerweitern THEN
          BEGIN
            IF Schnittpunktneu.VideoEffekt.EndeLaenge > ArbeitsumgebungObj.Vorschaudauer1 * 1000 THEN  // Effekte wenn nötig verkürzen
              Schnittpunktneu.VideoEffekt.EndeLaenge := ArbeitsumgebungObj.Vorschaudauer1 * 1000;
            IF Schnittpunktneu.AudioEffekt.EndeLaenge > ArbeitsumgebungObj.Vorschaudauer1 * 1000 THEN
              Schnittpunktneu.AudioEffekt.EndeLaenge := ArbeitsumgebungObj.Vorschaudauer1 * 1000;
          END;
//          Sartzeitsetzen;
          IF Schnittpunktneu.Anfang < Schnittpunkt.Anfang THEN
            Schnittpunktneu.Anfang := Schnittpunkt.Anfang;
          Schnittpunktneu.Anfang := Schnittanpassen(Schnittpunktneu); // Anfangsschnittpunkt auf vorheriges I-Frame ändern
//          Showmessage(IntTostr(Zeitdauerlesen_microSek));
          Schnittpunktneu.VideoEffekt.AnfangLaenge := 0;     // Anfangseffekte löschen
          Schnittpunktneu.AudioEffekt.AnfangLaenge := 0;
//          Schnittpunktneu.Anfangberechnen := 128;            // nicht framgenau berechen
          Schnittpunktneu.Endeberechnen := 0;
          Schnittpunktneu.VideoGroesse := SchnittgroesseberechnenVideoaktiv(ZVideoListe, ZIndexListe, Schnittpunktneu.Anfang, Schnittpunktneu.Ende);
          Schnittpunktneu.AudioGroesse := SchnittgroesseberechnenAudio(aktiverAudioname(Schnittpunktneu), Schnittpunktneu.Anfang, Schnittpunktneu.Ende, (1000 / Schnittpunktneu.Framerate));
          VorschauSchnittliste.AddObject('', Schnittpunktneu);  // zur VorschauSchnittliste hinzufügen.
          Inc(I);
          Schnittpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
          Schnittpunktneu := TSchnittpunkt.Create;           // Zweiten Schnittpunkt erzeugen,
          Schnittpunkt_kopieren(Schnittpunkt, Schnittpunktneu);
          IF Schnittpunktneu.VideoEffekt.AnfangLaenge > Schnittpunktneu.AudioEffekt.AnfangLaenge THEN
            HInteger1 := Schnittpunktneu.VideoEffekt.AnfangLaenge
          ELSE
            HInteger1 := Schnittpunktneu.AudioEffekt.AnfangLaenge;
          IF ArbeitsumgebungObj.Vorschauerweitern AND
             ((HInteger1 + ArbeitsumgebungObj.VorschaudauerPlus * 1000) >
              (ArbeitsumgebungObj.Vorschaudauer2 * 1000)) THEN
            Schnittpunktneu.Ende := Schnittpunkt.Anfang +
                                    Round(((HInteger1 / 1000) +
                                    ArbeitsumgebungObj.VorschaudauerPlus) *
                                    Schnittpunkt.Framerate) // neuen Endepunkt berechnen
          ELSE
            Schnittpunktneu.Ende := Schnittpunkt.Anfang +
                                    Round(ArbeitsumgebungObj.Vorschaudauer2 *
                                    Schnittpunkt.Framerate); // neuen Endepunkt berechnen
          IF NOT ArbeitsumgebungObj.Vorschauerweitern THEN
          BEGIN
            IF Schnittpunktneu.VideoEffekt.AnfangLaenge > ArbeitsumgebungObj.Vorschaudauer2 * 1000 THEN  // Effekte wenn nötig verkürzen
              Schnittpunktneu.VideoEffekt.AnfangLaenge := ArbeitsumgebungObj.Vorschaudauer2 * 1000;
            IF Schnittpunktneu.AudioEffekt.AnfangLaenge > ArbeitsumgebungObj.Vorschaudauer2 * 1000 THEN
              Schnittpunktneu.AudioEffekt.AnfangLaenge := ArbeitsumgebungObj.Vorschaudauer2 * 1000;
          END;
//          Sartzeitsetzen;
          IF Schnittpunktneu.Ende > Schnittpunkt.Ende THEN
            Schnittpunktneu.Ende := Schnittpunkt.Ende;
          Schnittpunktneu.Ende := Schnittanpassen(Schnittpunktneu, False); // Endeschnittpunkt auf nächstes I- oder P-Frame ändern
//          Showmessage(IntTostr(Zeitdauerlesen_microSek));
          Schnittpunktneu.Anfangberechnen := 0;
          Schnittpunktneu.VideoEffekt.EndeLaenge := 0;         // Endeeffekte löschen
          Schnittpunktneu.AudioEffekt.EndeLaenge := 0;
//          Schnittpunktneu.Endeberechnen := 128;              // nicht framgenau berechen
          Schnittpunktneu.VideoGroesse := SchnittgroesseberechnenVideoaktiv(ZVideoListe, ZIndexListe, Schnittpunktneu.Anfang, Schnittpunktneu.Ende);
          Schnittpunktneu.AudioGroesse := SchnittgroesseberechnenAudio(aktiverAudioname(Schnittpunktneu), Schnittpunktneu.Anfang, Schnittpunktneu.Ende, (1000 / Schnittpunktneu.Framerate));
          VorschauSchnittliste.AddObject('', Schnittpunktneu);  // zur VorschauSchnittliste hinzufügen.
          IF DateigeoeffnetVideo(TSchnittpunkt(VorschauSchnittliste.Objects[0]).Videoknoten) OR
             DateigeoeffnetVideo(TSchnittpunkt(VorschauSchnittliste.Objects[1]).Videoknoten) THEN
          BEGIN
            Videoabspieler_freigeben;                          // aktuelle Dateien freigeben
            Protokoll_schreiben('Videodateien freigegeben');
          END
          ELSE
            Protokoll_schreiben('Videodateien nicht geöffnet');
          aktSpur := aktAudiospursuchen(TSchnittpunkt(VorschauSchnittliste.Objects[0]).Audioknoten, False);
          IF aktSpur < 0 THEN
            aktSpur := aktAudiospursuchen(TSchnittpunkt(VorschauSchnittliste.Objects[1]).Audioknoten);
          IF DateigeoeffnetAudio(TSchnittpunkt(VorschauSchnittliste.Objects[0]).Audioknoten, aktSpur) OR
             DateigeoeffnetAudio(TSchnittpunkt(VorschauSchnittliste.Objects[1]).Audioknoten, aktSpur) THEN
          BEGIN
            AudioPlayerClose;                                  // aktuelle Dateien freigeben
          END;
          IF DateienlisteVideopruefen(VorschauSchnittliste) < 0 THEN
            Fehlernummer := -1;
          IF DateienlisteAudiopruefen(VorschauSchnittliste) < 0 THEN
            Fehlernummer := Fehlernummer + -2;
          TRY
            HInteger1 := 0;
            IF Fehlernummer > -1 THEN
            BEGIN
              HString1 := DateinameausKnoten(TSchnittpunkt(VorschauSchnittliste.Objects[0]).Videoknoten, NIL);
              IF HString1 = '' THEN
                HString1 := DateinameausKnoten(TSchnittpunkt(VorschauSchnittliste.Objects[1]).Videoknoten, NIL);
              IF HString1 = '' THEN
                HString1 := DateinameausKnoten(NIL, TSchnittpunkt(VorschauSchnittliste.Objects[0]).Audioknoten);
              IF HString1 = '' THEN
                HString1 := DateinameausKnoten(NIL, TSchnittpunkt(VorschauSchnittliste.Objects[1]).Audioknoten);
              IF Projektname = '' THEN
                HString2 := HString1
              ELSE
                HString2 := ChangeFileExt(Projektname, '');
              HString1 := VariablenersetzenText(ArbeitsumgebungObj.VorschauVerzeichnis, ['$VideoName#', ExtractFileName(HString1), '$ProjectName#', ExtractFileName(HString2),
                                                                                         '$VideoDirectory#', ExtractFilePath(HString1), '$ProjectDirectory#', ExtractFilePath(HString2)]);
              HString1 := VariablenentfernenText(HString1);
              HString1 := doppeltePathtrennzeichen(HString1);
              Verzeichniserstellen(HString1);
              VideoProjekt := Dateinamenbilden(HString1,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[0]).Videoknoten,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[1]).Videoknoten,
                                           0,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[0]).Anfang,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[0]).Ende,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[1]).Anfang,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[1]).Ende);
              IF VideoProjekt <> '' THEN
                IF (NOT FileExists(VideoProjekt)) OR Vorschauneuberechnen OR ArbeitsumgebungObj.VorschauImmerberechnen THEN
                BEGIN
                  // weitere Prüfung ob neu berechnet werden muß anhand des Projektes
                  DeleteFile(VideoProjekt);
                  DeleteFile(VideoProjekt + '.m2e');
                  ProjektinDateispeichern(VideoProjekt + '.m2e', VorschauSchnittliste, False, 0);
                  HInteger1 := 1;
                END
                ELSE
                BEGIN
                  Protokoll_schreiben('Vorschaudatei ' + VideoProjekt + ' existierte bereits');
                END;
              AudioProjekt := Dateinamenbilden(HString1,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[0]).Audioknoten,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[1]).Audioknoten,
                                           aktSpur,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[0]).Anfang,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[0]).Ende,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[1]).Anfang,
                                           TSchnittpunkt(VorschauSchnittliste.Objects[1]).Ende);
              IF AudioProjekt <> '' THEN
                IF (NOT FileExists(AudioProjekt)) OR Vorschauneuberechnen OR ArbeitsumgebungObj.VorschauImmerberechnen THEN
                BEGIN
                  // weitere Prüfung ob neu berechnet werden muß anhand des Projektes
                  DeleteFile(AudioProjekt);
                  DeleteFile(AudioProjekt + '.m2e');
                  ProjektinDateispeichern(AudioProjekt + '.m2e', VorschauSchnittliste, False, aktSpur);
                  HInteger1 := HInteger1 + 2;
                END
                ELSE
                BEGIN
                  Protokoll_schreiben('Vorschaudatei ' + AudioProjekt + ' existierte bereits');
                END;
              IF HInteger1 > 0 THEN                                             //Vorschau muß neu berechnet werden
              BEGIN
                AllesEinAusschalten(False);
                Fortschrittsfensteranzeigen;
                Fortschrittsfenster.Fortschrittstext.Caption := 'Vorschau berechnen';
                HString1 := ExtractFilePath(Application.ExeName) + 'SchnittTool.exe';   // SchnittTool
                IF (HInteger1 AND 1) = 1 THEN
                  HString1 := HString1 + ' "' + VideoProjekt + '.m2e"';                 // Videoprojekt einfügen
                IF (HInteger1 AND 2) = 2 THEN
                  HString1 := HString1 + ' "' + AudioProjekt + '.m2e"';                 // Audioprojekt einfügen
                HString1 := HString1 + ' /C /E /NS';                                    // SchnittTool sofort starten und nach dem Schnitt schließen und verstecken
                IF Assigned(ArbeitsumgebungObj) THEN
                BEGIN
                  HString1 := HString1 + ' /PP "';                                      // SchnittToolgröße und Position (ProgrammPosition)
                  IF ArbeitsumgebungObj.SchnittToolFensterBreite > Width THEN
                    IF ArbeitsumgebungObj.SchnittToolFensterHoehe > Height THEN
                      HString1 := HString1 + IntToStr(Left) + ', ' + IntToStr(Top) + ', ' + IntToStr(Width) + ', ' + IntToStr(Height) + '"'
                    ELSE
                      HString1 := HString1 + IntToStr(Left) + ', ' +
                                           IntToStr((Height - ArbeitsumgebungObj.SchnittToolFensterHoehe) DIV 2 + Top) + ', ' +
                                           IntToStr(Width) + ', ' +
                                           IntToStr(ArbeitsumgebungObj.SchnittToolFensterHoehe) + '"'
                  ELSE
                    IF ArbeitsumgebungObj.SchnittToolFensterHoehe > Height THEN
                      HString1 := HString1 + IntToStr((Width - ArbeitsumgebungObj.SchnittToolFensterBreite) DIV 2 + Left) + ', ' +
                                           IntToStr(Top) + ', ' +
                                           IntToStr(ArbeitsumgebungObj.SchnittToolFensterBreite) + ', ' +
                                           IntToStr(Height) + '"'
                    ELSE
                      HString1 := HString1 + IntToStr((Width - ArbeitsumgebungObj.SchnittToolFensterBreite) DIV 2 + Left) + ', ' +
                                           IntToStr((Height - ArbeitsumgebungObj.SchnittToolFensterHoehe) DIV 2 + Top) + ', ' +
                                           IntToStr(ArbeitsumgebungObj.SchnittToolFensterBreite) + ', ' +
                                           IntToStr(ArbeitsumgebungObj.SchnittToolFensterHoehe) + '"';
                END;
                IF Unterprogramm_starten(HString1, Programmschliessen, True) THEN       // SchnittTool aufrufen
                BEGIN                                                                   // SchnittTool erfolgreich aufgerufen
                  Fehlernummer := 10000;                                                // Fehler vorgeben
                  IF VideoProjekt <> '' THEN
                    Fehlernummer := Projektpruefen(VideoProjekt);
                  IF Fehlernummer > -1 THEN
                    IF AudioProjekt <> '' THEN
                      Fehlernummer := Projektpruefen(AudioProjekt);
                  IF Fehlernummer = 10000 THEN
                    Fehlernummer := -1;                                                 // kein Projekt vorhanden
                END
                ELSE
                  Fehlernummer := -1;                                                   // Fehler beim aufrufen des SchnittTools
                BringToFront;
                AllesEinAusschalten;
              END;
            END;
            IF Fehlernummer > -1 THEN
            BEGIN
              IF FileExists(VideoProjekt) OR                       // Videovorschaudatei ist vorhanden
                 FileExists(AudioProjekt) THEN                     // Audiovorschaudatei ist vorhanden
              BEGIN
                VorschauVideoknoten := aktVideoknoten;             // aktuellen Videoknoten merken
                VorschauAudioknoten := aktAudioknoten;             // aktuellen Audioknoten merken
                VorschauListe := VideoListe;                       // Alle Listen und Header in
                VideoListe := TListe.Create;                       // VorschauListen und -Header speichern
                VorschauIndexListe := IndexListe;                  // und neue
                IndexListe := TListe.Create;                       // Listen und Header erzeugen.
                VorschauAudioListe := AudioListe;
                AudioListe := TListe.Create;
                VorschauSequenzHeader := SequenzHeader;
                SequenzHeader := TSequenzHeader.Create;
                VorschauBildHeader := BildHeader;
                BildHeader := TBildHeader.Create;
                VorschauAudioHeader := AudioHeader;
                AudioHeader := TAudioHeader.Create;
                VorschauPosition := SchiebereglerPosition;
                VorschauPositionIn := PositionIn;
                VorschauPositionOut := PositionOut;
                VorschauSchiebereglerMarkerPosition := SchiebereglerMarkerPosition;
                SetPositionIn(0);
                SetPositionOut(0);
                GehezuIn.Enabled := False;
                GehezuOut.Enabled := False;
                Schnittuebernehmen.Enabled := False;
  //              Kapitel.Enabled := False;                         // erledigt Cutmöglich
                Marke.Enabled := False;
                ProjektNeuBtn.Enabled := False;
                ProjektLadenBtn.Enabled := False;
                ProjektSpeichernBtn.Enabled := False;
  //              SchiebereglerSelStart_setzen(0);
  //              SchiebereglerSelEnd_setzen(0);
                SchiebereglerMarkersetzen(Round((TSchnittpunkt(VorschauSchnittliste.Objects[0]).Ende - TSchnittpunkt(VorschauSchnittliste.Objects[0]).Anfang + 1) *
                                         9999 / ((TSchnittpunkt(VorschauSchnittliste.Objects[0]).Ende - TSchnittpunkt(VorschauSchnittliste.Objects[0]).Anfang + 1) +
                                         (TSchnittpunkt(VorschauSchnittliste.Objects[1]).Ende - TSchnittpunkt(VorschauSchnittliste.Objects[1]).Anfang))));
  //              SchiebereglermittePanel.Visible := True;
  //              Vorschau.Font.Style := [fsBold,fsUnderline];
                Vorschau.Down := True;                             // für alle Fälle
                IF VideoProjekt <> '' THEN
                BEGIN
                  Vorschauknoten := DateienlisteEintrageinfuegenVideo(NIL, VideoProjekt);
                  Protokoll_schreiben('Videoknoten eingefügt');
                END
                ELSE
                  Vorschauknoten := NIL;
                IF AudioProjekt <> '' THEN
                BEGIN
                  Vorschauknoten := DateienlisteEintrageinfuegenAudio(Vorschauknoten, AudioProjekt, 0, aktSpur);
                  Protokoll_schreiben('Audioknoten eingefügt');
                END;
                IF Assigned(Vorschauknoten) AND (Vorschauknoten.Level > 0) THEN
                  Vorschauknoten := Vorschauknoten.Parent;
                Dateilisteaktualisieren(Vorschauknoten, False);
                SchiebereglerPosition_setzen(0);
                Play.Down := True;
                Play.Click;
              END
              ELSE
                Fehlernummer := -5;
            END;
          FINALLY
            Fortschrittsfensterverbergen;
          END;
        FINALLY
          FOR I := 0 TO VorschauSchnittliste.Count - 1 DO
            VorschauSchnittliste.Objects[I].Free;            // den Inhalt der Schnittliste freigeben
          VorschauSchnittliste.Free;                         // die Schnittliste freigeben
          HVideoliste.Free;
          HIndexliste.Free;
//          ArbeitsumgebungObj.IndexDateierstellen := VorschauIDD_erzeugen;
        END;
      END
      ELSE
        Vorschau.Down := False;
      Vorschauneuberechnen := False;
      IF Fehlernummer < 0 THEN
      BEGIN
        Protokoll_schreiben(Wortlesen(NIL, 'Meldung142', 'Fehler beim erstellen der Vorschau.') + ' ' +
                            Wortlesen(NIL, 'Fehlercode', 'Fehlercode') + ': ' + IntToStr(Fehlernummer));
        Vorschau.Down := False;
        Hinweisanzeigen(Wortlesen(NIL, 'Meldung142', 'Fehler beim erstellen der Vorschau.') + ' ' +
                        Wortlesen(NIL, 'Fehlercode', 'Fehlercode') + ': ' + IntToStr(Fehlernummer),
                        ArbeitsumgebungObj.Hinweisanzeigedauer, True, True);
        IF Assigned(aktVideoknoten) AND
           Assigned(aktVideoknoten.Data) THEN
          VideoDateiaktualisieren(TDateieintrag(aktVideoknoten.Data).Name, VideoListe, IndexListe,
                                  SequenzHeader, BildHeader);
        IF Assigned(aktAudioknoten) AND
           Assigned(aktAudioknoten.Data) THEN
          Audiodateiaktualisieren(TDateieintragAudio(aktAudioknoten.Data).Name, AudioListe, AudioHeader);
        SchiebereglerPosition_setzen(SchiebereglerPosition);
        // Video und Audio wieder laden
      END;
    FINALLY
      Vorschau.Enabled := True;
    END;
  END;
end;

procedure TMpegEdit.VorschaumenuePopup(Sender: TObject);
begin
  IF Assigned(Vorschauknoten) THEN
    Vorschau_beenden.Enabled := True
  ELSE
    Vorschau_beenden.Enabled := False;
  IF (Schnittliste.SelCount > 0) AND (Schnittliste.Items.Count > 1) THEN
    Vorschau_neu.Enabled := True
  ELSE
    Vorschau_neu.Enabled := False;
end;

procedure TMpegEdit.Vorschau_beendenClick(Sender: TObject);
begin
  Vorschaubeenden;
end;

procedure TMpegEdit.Vorschau_neuClick(Sender: TObject);
begin
  Vorschauneuberechnen := True;
  Vorschau_beenden.Click;
  Vorschau.Click;
end;

procedure TMpegEdit.SchnittlisteMenuePopup(Sender: TObject);
begin
  Pause;
  IF SchnittListe.Items.Count = 0 THEN
  BEGIN
    MarkierteSchnittpunkteloeschen.Enabled := False;
    Schnittlisteloeschen.Enabled := False;
    Projektspeichernspezial1.Enabled := False;
    Markierungenaufheben1.Enabled := False;
    Schnittpunktformatanpassen.Enabled := False;
    SchnittpktAnfangkopieren.Enabled := False;
    SchnittpktEndekopieren.Enabled := False;
    VideoEffekt.Enabled := False;
    AudioEffekt.Enabled := False;
  END
  ELSE
  BEGIN
    IF SchnittListe.SelCount = 0 THEN
    BEGIN
      MarkierteSchnittpunkteloeschen.Enabled := False;
      Markierungenaufheben1.Enabled := False;
      IF MarkierteSchnittpunktespeichern.Checked THEN
        Projektspeichernspezial1.Enabled := False
      ELSE
        Projektspeichernspezial1.Enabled := True;
      SchnittpktAnfangkopieren.Enabled := False;
      SchnittpktEndekopieren.Enabled := False;
      VideoEffekt.Enabled := False;
      AudioEffekt.Enabled := False;
    END
    ELSE
    BEGIN
      MarkierteSchnittpunkteloeschen.Enabled := True;
      Markierungenaufheben1.Enabled := True;
      Projektspeichernspezial1.Enabled := True;
{      IF (SchnittListe.ItemIndex > -1) AND
          Assigned(aktVideoknoten) AND
         (TSchnittpunkt(SchnittListe.Items.Objects[SchnittListe.ItemIndex]).Videoknoten = aktVideoknoten.Parent) THEN
        SchnittpktAnfangkopieren.Enabled := True
      ELSE
        SchnittpktAnfangkopieren.Enabled := False;    }
      SchnittpktAnfangkopieren.Enabled := True;
      SchnittpktEndekopieren.Enabled := True;
      VideoEffekt.Enabled := True;
      AudioEffekt.Enabled := True;
    END;
    Schnittlisteloeschen.Enabled := True;
    Schnittpunktformatanpassen.Enabled := True;
  END;
{  IF (Dateien.Items.Count > 0) OR (Schnittliste.Items.Count > 0) OR (KapitelListeGrid.Tag > 1) THEN
  BEGIN
    IF Projekt_geaendert THEN
      Projektspeichern1.Enabled := True
    ELSE
      Projektspeichern1.Enabled := False;
    ProjektEinfuegen1.Enabled := True;
    Projektspeichernunter1.Enabled := True;
    ProjektspeichernPlus1.Enabled := True;
  END
  ELSE
  BEGIN
    ProjektEinfuegen1.Enabled := False;
    Projektspeichern1.Enabled := False;
    Projektspeichernunter1.Enabled := False;
    ProjektspeichernPlus1.Enabled := False;
  END;  }
  IF Assigned(aktVideoknoten) THEN
    Schnittlisteimportieren.Enabled := True
  ELSE
    Schnittlisteimportieren.Enabled := False;
  IF Dateien.Items.Count > 0 THEN
    SchnitteausDateienMenuItem.Enabled := True
  ELSE
    SchnitteausDateienMenuItem.Enabled := False;
end;

procedure TMpegEdit.Projektspeichern_Click(Sender: TObject);
begin
  Pause;
  IF ((Dateien.Items.Count > 0) OR
      (Schnittliste.Items.Count > 0) OR
      (KapitelListeGrid.Tag > 1)) AND
     (NOT Assigned(Vorschauknoten)) THEN
  BEGIN
    IF Projekt_geaendert THEN
      Projektspeichern.Enabled := True
    ELSE
      Projektspeichern.Enabled := False;
    Projektspeichernunter.Enabled := True;
    ProjektspeichernPlus.Enabled := True;
    IF SchnittListe.Items.Count = 0 THEN
      Projektspeichernspezial.Enabled := False
    ELSE
      IF SchnittListe.SelCount = 0 THEN
        IF MarkierteSchnittpunktespeichern.Checked THEN
          Projektspeichernspezial.Enabled := False
        ELSE
          Projektspeichernspezial.Enabled := True
      ELSE
        Projektspeichernspezial.Enabled := True;
  END
  ELSE
  BEGIN
    Projektspeichern.Enabled := False;
    Projektspeichernunter.Enabled := False;
    ProjektspeichernPlus.Enabled := False;
    Projektspeichernspezial.Enabled := False;
  END;
end;

PROCEDURE TMpegEdit.Ausgabe(AusgabeListe, KapitelListe: TStrings);
{
VAR I, J, K, L,
    VarZahl,
    VarZaehler : Integer;
    BilderProSek : Real;
    AusgabeDaten : TAusgabeDaten;
    HProgrammname,
    HAusgabedatei,
    HParameterdatei,
    HProgrammParameter,
    HVideoname,
    HVideoverzeichnis,
    HProjektname,
    HProjektverzeichnis : STRING;
    Variablen : ARRAY OF STRING;  }

BEGIN
{  IF ArbeitsumgebungObj.Ausgabebenutzen AND
     Assigned(ArbeitsumgebungObj.MuxerListe) AND
     (ArbeitsumgebungObj.MuxerIndex > 0) AND
     (ArbeitsumgebungObj.MuxerIndex < ArbeitsumgebungObj.MuxerListe.Count) AND
     Assigned(TProgramme(ArbeitsumgebungObj.MuxerListe.Objects[ArbeitsumgebungObj.MuxerIndex]).Programmdaten) AND
     (AusgabeListe.Count > 0) THEN
  BEGIN
//    IF Pos('VideoFile', AusgabeListe.Strings[0]) = 1 THEN
//    BEGIN
      AusgabeDaten := TProgramme(ArbeitsumgebungObj.MuxerListe.Objects[ArbeitsumgebungObj.MuxerIndex]).Programmdaten;
      I := 0;
      J := 0;
      REPEAT
        HVideoname := ChangeFileExt(ExtractfileName(KopiereVonBis(AusgabeListe.Strings[I], '=', '', False, False)), '');
        HVideoverzeichnis := ExtractFileDir(KopiereVonBis(AusgabeListe.Strings[I], '=', '', False, False));
        IF Projektname = '' THEN
        BEGIN
          HProjektname := HVideoname;
          HProjektverzeichnis := HVideoverzeichnis;
        END
        ELSE
        BEGIN
          HProjektname := ChangeFileExt(ExtractfileName(Projektname), '');
          HProjektverzeichnis := ExtractFileDir(Projektname);
        END;
        HAusgabedatei := VariablenersetzenText(AusgabeDaten.Parameter, ['$VideoName#', HVideoname, '$VideoDirectory#', HVideoverzeichnis, '$ProjectName#', HProjektname, '$ProjectDirectory#', HProjektverzeichnis, '$TempDirectory#', ohnePathtrennzeichen(ArbeitsumgebungObj.Zwischenverzeichnis)]);
        HParameterdatei := VariablenersetzenText(AusgabeDaten.ParameterDateiName, ['$VideoName#', HVideoname, '$VideoDirectory#', HVideoverzeichnis, '$ProjectName#', HProjektname, '$ProjectDirectory#', HProjektverzeichnis]);
        HProgrammName := VariablenersetzenText(AusgabeDaten.ProgrammName, ['$VideoName#', HVideoname, '$VideoDirectory#', HVideoverzeichnis, '$ProjectName#', HProjektname, '$ProjectDirectory#', HProjektverzeichnis, '$TempDirectory#', ohnePathtrennzeichen(ArbeitsumgebungObj.Zwischenverzeichnis), '$ParameterFile#', HParameterdatei]);
        K := 0;
        IF Pos('VideoFile', AusgabeListe.Strings[I]) = 1 THEN
          Inc(K);                               // Videodatei vorhanden
        WHILE ((I + K) < AusgabeListe.Count) AND (Pos('AudioFile', AusgabeListe.Strings[I + K]) = 1)  DO
          Inc(K);                               // Anzahl der Audiodateien bestimmen
        L := 0;
        SetLength(Variablen, L + (K * 2));
        WHILE L < High(Variablen) DO            // Variablen mit Video- und Audiodaten füllen
        BEGIN
          Variablen[L] := '$' + KopiereVonBis(AusgabeListe.Strings[I], '', '=', False, False) + '#';
          Inc(L);
          Variablen[L] := KopiereVonBis(AusgabeListe.Strings[I], '=', '', False, False);
          Inc(L);
          Inc(I);
        END;
        K := 0;
        Inc(J);                                 // "VideoFile=..." wird nicht benutzt
        IF (J < KapitelListe.Count) AND
           (KopiereVonBis(KapitelListe.Strings[J], '', '=', False, False) = 'BilderProSek') THEN
          BilderProSek := StrToFloatDef(KopiereVonBis(KapitelListe.Strings[J], '=', '', False, False), 25)
        ELSE
          BilderProSek := 25;
        Inc(J);
        WHILE ((J + K) < KapitelListe.Count) AND (Pos('Chapter', KapitelListe.Strings[J + K]) = 1)  DO
          Inc(K);                               // Anzahl der Kapitel bestimmen
        L := High(Variablen) + 1;
        IF K > 0 THEN
          SetLength(Variablen, L + K * 2);
        WHILE L < High(Variablen) DO            // Variablen mit Kapiteldaten füllen
        BEGIN
          Variablen[L] := '$' + KopiereVonBis(KapitelListe.Strings[J], '', '=', False, False) + '#';
          Inc(L);
          Variablen[L] := KopiereVonBis(KapitelListe.Strings[J], '=', '', False, False);
          Inc(L);
          Inc(J);
        END;
        L := High(Variablen) + 1;
        SetLength(Variablen, L + 7 * 2);
        Variablen[L + 0] := '$VideoName#';
        Variablen[L + 1] := HVideoname;
        Variablen[L + 2] := '$ProjectName#';
        Variablen[L + 3] := HProjektname;
        Variablen[L + 4] := '$ParameterFile#';
        Variablen[L + 5] := HParameterdatei;
        Variablen[L + 6] := '$OutputFile#';
        Variablen[L + 7] := HAusgabedatei;
        Variablen[L + 8] := '$VideoDirectory#';
        Variablen[L + 9] := HVideoverzeichnis;
        Variablen[L + 10] := '$ProjectDirectory#';
        Variablen[L + 11] := HProjektverzeichnis;
        Variablen[L + 12] := '$TempDirectory#';
        Variablen[L + 13] := ohnePathtrennzeichen(ArbeitsumgebungObj.Zwischenverzeichnis);
        VarZaehler := High(Variablen) + 1;
        VarZahl := VariablenausText(AusgabeDaten.Parameter, '=', ';', Variablen, VarZaehler);
        SetLength(Variablen, VarZaehler + VarZahl * 2);
        VariablenausText(AusgabeDaten.Parameter, '=', ';', Variablen, VarZaehler);
        HProgrammParameter := VariablenersetzenText(AusgabeDaten.ProgrammParameter, Variablen, '', '', BilderProSek);
        HProgrammParameter := VariablenentfernenText(HProgrammParameter);
        VariablenersetzenDatei(AusgabeDaten.OrginalparameterDatei, HParameterdatei, Variablen, '', '', BilderProSek);
        VariablenentfernenDatei(HParameterdatei);
        Finalize(Variablen);
        IF (HProgrammname <> '') AND FileExists(HProgrammname) THEN
          IF I < AusgabeListe.Count THEN
            Unterprogramm_starten(HProgrammname + ' ' + HProgrammParameter, True)
          ELSE
            Unterprogramm_starten(HProgrammname + ' ' + HProgrammParameter, False);
      UNTIL I >= AusgabeListe.Count;
//    END;
  END;    }
END;

procedure TMpegEdit.ZusatzFunktionenmenueClick(Sender: TObject);
begin
  Pause;
  IF Assigned(aktVideoknoten) AND Assigned(aktVideoknoten.Data) THEN
  BEGIN
    Schnittesuchen.Enabled := True;
    aktuellesBildspeichern.Enabled := True;
    aktuellesBildkopieren.Enabled := True;
    FilmGrobansichtMenuItem.Enabled := True;
  END
  ELSE
  BEGIN
    Schnittesuchen.Enabled:=False;
    aktuellesBildspeichern.Enabled := False;
    aktuellesBildkopieren.Enabled := False;
    FilmGrobansichtMenuItem.Enabled := False;
  END;
  IF Assigned(aktAudioKnoten) AND Assigned(aktAudioKnoten.Data) THEN
    aktAudioFramespeichern.Enabled := True
  ELSE
    aktAudioFramespeichern.Enabled := False;
end;

procedure TMpegEdit.SchnittesuchenClick(Sender: TObject);

VAR Schnittliste : TListe;
//    Fehler : Byte;
    audioPos : Int64;

begin
  audioPos := AudioplayerPosition_holen;    // Audioposition merken
  AudioPlayerClose;
  Schnittliste := TListe.Create;
  TRY
    SchnittsucheFenster.Schnittliste := Schnittliste;
    SchnittsucheFenster.Indexliste := Indexliste;
    SchnittsucheFenster.Liste:=VideoListe;
    SchnittsucheFenster.BilderProsek := BilderProsek;
    SchnittsucheFenster.AktuelleBildnummer := Videobildposition;
    IF Assigned(aktVideoknoten) AND
       Assigned(aktVideoknoten.Data)  THEN
       SchnittsucheFenster.VideoDateiname := PChar(TDateieintrag(aktVideoknoten.Data).Name)
    ELSE
       SchnittsucheFenster.VideoDateiname := NIL;
    IF Assigned(aktAudioknoten) AND
       Assigned(aktAudioknoten.Data)  THEN
       SchnittsucheFenster.AudiodateiName := PChar(TDateieintragAudio(aktAudioknoten.Data).Name)
    ELSE
       SchnittsucheFenster.AudiodateiName := NIL;
    Dialogaktiv := True;
    CloseMpeg2File;
    SchnittsucheFenster.Starten;
//    Fehler := SchnittsucheFenster.Starten;  // für die Zukunft, wird zur Zeit alles innerhalb der Schnittsuche behandelt
    Show();
    Dialogaktiv := False;
    SchnittpunktListeeinfuegen_akt(Schnittliste);
  FINALLY
    IF Assigned(aktVideoknoten) AND
       Assigned(aktVideoknoten.Data) THEN
    BEGIN
      Mpeg2Decoder.OpenMPEG2File(PChar(TDateieintrag(aktVideoknoten.Data).Name));
      Positionieren(VideoBildPosition + 1);
      IF ArbeitsumgebungObj.VideoGraudarstellen THEN
        Mpeg2decoder.SetMPEG2PixelFormat(VideoFormatGray8)
      ELSE
        Mpeg2decoder.SetMPEG2PixelFormat(VideoFormatRGB24);
      END;
    Schnittliste.Free;
  END;
  IF Player AND 2 = 2 THEN                  // Audioplayer öffnen nur wenn vorher ein Audioplayer aktiv war.
  begin
    AudioplayerOeffnen(aktAudiodatei);
    AudioPlayerPosition_Setzen(audioPos);
  end;
end;

procedure TMpegEdit.DateiClick(Sender: TObject);
begin
  Pause;
  IF NOT Assigned(Vorschauknoten) THEN
  BEGIN
    ProjektNeu.Enabled := True;
    ProjektLaden.Enabled := True;
    IF (Schnittliste.Items.Count > 0) OR (KapitelListeGrid.Tag > 1) THEN
      ProjektEinfuegen.Enabled := True
    ELSE
      ProjektEinfuegen.Enabled := False;
    Projektspeichern_.Enabled := True;
    IF Dateien.Items.Count > 0 THEN
      IF Assigned(Dateien.Selected) THEN
        Datei_hinzufuegen.Enabled := True
      ELSE
        Datei_hinzufuegen.Enabled := False
    ELSE
      Datei_hinzufuegen.Enabled := False;
  END
  ELSE
  BEGIN
    ProjektNeu.Enabled := False;
    ProjektLaden.Enabled := False;
    ProjektEinfuegen.Enabled := False;
    Projektspeichern_.Enabled := False;
    Datei_hinzufuegen.Enabled := False;
  END;
end;

procedure TMpegEdit.BearbeitenClick(Sender: TObject);

VAR I : Integer;

begin
  Pause;
  I := Pos(':', RueckgaengigMenuIntem.Caption);
  IF I > 0 THEN
    RueckgaengigMenuIntem.Caption := LeftStr(RueckgaengigMenuIntem.Caption, I - 1);
  I := Pos(':', WiederherstellenMenuItem.Caption);
  IF I > 0 THEN
    WiederherstellenMenuItem.Caption := LeftStr(WiederherstellenMenuItem.Caption, I - 1);
  IF Assigned(UndoObject) THEN
  BEGIN
    RueckgaengigMenuIntem.Enabled := True;
    RueckgaengigMenuIntem.Caption := RueckgaengigMenuIntem.Caption + ': ' + UndoObject.Caption;
  END
  ELSE
    RueckgaengigMenuIntem.Enabled := False;
  IF Assigned(RedoObject) THEN
  BEGIN
    WiederherstellenMenuItem.Enabled := True;
    WiederherstellenMenuItem.Caption := WiederherstellenMenuItem.Caption + ': ' + RedoObject.Caption;
  END
  ELSE
    WiederherstellenMenuItem.Enabled := False;
end;

procedure TMpegEdit.RueckgaengigMenuIntemClick(Sender: TObject);
begin
  DoUndo;
end;

procedure TMpegEdit.WiederherstellenMenuItemClick(Sender: TObject);
begin
  DoRedo;
end;

PROCEDURE TMpegEdit.Kommandozeile;
BEGIN
  Parameterlesen;
  IF gleichSchneidenCL THEN
  BEGIN
    Schneiden.Click;
    gleichSchneidenCL := False;
  END
  ELSE
    IF (ArbeitsumgebungObj.letztesVideoanzeigen AND (NOT letztesVideoanzeigenCLaktiv)) OR
       (letztesVideoanzeigenCL AND letztesVideoanzeigenCLaktiv) THEN
    BEGIN
//      Fortschrittsfensteranzeigen;
      TRY
        IF ArbeitsumgebungObj.SchiebereglerPosbeibehalten THEN
          Dateilisteaktualisieren(Dateien.Selected)
        ELSE
        BEGIN
          Dateilisteaktualisieren(Dateien.Selected, False);
          SchiebereglerPosition_setzen(0);
        END;
      FINALLY
        Fortschrittsfensterverbergen;
      END;
      Schnittpunktanzeigeloeschen;
    END;
END;      

FUNCTION TMpegEdit.SchnittpunkteinfuegenCL(SchnittpunktIn, SchnittpunktOut: STRING): Integer;

VAR NeuerSchnittpunktIn,
    NeuerSchnittpunktOut : Int64;
    Schnittpunkt : TSchnittpunkt;

BEGIN
  Result := 0;
  IF SchnittpunktIn = '' THEN
    NeuerSchnittpunktIn := 0
  ELSE
    NeuerSchnittpunktIn := ZeitStrInBildnummer(SchnittpunktIn, BilderProSek, ArbeitsumgebungObj.SchnittImportZeitTrennzeichenliste, False);
  IF SchnittpunktOut = '' THEN
    NeuerSchnittpunktOut := Round(86400 * BilderProSek) - 1             // 86400 s = 24 h
  ELSE
    NeuerSchnittpunktOut := ZeitStrInBildnummer(SchnittpunktOut, BilderProSek, ArbeitsumgebungObj.SchnittImportZeitTrennzeichenliste, False);
  IF (NeuerSchnittpunktIn > - 1) AND (NeuerSchnittpunktOut > - 1) AND
     (NeuerSchnittpunktIn < NeuerSchnittpunktOut + 1) THEN
  BEGIN
    IF Assigned(Dateien.Selected) THEN
    BEGIN
      Schnittpunkt := TSchnittpunkt.Create;
      Schnittpunkt.VideoName := '';
      Schnittpunkt.AudioName := '';
      IF Dateien.Selected.Level > 0 THEN
        Schnittpunkt.Videoknoten := Dateien.Selected.Parent
      ELSE
        Schnittpunkt.Videoknoten := Dateien.Selected;
      Schnittpunkt.Audioknoten := Schnittpunkt.Videoknoten;
      Schnittpunkt.Anfang := NeuerSchnittpunktIn;
      Schnittpunkt.Ende := NeuerSchnittpunktOut;
      Schnittpunkt.Audiooffset := 0;
      Schnittpunkt.Framerate := BilderProsek;
      // Videogröße berechnen
      Schnittpunkt.VideoGroesse := 0;
      // Audiogröße berechnen  
      Schnittpunkt.AudioGroesse := 0;
      SchnittListe.Items.AddObject(SchnittpunktFormatberechnen(Schnittpunkt.Anfang, Schnittpunkt.Ende, Schnittpunkt.Framerate), Schnittpunkt);
      Schnittpunktanzeige_berechnen(SchnittListe.Items.Count - 1, SchnittListe.Items.Count - 1);
      Schneiden.Enabled := Schneidenmoeglich;
      Vorschau.Enabled := Vorschaumoeglich;
      Projektgeaendert_setzen(2);
    END
    ELSE
      Result := -2;                                                          // kein selektierter Knoten
  END
  ELSE
    Result := -1;                                                            // mindestens ein Schnittpunkt ungültig
END;

// -----------Procedure von Igor Feldhaus ------------------------
procedure TMpegEdit.aktuellesBildspeichernClick(Sender: TObject);

VAR BMP : TBitmap;

begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog66', 'Aktuelles Bild speichern');
  Speichern.Filter := Wortlesen(NIL, 'Dialog67', 'BMP-Dateien') + '|*.bmp';
  Speichern.DefaultExt := 'bmp';
  IF ProjektName = '' THEN
    IF SchnittListe.Items.Count > 0 THEN
      Speichern.FileName := ExtractFilename(ChangeFileExt(TSchnittpunkt(SchnittListe.Items.Objects[0]).Videoname, ''))
    ELSE
      Speichern.FileName := ''
  ELSE
    Speichern.FileName := ExtractFilename(ChangeFileExt(ProjektName, ''));
  Speichern.InitialDir := Verzeichnissuchen('');
  IF Speichern.Execute THEN
  BEGIN
    BMP := BMPBildlesen(-1, -1, True, False);
    IF Assigned(BMP) THEN
    BEGIN
      TRY
        BMP.SaveToFile(Speichern.FileName);
      FINALLY
        BMP.Free;
      END;
    END;
  END;
end;

// -----------Procedure von Igor Feldhaus ------------------------
procedure TMpegEdit.aktuellesBildkopierenClick(Sender: TObject);

VAR BMP : TBitmap;

begin
  BMP := BMPBildlesen(-1, -1, True, False);
  IF Assigned(BMP) THEN
  BEGIN
    TRY
      Clipboard.Assign(BMP);
    FINALLY
      BMP.free;
    END;
  END;
end;

procedure TMpegEdit.aktAudioFramespeichernClick(Sender: TObject);

VAR Quelldatei,
    Zieldatei : TDateiPuffer;
    AudioIndex : Int64;
    Puffergroesse : Integer;
    Puffer : PChar;
    Zieldateiloeschen : Boolean;

begin
  IF Assigned(aktAudioknoten) AND Assigned(aktAudioknoten.Data) THEN
  BEGIN
    Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
    Speichern.Title := Wortlesen(NIL, 'Dialog68', 'aktuellen Audioframe speichern');
    Speichern.Filter := Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + ArbeitsumgebungObj.DateiendungenAudio;
    Speichern.DefaultExt := '';
    IF ProjektName = '' THEN
      IF SchnittListe.Items.Count > 0 THEN
        Speichern.FileName := ExtractFilename(ChangeFileExt(TSchnittpunkt(SchnittListe.Items.Objects[0]).Videoname, ''))
      ELSE
        Speichern.FileName := ''
    ELSE
      Speichern.FileName := ExtractFilename(ProjektName);
    Speichern.InitialDir := Verzeichnissuchen('');
    IF Speichern.Execute THEN
    BEGIN
  //    IF ProjektVerzeichnisspeichern THEN
  //      ProjektVerzeichnis := ExtractFilePath(Speichern.FileName);
      Zieldateiloeschen := True;
      AudioPlayerClose;
      Quelldatei := TDateiPuffer.Create(aktAudiodatei, fmOpenRead);
      Zieldatei := TDateiPuffer.Create(Speichern.FileName, fmCreate);
      TRY
        IF Quelldatei.DateiMode = fmOpenRead THEN
        BEGIN
          AudioIndex := Round(((SchiebereglerPosition * Bildlaenge) + Audiooffset^) / Audioheader.Framezeit);
          IF AudioIndex < 0 THEN                                       // AnfangsIndex darf nicht
            AudioIndex := 0;                                           // kleiner Null sein.
          Quelldatei.Pufferfreigeben;
          IF Quelldatei.NeuePosition(TAudioHeaderklein(AudioListe[AudioIndex]).Adresse) THEN
          BEGIN
            Puffergroesse := TAudioHeaderklein(AudioListe[AudioIndex + 1]).Adresse - TAudioHeaderklein(AudioListe[AudioIndex]).Adresse;
            GetMem(Puffer, Puffergroesse);
            TRY
              IF Quelldatei.LesenDirekt(Puffer^, Puffergroesse) = Puffergroesse THEN
                IF Zieldatei.SchreibenDirekt(Puffer^, Puffergroesse) = Puffergroesse THEN
                  Zieldateiloeschen := False
                ELSE
                  Meldungsfenster(Meldunglesen(NIL, 'Meldung132', Speichern.FileName, 'Die Datei $Text1# konnte nicht erzeugt werden.'),
                                  Wortlesen(NIL, 'Hinweis', 'Hinweis'))
//                  ShowMessage(Meldunglesen(NIL, 'Meldung132', Speichern.FileName, 'Die Datei $Text1# konnte nicht erzeugt werden.'))
              ELSE
                Meldungsfenster(Meldunglesen(NIL, 'Meldung122', aktAudiodatei, 'Die Datei $Text1# ist scheinbar zu kurz.'),
                                Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//                ShowMessage(Meldunglesen(NIL, 'Meldung122', aktAudiodatei, 'Die Datei $Text1# ist scheinbar zu kurz.'));
            FINALLY
              FreeMem(Puffer);
            END;
          END
          ELSE
            Meldungsfenster(Meldunglesen(NIL, 'Meldung122', aktAudiodatei, 'Die Datei $Text1# ist scheinbar zu kurz.'),
                            Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//            ShowMessage(Meldunglesen(NIL, 'Meldung122', aktAudiodatei, 'Die Datei $Text1# ist scheinbar zu kurz.'));
        END
        ELSE
          Meldungsfenster(Meldunglesen(NIL, 'Meldung114', aktAudiodatei, 'Die Datei $Text1# läßt sich nicht öffnen.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung114', aktAudiodatei, 'Die Datei $Text1# läßt sich nicht öffnen.'));
      FINALLY
        Quelldatei.Free;
        Zieldatei.Free;
        IF Player AND 2 = 2 THEN                  // Audioplayer öffnen nur wenn vorher ein Audioplayer aktiv war.
          AudioplayerOeffnen(aktAudiodatei);
      END;
      IF Zieldateiloeschen THEN
      BEGIN
        IF DeleteFile(Speichern.FileName) THEN;
          Meldungsfenster(Meldunglesen(NIL, 'Meldung123', Speichern.FileName, 'Die Zieldatei $Text1# wird wieder gelöscht.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung123', Speichern.FileName, 'Die Zieldatei $Text1# wird wieder gelöscht.'));
      END;
    END;
  END;  
end;

procedure TMpegEdit.FilmGrobansichtMenuItemClick(Sender: TObject);
begin
  FilmGrobAnsichtFrm.Show;
  FilmGrobAnsichtFrm.Bildereinlesen;
  binaereSucheForm.Show;
end;

procedure TMpegEdit.SchnittpunktformatanpassenClick(Sender: TObject);

VAR I : Integer;
    Schnittpunkt : TSchnittpunkt;

begin
  FOR I := 0 TO Schnittliste.Items.Count - 1 DO
  BEGIN
    Schnittpunkt := TSchnittpunkt(Schnittliste.Items.Objects[I]);
    Schnittliste.Items.Strings[I] := SchnittpunktFormatberechnen(Schnittpunkt.Anfang, Schnittpunkt.Ende, Schnittpunkt.Framerate);
  END;  
end;

FUNCTION TMpegEdit.SchnittlisteersteZeile: Integer;
BEGIN
  Result := 0;
  WHILE (Result < Schnittliste.Items.Count) AND (NOT Schnittliste.Selected[Result]) DO
    Inc(Result);
  IF Result = Schnittliste.Items.Count THEN
    Result := -1;
END;

FUNCTION TMpegEdit.SchnittlisteletzteZeile: Integer;
BEGIN
  Result := Schnittliste.Items.Count - 1;
  WHILE (Result > -1) AND (NOT Schnittliste.Selected[Result]) DO
    Dec(Result);
END;

FUNCTION TMpegEdit.Schnittliste_importieren(Name: STRING): Integer;

VAR I : Integer;
    Schnittpunkt : TSchnittpunkt;
    Schnittliste : TListe;
    ImportListe : TStringList;
    HString : STRING;
    Position1,
    Position2,
    Laenge2,
    Anfang,
    Ende,
    HZahl : Integer;
    istAnfang : Boolean;

BEGIN
  Result := 0;
  istAnfang := True;
  Anfang := -1;
  Ende := -1;
  IF FileExists(Name) THEN
  BEGIN
    Schnittliste := TListe.Create;
    ImportListe := TStringList.Create;
    TRY
      ImportListe.LoadFromFile(Name);
      IF ImportListe.Count > 0 THEN
      BEGIN
        I := 0;
        WHILE(I < ImportListe.Count) DO         // Zeilenschleife
        BEGIN
          Position1 := 0;
          REPEAT                                // Durchsuchen einer Zeile
            Position2 := PosX(ArbeitsumgebungObj.SchnittImportTrennzeichenliste, ImportListe.Strings[I], Position1 + 1, False, Laenge2);
            IF Position2 = 0 THEN
              Position2 := Length(ImportListe.Strings[I]) + 1;
            IF Position2 > (Position1 + 1) THEN
              HString := Copy(ImportListe.Strings[I], Position1 + 1, Position2 - Position1 -1)
            ELSE
              HString := '';
            IF HString <> '' THEN
            BEGIN
              HZahl := ZeitStrInBildnummer(HString, BilderProSek, ArbeitsumgebungObj.SchnittImportZeitTrennzeichenliste, False);
              IF HZahl > -1 THEN
                IF istAnfang THEN
                BEGIN
                  Anfang := HZahl;
                  istAnfang := False;
                END
                ELSE
                BEGIN
                  Ende := HZahl;
                  istAnfang := True;
                END;
              IF (Anfang > -1) AND (Ende > -1) AND (Anfang < Ende + 1) AND ((Ende < Indexliste.Count) OR ((Indexliste.Count = 0) AND (Ende < AudioListe.Count))) THEN
              BEGIN
                Schnittpunkt := TSchnittpunkt.create;
                Schnittpunkt.Anfang := Anfang;
                Schnittpunkt.Ende := Ende;
                Schnittliste.Add(Schnittpunkt);
                Anfang := -1;
                Ende := -1;
              END;
            END;
            Position1 := Position2;
          UNTIL Position1 > Length(ImportListe.Strings[I]);
          Inc(I);
        END;
        IF Schnittliste.Count > 0 THEN
          IF istAnfang THEN
            SchnittpunktListeeinfuegen_akt(Schnittliste)
          ELSE
            Result := -4       // ungerade Schnittpunkte
        ELSE
          Result := -3;        // keine Schnitte gefunden
      END
      ELSE
        Result := -2;          // Importliste ist leer
    FINALLY
      Schnittliste.Loeschen;
      Schnittliste.Free;
      ImportListe.Free;
    END;
  END
  ELSE
    Result := -1;              // Datei nicht vorhanden
END;

procedure TMpegEdit.SchnittlisteimportierenClick(Sender: TObject);
begin
  Oeffnen.Title := Wortlesen(NIL, 'Dialog69', 'Schnittliste importieren');
  Oeffnen.Filter := Wortlesen(NIL, 'Dialog70', 'Schnittlisten') + '|*.*';
  Oeffnen.DefaultExt := '';
  Oeffnen.FileName := '';
  Oeffnen.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.VideoAudioVerzeichnis);
  IF Oeffnen.Execute THEN
  BEGIN
    Schnittliste_importieren(Oeffnen.FileName);
  END;
end;

procedure TMpegEdit.SchnitteausDateienMenuItemClick(Sender: TObject);

VAR I, J : Integer;
    Spur : Integer;
    Laenge : Integer;
    AudioVersatz : Integer;
    HBilderProsek : Real;
    Knoten : TTreeNode;
    MpegHeader : TMpeg2Header;
    MpegAudio : TMpegAudio;
    HListe,
    HIndexListe,
    HAudioListe : TListe;
    HSequenzHeader : TSequenzHeader;
    HBildHeader : TBildHeader;
    HAudioHeader : TAudioHeader;
    Schnitt : TSchnittpunkt;

begin
  HListe := TListe.Create;                                   // Listen erzeugen
  HIndexListe := TListe.Create;
  HAudioListe := TListe.Create;
  HSequenzHeader := TSequenzHeader.Create;
  HBildHeader := TBildHeader.Create;
  HAudioHeader := TAudioHeader.Create;
  TRY
    Spur := aktAudiospursuchen(Dateien.Selected);
    FOR I := 0 TO Dateien.Items.Count -1 DO
    BEGIN
      Laenge := -1;
      HBilderProsek := 0;
      HListe.Loeschen;                                       // Listen löschen
      HIndexListe.Loeschen;
      HAudioListe.Loeschen;
      IF Dateien.Items[I].Level = 0 THEN
      BEGIN
        IF Assigned(Dateien.Items[I].Item[0].Data) THEN
        BEGIN                                                // Video vorhanden
          IF aktVideoknoten = Dateien.Items[I].Item[0] THEN
          BEGIN
            Laenge := IndexListe.Count - 1;                  // Video ist aktuelles Video
            HBilderProSek := BilderProSek;
          END
          ELSE
          BEGIN
            Fortschrittsfensteranzeigen;                     // Fortschrittsfenster anzeigen
            MpegHeader:= TMpeg2Header.Create;                // notwendige Objekte erzeugen
            TRY
              MpegHeader.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
              MpegHeader.Textanzeige := Fortschrittsfenster.Textanzeige;
              MpegHeader.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
              MpegHeader.SequenzEndeIgnorieren := ArbeitsumgebungObj.SequenzEndeignorieren;
              IF MpegHeader.Dateioeffnen(TDateieintrag(Dateien.Items[I].Item[0].Data).Name) THEN
              BEGIN
                MpegHeader.DateiInformationLesen(HSequenzHeader, HBildHeader);
                MpegHeader.Listeerzeugen(HListe, HIndexListe); // Liste einlesen
                Laenge := HIndexListe.Count - 1;
                IF ArbeitsumgebungObj.FesteFramerateverwenden THEN
                  HBilderProSek := ArbeitsumgebungObj.FesteFramerate
                ELSE
                  HBilderProSek := BilderProSekausSeqHeaderFramerate(HSequenzHeader.Framerate);
              END;
            FINALLY
              MpegHeader.Free;
            END;
          END;
        END
        ELSE
        BEGIN
          Knoten := NIL;
          IF (Spur > -1) AND                                 // aktive Audiospur ist vorhanden
             (Dateien.Items[I].Count > Spur) AND             // aktive Audiospur ist gültig
             Assigned(Dateien.Items[I].Item[Spur].Data) THEN // Audiodaten sind vorhanden
            Knoten := Dateien.Items[I].Item[Spur]
          ELSE
          BEGIN
            J := 0;
            WHILE J < Dateien.Items[I].Count DO              // erste mögliche Audiospur suchen
            BEGIN
              IF Assigned(Dateien.Items[I].Item[J].Data) THEN
              BEGIN
                Knoten := Dateien.Items[I].Item[J];
                J := Dateien.Items[I].Count;
              END
              ELSE
                Inc(J);
            END;
          END;
          IF Assigned(Knoten) THEN                           // Audiospur gefunden
          BEGIN
            IF aktAudioknoten = Knoten THEN
            BEGIN
              Laenge := AudioListe.Count - 1;                 // Audio ist aktuelles Audio
              HBilderProSek := BilderProSek;
            END
            ELSE
            BEGIN
              Fortschrittsfensteranzeigen;                   // Fortschrittsfenster anzeigen
              MpegAudio:= TMpegAudio.Create;                 // notwendige Objekte erzeugen
              TRY
                MpegAudio.FortschrittsEndwert := @Fortschrittsfenster.Endwert;
                MpegAudio.Textanzeige := Fortschrittsfenster.Textanzeige;
                MpegAudio.Fortschrittsanzeige := Fortschrittsfenster.Fortschrittsanzeige;
                IF MpegAudio.Dateioeffnen(TDateieintragAudio(Knoten.Data).Name) = 0 THEN
                BEGIN
                  IF MpegAudio.DateiInformationLesen(HAudioHeader) > -1 THEN
                  BEGIN
                    MpegAudio.Listeerzeugen(HAudioListe, NIL, AudioVersatz); // Liste einlesen
                    Laenge := HAudioListe.Count - 1;
                    IF HAudioHeader.Framezeit > 0 THEN
                      HBilderProSek := 1000 / HAudioHeader.Framezeit;
                  END;
                END;
              FINALLY
                MpegAudio.Free;
              END;
            END;
          END;
        END;
        IF Laenge > 0 THEN
        BEGIN
          Schnitt := TSchnittpunkt.Create;
          IF Schnittpunktfuellen(Schnitt, Dateien.Items[I], Dateien.Items[I],
                                 0, Laenge, HBilderProsek,
                                 HListe, HIndexListe) = 0 THEN
          BEGIN
            SchnittListe.ItemIndex := SchnittListe.Items.AddObject(SchnittpunktFormatberechnen(0, Laenge, BilderProsek), Schnitt);
//            Schnittpunktanzeige_berechnen(Schnittliste.ItemIndex, Schnittliste.ItemIndex); //????
            Dateigroesse;
            Projektgeaendert_setzen(2);
          END
          ELSE
            Schnitt.Free;
        END;
      END;
    END;
    Schneiden.Enabled := Schneidenmoeglich;
    Vorschau.Enabled := Vorschaumoeglich;
  FINALLY
    Fortschrittsfensterverbergen;                            // Fortschrittsfenster verbergen
    HIndexListe.Free;                                        // Listen freigeben
    HListe.Free;
    HAudioListe.Free;
    HSequenzHeader.Free;
    HBildHeader.Free;
    HAudioHeader.Free;
  END;
end;

procedure TMpegEdit.OptionenfensterClick(Sender: TObject);
begin
  Pause;
  WITH OptionenFenster DO
  BEGIN
    IF Sender = Allgemeinseite THEN
      OptionenSeiten.ActivePageIndex := OptionenAllgemeinSeiteTab.PageIndex;
    IF Sender = Oberflaechenseite THEN
      OptionenSeiten.ActivePageIndex := OptionenOberflaecheTab.PageIndex;
    IF Sender = Verzeichnisseite THEN
      OptionenSeiten.ActivePageIndex := OptionenVerzeichnisseiteTab.PageIndex;
    IF Sender = DateinamenEndungenseite THEN
      OptionenSeiten.ActivePageIndex := OptionenDateinamenEndungenseiteTab.PageIndex;
    IF Sender = Wiedergabeseite THEN
      OptionenSeiten.ActivePageIndex := OptionenWiedergabeSeiteTab.PageIndex;
    IF Sender = VideoAudioSchnittseite THEN
      OptionenSeiten.ActivePageIndex := OptionenVideoAudioSchnittseiteTab.PageIndex;
    IF (Sender = SchnittlistenFormatseiteMenuItem) OR
       (Sender = SchnittlistenFormatseiteMenuItem1) THEN
      OptionenSeiten.ActivePageIndex := OptionenSchnittlistenFormatseiteTab.PageIndex;
    IF (Sender = KapitellistenFormatseiteMenuItem) OR
       (Sender = KapitellistenFormatseiteMenuItem1) THEN
      OptionenSeiten.ActivePageIndex := OptionenKapitellistenFormatseiteTab.PageIndex;
    IF (Sender = MarkenlistenFormatseiteMenuItem) OR
       (Sender = MarkenlistenFormatseiteMenuItem1) THEN
      OptionenSeiten.ActivePageIndex := OptionenMarkenlistenFormatseiteTab.PageIndex;
    IF Sender = ListenImportseiteMenuItem THEN
      OptionenSeiten.ActivePageIndex := OptionenListenImportseiteTab.PageIndex;
    IF Sender = ListenExportseiteMenuItem THEN
      OptionenSeiten.ActivePageIndex := OptionenListenExportseiteTab.PageIndex;
    IF Sender = TastenbelegungSeite THEN
      OptionenSeiten.ActivePageIndex := OptionenTastenbelegungseiteTab.PageIndex;
    IF Sender = NavigationsSeite THEN
      OptionenSeiten.ActivePageIndex := OptionenNavigationsseiteTab.PageIndex;
    IF Sender = VorschauSeite THEN
      OptionenSeiten.ActivePageIndex := OptionenVorschauseiteTab.PageIndex;
    IF Sender = AusgabeSeite THEN
      OptionenSeiten.ActivePageIndex := OptionenAusgabeseiteTab.PageIndex;
    IF Sender = EffekteSeite THEN
      OptionenSeiten.ActivePageIndex := OptionenEffektseiteTab.PageIndex;
    IF Sender = GrobansichtSeite THEN
      OptionenSeiten.ActivePageIndex := OptionenGrobansichtSeiteTab.PageIndex;
    Fensterpositionmerken;
    Fensteranzeigemerken;
    Kapitelspaltenbreitemerken;
    ListeTabIndexspeichern;
    FilmGrobAnsichtFrm.Fensterpositionmerken;
    binaereSucheForm.Fensterpositionmerken;
    Dialogaktiv := True;
    Arbeitsumgebung := ArbeitsumgebungObj;
    Dateienleer := Dateien.Items.Count = 0;
    IF (ShowModal = mrOK) THEN
    BEGIN
      IF ArbeitsumgebungbeiOKspeichern THEN
        ArbeitsumgebungObj.Arbeitsumgebungspeichern(ArbeitsumgebungObj.Dateiname);
      ZielDateinameCLaktiv := False;
      FramegenauschneidenCLaktiv := False;
      nachSchneidenbeendenCL := False;
      letztesVideoanzeigenCLaktiv := False;
//      aktArbeitsumgebungCLaktiv := False;
      Rueckgabeparameter_lesen;
    END;
    Dialogaktiv := False;
  END;
end;

PROCEDURE TMpegEdit.SchnittListeFormat;

VAR I : Integer;
    HListe,
    HIndexliste : TListe;
    HVideoname : STRING;
    Schnittpunkt : TSchnittpunkt;

BEGIN
  IF ArbeitsumgebungObj.SchnittpunktAnfangbild OR ArbeitsumgebungObj.SchnittpunktEndebild THEN
  BEGIN
    HListe := TListe.Create;
    HIndexliste := TListe.Create;
    TRY
      HVideoname := '';
      FOR I := 0 TO Schnittliste.Count - 1 DO
      BEGIN
        Schnittpunkt := TSchnittpunkt(Schnittliste.Items.Objects[I]);
        SchnittpunktBildereinfuegen(Schnittpunkt, HVideoname, HListe, HIndexliste);
      END;
    FINALLY
      HListe.Free;
      HIndexliste.Free;
    END;
  END;
  Schnittliste.ItemHeight := 16;
  Schnittliste.Invalidate;
END;

procedure TMpegEdit.SchnittlisteDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);

VAR X, X1, Y, Z, I : Integer;
    Schnittpunkt : TSchnittpunkt;
    Anfang, Ende : Int64;
    HString : STRING;
    Farbe : TColor;

begin
  X := 3;                                                                       // Anfangsrand links
  Y := 1;                                                                       // Anfangsrand oben
  Z := Y;                                                                       // oberer Rand der Schrift
  X1 := 0;
  Farbe := Schnittliste.Canvas.Font.Color;                                      // Schriftfarbe merken
  Schnittpunkt := Schnittliste.Items.Objects[Index] AS TSchnittpunkt;
  IF Assigned(ArbeitsumgebungObj) AND
    (Tastegedrueckt = ArbeitsumgebungObj.Tasten[46]) THEN
  BEGIN
    Anfang := 0;
    Ende := -1;
    FOR I := 0 TO Index DO
    BEGIN
      Anfang := Ende + 1;
      Ende := TSchnittpunkt(Schnittliste.Items.Objects[I]).Ende -
              TSchnittpunkt(Schnittliste.Items.Objects[I]).Anfang + Anfang;
    END;
  END
  ELSE
  BEGIN
    Anfang := Schnittpunkt.Anfang;
    Ende := Schnittpunkt.Ende;
  END;
  Schnittliste.Canvas.FillRect(Rect);                                           // Schnittpunktinhalt löschen
//  Schnittliste.Canvas.Pen.Color := clgray;
//  Schnittliste.Canvas.Rectangle(Rect);
  IF Assigned(Schnittpunkt) AND
     Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    IF ArbeitsumgebungObj.SchnittpunktAnfangbild OR ArbeitsumgebungObj.SchnittpunktEndebild THEN
    BEGIN
      IF Schnittliste.ItemHeight < (Y + Y + (Schnittliste.Canvas.TextHeight('a') * 3)) THEN // Mindesthöhe um die Schrift darzustellen
       Schnittliste.ItemHeight := Y + Y + (Schnittliste.Canvas.TextHeight('a') * 3);
      IF Schnittliste.ItemHeight < Schnittpunkt.AnfangsBild.Height + Y + Y THEN // Schnittpunkthöhe für Bilder
        Schnittliste.ItemHeight := Schnittpunkt.AnfangsBild.Height + Y + Y;     // Schnittpunkthöhe ist gleich Höhe des größten Bildes
      Z := Trunc((Schnittliste.ItemHeight - (3 * Schnittliste.Canvas.TextHeight('a'))) / 2);
    END
    ELSE
      Schnittliste.ItemHeight := Y + Y + Schnittliste.Canvas.TextHeight('a');   // Schnittpunkthöhe für Text
    IF ArbeitsumgebungObj.SchnittpunktAnfangbild THEN
    BEGIN
      Schnittliste.Canvas.Draw(Rect.Left + X, Rect.Top + Y, Schnittpunkt.AnfangsBild); // Anfangsbild zeichnen
      X := X + Schnittpunkt.AnfangsBild.Width + 3;
    END;
    HString := IntToStrFmt(Index + 1, 2) + ' ' +
               IntToStrFmt(DateienlisteHauptknotenNr(Schnittpunkt.Videoknoten), 2) + ' ' +
               IntToStrFmt(DateienlisteHauptknotenNr(Schnittpunkt.Audioknoten), 2);
    Schnittliste.Canvas.TextOut(Rect.Left + X, Rect.Top + Z, HString);          // Knotenanzeige zeichnen
    IF ArbeitsumgebungObj.SchnittpunktAnfangbild OR ArbeitsumgebungObj.SchnittpunktEndebild THEN
    BEGIN
      Z := Z + Schnittliste.Canvas.TextHeight(HString);
      X1 := Schnittliste.Canvas.TextWidth(HString);
    END
    ELSE
    BEGIN                                                                       // Trennzeichen zeichnen
      X := X + Schnittliste.Canvas.TextWidth(HString);
      HString := ArbeitsumgebungObj.SchnittpunktTrennzeichen;
      Schnittliste.Canvas.TextOut(Rect.Left + X, Rect.Top + Z, HString);
      X := X + Schnittliste.Canvas.TextWidth(HString);
    END;
    CASE Schnittpunkt.Anfangberechnen AND $7 OF                                 // Farbe einstellen
      3: Schnittliste.Canvas.Font.Color := ArbeitsumgebungObj.SchnittpunktberechnenFarbe;
      7: Schnittliste.Canvas.Font.Color := ArbeitsumgebungObj.SchnittpunktnichtberechnenFarbe;
    ELSE
      Schnittliste.Canvas.Font.Color := Farbe;
    END;
    HString := BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, Anfang, Schnittpunkt.Framerate);
    Schnittliste.Canvas.TextOut(Rect.Left + X, Rect.Top + Z, HString);          // Anfangschnittpunkt zeichnen
    IF ArbeitsumgebungObj.SchnittpunktAnfangbild OR ArbeitsumgebungObj.SchnittpunktEndebild THEN
    BEGIN
      Z := Z + Schnittliste.Canvas.TextHeight(HString);
      IF X1 < Schnittliste.Canvas.TextWidth(HString) THEN
        X1 := Schnittliste.Canvas.TextWidth(HString);
    END
    ELSE
    BEGIN                                                                       // Trennzeichen zeichnen
      X := X + Schnittliste.Canvas.TextWidth(HString);
      Schnittliste.Canvas.Font.Color := Farbe;
      HString := ArbeitsumgebungObj.SchnittpunktTrennzeichen;
      Schnittliste.Canvas.TextOut(Rect.Left + X, Rect.Top + Z, HString);
      X := X + Schnittliste.Canvas.TextWidth(HString);
    END;
    CASE Schnittpunkt.Endeberechnen AND $7 OF                                   // Farbe einstellen
      3: Schnittliste.Canvas.Font.Color := ArbeitsumgebungObj.SchnittpunktberechnenFarbe;
      7: Schnittliste.Canvas.Font.Color := ArbeitsumgebungObj.SchnittpunktnichtberechnenFarbe;
    ELSE
      Schnittliste.Canvas.Font.Color := Farbe;
    END;
    HString := BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, Ende, Schnittpunkt.Framerate);
    Schnittliste.Canvas.TextOut(Rect.Left + X, Rect.Top + Z, HString);          // Endschnittpunkt zeichnen
    IF ArbeitsumgebungObj.SchnittpunktEndebild THEN
    BEGIN
      IF X1 < Schnittliste.Canvas.TextWidth(HString) THEN
        X1 := Schnittliste.Canvas.TextWidth(HString);
      X := X + X1 + 3;
      Schnittliste.Canvas.Draw(Rect.Left + X, Rect.Top + Y, Schnittpunkt.EndeBild); // Endbild zeichnen
    END;
    Schnittliste.Canvas.Font.Color := Farbe;                                    // Farbe wiederherstellen
  END;
end;

PROCEDURE TMpegEdit.Effektkopieren(Audio: Boolean);

VAR I : Integer;

BEGIN
  IF Schnittliste.ItemIndex > -1 THEN
    FOR I := 0 TO Schnittliste.Items.Count - 1 DO
      IF (SchnittListe.Selected[I]) AND
         (SchnittListe.ItemIndex <> I) THEN
        IF Audio THEN
        BEGIN
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.AnfangEffektName := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.AnfangEffektName;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.AnfangEffektDateiname := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.AnfangEffektDateiname;
//          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.AnfangEffektPosition := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.AnfangEffektPosition;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.AnfangLaenge := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.AnfangLaenge;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.AnfangEffektParameter := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.AnfangEffektParameter;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.EndeEffektName := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.EndeEffektName;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.EndeEffektDateiname := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.EndeEffektDateiname;
//          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.EndeEffektPosition := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.EndeEffektPosition;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.EndeLaenge := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.EndeLaenge;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).AudioEffekt.EndeEffektParameter := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt.EndeEffektParameter;
        END
        ELSE
        BEGIN
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.AnfangEffektName := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.AnfangEffektName;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.AnfangEffektDateiname := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.AnfangEffektDateiname;
//          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.AnfangEffektPosition := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.AnfangEffektPosition;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.AnfangLaenge := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.AnfangLaenge;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.AnfangEffektParameter := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.AnfangEffektParameter;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.EndeEffektName := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.EndeEffektName;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.EndeEffektDateiname := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.EndeEffektDateiname;
//          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.EndeEffektPosition := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.EndeEffektPosition;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.EndeLaenge := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.EndeLaenge;
          TSchnittpunkt(Schnittliste.Items.Objects[I]).VideoEffekt.EndeEffektParameter := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt.EndeEffektParameter;
        END;
END;

procedure TMpegEdit.VideoEffektClick(Sender: TObject);
begin
  IF Schnittliste.ItemIndex > -1 THEN
  BEGIN
    Effektfenster.Caption := Wortlesen(NIL, 'Videoeffekt', 'Videoeffekt');
    Effektfenster.Effekte := ArbeitsumgebungObj.VideoEffekte;
    Effektfenster.Effekt := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).VideoEffekt;
    Effektfenster.Effektvorgaben := ArbeitsumgebungObj.Videoeffektvorgaben;
    IF ArbeitsumgebungObj.Vorgabeeffekteverwenden THEN
      Effektfenster.Effektvorgabe :=  ArbeitsumgebungObj.Videoeffektvorgabe
    ELSE
      Effektfenster.Effektvorgabe := '';
    Dialogaktiv := True;
    IF Effektfenster.ShowModal = mrOK THEN
    BEGIN
      Projektgeaendert_setzen(4);
      Effektkopieren(False);
    END;
    Dialogaktiv := False;
  END;
end;

procedure TMpegEdit.AudioEffektClick(Sender: TObject);
begin
  IF Schnittliste.ItemIndex > -1 THEN
  BEGIN
    Effektfenster.Caption := Wortlesen(NIL, 'Audioeffekt', 'Audioeffekt');
    Effektfenster.Effekte := ArbeitsumgebungObj.AudioEffekte;
    Effektfenster.Effekt := TSchnittpunkt(Schnittliste.Items.Objects[Schnittliste.ItemIndex]).AudioEffekt;
    Effektfenster.Effektvorgaben := ArbeitsumgebungObj.Audioeffektvorgaben;
    IF ArbeitsumgebungObj.Vorgabeeffekteverwenden THEN
      Effektfenster.Effektvorgabe :=  ArbeitsumgebungObj.Audioeffektvorgabe
    ELSE
      Effektfenster.Effektvorgabe := '';
    Dialogaktiv := True;
    IF Effektfenster.ShowModal = mrOK THEN
    BEGIN
      Projektgeaendert_setzen(4);
      Effektkopieren(True);
    END;
    Dialogaktiv := False;
  END;
end;

PROCEDURE TMpegEdit.Fortschrittsfensteranzeigen;
BEGIN
  Anzeigeflaeche.Update;
  Dialogaktiv := True;
  Enabled := False;
  Fortschrittsfenster.Fensteranzeigen;
END;

PROCEDURE TMpegEdit.Fortschrittsfensterverbergen;
BEGIN
//  IF NOT Fortschrittsfenster.Fensterwarsichtbar THEN
    BringToFront;
  Fortschrittsfenster.Fensterverbergen;
//  IF NOT Fortschrittsfenster.Visible THEN
//  BEGIN
//    BringToFront;               // zur Sicherheit
    Dialogaktiv := False;
    Enabled := True;
//  END;
END;

PROCEDURE TMpegEdit.ListeTabIndexspeichern;
BEGIN
  ArbeitsumgebungObj.SchnitteTabPos := SchnittlistenTab.PageIndex;
  ArbeitsumgebungObj.KapitelTabPos := KapitellistenTab.PageIndex;
  ArbeitsumgebungObj.MarkenTabPos := MarkenlistenTab.PageIndex;
  ArbeitsumgebungObj.InfoTabPos := InformationenTab.PageIndex;
  IF DateienTab.TabVisible THEN
    ArbeitsumgebungObj.DateienTabPos := DateienTab.PageIndex;
END;

// ------------- Dateienliste ---------------

PROCEDURE TMpegEdit.DateienListeInit;
BEGIN
  DateienListeDragDrop := False;
END;

FUNCTION TMpegEdit.DateienListeAudioKnotenverschiebenKnoten(Quelle, Ziel: Integer; Knoten: TTreeNode): Integer;

VAR HKnoten : TTreeNode;
    I, Position1, Position2 : Integer;

BEGIN
  Result := -1;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    IF (Quelle > 0) AND
       (Quelle < Knoten.Count) AND
       (Ziel > 0) AND
       (Ziel < Knoten.Count) THEN
    BEGIN
      IF Quelle < Ziel THEN                               // Quelle steht über Ziel (Quelle ist kleiner)
      BEGIN
        IF Ziel < Knoten.Count - 1 THEN
          HKnoten := Dateien.Items.InsertObject(Knoten.Item[Ziel + 1], Knoten.Item[Quelle].Text, Knoten.Item[Quelle].Data)
        ELSE
          HKnoten := Dateien.Items.AddObject(Knoten.Item[Ziel], Knoten.Item[Quelle].Text, Knoten.Item[Quelle].Data);
        IF aktAudioknoten = Knoten.Item[Quelle] THEN      // aktuellen Audioknoten korrigieren
          aktAudioknoten := HKnoten;
        Dateien.Items.Delete(Knoten.Item[Quelle]);
      END
      ELSE                                                // Ziel steht über Quelle
      BEGIN
        HKnoten := Dateien.Items.InsertObject(Knoten.Item[Ziel], Knoten.Item[Quelle].Text, Knoten.Item[Quelle].Data);
        IF aktAudioknoten = Knoten.Item[Quelle + 1] THEN  // aktuellen Audioknoten korrigieren
          aktAudioknoten := HKnoten;
        Dateien.Items.Delete(Knoten.Item[Quelle + 1]);
      END;
      FOR I := 1 TO Knoten.Count - 1 DO                   // Knoten neu nummerieren
      BEGIN
        HKnoten := Knoten.Item[I];
        Position1 := Pos(' ', HKnoten.Text);
        Position2 := PosX(' ', HKnoten.Text, Position1 + 1, False);
        HKnoten.Text := Copy(HKnoten.Text, 1, Position1) + IntToStr(I) +
                        Copy(HKnoten.Text, Position2, Length(HKnoten.Text) - Position2 + 1);
      END;
      Result := 0;
    END;
  END;
END;

FUNCTION TMpegEdit.DateienListeAudioKnotenverschieben(Quelle, Ziel: Integer): Integer;

VAR I, Erg : Integer;
    HKnoten : TTreeNode;

BEGIN
  Result := 0;
  FOR I := 0 TO Dateien.Items.Count - 1 DO
  BEGIN
    HKnoten := Dateien.Items.Item[I];
    IF HKnoten.Level = 0 THEN
    BEGIN
      Erg := DateienListeAudioKnotenverschiebenKnoten(Quelle, Ziel, HKnoten);
      IF Erg < 0 THEN
        Result := Erg;
    END;
  END;
END;

// ------------ Dateienlistenereingnisse -----------------

procedure TMpegEdit.DateienKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

VAR Index : Integer;
    Knoten : TTreeNode;

begin
  IF Shift = [ssCtrl] THEN
  BEGIN
    IF Assigned(Dateien.Selected) THEN            // Knoten angewählt
    BEGIN
      IF Dateien.Selected.Level = 0 THEN
        Knoten := Dateien.Selected
      ELSE
        Knoten := Dateien.Selected.Parent;
      Index := Knoten.IndexOf(Dateien.Selected);
      IF Index > - 1 THEN                         // Knoten 2. Ebene angewählt
      BEGIN
        IF (Key = VK_UP) THEN
          IF DateienListeAudioKnotenverschieben(Index, Index - 1) = 0 THEN
          BEGIN
            Dateien.Select([Knoten.Item[Index - 1]]);
            Projektgeaendert_setzen(1);
          END;
        IF (Key = VK_DOWN) THEN
          IF DateienListeAudioKnotenverschieben(Index, Index + 1) = 0 THEN
          BEGIN
            Dateien.Select([Knoten.Item[Index + 1]]);
            Projektgeaendert_setzen(1);
          END;
        IF (Key = VK_PRIOR) THEN
          IF DateienListeAudioKnotenverschieben(Index, Index - 10) = 0 THEN
          BEGIN
            Dateien.Select([Knoten.Item[Index - 10]]);
            Projektgeaendert_setzen(1);
          END
          ELSE
            Key := VK_HOME;        // es ist nicht mehr genug Platz also bis zum Anfang verschieben
        IF (Key = VK_NEXT) THEN
          IF DateienListeAudioKnotenverschieben(Index, Index + 10) = 0 THEN
          BEGIN
            Dateien.Select([Knoten.Item[Index + 10]]);
            Projektgeaendert_setzen(1);
          END
          ELSE
            Key := VK_END;        // es ist nicht mehr genug Platz also bis ans Ende verschieben
        IF (Key = VK_HOME) THEN
          IF DateienListeAudioKnotenverschieben(Index, 1) = 0 THEN
          BEGIN
            Dateien.Select([Knoten.Item[1]]);
            Projektgeaendert_setzen(1);
          END;
        IF (Key = VK_END) THEN
          IF DateienListeAudioKnotenverschieben(Index, Knoten.Count - 1) = 0 THEN
          BEGIN
            Dateien.Select([Knoten.Item[Knoten.Count - 1]]);
            Projektgeaendert_setzen(1);
          END;
      END;
    END;
    IF (Key = Ord('O')) THEN      // Strg O Video/Audio öffnen
      VideoAudiooeffnen.Click;
    IF (Key = Ord('A')) THEN      // Strg A Audio hinzufügen
      Dateihinzufuegen.Click;
    IF (Key = Ord('N')) THEN      // Strg N Video/Audio ändern
      Dateiaendern.Click;
    IF (Key = VK_DELETE) THEN     // Strg Entf Löschen
      Dateiloeschen.Click;
    Key := 0;                     // Taste löschen
  END;
end;

procedure TMpegEdit.DateienDragDrop(Sender, Source: TObject; X, Y: Integer);

VAR Knoten : TTreeNode;
    Quelle, Ziel : Integer;

begin
  IF (Source = Dateien) AND DateienListeDragDrop THEN
  BEGIN
    Knoten := Dateien.GetNodeAt(X, Y);
    IF Assigned(Knoten) AND
       Assigned(Dateien.Selected) THEN
    BEGIN
      Quelle := Dateien.Selected.Parent.IndexOf(Dateien.Selected);
      Ziel := Knoten.Parent.IndexOf(Knoten);
      IF DateienListeAudioKnotenverschieben(Quelle, Ziel) = 0 THEN
        Dateien.Select([Knoten.Parent.Item[Ziel]]);
    END;
  END;
end;

procedure TMpegEdit.DateienDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);

VAR Knoten : TTreeNode;

begin
  Accept := False;
  IF (Source = Dateien) AND DateienListeDragDrop THEN
  BEGIN
    Knoten := Dateien.GetNodeAt(X, Y);
    IF Assigned(Knoten) AND
       Assigned(Dateien.Selected) AND
       (Knoten.Level > 0) AND
       (Dateien.Selected.Level > 0) AND
       (Dateien.Selected.Parent.IndexOf(Dateien.Selected) > 0) AND
       (Knoten.Parent.IndexOf(Knoten) > 0) AND
       (Knoten <> Dateien.Selected) AND
       (Knoten.Parent = Dateien.Selected.Parent) THEN
      Accept := True;
  END;
end;

procedure TMpegEdit.DateienEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  DateienListeDragDrop := False;
end;

procedure TMpegEdit.DateienStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  DateienListeDragDrop := True;
end;


// ------------- Kapitelliste ---------------

PROCEDURE TMpegEdit.KapitelListeInit;
BEGIN
  KapitelListeGrid.Tag := 1;
  Mausposition.X := -1;
  Mausposition.Y := -1;
  KapitelListeDragDrop := False;
  KapitelListeKopieren := False;
  KapitelkopierenListe := TListe.Create;
END;

PROCEDURE TMpegEdit.KapitelListeFormat;
BEGIN
  KapitelListeGrid.Font.Color := ArbeitsumgebungObj.KapitellistenVGFarbe;
  KapitelListeGrid.Color := ArbeitsumgebungObj.KapitellistenHGFarbe;
  KapitelListeGrid.ColWidths[0] := ArbeitsumgebungObj.KapitellisteSpaltenbreite1;
  KapitelListeGrid.ColWidths[1] := ArbeitsumgebungObj.KapitellisteSpaltenbreite2;
  KapitelListeGrid.ColWidths[2] := ArbeitsumgebungObj.KapitellisteSpaltenbreite3;
  KapitelListeGrid.ColWidths[3] := ArbeitsumgebungObj.KapitellisteSpaltenbreite4;
END;

PROCEDURE TMpegEdit.KapitelListeSpracheaendern(Spracheladen: TSprachen);
BEGIN
  KapitelListeGrid.Cells[0, 0] := Wortlesen(Spracheladen, 'Video', 'Video');
  KapitelListeGrid.Cells[1, 0] := Wortlesen(Spracheladen, 'Audio', 'Audio');
  KapitelListeGrid.Cells[2, 0] := Wortlesen(Spracheladen, 'Kapitel', 'Kapitel');
  KapitelListeGrid.Cells[3, 0] := Wortlesen(Spracheladen, 'Name', 'Name');
END;

PROCEDURE TMpegEdit.KapitelListeFormatspeichern;
BEGIN
  ArbeitsumgebungObj.KapitellisteSpaltenbreite1 := KapitelListeGrid.ColWidths[0];
  ArbeitsumgebungObj.KapitellisteSpaltenbreite2 := KapitelListeGrid.ColWidths[1];
  ArbeitsumgebungObj.KapitellisteSpaltenbreite3 := KapitelListeGrid.ColWidths[2];
  ArbeitsumgebungObj.KapitellisteSpaltenbreite4 := KapitelListeGrid.ColWidths[3];
END;

PROCEDURE TMpegEdit.KapitelListeClose;
BEGIN
  KapitelkopierenListeloeschen;
  KapitelkopierenListe.Free;
  KapitelkopierenListe := NIL;
END;

PROCEDURE TMpegEdit.KapitelListeVerschiebemodus(aktiv: Boolean);
BEGIN
  IF aktiv THEN
  BEGIN
    KapitelListeGrid.DragMode := dmAutomatic;
    KapitelListeGrid.Font.Color := ArbeitsumgebungObj.KapitellistenVerschiebeVGFarbe;
    KapitelListeGrid.Color := ArbeitsumgebungObj.KapitellistenVerschiebeHGFarbe;
  END
  ELSE
  BEGIN
    KapitelListeGrid.DragMode := dmManual;
    KapitelListeGrid.Font.Color := ArbeitsumgebungObj.KapitellistenVGFarbe;
    KapitelListeGrid.Color := ArbeitsumgebungObj.KapitellistenHGFarbe;
  END;
END;

PROCEDURE TMpegEdit.KapitelListeZeilenberechnen;

VAR Zeilen : Integer;

BEGIN
  Zeilen := Trunc((KapitelListeGrid.ClientHeight - 8) / KapitelListeGrid.DefaultRowHeight) - 1;
  IF Zeilen > KapitelListeGrid.Tag THEN
    KapitelListeGrid.RowCount := Zeilen
  ELSE
    KapitelListeGrid.RowCount := KapitelListeGrid.Tag + 1;
END;

FUNCTION TMpegEdit.Kapiteleintragkopieren(Kapiteleintrag : TKapiteleintrag): TKapiteleintrag;
BEGIN
  IF Assigned(Kapiteleintrag) THEN
  BEGIN
    Result := TKapiteleintrag.Create;
    Result.Kapitel := Kapiteleintrag.Kapitel;
    Result.Videoknoten := Kapiteleintrag.Videoknoten;
    Result.Audioknoten := Kapiteleintrag.Audioknoten;
    Result.BilderproSek := Kapiteleintrag.BilderproSek;
  END
  ELSE
    Result := NIL;
END;

PROCEDURE TMpegEdit.KapitelkopierenListeloeschen;

VAR I : Integer;

BEGIN
  FOR I := 0 TO KapitelkopierenListe.Count - 1 DO
    Stringliste_loeschen(TStrings(KapitelkopierenListe.Items[I]));
  KapitelkopierenListe.Loeschen;
END;

PROCEDURE TMpegEdit.KapitelkopierenListekopieren(Anfang, Ende: Integer);

VAR I : Integer;
    Zeile : TStringList;

BEGIN
  IF (Anfang > 0) AND
     (Ende < KapitelListeGrid.Tag) AND
     (Anfang < Ende + 1) THEN
  BEGIN
    KapitelkopierenListeloeschen;
    FOR I := Anfang TO Ende DO
    BEGIN
      Zeile := TStringList.Create;
      Zeile.Assign(KapitelListeGrid.Rows[I]);
      Zeile.Objects[2] := Kapiteleintragkopieren(TKapiteleintrag(KapitelListeGrid.Rows[I].Objects[2]));
      KapitelkopierenListe.Add(Zeile);
    END;
  END;
END;

PROCEDURE TMpegEdit.KapitelListekopierenClipboard;

VAR I, J : Integer;
    HString : STRING;

BEGIN
  Clipboard.AsText := '';
  FOR I := KapitelListeGrid.Selection.Top TO KapitelListeGrid.Selection.Bottom DO
  BEGIN
    HString := '';
    FOR J := KapitelListeGrid.Selection.Left TO KapitelListeGrid.Selection.Right DO
    BEGIN
      IF J > KapitelListeGrid.Selection.Left THEN
        HString := HString + Chr(9);
      HString := HString + KapitelListeGrid.Cells[J, I];
    END;
    IF I > KapitelListeGrid.Selection.Top THEN
      Clipboard.AsText := Clipboard.AsText + Chr(13) + Chr(10);
    Clipboard.AsText := Clipboard.AsText + HString;
  END;
END;

PROCEDURE TMpegEdit.KapitelListeeinfuegenClipboard;

VAR I, J,
    Position1,
    Position2 : Integer;
    Zeile,
    Text : TStringList;
    Kapiteleintrag : TKapiteleintrag;

BEGIN
  IF Clipboard.HasFormat(CF_TEXT) THEN
  BEGIN
    Text := TStringList.Create;
    Zeile := TStringList.Create;
    TRY
      Text.Text := Clipboard.AsText;
      I := 0;
      WHILE I < Text.Count DO
      BEGIN
        J := 0;
        WHILE J < KapitelListeGrid.Selection.Left DO
        BEGIN
          Zeile.Add('');
          Inc(J);
        END;
        Position1 := 1;
        WHILE (J < KapitelListeGrid.ColCount) AND (Position1 < Length(Text.Strings[I]) + 1) DO
        BEGIN
          Position2 := PosX(Chr(9), Text.Strings[I], Position1, False);
          IF Position2 = 0 THEN
            Position2 := Length(Text.Strings[I]) + 1;
          Zeile.Add(Copy(Text.Strings[I], Position1, Position2 - Position1));
          Position1 := Position2 + 1;
          Inc(J);
        END;
        WHILE J < KapitelListeGrid.ColCount DO
        BEGIN
          Zeile.Add('');
          Inc(J);
        END;
        Kapiteleintrag := TKapiteleintrag.Create;
        Kapiteleintrag.Videoknoten := aktVideoknoten;
        Kapiteleintrag.Audioknoten := aktAudioknoten;
        IF Assigned(Kapiteleintrag.Videoknoten) AND
           (Kapiteleintrag.Videoknoten.Level > 0) THEN
          Kapiteleintrag.Videoknoten := Kapiteleintrag.Videoknoten.Parent;
        IF Assigned(Kapiteleintrag.Audioknoten) AND
           (Kapiteleintrag.Audioknoten.Level > 0) THEN
          Kapiteleintrag.Audioknoten := Kapiteleintrag.Audioknoten.Parent;
        Kapiteleintrag.BilderproSek := BilderproSek;
        Kapiteleintrag.Kapitel := ZeitStrInBildnummer(Zeile.Strings[2], BilderproSek, ArbeitsumgebungObj.KapitelImportZeitTrennzeichenliste, False);
        IF Kapiteleintrag.Kapitel > -1 THEN
          Zeile.Strings[2] := BildnummerInZeitStr(ArbeitsumgebungObj.KapitelFormat, Kapiteleintrag.Kapitel, BilderProSek);
        Zeile.Objects[2] := Kapiteleintrag;
        IF Assigned(Kapiteleintrag.Videoknoten) THEN
          Zeile.Strings[0] := IntToStrFmt(DateienlisteHauptknotenNr(Kapiteleintrag.Videoknoten), 2);
        IF Assigned(Kapiteleintrag.Audioknoten) THEN
          Zeile.Strings[1] := IntToStrFmt(DateienlisteHauptknotenNr(Kapiteleintrag.Audioknoten), 2);
        IF KapitelListeZeileeinfuegen(Zeile, KapitelListeEinfuegePosition, False) = 0 THEN
        BEGIN
          IF ArbeitsumgebungObj.Kapiteleinfuegen = 0 THEN
            KapitelListeMarkierungPlus(1);
          Projektgeaendert_setzen(3);
        END
        ELSE
          Kapiteleintrag.Free;
        Zeile.Clear;
        Inc(I);
      END;
    FINALLY
      Text.Free;
      Zeile.Free;
    END;
  END;
END;

// bestimmt die Einfügeposition, vor oder nach der Markierung oder am Ende der Liste
FUNCTION TMpegEdit.KapitelListeEinfuegePosition: Integer;
BEGIN
  CASE ArbeitsumgebungObj.Kapiteleinfuegen OF
    0: Result := KapitelListeGrid.Selection.Top;
    1: BEGIN
         Result := KapitelListeGrid.Selection.Bottom;
         IF Result < KapitelListeGrid.Tag THEN
           Inc(Result);
       END;
    2: Result := KapitelListeGrid.Tag;
  ELSE
    Result := KapitelListeGrid.Selection.Top;
  END;
END;

// verschiebt eine Zeile auf eine neue Position, alle Zeilen dazwischen rücken nach
FUNCTION TMpegEdit.KapitelListeZeileverschieben(Quelle, Ziel: Integer): Integer;

VAR Zeile : TStringList;
    I : Integer;

BEGIN
  IF (Quelle > 0) AND
     (Quelle < KapitelListeGrid.Tag) AND
     (Ziel > 0) AND
     (Ziel < KapitelListeGrid.Tag) THEN
  BEGIN
    Zeile := TStringList.Create;
    TRY
      Zeile.Assign(KapitelListeGrid.Rows[Quelle]);        // Quellzeile sichern
      IF Quelle < Ziel THEN                               // Quelle steht über Ziel (Quelle ist kleiner)
        FOR I := Quelle TO Ziel - 1 DO                    // alle Zeilen eins nach oben verschieben
          KapitelListeGrid.Rows[I] := KapitelListeGrid.Rows[I + 1]
      ELSE                                                // Ziel steht über Quelle
        FOR I := Quelle DOWNTO Ziel + 1 DO                // alle Zeilen eins nach unten verschieben
          KapitelListeGrid.Rows[I] := KapitelListeGrid.Rows[I - 1];
      KapitelListeGrid.Rows[Ziel] := Zeile;               // gesicherte Quelle auf Ziel kopieren
    FINALLY
      Zeile.Free;
    END;  
    Result := 0;
  END
  ELSE
    Result := -1;
END;

// verschiebt mehrere Zeilen auf eine neue Position, alle Zeilen dazwischen rücken nach
FUNCTION TMpegEdit.KapitelListeZeilenverschieben(Quelle, Ziel, Anzahl: Integer): Integer;

VAR I : Integer;

BEGIN
  IF (Quelle > 0) AND
     (Quelle + Anzahl - 1 < KapitelListeGrid.Tag) AND
     (Ziel > 0) AND
     (Ziel + Anzahl - 1 < KapitelListeGrid.Tag) THEN
  BEGIN
    Result := 0;
    IF Quelle < Ziel THEN
      FOR I := 1 TO Anzahl DO
        Result := KapitelListeZeileverschieben(Quelle, Ziel + Anzahl - 1)
    ELSE
      FOR I := 1 TO Anzahl DO
        Result := KapitelListeZeileverschieben(Quelle + Anzahl -1, Ziel)
  END
  ELSE
    Result := -1;
END;

// kopiert eine Zeile auf eine neue Position, alle Zeilen dazwischen rücken nach
FUNCTION TMpegEdit.KapitelListeZeileKopieren(Quelle, Ziel: Integer): Integer;

VAR Zeile : TStringList;

BEGIN
  IF (Quelle > 0) AND
     (Quelle < KapitelListeGrid.Tag) THEN
  BEGIN
    Zeile := TStringList.Create;
    TRY
      Zeile.Assign(KapitelListeGrid.Rows[Quelle]);        // Quellzeile kopieren
      Result := KapitelListeZeileeinfuegen(Zeile, Ziel, True);
    FINALLY
      Zeile.Free;
    END;
  END
  ELSE
    Result := -1;
END;

// kopiert mehrere Zeilen auf eine neue Position, alle Zeilen dazwischen rücken nach
FUNCTION TMpegEdit.KapitelListeZeilenKopieren(Quelle, Ziel, Anzahl: Integer): Integer;

VAR I : Integer;

BEGIN
  IF (Quelle > 0) AND
     (Quelle + Anzahl - 1 < KapitelListeGrid.Tag) THEN
  BEGIN
    Result := 0;
    FOR I := 1 TO Anzahl DO
      IF Quelle + Anzahl - I > Ziel - 1 THEN
        Result := KapitelListeZeileKopieren(Quelle + Anzahl - 1, Ziel)
      ELSE
        Result := KapitelListeZeileKopieren(Quelle + Anzahl - I, Ziel);
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.KapitelListeZeileeinfuegen(Zeile: TStrings; Position: Integer; Datenkopieren: Boolean): Integer;

VAR Selektion : TGridRect;

BEGIN
  IF Position > KapitelListeGrid.Tag THEN
    Position := KapitelListeGrid.Tag;
  IF Assigned(Zeile) AND
     (Position > 0) AND
     (Position < KapitelListeGrid.Tag + 1) THEN
  BEGIN
    KapitelListeGrid.Tag := KapitelListeGrid.Tag + 1;
    IF KapitelListeGrid.Tag > KapitelListeGrid.RowCount - 1 THEN
    BEGIN
      Selektion := KapitelListeGrid.Selection;   // ändern von RowCount ändert die Selektion
      KapitelListeGrid.RowCount := KapitelListeGrid.Tag + 1;
      KapitelListeGrid.Selection := Selektion;
    END;
    Result := KapitelListeZeilenverschieben(Position, Position + 1, KapitelListeGrid.Tag - 1 - Position);
    IF Result = 0 THEN
    BEGIN
      KapitelListeGrid.Rows[Position] := Zeile;
      IF Datenkopieren THEN
        KapitelListeGrid.Rows[Position].Objects[2] := Kapiteleintragkopieren(TKapiteleintrag(Zeile.Objects[2]));
    END;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.KapitelListeZeileeinfuegen1(Kapitel, Position: Integer; BilderProSek: Real; VideoKnoten, AudioKnoten: TTreeNode; Kapitelname: STRING): Integer;

VAR KapitelEintrag : TKapiteleintrag;
    Zeile : TStringList;

BEGIN
  KapitelEintrag := TKapiteleintrag.Create;
  Zeile := TStringList.Create;
  TRY
    KapitelEintrag.Kapitel := Kapitel;
    IF Assigned(VideoKnoten) AND
       (VideoKnoten.Level > 0) THEN
      KapitelEintrag.Videoknoten := VideoKnoten.Parent
    ELSE
      KapitelEintrag.Videoknoten := VideoKnoten;
    IF Assigned(AudioKnoten) AND
       (AudioKnoten.Level > 0) THEN
      KapitelEintrag.Audioknoten := AudioKnoten.Parent
    ELSE
      KapitelEintrag.Audioknoten := AudioKnoten;
    KapitelEintrag.BilderproSek := BilderProSek;
    Zeile.Add(IntToStrFmt(DateienlisteHauptknotenNr(VideoKnoten), 2));
    Zeile.Add(IntToStrFmt(DateienlisteHauptknotenNr(AudioKnoten), 2));
    Zeile.AddObject(BildnummerInZeitStr(ArbeitsumgebungObj.KapitelFormat, Kapitel, BilderProSek), KapitelEintrag);
    Zeile.Add(Kapitelname);
    Result := KapitelListeZeileeinfuegen(Zeile, Position, False);
  FINALLY
    Zeile.Free;
  END;
END;

FUNCTION TMpegEdit.KapitelListeZeileneinfuegen(Zeilen: TListe; Position: Integer; Datenkopieren: Boolean): Integer;

VAR I : Integer;

BEGIN
  IF Position > KapitelListeGrid.Tag THEN
    Position := KapitelListeGrid.Tag;
  IF Assigned(Zeilen) AND
     (Position > 0) AND
     (Position < KapitelListeGrid.Tag + 1) THEN
  BEGIN
    FOR I := Zeilen.Count - 1 DOWNTO 0 DO
      KapitelListeZeileeinfuegen(Zeilen.Items[I], Position, Datenkopieren);
    Result := 0;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.KapitelListeZeileaendern1(Kapitel, Position: Integer; BilderProSek: Real; VideoKnoten, AudioKnoten: TTreeNode; Kapitelname: STRING): Integer;

VAR KapitelEintrag : TKapiteleintrag;

BEGIN
  IF (Position > 0) AND
     (Position < KapitelListeGrid.Tag + 1) THEN
  BEGIN
    KapitelEintrag := TKapiteleintrag(KapitelListeGrid.Objects[2, Position]);
    IF NOT Assigned(KapitelEintrag) THEN
      KapitelEintrag := TKapiteleintrag.Create;
    KapitelEintrag.Kapitel := Kapitel;
    IF Assigned(VideoKnoten) AND
       (VideoKnoten.Level > 0) THEN
      KapitelEintrag.Videoknoten := VideoKnoten.Parent
    ELSE
      KapitelEintrag.Videoknoten := VideoKnoten;
    IF Assigned(AudioKnoten) AND
       (AudioKnoten.Level > 0) THEN
      KapitelEintrag.Audioknoten := AudioKnoten.Parent
    ELSE
      KapitelEintrag.Audioknoten := AudioKnoten;
    KapitelEintrag.BilderproSek := BilderProSek;
    KapitelListeGrid.Cells[0, Position] := IntToStrFmt(DateienlisteHauptknotenNr(VideoKnoten), 2);
    KapitelListeGrid.Cells[1, Position] := IntToStrFmt(DateienlisteHauptknotenNr(AudioKnoten), 2);
    KapitelListeGrid.Cells[2, Position] := BildnummerInZeitStr(ArbeitsumgebungObj.KapitelFormat, Kapitel, BilderProSek);
    KapitelListeGrid.Cells[3, Position] := Kapitelname;
    KapitelListeGrid.Objects[2, Position] := KapitelEintrag;
    Result := 0;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.KapitelListeTrennzeileeinfuegen(Position: Integer; Name: STRING): Integer;

VAR Zeile : TStringList;

BEGIN
  Zeile := TStringList.Create;
  TRY
    Zeile.Add(ArbeitsumgebungObj.KapitelTrennzeile1);
    Zeile.Add(ArbeitsumgebungObj.KapitelTrennzeile2);
    Zeile.Add(ArbeitsumgebungObj.KapitelTrennzeile3);
    Zeile.Add(Name);
    Result := KapitelListeZeileeinfuegen(Zeile, Position, False);
  FINALLY
    Zeile.Free;
  END;
END;

FUNCTION TMpegEdit.KapitelListeZeilenloeschen(Anfang, Ende: Integer): Integer;

VAR I, J : Integer;

BEGIN
  IF (Anfang > 0) AND
     (Ende < KapitelListeGrid.Tag) AND
     (Anfang < Ende + 1) THEN
  BEGIN
    Result := KapitelListeZeilenverschieben(Ende + 1, Anfang, KapitelListeGrid.Tag - Ende - 1);
    IF Result = 0 THEN
    BEGIN
      FOR I := KapitelListeGrid.Tag - (Ende - Anfang + 1) TO KapitelListeGrid.Tag - 1 DO
        FOR J := 0 TO KapitelListeGrid.ColCount - 1 DO
        BEGIN
          IF Assigned(KapitelListeGrid.Objects[J, I]) THEN
            KapitelListeGrid.Objects[J, I].Free;
          KapitelListeGrid.Cells[J, I] := '';
        END;
      KapitelListeGrid.Tag := KapitelListeGrid.Tag - (Ende - Anfang + 1);
      KapitelListeZeilenberechnen;
    END;
  END
  ELSE
    Result := -1;
END;

PROCEDURE TMpegEdit.KapitelListeloeschen;
BEGIN
  IF KapitelListeZeilenloeschen(1, KapitelListeGrid.Tag - 1) = 0 THEN
    KapitelListeMarkierungsetzen(-1, KapitelListeGrid.Tag, -1, KapitelListeGrid.Tag);
END;

FUNCTION TMpegEdit.KapitelListeMarkierungsetzen(Links, Oben, Rechts, Unten: Integer): Integer;

VAR Selektion : TGridRect;

BEGIN
  IF (Links < Rechts + 1) AND
     (Oben < Unten + 1) THEN
  BEGIN
    IF Links > KapitelListeGrid.ColCount - 1 THEN
      Links := KapitelListeGrid.ColCount - 1;
    IF Rechts > KapitelListeGrid.ColCount - 1 THEN
      Rechts := KapitelListeGrid.ColCount - 1;
    IF Oben = 0 THEN
      Oben := 1;
    IF Unten = 0 THEN
      Unten := 1;
    IF Oben > KapitelListeGrid.RowCount - 1 THEN
      Oben := KapitelListeGrid.RowCount - 1;
    IF Unten > KapitelListeGrid.RowCount - 1 THEN
      Unten := KapitelListeGrid.RowCount - 1;
    Selektion := KapitelListeGrid.Selection;
    IF Links > - 1 THEN
      Selektion.Left := Links;
    IF Oben > - 1 THEN
      Selektion.Top := Oben;
    IF Rechts > - 1 THEN
      Selektion.Right := Rechts;
    IF Unten > - 1 THEN
      Selektion.Bottom := Unten;
    KapitelListeGrid.Selection := Selektion;
    Result := 0;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.KapitelListeMarkierungPlus(Anzahl: Integer): Integer;

VAR Oben, Unten : Integer;

BEGIN
  IF (KapitelListeGrid.Selection.Top < KapitelListeGrid.Tag) AND
     (KapitelListeGrid.Selection.Top > 0)THEN
  BEGIN
    Oben := KapitelListeGrid.Selection.Top + Anzahl;
    Unten := KapitelListeGrid.Selection.Bottom + Anzahl;
    IF Oben > KapitelListeGrid.Tag THEN
    BEGIN
      Oben := KapitelListeGrid.Tag;
      Unten := KapitelListeGrid.Selection.Bottom + KapitelListeGrid.Tag - KapitelListeGrid.Selection.Top;
    END;
    IF Oben < 1 THEN
    BEGIN
      Oben := 1;
      Unten := KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1;
    END;
    Result := KapitelListeMarkierungsetzen(-1, Oben, -1, Unten);
  END
  ELSE
    Result := 0;
END;

FUNCTION TMpegEdit.KapitelListeKapitelexportieren(Dateiname: STRING; Anfang, Ende: Integer): Integer;

VAR KapitelListeneu : TStringList;
    I, Kapitel : Integer;

BEGIN
  IF (Anfang < 1) THEN
    Anfang := 1;
  IF (Ende < 0) THEN
    Ende := KapitelListeGrid.Tag - 1;
  IF (Anfang > 0) AND
     (Ende < KapitelListeGrid.Tag) AND
     (Anfang < Ende + 1) THEN
  BEGIN
    KapitelListeneu := TStringList.Create;
    TRY
      FOR I := Anfang TO Ende DO
      BEGIN
        IF Assigned(KapitelListeGrid.Objects[2, I]) THEN
        BEGIN
          Kapitel := TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Kapitel + ArbeitsumgebungObj.KapitelExportOffset;
          IF Kapitel < 0 THEN
            Kapitel := 0;
          KapitelListeneu.Add(BildnummerInZeitStr(ArbeitsumgebungObj.KapitelExportFormat, Kapitel, TKapitelEintrag(KapitelListeGrid.Objects[2, I]).BilderProSek));
        END;
      END;
      KapitelListeneu.SaveToFile(Dateiname);
    FINALLY
      KapitelListeneu.Free;
    END;
    Result := 0;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.KapitellisteKapitelimportieren(Name: STRING; Position: Integer): Integer;

VAR I, J,
    Kapitelanzahl : Integer;
    ImportListe : TStringList;
    Zahlen : ARRAY OF Integer;

BEGIN
  Result := 0;
  IF FileExists(Name) THEN
  BEGIN
    ImportListe := TStringList.Create;
    TRY
      ImportListe.LoadFromFile(Name);
      IF ImportListe.Count > 0 THEN
      BEGIN
        SetLength(Zahlen, 10);
        I := 0;
        WHILE(I < ImportListe.Count) DO // Zeilenschleife
        BEGIN
          Kapitelanzahl := TextzeileinBildnummern(ImportListe.Strings[I], Zahlen, BilderProSek, ArbeitsumgebungObj.KapitelImportTrennzeichenliste, ArbeitsumgebungObj.KapitelImportZeitTrennzeichenliste, False);
          IF Kapitelanzahl > Length(Zahlen) THEN
          BEGIN
            SetLength(Zahlen, Kapitelanzahl);
            Kapitelanzahl := TextzeileinBildnummern(ImportListe.Strings[I], Zahlen, BilderProSek, ArbeitsumgebungObj.KapitelImportTrennzeichenliste, ArbeitsumgebungObj.KapitelImportZeitTrennzeichenliste, False);
          END;
          FOR J := 0 TO Kapitelanzahl - 1 DO
          BEGIN
            IF KapitelListeZeileeinfuegen1(Zahlen[J], Position, BilderProSek, aktVideoKnoten, aktAudioKnoten, KnotennameausKnoten(aktVideoKnoten, aktAudioKnoten)) = 0 THEN
            BEGIN
              Inc(Position);
              Inc(Result);
            END;
          END;
          Inc(I);
        END;
        Finalize(Zahlen);
      END
      ELSE
        Result := -2;          // Importliste ist leer
    FINALLY
      ImportListe.Free;
    END;
  END
  ELSE
    Result := -1;              // Datei nicht vorhanden
END;

PROCEDURE TMpegEdit.KapitellisteHauptknotenNrneuschreiben;

VAR I : Integer;

BEGIN
  FOR I := 1 TO KapitelListeGrid.Tag - 1 DO
  BEGIN
    IF Assigned(KapitelListeGrid.Objects[2, I]) THEN
    BEGIN
      KapitelListeGrid.Cells[0, I] := IntToStrFmt(DateienlisteHauptknotenNr(TKapitelEintrag(KapitelListeGrid.Objects[2, I]).VideoKnoten), 2);
      KapitelListeGrid.Cells[1, I] := IntToStrFmt(DateienlisteHauptknotenNr(TKapitelEintrag(KapitelListeGrid.Objects[2, I]).AudioKnoten), 2);
    END;
  END;
END;

FUNCTION TMpegEdit.KapitelEintraegevorhanden(Knoten: TTreeNode): Integer;

VAR I : Integer;

BEGIN
  Result := 0;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    I := 1;
    WHILE I < KapitelListeGrid.Tag DO
    BEGIN
      IF Assigned(KapitelListeGrid.Objects[2, I]) AND
         ((Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Videoknoten) OR
         (Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Videoknoten.Parent) OR
         (Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Audioknoten) OR
         (Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Audioknoten.Parent)) THEN
        Inc(Result);
      Inc(I);
    END;
  END;
END;

PROCEDURE TMpegEdit.KapitelEintraegeloeschen(Knoten: TTreeNode);

VAR I, Oben, Unten : Integer;

BEGIN
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    Oben := KapitelListeGrid.Selection.Top;
    Unten := KapitelListeGrid.Selection.Bottom;
    I := 1;
    WHILE I < KapitelListeGrid.Tag DO
    BEGIN
      IF Assigned(KapitelListeGrid.Objects[2, I]) AND
         ((Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Videoknoten) OR
         (Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Videoknoten.Parent) OR
         (Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Audioknoten) OR
         (Knoten = TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Audioknoten.Parent)) THEN
      BEGIN
        KapitelListeZeilenloeschen(I, I);
        IF I < Oben THEN
        BEGIN
          Dec(Oben);
          Dec(Unten);
        END
        ELSE
        BEGIN
          IF I < Unten + 1 THEN
            Dec(Unten);
          IF Unten < Oben THEN
          BEGIN
            Oben := KapitelListeGrid.Tag;
            Unten := KapitelListeGrid.Tag;
          END;
        END;
      END
      ELSE
        Inc(I);
    END;
    KapitelListeMarkierungsetzen(-1, Oben, -1, Unten);
  END;
END;

FUNCTION TMpegEdit.KapitelListeSchnittpunkteimportieren(Position: Integer): Integer;

VAR I : Integer;

BEGIN
  Result := 0;
  IF Schnittliste.Count > 0 THEN
  BEGIN
    FOR I := 0 TO Schnittliste.Count -1 DO
      IF ((Schnittliste.SelCount = 0) OR
          Schnittliste.Selected[I]) AND
          Assigned(Schnittliste.Items.Objects[I]) THEN
      BEGIN
        KapitelListeZeileeinfuegen1(TSchnittpunkt(Schnittliste.Items.Objects[I]).Anfang, Position,
                                    TSchnittpunkt(Schnittliste.Items.Objects[I]).Framerate,
                                    TSchnittpunkt(Schnittliste.Items.Objects[I]).Videoknoten,
                                    TSchnittpunkt(Schnittliste.Items.Objects[I]).Audioknoten,
                                    KnotennameausKnoten(TSchnittpunkt(Schnittliste.Items.Objects[I]).Videoknoten,
                                                        TSchnittpunkt(Schnittliste.Items.Objects[I]).Audioknoten));
        Inc(Position);
        Inc(Result);
      END;
  END
  ELSE
    Result := -1;                             // Schnittliste leer
END;

FUNCTION TMpegEdit.KapitellisteKapitelberechnen(Name: STRING; Anfang, Ende: Integer; SchnittpunktListe, Liste: TStrings): Integer;

VAR I, J, K,
    Laenge : Integer;
    Schnittpunkt : TSchnittpunkt;
    KapitelEintrag : TKapitelEintrag;

BEGIN
  Result := 0;
  IF (Anfang < 1) THEN
    Anfang := 1;
  IF (Ende < 0) THEN
    Ende := KapitelListeGrid.Tag - 1;
  IF (Ende < KapitelListeGrid.Tag) AND
     (Anfang < Ende + 1) THEN
    IF Assigned(SchnittpunktListe) THEN
      IF SchnittpunktListe.Count > 0 THEN
        IF KapitelListeGrid.Tag > 1 THEN
          IF Assigned(Liste) THEN
          BEGIN
            Laenge := 0;
            K := 1;
            Liste.Add('VideoFile=' + ChangeFileExt(Name, ''));
            Liste.Add('BilderProSek=' + FloatToStr(TSchnittpunkt(SchnittpunktListe.Objects[0]).Framerate));
            FOR I := 0 TO SchnittpunktListe.Count -1 DO
            BEGIN
              Schnittpunkt := TSchnittpunkt(SchnittpunktListe.Objects[I]);
              IF Assigned(Schnittpunkt) THEN
              BEGIN
                FOR J := Anfang TO Ende DO
                BEGIN
                  KapitelEintrag := TKapitelEintrag(KapitelListeGrid.Objects[2, J]);
                  IF Assigned(Kapiteleintrag) THEN
                  BEGIN
                    IF KnotenDatengleichVideo(KapitelEintrag.Videoknoten, Schnittpunkt.Videoknoten) AND
                       KnotenDatengleichAudio(KapitelEintrag.Audioknoten, Schnittpunkt.Audioknoten) AND
          //          IF (KapitelEintrag.Videoknoten = Schnittpunkt.Videoknoten) AND
          //             (KapitelEintrag.Audioknoten = Schnittpunkt.Audioknoten) AND
                       (KapitelEintrag.Kapitel >= Schnittpunkt.Anfang) AND (KapitelEintrag.Kapitel <= Schnittpunkt.Ende) THEN
                    BEGIN
                      Liste.Add('Chapter' + IntToStr(K) + '=' + IntToStr(KapitelEintrag.Kapitel - Schnittpunkt.Anfang + Laenge));
                      Inc(K);
                    END;
                  END;
                END;
                Laenge := Laenge + Schnittpunkt.Ende - Schnittpunkt.Anfang + 1;
              END;
            END;
          END
          ELSE
            Result := -5                       // keine KapitelListe übergeben
        ELSE
          Result := -4                         // kein Kapitellisteneintrag
      ELSE
        Result := -3                           // kein Schnittlisteneintrag
    ELSE
      Result := -2                             // keine Schnittliste übergeben
  ELSE
    Result := -1;                              // Anfang, Ende ungültig
END;

FUNCTION TMpegEdit.KapitellisteListespeichern(Name: STRING; Liste: TStrings): Integer;

VAR KapitellisteNeu : TStringList;
    BilderProSek : Real;
    Kapitel,
    I : Integer;

BEGIN
  Result := 0;
  IF Assigned(Liste) AND
     (Liste.Count > 2) THEN
  BEGIN
    I := Liste.Count - 1;
    WHILE (I > -1) AND (Pos('VideoFile=', Liste.Strings[I]) = 0) DO
      Dec(I);                                                                   // letzten "VideoFile" Eintrag suchen
    Inc(I);                                                                     // VideoFile=... wird nicht benutzt
    IF (I < Liste.Count) THEN
      IF (KopiereVonBis(Liste.Strings[I], '', '=', False, False) = 'BilderProSek') THEN
      BEGIN
        BilderProSek := StrToFloatDef(KopiereVonBis(Liste.Strings[I], '=', '', False, False), 25);
        KapitellisteNeu := TStringList.Create;
        TRY
          Inc(I);
          WHILE I < Liste.Count DO
          BEGIN
            Kapitel := StrToIntDef(KopiereVonBis(Liste.Strings[I], '=', '', False, False), 0) + ArbeitsumgebungObj.KapitelExportOffset;
            IF Kapitel < 0 THEN
              Kapitel := 0;                                                     // negativen Offset korrigieren
            KapitellisteNeu.Add(BildnummerInZeitStr(ArbeitsumgebungObj.KapitelExportFormat, Kapitel, BilderProSek));
            Inc(I);
          END;
          IF KapitellisteNeu.Count > 0 THEN
            KapitellisteNeu.SaveToFile(Name);
        FINALLY
          KapitellisteNeu.Free;
        END;
      END
      ELSE
        Result := -3                        // "BilderProSek" fehlt
    ELSE
      Result := -2;                         // keine Kapitel vorhanden
  END
  ELSE
    Result := -1;                           // keine Liste übergeben oder Liste leer
END;

// ------------ Kapitellistenereingnisse -----------------

procedure TMpegEdit.KapitelListeGridClick(Sender: TObject);

VAR Knoten : TTreeNode;
    Kapiteleintrag : TKapiteleintrag;

begin
  Knoten := NIL;
  IF KapitelListeGrid.Row < KapitelListeGrid.Tag THEN
  BEGIN
    Kapiteleintrag := TKapiteleintrag(KapitelListeGrid.Objects[2, KapitelListeGrid.Row]);
    IF Assigned(Kapiteleintrag) THEN
      IF Assigned(Kapiteleintrag.Videoknoten) AND
         Kapiteleintrag.Videoknoten.HasChildren AND
         Assigned(Kapiteleintrag.Videoknoten.Item[0].Data) THEN
        Knoten := Kapiteleintrag.Videoknoten
      ELSE
        IF Assigned(Kapiteleintrag.Audioknoten) THEN
          Knoten := Kapiteleintrag.Audioknoten;
    IF Assigned(Knoten) THEN
      Dateien.Selected := Knoten;
  END;
end;

procedure TMpegEdit.KapitelListeGridDblClick(Sender: TObject);

VAR Kapiteleintrag : TKapiteleintrag;

begin
  CASE KapitelListeGrid.Col OF
  3 : BEGIN
        KapitelnameEdit.Text := KapitelListeGrid.Cells[KapitelListeGrid.Col, KapitelListeGrid.Row];
        KapitelnameEdit.Visible := True;
        KapitelnameEdit.SetFocus;
        KapitelnameEdit.Tag := 1;
      END;
  ELSE
    IF KapitelListeGrid.Row < KapitelListeGrid.Tag THEN
    BEGIN
      Kapiteleintrag := TKapiteleintrag(KapitelListeGrid.Objects[2, KapitelListeGrid.Row]);
      IF Assigned(Kapiteleintrag) THEN
      BEGIN
//        Fortschrittsfensteranzeigen;
        TRY
          IF (DateilisteaktualisierenVideo(Kapiteleintrag.Videoknoten, False) = 0) AND
             (DateilisteaktualisierenAudio(Kapiteleintrag.Audioknoten, False) = 0) THEN
          BEGIN
            Vorschauknotenloeschen;
            IF (Kapiteleintrag.Kapitel > - 1) AND (Kapiteleintrag.Kapitel < SchiebereglerMax) THEN
            BEGIN
              IF Play.Down THEN
              BEGIN
                AbspielModus := False;
                PlayerPause;
              END;
              SchiebereglerPosition_setzen(Kapiteleintrag.Kapitel);
              IF Play.Down THEN
              BEGIN
                PlayerStart;
                AbspielModus := True;
                CutIn.Enabled := False;
                CutOut.Enabled := False;
              END;
            END;
            Schnittpunktanzeigekorrigieren;
          END;
        FINALLY
          Fortschrittsfensterverbergen;
        END;
      END;
      IF Enabled THEN
        Pos0Panel.SetFocus;
    END;
  END;
end;

procedure TMpegEdit.KapitelListeGridEnter(Sender: TObject);
begin
  Kapitellisteaktiv := True;
  IF KapitelnameEdit.Tag = 1 THEN
  BEGIN
    KapitelListeGrid.Cells[KapitelListeGrid.Col, KapitelListeGrid.Row] := KapitelnameEdit.Text;
    KapitelnameEdit.Tag := 0;
    Projektgeaendert_setzen(3);
  END;  
end;

procedure TMpegEdit.KapitelListeGridExit(Sender: TObject);
begin
  Kapitellisteaktiv := False;
end;

procedure TMpegEdit.KapitelListeGridDragDrop(Sender, Source: TObject; X, Y: Integer);

VAR Ziel : Integer;

begin
  Ziel := KapitelListeGrid.MouseCoord(X, Y).Y;
  IF (Source = KapitelListeGrid) AND KapitelListeDragDrop THEN
  BEGIN
    IF KapitelListeKopieren THEN
    BEGIN
      IF KapitelListeZeilenKopieren(KapitelListeGrid.Selection.Top, Ziel, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
        KapitelListeMarkierungsetzen(-1, Ziel, -1, Ziel + KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top);
    END
    ELSE
      IF KapitelListeGrid.Selection.Top < Ziel THEN
      BEGIN
        IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top, Ziel - KapitelListeGrid.Selection.Bottom + KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
          KapitelListeMarkierungsetzen(-1, Ziel - KapitelListeGrid.Selection.Bottom + KapitelListeGrid.Selection.Top, -1, Ziel);
      END
      ELSE
      BEGIN
        IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top, Ziel, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
          KapitelListeMarkierungsetzen(-1, Ziel, -1, Ziel + KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top);
      END;
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelListeGridDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);

VAR Ziel : Integer;

begin
  Accept := False;
  IF (Source = KapitelListeGrid) AND KapitelListeDragDrop THEN
  BEGIN
    Ziel := KapitelListeGrid.MouseCoord(X, Y).Y;
    IF Ziel > 0 THEN
    BEGIN
      IF KapitelListeKopieren THEN
      BEGIN
        KapitelListeGrid.DragCursor := crDragPl;
        IF Ziel < KapitelListeGrid.Tag + 1 THEN
          Accept := True;
      END
      ELSE
      BEGIN
        KapitelListeGrid.DragCursor := crDrag;
        IF ((Ziel < KapitelListeGrid.Selection.Top) OR
           (Ziel > KapitelListeGrid.Selection.Bottom)) AND
           (Ziel < KapitelListeGrid.Tag) THEN
          Accept := True;
      END;    
    END;
  END;
end;

procedure TMpegEdit.KapitelListeGridEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  KapitelListeDragDrop := False;
  KapitelListeKopieren := False;
  KapitelListeVerschiebemodus(False);
end;

procedure TMpegEdit.KapitelListeGridStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  KapitelListeDragDrop := True;
end;

procedure TMpegEdit.KapitelListeGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  IF Key = VK_CONTROL THEN
    KapitelListeVerschiebemodus(True);
  IF Key = VK_SHIFT THEN
    KapitelListeKopieren := True;
  IF Shift = [ssCtrl] THEN
  BEGIN
    IF (Key = VK_UP) THEN
      IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top , KapitelListeGrid.Selection.Top - 1, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
      BEGIN
        KapitelListeMarkierungsetzen(-1, KapitelListeGrid.Selection.Top - 1, -1, KapitelListeGrid.Selection.Bottom - 1);
        Projektgeaendert_setzen(3);
      END;
    IF (Key = VK_DOWN) THEN
      IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top , KapitelListeGrid.Selection.Top + 1, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
      BEGIN
        KapitelListeMarkierungsetzen(-1, KapitelListeGrid.Selection.Top + 1, -1, KapitelListeGrid.Selection.Bottom + 1);
        Projektgeaendert_setzen(3);
      END;
    IF (Key = VK_PRIOR) THEN
      IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top , KapitelListeGrid.Selection.Top - 10, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
      BEGIN
        KapitelListeMarkierungPlus(-10);
        Projektgeaendert_setzen(3);
      END
      ELSE
        Key := VK_HOME;        // es ist nicht mehr genug Platz also bis zum Anfang verschieben
    IF (Key = VK_NEXT) THEN
      IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top , KapitelListeGrid.Selection.Top + 10, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
      BEGIN
        KapitelListeMarkierungPlus(10);
        Projektgeaendert_setzen(3);
      END
      ELSE
        Key := VK_END;        // es ist nicht mehr genug Platz also bis ans Ende verschieben
    IF (Key = VK_HOME) THEN
      IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top , 1, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
      BEGIN
        KapitelListeMarkierungsetzen(-1, 1, -1, KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1);
        Projektgeaendert_setzen(3);
      END;
    IF (Key = VK_END) THEN
      IF KapitelListeZeilenverschieben(KapitelListeGrid.Selection.Top , KapitelListeGrid.Tag - 1 - (KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top), KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top + 1) = 0 THEN
      BEGIN
        KapitelListeMarkierungsetzen(-1, KapitelListeGrid.Tag - 1 - (KapitelListeGrid.Selection.Bottom - KapitelListeGrid.Selection.Top), -1, KapitelListeGrid.Tag - 1);
        Projektgeaendert_setzen(3);
      END;
    IF (Key = Ord('X')) THEN     // Strg X Ausschneiden
      KapitelausschneidenMenuItem.Click;
    IF (Key = Ord('C')) THEN     // Strg C Kopieren
      KapitelkopierenMenuItem.Click;
    IF (Key = Ord('V')) THEN     // Strg V Einfügen
      KapiteleinfuegenMenuItem.Click;
    IF (Key = VK_DELETE) THEN    // Strg Entf Löschen
      KapitelloeschenMenuItem.Click;
    IF (Key = Ord('T')) THEN     // Strg T fügt eine Trennzeile ein
      KapitelListeTrennzeileeinfuegenMenuItem.Click;
    Key := 0;                    // Taste löschen
  END;
  IF (Shift = [ssShift, ssCtrl]) AND (Key = Ord('V')) THEN // Strg V Einfügen Clipboard
  BEGIN
    KapiteleinfuegenClpbrdMenuItem.Click;
    Key := 0;                    // Taste löschen
  END;
end;

procedure TMpegEdit.KapitelListeGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  IF Key = VK_CONTROL THEN
    KapitelListeVerschiebemodus(False);
  IF Key = VK_SHIFT THEN
    KapitelListeKopieren := False;
end;

procedure TMpegEdit.KapitelnameEditKeyPress(Sender: TObject; var Key: Char);
begin
  IF Key = Chr(13) THEN
  BEGIN
    KapitelListeGrid.SetFocus;
    Key := Chr(0);
  END;
end;

procedure TMpegEdit.KapitelnameEditEnter(Sender: TObject);
begin
  KapitellistenEditaktiv := True;
end;

procedure TMpegEdit.KapitelnameEditExit(Sender: TObject);
begin
  KapitelnameEdit.Visible := False;
  IF NOT KapitelListeGrid.Focused THEN
    KapitelnameEdit.Tag := 0;
  KapitellistenEditaktiv := False;
end;

procedure TMpegEdit.KapitelClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Listen.ActivePage := KapitellistenTab;
  IF KapitelListeZeileeinfuegen1(SchiebereglerPosition, KapitelListeEinfuegePosition, BilderProSek, aktVideoKnoten, aktAudioKnoten, KnotennameausKnoten(aktVideoKnoten, aktAudioKnoten)) = 0 THEN
  BEGIN
    IF ArbeitsumgebungObj.Kapiteleinfuegen < 2 THEN
      KapitelListeMarkierungPlus(1);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelvorhereinfuegenMenuItemClick(Sender: TObject);
begin
  Listen.ActivePage := KapitellistenTab;
  IF KapitelListeZeileeinfuegen1(SchiebereglerPosition, KapitelListeGrid.Selection.Top, BilderProSek, aktVideoKnoten, aktAudioKnoten, KnotennameausKnoten(aktVideoKnoten, aktAudioKnoten)) = 0 THEN
  BEGIN
    KapitelListeMarkierungPlus(1);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelnachhereinfuegenMenuItemClick(Sender: TObject);

VAR Position : Integer;

begin
  Listen.ActivePage := KapitellistenTab;
  Position := KapitelListeGrid.Selection.Bottom;
  IF Position < KapitelListeGrid.Tag THEN
    Inc(Position);
  IF KapitelListeZeileeinfuegen1(SchiebereglerPosition, Position, BilderProSek, aktVideoKnoten, aktAudioKnoten, KnotennameausKnoten(aktVideoKnoten, aktAudioKnoten)) = 0 THEN
  BEGIN
    KapitelListeMarkierungPlus(1);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelamEndeeinfuegenMenuItemClick(Sender: TObject);
begin
  Listen.ActivePage := KapitellistenTab;
  IF KapitelListeZeileeinfuegen1(SchiebereglerPosition, KapitelListeGrid.Tag, BilderProSek, aktVideoKnoten, aktAudioKnoten, KnotennameausKnoten(aktVideoKnoten, aktAudioKnoten)) = 0 THEN
    Projektgeaendert_setzen(3);
end;

procedure TMpegEdit.KapitelaendernClick(Sender: TObject);
begin
  Listen.ActivePage := KapitellistenTab;
  KapitelListeZeileaendern1(SchiebereglerPosition, KapitelListeGrid.Row, BilderProSek, aktVideoKnoten, aktAudioKnoten, KnotennameausKnoten(aktVideoKnoten, aktAudioKnoten));
  Projektgeaendert_setzen(3);
end;

procedure TMpegEdit.KapiteltastenMenuePopup(Sender: TObject);
begin
  IF (KapitelListeGrid.Selection.Top > 0) AND
     (KapitelListeGrid.Selection.Top < KapitelListeGrid.Tag + 1) THEN
    KapitelvorhereinfuegenMenuItem.Enabled := True
  ELSE
    KapitelvorhereinfuegenMenuItem.Enabled := False;
  IF (KapitelListeGrid.Selection.Bottom > 0) AND
     (KapitelListeGrid.Selection.Bottom < KapitelListeGrid.Tag) THEN
    KapitelnachhereinfuegenMenuItem.Enabled := True
  ELSE
    KapitelnachhereinfuegenMenuItem.Enabled := False;
  IF (KapitelListeGrid.Selection.Top > 0) AND
     (KapitelListeGrid.Selection.Bottom < KapitelListeGrid.Tag) AND
     (KapitelListeGrid.Selection.Top = KapitelListeGrid.Selection.Bottom) AND
     (Listen.ActivePage = KapitellistenTab) THEN
    Kapitelaendern.Enabled := True
  ELSE
    Kapitelaendern.Enabled := False;
end;

// ------------ KapitellistenPopupmenü ------------------------

procedure TMpegEdit.KapitellistePopupMenuPopup(Sender: TObject);
begin
  IF KapitelListeGrid.Tag > 1 THEN
  BEGIN
    KapitelListeloeschenMenuItem.Enabled := True;
    KapitelListeexportierenMenuItem.Enabled := True;
    KapitelListeberechnenexportierenMenuItem.Enabled := True;
  END
  ELSE
  BEGIN
    KapitelListeloeschenMenuItem.Enabled := False;
    KapitelListeexportierenMenuItem.Enabled := False;
    KapitelListeberechnenexportierenMenuItem.Enabled := False;
  END;
  IF (KapitelListeGrid.Selection.Top > 0) AND
     (KapitelListeGrid.Selection.Bottom < KapitelListeGrid.Tag) THEN
  BEGIN
    KapitelexportierenMenuItem.Enabled := True;
    KapitelberechnenexportierenMenuItem.Enabled := True;
    KapitelverschiebenMenuItem.Enabled := True;
    KapitelausschneidenMenuItem.Enabled := True;
    KapitelkopierenMenuItem.Enabled := True;
    KapitelloeschenMenuItem.Enabled := True;
    KapitelListeMarkierungenaufhebenMenuItem.Enabled := True;
    KapitelListeZeitformataendernMenuItem.Enabled := True;
  END
  ELSE
  BEGIN
    KapitelexportierenMenuItem.Enabled := False;
    KapitelberechnenexportierenMenuItem.Enabled := False;
    KapitelverschiebenMenuItem.Enabled := False;
    KapitelausschneidenMenuItem.Enabled := False;
    KapitelkopierenMenuItem.Enabled := False;
    KapitelloeschenMenuItem.Enabled := False;
    KapitelListeMarkierungenaufhebenMenuItem.Enabled := False;
    KapitelListeZeitformataendernMenuItem.Enabled := False;
  END;
  IF KapitelkopierenListe.Count > 0 THEN
    KapiteleinfuegenMenuItem.Enabled := True
  ELSE
    KapiteleinfuegenMenuItem.Enabled := False;
  IF Clipboard.HasFormat(CF_TEXT) THEN
    KapiteleinfuegenClpbrdMenuItem.Enabled := True
  ELSE
    KapiteleinfuegenClpbrdMenuItem.Enabled := False;
  IF SchnittListe.Count > 0 THEN
    KapitelListeSchnitteimportierenMenuItem.Enabled := True
  ELSE
    KapitelListeSchnitteimportierenMenuItem.Enabled := False;
end;

procedure TMpegEdit.KapitelListeloeschenMenuItemClick(Sender: TObject);
begin
  KapitelListeloeschen;
  Projektgeaendert_setzen(3);
end;

procedure TMpegEdit.KapitelListeimportierenMenuItemClick(Sender: TObject);

VAR Anzahl : Integer;

begin
  Oeffnen.Title := Wortlesen(NIL, 'Dialog71', 'Kapitelliste importieren');
  Oeffnen.Filter := Wortlesen(NIL, 'Dialog33', 'Kapiteldateien') + '|' + ArbeitsumgebungObj.DateiendungenKapitel + '|' +
                    Wortlesen(NIL, 'Dialog61', 'Alle Dateien') + '|*.*';
  Oeffnen.DefaultExt := '';
  Oeffnen.FileName := '';
  Oeffnen.InitialDir := ExtractFilePath(Dateinamebilden(ArbeitsumgebungObj.KapitelVerzeichnis, ArbeitsumgebungObj.Kapiteldateiname, True, True));
  Oeffnen.InitialDir := Verzeichnissuchen(Oeffnen.InitialDir);
  IF Oeffnen.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Oeffnen.FileName);
    Anzahl := KapitellisteKapitelimportieren(Oeffnen.FileName, KapitelListeEinfuegePosition);
    IF Anzahl > 0 THEN
    BEGIN
      IF ArbeitsumgebungObj.Kapiteleinfuegen = 0 THEN
        KapitelListeMarkierungPlus(Anzahl);
      Projektgeaendert_setzen(3);
    END;
  END;
end;

procedure TMpegEdit.KapitelListeexportierenMenuItemClick(Sender: TObject);
begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog72', 'Kapitelliste exportieren');
  Speichern.Filter := Wortlesen(NIL, 'Dialog33', 'Kapiteldateien') + '|' +
                      '*' + ArbeitsumgebungObj.StandardEndungenKapitel + ';' +
                      ArbeitsumgebungObj.DateiendungenKapitel + '|' +
                      Wortlesen(NIL, 'Dialog61', 'Alle Dateien') + '|*.*';
  Speichern.DefaultExt := Copy(ArbeitsumgebungObj.StandardEndungenKapitel, 2, Length(ArbeitsumgebungObj.StandardEndungenKapitel) - 1);
  Speichern.FileName := Dateinamebilden(ArbeitsumgebungObj.KapitelVerzeichnis, ArbeitsumgebungObj.Kapiteldateiname, True, True);
  Speichern.InitialDir := ExtractFilePath(Speichern.FileName);
  Verzeichniserstellen(Speichern.InitialDir);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    IF FileExists(Speichern.FileName) THEN
    BEGIN
      IF DeleteFile(Speichern.FileName) THEN
      BEGIN
        IF KapitelListeKapitelexportieren(Speichern.FileName, 1, KapitelListeGrid.Tag - 1) = 0 THEN
//          Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END
      ELSE
        Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                        Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//        ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
    END
    ELSE
    BEGIN
      IF KapitelListeKapitelexportieren(Speichern.FileName, 1, KapitelListeGrid.Tag - 1) = 0 THEN
//        Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
    END;
  END;
end;

procedure TMpegEdit.KapitelexportierenMenuItemClick(Sender: TObject);
begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog72', 'Kapitelliste exportieren');
  Speichern.Filter := Wortlesen(NIL, 'Dialog33', 'Kapiteldateien') + '|' +
                      '*' + ArbeitsumgebungObj.StandardEndungenKapitel + ';' +
                      ArbeitsumgebungObj.DateiendungenKapitel + '|' +
                      Wortlesen(NIL, 'Dialog61', 'Alle Dateien') + '|*.*';
  Speichern.DefaultExt := Copy(ArbeitsumgebungObj.StandardEndungenKapitel, 2, Length(ArbeitsumgebungObj.StandardEndungenKapitel) - 1);
  Speichern.FileName := Dateinamebilden(ArbeitsumgebungObj.KapitelVerzeichnis, ArbeitsumgebungObj.Kapiteldateiname, True, True);
  Speichern.InitialDir := ExtractFilePath(Speichern.FileName);
  Verzeichniserstellen(Speichern.InitialDir);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    IF FileExists(Speichern.FileName) THEN
    BEGIN
      IF DeleteFile(Speichern.FileName) THEN
      BEGIN
        IF KapitelListeKapitelexportieren(Speichern.FileName, KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom) = 0 THEN
//          Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END
      ELSE
        Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                        Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//        ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
    END
    ELSE
    BEGIN
      IF KapitelListeKapitelexportieren(Speichern.FileName, KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom) = 0 THEN
//        Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
    END;
  END;
end;

procedure TMpegEdit.KapitelListeSchnitteimportierenMenuItemClick(Sender: TObject);

VAR Anzahl : Integer;

begin
  Anzahl := KapitelListeSchnittpunkteimportieren(KapitelListeEinfuegePosition);
  IF Anzahl > 0 THEN
  BEGIN
    IF ArbeitsumgebungObj.Kapiteleinfuegen = 0 THEN
      KapitelListeMarkierungPlus(Anzahl);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelberechnenexportierenMenuItemClick(Sender: TObject);

VAR I : Integer;
    Schnittpunkt : TSchnittpunkt;
    HSchnittListe,
    Kapitel : TStringList;

begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog72', 'Kapitelliste exportieren');
  Speichern.Filter := Wortlesen(NIL, 'Dialog33', 'Kapiteldateien') + '|' +
                      '*' + ArbeitsumgebungObj.StandardEndungenKapitel + ';' +
                      ArbeitsumgebungObj.DateiendungenKapitel + '|' +
                      Wortlesen(NIL, 'Dialog61', 'Alle Dateien') + '|*.*';
  Speichern.DefaultExt := Copy(ArbeitsumgebungObj.StandardEndungenKapitel, 2, Length(ArbeitsumgebungObj.StandardEndungenKapitel) - 1);
  Speichern.FileName := Dateinamebilden(ArbeitsumgebungObj.KapitelVerzeichnis, ArbeitsumgebungObj.Kapiteldateiname, True, True);
  Speichern.InitialDir := ExtractFilePath(Speichern.FileName);
  Verzeichniserstellen(Speichern.InitialDir);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    HSchnittListe := TStringList.Create;
    Kapitel := TStringList.Create;
    TRY
      FOR I := 0 TO SchnittListe.Items.Count - 1 DO
        IF (NOT MarkierteSchnittpunkte.Down) OR SchnittListe.Selected[I] THEN
        BEGIN
          Schnittpunkt := TSchnittpunkt.Create;
          Schnittpunkt_kopieren(TSchnittpunkt(SchnittListe.Items.Objects[I]), Schnittpunkt);
          HSchnittListe.AddObject('', Schnittpunkt);
        END;
      IF Sender = KapitelberechnenexportierenMenuItem THEN
        KapitellisteKapitelberechnen('', KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom, HSchnittListe, Kapitel)
      ELSE
        KapitellisteKapitelberechnen('', -1, -1, HSchnittListe, Kapitel);
      IF FileExists(Speichern.FileName) THEN
      BEGIN
        IF DeleteFile(Speichern.FileName) THEN
        BEGIN
          IF KapitellisteListespeichern(Speichern.FileName, Kapitel) = 0 THEN
//            Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
        END
        ELSE
          Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
      END
      ELSE
      BEGIN
        IF KapitellisteListespeichern(Speichern.FileName, Kapitel) = 0 THEN
//          Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END;
    FINALLY
      Kapitel.Free;
      Stringliste_loeschen(HSchnittListe);
      HSchnittListe.Free;
    END;
  END;
end;

procedure TMpegEdit.KapitelverschiebenMenuItemClick(Sender: TObject);
begin
  KapitelListeVerschiebemodus(True);
end;

procedure TMpegEdit.KapitelausschneidenMenuItemClick(Sender: TObject);
begin
  KapitelkopierenListekopieren(KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom);
  IF KapitelListeZeilenloeschen(KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom) = 0 THEN
  BEGIN
    KapitelListeMarkierungsetzen(-1, KapitelListeGrid.Tag, -1, KapitelListeGrid.Tag);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelkopierenMenuItemClick(Sender: TObject);
begin
  KapitelkopierenListekopieren(KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom);
  KapitelListekopierenClipboard;
end;

procedure TMpegEdit.KapiteleinfuegenMenuItemClick(Sender: TObject);
begin
  IF KapitelListeZeileneinfuegen(KapitelkopierenListe, KapitelListeEinfuegePosition, True) = 0 THEN
  BEGIN
    IF ArbeitsumgebungObj.Kapiteleinfuegen = 0 THEN
      KapitelListeMarkierungPlus(KapitelkopierenListe.Count);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelloeschenMenuItemClick(Sender: TObject);
begin
  IF KapitelListeZeilenloeschen(KapitelListeGrid.Selection.Top, KapitelListeGrid.Selection.Bottom) = 0 THEN
  BEGIN
    KapitelListeMarkierungsetzen(-1, KapitelListeGrid.Tag, -1, KapitelListeGrid.Tag);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapiteleinfuegenClpbrdMenuItemClick(Sender: TObject);
begin
  KapitelListeeinfuegenClipboard;
end;

procedure TMpegEdit.KapitelListeMarkierungenaufhebenMenuItemClick(Sender: TObject);
begin
  KapitelListeMarkierungsetzen(-1, KapitelListeGrid.Tag, -1, KapitelListeGrid.Tag);
end;

procedure TMpegEdit.KapitelListeTrennzeileeinfuegenMenuItemClick(Sender: TObject);
begin
  IF KapitelListeTrennzeileeinfuegen(KapitelListeGrid.Selection.Top, ArbeitsumgebungObj.KapitelTrennzeile4) = 0 THEN
  BEGIN
    KapitelListeMarkierungPlus(1);
    Projektgeaendert_setzen(3);
  END;
end;

procedure TMpegEdit.KapitelListeZeitformataendernMenuItemClick(Sender: TObject);

VAR I : Integer;

begin
  FOR I := KapitelListeGrid.Selection.Top TO KapitelListeGrid.Selection.Bottom DO
    IF Assigned(KapitelListeGrid.Objects[2, I]) THEN
      KapitelListeGrid.Cells[2, I] := BildnummerInZeitStr(ArbeitsumgebungObj.KapitelFormat, TKapitelEintrag(KapitelListeGrid.Objects[2, I]).Kapitel, TKapitelEintrag(KapitelListeGrid.Objects[2, I]).BilderproSek);
end;

// ------------- Markenliste ---------------

FUNCTION TMpegEdit.TextfenstermarkierteZeile(Textfenster: TMemo): Integer;

VAR I, Laenge : Integer;

BEGIN
  Result := 0;
  Laenge := Length(Textfenster.Lines.Text) + 1;
  I := 1;
  WHILE (I < Laenge) AND (I < Textfenster.SelStart + 1) DO
  BEGIN
    IF (Textfenster.Lines.Text[I] = Chr(13)) OR (Textfenster.Lines.Text[I] = Chr(10)) THEN
    BEGIN
      IF I + 1 < Laenge THEN
        IF (Textfenster.Lines.Text[I + 1] = Chr(13)) OR (Textfenster.Lines.Text[I + 1] = Chr(10)) THEN
          Inc(I);
      IF I < Textfenster.SelStart + 1 THEN
        Inc(Result);
      Inc(I);
    END
    ELSE
      Inc(I);
  END;
  IF Result > Textfenster.Lines.Count THEN
    Result := -1;
END;

PROCEDURE TMpegEdit.TextfensterSelektbereich(Textfenster: TMemo; VAR Anfang, Ende: Integer);

VAR I, Laenge,
    SelektStart,
    SelektLaenge : Integer;

BEGIN
  Anfang := 0;
  Ende := 0;
  Laenge := Length(Textfenster.Lines.Text) + 1;
  I := 1;                                                // Zeichenzähler
  SelektStart := Textfenster.SelStart;                   // steht der Kursor auf der letzten Position der vorherigen Zeile soll diese nicht mitgezählt werden (Funktion noch nicht eingebaut)
  IF Textfenster.SelLength > 0 THEN
    SelektLaenge := Textfenster.SelLength - 1            // steht der Kursor auf der ersten Position der nächsten Zeile soll diese noch nicht mitgezählt werden
  ELSE
    SelektLaenge := 0;
  WHILE (I < Laenge) AND (I < Textfenster.SelStart + Textfenster.SelLength + 1) DO
  BEGIN
    IF (Textfenster.Lines.Text[I] = Chr(13)) OR (Textfenster.Lines.Text[I] = Chr(10)) THEN
    BEGIN                                                // CR oder LF gefunden
      IF I + 1 < Laenge THEN                             // es ist ein weiteres Zeichen vorhanden
        IF (Textfenster.Lines.Text[I + 1] = Chr(13)) OR (Textfenster.Lines.Text[I + 1] = Chr(10)) THEN
          Inc(I);                                        // weiteres CR oder LF überspringen
      IF I < SelektStart + 1 THEN
        Inc(Anfang);                                     // Zeichenzähler ist kleiner als Selektionsanfang
      IF I < SelektStart + SelektLaenge + 1 THEN
        Inc(Ende);                                       // Zeichenzähler ist kleiner als Selektionsende
    END;
    Inc(I);                                              // nächstes Zeichen
  END;
  IF Ende > Textfenster.Lines.Count THEN
    Ende := -1;
  IF Anfang > Ende THEN
    Anfang := -1;
END;

PROCEDURE TMpegEdit.MarkenlisteZeileeinfuegenPosition(Position: Integer; Text: STRING);

VAR SelktionStart,
    SelektionLaenge,
    MarkierungsAnfang,
    MarkierungEnde : Integer;

BEGIN
  IF (Position > -1) AND
     (Position < Markenliste.Lines.Count + 1) THEN
  BEGIN
    SelktionStart := Markenliste.SelStart;
    SelektionLaenge := Markenliste.SelLength;
    TextfensterSelektbereich(Markenliste, MarkierungsAnfang, MarkierungEnde);
    Markenliste.Lines.Insert(Position, Text);
    IF MarkierungEnde < Position THEN
    BEGIN
      Markenliste.SelStart := SelktionStart;
      Markenliste.SelLength := SelektionLaenge;
    END
    ELSE
      IF MarkierungsAnfang < Position THEN
      BEGIN
        Markenliste.SelStart := SelktionStart;
        Markenliste.SelLength := SelektionLaenge + Length(Markenliste.Lines[Position]) + 2;
      END
      ELSE
      BEGIN
        Markenliste.SelStart := SelktionStart + Length(Markenliste.Lines[Position]) + 2;
        Markenliste.SelLength := SelektionLaenge;
      END;
  END;
END;

PROCEDURE TMpegEdit.MarkenlisteZeileeinfuegennachMarkierung(Text: STRING);

VAR Position,
    SelktionStart,
    SelektionLaenge,
    EinfuegePosition,
    I : Integer;

BEGIN
  TextfensterSelektbereich(MarkenListe, EinfuegePosition, Position);
  IF Position > -1 THEN
  BEGIN
    IF Position > MarkenListe.Lines.Count - 1 THEN
      MarkenlisteZeileeinfuegenPosition(MarkenListe.Lines.Count, Text)
    ELSE
    BEGIN
      SelktionStart := Markenliste.SelStart;
      SelektionLaenge := Markenliste.SelLength;
      Inc(Position);
      Markenliste.Lines.Insert(Position, Text);
      EinfuegePosition := 0;
      FOR I := 0 TO Position - 1 DO
        EinfuegePosition := EinfuegePosition + Length(Markenliste.Lines[I]) + 2;
      Markenliste.SelStart := SelktionStart + Length(Markenliste.Lines[Position - 1]) + 2;
      IF Markenliste.SelStart > EinfuegePosition + Length(Markenliste.Lines[Position]) THEN
        Markenliste.SelStart := EinfuegePosition + Length(Markenliste.Lines[Position]);
      Markenliste.SelLength := SelektionLaenge;
      IF Markenliste.SelStart + Markenliste.SelLength > EinfuegePosition + Length(Markenliste.Lines[Position]) THEN
        Markenliste.SelLength := EinfuegePosition + Length(Markenliste.Lines[Position]) - Markenliste.SelStart;
    END;
  END;
END;

PROCEDURE TMpegEdit.MarkenlisteZeileeinfuegen(Text: STRING);
BEGIN
  CASE ArbeitsumgebungObj.Markeneinfuegen OF
    0: MarkenlisteZeileeinfuegenPosition(TextfenstermarkierteZeile(MarkenListe), Text);
    1: MarkenlisteZeileeinfuegennachMarkierung(Text);
    2: MarkenlisteZeileeinfuegenPosition(MarkenListe.Lines.Count, Text);
  ELSE
    MarkenlisteZeileeinfuegenPosition(TextfenstermarkierteZeile(MarkenListe), Text);
  END;
END;

FUNCTION TMpegEdit.MarkenListeMarkenimportieren(Dateiname: STRING; Position: Integer): Integer;

VAR I, J,
    Kapitelanzahl : Integer;
    ImportListe : TStringList;
    Zahlen : ARRAY OF Integer;

BEGIN
  Result := 0;
  IF FileExists(Dateiname) THEN
  BEGIN
    ImportListe := TStringList.Create;
    TRY
      ImportListe.LoadFromFile(Dateiname);
      IF ImportListe.Count > 0 THEN
      BEGIN
        SetLength(Zahlen, 10);
        I := 0;
        WHILE(I < ImportListe.Count) DO // Zeilenschleife
        BEGIN
          Kapitelanzahl := TextzeileinBildnummern(ImportListe.Strings[I], Zahlen, BilderProSek, ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste, False);
          IF Kapitelanzahl > Length(Zahlen) THEN
          BEGIN
            SetLength(Zahlen, Kapitelanzahl);
            Kapitelanzahl := TextzeileinBildnummern(ImportListe.Strings[I], Zahlen, BilderProSek, ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste, False);
          END;
          FOR J := 0 TO Kapitelanzahl - 1 DO
          BEGIN
            IF Position < 0 THEN
              MarkenlisteZeileeinfuegen(BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, Zahlen[J], BilderProSek))
            ELSE
            BEGIN
              MarkenlisteZeileeinfuegenPosition(Position, BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, Zahlen[J], BilderProSek));
              Inc(Position);
            END;
          END;
          Inc(I);
        END;
        Finalize(Zahlen);
      END
      ELSE
        Result := -2;          // Importliste ist leer
    FINALLY
      ImportListe.Free;
    END;
  END
  ELSE
    Result := -1;              // Datei nicht vorhanden
END;

FUNCTION TMpegEdit.MarkenListeMarkenexportieren(Dateiname: STRING; Liste: TStrings; Anfang, Ende: Integer): Integer;

VAR Listeneu : TStringList;
    I, J, Kapitelanzahl : Integer;
    Zahlen : ARRAY OF Integer;

BEGIN
  IF (Anfang < 0) THEN
    Anfang := 0;
  IF (Ende < 0) THEN
    Ende := Liste.Count - 1;
  IF (Ende < Liste.Count) AND
     (Anfang < Ende + 1) THEN
  BEGIN
    Listeneu := TStringList.Create;
    TRY
      SetLength(Zahlen, 10);
      FOR I := Anfang TO Ende DO
      BEGIN
        Kapitelanzahl := TextzeileinBildnummern(Liste[I], Zahlen, BilderProSek, ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste, False);
        IF Kapitelanzahl > Length(Zahlen) THEN
        BEGIN
          SetLength(Zahlen, Kapitelanzahl);
          Kapitelanzahl := TextzeileinBildnummern(Liste[I], Zahlen, BilderProSek, ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste, False);
        END;
        FOR J := 0 TO Kapitelanzahl - 1 DO
        BEGIN
          Zahlen[J] := Zahlen[J] + ArbeitsumgebungObj.MarkenExportOffset;
          IF Zahlen[J] < 0 THEN
            Zahlen[J] := 0;
          Listeneu.Add(BildnummerInZeitStr(ArbeitsumgebungObj.MarkenExportFormat, Zahlen[J], BilderProSek));
        END;
      END;
      Finalize(Zahlen);
      Listeneu.SaveToFile(Dateiname);
    FINALLY
      Listeneu.Free;
    END;
    Result := 0;
  END
  ELSE
    Result := -1;
END;

FUNCTION TMpegEdit.MarkenListeSchnittpunkteimportieren(Position: Integer): Integer;

VAR I : Integer;

BEGIN
  Result := 0;
  IF Schnittliste.Count > 0 THEN
  BEGIN
    FOR I := 0 TO Schnittliste.Count -1 DO
      IF ((Schnittliste.SelCount = 0) OR
          Schnittliste.Selected[I]) AND
          Assigned(Schnittliste.Items.Objects[I]) THEN
      BEGIN
        IF Position < 0 THEN
          MarkenlisteZeileeinfuegen(BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, TSchnittpunkt(Schnittliste.Items.Objects[I]).Anfang, BilderProSek))
        ELSE
        BEGIN
          MarkenlisteZeileeinfuegenPosition(Position, BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, TSchnittpunkt(Schnittliste.Items.Objects[I]).Anfang, BilderProSek));
          Inc(Position);
        END;
      END;
  END
  ELSE
    Result := -1;                             // Schnittliste leer
END;

FUNCTION TMpegEdit.MarkenListeMarkenberechnen(Anfang, Ende: Integer; Liste: TStrings): Integer;

VAR I, J, K,
    Laenge,
    Anzahl : Integer;
    Zahlen : ARRAY OF Integer;
    Schnittpunkt : TSchnittpunkt;

BEGIN
  Result := 0;
  IF (Anfang < 0) THEN
    Anfang := 0;
  IF (Ende < 0) THEN
    Ende := MarkenListe.Lines.Count - 1;
  IF (Ende < MarkenListe.Lines.Count) AND
     (Anfang < Ende + 1) THEN
  BEGIN
    IF SchnittListe.Count > 0 THEN
      IF MarkenListe.Lines.Count > 0 THEN
        IF Assigned(Liste) THEN
        BEGIN
          SetLength(Zahlen, 10);
          Laenge := 0;
          FOR I := 0 TO SchnittListe.Count -1 DO                                // Schnittlistenschleife
          BEGIN
            Schnittpunkt := TSchnittpunkt(SchnittListe.Items.Objects[I]);
            IF Assigned(Schnittpunkt) THEN
            BEGIN
              FOR J := Anfang TO Ende DO                                        // Markenlistenschleife
              BEGIN
                Anzahl := TextzeileinBildnummern(MarkenListe.Lines[J], Zahlen, BilderProSek, ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste, False);
                IF Anzahl > Length(Zahlen) THEN
                BEGIN
                  SetLength(Zahlen, Anzahl);
                  Anzahl := TextzeileinBildnummern(MarkenListe.Lines[J], Zahlen, BilderProSek, ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste, False);
                END;
                FOR K := 0 TO Anzahl - 1 DO                                     // Marken pro Zeile
                BEGIN
                  IF KnotenDatengleichVideo(aktVideoknoten, Schnittpunkt.Videoknoten) AND
                     KnotenDatengleichAudio(aktAudioknoten, Schnittpunkt.Audioknoten) AND
                     (Zahlen[K] >= Schnittpunkt.Anfang) AND (Zahlen[K] <= Schnittpunkt.Ende) THEN
                    Liste.Add(BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, Zahlen[K] - Schnittpunkt.Anfang + Laenge, BilderProSek));
                END;
              END;
              Laenge := Laenge + Schnittpunkt.Ende - Schnittpunkt.Anfang + 1;
            END;
          END;
          Finalize(Zahlen);
        END
        ELSE
          Result := -4                       // keine Liste übergeben
      ELSE
        Result := -3                         // kein Markenlisteneintrag
    ELSE
      Result := -2;                          // kein Schnittlisteneintrag
  END
  ELSE
    Result := -1;                            // Anfang, Ende ungültig
END;

// ------------ Markenlistenereingnisse -----------------

procedure TMpegEdit.MarkenListeChange(Sender: TObject);
begin
  IF MarkenListe.Modified THEN
    Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.MarkenListeClick(Sender: TObject);

VAR Index : Integer;

begin
  Index := TextfenstermarkierteZeile(Markenliste);
  IF Index > -1 THEN
  BEGIN
    //
  END;
end;

procedure TMpegEdit.MarkenListeDblClick(Sender: TObject);

VAR NeuePos : Array[0..0] OF Integer;

begin
  IF Markenliste.SelLength > 0 THEN
  BEGIN
    IF TextzeileinBildnummern(Markenliste.SelText, NeuePos, BilderProSek, ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste, False) > 0 THEN
      IF (NeuePos[0] > - 1) AND (NeuePos[0] < SchiebereglerMax) THEN
      BEGIN
        IF Play.Down THEN
        BEGIN
          AbspielModus := False;
          PlayerPause;
          SchiebereglerPosition_setzen(NeuePos[0], True);
          AbspielModus := True;
          PlayerStart;
          CutIn.Enabled := False;
          CutOut.Enabled := False;
        END
        ELSE
          SchiebereglerPosition_setzen(NeuePos[0], True);
      END;
    IF Enabled THEN
      Pos0Panel.SetFocus;
  END;
end;

procedure TMpegEdit.MarkenListeEnter(Sender: TObject);
begin
  Markenlisteaktiv := True;
end;

procedure TMpegEdit.MarkenListeExit(Sender: TObject);
begin
  Markenlisteaktiv := False;
end;

procedure TMpegEdit.MarkeClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  Listen.ActivePage := MarkenlistenTab;
  MarkenlisteZeileeinfuegen(BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, SchiebereglerPosition, BilderProSek));
  Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.MarkevorhereinfuegenMenuItemClick(Sender: TObject);
begin
  Listen.ActivePage := MarkenlistenTab;
  MarkenlisteZeileeinfuegenPosition(TextfenstermarkierteZeile(MarkenListe), BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, SchiebereglerPosition, BilderProSek));
  Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.MarkenachhereinfuegenMenuItemClick(Sender: TObject);
begin
  Listen.ActivePage := MarkenlistenTab;
  MarkenlisteZeileeinfuegennachMarkierung(BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, SchiebereglerPosition, BilderProSek));
  Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.MarkeamEndeeinfuegenMenuItemClick(Sender: TObject);
begin
  Listen.ActivePage := MarkenlistenTab;
  MarkenlisteZeileeinfuegenPosition(MarkenListe.Lines.Count, BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, SchiebereglerPosition, BilderProSek));
  Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.MarkeaendernMenuItemClick(Sender: TObject);

VAR ListenIndex : Integer;

begin
  Listen.ActivePage := MarkenlistenTab;
  ListenIndex := TextfenstermarkierteZeile(MarkenListe);
  IF ListenIndex > -1 THEN
  BEGIN
    MarkenListe.Lines[ListenIndex] := BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, SchiebereglerPosition, BilderProSek);
    Projektgeaendert_setzen(5);
  END;
end;

procedure TMpegEdit.MarkentastePopupMenuPopup(Sender: TObject);

VAR Anfang, Ende: Integer;

begin
  TextfensterSelektbereich(MarkenListe, Anfang, Ende);
  IF (Anfang > -1) AND (Anfang = Ende) AND
     (Listen.ActivePage = MarkenlistenTab) THEN
    MarkeaendernMenuItem.Enabled := True
  ELSE
    MarkeaendernMenuItem.Enabled := False
end;

// ------------ MarkenlistenPopupmenü ------------------------

procedure TMpegEdit.MarkenListePopupMenuPopup(Sender: TObject);
begin
  Pause;
  IF MarkenListe.Lines.Count > 0 THEN
  BEGIN
    IF (TextfenstermarkierteZeile(MarkenListe) < MarkenListe.Lines.Count) AND
       (TextfenstermarkierteZeile(MarkenListe) > -1)THEN
    BEGIN
      MarkenexportierenMenuItem.Enabled := True;
      MarkenberechnenexportierenMenuItem.Enabled := True;
      MarkeloeschenMenuItem.Enabled := True;
      MarkenListeMarkierungenaufhebenMenuItem.Enabled := True;
      MarkenListeZeitformataendernMenuItem.Enabled := True;
    END
    ELSE
    BEGIN
      MarkenexportierenMenuItem.Enabled := False;
      MarkenberechnenexportierenMenuItem.Enabled := False;
      MarkeloeschenMenuItem.Enabled := False;
      MarkenListeMarkierungenaufhebenMenuItem.Enabled := False;
      MarkenListeZeitformataendernMenuItem.Enabled := False;
    END;
    MarkenListeexportierenMenuItem.Enabled := True;
    MarkenListeberechnenexportierenMenuItem.Enabled := True;
    MarkenListespeichernMenuItem.Enabled := True;
    MarkenListeloeschenMenuItem.Enabled := True;
  END
  ELSE
  BEGIN
    MarkenListeexportierenMenuItem.Enabled := False;
    MarkenListeberechnenexportierenMenuItem.Enabled := False;
    MarkenListespeichernMenuItem.Enabled := False;
    MarkenexportierenMenuItem.Enabled := False;
    MarkenberechnenexportierenMenuItem.Enabled := False;
    MarkeloeschenMenuItem.Enabled := False;
    MarkenListeloeschenMenuItem.Enabled := False;
    MarkenListeMarkierungenaufhebenMenuItem.Enabled := False;
    MarkenListeZeitformataendernMenuItem.Enabled := False;
  END;
  IF SchnittListe.Count > 0 THEN
    MarkenlisteSchnittpunkteimportierenMenuItem.Enabled := True
  ELSE
    MarkenlisteSchnittpunkteimportierenMenuItem.Enabled := False;
  IF MarkenListe.SelLength > 0 THEN
  BEGIN
    IF MarkenListe.ReadOnly THEN
    BEGIN
      MarkenListeAusschneidenMenuItem.Enabled := False;
      MarkenListeMarkierungLoeschenMenuItem.Enabled := False;
    END
    ELSE
    BEGIN
      MarkenListeAusschneidenMenuItem.Enabled := True;
      MarkenListeMarkierungLoeschenMenuItem.Enabled := True;
    END;
    MarkenListeKopierenMenuItem.Enabled := True;
  END
  ELSE
  BEGIN
    MarkenListeAusschneidenMenuItem.Enabled := False;
    MarkenListeKopierenMenuItem.Enabled := False;
    MarkenListeMarkierungLoeschenMenuItem.Enabled := False;
  END;
  IF MarkenListe.CanUndo THEN
    MarkenListeRueckgaengigMenuItem.Enabled := True
  ELSE
    MarkenListeRueckgaengigMenuItem.Enabled := False;
  IF MarkenListe.ReadOnly THEN
    MarkenListeEinfuegenMenuItem.Enabled := False
  ELSE
    MarkenListeEinfuegenMenuItem.Enabled := True;
end;

procedure TMpegEdit.MarkenListeloeschenMenuItemClick(Sender: TObject);
begin
  MarkenListe.Clear;
  Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.MarkenListeimportierenMenuItemClick(Sender: TObject);
begin
  Oeffnen.Title := Wortlesen(NIL, 'Dialog73', 'Markenliste importieren');
  Oeffnen.Filter := Wortlesen(NIL, 'Dialog38', 'Markendateien') + '|*.txt' + '|' +
                    Wortlesen(NIL, 'Dialog61', 'Alle Dateien') + '|*.*';
  Oeffnen.DefaultExt := '';
  Oeffnen.FileName := '';
  Oeffnen.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.KapitelVerzeichnis);
  IF Oeffnen.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Oeffnen.FileName);
    IF MarkenListeMarkenimportieren(Oeffnen.FileName, -1) = 0 THEN
      Projektgeaendert_setzen(5);
  END;
end;

procedure TMpegEdit.MarkenListeexportierenMenuItemClick(Sender: TObject);
begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog74', 'Markenliste exportieren');
  Speichern.Filter := Wortlesen(NIL, 'Dialog38', 'Markendateien') + '|*.txt';
  Speichern.DefaultExt := 'txt';
  IF Projektname = '' THEN
    Speichern.FileName := ExtractFilename(ChangeFileExt(DateinameausKnoten(aktVideoknoten, aktAudioknoten), '.txt'))
  ELSE
    Speichern.FileName := ExtractFilename(ChangeFileExt(Projektname, '.txt'));
  Speichern.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.KapitelVerzeichnis);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    IF FileExists(Speichern.FileName) THEN
    BEGIN
      IF DeleteFile(Speichern.FileName) THEN
      BEGIN
        IF MarkenListeMarkenexportieren(Speichern.FileName, MarkenListe.Lines, -1, -1) = 0 THEN
//          Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END
      ELSE
        Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                        Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//        ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
    END
    ELSE
    BEGIN
      IF MarkenListeMarkenexportieren(Speichern.FileName, MarkenListe.Lines, -1, -1) = 0 THEN
//        Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
    END;
  END;
end;

procedure TMpegEdit.MarkenexportierenMenuItemClick(Sender: TObject);

VAR Anfang, Ende : Integer;

begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog74', 'Markenliste exportieren');
  Speichern.Filter := Wortlesen(NIL, 'Dialog38', 'Markendateien') + '|*.txt';
  Speichern.DefaultExt := 'txt';
  IF Projektname = '' THEN
    Speichern.FileName := ExtractFilename(ChangeFileExt(DateinameausKnoten(aktVideoknoten, aktAudioknoten), '.txt'))
  ELSE
    Speichern.FileName := ExtractFilename(ChangeFileExt(Projektname, '.txt'));
  Speichern.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.KapitelVerzeichnis);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    TextfensterSelektbereich(MarkenListe, Anfang, Ende);
    IF FileExists(Speichern.FileName) THEN
    BEGIN
      IF DeleteFile(Speichern.FileName) THEN
      BEGIN
        IF MarkenListeMarkenexportieren(Speichern.FileName, MarkenListe.Lines, Anfang, Ende) = 0 THEN
//          Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END
      ELSE
        Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                        Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//        ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
    END
    ELSE
    BEGIN
      IF MarkenListeMarkenexportieren(Speichern.FileName, MarkenListe.Lines, Anfang, Ende) = 0 THEN
//        Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
    END;
  END;
end;

procedure TMpegEdit.MarkenListeladenMenuItemClick(Sender: TObject);
begin
  Oeffnen.Title := Wortlesen(NIL, 'Dialog75', 'Markenliste laden');
  Oeffnen.Filter := Wortlesen(NIL, 'Dialog38', 'Markendateien') + '|*.txt' + '|' +
                    Wortlesen(NIL, 'Dialog61', 'Alle Dateien') + '|*.*';
  Oeffnen.DefaultExt := '';
  Oeffnen.FileName := '';
  Oeffnen.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.KapitelVerzeichnis);
  IF Oeffnen.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Oeffnen.FileName);
    MarkenListe.Lines.LoadFromFile(Oeffnen.FileName);
    Projektgeaendert_setzen(5);
  END;
end;

procedure TMpegEdit.MarkenListespeichernMenuItemClick(Sender: TObject);
begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog76', 'Markenliste speichern');
  Speichern.Filter := Wortlesen(NIL, 'Dialog38', 'Markendateien') + '|*.txt';
  Speichern.DefaultExt := 'txt';
  IF Projektname = '' THEN
    Speichern.FileName := ExtractFilename(ChangeFileExt(DateinameausKnoten(aktVideoknoten, aktAudioknoten), '.txt'))
  ELSE
    Speichern.FileName := ExtractFilename(ChangeFileExt(Projektname, '.txt'));
  Speichern.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.KapitelVerzeichnis);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    IF FileExists(Speichern.FileName) THEN
    BEGIN
      IF DeleteFile(Speichern.FileName) THEN
      BEGIN
        MarkenListe.Lines.SaveToFile(Speichern.FileName);
//        Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END
      ELSE
        Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                        Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//        ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
    END
    ELSE
    BEGIN
      MarkenListe.Lines.SaveToFile(Speichern.FileName);
//      Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
    END;
  END;
end;

procedure TMpegEdit.MarkenlisteSchnittpunkteimportierenMenuItemClick(Sender: TObject);
begin
  IF MarkenListeSchnittpunkteimportieren(-1) = 0 THEN
    Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.MarkenListeberechnenexportierenMenuItemClick(Sender: TObject);

VAR Marken : TStringList;

begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog74', 'Markenliste exportieren');
  Speichern.Filter := Wortlesen(NIL, 'Dialog38', 'Markendateien') + '|*.txt';
  Speichern.DefaultExt := 'txt';
  IF Projektname = '' THEN
    Speichern.FileName := ExtractFilename(ChangeFileExt(DateinameausKnoten(aktVideoknoten, aktAudioknoten), '.txt'))
  ELSE
    Speichern.FileName := ExtractFilename(ChangeFileExt(Projektname, '.txt'));
  Speichern.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.KapitelVerzeichnis);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    Marken := TStringList.Create;
    TRY
      MarkenListeMarkenberechnen(-1, -1, Marken);
      IF FileExists(Speichern.FileName) THEN
      BEGIN
        IF DeleteFile(Speichern.FileName) THEN
        BEGIN
          IF MarkenListeMarkenexportieren(Speichern.FileName, Marken, -1, -1) = 0 THEN
//            Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
        END
        ELSE
          Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
      END
      ELSE
      BEGIN
        IF MarkenListeMarkenexportieren(Speichern.FileName, Marken, -1, -1) = 0 THEN
//          Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END;
    FINALLY
      Marken.Free;
    END;
  END;
end;

procedure TMpegEdit.MarkenberechnenexportierenMenuItemClick(Sender: TObject);

VAR Anfang, Ende : Integer;
    Marken : TStringList;

begin
  Speichern.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
  Speichern.Title := Wortlesen(NIL, 'Dialog74', 'Markenliste exportieren');
  Speichern.Filter := Wortlesen(NIL, 'Dialog38', 'Markendateien') + '|*.txt';
  Speichern.DefaultExt := 'txt';
  IF Projektname = '' THEN
    Speichern.FileName := ExtractFilename(ChangeFileExt(DateinameausKnoten(aktVideoknoten, aktAudioknoten), '.txt'))
  ELSE
    Speichern.FileName := ExtractFilename(ChangeFileExt(Projektname, '.txt'));
  Speichern.InitialDir := Verzeichnissuchen(ArbeitsumgebungObj.KapitelVerzeichnis);
  IF Speichern.Execute THEN
  BEGIN
    IF ArbeitsumgebungObj.KapitelVerzeichnisspeichern THEN
      ArbeitsumgebungObj.KapitelVerzeichnis := ExtractFilePath(Speichern.FileName);
    TextfensterSelektbereich(MarkenListe, Anfang, Ende);
    Marken := TStringList.Create;
    TRY
      MarkenListeMarkenberechnen(Anfang, Ende, Marken);
      IF FileExists(Speichern.FileName) THEN
      BEGIN
        IF DeleteFile(Speichern.FileName) THEN
        BEGIN
          IF MarkenListeMarkenexportieren(Speichern.FileName, Marken,  -1, -1) = 0 THEN
//            Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
        END
        ELSE
          Meldungsfenster(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'),
                          Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//          ShowMessage(Meldunglesen(NIL, 'Meldung119', Speichern.FileName, 'Die Datei $Text1# konnte nicht überschrieben werden.'));
      END
      ELSE
      BEGIN
        IF MarkenListeMarkenexportieren(Speichern.FileName, Marken,  -1, -1) = 0 THEN
//          Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Speichern.FileName, 'Datei $Text1# gespeichert.'), ArbeitsumgebungObj.Hinweisanzeigedauer, False, True);
      END;
    FINALLY
      Marken.Free;
    END;
  END;
end;

procedure TMpegEdit.MarkeloeschenMenuItemClick(Sender: TObject);

VAR I, Anfang, Ende : Integer;

begin
  TextfensterSelektbereich(MarkenListe, Anfang, Ende);
  IF Anfang > -1 THEN
  BEGIN
    FOR I := Ende DOWNTO Anfang DO
      MarkenListe.Lines.Delete(I);
    Projektgeaendert_setzen(5);
  END;
end;

procedure TMpegEdit.GOPssuchenMenuItemClick(Sender: TObject);

VAR Frame1, Frame2 : Int64;

begin
  IF Assigned(IndexListe) AND (IndexListe.Count > 0) AND
     (ArbeitsumgebungObj.maxGOPLaenge > 0) THEN
  BEGIN
    Frame2 := -1;
    REPEAT
      LangeGOPsuchen(Frame2 + 1, IndexListe.Count - 1, Frame1, Frame2, ArbeitsumgebungObj.maxGOPLaenge);
      IF Frame1 < Frame2 THEN
        MarkenListe.Lines.Add(BildnummerInZeitStr(ArbeitsumgebungObj.MarkenFormat, Frame1 + 1, BilderProSek){ + ' ' + IntToStr(Frame2 - Frame1)});
    UNTIL Frame1 = Frame2;
  END;
end;

procedure TMpegEdit.MarkenListeRueckgaengigMenuItemClick(Sender: TObject);
begin
  MarkenListe.Undo;
end;

procedure TMpegEdit.MarkenListeAusschneidenMenuItemClick(
  Sender: TObject);
begin
  MarkenListe.CutToClipboard;
end;

procedure TMpegEdit.MarkenListeKopierenMenuItemClick(Sender: TObject);
begin
  MarkenListe.CopyToClipboard;
end;

procedure TMpegEdit.MarkenListeEinfuegenMenuItemClick(Sender: TObject);
begin
  MarkenListe.PasteFromClipboard;
end;

procedure TMpegEdit.MarkenListeMarkierungLoeschenMenuItemClick(Sender: TObject);
begin
  MarkenListe.ClearSelection
end;

procedure TMpegEdit.MarkenListeMarkierungenaufhebenMenuItemClick(Sender: TObject);
begin
  Markenliste.SelStart := Length(Markenliste.Text);
end;

procedure TMpegEdit.MarkenListeZeitformataendernMenuItemClick(Sender: TObject);

VAR I, Anfang, Ende : Integer;

begin
  TextfensterSelektbereich(MarkenListe, Anfang, Ende);
  FOR I := Anfang TO Ende DO
  BEGIN
    MarkenListe.Lines[I] := TextzeileZeitformataendern(MarkenListe.Lines[I], ArbeitsumgebungObj.MarkenFormat, BilderProSek,
                                                       ArbeitsumgebungObj.MarkenImportTrennzeichenliste, ArbeitsumgebungObj.MarkenImportZeitTrennzeichenliste);
  END;
  Projektgeaendert_setzen(5);
end;

procedure TMpegEdit.KapitelListeGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);

{VAR X : Integer;
    SFarbe,
    HFarbe : TColor; }   

begin
{  SFarbe := KapitelListeGrid.Canvas.Font.Color;
  HFarbe := KapitelListeGrid.Canvas.Brush.Color;
//  X := 0;
  IF (ARow > KapitelListeGrid.Selection.Top - 1) AND
     (ARow < KapitelListeGrid.Selection.Bottom + 1) THEN
    KapitelListeGrid.Canvas.Brush.Color := clSilver;
  Rect.Left := 1;
  Rect.Right := KapitelListeGrid.ColWidths[0] + KapitelListeGrid.ColWidths[1] +
                KapitelListeGrid.ColWidths[2] + KapitelListeGrid.ColWidths[3] - 1;
  KapitelListeGrid.Canvas.FillRect(Rect);
  KapitelListeGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, KapitelListeGrid.Cells[ACol, ARow]);
  KapitelListeGrid.Canvas.Brush.Color := HFarbe;
  Edit1.Text := IntToStr(Rect.Left) + IntToStr(Rect.Top); }
{  IF (ACol = 2) AND (ARow > 0) AND (ARow < KapitelListeGrid.Tag) THEN
  BEGIN
    IF State = [gdSelected] THEN
      KapitelListeGrid.Canvas.Brush.Color := clSilver;
    KapitelListeGrid.Canvas.FillRect(Rect);
    KapitelListeGrid.Canvas.Font.Color := clGreen;
    KapitelListeGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, KapitelListeGrid.Cells[ACol, ARow]);
    KapitelListeGrid.Canvas.Font.Color := SFarbe;
    KapitelListeGrid.Canvas.Brush.Color := HFarbe;
  END;    }
//    X := X + KapitelListeGrid.Canvas.TextWidth('Test');

end;

// ---------------- Audiooffsetfenster ---------------------------

PROCEDURE TMpegEdit.AudioOffsetfensterAnzeige_aendern;
BEGIN
  IF Assigned(Audiooffset) AND (Audiooffset <> @AudiooffsetNull) THEN
    AudioOffsetEdit.Text := BildnummerInZeitStr('N', Audiooffset^, BilderProSek)
  ELSE
    AudioOffsetEdit.Text := 'X';
  AudioOffsetfensterRegler_aendern
END;

PROCEDURE TMpegEdit.AudioOffsetfensterRegler_aendern;

VAR skew,fine : Integer;

BEGIN
  IF Assigned(Audiooffset) THEN
  BEGIN
    IF Audiooffset^<>0 THEN
    BEGIN
      IF Audiooffset^ = 5050 THEN
      BEGIN
        skew := 50;
        fine := 50
      END
      ELSE
      BEGIN
        fine := Audiooffset^ + 5050;
        skew := fine div 100;
        fine := (fine - skew * 100) - 50;
        skew := skew - 50
      END;
      AS10th.Position := skew;
      AS1000th.Position := fine;
    END
    ELSE
    BEGIN
      AS10th.Position := 0;
      AS1000th.Position := 0;
    END;
  END
  ELSE
  BEGIN
    AS10th.Position := 0;
    AS1000th.Position := 0;
  END;
END;

procedure TMpegEdit.AudiooffsetfensterausBtnClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  AudioSkewPanel.Visible := False;
  AudiooffseteinPanel.Visible := True;
  Fenstereinstellen;
end;

procedure TMpegEdit.ASChange(Sender: TObject);
begin
  IF Sender = AS10th THEN
    AS10th_.Caption := IntToStr(AS10th.Position * 100)
  ELSE
    IF Sender = AS1000th THEN
      AS1000th_.Caption := IntToStr(AS1000th.Position);
  IF Assigned(Audiooffset) AND (Audiooffset <> @AudiooffsetNull) THEN
  BEGIN
    IF NOT(((AS10th.Position = 50) AND (Audiooffset^ > 5050)) OR
          ((AS10th.Position = -50) AND (Audiooffset^ < -5050))) THEN
    BEGIN
      Audiooffset^ := AS10th.Position * 100 + AS1000th.Position;
      AudioOffsetEdit.Text := BildnummerInZeitStr('N', Audiooffset^, BilderProSek);
    END;
  END
  ELSE
    AudioOffsetEdit.Text := 'X';
  AudioOffsetAnzeige_aendern;
end;

procedure TMpegEdit.AudioOffsetEditEnter(Sender: TObject);
begin
  OffsetEditaktiv := True;
end;

procedure TMpegEdit.AudioOffsetEditExit(Sender: TObject);
begin
  OffsetEditaktiv := False;
  IF Assigned(Audiooffset) AND (Audiooffset <> @AudiooffsetNull) THEN
  BEGIN
    IF AudioOffsetEdit.Modified THEN
    BEGIN
      Audiooffset^ := ZeitStrInMillisekInt(Trim(AudioOffsetEdit.Text), BilderProSek, ArbeitsumgebungObj.SchnittImportZeitTrennzeichenliste, True);
      Projektgeaendert_setzen(1);
      AudioOffsetfensterRegler_aendern;
      Schiebereglerlaenge_einstellen;
      SchiebereglerPosition_setzen(SchiebereglerPosition);
      AudioOffsetEdit.Text := IntToStr(Audiooffset^);
    END;
  END
  ELSE
    AudioOffsetEdit.Text := 'X';
end;

procedure TMpegEdit.AudioOffsetEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  IF Key = Chr(13) THEN
  BEGIN
    Key := Chr(0);
    IF Enabled THEN
      Pos0Panel.SetFocus;
  END;
end;

// ----------------- Tastenbilder laden ------------------------

// Q: etwas unschön...
procedure TMpegEdit.ErsetzeSpeedButtons;
begin
  Play := TAlphaSpeedBtn.Create(Self).Replace(Play);
  Spielebis := TAlphaSpeedBtn.Create(Self).Replace(Spielebis);
  Spieleab := TAlphaSpeedBtn.Create(Self).Replace(Spieleab);
  VorherigesI := TAlphaSpeedBtn.Create(Self).Replace(VorherigesI);
  VorherigesP := TAlphaSpeedBtn.Create(Self).Replace(VorherigesP);
  SchrittZurueck := TAlphaSpeedBtn.Create(Self).Replace(SchrittZurueck);
  NaechstesI := TAlphaSpeedBtn.Create(Self).Replace(NaechstesI);
  NaechstesP := TAlphaSpeedBtn.Create(Self).Replace(NaechstesP);
  SchrittVor := TAlphaSpeedBtn.Create(Self).Replace(SchrittVor);
  GehezuIn := TAlphaSpeedBtn.Create(Self).Replace(GehezuIn);
  GehezuOut := TAlphaSpeedBtn.Create(Self).Replace(GehezuOut);
  SchnittUebernehmen := TAlphaSpeedBtn.Create(Self).Replace(SchnittUebernehmen);
  Kapitel := TAlphaSpeedBtn.Create(Self).Replace(Kapitel);
  Marke := TAlphaSpeedBtn.Create(Self).Replace(Marke);
  Vorschau := TAlphaSpeedBtn.Create(Self).Replace(Vorschau);
  Schneiden := TAlphaSpeedBtn.Create(Self).Replace(Schneiden);
  Schnittpunkteeinzelnschneiden := TAlphaSpeedBtn.Create(Self).Replace(Schnittpunkteeinzelnschneiden);
  MarkierteSchnittpunkte := TAlphaSpeedBtn.Create(Self).Replace(MarkierteSchnittpunkte);
  nurAudiospeichern := TAlphaSpeedBtn.Create(Self).Replace(nurAudiospeichern);
  CutIn := TAlphaSpeedBtn.Create(Self).Replace(CutIn);
  CutOut := TAlphaSpeedBtn.Create(Self).Replace(CutOut);
  BtnVideoAdd := TAlphaSpeedBtn.Create(Self).Replace(BtnVideoAdd);
  SchnitteinfuegenvorMarkierungBtn := TAlphaSpeedBtn.Create(Self).Replace(SchnitteinfuegenvorMarkierungBtn);
  SchnitteinfuegennachMarkierungBtn := TAlphaSpeedBtn.Create(Self).Replace(SchnitteinfuegennachMarkierungBtn);
  SchnitteinfuegenamEndeBtn := TAlphaSpeedBtn.Create(Self).Replace(SchnitteinfuegenamEndeBtn);
  SchnittaendernBtn := TAlphaSpeedBtn.Create(Self).Replace(SchnittaendernBtn);
  ProjektNeuBtn := TAlphaSpeedBtn.Create(Self).Replace(ProjektNeuBtn);
  ProjektLadenBtn := TAlphaSpeedBtn.Create(Self).Replace(ProjektLadenBtn);
  ProjektSpeichernBtn := TAlphaSpeedBtn.Create(Self).Replace(ProjektSpeichernBtn);
{THU051004}
  Pos0Btn := TAlphaSpeedBtn.Create(Self).Replace(Pos0Btn);
  EndeBtn := TAlphaSpeedBtn.Create(Self).Replace(EndeBtn);
  EndeBtn1 := TAlphaSpeedBtn.Create(Self).Replace(EndeBtn1);
  AudiooffsetfensterausBtn := TAlphaSpeedBtn.Create(Self).Replace(AudiooffsetfensterausBtn);
  DateienfensterausBtn := TAlphaSpeedBtn.Create(Self).Replace(DateienfensterausBtn);
  TempoMinusBtn := TAlphaSpeedBtn.Create(Self).Replace(TempoMinusBtn);
  TempoPlusBtn := TAlphaSpeedBtn.Create(Self).Replace(TempoPlusBtn);
{---------}
end;

{
// Updaten von alten Format ins neue Format, Datei wird danach umbenannt nach
// <Dateiname>+'.q6' und die neue Vorlage wird als <Dateiname> gespeichert.
function TMpegEdit.SymbolVorlagenUpdaten(skin: TSkinFactory;
                               const DateiName: String): TSkinFactory;
var
  I: Cardinal;
begin
  // Rahmen erzeugen
  result := TSkinFactory.CreateTemplate(
    skin.PixelFormat, 284, 165
  );
  SymbolMapping72(result);  // aktuelles Mapping erzeugen
  result.DrawBorders;     // Rahmen zeichnen (nach Mapping);

  for I:=0 to skin.Count-1 do
    result.CopySkinBitmap(I, skin, I);

  result.InitSkin;
  skin.Free;
  RenameFile(DateiName, DateiName + '.q6');   // altes Skin-File umbenennen
  result.SaveSkin(DateiName);                 // neues Skin-File schreiben
end;

// altes Mapping erzeugen
procedure TMpegEdit.SymbolMappingQ6(skin: TSkinFactory);
var
  row: TRect;
begin
  // von Hand Layout
  skin.Row := Rect(0,0,2*Play.Width-6,0); // 2 Icons nebeneinander
  skin.AddToMapping(Play,2);
  // Vorschau
  skin.AddToMapping(POINT(51,71), 2);// Btn. muß mind 55,75 groß sein.
  // Schnittuebernehmen
  skin.AddToMapping(POINT(80,21),1);
  skin.AddToMapping(SpieleAb,2);
  skin.AddToMapping(SpieleBis,2);
  skin.AddToMapping(BtnVideoAdd,1);
  // von Hand Layout
  skin.NextBitmapCol;
  row := skin.Row;
  row.Right := row.Right + Kapitel.Width -4 + Marke.Width -4 +2;
  skin.Row := row;
  skin.AddToMapping(Kapitel,1);
  skin.AddToMapping(Marke,1);
  skin.AddToMapping(VorherigesI,1);
  skin.AddToMapping(NaechstesI,1);
  skin.AddToMapping(VorherigesP,1);
  skin.AddToMapping(NaechstesP,1);
  skin.AddToMapping(SchrittZurueck,1);
  skin.AddToMapping(SchrittVor,1);
  // Spezialbehandlung für CutIn/CutOut, da nun auch Text auf den Buttons ist.
  skin.AddToMapping(POINT(21,21),4);
  // Spezialbehandlung für GehezuIn/Out/Länge
  skin.AddToMapping(POINT(24,21),1);
  skin.AddToMapping(Schnittpunkteeinzelnschneiden,2);
  skin.AddToMapping(MarkierteSchnittpunkte,2);
  // Spezialbehandlung für GehezuIn/Out/Länge
  skin.AddToMapping(POINT(24,21),1);
  skin.AddToMapping(nurAudiospeichern,2);
  //skin.AddControlToTemplate(Schneiden,1);
  skin.AddToMapping(POINT(51,71),1);
  // Schnittliste bmp;
  skin.AddToMapping(POINT(24,13),1);
  // neue Rahmen:
  skin.AddToMapping(POINT(42,18),2);
  skin.MappingDone;
end;

// neues Mapping erzeugen
procedure TMpegEdit.SymbolMapping72(skin:TSkinFactory);
var
  row: TRect;
begin
  // von Hand Layout
  skin.Row := Rect(0,0,2*Play.Width-6,0); // 2 Icons nebeneinander
  skin.AddToMapping(Play,2);
  // Vorschau
  skin.AddToMapping(POINT(51,71), 2);// Btn. muß mind 55,75 groß sein.
  // Schnittuebernehmen
  skin.AddToMapping(POINT(80,21),1);
  skin.AddToMapping(SpieleAb,2);
  skin.AddToMapping(SpieleBis,2);
  skin.AddToMapping(BtnVideoAdd,1);
  // von Hand Layout
  skin.NextBitmapCol;
  row := skin.Row;
  row.Right := row.Right + Kapitel.Width -4 + Marke.Width -4 +3;
  skin.Row := row;
  skin.AddToMapping(Kapitel,1);
  skin.AddToMapping(Marke,1);
  skin.AddToMapping(VorherigesI,1);
  skin.AddToMapping(NaechstesI,1);
  skin.AddToMapping(VorherigesP,1);
  skin.AddToMapping(NaechstesP,1);
  skin.AddToMapping(SchrittZurueck,1);
  skin.AddToMapping(SchrittVor,1);
  // Spezialbehandlung für CutIn/CutOut, da nun auch Text auf den Buttons ist.
  skin.AddToMapping(POINT(21,21),4);
  // Spezialbehandlung für GehezuIn/Out/Länge
  skin.AddToMapping(POINT(24,21),1);
  skin.AddToMapping(Schnittpunkteeinzelnschneiden,2);
  skin.AddToMapping(MarkierteSchnittpunkte,2);
  // Spezialbehandlung für GehezuIn/Out/Länge
  skin.AddToMapping(POINT(24,21),1);
  skin.AddToMapping(nurAudiospeichern,2);
  //skin.AddControlToTemplate(Schneiden,1);
  skin.AddToMapping(POINT(51,71),1);
  // Schnittliste bmp;
  skin.AddToMapping(POINT(24,13),1);
  // neue Rahmen:
  skin.AddToMapping(POINT(42,18),4);
  skin.MappingDone;
end;
}

{THU051004}
{procedure TMpegEdit.LeereVorlageErzeugen;  // wird bei Änderungen an der Vorlage
                                           // gebraucht...
var
  skin: TSkinFactory;
begin
  skin := TSkinFactory.CreateTemplate(
    pf32bit, 297, 165
  );
  SymbolMapping74(skin);  // aktuelles Mapping erzeugen
  skin.DrawBorders;       // Rahmen zeichnen (nach Mapping);
  skin.SaveSkin('M2SSymbolSetTemplate.bmp')
end;    }
{---------}

procedure TMpegEdit.SymbolMapping74(skin:TSkinFactory);
var
  row: TRect;
begin
  skin.AddToMapping(POINT(51, 71), 4);// Play/VorschauInaktiv/Pause/VorschauAktiv
  skin.NextBitmapCol;
  row := Rect(0, 0, 3*44+3, 0);
  offsetRect(row, skin.Offset.X, skin.Offset.Y);
  skin.Row := row;
  skin.AddToMapping(POINT(44, 33), 3);  // Kapitel/Kapitel ungültig/Marke
  skin.AddToMapping(POINT(24, 21), 1);  // gotoIn
  skin.AddToMapping(POINT(21, 21), 5);
  skin.AddToMapping(POINT(24, 21), 1);  // gogoOut
  skin.AddToMapping(POINT(21, 21), 5);
  skin.NextBitmapRow;
  skin.AddToMapping(POINT(50, 65), 1);  // etwas kleiner als vorher (war 51,71)
  row := Rect(0, 0, 2*41+2, 0);
  offsetRect(row, skin.Offset.X, skin.Offset.Y);
  skin.Row := row;
  skin.AddToMapping(POINT(41, 21), 6);  // Navigation
  skin.NextBitmapCol;
  skin.AddToMapping(POINT(36, 33), 4);  // PlayAb/Bis Buttons
  skin.NextBitmapCol;
  skin.AddToMapping(POINT(20, 21), 3);  // Project Buttons
  skin.AddToMapping(POINT(20, 13), 1);  // Mini Schere
  skin.AddToMapping(POINT(13, 13), 2);  // Pos0/Ende
  skin.AddToMapping(POINT(11, 8));      // Minimieren
  skin.AddToMapping(POINT(10, 12), 2);  // Minus/Plus
  skin.Row := Rect(0, 144, skin.Skin.Width, 144);
  skin.AddToMapping(POINT(40, 21), 4);
  skin.AddToMapping(POINT(87, 21), 1);
  skin.Row := Rect(252, 136, 252, 136); // VideoAdd
  skin.AddToMapping(POINT(30, 26), 1);
  skin.MappingDone;
end;


// Wenn die Datei die in Dateinamen übergeben wird nicht
// existiert, dann wird der 'default' set geladen.
function TMpegEdit.LadeIconTemplate(Mode: Integer; DateiName : STRING): Integer;
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
        Result := -2;                                                // Symboldatei laden fehlgeschlagen
  //////////////////////////////////////////////////////////////////////////////
        // hier sollte eine Fehlermeldung erscheinen:
        // 'Symbolvorlage konnte nicht geladen werden' oder so ähnlich
      end
    end else
      Result := -3;                                                  // Defaultsymbole
    if skin = nil then                                               // default Symbol-Set laden
      skin := TSkinFactory.CreateFromResource('STDSYMBOLSET');
  end else
    Result := -1;                                                    // keine Symbole

  if skin = nil then begin
    TAlphaSpeedBtn(Play).Glyph := nil;
    TAlphaSpeedBtn(Spieleab).Glyph := nil;
    TAlphaSpeedBtn(Spielebis).Glyph := nil;
    TAlphaSpeedBtn(VorherigesI).Glyph := nil;
    TAlphaSpeedBtn(VorherigesP).Glyph := nil;
    TAlphaSpeedBtn(SchrittZurueck).Glyph := nil;
    TAlphaSpeedBtn(NaechstesI).Glyph := nil;
    TAlphaSpeedBtn(NaechstesP).Glyph := nil;
    TAlphaSpeedBtn(SchrittVor).Glyph := nil;
    TAlphaSpeedBtn(GehezuIn).Glyph := nil;
    TAlphaSpeedBtn(GehezuOut).Glyph := nil;
    TAlphaSpeedBtn(SchnittUebernehmen).Glyph := nil;
    TAlphaSpeedBtn(Kapitel).Glyph := nil;
    TAlphaSpeedBtn(Marke).Glyph := nil;
    TAlphaSpeedBtn(Vorschau).Glyph := nil;
    TAlphaSpeedBtn(Schneiden).Glyph := nil;
    TAlphaSpeedBtn(Schnittpunkteeinzelnschneiden).Glyph := nil;
    TAlphaSpeedBtn(MarkierteSchnittpunkte).Glyph := nil;
    TAlphaSpeedBtn(nurAudiospeichern).Glyph := nil;
    TAlphaSpeedBtn(CutIn).Glyph := nil;
    TAlphaSpeedBtn(CutOut).Glyph := nil;
    TAlphaSpeedBtn(BtnVideoAdd).Glyph := nil;
    TAlphaSpeedBtn(SchnitteinfuegenvorMarkierungBtn).Glyph := nil;
    TAlphaSpeedBtn(SchnitteinfuegennachMarkierungBtn).Glyph := nil;
    TAlphaSpeedBtn(SchnitteinfuegenamEndeBtn).Glyph := nil;
    TAlphaSpeedBtn(SchnittaendernBtn).Glyph := nil;
    TAlphaSpeedBtn(ProjektNeuBtn).Glyph := nil;
    TAlphaSpeedBtn(ProjektLadenBtn).Glyph := nil;
    TAlphaSpeedBtn(ProjektSpeichernBtn).Glyph := nil;
{THU051004}
    TAlphaSpeedBtn(Pos0Btn).Glyph := nil;
    TAlphaSpeedBtn(EndeBtn).Glyph := nil;
    TAlphaSpeedBtn(EndeBtn1).Glyph := nil;
    TAlphaSpeedBtn(AudiooffsetfensterausBtn).Glyph := nil;
    TAlphaSpeedBtn(DateienfensterausBtn).Glyph := nil;
    TAlphaSpeedBtn(TempoMinusBtn).Glyph := nil;
    TAlphaSpeedBtn(TempoPlusBtn).Glyph := nil;
{---------}
  end else begin
{    // test ob update nötig
    if skin.Skin.Width = 282 then begin                   // old format
      SymbolMappingQ6(skin);                              // altes q6 Format
      skin := SymbolVorlagenUpdaten(skin, DateiName)
    end else
      SymbolMapping72(skin);
}
    SymbolMapping74(skin);     // 297x165
    skin.Premultiply;          // darf nicht beim einladen gemacht werden, sonst
                               // funktioniert das Update nicht mehr richtig.

    TAlphaSpeedBtn(Play).Glyph := skin.GetBitmap([0, 2]);
    TAlphaSpeedBtn(Vorschau).Glyph := skin.GetBitmap([1, 3]);
    TAlphaSpeedBtn(Kapitel).Glyph := skin.GetBitmap([4,5]);
    TAlphaSpeedBtn(Marke).Glyph := skin.GetBitmap(6);
    TAlphaSpeedBtn(GehezuIn).Glyph := skin.GetBitmap(7);
    TAlphaSpeedBtn(GehezuOut).Glyph := skin.GetBitmap(13);
    TAlphaSpeedBtn(CutIn).Glyph := skin.GetBitmap([8,14]);
    TAlphaSpeedBtn(CutOut).Glyph := skin.GetBitmap([9,15]);
    TAlphaSpeedBtn(Schnittpunkteeinzelnschneiden).Glyph := skin.GetBitmap([10,16]);
    TAlphaSpeedBtn(MarkierteSchnittpunkte).Glyph := skin.GetBitmap([11,17]);
    TAlphaSpeedBtn(nurAudiospeichern).Glyph := skin.GetBitmap([12,18]);
    TAlphaSpeedBtn(Schneiden).Glyph := skin.GetBitmap(19);
    TAlphaSpeedBtn(VorherigesI).Glyph := skin.GetBitmap(20);
    TAlphaSpeedBtn(NaechstesI).Glyph := skin.GetBitmap(21);
    TAlphaSpeedBtn(VorherigesP).Glyph := skin.GetBitmap(22);
    TAlphaSpeedBtn(NaechstesP).Glyph := skin.GetBitmap(23);
    TAlphaSpeedBtn(SchrittZurueck).Glyph := skin.GetBitmap(24);
    TAlphaSpeedBtn(SchrittVor).Glyph := skin.GetBitmap(25);
    TAlphaSpeedBtn(Spieleab).Glyph := skin.GetBitmap([26,27]);
    TAlphaSpeedBtn(Spielebis).Glyph := skin.GetBitmap([28,29]);
    TAlphaSpeedBtn(ProjektNeuBtn).Glyph := skin.GetBitmap(30);
    TAlphaSpeedBtn(ProjektLadenBtn).Glyph := skin.GetBitmap(31);
    TAlphaSpeedBtn(ProjektSpeichernBtn).Glyph := skin.GetBitmap(32);
    // dazwischen mein SchnittlistenIcon skin.GetBitmap(33);
{THU051004}
    TAlphaSpeedBtn(Pos0Btn).Glyph := skin.GetBitmap(34);
    TAlphaSpeedBtn(EndeBtn).Glyph := skin.GetBitmap(35);
    TAlphaSpeedBtn(EndeBtn1).Glyph := skin.GetBitmap(35);
    TAlphaSpeedBtn(TempoMinusBtn).Glyph := skin.GetBitmap(37);
    TAlphaSpeedBtn(TempoPlusBtn).Glyph := skin.GetBitmap(38);
    TAlphaSpeedBtn(AudiooffsetfensterausBtn).Glyph := skin.GetBitmap(36);
    TAlphaSpeedBtn(DateienfensterausBtn).Glyph := skin.GetBitmap(36);
    TAlphaSpeedBtn(SchnitteinfuegenvorMarkierungBtn).Glyph := skin.GetBitmap(39);
    TAlphaSpeedBtn(SchnitteinfuegennachMarkierungBtn).Glyph := skin.GetBitmap(40);
    TAlphaSpeedBtn(SchnitteinfuegenamEndeBtn).Glyph := skin.GetBitmap(41);
    TAlphaSpeedBtn(SchnittaendernBtn).Glyph := skin.GetBitmap(42);
    TAlphaSpeedBtn(SchnittUebernehmen).Glyph := skin.GetBitmap(43);
    TAlphaSpeedBtn(BtnVideoAdd).Glyph := skin.GetBitmap(44);
{---------}
  end;
  Tastenbeschriftunganpassen;
end;

procedure TMpegEdit.TastenbeschriftungVerbergen(Taste: TSpeedButton);
begin
  if TAlphaSpeedBtn(Taste).Glyph <> nil then
    TAlphaSpeedBtn(Taste).CaptionHidden := True;
end;

procedure TMpegEdit.TastenbeschriftungAusrichten(Taste: TSpeedButton; Margin1, Spacing1, Margin2, Spacing2: Integer);
begin
  if TAlphaSpeedBtn(Taste).Glyph = nil then begin
    Taste.Margin := Margin2;
    Taste.Spacing := Spacing2;
  end else begin
    Taste.Margin := Margin1;
    Taste.Spacing := Spacing1;
  end;
end;

procedure TMpegEdit.Tastenbeschriftunganpassen;
begin
  // Zuerste die Text/Bild exklusiv buttons
  TastenbeschriftungVerbergen(Play);
  TastenbeschriftungVerbergen(Spielebis);
  TastenbeschriftungVerbergen(Spieleab);
  TastenbeschriftungVerbergen(VorherigesI);
  TastenbeschriftungVerbergen(VorherigesP);
  TastenbeschriftungVerbergen(SchrittZurueck);
  TastenbeschriftungVerbergen(NaechstesI);
  TastenbeschriftungVerbergen(NaechstesP);
  TastenbeschriftungVerbergen(SchrittVor);
  TastenbeschriftungVerbergen(Kapitel);
  TastenbeschriftungVerbergen(Marke);
  TastenbeschriftungVerbergen(Vorschau);
  TastenbeschriftungVerbergen(Schneiden);
  TastenbeschriftungVerbergen(Schnittpunkteeinzelnschneiden);
  TastenbeschriftungVerbergen(MarkierteSchnittpunkte);
  TastenbeschriftungVerbergen(nurAudiospeichern);
  TastenbeschriftungVerbergen(BtnVideoAdd);
  TastenbeschriftungAusrichten(CutIn, 1, 0, -1, 4);
  TastenbeschriftungAusrichten(CutOut, 1, 0, -1, 4);
  TastenbeschriftungAusrichten(Schnittuebernehmen, 2, 4, 2, 4);
  TastenbeschriftungVerbergen(ProjektNeuBtn);
  TastenbeschriftungVerbergen(ProjektLadenBtn);
  TastenbeschriftungVerbergen(ProjektSpeichernBtn);
{THU051004}
  TastenbeschriftungVerbergen(Pos0Btn);
  TastenbeschriftungVerbergen(EndeBtn);
  TastenbeschriftungVerbergen(EndeBtn1);
  TastenbeschriftungVerbergen(AudiooffsetfensterausBtn);
  TastenbeschriftungVerbergen(DateienfensterausBtn);
  TastenbeschriftungVerbergen(TempoMinusBtn);
  TastenbeschriftungVerbergen(TempoPlusBtn);
{---------}
  SetPositionIn(PositionIn);
  SetPositionOut(PositionOut);
  TastenbeschriftungAusrichten(SchnitteinfuegenvorMarkierungBtn, 2, 0, -1, 4);
  TastenbeschriftungAusrichten(SchnitteinfuegennachMarkierungBtn, 2, 0, -1, 4);
  TastenbeschriftungAusrichten(SchnitteinfuegenamEndeBtn, 2, 0, -1, 4);
  TastenbeschriftungAusrichten(SchnittaendernBtn, 2, 0, -1, 4);
end;

procedure TMpegEdit.DateienlisteEinAusBtnClick(Sender: TObject);
begin
  Dateien.Visible := NOT Dateien.Visible;
  Fenstereinstellen;
end;

// ------- Paneltasten -----------------

PROCEDURE TMpegEdit.Panelaktivieren(Panel: TPanel; Aktive: Boolean);
BEGIN
  IF Aktive THEN
    Panel.BevelOuter := bvRaised
  ELSE
    Panel.BevelOuter := bvLowered;
END;

procedure TMpegEdit.Dateifensterein_Click(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  DateienfensterausPanel.Visible := True;
  ArbeitsumgebungObj.DateienfensterSichtbar := True;
  DateienTrennPanel.Visible := True;
  DateifenstereinPanel.Visible := False;
  Fenstereinstellen;
end;

procedure TMpegEdit.DateienfensterausBtnClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  DateienfensterausPanel.Visible := False;
  ArbeitsumgebungObj.DateienfensterSichtbar := False;
  DateienTrennPanel.Visible := False;
  DateifenstereinPanel.Visible := True;
  Fenstereinstellen;
end;

procedure TMpegEdit.Dateifensterein_MouseEnter(Sender: TObject);
begin
  Panelaktivieren(TLabel(Sender).Parent as TPanel, True);
end;

procedure TMpegEdit.Dateifensterein_MouseLeave(Sender: TObject);
begin
  Panelaktivieren(TLabel(Sender).Parent as TPanel, False);
end;

procedure TMpegEdit.Audiooffsetein_Click(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
  AudioSkewPanel.Visible := True;
  AudiooffseteinPanel.Visible := False;
  Fenstereinstellen;
end;

procedure TMpegEdit.Audiooffsetein_MouseEnter(Sender: TObject);
begin
  Panelaktivieren(TLabel(Sender).Parent as TPanel, True);
end;

procedure TMpegEdit.Audiooffsetein_MouseLeave(Sender: TObject);
begin
  Panelaktivieren(TLabel(Sender).Parent as TPanel, False);
end;

procedure TMpegEdit.AnzeigeClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
end;

procedure TMpegEdit.VAGroessePanelClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
end;

procedure TMpegEdit.VorschauSchneidenPanelClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
end;

procedure TMpegEdit.AudioSkewPanelClick(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
end;

procedure TMpegEdit.AudiooffsetfensterkleinBtnClick(Sender: TObject);
begin
  IF AudioSkewPanel.Height > 50 THEN
    AudioSkewPanel.Height := 30
  ELSE
    AudioSkewPanel.Height := 110;
  Fenstereinstellen;  
end;

procedure TMpegEdit.ListenverschiebePanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  IF Shift = [ssLeft]	THEN
    IF ArbeitsumgebungObj.ListenfensterLinks THEN
      IF ListenTrennPanel.Left + X - 1 < 215 THEN
        ListenTrennXPanel.Left := 215
      ELSE
        IF ListenTrennPanel.Left + X - 1 > ClientWidth - 500 THEN
          ListenTrennXPanel.Left := ClientWidth - 500
        ELSE
          ListenTrennXPanel.Left := ListenTrennPanel.Left + X - 1
    ELSE
      IF ListenTrennPanel.Left + X - 1 < 500 THEN
        ListenTrennXPanel.Left := 500
      ELSE
        IF ListenTrennPanel.Left + X - 1 > ClientWidth - 215 THEN
          ListenTrennXPanel.Left := ClientWidth - 215
        ELSE
          ListenTrennXPanel.Left := ListenTrennPanel.Left + X - 1;
end;

procedure TMpegEdit.ListenTrennPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF Shift = [ssLeft]	THEN
  BEGIN
    ListenTrennXPanel.Height := ListenTrennPanel.Height;
    ListenTrennPanel.Visible := False;
    ListenTrennXPanel.Visible := True;
  END;
end;

procedure TMpegEdit.ListenverschiebePanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF ArbeitsumgebungObj.ListenfensterLinks THEN
    ArbeitsumgebungObj.ListenfensterBreite := ListenTrennXPanel.Left + ListenTrennXPanel.Width
  ELSE
    ArbeitsumgebungObj.ListenfensterBreite := ClientWidth - ListenTrennXPanel.Left;
  ListenTrennXPanel.Visible := False;
  ListenTrennPanel.Visible := True;
  Fenstereinstellen;
end;

procedure TMpegEdit.DateienTrennPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF Shift = [ssLeft]	THEN
  BEGIN
    DateienTrennXPanel.Width := DateienTrennPanel.Width;
    DateienTrennXPanel.Left := DateienTrennPanel.Left;
    DateienTrennPanel.Visible := False;
    DateienTrennXPanel.Visible := True;
  END;
end;

procedure TMpegEdit.DateienTrennPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  IF Shift = [ssLeft]	THEN
    IF DateienTrennPanel.Top + Y - 1 < 135 THEN
      DateienTrennXPanel.Top := 135
    ELSE
      IF DateienTrennPanel.Top + Y - 1 > ClientHeight - 157 - 3 THEN
        DateienTrennXPanel.Top := ClientHeight - 157 - 3
      ELSE
        DateienTrennXPanel.Top := DateienTrennPanel.Top + Y - 1;
//    ArbeitsumgebungObj.DateienfensterHoehe := DateienfensterausPanel.Height - Y + 1;
end;

procedure TMpegEdit.DateienTrennPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ArbeitsumgebungObj.DateienfensterHoehe := DateienfensterausPanel.Height + DateienfensterausPanel.Top - DateienTrennXPanel.Top - DateienTrennXPanel.Height;
  DateienTrennXPanel.Visible := False;
  DateienTrennPanel.Visible := True;
  Fenstereinstellen;
end;

procedure TMpegEdit.SchiebereglerEnter(Sender: TObject);
begin
  IF Enabled THEN
    Pos0Panel.SetFocus;
end;

procedure TMpegEdit.ListenMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IF Shift = [ssRight] THEN
  BEGIN
    ListenTabIndex := Listen.IndexOfTabAt(X, Y);
    Listen.Cursor := crNoDrop;
  END;
end;

procedure TMpegEdit.ListenMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IF ListenTabIndex > -1 THEN
    Listen.Pages[ListenTabIndex].PageIndex := Listen.IndexOfTabAt(X, Y);
  ListenTabIndex := -1;
  Listen.Cursor := crDefault;
end;

procedure TMpegEdit.ListenMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  IF Shift = [ssRight] THEN
    IF (Listen.IndexOfTabAt(X, Y) <> ListenTabIndex) THEN
      Listen.Cursor := crDrag
    ELSE
      Listen.Cursor := crNoDrop
  ELSE
    Listen.Cursor := crDefault;
end;

PROCEDURE TMpegEdit.Infoaktualisieren;

VAR Playergestoppt : Boolean;

BEGIN
  IF AbspielModus THEN
  BEGIN
    AbspielModus := False;
    PlayerPause;
    Playergestoppt := True;
  END
  ELSE
    Playergestoppt := False;
  InfoaktualisierenVideo;
  InfoaktualisierenAudio;
  Eigenschaftenanzeigen;
  IF Playergestoppt THEN
  BEGIN
    AbspielModus := True;
    PlayerStart;
    CutIn.Enabled := False;
    CutOut.Enabled := False;
  END;
END;

PROCEDURE TMpegEdit.InfoaktualisierenVideo;

VAR MpegHeader : TMpeg2Header;
    HBildHeader : TBildHeader;
    Dateigeoeffnet,
    Dateigeschlossen : Boolean;
    Index : Int64;
    HSeitenverhaeltnis : Byte;

BEGIN
  IF Assigned(aktVideoknoten) AND
     Assigned(aktVideoknoten.Data) AND
     (TDateiEintrag(aktVideoknoten.Data).Name <> '') THEN
  BEGIN
    MpegHeader := TMpeg2Header.Create;
    HBildHeader := TBildHeader.Create;
    HSeitenverhaeltnis := SequenzHeader.Seitenverhaeltnis;
    TRY
      Dateigeschlossen := False;
      Dateigeoeffnet := MpegHeader.Dateioeffnen(TDateiEintrag(aktVideoknoten.Data).Name);
      IF NOT Dateigeoeffnet THEN
      BEGIN
        Videodatei_freigeben;
        Dateigeschlossen := True;
        Dateigeoeffnet := MpegHeader.Dateioeffnen(TDateiEintrag(aktVideoknoten.Data).Name);
      END;
      IF Dateigeoeffnet THEN
      BEGIN
        IF SchiebereglerPosition < IndexListe.Count THEN
        BEGIN
          Index := TBildIndex(IndexListe[SchiebereglerPosition]).BildIndex;
          MpegHeader.DateiStream.NeuePosition(THeaderklein(VideoListe[Index]).Adresse);
          MpegHeader.DateiInformationLesen(SequenzHeader, BildHeader);
          WHILE (Index > 0) AND NOT (THeaderklein(VideoListe[Index]).HeaderTyp = SequenceStartCode) DO
            Dec(Index);
          MpegHeader.DateiStream.NeuePosition(THeaderklein(VideoListe[Index]).Adresse);
          MpegHeader.DateiInformationLesen(SequenzHeader, HBildHeader);
        END;
      END;
    FINALLY
      MpegHeader.Free;
      HBildHeader.Free;
    END;
    IF Dateigeschlossen THEN
      Videodatei_laden(TDateiEintrag(aktVideoknoten.Data).Name, VideoListe, IndexListe);
    IF NOT (HSeitenverhaeltnis = SequenzHeader.Seitenverhaeltnis) THEN
      Bildeinpassen(ArbeitsumgebungObj.Videoanzeigefaktor);
//    Anzeigeaktualisieren(SchiebereglerPosition);
  END;
END;

PROCEDURE TMpegEdit.InfoaktualisierenAudio;

VAR MpegAudio : TMpegAudio;
    Dateigeoeffnet,
    Dateigeschlossen : Boolean;
    Index : Int64;

BEGIN
  IF (Assigned(aktAudioknoten) AND
     Assigned(aktAudioknoten.Data) AND
     (TDateieintragAudio(aktAudioknoten.Data).Name <> '')) THEN
  BEGIN
    MpegAudio := TMpegAudio.Create;
    TRY
      Dateigeschlossen := False;
      Dateigeoeffnet := MpegAudio.Dateioeffnen(TDateiEintragAudio(aktAudioknoten.Data).Name) = 0;
      IF NOT Dateigeoeffnet THEN
      BEGIN
        AudioPlayerClose;
        Dateigeschlossen := True;
        Dateigeoeffnet := MpegAudio.Dateioeffnen(TDateiEintragAudio(aktAudioknoten.Data).Name) = 0;
      END;
      IF Dateigeoeffnet THEN
      BEGIN
        Index := Round(((SchiebereglerPosition * Bildlaenge) - TDateiEintragAudio(aktAudioknoten.Data).Audiooffset) / Audioheader.Framezeit);
        IF (Index > -1) AND (Index < AudioListe.Count) THEN
          MpegAudio.DateiStream.NeuePosition(TAudioHeaderklein(AudioListe[Index]).Adresse);
        MpegAudio.DateiInformationLesen(AudioHeader);
      END;
    FINALLY
      MpegAudio.Free;
    END;
    IF Dateigeschlossen THEN
      AudioplayerOeffnen(TDateiEintrag(aktAudioknoten.Data).Name);
  END;
END;

procedure TMpegEdit.InfoAktualisierenMenuItemClick(Sender: TObject);
begin
  Infoaktualisieren;
end;

procedure TMpegEdit.InfoRueckgaengigMenuItemClick(Sender: TObject);
begin
  Informationen.Undo;
end;

procedure TMpegEdit.InfoAusschneidenMenuItemClick(Sender: TObject);
begin
  Informationen.CutToClipboard;
end;

procedure TMpegEdit.InfoKopierenMenuItemClick(Sender: TObject);
begin
  Informationen.CopyToClipboard;
end;

procedure TMpegEdit.InfoEinfuegenMenuItemClick(Sender: TObject);
begin
  Informationen.PasteFromClipboard;
end;

procedure TMpegEdit.InfoLoeschenMenuItemClick(Sender: TObject);
begin
  Informationen.ClearSelection;
end;

procedure TMpegEdit.InfoPopupMenuPopup(Sender: TObject);
begin
  IF (Assigned(aktVideoknoten) AND
     Assigned(aktVideoknoten.Data) AND
     (TDateiEintrag(aktVideoknoten.Data).Name <> '')) OR
     (Assigned(aktAudioknoten) AND
     Assigned(aktAudioknoten.Data) AND
     (TDateieintragAudio(aktAudioknoten.Data).Name <> '')) THEN
    InfoAktualisierenMenuItem.Enabled := True
  ELSE
    InfoAktualisierenMenuItem.Enabled := False;
  IF Informationen.SelLength > 0 THEN
  BEGIN
    IF Informationen.ReadOnly THEN
    BEGIN
      InfoAusschneidenMenuItem.Enabled := False;
      InfoLoeschenMenuItem.Enabled := False;
    END
    ELSE
    BEGIN
      InfoAusschneidenMenuItem.Enabled := True;
      InfoLoeschenMenuItem.Enabled := True;
    END;
    InfoKopierenMenuItem.Enabled := True;
  END
  ELSE
  BEGIN
    InfoAusschneidenMenuItem.Enabled := False;
    InfoKopierenMenuItem.Enabled := False;
    InfoLoeschenMenuItem.Enabled := False;
  END;
  IF Informationen.CanUndo THEN
    InfoRueckgaengigMenuItem.Enabled := True
  ELSE
    InfoRueckgaengigMenuItem.Enabled := False;
  IF Informationen.ReadOnly THEN
    InfoEinfuegenMenuItem.Enabled := False
  ELSE
    InfoEinfuegenMenuItem.Enabled := True;
end;

procedure TMpegEdit.ZweiFensterMenuItemClick(Sender: TObject);

VAR BMP: TBitMap;

begin
  ZweiFensterMenuItem.Checked := NOT ZweiFensterMenuItem.Checked;
  IF ZweiFensterMenuItem.Checked THEN
  BEGIN
    BildFlaeche.Visible := True;
    Anzeigeflaeche.BevelKind := bkFlat;
    Anzeigeflaeche.Color := ArbeitsumgebungObj.Videohintergrundfarbeakt;
    BMP := BMPBildlesen(-2, -2, True, False);
    IF Assigned(BMP) THEN
    BEGIN
      TRY
        VideoImage.Picture.Assign(BMP);
      FINALLY
        BMP.Free;
      END;
    END;
    StandBildPosition := SchiebereglerPosition;
    StandBildPositionFrame.Caption := IntToStr(StandBildPosition);
    StandBildPositionZeit.Caption := ZeitToStr(FramesToZeit(StandBildPosition, BilderProSek));
  END
  ELSE
  BEGIN
    BildFlaeche.Visible := False;
    Anzeigeflaeche.BevelKind := bkNone;
    Anzeigeflaeche.Color := ArbeitsumgebungObj.Videohintergrundfarbe;
  END;
  Fenstereinstellen;
end;

PROCEDURE TMpegEdit.LangeGOPsuchen(Anfang, Ende: Int64; VAR Frame1, Frame2: Int64; maxGOPLaenge: Integer);

VAR GOPAnfang, IFrame, GOPEnde : Int64;

BEGIN
  IFrame := Anfang;
  GOPEnde := VorherigesBild(2, Anfang - 1, IndexListe);        // vorheriges I- oder P-Frame suchen
  IF GOPEnde < 0 THEN
    GOPEnde := -1;                                             // Filmanfang
  REPEAT
    GOPAnfang := GOPEnde + 1;
    IFrame := NaechstesBild(1, IFrame + 1, IndexListe);        // nächstes I-Frame suchen
    IF IFrame < 0 THEN
      IFrame := IndexListe.Count;                              // Filmende
    GOPEnde := VorherigesBild(2, IFrame - 1, IndexListe);      // vorheriges I- oder P-Frame suchen
    IF GOPEnde > Ende THEN
      GOPEnde := Ende;
  UNTIL (GOPEnde = Ende) OR (GOPEnde - GOPAnfang + 1 > maxGOPLaenge);
  IF GOPEnde - GOPAnfang + 1 > maxGOPLaenge THEN
  BEGIN
    Frame1 := VorherigesBild(2, GOPAnfang + maxGOPLaenge, IndexListe);
    Frame2 := IFrame - 1;
  END
  ELSE
  BEGIN
    Frame1 := Ende;
    Frame2 := Ende;
  END;
END;

end.

