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

unit Mpeg2decoder2;

interface

USES SysUtils,       // für PByteArray, ExtractFilePath
     //Windows,        // für DWord, LoadLibrary, FreeLibrary, GetProcAddress
//     Dialogs,        // Showmessage
     mpeg2,          // für libmpeg2
     Types,
     videoParser;
//     DateiPuffer;
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
  FUNCTION  OpenMPEG2File(FileName: PChar; Offset: Int64=0; Size: Int64=-1): LongBool;
  FUNCTION  ReOpenMPEG2File(firstslice,lastslice:byte): LongBool;
  PROCEDURE CloseMPEG2File      ;
  FUNCTION  GetMPEG2Frame       : PByteArray;
  PROCEDURE SkipMPEG2Frames     (FrameCount: Integer);
  PROCEDURE GetMPEG2FrameInfo   (VAR BildInfo: TBildeigenschaften);
  PROCEDURE GetMPEG2FileInfo    (VAR DateiInfo: TDateieigenschaften);
  PROCEDURE MPEG2Seek           (Position: Int64);
  PROCEDURE SetMPEG2PixelFormat (PixelFormat: Integer);
  PROCEDURE SetRGBScaleFlag     (DoScaling: LongBool);
  PROCEDURE Bilderdecodieren    (bilderdecode:dword);

VAR
  Mpeg2Decoder_OK : Boolean;
  decoder : Pmpeg2dec_t;
  info : Pmpeg2_info_t;
  buffer : array[0..4095] of byte;
  state : TMpeg2_state_t;
  Dateistream : TvideoParser;
  sequence : Pmpeg2_sequence_t;
  pstart : Puint8_t;
  pende : Puint8_t;
  bildnummer:Integer;

implementation

FUNCTION  OpenMPEG2File(FileName: PChar; Offset: Int64=0; Size: Int64=-1): LongBool;
BEGIN
  mpeg2_reset(decoder,1);
  dateistream.Dateioeffnen(FileName,fmOpenRead,0,0);
  bildnummer:=0;
  bilderdecodieren(1);
  result:=true;
END;

// Datei mit "gefaelschter Aufloesung" neu laden;
FUNCTION  ReOpenMPEG2File(firstslice,lastslice:byte): LongBool;
VAR name: string;
BEGIN
  mpeg2_reset(decoder,1);
  name:=dateistream.DateiName;
  CloseMpeg2File;
  dateistream.Dateioeffnen(name,fmOpenRead,firstslice,lastslice);
  bildnummer:=0;
  bilderdecodieren(1);
  result:=true;
END;

Procedure Bilderdecodieren(bilderdecode:dword);
VAR bilder:dword;
begin
  bilder:=0;
  REPEAT
    state := mpeg2_parse(decoder);
    sequence :=info.sequence;
    case (state) of
      STATE_BUFFER:
      BEGIN
        Dateistream.LesenX(buffer, 4095);
        mpeg2_buffer (decoder, pstart,pende);
      END;
      STATE_SEQUENCE:
      BEGIN
//                    mpeg2_convert (decoder, mpeg2convert_rgb24, nil);
      END;
      STATE_SLICE,
      STATE_END,
      STATE_INVALID_END:
      BEGIN
        if NOT (info.display_fbuf=nil) THEN
        BEGIN
          inc(bilder);
          inc(bildnummer);
        END;
      END;
    end;
  UNTIL (dateistream.DateiEnde) OR (bilder=bilderdecode);
end;

PROCEDURE  CloseMPEG2File;
BEGIN
  dateistream.dateischliessen;
END;

FUNCTION  GetMPEG2Frame       : PByteArray;
BEGIN
  BilderDecodieren(1);
  if not(info.display_fbuf=nil)then
    result:=Pointer(info.display_fbuf.buf[0])
  else
    result:=nil;
END;

PROCEDURE  SkipMPEG2Frames     (FrameCount: Integer);
begin
  BilderDecodieren(Framecount);
end;

PROCEDURE  GetMPEG2FrameInfo   (VAR BildInfo: TBildeigenschaften);
begin
  Bildinfo.Breite:=sequence.width;
  Bildinfo.Hoehe:=sequence.height;
  Bildinfo.FrameRate:=(27000000/sequence.frame_period);
end;

PROCEDURE  GetMPEG2FileInfo    (VAR DateiInfo: TDateieigenschaften);
begin
  Dateiinfo.Size:=dateistream.Dateigroesse;
  Dateiinfo.Position:=dateistream.AktuelleAdr;
  Dateiinfo.Frame:=bildnummer;
  Dateiinfo.VideoPTS:=7; // wird nicht gebraucht
end;

// nur zu i-frames seeken fuer sauber dekodierte Bilder !!
PROCEDURE  MPEG2Seek           (Position: Int64);
begin
  dateistream.NeuePosition(Position);
  mpeg2_reset(decoder,0);
  bildnummer:=0;
  if (Position > 1000) then // beim Ersten I-Frame keine Bilder ignorieren
    bilderdecodieren(2)     // nicht schön, sollte aber fuer sauberes Material ausreichen
  else
    inc(bildnummer,2);
end;

PROCEDURE  SetMPEG2PixelFormat  (PixelFormat: Integer);
begin
// damit Delphi die Methode nicht rausschmeisst
end;

PROCEDURE SetRGBScaleFlag     (DoScaling: LongBool);
begin
// damit Delphi die Methode nicht rausschmeisst
end;

INITIALIZATION
BEGIN
  bildnummer:=-1;
  Mpeg2Decoder_OK := mpeg2.Mpeg2Decoder_OK;
  if Mpeg2Decoder_OK then
  begin
    decoder :=mpeg2_init;
    info:=mpeg2_info(decoder);
    pstart:=@buffer[0];
    pende:=@buffer[4095];
    Dateistream:=TvideoParser.Create('', fmOpenRead);
  end;
END;

FINALIZATION
BEGIN
  if Mpeg2Decoder_OK then
  begin
//    dateistream.Destroy;
    mpeg2_close(decoder);
  end;
END;

end.

