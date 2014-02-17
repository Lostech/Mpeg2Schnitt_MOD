{----------------------------------------------------------------------------------------------
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

unit Fortschritt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls,     // Standardunits
  DateUtils,              // Zeitsteuerung
  Sprachen,               // Sprachunterstützung
  StrUtils,               // AnsiReplaceText
  AllgVariablen;        // Programmeinstellungen

type
  TFortschrittsfenster = class(TForm)
    AbbrechenTaste: TButton;
    Fortschrittsbalken: TProgressBar;
    Fortschrittstext: TLabel;
    procedure AbbrechenTasteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    Anhalten : Boolean;
    FMinimiert : Boolean;
    FAktualisierungszyklus : Integer;
    FEndwert : Int64;
    naechsteAktualisierung : TDateTime;
    alterWert,
    neuerWert : Integer;
    Fortschritt1,
    Fortschritt2,
    Fortschritt3,
    Fortschritt4,
    Fortschritt5,
    Fortschritt6 : STRING;
  public
    { Public-Deklarationen }
    Fensterwarsichtbar : Boolean;
    PROCEDURE Fensteranzeigen;
    PROCEDURE Fensterverbergen;
    FUNCTION Fortschrittsanzeige(Fortschritt: Int64): Boolean;
    FUNCTION Textanzeige(Meldung: Integer; Text: STRING): Boolean;
    PROPERTY Minimiert: Boolean READ FMinimiert WRITE FMinimiert;
    PROPERTY Aktualisierungszyklus : Integer READ FAktualisierungszyklus WRITE FAktualisierungszyklus;
    PROPERTY Endwert : Int64 READ FEndwert WRITE FEndwert;
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
  Fortschrittsfenster: TFortschrittsfenster;
                                                          
implementation

{$R *.DFM}
procedure TFortschrittsfenster.FormCreate(Sender: TObject);
begin
  Fensterwarsichtbar := False;
  Anhalten := False;
  FAktualisierungszyklus := 1000;
  FEndwert := 100;
end;

procedure TFortschrittsfenster.FormShow(Sender: TObject);
begin
  Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
  Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
end;

PROCEDURE TFortschrittsfenster.Fensteranzeigen;
BEGIN
  Fortschrittsbalken.Position := 0;
  Fortschrittstext.Caption := '';
  alterWert := 0;
  Fortschrittsbalken.Update;
  naechsteAktualisierung := incMilliSecond(Time,FAktualisierungszyklus);
  IF Visible THEN
//    Fensterwarsichtbar := True
  ELSE
    Show;
END;

PROCEDURE TFortschrittsfenster.Fensterverbergen;
BEGIN
//  IF Fensterwarsichtbar THEN
//    Fensterwarsichtbar := False
//  ELSE
    Hide;
END;

FUNCTION TFortschrittsfenster.Fortschrittsanzeige(Fortschritt: Int64): Boolean;
BEGIN
  IF FEndwert > 0 THEN
    neuerWert := Round((Fortschritt*100)/FEndwert)
  ELSE
    neuerWert  := 0;
  IF ((neuerWert > alterWert) OR (Time > naechsteAktualisierung)) AND Visible THEN
  BEGIN
    alterWert := neuerWert;
    Fortschrittsbalken.Position := neuerWert;
    Fortschrittsbalken.Update;
    naechsteAktualisierung := incMilliSecond(Time, FAktualisierungszyklus);
  END;
  Application.ProcessMessages;
  Result := Anhalten;
  Anhalten := False;
END;

FUNCTION TFortschrittsfenster.Textanzeige(Meldung: Integer; Text: STRING): Boolean;
BEGIN
  CASE Meldung OF
    1 : Fortschrittstext.Caption := AnsiReplaceText(Fortschritt1, '$Text1#', Text);
    2 : Fortschrittstext.Caption := AnsiReplaceText(Fortschritt2, '$Text1#', Text);
    3 : Fortschrittstext.Caption := AnsiReplaceText(Fortschritt3, '$Text1#', Text);
    4 : Fortschrittstext.Caption := AnsiReplaceText(Fortschritt4, '$Text1#', Text);
    5 : Fortschrittstext.Caption := AnsiReplaceText(Fortschritt5, '$Text1#', Text);
    6 : Fortschrittstext.Caption := AnsiReplaceText(Fortschritt6, '$Text1#', Text);
  ELSE
    Fortschrittstext.Caption := Text;
  END;
  IF Fortschrittstext.Caption = '' THEN
    Fortschrittstext.Caption := Text;
  Fortschrittstext.Update;
  Application.ProcessMessages;
  Result := Anhalten;
  Anhalten := False;
END;

procedure TFortschrittsfenster.AbbrechenTasteClick(Sender: TObject);
begin
  Anhalten := True;
end;

PROCEDURE TFortschrittsfenster.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    Komponente : TComponent;

BEGIN
  Caption := Wortlesen(Spracheladen, 'FortschrittsFenster', Caption);
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
    END;    }
    IF Komponente IS TCheckBox THEN           // in der Unit StdCtrls
    BEGIN
      TCheckBox(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TCheckBox(Komponente).Caption);
      TCheckBox(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TCheckBox(Komponente).Hint);
    END;
{    IF Komponente IS TRadioButton THEN
    BEGIN
      TRadioButton(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TRadioButton(Komponente).Caption);
      TRadioButton(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TRadioButton(Komponente).Hint);
    END;    }
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
    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      TTabSheet(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TTabSheet(Komponente).Caption);
      TTabSheet(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TTabSheet(Komponente).Hint);
    END;
  END;
  Fortschritt1 := Wortlesen(Spracheladen, 'Fortschritt1', 'Datei $Text1# analysieren.');
  Fortschritt2 := Wortlesen(Spracheladen, 'Fortschritt2', 'Indexdatei $Text1# einlesen.');
  Fortschritt3 := Wortlesen(Spracheladen, 'Fortschritt3', 'Indexdatei $Text1# schreiben.');
  Fortschritt4 := Wortlesen(Spracheladen, 'Fortschritt4', 'Schnitt $Text1# kopieren.');
  Fortschritt5 := Wortlesen(Spracheladen, 'Fortschritt5', 'Suche Schnitte im Audio/Video.');
  Fortschritt6 := Wortlesen(Spracheladen, 'Fortschritt6', '$Text1# Schnitt(e) gefunden.');
END;

end.
