{-----------------------------------------------------------------------------------
Diese Unit ist Teil des Programms IndexTool.

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

unit Ueber;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, Dialogs, Textanzeigefenster;

type
  TUeberFenster = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Kommentar1: TLabel;
    OKButton: TButton;
    akzeptiert: TCheckBox;
    Kommentar2: TLabel;
    Internet_: TLabel;
    EMail_: TLabel;
    Lizenzvertrag: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure LizenzvertragClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UeberFenster: TUeberFenster;

CONST Versionsnr = '0.2c';

implementation
                                              
USES Hauptfenster;

{$R *.dfm}

procedure TUeberFenster.FormShow(Sender: TObject);
begin
  ProductName.Caption := 'Programmname: IndexTool';
  Version.Caption := 'Version: ' + Versionsnr;
  Copyright.Caption := 'Copyright: (2003)   Martin Dienert';
  Internet_.Caption := 'Internetseite: www.mdienert.de/mpeg2schnitt';
  EMail_.Caption := 'EMail: meinmpeg2schnitt@gmx.de';
  Kommentar1.Caption := 'Mpeg2Schnitt comes with ABSOLUTELY NO WARRANTY. This is free software, and you are welcome to redistribute it under certain conditions. See the License for more details.' + Chr(13) +
                        'The software may be used only for personal, not commercial purposes.' + Chr(13) +
                        'Auf Deutsch:' + Chr(13) +
                        'Für Mpeg2Schnitt besteht KEINERLEI GARANTIE. Mpeg2Schnitt ist freie Software, die Sie unter bestimmten Bedingungen weitergeben dürfen. Weitere Informationen im Lizenzvertrag.' + Chr(13) +
                        'Die Software darf nur für persönliche, nicht gewerbliche Zwecke benutzt werden.';
  Kommentar2.Caption := 'Das Programm Indextool dient zum Erzeugen von Indexdateien aus Mpeg2-Videodateien sowie MpegAudio- und AC3-Dateien. Diese Indexdateien werden vom Programm "Mpeg2Schnitt" verwendet.' + Chr(13) +
                        'Die Annahme des Lizenzvertrages gilt auch für das Programm "Mpeg2Schnitt".'
end;

procedure TUeberFenster.OKButtonClick(Sender: TObject);
begin
  IF akzeptiert.Checked THEN
    ModalResult := mrOK
  ELSE
    ModalResult := mrCancel;
end;

procedure TUeberFenster.LizenzvertragClick(Sender: TObject);
begin
  Application.CreateForm(TTextfenster, Textfenster);
  Textfenster.Text.Lines.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Lizenz.txt');
  Textfenster.ShowModal;
  Textfenster.Free;
end;

procedure TUeberFenster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IF akzeptiert.Checked THEN
    ModalResult := mrOK
  ELSE
    ModalResult := mrCancel;
end;

end.

