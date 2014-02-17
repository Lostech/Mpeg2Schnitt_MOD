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

unit Hinweis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  Sprachen, Buttons;                          // ändern der Sprache

type
  THinweisfenster = class(TForm)
    Hinweistext: TLabel;
    Autoschliessen: TTimer;
    OKTaste: TBitBtn;
    procedure AutoschliessenTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKTasteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
  Hinweisfenster: THinweisfenster = NIL;

PROCEDURE Hinweisanzeigen(Hinweistext: STRING; Anzeigedauer: Integer; Modalanzeigen, OKanzeigen: Boolean);

implementation

{$R *.dfm}

PROCEDURE Hinweisanzeigen(Hinweistext: STRING; Anzeigedauer: Integer; Modalanzeigen, OKanzeigen: Boolean);
BEGIN
  IF Anzeigedauer > 0 THEN
  BEGIN
    Application.CreateForm(THinweisfenster, Hinweisfenster);
    Hinweisfenster.Hide;
    Hinweisfenster.Autoschliessen.Interval := Anzeigedauer * 1000;
    Hinweisfenster.Autoschliessen.Enabled := True;
    Hinweisfenster.Spracheaendern(NIL);
    Hinweisfenster.Hinweistext.Caption := Hinweistext;
    IF OKanzeigen THEN
      Hinweisfenster.OKTaste.Enabled := True
    ELSE
      Hinweisfenster.OKTaste.Enabled := False;
    IF Modalanzeigen THEN
      Hinweisfenster.ShowModal
    ELSE
      Hinweisfenster.Show;
  END;
END;

procedure THinweisfenster.AutoschliessenTimer(Sender: TObject);
begin
  Close;
end;

procedure THinweisfenster.OKTasteClick(Sender: TObject);
begin
  Close;
end;

PROCEDURE THinweisfenster.Spracheaendern(Spracheladen: TSprachen);
BEGIN
  Caption := Wortlesen(Spracheladen, Caption, 'Hinweis');
END;

procedure THinweisfenster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
