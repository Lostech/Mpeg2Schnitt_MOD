{-----------------------------------------------------------------------------------
Diese Unit ist Teil der MOD Extension (Erweiterung) des Programms Mpeg2Schnitt.

Das Programm Mpeg2Schnitt ist ein einfaches Schnittprogramm (nur harte Schnitte) für
Mpeg2Video-Dateien und Mpeg2- und AC3Ton-Dateien.

Copyright (C) 2003  Martin Dienert
 Homepage: http:www.mdienert.de/mpeg2schnitt/
 E-Mail:   m.dienert@gmx.de

Die MOD Extension erlaubt die Integration von ProjectX
(ProjectX - a free Java based demux utility -> sourceforge.net/projects/project-x/)
im Mpeg2Schnitt Programm.

MOD Extension Copyright (C) 2006  Lostech
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

unit ProjectX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, StdCtrls, ComCtrls, ExtCtrls, JvComponentBase,
  JvCreateProcess, StrUtils, ShellApi, Buttons, JvBrowseFolder, JvSearchFiles,
  JvBaseDlg;

type
  TProjectXForm = class(TForm)
    OpenDialog1: TOpenDialog;
    ListView1: TListView;
    Memo1: TMemo;
    JvCreateProcess1: TJvCreateProcess;
    Timer1: TTimer;
    Panel1: TPanel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button7: TButton;
    JvBrowseForFolderDialog1: TJvBrowseForFolderDialog;
    JvSearchFiles1: TJvSearchFiles;
    Panel3: TPanel;
    Button8: TButton;
    Button9: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure JvCreateProcess1Terminate(Sender: TObject;
      ExitCode: Cardinal);
    procedure JvCreateProcess1Read(Sender: TObject; const S: String;
      const StartsOnNewLine: Boolean);
    procedure JvCreateProcess1RawRead(Sender: TObject; const S: String);
    procedure Memo1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure JvSearchFiles1FindFile(Sender: TObject; const AName: String);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure HomepageLink(Sender: TObject);
  public
    { Public-Deklarationen }
    procedure Start(Sender: TObject);
    procedure ProjectXPfadSetup(Sender: TObject);
    procedure ProjectXAusgabeOrdnerSetup(Sender: TObject);
    procedure ProjectXAusgabeOrdnerAufraeumen(Sender: TObject);
    procedure ProjectXaufrufen(Sender: TObject);
    procedure JavaPfadSetup(Sender: TObject);
    procedure About(Sender: TObject);
    procedure AktualisiereProjectXSprache;
    procedure AutomatischePfadangaben(Sender: TObject);
  end;

  procedure EinstellungenAnzeigen;
  procedure INI_Einstellungen_einlesen;
  procedure INI_Einstellungen_schreiben;
  procedure Kontrollen_freigeben;
  procedure Kontrollen_sperren;
  procedure SprachAuswahl;
  procedure MoveListViewItem(ListView: TListView; ItemFrom, ItemTo: Word);
  function Demux(Files: String; OutputPath: String): Integer;
  function GetFileSize(FileName: String): Int64;
  function LoescheDateien(Pfad: String; Dateiendung: String): Integer;
  function ResString(ResID: Integer): string;
  function ResString2(ResID: Integer): string;
  function SucheDatei(Name: String): String;


{$I MODCopyright.inc}

var
  ProjectXForm: TProjectXForm;
  ProjectXPfad: String;
  ProjectXAusgabeOrdner: String;
  JavaPfad: String;
  ImportPfad: String;
  Start: TDateTime;
  SprachID: Integer;  //0=Deutsch 1000=Englisch
  Abbruch: Boolean;

implementation

uses
  Hauptfenster;

//Text Ressource einbinden (Sprachen)
{$R MODProjectXText.RES}
{$R *.dfm}

procedure TProjectXForm.AktualisiereProjectXSprache;
//alle Bezeichnungen in der gewünschten Sprache darstellen
begin
  //eingestellte Sprache aus "original" Mpeg2Schnitt übernehmen
  SprachAuswahl;

  //Hauptprogramm Titel abändern
  MpegEdit.Caption:=StringReplace(MpegEdit.Caption, 'Mpeg2Schnitt ', 'Mpeg2Schnitt MOD ',[rfReplaceAll, rfIgnoreCase]);
  MpegEdit.Caption:=MpegEdit.Caption+' ('+MODVersion+')';
  Application.Title:=MpegEdit.Caption;

  //dynamisch erzeugte MenüItems im Hauptprogramm übersetzen
  Hauptfenster.PXMenueItem.Caption:=ResString(0);
  Hauptfenster.PXMenueItem2.Caption:=ResString(1);
  Hauptfenster.PXMenueItem3.Caption:=ResString(2);
  Hauptfenster.PXMenueItem4.Caption:=ResString(3);
  Hauptfenster.PXMenueItem5.Caption:=ResString(4);
  Hauptfenster.PXMenueItem6.Caption:=ResString(5);
  Hauptfenster.PXMenueItem7.Caption:=ResString(24);
  Hauptfenster.PXMenueItem8.Caption:=ResString(34);
  Hauptfenster.PXMenueItem9.Caption:=ResString(39);

  //ProjectXFormular übersetzen
  Button3.Caption:=ResString(6);
  Button4.Caption:=ResString(7);
  Button5.Caption:=ResString(8);
  Button6.Caption:=ResString(9);
  Button7.Caption:=ResString(30);
  Button8.Caption:=ResString(40);
  Button9.Caption:=ResString(41);
  ListView1.Columns[0].Caption:=ResString(10);
  ListView1.Columns[1].Caption:=ResString(42);
  ListView1.Columns[2].Caption:=ResString(11);
  ListView1.Columns[3].Caption:=ResString(12);
  Label1.Caption:=ResString(13);
  Label2.Caption:=ResString(14);
  Label3.Caption:=ResString(15);
  Label7.Caption:=ResString(16);
end;

procedure SprachAuswahl;
//eingestellte Sprache aus "original" Mpeg2Schnitt übernehmen
begin
  if Pos('atei',MpegEdit.Datei.Caption)>0 then
    SprachID:=0
  else
    SprachID:=1000;
end;

function ResString(ResID: Integer): string;
//String in der angewählten Sprache aus der Ressource laden
var
  buffer: array[0..255] of Char;
begin
  Loadstring(hinstance,10000+ResID+SprachID, @buffer, 255);
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

procedure Kontrollen_sperren;
//Benutzer Kontrollen sperren
begin
  ProjectXForm.ListView1.Enabled:=false;
  ProjectXForm.Button1.Enabled:=false;
  ProjectXForm.Button2.Enabled:=false;
  ProjectXForm.Button3.Enabled:=false;
  ProjectXForm.Button4.Enabled:=false;
  ProjectXForm.Button5.Enabled:=false;
  ProjectXForm.Button6.Enabled:=false;
  ProjectXForm.Button8.Enabled:=false;
  ProjectXForm.Button9.Enabled:=false;
  ProjectXForm.Panel2.Enabled:=false;
end;

procedure Kontrollen_freigeben;
//Benutzer Kontrollen freigeben
begin
  ProjectXForm.ListView1.Enabled:=true;
  ProjectXForm.Button1.Enabled:=true;
  ProjectXForm.Button2.Enabled:=true;
  ProjectXForm.Button3.Enabled:=true;
  ProjectXForm.Button4.Enabled:=true;
  ProjectXForm.Button5.Enabled:=true;
  ProjectXForm.Button6.Enabled:=true;
  ProjectXForm.Panel2.Enabled:=true;
  //Buttons zum verschieben freigeben wenn Einträge vorhanden
  if ProjectXForm.ListView1.Items.Count>0 then
    begin
      ProjectXForm.Button8.Enabled:=true;
      ProjectXForm.Button9.Enabled:=true;
    end
  else
    begin
      ProjectXForm.Button8.Enabled:=false;
      ProjectXForm.Button9.Enabled:=false;
    end;
end;

function Demux(Files: String; OutputPath: String): Integer;
//Demultiplexing mit ProjectX
begin
  //Abbruch Signalisierung zurücksetzen
  Abbruch:=false;

  //Alle benötigen Angaben vorhanden?
  if (Files='') or (OutputPath='') then
    begin
      ShowMessage(ResString(19));
      Demux:=-1;
      exit;
    end;

  //ProjectX.jar vorhanden?
  if FileExists(ProjectXPfad)=false then
    begin
      ShowMessage(ResString(20));
      Demux:=-1;
      exit;
    end;

  //JAVA Runtime vorhanden?
  if FileExists(JavaPfad)=false then
    begin
      ShowMessage(ResString(21));
      Demux:=-1;
      exit;
    end;
  ProjectXForm.JvCreateProcess1.ApplicationName:=JavaPfad;

  //Slash abschneiden, wenn Rootfolder z.B. "C:\" angegeben wird
  if Length(OutputPath)=3 then
    OutputPath:=LeftStr(OutputPath,2);

  //Demultiplexing starten
  Start:=Time;
  ProjectXForm.Button7.BringToFront;

  //Timer zur Aktualisierung der Log Anzeige starten
  ProjectXForm.Timer1.Enabled:=true;

  //ProjectX Meldungen in Logfenster umleiten
  ProjectXForm.JvCreateProcess1.ConsoleOptions:=[coRedirect];

  //ProjectX Commandline zusammenstellen
  ProjectXForm.JvCreateProcess1.CommandLine:=' -jar "'+ProjectXPfad+'"'+Files+' -out "'+OutputPath+'" -log -ini "'+ExtractFilePath(ProjectXPfad)+'X.ini"';

  //externen Prozess von ProjectX mit der JAVA Runtime starten
  ProjectXForm.JvCreateProcess1.WaitForTerminate:=true;
  ProjectXForm.JvCreateProcess1.Run;
  while (ProjectXForm.JvCreateProcess1.State=psWaiting) and (Abbruch=false) do
    begin
      Application.ProcessMessages;
    end;

  //Sollte externer Prozess z.B. nach Abbruch noch laufen, dann beenden
  if (ProjectXForm.JvCreateProcess1.State=psRunning) or (Abbruch=true) then
    ProjectXForm.JvCreateProcess1.Terminate;

  //Timer zur Aktualisierung der Log Anzeige beenden
  ProjectXForm.Timer1.Enabled:=false;
  Sleep(1000);
  if Abbruch=false then
    Demux:=1
  else
    Demux:=-1;

  //Log speichern
  if FileExists(ExtractFilePath(Application.ExeName)+'ProjectX.log') then
    DeleteFile(ExtractFilePath(Application.ExeName)+'ProjectX.log');
  ProjectXForm.Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName)+'ProjectX.log');

  ProjectXForm.Button7.SendToBack;
end;

function GetFileSize(FileName: String): Int64;
//Dateigröße auslesen auch wenn >4GB
var
  FileStream: TFileStream;

begin
  FileStream:=TFileStream.Create(FileName,fmOpenRead OR fmShareDenyWrite);
  try
  GetFileSize:=FileStream.Size;
  finally
  FileStream.Free;
  end;
end;

procedure TProjectXForm.Start(Sender: TObject);
//ProjectX Fenster anzeigen
begin
  //Pfad zu ProjectX und JAVA Runtime einlesen
  INI_Einstellungen_einlesen;
  if (ProjectXPfad='') or (JavaPfad='') or (FileExists(ProjectXPfad)=false) or (FileExists(JavaPfad)=false) then
    begin
      ShowMessage(ResString(17));
      exit;
    end;

  //Ausgabe Ordner für ProjectX festlegen
  if ProjectXAusgabeOrdner='' then
    begin
      ShowMessage(ResString(18));
      ProjectXAusgabeOrdner:=ExtractFilePath(Application.ExeName);
    end;
  ProjectXForm.ShowModal;
end;

procedure TProjectXForm.ProjectXPfadSetup(Sender: TObject);
//Pfad zur ProjectX.jar einstellen
var
  INI: TIniFile;
  XINI: TStringList;
  Counter: Integer;

begin
  //ProjectX.jar suchen
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  ProjectXForm.OpenDialog1.Title:=ResString(2);
  ProjectXForm.OpenDialog1.Filter:=ResString(22);
  ProjectXForm.OpenDialog1.FilterIndex:=0;
  if ProjectXPfad<>'' then
    ProjectXForm.OpenDialog1.InitialDir:=ProjectXPfad
  else
    ProjectXForm.OpenDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  ProjectXForm.OpenDialog1.FileName:='';
  if ProjectXForm.OpenDialog1.Execute=false then
    exit;
  if FileExists(ProjectXForm.OpenDialog1.FileName)=true then
    ProjectXPfad:=ProjectXForm.OpenDialog1.FileName
  else
    ProjectXPfad:='';
  INI.WriteString('ProjectX','ProjectX_Pfad',ProjectXPfad);
  INI.Free;

  //ProjectX.jar INI umschreiben, so das M2S IDDs bei Umwandlung automatisch erzeugt werden sollen
  XINI:=TStringList.Create;
  if FileExists(ExtractFilePath(ProjectXPfad)+'X.ini')=true then
    XINI.LoadFromFile(ExtractFilePath(ProjectXPfad)+'X.ini');

  //wenn M2S Eintrag bereits vorhanden, dann umschreiben
  for Counter:=0 to XINI.Count-1 do
    begin
      if Pos('createM2sIndex',XINI.Strings[Counter])>0 then
        begin
          XINI.Strings[Counter]:='ExternPanel.createM2sIndex=1';
          break;
        end;
    end;
  //wenn M2S Eintrag nicht vorhanden, aber ExternPanel Abschnitt vorhanden, dann einfügen
  if Counter>=XINI.Count then
    begin
      for Counter:=0 to XINI.Count-1 do
        begin
          if Pos('# ExternPanel',XINI.Strings[Counter])>0 then
            begin
              XINI.Insert(Counter+1,'ExternPanel.createM2sIndex=1');
              break;
            end;
        end;
    end;
  //wenn M2S Eintrag und ExternPanel Abschnitt nicht vorhanden, dann neu erzeugen
  if Counter>=XINI.Count then
    begin
      XINI.Add('');
      XINI.Add('# ExternPanel');
      XINI.Add('ExternPanel.createM2sIndex=1');
    end;
    
  //neue X.ini speichern
  XINI.SaveToFile(ExtractFilePath(ProjectXPfad)+'X.ini');
  XINI.Free;
end;

procedure TProjectXForm.ProjectXAusgabeOrdnerSetup(Sender: TObject);
//Pfad zum PROJECTX Ausgabe Ordner einstellen
var
  INI: TIniFile;

begin
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');

  ProjectXForm.JvBrowseForFolderDialog1.Title:=ResString(3);
  if ProjectXAusgabeOrdner<>'' then
    ProjectXForm.JvBrowseForFolderDialog1.Directory:=ProjectXAusgabeOrdner
  else
    ProjectXForm.JvBrowseForFolderDialog1.Directory:=ExtractFilePath(Application.ExeName);
  if ProjectXForm.JvBrowseForFolderDialog1.Execute=false then
    exit;
  ProjectXAusgabeOrdner:=ProjectXForm.JvBrowseForFolderDialog1.Directory;
  INI.WriteString('ProjectX','ProjectX_Ausgabe_Ordner',ProjectXAusgabeOrdner);
  INI.Free;
end;

procedure TProjectXForm.ProjectXAusgabeOrdnerAufraeumen(Sender: TObject);
//PROJECTX Ausgabe Ordner aufräumen
var
  DateiAnzahl: Integer;

begin
  //ProjectX Ausgabe Ordner einlesen und überprüfen
  INI_Einstellungen_einlesen;
  if ProjectXAusgabeOrdner='' then
    begin
      ShowMessage(ResString(18));
      ProjectXAusgabeOrdner:=ExtractFilePath(Application.ExeName);
    end;

  //Sicherheitsabfrage
  if MessageBox(ProjectXForm.Handle,PChar(ResString(25)+#13+#10+ResString(33)),PChar(MpegEdit.Caption),MB_OKCANCEL)<>IDOK then
    begin
      MpegEdit.SetFocus;
      exit;
    end;

  //alle Dateien im ProjectX Ausgabe Ordner abhängig von Dateiendung löschen
  DateiAnzahl:=LoescheDateien(ProjectXAusgabeOrdner,'mpv');
  DateiAnzahl:=DateiAnzahl+LoescheDateien(ProjectXAusgabeOrdner,'m2v');
  DateiAnzahl:=DateiAnzahl+LoescheDateien(ProjectXAusgabeOrdner,'mpa');
  DateiAnzahl:=DateiAnzahl+LoescheDateien(ProjectXAusgabeOrdner,'mp2');
  DateiAnzahl:=DateiAnzahl+LoescheDateien(ProjectXAusgabeOrdner,'ac3');
  DateiAnzahl:=DateiAnzahl+LoescheDateien(ProjectXAusgabeOrdner,'idd');
  DateiAnzahl:=DateiAnzahl+LoescheDateien(ProjectXAusgabeOrdner,'txt');

  //Lösch Ergebnis melden
  if DateiAnzahl=0 then
    ShowMessage(ResString(32))
  else
    ShowMessage(IntToStr(DateiAnzahl)+ResString(31));
  MpegEdit.SetFocus;
end;

function LoescheDateien(Pfad: String; Dateiendung: String): Integer;
//Dateien eines bestimmten Typs in einem Ordner löschen
var
  SR : TSearchRec;
  DateiAnzahl: Integer;

begin
  //Dateien anhand von Dateiendung im angegebenem Ordner suchen und dann löschen
  SR.Name:='';
  DateiAnzahl:=0;
  LoescheDateien:=0;
  Kontrollen_sperren;
  if FindFirst(Pfad+'\*.*'+Dateiendung,faAnyFile,SR)<>0 then
    begin
      Kontrollen_freigeben;
      exit;
    end;
  if FileExists(Pfad+'\'+SR.Name) then
    begin
      DeleteFile(Pfad+'\'+SR.Name);
      Inc(DateiAnzahl);
    end;
  while FindNext(SR)=0 do
    begin
      if FileExists(Pfad+'\'+SR.Name) then
        begin
          DeleteFile(Pfad+'\'+SR.Name);
          Inc(DateiAnzahl);
        end;
    end;
  FindClose(SR);
  LoescheDateien:=DateiAnzahl;
  Kontrollen_freigeben;
end;

procedure TProjectXForm.ProjectXaufrufen(Sender: TObject);
//ProjectX aufrufen
begin
  //INI neu einlesen, um Pfadanagabe zu erhalten
  INI_Einstellungen_einlesen;

  //ProjectX extern öffnen
  if (FileExists(JavaPfad)=true) and (FileExists(ProjectXPfad)=true) then
    ShellExecute(ProjectXForm.Handle,'open',PChar(JavaPfad),PChar(' -jar "'+ProjectXPfad+'"'),PChar(ExtractFilePath(ProjectXPfad)), SW_SHOWNORMAL)
  else
    begin
      ShowMessage(ResString(17));
      MpegEdit.SetFocus;
    end;
end;

procedure TProjectXForm.JavaPfadSetup(Sender: TObject);
//Pfad zur JAVA.EXE einstellen
var
  INI: TIniFile;

begin
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  ProjectXForm.OpenDialog1.Title:=ResString(4);
  ProjectXForm.OpenDialog1.Filter:=ResString(23);
  ProjectXForm.OpenDialog1.FilterIndex:=0;
  if JavaPfad<>'' then
    ProjectXForm.OpenDialog1.InitialDir:=JavaPfad
  else
    ProjectXForm.OpenDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  ProjectXForm.OpenDialog1.FileName:='';
  if ProjectXForm.OpenDialog1.Execute=false then
    exit;
  if FileExists(ProjectXForm.OpenDialog1.FileName)=true then
    JavaPfad:=ProjectXForm.OpenDialog1.FileName
  else
    JavaPfad:='';
  INI.WriteString('ProjectX','Java_Pfad',JavaPfad);
  INI.Free;
end;

procedure INI_Einstellungen_einlesen;
//Einstellungen aus INI Datei einlesen
var
  INI: TIniFile;

begin
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  ProjectXPfad:=INI.ReadString('ProjectX','ProjectX_Pfad','');
  ProjectXAusgabeOrdner:=INI.ReadString('ProjectX','ProjectX_Ausgabe_Ordner','');
  JavaPfad:=INI.ReadString('ProjectX','Java_Pfad','');
  ImportPfad:=INI.ReadString('ProjectX','Import_Pfad','');
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
  INI.WriteString('ProjectX','Import_Pfad',ImportPfad);
  INI.Free;
end;

procedure TProjectXForm.FormCreate(Sender: TObject);
//ProjectX Formular erzeugen
begin
  //Eigenschaften von Formular und sonstigen Komponenten definieren
  ProjectXForm.Icon:=MpegEdit.Icon;
  Memo1.Top:=ListView1.Top;
  Memo1.Left:=ListView1.Left;
  Memo1.Width:=ListView1.Width;
  Memo1.Height:=ListView1.Height;
  Memo1.DoubleBuffered:=true;
  Label4.OnClick:=Label1Click;
  Label5.OnClick:=Label2Click;
  Label6.OnClick:=Label3Click;

  //Sprache definiert setzen
  AktualisiereProjectXSprache;
  ProjectXForm.Caption:='ProjectX '+Button4.Caption;
end;

procedure TProjectXForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
//aufräumen
begin
  INI_Einstellungen_schreiben;
  ListView1.Items.Clear;
end;

procedure TProjectXForm.Button3Click(Sender: TObject);
//ListView aufräumen
begin
  ListView1.Items.Clear;
end;

procedure TProjectXForm.Button6Click(Sender: TObject);
//ProjectX Form schließen
begin
  ProjectXForm.Close;
end;

procedure TProjectXForm.Button4Click(Sender: TObject);
//ausgewählte Dateien mit ProjectX umwandeln und in Mpeg2Schnitt laden
var
  ImportDateien: TStringList;
  DateiNamenListe: TStringList;
  Counter: Integer;
  Ergebnis: Integer;
  ProjectXDateien: String;

begin
  //Import vorbereiten
  Kontrollen_sperren;
  Memo1.BringToFront;
  ProjectXDateien:='';
  ImportDateien:=TStringList.Create;
  DateiNamenListe:=TStringList.Create;

  for Counter:=0 to ListView1.Items.Count-1 do
    begin
      ProjectXDateien:=ProjectXDateien+' "'+ListView1.Items.Item[Counter].SubItems.Strings[1]+ListView1.Items.Item[Counter].Caption+'"';
      ImportDateien.Add(ListView1.Items.Item[Counter].Caption);
    end;
  Memo1.Clear;

  //ProjectX Umwandlung starten und Dateien in M2S laden
  Ergebnis:=Demux(ProjectXDateien,ProjectXAusgabeOrdner);
  if Ergebnis>0 then
    begin
      //erst die Video Datei (*.mpv/*.m2v) laden
      for Counter:=0 to ImportDateien.Count-1 do
        begin
          if FileExists(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.mpv'))=true then
            begin
              DateiNamenListe.Add(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.mpv'));
              break;
            end;
          if FileExists(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.m2v'))=true then
            begin
              DateiNamenListe.Add(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.m2v'));
              break;
            end;
        end;

      //falls keine Video Datei geladen wurde dann versuchen eine Audio Datei (*.mp2/*.mpa/*.ac3) zu laden
      if DateiNamenListe.Count=0 then
        begin
          for Counter:=0 to ImportDateien.Count-1 do
            begin
              if FileExists(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.mp2'))=true then
                begin
                  DateiNamenListe.Add(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.mp2'));
                  break;
                end;
              if FileExists(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.mpa'))=true then
                begin
                  DateiNamenListe.Add(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.mpa'));
                  break;
                end;
              if FileExists(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.ac3'))=true then
                begin
                  DateiNamenListe.Add(ChangeFileExt(ProjectXAusgabeOrdner+'\'+ImportDateien.Strings[Counter],'.ac3'));
                  break;
                end;
            end;
        end;

      //Video Datei in Mpeg2Schnitt laden (Audio Dateien werden automatisch geladen)
      if DateiNamenListe<>NIL then
        begin
          DateiNamenListe.Sort;
          MpegEdit.Dateilisteeinfuegen(DateiNamenListe);
          MpegEdit.Dateilisteaktualisieren(MpegEdit.Dateien.Selected,false);
          MpegEdit.SchiebereglerPosition_setzen(0);
          MpegEdit.Fortschrittsfensterverbergen;
          DateiNamenListe.Free;
        end;

      //Aufräumen
      if ImportDateien<>NIL then
        ImportDateien.Free;
      Memo1.SendToBack;
      Kontrollen_freigeben;
      ProjectXForm.Close;
      exit;
    end
  else
    begin
      //bei Bedarf zusätzliches Fehlerhandling hier möglich
      ShowMessage(ResString(26));
    end;

  //Aufräumen
  if ImportDateien<>NIL then
    ImportDateien.Free;
  Memo1.SendToBack;
  Kontrollen_freigeben;
end;

procedure TProjectXForm.ListView1Compare(Sender: TObject; Item1,Item2: TListItem; Data: Integer; var Compare: Integer);
//ListView nach Dateigröße sortieren
begin
  Compare := StrToInt(StringReplace(Item1.SubItems[2],' MB','',[rfReplaceAll, rfIgnoreCase])) - StrToInt(StringReplace(Item1.SubItems[2],' MB','',[rfReplaceAll, rfIgnoreCase]));
end;

procedure TProjectXForm.JvCreateProcess1Terminate(Sender: TObject; ExitCode: Cardinal);
//System Meldungen abarbeiten (wichtig, damit PX in Shell Schleife nicht einfriert)
begin
  Application.ProcessMessages;
end;

procedure TProjectXForm.JvCreateProcess1Read(Sender: TObject; const S: String; const StartsOnNewLine: Boolean);
//System Meldungen abarbeiten (wichtig, damit PX in Shell Schleife nicht einfriert)
begin
  Application.ProcessMessages;
end;

procedure TProjectXForm.JvCreateProcess1RawRead(Sender: TObject; const S: String);
//ProjectX Konsolenausgabe filtern
var
  buffer: String;

begin
  Application.ProcessMessages;
  if S='' then exit;
  buffer:=S;
  buffer:=StringReplace(buffer,#13+#10+#10,#10,[rfReplaceAll, rfIgnoreCase]);
  buffer:=StringReplace(buffer,#13,'',[rfReplaceAll, rfIgnoreCase]);
  buffer:=StringReplace(buffer,'%','%'+#10,[rfReplaceAll, rfIgnoreCase]);
  buffer:=StringReplace(buffer,#10,#13+#10,[rfReplaceAll, rfIgnoreCase]);
  Memo1.Text:=Memo1.Text+buffer;
end;

procedure TProjectXForm.Memo1Change(Sender: TObject);
//Log Ausgabe von ProjectX in Memo anzeigen
begin
  if (Pos('%',Memo1.Lines.ValueFromIndex[Memo1.Lines.Count-2])>0) then
    Memo1.Lines.Delete(Memo1.Lines.Count-2);
  if (Pos('100%',Memo1.Text)>0) then
    Memo1.Text:=StringReplace(Memo1.Text,#13+#10+'100%','',[rfReplaceAll, rfIgnoreCase]);
  SendMessage(Memo1.Handle,WM_VSCROLL,SB_BOTTOM,0);
  HideCaret(Memo1.Handle);
  Application.ProcessMessages;
end;

procedure TProjectXForm.Button5Click(Sender: TObject);
//ausgewählte Dateien mit ProjectX umwandeln und in Mpeg2Schnitt laden
var
  Counter: Integer;
  Ergebnis: Integer;
  ProjectXDateien: String;

begin
  //Import vorbereiten
  Kontrollen_sperren;
  Memo1.BringToFront;
  ProjectXDateien:='';
  for Counter:=0 to ListView1.Items.Count-1 do
    begin
      ProjectXDateien:=ProjectXDateien+' "'+ListView1.Items.Item[Counter].SubItems.Strings[1]+ListView1.Items.Item[Counter].Caption+'"';
    end;
  Memo1.Clear;

  //ProjectX Umwandlung starten und Dateien in M2S laden
  Ergebnis:=Demux(ProjectXDateien,ProjectXAusgabeOrdner);
  if Ergebnis>0 then
    begin
      ShowMessage(ResString(27))
    end
  else
    begin
      //bei Bedarf zusätzliches Fehlerhandling hier möglich
      ShowMessage(ResString(26));
    end;

  //Aufräumen
  Memo1.SendToBack;
  Kontrollen_freigeben;
end;

procedure TProjectXForm.About(Sender: TObject);
//MOD Versions- und Copyright Info
var
  AboutForm: TForm;
  AboutMemo: TMemo;
  URLLabel: TLabel;

begin
  //About Formular dynamisch erzeugen
  AboutForm:=TForm.Create(MpegEdit);
  AboutForm.BorderIcons:=[biSystemMenu];
  AboutForm.BorderStyle:=bsToolWindow;
  AboutForm.Position:=poMainFormCenter;
  AboutForm.Caption:=MpegEdit.Caption;
  AboutForm.Height:=100;
  AboutForm.Width:=300;

  //Homepage Label dynamisch erzeugen
  URLLabel:=TLabel.Create(self);
  URLLabel.Parent:=AboutForm;
  URLLabel.AutoSize:=false;
  URLLabel.Alignment:=taCenter;
  URLLabel.Left:=0;
  URLLabel.Height:=16;
  URLLabel.Top:=55;
  URLLabel.Width:=300;
  URLLabel.Caption:=HomepageURL;
  URLLabel.OnClick:=HomepageLink;
  URLLabel.Font.Name:='Tahoma';
  URLLabel.Font.Size:=10;
  URLLabel.Font.Color:=clBlue;
  URLLabel.Font.Style:=[fsUnderline];
  URLLabel.Cursor:=crHandPoint;
  URLLabel.Transparent:=true;
  URLLabel.Visible:=true;

  //Infotext Fenster dynamisch erzeugen
  AboutMemo:=TMemo.Create(self);
  AboutMemo.Parent:=AboutForm;
  AboutMemo.Top:=0;
  AboutMemo.Left:=0;
  AboutMemo.Height:=URLLabel.Top;
  AboutMemo.Width:=AboutForm.Width;
  AboutMemo.Alignment:=taCenter;
  AboutMemo.Lines.Add(MODName);
  AboutMemo.Lines.Add('Version '+MODVersion);
  AboutMemo.Lines.Add(MODCopyright);
  AboutMemo.Lines.Add('');
  HideCaret(AboutMemo.Handle);

  //About Form modal anzeigen
  AboutForm.ShowModal;

  //dynamisch erzeugte Komponenten freigeben
  URLLabel.Free;
  AboutMemo.Free;
  AboutForm.Free;
end;

procedure TProjectXForm.HomepageLink(Sender: TObject);
//Homepage Link aufrufen
begin
  ShellExecute(ProjectXForm.Handle,'open',PChar(HomepageURL),nil,nil, SW_SHOWNORMAL);
end;

procedure TProjectXForm.Button1Click(Sender: TObject);
//Datei zur ProjectX Jobliste hinzufügen
var
  ListItem: TListItem;

begin
  //Datei auswählen und überprüfen
  Kontrollen_sperren;
  OpenDialog1.Title:=ResString(28);
  OpenDialog1.Filter:=ResString(29);
  if ImportPfad<>'' then
    OpenDialog1.InitialDir:=ImportPfad
  else
    OpenDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  OpenDialog1.FileName:='';
  if OpenDialog1.Execute=false then
    begin
      Kontrollen_freigeben;
      exit;
    end;
  ImportPfad:=ExtractFilePath(OpenDialog1.FileName);
  if FileExists(OpenDialog1.FileName)=false then
    begin
      Kontrollen_freigeben;
      exit;
    end;

  //Datei in ListView speichern
  ListItem:=ListView1.Items.Add;
  ListItem.Caption:=ExtractFileName(OpenDialog1.FileName);
  ListItem.SubItems.Add(StringReplace(ExtractFileExt(OpenDialog1.FileName),'.','',[rfReplaceAll, rfIgnoreCase]));
  ListItem.SubItems.Add(ExtractFilePath(OpenDialog1.FileName));
  ListItem.SubItems.Add(IntToStr(GetFileSize(OpenDialog1.FileName) div 1048576)+' MB');

  //sortieren, damit größte Datei (meist Video) nach oben gelangt und später als erstes in PX geladen wird
  ListView1.AlphaSort;
  Kontrollen_freigeben;
end;

procedure TProjectXForm.Button2Click(Sender: TObject);
//ListView Eintrag löschen
begin
  Kontrollen_sperren;
  //Eintrag löschen
  if ListView1.Selected<>NIL then
    begin
      ListView1.Selected.Delete;
    end;
  Kontrollen_freigeben;
end;

procedure TProjectXForm.FormShow(Sender: TObject);
//aktuelle Einstellungen anzeigen wenn ProjectX Formular aufgerufen wird
begin
  EinstellungenAnzeigen;
end;

procedure EinstellungenAnzeigen;
//Anzeige der Einstellungen aktualisieren
begin
  ProjectXForm.Label4.Caption:=ProjectXPfad;
  ProjectXForm.Label5.Caption:=JavaPfad;
  ProjectXForm.Label6.Caption:=ProjectXAusgabeOrdner;
end;

procedure TProjectXForm.Label1Click(Sender: TObject);
//ProjectX Pfad einstellen
begin
  ProjectXPfadSetup(Sender);
  EinstellungenAnzeigen
end;

procedure TProjectXForm.Label2Click(Sender: TObject);
//JAVA Pfad einstellen
begin
  JavaPfadSetup(Sender);
  EinstellungenAnzeigen
end;

procedure TProjectXForm.Label3Click(Sender: TObject);
//ProjectX Ausgabe Ordner festlegen
begin
  ProjectXAusgabeOrdnerSetup(Sender);
  EinstellungenAnzeigen
end;

procedure TProjectXForm.Button7Click(Sender: TObject);
//Demux Funktion vorzeitig abbrechen
begin
  Abbruch:=true;
end;

procedure TProjectXForm.AutomatischePfadangaben(Sender: TObject);
//ProjectX und JAVA Pfadangaben automatisch suchen lassen
var
  Pfad: String;
  INI: TIniFile;
  Titel: String;

begin
  //wenn keine Mpeg2Schnitt INI Datei vorhanden ist, dann abbrechen
  if FileExists(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini')=false then
    exit;

  //Sicherheitsabfrage
  if MessageBox(ProjectXForm.Handle,PChar(ResString(35)+#13+#10+ResString(36)),PChar(MpegEdit.Caption),MB_OKCANCEL)<>IDOK then
    begin
      MpegEdit.SetFocus;
      exit;
    end;

  //Vorbereitung
  INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Mpeg2Schnitt.ini');
  Titel:=MpegEdit.Caption;

  //ProjectX suchen
  Pfad:=SucheDatei('PROJECTX.JAR');
  if (Pfad<>'') and (AnsiPos('PROJECTX.JAR',UpperCase(Pfad))>0) then
    begin
      ProjectXPfad:=Pfad;
      INI.WriteString('ProjectX','ProjectX_Pfad',ProjectXPfad);
    end
  else
    ShowMessage(ResString(20));

  //JAVA Runtime suchen
  Pfad:=SucheDatei('JAVA.EXE');
  if (Pfad<>'') and (AnsiPos('JAVA.EXE',UpperCase(Pfad))>0) then
    begin
      JavaPfad:=Pfad;
      INI.WriteString('ProjectX','Java_Pfad',JavaPfad);
    end
  else
    ShowMessage(ResString(21));

  //aufräumen
  INI.Free;
  MpegEdit.Caption:=Titel;
end;

function SucheDatei(Name: String): String;
//nach Datei suchen
begin
  //Bedienung sperren
  ProjectX.Kontrollen_sperren;

  //Suchvorgang konfigurieren und starten
  ProjectXForm.JvSearchFiles1.Files.Clear;
  ProjectXForm.JvSearchFiles1.Directories.Clear;
  ProjectXForm.JvSearchFiles1.RootDirectory:='C:\';
  ProjectXForm.JvSearchFiles1.DirOption:=doIncludeSubDirs;
  ProjectXForm.JvSearchFiles1.FileParams.FileMask:=Name;
  ProjectXForm.JvSearchFiles1.Search;

  //letzte gefundene Datei als Ergebnis liefern
  if ProjectXForm.JvSearchFiles1.Files.Count>0 then
    SucheDatei:=ProjectXForm.JvSearchFiles1.Files.Strings[ProjectXForm.JvSearchFiles1.Files.Count-1];

  //Bedienung wieder freigeben
  ProjectX.Kontrollen_freigeben;
end;

procedure TProjectXForm.JvSearchFiles1FindFile(Sender: TObject;
  const AName: String);
//Datei im Suchlauf gefunden
begin
  //Systemmeldungen abarbeiten
  Application.ProcessMessages;

  //Abbrechen beim ersten Fund der gesuchten Datei ("*.lnk" Links werden ignoriert) 
  if (AnsiPos(UpperCase(JvSearchFiles1.FileParams.FileMask),UpperCase(AName))>0) and (AnsiPos('.LNK',UpperCase(AName))=0) then
    JvSearchFiles1.Abort;

  //Status Ansicht aktualisieren (mangels Statuszeile wird die Titelleiste des Hauptprogrammes verwendet)
  if AnsiPos('JAR',UpperCase(JvSearchFiles1.FileParams.FileMask))>0 then
    MpegEdit.Caption:=ResString(37)+AName;
  if AnsiPos('JAVA',UpperCase(JvSearchFiles1.FileParams.FileMask))>0 then
    MpegEdit.Caption:=ResString(38)+AName;
end;

procedure MoveListViewItem(ListView: TListView; ItemFrom, ItemTo: Word);
//ListView Reihen verschieben
var
  Source, Target: TListItem;

begin
  ListView.Items.BeginUpdate;
  try
    Source:=ListView.Items[ItemFrom];
    Target:=ListView.Items.Insert(ItemTo);
    Target.Assign(Source);
    Source.Free;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TProjectXForm.Button8Click(Sender: TObject);
//Eintrag nach oben schieben
var
  Reihe: Integer;

begin
  Reihe:=ListView1.Selected.Index;
  if Reihe>0 then
    begin
      MoveListViewItem(ListView1, Reihe, Reihe-1);
      ListView1.Items[Reihe-1].Selected:=true;
      ListView1.Items[Reihe-1].Focused:=true;
      ListView1.SetFocus;
    end;
end;

procedure TProjectXForm.Button9Click(Sender: TObject);
//Eintrag nach unten schieben
var
  Reihe: Integer;

begin
  Reihe:=ListView1.Selected.Index;
  if Reihe<ListView1.Items.Count-1 then
    begin
      MoveListViewItem(ListView1, Reihe+1, Reihe);
      ListView1.Items[Reihe+1].Selected:=true;
      ListView1.Items[Reihe+1].Focused:=true;
      ListView1.SetFocus;
    end;
end;

end.
