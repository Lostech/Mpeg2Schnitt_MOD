{-----------------------------------------------------------------------------------
Das Programm IndexTool ist ein Hilfsprogramm zum Erstellen von Indexdateien
für das Programm Mpeg2Schnitt.

Copyright (C) 2003  Martin Dienert
 Homepage: http:www.mdienert.de/mpeg2schnitt/
 E-Mail:   meinmpeg2schnitt@gmx.de

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
program Index;

uses
  Forms,
  Controls,           // für mrOK
  IniFiles,           // für TIniFile
  SysUtils,           // ChangeFileExt                  
  Hauptfenster in 'Hauptfenster.pas' {IndexTool},
  Dateipuffer in '..\Mpeg-Schnitt\Dateipuffer.pas',
  Mpeg2Unit in '..\Mpeg-Schnitt\Mpeg2Unit.pas',
  Ueber in 'Ueber.pas' {UeberFenster},
  WinEnde in '..\Units\WinEnde.pas',
  Protokoll in '..\Mpeg-Schnitt\Protokoll.pas',
  Textanzeigefenster in '..\Mpeg-Schnitt\Textanzeigefenster.pas' {Textfenster};

{$R *.res}

VAR IniFile : TIniFile;

begin
  Application.Initialize;
  Application.Title := 'Indextool';
  Application.CreateForm(TIndexTool, IndexTool);
  Application.CreateForm(TUeberFenster, UeberFenster);
  Application.CreateForm(TTextfenster, Textfenster);
//  Application.Run;
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.ini');
  IF NOT IniFile.ReadBool('Allgemein', 'Lizenzakzeptiert', False) THEN
  BEGIN
    IF UeberFenster.ShowModal = mrOK THEN
    BEGIN
      IniFile.WriteBool('Allgemein', 'Lizenzakzeptiert', True);
      IniFile.Free;
      UeberFenster.akzeptiert.Enabled := False;
      UeberFenster.Lizenzvertrag.Enabled := False;
      Application.Run;
    END
    ELSE
      IniFile.Free;
  END
  ELSE
  BEGIN
    IniFile.Free;
    UeberFenster.akzeptiert.Checked := True;
    UeberFenster.akzeptiert.Enabled := False;
//    UeberFenster.Lizenzvertrag.Enabled := False;
    Application.Run;
  END;  
end.
