{-----------------------------------------------------------------------------------
Diese INC Datei ist Teil der MOD Extension (Erweiterung) des Programms Mpeg2Schnitt.

Das Programm Mpeg2Schnitt ist ein einfaches Schnittprogramm (nur harte Schnitte) für
Mpeg2Video-Dateien und Mpeg2- und AC3Ton-Dateien.

Copyright (C) 2003  Martin Dienert
 Homepage: http:www.mdienert.de/mpeg2schnitt/
 E-Mail:   m.dienert@gmx.de

Die MOD Extension erlaubt die Integration von ProjectX
(ProjectX - a free Java based demux utility -> http://sourceforge.net/projects/project-x/)
sowie die Nutzung von dvdauthor (http://dvdauthor.sourceforge.net/), MKISOFS (http://freshmeat.net/projects/mkisofs),
MEDIAINFO.DLL (http://mediainfo.sourceforge.net/), MPLEX (http://mjpeg.sourceforge.net/),
TCMPLEX-PANTELTJE (http://panteltje.com/panteltje/dvd/index.html bzw. http://tekcode.te.funpic.de)
und NERO Burning ROM (http://www.nero.com/deu/index.html) im Mpeg2Schnitt Programm.

MOD Extension Copyright (C) 2006-2012  Lostech
 Homepage: http://www.lostech.de.vu
 E-Mail:   lostech@gmx.de

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

unit DVD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MediaInfo, ComCtrls, StdCtrls, Buttons, ExtCtrls, StrUtils,
  JvSpin, DateUtils, JvComponentBase, JvBrowseFolder, IniFiles,
  JvBaseDlg, JvCreateProcess, ShellApi, JvExStdCtrls, JvCombobox,
  JvDriveCtrls, Mask, JvExMask, Menus;

const
  WM_AFTER_SHOW = WM_USER + 300;

type
  TDVDForm = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    JvSpinEdit1: TJvSpinEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    JvBrowseForFolderDialog1: TJvBrowseForFolderDialog;
    JvCreateProcess1: TJvCreateProcess;
    Timer1: TTimer;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    Button5: TButton;
    Label4: TLabel;
    Memo2: TMemo;
    JvDriveCombo1: TJvDriveCombo;
    Label5: TLabel;
    SpeedButton2: TSpeedButton;
    JvCreateProcess2: TJvCreateProcess;
    CheckBox6: TCheckBox;
    ListBox1: TListBox;
    SpeedButton3: TSpeedButton;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JvSpinEdit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure JvCreateProcess1RawRead(Sender: TObject; const S: String);
    procedure Button4Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure JvDriveCombo1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure JvCreateProcess2Terminate(Sender: TObject;
      ExitCode: Cardinal);
    procedure CheckBox6Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure OpenVideoFile(Sender: TObject);
    procedure OpenAudio1File(Sender: TObject);
    procedure OpenAudio2File(Sender: TObject);
    procedure OpenAudio3File(Sender: TObject);
    procedure OpenAudio4File(Sender: TObject);
    procedure WmAfterShow(var Msg: TMessage); message WM_AFTER_SHOW;
  public
    { Public-Deklarationen }
    procedure Start(Sender: TObject);
    procedure NeroPfadSetup(Sender: TObject);
    procedure NeroSuche(Sender: TObject);
    procedure DVD_Menue_Einstellung(Sender: TObject);
    procedure AktualisiereDVDSprache;
  end;

  procedure CreateDVD(Path: String; ISOImage: Boolean; IFOVOBFileDelete: Boolean; ISOBurn: Boolean; ISOFileDeleteAfterBurn: Boolean; DVDName: String);
  procedure INI_Einstellungen_einlesen;
  procedure INI_Einstellungen_schreiben;
  procedure INI_Einstellungen_schreiben2;
  procedure Kontrollen_sperren;
  procedure Kontrollen_freigeben;
  procedure LOG_schreiben;
  procedure SprachAuswahl;
  function CalculateChapters(TitleSet: Byte): String;
  function CheckTools: Boolean;
  function CreateDVDauthorXML: Boolean;
  function DelDir(dir: string): Boolean;
  function DVDISOBurn(ISOImage: String; DVDDrive:String; DeleteISOafterBurning: Boolean): Boolean;
  function GetDiskSize(drive: Char; var free_size, total_size: Int64): Boolean;
  function GetDriveFormat(sDrive : string):string;
  function GetFileSize(FileName: String): Int64;
  function PrintChapters: String;
  function ResString(ResID: Integer): string;
  function ResString2(ResID: Integer): string;

var
  DVDForm: TDVDForm;
  Start: TDateTime;
  SprachID: Integer;  //0=Deutsch 1000=Englisch
  Abbruch: Boolean;
  TabSheet: array[1..9] of TTabSheet;
  VideoLabel: array[1..9] of TLabel;
  VideoFileNameEdit: array[1..9] of TEdit;
  VideoFileNameOpen: array[1..9] of TSpeedButton;
  VideoFileAspectComboBox: array[1..9] of TComboBox;
  VideoFileAspectLabel: array[1..9] of TLabel;
  VideoFileResolutionLabel1: array[1..9] of TLabel;
  VideoFileResolutionLabel2: array[1..9] of TLabel;
  Audio1Label: array[1..9] of TLabel;
  Audio1FileNameEdit: array[1..9] of TEdit;
  Audio1FileNameOpen: array[1..9] of TSpeedButton;
  Audio1FileFormatComboBox: array[1..9] of TComboBox;
  Audio1FileFormatLabel: array[1..9] of TLabel;
  Audio1FileLanguageComboBox: array[1..9] of TComboBox;
  Audio1FileLanguageLabel: array[1..9] of TLabel;
  Audio2Label: array[1..9] of TLabel;
  Audio2FileNameEdit: array[1..9] of TEdit;
  Audio2FileNameOpen: array[1..9] of TSpeedButton;
  Audio2FileFormatComboBox: array[1..9] of TComboBox;
  Audio2FileFormatLabel: array[1..9] of TLabel;
  Audio2FileLanguageComboBox: array[1..9] of TComboBox;
  Audio2FileLanguageLabel: array[1..9] of TLabel;
  Audio3Label: array[1..9] of TLabel;
  Audio3FileNameEdit: array[1..9] of TEdit;
  Audio3FileNameOpen: array[1..9] of TSpeedButton;
  Audio3FileFormatComboBox: array[1..9] of TComboBox;
  Audio3FileFormatLabel: array[1..9] of TLabel;
  Audio3FileLanguageComboBox: array[1..9] of TComboBox;
  Audio3FileLanguageLabel: array[1..9] of TLabel;
  Audio4Label: array[1..9] of TLabel;
  Audio4FileNameEdit: array[1..9] of TEdit;
  Audio4FileNameOpen: array[1..9] of TSpeedButton;
  Audio4FileFormatComboBox: array[1..9] of TComboBox;
  Audio4FileFormatLabel: array[1..9] of TLabel;
  Audio4FileLanguageComboBox: array[1..9] of TComboBox;
  Audio4FileLanguageLabel: array[1..9] of TLabel;
  MediaFileDuration: array[1..9] of Int64;
  Nero_Path: String;
  Nero_ExitCode: Cardinal;
  DVDDrive: String;
  M2SDateien: TStringList;
  Letzter_Ordner: String;

implementation

uses Hauptfenster, ProjectX;

{$R *.dfm}

function CheckTools: Boolean;
//überprüfen, ob externe Tools vorhanden
var
  Buffer: String;

begin
  //jede benötigte Datei auf Existenz prüfen
  Buffer:='';
  if FileExists(ExtractFilePath(Application.ExeName)+'dvdauthor.exe')=false then
    Buffer:=Buffer+'DVDAUTHOR.EXE'+#13+#10;
  if FileExists(ExtractFilePath(Application.ExeName)+'mkisofs.exe')=false then
    Buffer:=Buffer+'MKISOFS.EXE'+#13+#10;
  if FileExists(ExtractFilePath(Application.ExeName)+'mplex.exe')=false then
    Buffer:=Buffer+'MPLEX.EXE'+#13+#10;
  if FileExists(ExtractFilePath(Application.ExeName)+'tcmplex-panteltje.exe')=false then
    Buffer:=Buffer+'TCMPLEX-PANTELTJE.EXE'+#13+#10;
  if FileExists(ExtractFilePath(Application.ExeName)+'MediaInfo.dll')=false then
    Buffer:=Buffer+'MEDIAINFO.DLL'+#13+#10;

  //Fehlermeldung anzeigen
  if Buffer<>'' then
    begin
      ShowMessage(ResString(73)+#13+#10+#13+#10+Buffer);
      result:=false;
    end
  else
    result:=true;
end;

function CalculateChapters(TitleSet: Byte): String;
//automatische Kapitel Berechnung für DVDauthor.xml
var
  Kapiteldauer: Extended;
  Kapitel: Byte;
  Kapitelliste: String;
  ZeitMarke: TDateTime;

begin
  //Wenn keine Spieldauer bekannt ist dann abbrechen
  if MediaFileDuration[TitleSet]<=0 then
    begin
      Result:='';
      exit;
    end;

  //Kapiteldauer berechnen und abbrechen, wenn Kapitel zu kurz bzw. 0
  Kapiteldauer:=trunc(MediaFileDuration[TitleSet]/DVDForm.JvSpinEdit1.Value/1000);
  if Kapiteldauer<=0 then
    begin
      Result:='';
      exit;
    end;

  //Kapitelliste zusammenstellen
  Kapitelliste:='00:00:00.000';
  ZeitMarke:=0;
  for Kapitel:=1 to StrToInt(DVDForm.JvSpinEdit1.Text)-1 do
    begin
      ZeitMarke:=IncSecond(ZeitMarke, trunc(Kapiteldauer));
      Kapitelliste:=Kapitelliste+','+TimeToStr(ZeitMarke)+'.000'
    end;
  Result:=Kapitelliste;
end;

function PrintChapters: String;
//manuelle Kapitel für DVDauthor.xml zusammenstellen(nur TitleSet 1)
var
  Counter: Integer;

begin
  Result:='';
  for Counter:=0 to DVDForm.ListBox1.Items.Count-1 do
    begin
      Result:=Result+DVDForm.ListBox1.Items[Counter];
      if Counter<DVDForm.ListBox1.Items.Count-1 then
        Result:=Result+',';
    end;
end;

function CreateDVDauthorXML: Boolean;
//dvdauthor.xml erzeugen
var
  XML: TStringList;
  Counter: Byte;
  Buffer: String;
  Chapters: String;

begin
  //XML Datei für dvdauthor mit den Werten der TitleSets erzeugen
  XML:=TStringList.Create;
  XML.Add('<dvdauthor>');
  XML.Add(' <vmgm />');
  for Counter:=1 to 9 do
    begin
      if FileExists(VideoFileNameEdit[Counter].Text)=true then
        begin
          //Header
          XML.Add(' <titleset>');
          XML.Add('   <titles>');

          //Video
          if (VideoFileAspectComboBox[Counter].Text<>'') and (VideoFileResolutionLabel1[Counter].Caption<>'') then
            XML.Add('   <video format="pal" aspect="'+VideoFileAspectComboBox[Counter].Text+'" resolution="'+VideoFileResolutionLabel1[Counter].Caption+'"/>');
          if (VideoFileAspectComboBox[Counter].Text<>'') and (VideoFileResolutionLabel1[Counter].Caption='') then
            XML.Add('   <video format="pal" aspect="'+VideoFileAspectComboBox[Counter].Text+'"/>');
          if (VideoFileAspectComboBox[Counter].Text='') and (VideoFileResolutionLabel1[Counter].Caption='') then
            XML.Add('   <video format="pal"/>');

          //Audio 1
          if FileExists(Audio1FileNameEdit[Counter].Text)=true then
            begin
              if (Audio1FileFormatComboBox[Counter].Text<>'') and (Audio1FileLanguageComboBox[Counter].Text<>'') then
                XML.Add('   <audio format="'+LowerCase(Audio1FileFormatComboBox[Counter].Text)+'" lang="'+LowerCase(Audio1FileLanguageComboBox[Counter].Text)+'"/>');
              if (Audio1FileFormatComboBox[Counter].Text<>'') and (Audio1FileLanguageComboBox[Counter].Text='') then
                XML.Add('   <audio format="'+LowerCase(Audio1FileFormatComboBox[Counter].Text)+'"/>');
            end;

          //Audio 2
          if FileExists(Audio2FileNameEdit[Counter].Text)=true then
            begin
              if (Audio2FileFormatComboBox[Counter].Text<>'') and (Audio2FileLanguageComboBox[Counter].Text<>'') then
                XML.Add('   <audio format="'+LowerCase(Audio2FileFormatComboBox[Counter].Text)+'" lang="'+LowerCase(Audio2FileLanguageComboBox[Counter].Text)+'"/>');
              if (Audio2FileFormatComboBox[Counter].Text<>'') and (Audio2FileLanguageComboBox[Counter].Text='') then
                XML.Add('   <audio format="'+LowerCase(Audio2FileFormatComboBox[Counter].Text)+'"/>');
            end;

          //Audio 3
          if FileExists(Audio3FileNameEdit[Counter].Text)=true then
            begin
              if (Audio3FileFormatComboBox[Counter].Text<>'') and (Audio3FileLanguageComboBox[Counter].Text<>'') then
                XML.Add('   <audio format="'+LowerCase(Audio3FileFormatComboBox[Counter].Text)+'" lang="'+LowerCase(Audio3FileLanguageComboBox[Counter].Text)+'"/>');
              if (Audio3FileFormatComboBox[Counter].Text<>'') and (Audio3FileLanguageComboBox[Counter].Text='') then
                XML.Add('   <audio format="'+LowerCase(Audio3FileFormatComboBox[Counter].Text)+'"/>');
            end;
            
          //Audio 4
          if FileExists(Audio4FileNameEdit[Counter].Text)=true then
            begin
              if (Audio4FileFormatComboBox[Counter].Text<>'') and (Audio4FileLanguageComboBox[Counter].Text<>'') then
                XML.Add('   <audio format="'+LowerCase(Audio4FileFormatComboBox[Counter].Text)+'" lang="'+LowerCase(Audio4FileLanguageComboBox[Counter].Text)+'"/>');
              if (Audio4FileFormatComboBox[Counter].Text<>'') and (Audio4FileLanguageComboBox[Counter].Text='') then
                XML.Add('   <audio format="'+LowerCase(Audio4FileFormatComboBox[Counter].Text)+'"/>');
            end;

          //MPEG/VOB Vorlage mit Kapitel Auswertung
          XML.Add('     <pgc>');
          if (AnsiRightStr(DVDForm.Edit2.Text,1)='\') or (AnsiRightStr(DVDForm.Edit2.Text,1)='/') then
            Buffer:='       <vob file="'+DVDForm.Edit2.Text+'temp'+IntToStr(Counter)+'.vob"'
          else
            Buffer:='       <vob file="'+DVDForm.Edit2.Text+'\temp'+IntToStr(Counter)+'.vob"';
          if (DVDForm.CheckBox3.Checked) then
            begin
              Chapters:=CalculateChapters(Counter);
              if Chapters<>'' then
                Buffer:=Buffer+' chapters="'+Chapters+'"/>'
              else
                begin
                  //Warnhinweis wenn keine automatischen Kapitel generiert werden
                  DVDForm.Memo2.Lines.Add('TitleSet '+IntToStr(Counter));
                  DVDForm.Memo2.Lines.Add(ResString(10127));
                end
            end
          else if (DVDForm.CheckBox6.Checked) then
            Buffer:=Buffer+' chapters="'+PrintChapters+'"/>'
          else
            Buffer:=Buffer+'/>';
          XML.Add(Buffer);
          XML.Add('     </pgc>');

          //Footer
          XML.Add('   </titles>');
          XML.Add(' </titleset>');
        end;
    end;
  XML.Add('</dvdauthor>');
  XML.SaveToFile(ExtractFilePath(Application.ExeName)+'/DVDauthor.xml');
  XML.Free;
  Result:=true;
end;

procedure Kontrollen_sperren;
//Bedienung sperren
begin
  DVDForm.Panel1.Enabled:=false;
  DVDForm.Button1.Enabled:=false;
  DVDForm.Button2.Enabled:=false;
  DVDForm.Button3.Enabled:=false;
  DVDForm.Button4.Enabled:=false;
  DVDForm.Edit1.Enabled:=false;
  DVDForm.Edit2.Enabled:=false;
  DVDForm.SpeedButton1.Enabled:=false;
  DVDForm.SpeedButton2.Enabled:=false;
  DVDForm.SpeedButton3.Enabled:=false;
  DVDForm.JvSpinEdit1.Enabled:=false;
  DVDForm.ComboBox1.Enabled:=false;
  DVDForm.JvDriveCombo1.Enabled:=false;
  DVDForm.CheckBox1.Enabled:=false;
  DVDForm.CheckBox2.Enabled:=false;
  DVDForm.CheckBox3.Enabled:=false;
  DVDForm.CheckBox4.Enabled:=false;
  DVDForm.CheckBox5.Enabled:=false;
  DVDForm.CheckBox6.Enabled:=false;
  DVDForm.Label1.Enabled:=false;
  DVDForm.Label2.Enabled:=false;
  DVDForm.Label3.Enabled:=false;
  DVDForm.Label4.Enabled:=false;
  DVDForm.Label5.Enabled:=false;
  DVDForm.Label6.Enabled:=false;
  Application.ProcessMessages;
end;

procedure Kontrollen_freigeben;
//Bedienung freigeben
begin
  DVDForm.Panel1.Enabled:=true;
  if DVDForm.PageControl1.PageCount<9 then
    DVDForm.Button1.Enabled:=true;
  if DVDForm.PageControl1.PageCount>1 then
    DVDForm.Button2.Enabled:=true;
  DVDForm.Button3.Enabled:=true;
  DVDForm.Button4.Enabled:=true;
  DVDForm.Edit1.Enabled:=DVDForm.CheckBox1.Checked;
  DVDForm.Edit2.Enabled:=true;
  DVDForm.SpeedButton1.Enabled:=true;
  DVDForm.SpeedButton2.Enabled:=true;
  DVDForm.JvSpinEdit1.Enabled:=DVDForm.CheckBox3.Checked;
  DVDForm.ComboBox1.Enabled:=true;
  DVDForm.JvDriveCombo1.Enabled:=true;
  DVDForm.CheckBox1.Enabled:=true;
  DVDForm.CheckBox3.Enabled:=true;
  DVDForm.CheckBox6.Enabled:=true;
  if DVDForm.CheckBox1.Checked=true then
    begin
      DVDForm.CheckBox2.Enabled:=true;
      DVDForm.CheckBox4.Enabled:=true;
    end;
  if DVDForm.CheckBox4.Checked=true then
    DVDForm.CheckBox5.Enabled:=true;
  if DVDForm.CheckBox6.Checked=false then
    begin
      DVDForm.SpeedButton3.Enabled:=false;
      DVDForm.ListBox1.Enabled:=false;
    end
  else
    begin
      DVDForm.SpeedButton3.Enabled:=true;
      DVDForm.ListBox1.Enabled:=true;
    end;
  DVDForm.Label1.Enabled:=true;
  if DVDForm.CheckBox3.Checked=true then
    DVDForm.Label2.Enabled:=true;
  DVDForm.Label3.Enabled:=true;
  DVDForm.Label4.Enabled:=true;
  DVDForm.Label5.Enabled:=true;
  if DVDForm.CheckBox6.Checked=true then
    DVDForm.Label6.Enabled:=true;
  Application.ProcessMessages;    
end;

procedure TDVDForm.OpenVideoFile(Sender: TObject);
//Video Datei öffnen
var
  Buffer: String;

begin
  Kontrollen_sperren;
  OpenDialog1.Title:=ResString(105);
  OpenDialog1.Filter:=ResString(106);
  if VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text<>'' then
    begin
      if Letzter_Ordner<>'' then
        OpenDialog1.InitialDir:=Letzter_Ordner
      else
        OpenDialog1.InitialDir:=ExtractFilePath(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text);
    end;
  if OpenDialog1.Execute=true then
    begin
      VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text:=OpenDialog1.FileName;
      VideoFileNameEdit[(Sender as TSpeedButton).Tag].Hint:=VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text;
      VideoFileNameEdit[(Sender as TSpeedButton).Tag].ShowHint:=true;
      VideoFileNameEdit[(Sender as TSpeedButton).Tag].SelStart:=Length(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text);
      OpenDialog1.FileName:='';
      try
      Application.ProcessMessages;
      Buffer:=MediaInfoFileVideoAspect(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text);
      except
      Buffer:='';
      end;
      if ((Buffer='16/9') or (Buffer='16:9')) then
        VideoFileAspectComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=2
      else if ((Buffer='4/3') or (Buffer='4:3')) then
        VideoFileAspectComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=1
      else
        VideoFileAspectComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=0;
      Application.ProcessMessages;
      try
      Buffer:=IntToStr(MediaInfoFileVideoWidth(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text));
      except
      Buffer:='';
      end;
      if Buffer<>'' then
        VideoFileResolutionLabel1[(Sender as TSpeedButton).Tag].Caption:=Buffer;
      Buffer:=IntToStr(MediaInfoFileVideoHeight(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text));
      if Buffer<>'' then
        VideoFileResolutionLabel1[(Sender as TSpeedButton).Tag].Caption:=VideoFileResolutionLabel1[(Sender as TSpeedButton).Tag].Caption+'x'+Buffer
      else
        VideoFileResolutionLabel1[(Sender as TSpeedButton).Tag].Caption:='';

      //Filmdauer auswerten
      Application.ProcessMessages;
      try
      MediaFileDuration[(Sender as TSpeedButton).Tag]:=MediaInfo.MediaInfoFilePlayTime(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text);
      except
      MediaFileDuration[(Sender as TSpeedButton).Tag]:=0;
      end;

      //Name aus erstem TitleSet übernehmen
      if (Sender as TSpeedButton).Tag=1 then
        begin
          Buffer:=ExtractFileName(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text);
          Buffer:=ChangeFileExt(Buffer,'');
          if Pos('_',Buffer)>0 then
            Buffer:=AnsiRightStr(Buffer,Length(Buffer)-17);
          if Length(Buffer)>15 then
            Buffer:=AnsiLeftStr(Buffer,15);
          if Pos('(',Buffer)>0 then
            Buffer:=AnsiLeftStr(Buffer,Pos('(',Buffer)-1);
          Buffer:=StringReplace(Buffer,'_',' ',[rfReplaceAll, rfIgnoreCase]);
          Edit1.Text:=Trim(Buffer);
        end;
    end;
  Kontrollen_freigeben;
end;

procedure TDVDForm.OpenAudio1File(Sender: TObject);
//Audio Datei 1 öffnen
var
  Buffer: String;

begin
  Kontrollen_sperren;
  OpenDialog1.Title:=ResString(108);
  OpenDialog1.Filter:=ResString(107);
  if VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text<>'' then
    OpenDialog1.InitialDir:=ExtractFilePath(VideoFileNameEdit[(Sender as TSpeedButton).Tag].Text);
  if OpenDialog1.Execute=true then
    begin
      Audio1FileNameEdit[(Sender as TSpeedButton).Tag].Text:=OpenDialog1.FileName;
      Audio1FileNameEdit[(Sender as TSpeedButton).Tag].Hint:=Audio1FileNameEdit[(Sender as TSpeedButton).Tag].Text;
      Audio1FileNameEdit[(Sender as TSpeedButton).Tag].ShowHint:=true;
      Audio1FileNameEdit[(Sender as TSpeedButton).Tag].SelStart:=Length(Audio1FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      OpenDialog1.FileName:='';
      try
      Application.ProcessMessages;
      Buffer:=MediaInfoFileCodec(Audio1FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      except
      Buffer:='';
      end;
      if ((Buffer='AC3') or (Buffer='AC-3')) then
        Audio1FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=2
      else if ((Buffer='MPEG-1 Audio') or (Buffer='MPA1L2') or (Buffer='MPEG Audio')) then
        Audio1FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=1
      else
        Audio1FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=0;
    end;
  Kontrollen_freigeben;
end;

procedure TDVDForm.OpenAudio2File(Sender: TObject);
//Audio Datei 2 öffnen
var
  Buffer: String;

begin
  Kontrollen_sperren;
  OpenDialog1.Title:=ResString(109);
  OpenDialog1.Filter:=ResString(107);
  if Audio1FileNameEdit[(Sender as TSpeedButton).Tag].Text<>'' then
    OpenDialog1.InitialDir:=ExtractFilePath(Audio1FileNameEdit[(Sender as TSpeedButton).Tag].Text);
  //else
  //  OpenDialog1.InitialDir:=Form1.JvDirectoryListBox2.Directory;
  if OpenDialog1.Execute=true then
    begin
      Audio2FileNameEdit[(Sender as TSpeedButton).Tag].Text:=OpenDialog1.FileName;
      Audio2FileNameEdit[(Sender as TSpeedButton).Tag].Hint:=Audio2FileNameEdit[(Sender as TSpeedButton).Tag].Text;
      Audio2FileNameEdit[(Sender as TSpeedButton).Tag].ShowHint:=true;
      Audio2FileNameEdit[(Sender as TSpeedButton).Tag].SelStart:=Length(Audio2FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      OpenDialog1.FileName:='';
      try
      Application.ProcessMessages;
      Buffer:=MediaInfoFileCodec(Audio2FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      except
      Buffer:='';
      end;
      if ((Buffer='AC3') or (Buffer='AC-3')) then
        Audio2FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=2
      else if ((Buffer='MPEG-1 Audio') or (Buffer='MPA1L2') or (Buffer='MPEG Audio')) then
        Audio2FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=1
      else
        Audio2FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=0;
    end;
  Kontrollen_freigeben;
end;

procedure TDVDForm.OpenAudio3File(Sender: TObject);
//Audio Datei 3 öffnen
var
  Buffer: String;

begin
  Kontrollen_sperren;
  OpenDialog1.Title:=ResString(110);
  OpenDialog1.Filter:=ResString(107);
  if Audio2FileNameEdit[(Sender as TSpeedButton).Tag].Text<>'' then
    OpenDialog1.InitialDir:=ExtractFilePath(Audio2FileNameEdit[(Sender as TSpeedButton).Tag].Text);
  //else
  //  OpenDialog1.InitialDir:=Form1.JvDirectoryListBox2.Directory;
  if OpenDialog1.Execute=true then
    begin
      Audio3FileNameEdit[(Sender as TSpeedButton).Tag].Text:=OpenDialog1.FileName;
      Audio3FileNameEdit[(Sender as TSpeedButton).Tag].Hint:=Audio3FileNameEdit[(Sender as TSpeedButton).Tag].Text;
      Audio3FileNameEdit[(Sender as TSpeedButton).Tag].ShowHint:=true;
      Audio3FileNameEdit[(Sender as TSpeedButton).Tag].SelStart:=Length(Audio3FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      OpenDialog1.FileName:='';
      try
      Application.ProcessMessages;
      Buffer:=MediaInfoFileCodec(Audio3FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      except
      Buffer:='';
      end;
      if ((Buffer='AC3') or (Buffer='AC-3')) then
        Audio3FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=2
      else if ((Buffer='MPEG-1 Audio') or (Buffer='MPA1L2') or (Buffer='MPEG Audio')) then
        Audio3FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=1
      else
        Audio3FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=0;
    end;
  Kontrollen_freigeben;
end;

procedure TDVDForm.OpenAudio4File(Sender: TObject);
//Audio Datei 4 öffnen
var
  Buffer: String;

begin
  Kontrollen_sperren;
  OpenDialog1.Title:=ResString(111);
  OpenDialog1.Filter:=ResString(107);
  if Audio3FileNameEdit[(Sender as TSpeedButton).Tag].Text<>'' then
    OpenDialog1.InitialDir:=ExtractFilePath(Audio3FileNameEdit[(Sender as TSpeedButton).Tag].Text);
  //else
  //  OpenDialog1.InitialDir:=Form1.JvDirectoryListBox2.Directory;
  if OpenDialog1.Execute=true then
    begin
      Audio4FileNameEdit[(Sender as TSpeedButton).Tag].Text:=OpenDialog1.FileName;
      Audio4FileNameEdit[(Sender as TSpeedButton).Tag].Hint:=Audio4FileNameEdit[(Sender as TSpeedButton).Tag].Text;
      Audio4FileNameEdit[(Sender as TSpeedButton).Tag].ShowHint:=true;
      Audio4FileNameEdit[(Sender as TSpeedButton).Tag].SelStart:=Length(Audio4FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      OpenDialog1.FileName:='';
      try
      Application.ProcessMessages;
      Buffer:=MediaInfoFileCodec(Audio4FileNameEdit[(Sender as TSpeedButton).Tag].Text);
      except
      Buffer:='';
      end;
      if ((Buffer='AC3') or (Buffer='AC-3')) then
        Audio4FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=2
      else if ((Buffer='MPEG-1 Audio') or (Buffer='MPA1L2') or (Buffer='MPEG Audio')) then
        Audio4FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=1
      else
        Audio4FileFormatComboBox[(Sender as TSpeedButton).Tag].ItemIndex:=0;
    end;
  Kontrollen_freigeben;
end;

procedure AddTitleSet;
//bis zu 9 TitleSet Tabsheets dynamisch erzeugen
var
  PageCount: Integer;

begin
  //Anzahl der TabSheets auswerten
  PageCount:=DVDForm.PageControl1.PageCount;
  if PageCount=9 then
    begin
      ShowMessage(ResString(47));
      exit;
    end;
  inc(PageCount);

  //TabSheets erzeugen
  TabSheet[PageCount]:=TTabSheet.Create(DVDForm);
  TabSheet[PageCount].Parent:=DVDForm.PageControl1;
  TabSheet[PageCount].PageControl:=DVDForm.PageControl1;
  TabSheet[PageCount].PageIndex:=PageCount-1;
  TabSheet[PageCount].Caption:='TitleSet '+IntToStr(PageCount);
  TabSheet[PageCount].DoubleBuffered:=true;
  TabSheet[PageCount].Font.Name:='Tahoma';

  //Seite vor Erstellung anwählen und ausblenden
  DVDForm.PageControl1.ActivePageIndex:=PageCount-1;
  DVDForm.PageControl1.Pages[PageCount-1].Visible:=false;

  //Video Hinweislabel
  VideoLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  VideoLabel[PageCount].Parent:=TabSheet[PageCount];
  VideoLabel[PageCount].Caption:=ResString(48);
  VideoLabel[PageCount].Top:=DVDForm.PageControl1.Top+5;
  VideoLabel[PageCount].Left:=DVDForm.PageControl1.Left+5;
  VideoLabel[PageCount].Font.Name:='Tahoma';

  //Video Datei Name Eingabefeld
  VideoFileNameEdit[PageCount]:=TEdit.Create(DVDForm.PageControl1);
  VideoFileNameEdit[PageCount].Parent:=TabSheet[PageCount];
  VideoFileNameEdit[PageCount].Top:=VideoLabel[PageCount].Top+VideoLabel[PageCount].Height+5;
  VideoFileNameEdit[PageCount].Left:=DVDForm.PageControl1.Left+5;
  VideoFileNameEdit[PageCount].Width:=TabSheet[PageCount].Width-170;
  VideoFileNameEdit[PageCount].Font.Name:='Tahoma';

  //Video Datei öffnen Dialog Button
  VideoFileNameOpen[PageCount]:=TSpeedButton.Create(DVDForm.PageControl1);
  VideoFileNameOpen[PageCount].Parent:=TabSheet[PageCount];
  VideoFileNameOpen[PageCount].Glyph:=DVDForm.SpeedButton1.Glyph;
  VideoFileNameOpen[PageCount].Height:=DVDForm.SpeedButton1.Height;
  VideoFileNameOpen[PageCount].Width:=DVDForm.SpeedButton1.Width;
  VideoFileNameOpen[PageCount].Top:=VideoFileNameEdit[PageCount].Top;
  VideoFileNameOpen[PageCount].Left:=VideoFileNameEdit[PageCount].Left+VideoFileNameEdit[PageCount].Width+5;
  VideoFileNameOpen[PageCount].Tag:=PageCount;
  VideoFileNameOpen[PageCount].OnClick:=DVDForm.OpenVideoFile;

  //Video AspectRatio ComboBox
  VideoFileAspectComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  VideoFileAspectComboBox[PageCount].Parent:=TabSheet[PageCount];
  VideoFileAspectComboBox[PageCount].Height:=VideoFileNameOpen[PageCount].Height;
  VideoFileAspectComboBox[PageCount].Width:=55;
  VideoFileAspectComboBox[PageCount].Top:=VideoFileNameEdit[PageCount].Top;
  VideoFileAspectComboBox[PageCount].Left:=VideoFileNameOpen[PageCount].Left+VideoFileNameOpen[PageCount].Width+5;
  VideoFileAspectComboBox[PageCount].Items.Add('');
  VideoFileAspectComboBox[PageCount].Items.Add('4:3');
  VideoFileAspectComboBox[PageCount].Items.Add('16:9');
  VideoFileAspectComboBox[PageCount].ItemIndex:=0;
  VideoFileAspectComboBox[PageCount].Style:=csDropDownList;
  VideoFileAspectComboBox[PageCount].Font.Name:='Tahoma';

  //Video AspectRatio Hinweislabel
  VideoFileAspectLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  VideoFileAspectLabel[PageCount].Parent:=TabSheet[PageCount];
  VideoFileAspectLabel[PageCount].Caption:=ResString(49);
  VideoFileAspectLabel[PageCount].Top:=VideoLabel[PageCount].Top;
  VideoFileAspectLabel[PageCount].Left:=VideoFileAspectComboBox[PageCount].Left;
  VideoFileAspectLabel[PageCount].Font.Name:='Tahoma';

  //Video Auflösung
  VideoFileResolutionLabel1[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  VideoFileResolutionLabel1[PageCount].Parent:=TabSheet[PageCount];
  VideoFileResolutionLabel1[PageCount].AutoSize:=false;
  VideoFileResolutionLabel1[PageCount].Caption:='';
  VideoFileResolutionLabel1[PageCount].Top:=VideoFileAspectComboBox[PageCount].Top+4;
  VideoFileResolutionLabel1[PageCount].Left:=VideoFileAspectComboBox[PageCount].Left+VideoFileAspectComboBox[PageCount].Width+5;
  VideoFileResolutionLabel1[PageCount].Width:=VideoFileAspectComboBox[PageCount].Width;
  VideoFileResolutionLabel1[PageCount].Alignment:=taCenter;
  VideoFileResolutionLabel1[PageCount].Font.Name:='Tahoma';

  //Video Auflösung Hinweislabel
  VideoFileResolutionLabel2[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  VideoFileResolutionLabel2[PageCount].Parent:=TabSheet[PageCount];
  VideoFileResolutionLabel2[PageCount].Caption:=ResString(50);
  VideoFileResolutionLabel2[PageCount].Top:=VideoFileAspectLabel[PageCount].Top;
  VideoFileResolutionLabel2[PageCount].Left:=VideoFileResolutionLabel1[PageCount].Left;
  VideoFileResolutionLabel2[PageCount].Font.Name:='Tahoma';

  //Audio 1 Hinweislabel
  Audio1Label[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio1Label[PageCount].Parent:=TabSheet[PageCount];
  Audio1Label[PageCount].Caption:=ResString(53);
  Audio1Label[PageCount].Top:=VideoFileNameEdit[PageCount].Top+VideoFileNameEdit[PageCount].Height+7;
  Audio1Label[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio1Label[PageCount].Font.Name:='Tahoma';

  //Audio 1 Datei Name Eingabefeld
  Audio1FileNameEdit[PageCount]:=TEdit.Create(DVDForm.PageControl1);
  Audio1FileNameEdit[PageCount].Parent:=TabSheet[PageCount];
  Audio1FileNameEdit[PageCount].Top:=Audio1Label[PageCount].Top+Audio1Label[PageCount].Height+5;
  Audio1FileNameEdit[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio1FileNameEdit[PageCount].Width:=TabSheet[PageCount].Width-170;
  Audio1FileNameEdit[PageCount].Font.Name:='Tahoma';

  //Audio 1 Datei öffnen Dialog Button
  Audio1FileNameOpen[PageCount]:=TSpeedButton.Create(DVDForm.PageControl1);
  Audio1FileNameOpen[PageCount].Parent:=TabSheet[PageCount];
  Audio1FileNameOpen[PageCount].Glyph:=DVDForm.SpeedButton1.Glyph;
  Audio1FileNameOpen[PageCount].Height:=DVDForm.SpeedButton1.Height;
  Audio1FileNameOpen[PageCount].Width:=DVDForm.SpeedButton1.Width;
  Audio1FileNameOpen[PageCount].Top:=Audio1FileNameEdit[PageCount].Top;
  Audio1FileNameOpen[PageCount].Left:=Audio1FileNameEdit[PageCount].Left+Audio1FileNameEdit[PageCount].Width+5;
  Audio1FileNameOpen[PageCount].Tag:=PageCount;
  Audio1FileNameOpen[PageCount].OnClick:=DVDForm.OpenAudio1File;

  //Audio 1 Format ComboBox
  Audio1FileFormatComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio1FileFormatComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio1FileFormatComboBox[PageCount].Height:=Audio1FileNameOpen[PageCount].Height;
  Audio1FileFormatComboBox[PageCount].Width:=55;
  Audio1FileFormatComboBox[PageCount].Top:=Audio1FileNameEdit[PageCount].Top;
  Audio1FileFormatComboBox[PageCount].Left:=Audio1FileNameOpen[PageCount].Left+Audio1FileNameOpen[PageCount].Width+5;
  Audio1FileFormatComboBox[PageCount].Items.Add('');
  Audio1FileFormatComboBox[PageCount].Items.Add('MP2');
  Audio1FileFormatComboBox[PageCount].Items.Add('AC3');
  Audio1FileFormatComboBox[PageCount].ItemIndex:=0;
  Audio1FileFormatComboBox[PageCount].Style:=csDropDownList;
  Audio1FileFormatComboBox[PageCount].Font.Name:='Tahoma';

  //Audio 1 Format Hinweislabel
  Audio1FileFormatLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio1FileFormatLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio1FileFormatLabel[PageCount].Caption:=ResString(51);
  Audio1FileFormatLabel[PageCount].Top:=Audio1Label[PageCount].Top;
  Audio1FileFormatLabel[PageCount].Left:=Audio1FileFormatComboBox[PageCount].Left;
  Audio1FileFormatLabel[PageCount].Font.Name:='Tahoma';

  //Audio 1 Sprach ComboBox
  Audio1FileLanguageComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio1FileLanguageComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio1FileLanguageComboBox[PageCount].Height:=Audio1FileNameOpen[PageCount].Height;
  Audio1FileLanguageComboBox[PageCount].Width:=55;
  Audio1FileLanguageComboBox[PageCount].Top:=Audio1FileNameEdit[PageCount].Top;
  Audio1FileLanguageComboBox[PageCount].Left:=Audio1FileFormatComboBox[PageCount].Left+Audio1FileFormatComboBox[PageCount].Width+5;
  //Sprachkennungen für die DVD Audiosprachen
  //'"","DE","EN","FR","IT","AB","OM","AA","AF","SQ","AM","AR","HY","AS","AY","AZ","BA","EU","DZ","BH","BI","BR","BG","MY","BE","KM","CA","ZH","CO","HR","CS","DA","NL","EO","ET","FO","FJ","FI","FY","GL","KA","EL","KL","GN","GU","HA","IW","HI","HU","IS","IN","IA","IE","IK","GA","JA","JV","KN","KS","KK","RW","KY","RN","KO","KU","LO","LA","LN","LT","MK","MG","MS","ML","MT","MI","MR","MO","MN","NA","NE","NO","OC","OR","FA","PL","PT","PA","QU","RM","RO","RU","SM","SG","SA","SR","SH","ST","TN","SN","SD","SI","SS","SK","SL","SO","ES","SU","SW","SV","TL","TG","TA","TT","TE","TH","BO","TI","TO","TS","TR","TK","TW","UK","UR","UZ","VI","VO","CY","WO","XH","JI","YO","ZU"';
  Audio1FileLanguageComboBox[PageCount].Items.CommaText:='"","DE","EN","FR","IT","ES","NL","RU","TR"';
  Audio1FileLanguageComboBox[PageCount].ItemIndex:=0;
  Audio1FileLanguageComboBox[PageCount].Style:=csDropDownList;
  Audio1FileLanguageComboBox[PageCount].Font.Name:='Tahoma';

  //Audio 1 Sprachen Hinweislabel
  Audio1FileLanguageLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio1FileLanguageLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio1FileLanguageLabel[PageCount].Caption:=ResString(52);
  Audio1FileLanguageLabel[PageCount].Top:=Audio1Label[PageCount].Top;
  Audio1FileLanguageLabel[PageCount].Left:=Audio1FileLanguageComboBox[PageCount].Left;
  Audio1FileLanguageLabel[PageCount].Font.Name:='Tahoma';

  //Audio 2 Hinweislabel
  Audio2Label[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio2Label[PageCount].Parent:=TabSheet[PageCount];
  Audio2Label[PageCount].Caption:=ResString(54);
  Audio2Label[PageCount].Top:=Audio1FileNameEdit[PageCount].Top+Audio1FileNameEdit[PageCount].Height+7;
  Audio2Label[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio2Label[PageCount].Font.Name:='Tahoma';

  //Audio 2 Datei Name Eingabefeld
  Audio2FileNameEdit[PageCount]:=TEdit.Create(DVDForm.PageControl1);
  Audio2FileNameEdit[PageCount].Parent:=TabSheet[PageCount];
  Audio2FileNameEdit[PageCount].Top:=Audio2Label[PageCount].Top+Audio2Label[PageCount].Height+5;
  Audio2FileNameEdit[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio2FileNameEdit[PageCount].Width:=TabSheet[PageCount].Width-170;
  Audio2FileNameEdit[PageCount].Font.Name:='Tahoma';

  //Audio 2 Datei öffnen Dialog Button
  Audio2FileNameOpen[PageCount]:=TSpeedButton.Create(DVDForm.PageControl1);
  Audio2FileNameOpen[PageCount].Parent:=TabSheet[PageCount];
  Audio2FileNameOpen[PageCount].Glyph:=DVDForm.SpeedButton1.Glyph;
  Audio2FileNameOpen[PageCount].Height:=DVDForm.SpeedButton1.Height;
  Audio2FileNameOpen[PageCount].Width:=DVDForm.SpeedButton1.Width;
  Audio2FileNameOpen[PageCount].Top:=Audio2FileNameEdit[PageCount].Top;
  Audio2FileNameOpen[PageCount].Left:=Audio2FileNameEdit[PageCount].Left+Audio2FileNameEdit[PageCount].Width+5;
  Audio2FileNameOpen[PageCount].Tag:=PageCount;
  Audio2FileNameOpen[PageCount].OnClick:=DVDForm.OpenAudio2File;
  Audio2FileNameOpen[PageCount].Font.Name:='Tahoma';

  //Audio 2 Format ComboBox
  Audio2FileFormatComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio2FileFormatComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio2FileFormatComboBox[PageCount].Height:=Audio2FileNameOpen[PageCount].Height;
  Audio2FileFormatComboBox[PageCount].Width:=55;
  Audio2FileFormatComboBox[PageCount].Top:=Audio2FileNameEdit[PageCount].Top;
  Audio2FileFormatComboBox[PageCount].Left:=Audio2FileNameOpen[PageCount].Left+Audio2FileNameOpen[PageCount].Width+5;
  Audio2FileFormatComboBox[PageCount].Items.Add('');
  Audio2FileFormatComboBox[PageCount].Items.Add('MP2');
  Audio2FileFormatComboBox[PageCount].Items.Add('AC3');
  Audio2FileFormatComboBox[PageCount].ItemIndex:=0;
  Audio2FileFormatComboBox[PageCount].Style:=csDropDownList;
  Audio2FileFormatComboBox[PageCount].Font.Name:='Tahoma';

  //Audio 2 Format Hinweislabel
  Audio2FileFormatLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio2FileFormatLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio2FileFormatLabel[PageCount].Caption:=ResString(51);
  Audio2FileFormatLabel[PageCount].Top:=Audio2Label[PageCount].Top;
  Audio2FileFormatLabel[PageCount].Left:=Audio2FileFormatComboBox[PageCount].Left;
  Audio2FileFormatLabel[PageCount].Font.Name:='Tahoma';

  //Audio 2 Sprach ComboBox
  Audio2FileLanguageComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio2FileLanguageComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio2FileLanguageComboBox[PageCount].Height:=Audio2FileNameOpen[PageCount].Height;
  Audio2FileLanguageComboBox[PageCount].Width:=55;
  Audio2FileLanguageComboBox[PageCount].Top:=Audio2FileNameEdit[PageCount].Top;
  Audio2FileLanguageComboBox[PageCount].Left:=Audio2FileFormatComboBox[PageCount].Left+Audio2FileFormatComboBox[PageCount].Width+5;
  Audio2FileLanguageComboBox[PageCount].Items:=Audio1FileLanguageComboBox[PageCount].Items;
  Audio2FileLanguageComboBox[PageCount].ItemIndex:=0;
  Audio2FileLanguageComboBox[PageCount].Style:=csDropDownList;
  Audio2FileLanguageComboBox[PageCount].Font.Name:='Tahoma';

  //Audio 2 Sprachen Hinweislabel
  Audio2FileLanguageLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio2FileLanguageLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio2FileLanguageLabel[PageCount].Caption:=ResString(52);
  Audio2FileLanguageLabel[PageCount].Top:=Audio2Label[PageCount].Top;
  Audio2FileLanguageLabel[PageCount].Left:=Audio2FileLanguageComboBox[PageCount].Left;
  Audio2FileLanguageLabel[PageCount].Font.Name:='Tahoma';

  //Audio 3 Hinweislabel
  Audio3Label[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio3Label[PageCount].Parent:=TabSheet[PageCount];
  Audio3Label[PageCount].Caption:=ResString(55);
  Audio3Label[PageCount].Top:=Audio2FileNameEdit[PageCount].Top+Audio2FileNameEdit[PageCount].Height+7;
  Audio3Label[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio3Label[PageCount].Font.Name:='Tahoma';

  //Audio 3 Datei Name Eingabefeld
  Audio3FileNameEdit[PageCount]:=TEdit.Create(DVDForm.PageControl1);
  Audio3FileNameEdit[PageCount].Parent:=TabSheet[PageCount];
  Audio3FileNameEdit[PageCount].Top:=Audio3Label[PageCount].Top+Audio3Label[PageCount].Height+5;
  Audio3FileNameEdit[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio3FileNameEdit[PageCount].Width:=TabSheet[PageCount].Width-170;
  Audio3FileNameEdit[PageCount].Font.Name:='Tahoma';

  //Audio 3 Datei öffnen Dialog Button
  Audio3FileNameOpen[PageCount]:=TSpeedButton.Create(DVDForm.PageControl1);
  Audio3FileNameOpen[PageCount].Parent:=TabSheet[PageCount];
  Audio3FileNameOpen[PageCount].Glyph:=DVDForm.SpeedButton1.Glyph;
  Audio3FileNameOpen[PageCount].Height:=DVDForm.SpeedButton1.Height;
  Audio3FileNameOpen[PageCount].Width:=DVDForm.SpeedButton1.Width;
  Audio3FileNameOpen[PageCount].Top:=Audio3FileNameEdit[PageCount].Top;
  Audio3FileNameOpen[PageCount].Left:=Audio3FileNameEdit[PageCount].Left+Audio3FileNameEdit[PageCount].Width+5;
  Audio3FileNameOpen[PageCount].Tag:=PageCount;
  Audio3FileNameOpen[PageCount].OnClick:=DVDForm.OpenAudio3File;

  //Audio 3 Format ComboBox
  Audio3FileFormatComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio3FileFormatComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio3FileFormatComboBox[PageCount].Height:=Audio3FileNameOpen[PageCount].Height;
  Audio3FileFormatComboBox[PageCount].Width:=55;
  Audio3FileFormatComboBox[PageCount].Top:=Audio3FileNameEdit[PageCount].Top;
  Audio3FileFormatComboBox[PageCount].Left:=Audio3FileNameOpen[PageCount].Left+Audio3FileNameOpen[PageCount].Width+5;
  Audio3FileFormatComboBox[PageCount].Items.Add('');
  Audio3FileFormatComboBox[PageCount].Items.Add('MP2');
  Audio3FileFormatComboBox[PageCount].Items.Add('AC3');
  Audio3FileFormatComboBox[PageCount].ItemIndex:=0;
  Audio3FileFormatComboBox[PageCount].Style:=csDropDownList;
  Audio3FileNameOpen[PageCount].Font.Name:='Tahoma';

  //Audio 3 Format Hinweislabel
  Audio3FileFormatLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio3FileFormatLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio3FileFormatLabel[PageCount].Caption:=ResString(51);
  Audio3FileFormatLabel[PageCount].Top:=Audio3Label[PageCount].Top;
  Audio3FileFormatLabel[PageCount].Left:=Audio3FileFormatComboBox[PageCount].Left;
  Audio3FileFormatLabel[PageCount].Font.Name:='Tahoma';

  //Audio 3 Sprach ComboBox
  Audio3FileLanguageComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio3FileLanguageComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio3FileLanguageComboBox[PageCount].Height:=Audio3FileNameOpen[PageCount].Height;
  Audio3FileLanguageComboBox[PageCount].Width:=55;
  Audio3FileLanguageComboBox[PageCount].Top:=Audio3FileNameEdit[PageCount].Top;
  Audio3FileLanguageComboBox[PageCount].Left:=Audio3FileFormatComboBox[PageCount].Left+Audio3FileFormatComboBox[PageCount].Width+5;
  Audio3FileLanguageComboBox[PageCount].Items:=Audio1FileLanguageComboBox[PageCount].Items;
  Audio3FileLanguageComboBox[PageCount].ItemIndex:=0;
  Audio3FileLanguageComboBox[PageCount].Style:=csDropDownList;
  Audio3FileLanguageComboBox[PageCount].Font.Name:='Tahoma';

  //Audio 3 Sprachen Hinweislabel
  Audio3FileLanguageLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio3FileLanguageLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio3FileLanguageLabel[PageCount].Caption:=ResString(52);
  Audio3FileLanguageLabel[PageCount].Top:=Audio3Label[PageCount].Top;
  Audio3FileLanguageLabel[PageCount].Left:=Audio3FileLanguageComboBox[PageCount].Left;
  Audio3FileLanguageLabel[PageCount].Font.Name:='Tahoma';

  //Audio 4 Hinweislabel
  Audio4Label[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio4Label[PageCount].Parent:=TabSheet[PageCount];
  Audio4Label[PageCount].Caption:=ResString(56);
  Audio4Label[PageCount].Top:=Audio3FileNameEdit[PageCount].Top+Audio3FileNameEdit[PageCount].Height+7;
  Audio4Label[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio4Label[PageCount].Font.Name:='Tahoma';

  //Audio 4 Datei Name Eingabefeld
  Audio4FileNameEdit[PageCount]:=TEdit.Create(DVDForm.PageControl1);
  Audio4FileNameEdit[PageCount].Parent:=TabSheet[PageCount];
  Audio4FileNameEdit[PageCount].Top:=Audio4Label[PageCount].Top+Audio4Label[PageCount].Height+5;
  Audio4FileNameEdit[PageCount].Left:=DVDForm.PageControl1.Left+5;
  Audio4FileNameEdit[PageCount].Width:=TabSheet[PageCount].Width-170;
  Audio4FileNameEdit[PageCount].Font.Name:='Tahoma';

  //Audio 4 Datei öffnen Dialog Button
  Audio4FileNameOpen[PageCount]:=TSpeedButton.Create(DVDForm.PageControl1);
  Audio4FileNameOpen[PageCount].Parent:=TabSheet[PageCount];
  Audio4FileNameOpen[PageCount].Glyph:=DVDForm.SpeedButton1.Glyph;
  Audio4FileNameOpen[PageCount].Height:=DVDForm.SpeedButton1.Height;
  Audio4FileNameOpen[PageCount].Width:=DVDForm.SpeedButton1.Width;
  Audio4FileNameOpen[PageCount].Top:=Audio4FileNameEdit[PageCount].Top;
  Audio4FileNameOpen[PageCount].Left:=Audio4FileNameEdit[PageCount].Left+Audio4FileNameEdit[PageCount].Width+5;
  Audio4FileNameOpen[PageCount].Tag:=PageCount;
  Audio4FileNameOpen[PageCount].OnClick:=DVDForm.OpenAudio4File;

  //Audio 4 Format ComboBox
  Audio4FileFormatComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio4FileFormatComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio4FileFormatComboBox[PageCount].Height:=Audio4FileNameOpen[PageCount].Height;
  Audio4FileFormatComboBox[PageCount].Width:=55;
  Audio4FileFormatComboBox[PageCount].Top:=Audio4FileNameEdit[PageCount].Top;
  Audio4FileFormatComboBox[PageCount].Left:=Audio4FileNameOpen[PageCount].Left+Audio4FileNameOpen[PageCount].Width+5;
  Audio4FileFormatComboBox[PageCount].Items.Add('');
  Audio4FileFormatComboBox[PageCount].Items.Add('MP2');
  Audio4FileFormatComboBox[PageCount].Items.Add('AC3');
  Audio4FileFormatComboBox[PageCount].ItemIndex:=0;
  Audio4FileFormatComboBox[PageCount].Style:=csDropDownList;
  Audio4FileFormatComboBox[PageCount].Font.Name:='Tahoma';

  //Audio 4 Format Hinweislabel
  Audio4FileFormatLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio4FileFormatLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio4FileFormatLabel[PageCount].Caption:=ResString(51);
  Audio4FileFormatLabel[PageCount].Top:=Audio4Label[PageCount].Top;
  Audio4FileFormatLabel[PageCount].Left:=Audio4FileFormatComboBox[PageCount].Left;
  Audio4FileFormatLabel[PageCount].Font.Name:='Tahoma';

  //Audio 4 Sprach ComboBox
  Audio4FileLanguageComboBox[PageCount]:=TComboBox.Create(DVDForm.PageControl1);
  Audio4FileLanguageComboBox[PageCount].Parent:=TabSheet[PageCount];
  Audio4FileLanguageComboBox[PageCount].Height:=Audio4FileNameOpen[PageCount].Height;
  Audio4FileLanguageComboBox[PageCount].Width:=55;
  Audio4FileLanguageComboBox[PageCount].Top:=Audio4FileNameEdit[PageCount].Top;
  Audio4FileLanguageComboBox[PageCount].Left:=Audio4FileFormatComboBox[PageCount].Left+Audio4FileFormatComboBox[PageCount].Width+5;
  Audio4FileLanguageComboBox[PageCount].Items:=Audio1FileLanguageComboBox[PageCount].Items;
  Audio4FileLanguageComboBox[PageCount].ItemIndex:=0;
  Audio4FileLanguageComboBox[PageCount].Style:=csDropDownList;
  Audio4FileLanguageComboBox[PageCount].Font.Name:='Tahoma';

  //Audio 4 Sprachen Hinweislabel
  Audio4FileLanguageLabel[PageCount]:=TLabel.Create(DVDForm.PageControl1);
  Audio4FileLanguageLabel[PageCount].Parent:=TabSheet[PageCount];
  Audio4FileLanguageLabel[PageCount].Caption:=ResString(52);
  Audio4FileLanguageLabel[PageCount].Top:=Audio4Label[PageCount].Top;
  Audio4FileLanguageLabel[PageCount].Left:=Audio4FileLanguageComboBox[PageCount].Left;
  Audio4FileLanguageLabel[PageCount].Font.Name:='Tahoma';

  //Seite nach Erstellung wieder einblenden
  DVDForm.PageControl1.Pages[PageCount-1].Visible:=true;
end;

procedure TDVDForm.AktualisiereDVDSprache;
//alle Bezeichnungen in der gewünschten Sprache darstellen
begin
  //eingestellte Sprache aus "original" Mpeg2Schnitt übernehmen
  SprachAuswahl;

  //dynamisch erzeugte MenüItems im Hauptprogramm übersetzen
  Hauptfenster.DVDMenueItem.Caption:=ResString(43);
  Hauptfenster.DVDMenueItem2.Caption:=ResString(44);
  Hauptfenster.DVDMenueItem3.Caption:=ResString(118);
  Hauptfenster.DVDMenueItem4.Caption:=ResString(74);
  Hauptfenster.DVDMenueItem5.Caption:=ResString(120);
  Hauptfenster.DVDMenueItem6.Caption:=ResString(121);

  //DVDFormular übersetzen
  Button1.Caption:=ResString(45);
  Button2.Caption:=ResString(46);
  Button3.Caption:=ResString(9);
  Button4.Caption:=ResString(63);
  Button5.Caption:=ResString(30);
  CheckBox1.Caption:=ResString(58);
  CheckBox2.Caption:=ResString(59);
  CheckBox3.Caption:=ResString(60);
  CheckBox4.Caption:=ResString(61);
  CheckBox5.Caption:=ResString(62);
  CheckBox6.Caption:=ResString(122);
  Label1.Caption:=ResString(64);
  Label2.Caption:=ResString(65);
  Label3.Caption:=ResString(66);
  Label4.Caption:=ResString(101);
  Label5.Caption:=ResString(102);
  Label6.Caption:=ResString(123);
end;

procedure SprachAuswahl;
//eingestellte Sprache aus "original" Mpeg2Schnitt übernehmen
begin
  //wenn Punkt "Datei" im Hauptmenü vorhanden dann "Deutsch" ansonsten "Englisch" als Sprache
  if Pos('atei',MpegEdit.Datei.Caption)>0 then
    SprachID:=0
  else
    SprachID:=1000;

  //INI einlesen, damit Menüoptionen gesetzt werden können
  INI_Einstellungen_einlesen;
end;

function ResString(ResID: Integer): string;
//String in der angewählten Sprache aus der Ressource laden
var
  buffer: array[0..255] of Char;
begin
  //String aus Ressource
  Loadstring(hinstance,10000+ResID+SprachID, @buffer, 255);

  //wenn kein String in Ressource vorhanden war, dann deutschen String laden
  if StrPas(buffer)='' then
    ResString:=ResString2(ResID)
  else
    ResString:=StrPas(buffer);
end;

function ResString2(ResID: Integer): string;
//String unabhängig von Sprache aus der Ressource laden
var
  buffer: array[0..255] of Char;
begin
  Loadstring(hinstance,10000+ResID, @buffer, 255);
  ResString2:=StrPas(buffer);
end;

procedure TDVDForm.Start(Sender: TObject);
//DVD Bearbeitungsmenü anzeigen
begin
  //Einstellungen einlesen
  INI_Einstellungen_einlesen;
  if DVDForm.Edit2.Text='' then
    begin
      DVDForm.Edit2.Text:=ExtractFilePath(Application.ExeName);
      ShowMessage(ResString(72));
    end;
  DVDForm.Edit2.Hint:=DVDForm.Edit2.Text;
  DVDForm.Edit2.ShowHint:=true;
  DVDForm.Edit2.SelStart:=Length(DVDForm.Edit2.Text);
  DVDForm.JvDriveCombo1Change(DVDForm);
  DVDForm.Memo1.DoubleBuffered:=true;
  DVDForm.Memo2.DoubleBuffered:=true;
  DVDForm.Button1.Enabled:=true;
  DVDForm.Button2.Enabled:=false;
  if DVDForm.CheckBox6.Checked=false then
    begin
      DVDForm.SpeedButton3.Enabled:=false;
      DVDForm.ListBox1.Enabled:=false;
    end
  else
    begin
      DVDForm.SpeedButton3.Enabled:=true;
      DVDForm.ListBox1.Enabled:=true;
    end;

  //wenn NERO nicht vorhanden, dann Brennoptionen ausblenden
  if (NERO_PATH='') or (FileExists(Nero_Path+'NeroCmd.exe')=false) then
    begin
      DVDForm.CheckBox4.Checked:=false;
      DVDForm.CheckBox5.Checked:=false;
      DVDForm.CheckBox4.Visible:=false;
      DVDForm.CheckBox5.Visible:=false;
      DVDForm.Label5.Visible:=false;
      DVDForm.JvDriveCombo1.Visible:=false;
      DVDForm.SpeedButton2.Visible:=false;
      DVDForm.Memo1.Text:=ResString(112);
    end;

  //wenn externe Tools vorhanden sind, dann Fenster anzeigen
  if CheckTools=true then
    begin
      //Alle Tastenabfragen etc. NICHT auf das Hauptprogramm umleiten
      Application.OnMessage:=NIL;
      DVDForm.ShowModal;
    end;
end;

procedure TDVDForm.NeroPfadSetup(Sender: TObject);
//Pfad zur NERO Burning ROM NEROCMD.EXE einstellen
var
  INI: TIniFile;

begin
  //wenn INI nicht vorhanden Funktion verlassen
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;

  //vorhandene Einstellungen einlesen
  INI_Einstellungen_einlesen;

  //manuell NEROCMD.EXE suchen
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  ProjectXForm.OpenDialog1.Title:=ResString(118);
  ProjectXForm.OpenDialog1.Filter:=ResString(119);
  ProjectXForm.OpenDialog1.FilterIndex:=0;
  if Nero_Path<>'' then
    ProjectXForm.OpenDialog1.InitialDir:=Nero_Path
  else
    ProjectXForm.OpenDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  ProjectXForm.OpenDialog1.FileName:='';
  if ProjectXForm.OpenDialog1.Execute=false then
    exit;
  if FileExists(ProjectXForm.OpenDialog1.FileName)=true then
    Nero_Path:=ExtractFilePath(ProjectXForm.OpenDialog1.FileName)
  else
    Nero_Path:='';
  INI.WriteString('DVD_Erzeugung','NERO',Nero_Path);
  INI.Free;
end;

procedure TDVDForm.NeroSuche(Sender: TObject);
//NERO Burning ROM Pfadangabe automatisch suchen lassen
var
  Pfad: String;
  INI: TIniFile;

begin
  //wenn keine Mpeg2Schnitt INI Datei vorhanden ist, dann abbrechen
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;

  //Sicherheitsabfrage
  if MessageBox(DVDForm.Handle,PChar(ResString(114)+#13+#10+ResString(36)),PChar(MpegEdit.Caption),MB_OKCANCEL)<>IDOK then
    begin
      MpegEdit.SetFocus;
      exit;
    end;

  //Vorbereitung
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');

  //NeroCmd suchen
  Pfad:=ProjectXForm.SucheDatei('NEROCMD.EXE');
  if (Pfad<>'') and (AnsiPos('NEROCMD.EXE',UpperCase(Pfad))>0) then
    begin
      Nero_Path:=ExtractFilePath(Pfad);
      INI.WriteString('DVD_Erzeugung','NERO',Nero_Path);
      ShowMessage(ResString(116));
    end
  else
    ShowMessage(ResString(115));

  //aufräumen
  INI.Free;
end;

procedure TDVDForm.FormCreate(Sender: TObject);
//DVD Bearbeitungsmenü erzeugen
begin
  //Eigenschaften von Formular und sonstigen Komponenten definieren
  DVDForm.Icon:=MpegEdit.Icon;

  //Sprache definiert setzen
  AktualisiereDVDSprache;
  DVDForm.Caption:=ResString(57);

  //aus M2S übernommene Dateiliste löschen
  if M2SDateien=NIL then
    M2SDateien:=TStringList.Create;
end;

procedure TDVDForm.FormShow(Sender: TObject);
//DVD Bearbeitungsmenü einblenden
var
  Counter: Integer;
  Buffer: String;

begin
  //wenn kein TabSheet vorhanden, dann zumindest 1 TabSheet erzeugen
  if DVDForm.PageControl1.PageCount=0 then
    AddTitleSet;

  //geschnittene M2S Dateien übernehmen
  if M2SDateien.Count>0 then
    begin
      for Counter:=0 to M2SDateien.Count-1 do
        begin
          //Video Datei übernehmen
          if Pos('VideoFile=',M2SDateien.Strings[Counter])>0 then
            begin
              VideoFileNameEdit[1].Text:=AnsiReplaceStr(M2SDateien.Strings[Counter],'VideoFile=','');
              VideoFileNameEdit[1].Hint:=VideoFileNameEdit[1].Text;
              VideoFileNameEdit[1].ShowHint:=true;
              VideoFileNameEdit[1].SelStart:=Length(VideoFileNameEdit[1].Text);
              try
              Buffer:=MediaInfoFileVideoAspect(VideoFileNameEdit[1].Text);
              except
              Buffer:='';
              end;
              if Buffer='16/9' then
                VideoFileAspectComboBox[1].ItemIndex:=2
              else if Buffer='4/3' then
                VideoFileAspectComboBox[1].ItemIndex:=1
              else
                VideoFileAspectComboBox[1].ItemIndex:=0;
              Application.ProcessMessages;
              try
              Buffer:=IntToStr(MediaInfoFileVideoWidth(VideoFileNameEdit[1].Text));
              except
              Buffer:='';
              end;
              if Buffer<>'' then
                VideoFileResolutionLabel1[1].Caption:=Buffer;
              try
              Buffer:=IntToStr(MediaInfoFileVideoHeight(VideoFileNameEdit[1].Text));
              except
              Buffer:='';
              end;
              if Buffer<>'' then
                VideoFileResolutionLabel1[1].Caption:=VideoFileResolutionLabel1[1].Caption+'x'+Buffer
              else
                VideoFileResolutionLabel1[1].Caption:='';

              //Filmdauer auswerten
              Application.ProcessMessages;
              try
              MediaFileDuration[1]:=MediaInfo.MediaInfoFilePlayTime(VideoFileNameEdit[1].Text);
              except
              MediaFileDuration[1]:=0;
              end;

              //Name aus erstem TitleSet übernehmen
              Buffer:=ExtractFileName(VideoFileNameEdit[1].Text);
              Buffer:=ChangeFileExt(Buffer,'');
              if Pos('_',Buffer)>0 then
                Buffer:=AnsiRightStr(Buffer,Length(Buffer)-17);
              if Length(Buffer)>15 then
                Buffer:=AnsiLeftStr(Buffer,15);
              if Pos('(',Buffer)>0 then
                Buffer:=AnsiLeftStr(Buffer,Pos('(',Buffer)-1);
              Buffer:=StringReplace(Buffer,'_',' ',[rfReplaceAll, rfIgnoreCase]);
              Edit1.Text:=Trim(Buffer);
            end;

          //1. Audio Datei übernehmen
          if Pos('AudioFile1=',M2SDateien.Strings[Counter])>0 then
            begin
              Audio1FileNameEdit[1].Text:=AnsiReplaceStr(M2SDateien.Strings[Counter],'AudioFile1=','');
              Audio1FileNameEdit[1].Hint:=Audio1FileNameEdit[1].Text;
              Audio1FileNameEdit[1].ShowHint:=true;
              Audio1FileNameEdit[1].SelStart:=Length(Audio1FileNameEdit[1].Text);
              try
              Buffer:=MediaInfoFileCodec(Audio1FileNameEdit[1].Text);
              except
              Buffer:='';
              end;
              if Buffer='AC3' then
                Audio1FileFormatComboBox[1].ItemIndex:=2
              else if Buffer='MPEG-1 Audio' then
                Audio1FileFormatComboBox[1].ItemIndex:=1
              else
                Audio1FileFormatComboBox[1].ItemIndex:=0;
            end;

          //2. Audio Datei übernehmen
          if Pos('AudioFile2=',M2SDateien.Strings[Counter])>0 then
            begin
              Audio2FileNameEdit[1].Text:=AnsiReplaceStr(M2SDateien.Strings[Counter],'AudioFile2=','');
              Audio2FileNameEdit[1].Hint:=Audio2FileNameEdit[1].Text;
              Audio2FileNameEdit[1].ShowHint:=true;
              Audio2FileNameEdit[1].SelStart:=Length(Audio2FileNameEdit[1].Text);
              try
              Buffer:=MediaInfoFileCodec(Audio2FileNameEdit[1].Text);
              except
              Buffer:='';
              end;
              if Buffer='AC3' then
                Audio2FileFormatComboBox[1].ItemIndex:=2
              else if Buffer='MPEG-1 Audio' then
                Audio2FileFormatComboBox[1].ItemIndex:=1
              else
                Audio2FileFormatComboBox[1].ItemIndex:=0;
            end;

          //3. Audio Datei übernehmen
          if Pos('AudioFile3=',M2SDateien.Strings[Counter])>0 then
            begin
              Audio3FileNameEdit[1].Text:=AnsiReplaceStr(M2SDateien.Strings[Counter],'AudioFile3=','');
              Audio3FileNameEdit[1].Hint:=Audio3FileNameEdit[1].Text;
              Audio3FileNameEdit[1].ShowHint:=true;
              Audio3FileNameEdit[1].SelStart:=Length(Audio3FileNameEdit[1].Text);
              try
              Buffer:=MediaInfoFileCodec(Audio3FileNameEdit[1].Text);
              except
              Buffer:='';
              end;
              if Buffer='AC3' then
                Audio3FileFormatComboBox[1].ItemIndex:=2
              else if Buffer='MPEG-1 Audio' then
                Audio3FileFormatComboBox[1].ItemIndex:=1
              else
                Audio3FileFormatComboBox[1].ItemIndex:=0;
            end;

          //4. Audio Datei übernehmen
          if Pos('AudioFile4=',M2SDateien.Strings[Counter])>0 then
            begin
              Audio4FileNameEdit[1].Text:=AnsiReplaceStr(M2SDateien.Strings[Counter],'AudioFile4=','');
              Audio4FileNameEdit[1].Hint:=Audio4FileNameEdit[1].Text;
              Audio4FileNameEdit[1].ShowHint:=true;
              Audio4FileNameEdit[1].SelStart:=Length(Audio4FileNameEdit[1].Text);
              try
              Buffer:=MediaInfoFileCodec(Audio4FileNameEdit[1].Text);
              except
              Buffer:='';
              end;
              if Buffer='AC3' then
                Audio4FileFormatComboBox[1].ItemIndex:=2
              else if Buffer='MPEG-1 Audio' then
                Audio4FileFormatComboBox[1].ItemIndex:=1
              else
                Audio4FileFormatComboBox[1].ItemIndex:=0;
            end;
        end;

      //automatisch DVD erstellen
      PostMessage(DVDForm.Handle, WM_AFTER_SHOW, 0, 0);
    end;
end;

procedure TDVDForm.WmAfterShow(var Msg: TMessage);
//automatisch DVD erstellen
begin
  if DVDMenueItem6.Checked=true then
    Button4Click(DVDForm);
end;

procedure TDVDForm.JvSpinEdit1Change(Sender: TObject);
//Änderung der Anzahl der automatischen zu erzeugenden Kapitel
begin
  //kein leeres Feld zulassen
  if Length(JvSpinEdit1.Text)=0 then
    JvSpinEdit1.Text:='1';

  //nicht mehr als 50 Kapitel zulassen
  if StrToInt(JvSpinEdit1.Text)>50 then
    JvSpinEdit1.Text:='1';
end;

procedure TDVDForm.Button1Click(Sender: TObject);
//TabSheet (=TitleSet) hinzufügen
begin
  //TitleSet hinzufügen
  Kontrollen_sperren;
  AddTitleSet;
  Kontrollen_freigeben;
  Button2.Enabled:=true;

  //Button sperren, wenn 9 TabSheets vorhanden
  if DVDForm.PageControl1.PageCount>8 then
    Button1.Enabled:=false;
end;

procedure TDVDForm.Button2Click(Sender: TObject);
//TabSheet (=TitleSet) löschen
var
  Counter: Byte;

begin
  //wenn kein TabSheet aktiviert ist dann Funktion verlassen
  if DVDForm.PageControl1.ActivePageIndex<0 then
    exit;

  //nur löschen wenn mehr als 1 TabSheet vorhanden
  Kontrollen_sperren;
  if DVDForm.PageControl1.PageCount>1 then
    begin
      DVDForm.PageControl1.Pages[DVDForm.PageControl1.ActivePageIndex].Free;
    end
  else
    begin
      Kontrollen_freigeben;
      exit;
    end;

  //übrige TitleSets neu benennen
  for Counter:=0 to DVDForm.PageControl1.PageCount-1 do
    begin
      DVDForm.PageControl1.Pages[Counter].Caption:='TitleSet '+IntToStr(Counter+1);
    end;
  Kontrollen_freigeben;

  //Lösch Button sperren, wenn nur noch ein TabSheet vorhanden
  if DVDForm.PageControl1.PageCount<2 then
    Button2.Enabled:=false;

  //Hinzufügen Button freigeben, wenn weniger als 9 TabSheets vorhanden
  if DVDForm.PageControl1.PageCount<9 then
    Button1.Enabled:=true;
end;

procedure TDVDForm.Button3Click(Sender: TObject);
//Beenden
begin
  //DVDForm ausblenden
  DVDForm.Close;

  //Hauptform wieder anzeigen
  MpegEdit.BringToFront;
end;

procedure TDVDForm.FormClose(Sender: TObject; var Action: TCloseAction);
//DVD Bearbeitungsmenü schließen
var
  Counter: Integer;

begin
  //Einstellungen speichern
  INI_Einstellungen_schreiben;

  //DVDForm unsichtbar machen, um Grafikfehler beim TabSheet löschen zu vermeiden
  DVDForm.Visible:=false;

  //Alle Tastenabfragen etc. wieder auf das Hauptprogramm umleiten
  Application.OnMessage:=MpegEdit.AlleNachrichten;
  MpegEdit.BringToFront;

  //TabSheets löschen
  while DVDForm.PageControl1.PageCount>0 do
    begin
      if DVDForm.PageControl1.Pages[DVDForm.PageControl1.PageCount-1]<>NIL then
        DVDForm.PageControl1.Pages[DVDForm.PageControl1.PageCount-1].Free;
    end;

  //Anzeigen und Variablen löschen
  for Counter:=1 to 9 do
    MediaFileDuration[Counter]:=0;
  if M2SDateien<>NIL then
    M2SDateien.Clear;
  DVDForm.Memo1.Clear;
  DVDForm.Memo2.Clear;
  ListBox1.Items.Clear;
  DVDForm.ModalResult:=mrOK;
end;

procedure TDVDForm.CheckBox1Click(Sender: TObject);
//Option ISO Image erstellen
begin
  Edit1.Enabled:=CheckBox1.Checked;
  CheckBox2.Enabled:=CheckBox1.Checked;
  CheckBox4.Enabled:=CheckBox1.Checked;
  if CheckBox2.Enabled=false then
    CheckBox2.Checked:=false;
  if CheckBox4.Enabled=false then
    CheckBox4.Checked:=false;
  CheckBox5.Enabled:=CheckBox4.Checked;
  if CheckBox5.Enabled=false then
    CheckBox5.Checked:=false;
end;

procedure TDVDForm.CheckBox4Click(Sender: TObject);
//Option ISO Image brennen
begin
  CheckBox5.Enabled:=CheckBox4.Checked;
  if CheckBox5.Enabled=false then
    CheckBox5.Checked:=false;
end;

procedure TDVDForm.CheckBox3Click(Sender: TObject);
//Option Kapitel erzeugen
begin
  JvSpinEdit1.Enabled:=CheckBox3.Checked;
  if CheckBox3.Checked=true then
    begin
      CheckBox6.Checked:=false;
      Label2.Enabled:=true;
    end
  else
    Label2.Enabled:=false;
end;

procedure TDVDForm.SpeedButton1Click(Sender: TObject);
//Zielverzeichnis auswählen
begin
  JvBrowseForFolderDialog1.Title:=ResString(66);
  JvBrowseForFolderDialog1.Directory:=ExtractFilePath(Application.ExeName);
  if JvBrowseForFolderDialog1.Execute=true then
    begin
      Edit2.Text:=JvBrowseForFolderDialog1.Directory;
      Edit2.Hint:=Edit2.Text;
    end;
end;

procedure TDVDForm.DVD_Menue_Einstellung(Sender: TObject);
//Einstellung aus Hauptprogramm anpassen
begin
  if (DVDMenueItem5.Checked=false) and ((Sender as TMenuItem).Name='DVDMenueItem5') then
    DVDMenueItem6.Checked:=false;
  if (DVDMenueItem6.Checked=true) and ((Sender as TMenuItem).Name='DVDMenueItem6') then
    DVDMenueItem5.Checked:=true;
  INI_Einstellungen_schreiben2;
end;

procedure INI_Einstellungen_schreiben2;
//zusätzliche Einstellungen in INI Datei schreiben
var
  INI: TIniFile;

begin
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  INI.WriteBool('DVD_Erzeugung','DVD_Menü_automatisch_öffnen',DVDMenueItem5.Checked);
  INI.WriteBool('DVD_Erzeugung','DVD_automatisch_erstellen',DVDMenueItem6.Checked);
  INI.Free;
end;

procedure INI_Einstellungen_schreiben;
//zusätzliche Einstellungen in INI Datei schreiben
var
  INI: TIniFile;

begin
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  INI.WriteString('DVD_Erzeugung','Arbeitsverzeichnis',DVDForm.Edit2.Text);
  INI.WriteBool('DVD_Erzeugung','ISO_Image_erzeugen',DVDForm.CheckBox1.Checked);
  INI.WriteBool('DVD_Erzeugung','IFO_VOB_löschen',DVDForm.CheckBox2.Checked);
  INI.WriteBool('DVD_Erzeugung','Kapitel_erzeugen',DVDForm.CheckBox3.Checked);
  INI.WriteBool('DVD_Erzeugung','Kapitel_manuell',DVDForm.CheckBox6.Checked);
  INI.WriteString('DVD_Erzeugung','Kapitel',FloatToStr(DVDForm.JvSpinEdit1.Value));
  INI.WriteBool('DVD_Erzeugung','ISO_Image_brennen',DVDForm.CheckBox4.Checked);
  INI.WriteBool('DVD_Erzeugung','ISO_Image_löschen',DVDForm.CheckBox5.Checked);
  INI.WriteInteger('DVD_Erzeugung','Multiplexer',DVDForm.ComboBox1.ItemIndex);
  INI.WriteString('DVD_Erzeugung','NERO',Nero_Path);
  INI.WriteString('DVD_Erzeugung','DVD_Rekorder',DVDDrive);
  INI.WriteBool('DVD_Erzeugung','DVD_Menü_automatisch_öffnen',DVDMenueItem5.Checked);
  if VideoFileNameEdit[1].Text<>'' then
    INI.WriteString('DVD_Erzeugung','Letzter_Ordner',ExtractFilePath(VideoFileNameEdit[1].Text));
  INI.Free;
end;

procedure LOG_schreiben;
//Log Datei schreiben
var
  Log: TextFile;

begin
  DVDForm.Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName)+'Recording.log');
  if Length(DVDForm.Memo2.Text)>25 then
    begin
      try
      AssignFile(Log, ExtractFilePath(Application.ExeName)+'Recording.log');
      if FileExists(ExtractFilePath(Application.ExeName)+'Recording.log')=true then
        Append(Log)
      else
        ReWrite(Log);
      WriteLn(Log, #13+#10+#13+#10+'Detail Log:'+#13+#10);
      Write(Log, DVDForm.Memo2.Text);
      finally
      CloseFile(Log);
      end;
    end;
end;

procedure INI_Einstellungen_einlesen;
//Einstellungen aus INI Datei einlesen
var
  INI: TIniFile;

begin
  //Werte aus INI datei auslesen
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  DVDForm.Edit2.Text:=INI.ReadString('DVD_Erzeugung','Arbeitsverzeichnis','');
  DVDForm.CheckBox1.Checked:=INI.ReadBool('DVD_Erzeugung','ISO_Image_erzeugen',false);
  DVDForm.CheckBox2.Checked:=INI.ReadBool('DVD_Erzeugung','IFO_VOB_löschen',false);
  DVDForm.CheckBox3.Checked:=INI.ReadBool('DVD_Erzeugung','Kapitel_erzeugen',false);
  DVDForm.CheckBox6.Checked:=INI.ReadBool('DVD_Erzeugung','Kapitel_manuell',false);
  DVDForm.JvSpinEdit1.Value:=StrToInt(INI.ReadString('DVD_Erzeugung','Kapitel','10'));
  DVDForm.CheckBox4.Checked:=INI.ReadBool('DVD_Erzeugung','ISO_Image_brennen',false);
  DVDForm.CheckBox5.Checked:=INI.ReadBool('DVD_Erzeugung','ISO_Image_löschen',false);
  DVDForm.ComboBox1.ItemIndex:=INI.ReadInteger('DVD_Erzeugung','Multiplexer',0);
  Nero_Path:=INI.ReadString('DVD_Erzeugung','NERO','');
  DVDDrive:=INI.ReadString('DVD_Erzeugung','DVD_Rekorder','');
  DVDMenueItem5.Checked:=INI.ReadBool('DVD_Erzeugung','DVD_Menü_automatisch_öffnen',false);
  DVDMenueItem6.Checked:=INI.ReadBool('DVD_Erzeugung','DVD_automatisch_erstellen',false);
  Letzter_Ordner:=INI.ReadString('DVD_Erzeugung','Letzter_Ordner','');
  INI.Free;

  //ausgelesene Werte als Einstellungen im Programm setzen
  DVDForm.CheckBox2.Enabled:=DVDForm.CheckBox1.Checked;
  DVDForm.CheckBox4.Enabled:=DVDForm.CheckBox1.Checked;
  if DVDForm.CheckBox2.Enabled=false then
    DVDForm.CheckBox2.Checked:=false;
  if DVDForm.CheckBox4.Enabled=false then
    DVDForm.CheckBox4.Checked:=false;
  DVDForm.CheckBox5.Enabled:=DVDForm.CheckBox4.Checked;
  if DVDForm.CheckBox5.Enabled=false then
    DVDForm.CheckBox5.Checked:=false;
  if DVDForm.CheckBox3.Checked=true then
    DVDForm.CheckBox6.Checked:=false;
  if DVDForm.CheckBox6.Checked=true then
    DVDForm.CheckBox3.Checked:=false;
  if DVDForm.CheckBox6.Checked=false then
    begin
      DVDForm.SpeedButton3.Enabled:=false;
      DVDForm.ListBox1.Enabled:=false;
    end
  else
    begin
      DVDForm.SpeedButton3.Enabled:=true;
      DVDForm.ListBox1.Enabled:=true;
    end;
  DVDForm.JvSpinEdit1.Enabled:=DVDForm.CheckBox3.Checked;
  if DVDDrive<>'' then
    DVDForm.JvDriveCombo1.Drive:=DVDDrive[1];
end;

function DVDISOBurn(ISOImage: String; DVDDrive:String; DeleteISOafterBurning: Boolean): Boolean;
//ISO Image auf DVD brennen
begin
  //Vorbereitung
  Result:=false;
  DVDForm.Memo1.Lines.Add('');
  DVDForm.Memo1.Lines.Add(ResString(68)+' "'+ExtractFileName(ISOImage)+'"');
  DVDForm.Memo1.Lines.Add('');

  //ISOImage überprüfen
  if FileExists(ISOImage)=false then
    begin
      DVDForm.Memo1.Lines.Add(ResString(69));
      exit;
    end;

  //DVD Brenner überprüfen
  if DVDDrive='' then
    begin
      DVDForm.Memo1.Lines.Add(ResString(70));
      exit;
    end;

  //Timer zur Sekundenzeitanzeige starten
  Start:=Time;
  DVDForm.Timer1.Enabled:=true;

  //Brennvorgang starten
  DVDForm.Button5.Enabled:=false;
  DVDForm.JvCreateProcess2.StartupInfo.Title:=DVDForm.Caption+' '+ResString(67);
  DVDForm.JvCreateProcess2.ApplicationName:=Nero_Path+'NeroCmd.exe';
  DVDForm.JvCreateProcess2.CommandLine:=' --write --real --drivename '+DVDDrive+' --image "'+ISOImage+'" --speedtest --enable_abort --close_session --underrun_prot --dvd --dvd_high_compatibility --verify --no_error_log';
  DVDForm.JvCreateProcess2.Run;
  DVDForm.JvCreateProcess2.ConsoleOutput.Clear;
  while DVDForm.JvCreateProcess2.State=psWaiting do
    Application.ProcessMessages;
  DVDForm.Button5.Enabled:=true;

  //Timer zur Sekundenzeitanzeige beenden
  DVDForm.Timer1.Enabled:=false;
  Sleep(1000);

  //Ergebnis
  if Nero_ExitCode=0 then
    begin
      Result:=true;
      //ISO Image löschen
      if (DeleteISOafterBurning=true) and (FileExists(ISOImage)=true) then
        DeleteFile(ISOImage);
    end
  else
    begin
      DVDForm.Memo1.Lines.Add('Nero Exit Code '+IntToStr(Nero_ExitCode));
      Result:=false;
    end;
end;

procedure CreateDVD(Path: String; ISOImage: Boolean; IFOVOBFileDelete: Boolean; ISOBurn: Boolean; ISOFileDeleteAfterBurn: Boolean; DVDName: String);
//DVD erzeugen
var
  Counter: Byte;
  Buffer: String;
  FATFilesystem: Boolean;
  free_size: Int64;
  total_size: Int64;
  files_size_all: Int64;
  FuncResult: Boolean;

begin
  //Filesystem auswerten
  if Pos('FAT',GetDriveFormat(AnsiLeftStr(Path,1)+':\'))>0 then
    FATFilesystem:=true
  else
    FATFilesystem:=false;

  //Bedienung sperren und DVD Erzeugung starten
  Kontrollen_sperren;
  DVDForm.Memo1.Lines.Add(ResString(75));
  DVDForm.Memo2.Lines.Add('');
  DVDForm.Memo2.Lines.Add('');

  if (AnsiRightStr(Path,1)<>'\') and (AnsiRightStr(Path,1)<>'/') then
    Path:=Path+'\';

  //Pfadangabe zur MPLEX.EXE/TCMPLEX-PANTELTJE.EXE
  if DVDForm.ComboBox1.ItemIndex=0 then
    DVDForm.JvCreateProcess1.ApplicationName:=ExtractFilePath(Application.ExeName)+'mplex.exe'
  else
    DVDForm.JvCreateProcess1.ApplicationName:=ExtractFilePath(Application.ExeName)+'tcmplex-panteltje.exe';
  DVDForm.JvCreateProcess1.CurrentDirectory:=ExtractFilePath(DVDForm.JvCreateProcess1.ApplicationName);

  //Multiplexer Meldungen in Logfenster umleiten
  DVDForm.JvCreateProcess1.ConsoleOptions:=[coRedirect];

  //Multiplexing der temporären VOB TitleSets
  for Counter:=1 to 9 do
    begin
      //Commandline zusammenstellen
      if DVDForm.ComboBox1.ItemIndex=0 then
        Buffer:=' "'+DVDForm.JvCreateProcess1.ApplicationName+'" -S 0 -M -f 8 -o "'+Path+'temp'+IntToStr(Counter)+'.vob"'
      else
        Buffer:=' "'+DVDForm.JvCreateProcess1.ApplicationName+'" -m d -D 0 -o "'+Path+'temp'+IntToStr(Counter)+'.vob"';

      //Benötigte Dateien auswerten
      files_size_all:=0;
      if FileExists(VideoFileNameEdit[Counter].Text)=true then
        begin
          if DVDForm.ComboBox1.ItemIndex=0 then
            Buffer:=Buffer+' "'+VideoFileNameEdit[Counter].Text+'"'
          else
            Buffer:=Buffer+' -i "'+VideoFileNameEdit[Counter].Text+'"';
          files_size_all:=files_size_all+GetFileSize(VideoFileNameEdit[Counter].Text);
          if  FATFilesystem=true then
            begin
              if (GetFileSize(VideoFileNameEdit[Counter].Text)>2147483648) then// div 1048576>4096) then
                begin
                  DVDForm.Memo1.Lines.Add(AnsiReplaceStr(ResString(76),'%1',ExtractFileName(VideoFileNameEdit[Counter].Text))+' ('+IntToStr(GetFileSize(VideoFileNameEdit[Counter].Text) div 1048576)+'MB)');
                  DVDForm.Memo1.Lines.Add(AnsiReplaceStr(ResString(77),'%1',ExtractFileDrive(DVDForm.Edit2.Text)));
                  DVDForm.Memo1.Lines.Add('');
                  //nicht mehr benötigte DVDauthor.xml löschen
                  if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
                    DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');
                  Kontrollen_freigeben;
                  exit;
                end;
            end;
        end;
      if FileExists(Audio1FileNameEdit[Counter].Text)=true then
        begin
          if DVDForm.ComboBox1.ItemIndex=0 then
            Buffer:=Buffer+' "'+Audio1FileNameEdit[Counter].Text+'"'
          else
            Buffer:=Buffer+' -0 "'+Audio1FileNameEdit[Counter].Text+'"';
          files_size_all:=files_size_all+GetFileSize(Audio1FileNameEdit[Counter].Text);
        end;
      if FileExists(Audio2FileNameEdit[Counter].Text)=true then
        begin
          if DVDForm.ComboBox1.ItemIndex=0 then
            Buffer:=Buffer+' "'+Audio2FileNameEdit[Counter].Text+'"'
          else
            Buffer:=Buffer+' -1 "'+Audio2FileNameEdit[Counter].Text+'"';
          files_size_all:=files_size_all+GetFileSize(Audio2FileNameEdit[Counter].Text);
        end;
      if FileExists(Audio3FileNameEdit[Counter].Text)=true then
        begin
          if DVDForm.ComboBox1.ItemIndex=0 then
            Buffer:=Buffer+' "'+Audio3FileNameEdit[Counter].Text+'"'
          else
            Buffer:=Buffer+' -2 "'+Audio3FileNameEdit[Counter].Text+'"';
          files_size_all:=files_size_all+GetFileSize(Audio3FileNameEdit[Counter].Text);
        end;
      if FileExists(Audio4FileNameEdit[Counter].Text)=true then
        begin
          if DVDForm.ComboBox1.ItemIndex=0 then
            Buffer:=Buffer+' "'+Audio4FileNameEdit[Counter].Text+'"'
          else
            Buffer:=Buffer+' -3 "'+Audio4FileNameEdit[Counter].Text+'"';
          files_size_all:=files_size_all+GetFileSize(Audio4FileNameEdit[Counter].Text);
        end;
      DVDForm.JvCreateProcess1.CommandLine:=Buffer;

      //temporäre VOB Datei aufräumen
      if FileExists(Path+'temp'+IntToStr(Counter)+'.vob"') then
        DeleteFile(Path+'temp'+IntToStr(Counter)+'.vob"');

      //freien Speicherplatz überprüfen
      free_size:=0;
      total_size:=0;
      if GetDiskSize(LeftStr(Path,1)[1], free_size, total_size)=false then
        begin
          DVDForm.Memo1.Lines.Add(ResString(78)+' '+ExtractFileDrive(Path)+' !');
          DVDForm.Memo1.Lines.Add('');
          //nicht mehr benötigte DVDauthor.xml löschen
          if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
            DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');
          Kontrollen_freigeben;
          exit;
        end
      else
        begin
          if files_size_all>1048576 then
            begin                     
              DVDForm.Memo1.Lines.Add(ResString(79)+' '+ExtractFileDrive(Path)+' '+IntToStr(free_size div 1048576)+' MB');
              DVDForm.Memo1.Lines.Add(ResString(80)+' (TitleSet '+IntToStr(Counter)+') '+IntToStr(files_size_all div 1048576)+' MB ('+ResString(81)+')');
              DVDForm.Memo1.Lines.Add('');
            end;
          if files_size_all>free_size then
            begin
              DVDForm.Memo1.Lines.Add(ResString(82)+' '+ExtractFileDrive(DVDForm.Edit2.Text)+' !');
              DVDForm.Memo1.Lines.Add('');
              //nicht mehr benötigte DVDauthor.xml löschen
              if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
                DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');
              Kontrollen_freigeben;
              exit;
            end;
        end;

      //externen Multiplex Prozess starten wenn eine Videodatei vorhanden ist
      sleep(100);
      if FileExists(VideoFileNameEdit[Counter].Text)=true then
        begin
          //Timer zur Sekundenzeitanzeige starten
          Start:=Time;
          DVDForm.Timer1.Enabled:=true;

          DVDForm.JvCreateProcess1.WaitForTerminate:=true;
          DVDForm.JvCreateProcess1.Run;
          while DVDForm.JvCreateProcess1.State=psWaiting do
            begin
              Application.ProcessMessages;
              if Abbruch=true then
                begin
                  DVDForm.JvCreateProcess1.Terminate;
                  Abbruch:=false;
                  DVDForm.Memo1.Lines.Add(ResString(83));
                  DVDForm.Memo1.Lines.Add('');
                  //nicht mehr benötigte DVDauthor.xml löschen
                  if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
                    DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');
                  Kontrollen_freigeben;
                  exit;
                end;
            end;

          //Timer zur Sekundenzeitanzeige beenden
          DVDForm.Timer1.Enabled:=false;
          Sleep(1000);
        end;
      Application.ProcessMessages;
    end;
  DVDForm.Memo1.Lines.Add(ResString(84));
  DVDForm.Memo1.Lines.Add('');

  //DVD Authoring beginnen
  DVDForm.Memo1.Lines.Add(ResString(85));
  DVDForm.Memo1.Lines.Add('');
  DVDForm.Memo2.Lines.Add('');
  DVDForm.Memo2.Lines.Add('');

  //Pfadangabe zur DVDAUTHOR.EXE
  DVDForm.JvCreateProcess1.ApplicationName:=ExtractFilePath(Application.ExeName)+'dvdauthor.exe';
  DVDForm.JvCreateProcess1.CurrentDirectory:=ExtractFilePath(DVDForm.JvCreateProcess1.ApplicationName);

  //DVDAUTHOR Meldungen in Logfenster umleiten
  DVDForm.JvCreateProcess1.ConsoleOptions:=[coRedirect];

  //DVDAUTHOR Commandline zusammenstellen
  DVDForm.JvCreateProcess1.CommandLine:=' "'+DVDForm.JvCreateProcess1.ApplicationName+'" -o "'+Path+'DVD" -x DVDauthor.xml';

  //eventuell vorhandene DVD Daten löschen
  try
    sleep(1000);
    DelDir(Path+'DVD')
  finally
    Application.ProcessMessages;
  end;

  //freien Speicherplatz überprüfen
  files_size_all:=0;
  free_size:=0;
  total_size:=0;
  for Counter:=1 to 9 do
    begin
      if FileExists(Path+'temp'+IntToStr(Counter)+'.vob') then
        files_size_all:=files_size_all+GetFileSize(Path+'temp'+IntToStr(Counter)+'.vob');
    end;
  if GetDiskSize(LeftStr(Path,1)[1], free_size, total_size)=false then
    begin
      DVDForm.Memo1.Lines.Add(ResString(78)+' '+ExtractFileDrive(Path)+' !');
      DVDForm.Memo1.Lines.Add('');
      //nicht mehr benötigte DVDauthor.xml löschen
      if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
        DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');
      Kontrollen_freigeben;
      exit;
    end
  else
    begin
      if files_size_all>1048576 then
        begin
          DVDForm.Memo1.Lines.Add(ResString(79)+' '+ExtractFileDrive(Path)+' '+IntToStr(free_size div 1048576)+' MB');
          DVDForm.Memo1.Lines.Add(ResString(86)+' '+IntToStr(files_size_all div 1048576)+' MB ('+ResString(81)+')');
          DVDForm.Memo1.Lines.Add('');
        end;
      if files_size_all>free_size then
        begin
          DVDForm.Memo1.Lines.Add(ResString(87)+' '+ExtractFileDrive(DVDForm.Edit2.Text)+' !');
          DVDForm.Memo1.Lines.Add('');
          //nicht mehr benötigte DVDauthor.xml löschen
          if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
            DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');
          Kontrollen_freigeben;
          exit;
        end;
    end;

  //Timer zur Sekundenzeitanzeige starten
  Start:=Time;
  DVDForm.Timer1.Enabled:=true;

  //externen DVD Authoring Prozess starten
  sleep(100);
  DVDForm.JvCreateProcess1.WaitForTerminate:=true;
  DVDForm.JvCreateProcess1.Run;
  while DVDForm.JvCreateProcess1.State=psWaiting do
    begin
      Application.ProcessMessages;
      if Abbruch=true then
        begin
          DVDForm.JvCreateProcess1.Terminate;
          Abbruch:=false;
          DVDForm.Memo1.Lines.Add(ResString(88));
          DVDForm.Memo1.Lines.Add('');
          //nicht mehr benötigte DVDauthor.xml löschen
          if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
            DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');
          Kontrollen_freigeben;
          exit;
        end;
    end;
  DVDForm.Memo1.Lines.Add(ResString(104));

  //nicht mehr benötigte DVDauthor.xml löschen
  if FileExists(ExtractFilePath(Application.ExeName)+'DVDauthor.xml')=true then
    DeleteFile(ExtractFilePath(Application.ExeName)+'DVDauthor.xml');

  //Timer zur Sekundenzeitanzeige beenden
  DVDForm.Timer1.Enabled:=false;
  Sleep(1000);

  //temporäre VOB Datei aufräumen nachdem DVD Daten erstellt wurden
  for Counter:=1 to 9 do
    begin
      if FileExists(Path+'temp'+IntToStr(Counter)+'.vob') then
        DeleteFile(Path+'temp'+IntToStr(Counter)+'.vob');
    end;

  //ISO Image erstellen
  if FileExists(Path+'\DVD\VIDEO_TS\VTS_01_1.VOB')=false then
    begin
      DVDForm.Memo1.Lines.Add(ResString(89));
      DVDForm.Memo1.Lines.Add('');
      Kontrollen_freigeben;
      exit;
    end;

  if ISOImage=true then
    begin
      DVDForm.Memo1.Lines.Add('');
      DVDForm.Memo1.Lines.Add(ResString(90));

      //freien Speicherplatz überprüfen (die vorhanden temporären VOB Dateien mit ungefährem Overhead berechnen)
      files_size_all:=Round(files_size_all*1.00026);
      free_size:=0;
      total_size:=0;
      if GetDiskSize(LeftStr(Path,1)[1], free_size, total_size)=false then
        begin
          DVDForm.Memo1.Lines.Add(ResString(78)+' '+ExtractFileDrive(Path)+' !');
          DVDForm.Memo1.Lines.Add('');
          Kontrollen_freigeben;
          exit;
        end
      else
        begin
          if files_size_all>1048576 then
            begin
              DVDForm.Memo1.Lines.Add(ResString(79)+' '+ExtractFileDrive(Path)+' '+IntToStr(free_size div 1048576)+' MB');
              DVDForm.Memo1.Lines.Add(ResString(91)+' '+IntToStr(files_size_all div 1048576)+' MB ('+ResString(81)+')');
              DVDForm.Memo1.Lines.Add('');
            end;
          if files_size_all>free_size then
            begin
              DVDForm.Memo1.Lines.Add(ResString(92)+' '+ExtractFileDrive(DVDForm.Edit2.Text)+' !');
              DVDForm.Memo1.Lines.Add('');
              Kontrollen_freigeben;
              exit;
            end;
        end;

      //Timer zur Sekundenzeitanzeige starten
      Start:=Time;
      DVDForm.Timer1.Enabled:=true;

      //Pfadangabe zur MKISOFS.EXE
      DVDForm.JvCreateProcess1.ApplicationName:=ExtractFilePath(Application.ExeName)+'mkisofs.exe';
      DVDForm.JvCreateProcess1.CurrentDirectory:=ExtractFilePath(DVDForm.JvCreateProcess1.ApplicationName);

      //MKISOFS Meldungen in Logfenster umleiten
      DVDForm.JvCreateProcess1.ConsoleOptions:=[coRedirect];

      //MKISOFS Commandline zusammenstellen
      DateTimeToString(Buffer,'dmy-hhnn',Date+Time);
      if DVDName<>'' then
        DVDForm.JvCreateProcess1.CommandLine:=' -dvd-video -V "'+DVDName+'" -o "'+Path+DVDName+'.iso" "'+Path+'DVD"'
      else
        DVDForm.JvCreateProcess1.CommandLine:=' -dvd-video -V "VIDEODVD" -o "'+Path+'VideoDVD_'+Buffer+'.iso" "'+Path+'DVD"';

      //externen ISO Image Erzeugung starten
      DVDForm.Memo2.Lines.Add('');
      DVDForm.Memo2.Lines.Add('');
      DVDForm.Memo2.Lines.Add('');
      sleep(100);
      DVDForm.JvCreateProcess1.WaitForTerminate:=true;
      DVDForm.JvCreateProcess1.Run;
      while DVDForm.JvCreateProcess1.State=psWaiting do
        begin
          Application.ProcessMessages;
          if Abbruch=true then
            begin
              DVDForm.JvCreateProcess1.Terminate;
              Abbruch:=false;
              DVDForm.Memo1.Lines.Add(ResString(93));
              DVDForm.Memo1.Lines.Add('');
              Kontrollen_freigeben;
              exit;
            end;
        end;
      Application.ProcessMessages;

      //DVD Daten löschen
      if IFOVOBFileDelete=true then
        begin
          try
            sleep(1000);
            DelDir(Path+'DVD')
          finally
            Application.ProcessMessages;
          end;
        end;

      //Timer zur Sekundenzeitanzeige beenden
      DVDForm.Timer1.Enabled:=false;
      Sleep(1500);

      //Rückmeldung und DVD Brennvorgang starten
      if FileExists(Path+DVDName+'.iso') then
        begin
          DVDForm.Memo1.Lines.Add(AnsiReplaceStr(ResString(94),'%1',DVDName));
          if ISOBurn=true then
            begin
              files_size_all:=GetFileSize(Path+DVDName+'.iso');
              DVDForm.Memo1.Lines.Add(ResString(95)+' '+IntToStr(files_size_all div 1048576)+' MB');
              if files_size_all>4718592000 then
                DVDForm.Memo1.Lines.Add(ResString(96));
              DVDForm.Button5.Enabled:=false;
              FuncResult:=DVDISOBurn(Path+DVDName+'.iso',DVDDrive,ISOFileDeleteAfterBurn);
              if FuncResult=false then
                DVDForm.Memo1.Lines.Add(ResString(97))
              else
                DVDForm.Memo1.Lines.Add(ResString(98));
              DVDForm.Button5.Enabled:=true;
            end;
        end
      else if FileExists(Path+'VideoDVD_'+Buffer+'.iso') then
        begin
          DVDForm.Memo1.Lines.Add(AnsiReplaceStr(ResString(94),'%1',Buffer));
          if ISOBurn=true then
            begin
              files_size_all:=GetFileSize(Path+'VideoDVD_'+Buffer+'.iso');
              DVDForm.Memo1.Lines.Add(ResString(95)+' '+IntToStr(files_size_all div 1048576)+' MB');
              if files_size_all>4718592000 then
                DVDForm.Memo1.Lines.Add(ResString(96));
              DVDForm.Button5.Enabled:=false;
              FuncResult:=DVDISOBurn(Path+'VideoDVD_'+Buffer+'.iso',DVDDrive,ISOFileDeleteAfterBurn);
              if FuncResult=false then
                DVDForm.Memo1.Lines.Add(ResString(97))
              else
                DVDForm.Memo1.Lines.Add(ResString(98));
              DVDForm.Button5.Enabled:=true;
            end;
        end
      else
        DVDForm.Memo1.Lines.Add(ResString(100));
  end;

  //Log speichern und Bedienung freigeben
  LOG_schreiben;
  Kontrollen_freigeben;
end;

function DelDir(dir: string): Boolean;
//Verzeichnis löschen
var
  fos: TSHFileOpStruct;

begin
  ZeroMemory(@fos,SizeOf(fos));
  with fos do
    begin
      wFunc:=FO_DELETE;
      fFlags:=FOF_SILENT or FOF_NOCONFIRMATION;
      pFrom:=PChar(dir+#0);
    end;
  Result:=(0=ShFileOperation(fos));
end;

function GetDriveFormat(sDrive : string):string;
//FileSystem auswerten
var
  pFSBuf, pVolName : PChar;
  nVNameSer : PDWORD;
  FSSysFlags, maxCmpLen : DWord;

begin
  result:='';
  GetMem(pVolName,MAX_PATH);
  GetMem(pFSBuf,MAX_PATH);
  GetMem(nVNameSer,MAX_PATH);
  Try
  GetVolumeInformation(PChar(Copy(sDrive,1,1)+':\'),pVolName,MAX_PATH,nVNameSer,maxCmpLen,FSSysFlags,pFSBuf,MAX_PATH);
  result:=StrPas(pFSBuf);
  Finally
  End;
  FreeMem(pVolName,MAX_PATH);
  FreeMem(pFSBuf,MAX_PATH);
  FreeMem(nVNameSer,MAX_PATH);
end;

function GetFileSize(FileName: String): Int64;
//Dateigröße auslesen
var
  FileStream: TFileStream;

begin
  result:=0;
  if FileExists(FileName)=false then
    exit;
  FileStream:=TFileStream.Create(FileName,fmOpenRead OR fmShareDenyWrite);
  try
  GetFileSize:=FileStream.Size;
  finally
  FileStream.Free;
  end;
end;

function GetDiskSize(drive: Char; var free_size, total_size: Int64): Boolean;
//freien Festplattenspeicher herausfinden
var
  RootPath: array[0..4] of Char;
  RootPtr: PChar;
  current_dir: string;

begin
  RootPath[0]:=Drive;
  RootPath[1]:=':';
  RootPath[2]:='\';
  RootPath[3]:=#0;
  RootPtr:=RootPath;
  current_dir:=GetCurrentDir;
  if SetCurrentDir(drive+':\') then
    begin
      GetDiskFreeSpaceEx(RootPtr,Free_size,Total_size,nil);
      SetCurrentDir(current_dir);
      Result:=true;
    end
  else
    begin
      Result:=false;
      Free_size:=-1;
      Total_size:=-1;
    end;
end;

procedure TDVDForm.JvCreateProcess1RawRead(Sender: TObject; const S: String);
//Konsolenausgabe filtern
var
  buffer: String;

begin
  Application.ProcessMessages;
  if S='' then exit;
  buffer:=S;
  //DVDAuthor Konsolenausgabe
  if AnsiPos('DVDAUTHOR', UpperCase(JvCreateProcess1.ApplicationName))>0 then
    begin
      buffer:=StringReplace(buffer,#13,#13+#13,[rfReplaceAll, rfIgnoreCase]);
      buffer:=StringReplace(buffer,#10,#10+#10,[rfReplaceAll, rfIgnoreCase]);
      buffer:=StringReplace(buffer,#10+#10,#13+#10,[rfReplaceAll, rfIgnoreCase]);
      buffer:=StringReplace(buffer,#13+#13,#13+#10,[rfReplaceAll, rfIgnoreCase]);
    end
  else
    begin
      //Fortschrittsanzeigen in Prozent der Konsolenausgabe
      buffer:=StringReplace(buffer,#13+#10+#10,#10,[rfReplaceAll, rfIgnoreCase]);
      buffer:=StringReplace(buffer,#13,'',[rfReplaceAll, rfIgnoreCase]);
      buffer:=StringReplace(buffer,'%','%'+#10,[rfReplaceAll, rfIgnoreCase]);
      buffer:=StringReplace(buffer,#10,#13+#10,[rfReplaceAll, rfIgnoreCase]);
    end;
  Memo2.Text:=Memo2.Text+buffer;
end;

procedure TDVDForm.Button4Click(Sender: TObject);
//DVD erstellen
begin
  Kontrollen_sperren;
  Abbruch:=false;
  Memo2.BringToFront;
  Button5.BringToFront;
  CreateDVDauthorXML;
  CreateDVD(Edit2.Text,CheckBox1.Checked,CheckBox2.Checked,CheckBox4.Checked,CheckBox5.Checked,Edit1.Text);
  Memo2.SendToBack;
  Button5.SendToBack;
  Kontrollen_freigeben;
end;

procedure TDVDForm.Memo2Change(Sender: TObject);
//Log Ausgaben der externen Tools filtern und anzeigen
begin
  //maximal 1500 Einträge
  if Memo2.Lines.Count>1500 then
    Memo2.Clear;

  //MKISOFS Fortschrittsanzeige korrigieren
  if (Pos('estimate finish',Memo2.Lines.ValueFromIndex[Memo2.Lines.Count-2])>0) then
    Memo2.Lines.Delete(Memo2.Lines.Count-2);

  //MPLEX  Fortschrittsanzeige korrigieren
  if (Pos('VOBU',Memo2.Lines.ValueFromIndex[Memo2.Lines.Count-3])>0) then
    Memo2.Lines.Delete(Memo2.Lines.Count-3);
  if (Pos('VOBU',Memo2.Lines.ValueFromIndex[Memo2.Lines.Count-2])>0) then
    Memo2.Lines.Delete(Memo2.Lines.Count-2);

  //ProjectX Fortschrittsanzeige korrigieren
  if (Pos('%',Memo2.Lines.ValueFromIndex[Memo2.Lines.Count-2])>0) then
    Memo2.Lines.Delete(Memo2.Lines.Count-2);
  if (Pos('100%',Memo2.Text)>0) then
    Memo2.Text:=StringReplace(Memo2.Text,#13+#10+'100%','',[rfReplaceAll, rfIgnoreCase]);

  //Memo Box nach unten scrollen und Cursor ausblenden
  SendMessage(Memo2.Handle,WM_VSCROLL,SB_BOTTOM,0);
  HideCaret(Memo2.Handle);
  Application.ProcessMessages;
end;

procedure TDVDForm.JvDriveCombo1Change(Sender: TObject);
//Wechels des DVD Laufwerks
begin
  DVDDrive:=JvDriveCombo1.Drive;
end;

procedure TDVDForm.SpeedButton2Click(Sender: TObject);
//Laufwerksinfo auslesen
begin
  //Bedienung sperren
  Kontrollen_sperren;

  //Info zum angewählten Laufwerk auslesen
  Memo1.Text:=AnsiReplaceStr(ResString(103),'%1',UpperCase(DVDDrive))+#13+#10+#13+#10;
  JvCreateProcess1.ApplicationName:=Nero_Path+'NeroCmd.exe';
  JvCreateProcess1.CommandLine:=' --driveinfo --drivename '+DVDDrive;
  JvCreateProcess1.ConsoleOutput.Clear;
  JvCreateProcess1.Run;
  while JvCreateProcess1.State=psWaiting do
    Application.ProcessMessages;
  Memo1.Lines.AddStrings(JvCreateProcess1.ConsoleOutput);

  //Bedienung reigeben
  Kontrollen_freigeben
end;

procedure TDVDForm.Button5Click(Sender: TObject);
//globaler Abbruch
begin
  Abbruch:=true;
end;

procedure TDVDForm.JvCreateProcess2Terminate(Sender: TObject; ExitCode: Cardinal);
//NERO ExitCode auswerten
begin
  Nero_ExitCode:=ExitCode;
end;

procedure TDVDForm.CheckBox6Click(Sender: TObject);
//Kapitel vorgeben
begin
  if CheckBox6.Checked=false then
    begin
      SpeedButton3.Enabled:=false;
      ListBox1.Items.Clear;
      ListBox1.Enabled:=false;
      Label6.Enabled:=false;
    end
  else
    begin
      SpeedButton3.Enabled:=true;
      ListBox1.Enabled:=true;
      CheckBox3.Checked:=false;
      Label6.Enabled:=true;
    end;
end;

procedure TDVDForm.SpeedButton3Click(Sender: TObject);
//Kapitelliste laden
var
  Kapitelliste: TStringList;
  Kapitelmarke: Extended;
  Kapitelzeit: TDateTime;
  Counter: Integer;

begin
  Kontrollen_sperren;
  ProjectXForm.OpenDialog1.Title:=ResString(124);
  ProjectXForm.OpenDialog1.Filter:=ResString(125);
  ProjectXForm.OpenDialog1.FilterIndex:=0;
  ProjectXForm.OpenDialog1.FileName:='';
  if ProjectXForm.OpenDialog1.Execute=true then
    begin
      ListBox1.Items.Clear;
      Kapitelliste:=TStringList.Create;
      Kapitelliste.LoadFromFile(ProjectXForm.OpenDialog1.FileName);
      
      //Mpeg2Schnitt KAP und IfoEdit Format laden
      if ProjectXForm.OpenDialog1.FilterIndex<3 then
        begin
          ListBox1.Items.Add('00:00:00.000');
          for Counter:=0 to Kapitelliste.Count-1 do
            begin
              Kapitelmarke:=StrToFloat(Kapitelliste.Strings[Counter]) / 25;
              if Kapitelliste.Strings[Counter]<>'0' then
                begin
                  Kapitelzeit:=IncSecond(0, trunc(Kapitelmarke));
                  ListBox1.Items.Add(TimeToStr(Kapitelzeit)+'.000');
                end;
            end;
        end;

      //GUI for DVDauthor Format laden
      if ProjectXForm.OpenDialog1.FilterIndex=3 then
        begin
          ListBox1.Items.Add('00:00:00.000');
          for Counter:=0 to Kapitelliste.Count-1 do
            begin
              if Kapitelliste.Strings[Counter]<>'00:00:00.000' then
                begin
                  ListBox1.Items.Add(Kapitelliste.Strings[Counter]);
                end;
            end;
        end;

      Kapitelliste.Free;
    end;
  Kontrollen_freigeben;
end;

end.
