{-----------------------------------------------------------------------------------
Diese Unit implementiert eine Grobansicht zur Schnittsuche

Copyright (C) 2006  Bernd Ohse
 Homepage: n/a
 E-Mail:   ???

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

--------------------------------------------------------------------------------------}

{-------------------------------------------------------------------------------------

Anleitung zum Auffinden von Werbung:
Durch Erstellung der Filmgrobansicht :

  Menüpunkt: ZUsatzfunktionen | Grobansicht zur Schnittsuche

wird im Abstand von jeweils  mind. 2 Minuten ein Bild aus dem Film geschnitten
und festgehalten. Der Abstand sollte so gewählt werden, daß mit Sicherheit
jede Werbung mind. einmal getrofeen wird.
normale Werbeblöcke haben eine Länge zwischen 8 .. 10 Minuten, sodaß
eine Länge von 2 Minuten völlig ausreicht. Der Abstand kann wahrscheinlich
auf 3 Minuten erhöht werden. (Hier wären Rückmeldungen aus der Praxis hilfreich)

Durch Clicken auf ein Bild der Grobansicht wird das Startbild , markiert duch einen
gelben Rahmen , durch Clicken mit SHIFT das Endbild, markiert mit rotem Rahmen
eingestellt. Die Startposition für die binäre Suche wird auf die Mitte des
Suchbereichs eingestellt -->(Anfang+Ende)/2.
Anfang des Werbeblocks suchen:
Startbild auf beliebiges Bild vor dem Werbeblock setzen
Endbild   auf beliebiges Bild im Werbeblock setzen
Jetzt muß visuell entschieden werden ob das
augenblickliche Bild im Film oder in der Werbung liegt.
liegt es in der Werbung Button Binärsuche zurück clicken (Anfang des Werbeblocks wird gesucht)
liegt es im Film Button Binärsuche vor clicken
Entsprechend der ausgewählten Richtung wird der Suchbereich um die Hälfte verkleinert
daher : binäre Suche
Ende des Werbeblocks suchen:
Vorgehen wie zuvor, jedoch genau in umgekehrter Reihenfolge

Die Suche führt mit wenigen Clicks (8..12) auf die gesuchte Position

Anfang und Ende des Films lassen sich natürlich genau so finden.

Ein Rechtsclick auf ein Bild der Grobansicht stellt das Mpeg2Schitt-Hauptfenster
auf die mit diesem Bild verbunden Position ein:

Achtung!!! Für die binäre Suche ist das keine gute Ausgangsposition.

Die lästige Wiederholung von Filmsequenzen am Ende der Werbung ist
damit leider nicht zu finden.
----------------------------------------------------------------------------------------}
unit FilmGrobAnsicht;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, ComCtrls, Spin, IniFiles, Buttons,
  AllgFunktionen, AllgVariablen, binaereSuche, Arbeitsumgebung, Sprachen;

type

  TBildzuBitmap = function(Position: LongInt; Weite: Integer; Positionwiederherstellen, IFrame: Boolean): TBitmap of object; // neu Martin
  TPositionsetzen = procedure(Pos: LongInt; verwendeUndo: Boolean = False) of object; // neu Martin

  TMpegImage = class(TImage)
  public
    BildIndex: Integer;
    BildNr: Integer;
  end;

  TFilmGrobAnsichtFrm = class(TForm)
    TopPanel: TPanel;
    FensterPopup: TPopupMenu;
    FensterSchliessen: TMenuItem;
    FensterimVordergrund: TMenuItem;
    FenstermitRahmen: TMenuItem;
    FensterPanel: TPanel;
    GrobansichtScrollBox: TScrollBox;
    BildPanel: TPanel;
    GrossansichtSymbolleistePanel: TPanel;
    AuffrischenBtn: TSpeedButton;
    bSuchesetzenBtn: TSpeedButton;
    FensterSymbolleiste: TMenuItem;
    Dummy: TPopupMenu;
    binaereSucheBtn1: TSpeedButton;
    binaereSucheBtn2: TSpeedButton;
    Trennlinie1: TMenuItem;
    AuffrischenItemIndex: TMenuItem;
    bSuchesetzenItemIndex: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure alsAnfangsetzen1Click(Sender: TObject);
    procedure alsEndesetzen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure alsaktuellePositionsetzen1Click(Sender: TObject);
    procedure AuffrischenBtnClick(Sender: TObject);
    procedure bSuchesetzenBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FensterSchliessenClick(Sender: TObject);
    procedure FensterimVordergrundClick(Sender: TObject);
    procedure FenstermitRahmenClick(Sender: TObject);
    procedure FensterSymbolleisteClick(Sender: TObject);
    procedure binaereSucheBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    TopicImage: TMpegImage;
    Aktivgewaehlt: Integer;
    Anfanggewaehlt: Integer;                                                    // Variablen
    EndeGewaehlt: Integer;                                                      // nach Private
    IMPanels: array of TPanel;
    PanelImages: array of TMpegImage;
    FPositionsetzen : TPositionsetzen;                                          // neu Martin
    FBildzuBitmap : TBildzuBitmap;                                              // neu Martin
// ----------------------- binäre Suche ----------------------------------------
    WerbePosition,
    FilmPosition : LongInt;
    AktuellePosition : LongInt;
// ----------------------- Filmübersicht ---------------------------------------
    procedure Aktivsetzen;
    procedure AnfangSetzen;
    procedure ClearPanels;
    procedure Endesetzen;
//    procedure Grenzenpruefenundsetzen;                                        // geändert Martin
    procedure Bilderanzeigen;                                                   // neu Martin 2
    procedure InitImageArray(Anzahl: Integer; Ratio: Double);
// ----------------------- binäre Suche ----------------------------------------
    PROCEDURE SetzeBildPosition;
// ----------------------- Fenster ---------------------------------------------
    PROCEDURE SetzeFensterimVordergrund;
    PROCEDURE SetzeFenstermitRahmen;
    PROCEDURE SetzeFensterSymbolleiste;
  public
    { Public-Deklarationen }
    MaxBildNr: Integer;
    HandleHauptFenster: Integer;
    property OnPositionsetzen: TPositionsetzen write FPositionsetzen;           // neu Martin
    property OnBildzuBitmap: TBildzuBitmap write FBildzuBitmap;                 // neu Martin
    procedure Bildereinlesen;
    PROCEDURE Fensterpositionsetzen;
    PROCEDURE Fensterpositionmerken;
    PROCEDURE binaereSucheKlick(Taste: Integer);
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
  FilmGrobAnsichtFrm: TFilmGrobAnsichtFrm;

implementation

{$R *.dfm}

procedure TFilmGrobAnsichtFrm.AnfangSetzen;
var
  OldGewaehlt: Integer;
begin
  if TopicImage <> nil then
  begin
    OldGewaehlt := Anfanggewaehlt;
    AnfangGewaehlt := TopicImage.BildIndex;
    if OldGewaehlt <> -1 then
      if OldGewaehlt = EndeGewaehlt then                                        // geändert Martin 2
        IMPanels[OldGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeWerbung // geändert Martin 2
      else                                                                      // geändert Martin 2
        if OldGewaehlt = Aktivgewaehlt then                                      // geändert Martin 2
          IMPanels[OldGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeAktiv
        else
          IMPanels[OldGewaehlt].Color := clBtnFace;
    IMPanels[AnfangGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeFilm;
    if PanelImages[Anfanggewaehlt].BildNr > Bilderzahl then                     // neu Martin 2
    BEGIN
      FilmPosition := Bilderzahl;
      SetzeBildPosition;
    END
    else                                                                        // neu Martin 2
    BEGIN
      FilmPosition := PanelImages[Anfanggewaehlt].BildNr;
      SetzeBildPosition;
    END;
  end;
end;

procedure TFilmGrobAnsichtFrm.ClearPanels;
var
    I : Integer;
begin
  for I := 0 to High(IMPanels) do                                               // geändert Martin
  begin
    PanelImages[i].Free;
    IMPanels[i].Free;
  end; // for
end;

procedure TFilmGrobAnsichtFrm.Endesetzen;
var
  OldGewaehlt: Integer;
begin
  if TopicImage <> nil then
  begin
    OldGewaehlt := EndeGewaehlt;
    EndeGewaehlt := TopicImage.BildIndex;
    if OldGewaehlt <> -1 then
      if OldGewaehlt = Anfanggewaehlt then                                      // geändert Martin 2
        IMPanels[OldGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeFilm  // geändert Martin 2
      else                                                                      // geändert Martin 2
        if OldGewaehlt = Aktivgewaehlt then                                     // geändert Martin 2
          IMPanels[OldGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeAktiv
        else
          IMPanels[OldGewaehlt].Color := clBtnFace;
    IMPanels[EndeGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeWerbung;
    if PanelImages[Endegewaehlt].BildNr > Bilderzahl then                       // neu Martin 2
    BEGIN
      WerbePosition := Bilderzahl;
      SetzeBildPosition;
    END
    else                                                                        // neu Martin 2
    BEGIN
      WerbePosition := PanelImages[Endegewaehlt].BildNr;
      SetzeBildPosition;
    END;
  end;
end;

procedure TFilmGrobAnsichtFrm.Aktivsetzen;
var
  OldGewaehlt: Integer;
begin
  if TopicImage <> nil then
  begin
    OldGewaehlt := Aktivgewaehlt;
    Aktivgewaehlt := TopicImage.BildIndex;
    if OldGewaehlt <> -1 then
      if OldGewaehlt = Anfanggewaehlt then                                      // geändert Martin 2
        IMPanels[OldGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeFilm  // geändert Martin 2
      else
        if OldGewaehlt = Endegewaehlt then
          IMPanels[OldGewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeWerbung  // geändert Martin 2
        else
          IMPanels[OldGewaehlt].Color := clBtnFace;
    IMPanels[Aktivgewaehlt].Color := ArbeitsumgebungObj.GrobansichtFarbeAktiv;
  end;
  IF Assigned(FPositionsetzen) THEN
    FPositionsetzen(TopicImage.BildNr, True);
end;

procedure TFilmGrobAnsichtFrm.Bilderanzeigen;                                   // neu Martin 2

VAR BilderProZeile,
    Zeilen,
    I, J, Z : Integer;

begin
  if High(IMPanels) > -1 then
  begin
    if GrobansichtScrollBox.ClientHeight < (IMPanels[0].Height * 2) then
    begin
      BilderProZeile := High(IMPanels) + 1;
      Zeilen := 1;
      BildPanel.Width := BilderProZeile * (ArbeitsumgebungObj.GrobansichtBildweite + 10);
      BildPanel.Height := GrobansichtScrollBox.ClientHeight;
    end
    else
    begin
      BilderProZeile := GrobansichtScrollBox.Width div (ArbeitsumgebungObj.GrobansichtBildweite + 10);
      if BilderProZeile < 1 then
        BilderProZeile := 1;
      Zeilen := (High(IMPanels) + 1) div BilderProZeile;
      if (Zeilen * BilderProZeile) < (High(IMPanels) + 1) then
        inc(Zeilen);
      if (Zeilen * IMPanels[0].Height) > (GrobansichtScrollBox.Height - 5) then
      begin
        BilderProZeile := (GrobansichtScrollBox.Width - 15) div (ArbeitsumgebungObj.GrobansichtBildweite + 10);
        if BilderProZeile < 1 then
          BilderProZeile := 1;
        Zeilen := (High(IMPanels) + 1) div BilderProZeile;
        if (Zeilen * BilderProZeile) < (High(IMPanels) + 1) then
          inc(Zeilen);
      end;
      BildPanel.Height := Zeilen * IMPanels[0].Height;
      BildPanel.Width := GrobansichtScrollBox.ClientWidth;
    end;
    Z := 0;
    for I := 0 to Zeilen - 1 do
      for J := 0 to BilderProZeile - 1 do
        if Z < (High(IMPanels) + 1) then
        begin
          IMPanels[Z].Left := J * (ArbeitsumgebungObj.GrobansichtBildweite + 10);
          IMPanels[Z].Top := I * IMPanels[0].Height;
          inc(Z);
        end;
  end
  else
  begin
    BildPanel.Height := GrobansichtScrollBox.ClientHeight;
    BildPanel.Width := GrobansichtScrollBox.ClientWidth;
  end;
end;

procedure TFilmGrobAnsichtFrm.InitImageArray(Anzahl: Integer; Ratio: Double);
var
  I: Integer;
  IM: TMpegImage;
  IP: TPanel;

begin
  ClearPanels;
  WerbePosition := -1;
  FilmPosition := -1;
  Aktivgewaehlt := -1;
  Anfanggewaehlt := -1;
  EndeGewaehlt := -1;
  binaereSucheBtn1.Caption := '??:??:??:??';
  binaereSucheBtn2.Caption := '??:??:??:??';
  binaereSucheForm.binaereSucheKlick := binaereSucheKlick;
  binaereSucheForm.Init;
  SetLength(IMPanels, Anzahl);
  SetLength(PanelImages, Anzahl);
  for I := 0 to Anzahl - 1 do
  begin
    IP := TPanel.Create(nil);
    if IP <> nil then
    begin
      IP.Parent := BildPanel;
      IP.Width := ArbeitsumgebungObj.GrobansichtBildweite + 10;
      IP.Height := trunc((ArbeitsumgebungObj.GrobansichtBildweite + 10) / Ratio);
      IP.Bevelouter := bvLowered;
      IP.BorderWidth := 4;
      IP.Align := alNone;
      IMPanels[I] := IP;
    end
    else
      break;
    IM := TMpegImage.Create(nil);
    if IM <> nil then
    begin
      IM.Name := Format('IM%d', [I]);
      PanelImages[I] := IM;
      IM.BildIndex := I;
      IM.Stretch := true;
      IM.Align := alClient;
      IM.Parent := IP;
      IM.OnMouseDown := ImageMouseDown;
      im.PopupMenu := Dummy;
    end
    else
      break;
  end;
  Bilderanzeigen;
end;

procedure TFilmGrobAnsichtFrm.FormDestroy(Sender: TObject);
begin
  //dynamische Arrays wieder freigeben
  ClearPanels;
end;

procedure TFilmGrobAnsichtFrm.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Sender is TMpegImage then
  begin
    TopicImage := TMpegImage(Sender);
    if Button = mbLeft then
    begin
      if ssSHift in Shift then
        Endesetzen
      else
        AnfangSetzen;
    end
    else
      if Button = mbRight then
        Aktivsetzen;
  end;
end;

procedure TFilmGrobAnsichtFrm.alsAnfangsetzen1Click(Sender: TObject);
begin
  Anfangsetzen;
end;

procedure TFilmGrobAnsichtFrm.alsEndesetzen1Click(Sender: TObject);
begin
  Endesetzen;
end;

procedure TFilmGrobAnsichtFrm.FormCreate(Sender: TObject);
begin
  Anfanggewaehlt := -1;                                                         // neu Martin
  EndeGewaehlt := -1;                                                           // neu Martin
  Bilderanzeigen;
end;

procedure TFilmGrobAnsichtFrm.alsaktuellePositionsetzen1Click(Sender: TObject);
begin
  FPositionsetzen(TMpegimage(Sender).BildNr, True);                             // geändert Martin
end;

procedure TFilmGrobAnsichtFrm.Bildereinlesen;                                                       // neu Martin
var
  Zaehler,
  Anzahl,
  BildNr: Integer;
  bmp: TBitmap;

  function CreateGrobImageVonBildposition(Position:LongInt; Zaehler:Integer; Poswiederher, IFrame:Boolean): integer;
  var
    IM: TMpegImage;
  begin
    IM := PanelImages[Zaehler];
    if Assigned(IM) then
    begin
      IM.BildNr := Position;
      if Assigned(FBildzuBitmap) then
        bmp := FBildzuBitmap(Position,ArbeitsumgebungObj.GrobansichtBildweite, Poswiederher, IFrame);
      if assigned(bmp) then
      begin
        Result := 0;
        try
          IM.Picture.Assign(bmp);
          FilmGrobAnsichtFrm.Refresh;
        finally
          bmp.free;
        end;
      end
      else
        Result := -2;
    end
    else
      Result := -3;
  end;

begin
  if (BildBreite > 0) and (BildHoehe > 0) and (Bilderzahl > 0) then
  begin
    Screen.Cursor := crHourGlass;
    Anzahl:=(Bilderzahl div ArbeitsumgebungObj.GrobansichtSchritt) + 2; //für das letzte Bild
    // + 1 weil von 0 gezählt wird
    // + 2 für das letzte Bild
    //Bildbreite / zu Bildhöhe ist notwendig um die Images der
    //Grobansicht auf das richtige Bildverhältnis zu bringen
    InitImageArray(Anzahl, BildBreite / BildHoehe);
    BildNr := 0;
    Zaehler := 0;
    while (Zaehler < Anzahl) and
          (CreateGrobImageVonBildposition(BildNr, Zaehler, False, True) = 0) do
    begin
      if BildNr + ArbeitsumgebungObj.GrobansichtSchritt < Bilderzahl - 1 then
        inc(BildNr, ArbeitsumgebungObj.GrobansichtSchritt)
      else
      begin
        inc(Zaehler);
        CreateGrobImageVonBildposition(Bilderzahl - 1, Zaehler, True, False);     // letztes Bild
        Zaehler := Anzahl;                                                        // Abbruch
      end;
      inc(Zaehler);
      Application.ProcessMessages;
    end;
    Screen.Cursor := crDefault;
  end;
end;
procedure TFilmGrobAnsichtFrm.AuffrischenBtnClick(Sender: TObject);             // neu Martin
begin
  Bildereinlesen;
end;

procedure TFilmGrobAnsichtFrm.bSuchesetzenBtnClick(Sender: TObject);            // neu Martin 2
begin
  if TopicImage <> nil then
  begin
    if Anfanggewaehlt > -1 then
      if PanelImages[Anfanggewaehlt].BildNr > Bilderzahl then
      BEGIN
        FilmPosition := Bilderzahl;
      END
      else
      BEGIN
        FilmPosition := PanelImages[Anfanggewaehlt].BildNr;
      END;
    if Endegewaehlt > -1 then
      if PanelImages[Endegewaehlt].BildNr > Bilderzahl then
      BEGIN
        WerbePosition := Bilderzahl;
      END
      else
      BEGIN
        WerbePosition := PanelImages[Endegewaehlt].BildNr;
      END;
    SetzeBildPosition;
  end;
end;

procedure TFilmGrobAnsichtFrm.binaereSucheBtnClick(Sender: TObject);
begin
  IF TSpeedButton(Sender).Font.Color = ArbeitsumgebungObj.GrobansichtFarbeFilm THEN
    binaereSucheKlick(1)
  ELSE
    binaereSucheKlick(2);  
end;

procedure TFilmGrobAnsichtFrm.FormResize(Sender: TObject);
begin
  Bilderanzeigen;
end;

procedure TFilmGrobAnsichtFrm.FensterSchliessenClick(Sender: TObject);
begin
  Hide;
end;

procedure TFilmGrobAnsichtFrm.FensterimVordergrundClick(Sender: TObject);
begin
  FensterimVordergrund.Checked := NOT FensterimVordergrund.Checked;
  SetzeFensterimVordergrund;
end;

procedure TFilmGrobAnsichtFrm.FenstermitRahmenClick(Sender: TObject);
begin
  FenstermitRahmen.Checked := NOT FenstermitRahmen.Checked;
  SetzeFenstermitRahmen;
end;

procedure TFilmGrobAnsichtFrm.FensterSymbolleisteClick(Sender: TObject);
begin
  FensterSymbolleiste.Checked := NOT FensterSymbolleiste.Checked;
  SetzeFensterSymbolleiste;
  Bilderanzeigen;
end;

// ----------------------- binäre Suche ----------------------------------------

PROCEDURE TFilmGrobAnsichtFrm.binaereSucheKlick(Taste: Integer);
BEGIN
  IF binaereSucheBtn1.Enabled THEN
  BEGIN
    IF Taste = 1 THEN
      IF (FilmPosition = AktuellePosition) OR (WerbePosition = AktuellePosition) THEN
      BEGIN
        FilmPosition := AktuellePosition;
        WerbePosition := AktuellePosition;
      END
      ELSE
        FilmPosition := AktuellePosition
    ELSE
      IF (FilmPosition = AktuellePosition) OR (WerbePosition = AktuellePosition) THEN
        WerbePosition := FilmPosition
      ELSE
        WerbePosition := AktuellePosition;
    SetzeBildPosition;
  END;
END;

PROCEDURE TFilmGrobAnsichtFrm.SetzeBildPosition;
BEGIN
  IF (WerbePosition > -1) AND (FilmPosition > -1) THEN
  BEGIN
    IF WerbePosition < FilmPosition THEN
    BEGIN
      binaereSucheBtn1.Font.Color := ArbeitsumgebungObj.GrobansichtFarbeWerbung;
      binaereSucheBtn2.Font.Color := ArbeitsumgebungObj.GrobansichtFarbeFilm;
      binaereSucheForm.WerbePosition_.Caption := BildnummerInZeitStr('hh:mm:ss:ff', WerbePosition, BilderProSek);
      binaereSucheBtn1.Caption := BildnummerInZeitStr('hh:mm:ss:ff', WerbePosition, BilderProSek);
      binaereSucheForm.FilmPosition_.Caption := BildnummerInZeitStr('hh:mm:ss:ff', FilmPosition, BilderProSek);
      binaereSucheBtn2.Caption := BildnummerInZeitStr('hh:mm:ss:ff', FilmPosition, BilderProSek);
    END
    ELSE
    BEGIN
      binaereSucheBtn1.Font.Color := ArbeitsumgebungObj.GrobansichtFarbeFilm;
      binaereSucheBtn2.Font.Color := ArbeitsumgebungObj.GrobansichtFarbeWerbung;
      binaereSucheForm.WerbePosition_.Caption := BildnummerInZeitStr('hh:mm:ss:ff', WerbePosition, BilderProSek);
      binaereSucheBtn1.Caption := BildnummerInZeitStr('hh:mm:ss:ff', FilmPosition, BilderProSek);
      binaereSucheForm.FilmPosition_.Caption := BildnummerInZeitStr('hh:mm:ss:ff', FilmPosition, BilderProSek);
      binaereSucheBtn2.Caption := BildnummerInZeitStr('hh:mm:ss:ff', WerbePosition, BilderProSek);
    END;
    AktuellePosition := (FilmPosition + WerbePosition) DIV 2;
    IF Assigned(FPositionsetzen) THEN
      FPositionsetzen(AktuellePosition, True);
    IF WerbePosition <> FilmPosition THEN
    BEGIN
      binaereSucheForm.binaereSucheFilm.Enabled := True;
      binaereSucheForm.binaereSucheWerbung.Enabled := True;
      binaereSucheBtn1.Enabled := True;
      binaereSucheBtn2.Enabled := True;
    END
    ELSE
    BEGIN
      binaereSucheForm.binaereSucheFilm.Enabled := False;
      binaereSucheForm.binaereSucheWerbung.Enabled := False;
      binaereSucheBtn1.Enabled := False;
      binaereSucheBtn2.Enabled := False;
      IMPanels[AnfangGewaehlt].Color := clBtnFace;
      AnfangGewaehlt := -1;
      IMPanels[EndeGewaehlt].Color := clBtnFace;
      EndeGewaehlt := -1;
      WerbePosition := -1;
      FilmPosition := -1;
    END;
  END;
END;

// ----------------------- Fenster ---------------------------------------------

PROCEDURE TFilmGrobAnsichtFrm.SetzeFensterimVordergrund;
BEGIN
  IF FensterimVordergrund.Checked THEN
    FormStyle := fsStayOnTop
  ELSE
    FormStyle := fsNormal;
END;

PROCEDURE TFilmGrobAnsichtFrm.SetzeFenstermitRahmen;

VAR Fensterhoehe : Integer;

BEGIN
  IF FenstermitRahmen.Checked THEN
  BEGIN
    IF BorderStyle = bsNone THEN                               // Rahmen war vorher nicht sichtbar
    BEGIN
      Fensterhoehe := Height;
      FensterPanel.BevelInner := bvNone;
      FensterPanel.BevelOuter := bvNone;
      BorderStyle := bsSizeToolWin;
      ClientHeight := Fensterhoehe - FensterPanel.BevelWidth * 4;
      Top := Top - Height + Fensterhoehe - (Width - ClientWidth) DIV 2 + FensterPanel.BevelWidth * 4;
    END;
  END
  ELSE
  BEGIN
    IF BorderStyle = bsSizeToolWin THEN                        // Rahmen war vorher sichtbar
    BEGIN
      Fensterhoehe := ClientHeight;
      FensterPanel.BevelInner := bvRaised;
      FensterPanel.BevelOuter := bvLowered;
      BorderStyle := bsNone;
      Top := Top + Height - Fensterhoehe - (Width - ClientWidth) DIV 2 - FensterPanel.BevelWidth * 4;
      Height := Fensterhoehe + FensterPanel.BevelWidth * 4;
    END;
  END;
END;

PROCEDURE TFilmGrobAnsichtFrm.SetzeFensterSymbolleiste;
BEGIN
  IF FensterSymbolleiste.Checked THEN
    GrossansichtSymbolleistePanel.Visible := True
  ELSE
    GrossansichtSymbolleistePanel.Visible := False;
END;

PROCEDURE TFilmGrobAnsichtFrm.Fensterpositionsetzen;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    FensterimVordergrund.Checked := ArbeitsumgebungObj.GrobansichtFensterVordergrund;
    SetzeFensterimVordergrund;
    FensterSymbolleiste.Checked := ArbeitsumgebungObj.GrobansichtFensterSchnellstartleiste;
    SetzeFensterSymbolleiste;
    Visible := ArbeitsumgebungObj.GrobansichtFensterSichtbar;
    FenstermitRahmen.Checked := ArbeitsumgebungObj.GrobansichtFensterRahmen;
    SetzeFenstermitRahmen;
    SetBounds(ArbeitsumgebungObj.GrobansichtFensterLinks,
              ArbeitsumgebungObj.GrobansichtFensterOben,
              ArbeitsumgebungObj.GrobansichtFensterBreite,
              ArbeitsumgebungObj.GrobansichtFensterHoehe);
    IF ArbeitsumgebungObj.GrobansichtFensterMaximized THEN
      WindowState := wsMaximized
    ELSE
      WindowState := wsNormal;
  END;
END;

PROCEDURE TFilmGrobAnsichtFrm.Fensterpositionmerken;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    IF WindowState = wsNormal	 THEN
    BEGIN
      ArbeitsumgebungObj.GrobansichtFensterOben := Top;
      ArbeitsumgebungObj.GrobansichtFensterLinks := Left;
      ArbeitsumgebungObj.GrobansichtFensterBreite := Width;
      ArbeitsumgebungObj.GrobansichtFensterHoehe := Height;
    END;
    ArbeitsumgebungObj.GrobansichtFensterMaximized := WindowState = wsMaximized;
    ArbeitsumgebungObj.GrobansichtFensterVordergrund := FensterimVordergrund.Checked;
    ArbeitsumgebungObj.GrobansichtFensterRahmen := FenstermitRahmen.Checked;
    ArbeitsumgebungObj.GrobansichtFensterSchnellstartleiste := FensterSymbolleiste.Checked;
    ArbeitsumgebungObj.GrobansichtFensterSichtbar := Visible;
  END;
END;

PROCEDURE TFilmGrobAnsichtFrm.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Caption := Wortlesen(Spracheladen, 'FilmGrobAnsichtFrm', Caption);
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
      TLabel(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TLabel(Komponente).Caption);
      TLabel(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TLabel(Komponente).Hint);
    END;  }
    IF Komponente IS TMenuItem THEN           // in der Unit Menus
      IF Komponente.Name <> '' THEN
      BEGIN
        TMenuItem(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TMenuItem(Komponente).Caption);
        TMenuItem(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TMenuItem(Komponente).Hint);
      END;
{    IF Komponente IS TGroupBox THEN           // in der Unit StdCtrls
    BEGIN
      TGroupBox(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TGroupBox(Komponente).Caption);
      TGroupBox(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TGroupBox(Komponente).Hint);
    END;
    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      TTabSheet(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TTabSheet(Komponente).Caption);
      TTabSheet(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TTabSheet(Komponente).Hint);
    END;   }
  END;
END;

end.

