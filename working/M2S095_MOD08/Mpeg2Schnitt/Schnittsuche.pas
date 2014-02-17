{-----------------------------------------------------------------------------------
Diese Unit implementiert verschiedene Algorithmen mit dem Ziel in dvb-Aufnahmen
automatisch die eigentliche(n) Sendung(en) zu erkennen. (Ueberspringen von Werbebloecken)

Copyright (C) 2004  Igor Feldhaus
 Homepage: n/a
 E-Mail:   igor.feldhaus@gmx.net

Es gelten die Lizenzbestimmungen von Mpeg2Schnitt.

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

--------------------------------------------------------------------------------------

Funktionsweise der Algorithmen:
  Audioschnittsuche:
    Bei einigen Sendern tauchen an den relevanten Schnittpunkten
    (Übergang zwischen Werbung und Sendung) binär identische Audioframes auf.
    Diese werden durch Binärvergleich mit einem dieser zuvor gespeicherten Frames gesucht.
  Videoschnittsuche:
    Letterboxed Video (schwarze Balken)
      Die Farbe Schwarz hat einen sehr niedrigen Farb-/Grauwert. Ist das Mittel für
      eine(n) Zeile/Spalte/Bereich unter einem bestimmten Wert, so wird diese(r)
      als schwarz erkannt.
    Pixelvergleiche (Logoerkennung)
      Funktioniert nach dem gleichen Prinzip wie die Letterboxed-Suche, nur das hier gezielt
      einzelne Pixel untersucht werden. Bei farbigen Logos liegen einzelne Pixel des Logos
      für alle Einzelbilder die das Logo enthalten in einem bestimmten Farbintervall.
      Pixel von alphatransparenten Logos haben zumindest einen Minimalwert, der für alle
      Einzelbilder überschritten wird, die das Logo enthalten.
    Aus Performanzgründen werden die zu untersuchenden Einzelbilder grau dekodiert.
    Es ist also von Farb-/Grauwerten zwischen 0 und 255 auszugehen.
  Erklärung einiger Parameter:
    minimale Schnittlänge: muss von einem, als Teil der Sendung erkannten, Bereichs
                           überschritten sein, um akzeptiert zu werden. (Ausschliessen
                           von Zufallstreffern in Werbeblöcken).
    Schrittweite:          Das Dekodieren der Einzelbilder ist sehr zeitaufwendig,
                           deshalb wird nach jedem untersuchten Bild im Video um diesen
                           Wert vorgesprungen.
    IN/OUT-Korrektur:      Die gefundenen Schnitte können über diese Parameter automatisch
                           nachkorregiert werden.
    invertierte Suche:     Kehrt das Ergebnis der Einzelbilduntersuchung um. In Kombination
                           mit einer sehr niedrigen Schrittweite und entsprechenden Korrektur-
                           werten, lassen sich z.B. bei einigen Musiksendern anhand von Titel-
                           einblendungen Musikvideos relativ genau erkennen.

Zu übergebende Parameter:
 Schnittliste       // eine (leere) Liste vom Typ TListe zum Zurückgeben der Suchergebnisse
 BilderProsek       // Framerate des Videos zur Umrechnung zwischen Bildnummern und Zeiten
 Indexliste, Liste  // Listen von Martin Dienert's IndexSystem zur gezielten Navigation im Video
 Audiodateiname     // (nur Audioschnittsuche), absoluter Pfad der zu untersuchenden Audiodatei

 Eine zu untersuchende Audiodatei muss freigegeben sein.
 Auf Video wird über die Unit Mpeg2Decoder zugegriffen. Hier muss das zu untersuchende Video
 geöffnet sein, der Dekoder auf VideoFormatGray8 (Y Plane) stehen und das aktuelle Bild in diesem Format
 abrufbar sein. (Zum Überprüfen von Werten im aktuellen Bild)
}
unit Schnittsuche;
  {$IFDEF MSWINDOWS}
    {$UNDEF LINUX}
  {$ENDIF}

interface

uses
  SysUtils, Variants, Classes,
  {$IFDEF LINUX}
  QGraphics, QControls, QForms,  QDialogs, QStdCtrls,
  QMenus, QExtCtrls, QComCtrls, QTypes,
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  Graphics, Forms, Dialogs, Menus, Controls, ExtCtrls, StdCtrls, ComCtrls,
  {$ENDIF}
  IniFiles,
  DateUtils,
  Types,
  Mpeg2Unit,             // Für TMpegAudio
  Mpeg2Decoder,
  Mpeg2Decoder2,
  Fortschritt,
  DateiPuffer,           // einlesen der Vergleichsframes
  Sprachen,              // ändern der Sprache
  AllgFunktionen,        // Meldungsfenster
  AllgVariablen,         // Programmeinstellungen
  DatenTypen;            // Typdefinitionen

const
  KEIN_FEHLER  = 0;
  KEIN_DECODER  = 1;

type

  TProfil = CLASS
    INkorr : Integer;
    OUTkorr : Integer;
    Laenge : Integer;
    Schrittweite: Integer;
    Invertiert : Boolean;
    MinGrau : Byte;
    MaxGrau : Byte;
    zeilenignorieren:integer;
    spaltenignorieren:integer;
    Suchbereich:Byte;
    Suchbereichswert:Integer;
    Verfeinern:byte;
    Name : String;
    INframe : String;
    OUTframe : String;
    CONSTRUCTOR Create;
  END;

  TvglPixel = CLASS
    posX : Integer;
    posY : Integer;
    minGrau : byte;
    maxGrau : byte;
    CONSTRUCTOR Create;
  END;

  TAudioFrame = CLASS
    Pos : Int64;
    FrameNum : Integer;
    Anzahl : Integer;
    Framelaenge : Integer;
  END;

  TSchnittsucheFenster = class(TForm)
    PageControl: TPageControl;
    Framevergleiche: TTabSheet;
      Audio_INKorrektur_: TLabel;
      Audio_Bilder2_: TLabel;
      Audio_Minuten_: TLabel;
      Audio_Schnittlaenge_: TLabel;
      Audio_Bilder1_: TLabel;
      Audio_OUTKorrektur_: TLabel;
      Audio_SuchProfile_: TLabel;
      Audio_ProfilName_: TLabel;
      Audio_vglIN_: TLabel;
      Audio_vglOUT_: TLabel;
      Audio_INkorrektur: TEdit;
      Audio_OUTkorrektur: TEdit;
      Audio_Laenge: TEdit;
      Audio_Abbrechen: TButton;
      Audio_Suchen: TButton;
      Audio_ProfilListe: TListBox;
      Audio_Profilname: TEdit;
      Audio_frameINdatei: TEdit;
      Audio_frameOUTdatei: TEdit;
      Audio_ProfilMenue: TPopupMenu;
      AudioMenue_Loeschen: TMenuItem;
      AudioMenue_Aendern: TMenuItem;
      AudioMenue_Neu: TMenuItem;
      Audio_Aendernbtn: TButton;
      Audio_neubtn: TButton;
      Audio_Analysieren: TButton;
    Letterboxed: TTabSheet;
      Letterboxed_ZeilenIgnorieren_: TLabel;
      Letterboxed_SpaltenIgnorieren_: TLabel;
      Letterboxed_MinGrau_: TLabel;
      Letterboxed_MaxGrau_: TLabel;
      Letterboxed_Schnittlaenge_: TLabel;
      Letterboxed_Schrittweite_: TLabel;
      Letterboxed_INkorrektur_: TLabel;
      Letterboxed_OUTkorrektur_: TLabel;
      Letterboxed_Sekunden1_: TLabel;
      Letterboxed_Sekunden2_: TLabel;
      Letterboxed_Bilder1_: TLabel;
      Letterboxed_Bilder2_: TLabel;
      Letterboxed_Analysebereich_: TLabel;
      Letterboxed_Profilname_: TLabel;
      Letterboxed_SuchProfile_: TLabel;
      Letterboxed_Suchen: TButton;
      Letterboxed_Abbrechen: TButton;
      Letterboxed_ZeilenOben: TEdit;
      Letterboxed_ZeilenUnten: TEdit;
      Letterboxed_SpaltenLinks: TEdit;
      Letterboxed_SpaltenRechts: TEdit;
      Letterboxed_ZeilenIgnorieren: TEdit;
      Letterboxed_MaxGrau: TEdit;
      Letterboxed_MinGrau: TEdit;
      Letterboxed_Analysieren: TButton;
      Letterboxed_SpaltenIgnorieren: TEdit;
      Letterboxed_Schnittlaenge: TEdit;
      Letterboxed_Schrittweite: TEdit;
      Letterboxed_INkorrektur: TEdit;
      Letterboxed_OUTkorrektur: TEdit;
      Letterboxed_invertiert: TCheckBox;
      rb_oben: TRadioButton;
      rb_unten: TRadioButton;
      rb_links: TRadioButton;
      rb_rechts: TRadioButton;
      Letterboxed_Profilliste: TListBox;
      Letterboxed_AendernBtn: TButton;
      Letterboxed_NeuBtn: TButton;
      Letterboxed_Profilname: TEdit;
      Letterboxed_ProfilListeMenue: TPopupMenu;
      LetterboxedMenue_Loeschen: TMenuItem;
      LetterboxedMenue_Aendern: TMenuItem;
      LetterboxedMenue_Neu: TMenuItem;
    Logo: TTabSheet;
      Logo_Suchprofile_: TLabel;
      Logo_vglPixel_: TLabel;
      Logo_ProfilName_: TLabel;
      Logo_Min_: TLabel;
      Logo_PosY_: TLabel;
      Logo_PosX_: TLabel;
      Logo_Max_: TLabel;
      Logo_INkorrektur_: TLabel;
      Logo_OUTkorrektur_: TLabel;
      Logo_Schnittlaenge_: TLabel;
      Logo_Schrittweite_: TLabel;
      Logo_Sekunden1_: TLabel;
      Logo_Sekunden2_: TLabel;
      Logo_Bilder1_: TLabel;
      Logo_Bilder2_: TLabel;
      Logo_Profilliste: TListBox;
      Logo_PixelListe: TListBox;
      Logo_suchen: TButton;
      Logo_Abbrechen: TButton;
      Logo_posy: TEdit;
      Logo_posx: TEdit;
      Logo_Profilname: TEdit;
      Logo_Neu: TButton;
      Logo_PixelListeMenue: TPopupMenu;
      LogoPixelMenue_Loeschen: TMenuItem;
      LogoPixelMenue_Aendern: TMenuItem;
      LogoPixelMenue_Neu: TMenuItem;
      LogoMenue_Loeschen: TMenuItem;
      LogoMenue_Aendern: TMenuItem;
      LogoMenue_Neu: TMenuItem;
      LogoPixelMenue_ListeLeeren: TMenuItem;
      N1: TMenuItem;
      logo_ProfilListeMenue: TPopupMenu;
      Logo_Farbwert: TButton;
      Logo_len: TEdit;
      Logo_seek: TEdit;
      Logo_Invertiert: TCheckBox;
      Logo_Aendern: TButton;
      LogoProfil_Aendern: TButton;
      LogoProfil_neu: TButton;
      Logo_mingrau: TEdit;
      Logo_maxgrau: TEdit;
      Logo_INkorrektur: TEdit;
      Logo_OUTkorrektur: TEdit;
      Logo_Profile_testen: TButton;
    AudioAnalyse: TTabSheet;
      Analyse_datei1: TEdit;
      Analyse_datei2: TEdit;
      Analyse_Ergebnisliste_: TLabel;
      Analyse_Ergebnisliste2_: TLabel;
      Analyse_Zurueck: TButton;
      Analyse_Ergebnisliste: TListBox;
      Analyse_Suchen: TButton;
      Analyse_Datei1_: TLabel;
      Analyse_Datei2_: TLabel;
      Analyse_Abbrechenbtn: TButton;
      Analyse_Menu: TPopupMenu;
      Analyse_ListeLeeren: TMenuItem;
      N2: TMenuItem;
      Analyse_speichern: TMenuItem;

    DateiSpeichernDialog: TSaveDialog;
    DateiLadenDialog: TOpenDialog;
    Logo_Verfeinern_: TLabel;
    logo_verf_lin: TRadioButton;
    logo_verf_bin: TRadioButton;
    logo_verf_aus: TRadioButton;
    lb_verf_panel: TPanel;
    lb_verf_lin: TRadioButton;
    lb_verf_bin: TRadioButton;
    lb_verf_aus: TRadioButton;
    lb_verfeinern_: TLabel;
    SliceInfo1: TMenuItem;
    Analyse_Ergebnisliste3_: TLabel;

    procedure Audio_AbbrechenClick(Sender: TObject);
    procedure Audio_SuchenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SuchProfileSelect(Sender: TObject);
    procedure WertePruefen(Sender: TObject);
    procedure LogoWertePruefen(Sender: TObject);
    procedure LogoProfileWertePruefen(Sender: TObject);
    procedure LetterboxedWertePruefen(Sender: TObject);
    procedure AnalyseWertePruefen(Sender: TObject);
    procedure ProfileSpeichern();
    procedure ProfileLaden();
    FUNCTION Schnittpunktesuchen(MpegAudio : TMpegAudio; Liste: TListe;
                                 vergleichsdatenIN,vergleichsdatenOUT: Array of Byte;
                                 Schnittlaenge, INkorr, OUTkorr: Integer): boolean;
    procedure AudioMenue_LoeschenClick(Sender: TObject);
    procedure AudioMenue_AendernClick(Sender: TObject);
    procedure AudioMenue_NeuClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vglFrameINClick(Sender: TObject);
    procedure vglFrameOUTClick(Sender: TObject);
    procedure sucheImVideo(SuchTyp:byte);
    function  pruefeLetterboxed():boolean;
    function  pruefeLetterboxedObenUnten():boolean;
    function  pruefeLetterboxedLinksRechts():boolean;
    function  pruefeLogo():boolean;
    function  pruefeLogo2():boolean;
    function  verfeinereIN(bildnr:dword; SuchTyp: byte):Integer;
    function  verfeinereINlinear(bildnr:dword; suchtyp:byte):Integer;
    function  verfeinereINbinaer(bildnr:dword; suchtyp:byte):Integer;
    function  verfeinereOUT(bildnr:dword;SuchTyp: byte):Integer;
    function  verfeinereOUTlinear(bildnr:dword;SuchTyp: byte):Integer;
    function  verfeinereOUTbinaer(bildnr:dword;SuchTyp: byte):Integer;
    procedure ZeilenErmitteln();
    procedure SpaltenErmitteln();
    procedure Letterboxed_SuchenClick(Sender: TObject);
    procedure Logo_suchenClick(Sender: TObject);
    procedure Logo_PixelListeDblClick(Sender: TObject);
    procedure Logo_NeuClick(Sender: TObject);
    procedure Logo_AendernClick(Sender: TObject);
    procedure LogoPixelMenue_LoeschenClick(Sender: TObject);
    procedure LogoProfil_neuClick(Sender: TObject);
    procedure Logo_ProfillisteDblClick(Sender: TObject);
    procedure logoProfil_LoeschenClick(Sender: TObject);
    procedure Logo_FarbwertClick(Sender: TObject);
    function  strToVglPixel(s : String):TvglPixel;
    function  VglPixelToStr(Pixel: TvglPixel):String;
    procedure LogoPixelMenue_ListeLeerenClick(Sender: TObject);
    procedure LogoProfil_AendernClick(Sender: TObject);
    PROCEDURE SortiereArray ();
    procedure Audio_AnalysierenClick(Sender: TObject);
    procedure Analyse_ZurueckClick(Sender: TObject);
    procedure Letterboxed_AnalysierenClick(Sender: TObject);
    procedure Letterboxed_ZeilenObenClick(Sender: TObject);
    procedure Letterboxed_ZeilenUntenClick(Sender: TObject);
    procedure Letterboxed_SpaltenLinksClick(Sender: TObject);
    procedure Letterboxed_SpaltenRechtsClick(Sender: TObject);
    procedure Letterboxed_NeuBtnClick(Sender: TObject);
    procedure Letterboxed_AendernBtnClick(Sender: TObject);
    procedure LetterboxedMenue_LoeschenClick(Sender: TObject);
    procedure Letterboxed_ProfillisteDblClick(Sender: TObject);
    procedure SeitenAnordnen(audioAktiv: boolean);
    procedure Analyse_datei1Click(Sender: TObject);
    procedure Analyse_datei2Click(Sender: TObject);
    procedure Analyse_SuchenClick(Sender: TObject);
    procedure Logo_ProfillisteStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure Logo_ProfillisteDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Logo_ProfillisteDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure Logo_ProfillisteEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure Logo_ProfillisteMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Letterboxed_ProfillisteStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure Letterboxed_ProfillisteDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure Letterboxed_ProfillisteDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Letterboxed_ProfillisteEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure Letterboxed_ProfillisteMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Audio_ProfilListeStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure Audio_ProfilListeDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Audio_ProfilListeDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure Audio_ProfilListeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Audio_ProfilListeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Logo_Profile_testenClick(Sender: TObject);
    procedure AudioAnalyse_ErgebnisAuswerten(Liste : Tliste; framelaenge : Integer);
    procedure Analyse_ListeLeerenClick(Sender: TObject);
    procedure Analyse_speichernClick(Sender: TObject);
    procedure SliceInfo1Click(Sender: TObject);
    procedure Logo_ProfillisteMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Letterboxed_ProfillisteMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Audio_ProfilListeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    Function sucheAehnlichesBild(Referenzbild : pbytearray; StartBild, BildAnzahl:Integer):Integer;
    Function VergleicheBilder(ReferenzBild,Bild:pbytearray):boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function Starten():byte;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
    LetterBoxed_Anzahl:Integer;
    seek,len:Integer;
    verfeinern:byte;
    invertiert:boolean; // Suchbedingung invertieren
    korrigiereIN,korrigiereOUT:Integer;
    bildinfo:Mpeg2Decoder.TBildeigenschaften;
    minGrau : byte;
    maxGrau : byte;
    Letterboxed_StartPosition : Integer;
    letterboxed_obenunten:boolean;
    Profilbewegen,
    ProfilbewegenCount : Integer;
    Logo_Profilliste_itemindex : Integer;
    Letterboxed_Profilliste_itemindex : Integer;
    Audio_ProfilListe_itemindex : Integer;
    Fehler:byte;
    aktuellesBild:pbytearray;
    PROCEDURE deleteSelected(var Listbox : TListbox);
  public
    { Public declarations }
    AudiodateiName : PChar;//String; // TDateieintragAudio(Knoten.Data).Name;
    VideodateiName : PChar;//String; // TDateieintrag(Knoten.Data).Name;
    Schnittliste: TListe;
    BilderProsek : Real;     // BilderProsek;
    IndexListe : TListe;
    Liste:Tliste;
    DecoderVorhanden : boolean;
    AktuelleBildnummer:integer;
    InitDir : String;
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
SchnittsucheFenster: TSchnittsucheFenster;
Profile : Array of Array[0..2] of Integer;
LogoDaten : Array of Array[0..2] of Integer;

implementation

CONSTRUCTOR TProfil.Create;
BEGIN
  INHERITED Create;
  INkorr :=0;
  OUTkorr := 0;
  Laenge:=1;
  Name:='';
  Schrittweite:=10;
  Invertiert:=false;
  MinGrau :=0;
  MaxGrau :=25;
  zeilenignorieren:=0;
  spaltenignorieren:=0;
  Suchbereich:=1;
  Suchbereichswert:=16;
  Verfeinern:=1;
END;

CONSTRUCTOR TvglPixel.Create;
BEGIN
  INHERITED Create;
    posX :=0;
    posY :=0;
    minGrau :=0;
    maxGrau :=255;
END;

{$IFDEF LINUX}
  {$R *.xfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
  {$R *.dfm}
{$ENDIF}

PROCEDURE TSchnittsucheFenster.deleteSelected(var Listbox : TListbox);
VAR x:integer;
    ba:array of boolean;
BEGIN
  x:=Listbox.Items.Count-1;
  setLength(ba,x+1);
  while (x>=0) do
  begin
    if Listbox.Selected[x] then
      ba[x]:=true
    else
      ba[x]:=false;
    dec(x);
  end;
  x:=Listbox.Items.Count-1;
  while (x>=0) do
  begin
    if ba[x] then
      Listbox.Items.Delete(x);
    dec(x);
  end;
END;

function TSchnittsucheFenster.sucheAehnlichesBild(Referenzbild : pbytearray; StartBild, BildAnzahl:Integer):Integer;
VAR bild:pbytearray;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
    I : Integer;
    Anhalten:boolean;
    Bildinfo2: Mpeg2Decoder2.TBildeigenschaften;
BEGIN
  Anhalten:=false;
  if bildanzahl > Indexliste.Count then
    bildanzahl := Indexliste.Count-StartBild;
  if StartBild >= Indexliste.Count then
    result:=-2
  else
  begin
    Fortschrittsfenster.Endwert := bildanzahl;
    Fortschrittsfenster.Textanzeige(5, '');
    Fortschrittsfenster.Show;
    result:=-1;
    i:=StartBild;
    If Mpeg2Decoder2.Mpeg2Decoder_OK then
    begin
      Mpeg2Decoder2.getMpeg2FrameInfo(bildinfo2);
      bildinfo.breite:=bildinfo2.breite;
      bildinfo.hoehe:=bildinfo2.hoehe;
    end
    else
      Mpeg2Decoder.getMpeg2FrameInfo(bildinfo);
  // Ersten I-Frame in den VergleichsBildern Suchen
    WHILE (I < bildanzahl+StartBild) AND (Anhalten=false) DO
    BEGIN
      Anhalten:=Fortschrittsfenster.Fortschrittsanzeige(i-StartBild);
      IndexListenpunkt := IndexListe.Items[I];
      if not(IndexListenpunkt.BildTyp = 1)THEN
        inc(I)
      else
      begin
        Listenpunkt := Liste[IndexListenpunkt.BildIndex];
        if Mpeg2Decoder2.Mpeg2Decoder_OK then
          Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
        else
          Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
        Anhalten:=true;
      end;
    END;
    Anhalten:=false;
    WHILE (I < bildanzahl+StartBild) AND (Anhalten=false) AND (result<0) DO
    BEGIN
      Anhalten:=Fortschrittsfenster.Fortschrittsanzeige(i-StartBild);
      if Mpeg2Decoder2.Mpeg2Decoder_OK then
        Bild:=Mpeg2Decoder2.getMpeg2Frame
      else
        Bild:=Mpeg2Decoder.getMpeg2Frame;
//      showmessage(inttostr(I));
      if VergleicheBilder(ReferenzBild,Bild) then
        result:=I
      else
        inc(i);
    END;
  END;
  Fortschrittsfenster.hide();
end;

function TSchnittsucheFenster.VergleicheBilder(ReferenzBild,Bild:pbytearray):boolean;
VAR  p1,p2:pbyte;
     i, AehnlichePixel:Integer;
     x:int64;
begin
  AehnlichePixel:=0;
  p1:=Pointer(Bild);
  p2:=Pointer(ReferenzBild);
  i:=0;
  x:=0;
  while i < bildinfo.hoehe*bildinfo.breite do
  begin
    if abs(p1^-p2^)<10 then //die Helligkeit darf um 10 abweichen
      inc(AehnlichePixel);
    inc(i);
    inc(x,p1^);
    inc(p1);
    inc(p2);
  end; // 80% der Pixel muessen aehnlich sein
//  showmessage(inttostr(x));
  if ((bildinfo.hoehe*bildinfo.breite)*9) < (AehnlichePixel*10) then
//  if(AehnlichePixel=(bildinfo.hoehe*bildinfo.breite)) then
    result:=true
  else
    result:=false;
end;

procedure TSchnittsucheFenster.FormCreate(Sender: TObject);
begin
  ProfileLaden();
  logoProfilewertepruefen(self);
  logowertepruefen(self);
  wertepruefen(self);
  LetterboxedWertePruefen(self);
  Profilbewegen:=-1;
  If Mpeg2Decoder.Mpeg2Decoder_OK or Mpeg2Decoder2.Mpeg2Decoder_OK then
    DecoderVorhanden:=true
  else
    DecoderVorhanden:=false;
//  Profilbewegen.Items.Count:=-1;
end;

procedure TSchnittsucheFenster.FormShow(Sender: TObject);
begin
  Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
  Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
end;

// Beim Beenden  des Hauptprogammes Profile speichern
procedure TSchnittsucheFenster.FormDestroy(Sender: TObject);
begin
  ProfileSpeichern();
end;

function TSchnittsucheFenster.Starten():byte;
var bildinfo2:Mpeg2Decoder2.TBildeigenschaften;
    i : integer;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
begin
{  IF (Schnittliste=nil) OR (BilderProsek <= 0)
     OR (IndexListe=nil) OR (Liste=nil) THEN
  BEGIN
//    hide();
//    showmessage('Fehler, ungültige Werte übergeben');
//    EXIT;
  END; }
  fehler:=KEIN_FEHLER;
  if assigned(Audiodateiname) then
    Seitenanordnen(true)
  else
    Seitenanordnen(false);
  if DecoderVorhanden then
  begin
    if assigned(VideoDateiname) then
    begin
      I := aktuelleBildNummer;
      IndexListenpunkt := IndexListe.Items[I];
      WHILE (I > 0)  AND (IndexListenpunkt.BildTyp <> 1) DO
      BEGIN
        Dec(I);
        IndexListenpunkt := IndexListe.Items[I];
      END;
      Listenpunkt := Liste[IndexListenpunkt.BildIndex];
      if Mpeg2Decoder2.Mpeg2Decoder_OK then
      begin
        Mpeg2Decoder2.OpenMpeg2File(VideoDateiname);
        Mpeg2Decoder2.getMpeg2FrameInfo(bildinfo2);
        bildinfo.breite:=bildinfo2.breite;
        bildinfo.hoehe:=bildinfo2.hoehe;
        Mpeg2Decoder2.mpeg2seek(Listenpunkt.Adresse);
        IF ((aktuelleBildNummer - I) > 0) THEN
          Mpeg2Decoder2.SkipMPEG2Frames(aktuelleBildNummer - I );
        aktuellesBild:=Mpeg2Decoder2.getMpeg2Frame;
      end
      else
      begin
        Mpeg2Decoder.OpenMpeg2File(VideoDateiname);
        Mpeg2Decoder.getMpeg2FrameInfo(bildinfo);
        Mpeg2Decoder.SetMPEG2PixelFormat(VideoFormatGray8);
        Mpeg2Decoder.mpeg2seek(Listenpunkt.Adresse);
        IF ((aktuelleBildNummer - I) > 0) THEN
          Mpeg2Decoder.SkipMPEG2Frames(aktuelleBildNummer - I );
        aktuellesBild:=Mpeg2Decoder.getMpeg2Frame;
      end;
    end;
    showModal;
  end
  else
  begin
    fehler:=KEIN_DECODER;
    Meldungsfenster('no decoder');
//    showmessage('no decoder');
  end;
  result:=fehler;
end;

procedure TSchnittsucheFenster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Mpeg2Decoder2.Mpeg2Decoder_ok then // schliessen
    Mpeg2Decoder2.CloseMpeg2File
  else
    Mpeg2Decoder.CloseMpeg2File;
end;

procedure TSchnittsucheFenster.Audio_AbbrechenClick(Sender: TObject);
begin
  if Mpeg2Decoder2.Mpeg2Decoder_ok then // schliessen
    Mpeg2Decoder2.CloseMpeg2File
  else
    Mpeg2Decoder.CloseMpeg2File;
  ModalResult := mrCancel;
end;

procedure TSchnittsucheFenster.SeitenAnordnen(audioAktiv: boolean);
begin
  Schnittsuchefenster.PageControl.Pages[3].TabVisible:=false;
  Schnittsuchefenster.PageControl.Pages[0].TabVisible:=true;
  Schnittsuchefenster.PageControl.Pages[1].TabVisible:=true;
  Schnittsuchefenster.PageControl.ActivePageIndex:=0;
  if audioaktiv THEN // AudioSchnittsuche nur einblenden, wenn das Fenster über eine Audiodatei aufgerufen wurde
    Schnittsuchefenster.PageControl.Pages[2].TabVisible:=true
  else
    Schnittsuchefenster.PageControl.Pages[2].TabVisible:=false;
end;

// -------------------- Schnittsuche im Audio -----------------------

procedure TSchnittsucheFenster.Audio_SuchenClick(Sender: TObject);

VAR MpegAudio : TMpegAudio;
    INkorr,
    OUTkorr,
    Laenge : Integer;
    INvgl,
    OUTvgl: array of byte;
    Puffer: TDateipuffer;
begin
    Hide();
    INkorr := StrToIntDef(SchnittsucheFenster.Audio_INkorrektur.Text, 380);
    OUTkorr := StrToIntDef(SchnittsucheFenster.Audio_OUTkorrektur.Text, 0);
    // Minimale Zeit zwischen 2 Schnittpunkten, damit diese als solche akzeptiert werden
    Laenge := StrToIntDef(SchnittsucheFenster.Audio_laenge.Text, 20);
    IF Laenge < 1 THEN
      Laenge := 1;
    Puffer:=TDateipuffer.create(Audio_frameINdatei.hint,fmOpenRead);
    setLength(INvgl,Puffer.Dateigroesse);
    Puffer.LesenX(INvgl,length(INvgl));
    Puffer.Free;
    Puffer:=TDateipuffer.create(Audio_frameOUTdatei.hint,fmOpenRead);
    setLength(OUTvgl,Puffer.Dateigroesse);
    Puffer.LesenX(OUTvgl,length(OUTvgl));
    Puffer.Free;

    MpegAudio := TMpegAudio.Create;
    TRY
      MpegAudio.Dateioeffnen(Audiodateiname);
      Fortschrittsfenster.Endwert := MpegAudio.Dateigroesse;
      Fortschrittsfenster.Textanzeige(5, '');
      Fortschrittsfenster.Show;
      Schnittpunktesuchen(MpegAudio, Schnittliste, INvgl, OUTvgl, Laenge, INkorr, OUTkorr);
      Fortschrittsfenster.Hide;
    FINALLY
      MpegAudio.Free;
    END;
    ModalResult := MrOK;
  {$IFDEF WIN32}
//    Show();                     //Mpeg2Schnitt geht sonst in den Hintergrund
  {$ENDIF}
end;

FUNCTION vergleicheArray(Array1, Array2 : ARRAY of Byte):boolean;

VAR I : Integer;
    ArrayLaenge : Integer;

BEGIN
// Haben die Frames nicht die gleichen Eigenschaften ist spaetestens nach dem 4. Byte Schluss
  ArrayLaenge := Length(Array1);
// Gelockerter Vergleich: die Felder koennen unterschiedlich lang sein, es wird bis zur Laenge des kuerzeren verglichen
  IF ArrayLaenge > Length(Array2) THEN
    ArrayLaenge:=Length(Array2);
  BEGIN
    I := 0;
    WHILE  I < ArrayLaenge DO
    BEGIN
      IF Array1[I] = Array2[I] THEN
        Inc(I)
      ELSE
        I := ArrayLaenge + 1;            // Zum Erfuellen der Abbruchbedingung muss I >= ArrayLaenge sein.
    END;
    IF I = ArrayLaenge THEN              // Nur wenn I = ArrayLaenge ist wurde die gesamte Schleife erfolgreich durchlaufen.
      Result := True
    ELSE
      Result := False;
  END
//  ELSE
//    Result := False;
END;

// Schnittpunkte suchen durch binär-Vergleich einzelner Audio-Frames
FUNCTION TSchnittsucheFenster.Schnittpunktesuchen(MpegAudio : TMpegAudio; Liste: TListe;
                                                  vergleichsdatenIN, vergleichsdatenOUT: Array of Byte;
                                                  Schnittlaenge, INkorr, OUTkorr : Integer): Boolean;
VAR Puffer : ARRAY OF Byte;
    I, myIN :int64;
    Schnittpunkt : TSchnittpunkt;
    Anhalten : boolean;
    Audioheader : TAudioHeader;
    Ergebnis,
    Framelaenge : Integer;
    Adressenzaehler : Int64;
//    gesprungen:boolean;
//    Startzeit : TDateTime;                                       // zum anzeigen der Schleifendauer
//    J : Integer;                                                 // zum testen

BEGIN
 // ---------------------Test ---------------------
     {           Schnittpunkt := TSchnittpunkt.Create;
                Schnittpunkt.Anfang := 17;
                Schnittpunkt.Ende := 50;
                SchnittListe.Add(Schnittpunkt);
                Result := True;
                Schnittpunkt := TSchnittpunkt.Create;
                Schnittpunkt.Anfang := 500;
                Schnittpunkt.Ende := 550;
                SchnittListe.Add(Schnittpunkt);
                Result := True;      }
  // ---------------------Test ---------------------

//  Startzeit:=Time;                                            // zum anzeigen der Schleifendauer
//  gesprungen:=false;
  Result:=False;
  I := 0;                                                        // Audioframezaehler
  myIN := -1;                                                    // IN-Schnittpunkt
  Adressenzaehler := 0;
  Audioheader := TAudioheader.Create;
  TRY
    Ergebnis := MpegAudio.DateiInformationLesen(Audioheader);
    IF Ergebnis > -1 THEN
    BEGIN
      Schnittlaenge := Round((1000 / Audioheader.Framezeit) * 60 * Schnittlaenge);
      Framelaenge := Audioheader.Framelaenge;
      SetLength(Puffer, Framelaenge);
      REPEAT
        IF (Ergebnis = 0) OR (Ergebnis = 1) THEN
        BEGIN
          Ergebnis := MpegAudio.FrameLesen(Framelaenge, Puffer, False);
// ---------------------- zum testen -------------------------------------------
{          IF ((Adressenzaehler > 5750) AND (Adressenzaehler < 5770)) OR ((Adressenzaehler > 1727990)  AND (Adressenzaehler < 1728010)) OR
              ((Adressenzaehler > 2303990) AND (Adressenzaehler < 2304010)) OR ((Adressenzaehler > 4031990)  AND (Adressenzaehler < 4032010)) THEN
            FOR J := 0 TO Framelaenge - 1 DO
              Puffer[J] := vergleichsDatenIN[J];     }
// ---------------------- zum testen -------------------------------------------
          IF Ergebnis = 0 THEN
          BEGIN
            IF myIN < 0 THEN                                            // noch kein möglicher IN gefunden
            BEGIN
              IF vergleicheArray(Puffer, vergleichsDatenIN) THEN
                myIN := I;                                              // Frame entspricht VergleichsFrame
            END
            ELSE
            BEGIN                                                       // schon möglicher IN gefunden --> OUT suchen
              IF vergleicheArray(Puffer, vergleichsDatenOUT) THEN
                IF (I - Schnittlaenge) > myIN THEN                      // aktueller Frame = OUT ?
                BEGIN
                  Schnittpunkt := TSchnittpunkt.Create;
                  Schnittpunkt.Anfang := Round(myIN * (Audioheader.Framezeit / 1000) * BilderProsek) + INkorr;
                  Schnittpunkt.Ende := Round(I * (Audioheader.Framezeit / 1000) * BilderProsek) + Outkorr;
                  IF NOT ((Schnittpunkt.Anfang < 0)
                        OR(Schnittpunkt.Anfang+100 > Schnittpunkt.Ende) // Reserve zum Korrigieren (theoretisch koennten IN und OUT nach Korrektur beide nach dem letzten I-Frame liegen)
                        OR(Schnittpunkt.Ende > IndexListe.Count)) THEN
                  BEGIN
                    SchnittListe.Add(Schnittpunkt);
                    Fortschrittsfenster.Textanzeige(6, IntToStr(Liste.Count));
                    Result := True;
                  END
                  ELSE
                    Schnittpunkt.Free;
                  myIN := -1;
                END;
              IF (vergleicheArray(Puffer, vergleichsDatenIN)) THEN      // ist der OUT auch ein IN ?, oder ein neuer IN, bevor OUT gefunden wurde
                myIN := I
            END;
            Inc(I);
          END;
        END;
        Adressenzaehler := Adressenzaehler + Framelaenge;
        Anhalten := Fortschrittsfenster.Fortschrittsanzeige(Adressenzaehler);
      UNTIL (Ergebnis < 0) OR Anhalten;
    END;
  FINALLY
    Audioheader.Free;
  END;
//  Showmessage(IntToStr(MilliSecondsBetween(Startzeit, Time)));  // zum anzeigen der Schleifendauer
END;

procedure TSchnittsucheFenster.Analyse_SuchenClick(Sender: TObject);
VAR MpegAudio1 : TMpegAudio;
    MpegAudio2 : TMpegAudio;
    Audioheader1 : TAudioHeader;
    Audioheader2 : TAudioHeader;
    Puffer1 : ARRAY OF Byte;
    Puffer2 : ARRAY OF Byte;
    Ergebnis1: Integer;
    Ergebnis2: Integer;
    Framelaenge1 : Integer;
    Framelaenge2 : Integer;
    Anhalten : boolean;
    Adressenzaehler: Int64;
    Treffer:Integer;
    AFrame : TAudioFrame;
    Liste : TListe;
begin
    MpegAudio1 := TMpegAudio.Create;
    MpegAudio2 := TMpegAudio.Create;
    Audioheader1:=TAudioHeader.Create;
    Audioheader2:=TAudioHeader.Create;
    Adressenzaehler:=0;
    Liste:=TListe.Create;
    Anhalten:=false;
    TRY
      MpegAudio1.Dateioeffnen(Analyse_datei1.Hint);
      MpegAudio2.Dateioeffnen(Analyse_datei2.Hint);
      Ergebnis1 := MpegAudio1.DateiInformationLesen(Audioheader1);
      Ergebnis2 := MpegAudio2.DateiInformationLesen(Audioheader2);
      IF ((Ergebnis1 > -1) AND (Ergebnis2 > -1)) THEN
      begin
        Framelaenge1 := Audioheader1.Framelaenge;
        Framelaenge2 := Audioheader2.Framelaenge;
        SetLength(Puffer1, Framelaenge1);
        SetLength(Puffer2, Framelaenge2);
        Fortschrittsfenster.Endwert := MpegAudio1.Dateigroesse;
        Fortschrittsfenster.Textanzeige(7,'');
        Fortschrittsfenster.Show;
        REPEAT
          IF (Ergebnis1 = 0) OR (Ergebnis1 = 1) THEN
          BEGIN
            Ergebnis1 := MpegAudio1.FrameLesen(Framelaenge1, Puffer1, False);
            IF Ergebnis1 = 0 THEN
            begin
              MpegAudio2.Dateischliessen;
              MpegAudio2.Dateioeffnen(Analyse_datei2.Hint);
              Ergebnis2 := MpegAudio2.DateiInformationLesen(Audioheader2);
              Treffer:=0;
              REPEAT
                IF (Ergebnis2 = 0) OR (Ergebnis2 = 1) THEN
                BEGIN
                  Ergebnis2 := MpegAudio2.FrameLesen(Framelaenge2, Puffer2, False);
                  IF Ergebnis2 = 0 THEN
                  begin
                    IF (vergleicheArray(Puffer1,Puffer2)) THEN
                    begin
                      inc(Treffer);
                    end;
                    Anhalten := Fortschrittsfenster.Fortschrittsanzeige(Adressenzaehler);
                  end;
                END;
              UNTIL (Ergebnis2 < 0) OR Anhalten;
              IF (Treffer > 0) THEN
              begin
                Aframe := TAudioframe.Create;
                Aframe.Pos:=Adressenzaehler;
                Aframe.FrameNum:=round(Adressenzaehler/Framelaenge1);
                Aframe.Anzahl:=Treffer;
                Aframe.Framelaenge:=Framelaenge1;
                Liste.Add(Aframe);
              end;
            end;
          END;
          Adressenzaehler := Adressenzaehler + Framelaenge1;
          Anhalten := Fortschrittsfenster.Fortschrittsanzeige(Adressenzaehler);
        UNTIL (Ergebnis1 < 0) OR Anhalten;
      end;
      IF (liste.Count > 0) THEN
        AudioAnalyse_ErgebnisAuswerten(liste, framelaenge1);
    FINALLY
      Fortschrittsfenster.Hide;
      MpegAudio1.Free;
      MpegAudio2.Free;
      Audioheader1.Free;
      Audioheader2.Free;
      Liste.Free;
    END;
end;

procedure TSchnittsucheFenster.AudioAnalyse_ErgebnisAuswerten(Liste : Tliste; framelaenge : Integer);
VAR Dateistream : TDateipuffer;
    frameArray : Array of Array of Byte;
    filter : Array of Boolean;
    i,j : Integer;
    AFrame : TAudioFrame;
begin
    SetLength(FrameArray, Liste.Count);
    SetLength(filter, Liste.Count);
    Dateistream:=TDateiPuffer.Create(Analyse_datei1.Hint,fmopenread);
    for i:=0 to Liste.Count-1 do
    begin
      filter[i]:=false;
      setlength(frameArray[i], framelaenge);
      Dateistream.NeuePosition(TAudioframe(Liste.Items[i]).Pos);
      Dateistream.LesenDirekt(frameArray[i],framelaenge);
    end;
    for i:=0 to Length(frameArray)-1 do
      if (not(filter[i])) THEN
        for j:=(i+1) to Length(frameArray)-1 do
          if ((filter[j]=false)AND(vergleicheArray(frameArray[i],frameArray[j]))) THEN
	    filter[j]:=true;
    for i:=0 to Length(filter)-1 do
      if (NOT(filter[i])) THEN
      begin
        Aframe:=TAudioFrame(Liste.Items[i]);
        Analyse_Ergebnisliste.Items.AddObject(inttostr(Aframe.FrameNum)
                                      +','+inttostr(Aframe.Anzahl),Aframe);
      end;
    DateiStream.Free;
end;

procedure TSchnittsucheFenster.Analyse_speichernClick(Sender: TObject);
VAR SpeicherStream : TMemoryStream;
    DateiStream : TDateipuffer;
    AFrame : TAudioFrame;
    Puffer:Array of Byte;
    i:integer;
    Extension:String;
begin
  Extension:=ExtractFileExt(Analyse_datei1.hint);
  Extension:=copy(Extension,2,length(extension)-1);
  DateiSpeichernDialog.InitialDir:=initdir;
  DateiSpeichernDialog.Title := Wortlesen(NIL, 'Dialog55', 'Audioframe speichern');
  DateiSpeichernDialog.Filter := Extension+'|'+'*.'+Extension;
  DateiSpeichernDialog.DefaultExt := Extension;
  DateiSpeichernDialog.FileName := '';
  IF DateiSpeichernDialog.Execute  THEN
  begin
    Dateistream:=TDateiPuffer.Create(Analyse_datei1.Hint,fmopenread);
    SpeicherStream:=TMemoryStream.Create;
    try
      AFrame := TAudioFrame(Analyse_Ergebnisliste.Items.Objects[Analyse_Ergebnisliste.ItemIndex]);
      Dateistream.NeuePosition(Aframe.Pos);
      setlength(puffer,Aframe.Framelaenge);
      Dateistream.LesenX(puffer,length(puffer));
      for i:=0 to length(puffer)-1 do
        SpeicherStream.Write(puffer[i],1);
      SpeicherStream.SaveToFile(DateiSpeichernDialog.FileName);
    finally
      Dateistream.Free;
      SpeicherStream.Free;
    end;
  end;
end;

// -------------------- Schnittsuche im Video -----------------------
procedure TSchnittsucheFenster.Letterboxed_SuchenClick(Sender: TObject);
VAR firstslice,lastslice:byte;
begin
  // Vergleichsoptionen den entsprechenden Variablen zuordnen
  invertiert:=Letterboxed_invertiert.Checked;
  korrigiereIN:=strtoint(Letterboxed_INkorrektur.Text);
  korrigiereOUT:=strtoint(Letterboxed_OUTkorrektur.Text);
  mingrau:=strtoint(letterboxed_MinGrau.Text);
  maxgrau:=strtoint(letterboxed_MaxGrau.Text);
  len:=strtoint(letterboxed_Schnittlaenge.Text);
  seek:=strtoint(letterboxed_schrittweite.Text);
  lastslice:=0;
  firstslice:=0;
  if (rb_oben.Checked) THEN
  begin
    if Mpeg2Decoder2.Mpeg2Decoder_OK then
    begin
      firstslice:=1+(strtoint(Letterboxed_ZeilenIgnorieren.Text))div 16;
      lastslice:=1+(((strtoint(Letterboxed_ZeilenIgnorieren.Text))+strtoint(Letterboxed_ZeilenOben.Text)-1)div 16);
      Letterboxed_StartPosition:=((strtoint(Letterboxed_ZeilenIgnorieren.Text))mod 16)*bildinfo.Breite;
    end
    else
    begin
      Letterboxed_StartPosition:=(strtoint(Letterboxed_ZeilenIgnorieren.Text))*bildinfo.Breite;
    end;
    Letterboxed_Anzahl:=strtoint(Letterboxed_ZeilenOben.Text);
    letterboxed_obenunten:=true;
  end
  else
  if (rb_unten.Checked) THEN
  begin
    if Mpeg2Decoder2.Mpeg2Decoder_OK then
    begin
      firstslice:=(bildinfo.hoehe div 16)-((strtoint(Letterboxed_ZeilenIgnorieren.Text)+strtoint(Letterboxed_ZeilenUnten.Text)-1)div 16);
      lastslice:=(bildinfo.hoehe div 16)-((strtoint(Letterboxed_ZeilenIgnorieren.Text))div 16);
      if not (((strtoint(Letterboxed_ZeilenIgnorieren.Text)+strtoint(Letterboxed_ZeilenUnten.Text))mod 16)= 0) then
        Letterboxed_StartPosition:=(16-((strtoint(Letterboxed_ZeilenIgnorieren.Text)+strtoint(Letterboxed_ZeilenUnten.Text))mod 16))*bildinfo.Breite
      else
        Letterboxed_StartPosition:=0;
    end
    else
    begin
      Letterboxed_StartPosition:=((bildinfo.Hoehe-(strtoint(Letterboxed_ZeilenIgnorieren.Text))-Letterboxed_Anzahl)*bildinfo.Breite);
    end;
    Letterboxed_Anzahl:=strtoint(Letterboxed_ZeilenUnten.Text);
    letterboxed_obenunten:=true;
  end
  else
  if (rb_links.Checked) THEN
  begin
    Letterboxed_Anzahl:=strtoint(Letterboxed_SpaltenLinks.Text);
    Letterboxed_StartPosition:=strtoint(Letterboxed_spaltenignorieren.Text);
    letterboxed_obenunten:=false;
  end
  else
  begin
    Letterboxed_Anzahl:=strtoint(Letterboxed_SpaltenRechts.Text);
    Letterboxed_StartPosition:=(bildinfo.Breite-strtoint(Letterboxed_spaltenignorieren.Text)-Letterboxed_Anzahl);
    letterboxed_obenunten:=false;
  end;
    if lb_verf_lin.Checked=true THEN
      verfeinern:=1
    else
    if lb_verf_bin.Checked=true THEN
      verfeinern:=2
    else
      verfeinern:=0;
  if Mpeg2Decoder2.Mpeg2Decoder_ok then
  BEGIN
    Mpeg2Decoder2.ReOpenMpeg2File(firstslice,lastslice);// Datei für schnelle Suche öffnen'
  END;
    sucheimVideo(1); // Suche starten

  if Mpeg2Decoder2.Mpeg2Decoder_ok then // schliessen
    Mpeg2Decoder2.CloseMpeg2File
  else
    Mpeg2Decoder.CloseMpeg2File;

  ModalResult := MrOK;

  {$IFDEF MSWINDOWS}
//  Show();                     //Mpeg2Schnitt geht sonst in den Hintergrund
  {$ENDIF}
end;

procedure TSchnittsucheFenster.Logo_suchenClick(Sender: TObject);
VAR Pixel : TvglPixel;
    i:Integer;
    firstslice,lastslice:integer;
BEGIN
  setlength(logodaten,Logo_PixelListe.Items.Count);
  i:=0;
  while (i < Logo_Pixelliste.Items.Count) do // Die Vergleichspixel in ein Array eintragen
  begin
    Pixel := TvglPixel(Logo_PixelListe.items.Objects[i]);
    logodaten[i,0]:=(Pixel.posY*bildinfo.Breite)+Pixel.posX; // Position des Pixels ab Bildanfang
    logodaten[i,1]:=Pixel.minGrau;
    logodaten[i,2]:=Pixel.maxGrau;
    inc(i);
  end;
  SortiereArray(); // Vergleichspixel nach der Position aufsteigend sortieren
  // ungültige Vergleichsdaten abfangen
  lastslice:=1+((logodaten[length(logodaten)-1,0])div (16*bildinfo.Breite) );
  firstslice:=1+((logodaten[0,0])div (16*bildinfo.Breite) );


  if ((logodaten[0][0]<0) OR (logodaten[length(logodaten)-1][0]>=(bildinfo.Hoehe*bildinfo.Breite))) THEN
    Meldungsfenster(Wortlesen(NIL, 'Meldung900', 'Fehler, ein oder mehrere Vergleichspixel liegen ausserhalb des Bildbereichs.'))
//    showmessage(Wortlesen(NIL, 'Meldung900', 'Fehler, ein oder mehrere Vergleichspixel liegen ausserhalb des Bildbereichs.'))
  else // alle Daten gültig, Suche vorbereiten und starten
  begin
    if Mpeg2Decoder2.Mpeg2Decoder_ok then // SuchDaten für schnelle Suche aufbereiten
    begin
      for i:=0 to length(logodaten)-1 do
        logodaten[i,0]:=(logodaten[i,0]-((firstslice-1)*16*bildinfo.breite));
    end;
    i:=length(logodaten)-1;
    while (i >0) do // die Positionen relativ zum Vorgänger umrechnen (zur späteren PointerInkrementierung)
    begin
      logodaten[i][0]:=logodaten[i][0]-logodaten[i-1][0];
      dec(i);
    end;
    // Vergleichsoptionen den entsprechenden Variablen zuordnen
    seek:=strtoint(logo_seek.Text);
    len:=strtoint(logo_len.Text);
    invertiert:=logo_Invertiert.Checked;
    korrigiereIN:=strtoint(logo_INkorrektur.Text);
    korrigiereOUT:=strtoint(logo_OUTkorrektur.Text);
    if logo_verf_lin.Checked=true THEN
      verfeinern:=1
    else
    if logo_verf_bin.Checked=true THEN
      verfeinern:=2
    else
      verfeinern:=0;
    // Datei für schnelle Suche öffnen
    if Mpeg2Decoder2.Mpeg2Decoder_ok then
      Mpeg2Decoder2.ReOpenMpeg2File(firstslice,lastslice);

    sucheImVideo(2); // Suche starten

    if Mpeg2Decoder2.Mpeg2Decoder_ok then // schliessen
      Mpeg2Decoder2.CloseMpeg2File
    else
      Mpeg2Decoder.CloseMpeg2File;

    ModalResult := MrOK;
    {$IFDEF MSWINDOWS}
//      Show();                     //Mpeg2Schnitt geht sonst in den Hintergrund
    {$ENDIF}
  end;
end;

// Array aufsteigend sortieren
PROCEDURE TSchnittsucheFenster.SortiereArray ();
VAR
  i,j,l: INTEGER;
begin
  l:=length(logodaten);
  setlength(logodaten,l+1);
  for i:=0 to l do
    for j:=i to l-1 do
      if logodaten[i][0]>logodaten[j][0] then
      begin
        logodaten[l]:=logodaten[i];
        logodaten[i]:=logodaten[j];
        logodaten[j]:=logodaten[l];
      end;
  setlength(logodaten,l);
end;

procedure TSchnittsucheFenster.sucheImVideo(SuchTyp:byte);
VAR
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
    bildanzahl,I : DWord;
    inFrame:Integer;
    Schnittpunkt:Tschnittpunkt;
    Anhalten:boolean;
//    Startzeit : TDateTime;
    ergebnis:boolean;
BEGIN
//  Startzeit:=time;
  Hide();
  Anhalten:=false;
  bildanzahl:=Indexliste.Count;
  inFrame:=-1;
  Fortschrittsfenster.Endwert := bildanzahl;
  Fortschrittsfenster.Textanzeige(5, '');
  Fortschrittsfenster.Show;
  i:=0;
  WHILE (I < bildanzahl) AND (Anhalten=false) DO
  BEGIN
    Anhalten:=Fortschrittsfenster.Fortschrittsanzeige(i);
    IndexListenpunkt := IndexListe.Items[I];
    if not(IndexListenpunkt.BildTyp = 1)THEN
      inc(I)
    else
    BEGIN
    Listenpunkt := Liste[IndexListenpunkt.BildIndex];
    if Mpeg2Decoder2.Mpeg2Decoder_OK then
      Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
    else
      Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
    case Suchtyp of
      1: ergebnis:=pruefeLetterboxed();
      2: ergebnis:=pruefeLogo();
    else
      ergebnis:=invertiert;
    end;
    IF (ergebnis = (NOT invertiert))THEN
    BEGIN
      IF (inFrame=-1)THEN  // wenn noch kein IN, dann neuer IN
        inFrame:=i;
    END
    ELSE                   // Das aktuelle Bild erfüllt die Vegleichsbedingung nicht
    BEGIN                  // Erfüllt der Bereich ab dem IN die minimale Schnittlänge?
      IF ((inframe>-1)AND((i-round(len*bilderprosek))>inFrame)) THEN // Schnitt gefunden
      BEGIN
        Schnittpunkt:=TSchnittpunkt.create();
        Schnittpunkt.Anfang:=verfeinereIN(inframe,SuchTyp);
        Schnittpunkt.Ende:=verfeinereOUT(i,SuchTyp);
        IF (Schnittpunkt.Anfang=-1) OR (Schnittpunkt.Ende=-1) THEN
        begin
          Anhalten:=true;
          Schnittpunkt.Free;
        end
        else
        begin
          Schnittliste.Add(Schnittpunkt);
          Fortschrittsfenster.Textanzeige(6, IntToStr(SchnittListe.Count));
        end;
      END;
      inFrame:=-1; // zurücksetzen ( kein IN )
    END;
    I:=I+(round(seek*bilderprosek)); // Sekunden überspringen (Schrittweite)
    END;
  END;
  // Den letzten Abschnitt auch in die Schnittliste übernehmen, falls die minimale Schnittlänge erfüllt ist
  if ((inframe>-1)AND((bildanzahl-1-round(len*bilderprosek))>inFrame)) THEN //Schnitt gefunden
  BEGIN
    Schnittpunkt:=TSchnittpunkt.create();
    Schnittpunkt.Anfang:= verfeinereIN(inframe,SuchTyp);
    Schnittpunkt.Ende:= BildAnzahl-1;
    IF (Schnittpunkt.Anfang=-1) OR (Schnittpunkt.Ende=-1) THEN
      Schnittpunkt.Free
    else
    Schnittliste.Add(Schnittpunkt);
  END;
  Fortschrittsfenster.Hide;
//  Showmessage(IntToStr(MilliSecondsBetween(Startzeit, Time)));  // zum anzeigen der Schleifendauer
END;

function TschnittsucheFenster.verfeinereIN(bildnr:dword; suchtyp:byte):Integer;
begin
  case verfeinern of
    1: result:=verfeinereINlinear(bildnr, suchtyp);
    2: result:=verfeinereINbinaer(bildnr, suchtyp);
  else
    result:=bildnr;
  end;
end;

function TschnittsucheFenster.verfeinereINlinear(bildnr:dword; suchtyp:byte):Integer;
VAR i:dword;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
    ergebnis:boolean;
    Anhalten:boolean;
BEGIN
  Anhalten:=false;
  if((bildnr-(round((seek+2)*bilderprosek)))>0)THEN
    i:=bildnr-(round((seek+2)*bilderprosek))
  else
    i:=0;
  result:=i;
  // solange rückwärts die I-Frames untersuchen, bis einer die Bedingung nicht erfüllt
  while (bildnr>i) and NOT anhalten do
  BEGIN
    IndexListenpunkt := IndexListe.Items[bildnr];
    Anhalten:=Fortschrittsfenster.Fortschrittsanzeige(bildnr);
    if (IndexListenpunkt.BildTyp = 1)THEN
    BEGIN
      Listenpunkt := Liste[IndexListenpunkt.BildIndex];
      if Mpeg2Decoder2.Mpeg2Decoder_OK then
        Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
      else
        Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);

      case Suchtyp of
        1: ergebnis:=pruefeLetterboxed();
        2: ergebnis:=pruefeLogo();
      else
        ergebnis:=invertiert;
      end;
      if (ergebnis= (NOT invertiert)) THEN
        result:=bildnr
        else
        bildnr:=i;
    END;
    dec(bildnr)
  END;
  // Benutzerdefinierten Korrekturwert verrechnen
  IF (result+korrigiereIN)<0 THEN
    result:=0
  else IF ((result+korrigiereIN)>= indexliste.Count) THEN
    result:=indexliste.Count-1
  else
    result:=result+korrigiereIN;

  if
    Anhalten THEN
    result:=-1
END;

function TschnittsucheFenster.verfeinereINbinaer(bildnr:dword; suchtyp:byte):Integer;
VAR i:dword;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
    ergebnis:boolean;
    a:array of Integer;
    k,z:Integer;
    ober,unter:Integer;
    Anhalten:boolean;
BEGIN
  Anhalten:=false;
  if((bildnr-(round((seek+2)*bilderprosek)))>0)THEN
    i:=bildnr-(round((seek+2)*bilderprosek))
  else
    i:=0;
  result:=i;
  z:=0;
  while (i<=bildnr) do
  BEGIN
    IndexListenpunkt := IndexListe.Items[i];
    if (IndexListenpunkt.BildTyp = 1)THEN
      inc(z);
    inc(i);
  END;
  setlength(a,z);
  z:=0;
  i:=result;
  while (i<=bildnr) do
  BEGIN
    IndexListenpunkt := IndexListe.Items[i];
    if (IndexListenpunkt.BildTyp = 1)THEN
    begin
      a[z]:=i;
      inc(z);
    end;
    inc(i);
  END;
  result:=-1;
  ober:=z-2;
  unter:=0;
  // suche das Bild, das ein Logo enthält UND dessen Vorgänger keines enthält
  while (result=-1) AND(ober>=unter) AND (NOT Anhalten) do
  begin
    Anhalten:=Fortschrittsfenster.Fortschrittsanzeige(i);
    k:=round((ober+unter)/2); //Mitte zwischen ober und untergrenze ermitteln
    IndexListenpunkt := IndexListe.Items[a[k]];
    Listenpunkt := Liste[IndexListenpunkt.BildIndex];
    if Mpeg2Decoder2.Mpeg2Decoder_OK then
      Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
    else
      Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
    case Suchtyp of
      1: ergebnis:=pruefeLetterboxed();
      2: ergebnis:=pruefeLogo();
    else
      ergebnis:=invertiert;
    end;
    if (ergebnis= (invertiert)) THEN     // Bild passt nicht auf Vergleichsdaten
    begin
    // nachfolgenden I-Frame untersuchen
      IndexListenpunkt := IndexListe.Items[a[k+1]];
      Listenpunkt := Liste[IndexListenpunkt.BildIndex];
      if Mpeg2Decoder2.Mpeg2Decoder_OK then
        Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
      else
        Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
      case Suchtyp of
        1: ergebnis:=pruefeLetterboxed();
        2: ergebnis:=pruefeLogo();
      else
        ergebnis:=invertiert;
      end;
      if (ergebnis= (NOT invertiert)) THEN     // Bild passt auf Vergleichsdaten
        result:=a[k+1]
      else // das gesuchte Bild befindet sich weiter hinten, Grenzen anpassen
        unter:=k+1;
    end
    else // das gesuchte Bild befindet sich weiter vorne, Grenzen anpassen
      ober:=k-1;
  end;
  if (result=-1) THEN
    result:=bildnr;
  // Benutzerdefinierten Korrekturwert verrechnen
  IF (result+korrigiereIN)<0 THEN
    result:=0
  else IF ((result+korrigiereIN)>= indexliste.Count) THEN
    result:=indexliste.Count-1
  else
    result:=result+korrigiereIN;

  if Anhalten THEN
    result:=-1
END;

function TschnittsucheFenster.verfeinereOUT(bildnr:dword; SuchTyp: byte):Integer;
begin
  case verfeinern of
    1: result:=verfeinereOUTlinear(bildnr, suchtyp);
    2: result:=verfeinereOUTbinaer(bildnr, suchtyp);
  else
    result:=bildnr;
  end;
end;

function TschnittsucheFenster.verfeinereOUTlinear(bildnr:dword; SuchTyp: byte):Integer;
VAR i:dword;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
    ergebnis:boolean;
//    skip:byte;
    Anhalten:boolean;
BEGIN
  Anhalten:=false;
  result:=bildnr;
  // zum zuvor untersuchten I-Frame zurückgehen und I-Frame-genau verfeinern
  if((bildnr-(round((seek+2)*bilderprosek)))>0)THEN
    i:=bildnr-(round((seek+2)*bilderprosek))
  else
    i:=0;
  while (i<bildnr) AND (NOT Anhalten) do
  BEGIN
    Anhalten:=Fortschrittsfenster.Fortschrittsanzeige(i);
    IndexListenpunkt := IndexListe.Items[i];
    if (IndexListenpunkt.BildTyp = 1)THEN
    BEGIN
      Listenpunkt := Liste[IndexListenpunkt.BildIndex];
      if Mpeg2Decoder2.Mpeg2Decoder_OK then
        Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
      else
        Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
      case Suchtyp of
        1: ergebnis:=pruefeLetterboxed();
        2: ergebnis:=pruefeLogo();
      else
        ergebnis:=invertiert;
      end;
      if (ergebnis= (NOT invertiert)) THEN
        result:=i
      else
        i:=bildnr;
    END;
    inc(I)
  END;
  IndexListenpunkt := IndexListe.Items[result];
  Listenpunkt := Liste[IndexListenpunkt.BildIndex];
  if Mpeg2Decoder2.Mpeg2Decoder_OK then
    Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
  else
    Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
  IF ((result+korrigiereOUT)<0) THEN
    result:=0
  else IF ((result+korrigiereOUT)>= indexliste.Count) THEN
    result:=indexliste.Count-1
  else
    result:=result+korrigiereOUT;

  if Anhalten THEN
    result:=-1
END;

function TschnittsucheFenster.verfeinereOUTbinaer(bildnr:dword; SuchTyp: byte):Integer;
VAR i:dword;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
    ergebnis:boolean;
    a:array of Integer;
   // skip,
    k,z:Integer;
    ober,unter:Integer;
    Anhalten:boolean;
BEGIN
  Anhalten:=false;
  if((bildnr-(round((seek+2)*bilderprosek)))>0)THEN
    i:=bildnr-(round((seek+2)*bilderprosek))
  else
    i:=0;
  result:=i;
  z:=0;
  // solange rückwärts die I-Frames untersuchen, bis einer die Bedingung nicht erfüllt
  while (i<=bildnr) do
  BEGIN
    IndexListenpunkt := IndexListe.Items[i];
    if (IndexListenpunkt.BildTyp = 1)THEN
      inc(z);
    inc(i);
  END;
  setlength(a,z);
  z:=0;
  i:=result;
  while (i<=bildnr) do
  BEGIN
    IndexListenpunkt := IndexListe.Items[i];
    if (IndexListenpunkt.BildTyp = 1)THEN
    begin
      a[z]:=i;
      inc(z);
    end;
    inc(i);
  END;
  result:=-1;
  ober:=z-2;
  unter:=0;
  // suche das Bild, das ein Logo enthält UND dessen Folgebild keines enthält
  while (result=-1) AND (ober>=unter) AND (NOT Anhalten) do
  begin
    Anhalten:=Fortschrittsfenster.Fortschrittsanzeige(i);
    k:=round((ober+unter)/2); //Mitte zwischen ober und untergrenze ermitteln
//    Meldungsfenster('ober: '+inttostr(ober)+' unter: '+inttostr(unter));
//    showmessage('ober: '+inttostr(ober)+' unter: '+inttostr(unter));
    IndexListenpunkt := IndexListe.Items[a[k]];
    Listenpunkt := Liste[IndexListenpunkt.BildIndex];
    if Mpeg2Decoder2.Mpeg2Decoder_OK then
      Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
    else
      Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
    case Suchtyp of
      1: ergebnis:=pruefeLetterboxed();
      2: ergebnis:=pruefeLogo();
    else
      ergebnis:=invertiert;
    end;
    if (ergebnis= ( NOT invertiert)) THEN     // Bild passt auf Vergleichsdaten
    begin
    // nachfolgenden I-Frame untersuchen
      IndexListenpunkt := IndexListe.Items[a[k+1]];
      Listenpunkt := Liste[IndexListenpunkt.BildIndex];
      if Mpeg2Decoder2.Mpeg2Decoder_OK then
        Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
      else
        Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
      case Suchtyp of
        1: ergebnis:=pruefeLetterboxed();
        2: ergebnis:=pruefeLogo();
      else
        ergebnis:=invertiert;
      end;
      if (ergebnis= (invertiert)) THEN     // Bild passt nicht auf Vergleichsdaten
        result:=a[k]
      else // das gesuchte Bild befindet sich weiter hinten, Grenzen anpassen
        unter:=k+1;
    end
    else // das gesuchte Bild befindet sich weiter vorne, Grenzen anpassen
      ober:=k-1;
  end;


  if (result=-1) THEN
    result:=bildnr;
  IndexListenpunkt := IndexListe.Items[result];
  Listenpunkt := Liste[IndexListenpunkt.BildIndex];
  if Mpeg2Decoder2.Mpeg2Decoder_OK then
    Mpeg2Decoder2.Mpeg2Seek(Listenpunkt.Adresse)
  else
    Mpeg2Decoder.Mpeg2Seek(Listenpunkt.Adresse);
  // Benutzerdefinierten Korrekturwert verrechnen
  IF ((result+korrigiereOUT)<0) THEN
    result:=0
  else IF ((result+korrigiereOUT)>= indexliste.Count) THEN
    result:=indexliste.Count-1
  else
    result:=result+korrigiereOUT;
  if Anhalten THEN
    result:=-1
END;

function TSchnittsucheFenster.pruefeLetterboxed():boolean;
begin
  IF (letterboxed_obenunten) THEN
    result:=pruefeLetterboxedObenUnten()
  else
    result:=pruefeLetterboxedLinksRechts;
end;

function TSchnittsucheFenster.pruefeLetterboxedObenUnten():boolean;
VAR bild:pbytearray;
    i:Integer;
    p: pbyte;
    farbsumme:Integer;
BEGIN
  farbsumme:=0;
  if Mpeg2Decoder2.Mpeg2Decoder_ok then
    bild:=Mpeg2Decoder2.getMpeg2Frame
  else
    bild:=Mpeg2Decoder.getMpeg2Frame;
  if not assigned(bild) then
    result:=true
  else
  begin
    p:=Pointer(Bild);
    for i:=1 to Letterboxed_StartPosition do // zum ersten Byte des Suchbereiches gehen
      inc(p);
    for i:=1 to (Letterboxed_anzahl*bildinfo.Breite) do
    begin  // alle bytes des Suchbereiches summieren
      farbsumme:=farbsumme+p^;
      inc(p);
    end; // Mittelwert überprüfen
    if (((round(farbsumme/(Letterboxed_anzahl*bildinfo.Breite)))<=maxgrau)
    AND ((round(farbsumme/(Letterboxed_anzahl*bildinfo.Breite)))>=mingrau)) THEN
      result:=true
    else
      result:=false;
  end;
end;

function TSchnittsucheFenster.pruefeLetterboxedLinksRechts():boolean;
VAR bild:pbytearray;
    i,j:Integer;
    p: pbyte;
    farbsumme:Integer;
BEGIN
  farbsumme:=0;
  if Mpeg2Decoder2.Mpeg2Decoder_ok then
    bild:=Mpeg2Decoder2.getMpeg2Frame
  else
    bild:=Mpeg2Decoder.getMpeg2Frame;
  if not assigned(bild) then
    result:=true
  else
  begin
    p:=Pointer(Bild);
    for i:=1 to Letterboxed_StartPosition do // zum ersten Byte des Suchbereiches gehen
      inc(p);
    i:=Letterboxed_StartPosition;
    while (i < bildinfo.Hoehe) do
    begin
      for j:=1 to Letterboxed_anzahl do //die bytes der relevanten Spalten summieren
      begin
        farbsumme:=farbsumme+p^;
        inc(p);
      end;
      for j:=1 to ((bildinfo.breite)-Letterboxed_Anzahl) do
        inc(p);  // zur ersten relevanten Spalte der nächsten Zeile gehen
      inc(i);
    end; // Mittelwert der Summe überprüfen
    if (((round(farbsumme/(Letterboxed_anzahl*bildinfo.hoehe)))<=maxgrau)
    AND ((round(farbsumme/(Letterboxed_anzahl*bildinfo.hoehe)))>=mingrau)) THEN
      result:=true
    else
      result:=false;
  end;
end;

function TSchnittsucheFenster.pruefeLogo():boolean;
VAR bild:pbytearray;
    i,j:Integer;
    p: pbyte;
BEGIN
  i:=0;
  result:=true;
  if Mpeg2Decoder2.Mpeg2Decoder_ok then
    bild:=Mpeg2Decoder2.getMpeg2Frame
  else
    bild:=Mpeg2Decoder.getMpeg2Frame;
  if not assigned(bild) then
    result:=true
  else
  begin
    p:=Pointer(Bild);
    while (i < length(logodaten)) AND (result=true)do
    begin
      for j:=1 to logodaten[i,0] do
        inc(p);
      if((p^>=logodaten[i,1])AND(p^<=logodaten[i,2]))THEN
        result:=true
      else
        result:=false;
      inc(i);
    end;
  end;
end;


procedure TSchnittsucheFenster.Letterboxed_AnalysierenClick(Sender: TObject);
begin
  mingrau:=strtoint(letterboxed_MinGrau.Text);
  maxgrau:=strtoint(letterboxed_MaxGrau.Text);
   // Schwarze Zeilen automatisch erkennen
  Letterboxed_StartPosition:=strtoint(Letterboxed_ZeilenIgnorieren.Text);
  zeilenermitteln();
   // Schwarze Spalten automatisch erkennen
  Letterboxed_StartPosition:=strtoint(Letterboxed_SpaltenIgnorieren.Text);
  spaltenermitteln();
  // Den Maximalwert als Suchbereich vor-auswählen

  rb_oben.Checked:=true;
  if (strtoint(Letterboxed_zeilenunten.Text)>strtoint(Letterboxed_zeilenoben.Text)) THEN
     rb_unten.Checked:=true;
  if (strtoint(Letterboxed_spaltenlinks.Text)>strtoint(Letterboxed_zeilenunten.Text)) THEN
     rb_links.Checked:=true;
  if (strtoint(Letterboxed_spaltenrechts.Text)>strtoint(Letterboxed_zeilenunten.Text)) THEN
     rb_rechts.Checked:=true;
  LetterboxedWertePruefen(self);
end;

procedure TSchnittsuchefenster.ZeilenErmitteln();
VAR bild:pbytearray;
    i,j:Integer;
    p: pbyte;
    zeilensumme:Integer;
    hoehe,breite:Integer;
    schleifenende:boolean;
    zeilenOben_, zeilenUnten_:dword;
    summe:Array of dword;
BEGIN
  schleifenende:=false;
  zeilenoben_:=0;
  zeilenunten_:=0;
  bild:=aktuellesBild;
  hoehe:=bildinfo.Hoehe;
  breite:=bildinfo.Breite;
  p:=Pointer(Bild);
  for i:=0 to hoehe-1 do
  setlength(summe,hoehe);
  for i:=0 to hoehe-1 do
  begin
    zeilensumme:=0;
    for j:=0 to breite-1 do
    begin
      zeilensumme:=zeilensumme+p^;
      inc(p);
    end;
    summe[i]:=zeilensumme;
  end;
  // Letterboxed_StartPosition: hier: zu ignorierende Zeilen
  i:=Letterboxed_StartPosition;
  // oben analysieren
  while (NOT SchleifenEnde) AND (i<hoehe) do
  begin
    if (((round(summe[i]/breite))<=maxgrau)AND((round(summe[i]/breite))>=mingrau)) THEN
    begin
      inc(zeilenoben_);
      inc(i);
    end
    else
      SchleifenEnde:=true;
  end;
  i:=hoehe-Letterboxed_StartPosition-1;
  Schleifenende:=false;
  // unten analysieren
  while (NOT SchleifenEnde) AND (i>=0) do
  begin
    if (((round(summe[i]/breite))<=maxgrau)AND((round(summe[i]/breite))>=mingrau)) THEN
    BEGIN
      inc(zeilenunten_);
      dec(i);
    END
    else
      SchleifenEnde:=true;
    end;
  Letterboxed_ZeilenOben.text:=inttostr(zeilenoben_);
  Letterboxed_ZeilenUnten.text:=inttostr(zeilenunten_);
END;

procedure TSchnittsuchefenster.SpaltenErmitteln();
VAR bild:pbytearray;
    i,j:Integer;
    p: pbyte;
    hoehe,breite:Integer;
    schleifenende:boolean;
    spaltenLinks_, spaltenRechts_:dword;
    summe:Array of dword;
BEGIN
  schleifenende:=false;
  spaltenLinks_:=0;
  spaltenRechts_:=0;
  bild:=aktuellesBild;
  hoehe:=bildinfo.Hoehe;
  breite:=bildinfo.Breite;
  p:=Pointer(Bild);
  setlength(summe,breite);
  for i:=0 to breite-1 do
     summe[i]:=0;
  for i:=0 to hoehe-1 do
  begin
    for j:=0 to breite-1 do
    begin
      summe[j]:=summe[j]+p^;
      inc(p);
    end;
  end;
  // Letterboxed_StartPosition: hier zu ignorierende Spalten
  i:=Letterboxed_StartPosition;
  // links analysieren
  while (NOT SchleifenEnde) AND (i<breite) do
  begin
    if (((round(summe[i]/hoehe))<=maxgrau)AND ((round(summe[i]/hoehe))>=mingrau))THEN
    begin
      inc(spaltenlinks_);
      inc(i);
    end
    else
      SchleifenEnde:=true;
  end;

  i:=breite-Letterboxed_StartPosition-1;
  Schleifenende:=false;
  // rechts analysieren
  while (NOT SchleifenEnde) AND (i>=0) do
  begin
    if (((round(summe[i]/hoehe))<=maxgrau)AND ((round(summe[i]/hoehe))>=mingrau))THEN
    BEGIN
      inc(spaltenRechts_);
      dec(i);
    END
    else
      SchleifenEnde:=true;
    end;
  Letterboxed_SpaltenLinks.Text:=inttostr(spaltenLinks_);
  Letterboxed_SpaltenRechts.Text:=inttostr(spaltenRechts_);
END;

procedure TSchnittsucheFenster.Logo_Profile_testenClick(Sender: TObject);
VAR I,J : Integer;
    PListe : TListe;
    Pixel : TvglPixel;
    s : String;
begin
    s:=(Wortlesen(NIL, 'Meldung901', 'Folgende Profile passen auf das aktuelle Bild:'));
    for i:=0 to logo_Profilliste.Items.Count-1 do
    begin
      Pliste := TListe(Logo_Profilliste.Items.Objects[I]);
      setlength(logodaten,PListe.Count-1);
      j:=1;
      while (j < PListe.Count) do // Die Vergleichspixel in ein Array eintragen
      begin
        Pixel := TvglPixel(PListe.items[j]);
        logodaten[j-1,0]:=(Pixel.posY*bildinfo.Breite)+Pixel.posX; // Position des Pixels ab Bildanfang
        logodaten[j-1,1]:=Pixel.minGrau;
        logodaten[j-1,2]:=Pixel.maxGrau;
        inc(j);
      end;
      SortiereArray(); // Vergleichspixel nach der Position aufsteigend sortieren
      if (NOT (logodaten[0][0]<0) OR (logodaten[length(logodaten)-1][0]>=(bildinfo.Hoehe*bildinfo.Breite))) THEN
      begin
        j:=length(logodaten)-1;
        while (j >0) do // die Positionen relativ zum Vorgänger umrechnen (zur späteren PointerInkrementierung)
        begin
          logodaten[j][0]:=logodaten[j][0]-logodaten[j-1][0];
          dec(j);
        end;
        if (pruefeLogo2()) THEN
          s:=s+chr(13)+ Logo_Profilliste.Items[i];
      end;
    end;
    Meldungsfenster(s);
//    showmessage(s);
end;

function TSchnittsucheFenster.pruefeLogo2():boolean;
VAR i,j:Integer;
    p: pbyte;
BEGIN
  i:=0;
  result:=true;
  p:=Pointer(aktuellesBild);
  while (i < length(logodaten)) AND (result=true)do
  begin
    for j:=1 to logodaten[i,0] do
      inc(p);
    if((p^>=logodaten[i,1])AND(p^<=logodaten[i,2]))THEN
      result:=true
    else
      result:=false;
    inc(i);
  end;
end;

// -------------------- Verwaltung der Such-Profil-Datei -----------------------

procedure TSchnittsucheFenster.ProfileLaden();

VAR ProfilDatei: TIniFile;
    Dateiname: String;
    Z,I: Integer;
    Profil : Tprofil;
    Liste : TListe;
    Pixel : TvglPixel;
    s : String;
begin
  {$IFDEF LINUX}
    Dateiname := GetEnvironmentVariable('M2SHOME')+'SuchProfile.ini';
  {$ENDIF}
  {$IFDEF WIN32}
    Dateiname := ExtractFilePath(Application.ExeName)+'SuchProfile.ini';
  {$ENDIF}
  IF FileExists(Dateiname) THEN
  BEGIN
    ProfilDatei := TIniFile.Create(Dateiname);
    Z:=0;
    initDir :=Profildatei.ReadString('Allgemein', 'InitDir', '');
    WHILE Profildatei.SectionExists('Profil_'+IntToStr(Z)) DO
    BEGIN
      Profil := TProfil.Create;
      Profil.INkorr := Profildatei.ReadInteger('Profil_'+IntToStr(Z), 'INkorrektur', 0);
      Profil.OUTkorr := Profildatei.ReadInteger('Profil_'+IntToStr(Z), 'OUTkorrektur', 0);
      Profil.Laenge := Profildatei.ReadInteger('Profil_'+IntToStr(Z), 'Laenge', 0);
      Profil.Name := Profildatei.ReadString('Profil_'+IntToStr(Z), 'Name', 'undefiniert');
      Profil.INframe := Profildatei.ReadString('Profil_'+IntToStr(Z), 'INframe', '');
      Profil.OUTframe := Profildatei.ReadString('Profil_'+IntToStr(Z), 'OUTframe', '');
      Audio_Profilliste.Items.AddObject(Profil.Name, Profil);
      Inc(Z);
    END;
    IF Z > 0 THEN
    BEGIN
      Audio_ProfilListe.ItemIndex := 0;
      Profil := TProfil(Audio_ProfilListe.items.Objects[0]);
      Audio_INKorrektur.Text := IntToStr(Profil.INkorr);
      Audio_OUTKorrektur.Text := IntToStr(Profil.OUTkorr);
      Audio_Laenge.Text := IntToStr(Profil.Laenge);
      Audio_ProfilName.Text := Profil.Name;
      Audio_frameINdatei.Hint:=Profil.INframe;
      Audio_frameOUTdatei.Hint:=Profil.OUTframe;
      Audio_frameINdatei.Text := ExtractFilename(Profil.INframe);
      Audio_frameOUTdatei.Text := ExtractFilename(Profil.OUTframe);
    END
    ELSE
    BEGIN
      AudioMenue_Loeschen.Enabled := False;
      AudioMenue_Aendern.Enabled := False;
    END;
    //VideoProfile
    Z:=0;
    WHILE Profildatei.SectionExists('LB_Profil_'+IntToStr(Z)) DO
    BEGIN
      Profil := TProfil.Create;
      Profil.INkorr := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'INkorrektur', 0);
      Profil.OUTkorr := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'OUTkorrektur', 0);
      Profil.Laenge := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'Laenge', 300);
      Profil.Name := Profildatei.ReadString('LB_Profil_'+IntToStr(Z), 'Name', 'undefiniert');
      Profil.Schrittweite := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'Schrittweite', 10);
      Profil.MinGrau := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'MinGrau', 0);
      Profil.MaxGrau := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'MaxGrau', 0);
      Profil.zeilenignorieren := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'zeilenignorieren', 0);
      Profil.spaltenignorieren := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'spaltenignorieren', 0);
      Profil.Suchbereich := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'Suchbereich', 1);
      Profil.Suchbereichswert := Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z), 'Suchbereichswert', 1);
      Profil.Invertiert := Profildatei.ReadBool('LB_Profil_'+IntToStr(Z), 'invertiert', false);
      Profil.Verfeinern:=  Profildatei.ReadInteger('LB_Profil_'+IntToStr(Z),'Verfeinern',1);
      Letterboxed_ProfilListe.Items.AddObject(Profil.Name, Profil);
      Inc(Z);
    END;
    IF Z > 0 THEN
    BEGIN
      Letterboxed_ProfilListe.ItemIndex := 0;
      Profil := TProfil(Letterboxed_ProfilListe.items.Objects[0]);
      Letterboxed_ProfilName.Text:=Profil.Name;
      Letterboxed_INkorrektur.Text:=inttostr(Profil.INkorr);
      Letterboxed_OUTkorrektur.text:=inttostr(Profil.OUTkorr);
      Letterboxed_Schnittlaenge.Text:=inttostr(Profil.Laenge);
      Letterboxed_Schrittweite.Text:=inttostr(Profil.Schrittweite);
      Letterboxed_invertiert.Checked:=Profil.Invertiert;
      Letterboxed_Mingrau.Text:=inttostr(Profil.MinGrau);
      Letterboxed_Maxgrau.Text:=inttostr(Profil.MaxGrau);
      Letterboxed_ZeilenIgnorieren.Text:=inttostr(Profil.zeilenignorieren);
      Letterboxed_SpaltenIgnorieren.Text:=inttostr(Profil.spaltenignorieren);
      Letterboxed_zeilenoben.Text:='';
      Letterboxed_zeilenunten.Text:='';
      Letterboxed_spaltenlinks.Text:='';
      Letterboxed_spaltenrechts.Text:='';
      if Profil.Suchbereich=1 THEN
      begin
        rb_oben.Checked:=true;
        Letterboxed_zeilenoben.Text:=inttostr(Profil.Suchbereichswert);
      end
      else
      if Profil.Suchbereich=2 THEN
      begin
        rb_unten.Checked:=true;
        Letterboxed_zeilenunten.Text:=inttostr(Profil.Suchbereichswert);
      end
      else
      if Profil.Suchbereich=3 THEN
      begin
        rb_links.Checked:=true;
        Letterboxed_spaltenlinks.Text:=inttostr(Profil.Suchbereichswert);
      end
      else
      begin
        rb_rechts.Checked:=true;
        Letterboxed_spaltenrechts.Text:=inttostr(Profil.Suchbereichswert);
      end;
      case Profil.Verfeinern of
        1: lb_verf_lin.Checked:=true;
        2: lb_verf_bin.Checked:=true;
      else
        lb_verf_aus.Checked:=true;
      end;

    END;
    Z:=0;
    WHILE Profildatei.SectionExists('VProfil_'+IntToStr(Z)) DO
      BEGIN
      Liste:=TListe.Create;
      Profil:=TProfil.Create;
      Profil.Name:=        Profildatei.ReadString('VProfil_'+IntToStr(Z),'Name','Profil');
      Profil.INkorr:=      Profildatei.ReadInteger('VProfil_'+IntToStr(Z),'INkorrektur',0);
      Profil.OUTkorr:=     Profildatei.ReadInteger('VProfil_'+IntToStr(Z),'OUTkorrektur',0);
      Profil.Laenge:=      Profildatei.ReadInteger('VProfil_'+IntToStr(Z),'Laenge',300);
      Profil.Schrittweite:=Profildatei.ReadInteger('VProfil_'+IntToStr(Z),'Schrittweite',10);
      Profil.Invertiert:=  Profildatei.ReadBool('VProfil_'+IntToStr(Z),'Invertiert',false);
      Profil.Verfeinern:=  Profildatei.ReadInteger('VProfil_'+IntToStr(Z),'Verfeinern',1);
      Liste.Add(Profil);
      I:=0;
      WHILE NOT (Profildatei.ReadString('VProfil_'+IntToStr(Z), 'vgl-'+IntToStr(I),'')='') DO
      BEGIN
        Liste.Add(strToVglPixel(Profildatei.ReadString('VProfil_'+IntToStr(Z), 'vgl-'+IntToStr(I),'')));
        Inc(I);
      END;
      s:=Profildatei.ReadString('VProfil_'+IntToStr(Z), 'Name','Profil');
      Logo_Profilliste.Items.AddObject(s,Liste);
      Inc(z);
    END;
    IF Z > 0 THEN
    BEGIN
//      Logo_ProfilListe.ItemIndex := 0;

//      showmessage(inttostr(Logo_ProfilListe.ItemIndex));
      Logo_Pixelliste.Items.Clear;
//      showmessage(inttostr(Logo_Profilliste.itemindex));
      Logo_Profilname.text:=Logo_Profilliste.Items.Strings[0];
      Liste:=TListe(Logo_Profilliste.items.Objects[0]);
      Profil:=TProfil(Liste.Items[0]);
      Logo_ProfilName.Text:=Profil.Name;
      logo_INkorrektur.Text:=inttostr(Profil.INkorr);
      logo_OUTkorrektur.Text:=inttostr(Profil.OUTkorr);
      logo_len.Text:=inttostr(Profil.Laenge);
      logo_seek.Text:=inttostr(Profil.Schrittweite);
      logo_invertiert.Checked:=Profil.Invertiert;
      case Profil.Verfeinern of
        1: logo_verf_lin.Checked:=true;
        2: logo_verf_bin.Checked:=true;
      else
        logo_verf_aus.Checked:=true;
      end;

      for i:=1 to Liste.Count-1 do
      begin
        Pixel:=TvglPixel(Liste.Items[i]);
        Logo_PixelListe.Items.AddObject(vglPixelToStr(Pixel),Pixel);
      end;
      IF Logo_Pixelliste.Items.Count > 0 THEN
      begin
        Logo_Pixelliste.ItemIndex:=0;
        Pixel := TvglPixel(Logo_PixelListe.items.Objects[0]);
        Logo_posX.Text:=inttostr(Pixel.posX);
        Logo_posY.Text:=inttostr(Pixel.posY);
        logo_mingrau.Text:=inttostr(Pixel.mingrau);
        logo_maxgrau.Text:=inttostr(Pixel.maxgrau);
      end;
    end;
    ProfilDatei.Free;
  END;
end;

procedure TSchnittsucheFenster.ProfileSpeichern();

VAR ProfilDatei: TIniFile;
    Dateiname: String;
    Z,I: Integer;
    Profil : Tprofil;
    Liste : Tliste;
begin
  {$IFDEF LINUX}
    Dateiname := GetEnvironmentVariable('M2SHOME')+'SuchProfile.ini';
  {$ENDIF}
  {$IFDEF WIN32}
    Dateiname := ExtractFilePath(Application.ExeName)+'SuchProfile.ini';
  {$ENDIF}
  ProfilDatei := TIniFile.Create(Dateiname);
  // Alle alten Einträge entfernen
  Z := 0;
  WHILE ProfilDatei.SectionExists('Profil_'+IntToStr(Z)) DO
  BEGIN
    ProfilDatei.EraseSection('Profil_'+IntToStr(Z));
    Inc(Z);
  END;
  Z := 0;
  WHILE ProfilDatei.SectionExists('VProfil_'+IntToStr(Z)) DO
  BEGIN
    ProfilDatei.EraseSection('VProfil_'+IntToStr(Z));
    Inc(Z);
  END;
  Z := 0;
  WHILE ProfilDatei.SectionExists('LB_Profil_'+IntToStr(Z)) DO
  BEGIN
    ProfilDatei.EraseSection('LB_Profil_'+IntToStr(Z));
    Inc(Z);
  END;
  Profildatei.WriteString('Allgemein', 'InitDir', initDir);
  IF Audio_ProfilListe.Items.Count > 0 THEN
  BEGIN
    Z := 0;
    WHILE  Z < Audio_ProfilListe.Items.Count DO  //Profildatei.SectionExists('Profil_'+IntToStr(Z)) DO
    BEGIN
      Profil := TProfil(Audio_ProfilListe.Items.Objects[Z]);
      Profildatei.WriteInteger('Profil_'+IntToStr(Z), 'INkorrektur', Profil.INkorr);
      Profildatei.WriteInteger('Profil_'+IntToStr(Z), 'OUTkorrektur', Profil.OUTkorr);
      Profildatei.WriteInteger('Profil_'+IntToStr(Z), 'Laenge', Profil.Laenge);
      Profildatei.WriteString('Profil_'+IntToStr(Z), 'Name', Profil.Name);
      Profildatei.WriteString('Profil_'+IntToStr(Z), 'INframe', Profil.INframe);
      Profildatei.WriteString('Profil_'+IntToStr(Z), 'OUTframe', Profil.OUTframe);
      Inc(Z);
    END;
  END;
  IF Letterboxed_ProfilListe.Items.Count > 0 THEN
  BEGIN
    Z := 0;
    WHILE  Z < Letterboxed_ProfilListe.Items.Count DO  //Profildatei.SectionExists('Profil_'+IntToStr(Z)) DO
    BEGIN
      Profil := TProfil(Letterboxed_ProfilListe.Items.Objects[Z]);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'INkorrektur', Profil.INkorr);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'OUTkorrektur', Profil.OUTkorr);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'Laenge', Profil.Laenge);
      Profildatei.WriteString ('LB_Profil_'+IntToStr(Z), 'Name', Profil.Name);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'Schrittweite', Profil.Schrittweite);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'MinGrau', Profil.MinGrau);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'MaxGrau', Profil.MaxGrau);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'zeilenignorieren', Profil.zeilenignorieren);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'spaltenignorieren', Profil.spaltenignorieren);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'Suchbereich', Profil.Suchbereich);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'Suchbereichswert', Profil.Suchbereichswert);
      Profildatei.WriteBool   ('LB_Profil_'+IntToStr(Z), 'invertiert', Profil.Invertiert);
      Profildatei.WriteInteger('LB_Profil_'+IntToStr(Z), 'Verfeinern', Profil.Verfeinern);
      Inc(Z);
    END;
  END;
  IF Logo_Profilliste.Items.Count > 0 THEN
  BEGIN
    Z:=0;
    WHILE  Z < Logo_Profilliste.Items.Count DO
    BEGIN
      Liste:=TListe(Logo_Profilliste.Items.Objects[Z]);
      Profil:=TProfil(Liste.Items[0]);
      Profildatei.WriteString ('VProfil_'+IntToStr(Z),'Name',Profil.Name);
      Profildatei.WriteInteger('VProfil_'+IntToStr(Z),'INkorrektur',(Profil.INkorr));
      Profildatei.WriteInteger('VProfil_'+IntToStr(Z),'OUTkorrektur',(Profil.OUTkorr));
      Profildatei.WriteInteger('VProfil_'+IntToStr(Z),'Laenge',(Profil.Laenge));
      Profildatei.WriteInteger('VProfil_'+IntToStr(Z),'Schrittweite',(Profil.Schrittweite));
      Profildatei.WriteBool   ('VProfil_'+IntToStr(Z),'Invertiert',Profil.Invertiert);
      Profildatei.WriteInteger('VProfil_'+IntToStr(Z), 'Verfeinern', Profil.Verfeinern);
      I:=1;
      WHILE  I < Liste.Count DO
      BEGIN
        Profildatei.WriteString('VProfil_'+IntToStr(Z), 'vgl-'+inttoStr(I-1), VglPixelToStr(TvglPixel(Liste.Items[I])));
        Inc(I);
      END;
      Inc(Z);
    END;
    ProfilDatei.Free;
  END;
END;

function TSchnittsucheFenster.strToVglPixel(s : String):TvglPixel;
VAR i,j,z : Integer;
    Pixel : TVglPixel;
BEGIN
  Pixel:=TVglPixel.Create;
  i:=2;
  j:=2;
  z:=0;
  while (i <= (length(s)))do
  begin
    if (copy(s,i,1)=',') OR (copy(s,i,1)=']') THEN
    begin
      case z OF
        0 : Pixel.posX:=strToInt(copy(s,j,i-j));
        1 : Pixel.posY:=strToInt(copy(s,j,i-j));
        2 : Pixel.minGrau:=strToInt(copy(s,j,i-j));
        3 : Pixel.maxGrau:=strToInt(copy(s,j,i-j));
      end;
      inc(z);
      j:=i+1;
    END;
    inc(i);
  end;
  result:=Pixel;
END;

function TSchnittsucheFenster.VglPixelToStr(Pixel: TvglPixel):String;
BEGIN
result:='['+InttoStr(Pixel.posX)+','+InttoStr(Pixel.posY)+','
           +InttoStr(Pixel.minGrau)+','+InttoStr(Pixel.maxGrau)+']';
END;

// -------------------- Validieren der Eingaben ( Audio Schnittsuche )-----------------------

procedure TSchnittsucheFenster.WertePruefen(Sender:TObject);
begin
  IF  (StrToInt64Def(Audio_INKorrektur.Text, 1) = StrToInt64Def(Audio_INKorrektur.Text, -1))
  AND (StrToInt64Def(Audio_OUTKorrektur.Text, 1) = StrToInt64Def(Audio_OUTKorrektur.Text, -1))
  AND (StrToInt64Def(Audio_Laenge.Text, 1) = StrToInt64Def(Audio_Laenge.Text, -1))
  AND (Audio_frameINdatei.Text <> '')
  AND (Audio_frameOUTdatei.Text <> '')
  AND (Audio_ProfilName.Text <> '') THEN
  BEGIN
    Audio_Suchen.Enabled := True;
    AudioMenue_Neu.Enabled := True;
    Audio_neubtn.Enabled := True;
    IF (Audio_ProfilListe.ItemIndex >= 0) AND (Audio_ProfilListe.Items.Count > 0) THEN
    BEGIN
      AudioMenue_Aendern.Enabled := True;
      Audio_Aendernbtn.Enabled := true;
    END
    ELSE
    BEGIN
      AudioMenue_Aendern.Enabled := False;
      Audio_Aendernbtn.Enabled := False;
    END;
  END
  ELSE
  BEGIN
    Audio_Suchen.Enabled := False;
    AudioMenue_Neu.Enabled := False;
    Audio_neubtn.Enabled := False;
    AudioMenue_Aendern.Enabled := False;
    Audio_Aendernbtn.Enabled := False;
  END;
    IF (Audio_ProfilListe.ItemIndex >= 0) AND (Audio_ProfilListe.Items.Count > 0) THEN
      AudioMenue_Loeschen.Enabled := True
    else
      AudioMenue_Loeschen.Enabled := False;
end;

// -------------------- Validieren der Eingaben ( Pixelvergleiche )-----------------------

procedure TSchnittsucheFenster.LogoWertePruefen(Sender: TObject);
begin
  IF  (StrToInt64Def(Logo_posX.Text, -1) >=0)               // Positionen positiv
  AND (StrToInt64Def(Logo_posY.Text, -1) >=0)
  AND (StrToInt64Def(logo_mingrau.Text, -1) >=0)            // Farbwerte zwischen 0 und 255
  AND (StrToInt64Def(logo_mingrau.Text, 256) <=255)
  AND (StrToInt64Def(logo_maxgrau.Text, -1) >=0)
  AND (StrToInt64Def(logo_maxgrau.Text, 256) <=255) THEN
  BEGIN
    Logo_Neu.Enabled := true;                           // gueltige Werte, neu zulassen
    LogoPixelMenue_Neu.Enabled := true;
    IF (Logo_PixelListe.ItemIndex >= 0) AND (Logo_PixelListe.Items.Count > 0) THEN
    BEGIN
    logo_Aendern.Enabled:=true;                         // gueltige Werte und VergleichsPixel markiert
    LogoPixelMenue_Aendern.Enabled := true;                         // aendern zulassen
    END
    ELSE
    BEGIN
    logo_Aendern.Enabled:=false;
    LogoPixelMenue_Aendern.Enabled := false;
    END;
  END
  ELSE
  BEGIN
    Logo_Neu.Enabled := False;
    logo_Aendern.Enabled:=false;
    LogoPixelMenue_Neu.Enabled := false;;
    LogoPixelMenue_Aendern.Enabled := false;
  END;
  IF (Logo_PixelListe.ItemIndex >= 0) AND (Logo_PixelListe.Items.Count > 0) THEN
    LogoPixelMenue_Loeschen.Enabled := true                         // Pixel markiert, löschen zulassen
  else
    LogoPixelMenue_Loeschen.Enabled := false;
  LogoProfileWertePruefen(self);
end;

procedure TSchnittsucheFenster.LogoProfileWertePruefen(Sender: TObject);
begin
  IF  (Logo_PixelListe.Items.Count > 0)
  AND (StrToInt64Def(logo_len.Text, -1) >=0)    //positive Zahl ?
  AND (StrToInt64Def(logo_seek.Text, -1) >=0)   //positive Zahl ?
  AND (StrToInt64Def(logo_INkorrektur.Text, 1) = StrToInt64Def(logo_INkorrektur.Text, -1))   // Zahl ?
  AND (StrToInt64Def(logo_OUTkorrektur.Text, 1) = StrToInt64Def(logo_OUTkorrektur.Text, -1)) // Zahl ?
  AND (Logo_Profilname.Text<>'') THEN
  begin
    logo_suchen.Enabled:=true;
    IF  (Logo_Profilliste.Items.Count >0)
    AND (Logo_Profilliste.ItemIndex >=0) THEN
    begin
      LogoMenue_Aendern.Enabled:=true;
      logoProfil_aendern.Enabled:=true;
    end
    ELSE
    begin
      LogoMenue_Aendern.Enabled:=false;
      logoProfil_aendern.Enabled:=false;
    end;
    IF (Logo_PixelListe.Items.Count > 0) THEN
    begin
      LogoMenue_Neu.Enabled:=true;
      logoProfil_neu.Enabled:=true;
    end
    else
    begin
      LogoMenue_Neu.Enabled:=false;
      logoProfil_neu.Enabled:=false;
    end
  END
  else
  begin
    LogoMenue_Aendern.Enabled:=false;
    logo_suchen.Enabled:=false;
    LogoMenue_Neu.Enabled:=false;
    logoProfil_neu.Enabled:=false;
    logoProfil_aendern.Enabled:=false;
  end;
  IF (Logo_Profilliste.ItemIndex >=0) AND (Logo_Profilliste.Items.Count >0) THEN
    LogoMenue_Loeschen.Enabled:=true
  else
    LogoMenue_Loeschen.Enabled:=false;
  IF (Logo_Profilliste.Items.Count >0) THEN
    logo_Profile_testen.Enabled:=true
  else
    logo_Profile_testen.Enabled:=false;
end;
// -------------------- Validieren der Eingaben ( Letterboxed )-----------------------
procedure TSchnittsucheFenster.LetterboxedWertePruefen(Sender: TObject);
begin
  IF  (StrToInt64Def(letterboxed_mingrau.Text, -1) >=0)            // Farbwerte zwischen 0 und 255
  AND (StrToInt64Def(letterboxed_mingrau.Text, 256) <=255)
  AND (StrToInt64Def(letterboxed_maxgrau.Text, -1) >=0)
  AND (StrToInt64Def(letterboxed_maxgrau.Text, 256) <=255)
  AND (StrToInt64Def(Letterboxed_zeilenignorieren.Text, -1) >=0)
  AND (StrToInt64Def(Letterboxed_zeilenignorieren.Text, bildinfo.hoehe) < bildinfo.hoehe)
  AND (StrToInt64Def(Letterboxed_spaltenignorieren.Text, -1) >=0)
  AND (StrToInt64Def(Letterboxed_spaltenignorieren.Text, bildinfo.Breite) < bildinfo.Breite) THEN
  begin
    Letterboxed_Analysieren.Enabled:=true;
    IF  (StrToInt64Def(Letterboxed_Schnittlaenge.Text, -1) >=0)    //positive Zahl ?
    AND (StrToInt64Def(Letterboxed_Schrittweite.Text, -1) >=0)   //positive Zahl ?
    AND (StrToInt64Def(letterboxed_INkorrektur.Text, 1) = StrToInt64Def(letterboxed_INkorrektur.Text, -1))   // Zahl ?
    AND (StrToInt64Def(letterboxed_OUTkorrektur.Text, 1) = StrToInt64Def(letterboxed_OUTkorrektur.Text, -1)) // Zahl ?
    AND (
        (rb_oben.Checked AND (StrToInt64Def(Letterboxed_ZeilenOben.Text, -1) >0) AND (StrToInt64Def(Letterboxed_ZeilenOben.Text, -1) <bildinfo.Hoehe))
     OR (rb_unten.Checked AND (StrToInt64Def(Letterboxed_ZeilenUnten.Text, -1) >0) AND (StrToInt64Def(Letterboxed_ZeilenUnten.Text, -1) <bildinfo.Hoehe))
     OR (rb_links.Checked AND (StrToInt64Def(Letterboxed_SpaltenLinks.Text, -1) >0) AND (StrToInt64Def(Letterboxed_SpaltenLinks.Text, -1) <bildinfo.Breite))
     OR (rb_rechts.Checked AND (StrToInt64Def(Letterboxed_SpaltenRechts.Text, -1) >0) AND (StrToInt64Def(Letterboxed_SpaltenRechts.Text, -1) <bildinfo.Breite))
        )THEN
    begin
      Letterboxed_Suchen.Enabled:=true;
      IF (letterboxed_Profilname.Text='') THEN
      begin
      letterboxed_neubtn.Enabled:=false;
      letterboxedMenue_Neu.Enabled:=false;
      end
      else
      begin
        letterboxed_neubtn.Enabled:=true;
        letterboxedMenue_Neu.Enabled:=true;
      end;
      IF (Letterboxed_Profilliste.ItemIndex >=0) AND (Letterboxed_Profilliste.Items.Count >0)
      AND NOT(letterboxed_Profilname.Text='') THEN
      begin
        letterboxed_aendernbtn.Enabled:=true;
        letterboxedMenue_Aendern.Enabled:=true;
      end
      else
      begin
        letterboxed_aendernbtn.Enabled:=false;
        letterboxedMenue_Aendern.Enabled:=false;
      end;
    end
    else
    begin
      Letterboxed_Suchen.Enabled:=false;
      letterboxed_neubtn.Enabled:=false;
      letterboxed_aendernbtn.Enabled:=false;
    end;
  end
  else
  begin
    Letterboxed_Suchen.Enabled:=false;
    Letterboxed_Analysieren.Enabled:=false;
    letterboxed_neubtn.Enabled:=false;
    letterboxed_aendernbtn.Enabled:=false;
    letterboxedMenue_Aendern.Enabled:=false;
    letterboxedMenue_Neu.Enabled:=false;
  end;
  IF (Letterboxed_Profilliste.ItemIndex >=0) AND (Letterboxed_Profilliste.Items.Count >0) THEN
    LetterboxedMenue_Loeschen.Enabled:=true
  else
    LetterboxedMenue_Loeschen.Enabled:=false;
end;

// -------------------- Audioschnittsuche -----------------------
procedure TSchnittsucheFenster.AudioMenue_LoeschenClick(Sender: TObject);
begin
  deleteSelected(Audio_ProfilListe);
  wertepruefen(self);
end;

procedure TSchnittsucheFenster.AudioMenue_AendernClick(Sender: TObject);
VAR Profil : TProfil;
begin
  Profil := TProfil(Audio_ProfilListe.Items.Objects[Audio_ProfilListe.ItemIndex]);
  Profil.INkorr := strToInt64(Audio_INkorrektur.Text);
  Profil.OUTkorr := strToInt64(Audio_OUTkorrektur.Text);
  Profil.Laenge := strToInt64(Audio_Laenge.Text);
  Profil.Name := Audio_ProfilName.Text;
  Profil.INframe := Audio_frameINdatei.Hint;
  Profil.OUTframe := Audio_frameOUTdatei.Hint;
  Audio_ProfilListe.Items.Strings[Audio_ProfilListe.ItemIndex] := Audio_ProfilName.Text;
end;

procedure TSchnittsucheFenster.AudioMenue_NeuClick(Sender: TObject);
VAR Profil : TProfil;
begin
  Profil := TProfil.create;
  Profil.INkorr := strToInt64(Audio_INkorrektur.Text);
  Profil.OUTkorr := strToInt64(Audio_OUTkorrektur.Text);
  Profil.Laenge := strToInt64(Audio_Laenge.Text);
  Profil.Name := Audio_ProfilName.Text;
  Profil.INframe := Audio_frameINdatei.Hint;
  Profil.OUTframe := Audio_frameOUTdatei.Hint;
  Audio_ProfilListe.Items.AddObject(Audio_ProfilName.Text, Profil);
end;

procedure TSchnittsucheFenster.SuchProfileSelect(Sender: TObject);
VAR Profil : TProfil;
begin
  IF Audio_ProfilListe.ItemIndex > - 1 THEN
  BEGIN
    Profil := TProfil(Audio_ProfilListe.items.Objects[Audio_ProfilListe.ItemIndex]);
    Audio_INKorrektur.Text := IntToStr(Profil.INkorr);
    Audio_OUTKorrektur.Text := IntToStr(Profil.OUTkorr);
    Audio_Laenge.Text := IntToStr(Profil.Laenge);
    Audio_ProfilName.Text := Audio_ProfilListe.Items.Strings[Audio_ProfilListe.ItemIndex];
    Audio_frameINdatei.Hint:=Profil.INframe;
    Audio_frameOUTdatei.Hint:=Profil.OUTframe;
    Audio_frameINdatei.Text := ExtractFilename(Profil.INframe);
    Audio_frameOUTdatei.Text := ExtractFilename(Profil.OUTframe);
    wertePruefen(self);
  END;
end;

procedure TSchnittsucheFenster.vglFrameINClick(Sender: TObject);
begin
  Dateiladendialog.Title := Wortlesen(NIL, 'Dialog51', 'Vergleichsframe für IN auswählen');
  Dateiladendialog.Filter := 'Mpeg-Audio|*.mp2;*.mpa;*.ac3';
  Dateiladendialog.FileName := '';
  Dateiladendialog.InitialDir := initDir;
  IF Dateiladendialog.Execute THEN
  BEGIN
    Audio_frameINdatei.Text:=extractFilename(Dateiladendialog.FileName);
    Audio_frameINdatei.Hint:=Dateiladendialog.FileName;
    initDir:=extractFileDir(Dateiladendialog.FileName);
    wertePruefen(self);
  END;
end;

procedure TSchnittsucheFenster.vglFrameOUTClick(Sender: TObject);
begin
  Dateiladendialog.Title := Wortlesen(NIL, 'Dialog52', 'Vergleichsframe für OUT auswählen');
  Dateiladendialog.Filter := 'Mpeg-Audio|*.mp2;*.mpa;*.ac3';
  Dateiladendialog.FileName := '';
  Dateiladendialog.InitialDir := initDir;
  IF Dateiladendialog.Execute THEN
  BEGIN
    Audio_frameOUTdatei.Text:=extractFilename(Dateiladendialog.FileName);
    Audio_frameOUTdatei.Hint:=Dateiladendialog.FileName;
    initDir:=extractFileDir(Dateiladendialog.FileName);
    wertePruefen(self);
  END;
end;

// -------------------- Pixelvergleiche -----------------------

procedure TSchnittsucheFenster.Logo_PixelListeDblClick(Sender: TObject);
VAR Pixel : TvglPixel;
begin
  IF Logo_PixelListe.ItemIndex > - 1 THEN
  BEGIN
    Pixel := TvglPixel(Logo_PixelListe.items.Objects[Logo_PixelListe.ItemIndex]);
    Logo_posX.Text:=inttostr(Pixel.posX);
    Logo_posY.Text:=inttostr(Pixel.posY);
    logo_mingrau.Text:=inttostr(Pixel.mingrau);
    logo_maxgrau.Text:=inttostr(Pixel.maxgrau);
    logowertePruefen(self);
  END;
end;

procedure TSchnittsucheFenster.Logo_NeuClick(Sender: TObject);
VAR Pixel:TvglPixel;
begin
  Pixel:=TvglPixel.Create;
  Pixel.posX:=strtoint(Logo_posX.Text);
  Pixel.posY:=strtoint(Logo_posY.Text);
  Pixel.minGrau:=strtoint(logo_minGrau.Text);
  Pixel.maxGrau:=strtoint(logo_maxGrau.Text);
  Logo_PixelListe.Items.AddObject('['+Logo_posX.Text+','+Logo_posY.Text+','+logo_mingrau.Text+','+logo_maxgrau.Text+']',Pixel);
  logowertepruefen(self);
end;

procedure TSchnittsucheFenster.Logo_AendernClick(Sender: TObject);
VAR Pixel:TvglPixel;
begin
  Pixel := TvglPixel(Logo_PixelListe.Items.Objects[Logo_PixelListe.ItemIndex]);
  Pixel.posX:=strtoint(Logo_posX.Text);
  Pixel.posY:=strtoint(Logo_posY.Text);
  Pixel.minGrau:=strtoint(logo_minGrau.Text);
  Pixel.maxGrau:=strtoint(logo_maxGrau.Text);
  Logo_PixelListe.Items.Strings[Logo_PixelListe.ItemIndex] := VglPixelToStr(Pixel);
end;

procedure TSchnittsucheFenster.LogoPixelMenue_LoeschenClick(Sender: TObject);
begin
  deleteSelected(Logo_PixelListe);
  logowertepruefen(self);
end;

procedure TSchnittsucheFenster.LogoProfil_neuClick(Sender: TObject);
Var Liste:TListe;
    i:Integer;
    Profil:TProfil;
    vglPixel:TvglPixel;
begin
  Profil:=TProfil.Create;
  Profil.Name:=Logo_ProfilName.Text;
  Profil.INkorr:=strtoint(logo_INkorrektur.Text);
  Profil.OUTkorr:=strtoint(logo_OUTkorrektur.Text);
  Profil.Laenge:=strtoint(logo_len.Text);
  Profil.Schrittweite:=strtoint(logo_seek.Text);
  Profil.Invertiert:=logo_invertiert.Checked;
  if logo_verf_lin.Checked=true THEN
    Profil.verfeinern:=1
  else
  if logo_verf_bin.Checked=true THEN
    Profil.verfeinern:=2
  else
    Profil.verfeinern:=0;
  Liste:=Tliste.Create;
  Liste.Add(Profil);
  for i:=0 to Logo_PixelListe.Items.Count-1 do
  begin
    vglPixel:=TvglPixel.create;
    vglPixel.posX:=(TvglPixel(Logo_PixelListe.Items.Objects[i])).posX;
    vglPixel.posY:=(TvglPixel(Logo_PixelListe.Items.Objects[i])).posY;
    vglPixel.minGrau:=(TvglPixel(Logo_PixelListe.Items.Objects[i])).minGrau;
    vglPixel.maxGrau:=(TvglPixel(Logo_PixelListe.Items.Objects[i])).maxGrau;
    Liste.Add(vglPixel);
  end;
  Logo_Profilliste.Items.AddObject(Logo_Profilname.Text,Liste);
  LogoProfileWertePruefen(self);
end;

procedure TSchnittsucheFenster.Logo_ProfillisteDblClick(Sender: TObject);
Var Liste:TListe;
    i:Integer;
    Pixel:TvglPixel;
    Profil:TProfil;
begin
  Logo_Pixelliste.Items.Clear;
  Logo_Profilname.text:=Logo_Profilliste.Items.Strings[Logo_Profilliste.ItemIndex];
  Liste:=TListe(Logo_Profilliste.items.Objects[Logo_Profilliste.ItemIndex]);
  Profil:=TProfil(Liste.Items[0]);
  Logo_ProfilName.Text:=Profil.Name;
  logo_INkorrektur.Text:=inttostr(Profil.INkorr);
  logo_OUTkorrektur.Text:=inttostr(Profil.OUTkorr);
  logo_len.Text:=inttostr(Profil.Laenge);
  logo_seek.Text:=inttostr(Profil.Schrittweite);
  logo_invertiert.Checked:=Profil.Invertiert;
  for i:=1 to Liste.Count-1 do
  begin
    Pixel:=TvglPixel(Liste.Items[i]);
    Logo_PixelListe.Items.AddObject(vglPixelToStr(Pixel),Pixel);
  end;
  IF Logo_Pixelliste.Items.Count > 0 THEN
  begin
    Logo_Pixelliste.ItemIndex:=0;
    Pixel := TvglPixel(Logo_PixelListe.items.Objects[0]);
    Logo_posX.Text:=inttostr(Pixel.posX);
    Logo_posY.Text:=inttostr(Pixel.posY);
    logo_mingrau.Text:=inttostr(Pixel.mingrau);
    logo_maxgrau.Text:=inttostr(Pixel.maxgrau);
  end;
  case Profil.Verfeinern of
    1: logo_verf_lin.Checked:=true;
    2: logo_verf_bin.Checked:=true;
  else
    logo_verf_aus.Checked:=true;
  end;
  logowertepruefen(self);
end;

procedure TSchnittsucheFenster.logoProfil_LoeschenClick(Sender: TObject);
begin
  deleteSelected(Logo_ProfilListe);
  logoProfilewertepruefen(self);
end;

procedure TSchnittsucheFenster.Logo_FarbwertClick(Sender: TObject);
VAR p:pbyte;
    i:Integer;
begin
  p:=Pointer(aktuellesBild);
  for i:=1 to ((strtoint(Logo_posY.Text)*bildinfo.Breite)+strtoint(Logo_posX.Text)) do
    inc(p);
    Meldungsfenster(inttostr(p^));
//  showmessage(inttostr(p^));
end;

procedure TSchnittsucheFenster.LogoPixelMenue_ListeLeerenClick(Sender: TObject);
begin
  Logo_Pixelliste.Items.Clear;
  logowertepruefen(self);
end;

procedure TSchnittsucheFenster.LogoProfil_AendernClick(Sender: TObject);
Var Liste:TListe;
    i:Integer;
    Profil:TProfil;
begin
  Profil:=TProfil.Create;
  Profil.Name:=Logo_ProfilName.Text;
  Profil.INkorr:=strtoint(logo_INkorrektur.Text);
  Profil.OUTkorr:=strtoint(logo_OUTkorrektur.Text);
  Profil.Laenge:=strtoint(logo_len.Text);
  Profil.Schrittweite:=strtoint(logo_seek.Text);
  Profil.Invertiert:=logo_invertiert.Checked;
  if logo_verf_lin.Checked=true THEN
    Profil.verfeinern:=1
  else
  if logo_verf_bin.Checked=true THEN
    Profil.verfeinern:=2
  else
    Profil.verfeinern:=0;
  Liste:=TListe(Logo_Profilliste.Items.Objects[Logo_Profilliste.ItemIndex]);
  Liste.Clear;
  Liste.Add(Profil);
  for i:=0 to Logo_PixelListe.Items.Count-1 do
    Liste.Add(TvglPixel(Logo_PixelListe.Items.Objects[i]));
  Logo_Profilliste.Items.Strings[Logo_Profilliste.ItemIndex]:=Logo_Profilname.Text;
end;

// -------------------- Letterboxed -----------------------

procedure TSchnittsucheFenster.Letterboxed_ZeilenObenClick(Sender: TObject);
begin
  rb_oben.Checked:=true;
end;

procedure TSchnittsucheFenster.Letterboxed_ZeilenUntenClick(Sender: TObject);
begin
  rb_unten.Checked:=true;
end;

procedure TSchnittsucheFenster.Letterboxed_SpaltenLinksClick(Sender: TObject);
begin
  rb_links.Checked:=true;
end;

procedure TSchnittsucheFenster.Letterboxed_SpaltenRechtsClick(Sender: TObject);
begin
  rb_rechts.Checked:=true;
end;

procedure TSchnittsucheFenster.Letterboxed_NeuBtnClick(Sender: TObject);
Var Profil:TProfil;
begin
  Profil:=TProfil.Create;
  Profil.Name:=Letterboxed_ProfilName.Text;
  Profil.INkorr:=strtoint(Letterboxed_INkorrektur.Text);
  Profil.OUTkorr:=strtoint(Letterboxed_OUTkorrektur.Text);
  Profil.Laenge:=strtoint(Letterboxed_Schnittlaenge.Text);
  Profil.Schrittweite:=strtoint(Letterboxed_Schrittweite.Text);
  Profil.Invertiert:=Letterboxed_invertiert.Checked;
  Profil.zeilenignorieren:=strtoint(Letterboxed_ZeilenIgnorieren.Text);
  Profil.spaltenignorieren:=strtoint(Letterboxed_SpaltenIgnorieren.Text);
  Profil.MinGrau:=strtoint(Letterboxed_Mingrau.Text);
  Profil.MaxGrau:=strtoint(Letterboxed_Maxgrau.Text);
  if rb_oben.Checked THEN
  begin
    Profil.Suchbereich:=1;
    Profil.Suchbereichswert:=strtoint(Letterboxed_zeilenoben.Text)
  end
  else
  if rb_unten.Checked THEN
  begin
    Profil.Suchbereich:=2;
    Profil.Suchbereichswert:=strtoint(Letterboxed_zeilenunten.Text);
  end
  else
  if rb_links.Checked THEN
  begin
    Profil.Suchbereich:=3;
    Profil.Suchbereichswert:=strtoint(Letterboxed_spaltenlinks.Text);
  end
  else
  begin
    Profil.Suchbereich:=4;
    Profil.Suchbereichswert:=strtoint(Letterboxed_spaltenrechts.Text);
  end;

  if lb_verf_lin.Checked=true THEN
    Profil.verfeinern:=1
  else
  if lb_verf_bin.Checked=true THEN
    Profil.verfeinern:=2
  else
    Profil.verfeinern:=0;

  Letterboxed_Profilliste.Items.AddObject(Letterboxed_Profilname.Text,Profil);
  LetterboxedWertePruefen(self);
end;

procedure TSchnittsucheFenster.Letterboxed_AendernBtnClick(
  Sender: TObject);
Var Profil:TProfil;

begin
  Profil:=TProfil(Letterboxed_ProfilListe.Items.Objects[Letterboxed_Profilliste.ItemIndex]);
  Profil.Name:=Letterboxed_ProfilName.Text;
  Profil.INkorr:=strtoint(Letterboxed_INkorrektur.Text);
  Profil.OUTkorr:=strtoint(Letterboxed_OUTkorrektur.Text);
  Profil.Laenge:=strtoint(Letterboxed_Schnittlaenge.Text);
  Profil.Schrittweite:=strtoint(Letterboxed_Schrittweite.Text);
  Profil.Invertiert:=Letterboxed_invertiert.Checked;
  Profil.MinGrau:=strtoint(Letterboxed_Mingrau.Text);
  Profil.MaxGrau:=strtoint(Letterboxed_Maxgrau.Text);
  Profil.zeilenignorieren:=strtoint(Letterboxed_ZeilenIgnorieren.Text);
  Profil.spaltenignorieren:=strtoint(Letterboxed_SpaltenIgnorieren.Text);
  if rb_oben.Checked THEN
  begin
    Profil.Suchbereich:=1;
    Profil.Suchbereichswert:=strtoint(Letterboxed_zeilenoben.Text)
  end
  else
  if rb_unten.Checked THEN
  begin
    Profil.Suchbereich:=2;
    Profil.Suchbereichswert:=strtoint(Letterboxed_zeilenunten.Text);
  end
  else
  if rb_links.Checked THEN
  begin
    Profil.Suchbereich:=3;
    Profil.Suchbereichswert:=strtoint(Letterboxed_spaltenlinks.Text);
  end
  else
  begin
    Profil.Suchbereich:=4;
    Profil.Suchbereichswert:=strtoint(Letterboxed_spaltenrechts.Text);
  end;

  if lb_verf_lin.Checked=true THEN
    Profil.verfeinern:=1
  else
  if lb_verf_bin.Checked=true THEN
    Profil.verfeinern:=2
  else
    Profil.verfeinern:=0;

  Letterboxed_Profilliste.Items.Strings[Letterboxed_Profilliste.ItemIndex]:=Letterboxed_Profilname.Text;
  LetterboxedWertePruefen(self);
 end;

procedure TSchnittsucheFenster.LetterboxedMenue_LoeschenClick(
  Sender: TObject);
begin
  deleteSelected(Letterboxed_ProfilListe);
  LetterboxedWertePruefen(self);
end;

procedure TSchnittsucheFenster.Letterboxed_ProfillisteDblClick(
  Sender: TObject);
Var Profil:TProfil;
begin
  Profil:=TProfil(Letterboxed_ProfilListe.Items.Objects[Letterboxed_Profilliste.ItemIndex]);
  Letterboxed_ProfilName.Text:=Profil.Name;
  Letterboxed_INkorrektur.Text:=inttostr(Profil.INkorr);
  Letterboxed_OUTkorrektur.text:=inttostr(Profil.OUTkorr);
  Letterboxed_Schnittlaenge.Text:=inttostr(Profil.Laenge);
  Letterboxed_Schrittweite.Text:=inttostr(Profil.Schrittweite);
  Letterboxed_invertiert.Checked:=Profil.Invertiert;
  Letterboxed_Mingrau.Text:=inttostr(Profil.MinGrau);
  Letterboxed_Maxgrau.Text:=inttostr(Profil.MaxGrau);
  Letterboxed_zeilenoben.Text:='';
  Letterboxed_zeilenunten.Text:='';
  Letterboxed_spaltenlinks.Text:='';
  Letterboxed_spaltenrechts.Text:='';
  Letterboxed_ZeilenIgnorieren.Text:=inttostr(Profil.zeilenignorieren);
  Letterboxed_SpaltenIgnorieren.Text:=inttostr(Profil.spaltenignorieren);
  if Profil.Suchbereich=1 THEN
  begin
    rb_oben.Checked:=true;
    Letterboxed_zeilenoben.Text:=inttostr(Profil.Suchbereichswert);
  end
  else
  if Profil.Suchbereich=2 THEN
  begin
    rb_unten.Checked:=true;
    Letterboxed_zeilenunten.Text:=inttostr(Profil.Suchbereichswert);
  end
  else
  if Profil.Suchbereich=3 THEN
  begin
    rb_links.Checked:=true;
    Letterboxed_spaltenlinks.Text:=inttostr(Profil.Suchbereichswert);
  end
  else
  begin
    rb_rechts.Checked:=true;
    Letterboxed_spaltenrechts.Text:=inttostr(Profil.Suchbereichswert);
  end;
  case Profil.Verfeinern of
    1: lb_verf_lin.Checked:=true;
    2: lb_verf_bin.Checked:=true;
  else
    lb_verf_aus.Checked:=true;
  end;
  LetterboxedWertePruefen(self);
end;

// ----------------------- Audioanalyse --------------------------

procedure TSchnittsucheFenster.Audio_AnalysierenClick(Sender: TObject);
begin
    Schnittsuchefenster.PageControl.Pages[0].TabVisible:=false;
    Schnittsuchefenster.PageControl.Pages[1].TabVisible:=false;
    Schnittsuchefenster.PageControl.Pages[2].TabVisible:=false;
    Schnittsuchefenster.PageControl.Pages[3].TabVisible:=true;
    Schnittsuchefenster.PageControl.ActivePageIndex:=3 ;
end;

procedure TSchnittsucheFenster.Analyse_ZurueckClick(Sender: TObject);
begin
    Schnittsuchefenster.PageControl.Pages[0].TabVisible:=true;
    Schnittsuchefenster.PageControl.Pages[1].TabVisible:=true;
    Schnittsuchefenster.PageControl.Pages[2].TabVisible:=true;
    Schnittsuchefenster.PageControl.Pages[3].TabVisible:=false;
    Schnittsuchefenster.PageControl.ActivePageIndex:=2;
end;

procedure TSchnittsucheFenster.Analyse_datei1Click(Sender: TObject);
begin
  Dateiladendialog.Title := Wortlesen(NIL, 'Dialog53', 'Vergleichsdatei 1 laden');
  Dateiladendialog.Filter := 'Mpeg-Audio|*.mp2;*.mpa;*.ac3';
  Dateiladendialog.FileName := '';
  Dateiladendialog.InitialDir := initDir;
  IF Dateiladendialog.Execute THEN
  BEGIN
    Analyse_datei1.Text:=extractFilename(Dateiladendialog.FileName);
    Analyse_datei1.Hint:=Dateiladendialog.FileName;
    initDir:=extractFileDir(Dateiladendialog.FileName);
    AnalyseWertePruefen(self);
  END;
end;

procedure TSchnittsucheFenster.Analyse_datei2Click(Sender: TObject);
begin
  Dateiladendialog.Title := Wortlesen(NIL, 'Dialog54', 'Vergleichsdatei 2 laden');
  Dateiladendialog.Filter := 'Mpeg-Audio|*.mp2;*.mpa;*.ac3';
  Dateiladendialog.FileName := '';
  Dateiladendialog.InitialDir := initDir;
  IF Dateiladendialog.Execute THEN
  BEGIN
    Analyse_datei2.Text:=extractFilename(Dateiladendialog.FileName);
    Analyse_datei2.Hint:=Dateiladendialog.FileName;
    initDir:=extractFileDir(Dateiladendialog.FileName);
    AnalyseWertePruefen(self);
  END;
end;

procedure TSchnittsucheFenster.AnalyseWertePruefen(Sender: TObject);
BEGIN
  IF (Analyse_datei1.Text<>'') AND (Analyse_datei2.Text<>'') THEN
    Analyse_Suchen.Enabled:=true
  ELSE
    Analyse_Suchen.Enabled:=false;
  IF (Analyse_Ergebnisliste.ItemIndex >=0) AND (Analyse_Ergebnisliste.Items.Count >0) THEN
    Analyse_speichern.Enabled:=true
  ELSE
    Analyse_speichern.Enabled:=false;
  IF (Analyse_Ergebnisliste.Items.Count >0) THEN
    Analyse_ListeLeeren.Enabled:=true
  ELSE
    Analyse_ListeLeeren.Enabled:=false;
END;

procedure TSchnittsucheFenster.Analyse_ListeLeerenClick(Sender: TObject);
begin
  Analyse_Ergebnisliste.Clear;
  AnalyseWertePruefen(self);
end;

// ----------------------- Drag & Drop --------------------------
procedure TSchnittsucheFenster.Logo_ProfillisteStartDrag(Sender: TObject;
  var DragObject: TDragObject);
VAR I, J : Integer;
begin
  Profilbewegen := -1;
  I := 0;
  WHILE (I < Logo_Profilliste.Items.Count) AND (Profilbewegen < 0) DO
  BEGIN
    IF Logo_Profilliste.Selected[I] THEN
      Profilbewegen := I;
    Inc(I);
  END;
  J := -1;
  I := Logo_Profilliste.Items.Count - 1;
  WHILE (I > - 1) AND (J < 0) DO
  BEGIN
    IF Logo_Profilliste.Selected[I] THEN
      J := I;
    Dec(I);
  END;
  IF (J - Profilbewegen + 1) = Logo_Profilliste.SelCount THEN
    ProfilbewegenCount := Logo_Profilliste.SelCount
  ELSE
  BEGIN
    Profilbewegen := -1;
    ProfilbewegenCount := -1;
  END;
end;

procedure TSchnittsucheFenster.Logo_ProfillisteDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
VAR Punkt : TPoint;
    Ziel : Integer;
begin
//  test_.Caption:=inttostr(Profilbewegen);
  Accept := False;
  IF (Source = Logo_Profilliste) AND (Profilbewegen > - 1) THEN
  BEGIN
    Punkt.x:= x;
    Punkt.y:= y;
    Ziel := Logo_Profilliste.ItemAtPos(Punkt, True);
    Logo_Profilliste_itemindex:= Ziel;
    IF Ziel > -1 THEN
    BEGIN
      IF NOT Logo_Profilliste.Selected[Ziel] THEN
        Accept := True;
    END;
  END;
end;

procedure TSchnittsucheFenster.Logo_ProfillisteDragDrop(Sender,
  Source: TObject; X, Y: Integer);
VAR I, J : Integer;

begin
  J := Logo_Profilliste_ItemIndex;
  IF (Source = Logo_Profilliste) AND (Profilbewegen > - 1) THEN
  BEGIN
    IF Profilbewegen < Logo_Profilliste_itemindex THEN
      FOR I := 1 TO ProfilbewegenCount DO
      BEGIN
        Logo_Profilliste.Items.Move(Profilbewegen, J);
        Logo_Profilliste.Selected[J] := True;
      END
    ELSE
      FOR I := 1 TO ProfilbewegenCount DO
      BEGIN
        Logo_Profilliste.Items.Move(Profilbewegen + ProfilbewegenCount - 1, J);
        Logo_Profilliste.Selected[J] := True;
      END;
    Profilbewegen := -1;
    ProfilbewegenCount := -1;
  END;
end;

procedure TSchnittsucheFenster.Logo_ProfillisteEndDrag(Sender,
  Target: TObject; X, Y: Integer);
VAR I : Integer;

begin
  FOR I := 1 TO ProfilbewegenCount DO
  BEGIN
    Logo_Profilliste.Selected[Profilbewegen] := True;
    Inc(Profilbewegen);
  END;
  Profilbewegen := -1;
  ProfilbewegenCount := -1;
end;

procedure TSchnittsucheFenster.Logo_ProfillisteMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
VAR Punkt : TPoint;

begin
  IF Button = mbLeft THEN
  BEGIN
    Punkt.x:= x;
    Punkt.y:= y;
    IF Logo_Profilliste.ItemAtPos(Punkt, True) = -1 THEN
    BEGIN
      Logo_Profilliste.ClearSelection;
      Logo_Profilliste.ItemIndex := -1;
    END;
  END;
end;

procedure TSchnittsucheFenster.Letterboxed_ProfillisteStartDrag(
  Sender: TObject; var DragObject: TDragObject);
VAR I, J : Integer;
begin
  Profilbewegen := -1;
  I := 0;
  WHILE (I < Letterboxed_Profilliste.Items.Count) AND (Profilbewegen < 0) DO
  BEGIN
    IF Letterboxed_Profilliste.Selected[I] THEN
      Profilbewegen := I;
    Inc(I);
  END;
  J := -1;
  I := Letterboxed_Profilliste.Items.Count - 1;
  WHILE (I > - 1) AND (J < 0) DO
  BEGIN
    IF Letterboxed_Profilliste.Selected[I] THEN
      J := I;
    Dec(I);
  END;
  IF (J - Profilbewegen + 1) = Letterboxed_Profilliste.SelCount THEN
    ProfilbewegenCount := Letterboxed_Profilliste.SelCount
  ELSE
  BEGIN
    Profilbewegen := -1;
    ProfilbewegenCount := -1;
  END;
end;

procedure TSchnittsucheFenster.Letterboxed_ProfillisteDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
VAR Punkt : TPoint;
    Ziel : Integer;
begin
  Accept := False;
  IF (Source = Letterboxed_Profilliste) AND (Profilbewegen > - 1) THEN
  BEGIN
    Punkt.x:= x;
    Punkt.y:= y;
    Ziel := Letterboxed_Profilliste.ItemAtPos(Punkt, True);
    Letterboxed_Profilliste_itemindex := Ziel ;
    IF Ziel > -1 THEN
    BEGIN
      IF NOT Letterboxed_Profilliste.Selected[Ziel] THEN
        Accept := True;
    END;
  END;
end;

procedure TSchnittsucheFenster.Letterboxed_ProfillisteDragDrop(Sender,
  Source: TObject; X, Y: Integer);
VAR I, J : Integer;

begin
  J := Letterboxed_Profilliste_ItemIndex;
  IF (Source = Letterboxed_Profilliste) AND (Profilbewegen > - 1) THEN
  BEGIN
    IF Profilbewegen < Letterboxed_Profilliste_ItemIndex THEN
      FOR I := 1 TO ProfilbewegenCount DO
      BEGIN
        Letterboxed_Profilliste.Items.Move(Profilbewegen, J);
        Letterboxed_Profilliste.Selected[J] := True;
      END
    ELSE
      FOR I := 1 TO ProfilbewegenCount DO
      BEGIN
        Letterboxed_Profilliste.Items.Move(Profilbewegen + ProfilbewegenCount - 1, J);
        Letterboxed_Profilliste.Selected[J] := True;
      END;
    Profilbewegen := -1;
    ProfilbewegenCount := -1;
  END;
end;

procedure TSchnittsucheFenster.Letterboxed_ProfillisteEndDrag(Sender,
  Target: TObject; X, Y: Integer);
VAR I : Integer;

begin
  FOR I := 1 TO ProfilbewegenCount DO
  BEGIN
    Letterboxed_Profilliste.Selected[Profilbewegen] := True;
    Inc(Profilbewegen);
  END;
  Profilbewegen := -1;
  ProfilbewegenCount := -1;
end;

procedure TSchnittsucheFenster.Letterboxed_ProfillisteMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
VAR Punkt : TPoint;

begin
  IF Button = mbLeft THEN
  BEGIN
    Punkt.x:= x;
    Punkt.y:= y;
    IF Letterboxed_Profilliste.ItemAtPos(Punkt, True) = -1 THEN
    BEGIN
      Letterboxed_Profilliste.ClearSelection;
      Letterboxed_Profilliste.ItemIndex := -1;
    END;
  END;
end;

procedure TSchnittsucheFenster.Audio_ProfilListeStartDrag(Sender: TObject;
  var DragObject: TDragObject);
VAR I, J : Integer;
begin
  Profilbewegen := -1;
  I := 0;
  WHILE (I < Audio_Profilliste.Items.Count) AND (Profilbewegen < 0) DO
  BEGIN
    IF Audio_Profilliste.Selected[I] THEN
      Profilbewegen := I;
    Inc(I);
  END;
  J := -1;
  I := Audio_Profilliste.Items.Count - 1;
  WHILE (I > - 1) AND (J < 0) DO
  BEGIN
    IF Audio_Profilliste.Selected[I] THEN
      J := I;
    Dec(I);
  END;
  IF (J - Profilbewegen + 1) = Audio_Profilliste.SelCount THEN
    ProfilbewegenCount := Audio_Profilliste.SelCount
  ELSE
  BEGIN
    Profilbewegen := -1;
    ProfilbewegenCount := -1;
  END;
end;

procedure TSchnittsucheFenster.Audio_ProfilListeDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
VAR Punkt : TPoint;
    Ziel : Integer;
begin
  Accept := False;
  IF (Source = Audio_Profilliste) AND (Profilbewegen > - 1) THEN
  BEGIN
    Punkt.x:= x;
    Punkt.y:= y;
    Ziel := Audio_Profilliste.ItemAtPos(Punkt, True);
    Audio_Profilliste_itemindex:= Ziel ;
    IF Ziel > -1 THEN
    BEGIN
      IF NOT Audio_Profilliste.Selected[Ziel] THEN
        Accept := True;
    END;
  END;
end;

procedure TSchnittsucheFenster.Audio_ProfilListeDragDrop(Sender,
  Source: TObject; X, Y: Integer);
VAR I, J : Integer;

begin
  J := Audio_Profilliste_ItemIndex;
  IF (Source = Audio_Profilliste) AND (Profilbewegen > - 1) THEN
  BEGIN
    IF Profilbewegen < Audio_Profilliste.ItemIndex THEN
      FOR I := 1 TO ProfilbewegenCount DO
      BEGIN
        Audio_Profilliste.Items.Move(Profilbewegen, J);
        Audio_Profilliste.Selected[J] := True;
      END
    ELSE
      FOR I := 1 TO ProfilbewegenCount DO
      BEGIN
        Audio_Profilliste.Items.Move(Profilbewegen + ProfilbewegenCount - 1, J);
        Audio_Profilliste.Selected[J] := True;
      END;
    Profilbewegen := -1;
    ProfilbewegenCount := -1;
  END;
end;

procedure TSchnittsucheFenster.Audio_ProfilListeEndDrag(Sender,
  Target: TObject; X, Y: Integer);
VAR I : Integer;

begin
  FOR I := 1 TO ProfilbewegenCount DO
  BEGIN
    Audio_Profilliste.Selected[Profilbewegen] := True;
    Inc(Profilbewegen);
  END;
  Profilbewegen := -1;
  ProfilbewegenCount := -1;
end;

procedure TSchnittsucheFenster.Audio_ProfilListeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
VAR Punkt : TPoint;

begin
  IF Button = mbLeft THEN
  BEGIN
    Punkt.x:= x;
    Punkt.y:= y;
    IF Audio_Profilliste.ItemAtPos(Punkt, True) = -1 THEN
    BEGIN
      Audio_Profilliste.ClearSelection;
      Audio_Profilliste.ItemIndex := -1;
    END;
  END;
end;

// -------------------- Sprachen-Verwaltung -----------------------

PROCEDURE TSchnittsucheFenster.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Caption := Wortlesen(Spracheladen, 'SchnittsucheFenster', Caption);
  FOR I := 0 TO ComponentCount - 1 DO
  BEGIN
    Komponente := Components[I];
    IF Komponente IS TButton THEN             // in der Unit StdCtrls
    BEGIN
      TButton(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TButton(Komponente).Caption);
      TButton(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TButton(Komponente).Hint);
    END;
{    IF Komponente IS TBitBtn THEN             // in der Unit Buttons
    BEGIN
      TBitBtn(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TBitBtn(Komponente).Caption);
      TBitBtn(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TBitBtn(Komponente).Hint);
    END;   }
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
      TLabel(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TLabel(Komponente).Caption);
      TLabel(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TLabel(Komponente).Hint);
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
END;

procedure TSchnittsucheFenster.SliceInfo1Click(Sender: TObject);
VAR Pixel:TvglPixel;
    first,last:byte;
    i,x :integer;
begin
  {0x01 - 0xAF slice , zulaessige Werte laut mpeg2-spezifikation }
  first:=255;
  last:=0;
  for i:=0 to Logo_PixelListe.Items.Count-1 do
  begin
    Pixel := TvglPixel(Logo_PixelListe.Items.Objects[i]);
    x:=1+(Pixel.posY div 16);
    if x < first then
      first:=x;
    if x > last then
      last:=x;
  end;
  if last > 0 then
    Meldungsfenster('Untersucht werden folgende slices: '+inttostr(first)+' bis '+inttostr(last));
//    showmessage('Untersucht werden folgende slices: '+inttostr(first)+' bis '+inttostr(last));
end;

procedure TSchnittsucheFenster.Logo_ProfillisteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then //AND Sender = Logo_Profilliste then  { Nur ziehen, wenn linke Maustaste gedrückt ist }
    with Sender as TListBox do  { Sender als TFileListBox behandeln }
      begin
        if ItemAtPos(Point(X, Y), True) >= 0 then  { Ist ein Element vorhanden? }
        begin
          BeginDrag(False);  { Falls ja, Drag-Operation starten }
        end;
      end
   else
   if Button = mbRight then
     Logo_ProfilListeMenue.popup(left+Logo_Profilliste.Left+X+10,top+Y+78);
end;

procedure TSchnittsucheFenster.Letterboxed_ProfillisteMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Button = mbLeft then //AND Sender = Logo_Profilliste then  { Nur ziehen, wenn linke Maustaste gedrückt ist }
    with Sender as TListBox do  { Sender als TFileListBox behandeln }
      begin
        if ItemAtPos(Point(X, Y), True) >= 0 then  { Ist ein Element vorhanden? }
        begin
          BeginDrag(False);  { Falls ja, Drag-Operation starten }
        end;
      end
   else
   if Button = mbRight then
     Letterboxed_ProfilListeMenue.popup(left+Letterboxed_Profilliste.Left+X+10,top+Y+185);
end;

procedure TSchnittsucheFenster.Audio_ProfilListeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then //AND Sender = Logo_Profilliste then  { Nur ziehen, wenn linke Maustaste gedrückt ist }
    with Sender as TListBox do  { Sender als TListBox behandeln }
      begin
        if ItemAtPos(Point(X, Y), True) >= 0 then  { Ist ein Element vorhanden? }
        begin
          BeginDrag(False);  { Falls ja, Drag-Operation starten }
        end;
      end
   else
   if Button = mbRight then
//     Audio_ProfilMenue.popup(Framevergleiche.left+X,Framevergleiche.top+Y);
     Audio_ProfilMenue.popup(left+Audio_Profilliste.Left+X+10,top+Y+78);

end;

end.

