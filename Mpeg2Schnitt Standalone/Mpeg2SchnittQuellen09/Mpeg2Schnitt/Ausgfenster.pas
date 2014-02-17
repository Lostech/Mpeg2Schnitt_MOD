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

unit Ausgfenster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Menus, Clipbrd, {$Warnings off}FileCtrl{$Warnings on},
  DatenTypen,                   // für verwendete Datentypen
  Sprachen,                     // für Sprachunterstützung
  AllgFunktionen,               // allgemeine Funktionen
  AllgVariablen;                // Programmeinstellungen

type
  TEditBoxDaten = PROCEDURE OF OBJECT;

  TAusgabefenster = class(TForm)
    AusgabeName_: TLabel;
    NameEdit: TEdit;
    AusgabeProgrammName_: TLabel;
    ProgrammNameEdit: TEdit;
    ProgrammParameterEdit: TEdit;
    AusgabeProgrammParameter_: TLabel;
    AusgabeParameter_: TLabel;
    ParameterEdit: TEdit;
    OrgParameterDateiEdit: TEdit;
    AusgabeOrgParameterDatei_: TLabel;
    AusgabeParameterDateiName_: TLabel;
    ParameterDateiNameEdit: TEdit;
    AusgabeEinstellungen_: TLabel;
    EinstellungenEdit: TEdit;
    AbbrechenTaste: TBitBtn;
    OKTaste: TBitBtn;
    EditBoxPopupMenu: TPopupMenu;
    EditBoxDateisuchen: TMenuItem;
    EditBoxVerzeichnissuchen: TMenuItem;
    Trennlinie22: TMenuItem;
    EditBoxAusschneidenClipboard: TMenuItem;
    EditBoxKopierenClipboard: TMenuItem;
    EditBoxEinfuegenClipboard: TMenuItem;
    EditBoxLoeschenClipboard: TMenuItem;
    ProgrammNameBitBtn: TBitBtn;
    OrgParameterDateiBitBtn: TBitBtn;
    ParameterDateiNameBitBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKTasteClick(Sender: TObject);
    procedure AbbrechenTasteClick(Sender: TObject);
    procedure EditBoxDblClick(Sender: TObject);
    procedure EditBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure EditBoxDateisuchenClick(Sender: TObject);
    procedure EditBoxVerzeichnissuchenClick(Sender: TObject);
    procedure EditBoxAusschneidenClipboardClick(Sender: TObject);
    procedure EditBoxKopierenClipboardClick(Sender: TObject);
    procedure EditBoxEinfuegenClipboardClick(Sender: TObject);
    procedure EditBoxLoeschenClipboardClick(Sender: TObject);
    procedure EditBoxPopupMenuPopup(Sender: TObject);
    procedure EditBoxBitBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    aktEditBox : TEdit;
    aktEditBoxDateioeffnen : TEditBoxDaten;
    aktEditBoxDateioeffnenFilter : STRING;
    aktEditBoxModus : Integer;
    PROCEDURE DatenbehandlungfestlegenEditBox(Sender: TObject);
  public
    { Public-Deklarationen }
    DialogName,
    ParameterName,
    Einstellungen : STRING;
    AusgabeDaten : TAusgabeDaten;
    aktFelder : Integer;
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
  Ausgabefenster: TAusgabefenster;

implementation

{$R *.dfm}

procedure TAusgabefenster.FormCreate(Sender: TObject);
begin
  aktFelder := $7F;
end;

procedure TAusgabefenster.FormShow(Sender: TObject);
begin
  Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
  Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
  Caption := DialogName;
  AusgabeParameter_.Caption := ParameterName;
  IF (aktFelder AND $40) = $40 THEN       // Bit 7 = Eingabefeld Einstellungen
  BEGIN
    AusgabeEinstellungen_.Enabled := True;
    EinstellungenEdit.Enabled := True;
  END
  ELSE
  BEGIN
    AusgabeEinstellungen_.Enabled := False;
    EinstellungenEdit.Enabled := False;
  END;
  IF Assigned(AusgabeDaten) THEN
  BEGIN
    NameEdit.Text := AusgabeDaten.EffektName;
    ProgrammNameEdit.Text := relativPathAppl(AusgabeDaten.ProgrammName, Application.ExeName);
    ProgrammParameterEdit.Text := AusgabeDaten.ProgrammParameter;
    ParameterEdit.Text := AusgabeDaten.Parameter;
    OrgParameterDateiEdit.Text := relativPathAppl(AusgabeDaten.OrginalparameterDatei, Application.ExeName);
    ParameterDateiNameEdit.Text := relativPathAppl(AusgabeDaten.ParameterDateiName, Application.ExeName);
    EinstellungenEdit.Text := Einstellungen;
  END
  ELSE
  BEGIN
    NameEdit.Text := '';
    ProgrammNameEdit.Text := '';
    ProgrammParameterEdit.Text := '';
    ParameterEdit.Text := '';
    OrgParameterDateiEdit.Text := '';
    ParameterDateiNameEdit.Text := '';
    EinstellungenEdit.Text := '';
  END;
end;

procedure TAusgabefenster.OKTasteClick(Sender: TObject);
begin
  IF Assigned(AusgabeDaten) THEN
  BEGIN
    AusgabeDaten.EffektName := NameEdit.Text;
    AusgabeDaten.ProgrammName := absolutPathAppl(ProgrammNameEdit.Text, Application.ExeName, False);
    AusgabeDaten.ProgrammParameter := ProgrammParameterEdit.Text;
    AusgabeDaten.Parameter := ParameterEdit.Text;
    AusgabeDaten.OrginalparameterDatei := absolutPathAppl(OrgParameterDateiEdit.Text, Application.ExeName, False);
    AusgabeDaten.ParameterDateiName := absolutPathAppl(ParameterDateiNameEdit.Text, Application.ExeName, False);
    Einstellungen := EinstellungenEdit.Text;
    NameEdit.Text := '';
    ProgrammNameEdit.Text := '';
    ProgrammParameterEdit.Text := '';
    ParameterEdit.Text := '';
    OrgParameterDateiEdit.Text := '';
    ParameterDateiNameEdit.Text := '';
    EinstellungenEdit.Text := '';
  END;
end;

procedure TAusgabefenster.AbbrechenTasteClick(Sender: TObject);
begin
  NameEdit.Text := '';
  ProgrammNameEdit.Text := '';
  ProgrammParameterEdit.Text := '';
  ParameterEdit.Text := '';
  OrgParameterDateiEdit.Text := '';
  ParameterDateiNameEdit.Text := '';
  EinstellungenEdit.Text := '';
end;

procedure TAusgabefenster.EditBoxBitBtnClick(Sender: TObject);

VAR Maus : TPoint;

begin
  IF Sender = ProgrammNameBitBtn THEN
    DatenbehandlungfestlegenEditBox(ProgrammNameEdit);
  IF Sender = OrgParameterDateiBitBtn THEN
    DatenbehandlungfestlegenEditBox(OrgParameterDateiEdit);
  IF Sender = ParameterDateiNameBitBtn THEN
    DatenbehandlungfestlegenEditBox(ParameterDateiNameEdit);
  GetCursorPos(Maus);
  EditBoxPopupMenu.Popup(Maus.X, Maus.Y);
end;

PROCEDURE TAusgabefenster.DatenbehandlungfestlegenEditBox(Sender: TObject);
BEGIN
  IF aktEditBox <> Sender THEN
  BEGIN
    aktEditBox := TEdit(Sender);
    aktEditBoxDateioeffnen := NIL;
    aktEditBoxModus := 0;                                     // Standard
    IF (Sender = ProgrammNameEdit) OR
       (Sender = OrgParameterDateiEdit) OR
       (Sender = ParameterDateiNameEdit) THEN
    BEGIN
//      aktEditBoxDateioeffnen := EffektDateiladen;
      aktEditBoxModus := aktEditBoxModus OR 1;                // Datei suchen
    END
    ELSE
      CASE aktEditBox.Tag OF
        1: aktEditBoxModus := aktEditBoxModus OR 1;           // Datei suchen
        2: aktEditBoxModus := aktEditBoxModus OR 2;           // Verzeichnis suchen
      END;
  END;
END;

procedure TAusgabefenster.EditBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  DatenbehandlungfestlegenEditBox(Sender);
end;

procedure TAusgabefenster.EditBoxDblClick(Sender: TObject);
begin
  DatenbehandlungfestlegenEditBox(Sender);
  IF (aktEditBoxModus AND 1) = 1 THEN
    EditBoxDateisuchenClick(Sender)
  ELSE
    IF (aktEditBoxModus AND 2) = 2 THEN
      EditBoxVerzeichnissuchenClick(Sender);
end;

procedure TAusgabefenster.EditBoxPopupMenuPopup(Sender: TObject);
begin
  EditBoxDateisuchen.Visible := False;
  EditBoxVerzeichnissuchen.Visible := False;
  Trennlinie22.Visible := False;
  IF (aktEditBoxModus AND 1) = 1 THEN
  BEGIN
    EditBoxDateisuchen.Visible := True;
    Trennlinie22.Visible := True;
  END;
  IF (aktEditBoxModus AND 2) = 2 THEN
  BEGIN
    EditBoxVerzeichnissuchen.Visible := True;
    Trennlinie22.Visible := True;
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

procedure TAusgabefenster.EditBoxDateisuchenClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  IF PromptForFileName(Dateiname, aktEditBoxDateioeffnenFilter, '', Wortlesen(NIL, 'Dialog101', 'Datei suchen'),
                       Verzeichnissuchen(absolutPathAppl(ExtractFilePath(aktEditBox.Text), Application.ExeName, True)), False) THEN
  BEGIN
    aktEditBox.Text := relativPathAppl(Dateiname, Application.ExeName);
    IF Assigned(aktEditBoxDateioeffnen) THEN
      aktEditBoxDateioeffnen;
  END;
end;

procedure TAusgabefenster.EditBoxVerzeichnissuchenClick(Sender: TObject);

VAR Verzeichnis : STRING;

begin
  Verzeichnis := absolutPathAppl(aktEditBox.Text, Application.ExeName, True);
  IF SelectDirectory(Wortlesen(NIL, 'Dialog103', 'Verzeichnis suchen'), '', Verzeichnis) THEN
    aktEditBox.Text := mitPathtrennzeichen(relativPathAppl(Verzeichnis, Application.ExeName));
end;

procedure TAusgabefenster.EditBoxAusschneidenClipboardClick(
  Sender: TObject);
begin
  aktEditBox.CutToClipboard;
end;

procedure TAusgabefenster.EditBoxKopierenClipboardClick(Sender: TObject);
begin
  aktEditBox.CopyToClipboard;
end;

procedure TAusgabefenster.EditBoxEinfuegenClipboardClick(Sender: TObject);
begin
  aktEditBox.PasteFromClipboard;
end;

procedure TAusgabefenster.EditBoxLoeschenClipboardClick(Sender: TObject);
begin
  aktEditBox.ClearSelection;
end;

PROCEDURE TAusgabefenster.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Caption := Wortlesen(Spracheladen, 'AusgabeFenster', Caption);
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
{    IF Komponente IS TRadioButton THEN
    BEGIN
      TRadioButton(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TRadioButton(Komponente).Caption);
      TRadioButton(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TRadioButton(Komponente).Hint);
    END;   }
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
{    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      TTabSheet(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TTabSheet(Komponente).Caption);
      TTabSheet(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TTabSheet(Komponente).Hint);
    END;   }
  END;
END;

end.
