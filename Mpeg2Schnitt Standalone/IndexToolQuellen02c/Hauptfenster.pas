{----------------------------------------------------------------------------------------------
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

unit Hauptfenster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, IniFiles, Mpeg2Unit, Ueber,
  Grids, ComCtrls, WinEnde;

type
  TIndexTool = class(TForm)
    Hauptmenue: TMainMenu;
    Datei: TMenuItem;
    Dateiladen: TMenuItem;
    Ende: TMenuItem;
    Tastenpanel: TPanel;
    Start: TBitBtn;
    Abbrechen: TBitBtn;
    Dateiladendialog: TOpenDialog;
    Ueber: TMenuItem;
    DateienGrid: TStringGrid;
    Gesamtgroesse_: TLabel;
    Gesamtgroesse: TLabel;
    MenueDateienfenster: TPopupMenu;
    Dateihinzufuegen: TMenuItem;
    Dateientfernen: TMenuItem;
    FortschrittDatei: TProgressBar;
    Fortschrittgesamt: TProgressBar;
    Ausschalten: TCheckBox;
    aktDateigroesse_: TLabel;
    aktDateigroesse: TLabel;
    Gesamtzeit_: TLabel;
    GesamtzeitDatei: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Restzeit: TLabel;
    RestzeitDatei: TLabel;
    Zeit_: TLabel;
    ZeitDatei: TLabel;
    Zeit__: TLabel;
    ZeitGesamt: TLabel;
    Restzeit__: TLabel;
    RestzeitGesamt: TLabel;
    Gesamtzeit__: TLabel;
    GesamtzeitGesamt: TLabel;
    Fenster_schliessen: TCheckBox;
    procedure DateiladenClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure AbbrechenClick(Sender: TObject);
    procedure UeberClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DateientfernenClick(Sender: TObject);
  private
    { Private-Deklarationen }
    DateiendungenVideo : STRING;
    DateiendungenAudio : STRING;
    StandardEndungenVideo : STRING;
    StandardEndungenAudio : STRING;
    VideoAudioVerzeichnis : STRING;
    ZielVerzeichnis : STRING;
    ProjektVerzeichnis : STRING;
    AktuelleDateiGroesse : Int64;
    DateienGesamtGroesse : Int64;
    PosGesamtAnfang : Integer;
    AnfangszeitDatei : TDateTime;
    AnfangszeitGesamt : TDateTime;
    Anhalten : Boolean;
    Laeuft : Boolean;
    FUNCTION  DateiinListe(Dateiname: STRING): Boolean;
    PROCEDURE Zeilefuellen(Dateiart, Dateiname: STRING);
    PROCEDURE Zellenfuellen(Dateien: TStrings);
    PROCEDURE Zeilenentfernen(Anfang, Ende: Integer);
    FUNCTION Fortschrittsanzeige(Fortschritt: Integer): Boolean;
  public
    { Public-Deklarationen }
  end;

var
  IndexTool: TIndexTool;

implementation

{$R *.dfm}

FUNCTION Dateigroesse(Dateiname: STRING): Int64;

VAR DateiHandle : Integer;
    Offset : Int64;

BEGIN
  Offset := 0;
  DateiHandle := FileOpen(Dateiname, fmOpenRead OR fmShareDenyNone);
  IF DateiHandle > - 1 THEN
  BEGIN
    Result := FileSeek(DateiHandle, Offset, 2);
    FileClose(DateiHandle);
  END  
  ELSE
    Result := - 1;
END;

FUNCTION GroessezuStr(Groesse: Int64): STRING;

VAR GroesseReal : Real;

BEGIN
  GroesseReal := Groesse / (1024 * 1024);
  Str(GroesseReal :2:2, Result);
  Result := Result + ' MB';
END;

FUNCTION TIndexTool.DateiinListe(Dateiname: STRING): Boolean;

VAR I : Integer;

BEGIN
  Result := False;
  FOR I := 0 TO DateienGrid.RowCount -1 DO
  BEGIN
    IF UpperCase(DateienGrid.Cells[1, I]) = UpperCase(Dateiname) THEN
      Result := True;
  END;
END;


PROCEDURE TIndexTool.Zeilefuellen(Dateiart, Dateiname: STRING);

VAR GroesseInt : Int64;

BEGIN
  IF FileExists(Dateiname) AND (NOT DateiinListe(Dateiname)) THEN
  BEGIN
    IF DateienGrid.Cells[0, DateienGrid.RowCount - 1] <> '' THEN
      DateienGrid.RowCount := DateienGrid.RowCount + 1;
    DateienGrid.Cells[0, DateienGrid.RowCount - 1] := Dateiart;
    DateienGrid.Cells[1, DateienGrid.RowCount - 1] := Dateiname;
    GroesseInt := Dateigroesse(Dateiname);
    DateienGrid.Cells[2, DateienGrid.RowCount - 1] := GroessezuStr(GroesseInt);
    DateienGesamtGroesse := DateienGesamtGroesse + GroesseInt;
    Gesamtgroesse.Caption := GroessezuStr(DateienGesamtGroesse);
  END;
END;

PROCEDURE TIndexTool.Zellenfuellen(Dateien: TStrings);

VAR I : Integer;
    Text : STRING;

BEGIN
  FOR I := 0 TO Dateien.Count -1 DO
  BEGIN
    IF Pos(ExtractFileExt(Dateien[I]), DateiendungenVideo) > 0 THEN
    BEGIN
      Zeilefuellen('Videodatei', Dateien[I]);
    END
    ELSE
    BEGIN
      IF Pos(ExtractFileExt(Dateien[I]), DateiendungenAudio) > 0 THEN
      BEGIN
        Zeilefuellen('Audiodatei', Dateien[I]);
      END
      ELSE
      BEGIN
        IF Text <> '' THEN
          Text := Text + Chr(13);
        Text := Text + 'Der Dateityp ' + Dateien[I] + ' wird nicht unterstützt.';
      END;
    END;
  END;
  IF Text <> '' THEN
    Showmessage(Text);
END;

PROCEDURE TIndexTool.Zeilenentfernen(Anfang, Ende: Integer);

VAR I : Integer;
    Anzahl : Integer;
    Groesse : Int64;

BEGIN
  FOR I := Anfang TO Ende DO
  BEGIN
    Groesse := Dateigroesse(DateienGrid.Cells[1, I]);
    IF Groesse > 0 THEN
      DateienGesamtGroesse := DateienGesamtGroesse - Groesse;
  END;    
  Anzahl := DateienGrid.RowCount - (Ende + 1);
  FOR I := 0 TO Anzahl - 1 DO
  BEGIN
    DateienGrid.Rows[Anfang + I] := DateienGrid.Rows[Ende + I + 1];
  END;
  IF DateienGrid.RowCount - (Ende - Anfang + 1) < 1 THEN
  BEGIN
    DateienGrid.Cells[0, 0] := '';
    DateienGrid.Cells[1, 0] := '';
    DateienGrid.Cells[2, 0] := '';
  END;
  DateienGrid.RowCount := DateienGrid.RowCount - (Ende - Anfang + 1);
  Gesamtgroesse.Caption := GroessezuStr(DateienGesamtGroesse);
END;

FUNCTION TIndexTool.Fortschrittsanzeige(Fortschritt: Integer): Boolean;

VAR aktuelleZeit,
    gesamteZeit : TDateTime;

FUNCTION ZeitzuStr(Zeit: TDateTime): STRING;
BEGIN

END;

BEGIN
  FortschrittDatei.Position := Fortschritt;
  aktuelleZeit := Time - AnfangszeitDatei;
  ZeitDatei.Caption := FormatDateTime('hh:nn:ss', aktuelleZeit);
  IF Fortschritt = 0 THEN
    gesamteZeit := 0
  ELSE
    gesamteZeit := aktuelleZeit * 100 / Fortschritt;
  GesamtzeitDatei.Caption := FormatDateTime('hh:nn:ss', gesamteZeit);
  RestzeitDatei.Caption := FormatDateTime('hh:nn:ss', gesamteZeit - aktuelleZeit);
  FortschrittDatei.Update;
  Fortschrittgesamt.Position := PosGesamtAnfang + Round(Fortschritt * AktuelleDateiGroesse / DateienGesamtGroesse);
  aktuelleZeit := Time - AnfangszeitGesamt;
  ZeitGesamt.Caption := FormatDateTime('hh:nn:ss', aktuelleZeit);
  IF Fortschrittgesamt.Position = 0 THEN
    gesamteZeit := 0
  ELSE
    gesamteZeit := aktuelleZeit * 100 / Fortschrittgesamt.Position;
  GesamtzeitGesamt.Caption := FormatDateTime('hh:nn:ss', gesamteZeit);
  RestzeitGesamt.Caption := FormatDateTime('hh:nn:ss', gesamteZeit - aktuelleZeit);
  Fortschrittgesamt.Update;
  Application.ProcessMessages;
  Result := Anhalten;
//  Anhalten := False;
END;

procedure TIndexTool.FormShow(Sender: TObject);

VAR IniFile : TIniFile;
    I : Integer;
    DateiNamenListe : TStringList;

begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\Mpeg2Schnitt.ini');
  DateiendungenVideo := IniFile.ReadString('Allgemein', 'Videodateiendungen', 'Mpeg-Video|*.mpv;*.m2v');
  DateiendungenAudio := IniFile.ReadString('Allgemein', 'Audiodateiendungen', 'Mpeg-Audio|*.mp2;*.mpa;*.ac3');
  StandardEndungenVideo := IniFile.ReadString('Allgemein', 'VideoStandardendungen', '.mpv');
  StandardEndungenAudio := IniFile.ReadString('Allgemein', 'AudioStandardendungen', '.mp2');
  VideoAudioVerzeichnis := IniFile.ReadString('Allgemein', 'VideoAudioVerzeichnis', '');
  ZielVerzeichnis := IniFile.ReadString('Allgemein', 'ZielVerzeichnis', '');
  ProjektVerzeichnis := IniFile.ReadString('Allgemein', 'ProjektVerzeichnis', '');
//  VideoAudioVerzeichnisspeichern := IniFile.ReadBool('Allgemein', 'VideoAudioVerzeichnisspeichern', True);
//  ZielVerzeichnisspeichern := IniFile.ReadBool('Allgemein', 'ZielVerzeichnisspeichern', True);
//  ProjektVerzeichnisspeichern := IniFile.ReadBool('Allgemein', 'ProjektVerzeichnisspeichern', True);
  IniFile.Free;
  IF ParamCount > 0 THEN
  BEGIN
    DateiNamenListe := TStringList.Create;
    FOR I := 1 TO ParamCount DO
    BEGIN
      DateiNamenListe.Add(ParamStr(I));
    END;
    Zellenfuellen(DateiNamenListe);
    DateiNamenListe.Free;
  END;
  Caption := 'IndexTool       Version ' + Versionsnr;
end;

procedure TIndexTool.DateiladenClick(Sender: TObject);

VAR DateiNamenListe : TStringList;

begin
  Text := '';
  Dateiladendialog.Title := 'Mpeg2 Videodatei öffnen';
  Dateiladendialog.Filter := 'Video/Audiodateien' +
                             Copy(DateiendungenVideo, Pos('|', DateiendungenVideo), Length(DateiendungenVideo)) + ';' +
                             Copy(DateiendungenAudio, Pos('|', DateiendungenAudio) + 1, Length(DateiendungenAudio));
  Dateiladendialog.DefaultExt := StandardEndungenVideo;
  Dateiladendialog.FileName := '';
  Dateiladendialog.InitialDir := VideoAudioVerzeichnis;
  IF Dateiladendialog.Execute THEN
  BEGIN
    DateiNamenListe := TStringList.Create;
    DateiNamenListe.Assign(Dateiladendialog.Files);
    DateiNamenListe.Sort;
    Zellenfuellen(DateiNamenListe);
    DateiNamenListe.Free;
  END;
end;

procedure TIndexTool.StartClick(Sender: TObject);

VAR I : Integer;
    Mpeg2Index : TMpeg2Header;
    AudioIndex : TMpegAudio;
    Markierung : TGridRect;

begin
  Markierung.Left := 0;
  Markierung.Right := 2;
  Mpeg2Index := TMpeg2Header.Create;
  AudioIndex := TMpegAudio.Create;
  Mpeg2Index.Fortschrittsanzeige := Fortschrittsanzeige;
  AudioIndex.Fortschrittsanzeige := Fortschrittsanzeige;
  Laeuft := True;
  I := 0;
  AnfangszeitGesamt := Time;
  WHILE I < DateienGrid.RowCount DO
//  FOR I := 0 TO DateienGrid.RowCount -1 DO
  BEGIN
    Markierung.Top := I;
    Markierung.Bottom := I;
    DateienGrid.Selection := Markierung;
    IF DateienGrid.Cells[1, I] <> '' THEN
    BEGIN
      AktuelleDateiGroesse := Dateigroesse(DateienGrid.Cells[1, I]);
      aktDateigroesse.Caption := GroessezuStr(AktuelleDateiGroesse);
      AnfangszeitDatei := Time;
      IF Pos(ExtractFileExt(DateienGrid.Cells[1, I]), DateiendungenVideo) > 0 THEN
      BEGIN
        Mpeg2Index.DateiOeffnen(DateienGrid.Cells[1, I]);
   //     showmessage(DateienGrid.Cells[1, I]);
        Mpeg2Index.IndexDateischreiben;
      END;
      IF Pos(ExtractFileExt(DateienGrid.Cells[1, I]), DateiendungenAudio) > 0 THEN
      BEGIN
        AudioIndex.DateiOeffnen(DateienGrid.Cells[1, I]);
   //     showmessage(DateienGrid.Cells[1, I]);
        AudioIndex.IndexDateischreiben;
      END;
      PosGesamtAnfang := PosGesamtAnfang + Round(AktuelleDateiGroesse * 100 / DateienGesamtGroesse);
    END;
    IF Anhalten THEN
      I := DateienGrid.RowCount;
    Inc(I);
  END;
  Mpeg2Index.Free;
  AudioIndex.Free;
  IF Fenster_schliessen.Checked AND (NOT Anhalten) THEN
    Close;
  IF Ausschalten.Checked AND (NOT Anhalten) THEN
  BEGIN
    Close;
    WindowsBeenden(EWX_SHUTDOWN);
  END;
  Laeuft := False;
end;

procedure TIndexTool.AbbrechenClick(Sender: TObject);
begin
  Anhalten := True;
  IF NOT Laeuft THEN
    Close;
end;

procedure TIndexTool.UeberClick(Sender: TObject);
begin
  UeberFenster.Showmodal;
end;

procedure TIndexTool.FormCreate(Sender: TObject);
begin
  DateienGesamtGroesse := 0;
  PosGesamtAnfang := 0;
  DateienGrid.ColWidths[0] := 80;
  DateienGrid.ColWidths[2] := 120;
  DateienGrid.ColWidths[1] := DateienGrid.Width - 200;
  Anhalten := False;
  Laeuft := False;
end;

procedure TIndexTool.FormResize(Sender: TObject);
begin
  DateienGrid.ColWidths[0] := 80;
  DateienGrid.ColWidths[2] := 120;
  DateienGrid.ColWidths[1] := DateienGrid.Width - 200;
  FortschrittDatei.Width := Tastenpanel.Width - 20;
  Fortschrittgesamt.Width := Tastenpanel.Width - 20;
end;

procedure TIndexTool.DateientfernenClick(Sender: TObject);

VAR Markierung : TGridRect;

begin
  Markierung := DateienGrid.Selection;
  Zeilenentfernen(Markierung.Top, Markierung.Bottom);
end;

end.

