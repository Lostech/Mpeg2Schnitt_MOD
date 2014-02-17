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

unit Efffenster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IniFiles,
  Sprachen,             // für Sprachunterstützung
  DatenTypen,           // für Datentypen
  AllgVariablen;        // Programmeinstellungen

type
  TEffektfenster = class(TForm)
    OKTaste: TBitBtn;
    AbbrechenTaste: TBitBtn;
    EffektvorgabenGroupBox: TGroupBox;
    EffektvorgabenComboBox: TComboBox;
    EffektAnfangGroupBox: TGroupBox;
    EffektAnfangComboBox: TComboBox;
    EffektAnfangEinstellungen_: TLabel;
    EffektAnfangParameterEdit: TEdit;
    EffektZeitAnfang_: TLabel;
    EffektZeitAnfangEdit: TEdit;
    EffektSekunden1_: TLabel;
    EffektEndeGroupBox: TGroupBox;
    EffektEndeComboBox: TComboBox;
    EffektEndeEinstellungen_: TLabel;
    EffektEndeParameterEdit: TEdit;
    EffektZeitEnde_: TLabel;
    EffektZeitEndeEdit: TEdit;
    EffektSekunden2_: TLabel;
    EffektgesamterSchnittCheckBox: TCheckBox;
    EffektvorgabeGroupBox: TGroupBox;
    EffektvorgabeEdit: TEdit;
    procedure FormShow(Sender: TObject);
    procedure OKTasteClick(Sender: TObject);
    procedure EffektgesamterSchnittCheckBoxClick(Sender: TObject);
    procedure EffektAnfangComboBoxCloseUp(Sender: TObject);
    procedure EffektEndeComboBoxCloseUp(Sender: TObject);
    procedure EffektvorgabenComboBoxCloseUp(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    PROCEDURE GesamtenSchnitteinstellen(Gesamt: Boolean);
  public
    { Public-Deklarationen }
    Effekte : TStrings;
    Effekt : TEffektEintrag;
    Effektvorgaben : TStringList;
    Effektvorgabe : STRING;
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
  Effektfenster: TEffektfenster;

implementation

{$R *.dfm}

procedure TEffektfenster.FormShow(Sender: TObject);
begin
  Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
  Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
  EffektAnfangComboBox.Clear;
  EffektEndeComboBox.Clear;
  IF Assigned(Effekt) AND
     Assigned(Effekte) THEN
  BEGIN
    EffektAnfangComboBox.Items.Assign(Effekte);
    EffektEndeComboBox.Items.Assign(Effekte);
    IF (Effekt.AnfangLaenge = 0) AND (Effekt.EndeLaenge = 0) THEN
      EffektgesamterSchnittCheckBox.Checked := True
    ELSE
      EffektgesamterSchnittCheckBox.Checked := False;
    GesamtenSchnitteinstellen(EffektgesamterSchnittCheckBox.Checked);
    EffektZeitAnfangEdit.Text := IntToStr(Effekt.AnfangLaenge);
    EffektZeitEndeEdit.Text := IntToStr(Effekt.EndeLaenge);
    EffektAnfangComboBox.ItemIndex := Effekte.IndexOf(Effekt.AnfangEffektName);
    IF (EffektAnfangComboBox.Items.Count > 0) AND
       (EffektAnfangComboBox.ItemIndex = -1) THEN
      EffektAnfangComboBox.ItemIndex := 0;
//    IF Effekt.AnfangEffektPosition < Effekte.Count THEN
//      EffektAnfangComboBox.ItemIndex := Effekt.AnfangEffektPosition
//    ELSE
//      EffektAnfangComboBox.ItemIndex := 0;
    EffektEndeComboBox.ItemIndex := Effekte.IndexOf(Effekt.EndeEffektName);
    IF (EffektEndeComboBox.Items.Count > 0) AND
       (EffektEndeComboBox.ItemIndex = -1) THEN
      EffektEndeComboBox.ItemIndex := 0;
//    IF Effekt.EndeEffektPosition < Effekte.Count THEN
//      EffektEndeComboBox.ItemIndex := Effekt.EndeEffektPosition
//    ELSE
//      EffektEndeComboBox.ItemIndex := 0;
    EffektAnfangComboBox.Tag := EffektAnfangComboBox.ItemIndex;
    EffektEndeComboBox.Tag := EffektEndeComboBox.ItemIndex;
    EffektAnfangParameterEdit.Text := Effekt.AnfangEffektParameter;
    EffektEndeParameterEdit.Text := Effekt.EndeEffektParameter;
  END;
  IF Assigned(Effektvorgaben) THEN
  BEGIN
//    EffektvorgabenGroupBox.Enabled := True;
//    EffektvorgabenGroupBox.Font.Color := clWindowText;
//    EffektvorgabenComboBox.Enabled := True;
    EffektvorgabenGroupBox.Visible := True;
    EffektvorgabeGroupBox.Visible := False;
    EffektvorgabenComboBox.Items.Assign(Effektvorgaben);
    IF (EffektAnfangComboBox.ItemIndex = 0) AND
       (EffektEndeComboBox.ItemIndex = 0) AND
       (EffektZeitAnfangEdit.Text = '0') AND
       (EffektZeitEndeEdit.Text = '0') THEN                                    // leerer Effekt
    BEGIN
      EffektvorgabenComboBox.ItemIndex := EffektvorgabenComboBox.Items.IndexOf(Effektvorgabe);
      IF (EffektvorgabenComboBox.ItemIndex > -1) AND
         Assigned(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]) THEN
      BEGIN
        EffektAnfangComboBox.ItemIndex := EffektAnfangComboBox.Items.IndexOf(TEffektEintrag(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]).AnfangEffektName);
        IF (EffektAnfangComboBox.Items.Count > 0) AND (EffektAnfangComboBox.ItemIndex = -1) THEN
          EffektAnfangComboBox.ItemIndex := 0;
        EffektZeitAnfangEdit.Text := IntToStr(TEffektEintrag(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]).AnfangLaenge);
        EffektAnfangParameterEdit.Text := TEffektEintrag(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]).AnfangEffektParameter;
        EffektEndeComboBox.ItemIndex := EffektEndeComboBox.Items.IndexOf(TEffektEintrag(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]).EndeEffektName);
        IF (EffektEndeComboBox.Items.Count > 0) AND (EffektEndeComboBox.ItemIndex = -1) THEN
          EffektEndeComboBox.ItemIndex := 0;
        EffektZeitEndeEdit.Text := IntToStr(TEffektEintrag(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]).EndeLaenge);
        EffektEndeParameterEdit.Text := TEffektEintrag(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]).EndeEffektParameter;
        IF (EffektZeitAnfangEdit.Text = '0') AND (EffektZeitEndeEdit.Text = '0') THEN
          EffektgesamterSchnittCheckBox.Checked := True
        ELSE
          EffektgesamterSchnittCheckBox.Checked := False;
        GesamtenSchnitteinstellen(EffektgesamterSchnittCheckBox.Checked);
      END;
    END;
  END
  ELSE
  BEGIN
//    EffektvorgabenGroupBox.Enabled := False;
//    EffektvorgabenGroupBox.Font.Color := clGray;
//    EffektvorgabenComboBox.Enabled := False;
    EffektvorgabeGroupBox.Visible := True;
    EffektvorgabenGroupBox.Visible := False;
    EffektvorgabeEdit.Text := Effektvorgabe;
  END;
end;

procedure TEffektfenster.OKTasteClick(Sender: TObject);
begin
  IF Assigned(Effekt) THEN
  BEGIN
    Effekt.AnfangLaenge := StrToIntDef(EffektZeitAnfangEdit.Text, 0);
    Effekt.EndeLaenge := StrToIntDef(EffektZeitEndeEdit.Text, 0);
    IF EffektAnfangComboBox.ItemIndex < 1 THEN
    BEGIN
      Effekt.AnfangEffektName := '';
      Effekt.AnfangEffektDateiname := '';
    END
    ELSE
    BEGIN
      Effekt.AnfangEffektName := EffektAnfangComboBox.Text;
      Effekt.AnfangEffektDateiname := TDateiListeneintrag(Effekte.Objects[Effekte.IndexOf(EffektAnfangComboBox.Text)]).Dateiname;
    END;
    IF EffektEndeComboBox.ItemIndex < 1 THEN
    BEGIN
      Effekt.EndeEffektName := '';
      Effekt.EndeEffektDateiname := '';
    END
    ELSE
    BEGIN
      Effekt.EndeEffektName := EffektEndeComboBox.Text;
      Effekt.EndeEffektDateiname := TDateiListeneintrag(Effekte.Objects[Effekte.IndexOf(EffektEndeComboBox.Text)]).Dateiname;
    END;
    Effekt.AnfangEffektParameter := EffektAnfangParameterEdit.Text;
    Effekt.EndeEffektParameter := EffektEndeParameterEdit.Text;
  END;
  IF NOT Assigned(Effektvorgaben) THEN
  BEGIN
    Effektvorgabe := EffektvorgabeEdit.Text;
  END;
end;

procedure TEffektfenster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Effekte := NIL;
  Effekt := NIL;
  Effektvorgaben := NIL;
end;

procedure TEffektfenster.EffektAnfangComboBoxCloseUp(Sender: TObject);
begin
  IF EffektAnfangComboBox.Tag <> EffektAnfangComboBox.ItemIndex THEN
  BEGIN
//    IF (EffektAnfangComboBox.ItemIndex > 0) AND
//        Assigned(EffektAnfangComboBox.Items.Objects[EffektAnfangComboBox.ItemIndex]) THEN
//      EffektAnfangParameterEdit.Text := TEffektAudioDaten(EffektAnfangComboBox.Items.Objects[EffektAnfangComboBox.ItemIndex]).EffektEinstellungen
//    ELSE
//      EffektAnfangParameterEdit.Text := '';
    EffektAnfangComboBox.Tag := EffektAnfangComboBox.ItemIndex;
  END;
end;

procedure TEffektfenster.EffektEndeComboBoxCloseUp(Sender: TObject);
begin
  IF EffektEndeComboBox.Tag <> EffektEndeComboBox.ItemIndex THEN
  BEGIN
//    IF (EffektEndeComboBox.ItemIndex > 0) AND
//        Assigned(EffektEndeComboBox.Items.Objects[EffektEndeComboBox.ItemIndex]) THEN
//      EffektEndeParameterEdit.Text := TEffektAudioDaten(EffektEndeComboBox.Items.Objects[EffektEndeComboBox.ItemIndex]).EffektEinstellungen
//    ELSE
//      EffektEndeParameterEdit.Text := '';
    EffektEndeComboBox.Tag := EffektEndeComboBox.ItemIndex;
  END;  
end;

PROCEDURE TEffektfenster.GesamtenSchnitteinstellen(Gesamt: Boolean);
BEGIN
  IF Gesamt THEN
  BEGIN
    EffektEndeGroupBox.Enabled := False;
    EffektEndeComboBox.Enabled := False;
    EffektEndeComboBox.ItemIndex := 0;
    EffektEndeParameterEdit.Enabled := False;
    EffektZeitAnfangEdit.Enabled := False;
    EffektZeitAnfangEdit.Text := '0';
    EffektZeitEndeEdit.Enabled := False;
    EffektZeitEndeEdit.Text := '0';
  END
  ELSE
  BEGIN
    EffektEndeGroupBox.Enabled := True;
    EffektEndeComboBox.Enabled := True;
    EffektEndeParameterEdit.Enabled := True;
    EffektZeitAnfangEdit.Enabled := True;
    EffektZeitEndeEdit.Enabled := True;
  END;
END;

procedure TEffektfenster.EffektgesamterSchnittCheckBoxClick(Sender: TObject);
begin
  GesamtenSchnitteinstellen(EffektgesamterSchnittCheckBox.Checked);
end;

procedure TEffektfenster.EffektvorgabenComboBoxCloseUp(Sender: TObject);

VAR Effektvorgaben : TEffektEintrag;

begin
  IF EffektvorgabenComboBox.ItemIndex > -1 THEN
  BEGIN
    Effektvorgaben := TEffektEintrag(EffektvorgabenComboBox.Items.Objects[EffektvorgabenComboBox.ItemIndex]);
    IF Assigned(Effektvorgaben) THEN
    BEGIN
      EffektAnfangComboBox.ItemIndex := EffektAnfangComboBox.Items.IndexOf(Effektvorgaben.AnfangEffektName);
      IF (EffektAnfangComboBox.Items.Count > 0) AND (EffektAnfangComboBox.ItemIndex = -1) THEN
        EffektAnfangComboBox.ItemIndex := 0;
      EffektZeitAnfangEdit.Text := IntToStr(Effektvorgaben.AnfangLaenge);
      EffektAnfangParameterEdit.Text := Effektvorgaben.AnfangEffektParameter;
      EffektEndeComboBox.ItemIndex := EffektEndeComboBox.Items.IndexOf(Effektvorgaben.EndeEffektName);
      IF (EffektEndeComboBox.Items.Count > 0) AND (EffektEndeComboBox.ItemIndex = -1) THEN
        EffektEndeComboBox.ItemIndex := 0;
      EffektZeitEndeEdit.Text := IntToStr(Effektvorgaben.EndeLaenge);
      EffektEndeParameterEdit.Text := Effektvorgaben.EndeEffektParameter;
      IF (EffektZeitAnfangEdit.Text = '0') AND (EffektZeitEndeEdit.Text = '0') THEN
        EffektgesamterSchnittCheckBox.Checked := True
      ELSE
        EffektgesamterSchnittCheckBox.Checked := False;
      GesamtenSchnitteinstellen(EffektgesamterSchnittCheckBox.Checked);
    END;
  END;
end;

PROCEDURE TEffektfenster.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Caption := Wortlesen(Spracheladen, 'EffektFenster', Caption);
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
{    IF Komponente IS TMenuItem THEN           // in der Unit Menus
      IF Komponente.Name <> '' THEN
      BEGIN
        TMenuItem(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TMenuItem(Komponente).Caption);
        TMenuItem(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TMenuItem(Komponente).Hint);
      END;   }
    IF Komponente IS TGroupBox THEN           // in der Unit StdCtrls
    BEGIN
      TGroupBox(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TGroupBox(Komponente).Caption);
      TGroupBox(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TGroupBox(Komponente).Hint);
    END;
{    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      TTabSheet(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TTabSheet(Komponente).Caption);
      TTabSheet(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TTabSheet(Komponente).Hint);
    END;    }
  END;
END;

end.
