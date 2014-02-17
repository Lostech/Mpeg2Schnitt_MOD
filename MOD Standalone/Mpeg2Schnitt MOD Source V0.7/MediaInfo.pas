{-----------------------------------------------------------------------------------
Diese Unit ist Teil der MOD Extension (Erweiterung) des Programms Mpeg2Schnitt.

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

MOD Extension Copyright (C) 2006-2008  Lostech
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

unit MediaInfo;

interface

uses
  Windows, SysUtils;

type
  TMediaInfo_New=function(): Cardinal; cdecl stdcall;
  TMediaInfo_Delete=procedure(Handle: Cardinal) cdecl stdcall;
  TMediaInfo_Open=function(Handle: Cardinal; File__: PWideChar): Cardinal cdecl stdcall;
  TMediaInfo_Close=procedure(Handle: Cardinal) cdecl stdcall;
  TMediaInfo_Inform=function (Handle: Cardinal; Reserved: Integer): PWideChar cdecl stdcall;
  TMediaInfo_GetI=function (Handle: Cardinal; StreamKind: Integer; StreamNumber: Integer; Parameter: Integer; KindOfInfo: Integer): PWideChar cdecl stdcall;
  TMediaInfo_Get=function (Handle: Cardinal; StreamKind: Integer; StreamNumber: Integer; Parameter: PWideChar; KindOfInfo: Integer; KindOfSearch: Integer): PWideChar cdecl stdcall;
  TMediaInfo_Option=function (Handle: Cardinal; Option: PWideChar; Value: PWideChar): PWideChar cdecl stdcall;
  TMediaInfo_State_Get=function (Handle: Cardinal): Integer cdecl stdcall;
  TMediaInfo_Count_Get=function (Handle: Cardinal; StreamKind: Integer; StreamNumber: Integer): Integer cdecl stdcall;
  TMediaInfoA_New=function (): Cardinal cdecl stdcall;
  TMediaInfoA_Delete=procedure (Handle: Cardinal) cdecl stdcall;
  TMediaInfoA_Open=function (Handle: Cardinal; File__: PChar): Cardinal cdecl stdcall;
  TMediaInfoA_Close=procedure (Handle: Cardinal) cdecl stdcall;
  TMediaInfoA_Inform=function (Handle: Cardinal; Reserved: Integer): PChar cdecl stdcall;
  TMediaInfoA_GetI=function (Handle: Cardinal; StreamKind: Integer; StreamNumber: Integer; Parameter: Integer; KindOfInfo: Integer): PChar cdecl stdcall;
  TMediaInfoA_Get=function (Handle: Cardinal; StreamKind: Integer; StreamNumber: Integer; Parameter: PChar; KindOfInfo: Integer; KindOfSearch: Integer): PChar cdecl stdcall;
  TMediaInfoA_Option=function (Handle: Cardinal; Option: PChar; Value: PChar): PChar cdecl stdcall;
  TMediaInfoA_State_Get=function (Handle: Cardinal): Integer cdecl stdcall;
  TMediaInfoA_Count_Get=function (Handle: Cardinal; StreamKind: Integer; StreamNumber: Integer): Integer cdecl stdcall;

  function MilliSecondsToString(MilliSeconds: Int64): string;

  function MediaInfoDLLVersion(): String;
  function MediaInfoFileSize(FilePath: String): Int64;
  function MediaInfoFileCodec(FilePath: String): String;
  function MediaInfoFileVideoWidth(FilePath: String): Integer;
  function MediaInfoFileVideoHeight(FilePath: String): Integer;
  function MediaInfoFileVideoAspect(FilePath: String): String;
  function MediaInfoFileBitrate(FilePath: String): Integer;
  function MediaInfoFilePlayTime(FilePath: String): Int64;

var
  MediaFile: Cardinal;
  PMediaFile: PWideChar;
  StreamKind: Integer;
  MediaInfoString: WideString;

  MediaInfo_DLLHandle: THandle;
  MediaInfo_DLL_OK: Boolean;
  MediaInfo_New: TMediaInfo_New;
  MediaInfo_Delete: TMediaInfo_Delete;
  MediaInfo_Open: TMediaInfo_Open;
  MediaInfo_Close: TMediaInfo_Close;
  MediaInfo_Inform: TMediaInfo_Inform;
  MediaInfo_GetI: TMediaInfo_GetI;
  MediaInfo_Get: TMediaInfo_Get;
  MediaInfo_Option: TMediaInfo_Option;
  MediaInfo_State_Get: TMediaInfo_State_Get;
  MediaInfo_Count_Get: TMediaInfo_Count_Get;
  MediaInfoA_New: TMediaInfoA_New;
  MediaInfoA_Delete: TMediaInfoA_Delete;
  MediaInfoA_Open: TMediaInfoA_Open;
  MediaInfoA_Close: TMediaInfoA_Close;
  MediaInfoA_Inform: TMediaInfoA_Inform;
  MediaInfoA_GetI: TMediaInfoA_GetI;
  MediaInfoA_Get: TMediaInfoA_Get;
  MediaInfoA_Option: TMediaInfoA_Option;
  MediaInfoA_State_Get: TMediaInfoA_State_Get;
  MediaInfoA_Count_Get: TMediaInfoA_Count_Get;

implementation

function MilliSecondsToString(MilliSeconds: Int64): string;
//Milliseconds to String
var
  Hours: Integer;
  Minutes: Integer;
  Seconds: Integer;

begin
  try
    Seconds:=MilliSeconds div 1000;
    Hours:=(Seconds div 3600);
    Seconds:=Seconds-(Hours*3600);
    Minutes:=(Seconds div 60);
    Seconds:=Seconds-(Minutes*60);
    MilliSecondsToString:= FormatFloat('00', Hours)+':'+FormatFloat('00', Minutes)+':'+FormatFloat('00', Seconds);
  except
    MilliSecondsToString:= '00:00:00';
  end;
end;

function MediaInfoDLLVersion(): String;
//MediaInfo DLL Version
begin
  try
   MediaInfoString:=MediaInfo_Option(0, 'Info_Version', '');
   Result:=MediaInfoString;
  except
    Result:='';
  end;
end;

function MediaInfoFileSize(FilePath: String): Int64;
//Media File Filesize
begin
  try
  MediaFile:=MediaInfo_New;
  GetMem(PMediaFile, 512);
  PMediaFile:=StringToWideChar(FilePath, PMediaFile, 256);
  MediaInfo_Open(MediaFile,PMediaFile);
  MediaInfoString:=MediaInfo_Get(MediaFile, 0, 0, 'FileSize', 1, 0);
  Result:=StrToInt64Def(MediaInfoString,0);
  MediaInfo_Close(MediaFile);
  MediaInfo_Delete(MediaFile);
  except
  Result:=0;
  end;
end;

function MediaInfoFileCodec(FilePath: String): String;
//Media File Codec
begin
  try
  MediaFile:=MediaInfo_New;
  GetMem(PMediaFile, 512);
  PMediaFile:=StringToWideChar(FilePath, PMediaFile, 256);
  MediaInfo_Open(MediaFile,PMediaFile);
  //StreamKind:=StrToInt(MediaInfo_Get(MediaFile, 0, 0, 'StreamKind', 1, 0));
  MediaInfoString:=MediaInfo_Get(MediaFile, 0, 0, 'Codec/String', 1, 0);
  Result:=MediaInfoString;
  MediaInfo_Close(MediaFile);
  MediaInfo_Delete(MediaFile);
  except
  Result:='';
  end;
end;

function MediaInfoFilePlayTime(FilePath: String): Int64;
//Media File Playtime
begin
  try
  MediaFile:=MediaInfo_New;
  GetMem(PMediaFile, 512);
  PMediaFile:=StringToWideChar(FilePath, PMediaFile, 256);
  MediaInfo_Open(MediaFile,PMediaFile);
  MediaInfoString:=MediaInfo_Get(MediaFile, 0, 0, 'PlayTime', 1, 0);
  Result:=StrToInt64Def(MediaInfoString,0);
  MediaInfo_Close(MediaFile);
  MediaInfo_Delete(MediaFile);
  except
  Result:=0;
  end;
end;

function MediaInfoFileVideoWidth(FilePath: String): Integer;
//Media File Video Width
begin
  try
  MediaFile:=MediaInfo_New;
  GetMem(PMediaFile, 512);
  PMediaFile:=StringToWideChar(FilePath, PMediaFile, 256);
  MediaInfo_Open(MediaFile,PMediaFile);
  MediaInfoString:=MediaInfo_Get(MediaFile, 1, 0, 'Width', 1, 0);
  if MediaInfoString<>'' then
    Result:=StrToInt(MediaInfoString)
  else
    Result:=0;
  MediaInfo_Close(MediaFile);
  MediaInfo_Delete(MediaFile);
  except
  Result:=0;
  end;
end;

function MediaInfoFileVideoHeight(FilePath: String): Integer;
//Media File Video Width
begin
  try
  MediaFile:=MediaInfo_New;
  GetMem(PMediaFile, 512);
  PMediaFile:=StringToWideChar(FilePath, PMediaFile, 256);
  MediaInfo_Open(MediaFile,PMediaFile);
  MediaInfoString:=MediaInfo_Get(MediaFile, 1, 0, 'Height', 1, 0);
  if MediaInfoString<>'' then
    Result:=StrToInt(MediaInfoString)
  else
    Result:=0;
  MediaInfo_Close(MediaFile);
  MediaInfo_Delete(MediaFile);
  except
  Result:=0;
  end;
end;

function MediaInfoFileVideoAspect(FilePath: String): String;
//Media File Video Aspect
begin
  try
  MediaFile:=MediaInfo_New;
  GetMem(PMediaFile, 512);
  PMediaFile:=StringToWideChar(FilePath, PMediaFile, 256);
  MediaInfo_Open(MediaFile,PMediaFile);
  MediaInfoString:=MediaInfo_Get(MediaFile, 1, 0, 'AspectRatio/String', 1, 0);
  Result:=MediaInfoString;
  MediaInfo_Close(MediaFile);
  MediaInfo_Delete(MediaFile);
  except
  Result:='';
  end;
end;

function MediaInfoFileBitrate(FilePath: String): Integer;
//Media File Bitrate
begin
  try
  MediaFile:=MediaInfo_New;
  GetMem(PMediaFile, 512);
  PMediaFile:=StringToWideChar(FilePath, PMediaFile, 256);
  MediaInfo_Open(MediaFile,PMediaFile);
  MediaInfoString:=MediaInfo_Get(MediaFile, 0, 0, 'BitRate', 1, 0);
  if MediaInfoString<>'' then
      Result:=StrToInt(MediaInfoString)
  else
    begin
      MediaInfoString:=MediaInfo_Get(MediaFile, 1, 0, 'BitRate', 1, 0);
      if MediaInfoString<>'' then
        Result:=StrToInt(MediaInfoString)
      else
        begin
          MediaInfoString:=MediaInfo_Get(MediaFile, 2, 0, 'BitRate', 1, 0);
          if MediaInfoString<>'' then
            Result:=StrToInt(MediaInfoString)
          else
            Result:=0;
        end;
    end;
  MediaInfo_Close(MediaFile);
  MediaInfo_Delete(MediaFile);
  except
  Result:=0;
  end;
end;

initialization
begin
  MediaInfo_DLL_OK:=false;
  try
  //DLL laden und Funktionen initialisieren
  if (MediaInfo_DLLHandle=0) and (FileExists('MediaInfo.dll')=true) then
    begin
      MediaInfo_DLLHandle:=LoadLibrary('MediaInfo.dll');
      if MediaInfo_DLLHandle<>0 then
        begin
          //MediaInfo_New
          MediaInfo_New:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_New');
          if not Assigned(MediaInfo_New) then Exit;
          //MediaInfo_Delete
          MediaInfo_Delete:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_Delete');
          if not Assigned(MediaInfo_Delete) then Exit;
          //MediaInfo_Open
          MediaInfo_Open:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_Open');
          if not Assigned(MediaInfo_Open) then Exit;
          //TMediaInfo_Close
          MediaInfo_Close:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_Close');
          if not Assigned(MediaInfo_Close) then Exit;
          //MediaInfo_Inform
          MediaInfo_Inform:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_Inform');
          if not Assigned(MediaInfo_Inform) then Exit;
          //MediaInfo_GetI
          MediaInfo_GetI:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_GetI');
          if not Assigned(MediaInfo_GetI) then Exit;
          //MediaInfo_Get
          MediaInfo_Get:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_Get');
          if not Assigned(MediaInfo_Get) then Exit;
          //MediaInfo_Option
          MediaInfo_Option:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_Option');
          if not Assigned(MediaInfo_Option) then Exit;
          //MediaInfo_State_Get
          MediaInfo_State_Get:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_State_Get');
          if not Assigned(MediaInfo_State_Get) then Exit;
          //MediaInfo_Count_Get
          MediaInfo_Count_Get:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfo_Count_Get');
          if not Assigned(MediaInfo_Count_Get) then Exit;
          //TMediaInfoA_New
          MediaInfoA_New:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_New');
          if not Assigned(MediaInfoA_New) then Exit;
          //MediaInfoA_Delete
          MediaInfoA_Delete:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_Delete');
          if not Assigned(MediaInfoA_Delete) then Exit;
          //MediaInfoA_Open
          MediaInfoA_Open:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_Open');
          if not Assigned(MediaInfoA_Open) then Exit;
          //MediaInfoA_Close
          MediaInfoA_Close:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_Close');
          if not Assigned(MediaInfoA_Close) then Exit;
          //MediaInfoA_Inform
          MediaInfoA_Inform:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_Inform');
          if not Assigned(MediaInfoA_Inform) then Exit;
          //MediaInfoA_GetI
          MediaInfoA_GetI:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_GetI');
          if not Assigned(MediaInfoA_GetI) then Exit;
          //MediaInfoA_Get
          MediaInfoA_Get:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_Get');
          if not Assigned(MediaInfoA_Get) then Exit;
          //MediaInfoA_Option
          MediaInfoA_Option:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_Option');
          if not Assigned(MediaInfoA_Option) then Exit;
          //MediaInfoA_State_Get
          MediaInfoA_State_Get:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_State_Get');
          if not Assigned(MediaInfoA_State_Get) then Exit;
          //MediaInfoA_Count_Get
          MediaInfoA_Count_Get:=GetProcAddress(MediaInfo_DLLHandle,'MediaInfoA_Count_Get');
          if not Assigned(MediaInfoA_Count_Get) then Exit;
          //alle DLL Funktion ohne Fehler geladen
          MediaInfo_DLL_OK:=true;
        end;
    end;
    except
    MediaInfo_DLL_OK:=false;
    end;
end;

finalization
begin
  //DLL freigeben
  if MediaInfo_DLLHandle<>0 then
    begin
      FreeLibrary(MediaInfo_DLLHandle);
      MediaInfo_DLLHandle:=0;
    end;
end;

end.
