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

unit Arbeitsumgebung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Menus, Clipbrd,
  {$Warnings off}FileCtrl{$Warnings on}, IniFiles,                      
  Mauladenspeichern,                 // Laden und Speichern von Arbeitsumgebungen
  Sprachen,                          // für Sprachunterstützung
  AllgFunktionen,                    // allgemeine Funktionen
  DatenTypen,                        // Datentypen
  AllgVariablen;

type
  TArbeitsumgebungFenster = class(TForm)
    ArbeitsumgebungAllgemein_: TGroupBox;
    Arbeitsumgebungverzeichnis_: TLabel;
    ArbeitsumgebungenverzeichnisEdit: TEdit;
    ArbeitsumgebungaktbeiEndespeichernBox: TCheckBox;
    ArbeitsumgebungBeiStartStandardladenBox: TCheckBox;
    ArbeitsumgebungverzeichnisspeichernBox: TCheckBox;
    ArbeitsumgebungbeiOKspeichernBox: TCheckBox;
    ArbeitsumgebungListe_: TGroupBox;
    Arbeitsumgebungakt_: TLabel;
    aktArbeitsumgebungComboBox: TComboBox;
    ArbeitsumgebungenListe_: TLabel;
    ArbeitsumgebungenListeComboBox: TComboBox;
    ArbeitsumgebungenListeBitBtn: TBitBtn;
    Arbeitsumgebungbearbeiten_: TGroupBox;
    ArbeitsumgebungOeffnenTaste: TBitBtn;
    AbbrechenTaste: TBitBtn;
    OKTaste: TBitBtn;
    ArbeitsumgebungenMenu: TPopupMenu;
    Listeneintragbearbeiten: TMenuItem;
    Listeneintrageinfuegen: TMenuItem;
    Listeneintragloeschen: TMenuItem;
    ArbeitsumgebungenverzeichnisMenue: TPopupMenu;
    EditBoxVerzeichnissuchen: TMenuItem;
    Trennlienie21: TMenuItem;
    EditBoxAusschneidenClipboard: TMenuItem;
    EditBoxKopierenClipboard: TMenuItem;
    EditBoxEinfuegenClipboard: TMenuItem;
    EditBoxLoeschenClipboard: TMenuItem;
    ArbeitsumgebungenverzeichnisBitBtn: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKTasteClick(Sender: TObject);
    procedure ArbeitsumgebungenverzeichnisEditDblClick(Sender: TObject);
    procedure ArbeitsumgebungenListeComboBoxDblClick(Sender: TObject);
    procedure ArbeitsumgebungenListeBitBtnClick(Sender: TObject);
    procedure ArbeitsumgebungOeffnenTasteClick(Sender: TObject);
    procedure ListeneintrageinfuegenClick(Sender: TObject);
    procedure ListeneintragbearbeitenClick(Sender: TObject);
    procedure ListeneintragloeschenClick(Sender: TObject);
    procedure EditBoxVerzeichnissuchenClick(Sender: TObject);
    procedure EditBoxAusschneidenClipboardClick(
      Sender: TObject);
    procedure EditBoxKopierenClipboardClick(
      Sender: TObject);
    procedure EditBoxEinfuegenClipboardClick(
      Sender: TObject);
    procedure EditBoxLoeschenClipboardClick(Sender: TObject);
    procedure ArbeitsumgebungenverzeichnisBitBtnClick(Sender: TObject);
    procedure ArbeitsumgebungenverzeichnisMenuePopup(Sender: TObject);
    procedure ArbeitsumgebungenMenuPopup(Sender: TObject);
  private
    { Private-Deklarationen }
    PROCEDURE Arbeitsumgebungeinfuegen(Name: STRING);
    FUNCTION Arbeitsumgebungbearbeiten(Name: STRING): Integer;
  public
    { Public-Deklarationen }
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

    PROCEDURE ArbeitsumgebungCreate;
    PROCEDURE ArbeitsumgebungDestroy;
    PROCEDURE Arbeitsumgebungenladen(Name: STRING);
    PROCEDURE Arbeitsumgebungenspeichern(Name: STRING);
    PROCEDURE Arbeitsumgebungladen(Arbeitsumgebung: Integer);
    FUNCTION ArbeitsumgebungladenName(Arbeitsumgebung: STRING): Integer;
    PROCEDURE Arbeitsumgebungspeichern(Arbeitsumgebung: Integer);
    PROCEDURE ArbeitsumgebungspeichernName(Arbeitsumgebung: STRING);
    PROCEDURE aktArbeitsumgebungspeichern;

var
    ArbeitsumgebungFenster: TArbeitsumgebungFenster;
    Arbeitsumgebungenverzeichnis : STRING;
    ArbeitsumgebungenVerzeichnisspeichern : Boolean;
    aktArbeitsumgebung : Integer;
    aktArbeitsumgebungDateiname : STRING;
    BeiStartStandardladen : Boolean;
    aktArbeitsumgebungbeiEndespeichern : Boolean;
    ArbeitsumgebungbeiOKspeichern : Boolean;
    ArbeitsumgebungenListe : TStringList = NIL;
    
implementation

{$R *.dfm}

USES
   Optfenster;                        // bearbeiten einer Arbeitsumgebung

procedure TArbeitsumgebungFenster.FormDestroy(Sender: TObject);
begin
  Stringliste_loeschen(aktArbeitsumgebungComboBox.Items);
  Stringliste_loeschen(ArbeitsumgebungenListeComboBox.Items);
end;

procedure TArbeitsumgebungFenster.FormShow(Sender: TObject);

VAR I : Integer;
    Dateieintrag : TDateiListeneintrag;

begin
  Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
  Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
  ArbeitsumgebungenverzeichnisEdit.Text := relativPathAppl(Arbeitsumgebungenverzeichnis, Application.ExeName);
  ArbeitsumgebungverzeichnisspeichernBox.Checked := Arbeitsumgebungenverzeichnisspeichern;
  ArbeitsumgebungBeiStartStandardladenBox.Checked := BeiStartStandardladen;
  ArbeitsumgebungaktbeiEndespeichernBox.Checked := aktArbeitsumgebungbeiEndespeichern;
  ArbeitsumgebungbeiOKspeichernBox.Checked := ArbeitsumgebungbeiOKspeichern;
  Stringliste_loeschen(aktArbeitsumgebungComboBox.Items);
  Stringliste_loeschen(ArbeitsumgebungenListeComboBox.Items);
  FOR I := 0 TO ArbeitsumgebungenListe.Count - 1 DO
  BEGIN
    Dateieintrag := TDateiListeneintrag.Create;
    Dateieintrag.Name := TDateiListeneintrag(ArbeitsumgebungenListe.Objects[I]).Name;
    Dateieintrag.Dateiname := relativPathAppl(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[I]).Dateiname, Application.ExeName);
    aktArbeitsumgebungComboBox.Items.Add(Dateieintrag.Name);
    ArbeitsumgebungenListeComboBox.Items.AddObject(Dateieintrag.Name, Dateieintrag);
  END;
  IF (aktArbeitsumgebung > -1) AND
     (aktArbeitsumgebung < ArbeitsumgebungenListeComboBox.Items.Count) THEN
    aktArbeitsumgebungComboBox.ItemIndex := aktArbeitsumgebung
  ELSE
    IF ArbeitsumgebungenListeComboBox.Items.Count > 0 THEN
      aktArbeitsumgebungComboBox.ItemIndex := 0
    ELSE
      aktArbeitsumgebungComboBox.ItemIndex := -1;
  ArbeitsumgebungenListeComboBox.ItemIndex := -1;
  ArbeitsumgebungenListeComboBox.Text := '';
end;

procedure TArbeitsumgebungFenster.OKTasteClick(Sender: TObject);

VAR I, J : Integer;
    Dateieintrag : TDateiListeneintrag;

begin
  ModalResult := mrOk;
  Arbeitsumgebungenverzeichnis := absolutPathAppl(ArbeitsumgebungenverzeichnisEdit.Text, Application.ExeName, True);
  Arbeitsumgebungenverzeichnisspeichern := ArbeitsumgebungverzeichnisspeichernBox.Checked;
  BeiStartStandardladen := ArbeitsumgebungBeiStartStandardladenBox.Checked;
  aktArbeitsumgebungbeiEndespeichern := ArbeitsumgebungaktbeiEndespeichernBox.Checked;
  ArbeitsumgebungbeiOKspeichern := ArbeitsumgebungbeiOKspeichernBox.Checked;
  aktArbeitsumgebungspeichern;
  Stringliste_loeschen(ArbeitsumgebungenListe);
  aktArbeitsumgebung := 0;
  J := 0;
  FOR I := 0 TO ArbeitsumgebungenListeComboBox.Items.Count - 1 DO
  BEGIN
    IF Assigned(ArbeitsumgebungenListeComboBox.Items.Objects[I]) AND
       (FileExists(absolutPathAppl(TDateiListeneintrag(ArbeitsumgebungenListeComboBox.Items.Objects[I]).Dateiname, Application.ExeName, False)) OR
       (I = 0)) THEN
    BEGIN
      Dateieintrag := TDateiListeneintrag.Create;
      Dateieintrag.Name := TDateiListeneintrag(ArbeitsumgebungenListeComboBox.Items.Objects[I]).Name;
      Dateieintrag.Dateiname := absolutPathAppl(TDateiListeneintrag(ArbeitsumgebungenListeComboBox.Items.Objects[I]).Dateiname, Application.ExeName, False);
      ArbeitsumgebungenListe.AddObject(Dateieintrag.Name, Dateieintrag);
      IF I = aktArbeitsumgebungComboBox.ItemIndex THEN
        aktArbeitsumgebung := J;
      Inc(J);
    END;
  END;
  Arbeitsumgebungladen(aktArbeitsumgebung);
end;

procedure TArbeitsumgebungFenster.ArbeitsumgebungenverzeichnisEditDblClick(Sender: TObject);

VAR Verzeichnis : STRING;

begin
  Verzeichnis := absolutPathAppl(ArbeitsumgebungenverzeichnisEdit.Text, Application.ExeName, True);
  IF SelectDirectory(Wortlesen(NIL, 'Dialog103', 'Verzeichnis suchen'), '', Verzeichnis) THEN
    ArbeitsumgebungenverzeichnisEdit.Text := mitPathtrennzeichen(relativPathAppl(Verzeichnis, Application.ExeName));
end;

procedure TArbeitsumgebungFenster.ArbeitsumgebungenverzeichnisBitBtnClick(Sender: TObject);

VAR Maus : TPoint;

begin
  GetCursorPos(Maus);
  ArbeitsumgebungenverzeichnisMenue.Popup(Maus.X, Maus.Y);
end;

procedure TArbeitsumgebungFenster.EditBoxVerzeichnissuchenClick(Sender: TObject);

VAR Verzeichnis : STRING;

begin
  Verzeichnis := absolutPathAppl(ArbeitsumgebungenverzeichnisEdit.Text, Application.ExeName, True);
  IF SelectDirectory(Wortlesen(NIL, 'Dialog103', 'Verzeichnis suchen'), '', Verzeichnis) THEN
    ArbeitsumgebungenverzeichnisEdit.Text := mitPathtrennzeichen(relativPathAppl(Verzeichnis, Application.ExeName));
end;

procedure TArbeitsumgebungFenster.EditBoxAusschneidenClipboardClick(
  Sender: TObject);
begin
  ArbeitsumgebungenverzeichnisEdit.CutToClipboard;
end;

procedure TArbeitsumgebungFenster.EditBoxKopierenClipboardClick(
  Sender: TObject);
begin
  ArbeitsumgebungenverzeichnisEdit.PasteFromClipboard;
end;

procedure TArbeitsumgebungFenster.EditBoxEinfuegenClipboardClick(
  Sender: TObject);
begin
  ArbeitsumgebungenverzeichnisEdit.PasteFromClipboard;
end;

procedure TArbeitsumgebungFenster.EditBoxLoeschenClipboardClick(
  Sender: TObject);
begin
  ArbeitsumgebungenverzeichnisEdit.ClearSelection;
end;

procedure TArbeitsumgebungFenster.ArbeitsumgebungenverzeichnisMenuePopup(Sender: TObject);
begin
  IF Clipboard.HasFormat(CF_TEXT) THEN
    EditBoxEinfuegenClipboard.Enabled := True
  ELSE
    EditBoxEinfuegenClipboard.Enabled := False;
  IF ArbeitsumgebungenverzeichnisEdit.SelLength > 0 THEN
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

procedure TArbeitsumgebungFenster.ArbeitsumgebungenListeComboBoxDblClick(Sender: TObject);
begin
  IF ArbeitsumgebungenListeComboBox.Text = '' THEN
    Listeneintrageinfuegen.Click
  ELSE
    Listeneintragbearbeiten.Click;
end;

procedure TArbeitsumgebungFenster.ArbeitsumgebungenListeBitBtnClick(Sender: TObject);

VAR Maus : TPoint;

begin
  GetCursorPos(Maus);
  ArbeitsumgebungenMenu.Popup(Maus.X, Maus.Y);
end;

procedure TArbeitsumgebungFenster.ArbeitsumgebungOeffnenTasteClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  Dateiname := '';
  IF PromptForFileName(Dateiname, Wortlesen(NIL, 'Dialog3', 'Mpeg2Schnitt Arbeitsumbegungen') + '|*.mau',
                       'mau', Wortlesen(NIL, 'Dialog2', 'Mpeg2Schnitt Arbeitsumbegung öffnen'),
                       Verzeichnissuchen(absolutPathAppl(ArbeitsumgebungenverzeichnisEdit.Text, Application.ExeName, True)),
                       False) THEN
  BEGIN
    IF Arbeitsumgebungbearbeiten(Dateiname) = 0 THEN
      IF ArbeitsumgebungverzeichnisspeichernBox.Checked THEN
        ArbeitsumgebungenverzeichnisEdit.Text := relativPathAppl(ExtractFilePath(Dateiname), Application.ExeName);
  END;
end;

procedure TArbeitsumgebungFenster.ListeneintrageinfuegenClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  Dateiname := '';
  IF PromptForFileName(Dateiname, Wortlesen(NIL, 'Dialog3', 'Mpeg2Schnitt Arbeitsumbegungen') + '|*.mau',
                       'mau', Wortlesen(NIL, 'Dialog2', 'Mpeg2Schnitt Arbeitsumbegung öffnen'),
                       Verzeichnissuchen(absolutPathAppl(ArbeitsumgebungenverzeichnisEdit.Text, Application.ExeName, True)),
                       False) THEN
  BEGIN
    IF NOT FileExists(Dateiname) THEN
    BEGIN
      IF Arbeitsumgebungbearbeiten(Dateiname) = 0 THEN
      BEGIN
        Arbeitsumgebungeinfuegen(relativPathAppl(Dateiname, Application.ExeName));
        IF ArbeitsumgebungverzeichnisspeichernBox.Checked THEN
          ArbeitsumgebungenverzeichnisEdit.Text := relativPathAppl(ExtractFilePath(Dateiname), Application.ExeName);
      END;
    END
    ELSE
    BEGIN
      Arbeitsumgebungeinfuegen(relativPathAppl(Dateiname, Application.ExeName));
      IF ArbeitsumgebungverzeichnisspeichernBox.Checked THEN
        ArbeitsumgebungenverzeichnisEdit.Text := relativPathAppl(ExtractFilePath(Dateiname), Application.ExeName);
    END;
  END;
end;

procedure TArbeitsumgebungFenster.ListeneintragbearbeitenClick(Sender: TObject);

VAR Dateiname : STRING;

begin
  IF ArbeitsumgebungenListeComboBox.ItemIndex < 0 THEN
    ArbeitsumgebungenListeComboBox.ItemIndex := ArbeitsumgebungenListeComboBox.Items.IndexOf(ArbeitsumgebungenListeComboBox.Text);
  IF ArbeitsumgebungenListeComboBox.ItemIndex > -1 THEN
  BEGIN
    IF Assigned(ArbeitsumgebungenListeComboBox.Items.Objects[ArbeitsumgebungenListeComboBox.ItemIndex]) THEN
    BEGIN
      Dateiname := absolutPathAppl(TDateiListeneintrag(ArbeitsumgebungenListeComboBox.Items.Objects[ArbeitsumgebungenListeComboBox.ItemIndex]).Dateiname, Application.ExeName, False);
      Arbeitsumgebungbearbeiten(Dateiname);
    END;
  END
  ELSE
    IF ArbeitsumgebungenListeComboBox.Text <> '' THEN
    BEGIN
      Dateiname := absolutPathAppl(ArbeitsumgebungenListeComboBox.Text, Application.ExeName, False);
      IF LowerCase(ExtractFileExt(Dateiname)) <> '.mau' THEN
        Dateiname := Dateiname + '.mau';
      IF Arbeitsumgebungbearbeiten(Dateiname) = 0 THEN
      BEGIN
        Arbeitsumgebungeinfuegen(relativPathAppl(Dateiname, Application.ExeName));
        IF ArbeitsumgebungverzeichnisspeichernBox.Checked THEN
          ArbeitsumgebungenverzeichnisEdit.Text := relativPathAppl(ExtractFilePath(Dateiname), Application.ExeName);
      END;
    END;
end;

procedure TArbeitsumgebungFenster.ListeneintragloeschenClick(Sender: TObject);
begin
  IF ArbeitsumgebungenListeComboBox.ItemIndex < 0 THEN
    ArbeitsumgebungenListeComboBox.ItemIndex := ArbeitsumgebungenListeComboBox.Items.IndexOf(ArbeitsumgebungenListeComboBox.Text);
  IF ArbeitsumgebungenListeComboBox.ItemIndex > 0 THEN
  BEGIN
    aktArbeitsumgebungComboBox.Items.Delete(ArbeitsumgebungenListeComboBox.ItemIndex);
    IF (aktArbeitsumgebungComboBox.ItemIndex < 0) AND
       (aktArbeitsumgebungComboBox.Items.Count > 0) THEN
      aktArbeitsumgebungComboBox.ItemIndex := 0;
    IF Assigned(ArbeitsumgebungenListeComboBox.Items.Objects[ArbeitsumgebungenListeComboBox.ItemIndex]) THEN
      ArbeitsumgebungenListeComboBox.Items.Objects[ArbeitsumgebungenListeComboBox.ItemIndex].Free;
    ArbeitsumgebungenListeComboBox.DeleteSelected;
  END;
end;

procedure TArbeitsumgebungFenster.ArbeitsumgebungenMenuPopup(Sender: TObject);
begin
  IF (ArbeitsumgebungenListeComboBox.ItemIndex > -1) OR
     (ArbeitsumgebungenListeComboBox.Text <> '') THEN
    Listeneintragbearbeiten.Enabled := True
  ELSE
    Listeneintragbearbeiten.Enabled := False;
  IF (ArbeitsumgebungenListeComboBox.ItemIndex > -1) OR
     (ArbeitsumgebungenListeComboBox.Items.IndexOf(ArbeitsumgebungenListeComboBox.Text) > -1) THEN
    Listeneintragloeschen.Enabled := True
  ELSE
    Listeneintragloeschen.Enabled := False;
end;

PROCEDURE TArbeitsumgebungFenster.Arbeitsumgebungeinfuegen(Name: STRING);

VAR Dateieintrag : TDateiListeneintrag;

BEGIN
  IF ArbeitsumgebungenListeComboBox.Items.IndexOf(ChangeFileExt(ExtractFileName(Name), '')) < 0 THEN
  BEGIN
    Dateieintrag := TDateiListeneintrag.Create;
    Dateieintrag.Name := ChangeFileExt(ExtractFileName(Name), '');
    Dateieintrag.Dateiname := Name;
    aktArbeitsumgebungComboBox.Items.Add(Dateieintrag.Name);
    ArbeitsumgebungenListeComboBox.Items.AddObject(Dateieintrag.Name, Dateieintrag);
    ArbeitsumgebungenListeComboBox.ItemIndex := ArbeitsumgebungenListeComboBox.Items.Count - 1;
  END;
END;

FUNCTION TArbeitsumgebungFenster.Arbeitsumgebungbearbeiten(Name: STRING): Integer;

VAR Arbeitsumgebung : TArbeitsumgebung;

BEGIN
  Result := 0;
  IF Name <> '' THEN
  BEGIN
    Arbeitsumgebung := TArbeitsumgebung.Create;
    TRY
      Arbeitsumgebung.ApplikationsName := Application.ExeName;
      Arbeitsumgebung.Protokollerstellen := False;
      Arbeitsumgebung.festeFramerateverwenden := False;
      IF FileExists(Name) THEN
        Arbeitsumgebung.Arbeitsumgebungladen(Name)
      ELSE
        Arbeitsumgebung.Arbeitsumgebungladen(ExtractFilePath(Application.ExeName) + 'Standard.mau');
      Optionenfenster.Arbeitsumgebung := Arbeitsumgebung;
      Optionenfenster.OptionenSeiten.ActivePageIndex := 0;
      IF Optionenfenster.ShowModal = mrOK THEN
      BEGIN
        Arbeitsumgebung.Arbeitsumgebungspeichern(Name);
        Result := 0;
      END
      ELSE
        Result := -1;
    EXCEPT
      Arbeitsumgebung.Free;
    END;
  END
  ELSE
    Result := -2;  
END;

PROCEDURE ArbeitsumgebungCreate;
BEGIN
  ArbeitsumgebungenListe := TStringList.Create;
  ArbeitsumgebungObj := TArbeitsumgebung.Create;
  ArbeitsumgebungObj.ApplikationsName := Application.ExeName;
  ArbeitsumgebungObj.Protokollerstellen := False;
  ArbeitsumgebungObj.festeFramerateverwenden := False;
  Arbeitsumgebungenladen(ChangeFileExt(Application.ExeName, '.ini'));
END;

PROCEDURE ArbeitsumgebungDestroy;
BEGIN
  Stringliste_loeschen(ArbeitsumgebungenListe);
  ArbeitsumgebungenListe.Free;
  ArbeitsumgebungenListe := NIL;
  ArbeitsumgebungObj.Free;
  ArbeitsumgebungObj := NIL;
END;

PROCEDURE Arbeitsumgebungenladen(Name: STRING);

VAR IniFile : TIniFile;
    Dateieintrag : TDateiListeneintrag;
    I : Integer;
    HString : STRING;

BEGIN
  IniFile := TIniFile.Create(Name);
  Arbeitsumgebungenverzeichnis := absolutPathAppl(IniFile.ReadString('Allgemein', 'Ini-Dateien', ''), Application.ExeName, True);
  Arbeitsumgebungenverzeichnisspeichern := IniFile.ReadBool('Allgemein', 'IniDateienVerzeichnisspeichern', True);
  aktArbeitsumgebung := IniFile.ReadInteger('Arbeitsumgebungen', 'aktive_Arbeitsumgebung', 0);
  BeiStartStandardladen := IniFile.ReadBool('Arbeitsumgebungen', 'bei_Programmstart_Standard_laden', False);
  aktArbeitsumgebungbeiEndespeichern := IniFile.ReadBool('Arbeitsumgebungen', 'bei_Programmende_akt_Umgebung_speichern', True);
  ArbeitsumgebungbeiOKspeichern := IniFile.ReadBool('Arbeitsumgebungen', 'Arbeitsumgebung_bei_OK_speichern', True);
  Stringliste_loeschen(ArbeitsumgebungenListe);
  Dateieintrag := TDateiListeneintrag.Create;
  Dateieintrag.Name := 'Standard';
  Dateieintrag.Dateiname := ExtractFilePath(Application.ExeName) + 'Standard.mau';
  ArbeitsumgebungenListe.AddObject('Standard.mau', Dateieintrag);
  I := 0;
  REPEAT
    HString := IniFile.ReadString('Arbeitsumgebungen', 'Arbeitsumgebung-' + IntToStr(I), 'letzter');
    IF HString <> 'letzter' THEN
    BEGIN
      HString := absolutPathAppl(HString, Application.ExeName, False);
      IF (HString <> TDateiListeneintrag(ArbeitsumgebungenListe.Objects[0]).Dateiname) AND
          FileExists(HString) THEN
      BEGIN
        Dateieintrag := TDateiListeneintrag.Create;
        Dateieintrag.Name := ChangeFileExt(ExtractFileName(HString), '');
        Dateieintrag.Dateiname := HString;
        ArbeitsumgebungenListe.AddObject(Dateieintrag.Name, Dateieintrag);
      END;
    END;
    Inc(I);
  UNTIL HString = 'letzter';
  Sprachverzeichnis := absolutPathAppl(IniFile.ReadString('Allgemein', 'Sprachverzeichnis', ''), Application.ExeName, True);
  Sprachdateiname := {absolutPathAppl(}IniFile.ReadString('Allgemein', 'Sprachdatei', ''){, Application.ExeName, False)};
  aktuelleSprache := IniFile.ReadString('Allgemein', 'aktuelleSprache', '');
  IniFile.Free;
END;

PROCEDURE Arbeitsumgebungenspeichern(Name: STRING);

VAR I, J : Integer;
    IniFile : TIniFile;
    Lizenzakzeptiert : Boolean;


BEGIN
  IniFile := TIniFile.Create(Name);
  Lizenzakzeptiert := IniFile.ReadBool('Allgemein', 'Lizenzakzeptiert', False); // zum bereinigen
  IniFile.EraseSection('Allgemein');                                            // der Mpeg2Schnitt.ini
  IniFile.EraseSection('Tastenbelegung');                                       // von den Einstellungen
  IniFile.EraseSection('Arbeitsumgebungen');                                    // der Standard.mau
  IniFile.WriteBool('Allgemein', 'Lizenzakzeptiert', Lizenzakzeptiert);
  IniFile.WriteString('Allgemein', 'Ini-Dateien', relativPathAppl(Arbeitsumgebungenverzeichnis, Application.ExeName));
  IniFile.WriteBool('Allgemein', 'IniDateienVerzeichnisspeichern', Arbeitsumgebungenverzeichnisspeichern);
  IniFile.WriteBool('Arbeitsumgebungen', 'bei_Programmstart_Standard_laden', BeiStartStandardladen);
  IniFile.WriteBool('Arbeitsumgebungen', 'bei_Programmende_akt_Umgebung_speichern', aktArbeitsumgebungbeiEndespeichern);
  IniFile.WriteBool('Arbeitsumgebungen', 'Arbeitsumgebung_bei_OK_speichern', ArbeitsumgebungbeiOKspeichern);
  IniFile.WriteInteger('Arbeitsumgebungen', 'aktive_Arbeitsumgebung', aktArbeitsumgebung);
  J := 0;
  FOR I := 0 TO ArbeitsumgebungenListe.Count - 1 DO
    IF Assigned(ArbeitsumgebungenListe.Objects[I]) AND
       (FileExists(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[I]).Dateiname) OR
       (I = 0)) THEN
    BEGIN
      IniFile.WriteString('Arbeitsumgebungen', 'Arbeitsumgebung-' + IntToStr(J), relativPathAppl(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[I]).Dateiname, Application.ExeName));
      Inc(J);
    END;
  IniFile.WriteString('Allgemein', 'Sprachverzeichnis', relativPathAppl(Sprachverzeichnis, Application.ExeName));
  IniFile.WriteString('Allgemein', 'Sprachdatei', {relativPathAppl(}Sprachdateiname{, Application.ExeName)});
  IniFile.WriteString('Allgemein', 'aktuelleSprache', aktuelleSprache);
  IniFile.Free;
END;

PROCEDURE Arbeitsumgebungladen(Arbeitsumgebung: Integer);

VAR Dateieintrag : TDateiListeneintrag;

BEGIN
  IF ArbeitsumgebungenListe.Count = 0 THEN                       // vorsichtshalber
  BEGIN
    Dateieintrag := TDateiListeneintrag.Create;
    Dateieintrag.Name := 'Standard';
    Dateieintrag.Dateiname := ExtractFilePath(Application.ExeName) + 'Standard.mau';
    ArbeitsumgebungenListe.AddObject('Standard.mau', Dateieintrag);
  END;
  IF (Arbeitsumgebung < 0) OR
     (Arbeitsumgebung > ArbeitsumgebungenListe.Count - 1) THEN
    Arbeitsumgebung := 0;                                        // Arbeitsumgebung außerhalb der Liste
  IF NOT FileExists(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[Arbeitsumgebung]).Dateiname) THEN
    Arbeitsumgebung := 0;                                        // Arbeitsumgebung existiert nicht
  aktArbeitsumgebung := Arbeitsumgebung;
  ArbeitsumgebungObj.Arbeitsumgebungladen(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[Arbeitsumgebung]).Dateiname);
END;

FUNCTION ArbeitsumgebungladenName(Arbeitsumgebung: STRING): Integer;
BEGIN
  IF LowerCase(ExtractFileExt(Arbeitsumgebung)) = '.mau' THEN
  BEGIN
    Result := 0;
    Arbeitsumgebung := absolutPathAppl(Arbeitsumgebung, Application.ExeName, False);
    IF FileExists(Arbeitsumgebung) THEN
    BEGIN
      ArbeitsumgebungObj.Arbeitsumgebungladen(Arbeitsumgebung);
      Result := ArbeitsumgebungenListe.IndexOf(ChangeFileExt(ExtractFileName(Arbeitsumgebung), ''));
    END;
  END
  ELSE
    Result := -2;
END;

PROCEDURE Arbeitsumgebungspeichern(Arbeitsumgebung: Integer);
BEGIN
  IF (Arbeitsumgebung > -1) AND
     (Arbeitsumgebung < ArbeitsumgebungenListe.Count) THEN
  BEGIN
    aktArbeitsumgebung := Arbeitsumgebung;
    ArbeitsumgebungObj.Arbeitsumgebungspeichern(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[Arbeitsumgebung]).Dateiname);
    ArbeitsumgebungObj.ProgrammPositionspeichern(TDateiListeneintrag(ArbeitsumgebungenListe.Objects[Arbeitsumgebung]).Dateiname);
  END;
END;

PROCEDURE ArbeitsumgebungspeichernName(Arbeitsumgebung: STRING);
BEGIN
  Arbeitsumgebung := absolutPathAppl(Arbeitsumgebung, Application.ExeName, False);
  ArbeitsumgebungObj.Arbeitsumgebungspeichern(Arbeitsumgebung);
  ArbeitsumgebungObj.ProgrammPositionspeichern(Arbeitsumgebung);
END;

PROCEDURE aktArbeitsumgebungspeichern;
BEGIN
  IF aktArbeitsumgebungbeiEndespeichern THEN
    Arbeitsumgebungspeichern(aktArbeitsumgebung);
END;

PROCEDURE TArbeitsumgebungFenster.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Caption := Wortlesen(Spracheladen, 'ArbeitsumgebungFenster', Caption);
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
