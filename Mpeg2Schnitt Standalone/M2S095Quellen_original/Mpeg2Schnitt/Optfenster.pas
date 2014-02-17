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

unit Optfenster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, IniFiles, StrUtils, ExtCtrls, Menus,
  Grids, Spin, {$Warnings off}FileCtrl{$Warnings on}, 
  Ausgfenster,                  // Datenbearbeitung
  Efffenster,                   // Effektvorgabenbearbeitung
  DatenTypen,                   // für verwendete Datentypen
  Sprachen,                     // für Sprachunterstützung
  Clipbrd,                      // Clipboard
  AllgFunktionen,               // allgemeine Funktionen
  Hinweis,                      // Hinweisfenster
  Mauladenspeichern;            // zum laden und speichern der Arbeitsumgebungen

type
  TComboBoxDaten = PROCEDURE(Index: Integer) OF OBJECT;
  TEditBoxDaten = PROCEDURE OF OBJECT;

  TOptionenfenster = class(TForm)
    AbbrechenTaste: TBitBtn;
    OptionenSpeichern: TBitBtn;
    OptionenSpeichernunter: TBitBtn;
    OptionenStandard: TBitBtn;
    OKTaste: TBitBtn;
    OptionenSeiten: TPageControl;
    ComboBoxMenue: TPopupMenu;
    ListeneintragDateisuchen: TMenuItem;
    Listeneintragneu: TMenuItem;
    Listeneintragkopieren: TMenuItem;
    Listeneintrageinfuegen: TMenuItem;
    Listeneintragaendern: TMenuItem;
    Listeneintragbearbeiten: TMenuItem;
    Listeneintragloeschen: TMenuItem;
    Trennlienie16: TMenuItem;
    ComboBoxAusschneidenClipboard: TMenuItem;
    ComboBoxKopierenClipboard: TMenuItem;
    ComboBoxEinfuegenClipboard: TMenuItem;
    ComboboxLoeschenClipboard: TMenuItem;
    EditBoxMenue: TPopupMenu;
    EditBoxDateisuchen: TMenuItem;
    EditBoxVerzeichnissuchen: TMenuItem;
    Trennlienie21: TMenuItem;
    EditBoxAusschneidenClipboard: TMenuItem;
    EditBoxKopierenClipboard: TMenuItem;
    EditBoxEinfuegenClipboard: TMenuItem;
    EditBoxLoeschenClipboard: TMenuItem;
    OptionenAllgemeinSeiteTab: TTabSheet;
    OptionenAllgemeineEinstellungen_: TGroupBox;
    OptionenIndexdateienloeschenBox: TCheckBox;
    OptionenProtokollerstellenBox: TCheckBox;
    OptionenfesteFramerateverwendenBox: TCheckBox;
    festeFramerateEdit: TEdit;
    OptionenfesteFramerate_: TLabel;
    OptionenSequenzEndeignorierenBox: TCheckBox;
    OptionennachSchneidenbeendenBox: TCheckBox;
    OptionenHinweisanzeigedauer_: TLabel;
    HinweisanzeigedauerEdit: TEdit;
    OptionenHinweisanzeigedauerSek_: TLabel;
    OptionenVerzeichnisseiteTab: TTabSheet;
    OptionenVideoAudioVerzeichnis_: TLabel;
    VideoAudioVerzeichnisEdit: TEdit;
    OptionenVideoAudioVerzeichnisBox: TCheckBox;
    OptionenZielVerzeichnis_: TLabel;
    ZielVerzeichnisEdit: TEdit;
    OptionenZielVerzeichnisBox: TCheckBox;
    OptionenProjektVerzeichnis_: TLabel;
    ProjektVerzeichnisEdit: TEdit;
    OptionenProjektVerzeichnisBox: TCheckBox;
    OptionenKapitelVerzeichnis_: TLabel;
    KapitelVerzeichnisEdit: TEdit;
    OptionenKapitelVerzeichnisBox: TCheckBox;
    OptionenVorschauVerzeichnis_: TLabel;
    VorschauVerzeichnisEdit: TEdit;
    OptionenZwischenVerzeichnis_: TLabel;
    ZwischenVerzeichnisEdit: TEdit;
    OptionenDateinamenEndungenseiteTab: TTabSheet;
    OptionenDateinamen_: TGroupBox;
    OptionenProjektdateiname_: TLabel;
    ProjektdateinameEdit: TEdit;
    OptionenProjektdateidialogunterdrueckenBox: TCheckBox;
    OptionenZielDateiname_: TLabel;
    ZielDateinameEdit: TEdit;
    OptionenZieldateidialogunterdrueckenBox: TCheckBox;
    OptionenKapiteldateiname_: TLabel;
    KapiteldateinameEdit: TEdit;
    OptionenDateinamennummerieren_: TGroupBox;
    OptionenProjektdateieneinzeln_: TLabel;
    ProjektdateieneinzelnFormatEdit: TEdit;
    OptionenSchnittdateieneinzeln_: TLabel;
    SchnittpunkteeinzelnFormatEdit: TEdit;
    OptionenEndungenVideo_: TGroupBox;
    OptionenDateiendungenVideo_: TLabel;
    DateiendungenVideoEdit: TEdit;
    OptionenStandardendungenVideo_: TLabel;
    StandardendungenVideoEdit: TEdit;
    OptionenEndungenAudio_: TGroupBox;
    OptionenDateiendungenAudio_: TLabel;
    DateiendungenAudioEdit: TEdit;
    OptionenStandardendungenAudio_: TLabel;
    StandardendungenAudioEdit: TEdit;
    OptionenStandardendungenPCM_: TLabel;
    StandardendungenPCMEdit: TEdit;
    OptionenStandardendungenMP2_: TLabel;
    StandardendungenMP2Edit: TEdit;
    OptionenStandardendungenAC3_: TLabel;
    StandardendungenAC3Edit: TEdit;
    OptionenAudioTrennzeichen_: TLabel;
    AudioTrennzeichenEdit: TEdit;
    OptionenStandardEndungenverwendenBox: TCheckBox;
    OptionenWiedergabeSeiteTab: TTabSheet;
    OptionenVideoanzeige_: TGroupBox;
    OptionenVideograudarstellenBox: TCheckBox;
    OptionenHauptfensteranpassenBox: TCheckBox;
    OptionenVideoanzeigegroesseBox: TCheckBox;
    OptionenVideohintergrund_: TLabel;
    OptionenVideohintergrundColorBox: TColorBox;
    OptionenVideohintergrundaktColorBox: TColorBox;
    OptionenWiedergabe_: TGroupBox;
    OptionenletztesVideoanzeigenBox: TCheckBox;
    OptionenTempo1beiPauseBox: TCheckBox;
    OptionenAudiowiedergabe_: TGroupBox;
    OptionenAudioFehleranzeigenBox: TCheckBox;
    OptionenkeinAudioRadio: TRadioButton;
    OptionenMCIPlayerRadio: TRadioButton;
    OptionenDSPlayerRadio: TRadioButton;
    OptionenAudioGraphName_: TLabel;
    AudioGraphNameEdit: TEdit;
    OptionenVideoAudioSchnittseiteTab: TTabSheet;
    OptionenSchnittAllgemein_: TGroupBox;
    OptionenIndexDateierstellenBox: TCheckBox;
    OptionenKapiteldateierstellenBox: TCheckBox;
    OptionenMuxenBox: TCheckBox;
    OptionenSpeicherplatzpruefenBox: TCheckBox;
    OptionenVideoschnitt_: TGroupBox;
    OptionenFramegenauschneidenBox: TCheckBox;
    OptionenTimecodekorrigierenBox: TCheckBox;
    OptionenBitratekorrigierenBox: TCheckBox;
    OptionenD2VDateierstellenBox: TCheckBox;
    OptionenIDXDateierstellenBox: TCheckBox;
    OptionenAudioschnitt_: TGroupBox;
    OptionenStilleAudioframes_: TLabel;
    OptionenAudioframesMpeg_: TLabel;
    OptionenAudioframesAC3_: TLabel;
    OptionenAudioframesPCM_: TLabel;
    AudioframesMpegComboBox: TComboBox;
    AudioframesAC3ComboBox: TComboBox;
    AudioframesPCMComboBox: TComboBox;
    OptionenSchnittlistenFormatseiteTab: TTabSheet;
    OptionenSchnittlistenformat_: TGroupBox;
    OptionenSchnittFormat_: TLabel;
    SchnittFormatEdit: TEdit;
    OptionenSchnittpunktTrennzeichen_: TLabel;
    SchnittpunktTrennzeichenEdit: TEdit;
    OptionenSchnittlistenFarbeinstellung_: TGroupBox;
    OptionenSchnittFormatberechnen_: TLabel;
    SchnittFormatberechnenColorBox: TColorBox;
    OptionenSchnittFormatnichtberechnen_: TLabel;
    SchnittFormatnichtberechnenColorBox: TColorBox;
    OptionenSchnittlistenSonstiges_: TGroupBox;
    OptionenSchnittFormatEinfuegen_: TLabel;
    SchnittFormatEinfuegenComboBox: TComboBox;
    OptionenKapitellistenFormatseiteTab: TTabSheet;
    OptionenKapitellistenformat_: TGroupBox;
    OptionenKapitelZahlenformat_: TLabel;
    KapitelFormatEdit: TEdit;
    OptionenSchnittlistenFormatuebernehmenBox: TCheckBox;
    OptionenKapitelTrennzeile: TLabel;
    KapitelTrennzeileEdit1: TEdit;
    KapitelTrennzeileEdit2: TEdit;
    KapitelTrennzeileEdit3: TEdit;
    KapitelTrennzeileEdit4: TEdit;
    OptionenKapitellistenFarbeinstellungen_: TGroupBox;
    OptionenKapitellistenFarbeVG_: TLabel;
    KapitellistenFarbeVGColorBox: TColorBox;
    OptionenKapitellistenFarbeHG_: TLabel;
    KapitellistenFarbeHGColorBox: TColorBox;
    OptionenKapitellistenMarkierungFarbeVG_: TLabel;
    KapitellistenMarkierungFarbeVGColorBox: TColorBox;
    OptionenKapitellistenMarkierungFarbeHG_: TLabel;
    KapitellistenMarkierungFarbeHGColorBox: TColorBox;
    OptionenKapitellistenVerschiebeFarbeVG_: TLabel;
    KapitellistenVerschiebeFarbeVGColorBox: TColorBox;
    OptionenKapitellistenVerschiebeFarbeHG_: TLabel;
    KapitellistenVerschiebeFarbeHGColorBox: TColorBox;
    OptionenKapitellistenSonstiges_: TGroupBox;
    OptionenKapitelFormatEinfuegen_: TLabel;
    KapitelFormatEinfuegenComboBox: TComboBox;
    OptionenMarkenlistenFormatseiteTab: TTabSheet;
    OptionenMarkenlistenFormat_: TGroupBox;
    OptionenMarkenZahlenformat_: TLabel;
    MarkenFormatEdit: TEdit;
    OptionenMarkenlistenSonstiges_: TGroupBox;
    OptionenMarkenlistebearbeitenBox: TCheckBox;
    OptionenMarkenFormatEinfuegen_: TLabel;
    MarkenFormatEinfuegenComboBox: TComboBox;
    OptionenListenImportseiteTab: TTabSheet;
    OptionenSchnittlistenimport_: TGroupBox;
    OptionenSchnittImportTrennzeichenliste_: TLabel;
    SchnittImportTrennzeichenCombobox: TComboBox;
    OptionenSchnittImportZeitTrennzeichenliste_: TLabel;
    SchnittImportZeitTrennzeichenCombobox: TComboBox;
    OptionenKapitellistenimport_: TGroupBox;
    OptionenSchnittlistenimportuebernehmenBox1: TCheckBox;
    OptionenKapitelImportTrennzeichenliste_: TLabel;
    KapitelImportTrennzeichenCombobox: TComboBox;
    OptionenKapitelImportZeitTrennzeichenliste_: TLabel;
    KapitelImportZeitTrennzeichenCombobox: TComboBox;
    OptionenMarkenlistenimport_: TGroupBox;
    OptionenSchnittlistenimportuebernehmenBox2: TCheckBox;
    OptionenMarkenImportTrennzeichenliste_: TLabel;
    MarkenImportTrennzeichenCombobox: TComboBox;
    OptionenMarkenImportZeitTrennzeichenliste_: TLabel;
    MarkenImportZeitTrennzeichenCombobox: TComboBox;
    OptionenListenExportseiteTab: TTabSheet;
    OptionenSchnittlistenexport_: TGroupBox;
    OptionenSchnittexportFormat_: TLabel;
    SchnittexportFormatEdit: TEdit;
    OptionenSchnittexportOffset_: TLabel;
    SchnittexportOffsetEdit: TEdit;
    OptionenKapitellistenexport_: TGroupBox;
    OptionenSchnittlistenexportuebernehmenBox1: TCheckBox;
    OptionenKapitelexportFormat_: TLabel;
    KapitelexportFormatEdit: TEdit;
    OptionenKapitelexportOffset_: TLabel;
    KapitelexportOffsetEdit: TEdit;
    OptionenMarkenlistenexport_: TGroupBox;
    OptionenSchnittlistenexportuebernehmenBox2: TCheckBox;
    OptionenMarkenexportFormat_: TLabel;
    MarkenexportFormatEdit: TEdit;
    OptionenMarkenexportOffset_: TLabel;
    MarkenexportOffsetEdit: TEdit;
    OptionenTastenbelegungseiteTab: TTabSheet;
    TastenbelegungGrid: TStringGrid;
    OptionenEigeneTastenbelegung_: TGroupBox;
    OptionenInfofensterTastenCheckBox: TCheckBox;
    OptionenSchnittlisteTastenCheckBox: TCheckBox;
    OptionenKapitellisteTastenCheckBox: TCheckBox;
    OptionenMarkenlisteTastenCheckBox: TCheckBox;
    OptionenDateienfensterTastenCheckBox: TCheckBox;
    OptionenSchrittweiten_: TGroupBox;
    OptionenSchrittweite1_: TLabel;
    Schrittweite1Edit: TEdit;
    OptionenSchrittweite2_: TLabel;
    Schrittweite2Edit: TEdit;
    OptionenSchrittweite3_: TLabel;
    Schrittweite3Edit: TEdit;
    OptionenSchrittweite4_: TLabel;
    Schrittweite4Edit: TEdit;
    OptionenNavigationsseiteTab: TTabSheet;
    OptionenAbspielzeit_: TLabel;
    AbspielzeitEdit: TEdit;
    OptionenAbspielzeit_sek: TLabel;
    OptionenVorschauseiteTab: TTabSheet;
    OptionenVorschaudateienloeschenBox: TCheckBox;
    OptionenVorschauneuberechnenBox: TCheckBox;
    VorschauDauer1Edit: TEdit;
    OptionenVorschauDauer_: TLabel;
    OptionenVorschauDauerSek_: TLabel;
    OptionenAusgabeseiteTab: TTabSheet;
    OptionenDemuxen_: TGroupBox;
    OptionenDemuxer_: TLabel;
    DemuxerBitBtn: TBitBtn;
    OptionenEncoden_: TGroupBox;
    OptionenEncoder_: TLabel;
    EncoderBitBtn: TBitBtn;
    OptionenAusgabe_: TGroupBox;
    OptionenAusgabePr_: TLabel;
    AusgabeBitBtn: TBitBtn;
    OptionenEffektseiteTab: TTabSheet;
    OptionenEffekt_bearbeiten_: TGroupBox;
    OptionenVideoEffekte_: TLabel;
    VideoEffektComboBox: TComboBox;
    VideoEffektBitBtn: TBitBtn;
    OptionenAudioEffekte_: TLabel;
    AudioEffektComboBox: TComboBox;
    AudioEffektBitBtn: TBitBtn;
    EffektAudioGroupBox: TGroupBox;
    OptionenEffektePCMRadioButton: TRadioButton;
    OptionenEffekteMP2RadioButton: TRadioButton;
    OptionenEffekteAC3RadioButton: TRadioButton;
    OptionenAlleTypenRadioButton: TRadioButton;
    OptionenEffekt_Voreinstellung_: TGroupBox;
    OptionenEffektvorgabenVideo_: TLabel;
    EffektvorgabeVideoComboBox: TComboBox;
    EffektvorgabeAudioBitBtn: TBitBtn;
    OptionenEffektvorgabenAudio_: TLabel;
    EffektvorgabeAudioComboBox: TComboBox;
    EffektvorgabeVideoBitBtn: TBitBtn;
    OptionenBeendenanzeigedauer_: TLabel;
    BeendenanzeigedauerEdit: TEdit;
    OptionenBeendenanzeigedauerSek_: TLabel;
    OptionenkeinVideoBox: TCheckBox;
    OptionenScrollradBox: TCheckBox;
    TastenbelegungMenu: TPopupMenu;
    Tastenbelegungloeschen: TMenuItem;
    AudioframesMpegBitBtn: TBitBtn;
    AudioframesAC3BitBtn: TBitBtn;
    AudioframesPCMBitBtn: TBitBtn;
    VideoAudioVerzeichnisBitBtn: TBitBtn;
    ZielVerzeichnisBitBtn: TBitBtn;
    ProjektVerzeichnisBitBtn: TBitBtn;
    KapitelVerzeichnisBitBtn: TBitBtn;
    VorschauVerzeichnisBitBtn: TBitBtn;
    ZwischenVerzeichnisBitBtn: TBitBtn;
    AudioGraphNameBitBtn: TBitBtn;
    MarkenImportTrennzeichenBitBtn: TBitBtn;
    MarkenImportZeitTrennzeichenBitBtn: TBitBtn;
    KapitelImportZeitTrennzeichenBitBtn: TBitBtn;
    KapitelImportTrennzeichenBitBtn: TBitBtn;
    SchnittImportZeitTrennzeichenBitBtn: TBitBtn;
    SchnittImportTrennzeichenBitBtn: TBitBtn;
    OptionenOberflaecheTab: TTabSheet;
    OptionenOberflaeche_: TGroupBox;
    OptionenDateienfensterhoehe_: TLabel;
    OptionenDateienfensterhoehePixel_: TLabel;
    OptionenListenfensterBreitePixel_: TLabel;
    OptionenListenfensterBreite_: TLabel;
    OptionenDateienfensterhoeheEdit: TEdit;
    OptionenListenfensterBreiteEdit: TEdit;
    OptionenListenfensterLinksBox: TCheckBox;
    OptionenSymbolGroupBox: TGroupBox;
    BilderdateiEdit: TEdit;
    OptionenkeineSymboleRadioButton: TRadioButton;
    OptionenStandardRadioButton: TRadioButton;
    OptionenSymboldateiRadioButton: TRadioButton;
    BilderdateiBitBtn: TBitBtn;
    OptionenTastenfensterzentrierenBox: TCheckBox;
    OptionenSchiebereglerMarkeranzeigenBox: TCheckBox;
    OptionenSchiebereglerPosbeibehaltenBox: TCheckBox;
    OptionenDateienimListenfensterBox: TCheckBox;
    OptionenProjektGroupBox: TGroupBox;
    OptionenProjektDateilisteBox: TCheckBox;
    OptionenProjektSchnittlisteBox: TCheckBox;
    OptionenProjektKapitellisteBox: TCheckBox;
    OptionenProjektMarkenlisteBox: TCheckBox;
    OptionenProjektEffektBox: TCheckBox;
    OptionenProjektSchneidenBox: TCheckBox;
    SchriftDialog: TFontDialog;
    OptionenSchriftarten_: TGroupBox;
    OptionenHauptfensterSchriftart_: TLabel;
    OptionenHauptfensterSchriftartEdit: TEdit;
    OptionenHauptfensterSchriftgroesseEdit: TEdit;
    OptionenHauptfensterSchriftartBtn: TBitBtn;
    OptionenTastenfensterSchriftart_: TLabel;
    OptionenTastenfensterSchriftartEdit: TEdit;
    OptionenTastenfensterSchriftgroesseEdit: TEdit;
    OptionenTastenfensterSchriftartBtn: TBitBtn;
    OptionenAnzeigefensterSchriftart_: TLabel;
    OptionenAnzeigefensterSchriftartEdit: TEdit;
    OptionenAnzeigefensterSchriftgroesseEdit: TEdit;
    OptionenAnzeigefensterSchriftartBtn: TBitBtn;
    OptionenDialogeSchriftart_: TLabel;
    OptionenDialogeSchriftartEdit: TEdit;
    OptionenDialogeSchriftgroesseEdit: TEdit;
    OptionenDialogeSchriftartBtn: TBitBtn;
    OptionenTastenFetteSchriftBox: TCheckBox;
    OptionenMenueTastenbedienungBox: TCheckBox;
    OptionenEnderechtsBox: TCheckBox;
    OptionenEndelinksBox: TCheckBox;
    OptionenVAextraBox: TCheckBox;
    OptionenVorschaudauererweiternBox: TCheckBox;
    VorschauDauer2Edit: TEdit;
    OptionenPlus_: TLabel;
    VorschaudauerPlusEdit: TEdit;
    OptionenVorschauDauerSek_2: TLabel;
    OptionenEndungenKapitel_: TGroupBox;
    OptionenDateiendungenKapitel_: TLabel;
    OptionenStandardendungenKapitel_: TLabel;
    DateiendungenKapitelEdit: TEdit;
    StandardendungenKapitelEdit: TEdit;
    OptionenVideohintergrundakt_: TLabel;
    OptionenGrobansichtSeiteTab: TTabSheet;
    OptionenSchrittweiteSpinEdit: TSpinEdit;
    OptionenSchrittweite_: TLabel;
    OptionenBildbreite_: TLabel;
    OptionenBildbreiteSpinEdit: TSpinEdit;
    OptionenWerbefarbeColorBox: TColorBox;
    OptionenWerbefarbe_: TLabel;
    OptionenFilmfarbe_: TLabel;
    OptionenFilmfarbeColorBox: TColorBox;
    OptionenAktivfarbe_: TLabel;
    OptionenAktivfarbeColorBox: TColorBox;
    OptionenSchnittBildbreite_: TLabel;
    SchnittBildbreiteSpinEdit: TSpinEdit;
    OptionenSchnittBildAnfangBox: TCheckBox;
    OptionenSchnittBildEndeBox: TCheckBox;
    EditBoxDateispeichern: TMenuItem;
    EditBoxDateispeichernunter: TMenuItem;
    OptionenEffektvorgabedatei_: TLabel;
    EffektvorgabedateiEdit: TEdit;
    EffektvorgabedateiBitBtn: TBitBtn;
    OptionenVideoEffektverz_: TLabel;
    VideoEffektverzEdit: TEdit;
    VideoEffektdateiBitBtn: TBitBtn;
    OptionenAudioEffektverz_: TLabel;
    AudioEffektverzEdit: TEdit;
    AudioEffektdateiBitBtn: TBitBtn;
    DemuxerDateiEdit: TEdit;
    EncoderDateiEdit: TEdit;
    AusgabeDateiEdit: TEdit;
    EditBoxFormat1: TMenuItem;
    EditBoxFormat2: TMenuItem;
    EditBoxFormat3: TMenuItem;
    OptionenOutSchnittanzeigenBox: TCheckBox;
    OptionenMaxGOPLaengeBox: TCheckBox;
    MaxGOPLaengeEdit: TEdit;
    OptionenersterHeader_: TLabel;
    BitrateersterHeaderComboBox: TComboBox;
    OptionenminBilder_: TLabel;
    minBilderEndeEdit: TEdit;
    minBilderAnfangEdit: TEdit;
    OptionenKlickBox: TCheckBox;
    OptionenDoppelKlickBox: TCheckBox;
    OptionenVideoeigenschaftenaktBox: TCheckBox;
    OptionenAudioeigenschaftenaktBox: TCheckBox;
    AspectratioersterHeaderComboBox: TComboBox;
    OptionenVorgabeeffekteverwendenBox: TCheckBox;
    OptionenZusammenhaengendeSchnitteberechnenBox: TCheckBox;
// ------------ Allgemeines -------------
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKTasteClick(Sender: TObject);
// ------------ Popupmenü -------------
    procedure ComboBoxMenuePopup(Sender: TObject);
    procedure ListeneintragDateisuchenClick(Sender: TObject);
    procedure ListeneintragneuClick(Sender: TObject);
    procedure ListeneintragaendernClick(Sender: TObject);
    procedure ListeneintragloeschenClick(Sender: TObject);
    procedure ListeneintragkopierenClick(Sender: TObject);
    procedure ListeneintrageinfuegenClick(Sender: TObject);
    procedure ListeneintragbearbeitenClick(Sender: TObject);
    procedure ComboBoxAusschneidenClipboardClick(Sender: TObject);
    procedure ComboBoxKopierenClipboardClick(Sender: TObject);
    procedure ComboBoxEinfuegenClipboardClick(Sender: TObject);
    procedure ComboboxLoeschenClipboardClick(Sender: TObject);
    procedure EditBoxMenuePopup(Sender: TObject);
    procedure EditBoxDateisuchenClick(Sender: TObject);
    procedure EditBoxVerzeichnissuchenClick(Sender: TObject);
    procedure EditBoxAusschneidenClipboardClick(Sender: TObject);
    procedure EditBoxKopierenClipboardClick(Sender: TObject);
    procedure EditBoxEinfuegenClipboardClick(Sender: TObject);
    procedure EditBoxLoeschenClipboardClick(Sender: TObject);
// ------------ Comboboxen -------------
    procedure ComboboxKeyPress(Sender: TObject; var Key: Char);
    procedure ComboboxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ComboBoxSelect(Sender: TObject);
    procedure ComboBoxDblClick(Sender: TObject);
    procedure ComboBoxBitBtnClick(Sender: TObject);
// ------------ Editboxen -------------
    procedure EditBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure EditBoxDblClick(Sender: TObject);
// ------------ Kapitelliste -------------
    procedure OptionenSchnittlistenFormatuebernehmenBoxClick(Sender: TObject);
// ------------ Listenimport -------------
    procedure OptionenSchnittlistenimportuebernehmenBox1Click(Sender: TObject);
    procedure OptionenSchnittlistenimportuebernehmenBox2Click(Sender: TObject);
// ------------ Listenexport -------------
    procedure OptionenSchnittlistenexportuebernehmenBox1Click(Sender: TObject);
    procedure OptionenSchnittlistenexportuebernehmenBox2Click(Sender: TObject);
// ------------ Effekte --------------------
    procedure EditBoxKeyPress(Sender: TObject; var Key: Char);
    procedure OptionenfesteFramerateverwendenBoxClick(Sender: TObject);
    procedure SpeichernTasteClick(Sender: TObject);
    procedure SpeichernunterTasteClick(Sender: TObject);
    procedure StandardTasteClick(Sender: TObject);
    procedure TastenbelegungloeschenClick(Sender: TObject);
    procedure SymboleRadioButtonClick(Sender: TObject);
    procedure EditBoxBitBtnClick(Sender: TObject);
    procedure OptionenHauptfensterSchriftartBtnClick(Sender: TObject);
    procedure OptionenTastenfensterSchriftartBtnClick(Sender: TObject);
    procedure OptionenAnzeigefensterSchriftartBtnClick(Sender: TObject);
    procedure OptionenDialogeSchriftartBtnClick(Sender: TObject);
    procedure TastenbelegungGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TastenbelegungGridDblClick(Sender: TObject);
    procedure TastenbelegungGridDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure TastenbelegungGridClick(Sender: TObject);
    procedure EditBoxDateispeichernClick(Sender: TObject);
    procedure EditBoxDateispeichernunterClick(Sender: TObject);
    procedure EditBoxFormatClick(Sender: TObject);
    procedure OptionenMaxGOPLaengeBoxClick(Sender: TObject);
    procedure BitrateersterHeaderComboBoxCloseUp(Sender: TObject);
    procedure BitrateersterHeaderComboBoxSelect(Sender: TObject);
    procedure AspectratioersterHeaderComboBoxCloseUp(Sender: TObject);
    procedure AspectratioersterHeaderComboBoxSelect(Sender: TObject);
  private
// ------------ Allgemeines -------------
    Titel : STRING;
// ------------ Popupmenü -------------
    aktComboBox : TComboBox;
    aktComboBoxDatenNeu : TComboBoxDaten;
    aktComboBoxDatenAendern : TComboBoxDaten;
    aktComboBoxDatenKopieren : TComboBoxDaten;
    aktComboBoxDatenBearbeiten : TComboBoxDaten;
    aktComboBoxModus : Integer;
// ------------ Editboxen -------------
    aktBoxDateioeffnenFilter : STRING;
    aktEditBox : TEdit;
    aktEditBoxDateioeffnen : TEditBoxDaten;
    aktEditBoxDateispeichern : TEditBoxDaten;
    aktEditBoxModus : Integer;
// ------------ Comboboxen -------------
    DatenZeigerComboBox : TObject;
// ------------ Tastenbelegung -------------
    Tastenbelegung : Boolean;
    TastenbelegungArray : ARRAY[0..46] OF Integer;
// ------------ Sprachen --------------------
    DemuxerbearbeitenDialogName,
    DemuxerbearbeitenParameterName,
    EncoderbearbeitenDialogName,
    EncoderbearbeitenParameterName,
    MuxerbearbeitenDialogName,
    MuxerbearbeitenParameterName,
    EffektbearbeitenDialogName,
    EffektbearbeitenParameterName,
    neuerEintrag,
    Kopievon : STRING;
// ------------ Allgemeines -------------
    PROCEDURE Arbeitsumgebungeinlesen(Arbeitsumgebung: TArbeitsumgebung);
    FUNCTION Eingabenpruefen: Integer;
    FUNCTION Arbeitsumgebungschreiben(Arbeitsumgebung: TArbeitsumgebung): Integer;
// ------------ Popupmenü -------------
    FUNCTION Listeneintrag_Neu(Eintragstext: STRING): Integer;
    FUNCTION Listeneintrag_Aendern(Eintragstext: STRING): Integer;
// ------------ Comboboxen -------------
    PROCEDURE Comboboxenloeschen;
    PROCEDURE DatenbehandlungfestlegenComboBox(Sender: TObject);
// ------------ Editboxen -------------
    PROCEDURE DatenbehandlungfestlegenEditBox(Sender: TObject);
// ------------ Arbeitsumgebungen -------------
    PROCEDURE ArbeitsumgebungausDialogspeichern(Name: STRING);
// ------------ Kapitelliste -------------
    PROCEDURE SchnittlistenFormatuebernehmen_gedrueckt;
// ------------ Listenimport -------------
    PROCEDURE Schnittlistenimportuebernehmen1_gedrueckt;
    PROCEDURE Schnittlistenimportuebernehmen2_gedrueckt;
// ------------ Listenexport -------------
    PROCEDURE Schnittlistenexportuebernehmen1_gedrueckt;
    PROCEDURE Schnittlistenexportuebernehmen2_gedrueckt;
// ------------ Effekte --------------------
//    FUNCTION DatenKopieren(Quelle, Ziel: TAusgabeDaten): STRING;
    FUNCTION EffektDatenkopieren(Quelle: TDateiListeneintrag): TDateiListeneintrag;
    FUNCTION EffektvorgabeDatenKopieren(Quelle: TEffektEintrag): TEffektEintrag;
    PROCEDURE EffektListeneinlesen(Arbeitsumgebung : TArbeitsumgebung);
    PROCEDURE EffektListenschreiben(Arbeitsumgebung : TArbeitsumgebung);
    PROCEDURE EffektvorgabeListeneinlesen(Arbeitsumgebung : TArbeitsumgebung);
    PROCEDURE EffektvorgabeListenschreiben(Arbeitsumgebung : TArbeitsumgebung);
    PROCEDURE EffektDatenEintragNeuVideo(Index: Integer);
    PROCEDURE EffektDatenEintragKopierenVideo(Index: Integer);
    PROCEDURE EffektDatenEintragAendernVideo(Index: Integer);
    PROCEDURE EffektDatenEintragBearbeitenVideo(Index: Integer);
    PROCEDURE EffektDatenEintragNeuAudio(Index: Integer);
    PROCEDURE EffektDatenEintragKopierenAudio(Index: Integer);
    PROCEDURE EffektDatenEintragAendernAudio(Index: Integer);
    PROCEDURE EffektDatenEintragBearbeitenAudio(Index: Integer);
    PROCEDURE Effekteladen;
    PROCEDURE EffektvorgabeDatenEintragNeu(Index: Integer);
    PROCEDURE EffektvorgabeDatenEintragKopieren(Index: Integer);
    PROCEDURE EffektvorgabeDatenBearbeitenVideo(Index: Integer);
    PROCEDURE EffektvorgabeDatenBearbeitenAudio(Index: Integer);
    PROCEDURE EffektvorgabeDateiladen;
    PROCEDURE EffektvorgabeDateispeichern;
// ------------ Ein-/Ausgabeprogramme --------------------
//    FUNCTION AusgabeDatenkopieren(Quelle: TProgramme): TProgramme;
//    PROCEDURE AusgabeListeneinlesen(Arbeitsumgebung : TArbeitsumgebung);
//    PROCEDURE AusgabeListenschreiben(Arbeitsumgebung : TArbeitsumgebung);
//    PROCEDURE AusgabeDatenEintragNeu(Index: Integer);
//    PROCEDURE AusgabeDatenEintragKopieren(Index: Integer);
//    PROCEDURE AusgabeDatenEintragAendern(Index: Integer);
//    PROCEDURE AusgabeDatenEintragBearbeiten(Index: Integer);
//    PROCEDURE AusgabeDateiladen;
//    PROCEDURE AusgabeDateispeichern;
  public
    { Public-Deklarationen }
    Arbeitsumgebung : TArbeitsumgebung;
    Dateienleer : Boolean;
// ------------ Tastenbelegung -------------
    PROCEDURE Tasten_weiterleiten(var Msg: TMsg; var Handled: Boolean);
// ------------ Allgemeines -------------
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
    Optionenfenster: TOptionenfenster;

implementation

{$R *.dfm}

// ++++++++++++++++++Formular++++++++++++++++++++++++++++

procedure TOptionenfenster.FormCreate(Sender: TObject);
begin
  Comboboxenloeschen;
end;

procedure TOptionenfenster.FormDestroy(Sender: TObject);
begin
// ------------ Effekte --------------------
  Stringliste_loeschen(VideoEffektComboBox.Items);
  Stringliste_loeschen(AudioEffektComboBox.Items);
  Stringliste_loeschen(EffektvorgabeVideoComboBox.Items);
  Stringliste_loeschen(EffektvorgabeAudioComboBox.Items);
end;

procedure TOptionenfenster.FormShow(Sender: TObject);
begin
  Font.Name := Arbeitsumgebung.DialogeSchriftart;
  Font.Size := Arbeitsumgebung.DialogeSchriftgroesse;
  OptionenSeiten.Height := (OptionenSeiten.RowCount * OptionenSeiten.TabHeight) + 340;
  ClientHeight := OptionenSeiten.Height + 53;
// ------------ Comboboxen ---------------------------
  DatenZeigerComboBox := NIL;
  aktComboBoxDatenNeu := NIL;
  aktComboBoxDatenNeu := NIL;
  aktComboBoxModus := 0;
// ------------ Arbeitsumgebungen -------
  Arbeitsumgebungeinlesen(Arbeitsumgebung);
  Caption := Titel + '     ' + Arbeitsumgebung.Dateiname;
  SchnittlistenFormatuebernehmen_gedrueckt;
  Schnittlistenimportuebernehmen1_gedrueckt;
  Schnittlistenimportuebernehmen2_gedrueckt;
  Schnittlistenexportuebernehmen1_gedrueckt;
  Schnittlistenexportuebernehmen2_gedrueckt;
// ------------ Oberfläche ---------------------------
  IF Dateienleer THEN
    OptionenDateienimListenfensterBox.Enabled := True
  ELSE
    OptionenDateienimListenfensterBox.Enabled := False;
// ------------ Tastenbelegung -----------------------
  TastenbelegungGrid.ColWidths[0] := 280;
  TastenbelegungGrid.ColWidths[1] := 100;
end;

procedure TOptionenfenster.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Comboboxenloeschen;
end;

PROCEDURE TOptionenfenster.Comboboxenloeschen;

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  FOR I := 0 TO ComponentCount - 1 DO
  BEGIN
    Komponente := Components[I];
    IF Komponente IS TComboBox THEN
    BEGIN
      TComboBox(Komponente).Text := '';
      TComboBox(Komponente).Tag := -1;
    END;
  END;
END;

// ++++++++++++++++++Bedienelemente Allgemein++++++++++++++

procedure TOptionenfenster.OKTasteClick(Sender: TObject);
begin
  IF Eingabenpruefen = 0 THEN
  BEGIN
    Arbeitsumgebungschreiben(Arbeitsumgebung);
    EffektListenschreiben(Arbeitsumgebung);
    EffektvorgabeListenschreiben(Arbeitsumgebung);
    ModalResult := mrOk;
  END
  ELSE
    ModalResult := mrNone;
end;

PROCEDURE TOptionenfenster.Arbeitsumgebungeinlesen(Arbeitsumgebung: TArbeitsumgebung);

VAR I : Integer;

BEGIN
  IF Assigned(Arbeitsumgebung) THEN
  BEGIN
  // ------------ Allgemein --------------------------------
    OptionenIndexdateienloeschenBox.Checked := Arbeitsumgebung.Indexdateienloeschen;
    OptionenProtokollerstellenBox.Checked := Arbeitsumgebung.Protokollerstellen;
    festeFramerateEdit.Text := FloatToStr(Arbeitsumgebung.festeFramerate);
    OptionenfesteFramerateverwendenBox.Checked := Arbeitsumgebung.festeFramerateverwenden;
    IF OptionenfesteFramerateverwendenBox.Checked THEN
      festeFramerateEdit.Enabled := True
    ELSE
      festeFramerateEdit.Enabled := False;
    OptionenSequenzEndeignorierenBox.Checked := Arbeitsumgebung.SequenzEndeignorieren;
    OptionennachSchneidenbeendenBox.Checked := Arbeitsumgebung.nachSchneidenbeenden;
    OptionenSchiebereglerPosbeibehaltenBox.Checked := Arbeitsumgebung.SchiebereglerPosbeibehalten;
    HinweisanzeigedauerEdit.Text := IntToStr(Arbeitsumgebung.Hinweisanzeigedauer);
    BeendenanzeigedauerEdit.Text := IntToStr(Arbeitsumgebung.Beendenanzeigedauer);
  // ------------ Projekt -----------------------------------
    OptionenProjektDateilisteBox.Checked := Arbeitsumgebung.Dateilistegeaendert;
    OptionenProjektSchnittlisteBox.Checked := Arbeitsumgebung.Schnittlistegeaendert;
    OptionenProjektKapitellisteBox.Checked := Arbeitsumgebung.Kapitellistegeaendert;
    OptionenProjektMarkenlisteBox.Checked := Arbeitsumgebung.Markenlistegeaendert;
    OptionenProjektEffektBox.Checked := Arbeitsumgebung.Effektgeaendert;
    OptionenProjektSchneidenBox.Checked := Arbeitsumgebung.Schneidensetztzurueck;
  // ------------ Oberfläche --------------------------------
    OptionenDateienfensterhoeheEdit.Text := IntToStr(Arbeitsumgebung.DateienfensterHoehe);
    OptionenListenfensterBreiteEdit.Text := IntToStr(Arbeitsumgebung.ListenfensterBreite);
    OptionenListenfensterLinksBox.Checked := Arbeitsumgebung.ListenfensterLinks;
    OptionenDateienimListenfensterBox.Checked := Arbeitsumgebung.DateienimListenfenster;
    Arbeitsumgebung.Bilderdateigeaendert := False;
    BilderdateiEdit.Enabled := False;
    CASE Arbeitsumgebung.Bilderverwenden OF
      0 : OptionenkeineSymboleRadioButton.Checked := True;
      2 : BEGIN
            OptionenSymboldateiRadioButton.Checked := True;
            BilderdateiEdit.Enabled := True;
          END;
    ELSE
      OptionenStandardRadioButton.Checked := True;
    END;
    BilderdateiEdit.Text := relativPathAppl(Arbeitsumgebung.Bilderdatei, Application.ExeName);
    OptionenTastenfensterzentrierenBox.Checked := Arbeitsumgebung.Tastenfensterzentrieren;
    OptionenSchiebereglerMarkeranzeigenBox.Checked := Arbeitsumgebung.SchiebereglerMarkeranzeigen;
    OptionenMenueTastenbedienungBox.Checked := Arbeitsumgebung.MenueTastenbedienung;
    OptionenEndelinksBox.Checked := Arbeitsumgebung.TasteEndelinks;
    OptionenEnderechtsBox.Checked := Arbeitsumgebung.TasteEnderechts;
    OptionenHauptfensterSchriftartEdit.Text := Arbeitsumgebung.HauptfensterSchriftart;
    OptionenHauptfensterSchriftgroesseEdit.Text := IntToStr(Arbeitsumgebung.HauptfensterSchriftgroesse);
    OptionenTastenfensterSchriftartEdit.Text := Arbeitsumgebung.TastenfensterSchriftart;
    OptionenTastenfensterSchriftgroesseEdit.Text := IntToStr(Arbeitsumgebung.TastenfensterSchriftgroesse);
    OptionenAnzeigefensterSchriftartEdit.Text := Arbeitsumgebung.AnzeigefensterSchriftart;
    OptionenAnzeigefensterSchriftgroesseEdit.Text := IntToStr(Arbeitsumgebung.AnzeigefensterSchriftgroesse);
    OptionenDialogeSchriftartEdit.Text := Arbeitsumgebung.DialogeSchriftart;
    OptionenDialogeSchriftgroesseEdit.Text := IntToStr(Arbeitsumgebung.DialogeSchriftgroesse);
    OptionenTastenFetteSchriftBox.Checked := Arbeitsumgebung.TastenFetteSchrift;
  // ------------ Verzeichnisse --------------------------------
    VideoAudioVerzeichnisEdit.Text := relativPathAppl(Arbeitsumgebung.VideoAudioVerzeichnis, Application.ExeName);
    OptionenVideoAudioVerzeichnisBox.Checked := Arbeitsumgebung.VideoAudioVerzeichnisspeichern;
    ZielVerzeichnisEdit.Text := relativPathAppl(Arbeitsumgebung.ZielVerzeichnis, Application.ExeName);
    OptionenZielVerzeichnisBox.Checked := Arbeitsumgebung.ZielVerzeichnisspeichern;
    ProjektVerzeichnisEdit.Text := relativPathAppl(Arbeitsumgebung.ProjektVerzeichnis, Application.ExeName);
    OptionenProjektVerzeichnisBox.Checked := Arbeitsumgebung.ProjektVerzeichnisspeichern;
    KapitelVerzeichnisEdit.Text := relativPathAppl(Arbeitsumgebung.KapitelVerzeichnis, Application.ExeName);
    OptionenKapitelVerzeichnisBox.Checked := Arbeitsumgebung.KapitelVerzeichnisspeichern;
    VorschauVerzeichnisEdit.Text := relativPathAppl(Arbeitsumgebung.VorschauVerzeichnis, Application.ExeName);
    ZwischenVerzeichnisEdit.Text := relativPathAppl(Arbeitsumgebung.ZwischenVerzeichnis, Application.ExeName);
  // ------------ Dateinamen/Endungen --------------------------------
    ProjektdateinameEdit.Text := Arbeitsumgebung.Projektdateiname;
    OptionenProjektdateidialogunterdrueckenBox.Checked := Arbeitsumgebung.Projektdateidialogunterdruecken;
    ZielDateinameEdit.Text :=  Arbeitsumgebung.ZielDateiname;
    OptionenZieldateidialogunterdrueckenBox.Checked := Arbeitsumgebung.Zieldateidialogunterdruecken;
    KapiteldateinameEdit.Text := Arbeitsumgebung.Kapiteldateiname;
    ProjektdateieneinzelnFormatEdit.Text := Arbeitsumgebung.ProjektdateieneinzelnFormat;
    SchnittpunkteeinzelnFormatEdit.Text := Arbeitsumgebung.SchnittpunkteeinzelnFormat;
    DateiendungenVideoEdit.Text := Arbeitsumgebung.DateiendungenVideo;
    StandardEndungenVideoEdit.Text := Arbeitsumgebung.StandardEndungenVideo;
    DateiendungenAudioEdit.Text := Arbeitsumgebung.DateiendungenAudio;
    StandardEndungenAudioEdit.Text := Arbeitsumgebung.StandardEndungenAudio;
    StandardEndungenPCMEdit.Text := Arbeitsumgebung.StandardEndungenPCM;
    StandardEndungenMP2Edit.Text := Arbeitsumgebung.StandardEndungenMP2;
    StandardEndungenAC3Edit.Text := Arbeitsumgebung.StandardEndungenAC3;
    AudioTrennzeichenEdit.Text := Arbeitsumgebung.AudioTrennzeichen;
    DateiendungenKapitelEdit.Text := Arbeitsumgebung.DateiendungenKapitel;
    StandardEndungenKapitelEdit.Text := Arbeitsumgebung.StandardEndungenKapitel;
    OptionenStandardEndungenverwendenBox.Checked := Arbeitsumgebung.StandardEndungenverwenden;
  // ------------ Anzeige/Wiedergabe -----------------------
    OptionenVideograudarstellenBox.Checked := Arbeitsumgebung.Videograudarstellen;
    OptionenkeinVideoBox.Checked := Arbeitsumgebung.keinVideo;
    OptionenHauptfensteranpassenBox.Checked := Arbeitsumgebung.Hauptfensteranpassen;
    OptionenVideoanzeigegroesseBox.Checked := Arbeitsumgebung.Videoanzeigegroesse;
    OptionenVideohintergrundColorBox.Selected := Arbeitsumgebung.Videohintergrundfarbe;
    OptionenVideohintergrundaktColorBox.Selected := Arbeitsumgebung.Videohintergrundfarbeakt;
    OptionenletztesVideoanzeigenBox.Checked := Arbeitsumgebung.letztesVideoanzeigen;
    OptionenTempo1beiPauseBox.Checked := Arbeitsumgebung.Tempo1beiPause;
    OptionenAudioFehleranzeigenBox.Checked := Arbeitsumgebung.AudioFehleranzeigen;
    OptionenkeinAudioRadio.Checked := Arbeitsumgebung.keinAudio;
    OptionenMCIPlayerRadio.Checked := Arbeitsumgebung.MCIPlayer;
    OptionenDSPlayerRadio.Checked := Arbeitsumgebung.DSPlayer;
    AudioGraphNameEdit.Text := relativPathAppl(Arbeitsumgebung.AudioGraphName, Application.ExeName);
  // ------------ Video- und Audioschnitt -------------
    OptionenIndexDateierstellenBox.Checked := Arbeitsumgebung.IndexDateierstellen;
    OptionenKapiteldateierstellenBox.Checked := Arbeitsumgebung.Kapiteldateierstellen;
    OptionenMuxenBox.Checked := Arbeitsumgebung.Ausgabebenutzen;
    OptionenSpeicherplatzpruefenBox.Checked := Arbeitsumgebung.Speicherplatzpruefen;
    OptionenFramegenauschneidenBox.Checked := Arbeitsumgebung.Framegenauschneiden;
    OptionenTimecodekorrigierenBox.Checked := Arbeitsumgebung.Timecodekorrigieren;
    OptionenBitratekorrigierenBox.Checked := Arbeitsumgebung.Bitratekorrigieren;
    BitrateersterHeaderComboBox.ItemIndex := Arbeitsumgebung.BitrateersterHeader;
    IF Arbeitsumgebung.BitrateersterHeader = 4 THEN
    BEGIN
      BitrateersterHeaderComboBox.Style := csDropDown;
      BitrateersterHeaderComboBox.Text := BitrateersterHeaderComboBox.Items[4] + ': ' + IntToStr(Arbeitsumgebung.festeBitrate);
    END;
    AspectratioersterHeaderComboBox.ItemIndex := Arbeitsumgebung.AspectratioersterHeader;
    IF Arbeitsumgebung.AspectratioersterHeader = 6 THEN
    BEGIN
      AspectratioersterHeaderComboBox.Style := csDropDown;
      AspectratioersterHeaderComboBox.Text := AspectratioersterHeaderComboBox.Items[6] + ': ' + IntToStr(Arbeitsumgebung.AspectratioOffset);
    END;
    OptionenMaxGOPLaengeBox.Checked := Arbeitsumgebung.maxGOPLaengeverwenden;
    MaxGOPLaengeEdit.Enabled := OptionenMaxGOPLaengeBox.Checked;
    MaxGOPLaengeEdit.Text := IntToStr(Arbeitsumgebung.maxGOPLaenge);
    OptionenD2VDateierstellenBox.Checked := Arbeitsumgebung.D2VDateierstellen;
    OptionenIDXDateierstellenBox.Checked := Arbeitsumgebung.IDXDateierstellen;
    OptionenZusammenhaengendeSchnitteberechnenBox.Checked := Arbeitsumgebung.ZusammenhaengendeSchnitteberechnen;
    minBilderAnfangEdit.Text := IntToStr(Arbeitsumgebung.minAnfang);
    minBilderEndeEdit.Text := IntToStr(Arbeitsumgebung.minEnde);
    AudioframesMpegComboBox.Items.Clear;
    FOR I := 0 TO Arbeitsumgebung.leereAudioframesMpegliste.Count - 1 DO
      AudioframesMpegComboBox.Items.Add(relativPathAppl(Arbeitsumgebung.leereAudioframesMpegliste.Strings[I], Application.ExeName));
    AudioframesAC3ComboBox.Items.Clear;
    FOR I := 0 TO Arbeitsumgebung.leereAudioframesAC3liste.Count - 1 DO
      AudioframesAC3ComboBox.Items.Add(relativPathAppl(Arbeitsumgebung.leereAudioframesAC3liste.Strings[I], Application.ExeName));
    AudioframesPCMComboBox.Items.Clear;
    FOR I := 0 TO Arbeitsumgebung.leereAudioframesPCMliste.Count - 1 DO
      AudioframesPCMComboBox.Items.Add(relativPathAppl(Arbeitsumgebung.leereAudioframesPCMliste.Strings[I], Application.ExeName));
  // ------------ Schnittliste -------------
    SchnittpunktTrennzeichenEdit.Text := Arbeitsumgebung.SchnittpunktTrennzeichen;
    SchnittFormatEdit.Text := Arbeitsumgebung.SchnittpunktFormat;
    SchnittBildbreiteSpinEdit.Value := Arbeitsumgebung.SchnittpunktBildbreite;
    OptionenSchnittBildAnfangBox.Checked := Arbeitsumgebung.SchnittpunktAnfangbild;
    OptionenSchnittBildEndeBox.Checked := Arbeitsumgebung.SchnittpunktEndebild;
    SchnittFormatberechnenColorBox.Selected := Arbeitsumgebung.SchnittpunktberechnenFarbe;
    SchnittFormatnichtberechnenColorBox.Selected := Arbeitsumgebung.SchnittpunktnichtberechnenFarbe;
    SchnittFormatEinfuegenComboBox.ItemIndex := Arbeitsumgebung.Schnittpunkteinfuegen;
  // ------------ Kapitelliste -------------
    OptionenSchnittlistenFormatuebernehmenBox.Checked := Arbeitsumgebung.SchnittlistenFormatuebernehmen;
    KapitelFormatEdit.Text := Arbeitsumgebung.KapitelFormat;
    KapitelTrennzeileEdit1.Text := Arbeitsumgebung.KapitelTrennzeile1;
    KapitelTrennzeileEdit2.Text := Arbeitsumgebung.KapitelTrennzeile2;
    KapitelTrennzeileEdit3.Text := Arbeitsumgebung.KapitelTrennzeile3;
    KapitelTrennzeileEdit4.Text := Arbeitsumgebung.KapitelTrennzeile4;
    KapitellistenFarbeVGColorBox.Selected := Arbeitsumgebung.KapitellistenVGFarbe;
    KapitellistenFarbeHGColorBox.Selected := Arbeitsumgebung.KapitellistenHGFarbe;
    KapitellistenMarkierungFarbeVGColorBox.Selected :=   Arbeitsumgebung.KapitellistenMarkierungVGFarbe;
    KapitellistenMarkierungFarbeHGColorBox.Selected :=   Arbeitsumgebung.KapitellistenMarkierungHGFarbe;
    KapitellistenVerschiebeFarbeVGColorBox.Selected := Arbeitsumgebung.KapitellistenVerschiebeVGFarbe;
    KapitellistenVerschiebeFarbeHGColorBox.Selected := Arbeitsumgebung.KapitellistenVerschiebeHGFarbe;
    KapitelFormatEinfuegenComboBox.ItemIndex := Arbeitsumgebung.Kapiteleinfuegen;
  // ------------ Markentliste -------------
    MarkenFormatEdit.Text := Arbeitsumgebung.MarkenFormat;
    OptionenMarkenlistebearbeitenBox.Checked := Arbeitsumgebung.Markenlistebearbeiten;
    MarkenFormatEinfuegenComboBox.ItemIndex := Arbeitsumgebung.Markeneinfuegen;
  // ------------ Listenimport -------------
    SchnittImportTrennzeichenCombobox.Items.Assign(Arbeitsumgebung.SchnittImportTrennzeichenliste);
    SchnittImportZeitTrennzeichenCombobox.Items.Assign(Arbeitsumgebung.SchnittImportZeitTrennzeichenliste);
    KapitelImportTrennzeichenCombobox.Items.Assign(Arbeitsumgebung.KapitelImportTrennzeichenliste);
    KapitelImportZeitTrennzeichenCombobox.Items.Assign(Arbeitsumgebung.KapitelImportZeitTrennzeichenliste);
    MarkenImportTrennzeichenCombobox.Items.Assign(Arbeitsumgebung.MarkenImportTrennzeichenliste);
    MarkenImportZeitTrennzeichenCombobox.Items.Assign(Arbeitsumgebung.MarkenImportZeitTrennzeichenliste);
    OptionenSchnittlistenimportuebernehmenBox1.Checked := Arbeitsumgebung.SchnittlistenimportFormatuebernehmen1;
    OptionenSchnittlistenimportuebernehmenBox2.Checked := Arbeitsumgebung.SchnittlistenimportFormatuebernehmen2;
  // ------------ Listenexport -------------
    SchnittexportOffsetEdit.Text := IntToStr(Arbeitsumgebung.SchnittExportOffset);
    SchnittexportFormatEdit.Text := Arbeitsumgebung.SchnittExportFormat;
    KapitelexportOffsetEdit.Text := IntToStr(Arbeitsumgebung.KapitelExportOffset);
    KapitelexportFormatEdit.Text := Arbeitsumgebung.KapitelExportFormat;
    MarkenexportOffsetEdit.Text := IntToStr(Arbeitsumgebung.MarkenExportOffset);
    MarkenexportFormatEdit.Text := Arbeitsumgebung.MarkenExportFormat;
    OptionenSchnittlistenexportuebernehmenBox1.Checked := Arbeitsumgebung.SchnittlistenexportFormatuebernehmen1;
    OptionenSchnittlistenexportuebernehmenBox2.Checked := Arbeitsumgebung.SchnittlistenexportFormatuebernehmen2;
  // ------------ Tastenbelegung ---------------------------
    FOR I := Low(Arbeitsumgebung.Tasten) + 1 TO High(Arbeitsumgebung.Tasten) DO
    BEGIN
      TastenbelegungGrid.Cells[1, I] := TastenNummerZuName(Arbeitsumgebung.Tasten[I]);
      TastenbelegungArray[I] := Arbeitsumgebung.Tasten[I];
    END;
    OptionenInfofensterTastenCheckBox.Checked := Arbeitsumgebung.InfofensterTasten;
    OptionenSchnittlisteTastenCheckBox.Checked := Arbeitsumgebung.SchnittlisteTasten;
    OptionenKapitellisteTastenCheckBox.Checked := Arbeitsumgebung.KapitellisteTasten;
    OptionenMarkenlisteTastenCheckBox.Checked := Arbeitsumgebung.MarkenlisteTasten;
    OptionenDateienfensterTastenCheckBox.Checked := Arbeitsumgebung.DateienfensterTasten;
    Schrittweite1Edit.Text := IntToStr(Arbeitsumgebung.Schrittweite1);
    Schrittweite2Edit.Text := IntToStr(Arbeitsumgebung.Schrittweite2);
    Schrittweite3Edit.Text := IntToStr(Arbeitsumgebung.Schrittweite3);
    Schrittweite4Edit.Text := IntToStr(Arbeitsumgebung.Schrittweite4);
  // ------------ Navigation -------------
    AbspielzeitEdit.Text := IntToStr(Arbeitsumgebung.Abspielzeit);
    OptionenScrollradBox.Checked := Arbeitsumgebung.Scrollrad = 1;
    OptionenVAextraBox.Checked := Arbeitsumgebung.VAextra;
    OptionenOutSchnittanzeigenBox.Checked := Arbeitsumgebung.OutSchnittanzeigen;
    OptionenKlickBox.Checked := Arbeitsumgebung.KlickStartStop;
    OptionenDoppelKlickBox.Checked := Arbeitsumgebung.DoppelklickMaximieren;
    OptionenVideoeigenschaftenaktBox.Checked := Arbeitsumgebung.Videoeigenschaftenaktualisieren;
    OptionenAudioeigenschaftenaktBox.Checked := Arbeitsumgebung.Audioeigenschaftenaktualisieren;
  // ------------ Vorschau --------------------
    VorschauDauer1Edit.Text := IntToStr(Arbeitsumgebung.Vorschaudauer1);
    VorschauDauer2Edit.Text := IntToStr(Arbeitsumgebung.Vorschaudauer2);
    OptionenVorschaudauererweiternBox.Checked := Arbeitsumgebung.Vorschauerweitern;
    VorschauDauerPlusEdit.Text := IntToStr(Arbeitsumgebung.VorschaudauerPlus);
    OptionenVorschauneuberechnenBox.Checked := Arbeitsumgebung.VorschauImmerberechnen;
    OptionenVorschaudateienloeschenBox.Checked := Arbeitsumgebung.Vorschaudateienloeschen;
  // ------------ Ein-/Ausgabeprogramme --------------------
    DemuxerDateiEdit.Text := relativPathAppl(Arbeitsumgebung.Demuxerdatei, Application.ExeName);
    EncoderDateiEdit.Text := relativPathAppl(Arbeitsumgebung.Encoderdatei, Application.ExeName);
    AusgabedateiEdit.Text := relativPathAppl(Arbeitsumgebung.Ausgabedatei, Application.ExeName);
//    AusgabeListeneinlesen(Arbeitsumgebung);
  // ------------ Effekte --------------------
    VideoEffektverzEdit.Text := relativPathAppl(Arbeitsumgebung.VideoEffektverzeichnis, Application.ExeName);
    AudioEffektverzEdit.Text := relativPathAppl(Arbeitsumgebung.AudioEffektverzeichnis, Application.ExeName);
    EffektvorgabedateiEdit.Text := relativPathAppl(Arbeitsumgebung.Effektvorgabedatei, Application.ExeName);
    EffektListeneinlesen(Arbeitsumgebung);
    EffektvorgabeListeneinlesen(Arbeitsumgebung);
    OptionenVorgabeeffekteverwendenBox.Checked := Arbeitsumgebung.Vorgabeeffekteverwenden;
  // ------------ Grobansicht --------------------
    OptionenSchrittweiteSpinEdit.Value := Arbeitsumgebung.GrobansichtSchritt;
    OptionenBildbreiteSpinEdit.Value := Arbeitsumgebung.GrobansichtBildweite;
    OptionenAktivfarbeColorBox.Selected := Arbeitsumgebung.GrobansichtFarbeAktiv;
    OptionenWerbefarbeColorBox.Selected := Arbeitsumgebung.GrobansichtFarbeWerbung;
    OptionenFilmfarbeColorBox.Selected := Arbeitsumgebung.GrobansichtFarbeFilm;
  END;
END;

FUNCTION TOptionenfenster.Eingabenpruefen: Integer;
BEGIN
  Result := 0;
  TRY
    StrToFloat(festeFramerateEdit.Text);
  EXCEPT
    ON EConvertError DO
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenAllgemeinSeiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung16', 'Der eingegebene Wert ist keine Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung16', 'Der eingegebene Wert ist keine Zahl.'));
      Result := -1;
    END;
  END;
  IF Result = 0 THEN
    IF StrToIntDef(HinweisanzeigedauerEdit.Text, -1) < 0 THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenAllgemeinSeiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'));
      Result := -2;
    END;
  IF Result = 0 THEN
    IF StrToIntDef(BeendenanzeigedauerEdit.Text, -1) < 0 THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenAllgemeinSeiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'));
      Result := -2;
    END;
  IF Result = 0 THEN
    IF StrToIntDef(OptionenDateienfensterhoeheEdit.Text, -1) < 0 THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenAllgemeinSeiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'));
      Result := -6;
    END;
  IF Result = 0 THEN
    IF StrToIntDef(OptionenListenfensterBreiteEdit.Text, -1) < 0 THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenAllgemeinSeiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'));
      Result := -6;
    END;
  IF Result = 0 THEN
    IF (BitrateersterHeaderComboBox.ItemIndex = -1) AND
       (StrToIntDef(KopiereVonBis(BitrateersterHeaderComboBox.Text,': ',''), -1) < 0) AND
       (StrToIntDef(BitrateersterHeaderComboBox.Text, -1) < 0) THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenVideoAudioSchnittseiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'));
      Result := -3;
    END;
  IF Result = 0 THEN
  BEGIN
    IF (AspectratioersterHeaderComboBox.ItemIndex = -1) AND
       (StrToIntDef(KopiereVonBis(AspectratioersterHeaderComboBox.Text,': ',''), -1) < 0) AND
       (StrToIntDef(AspectratioersterHeaderComboBox.Text, -1) < 0) THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenVideoAudioSchnittseiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'));
      Result := -10;
    END;
  END;
  IF Result = 0 THEN
    IF StrToIntDef(MaxGOPLaengeEdit.Text, -1) < 0 THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenVideoAudioSchnittseiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
      Result := -7;
    END;
  IF Result = 0 THEN
    IF StrToIntDef(minBilderAnfangEdit.Text, -1) < 0 THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenVideoAudioSchnittseiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
      Result := -8;
    END;
  IF Result = 0 THEN
    IF StrToIntDef(minBilderEndeEdit.Text, -1) < 0 THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenVideoAudioSchnittseiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
      Result := -9;
    END;
  IF Result = 0 THEN
    IF (StrToIntDef(Schrittweite1Edit.Text, -1) < 0) OR
       (StrToIntDef(Schrittweite2Edit.Text, -1) < 0) OR
       (StrToIntDef(Schrittweite3Edit.Text, -1) < 0) OR
       (StrToIntDef(Schrittweite4Edit.Text, -1) < 0) THEN
    BEGIN
      OptionenSeiten.ActivePageIndex := OptionenTastenbelegungseiteTab.PageIndex;
      Meldungsfenster(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'),
                      Wortlesen(NIL, 'Hinweis', 'Hinweis'));
//      ShowMessage(Wortlesen(NIL, 'Meldung17', 'Der eingegebene Wert ist keine ganze Zahl.'));
      Result := -4;
    END;
END;

FUNCTION TOptionenfenster.Arbeitsumgebungschreiben(Arbeitsumgebung: TArbeitsumgebung): Integer;

VAR I : Integer;
    Hinteger : Integer;
    HReal : Real;

BEGIN
  IF Assigned(Arbeitsumgebung) THEN
  BEGIN
    Result := 0;
  // ------------ Allgemein --------------------------------
    Arbeitsumgebung.Indexdateienloeschen := OptionenIndexdateienloeschenBox.Checked;
    IF Arbeitsumgebung.Protokollerstellen <> OptionenProtokollerstellenBox.Checked THEN
      Arbeitsumgebung.Protokollstartende := True
    ELSE
      Arbeitsumgebung.Protokollstartende := False;
    Arbeitsumgebung.Protokollerstellen := OptionenProtokollerstellenBox.Checked;
    TRY
      HReal := StrToFloat(festeFramerateEdit.Text);
    EXCEPT
      ON EConvertError DO
      BEGIN
        HReal := Arbeitsumgebung.festeFramerate;
        Result := -1;
      END;
    END;
    IF (Arbeitsumgebung.festeFramerateverwenden <> OptionenfesteFramerateverwendenBox.Checked) OR
       (Arbeitsumgebung.festeFramerate <> HReal) THEN
      Arbeitsumgebung.festeframerateverwendengeaendert := True
    ELSE
      Arbeitsumgebung.festeframerateverwendengeaendert := False;
    Arbeitsumgebung.festeFramerate := HReal;
    Arbeitsumgebung.festeFramerateverwenden := OptionenfesteFramerateverwendenBox.Checked;
    Arbeitsumgebung.SequenzEndeignorieren := OptionenSequenzEndeignorierenBox.Checked;
    Arbeitsumgebung.nachSchneidenbeenden := OptionennachSchneidenbeendenBox.Checked;
    Arbeitsumgebung.SchiebereglerPosbeibehalten := OptionenSchiebereglerPosbeibehaltenBox.Checked;
    Hinteger := StrToIntDef(HinweisanzeigedauerEdit.Text, -1);
    IF Hinteger < 0 THEN
      Result := -2
    ELSE
      Arbeitsumgebung.Hinweisanzeigedauer := HInteger;
    Hinteger := StrToIntDef(BeendenanzeigedauerEdit.Text, -1);
    IF Hinteger < 0 THEN
      Result := -2
    ELSE
      Arbeitsumgebung.Beendenanzeigedauer := HInteger;
  // ------------ Projekt -----------------------------------
    Arbeitsumgebung.Dateilistegeaendert := OptionenProjektDateilisteBox.Checked;
    Arbeitsumgebung.Schnittlistegeaendert := OptionenProjektSchnittlisteBox.Checked;
    Arbeitsumgebung.Kapitellistegeaendert := OptionenProjektKapitellisteBox.Checked;
    Arbeitsumgebung.Markenlistegeaendert := OptionenProjektMarkenlisteBox.Checked;
    Arbeitsumgebung.Effektgeaendert := OptionenProjektEffektBox.Checked;
    Arbeitsumgebung.Schneidensetztzurueck := OptionenProjektSchneidenBox.Checked;
  // ------------ Oberfläche --------------------------------
    Hinteger := StrToIntDef(OptionenDateienfensterhoeheEdit.Text, -1);
    IF Hinteger < 0 THEN
      Result := -6
    ELSE
      Arbeitsumgebung.DateienfensterHoehe := HInteger;
    Hinteger := StrToIntDef(OptionenListenfensterBreiteEdit.Text, -1);
    IF Hinteger < 0 THEN
      Result := -6
    ELSE
      Arbeitsumgebung.ListenfensterBreite := HInteger;
    Arbeitsumgebung.ListenfensterLinks := OptionenListenfensterLinksBox.Checked;
    Arbeitsumgebung.DateienimListenfenster := OptionenDateienimListenfensterBox.Checked;
    IF OptionenkeineSymboleRadioButton.Checked THEN
      Arbeitsumgebung.Bilderverwenden := 0
    ELSE
      IF OptionenSymboldateiRadioButton.Checked THEN
        Arbeitsumgebung.Bilderverwenden := 2
      ELSE
        Arbeitsumgebung.Bilderverwenden := 1;
    IF Arbeitsumgebung.Bilderdatei <> absolutPathAppl(BilderdateiEdit.Text, Application.ExeName, False) THEN
      Arbeitsumgebung.Bilderdateigeaendert := True;
    Arbeitsumgebung.Bilderdatei := absolutPathAppl(BilderdateiEdit.Text, Application.ExeName, False);
    Arbeitsumgebung.SchiebereglerMarkeranzeigen := OptionenSchiebereglerMarkeranzeigenBox.Checked;
    Arbeitsumgebung.Tastenfensterzentrieren := OptionenTastenfensterzentrierenBox.Checked;
    Arbeitsumgebung.MenueTastenbedienung := OptionenMenueTastenbedienungBox.Checked;
    Arbeitsumgebung.TasteEndelinks := OptionenEndelinksBox.Checked;
    Arbeitsumgebung.TasteEnderechts := OptionenEnderechtsBox.Checked;
    Arbeitsumgebung.HauptfensterSchriftart := OptionenHauptfensterSchriftartEdit.Text;
    Arbeitsumgebung.HauptfensterSchriftgroesse := StrToInt(OptionenHauptfensterSchriftgroesseEdit.Text);
    Arbeitsumgebung.TastenfensterSchriftart := OptionenTastenfensterSchriftartEdit.Text;
    Arbeitsumgebung.TastenfensterSchriftgroesse := StrToInt(OptionenTastenfensterSchriftgroesseEdit.Text);
    Arbeitsumgebung.AnzeigefensterSchriftart := OptionenAnzeigefensterSchriftartEdit.Text;
    Arbeitsumgebung.AnzeigefensterSchriftgroesse := StrToInt(OptionenAnzeigefensterSchriftgroesseEdit.Text);
    Arbeitsumgebung.DialogeSchriftart := OptionenDialogeSchriftartEdit.Text;
    Arbeitsumgebung.DialogeSchriftgroesse := StrToInt(OptionenDialogeSchriftgroesseEdit.Text);
    Arbeitsumgebung.TastenFetteSchrift := OptionenTastenFetteSchriftBox.Checked;
  // ------------ Verzeichnisse --------------------------------
    Arbeitsumgebung.VideoAudioVerzeichnis := mitPathtrennzeichen(absolutPathAppl(VideoAudioVerzeichnisEdit.Text, Application.ExeName, False));
    Arbeitsumgebung.VideoAudioVerzeichnisspeichern := OptionenVideoAudioVerzeichnisBox.Checked;
    Arbeitsumgebung.ZielVerzeichnis := mitPathtrennzeichen(absolutPathAppl(ZielVerzeichnisEdit.Text, Application.ExeName, False));
    Arbeitsumgebung.ZielVerzeichnisspeichern := OptionenZielVerzeichnisBox.Checked;
    Arbeitsumgebung.ProjektVerzeichnis := mitPathtrennzeichen(absolutPathAppl(ProjektVerzeichnisEdit.Text, Application.ExeName, True));
    Arbeitsumgebung.ProjektVerzeichnisspeichern := OptionenProjektVerzeichnisBox.Checked;
    Arbeitsumgebung.KapitelVerzeichnis := mitPathtrennzeichen(absolutPathAppl(KapitelVerzeichnisEdit.Text, Application.ExeName, False));
    Arbeitsumgebung.KapitelVerzeichnisspeichern := OptionenKapitelVerzeichnisBox.Checked;
    Arbeitsumgebung.VorschauVerzeichnis := mitPathtrennzeichen(absolutPathAppl(VorschauVerzeichnisEdit.Text, Application.ExeName, True));
    Arbeitsumgebung.ZwischenVerzeichnis := mitPathtrennzeichen(absolutPathAppl(ZwischenVerzeichnisEdit.Text, Application.ExeName, True));
  // ------------ Dateinamen/Endungen --------------------------------
    Arbeitsumgebung.Projektdateiname := ProjektdateinameEdit.Text;
    Arbeitsumgebung.Projektdateidialogunterdruecken := OptionenProjektdateidialogunterdrueckenBox.Checked;
    Arbeitsumgebung.ZielDateiname :=  ZielDateinameEdit.Text;
    Arbeitsumgebung.Zieldateidialogunterdruecken := OptionenZieldateidialogunterdrueckenBox.Checked;
    Arbeitsumgebung.Kapiteldateiname := KapiteldateinameEdit.Text;
    Arbeitsumgebung.ProjektdateieneinzelnFormat := ProjektdateieneinzelnFormatEdit.Text;
    Arbeitsumgebung.SchnittpunkteeinzelnFormat := SchnittpunkteeinzelnFormatEdit.Text;
    Arbeitsumgebung.DateiendungenVideo := DateiendungenVideoEdit.Text;
    Arbeitsumgebung.StandardEndungenVideo := StandardEndungenVideoEdit.Text;
    Arbeitsumgebung.DateiendungenAudio := DateiendungenAudioEdit.Text;
    Arbeitsumgebung.StandardEndungenAudio := StandardEndungenAudioEdit.Text;
    Arbeitsumgebung.StandardEndungenPCM := StandardEndungenPCMEdit.Text;
    Arbeitsumgebung.StandardEndungenMP2 := StandardEndungenMP2Edit.Text;
    Arbeitsumgebung.StandardEndungenAC3 := StandardEndungenAC3Edit.Text;
    Arbeitsumgebung.AudioTrennzeichen := AudioTrennzeichenEdit.Text;
    Arbeitsumgebung.DateiendungenKapitel := DateiendungenKapitelEdit.Text;
    Arbeitsumgebung.StandardEndungenKapitel := StandardEndungenKapitelEdit.Text;
    Arbeitsumgebung.StandardEndungenverwenden := OptionenStandardEndungenverwendenBox.Checked;
  // ------------ Anzeige/Wiedergabe -----------------------
    Arbeitsumgebung.Videograudarstellen := OptionenVideograudarstellenBox.Checked;
    Arbeitsumgebung.keinVideo := OptionenkeinVideoBox.Checked;
    Arbeitsumgebung.Hauptfensteranpassen := OptionenHauptfensteranpassenBox.Checked;
    Arbeitsumgebung.Videoanzeigegroesse := OptionenVideoanzeigegroesseBox.Checked;
    Arbeitsumgebung.Videohintergrundfarbe := OptionenVideohintergrundColorBox.Selected;
    Arbeitsumgebung.Videohintergrundfarbeakt := OptionenVideohintergrundaktColorBox.Selected;
    Arbeitsumgebung.letztesVideoanzeigen := OptionenletztesVideoanzeigenBox.Checked;
    Arbeitsumgebung.Tempo1beiPause := OptionenTempo1beiPauseBox.Checked;
    Arbeitsumgebung.AudioFehleranzeigen := OptionenAudioFehleranzeigenBox.Checked;
    Arbeitsumgebung.keinAudio := OptionenkeinAudioRadio.Checked;
    Arbeitsumgebung.MCIPlayer := OptionenMCIPlayerRadio.Checked;
    Arbeitsumgebung.DSPlayer := OptionenDSPlayerRadio.Checked;
    Arbeitsumgebung.AudioGraphName := absolutPathAppl(AudioGraphNameEdit.Text, Application.ExeName, False);
  // ------------ Video- und Audioschnitt -------------
    Arbeitsumgebung.IndexDateierstellen := OptionenIndexDateierstellenBox.Checked;
    Arbeitsumgebung.Kapiteldateierstellen := OptionenKapiteldateierstellenBox.Checked;
    Arbeitsumgebung.Ausgabebenutzen := OptionenMuxenBox.Checked;
    Arbeitsumgebung.Speicherplatzpruefen := OptionenSpeicherplatzpruefenBox.Checked;
    Arbeitsumgebung.Framegenauschneiden := OptionenFramegenauschneidenBox.Checked;
    Arbeitsumgebung.Timecodekorrigieren := OptionenTimecodekorrigierenBox.Checked;
    Arbeitsumgebung.Bitratekorrigieren := OptionenBitratekorrigierenBox.Checked;
    IF (BitrateersterHeaderComboBox.ItemIndex > -1) AND
       (BitrateersterHeaderComboBox.ItemIndex < 4) THEN
      Arbeitsumgebung.BitrateersterHeader := BitrateersterHeaderComboBox.ItemIndex
    ELSE
    BEGIN
      Hinteger := StrToIntDef(KopiereVonBis(BitrateersterHeaderComboBox.Text,': ',''), -1);
      IF Hinteger < 0 THEN
        Hinteger := StrToIntDef(BitrateersterHeaderComboBox.Text, -1);
      IF Hinteger < 0 THEN
        Result := -3
      ELSE
      BEGIN
        Arbeitsumgebung.festeBitrate := Hinteger;
        Arbeitsumgebung.BitrateersterHeader := 4;
      END;
    END;
    IF (AspectratioersterHeaderComboBox.ItemIndex > -1) AND
       (AspectratioersterHeaderComboBox.ItemIndex < 6) THEN
      Arbeitsumgebung.AspectratioersterHeader := AspectratioersterHeaderComboBox.ItemIndex
    ELSE
    BEGIN
      Hinteger := StrToIntDef(KopiereVonBis(AspectratioersterHeaderComboBox.Text,': ',''), -1);
      IF Hinteger < 0 THEN
        Hinteger := StrToIntDef(AspectratioersterHeaderComboBox.Text, -1);
      IF Hinteger < 0 THEN
        Result := -10
      ELSE
      BEGIN
        Arbeitsumgebung.AspectratioOffset := Hinteger;
        Arbeitsumgebung.AspectratioersterHeader := 6;
      END;
    END;
    Arbeitsumgebung.maxGOPLaengeverwenden := OptionenMaxGOPLaengeBox.Checked;
    Hinteger := StrToIntDef(MaxGOPLaengeEdit.Text, -1);
    IF Hinteger < 0 THEN
      Result := -7
    ELSE
      Arbeitsumgebung.maxGOPLaenge := Hinteger;
    Arbeitsumgebung.D2VDateierstellen := OptionenD2VDateierstellenBox.Checked;
    Arbeitsumgebung.IDXDateierstellen := OptionenIDXDateierstellenBox.Checked;
    Arbeitsumgebung.ZusammenhaengendeSchnitteberechnen := OptionenZusammenhaengendeSchnitteberechnenBox.Checked;
    Hinteger := StrToIntDef(minBilderAnfangEdit.Text, -1);
    IF Hinteger < 0 THEN
      Result := -8
    ELSE
      Arbeitsumgebung.minAnfang := Hinteger;
    Hinteger := StrToIntDef(minBilderEndeEdit.Text, -1);
    IF Hinteger < 0 THEN
      Result := -9
    ELSE
      Arbeitsumgebung.minEnde := Hinteger;
    Arbeitsumgebung.leereAudioframesMpegliste.Clear;
    FOR I := 0 TO AudioframesMpegComboBox.Items.Count - 1 DO
      Arbeitsumgebung.leereAudioframesMpegliste.Add(absolutPathAppl(AudioframesMpegComboBox.Items.Strings[I], Application.ExeName, False));
    Arbeitsumgebung.leereAudioframesAC3liste.Clear;
    FOR I := 0 TO AudioframesAC3ComboBox.Items.Count - 1 DO
      Arbeitsumgebung.leereAudioframesAC3liste.Add(absolutPathAppl(AudioframesAC3ComboBox.Items.Strings[I], Application.ExeName, False));
    Arbeitsumgebung.leereAudioframesPCMliste.Clear;
    FOR I := 0 TO AudioframesPCMComboBox.Items.Count - 1 DO
      Arbeitsumgebung.leereAudioframesPCMliste.Add(absolutPathAppl(AudioframesPCMComboBox.Items.Strings[I], Application.ExeName, False));
  // ------------ Schnittliste -------------
    Arbeitsumgebung.SchnittpunktTrennzeichen := SchnittpunktTrennzeichenEdit.Text;
    Arbeitsumgebung.SchnittpunktFormat := SchnittFormatEdit.Text;
    Arbeitsumgebung.SchnittpunktBildbreite := SchnittBildbreiteSpinEdit.Value;
    Arbeitsumgebung.SchnittpunktAnfangbild := OptionenSchnittBildAnfangBox.Checked;
    Arbeitsumgebung.SchnittpunktEndebild := OptionenSchnittBildEndeBox.Checked;
    Arbeitsumgebung.SchnittpunktberechnenFarbe := SchnittFormatberechnenColorBox.Selected;
    Arbeitsumgebung.SchnittpunktnichtberechnenFarbe := SchnittFormatnichtberechnenColorBox.Selected;
    Arbeitsumgebung.Schnittpunkteinfuegen := SchnittFormatEinfuegenComboBox.ItemIndex;
  // ------------ Kapitelliste -------------
    IF OptionenSchnittlistenFormatuebernehmenBox.Checked THEN
      Arbeitsumgebung.KapitelFormat := SchnittFormatEdit.Text
    ELSE
      Arbeitsumgebung.KapitelFormat := KapitelFormatEdit.Text;
    Arbeitsumgebung.SchnittlistenFormatuebernehmen := OptionenSchnittlistenFormatuebernehmenBox.Checked;
    Arbeitsumgebung.KapitelTrennzeile1 := KapitelTrennzeileEdit1.Text;
    Arbeitsumgebung.KapitelTrennzeile2 := KapitelTrennzeileEdit2.Text;
    Arbeitsumgebung.KapitelTrennzeile3 := KapitelTrennzeileEdit3.Text;
    Arbeitsumgebung.KapitelTrennzeile4 := KapitelTrennzeileEdit4.Text;
    Arbeitsumgebung.KapitellistenVGFarbe := KapitellistenFarbeVGColorBox.Selected;
    Arbeitsumgebung.KapitellistenHGFarbe := KapitellistenFarbeHGColorBox.Selected;
    Arbeitsumgebung.KapitellistenMarkierungVGFarbe := KapitellistenMarkierungFarbeVGColorBox.Selected;
    Arbeitsumgebung.KapitellistenMarkierungHGFarbe := KapitellistenMarkierungFarbeHGColorBox.Selected;
    Arbeitsumgebung.KapitellistenVerschiebeVGFarbe := KapitellistenVerschiebeFarbeVGColorBox.Selected;
    Arbeitsumgebung.KapitellistenVerschiebeHGFarbe := KapitellistenVerschiebeFarbeHGColorBox.Selected;
    Arbeitsumgebung.Kapiteleinfuegen := KapitelFormatEinfuegenComboBox.ItemIndex;
  // ------------ Markenliste -------------
    Arbeitsumgebung.MarkenFormat := MarkenFormatEdit.Text;
    Arbeitsumgebung.Markenlistebearbeiten := OptionenMarkenlistebearbeitenBox.Checked;
    Arbeitsumgebung.Markeneinfuegen := MarkenFormatEinfuegenComboBox.ItemIndex;
  // ------------ Listenimport -------------
    Arbeitsumgebung.SchnittImportTrennzeichenliste.Assign(SchnittImportTrennzeichenCombobox.Items);
    Arbeitsumgebung.SchnittImportZeitTrennzeichenliste.Assign(SchnittImportZeitTrennzeichenCombobox.Items);
    IF OptionenSchnittlistenimportuebernehmenBox1.Checked THEN
    BEGIN
      Arbeitsumgebung.KapitelImportTrennzeichenliste.Assign(SchnittImportTrennzeichenCombobox.Items);
      Arbeitsumgebung.KapitelImportZeitTrennzeichenliste.Assign(SchnittImportZeitTrennzeichenCombobox.Items);
    END
    ELSE
    BEGIN
      Arbeitsumgebung.KapitelImportTrennzeichenliste.Assign(KapitelImportTrennzeichenCombobox.Items);
      Arbeitsumgebung.KapitelImportZeitTrennzeichenliste.Assign(KapitelImportZeitTrennzeichenCombobox.Items);
    END;
    IF OptionenSchnittlistenimportuebernehmenBox2.Checked THEN
    BEGIN
      Arbeitsumgebung.MarkenImportTrennzeichenliste.Assign(SchnittImportTrennzeichenCombobox.Items);
      Arbeitsumgebung.MarkenImportZeitTrennzeichenliste.Assign(SchnittImportZeitTrennzeichenCombobox.Items);
    END
    ELSE
    BEGIN
      Arbeitsumgebung.MarkenImportTrennzeichenliste.Assign(MarkenImportTrennzeichenCombobox.Items);
      Arbeitsumgebung.MarkenImportZeitTrennzeichenliste.Assign(MarkenImportZeitTrennzeichenCombobox.Items);
    END;
    Arbeitsumgebung.SchnittlistenimportFormatuebernehmen1 := OptionenSchnittlistenimportuebernehmenBox1.Checked;
    Arbeitsumgebung.SchnittlistenimportFormatuebernehmen2 := OptionenSchnittlistenimportuebernehmenBox2.Checked;
  // ------------ Listenexport -------------
    Arbeitsumgebung.SchnittExportOffset := StrToIntDef(SchnittexportOffsetEdit.Text, -1);
    Arbeitsumgebung.SchnittExportFormat := SchnittexportFormatEdit.Text;
    IF OptionenSchnittlistenexportuebernehmenBox1.Checked THEN
    BEGIN
      Arbeitsumgebung.KapitelExportOffset := Arbeitsumgebung.SchnittExportOffset;
      Arbeitsumgebung.KapitelExportFormat := Arbeitsumgebung.SchnittExportFormat;
    END
    ELSE
    BEGIN
      Arbeitsumgebung.KapitelExportOffset := StrToIntDef(KapitelexportOffsetEdit.Text, -1);
      Arbeitsumgebung.KapitelExportFormat := KapitelexportFormatEdit.Text;
    END;
    IF OptionenSchnittlistenexportuebernehmenBox2.Checked THEN
    BEGIN
      Arbeitsumgebung.MarkenExportOffset := Arbeitsumgebung.SchnittExportOffset;
      Arbeitsumgebung.MarkenExportFormat := Arbeitsumgebung.SchnittExportFormat;
    END
    ELSE
    BEGIN
      Arbeitsumgebung.MarkenExportOffset := StrToIntDef(MarkenexportOffsetEdit.Text, -1);
      Arbeitsumgebung.MarkenExportFormat := MarkenexportFormatEdit.Text;
    END;
    Arbeitsumgebung.SchnittlistenexportFormatuebernehmen1 := OptionenSchnittlistenexportuebernehmenBox1.Checked;
    Arbeitsumgebung.SchnittlistenexportFormatuebernehmen2 := OptionenSchnittlistenexportuebernehmenBox2.Checked;
  // ------------ Tastenbelegung ---------------------------
    FOR I := Low(Arbeitsumgebung.Tasten) + 1 TO High(Arbeitsumgebung.Tasten) DO
      Arbeitsumgebung.Tasten[I] := TastenbelegungArray[I];
    Arbeitsumgebung.InfofensterTasten := OptionenInfofensterTastenCheckBox.Checked;
    Arbeitsumgebung.SchnittlisteTasten := OptionenSchnittlisteTastenCheckBox.Checked;
    Arbeitsumgebung.KapitellisteTasten := OptionenKapitellisteTastenCheckBox.Checked;
    Arbeitsumgebung.MarkenlisteTasten := OptionenMarkenlisteTastenCheckBox.Checked;
    Arbeitsumgebung.DateienfensterTasten := OptionenDateienfensterTastenCheckBox.Checked;
    IF (StrToIntDef(Schrittweite1Edit.Text, -1) < 0) OR
       (StrToIntDef(Schrittweite2Edit.Text, -1) < 0) OR
       (StrToIntDef(Schrittweite3Edit.Text, -1) < 0) OR
       (StrToIntDef(Schrittweite4Edit.Text, -1) < 0) THEN
      Hinteger := -1
    ELSE
      Hinteger := 0;
    IF Hinteger < 0 THEN
      Result := -4
    ELSE
    BEGIN
      Arbeitsumgebung.Schrittweite1 := StrToIntDef(Schrittweite1Edit.Text, 0);
      Arbeitsumgebung.Schrittweite2 := StrToIntDef(Schrittweite2Edit.Text, 0);
      Arbeitsumgebung.Schrittweite3 := StrToIntDef(Schrittweite3Edit.Text, 0);
      Arbeitsumgebung.Schrittweite4 := StrToIntDef(Schrittweite4Edit.Text, 0);
    END;
  // ------------ Navigation -------------
    Arbeitsumgebung.Abspielzeit := StrToIntDef(AbspielzeitEdit.Text, -1);
    IF OptionenScrollradBox.Checked THEN
      Arbeitsumgebung.Scrollrad := 1
    ELSE
      Arbeitsumgebung.Scrollrad := 0;
    Arbeitsumgebung.VAextra := OptionenVAextraBox.Checked;
    Arbeitsumgebung.OutSchnittanzeigen := OptionenOutSchnittanzeigenBox.Checked;
    Arbeitsumgebung.KlickStartStop := OptionenKlickBox.Checked;
    Arbeitsumgebung.DoppelklickMaximieren := OptionenDoppelKlickBox.Checked;
    Arbeitsumgebung.Videoeigenschaftenaktualisieren := OptionenVideoeigenschaftenaktBox.Checked;
    Arbeitsumgebung.Audioeigenschaftenaktualisieren := OptionenAudioeigenschaftenaktBox.Checked;
  // ------------ Vorschau --------------------
    Arbeitsumgebung.Vorschaudauer1 := StrToIntDef(VorschauDauer1Edit.Text, 5);
    Arbeitsumgebung.Vorschaudauer2 := StrToIntDef(VorschauDauer2Edit.Text, 5);
    Arbeitsumgebung.Vorschauerweitern := OptionenVorschaudauererweiternBox.Checked;
    Arbeitsumgebung.VorschaudauerPlus := StrToIntDef(VorschauDauerPlusEdit.Text, 1);
    Arbeitsumgebung.VorschauImmerberechnen := OptionenVorschauneuberechnenBox.Checked;
    Arbeitsumgebung.Vorschaudateienloeschen := OptionenVorschaudateienloeschenBox.Checked;
  // ------------ Ein-/Ausgabeprogramme --------------------
    Arbeitsumgebung.Demuxerdatei := absolutPathAppl(DemuxerDateiEdit.Text, Application.ExeName, False);
    Arbeitsumgebung.Encoderdatei := absolutPathAppl(EncoderDateiEdit.Text, Application.ExeName, False);
    Arbeitsumgebung.Ausgabedatei := absolutPathAppl(AusgabedateiEdit.Text, Application.ExeName, False);
  // ------------ Effekte --------------------
    Arbeitsumgebung.VideoEffektverzeichnis := absolutPathAppl(VideoEffektverzEdit.Text, Application.ExeName, True);
    Arbeitsumgebung.AudioEffektverzeichnis := absolutPathAppl(AudioEffektverzEdit.Text, Application.ExeName, True);
    Arbeitsumgebung.Effektvorgabedatei := absolutPathAppl(EffektvorgabedateiEdit.Text, Application.ExeName, False);
    Arbeitsumgebung.Vorgabeeffekteverwenden := OptionenVorgabeeffekteverwendenBox.Checked;
  // ------------ Grobansicht --------------------
    Arbeitsumgebung.GrobansichtSchritt := OptionenSchrittweiteSpinEdit.Value;
    Arbeitsumgebung.GrobansichtBildweite := OptionenBildbreiteSpinEdit.Value;
    Arbeitsumgebung.GrobansichtFarbeAktiv := OptionenAktivfarbeColorBox.Selected;
    Arbeitsumgebung.GrobansichtFarbeWerbung := OptionenWerbefarbeColorBox.Selected;
    Arbeitsumgebung.GrobansichtFarbeFilm := OptionenFilmfarbeColorBox.Selected;
  END
  ELSE
    Result := -5;  
END;

// ++++++++++++++++++Popupmenues+++++++++++++++++++++++++++

// ------------ ComboBox --------------------
procedure TOptionenfenster.ComboBoxMenuePopup(Sender: TObject);
begin
  IF Assigned(aktComboBox) THEN
  BEGIN
    IF Assigned(aktComboBoxDatenKopieren) THEN
    BEGIN
      Listeneintragkopieren.Visible := True;
      Listeneintrageinfuegen.Visible := True;
    END
    ELSE
    BEGIN
      Listeneintragkopieren.Visible := False;
      Listeneintrageinfuegen.Visible := False;
    END;
    IF Assigned(aktComboBoxDatenBearbeiten) THEN
      Listeneintragbearbeiten.Visible := True
    ELSE
      Listeneintragbearbeiten.Visible := False;
    IF (((aktComboBoxModus AND 1) = 1) AND (aktComboBox.Tag > 0)) OR
       (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.Tag > -1)) THEN
    BEGIN
      IF aktComboBox.ItemIndex = -1 THEN
      BEGIN
        Listeneintragkopieren.Enabled := False;
        Listeneintragloeschen.Enabled := False;
        Listeneintragaendern.Enabled := True;
        Listeneintragbearbeiten.Enabled := False;
        Listeneintrageinfuegen.Enabled := False;
      END
      ELSE
      BEGIN
        Listeneintragkopieren.Enabled := True;
        Listeneintragloeschen.Enabled := True;
        Listeneintragaendern.Enabled := False;
        IF ((aktComboBoxModus AND 8) = 0) OR
           Assigned(aktComboBox.Items.Objects[aktComboBox.ItemIndex]) THEN
          Listeneintragbearbeiten.Enabled := True
        ELSE
          Listeneintragbearbeiten.Enabled := False;
        IF Assigned(DatenZeigerComboBox) THEN
          Listeneintrageinfuegen.Enabled := True
        ELSE
          Listeneintrageinfuegen.Enabled := False;
      END;
    END
    ELSE
    BEGIN
      Listeneintragkopieren.Enabled := False;
      Listeneintragloeschen.Enabled := False;
      Listeneintragaendern.Enabled := False;
      Listeneintragbearbeiten.Enabled := False;
      IF Assigned(DatenZeigerComboBox) THEN
        Listeneintrageinfuegen.Enabled := True
      ELSE
        Listeneintrageinfuegen.Enabled := False;
    END;
    IF Clipboard.HasFormat(CF_TEXT) THEN
      ComboBoxEinfuegenClipboard.Enabled := True
    ELSE
      ComboBoxEinfuegenClipboard.Enabled := False;
    IF aktComboBox.SelLength > 0 THEN
    BEGIN
      ComboBoxAusschneidenClipboard.Enabled := True;
      ComboBoxKopierenClipboard.Enabled := True;
      ComboBoxLoeschenClipboard.Enabled := True;
    END
    ELSE
    BEGIN
      ComboBoxAusschneidenClipboard.Enabled := False;
      ComboBoxKopierenClipboard.Enabled := False;
      ComboBoxLoeschenClipboard.Enabled := False;
    END;
    IF (aktComboBoxModus AND 2) = 2 THEN
      ListeneintragDateisuchen.Visible := True
    ELSE
      ListeneintragDateisuchen.Visible := False;
  END
  ELSE
  BEGIN
    Listeneintragloeschen.Enabled := False;
    Listeneintragneu.Enabled := False;
    Listeneintragaendern.Enabled := False;
    ComboBoxEinfuegenClipboard.Enabled := False;
    ComboBoxAusschneidenClipboard.Enabled := False;
    ComboBoxKopierenClipboard.Enabled := False;
    ComboBoxLoeschenClipboard.Enabled := False;
    ListeneintragDateisuchen.Visible := False;
  END;
end;

FUNCTION TOptionenfenster.Listeneintrag_Neu(Eintragstext: STRING): Integer;
BEGIN
  IF (aktComboBoxModus AND 4) = 4 THEN
  BEGIN
    IF (((aktComboBoxModus AND 1) = 1) AND (aktComboBox.Tag > 0)) OR
       (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.Tag > -1)) THEN
      aktComboBox.Items.Insert(aktComboBox.Tag, Eintragstext)
    ELSE
    BEGIN
      aktComboBox.Items.Add(Eintragstext);
      aktComboBox.Tag := aktComboBox.Items.Count - 1;
    END;
    Result := aktComboBox.Tag;
  END
  ELSE
  BEGIN
    IF (((aktComboBoxModus AND 1) = 1) AND (aktComboBox.Tag > 0)) OR
       (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.Tag > -1)) THEN
    BEGIN
      aktComboBox.Items.Insert(aktComboBox.Tag, Eintragstext);
      Result := aktComboBox.Tag;
    END
    ELSE
    BEGIN
      aktComboBox.Items.Add(Eintragstext);
      Result := aktComboBox.Items.Count - 1;
    END;
    aktComboBox.Text := '';
    aktComboBox.Tag := -1;
  END;
  aktComboBox.ItemIndex := aktComboBox.Tag;
END;

FUNCTION TOptionenfenster.Listeneintrag_Aendern(Eintragstext: STRING): Integer;
BEGIN
  Result := -1;
  IF (aktComboBoxModus AND 4) = 4 THEN
  BEGIN
    IF (((aktComboBoxModus AND 1) = 1) AND (aktComboBox.Tag > 0)) OR
       (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.Tag > -1)) THEN
    BEGIN
      Result := aktComboBox.Tag;
      aktComboBox.Items[aktComboBox.Tag] := Eintragstext;
      aktComboBox.ItemIndex := aktComboBox.Tag;
    END;
  END
  ELSE
  BEGIN
    IF (((aktComboBoxModus AND 1) = 1) AND (aktComboBox.Tag > 0)) OR
       (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.Tag > -1)) THEN
    BEGIN
      Result := aktComboBox.Tag;
      aktComboBox.Items[aktComboBox.Tag] := Eintragstext;
      aktComboBox.Tag := -1;
      aktComboBox.Text := '';
    END;
  END;
END;

procedure TOptionenfenster.ListeneintragneuClick(Sender: TObject);

VAR Index : Integer;
    HString : STRING;

begin
  IF (aktComboBox.ItemIndex = -1) AND (aktComboBox.Text <> '') THEN
    HString := aktComboBox.Text
  ELSE
    HString := neuerEintrag;
  Index := Listeneintrag_Neu(HString);
  IF Assigned(aktComboBoxDatenNeu) AND (Index > -1) THEN
    aktComboBoxDatenNeu(Index);
end;

procedure TOptionenfenster.ListeneintragkopierenClick(Sender: TObject);
begin
  IF (((aktComboBoxModus AND 1) = 1) AND (aktComboBox.ItemIndex > 0)) OR
     (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.ItemIndex > -1)) THEN
    DatenZeigerComboBox := aktComboBox.Items.Objects[aktComboBox.ItemIndex];
end;

procedure TOptionenfenster.ListeneintrageinfuegenClick(Sender: TObject);

VAR Index : Integer;
    HString : STRING;

begin
  IF Assigned(DatenZeigerComboBox) THEN
  BEGIN
    HString := Kopievon + ' ' + aktComboBox.Items.Strings[aktComboBox.Items.IndexOfObject(DatenZeigerComboBox)];
    Index := Listeneintrag_Neu(HString);
    IF Assigned(aktComboBoxDatenKopieren) AND (Index > -1) THEN
      aktComboBoxDatenKopieren(Index);
  END;
end;

procedure TOptionenfenster.ListeneintragaendernClick(Sender: TObject);

VAR Index : Integer;

begin
  Index := Listeneintrag_Aendern(aktComboBox.Text);
  IF Assigned(aktComboBoxDatenAendern) AND (Index > -1) THEN
    aktComboBoxDatenAendern(Index);
end;

procedure TOptionenfenster.ListeneintragbearbeitenClick(Sender: TObject);

VAR Index : Integer;

begin
  Index := aktComboBox.Tag;
  IF Assigned(aktComboBoxDatenBearbeiten) AND (Index > -1) THEN
    aktComboBoxDatenBearbeiten(Index);
end;

procedure TOptionenfenster.ListeneintragloeschenClick(Sender: TObject);
begin
  IF (((aktComboBoxModus AND 1) = 1) AND (aktComboBox.Tag > 0)) OR
     (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.Tag > -1)) THEN
  BEGIN
    IF Assigned(aktComboBox.Items.Objects[aktComboBox.Tag]) THEN
    BEGIN
      aktComboBox.Items.Objects[aktComboBox.Tag].Free;
      aktComboBox.Items.Objects[aktComboBox.Tag] := NIL;
    END;
    aktComboBox.DeleteSelected;
    IF (aktComboBoxModus AND 1) = 1 THEN
    BEGIN
      aktComboBox.ItemIndex := 0;
      aktComboBox.Tag := 0;
    END
    ELSE
    BEGIN
      aktComboBox.Text := '';
      aktComboBox.Tag := -1;
    END;
  END;
end;

procedure TOptionenfenster.ListeneintragDateisuchenClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  IF PromptForFileName(Dateiname, aktBoxDateioeffnenFilter, '', Wortlesen(NIL, 'Dialog101', 'Datei suchen'),
                       Verzeichnissuchen(absolutPathAppl(ExtractFilePath(aktComboBox.Text), Application.ExeName, True)), False) THEN
  BEGIN
    aktComboBox.Items.Add(relativPathAppl(Dateiname, Application.ExeName));
    aktComboBox.Text := '';
    aktComboBox.Tag := -1;
  END;
end;

procedure TOptionenfenster.ComboBoxAusschneidenClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := aktComboBox.SelText;
  aktComboBox.SelText := '';
end;

procedure TOptionenfenster.ComboBoxKopierenClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := aktComboBox.SelText;
end;

procedure TOptionenfenster.ComboBoxEinfuegenClipboardClick(Sender: TObject);
begin
  IF Clipboard.HasFormat(CF_TEXT) THEN
    aktComboBox.SelText := Clipboard.AsText;
end;

procedure TOptionenfenster.ComboboxLoeschenClipboardClick(Sender: TObject);
begin
  aktComboBox.SelText := '';
end;

procedure TOptionenfenster.ComboBoxBitBtnClick(Sender: TObject);

VAR Maus : TPoint;

begin
  IF Sender = AudioframesMpegBitBtn THEN
    DatenbehandlungfestlegenComboBox(AudioframesMpegComboBox);
  IF Sender = AudioframesAC3BitBtn THEN
    DatenbehandlungfestlegenComboBox(AudioframesAC3ComboBox);
  IF Sender = AudioframesPCMBitBtn THEN
    DatenbehandlungfestlegenComboBox(AudioframesPCMComboBox);
  IF Sender = SchnittImportTrennzeichenBitBtn THEN
    DatenbehandlungfestlegenComboBox(SchnittImportTrennzeichenCombobox);
  IF Sender = SchnittImportZeitTrennzeichenBitBtn THEN
    DatenbehandlungfestlegenComboBox(SchnittImportZeitTrennzeichenCombobox);
  IF Sender = KapitelImportTrennzeichenBitBtn THEN
    DatenbehandlungfestlegenComboBox(KapitelImportTrennzeichenCombobox);
  IF Sender = KapitelImportZeitTrennzeichenBitBtn THEN
    DatenbehandlungfestlegenComboBox(KapitelImportZeitTrennzeichenCombobox);
  IF Sender = MarkenImportTrennzeichenBitBtn THEN
    DatenbehandlungfestlegenComboBox(MarkenImportTrennzeichenCombobox);
  IF Sender = MarkenImportZeitTrennzeichenBitBtn THEN
    DatenbehandlungfestlegenComboBox(MarkenImportZeitTrennzeichenCombobox);
  IF Sender = VideoEffektBitBtn THEN
    DatenbehandlungfestlegenComboBox(VideoEffektComboBox);
  IF Sender = AudioEffektBitBtn THEN
    DatenbehandlungfestlegenComboBox(AudioEffektComboBox);
  IF Sender = EffektvorgabeVideoBitBtn THEN
    DatenbehandlungfestlegenComboBox(EffektvorgabeVideoComboBox);
  IF Sender = EffektvorgabeAudioBitBtn THEN
    DatenbehandlungfestlegenComboBox(EffektvorgabeAudioComboBox);
  GetCursorPos(Maus);
  ComboBoxMenue.Popup(Maus.X, Maus.Y);
end;

// ------------ EditBox --------------------
procedure TOptionenfenster.EditBoxMenuePopup(Sender: TObject);
begin
  EditBoxDateisuchen.Visible := False;
  EditBoxVerzeichnissuchen.Visible := False;
  EditBoxDateispeichern.Visible := False;
  EditBoxDateispeichernunter.Visible := False;
  EditBoxFormat1.Visible := False;
  EditBoxFormat2.Visible := False;
  EditBoxFormat3.Visible := False;
  Trennlienie21.Visible := False;
  IF (aktEditBoxModus AND 1) = 1 THEN
  BEGIN
    EditBoxDateisuchen.Visible := True;
    Trennlienie21.Visible := True;
  END;
  IF (aktEditBoxModus AND 2) = 2 THEN
  BEGIN
    EditBoxVerzeichnissuchen.Visible := True;
    Trennlienie21.Visible := True;
  END;
  IF (aktEditBoxModus AND 4) = 4 THEN
  BEGIN
    EditBoxDateispeichern.Visible := True;
    Trennlienie21.Visible := True;
  END;
  IF (aktEditBoxModus AND 8) = 8 THEN
  BEGIN
    EditBoxDateispeichernunter.Visible := True;
    Trennlienie21.Visible := True;
  END;
  IF (aktEditBoxModus AND 16) = 16 THEN
  BEGIN
    EditBoxFormat1.Visible := True;
    EditBoxFormat2.Visible := True;
    EditBoxFormat3.Visible := True;
    Trennlienie21.Visible := True;
  END;
  IF Clipboard.HasFormat(CF_TEXT) THEN
    EditBoxEinfuegenClipboard.Enabled := True
  ELSE
    EditBoxEinfuegenClipboard.Enabled := False;
  IF aktEditBox.SelLength > 0 THEN
  BEGIN
    EditBoxAusschneidenClipboard.Enabled := True;
    EditBoxKopierenClipboard.Enabled := True;
    EditBoxLoeschenClipboard.Enabled := True;
  END
  ELSE
  BEGIN
    EditBoxAusschneidenClipboard.Enabled := False;
    EditBoxKopierenClipboard.Enabled := False;
    EditBoxLoeschenClipboard.Enabled := False;
  END;
end;

procedure TOptionenfenster.EditBoxDateisuchenClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  IF PromptForFileName(Dateiname, aktBoxDateioeffnenFilter, '', Wortlesen(NIL, 'Dialog101', 'Datei suchen'),
                       Verzeichnissuchen(absolutPathAppl(ExtractFilePath(aktEditBox.Text), Application.ExeName, True)), False) THEN
  BEGIN
    aktEditBox.Text := relativPathAppl(Dateiname, Application.ExeName);
    IF Assigned(aktEditBoxDateioeffnen) THEN
      aktEditBoxDateioeffnen;
  END;
end;

procedure TOptionenfenster.EditBoxVerzeichnissuchenClick(Sender: TObject);

VAR Verzeichnis : STRING;

begin
  Verzeichnis := absolutPathAppl(aktEditBox.Text, Application.ExeName, True);
  IF SelectDirectory(Wortlesen(NIL, 'Dialog103', 'Verzeichnis suchen'), '', Verzeichnis) THEN
    aktEditBox.Text := mitPathtrennzeichen(relativPathAppl(Verzeichnis, Application.ExeName));
  IF Assigned(aktEditBoxDateioeffnen) THEN
    aktEditBoxDateioeffnen;
end;

procedure TOptionenfenster.EditBoxDateispeichernClick(Sender: TObject);
begin
  IF Assigned(aktEditBoxDateispeichern) THEN
    aktEditBoxDateispeichern;
end;

procedure TOptionenfenster.EditBoxDateispeichernunterClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  IF PromptForFileName(Dateiname, aktBoxDateioeffnenFilter,
                       '', Wortlesen(NIL, 'Dialog102', 'Datei speichern'),
                       Verzeichnissuchen(absolutPathAppl(ExtractFilePath(aktEditBox.Text), Application.ExeName, True)), True) THEN
  BEGIN
    aktEditBox.Text := relativPathAppl(Dateiname, Application.ExeName);
    IF Assigned(aktEditBoxDateispeichern) THEN
      aktEditBoxDateispeichern;
  END;
end;

procedure TOptionenfenster.EditBoxFormatClick(Sender: TObject);
begin
  IF Sender = EditBoxFormat1 THEN
    aktEditBox.SelText := Wortlesen(NIL, 'EditBoxFormat1', 'F');
  IF Sender = EditBoxFormat2 THEN
    aktEditBox.SelText := Wortlesen(NIL, 'EditBoxFormat2', 'hh:mm:ss.mss');
  IF Sender = EditBoxFormat3 THEN
    aktEditBox.SelText := Wortlesen(NIL, 'EditBoxFormat3', 'hh:mm:ss:ff');
end;

procedure TOptionenfenster.EditBoxAusschneidenClipboardClick(Sender: TObject);
begin
  aktEditBox.CutToClipboard;
end;

procedure TOptionenfenster.EditBoxKopierenClipboardClick(Sender: TObject);
begin
  aktEditBox.CopyToClipboard;
end;

procedure TOptionenfenster.EditBoxEinfuegenClipboardClick(Sender: TObject);
begin
  aktEditBox.PasteFromClipboard;
end;

procedure TOptionenfenster.EditBoxLoeschenClipboardClick(Sender: TObject);
begin
  aktEditBox.ClearSelection;
end;

procedure TOptionenfenster.EditBoxBitBtnClick(Sender: TObject);

VAR Maus : TPoint;

begin
  IF Sender = BilderdateiBitBtn THEN
    DatenbehandlungfestlegenEditBox(BilderdateiEdit);
  IF Sender = VideoAudioVerzeichnisBitBtn THEN
    DatenbehandlungfestlegenEditBox(VideoAudioVerzeichnisEdit);
  IF Sender = ZielVerzeichnisBitBtn THEN
    DatenbehandlungfestlegenEditBox(ZielVerzeichnisEdit);
  IF Sender = ProjektVerzeichnisBitBtn THEN
    DatenbehandlungfestlegenEditBox(ProjektVerzeichnisEdit);
  IF Sender = KapitelVerzeichnisBitBtn THEN
    DatenbehandlungfestlegenEditBox(KapitelVerzeichnisEdit);
  IF Sender = VorschauVerzeichnisBitBtn THEN
    DatenbehandlungfestlegenEditBox(VorschauVerzeichnisEdit);
  IF Sender = ZwischenVerzeichnisBitBtn THEN
    DatenbehandlungfestlegenEditBox(ZwischenVerzeichnisEdit);
  IF Sender = AudioGraphNameBitBtn THEN
    DatenbehandlungfestlegenEditBox(AudioGraphNameEdit);
  IF Sender = DemuxerBitBtn THEN
    DatenbehandlungfestlegenEditBox(DemuxerDateiEdit);
  IF Sender = EncoderBitBtn THEN
    DatenbehandlungfestlegenEditBox(EncoderDateiEdit);
  IF Sender = AusgabeBitBtn THEN
    DatenbehandlungfestlegenEditBox(AusgabeDateiEdit);
  IF Sender = VideoEffektdateiBitBtn THEN
    DatenbehandlungfestlegenEditBox(VideoEffektverzEdit);
  IF Sender = AudioEffektdateiBitBtn THEN
    DatenbehandlungfestlegenEditBox(AudioEffektverzEdit);
  IF Sender = EffektvorgabedateiBitBtn THEN
    DatenbehandlungfestlegenEditBox(EffektvorgabedateiEdit);
  GetCursorPos(Maus);
  EditBoxMenue.Popup(Maus.X, Maus.Y);
end;

// ++++++++++++++++++Comboboxen++++++++++++++++++
PROCEDURE TOptionenfenster.DatenbehandlungfestlegenComboBox(Sender: TObject);
BEGIN
//  aktComboBoxModus: mögliche Einstellungen
//     Bit 1 = 0 : Index 0 wird benutzt (normale Funktionsweise)
//     Bit 1 = 1 : Index 0 bleibt leer  (der Benutzer kann den ersten Eintrag nicht ändern)
//     Bit 2 = 1 : Dateisuchen wird eingeblendet
//     Bit 3 = 0 : ItemIndex springt nach einem Pupup auf -1
//     Bit 3 = 1 : ItemIndex behält seinen Wert
//     Bit 4 = 0 : Eintrag nicht auf vorhandene Daten prüfen
//     Bit 4 = 1 : Eintrag auf vorhandene Daten prüfen

  IF aktComboBox <> Sender THEN
  BEGIN
    aktComboBox := TComboBox(Sender);
    aktComboBoxDatenNeu := NIL;
    aktComboBoxDatenAendern := NIL;
    aktComboBoxDatenKopieren := NIL;
    aktComboBoxDatenBearbeiten := NIL;
    aktComboBoxModus := 0;                 // zurücksetzen
    DatenZeigerComboBox := NIL;
    IF Sender = VideoEffektComboBox THEN
    BEGIN
      aktComboBoxDatenNeu := EffektDatenEintragNeuVideo;
      aktComboBoxDatenAendern := EffektDatenEintragAendernVideo;
      aktComboBoxDatenKopieren := EffektDatenEintragKopierenVideo;
      aktComboBoxDatenBearbeiten := EffektDatenEintragBearbeitenVideo;
      aktComboBoxModus := aktComboBoxModus OR 13;
    END;
    IF Sender = AudioEffektComboBox THEN
    BEGIN
      aktComboBoxDatenNeu := EffektDatenEintragNeuAudio;
      aktComboBoxDatenAendern := EffektDatenEintragAendernAudio;
      aktComboBoxDatenKopieren := EffektDatenEintragKopierenAudio;
      aktComboBoxDatenBearbeiten := EffektDatenEintragBearbeitenAudio;
      aktComboBoxModus := aktComboBoxModus OR 13;
    END;
    IF Sender = EffektvorgabeVideoComboBox THEN
    BEGIN
      aktComboBoxDatenNeu := EffektvorgabeDatenEintragNeu;
      aktComboBoxDatenKopieren := EffektvorgabeDatenEintragKopieren;
      aktComboBoxDatenBearbeiten := EffektvorgabeDatenBearbeitenVideo;
      aktComboBoxModus := aktComboBoxModus OR 12;
    END;
    IF Sender = EffektvorgabeAudioComboBox THEN
    BEGIN
      aktComboBoxDatenNeu := EffektvorgabeDatenEintragNeu;
      aktComboBoxDatenKopieren := EffektvorgabeDatenEintragKopieren;
      aktComboBoxDatenBearbeiten := EffektvorgabeDatenBearbeitenAudio;
      aktComboBoxModus := aktComboBoxModus OR 12;
    END;
    IF (Sender = AudioframesPCMComboBox) OR
       (Sender = AudioframesMpegComboBox) OR
       (Sender = AudioframesAC3ComboBox) THEN
    BEGIN
      aktComboBoxModus := aktComboBoxModus OR 2;
      aktBoxDateioeffnenFilter := Wortlesen(NIL, 'Dialog15', 'Audiodateien') + '|' + DateiendungenAudioEdit.Text;
    END;
  END;
END;

procedure TOptionenfenster.ComboboxKeyPress(Sender: TObject; var Key: Char);
begin
  IF Key = Chr(13) THEN
  BEGIN
    DatenbehandlungfestlegenComboBox(Sender);
    IF ((((aktComboBoxModus AND 1) = 1) AND (aktComboBox.Tag > 0)) OR
       (((aktComboBoxModus AND 1) = 0) AND (aktComboBox.Tag > -1))) AND
       (aktComboBox.Text <> '') THEN
    BEGIN
      IF aktComboBox.Text <> aktComboBox.Items.Strings[aktComboBox.Tag] THEN
        ListeneintragaendernClick(Sender)
      ELSE
        ListeneintragbearbeitenClick(Sender);
    END
    ELSE
      ListeneintragneuClick(Sender);
    Key := Chr(0);
  END;
end;

procedure TOptionenfenster.ComboboxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  DatenbehandlungfestlegenComboBox(Sender);
end;

procedure TOptionenfenster.ComboBoxDblClick(
  Sender: TObject);
begin
  DatenbehandlungfestlegenComboBox(Sender);
  ListeneintragDateisuchenClick(Sender);
end;

procedure TOptionenfenster.ComboBoxSelect(Sender: TObject);
begin
  TComboBox(Sender).Tag := TComboBox(Sender).ItemIndex;
end;

// ++++++++++++++++++EditBoxen++++++++++++++++++

PROCEDURE TOptionenfenster.DatenbehandlungfestlegenEditBox(Sender: TObject);
BEGIN
  IF aktEditBox <> TEdit(Sender) THEN
  BEGIN
    aktEditBox := TEdit(Sender);
    aktEditBoxDateioeffnen := NIL;
    aktEditBoxModus := 0;                                     // Standard
    aktBoxDateioeffnenFilter := Wortlesen(NIL, 'Dialog111', 'Alle Dateien') + '|' + '*.*';
    IF (Sender = VideoAudioVerzeichnisEdit) OR
       (Sender = ZielVerzeichnisEdit) OR
       (Sender = ProjektVerzeichnisEdit) OR
       (Sender = KapitelVerzeichnisEdit) OR
       (Sender = VorschauVerzeichnisEdit) OR
       (Sender = ZwischenVerzeichnisEdit) THEN
      aktEditBoxModus := aktEditBoxModus OR 2;                // Verzeichnis suchen
    IF Sender = AudioGraphNameEdit THEN
    BEGIN
      aktEditBoxModus := aktEditBoxModus OR 1;                // Datei suchen
      aktBoxDateioeffnenFilter := Wortlesen(NIL, 'Dialog112', 'Grapheditdateien') + '|' + '*.grf';
    END;
    IF (Sender = VideoEffektverzEdit) OR
       (Sender = AudioEffektverzEdit) THEN
    BEGIN
      aktEditBoxDateioeffnen := Effekteladen;
      aktEditBoxModus := aktEditBoxModus OR 2;                // Verzeichnis suchen
      aktBoxDateioeffnenFilter := Wortlesen(NIL, 'Dialog113', 'Effektdateien') + '|' + '*.eff';
    END;
    IF Sender = EffektvorgabedateiEdit THEN
    BEGIN
      aktEditBoxDateioeffnen := EffektvorgabeDateiladen;
      aktEditBoxDateispeichern := EffektvorgabeDateispeichern;
      aktEditBoxModus := aktEditBoxModus OR 13;               // Datei suchen, speichern, speichern unter
      aktBoxDateioeffnenFilter := Wortlesen(NIL, 'Dialog113', 'Effektdateien') + '|' + '*.eff';
    END;
    IF (Sender = DemuxerDateiEdit) OR
       (Sender = EncoderDateiEdit) OR
       (Sender = AusgabedateiEdit) THEN
    BEGIN
      aktEditBoxModus := aktEditBoxModus OR 1;                // Datei suchen
      aktBoxDateioeffnenFilter := Wortlesen(NIL, 'Dialog114', 'Programmdateien') + '|' + '*.prg';
    END;
    IF Sender = BilderdateiEdit THEN
    BEGIN
      aktEditBoxModus := aktEditBoxModus OR 1;                // Datei suchen
      aktBoxDateioeffnenFilter := Wortlesen(NIL, 'Dialog116', 'Bitmapdateien') + '|' + '*.bmp';
    END;
    IF (Sender = SchnittFormatEdit) OR
       (Sender = KapitelFormatEdit) OR
       (Sender = MarkenFormatEdit) OR
       (Sender = SchnittexportFormatEdit) OR
       (Sender = KapitelexportFormatEdit) OR
       (Sender = MarkenexportFormatEdit) THEN
    BEGIN
      aktEditBoxModus := aktEditBoxModus OR 16;                // Format
    END;
  END;
END;

procedure TOptionenfenster.EditBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  DatenbehandlungfestlegenEditBox(Sender);
end;

procedure TOptionenfenster.EditBoxDblClick(Sender: TObject);
begin
  DatenbehandlungfestlegenEditBox(Sender);
  IF (aktEditBoxModus AND 1) = 1 THEN
    EditBoxDateisuchenClick(Sender)
  ELSE
    IF (aktEditBoxModus AND 2) = 2 THEN
      EditBoxVerzeichnissuchenClick(Sender);
end;

procedure TOptionenfenster.EditBoxKeyPress(Sender: TObject; var Key: Char);
begin
  IF Key = Chr(13) THEN
  BEGIN
    DatenbehandlungfestlegenEditBox(Sender);
    IF (aktEditBoxModus AND 1) = 1 THEN
      EditBoxDateisuchenClick(Sender)
    ELSE
      IF (aktEditBoxModus AND 2) = 2 THEN
        EditBoxVerzeichnissuchenClick(Sender);
    Key := Chr(0);
  END;
end;

// ++++++++++++++++++Arbeitsumgebungen+++++++++++

PROCEDURE TOptionenfenster.ArbeitsumgebungausDialogspeichern(Name: STRING);

VAR Arbeitsumgebungladen : TArbeitsumgebung;

BEGIN
  IF Eingabenpruefen = 0 THEN
  BEGIN
    Arbeitsumgebungladen := TArbeitsumgebung.Create;
    TRY
      Arbeitsumgebungschreiben(Arbeitsumgebungladen);
      EffektListenschreiben(Arbeitsumgebungladen);
      EffektvorgabeListenschreiben(Arbeitsumgebungladen);
      Arbeitsumgebungladen.Arbeitsumgebungspeichern(Name);
    EXCEPT
      Arbeitsumgebungladen.Free;
    END;
  END;
END;

procedure TOptionenfenster.SpeichernTasteClick(Sender: TObject);
begin
  ArbeitsumgebungausDialogspeichern(Arbeitsumgebung.Dateiname);
  Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Arbeitsumgebung.Dateiname, 'Datei $Text1# gespeichert.'), StrToIntDef(HinweisanzeigedauerEdit.Text, Arbeitsumgebung.Hinweisanzeigedauer), False, True);
end;

procedure TOptionenfenster.SpeichernunterTasteClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  Dateiname := '';
  IF PromptForFileName(Dateiname, Wortlesen(NIL, 'Dialog3', 'Mpeg2Schnitt Arbeitsumbegungen') + '|*.mau',
                       'mau', Wortlesen(NIL, 'Dialog1', 'Mpeg2Schnitt Arbeitsumbegung speichern'),
                       Verzeichnissuchen(ExtractFilePath(Arbeitsumgebung.Dateiname)),
                       True) THEN
  BEGIN
    ArbeitsumgebungausDialogspeichern(Dateiname);
    Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', Dateiname, 'Datei $Text1# gespeichert.'), StrToIntDef(HinweisanzeigedauerEdit.Text, Arbeitsumgebung.Hinweisanzeigedauer), False, True);
  END;
end;

procedure TOptionenfenster.StandardTasteClick(Sender: TObject);
begin
  ArbeitsumgebungausDialogspeichern(ExtractFilePath(Application.ExeName) + 'Standard.mau');
  Hinweisanzeigen(Meldunglesen(NIL, 'Meldung134', ExtractFilePath(Application.ExeName) + 'Standard.mau', 'Datei $Text1# gespeichert.'), StrToIntDef(HinweisanzeigedauerEdit.Text, Arbeitsumgebung.Hinweisanzeigedauer), False, True);
end;

// ++++++++++++++++++Allgemein+++++++++++

procedure TOptionenfenster.OptionenfesteFramerateverwendenBoxClick(  Sender: TObject);
begin
  IF OptionenfesteFramerateverwendenBox.Checked THEN
    festeFramerateEdit.Enabled := True
  ELSE
    festeFramerateEdit.Enabled := False;
end;

procedure TOptionenfenster.SymboleRadioButtonClick(Sender: TObject);
begin
  IF OptionenSymboldateiRadioButton.Checked THEN
    BilderdateiEdit.Enabled := True
  ELSE
    BilderdateiEdit.Enabled := False;
  Arbeitsumgebung.Bilderdateigeaendert := True;
end;

// ++++++++++++++++++Oberfläche+++++++++++++++++++++

procedure TOptionenfenster.OptionenHauptfensterSchriftartBtnClick(Sender: TObject);
begin
  SchriftDialog.Font.Name := OptionenHauptfensterSchriftartEdit.Text;
  SchriftDialog.Font.Size := StrToInt(OptionenHauptfensterSchriftgroesseEdit.Text);
  IF SchriftDialog.Execute THEN
  BEGIN
    OptionenHauptfensterSchriftartEdit.Text := SchriftDialog.Font.Name;
    OptionenHauptfensterSchriftgroesseEdit.Text := IntToStr(SchriftDialog.Font.Size);
  END;
end;

procedure TOptionenfenster.OptionenTastenfensterSchriftartBtnClick(
  Sender: TObject);
begin
  SchriftDialog.Font.Name := OptionenTastenfensterSchriftartEdit.Text;
  SchriftDialog.Font.Size := StrToInt(OptionenTastenfensterSchriftgroesseEdit.Text);
  IF SchriftDialog.Execute THEN
  BEGIN
    OptionenTastenfensterSchriftartEdit.Text := SchriftDialog.Font.Name;
    OptionenTastenfensterSchriftgroesseEdit.Text := IntToStr(SchriftDialog.Font.Size);
  END;
end;

procedure TOptionenfenster.OptionenAnzeigefensterSchriftartBtnClick(
  Sender: TObject);
begin
  SchriftDialog.Font.Name := OptionenAnzeigefensterSchriftartEdit.Text;
  SchriftDialog.Font.Size := StrToInt(OptionenAnzeigefensterSchriftgroesseEdit.Text);
  IF SchriftDialog.Execute THEN
  BEGIN
    OptionenAnzeigefensterSchriftartEdit.Text := SchriftDialog.Font.Name;
    OptionenAnzeigefensterSchriftgroesseEdit.Text := IntToStr(SchriftDialog.Font.Size);
  END;
end;

procedure TOptionenfenster.OptionenDialogeSchriftartBtnClick(
  Sender: TObject);
begin
  SchriftDialog.Font.Name := OptionenDialogeSchriftartEdit.Text;
  SchriftDialog.Font.Size := StrToInt(OptionenDialogeSchriftgroesseEdit.Text);
  IF SchriftDialog.Execute THEN
  BEGIN
    OptionenDialogeSchriftartEdit.Text := SchriftDialog.Font.Name;
    OptionenDialogeSchriftgroesseEdit.Text := IntToStr(SchriftDialog.Font.Size);
    Font.Name := SchriftDialog.Font.Name;
    Font.Size := SchriftDialog.Font.Size;
    OptionenSeiten.Height := (OptionenSeiten.RowCount * OptionenSeiten.TabHeight) + 340;
    ClientHeight := OptionenSeiten.Height + 53;
  END;
end;

// ++++++++++++++++++Video-, Audioschnitt+++++++++++

procedure TOptionenfenster.BitrateersterHeaderComboBoxCloseUp(Sender: TObject);
begin
  IF BitrateersterHeaderComboBox.ItemIndex = 4 THEN
  BEGIN
    BitrateersterHeaderComboBox.Style := csDropDown;
    BitrateersterHeaderComboBox.Text := BitrateersterHeaderComboBox.Items[4] + ': ' + IntToStr(Arbeitsumgebung.festeBitrate);
    BitrateersterHeaderComboBox.SetFocus;
  END
  ELSE
    BitrateersterHeaderComboBox.Style := csDropDownList;
end;

procedure TOptionenfenster.BitrateersterHeaderComboBoxSelect(Sender: TObject);
begin
  IF BitrateersterHeaderComboBox.ItemIndex < 4 THEN
    BitrateersterHeaderComboBox.Style := csDropDownList;
end;

procedure TOptionenfenster.AspectratioersterHeaderComboBoxCloseUp(Sender: TObject);
begin
  IF AspectratioersterHeaderComboBox.ItemIndex = 6 THEN
  BEGIN
    AspectratioersterHeaderComboBox.Style := csDropDown;
    AspectratioersterHeaderComboBox.Text := AspectratioersterHeaderComboBox.Items[6] + ': ' + IntToStr(Arbeitsumgebung.AspectratioOffset);
    AspectratioersterHeaderComboBox.SetFocus;
  END
  ELSE
    AspectratioersterHeaderComboBox.Style := csDropDownList;
end;

procedure TOptionenfenster.AspectratioersterHeaderComboBoxSelect(Sender: TObject);
begin
  IF AspectratioersterHeaderComboBox.ItemIndex < 6 THEN
    AspectratioersterHeaderComboBox.Style := csDropDownList;
end;

procedure TOptionenfenster.OptionenMaxGOPLaengeBoxClick(Sender: TObject);
begin
  MaxGOPLaengeEdit.Enabled := OptionenMaxGOPLaengeBox.Checked;
end;

// ++++++++++++++++++ListenFormatseite+++++++++++

procedure TOptionenfenster.OptionenSchnittlistenFormatuebernehmenBoxClick(
  Sender: TObject);
begin
  SchnittlistenFormatuebernehmen_gedrueckt;
end;

PROCEDURE TOptionenfenster.SchnittlistenFormatuebernehmen_gedrueckt;
BEGIN
  IF OptionenSchnittlistenFormatuebernehmenBox.Checked THEN
  BEGIN
    KapitelFormatEdit.Enabled := False;
  END
  ELSE
  BEGIN
    KapitelFormatEdit.Enabled := True;
  END;
END;

// ++++++++++++++++++ListenImportseite+++++++++++

procedure TOptionenfenster.OptionenSchnittlistenimportuebernehmenBox1Click(
  Sender: TObject);
begin
  Schnittlistenimportuebernehmen1_gedrueckt;
end;

PROCEDURE TOptionenfenster.Schnittlistenimportuebernehmen1_gedrueckt;
BEGIN
  IF OptionenSchnittlistenimportuebernehmenBox1.Checked THEN
  BEGIN
    KapitelImportTrennzeichenCombobox.Enabled := False;
    KapitelImportTrennzeichenCombobox.Text := '';
    KapitelImportZeitTrennzeichenCombobox.Enabled := False;
    KapitelImportZeitTrennzeichenCombobox.Text := '';
  END
  ELSE
  BEGIN
    KapitelImportTrennzeichenCombobox.Enabled := True;
    KapitelImportZeitTrennzeichenCombobox.Enabled := True;
  END;
END;

procedure TOptionenfenster.OptionenSchnittlistenimportuebernehmenBox2Click(
  Sender: TObject);
begin
  Schnittlistenimportuebernehmen2_gedrueckt;
end;

PROCEDURE TOptionenfenster.Schnittlistenimportuebernehmen2_gedrueckt;
BEGIN
  IF OptionenSchnittlistenimportuebernehmenBox2.Checked THEN
  BEGIN
    MarkenImportTrennzeichenCombobox.Enabled := False;
    MarkenImportTrennzeichenCombobox.Text := '';
    MarkenImportZeitTrennzeichenCombobox.Enabled := False;
    MarkenImportZeitTrennzeichenCombobox.Text := '';
  END
  ELSE
  BEGIN
    MarkenImportTrennzeichenCombobox.Enabled := True;
    MarkenImportZeitTrennzeichenCombobox.Enabled := True;
  END;
END;

// ++++++++++++++++++ListenExportseite+++++++++++

procedure TOptionenfenster.OptionenSchnittlistenexportuebernehmenBox1Click(
  Sender: TObject);
begin
  Schnittlistenexportuebernehmen1_gedrueckt;
end;

procedure TOptionenfenster.OptionenSchnittlistenexportuebernehmenBox2Click(
  Sender: TObject);
begin
  Schnittlistenexportuebernehmen2_gedrueckt;
end;

PROCEDURE TOptionenfenster.Schnittlistenexportuebernehmen1_gedrueckt;
BEGIN
  IF OptionenSchnittlistenexportuebernehmenBox1.Checked THEN
  BEGIN
    KapitelexportFormatEdit.Enabled := False;
    KapitelexportOffsetEdit.Enabled := False;
  END
  ELSE
  BEGIN
    KapitelexportFormatEdit.Enabled := True;
    KapitelexportOffsetEdit.Enabled := True;
  END;
END;

PROCEDURE TOptionenfenster.Schnittlistenexportuebernehmen2_gedrueckt;
BEGIN
  IF OptionenSchnittlistenexportuebernehmenBox2.Checked THEN
  BEGIN
    MarkenexportFormatEdit.Enabled := False;
    MarkenexportOffsetEdit.Enabled := False;
  END
  ELSE
  BEGIN
    MarkenexportFormatEdit.Enabled := True;
    MarkenexportOffsetEdit.Enabled := True;
  END;
END;

// ++++++++++++++++++Tastenbelegung+++++++++++++++++++++++++

PROCEDURE TOptionenfenster.Tasten_weiterleiten(var Msg: TMsg; var Handled: Boolean);

VAR I : Integer;
    benutzt : Boolean;

BEGIN
  IF Tastenbelegung THEN
  BEGIN
    IF (Msg.message = WM_KeyDown) AND (Msg.wParam = 18) THEN
      Msg.wParam := 15;
    IF (Msg.message = WM_KeyDown) OR (Msg.message = WM_SysKeyDown) THEN
    BEGIN
      benutzt := False;
      FOR I := 1 TO High(TastenbelegungArray) DO
        IF TastenbelegungArray[I] = Msg.wParam THEN
          benutzt := True;
      IF NOT benutzt THEN
      BEGIN
        TastenbelegungGrid.Cells[1, TastenbelegungGrid.Row] := TastenNummerZuName(Msg.wParam);
        TastenbelegungArray[TastenbelegungGrid.Row] := Msg.wParam;
      END;
      Handled := True;
      Tastenbelegung := False;
      TastenbelegungGrid.Repaint;
    END;
    IF (Msg.message = WM_KeyUp) OR (Msg.message = WM_SysKeyUp) THEN
      Handled := True;
  END;
END;

procedure TOptionenfenster.TastenbelegungGridDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  TastenbelegungGrid.Canvas.Pen.Color := clred;
  TastenbelegungGrid.Canvas.Brush.Style := bsClear;
  IF Tastenbelegung AND (ARow = TastenbelegungGrid.Row) AND (ACol = 1) THEN
    TastenbelegungGrid.Canvas.Rectangle(Rect);
end;

procedure TOptionenfenster.TastenbelegungGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  IF Key = 13 THEN
    Tastenbelegung := True;
  TastenbelegungGrid.Repaint;
end;

procedure TOptionenfenster.TastenbelegungGridClick(Sender: TObject);
begin
  Tastenbelegung := False;
  TastenbelegungGrid.Repaint;
end;

procedure TOptionenfenster.TastenbelegungGridDblClick(Sender: TObject);
begin
  Tastenbelegung := True;
  TastenbelegungGrid.Repaint;
end;

procedure TOptionenfenster.TastenbelegungloeschenClick(Sender: TObject);
begin
  TastenbelegungGrid.Cells[1, TastenbelegungGrid.Row] := '';
  TastenbelegungArray[TastenbelegungGrid.Row] := 0;
end;

// ++++++++++++++++++Effekte+++++++++++++++++++++++++++++++++
{FUNCTION TOptionenfenster.DatenKopieren(Quelle, Ziel: TAusgabeDaten): STRING;
BEGIN
  IF Assigned(Quelle) AND Assigned(Ziel) THEN
  BEGIN
    Ziel.EffektName := Quelle.EffektName;
    Ziel.ProgrammName := Quelle.ProgrammName;
    Ziel.ProgrammParameter := Quelle.ProgrammParameter;
    Ziel.Parameter := Quelle.Parameter;
    Ziel.OrginalparameterDatei := Quelle.OrginalparameterDatei;
    Ziel.ParameterDateiName := Quelle.ParameterDateiName;
    Result := Ziel.EffektName;
  END
  ELSE
    Result := '';
END;    }

FUNCTION TOptionenfenster.EffektDatenkopieren(Quelle: TDateiListeneintrag): TDateiListeneintrag;
BEGIN
  IF Assigned(Quelle) THEN
  BEGIN
      Result := TDateiListeneintrag.Create;
      Result.Name := Quelle.Name;
      Result.Dateiname := Quelle.Dateiname;
  END
  ELSE
    Result := NIL;
END;

{FUNCTION TOptionenfenster.EffektDatenkopierenAudio(Quelle: TEffektAudioDaten): TEffektAudioDaten;
BEGIN
  IF Assigned(Quelle) THEN
  BEGIN
    Result := TEffektAudioDaten.Create;
    Result.EffektEinstellungen := Quelle.EffektEinstellungen;
    Result.alleAudiotypengleich := Quelle.alleAudiotypengleich;
    DatenKopieren(Quelle.AudioEffektPCM, Result.AudioEffektPCM);
    DatenKopieren(Quelle.AudioEffektMp2, Result.AudioEffektMp2);
    DatenKopieren(Quelle.AudioEffektAC3, Result.AudioEffektAC3);
  END
  ELSE
    Result := NIL;
END;     }

FUNCTION TOptionenfenster.EffektvorgabeDatenKopieren(Quelle: TEffektEintrag): TEffektEintrag;
BEGIN
  IF Assigned(Quelle) THEN
  BEGIN
    Result := TEffektEintrag.Create;
    Result.AnfangEffektName := Quelle.AnfangEffektName;
//    Result.AnfangEffektPosition := Quelle.AnfangEffektPosition;
    Result.AnfangLaenge := Quelle.AnfangLaenge;
    Result.AnfangEffektParameter := Quelle.AnfangEffektParameter;
    Result.EndeEffektName := Quelle.EndeEffektName;
//    Result.EndeEffektPosition := Quelle.EndeEffektPosition;
    Result.EndeLaenge := Quelle.EndeLaenge;
    Result.EndeEffektParameter := Quelle.EndeEffektParameter;
  END
  ELSE
    Result := NIL;
END;

PROCEDURE TOptionenfenster.EffektListeneinlesen(Arbeitsumgebung : TArbeitsumgebung);

VAR I : Integer;

BEGIN
  IF Assigned(Arbeitsumgebung) THEN
  BEGIN
    Stringliste_loeschen(VideoEffektComboBox.Items);
    FOR I := 0 TO Arbeitsumgebung.VideoEffekte.Count -1 DO
      VideoEffektComboBox.Items.AddObject(Arbeitsumgebung.VideoEffekte.Strings[I], EffektDatenkopieren(TDateiListeneintrag(Arbeitsumgebung.VideoEffekte.Objects[I])));
    Stringliste_loeschen(AudioEffektComboBox.Items);
    FOR I := 0 TO Arbeitsumgebung.AudioEffekte.Count -1 DO
      AudioEffektComboBox.Items.AddObject(Arbeitsumgebung.AudioEffekte.Strings[I], EffektDatenkopieren(TDateiListeneintrag(Arbeitsumgebung.AudioEffekte.Objects[I])));
    IF VideoEffektComboBox.Items.Count > 0 THEN
    BEGIN
      VideoEffektComboBox.ItemIndex := 0;
      VideoEffektComboBox.Tag := 0;
    END;
    IF AudioEffektComboBox.Items.Count > 0 THEN
    BEGIN
      AudioEffektComboBox.ItemIndex := 0;
      AudioEffektComboBox.Tag := 0;
    END;
  END;
END;

PROCEDURE TOptionenfenster.EffektvorgabeListeneinlesen(Arbeitsumgebung : TArbeitsumgebung);

VAR I : Integer;

BEGIN
  IF Assigned(Arbeitsumgebung) THEN
  BEGIN
    Stringliste_loeschen(EffektvorgabeVideoComboBox.Items);
    FOR I := 0 TO Arbeitsumgebung.Videoeffektvorgaben.Count -1 DO
      EffektvorgabeVideoComboBox.Items.AddObject(Arbeitsumgebung.Videoeffektvorgaben.Strings[I], EffektvorgabeDatenKopieren(TEffektEintrag(Arbeitsumgebung.Videoeffektvorgaben.Objects[I])));
    Stringliste_loeschen(EffektvorgabeAudioComboBox.Items);
    FOR I := 0 TO Arbeitsumgebung.Audioeffektvorgaben.Count -1 DO
      EffektvorgabeAudioComboBox.Items.AddObject(Arbeitsumgebung.Audioeffektvorgaben.Strings[I], EffektvorgabeDatenKopieren(TEffektEintrag(Arbeitsumgebung.Audioeffektvorgaben.Objects[I])));
    EffektvorgabeVideoComboBox.ItemIndex := EffektvorgabeVideoComboBox.Items.IndexOf(Arbeitsumgebung.Videoeffektvorgabe);
    EffektvorgabeVideoComboBox.Tag := EffektvorgabeVideoComboBox.ItemIndex;
    IF EffektvorgabeVideoComboBox.ItemIndex > -1 THEN
      EffektvorgabeVideoComboBox.Text := Arbeitsumgebung.Videoeffektvorgabe
    ELSE
      EffektvorgabeVideoComboBox.Text := '';
    EffektvorgabeAudioComboBox.ItemIndex := EffektvorgabeAudioComboBox.Items.IndexOf(Arbeitsumgebung.Audioeffektvorgabe);
    EffektvorgabeAudioComboBox.Tag := EffektvorgabeAudioComboBox.ItemIndex;
    IF EffektvorgabeAudioComboBox.ItemIndex > -1 THEN
      EffektvorgabeAudioComboBox.Text := Arbeitsumgebung.Audioeffektvorgabe
    ELSE
      EffektvorgabeAudioComboBox.Text := '';
  END;
END;

PROCEDURE TOptionenfenster.EffektListenschreiben(Arbeitsumgebung : TArbeitsumgebung);

VAR I : Integer;

BEGIN
  IF Assigned(Arbeitsumgebung) THEN
  BEGIN
    Stringliste_loeschen(Arbeitsumgebung.VideoEffekte);
    FOR I := 0 TO VideoEffektComboBox.Items.Count -1 DO
      Arbeitsumgebung.VideoEffekte.AddObject(VideoEffektComboBox.Items.Strings[I], EffektDatenkopieren(TDateiListeneintrag(VideoEffektComboBox.Items.Objects[I])));
    Stringliste_loeschen(Arbeitsumgebung.AudioEffekte);
    FOR I := 0 TO AudioEffektComboBox.Items.Count -1 DO
      Arbeitsumgebung.AudioEffekte.AddObject(AudioEffektComboBox.Items.Strings[I], EffektDatenkopieren(TDateiListeneintrag(AudioEffektComboBox.Items.Objects[I])));
  END;
END;

PROCEDURE TOptionenfenster.EffektvorgabeListenschreiben(Arbeitsumgebung : TArbeitsumgebung);

VAR I : Integer;

BEGIN
  IF Assigned(Arbeitsumgebung) THEN
  BEGIN
    Stringliste_loeschen(Arbeitsumgebung.Videoeffektvorgaben);
    FOR I := 0 TO EffektvorgabeVideoComboBox.Items.Count -1 DO
      Arbeitsumgebung.Videoeffektvorgaben.AddObject(EffektvorgabeVideoComboBox.Items.Strings[I], EffektvorgabeDatenKopieren(TEffektEintrag(EffektvorgabeVideoComboBox.Items.Objects[I])));
    Stringliste_loeschen(Arbeitsumgebung.Audioeffektvorgaben);
    FOR I := 0 TO EffektvorgabeAudioComboBox.Items.Count -1 DO
      Arbeitsumgebung.Audioeffektvorgaben.AddObject(EffektvorgabeAudioComboBox.Items.Strings[I], EffektvorgabeDatenKopieren(TEffektEintrag(EffektvorgabeAudioComboBox.Items.Objects[I])));
    Arbeitsumgebung.Videoeffektvorgabe := EffektvorgabeVideoComboBox.Text;
    Arbeitsumgebung.Audioeffektvorgabe := EffektvorgabeAudioComboBox.Text;
  END;
END;

PROCEDURE TOptionenfenster.EffektDatenEintragNeuVideo(Index: Integer);
BEGIN
//  aktComboBox.Items.Objects[Index] := TEffektVideoDaten.Create;
//  EffektDatenEintragAendernVideo(Index);
END;

PROCEDURE TOptionenfenster.EffektDatenEintragKopierenVideo(Index: Integer);
BEGIN
//  aktComboBox.Items.Objects[Index] := EffektDatenkopierenVideo(TEffektVideoDaten(DatenZeigerComboBox));
//  EffektDatenEintragAendernVideo(Index);
END;

PROCEDURE TOptionenfenster.EffektDatenEintragAendernVideo(Index: Integer);
BEGIN
//  IF Assigned(aktComboBox.Items.Objects[Index]) AND
//     Assigned(TEffektVideoDaten(aktComboBox.Items.Objects[Index]).VideoEffekt) THEN
//    TEffektVideoDaten(aktComboBox.Items.Objects[Index]).VideoEffekt.EffektName := aktComboBox.Items.Strings[Index];
END;

PROCEDURE TOptionenfenster.EffektDatenEintragBearbeitenVideo(Index: Integer);
BEGIN
{  IF Assigned(aktComboBox.Items.Objects[Index]) THEN
  BEGIN
    EffektDatenEintragAendernVideo(Index);
    Ausgabefenster.DialogName := EffektbearbeitenDialogName;
    Ausgabefenster.ParameterName := EffektbearbeitenParameterName;
    Ausgabefenster.aktFelder := $7F;
    Ausgabefenster.AusgabeDaten := TEffektVideoDaten(aktComboBox.Items.Objects[Index]).VideoEffekt;
    Ausgabefenster.Einstellungen := TEffektVideoDaten(aktComboBox.Items.Objects[Index]).EffektEinstellungen;
    IF Ausgabefenster.ShowModal = mrOk	THEN
    BEGIN
      TEffektVideoDaten(aktComboBox.Items.Objects[Index]).EffektEinstellungen := Ausgabefenster.Einstellungen;
      IF Assigned(Ausgabefenster.AusgabeDaten) THEN
        aktComboBox.Items.Strings[Index] := Ausgabefenster.AusgabeDaten.EffektName;
      aktComboBox.ItemIndex := aktComboBox.Tag;
      IF aktComboBox.Tag > -1 THEN
        aktComboBox.Text := aktComboBox.Items.Strings[Index];
    END;
  END;   }
END;

PROCEDURE TOptionenfenster.EffektDatenEintragNeuAudio(Index: Integer);
BEGIN
//  aktComboBox.Items.Objects[Index] := TEffektAudioDaten.Create;
//  EffektDatenEintragAendernAudio(Index);
END;

PROCEDURE TOptionenfenster.EffektDatenEintragKopierenAudio(Index: Integer);
BEGIN
//  aktComboBox.Items.Objects[Index] := EffektDatenkopierenAudio(TEffektAudioDaten(DatenZeigerComboBox));
//  EffektDatenEintragAendernAudio(Index);
END;

PROCEDURE TOptionenfenster.EffektDatenEintragAendernAudio(Index: Integer);
BEGIN
{  IF Assigned(aktComboBox.Items.Objects[Index]) AND
     Assigned(TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektPCM) AND
     Assigned(TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektMp2) AND
     Assigned(TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektAC3) THEN
  BEGIN
    TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektPCM.EffektName := aktComboBox.Items.Strings[Index];
    TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektMp2.EffektName := aktComboBox.Items.Strings[Index];
    TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektAC3.EffektName := aktComboBox.Items.Strings[Index];
  END;   }
END;

PROCEDURE TOptionenfenster.EffektDatenEintragBearbeitenAudio(Index: Integer);
BEGIN
{  IF Assigned(aktComboBox.Items.Objects[Index]) THEN
  BEGIN
    Ausgabefenster.DialogName := EffektbearbeitenDialogName;
    Ausgabefenster.ParameterName := EffektbearbeitenParameterName;
    Ausgabefenster.aktFelder := $7F;
    EffektDatenEintragAendernAudio(Index);
    IF OptionenAlleTypenRadioButton.Checked OR
       OptionenEffektePCMRadioButton.Checked THEN
      Ausgabefenster.AusgabeDaten := TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektPCM
    ELSE
      IF OptionenEffekteMP2RadioButton.Checked THEN
        Ausgabefenster.AusgabeDaten := TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektMp2
      ELSE
        Ausgabefenster.AusgabeDaten := TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektAC3;
    Ausgabefenster.Einstellungen := TEffektAudioDaten(aktComboBox.Items.Objects[Index]).EffektEinstellungen;
    IF Ausgabefenster.ShowModal = mrOk	THEN
    BEGIN
      TEffektAudioDaten(aktComboBox.Items.Objects[Index]).EffektEinstellungen := Ausgabefenster.Einstellungen;
      IF OptionenAlleTypenRadioButton.Checked THEN
      BEGIN
        DatenKopieren(Ausgabefenster.AusgabeDaten, TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektPCM);
        DatenKopieren(Ausgabefenster.AusgabeDaten, TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektMp2);
        DatenKopieren(Ausgabefenster.AusgabeDaten, TEffektAudioDaten(aktComboBox.Items.Objects[Index]).AudioEffektAC3);
      END;
      IF Assigned(Ausgabefenster.AusgabeDaten) THEN
        aktComboBox.Items.Strings[Index] := Ausgabefenster.AusgabeDaten.EffektName;
      aktComboBox.ItemIndex := aktComboBox.Tag;
      EffektDatenEintragAendernAudio(Index);
    END;
  END;   }
END;

PROCEDURE TOptionenfenster.Effekteladen;

VAR Arbeitsumgebung : TArbeitsumgebung;

BEGIN
  Arbeitsumgebung := TArbeitsumgebung.Create;
  TRY
    Arbeitsumgebung.ApplikationsName := Application.ExeName;
    Arbeitsumgebung.Effekteladen(absolutPathAppl(VideoEffektverzEdit.Text, Application.ExeName, True), Arbeitsumgebung.VideoEffekte);
    Arbeitsumgebung.Effekteladen(absolutPathAppl(AudioEffektverzEdit.Text, Application.ExeName, True), Arbeitsumgebung.AudioEffekte);
    EffektListeneinlesen(Arbeitsumgebung);
  EXCEPT
    Arbeitsumgebung.Free;
  END;
END;

PROCEDURE TOptionenfenster.EffektvorgabeDatenEintragNeu(Index: Integer);
BEGIN
  aktComboBox.Items.Objects[Index] := TEffektEintrag.Create;
END;

PROCEDURE TOptionenfenster.EffektvorgabeDatenEintragKopieren(Index: Integer);
BEGIN
  aktComboBox.Items.Objects[Index] := EffektvorgabeDatenKopieren(TEffektEintrag(DatenZeigerComboBox));
END;

PROCEDURE TOptionenfenster.EffektvorgabeDatenBearbeitenVideo(Index: Integer);
BEGIN
  IF Assigned(aktComboBox.Items.Objects[Index]) THEN
  BEGIN
    Effektfenster.Effekte := VideoEffektComboBox.Items;
    Effektfenster.Effekt := TEffektEintrag(aktComboBox.Items.Objects[Index]);
    Effektfenster.Effektvorgabe := aktComboBox.Text;
    IF Effektfenster.ShowModal = mrOk	THEN
    BEGIN
      aktComboBox.Items[aktComboBox.Tag] := Effektfenster.Effektvorgabe;
      aktComboBox.ItemIndex := aktComboBox.Tag;
    END;
  END;
END;

PROCEDURE TOptionenfenster.EffektvorgabeDatenBearbeitenAudio(Index: Integer);
BEGIN
  IF Assigned(aktComboBox.Items.Objects[Index]) THEN
  BEGIN
    Effektfenster.Effekte := AudioEffektComboBox.Items;
    Effektfenster.Effekt := TEffektEintrag(aktComboBox.Items.Objects[Index]);
    Effektfenster.Effektvorgabe := aktComboBox.Text;
    IF Effektfenster.ShowModal = mrOk	THEN
    BEGIN
      aktComboBox.Items[aktComboBox.Tag] := Effektfenster.Effektvorgabe;
      aktComboBox.ItemIndex := aktComboBox.Tag;
    END;
  END;
END;

PROCEDURE TOptionenfenster.EffektvorgabeDateiladen;

VAR Arbeitsumgebung : TArbeitsumgebung;

BEGIN
  Arbeitsumgebung := TArbeitsumgebung.Create;
  TRY
    Arbeitsumgebung.ApplikationsName := Application.ExeName;
    Arbeitsumgebung.Effektvorgabeladen(absolutPathAppl(EffektvorgabedateiEdit.Text, Application.ExeName, False));
    EffektvorgabeListeneinlesen(Arbeitsumgebung);
  EXCEPT
    Arbeitsumgebung.Free;
  END;
END;

PROCEDURE TOptionenfenster.EffektvorgabeDateispeichern;

VAR Arbeitsumgebung : TArbeitsumgebung;

BEGIN
  Arbeitsumgebung := TArbeitsumgebung.Create;
  TRY
    Arbeitsumgebung.ApplikationsName := Application.ExeName;
    EffektvorgabeListenschreiben(Arbeitsumgebung);
    Arbeitsumgebung.Effektvorgabespeichern(absolutPathAppl(EffektvorgabedateiEdit.Text, Application.ExeName, False));
  EXCEPT
    Arbeitsumgebung.Free;
  END;
END;

// ++++++++++++++++++Ein-/Ausgabeprogramme+++++++++++++++++++++++++++++++++
{FUNCTION TOptionenfenster.AusgabeDatenkopieren(Quelle: TProgramme): TProgramme;
BEGIN
  IF Assigned(Quelle) THEN
  BEGIN
      Result := TProgramme.Create;
      DatenKopieren(Quelle.Programmdaten, Result.Programmdaten);
  END
  ELSE
    Result := NIL;
END;   }

{PROCEDURE TOptionenfenster.AusgabeListeneinlesen(Arbeitsumgebung : TArbeitsumgebung);

//VAR I : Integer;

BEGIN
  Stringliste_loeschen(DemuxerComboBox.Items);
  FOR I := 0 TO Arbeitsumgebung.DemuxerListe.Count -1 DO
    DemuxerComboBox.Items.AddObject(Arbeitsumgebung.DemuxerListe.Strings[I], AusgabeDatenkopieren(TProgramme(Arbeitsumgebung.DemuxerListe.Objects[I])));
  Stringliste_loeschen(EncoderComboBox.Items);
  FOR I := 0 TO Arbeitsumgebung.EncoderListe.Count -1 DO
    EncoderComboBox.Items.AddObject(Arbeitsumgebung.EncoderListe.Strings[I], AusgabeDatenkopieren(TProgramme(Arbeitsumgebung.EncoderListe.Objects[I])));
  Stringliste_loeschen(AusgabeComboBox.Items);
  FOR I := 0 TO Arbeitsumgebung.MuxerListe.Count -1 DO
    AusgabeComboBox.Items.AddObject(Arbeitsumgebung.MuxerListe.Strings[I], AusgabeDatenkopieren(TProgramme(Arbeitsumgebung.MuxerListe.Objects[I])));
  DemuxerComboBox.ItemIndex := Arbeitsumgebung.DemuxerIndex;
  DemuxerComboBox.Tag := Arbeitsumgebung.DemuxerIndex;
  EncoderComboBox.ItemIndex := Arbeitsumgebung.EncoderIndex;
  EncoderComboBox.Tag := Arbeitsumgebung.EncoderIndex;
  AusgabeComboBox.ItemIndex := Arbeitsumgebung.MuxerIndex;
  AusgabeComboBox.Tag := Arbeitsumgebung.MuxerIndex;  
END; }

{PROCEDURE TOptionenfenster.AusgabeListenschreiben(Arbeitsumgebung : TArbeitsumgebung);

//VAR I : Integer;

BEGIN
  IF Assigned(Arbeitsumgebung) THEN
  BEGIN
    Stringliste_loeschen(Arbeitsumgebung.DemuxerListe);
    FOR I := 0 TO DemuxerComboBox.Items.Count -1 DO
      Arbeitsumgebung.DemuxerListe.AddObject(DemuxerComboBox.Items.Strings[I], AusgabeDatenkopieren(TProgramme(DemuxerComboBox.Items.Objects[I])));
    Arbeitsumgebung.DemuxerIndex := DemuxerComboBox.Tag;
    Stringliste_loeschen(Arbeitsumgebung.EncoderListe);
    FOR I := 0 TO EncoderComboBox.Items.Count -1 DO
      Arbeitsumgebung.EncoderListe.AddObject(EncoderComboBox.Items.Strings[I], AusgabeDatenkopieren(TProgramme(EncoderComboBox.Items.Objects[I])));
    Arbeitsumgebung.EncoderIndex := EncoderComboBox.Tag;
    Stringliste_loeschen(Arbeitsumgebung.MuxerListe);
    FOR I := 0 TO AusgabeComboBox.Items.Count -1 DO
      Arbeitsumgebung.MuxerListe.AddObject(AusgabeComboBox.Items.Strings[I], AusgabeDatenkopieren(TProgramme(AusgabeComboBox.Items.Objects[I])));
    Arbeitsumgebung.MuxerIndex := AusgabeComboBox.Tag;   
  END;
END;  }

{PROCEDURE TOptionenfenster.AusgabeDatenEintragNeu(Index: Integer);
BEGIN
  aktComboBox.Items.Objects[Index] := TProgramme.Create;
  AusgabeDatenEintragAendern(Index);
END;      }

{PROCEDURE TOptionenfenster.AusgabeDatenEintragKopieren(Index: Integer);
BEGIN
  aktComboBox.Items.Objects[Index] := AusgabeDatenkopieren(TProgramme(DatenZeigerComboBox));
  AusgabeDatenEintragAendern(Index);
END; }

{PROCEDURE TOptionenfenster.AusgabeDatenEintragAendern(Index: Integer);
BEGIN
  IF Assigned(aktComboBox.Items.Objects[Index]) AND
     Assigned(TProgramme(aktComboBox.Items.Objects[Index]).Programmdaten) THEN
    TProgramme(aktComboBox.Items.Objects[Index]).Programmdaten.EffektName := aktComboBox.Items.Strings[Index];
END;  }

{PROCEDURE TOptionenfenster.AusgabeDatenEintragBearbeiten(Index: Integer);
BEGIN
  IF Assigned(aktComboBox.Items.Objects[Index]) THEN
  BEGIN
    AusgabeDatenEintragAendern(Index);
    Ausgabefenster.DialogName := MuxerbearbeitenDialogName;
    Ausgabefenster.ParameterName := MuxerbearbeitenParameterName;
    Ausgabefenster.aktFelder := $3F;
    Ausgabefenster.AusgabeDaten := TProgramme(aktComboBox.Items.Objects[Index]).Programmdaten;
    Ausgabefenster.Einstellungen := '';
    IF Ausgabefenster.ShowModal = mrOk	THEN
    BEGIN
      IF Assigned(Ausgabefenster.AusgabeDaten) THEN
        aktComboBox.Items.Strings[Index] := Ausgabefenster.AusgabeDaten.EffektName;
      aktComboBox.ItemIndex := aktComboBox.Tag;
      IF aktComboBox.Tag > -1 THEN
        aktComboBox.Text := aktComboBox.Items.Strings[Index];
    END;
  END;
END; }

{PROCEDURE TOptionenfenster.AusgabeDateiladen;

//VAR Arbeitsumgebung : TArbeitsumgebung;

BEGIN
  Arbeitsumgebung := TArbeitsumgebung.Create;
  TRY
    Arbeitsumgebung.ApplikationsName := Application.ExeName;
    Arbeitsumgebung.ExterneProgrammeladen(absolutPathAppl(AusgabedateiEdit.Text, Application.ExeName, False));
    AusgabeListeneinlesen(Arbeitsumgebung);
  EXCEPT
    Arbeitsumgebung.Free;
  END;
END;   }

{PROCEDURE TOptionenfenster.AusgabeDateispeichern;

//VAR Arbeitsumgebung : TArbeitsumgebung;

BEGIN
  Arbeitsumgebung := TArbeitsumgebung.Create;
  TRY
    Arbeitsumgebung.ApplikationsName := Application.ExeName;
    AusgabeListenschreiben(Arbeitsumgebung);
    Arbeitsumgebung.ExterneProgrammespeichern(absolutPathAppl(AusgabedateiEdit.Text, Application.ExeName, False));
  EXCEPT
    Arbeitsumgebung.Free;
  END;
END;    }

PROCEDURE TOptionenfenster.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Titel := Wortlesen(Spracheladen, 'OptionenFenster', Caption);
  FOR I := 0 TO ComponentCount - 1 DO
  BEGIN
    Komponente := Components[I];
    IF Komponente IS TButton THEN             // in der Unit StdCtrls
    BEGIN
      TButton(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TButton(Komponente).Caption);
      TButton(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TButton(Komponente).Hint);
    END;
    IF Komponente IS TBitBtn THEN             // in der Unit Buttons
    BEGIN
      TBitBtn(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TBitBtn(Komponente).Caption);
      TBitBtn(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TBitBtn(Komponente).Hint);
    END;
    IF Komponente IS TCheckBox THEN           // in der Unit StdCtrls
    BEGIN
      TCheckBox(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TCheckBox(Komponente).Caption);
      TCheckBox(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TCheckBox(Komponente).Hint);
    END;
    IF Komponente IS TRadioButton THEN
    BEGIN
      TRadioButton(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TRadioButton(Komponente).Caption);
      TRadioButton(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TRadioButton(Komponente).Hint);
    END;
    IF Komponente IS TLabel THEN              // in der Unit StdCtrls
    BEGIN
      TLabel(Komponente).Caption := Wortlesen(Spracheladen, Komponentenname(Komponente), TLabel(Komponente).Caption);
      TLabel(Komponente).Hint := Wortlesen(Spracheladen, Komponentenname(Komponente) + '_Hint', TLabel(Komponente).Hint);
    END;
    IF Komponente IS TMenuItem THEN           // in der Unit Menus
      IF Komponente.Name <> '' THEN
      BEGIN
        TMenuItem(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TMenuItem(Komponente).Caption);
        TMenuItem(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TMenuItem(Komponente).Hint);
      END;
    IF Komponente IS TGroupBox THEN           // in der Unit StdCtrls
    BEGIN
      TGroupBox(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TGroupBox(Komponente).Caption);
      TGroupBox(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TGroupBox(Komponente).Hint);
    END;
    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      TTabSheet(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TTabSheet(Komponente).Caption);
      TTabSheet(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TTabSheet(Komponente).Hint);
    END;
  END;
  EffektbearbeitenDialogName := Wortlesen(Spracheladen, 'AusgabeEffekt_bearbeiten', 'Effekt bearbeiten');
  EffektbearbeitenParameterName := Wortlesen(Spracheladen, 'AusgabeEffektParameter', 'Parameter:');
  DemuxerbearbeitenDialogName := Wortlesen(Spracheladen, 'AusgabeDemuxer_bearbeiten', 'Demuxer bearbeiten');
  DemuxerbearbeitenParameterName := Wortlesen(Spracheladen, 'AusgabeDemuxerParameter', 'Zieldateiname:');
  EncoderbearbeitenDialogName := Wortlesen(Spracheladen, 'AusgabeEncoder_bearbeiten', 'Encoder bearbeiten');
  EncoderbearbeitenParameterName := Wortlesen(Spracheladen, 'AusgabeEncoderParameter', 'Parameter:');
  MuxerbearbeitenDialogName := Wortlesen(Spracheladen, 'AusgabeMuxer_bearbeiten', 'Muxer bearbeiten');
  MuxerbearbeitenParameterName := Wortlesen(Spracheladen, 'AusgabeMuxerParameter', 'Zieldateiname:');
  neuerEintrag := Wortlesen(Spracheladen, 'Ausgabeneuer_Eintrag', 'neuer Eintrag');
  Kopievon := Wortlesen(Spracheladen, 'AusgabeKopie_von', 'Kopie von');
  WITH TastenbelegungGrid DO
  BEGIN
    Cells[0,  0] := Wortlesen(Spracheladen, 'Tastenfunktion', 'Tastenfunktion');
    Cells[1,  0] := Wortlesen(Spracheladen, 'Tastenname', 'Tastenname');
    Cells[0,  1] := Wortlesen(Spracheladen, 'TasteSchrittweite1', 'Taste für Schrittweite 1');
    Cells[0,  2] := Wortlesen(Spracheladen, 'TasteSchrittweite2', 'Taste für Schrittweite 2');
    Cells[0,  3] := Wortlesen(Spracheladen, 'TasteSchrittweite3', 'Taste für Schrittweite 3');
    Cells[0,  4] := Wortlesen(Spracheladen, 'TasteSchrittweite4', 'Taste für Schrittweite 4');
    Cells[0,  5] := Wortlesen(Spracheladen, 'ZusatztasteIn', 'Zusatztaste für In');
    Cells[0,  6] := Wortlesen(Spracheladen, 'ZusatztasteOut', 'Zusatztaste für Out');
    Cells[0,  7] := Wortlesen(Spracheladen, 'TastePlay/Pause', 'Play / Pause');
    Cells[0,  8] := Wortlesen(Spracheladen, 'TasteStop', 'Stop');
    Cells[0,  9] := Wortlesen(Spracheladen, 'ab_akt_Position', 'ab akt. Position abspielen');
    Cells[0, 10] := Wortlesen(Spracheladen, 'bis_akt_Position', 'bis akt. Position abspielen');
    Cells[0, 11] := Wortlesen(Spracheladen, 'nächstesBild', 'nächstes Bild');
    Cells[0, 12] := Wortlesen(Spracheladen, 'vorheriges Bild', 'vorheriges Bild');
    Cells[0, 13] := Wortlesen(Spracheladen, 'nächstesIn-Bild', 'nächstes In-Bild');
    Cells[0, 14] := Wortlesen(Spracheladen, 'vorherigesIn-Bild', 'vorheriges In-Bild');
    Cells[0, 15] := Wortlesen(Spracheladen, 'nächstesOut-Bild', 'nächstes Out-Bild');
    Cells[0, 16] := Wortlesen(Spracheladen, 'vorherigesOut-Bild', 'vorheriges Out-Bild');
    Cells[0, 17] := Wortlesen(Spracheladen, 'springe_zum_In', 'springe zum In');
    Cells[0, 18] := Wortlesen(Spracheladen, 'springe_zum_Out', 'springe zum Out');
    Cells[0, 19] := Wortlesen(Spracheladen, 'springe_zum_Anfang', 'springe zum Anfang');
    Cells[0, 20] := Wortlesen(Spracheladen, 'springe_zum_Ende', 'springe zum Ende');
    Cells[0, 21] := Wortlesen(Spracheladen, 'In_übernehmen', 'In übernehmen');
    Cells[0, 22] := Wortlesen(Spracheladen, 'Out_übernehmen', 'Out übernehmen');
    Cells[0, 23] := Wortlesen(Spracheladen, 'TasteÄndern', 'Ändern');
    Cells[0, 24] := Wortlesen(Spracheladen, 'TasteNeu', 'Neu');
    Cells[0, 25] := Wortlesen(Spracheladen, 'TasteSchneiden', 'Schneiden');
    Cells[0, 26] := Wortlesen(Spracheladen, 'TasteKapitel', 'Kapitel');
    Cells[0, 27] := Wortlesen(Spracheladen, 'TasteVorschau', 'Vorschau');
    Cells[0, 28] := Wortlesen(Spracheladen, 'Video/Audio_öffnen', 'Video / Audio öffnen');
    Cells[0, 29] := Wortlesen(Spracheladen, 'Audio_einfügen', 'Audio einfügen');
    Cells[0, 30] := Wortlesen(Spracheladen, 'Projekt_neu', 'Projekt neu');
    Cells[0, 31] := Wortlesen(Spracheladen, 'Projekt_laden', 'Projekt laden');
    Cells[0, 32] := Wortlesen(Spracheladen, 'Projekt_speichern', 'Projekt speichern');
    Cells[0, 33] := Wortlesen(Spracheladen, 'Projekt_speichern_unter', 'Projekt speichern unter');
    Cells[0, 34] := Wortlesen(Spracheladen, 'Programm_Ende', 'Programm Ende');
    Cells[0, 35] := Wortlesen(Spracheladen, 'Schnittpunkt_einzeln', 'Schnittpunkt einzeln (Option)');
    Cells[0, 36] := Wortlesen(Spracheladen, 'makierte_Schnittpunkte', 'makierte Schnittpunkte (Option)');
    Cells[0, 37] := Wortlesen(Spracheladen, 'nurAudio_speichern', 'nur Audio speichern (Option)');
    Cells[0, 38] := Wortlesen(Spracheladen, 'TasteMarke', 'Marke');
    Cells[0, 39] := Wortlesen(Spracheladen, 'Video_ein/aus', 'Video ein/aus');
    Cells[0, 40] := Wortlesen(Spracheladen, 'nur_I-Frames', 'nur I-Frames abspielen');
    Cells[0, 41] := Wortlesen(Spracheladen, 'ScrollAudiooffset', 'Audiooffset scrollen');
    Cells[0, 42] := Wortlesen(Spracheladen, 'ScrollTempo', 'Geschwindigkeit scrollen');
    Cells[0, 43] := Wortlesen(Spracheladen, 'Infoaktualisieren', 'Infofenster aktualisieren');
    Cells[0, 44] := Wortlesen(Spracheladen, 'binaereSucheWerbung', 'binäre Suche Werbung');
    Cells[0, 45] := Wortlesen(Spracheladen, 'binaereSucheFilm', 'binäre Suche Film');
    Cells[0, 46] := Wortlesen(Spracheladen, 'SchnittlisteZeitanzeige', 'Schnittliste Zeitanzeige umschalten');
    Col := 1;
  END;
  BitrateersterHeaderComboBox.Items[0] := Wortlesen(Spracheladen, 'nichtaendern', 'nicht ändern');
  BitrateersterHeaderComboBox.Items[1] := Wortlesen(Spracheladen, 'vomOrginal', 'vom Orginal');
  BitrateersterHeaderComboBox.Items[2] := Wortlesen(Spracheladen, 'durchschnittlich', 'durchschnl.');
  BitrateersterHeaderComboBox.Items[3] := Wortlesen(Spracheladen, 'maximale', 'maximale');
  BitrateersterHeaderComboBox.Items[4] := Wortlesen(Spracheladen, 'festeBitrate', 'feste Bitrate');
  AspectratioersterHeaderComboBox.Items[0] := Wortlesen(Spracheladen, 'ARnichtaendern', 'Aspectratio nicht ändern');
  AspectratioersterHeaderComboBox.Items[1] := Wortlesen(Spracheladen, 'ARvomOrginal', 'Aspectratio vom Orginal');
  AspectratioersterHeaderComboBox.Items[2] := Wortlesen(Spracheladen, 'Aspectratio1/1', 'Aspectratio 1/1');
  AspectratioersterHeaderComboBox.Items[3] := Wortlesen(Spracheladen, 'Aspectratio3/4', 'Aspectratio 3/4');
  AspectratioersterHeaderComboBox.Items[4] := Wortlesen(Spracheladen, 'Aspectratio9/16', 'Aspectratio 9/16');
  AspectratioersterHeaderComboBox.Items[5] := Wortlesen(Spracheladen, 'Aspectratio1/2,21', 'Aspectratio 1/2,21');
  AspectratioersterHeaderComboBox.Items[6] := Wortlesen(Spracheladen, 'Aspectrationach', 'Aspectratio nach');
  SchnittFormatEinfuegenComboBox.Items[0] := Wortlesen(Spracheladen, 'vorMarkierung', 'vor der Markierung');
  SchnittFormatEinfuegenComboBox.Items[1] := Wortlesen(Spracheladen, 'nachMarkierung', 'nach der Markierung');
  SchnittFormatEinfuegenComboBox.Items[2] := Wortlesen(Spracheladen, 'amEnde', 'am Ende');
//  SchnittFormatEinfuegenComboBox.Items[3] := Wortlesen(Spracheladen, 'ändern', 'ändern');
  KapitelFormatEinfuegenComboBox.Items[0] := Wortlesen(Spracheladen, 'vorMarkierung', 'vor der Markierung');
  KapitelFormatEinfuegenComboBox.Items[1] := Wortlesen(Spracheladen, 'nachMarkierung', 'nach der Markierung');
  KapitelFormatEinfuegenComboBox.Items[2] := Wortlesen(Spracheladen, 'amEnde', 'am Ende');
//  KapitelFormatEinfuegenComboBox.Items[3] := Wortlesen(Spracheladen, 'ändern', 'ändern');
  MarkenFormatEinfuegenComboBox.Items[0] := Wortlesen(Spracheladen, 'vorMarkierung', 'vor der Markierung');
  MarkenFormatEinfuegenComboBox.Items[1] := Wortlesen(Spracheladen, 'nachMarkierung', 'nach der Markierung');
  MarkenFormatEinfuegenComboBox.Items[2] := Wortlesen(Spracheladen, 'amEnde', 'am Ende');
//  MarkenFormatEinfuegenComboBox.Items[3] := Wortlesen(Spracheladen, 'ändern', 'ändern');
END;

end.
