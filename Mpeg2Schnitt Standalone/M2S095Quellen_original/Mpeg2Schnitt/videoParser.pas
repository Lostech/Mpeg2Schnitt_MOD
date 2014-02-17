{----------------------------------------------------------------------------------------------
Gepuffertes Lesen von Mpeg2 Video-Dateien mit optinaler Einschraenkung auf
bestimmte slices unter Korrektur der entsprechenden Header.

 Copyright (C) 2005  Igor Feldhaus
 Homepage: n/a
 E-Mail:   igor.feldhaus@gmx.net

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
unit videoParser;

interface

USES // QDialogs, // zum Testen
     Dateipuffer,
     SysUtils;

TYPE
  TvideoParser = CLASS
    DateiName : STRING;
    DateiMode : Integer;
    Dateigroesse : Int64;
    DateiEnde : Boolean;
    CONSTRUCTOR Create(Name: STRING; Mode: LongWord);
    DESTRUCTOR Destroy; OVERRIDE;
    FUNCTION Dateioeffnen(Name: STRING; Mode: LongWord;firstSlice,lastSlice:Byte): Boolean;
    PROCEDURE Dateischliessen;
    FUNCTION GetDateigroesse: Int64;
    FUNCTION LesenX(VAR Puffer: ARRAY OF Byte; Laenge: Integer): Boolean;
    FUNCTION NeuePosition(Pos: Int64): Boolean;
    FUNCTION AktuelleAdr: Int64;
  private
    PROCEDURE fillBuffer;
    PROCEDURE writeByte(var Puffer: array of Byte; pos:Integer; wByte : Byte);

  END;

  VAR
  Dateistream:TDateipuffer;
  ErstesSlice:byte=0;
  LetztesSlice:byte=0;
  buffer : pchar;
  bytebuf:array[0..4095] of byte;
  cbuf : array[0..8] of byte; // Chunk Buffer, "Klotz" mit geparsten, aber nicht uebergebenen Header-Bytes
  bufpos:integer=0;
  cbufpos:byte; // Bytes im chunkbuffer
  bufsize:integer;
  Schreiben:boolean;
  headerbyte:byte;
  SprungZiel:int64;
  Springen:boolean;
implementation

CONSTRUCTOR TvideoParser.Create(Name: STRING; Mode: LongWord);
BEGIN
  INHERITED Create;
  Dateistream:=TDateipuffer.create(Name,Mode);
  Dateiname:=Name;
  ErstesSlice:=0;
  LetztesSlice:=0;
  GetMem(buffer, 5120);
  cbufpos:=0;
  bufsize:=0;
  bufpos:=0;
  Schreiben:=true;
  headerbyte:=$00;
  SprungZiel:=0;
  Springen:=true;
END;

DESTRUCTOR TVideoParser.Destroy;
BEGIN
  if not (dateistream.DateiPuffer=nil) then
    Dateistream.destroy;
  INHERITED;
END;

FUNCTION TVideoParser.Dateioeffnen(Name: STRING; Mode: LongWord;firstSlice,lastSlice:Byte): Boolean;
BEGIN
  result:=dateistream.Dateioeffnen(Name,Mode);
  Dateiname:=name;
  ErstesSlice:=firstSlice;
  LetztesSlice:=lastSlice;
  Schreiben:=true;
  cbufpos:=0;
  bufsize:=0;
  bufpos:=0;
  headerbyte:=$00;
  SprungZiel:=0;
END;

PROCEDURE TVideoParser.Dateischliessen;
BEGIN
  dateistream.Dateischliessen;
END;

FUNCTION TVideoParser.GetDateigroesse: Int64;
BEGIN
  result:=dateistream.GetDateigroesse;
END;

FUNCTION TVideoParser.LesenX(VAR Puffer: ARRAY OF Byte; Laenge: Integer): Boolean;
VAR i :integer;
    puffervoll:boolean;
BEGIN
  puffervoll:=false;
  IF((ErstesSlice=0) AND (LetztesSlice=0)) then
  begin
    dateistream.LesenX(Puffer,Laenge);
    bufpos:=4095;
  end
  else
  begin
    if ((bufsize-bufpos)<=6) then
      fillbuffer();
    i:=0;
    while (i < cbufpos) do //chunkbufffer schreiben
    begin
      Puffer[i]:=cbuf[i];
      inc(i);
    end;
    cbufpos:=0;
    while ((puffervoll=false)) do
    begin
      if (byte(buffer[bufpos])=$00) AND (byte(buffer[bufpos+1])=$00)
      AND (byte(buffer[bufpos+2])=$01) then //startcode
      begin
        headerbyte:=(byte(buffer[bufpos+3]));
        // alle benoetigten Bilddaten gelesen; Rest ueberspringen?
        // $AF = maximaler Slice-Startcode, entspricht 2800 Zeilen
        if (Springen AND (headerbyte>letztesSlice) AND (headerbyte <= $AF)) then
        begin
          NeuePosition(SprungZiel);
          fillbuffer;
          continue;
        end;
        if (((headerbyte > $00) AND (headerbyte < erstesSlice))
        OR ((headerbyte>letztesSlice) AND (headerbyte <= $AF))) then
          schreiben:=false
        else
          schreiben:=true;
        if (schreiben) then
        begin // $00 $00 $01 schreiben
          writeByte(puffer,i,byte(buffer[bufpos]));
          inc(i);inc(bufpos);
          writeByte(puffer,i,byte(buffer[bufpos]));
          inc(i);inc(bufpos);
          writeByte(puffer,i,byte(buffer[bufpos]));
          inc(i);inc(bufpos);
        end;
        if (headerbyte=$B3) then
        begin
          writeByte(puffer,i,byte(buffer[bufpos]));
          inc(i);inc(bufpos);
          writeByte(puffer,i,byte(buffer[bufpos]));
          inc(i);inc(bufpos);
          writeByte(puffer,i,(byte(buffer[bufpos]) AND $F0) xor((letztesSlice-erstesSlice+1) SHR 4));
          inc(i);inc(bufpos);
	  writeByte(puffer,i,((letztesSlice-erstesSlice+1) AND $0F )shl 4);
        end
        else
        if ((headerbyte >= erstesSlice)AND(headerbyte <=letztesSlice)) THEN // erwünschter slice-header, slice-nummer "fälschen"
        begin
          writebyte(Puffer,i,(headerbyte-ErstesSlice+1));
        end
        else // sonstige header
          if (schreiben) then
            writeByte(Puffer,i,headerbyte);
        if schreiben AND (i >= Laenge) then
          cbufpos:=i-Laenge+1;
      end
      else
      if (schreiben) then
        Puffer[i]:=byte(buffer[bufpos]);
      if not schreiben then
        dec(i);
      inc(i);
      inc(bufpos);
      if (i>=Laenge) then //Puffer voll
        puffervoll:=true;
      if ((bufsize-bufpos)<=6) then
        fillbuffer();
    end; // while
  end;   // else
  Dateiende:=dateistream.DateiEnde;
  result:=not Dateiende;
END;

PROCEDURE TVideoParser.writeByte(var Puffer: array of Byte; pos:Integer; wByte : Byte);
BEGIN
  if (pos >= 4095) then
    cbuf[pos-4095]:=wByte
  else
    Puffer[pos]:=wByte;
END;

PROCEDURE TVideoParser.fillBuffer();
VAR pb,pb2:pchar;
    j:integer;
begin
  pb:=buffer;
  pb2:=buffer;
  inc(pb2,bufpos);
  j:=0;
  while j < (bufsize-bufpos) do //ungeparste bytes an den Anfang meines Puffers
  begin
    pb^:=pb2^;
    inc(pb);inc(pb2);
    inc(j);
  end;
  dateistream.LesenX(bytebuf,4095);
  bufsize:=j;
  bufpos:=0;
// zum aktuellem Ende meines Puffers gehen und diesen mit frischen bytes füllen
  for j:=0 to 4094 do //Bytes in meinen Buffer umkopieren
  begin
    pb^:=char(bytebuf[j]);
    inc(pb);
  end;
  inc(bufsize,4095);
end;


FUNCTION TVideoParser.NeuePosition(Pos: Int64): Boolean; //seek
BEGIN
  result:=dateistream.NeuePosition(Pos);
  Schreiben:=true;
  cbufpos:=0;
  bufsize:=0;
  bufpos:=0;
  headerbyte:=$00;
  SprungZiel:=Pos;
END;

FUNCTION TVideoParser.AktuelleAdr: Int64;
BEGIN
  result:=dateistream.AktuelleAdr;
END;

end.
