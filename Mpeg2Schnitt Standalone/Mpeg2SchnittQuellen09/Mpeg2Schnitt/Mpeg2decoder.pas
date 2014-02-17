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

unit Mpeg2decoder;

interface

USES SysUtils,        // für PByteArray, ExtractFilePath
     Windows,         // für DWord, LoadLibrary, FreeLibrary, GetProcAddress
     Forms;           // für Application

CONST
  // Konstanten für SetMPEG2PixelFormat
  VideoFormatRGB24       = 1; // RGB interleaved, default
  VideoFormatGray8       = 2; // Y plane
  VideoFormatYUV24       = 3; // YUV planes

TYPE
  TBildeigenschaften = RECORD
                       Breite, Hoehe : Integer; 
                       FrameRate     : Double; // Bilder /Sekunde
                       END;

  TDateieigenschaften = RECORD
                        Size     : Int64;
                        Position : Int64;
                        Frame    : DWord;
                        VideoPTS : DWord; // Zeit in 1/90000 Sekunden, wird nur beim Mpeg2Seek aktualisiert
                        END;

  TOpenMPEG2File       = FUNCTION(FileName: PChar; Offset: Int64=0; Size: Int64=-1): LongBool; stdcall;
  TOpenMPEG2Disk       = FUNCTION(Disk: Byte; Offset: Int64=0; Size: Int64=-1): LongBool; stdcall;
  TCloseMPEG2File      = PROCEDURE; stdcall;
  TGetMPEG2Frame       = FUNCTION: PByteArray; stdcall;
  TSkipMPEG2Frames     = PROCEDURE(FrameCount: Integer); stdcall;
  TGetMPEG2FrameInfo   = PROCEDURE(VAR BildInfo: TBildeigenschaften); stdcall;
  TGetMPEG2FileInfo    = PROCEDURE(VAR DateiInfo: TDateieigenschaften); stdcall;
  TMPEG2Seek           = PROCEDURE(Position: Int64); stdcall;
  TSetMPEG2PixelFormat = PROCEDURE(PixelFormat: Integer); stdcall;
  TSetRGBScaleFlag     = PROCEDURE(DoScaling: LongBool); stdcall;
  TWriteDataToFile     = FUNCTION(FileName: PChar; Size: Int64=High(Int64)): Int64; stdcall;

VAR
  OpenMPEG2File : TOpenMPEG2File;
  OpenMPEG2Disk : TOpenMPEG2Disk;
  CloseMPEG2File : TCloseMPEG2File;
  GetMPEG2FrameInfo : TGetMPEG2FrameInfo;
  GetMPEG2FileInfo : TGetMPEG2FileInfo;
  GetMPEG2Frame : TGetMPEG2Frame;
  SkipMPEG2Frames : TSkipMPEG2Frames;
  MPEG2Seek : TMPEG2Seek;
  SetMPEG2PixelFormat : TSetMPEG2PixelFormat;
  SetRGBScaleFlag : TSetRGBScaleFlag;
  WriteDataToFile : TWriteDataToFile;
  DLLHandle : THandle;
  Mpeg2Decoder_OK : Boolean;

implementation

INITIALIZATION
BEGIN
  IF DLLHandle = 0 THEN
  BEGIN
    Mpeg2Decoder_OK := False;
    DLLHandle := LoadLibrary('mpeg2lib.dll');
//    IF DLLHandle = 0 THEN
//      DLLHandle := LoadLibrary(ExtractFilePath(Application.ExeName) + 'mpeg2lib.dll');
    IF DLLHandle <> 0 THEN
    BEGIN
      //--------------- DLL-Funktionen laden ------------------------
      OpenMPEG2File := GetProcAddress(DLLHandle, '?OpenMPEG2File@@YGHPAD_J1@Z');
        IF NOT Assigned(OpenMPEG2File) then Exit;
      OpenMPEG2Disk := GetProcAddress(DLLHandle, '?OpenMPEG2Disk@@YGHE_J0@Z');
        IF NOT Assigned(OpenMPEG2Disk) then Exit;
      GetMPEG2FrameInfo := GetProcAddress(DLLHandle, '?GetMPEG2FrameInfo@@YGXPAUTVideoFrameInfo@@@Z');
        IF NOT Assigned(GetMPEG2FrameInfo) then Exit;
      GetMPEG2FileInfo := GetProcAddress(DLLHandle, '?GetMPEG2FileInfo@@YGXPAUTVideoFileInfo@@@Z');
        IF NOT Assigned(GetMPEG2FileInfo) then Exit;
      CloseMPEG2File := GetProcAddress(DLLHandle, '?CloseMPEG2File@@YGXXZ');
        IF NOT Assigned(CloseMPEG2File) then Exit;
      GetMPEG2Frame := GetProcAddress(DLLHandle, '?GetMPEG2Frame@@YGPAEXZ');
        IF NOT Assigned(GetMPEG2Frame) then Exit;
      MPEG2Seek := GetProcAddress(DLLHandle, '?MPEG2Seek@@YGX_J@Z');
        IF NOT Assigned(MPEG2Seek) then Exit;
      SkipMPEG2Frames := GetProcAddress(DLLHandle, '?SkipMPEG2Frames@@YGXH@Z');
        IF NOT Assigned(SkipMPEG2Frames) then Exit;
      SetMPEG2PixelFormat := GetProcAddress(DLLHandle, '?SetMPEG2PixelFormat@@YGXH@Z');
        IF NOT Assigned(SetMPEG2PixelFormat) then Exit;
      SetRGBScaleFlag := GetProcAddress(DLLHandle, '?SetRGBScaleFlag@@YGXH@Z');
        IF NOT Assigned(SetRGBScaleFlag) then Exit;
      WriteDataToFile := GetProcAddress(DLLHandle, '?WriteDataToFile@@YG_JPAD_J@Z');
        IF NOT Assigned(WriteDataToFile) then Exit;
      Mpeg2Decoder_OK := True;
    END;
  END;
END;

FINALIZATION
BEGIN
  IF DLLHandle <> 0 THEN
  BEGIN
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
  END;
END;
end.
 
