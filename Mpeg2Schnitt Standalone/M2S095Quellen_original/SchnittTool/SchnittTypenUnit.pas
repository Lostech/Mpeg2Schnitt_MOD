{----------------------------------------------------------------------------------------------
Mpeg2Unit enthält alle Klassen und Funktionen zum lesen und bearbeiten von Mpeg2 Dateien.
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

unit SchnittTypenUnit;

interface

USES
  Classes, SysUtils,
  Dateipuffer, DateiStreamUnit;              // Schreib- und Lesefunktionen mit Pufferung


TYPE
  TFortschrittsanzeige = FUNCTION(Fortschritt: Int64): Boolean OF OBJECT;
  TTextanzeige = FUNCTION(Meldung: Integer; Text: STRING): Boolean OF OBJECT;

  TSchnitt = CLASS
    Dateistream : TDateipuffer;
//    Dateistream : TDateiFileStream;
    Speicherstream : TDateipuffer;
//    Indexstream : TDateipuffer;
//    SpeicherIndexstream : TDateipuffer;
    Fehlertext : STRING;
    FortschrittsPosition : Int64;
    Quelldateiname : STRING;
    FZieldateiname : STRING;
    FAnhalten : Boolean;
    FFortschrittsEndwert : PInt64;
    FFortschrittsanzeige : TFortschrittsanzeige;
    FTextanzeige : TTextanzeige;
    FIndexDateierstellen : Boolean;
//    FEffektdateiname : STRING;
    FZwischenverzeichnis : STRING;
    FEncoderDatei : STRING;
    PROCEDURE Zieldateinamesetzen(ZielDatei: STRING);
    FUNCTION Quelldateioeffnen(Dateiname: STRING): Integer;
    FUNCTION Zieldateioeffnen(ZielDatei: STRING = ''): Integer;
    PROCEDURE Quelldateischliessen;  
    PROCEDURE Zieldateischliessen;
  public
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY Zieldateiname: STRING READ FZieldateiname WRITE Zieldateinamesetzen;
    PROPERTY Anhalten: Boolean READ FAnhalten WRITE FAnhalten;
    PROPERTY FortschrittsEndwert: PInt64 WRITE FFortschrittsEndwert;
    PROPERTY Fortschrittsanzeige: TFortschrittsanzeige WRITE FFortschrittsanzeige;
    PROPERTY Textanzeige: TTextanzeige WRITE FTextanzeige;
    PROPERTY IndexDateierstellen: Boolean READ FIndexDateierstellen WRITE FIndexDateierstellen;
//    PROPERTY Effekte: STRING READ FEffektdateiname WRITE FEffektdateiname;
    PROPERTY Zwischenverzeichnis: STRING READ FZwischenverzeichnis WRITE FZwischenverzeichnis;
    PROPERTY EncoderDatei : STRING WRITE FEncoderDatei;
  END;

implementation

CONSTRUCTOR TSchnitt.Create;
BEGIN
  INHERITED Create;
  Dateistream := NIL;
  Speicherstream := NIL;
//  Indexstream := NIL;
//  SpeicherIndexstream := NIL;
  Fehlertext := '';
  FortschrittsPosition := 0;
  Quelldateiname := '';
  FZieldateiname := '';
  FAnhalten := False;
  FFortschrittsEndwert := NIL;
  FFortschrittsanzeige := NIL;
  FTextanzeige := NIL;
  FIndexDateierstellen := True;
//  FEffektdateiname := '';
  FZwischenverzeichnis := '';
  FEncoderDatei := '';
END;

DESTRUCTOR TSchnitt.Destroy;
BEGIN
  Quelldateischliessen;
  Zieldateischliessen;
  INHERITED Destroy;
END;

// öffnet eine neue Quelldatei
//  1 : Datei war schon geöffnet
//  0 : Datei öffnen erfolgreich
// -1 : kein Dateiname definiert
// -2 : Dateistream konnte nicht erzeugt werden
// -3 : Dateistream nicht zum lesen geöffnet
// -4 : Indexstream konnte nicht erzeugt werden
// -5 : Indexstream nicht zum lesen geöffnet
FUNCTION TSchnitt.Quelldateioeffnen(Dateiname: STRING): Integer;
BEGIN
// Hinweis: neue Datei im Dateistream öffen ohne das Objekt zu zerstören ist möglich
  IF Dateiname <> '' THEN
    IF NOT (Dateiname = Quelldateiname) THEN
    BEGIN
      Quelldateischliessen;
      Result := 0;
      Dateistream := TDateipuffer.Create(Dateiname, fmOpenRead);
//      Dateistream := TDateiFileStream.Create;
      IF Assigned(Dateistream) THEN
      BEGIN
//        IF Dateistream.Dateioeffnen(Dateiname, fmOpenRead) > -1 THEN
        IF Dateistream.DateiMode = fmOpenRead THEN
        BEGIN
//            Indexstream := TDateipuffer.Create(Dateiname + '.idd', fmOpenRead);
//            IF Assigned(Indexstream) THEN
//            BEGIN
//              IF Indexstream.DateiMode <> fmOpenRead THEN
//                Result := -5;
//            END
//            ELSE
//              Result := -4;
        END
        ELSE
          Result := -3;
//          Dateistream.Pufferfreigeben;
        Quelldateiname := Dateiname;
      END
      ELSE
      BEGIN
        Result := -2;
        Quelldateiname := '';
      END;
    END
    ELSE
      Result := 1
  ELSE
    Result := -1;
END;

// schließt die Quelldatei
PROCEDURE TSchnitt.Quelldateischliessen;
BEGIN
  IF Assigned(Dateistream) THEN
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
//  IF Assigned(Indexstream) THEN
//  BEGIN
//    Indexstream.Free;
//    Indexstream := NIL;
//  END;
  Quelldateiname := '';
END;

// setzt den Zieldateinamen
// ist der neue Dateiname unterschiedlich zum alten Namen wird der Zieldateistream geschlossen
PROCEDURE TSchnitt.Zieldateinamesetzen(ZielDatei: STRING);
BEGIN
  IF NOT (FZieldateiname = ZielDatei) THEN
  BEGIN
    Zieldateischliessen;
    FZieldateiname := ZielDatei;
  END;
END;

// öffnet eine neue Zieldatei
//  1 : Datei war schon geöffnet
//  0 : Datei öffnen erfolgreich
// -1 : kein Zieldateiname definiert
// -2 : Dateistream konnte nicht erzeugt werden
// -3 : Dateistream nicht zum schreiben geöffnet
// -4 : Indexstream konnte nicht erzeugt werden
// -5 : Indexstream nicht zum schreiben geöffnet
FUNCTION TSchnitt.Zieldateioeffnen(ZielDatei: STRING = ''): Integer;
BEGIN
  IF ZielDatei = '' THEN
    ZielDatei := FZieldateiname;
  IF ZielDatei <> '' THEN
    IF (NOT (FZieldateiname = ZielDatei)) OR
     (NOT Assigned(Speicherstream)) THEN
    BEGIN
      Zieldateischliessen;
      FZieldateiname := ZielDatei;
      Result := 0;
      Speicherstream := TDateipuffer.Create(ZielDatei, fmCreate);
      IF Assigned(Speicherstream) THEN
      BEGIN
        IF Speicherstream.DateiMode = fmCreate THEN
        BEGIN
//            SpeicherIndexstream := TDateipuffer.Create(ZielDatei + '.idd', fmCreate);
//            IF Assigned(SpeicherIndexstream) THEN
//            BEGIN
//              IF SpeicherIndexstream.DateiMode <> fmCreate THEN
//                Result := -5;
//            END
//            ELSE
//              Result := -4;
        END
        ELSE
          Result := -3;
      END
      ELSE
      BEGIN
        Result := -2;
      END;
    END
    ELSE
      Result := 1
  ELSE
    Result := -1;
END;

// schließt die Zieldatei
PROCEDURE TSchnitt.Zieldateischliessen;
BEGIN
  IF Assigned(Speicherstream) THEN
  BEGIN
    Speicherstream.Free;
    Speicherstream := NIL;
  END;
//  IF Assigned(SpeicherIndexstream) THEN
//  BEGIN
//    SpeicherIndexstream.Free;
//    SpeicherIndexstream := NIL;
//  END;
  FZieldateiname := '';
END;

end.
 