{-----------------------------------------------------------------------------------
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

program Mpeg2Schnitt;

{$R 'StdSymbolSet.res' 'StdSymbolSet.rc'}
{%File 'Sprachdatei.spr'}

uses
  Forms,
  Controls,
  IniFiles,
  SysUtils,
//  ShellApi,
//  Windows,
  Ueber in '..\Units\Mpeg2Schnitt\Ueber.pas' {UeberFenster},
  Hauptfenster in 'Hauptfenster.pas' {MpegEdit},
  Fortschritt in 'Fortschritt.pas' {Fortschrittsfenster},
  Mpeg2Fenster in 'Mpeg2Fenster.pas',
  Mpeg2decoder in 'Mpeg2decoder.pas',
  DirectDraw in 'DirectDraw.pas',
  Dateipuffer in 'Dateipuffer.pas',
//  Mpeg2Unit in 'Mpeg2Unit.pas',
  Audioplay in 'Audioplay.pas',
  Protokoll in 'Protokoll.pas',
  DirectSound in 'DirectSound.pas',
  DirectShow in 'DirectShow.pas',
  DXCommon in 'DXCommon.pas',
  Textanzeigefenster in '..\Units\Mpeg2Schnitt\Textanzeigefenster.pas' {Textfenster},
  DirectXGraphics in 'DirectXGraphics.pas',
  Sprachen in '..\Units\Mpeg2Schnitt\Sprachen.pas',
  Schnittsuche in 'Schnittsuche.pas' {SchnittsucheFenster},
  Hinweis in 'Hinweis.pas' {Hinweisfenster},
  Optfenster in 'Optfenster.pas' {Optionenfenster},
  Efffenster in 'Efffenster.pas' {Effektfenster},
  Ausgfenster in 'Ausgfenster.pas' {Ausgabefenster},
  DatenTypen in 'DatenTypen.pas',
  Mauladenspeichern in '..\Units\Mpeg2Schnitt\Mauladenspeichern.pas',
  Arbeitsumgebung in 'Arbeitsumgebung.pas' {ArbeitsumgebungFenster},
  AlphaBlend in '..\Units\Mpeg2Schnitt\AlphaBlend.pas',
  UndoRedo in 'UndoRedo.pas',
  Skins in '..\Units\Mpeg2Schnitt\Skins.pas',
  ThemeHandling in '..\Units\Mpeg2Schnitt\ThemeHandling.pas',
  Mpeg2decoder2 in 'Mpeg2Decoder2.pas',
  binaereSuche in 'binaereSuche.pas' {binaereSucheForm},
  FilmGrobAnsicht in 'FilmGrobAnsicht.pas' {FilmGrobAnsichtFrm},
  AllgVariablen in 'AllgVariablen.pas',
  AllgFunktionen in '..\Units\Mpeg2Schnitt\AllgFunktionen.pas';

{$R *.RES}

VAR IniFile : TIniFile;

begin
  Application.Initialize;
  Application.Title := 'Mpeg2Schnitt';
  Application.CreateForm(TMpegEdit, MpegEdit);
  Application.CreateForm(TUeberFenster, UeberFenster);
  Application.CreateForm(TFortschrittsfenster, Fortschrittsfenster);
  Application.CreateForm(TSchnittsucheFenster, SchnittsucheFenster);
  Application.CreateForm(TOptionenfenster, Optionenfenster);
  Application.CreateForm(TEffektfenster, Effektfenster);
  Application.CreateForm(TAusgabefenster, Ausgabefenster);
  Application.CreateForm(TbinaereSucheForm, binaereSucheForm);
  Application.CreateForm(TFilmGrobAnsichtFrm, FilmGrobAnsichtFrm);
  Application.CreateForm(TArbeitsumgebungFenster, ArbeitsumgebungFenster);
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  IF NOT IniFile.ReadBool('Allgemein', 'Lizenzakzeptiert', False) THEN
  BEGIN
    IF UeberFenster.ShowModal = mrOK THEN
    BEGIN
      IniFile.WriteBool('Allgemein', 'Lizenzakzeptiert', True);
      IniFile.Free;
      UeberFenster.Lizensiert := True;
//      UeberFenster.akzeptiert.Enabled := False;
//      UeberFenster.Lizenzvertrag.Enabled := False;
      MpegEdit.Optionenlesen;
      MpegEdit.Spracheeinlesen;
      MpegEdit.Kommandozeile;
//      ShellExecute(Application.Handle, 'open', PCHar(ExtractFilePath(Application.ExeName) + 'Installation.html'), nil, nil, SW_ShowNormal);
      Application.Run;
    END
    ELSE
      IniFile.Free;
  END
  ELSE
  BEGIN
    IniFile.Free;
    UeberFenster.Lizensiert := True;
//    UeberFenster.akzeptiert.Checked := True;
//    UeberFenster.akzeptiert.Enabled := False;
//    UeberFenster.Lizenzvertrag.Enabled := False;
    MpegEdit.Optionenlesen;
    MpegEdit.Spracheeinlesen;
    MpegEdit.Kommandozeile;
    Application.Run;
  END;
end.
