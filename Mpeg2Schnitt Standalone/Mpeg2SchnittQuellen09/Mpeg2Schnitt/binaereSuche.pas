{-----------------------------------------------------------------------------------
Diese Unit implementiert eine binäre Schnittsuche in das Programm Mpeg2Schnitt

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

unit binaereSuche;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,
  AllgFunktionen, AllgVariablen, Arbeitsumgebung, ExtCtrls, Menus;

type
  TbinaereSucheKlick = PROCEDURE(Taste: Integer) OF OBJECT;

  TbinaereSucheForm = class(TForm)
    FensterPanel: TPanel;
    FilmPosition_: TLabel;
    binaereSucheFilm: TSpeedButton;
    WerbePosition_: TLabel;
    binaereSucheWerbung: TSpeedButton;
    binaereSuchePopup: TPopupMenu;
    binaereSucheSchliessen: TMenuItem;
    FensterimVordergrund: TMenuItem;
    FenstermitRahmen: TMenuItem;
    procedure binaereSucheClick(Sender: TObject);
    procedure binaereSucheSchliessenClick(Sender: TObject);
    procedure FensterimVordergrundClick(Sender: TObject);
    procedure FenstermitRahmenClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FbinaereSucheKlick: TbinaereSucheKlick;
    PROCEDURE SetzeFensterimVordergrund;
    PROCEDURE SetzeFenstermitRahmen;
  public
    { Public-Deklarationen }
    PROCEDURE Init;
    PROCEDURE Fensterpositionsetzen;
    PROCEDURE Fensterpositionmerken;
    PROPERTY binaereSucheKlick: TbinaereSucheKlick WRITE FbinaereSucheKlick;
  end;

var
  binaereSucheForm: TbinaereSucheForm;

implementation

{$R *.dfm}

procedure TbinaereSucheForm.binaereSucheClick(Sender: TObject);
begin
  IF Assigned(FbinaereSucheKlick) THEN
    IF Sender = binaereSucheFilm THEN
      FbinaereSucheKlick(1)
    ELSE
      FbinaereSucheKlick(2);
end;

PROCEDURE TbinaereSucheForm.Init;
BEGIN
  WerbePosition_.Caption := '??:??:??:??';
  FilmPosition_.Caption := '??:??:??:??';
  binaereSucheFilm.Enabled := False;
  binaereSucheWerbung.Enabled := False;
END;

procedure TbinaereSucheForm.binaereSucheSchliessenClick(Sender: TObject);
begin
  Hide;
end;

procedure TbinaereSucheForm.FensterimVordergrundClick(Sender: TObject);
begin
  FensterimVordergrund.Checked := NOT FensterimVordergrund.Checked;
  SetzeFensterimVordergrund;
end;

procedure TbinaereSucheForm.FenstermitRahmenClick(Sender: TObject);
begin
  FenstermitRahmen.Checked := NOT FenstermitRahmen.Checked;
  SetzeFenstermitRahmen;
end;

PROCEDURE TbinaereSucheForm.SetzeFensterimVordergrund;
BEGIN
  IF FensterimVordergrund.Checked THEN
    FormStyle := fsStayOnTop
  ELSE
    FormStyle := fsNormal;
END;

PROCEDURE TbinaereSucheForm.SetzeFenstermitRahmen;
BEGIN
  IF FenstermitRahmen.Checked THEN
  BEGIN
    FensterPanel.BevelInner := bvNone;
    FensterPanel.BevelOuter := bvNone;
    BorderStyle := bsSizeToolWin;
  END
  ELSE
  BEGIN
    FensterPanel.BevelInner := bvRaised;
    FensterPanel.BevelOuter := bvLowered;
    BorderStyle := bsNone;
  END;
END;

PROCEDURE TbinaereSucheForm.Fensterpositionsetzen;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    Top := ArbeitsumgebungObj.BinaereSucheFensterOben;
    Left := ArbeitsumgebungObj.BinaereSucheFensterLinks;
    Width := ArbeitsumgebungObj.BinaereSucheFensterBreite;
    Height := ArbeitsumgebungObj.BinaereSucheFensterHoehe;
    FensterimVordergrund.Checked := ArbeitsumgebungObj.BinaereSucheFensterVordergrund;
    SetzeFensterimVordergrund;
    Visible := ArbeitsumgebungObj.BinaereSucheFensterSichtbar;
    FenstermitRahmen.Checked := ArbeitsumgebungObj.BinaereSucheFensterRahmen;
    SetzeFenstermitRahmen;
  END;
END;

PROCEDURE TbinaereSucheForm.Fensterpositionmerken;
BEGIN
  IF Assigned(ArbeitsumgebungObj) THEN
  BEGIN
    ArbeitsumgebungObj.BinaereSucheFensterOben := Top;
    ArbeitsumgebungObj.BinaereSucheFensterLinks := Left;
    ArbeitsumgebungObj.BinaereSucheFensterBreite := Width;
    ArbeitsumgebungObj.BinaereSucheFensterHoehe := Height;
    ArbeitsumgebungObj.BinaereSucheFensterVordergrund := FensterimVordergrund.Checked;
    ArbeitsumgebungObj.BinaereSucheFensterRahmen := FenstermitRahmen.Checked;
    ArbeitsumgebungObj.BinaereSucheFensterSichtbar := Visible;
  END;
END;

end.
