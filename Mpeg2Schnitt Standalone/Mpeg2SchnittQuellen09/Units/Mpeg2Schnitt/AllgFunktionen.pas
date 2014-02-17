{-----------------------------------------------------------------------------------
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

unit AllgFunktionen;

interface

USES Windows,
     SysUtils,        // für ExtractFilePath
     StrUtils,        // für DupeString
     Classes,         // für TStrings
     Forms;           // für Application

TYPE TZeichen = SET OF Char;

// startet ein Programm und wartet bei Bedarf bis zum Programmende
// über Ausgabe kann die Konsolenausgabe umgeleitet werden
FUNCTION Unterprogramm_starten(DateiName : STRING; VAR Programmschliessen: Boolean; warten: Boolean = False; Ausgabe: TStrings = NIL):Boolean; OVERLOAD;
FUNCTION Unterprogramm_starten(DateiName : STRING; warten: Boolean; Ausgabe: TStrings = NIL):Boolean; OVERLOAD;
FUNCTION Unterprogramm_starten(DateiName : STRING; Ausgabe: TStrings = NIL):Boolean; OVERLOAD;
// berechnet die Bildlänge aus der Framerate
FUNCTION BildlaengeausSeqHeaderFramerate(Framerate: Byte): Real;
// berechnet die Bilder pro Sekunde aus der Framerate
FUNCTION BilderProSekausSeqHeaderFramerate(Framerate: Byte): Real;
// teilt einen Text durch einfügen von CR
FUNCTION Textteilen(Text: STRING; Laenge: Integer): STRING;
// fügt an ein Verzeichnis, das nicht leer ist, das Pathtrennzeichen "\" an
FUNCTION mitPathtrennzeichen(Name: STRING): STRING;
// entfernt an einem Verzeichnis, das nicht leer ist, das Pathtrennzeichen "\"
FUNCTION ohnePathtrennzeichen(Name: STRING): STRING;
// entfernt doppelte Pathtrennzeichen "\"
FUNCTION doppeltePathtrennzeichen(Name: STRING): STRING;
// entfernt ein Pathtrennzeichen "\" am Anfang
FUNCTION AnfangPathtrennzeichen(Name: STRING): STRING;
// gibt den relativen Path zum Applicationsverzeichnis + Datei zurück
FUNCTION relativPathAppl(Datei, ApplicationDateiName: STRING): STRING;
// gibt den absoluten Path zurück (Applicationsverzechnis + Datei) Ist Verzeichnis = True wird auch ein leerer Dateiname in das Applicationsverzeichnis geändert.
FUNCTION absolutPathAppl(Datei, ApplicationDateiName: STRING; Verzeichnis: Boolean): STRING;
// sucht das nächsthöhere existierende Verzeichnis
FUNCTION Verzeichnissuchen(Verzeichnis: STRING): STRING;
// erstellt wenn nötig ein Verzeichnis mit den übergeordneten Verzeichnissen
FUNCTION Verzeichniserstellen(Verzeichnis: STRING): Boolean;
// löscht die passenden Dateien im Verzeichnis
PROCEDURE Dateienloeschen(Dateiname: STRING);
// Prüft den Zahlenformatstring und ergänzt ihn eventuell
FUNCTION ZahlenFormatDefault(Format: STRING): STRING;
// zählt den Dateinamen um eins höher
FUNCTION DateinamePlusEins(Name, Format: STRING; nurZahlaussen: Boolean = False): STRING;
// wandelt einen String(im Format Bilder oder Zeit) in eine Bildposition
FUNCTION ZeitStrInMillisek(Text: STRING; BilderProSek: Real; Trennzeichenliste: TStrings; GanzeZahlinms: Boolean): Int64;
// wandelt einen String(im Format Bilder oder Zeit) unter Beachtung des Vorzeichens in Millisekunden um
FUNCTION ZeitStrInMillisekInt(Text: STRING; BilderProSek: Real; Trennzeichenliste: TStrings; GanzeZahlinms: Boolean): Int64;
// wandelt einen String(im Format Bilder oder Zeit) in eine Bildposition
FUNCTION ZeitStrInBildnummer(Text: STRING; BilderProSek: Real; Trennzeichenliste: TStrings; GanzeZahlinms: Boolean): Int64; OVERLOAD;
FUNCTION ZeitStrInBildnummer(Text: STRING; BilderProSek: Real; Trennzeichen: ARRAY OF Char; GanzeZahlinms: Boolean): Int64; OVERLOAD;
// fügt Zahlen (Zeiten) einer Textzeile in ein Array ein
FUNCTION TextzeileinBildnummern(Text: STRING; VAR Zahlen: ARRAY OF Integer; BilderProSek: Real; Trennzeichenliste, ZeitTrennzeichenliste: TStrings; GanzeZahlinSek: Boolean): Integer;
// wandelt eine Zahl in einen String mit führenden Nullen um (nur für positive Zahlen)
FUNCTION IntToStrFmt(Zahl, Stellen: Integer): STRING;
// wandelt eine Zahl in einen String mit führenden "Zeichen" um (nur für positive Zahlen)
FUNCTION IntToStrFmtX(Zahl: Integer; Zeichen: Char; Stellen: Integer): STRING;
// wandelt eine Bildposition in einen String unter Benutzung von Format
FUNCTION BildnummerInZeitStr(Format: STRING; Bildnummer: Int64; BilderProSek: Real): STRING;
// ändert alle Zeiten in das neue Zeitformat
FUNCTION TextzeileZeitformataendern(Text, Format: STRING; BilderProSek: Real; Trennzeichenliste, ZeitTrennzeichenliste: TStrings): STRING;
// messen von Zeiten
PROCEDURE Sartzeitsetzen;
FUNCTION Zeitdauerlesen_milliSek: Int64;
FUNCTION Zeitdauerlesen_microSek: Int64;
// löscht die Objekte einer Stringliste
PROCEDURE Stringliste_loeschen(Liste: TStrings);
// prüft ob eine Datei(en) schon im gleichen Verzeichnis vorhanden sind (auch ohne Dateiendung)
FUNCTION Datei_vorhanden(Dateiname: STRING; mitneuerEndung: Boolean; Endung: STRING; VAR Text: STRING): Boolean;
// prüft ob ein Dateiname der möglich wäre schon vorhanden ist
FUNCTION Dateien_vorhanden(Dateiname, DateiendungenVideo, DateiendungenAudio: STRING; nurAudio: Boolean): Boolean;
// wandelt eine Tastennummer in den zugehörigen Namen
FUNCTION TastenNummerZuName(Nummer: Integer): STRING;
// wandelt einen Tastennamen in die entsprechende Zahl - diese Funktion ist nur noch für alte (*.mau) Dateien wichtig (vor V 0.6l-c)
FUNCTION TastenNummerausName(Name: STRING): Integer;
// sucht in einem Text eine Variable ($Variable#)
// die Zeichen $ und # dürfen nicht maskiert sein ($$, ##)
// in Position wird die Position der Variable und in Result die Länge zurückgegeben
FUNCTION Variablesuchen(Text: STRING; VAR Position: Integer): Integer;
// prüft ob in einem Text eine Variable ($Variable#) vorhanden ist
// die Zeichen $ und # dürfen nicht maskiert sein ($$, ##)
// Position ist die Position ab der gesucht wird
FUNCTION Variablevorhanden(Text: STRING; Position: Integer = -1): Boolean;
// ersetzt Variablen in einem Text durch Werte (in Textform), im ARRAY Variablen befinden sich
// Variablen und Werte abwechselnd beginnend mit der Variablen
// Format und Trennzeichen sind Standardvorgaben, BilderProSek wird zur Formatumrechnung benutzt
FUNCTION VariablenersetzenText(Text: STRING; Variablen: ARRAY OF STRING; Format, Trennzeichen: STRING; BilderProSek: Real): STRING; OVERLOAD;
FUNCTION VariablenersetzenText(Text: STRING; Variablen: ARRAY OF STRING): STRING; OVERLOAD;
// ersetzt Variablen in einem Text durch Werte (in Textform),
// in der Stringliste Variablen befinden sich Variablen und Werte abwechselnd beginnend mit der Variablen
// Format und Trennzeichen sind Standardvorgaben, BilderProSek wird zur Formatumrechnung benutzt
FUNCTION VariablenersetzenText(Text: STRING; Variablen: TStrings; Format, Trennzeichen: STRING; BilderProSek: Real): STRING; OVERLOAD;
FUNCTION VariablenersetzenText(Text: STRING; Variablen: TStrings): STRING; OVERLOAD;
// ersetzt in einer Datei alle Variablen durch Werte (in Textform)
FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: ARRAY OF STRING; Format, Trennzeichen: STRING; BilderProSek: Real): Integer; OVERLOAD;
FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: ARRAY OF STRING): Integer; OVERLOAD;
// ersetzt in einer Datei alle Variablen durch Werte (in Textform)
FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: TStrings; Format, Trennzeichen: STRING; BilderProSek: Real): Integer; OVERLOAD;
FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: TStrings): Integer; OVERLOAD;
// sucht eine Zuweisung in einem Text
// Result gibt die Position nach dem Zuweisungszeichen zurück
// wurde keine Zuweisung gefunden gibt Result 0 zurück
FUNCTION Zuweisungsuchen(Text, Zuweisungszeichen, Trennzeichen: STRING; Position: Integer; VAR Variable, Wert: STRING): Integer;
// fügt Variablen zu einem Arry hinzu
// ist die Variable schon vorhanden wird ihr Wert ersetzt
// ist das Array zu klein wird der zusätzlich benötigte Platz zurückgegeben
FUNCTION Variablesetzen(VAR Variablen: ARRAY OF STRING; Variable, Wert: STRING): Integer; OVERLOAD;
// fügt Variablen zu einer Stringliste hinzu
// ist die Variable schon vorhanden wird ihr Wert ersetzt
FUNCTION Variablesetzen(Variablen: TStrings; Variable, Wert: STRING): Integer; OVERLOAD;
// kopiert Variablen und Werte in ein VariablenArray
// vorhandene gleiche Variablen werden überschrieben
// ist das Array zu klein wird der zusätzlich benötigte Platz zurückgegeben
FUNCTION VariablenausText(Text, Zuweisungszeichen, Trennzeichen: STRING; VAR Variablen:  ARRAY OF STRING): Integer; OVERLOAD;
// kopiert Variablen und Werte in eine Stringliste
// vorhandene gleiche Variablen werden überschrieben
FUNCTION VariablenausText(Text, Zuweisungszeichen, Trennzeichen: STRING; Variablen: TStrings): Integer; OVERLOAD;
// liest einen Integerparameter aus einen Text
FUNCTION ParameterausTextInt(Text, Parameter, Zuweisungszeichen, Trennzeichen: STRING; DefaultParameter: Integer): Integer;
// liest einen Stringparameter aus einen Text
FUNCTION ParameterausTextStr(Text, Parameter, Zuweisungszeichen, Trennzeichen: STRING; Maske: Char; DefaultParameter: STRING): STRING;
// löscht in einem Text alle Maskierungszeichen
FUNCTION MaskierungenentfernenText(Text: STRING; Maske: TZeichen): STRING;
// löscht in einem Text alle Variablen
FUNCTION VariablenentfernenText(Text: STRING): STRING;
// löscht in einer Datei alle Variablen
PROCEDURE VariablenentfernenDatei(Dateiname: STRING);
// kopiert die Zeichen die zwischen den "Vontext" und "Bistext" Zeichen stehen
// dabei können die gesuchten Zeichen mitkopiert werden ("MitVonText", "MitBisText")
// Position ist die Startposition ab der gesucht wird
// wird "Bistext" nicht gefunden wird alles bis zum Ende kopiert
FUNCTION KopiereVonBis(Text, VonText, BisText: STRING; MitVonText: Boolean = False; MitBisText: Boolean = False; Position: Integer = 1): STRING;
// gibt den N'ten Parameter zurück
// Trennzeichen die in "" stehen werden ignoriert
FUNCTION KopiereParameter(Text: STRING; Ntes: Integer; Trennzeichen: STRING; Alles: Boolean = False): STRING; OVERLOAD;
FUNCTION KopiereParameter(Text: STRING; Ntes: Integer = 1; Alles: Boolean = False): STRING; OVERLOAD;
// entfernt die enschließenden Gänsefüßchen
FUNCTION OhneGaensefuesschen(Text: STRING): STRING;
// ------------ Suchen im Text --------------
// sucht ein Wort in einem Text vorwärts oder rückwärts ab der Startposition
FUNCTION PosX(Wort, Text: STRING; StartPosition: Integer; Rueckwaerts: Boolean): Integer; OVERLOAD;
// sucht ein Wort in einem Text vorwärts oder rückwärts ab der Startposition bis zur Endposition
FUNCTION PosX(Wort, Text: STRING; StartPosition, EndPosition: Integer; Rueckwaerts: Boolean): Integer; OVERLOAD;
// sucht ein Wort aus einer Wortliste in einem Text vorwärts oder rückwärts ab der Startposition
FUNCTION PosX(Wortliste: TStrings; Text: STRING; StartPosition: Integer; Rueckwaerts: Boolean; VAR Laenge: Integer): Integer; OVERLOAD;
// sucht das nächste Zeichen eines Textes das in einer Menge (nicht) enthalten ist, vorwärts oder rückwärts
FUNCTION PosX(Zeichenmenge: TZeichen; Text: STRING; StartPosition: Integer; Rueckwaerts, Zeichennichtvorhanden: Boolean): Integer; OVERLOAD;
// Sucht Wort in Text ab der Position vorwärts oder rückwärts und prüft ob das Wort maskiert ist
// ist die Wortlänge größer 1 muß Wort neben dem zeichen Maske mindestens ein anderes Zeichen enthalten
FUNCTION PosX(Wort, Text: STRING; Position: Integer; rueckwaerts: Boolean; Maske: Char): Integer; OVERLOAD;
// sucht ein Wort in einem Text ab der Startposition  bis zur Endposition vorwärts oder rückwärts und prüft ob das Wort maskiert ist
// ist die Wortlänge größer 1 muß Wort neben dem zeichen Maske mindestens ein anderes Zeichen enthalten
FUNCTION PosX(Wort, Text: STRING; StartPosition, EndPosition: Integer; rueckwaerts: Boolean;  Maske: Char): Integer; OVERLOAD;
// modales Nachrichtenfenster aus der API (Application.MessageBox)
FUNCTION Nachrichtenfenster(Nachricht, Titel: STRING; Tasten, Icon: Longint): Integer;
// modales Nachrichtenfenster ohne Rückmeldung aus der API
PROCEDURE Meldungsfenster(Nachricht: STRING; Titel: STRING = '');
// schneidet vom Komponentenname die Zahl am Ende ab
FUNCTION Komponentenname(Komponente: TComponent): STRING;
// vertaucht die beiden Integerzahlen A und B
PROCEDURE SwapInteger(VAR A, B: Integer);
// bestimmte Zeichen aus einem String entfernen
FUNCTION ErsetzeZeichen(Text: STRING; Zeichen: TZeichen; ErsatzZeichen: Char = '_'): STRING;

implementation

VAR Startzeit,
    Endzeit : Int64;

// startet ein Programm und wartet bei Bedarf bis zum Programmende
// über Ausgabe kann die Konsolenausgabe umgeleitet werden
FUNCTION Unterprogramm_starten(DateiName : STRING; VAR Programmschliessen: Boolean; warten: Boolean = False; Ausgabe: TStrings = NIL):Boolean;

VAR StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
    SecurityAttr: TSecurityAttributes;
    PipeOutputRead: THandle;
    PipeOutputWrite: THandle;
    Puffer: ARRAY [0..255] OF Char;
    Byteanzeahl,
    Pipegroesse,
    EndeCode, I : DWord;
    HString : STRING;

BEGIN
  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);                   //Initialisierung ProcessInfo
  IF Assigned(Ausgabe) THEN
  BEGIN
    FillChar(SecurityAttr, SizeOf(TSecurityAttributes), 0);                //Initialisierung SecurityAttr
    WITH SecurityAttr DO
    BEGIN
      nLength := SizeOf(SecurityAttr);
      bInheritHandle := True;
      lpSecurityDescriptor := NIL;
    END;
    CreatePipe(PipeOutputRead, PipeOutputWrite, @SecurityAttr, 0);         //Pipes erzeugen
  END;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);                          //Initialisierung StartupInfo
  IF Assigned(Ausgabe) THEN
  BEGIN
    WITH StartupInfo DO
    BEGIN
      cb:=SizeOf(StartupInfo);
      hStdInput := 0;
      hStdOutput := PipeOutputWrite;
//      hStdError := PipeOutputWrite;
      hStdError := 0;
      wShowWindow := sw_Hide;
      dwFlags := StartF_UseShowWindow OR StartF_UseStdHandles;
    END;
  END
  ELSE
  BEGIN
    WITH StartupInfo DO
    BEGIN
      cb:=SizeOf(StartupInfo);
      wShowWindow := sw_ShowNormal;
      dwFlags := StartF_UseShowWindow;
    END;
  END;
  Result := CreateProcess(NIL, PChar(DateiName),                           // externes Programm ausführen
                          NIL, NIL, True,
                          Create_New_Console or Normal_Priority_Class,
                          NIL, NIL,
                          StartupInfo, ProcessInfo);
  IF Assigned(Ausgabe) THEN
    CloseHandle(PipeOutputWrite);                                          // Pipe schließen
  TRY
    IF Result THEN
    BEGIN                                                                  // externes Programm erfolgreich gestartet
      IF Assigned(Ausgabe) OR warten THEN
      BEGIN
        IF Assigned(Ausgabe) THEN
          Ausgabe.Add('');                                                 // leere Zeile anhängen
        REPEAT
          GetExitCodeProcess(ProcessInfo.hProcess, EndeCode);              // Prozeßstatus abfragen
          IF Assigned(Ausgabe) THEN
          BEGIN                                                            // Ausgabe verwenden
            PeekNamedPipe(PipeOutputRead, @Puffer, 255, @Byteanzeahl, @Pipegroesse, NIL); // prüfen ob Zeichen in der Pipe sind
            IF Byteanzeahl > 0 THEN
            BEGIN                                                          // Daten in der Pipe vorhanden
              HString := Ausgabe.Strings[Ausgabe.Count - 1];               // letzte Zeile der Ausgabe in einen String übernehmen
              Ausgabe.Delete(Ausgabe.Count - 1);                           // letzte Zeile der Ausgabe löschen
              WHILE Byteanzeahl > 0 DO
              BEGIN                                                        // Pipe hat Daten
                ReadFile(PipeOutputRead, Puffer, 255, Byteanzeahl, NIL);   // Pipe auslesen
                I := 0;
                WHILE (I < Byteanzeahl) DO                                 // Puffer auslesen
                BEGIN
                  CASE Puffer[I] OF
                     #0: BEGIN
                           Inc(I);                                         // Nullen überspringen
                         END;
                    #10: BEGIN                                             // LF auswerten
                           Inc(I);
                           Ausgabe.Add(HString);                           // Zeile übernehmen
                           HString := '';
                         END;
                    #13: BEGIN                                             // CR auswerten
                           Inc(I);
                           IF (I < Byteanzeahl) AND (Puffer[I] = #10) THEN // dem CR folgt ein LF
                           BEGIN
                             Inc(I);
                             Ausgabe.Add(HString);                         // Zeile übernehmen
                             HString := '';
                           END
                           ELSE
                             HString := '';                                // zurück zum Zeilenanfang
  //                           HString := HString + '-' + inttostr(Byte(Puffer[I - 1])) + '_';
                         END;
                    ELSE
                    BEGIN                                                  // Zeichen übernehmen
                      HString := HString + Puffer[I];
                      Inc(I);
                    END;
                  END;
                END;
                PeekNamedPipe(PipeOutputRead, @Puffer, 255, @Byteanzeahl, @Pipegroesse, NIL); // prüfen ob weitere Zeichen in der Pipe sind
              END;
              Ausgabe.Add(HString);                                        // Zeile in die Ausgabeliste kopieren
            END;
          END;
          Sleep(10);                                                       // Programmpause 10 ms
          Application.ProcessMessages;                                     // Ereignisse auswerten
        UNTIL (EndeCode <> Still_Active) OR
              Programmschliessen;                                          // wiederholen solange der Prozeß läuft
        IF Assigned(Ausgabe) AND
          (Ausgabe.Strings[Ausgabe.Count - 1] = '') THEN
          Ausgabe.Delete(Ausgabe.Count - 1); 
      END;
    END;
  FINALLY
    IF Assigned(Ausgabe) THEN
    BEGIN
//      CloseHandle(PipeOutputWrite);                                        // Pipe schließen
      CloseHandle(PipeOutputRead);                                         // Pipe schließen
    END;
    CloseHandle(ProcessInfo.hProcess);
  END;
END;

FUNCTION Unterprogramm_starten(DateiName : STRING; warten: Boolean; Ausgabe: TStrings = NIL):Boolean;

VAR Programmschliessen : Boolean;

BEGIN
  Programmschliessen := False;
  Result := Unterprogramm_starten(DateiName, Programmschliessen, warten, Ausgabe);
END;

FUNCTION Unterprogramm_starten(DateiName : STRING; Ausgabe: TStrings = NIL):Boolean;
BEGIN
  Result := Unterprogramm_starten(DateiName, False, Ausgabe);
END;

// berechnet die Bildlänge aus der Framerate
FUNCTION BildlaengeausSeqHeaderFramerate(Framerate: Byte): Real;
BEGIN
  CASE Framerate OF
    1: Result :=  41.7084;
    2: Result :=  41.6667;
    3: Result :=  40;
    4: Result :=  33.3667;
    5: Result :=  33.3333;
    6: Result :=  20;
    7: Result :=  16.675;
    8: Result :=  16.6667;
  ELSE
    Result :=  40;
  END;
END;

// berechnet die Bilder pro Sekunde aus der Framerate
FUNCTION BilderProSekausSeqHeaderFramerate(Framerate: Byte): Real;
BEGIN
  CASE Framerate OF
    1: Result := 23.976;
    2: Result := 24;
    3: Result := 25;
    4: Result := 29.97;
    5: Result := 30;
    6: Result := 50;
    7: Result := 59.97;
    8: Result := 60;
  ELSE
    Result := 25;
  END;
END;

// teilt einen Text durch einfügen von CR
FUNCTION Textteilen(Text: STRING; Laenge: Integer): STRING;

VAR Textteile,
    Position,
    Position1,
    PositionR,
    PositionV : Integer;

BEGIN
  Result := '';
  Textteile := Trunc(Length(Text) / Laenge) + 1;
  CASE Textteile OF
    1 : Result := Text;
    2 : BEGIN
          IF (Length(Text) - Laenge) < Round(Laenge / 2) THEN
            Laenge := Round(Length(Text) / 2);
        END;
   END;
   Position := Laenge;
   Position1 := 1;
   REPEAT
     PositionR := PosX(' ', Text, Position, True);
     PositionV := PosX(' ', Text, Position, False);
     IF (PositionV > 0) AND (PositionV < PositionR)  THEN
       PositionR := PositionV;
     Result := Result + Copy(Text, Position1, PositionR - Position1) + Chr(13);
     Position := Laenge + PositionR;
     Position1 := PositionR + 1;
   UNTIL Position > Length(Text);
   Result := Result + Copy(Text,Position1, Length(Text) - PositionR);
   Result := Text;
END;

// fügt an ein Verzeichnis, das nicht leer ist, das Pathtrennzeichen "\" an
FUNCTION mitPathtrennzeichen(Name: STRING): STRING;
BEGIN
  IF Name <> '' THEN
    Result := IncludeTrailingPathDelimiter(Name)
  ELSE
    Result := Name;
END;

// entfernt an einem Verzeichnis, das nicht leer ist, das Pathtrennzeichen "\"
FUNCTION ohnePathtrennzeichen(Name: STRING): STRING;
BEGIN
  IF Name <> '' THEN
    Result := ExcludeTrailingPathDelimiter(Name)
  ELSE
    Result := Name;
END;

// entfernt doppelte Pathtrennzeichen "\"
FUNCTION doppeltePathtrennzeichen(Name: STRING): STRING;

VAR I, J : Integer;

BEGIN
  I := 1;
  WHILE I < Length(Name) + 1 DO
  BEGIN
    IF IsPathDelimiter(Name, I) THEN
    BEGIN
      J := I;
      WHILE (I < Length(Name) + 1) AND
            (IsPathDelimiter(Name, I)) DO
        Inc(I);
      IF J + 1 < I THEN
      BEGIN
        Name := LeftStr(Name, J) + RightStr(Name, Length(Name) -I + 1);
        Dec(I, I - J - 1);
      END;
    END;
    Inc(I);
  END;
  Result := Name;
END;

// entfernt ein Pathtrennzeichen "\" am Anfang
FUNCTION AnfangPathtrennzeichen(Name: STRING): STRING;
BEGIN
  IF Name <> '' THEN
    IF IsPathDelimiter(Name, 1) THEN
      Name := RightStr(Name, Length(Name) - 1);
  Result := Name;
END;

// gibt den relativen Path zum Applicationsverzeichnis + Datei zurück
FUNCTION relativPathAppl(Datei, ApplicationDateiName: STRING): STRING;
BEGIN
  IF Pos(ExtractFileDir(ApplicationDateiName), Datei) = 1 THEN              // absoluter Path
    Result := Copy(Datei, Length(ExtractFilePath(ApplicationDateiName)) + 1, Length(Datei))
  ELSE
    Result := Datei
END;

// gibt den absoluten Path zurück (Applicationsverzechnis + Datei) Ist Verzeichnis = True wird auch ein leerer Dateiname in das Applicationsverzeichnis geändert.
FUNCTION absolutPathAppl(Datei, ApplicationDateiName: STRING; Verzeichnis: Boolean): STRING;

VAR Position,
    Laenge : Integer;

BEGIN
  Position := 1;
  IF Verzeichnis OR (Datei <> '') THEN
    IF (Pos(':\', Datei) <> 2) THEN                                          // relativer Path
    BEGIN
      Laenge := Variablesuchen(Datei, Position);
      IF (Laenge > 0) AND                                                    // Variable vorhanden
         (Position = 1) THEN                                                 // Variable steht am Anfang
        IF (LeftStr(Datei, Laenge) = '$VideoName#') OR
           (LeftStr(Datei, Laenge) = '$ProjectName#') THEN
          Laenge := 0                                                        // keine Verzeichnisvariable am Anfang
        ELSE
      ELSE
        Laenge := 0;                                                         // Variable steht nicht am Anfang
      IF Laenge = 0 THEN
        Result := ExtractFilePath(ApplicationDateiName) + Datei
      ELSE
        Result := Datei;  
    END
    ELSE
      Result := Datei
  ELSE
    Result := '';
END;

// sucht das nächsthöhere existierende Verzeichnis
FUNCTION Verzeichnissuchen(Verzeichnis: STRING): STRING;

VAR Pathtrennzeichen : Boolean;

BEGIN
  IF Verzeichnis <> '' THEN
  BEGIN
    Pathtrennzeichen := Verzeichnis[Length(Verzeichnis)] = '\';
    Verzeichnis := ohnePathtrennzeichen(Verzeichnis);
    WHILE (NOT DirectoryExists(Verzeichnis)) AND (Verzeichnis <> '') DO
      Verzeichnis := Copy(Verzeichnis, 1, PosX('\', Verzeichnis, 0, True) - 1);
    IF Pathtrennzeichen THEN
      Verzeichnis := mitPathtrennzeichen(Verzeichnis);
  END;
  Result := Verzeichnis;
END;

// erstellt wenn nötig ein Verzeichnis mit den übergeordneten Verzeichnissen
FUNCTION Verzeichniserstellen(Verzeichnis: STRING): Boolean;
BEGIN
  IF Verzeichnis <> '' THEN
    IF NOT DirectoryExists(Verzeichnis) THEN
      Result := ForceDirectories(Verzeichnis)
    ELSE
      Result := True
  ELSE
    Result := False;
END;

// löscht die passenden Dateien im Verzeichnis
PROCEDURE Dateienloeschen(Dateiname: STRING);

VAR Suche : TSearchRec;
    Verzeichnis : STRING;

BEGIN
  Verzeichnis := ExtractFilePath(Dateiname);
  IF FindFirst(Dateiname, 0, Suche) = 0 THEN
  BEGIN
    REPEAT
      DeleteFile(Verzeichnis + Suche.Name);
    UNTIL FindNext(Suche) <> 0;
    FindClose(Suche);
  END;
END;

// Prüft den Zahlenformatstring und ergänzt ihn eventuell
FUNCTION ZahlenFormatDefault(Format: STRING): STRING;
BEGIN
  IF Format = '' THEN
    Format := '$FileName#-$Number; Format=NNN#';
  IF Pos('$filename#', LowerCase(Format)) = 0 THEN
  BEGIN
    IF Pos('$number', LowerCase(Format)) = 1 THEN
      Format := '$FileName#-' + Format      // kein Trennzeichen vorhanden
    ELSE
      Format := '$FileName#' + Format;      // Trennzeichen vorhanden
  END;
  IF Pos('$number', LowerCase(Format)) = 0 THEN
  BEGIN
    IF Pos('$filename#', LowerCase(Format)) + 9 = Length(Format) THEN
      Format := Format + '-';               // kein Trennzeichen vorhanden
    Format := Format + '$Number; Format=NNN#';  // Trennzeichen vorhanden
  END;
  Result := Format;
END;

// zählt den Dateinamen um eins höher
FUNCTION DateinamePlusEins(Name, Format: STRING; nurZahlaussen: Boolean = False): STRING;

VAR NamensTeil1,
    NamensTeil2,
    ZahlTeil,
    DateiEndung,
    Verzeichnis,
    Dateiname,
    HFormat,
    Trennzeichen,
    HZahl : STRING;
    Position1,
    Position2,
    Position3,
    Zahl : Integer;
    Zahlvorhanden : Boolean;

BEGIN
  Zahlvorhanden := False;
  DateiEndung := ExtractFileExt(Name);                                 // Dateiendung merken
  Verzeichnis := ExtractFilePath(Name);                                // Verzeichnis merken
  Dateiname := ExtractFileName(ChangeFileExt(Name, ''));               // Dateiendung löschen
  Format := ZahlenFormatDefault(Format);
  Position1 := Pos('$filename#', LowerCase(Format));
  Position2 := Pos('$number', LowerCase(Format));
  Position3 := PosX('#', Format, Position2 + 8, False, '#');
  IF Position3 = 0 THEN
    Position3 := Length(Format) + 1;
  HFormat := ParameterausTextStr(Copy(Format, Position2 + 8, Position3 - (Position2 + 8)), 'Format', '=', ';', ';', 'NNN');
  HZahl := ParameterausTextStr(Copy(Format, Position2 + 8, Position3 - (Position2 + 8)), 'No', '=', ';', ';', '1');
  IF Position1 > Position2 THEN
  BEGIN                                                                // Zahl steht vorn
    Trennzeichen := Copy(Format, Position3 + 1, Position1 - Position3 - 1);
    IF nurZahlaussen THEN
      Position1 := 1
    ELSE
      Position1 := PosX(['0'..'9'], Dateiname, 0, False, False);       // erste Zahl
    IF Position1 = 0 THEN
      Position1 := 1;
    Position2 := PosX(['0'..'9'], Dateiname, Position1, False, True);  // erstes Zeichen nach der Zahl
    IF Position2 = 0 THEN
      Position2 := Length(Dateiname) + 1;
    NamensTeil1 := Copy(Dateiname, 1, Position1 - 1);                  // Teil vor der Zahl Zahl
    NamensTeil2 := Copy(Dateiname, Position2, Length(Dateiname) - Position2 + 1); // Teil nach der Zahl
    ZahlTeil := Copy(Dateiname, Position1, Position2 - Position1);     // Zahl
    IF (ZahlTeil <> '') AND                                            // Zahlteil ist vorhanden
       ((Trennzeichen = '') OR                                         // (oder) Trennzeichen ist leer
       ((Position2 + Length(Trennzeichen) - 1  < Length(Dateiname) + 1) AND // nach dem Zahlteil kommen genug Zeichen
       (PosX(Trennzeichen, Dateiname, Position2, False) = Position2))) THEN  // Trennzeichen direkt nach dem Zahlteil gefunden
      Zahlvorhanden := True;
  END
  ELSE
  BEGIN                                                                // Zahl steht hinten
    Trennzeichen := Copy(Format, Position1 + 10, Position2 - Position1 - 10);
    IF nurZahlaussen THEN
      Position2 := Length(Dateiname)
    ELSE
      Position2 := PosX(['0'..'9'], Dateiname, 0, True, False);        // erste Zahl von hinten
    IF Position2 = 0 THEN
      Position2 := Length(Dateiname);
    Position1 := PosX(['0'..'9'], Dateiname, Position2, True, True);   // erstes Zeichen vor der Zahl
    NamensTeil1 := Copy(Dateiname, 1, Position1);                      // Teil vor der Zahl Zahl
    NamensTeil2 := Copy(Dateiname, Position2 + 1, Length(Dateiname) - Position2); // Teil nach der Zahl
    ZahlTeil := Copy(Dateiname, Position1 + 1, Position2 - Position1); // Zahl
    IF (ZahlTeil <> '') AND                                            // Zahlteil ist vorhanden
       ((Trennzeichen = '') OR                                         // (oder) Trennzeichen ist leer
       ((Position1 - Length(Trennzeichen) + 1 > 0) AND                 // vor dem Zahlteil kommen genug Zeichen
       (PosX(Trennzeichen, Dateiname, Position1, True) = Position1 - Length(Trennzeichen) + 1))) THEN  // Trennzeichen direkt vor dem Zahlteil gefunden
      Zahlvorhanden := True;
  END;
  Zahl := StrToIntDef(ZahlTeil, 0);
  Inc(Zahl);
  IF Zahlvorhanden THEN
    Result := Verzeichnis + NamensTeil1 + BildnummerInZeitStr(HFormat, Zahl, 25) + NamensTeil2 + DateiEndung
  ELSE
    Result := Verzeichnis + VariablenersetzenText(Format, ['$FileName#', Dateiname, '$Number#', HZahl], HFormat, '', 25) + DateiEndung;
END;

// wandelt einen String(im Format Bilder oder Zeit) in Millisekunden um
FUNCTION ZeitStrInMillisek(Text: STRING; BilderProSek: Real; Trennzeichenliste: TStrings; GanzeZahlinms: Boolean): Int64;

VAR Position1,
    Position2,
    Laenge2,
    HZahl : Integer;
    HString : STRING;

BEGIN
  Text := Trim(Text);
  Position1 := Length(Text) + 1;
  Position2 := PosX(Trennzeichenliste, Text, Position1 - 1, True, Laenge2);
  IF Position2 = 0 THEN
  BEGIN
    HZahl := StrToIntDef(Text, - 1);
    IF HZahl > -1 THEN
      IF NOT GanzeZahlinms THEN
        Result := Round(HZahl * (1000 / BilderProSek))    // Bilder in Millisekunden umrechnen
      ELSE
        Result := HZahl
    ELSE
      Result := -1;
  END
  ELSE
  BEGIN
    HString := Copy(Text, Position2 + Laenge2, Position1 - Position2 - Laenge2);
    HZahl := StrToIntDef(HString, - 1);
    IF HZahl > -1 THEN
    BEGIN
      IF Length(HString) < 3 THEN
        Result := Round(HZahl * (1000 / BilderProSek))    // Bilder in Millisekunden umrechnen
      ELSE
        Result := HZahl;                                  // Millisekunden
      IF Position2 > 1 THEN
      BEGIN
        Position1 := Position2;
        Position2 := PosX(Trennzeichenliste, Text, Position1 - 1, True, Laenge2);
        IF Position2 = 0 THEN                             // wird kein Trennzeichen gefunden muß mit dem
          Laenge2 := 1;                                   // ersten Zeichen gearbeitet werden
        HString := Copy(Text, Position2 + Laenge2, Position1 - Position2 - Laenge2);
        HZahl := StrToIntDef(HString, - 1);
        IF HZahl > -1 THEN
        BEGIN
          Result := Result + (HZahl * 1000);              // Sekunden in Millisekunden umrechnen
          IF Position2 > 1 THEN
          BEGIN
            Position1 := Position2;
            Position2 := PosX(Trennzeichenliste, Text, Position1 - 1, True, Laenge2);
            IF Position2 = 0 THEN                         // wird kein Trennzeichen gefunden muß mit dem
              Laenge2 := 1;                               // ersten Zeichen gearbeitet werden
            HString := Copy(Text, Position2 + Laenge2, Position1 - Position2 - Laenge2);
            HZahl := StrToIntDef(HString, - 1);
            IF HZahl > -1 THEN
            BEGIN
              Result := Result + (HZahl * 60000);         // Minuten in Millisekunden umrechnen
              IF Position2 > 1 THEN
              BEGIN
                Position1 := Position2;
                Position2 := PosX(Trennzeichenliste, Text, Position1 - 1, True, Laenge2);
                IF Position2 = 0 THEN                     // wird kein Trennzeichen gefunden muß mit dem
                  Laenge2 := 1;                           // ersten Zeichen gearbeitet werden
                HString := Copy(Text, Position2 + Laenge2, Position1 - Position2 - Laenge2);
                HZahl := StrToIntDef(HString, - 1);
                IF HZahl > -1 THEN
                  Result := Result + (HZahl * 3600000)    // Stunden in Millisekunden umrechnen
                ELSE
                  Result := -1;                           // Stunden keine Zahl
              END;
            END
            ELSE
              Result := -1;                               // Minuten keine Zahl
          END;
        END
        ELSE
          Result := -1;                                   // Sekunden keine Zahl
      END;
    END
    ELSE
      Result := -1;                                       // letzte Stelle keine Zahl
  END;
END;

// wandelt einen String(im Format Bilder oder Zeit) unter Beachtung des Vorzeichens in Millisekunden um
FUNCTION ZeitStrInMillisekInt(Text: STRING; BilderProSek: Real; Trennzeichenliste: TStrings; GanzeZahlinms: Boolean): Int64;

VAR Minus : Integer;

BEGIN
  Text := Trim(Text);
  IF Pos('-', Text) = 1 THEN
  BEGIN
    Text := Copy(Text, 2, Length(Text) -1);
    Minus := -1;
  END
  ELSE
    Minus := 1;
  Result := ZeitStrInMillisek(Text, BilderProSek, Trennzeichenliste, GanzeZahlinms);
  IF Result = -1 THEN
    Result := 0
  ELSE
    Result := Result * Minus;
END;

// wandelt einen String(im Format Bilder oder Zeit) in eine Bildposition
FUNCTION ZeitStrInBildnummer(Text: STRING; BilderProSek: Real; Trennzeichenliste: TStrings; GanzeZahlinms: Boolean): Int64; OVERLOAD;
BEGIN
  Result := ZeitStrInMillisek(Text, BilderProSek, Trennzeichenliste, GanzeZahlinms);
  IF Result > -1 THEN
    Result := Round(Result / (1000 / BilderProSek));
END;

FUNCTION ZeitStrInBildnummer(Text: STRING; BilderProSek: Real; Trennzeichen: ARRAY OF Char; GanzeZahlinms: Boolean): Int64; OVERLOAD;

VAR Trennzeichenliste : TStringList;
    I : Integer;

BEGIN
  Trennzeichenliste := TStringList.Create;
  TRY
    FOR I := Low(Trennzeichen) TO High(Trennzeichen) DO
      Trennzeichenliste.Add(Trennzeichen[I]);
    Result := ZeitStrInBildnummer(Text, BilderProSek, Trennzeichenliste, GanzeZahlinms);
  FINALLY
    Trennzeichenliste.Free;
  END;
END;

// fügt Zahlen (Zeiten) einer Textzeile in ein Array ein
FUNCTION TextzeileinBildnummern(Text: STRING; VAR Zahlen: ARRAY OF Integer; BilderProSek: Real; Trennzeichenliste, ZeitTrennzeichenliste: TStrings; GanzeZahlinSek: Boolean): Integer;

VAR HString : STRING;
    Position1,
    Position2,
    Laenge1,
    Laenge2,
    HZahl : Integer;

BEGIN
  Result := 0;
  Position1 := 0;                       // Position des ersten Trennzeichens
  Laenge1 := 1;
  REPEAT                                // Durchsuchen der Textzeile
    Position2 := PosX(Trennzeichenliste, Text, Position1 + Laenge1, False, Laenge2);
    IF Position2 = 0 THEN               // Position des zweiten Trennzeichens
    BEGIN
      Position2 := Length(Text) + 1;
      Laenge2 := 1;
    END;
    IF Position2 > (Position1 + Laenge1) THEN // Zwischen den Trennzeichen muß mindestens ein Zeichen stehen
    BEGIN
      HString := Copy(Text, Position1 + Laenge1, Position2 - Position1 - Laenge1);
      HZahl := ZeitStrInBildnummer(HString, BilderProSek, ZeitTrennzeichenliste, False);
      IF HZahl > -1 THEN
      BEGIN
        IF Result < Length(Zahlen) THEN
          Zahlen[Result] := HZahl;
        Inc(Result);
      END;
    END;
    Position1 := Position2;
    Laenge1 := Laenge2;
  UNTIL Position1 > (Length(Text) - 1);
END;

// wandelt eine Zahl in einen String mit führenden Nullen um (nur für positive Zahlen)
FUNCTION IntToStrFmt(Zahl, Stellen: Integer): STRING;
BEGIN
  Result := IntToStr(Zahl);
  Result := StringOfChar('0', Stellen - Length(Result))+ Result;
END;

// wandelt eine Zahl in einen String mit führenden "Zeichen" um (nur für positive Zahlen)
FUNCTION IntToStrFmtX(Zahl: Integer; Zeichen: Char; Stellen: Integer): STRING;
BEGIN
  Result := IntToStr(Zahl);
  Result := StringOfChar(Zeichen, Stellen - Length(Result))+ Result;
END;

// wandelt eine Bildposition in einen String unter Benutzung von Format
FUNCTION BildnummerInZeitStr(Format: STRING; Bildnummer: Int64; BilderProSek: Real): STRING;

VAR I,
    Formatlaenge : Integer;
    Stunde,
    Minute,
    Sekunde,
    Bilder,
    mSekunden : Integer;
    Abbrechen : Boolean;

FUNCTION NaechstesZeichen(Zeichen: STRING): Boolean;
BEGIN
  IF Zeichen <> '' THEN
    IF I + 1 < Formatlaenge THEN
      IF Format[I + 1] = Zeichen THEN
      BEGIN
        Inc(I);
        Result := True;
      END
      ELSE
        Result := False
    ELSE
      Result := False
  ELSE
    Result := False;
END;

FUNCTION KleinerBuchstabe(Zeichen, FolgeZeichen: STRING; Zahl, Folgezahl: Int64): STRING;
BEGIN
  IF NaechstesZeichen(Zeichen) THEN
    Result := IntToStrFmt(Zahl, 2)
  ELSE
    IF NaechstesZeichen(FolgeZeichen) THEN
      IF NaechstesZeichen(FolgeZeichen) THEN
        Result := IntToStrFmt(Folgezahl, 3)
      ELSE
        Result := IntToStr(Folgezahl)
    ELSE
      Result := IntToStr(Zahl);
END;

FUNCTION GrosserBuchstabe(Zeichen, FolgeZeichen: STRING; Zahl, Folgezahl: Int64): STRING;

VAR J : Integer;

BEGIN
  J := I - 1;
  IF NaechstesZeichen(Zeichen) THEN
  BEGIN
    WHILE NaechstesZeichen(Zeichen) DO;
    Result := IntToStrFmt(Zahl, I - J)
  END
  ELSE
    IF NaechstesZeichen(FolgeZeichen) THEN
    BEGIN
      J := I - 1;
      IF NaechstesZeichen(FolgeZeichen) THEN
      BEGIN
        WHILE NaechstesZeichen(FolgeZeichen) DO;
        Result := IntToStrFmt(Folgezahl, I - J)
      END
      ELSE
        IF NaechstesZeichen('l') OR NaechstesZeichen('L') THEN
        BEGIN
          WHILE NaechstesZeichen('l') OR NaechstesZeichen('L') DO;
          Result := IntToStrFmtX(Folgezahl, ' ', I - J)
        END
        ELSE
          Result := IntToStr(Folgezahl);
    END
    ELSE
      IF NaechstesZeichen('l') OR NaechstesZeichen('L') THEN
      BEGIN
        WHILE NaechstesZeichen('l') OR NaechstesZeichen('L') DO;
        Result := IntToStrFmtX(Zahl, ' ', I - J)
      END
      ELSE
        Result := IntToStr(Zahl);
END;

BEGIN
  Result := '';
  Formatlaenge := Length(Format) + 1;
  IF (LowerCase(Format) = 'frames') OR (LowerCase(Format) = 'bilder') THEN
    Result := IntToStr(Bildnummer)                                           // Abwärtskompatiblität
  ELSE
  BEGIN
    IF BilderProSek > 0 THEN
    BEGIN
      Stunde := Trunc(Bildnummer / (BilderProSek * 3600));
      Minute := Trunc((Bildnummer - Stunde * BilderProSek * 3600) / (BilderProSek * 60));
      Sekunde := Trunc((Bildnummer - Stunde * BilderProSek * 3600 - Minute * BilderProSek * 60) / BilderProSek);
      Bilder := Round(Bildnummer - Stunde * BilderProSek * 3600 - Minute * BilderProSek * 60 - Sekunde * BilderProSek);
      mSekunden := Round(1000 / BilderProSek * Bilder);
      I := 1;
      WHILE I < Formatlaenge DO
      BEGIN
        CASE Format[I] OF
          'h' : Result := Result + KleinerBuchstabe('h', '', Trunc(Bildnummer / (BilderProSek * 3600)), 0);
          'H' : Result := Result + GrosserBuchstabe('H', '', Trunc(Bildnummer / (BilderProSek * 3600)), 0);
          'm' : Result := Result + KleinerBuchstabe('m', 's', Minute, mSekunden);
          'M' : Result := Result + GrosserBuchstabe('M', 'S', Trunc(Bildnummer / (BilderProSek * 60)),
                                                              Round(1000 / BilderProSek * Bildnummer));
          's' : Result := Result + KleinerBuchstabe('s', '', Sekunde, 0);
          'S' : Result := Result + GrosserBuchstabe('S', '', Trunc(Bildnummer / BilderProSek), 0);
          'f' : Result := Result + KleinerBuchstabe('f', '', Bilder, 0);
          'F' : Result := Result + GrosserBuchstabe('F', '', Bildnummer, 0);
          'n' : Result := Result + KleinerBuchstabe('n', '', Bilder, 0);
          'N' : Result := Result + GrosserBuchstabe('N', '', Bildnummer, 0);
          '"' : BEGIN
                  IF NaechstesZeichen('"') THEN
                    Result := Result + '"'
                  ELSE
                  BEGIN
                    Abbrechen := False;
                    WHILE (I < Formatlaenge) AND (NOT Abbrechen) DO
                    BEGIN
                      Inc(I);
                      IF I < Formatlaenge THEN
                        IF Format[I] = '"' THEN
                          IF NaechstesZeichen('"') THEN
                            Result := Result + '"'
                          ELSE
                            Abbrechen := True
                        ELSE
                          Result := Result + Format[I];
                    END;
                  END;
                END;
        ELSE
          Result := Result + Format[I];
        END;
        Inc(I);
      END;
    END;
  END;
END;

// ändert alle Zeiten in das neue Zeitformat
FUNCTION TextzeileZeitformataendern(Text, Format: STRING; BilderProSek: Real; Trennzeichenliste, ZeitTrennzeichenliste: TStrings): STRING;

VAR HString : STRING;
    Position1,
    Position2,
    Laenge1,
    Laenge2,
    HZahl : Integer;

BEGIN
  Result := '';
  Position1 := 0;                       // Position des ersten Trennzeichens
  Laenge1 := 1;
  REPEAT                                // Durchsuchen der Textzeile
    Position2 := PosX(Trennzeichenliste, Text, Position1 + Laenge1, False, Laenge2);
    IF Position2 = 0 THEN               // Position des zweiten Trennzeichens
    BEGIN
      Position2 := Length(Text) + 1;
      Laenge2 := 1;
    END;
    IF Position2 > (Position1 + Laenge1) THEN // Zwischen den Trennzeichen muß mindestens ein Zeichen stehen
    BEGIN
      HString := Copy(Text, Position1 + Laenge1, Position2 - Position1 - Laenge1);
      HZahl := ZeitStrInBildnummer(HString, BilderProSek, ZeitTrennzeichenliste, False);
      IF HZahl > -1 THEN
        Result := Result + BildnummerInZeitStr(Format, HZahl, BilderProSek) +
                  Copy(Text, Position2, Laenge2) // Trennzeichen
      ELSE
        Result := Result + Copy(Text, Position1 + Laenge1, Position2 - Position1 - Laenge1 + Laenge2);
    END
    ELSE
      Result := Result + Copy(Text, Position1 + Laenge1, Position2 - Position1 - Laenge1 + Laenge2);
    Position1 := Position2;
    Laenge1 := Laenge2;
  UNTIL Position1 > (Length(Text) - 1);
END;

// messen von Zeiten
PROCEDURE Sartzeitsetzen;
BEGIN
  QueryPerformanceCounter(Startzeit);
END;

FUNCTION Zeitdauerlesen_milliSek: Int64;

VAR Takt : Int64;

BEGIN
  QueryPerformanceFrequency(Takt);
  QueryPerformanceCounter(Endzeit);
  Result := Round((Endzeit - Startzeit) / (Takt / 1000));
END;

FUNCTION Zeitdauerlesen_microSek: Int64;

VAR Takt : Int64;

BEGIN
  QueryPerformanceFrequency(Takt);
  QueryPerformanceCounter(Endzeit);
  Result := Round((Endzeit - Startzeit) / (Takt / 1000000));
END;

// löscht die Objekte einer Stringliste
PROCEDURE Stringliste_loeschen(Liste: TStrings);

VAR I : Integer;

BEGIN
  IF Assigned(Liste) THEN
  BEGIN
    FOR I := 0 TO Liste.Count -1 DO
      IF Assigned(Liste.Objects[I]) THEN
        Liste.Objects[I].Free;
    Liste.Clear;
  END;
END;

// prüft ob eine Datei(en) schon im gleichen Verzeichnis vorhanden sind (auch mit anderer Dateiendung)
FUNCTION Datei_vorhanden(Dateiname: STRING; mitneuerEndung: Boolean; Endung: STRING; VAR Text: STRING): Boolean;

VAR Suche : TSearchRec;
    Verzeichnis : STRING;

BEGIN
  IF mitneuerEndung THEN
    Dateiname := ChangeFileExt(Dateiname, Endung);
  Verzeichnis := ExtractFilePath(Dateiname);
  IF FindFirst(Dateiname, faAnyFile, Suche) = 0 THEN
  BEGIN
    Result := True;
    FindClose(Suche);
  END
  ELSE
    Result := False;
END;

// prüft ob ein Dateiname der möglich wäre schon vorhanden ist
FUNCTION Dateien_vorhanden(Dateiname, DateiendungenVideo, DateiendungenAudio: STRING;
                           nurAudio: Boolean): Boolean;

FUNCTION FileExistsX(Dateiname, Dateiendungen: STRING): Boolean;

VAR P1, P2: Integer;

BEGIN
  Result := False;
  P1 := 2;                                                                      // "*." überspringen
  P2 := Pos(';', DateiendungenVideo + ';');
  WHILE (P2 > P1) AND (NOT Result) DO
  BEGIN                                                                         // Startposition liegt vor der Endposition
    Result := FileExists(Dateiname + Copy(Dateiendungen, P1, P2 - P1));
    P1 := P2 + 2;                                                               // "*." überspringen
    P2  := PosX(';', Dateiendungen + ';', P1, False);
  END;
END;

BEGIN
  Result := False;
  IF NOT nurAudio THEN                                                          // Videodateinamen prüfen
  BEGIN
    IF Pos(UpperCase(ExtractFileExt(Dateiname)), UpperCase(DateiendungenVideo)) = 0 THEN
      Result := FileExistsX(Dateiname, DateiendungenVideo)
    ELSE
      Result := FileExists(Dateiname);
  END;
  IF NOT Result THEN
  BEGIN                                                                         // Audiodateinamen prüfen
    IF Pos(UpperCase(ExtractFileExt(Dateiname)), UpperCase(DateiendungenAudio)) = 0 THEN
      Result := FileExistsX(Dateiname, DateiendungenAudio)
    ELSE
      Result := FileExists(Dateiname);
  END;
END;

// wandelt eine Tastennummer in den zugehörigen Namen
FUNCTION TastenNummerZuName(Nummer: Integer): STRING;
BEGIN
  CASE Nummer OF
    0:  TastenNummerZuName := '';
    8:  TastenNummerZuName := 'Back';
    9:  TastenNummerZuName := 'Tab';
    12: TastenNummerZuName := 'Centr';
    13: TastenNummerZuName := 'Return';
    15: TastenNummerZuName := 'AltGr';
    16: TastenNummerZuName := 'Shift';
    17: TastenNummerZuName := 'Control';
    18: TastenNummerZuName := 'Alt';
    19: TastenNummerZuName := 'Pause';
    20: TastenNummerZuName := 'Capital';
    27: TastenNummerZuName := 'Escape';
    32: TastenNummerZuName := 'Space';
    33: TastenNummerZuName := 'Prior';
    34: TastenNummerZuName := 'Next';
    35: TastenNummerZuName := 'End';
    36: TastenNummerZuName := 'Home';
    37: TastenNummerZuName := 'Left';
    38: TastenNummerZuName := 'Up';
    39: TastenNummerZuName := 'Right';
    40: TastenNummerZuName := 'Down';
    44: TastenNummerZuName := 'Print';
    45: TastenNummerZuName := 'Insert';
    46: TastenNummerZuName := 'Delete';
    91: TastenNummerZuName := 'Left Win';
    92: TastenNummerZuName := 'Right Win';
    93: TastenNummerZuName := 'Apps';
    96: TastenNummerZuName := 'Numpad 0';
    97: TastenNummerZuName := 'Numpad 1';
    98: TastenNummerZuName := 'Numpad 2';
    99: TastenNummerZuName := 'Numpad 3';
    100: TastenNummerZuName := 'Numpad 4';
    101: TastenNummerZuName := 'Numpad 5';
    102: TastenNummerZuName := 'Numpad 6';
    103: TastenNummerZuName := 'Numpad 7';
    104: TastenNummerZuName := 'Numpad 8';
    105: TastenNummerZuName := 'Numpad 9';
    106: TastenNummerZuName := 'Numpad *';
    107: TastenNummerZuName := 'Numpad +';
    109: TastenNummerZuName := 'Numpad -';
    110: TastenNummerZuName := 'Numpad ,';
    111: TastenNummerZuName := 'Numpad /';
    112: TastenNummerZuName := 'F1';
    113: TastenNummerZuName := 'F2';
    114: TastenNummerZuName := 'F3';
    115: TastenNummerZuName := 'F4';
    116: TastenNummerZuName := 'F5';
    117: TastenNummerZuName := 'F6';
    118: TastenNummerZuName := 'F7';
    119: TastenNummerZuName := 'F8';
    120: TastenNummerZuName := 'F9';
    121: TastenNummerZuName := 'F10';
    122: TastenNummerZuName := 'F11';
    123: TastenNummerZuName := 'F12';
    144: TastenNummerZuName := 'Numlock';
    145: TastenNummerZuName := 'Scroll';
    186: TastenNummerZuName := 'ü';
    187: TastenNummerZuName := '+';
    188: TastenNummerZuName := ',';
    189: TastenNummerZuName := '-';
    190: TastenNummerZuName := '.';
    191: TastenNummerZuName := '#';
    192: TastenNummerZuName := 'ö';
    219: TastenNummerZuName := 'ß';
    220: TastenNummerZuName := '^';
    221: TastenNummerZuName := '´';
    222: TastenNummerZuName := 'ä';
    226: TastenNummerZuName := '<';
  ELSE
    TastenNummerZuName := Chr(Nummer);
  END;
END;

// wandelt einen Tastennamen in die entsprechende Zahl - diese Funktion ist nur noch für alte (*.mau) Dateien wichtig (vor V 0.6l-c)
FUNCTION TastenNummerausName(Name: STRING): Integer;
BEGIN
  IF Name = '' THEN
    TastenNummerausName := 0
  ELSE
  IF Name = 'Rückschr' THEN
    TastenNummerausName := 8
  ELSE
  IF Name = 'Tab' THEN
    TastenNummerausName := 9
  ELSE
  IF Name = 'Enter' THEN
    TastenNummerausName := 13
  ELSE
  IF Name = 'AltGr' THEN
    TastenNummerausName := 15
  ELSE
  IF Name = 'Umschalt' THEN
    TastenNummerausName := 16
  ELSE
  IF Name = 'Steuer' THEN
    TastenNummerausName := 17
  ELSE
  IF Name = 'Alt' THEN
    TastenNummerausName := 18
  ELSE
  IF Name = 'Pause' THEN
    TastenNummerausName := 19
  ELSE
  IF Name = 'Feststell' THEN
    TastenNummerausName := 20
  ELSE
  IF Name = 'ESC' THEN
    TastenNummerausName := 27
  ELSE
  IF Name = 'Leer' THEN
    TastenNummerausName := 32
  ELSE
  IF Name = 'BildnachOben' THEN
    TastenNummerausName := 33
  ELSE
  IF Name = 'BildnachUnten' THEN
    TastenNummerausName := 34
  ELSE
  IF Name = 'Ende' THEN
    TastenNummerausName := 35
  ELSE
  IF Name = 'Pos1' THEN
    TastenNummerausName := 36
  ELSE
  IF Name = 'nachLinks' THEN
    TastenNummerausName := 37
  ELSE
  IF Name = 'nachOben' THEN
    TastenNummerausName := 38
  ELSE
  IF Name = 'nachRechts' THEN
    TastenNummerausName := 39
  ELSE
  IF Name = 'nachUnten' THEN
    TastenNummerausName := 40
  ELSE
  IF Name = 'BSDruck' THEN
    TastenNummerausName := 44
  ELSE
  IF Name = 'Einfügen' THEN
    TastenNummerausName := 45
  ELSE
  IF Name = 'Entfernen' THEN
    TastenNummerausName := 46
  ELSE
  IF Name = 'Num0' THEN
    TastenNummerausName := 96
  ELSE
  IF Name = 'Num1' THEN
    TastenNummerausName := 97
  ELSE
  IF Name = 'Num2' THEN
    TastenNummerausName := 98
  ELSE
  IF Name = 'Num3' THEN
    TastenNummerausName := 99
  ELSE
  IF Name = 'Num4' THEN
    TastenNummerausName := 100
  ELSE
  IF Name = 'Num5' THEN
    TastenNummerausName := 101
  ELSE
  IF Name = 'Num6' THEN
    TastenNummerausName := 102
  ELSE
  IF Name = 'Num7' THEN
    TastenNummerausName := 103
  ELSE
  IF Name = 'Num8' THEN
    TastenNummerausName := 104
  ELSE
  IF Name = 'Num9' THEN
    TastenNummerausName := 105
  ELSE
  IF Name = 'Num*' THEN
    TastenNummerausName := 106
  ELSE
  IF Name = 'Num+' THEN
    TastenNummerausName := 107
  ELSE
  IF Name = 'Num-' THEN
    TastenNummerausName := 109
  ELSE
  IF Name = 'Num,' THEN
    TastenNummerausName := 110
  ELSE
  IF Name = 'Num/' THEN
    TastenNummerausName := 111
  ELSE
  IF Name = 'F1' THEN
    TastenNummerausName := 112
  ELSE
  IF Name = 'F2' THEN
    TastenNummerausName := 113
  ELSE
  IF Name = 'F3' THEN
    TastenNummerausName := 114
  ELSE
  IF Name = 'F4' THEN
    TastenNummerausName := 115
  ELSE
  IF Name = 'F5' THEN
    TastenNummerausName := 116
  ELSE
  IF Name = 'F6' THEN
    TastenNummerausName := 117
  ELSE
  IF Name = 'F7' THEN
    TastenNummerausName := 118
  ELSE
  IF Name = 'F8' THEN
    TastenNummerausName := 119
  ELSE
  IF Name = 'F9' THEN
    TastenNummerausName := 120
  ELSE
  IF Name = 'F10' THEN
    TastenNummerausName := 121
  ELSE
  IF Name = 'F11' THEN
    TastenNummerausName := 122
  ELSE
  IF Name = 'F12' THEN
    TastenNummerausName := 123
  ELSE
  IF Name = 'NumFeststell' THEN
    TastenNummerausName := 144
  ELSE
  IF Name = 'ScrollLock' THEN
    TastenNummerausName := 145
  ELSE
  IF AnsiLowerCase(Name) = 'ü' THEN
    TastenNummerausName := 186
  ELSE
  IF Name = '+' THEN
    TastenNummerausName := 187
  ELSE
  IF Name = ',' THEN
    TastenNummerausName := 188
  ELSE
  IF Name = '-' THEN
    TastenNummerausName := 189
  ELSE
  IF Name = '.' THEN
    TastenNummerausName := 190
  ELSE
  IF Name = '#' THEN
    TastenNummerausName := 191
  ELSE
  IF Name = 'ö' THEN
    TastenNummerausName := 192
  ELSE
  IF Name = 'ß' THEN
    TastenNummerausName := 219
  ELSE
  IF Name = '^' THEN
    TastenNummerausName := 220
  ELSE
  IF Name = '´' THEN
    TastenNummerausName := 221
  ELSE
  IF Name = 'ä' THEN
    TastenNummerausName := 222
  ELSE
  IF Name = '<' THEN
    TastenNummerausName := 226
  ELSE
    IF Length(Name) = 1 THEN
      TastenNummerausName := Ord(UpperCase(Name)[1])
    ELSE
      TastenNummerausName := 0;
END;

// sucht in einem Text eine Variable ($Variable#)
// die Zeichen $ und # dürfen nicht maskiert sein ($$, ##)
// in Position wird die Position der Variable und in Result die Länge zurückgegeben
FUNCTION Variablesuchen(Text: STRING; VAR Position: Integer): Integer;

VAR Position1,
    Position2 : Integer;

BEGIN
  Result := 0;
  IF Position < 1 THEN
    Position := 1;
  Position1 := 0;                                         // Variable suchen
  Position2 := Position - 2;
  REPEAT
    Position2 := PosX('#', Text, Position2 + 2, False, '#');  // # suchen
    IF Position2 > 0 THEN                                 // unmaskiertes # gefunden
    BEGIN
      Position1 := Position2 + 1;
      Position1 := PosX('$', Text, Position1 - 2, Position, True, '$');  // $ suchen
    END;
    IF Position1 > 0 THEN                                 // Variable gefunden
    BEGIN
      Position := Position1;                              // Position der Variablen
      Result := Position2 - Position1 + 1;                // Länge der Variablen
    END
    ELSE
      Dec(Position2);
  UNTIL (Result > 0) OR (Position2 < 1);
END;

// prüft ob in einem Text eine Variable ($Variable#) vorhanden ist
// die Zeichen $ und # dürfen nicht maskiert sein ($$, ##)
// Position ist die Position ab der gesucht wird
FUNCTION Variablevorhanden(Text: STRING; Position: Integer = -1): Boolean;
BEGIN
  Result := NOT (Variablesuchen(Text, Position) = 0);
END;

// ersetzt Variablen in einem Text durch Werte (in Textform),
// im ARRAY Variablen befinden sich Variablen und Werte abwechselnd beginnend mit der Variablen
// Format und Trennzeichen sind Standardvorgaben, BilderProSek wird zur Formatumrechnung benutzt
FUNCTION VariablenersetzenText(Text: STRING; Variablen: ARRAY OF STRING; Format, Trennzeichen: STRING; BilderProSek: Real): STRING; OVERLOAD;

VAR I, J,
    Position1,
    Position2,
    Position3,
    Laenge,
    Offset : Integer;
    HZahl : Integer;
    HString,
    HText,
    VariablenName,
    HFormat,
    HTrennzeichen : STRING;
    VariablenListe,
    ListeNull : Boolean;

BEGIN
  IF Text <> '' THEN
  BEGIN
    I := Low(Variablen);
    WHILE I < High(Variablen) DO                               // Variablen durchgehen
    BEGIN
      Position1 := 1;
      REPEAT
        Laenge := Variablesuchen(Text, Position1);
        IF Laenge > 0 THEN                                     // Variable gefunden
        BEGIN
          Position2 := PosX(';', Text, Position1 + 1, Position1 + Laenge - 1, False);
          IF Position2 = 0 THEN
            Position2 := Position1 + Laenge - 1;               // kein Trennzeichen gefunden
          IF PosX('list', LowerCase(Text), Position2, True) = Position2 - 4 THEN
          BEGIN
            VariablenName := Copy(Text, Position1, Position2 - Position1 - 4) + '1#';
            VariablenListe := True;
          END
          ELSE
          BEGIN
            VariablenName := Copy(Text, Position1, Position2 - Position1) + '#';
            VariablenListe := False;
          END;
          IF LowerCase(VariablenName) = LowerCase(Variablen[I]) THEN
          BEGIN                                                // Variable stimmt überein
            HFormat := Format;
            HTrennzeichen := Trennzeichen;
            Offset := 0;
            ListeNull := False;
            IF Position2 < Position1 + Laenge - 1 THEN         // Parameter vorhanden
            BEGIN
              HFormat := ParameterausTextStr(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'Format', '=', ';', ';', Format);
              Offset := ParameterausTextInt(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'Offset', '=', ';', 0);
              HTrennzeichen := ParameterausTextStr(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'Delimiter', '=', ';', ';', Trennzeichen);
              ListeNull := ParameterausTextInt(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'ListZero', '=', ';', 0) = 1;
            END;
            HText := '';
            IF ListeNull AND VariablenListe AND
              (ZeitStrInBildnummer(Variablen[I + 1], BilderProSek, [':', '.'], False) > 0) THEN
              HText := BildnummerInZeitStr(HFormat, 0, BilderProSek) + HTrennzeichen;
            J := 0;
            VariablenName := Copy(VariablenName, 1, Length(VariablenName) - 2); // Variablenname ohne Zahl und # am Ende
            REPEAT
              HString := Variablen[I + J + 1];
              IF HFormat <> '' THEN                            // Variablenformat ändern
              BEGIN
                HZahl := ZeitStrInBildnummer(HString, BilderProSek, [':', '.'], False);
                IF HZahl > - 1 THEN
                BEGIN
                  HZahl := HZahl + Offset;
                  IF HZahl < 0 THEN
                    HZahl := 0;
                  HString := BildnummerInZeitStr(HFormat, HZahl, BilderProSek);
                END;
              END;
              HText := HText + HString;                        // Variable einfügen
              IF (I + J + 2 < High(Variablen)) AND             // es sind noch weitere Variablen vorhanden
                 VariablenListe THEN                           // es ist eine Variablenliste
              BEGIN
                IF LowerCase(VariablenName + IntToStr((J + 4) DIV 2) + '#') = LowerCase(Variablen[I + J + 2]) THEN // der Variablenname entspricht der nächsten Variablen
                BEGIN
                  HText := HText + HTrennzeichen;              // Trennzeichen einfügen
                  Inc(J, 2);
                  VariablenListe := True;                      // kein Schleifenabbruch
                END
                ELSE
                  VariablenListe := False;                     // Schleifenabbruch
              END
              ELSE
                VariablenListe := False;                       // Schleifenabbruch
            UNTIL NOT VariablenListe;
            Position2 := PosX('$', Text, Position1 - 1, True, '$'); // vorherigen Variablenanfang suchen
            Position3 := PosX('#', Text, Position1 - 1, True, '#'); // vorheriges Variablenende suchen
            IF Position3 > Position2 THEN
              Position2 := Position3;
            Position2 := PosX('§', Text, Position1, Position2, True, '§');
            IF Position2 > 0 THEN                              //  Vorspann entfernen
            BEGIN
              HString := Copy(Text, Position2 + 1, Position1 - (Position2 + 1));
              Laenge := Laenge + Position1 - Position2;
              Position1 := Position2;
              HText := Hstring + HText;
            END;
            Position2 := PosX('$', Text, Position1 + Laenge, False, '$'); // nächsten Variablenanfang suchen
            Position3 := PosX('#', Text, Position1 + Laenge, False, '#'); // nächstes Variablenende suchen
            IF Position3 < Position2 THEN
              Position2 := Position3;
            Position2 := PosX('&', Text, Position1 + Laenge, Position2, False, '&');
            IF Position2 > 0 THEN                              //  Nachspann entfernen
            BEGIN
              HString := Copy(Text, Position1 + Laenge, Position2 - (Position1 + Laenge));
              Laenge := Position2 - Position1 + 1;
              HText := HText + Hstring;
            END
            ELSE;
            Text := LeftStr(Text, Position1 - 1) + HText + RightStr(Text, Length(Text) + 1 - (Position1 + Laenge));
          END
          ELSE
            Inc(Position1);
        END;
      UNTIL Laenge < 1;
      Inc(I, 2);
    END;
  END;
  Result := Text;
END;

// ersetzt Variablen in einem Text durch Werte (in Textform), im ARRAY Variablen befinden sich
// Variablen und Werte abwechselnd beginnend mit der Variablen
FUNCTION VariablenersetzenText(Text: STRING; Variablen: ARRAY OF STRING): STRING; OVERLOAD;
BEGIN
  Result := VariablenersetzenText(Text, Variablen, '', '', 25);
END;

// ersetzt Variablen in einem Text durch Werte (in Textform),
// in der Stringliste Variablen befinden sich Variablen und Werte abwechselnd beginnend mit der Variablen
// Format und Trennzeichen sind Standardvorgaben, BilderProSek wird zur Formatumrechnung benutzt
FUNCTION VariablenersetzenText(Text: STRING; Variablen: TStrings; Format, Trennzeichen: STRING; BilderProSek: Real): STRING; OVERLOAD;

VAR I, J,
    Position1,
    Position2,
    Position3,
    Laenge,
    Offset : Integer;
    HZahl : Integer;
    HString,
    HText,
    VariablenName,
    HFormat,
    HTrennzeichen : STRING;
    VariablenListe,
    ListeNull : Boolean;

BEGIN
  IF Assigned(Variablen) AND
     (Text <> '') THEN
  BEGIN
    I := 0;
    WHILE I < Variablen.Count - 1 DO                           // Variablen durchgehen
    BEGIN
      Position1 := 1;
      REPEAT
        Laenge := Variablesuchen(Text, Position1);
        IF Laenge > 0 THEN                                     // Variable gefunden
        BEGIN
          Position2 := PosX(';', Text, Position1 + 1, Position1 + Laenge - 1, False);
          IF Position2 = 0 THEN
            Position2 := Position1 + Laenge - 1;               // kein Trennzeichen gefunden
          IF PosX('list', LowerCase(Text), Position2, True) = Position2 - 4 THEN
          BEGIN
            VariablenName := Copy(Text, Position1, Position2 - Position1 - 4) + '1#';
            VariablenListe := True;
          END
          ELSE
          BEGIN
            VariablenName := Copy(Text, Position1, Position2 - Position1) + '#';
            VariablenListe := False;
          END;
          IF LowerCase(VariablenName) = LowerCase(Variablen[I]) THEN
          BEGIN                                                // Variable stimmt überein
            HFormat := Format;
            HTrennzeichen := Trennzeichen;
            Offset := 0;
            ListeNull := False;
            IF Position2 < Position1 + Laenge - 1 THEN         // Parameter vorhanden
            BEGIN
              HFormat := ParameterausTextStr(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'Format', '=', ';', ';', Format);
              Offset := ParameterausTextInt(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'Offset', '=', ';', 0);
              HTrennzeichen := ParameterausTextStr(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'Delimiter', '=', ';', ';', Trennzeichen);
              ListeNull := ParameterausTextInt(Copy(Text, Position2 + 1, Position1 + Laenge - Position2 - 2), 'ListZero', '=', ';', 0) = 1;
            END;
            HText := '';
            IF ListeNull AND VariablenListe AND
              (ZeitStrInBildnummer(Variablen[I + 1], BilderProSek, [':', '.'], False) > 0) THEN
              HText := BildnummerInZeitStr(HFormat, 0, BilderProSek) + HTrennzeichen;
            J := 0;
            VariablenName := Copy(VariablenName, 1, Length(VariablenName) - 2); // Variablenname ohne Zahl und # am Ende
            REPEAT
              HString := Variablen[I + J + 1];
              IF HFormat <> '' THEN                            // Variablenformat ändern
              BEGIN
                HZahl := ZeitStrInBildnummer(HString, BilderProSek, [':', '.'], False);
                IF HZahl > - 1 THEN
                BEGIN
                  HZahl := HZahl + Offset;
                  IF HZahl < 0 THEN
                    HZahl := 0;
                  HString := BildnummerInZeitStr(HFormat, HZahl, BilderProSek);
                END;
              END;
              HText := HText + HString;                        // Variable einfügen
              IF (I + J + 2 < Variablen.Count - 1) AND         // es sind noch weitere Variablen vorhanden
                 VariablenListe THEN                           // es ist eine Variablenliste
              BEGIN
                IF LowerCase(VariablenName + IntToStr((J + 4) DIV 2) + '#') = LowerCase(Variablen[I + J + 2]) THEN // der Variablenname entspricht der nächsten Variablen
                BEGIN
                  HText := HText + HTrennzeichen;              // Trennzeichen einfügen
                  Inc(J, 2);
                  VariablenListe := True;                      // kein Schleifenabbruch
                END
                ELSE
                  VariablenListe := False;                     // Schleifenabbruch
              END
              ELSE
                VariablenListe := False;                       // Schleifenabbruch
            UNTIL NOT VariablenListe;
            Position2 := PosX('$', Text, Position1 - 1, True, '$'); // vorherigen Variablenanfang suchen
            Position3 := PosX('#', Text, Position1 - 1, True, '#'); // vorheriges Variablenende suchen
            IF Position3 > Position2 THEN
              Position2 := Position3;
            Position2 := PosX('§', Text, Position1, Position2, True, '§');
            IF Position2 > 0 THEN                              //  Vorspann entfernen
            BEGIN
              HString := Copy(Text, Position2 + 1, Position1 - (Position2 + 1));
              Laenge := Laenge + Position1 - Position2;
              Position1 := Position2;
              HText := Hstring + HText;
            END;
            Position2 := PosX('$', Text, Position1 + Laenge, False, '$'); // nächsten Variablenanfang suchen
            Position3 := PosX('#', Text, Position1 + Laenge, False, '#'); // nächstes Variablenende suchen
            IF Position3 < Position2 THEN
              Position2 := Position3;
            Position2 := PosX('&', Text, Position1 + Laenge, Position2, False, '&');
            IF Position2 > 0 THEN                              //  Nachspann entfernen
            BEGIN
              HString := Copy(Text, Position1 + Laenge, Position2 - (Position1 + Laenge));
              Laenge := Position2 - Position1 + 1;
              HText := HText + Hstring;
            END
            ELSE;
            Text := LeftStr(Text, Position1 - 1) + HText + RightStr(Text, Length(Text) + 1 - (Position1 + Laenge));
          END
          ELSE
            Inc(Position1);
        END;
      UNTIL Laenge < 1;
      Inc(I, 2);
    END;
  END;
  Result := Text;
END;

// ersetzt Variablen in einem Text durch Werte (in Textform), in der Stringliste Variablen befinden sich
// Variablen und Werte abwechselnd beginnend mit der Variablen
FUNCTION VariablenersetzenText(Text: STRING; Variablen: TStrings): STRING; OVERLOAD;
BEGIN
  Result := VariablenersetzenText(Text, Variablen, '', '', 25);
END;

// ersetzt in einer Datei alle Variablen durch Werte (in Textform)
//  0 : Ok
// -1 : Parameter unvollständig
// -2 : Quelldatei existiert nicht
FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: ARRAY OF STRING; Format, Trennzeichen: STRING; BilderProSek: Real): Integer; OVERLOAD;

VAR Textdatei : TStringList;

BEGIN
  IF (QuellDatei <> '') AND (ZielDatei <> '') THEN
    IF FileExists(QuellDatei) THEN
    BEGIN
      Textdatei := TStringList.Create;
      Textdatei.LoadFromFile(QuellDatei);
      Textdatei.Text := VariablenersetzenText(Textdatei.Text, Variablen, Format, Trennzeichen, BilderProSek);
      IF NOT DirectoryExists(ExtractFilePath(ZielDatei)) THEN
        ForceDirectories(ExtractFilePath(ZielDatei));      // eventuell ein fehlendes Verzeichnis erzeugen
      Textdatei.SaveToFile(ZielDatei);
      Textdatei.Free;
      Result := 0;
    END
    ELSE
      Result := -2
  ELSE
    Result := -1;
END;

FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: ARRAY OF STRING): Integer; OVERLOAD;
BEGIN
  Result := VariablenersetzenDatei(QuellDatei, ZielDatei, Variablen, '', '', 25);
END;

// ersetzt in einer Datei alle Variablen durch Werte (in Textform)
//  0 : Ok
// -1 : Parameter unvollständig
// -2 : Quelldatei existiert nicht
FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: TStrings; Format, Trennzeichen: STRING; BilderProSek: Real): Integer; OVERLOAD;

VAR Textdatei : TStringList;

BEGIN
  IF (QuellDatei <> '') AND (ZielDatei <> '') THEN
    IF FileExists(QuellDatei) THEN
    BEGIN
      Textdatei := TStringList.Create;
      Textdatei.LoadFromFile(QuellDatei);
      Textdatei.Text := VariablenersetzenText(Textdatei.Text, Variablen, Format, Trennzeichen, BilderProSek);
      IF NOT DirectoryExists(ExtractFilePath(ZielDatei)) THEN
        ForceDirectories(ExtractFilePath(ZielDatei));      // eventuell ein fehlendes Verzeichnis erzeugen
      Textdatei.SaveToFile(ZielDatei);
      Textdatei.Free;
      Result := 0;
    END
    ELSE
      Result := -2
  ELSE
    Result := -1;
END;

FUNCTION VariablenersetzenDatei(QuellDatei, ZielDatei: STRING; Variablen: TStrings): Integer; OVERLOAD;
BEGIN
  Result := VariablenersetzenDatei(QuellDatei, ZielDatei, Variablen, '', '', 25);
END;

// sucht eine Zuweisung in einem Text
// Result gibt die Position nach dem Zuweisungszeichen zurück
// wurde keine Zuweisung gefunden gibt Result 0 zurück
FUNCTION Zuweisungsuchen(Text, Zuweisungszeichen, Trennzeichen: STRING; Position: Integer; VAR Variable, Wert: STRING): Integer;

VAR Position2, Position3 : Integer;

BEGIN
  IF Position < 1 THEN
    Position := 1;
  REPEAT
    Position2 := PosX(Zuweisungszeichen, Text, Position, False); // Zuweisungszeichen
    Position3 := PosX(Trennzeichen, Text, Position, False);      // Trennzeichen
    IF Position3 = 0 THEN                                        // kein Trennzeichen gefunden
      Position3 := Length(Text) + 1;                             // Textende + 1
    IF Position3 < Position2 THEN                      // Trennzeichen liegt vor dem Zuweisungszeichen
      Position := Position3 + Length(Trennzeichen);    // ab Trennzeichen wiederholen
  UNTIL (Position2 = 0) OR                             // kein Zuweisungszeichen gefunden
        ((Position < Position2) AND                    // Variable und Parameter gefunden
        (Position2 < Position3));
  IF Position2 > 0 THEN
  BEGIN
    Variable := '$' + Trim(Copy(Text, Position, Position2 - Position)) + '#';
    Wert := Trim(Copy(Text, Position2 + Length(Zuweisungszeichen), Position3 - (Position2 + Length(Zuweisungszeichen))));
    IF Position3 > Length(Text) THEN
      Result := Position3
    ELSE
      Result := Position3 + Length(Trennzeichen);
  END
  ELSE
  BEGIN
    Variable := '';
    Wert := '';
    Result := 0;
  END
END;

// fügt Variablen zu einem Arry hinzu
// ist die Variable schon vorhanden wird ihr Wert ersetzt
// ist das Array zu klein wird der zusätzlich benötigte Platz zurückgegeben
FUNCTION Variablesetzen(VAR Variablen: ARRAY OF STRING; Variable, Wert: STRING): Integer;

VAR I : Integer;

BEGIN
  Result := 0;
  IF Variable <> '' THEN
  BEGIN
    I := 0;
    WHILE (I < High(Variablen)) AND                    // Variable im Variablenarray suchen
          (Variablen[I] <> Variable) AND
          (Variablen[I] <> '') DO                      // freie Variable
      Inc(I, 2);
    IF I < High(Variablen) THEN                        // Variable oder freien Platz gefunden
    BEGIN
      Variablen[I] := Variable;
      Variablen[I + 1] := Wert;
    END
    ELSE
      Inc(Result);
  END;
END;

// fügt Variablen zu einer Stringliste hinzu
// ist die Variable schon vorhanden wird ihr Wert ersetzt
//  0 : Ok
// -1 : keine Variablenliste übergeben
FUNCTION Variablesetzen(Variablen: TStrings; Variable, Wert: STRING): Integer;

VAR I : Integer;

BEGIN
  IF Assigned(Variablen) THEN
  BEGIN
    Result := 0;
    IF Variable <> '' THEN
    BEGIN
      I := 0;
      WHILE (I < Variablen.Count) AND                    // Variable in der Variablenliste suchen
            (Variablen[I] <> Variable) DO
        Inc(I, 2);
      WHILE I + 2 > Variablen.Count DO                   // Variable nicht gefunden
        Variablen.Add('');                               // entsprechend Einträge anhängen
      Variablen[I] := Variable;
      Variablen[I + 1] := Wert;
    END;
  END
  ELSE
    Result := -1;
END;

// kopiert Variablen und Werte in ein VariablenArray
// vorhandene gleiche Variablen werden überschrieben
// ist das Array zu klein wird der zusätzlich benötigte Platz zurückgegeben
FUNCTION VariablenausText(Text, Zuweisungszeichen, Trennzeichen: STRING; VAR Variablen:  ARRAY OF STRING): Integer; OVERLOAD;

VAR Position : Integer;
    Variable, Wert: STRING;

BEGIN
  Result := 0;
  Position := 1;
  REPEAT
    Position := Zuweisungsuchen(Text, Zuweisungszeichen, Trennzeichen, Position, Variable, Wert);
    IF Position > 0 THEN
      Result := Variablesetzen(Variablen, Variable, Wert);
  UNTIL Position = 0;
END;

// kopiert Variablen und Werte in eine Stringliste
// vorhandene gleiche Variablen werden überschrieben
//  0 : Ok
// -1 : keine Variablenliste übergeben
FUNCTION VariablenausText(Text, Zuweisungszeichen, Trennzeichen: STRING; Variablen: TStrings): Integer; OVERLOAD;

VAR Position : Integer;
    Variable, Wert: STRING;

BEGIN
  Result := 0;
  Position := 1;
  REPEAT
    Position := Zuweisungsuchen(Text, Zuweisungszeichen, Trennzeichen, Position, Variable, Wert);
    IF Position > 0 THEN
      Result := Variablesetzen(Variablen, Variable, Wert);
  UNTIL Position = 0;
END;

// liest einen Integerparameter aus einen Text
FUNCTION ParameterausTextInt(Text, Parameter, Zuweisungszeichen, Trennzeichen: STRING; DefaultParameter: Integer): Integer;

VAR Position1,
    Position2 : Integer;
    Abbrechen : Boolean;

BEGIN
  Result := DefaultParameter;
  Abbrechen := False;
  Position1 := Pos(Parameter, Text);
  WHILE (Position1 > 0) AND (NOT Abbrechen) DO
  BEGIN
    IF ((Position1 = 1) OR                           // Parameter steht am Anfang
       (Text[Position1 - 1] = ' ') OR                // vor dem Parameter ist ein Leerzeichen
       (Text[Position1 - 1] = Trennzeichen)) OR      // vor dem Parameter ist ein Trennzeichen
       (Text[Position1 - 1] = Chr(13)) OR            // vor dem Parameter ist ein Enter
       (Text[Position1 - 1] = Chr(10)) THEN          // vor dem Parameter ist ein LF
    BEGIN                                            // Parameteranfang gefunden
      Position1 := Position1 + Length(Parameter);    // zum Parameterende gehen
      WHILE (Position1 < Length(Text) + 1) AND (Text[Position1] = ' ') DO
        Inc(Position1);                              // Leerzeichen überspringen
      IF Text[Position1] = Zuweisungszeichen THEN
      BEGIN
        Inc(Position1);
        WHILE (Position1 < Length(Text) + 1) AND (Text[Position1] = ' ') DO
          Inc(Position1);                            // Leerzeichen überspringen
        Position2 := Position1;
        WHILE (Position2 < Length(Text) + 1) AND (Text[Position2] IN ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-']) DO
          Inc(Position2);                            // Zahlen überspringen
        IF (Position2 > Length(Text)) OR (Text[Position2] = ' ') OR (Text[Position2] = Trennzeichen) THEN
        BEGIN
          Result := StrToIntDef(Copy(Text, Position1, Position2 - Position1), DefaultParameter);
          Abbrechen := True;
        END;
      END;
    END;
    Position1 := PosX(Parameter, Text, Position1 + 1, False);
  END;
END;

// liest einen Stringparameter aus einen Text
FUNCTION ParameterausTextStr(Text, Parameter, Zuweisungszeichen, Trennzeichen: STRING; Maske: Char; DefaultParameter: STRING): STRING;

VAR Position1,
    Position2 : Integer;
    Abbrechen : Boolean;

BEGIN
  Result := DefaultParameter;
  Abbrechen := False;
  Position1 := Pos(LowerCase(Parameter), LowerCase(Text));
  WHILE (Position1 > 0) AND (NOT Abbrechen) DO
  BEGIN
    IF ((Position1 = 1) OR                           // Parameter steht am Anfang
       (Text[Position1 - 1] = ' ') OR                // vor dem Parameter ist ein Leerzeichen
       (Text[Position1 - 1] = Trennzeichen)) OR      // vor dem Parameter ist ein Trennzeichen
       (Text[Position1 - 1] = Chr(13)) OR            // vor dem Parameter ist ein Enter
       (Text[Position1 - 1] = Chr(10)) THEN          // vor dem Parameter ist ein LF
    BEGIN                                            // Parameteranfang gefunden
      Position1 := Position1 + Length(Parameter);    // zum Parameterende gehen
      WHILE (Position1 < Length(Text) + 1) AND (Text[Position1] = ' ') DO
        Inc(Position1);                              // Leerzeichen überspringen
      IF Text[Position1] = Zuweisungszeichen THEN
      BEGIN
        Inc(Position1);
        WHILE (Position1 < Length(Text) + 1) AND (Text[Position1] = ' ') DO
          Inc(Position1);                            // Leerzeichen überspringen
        Position2 := PosX(Trennzeichen, Text, Position1, False, Maske); // Trennzeichen suchen und Maskierung beachten
        IF Position2 = 0 THEN
          Position2 := Length(Text) + 1;             // Textende erreicht
        WHILE (Position2 > Position1) AND (Text[Position2 - 1] = ' ') DO
          Dec(Position2);                            // Leerzeichen rückwärts überspringen
        IF (Position2 > Length(Text)) OR (Text[Position2] = ' ') OR (Text[Position2] = Trennzeichen) THEN
        BEGIN
          Result := Copy(Text, Position1, Position2 - Position1);
          Result := MaskierungenentfernenText(Result, [Maske]);
          Abbrechen := True;
        END;
      END;
    END;
    Position1 := PosX(Parameter, Text, Position1 + 1, False);
  END;
END;

// löscht in einem Text alle Maskierungszeichen
FUNCTION MaskierungenentfernenText(Text: STRING; Maske: TZeichen): STRING;

VAR Position : Integer;

BEGIN
  IF Text <> '' THEN
  BEGIN
    Position := 1;
    REPEAT
      Position := PosX(Maske, Text, Position, False, False);
      IF Position > 0 THEN
      BEGIN
        Text := LeftStr(Text, Position - 1) + RightStr(Text, Length(Text) - Position);
        Inc(Position);
      END;
    UNTIL Position = 0;
    Result := Text;
  END
  ELSE
    Result := '';
END;

// löscht in einem Text alle Variablen
FUNCTION VariablenentfernenText(Text: STRING): STRING;

VAR Position1,
    Position2,
    Position3,
    Laenge : Integer;

BEGIN
  REPEAT
    Position1 := 1;
    Laenge := Variablesuchen(Text, Position1);          // Variable suchen
    IF Laenge > 0 THEN                                  // Variable gefunden
    BEGIN
// " direkt vor und hinter der Variablen entfernen
      IF (Position1 > 1) AND                            // vor der Variablen ist noch etwas
         (Position1 + Laenge - 1 < Length(Text)) AND    // nach der Variablen ist noch etwas
         (Text[Position1 - 1] = '"') AND                // wenn vorher ein " ist
         (Text[Position1 + Laenge] = '"') THEN          // und nachher ein " ist
      BEGIN
        Dec(Position1);                                 // mit löschen
        Inc(Laenge, 2);
      END;
      Position2 := Position1;
// § vor der Variablen entfernen
      Position1 := PosX('$', Text, Position2 - 1, True, '$'); // vorherigen Variablenanfang suchen
      Position3 := PosX('#', Text, Position2 - 1, True, '#'); // vorheriges Variablenende suchen
      IF Position3 > Position1 THEN
        Position1 := Position3;
      Position1 := PosX('§', Text, Position2 - 1, Position1, True, '§');
      IF Position1 > 0 THEN                             // § Zeichen vor der Variable gefunden
        Laenge := Laenge + Position2 - Position1        // neue Länge der Variablen berechnen
      ELSE
        Position1 := Position2;
// & nach der Variablen entfernen
      Position2 := PosX('$', Text, Position1 + Laenge, False, '$'); // nächsten Variablenanfang suchen
      Position3 := PosX('#', Text, Position1 + Laenge, False, '#'); // nächstes Variablenende suchen
      IF Position3 < Position2 THEN
        Position2 := Position3;
      Position2 := PosX('&', Text, Position1 + Laenge, Position2, False, '&');
      IF Position2 > 0 THEN                             // & Zeichen nach der Variable gefunden
        Laenge := Position2 - Position1 + 1;            // neue Länge der Variablen berechnen
// Leerzeichen vor der Variablen entfernen
      IF (Position1 > 1) AND                            // vor der Variablen ist noch etwas
         (Text[Position1 - 1] = ' ') THEN               // wenn es ein Leerzeichen ist
      BEGIN
        Dec(Position1);                                 // mit löschen
        Inc(Laenge);
      END
      ELSE
// ist vor der Variablen kein Leerzeichen sondern ein Zeilenanfang oder ein " und nach der Variablen
// steht ein Leerzeichen dieses mit entfernen
        IF ((Position1 = 1) OR                          // vor der Variablen ist nichts mehr
           (Text[Position1 - 1] = '"') OR               // oder ein "
           (Text[Position1 - 1] = Chr(13)) OR           // oder ein Enter
           (Text[Position1 - 1] = Chr(10))) AND         // oder ein LF
           (Position1 + Laenge - 1 < Length(Text)) AND
           (Text[Position1 + Laenge] = ' ') THEN        // und nach der Variablen steht ein Leerzeichen
          Inc(Laenge)                                   // mit löschen
        ELSE
// ist vor der Variablen ein Zeilenanfang und nach der Variablen ein Zeilenende dieses mitentfernen
          IF ((Position1 = 1) OR                          // vor der Variablen ist nichts mehr
             (Text[Position1 - 1] = Chr(13)) OR           // oder ein Enter
             (Text[Position1 - 1] = Chr(10))) AND         // oder ein LF
             (Position1 + Laenge - 1 < Length(Text)) AND  // und nach der Variablen ist noch etwas
             ((Text[Position1 + Laenge] = Chr(13)) OR     // und nach der Variablen steht ein Enter
             (Text[Position1 + Laenge] = Chr(10))) THEN   // oder nach der Variablen steht ein LF
          BEGIN
            Inc(Laenge);
            IF (Position1 + Laenge - 1 < Length(Text)) AND  // nach der Variablen ist noch etwas
               ((Text[Position1 + Laenge] = Chr(13)) OR     // und nach der Variablen steht ein Enter
               (Text[Position1 + Laenge] = Chr(10))) THEN   // oder nach der Variablen steht ein LF
              Inc(Laenge);
          END;
// Text vor und hinter der Variablen zusammenkopieren
      Text := LeftStr(Text, Position1 - 1) + RightStr(Text, Length(Text) + 1 - (Position1 + Laenge));
    END;
  UNTIL Laenge = 0;                                     // keine Variable gefunden
  Result := MaskierungenentfernenText(Text, ['§', '$', '&', '#']);
END;

// löscht in einer Datei alle Variablen
PROCEDURE VariablenentfernenDatei(Dateiname: STRING);

VAR Textdatei : TStringList;

BEGIN
  IF (Dateiname <> '') AND FileExists(Dateiname) THEN
  BEGIN
    Textdatei := TStringList.Create;
    Textdatei.LoadFromFile(Dateiname);
    Textdatei.Text := VariablenentfernenText(Textdatei.Text);
    Textdatei.SaveToFile(Dateiname);
    Textdatei.Free;
  END;
END;

// kopiert die Zeichen die zwischen den "Vontext" und "Bistext" Zeichen stehen
// dabei können die gesuchten Zeichen mitkopiert werden ("MitVonText", "MitBisText")
// Position ist die Startposition ab der gesucht wird
// wird "Bistext" nicht gefunden wird alles bis zum Ende kopiert
FUNCTION KopiereVonBis(Text, VonText, BisText: STRING; MitVonText: Boolean = False; MitBisText: Boolean = False; Position: Integer = 1): STRING;

VAR Position1,
    Position2 : Integer;

BEGIN
  Result := '';
  IF VonText = '' THEN               // '' bedeutet vom Anfang an kopieren
    Position1 := Position
  ELSE
  BEGIN
    Position1 := PosX(VonText, Text, Position, False);
    IF (Position1 > 0) AND (NOT MitVonText) THEN
      Position1 := Position1 + Length(Vontext);
  END;
  IF Position1 > 0 THEN              // ohne Anfangsposition macht es keinen Sinn
  BEGIN
    IF BisText = '' THEN             // '' bedeutet bis zum Ende
      Position2 := Length(Text) + 1
    ELSE
    BEGIN
      Position2 := PosX(BisText, Text, Position1, False);
      IF Position2 = 0 THEN
        Position2 := Length(Text) + 1
      ELSE
        IF MitBisText THEN
          Position2 := Position2 + Length(Bistext);
    END;
    IF Position2 > 0 THEN            // ohne Endposition macht es keinen Sinn
      Result := Copy(Text, Position1, Position2 -Position1);
  END;
END;

// gibt den N'ten Parameter zurück
// Trennzeichen die in "" stehen werden ignoriert
FUNCTION KopiereParameter(Text: STRING; Ntes: Integer; Trennzeichen: STRING; Alles: Boolean = False): STRING; OVERLOAD;

VAR Gaensefuesschen : ARRAY OF Integer;
    I, J,
    Position1,
    Position2,
    Position3 : Integer;

BEGIN
  SetLength(Gaensefuesschen, 10);
  Position1 := 1;
  I := 0;
  REPEAT                                                    // Variablenliste mit Gänsefüßchenblöcke erstellen
    Position2 := PosX('"', Text, Position1, False);         // erstes " suchen
    IF Position2 > 0 THEN
    BEGIN
      IF I > High(Gaensefuesschen) THEN
        SetLength(Gaensefuesschen, I + 2);
      Gaensefuesschen[I] := Position2;
      Inc(Position2);
      Position1 := PosX('"', Text, Position2, False);       // zweites " suchen
      IF Position1 = 0 THEN
        Position1 := Length(Text) + 1;                      // kein zweites " gefunden
      Gaensefuesschen[I + 1] := Position1;
      Inc(Position1);
      Inc(I, 2);
    END;
  UNTIL Position2 = 0;
  Position2 := 1;
  J := 0;
  REPEAT                                                    // Nten Parameter suchen
    Position1 := PosX([Trennzeichen[1]], Text, Position2, False, True); // weitere Trennzeichen überspringen
    Position3 := Position1;
    REPEAT
      Position2 := PosX(Trennzeichen, Text, Position3, False); // Trennzeichen suchen
      IF Position2 = 0 THEN
        Position2 := Length(Text) + 1;                      // kein Trennzeichen gefunden
      I := 0;
      WHILE (Position2 > 0) AND                             // prüfen ob Trennzeichen in einem
            (I <= High(Gaensefuesschen)) DO                 // Gänsefüßchenblock liegt
      BEGIN
        IF (Position2 > Gaensefuesschen[I]) AND
           (Position2 < Gaensefuesschen[I + 1]) THEN
        BEGIN                                               // Trennzeichen liegt in einem Gänsefüßchenblock
          Position3 := Position2 + 1;
          Position2 := 0;
        END;
        Inc(I, 2);
      END;
    UNTIL Position2 > 0;
    Inc(J);
  UNTIL (J = Ntes) OR (Position2 > Length(Text));
  IF J = Ntes THEN
  BEGIN
    IF Alles THEN
      Result := Copy(Text, Position1, Length(Text) + 1 - Position1) // restliche Parameter kopieren
    ELSE
    BEGIN
      Result := Copy(Text, Position1, Position2 - Position1); // Parameter kopieren
      IF Pos('"', Result) = 1 THEN
         Result := RightStr(Result, Length(Result) - 1);      // Gänsefüßchen entfernen
      IF Pos('"', Result) = Length(Result) THEN
         Result := Leftstr(Result, Length(Result) - 1);
    END;
  END
  ELSE
    Result := '';                                          // kein Nter Parameter vorhanden
  Finalize(Gaensefuesschen);
END;

FUNCTION KopiereParameter(Text: STRING; Ntes: Integer = 1; Alles: Boolean = False): STRING; OVERLOAD;
BEGIN
  Result := KopiereParameter(Text, Ntes, ' ', Alles);
END;

// entfernt die enschließenden Gänsefüßchen
FUNCTION OhneGaensefuesschen(Text: STRING): STRING;
BEGIN
  IF Text[1] = '"' THEN
    IF Text[Length(Text)] = '"' THEN
      Result := Copy(Text, 2, Length(Text) - 2)
    ELSE
      Result := RightStr(Text, Length(Text) - 1)
  ELSE
    IF Text[Length(Text)] = '"' THEN
      Result := LeftStr(Text, Length(Text) - 1)
    ELSE
      Result := Text;  
END;

// ------------ Suchen im Text --------------

// sucht ein Wort in einem Text vorwärts oder rückwärts ab der Startposition
FUNCTION PosX(Wort, Text: STRING; StartPosition: Integer; Rueckwaerts: Boolean): Integer; OVERLOAD;

VAR I, J,
    Wortlaenge,
    Textlaenge : Integer;

BEGIN
  Result := 0;                                   // nichts gefunden
  Textlaenge := Length(Text);
  Wortlaenge := Length(Wort);
  IF StartPosition = 0 THEN                      // Startposition auf Anfang oder Ende setzen
    IF Rueckwaerts THEN
      StartPosition := Textlaenge
    ELSE
      StartPosition := 1;
  IF Rueckwaerts THEN
    I := StartPosition - Wortlaenge + 1          // I soll am Anfang des Wortes stehen
  ELSE
    I := StartPosition;
  IF (Textlaenge > 0) AND
     (Wortlaenge > 0) THEN
  BEGIN
    WHILE (I < Textlaenge - Wortlaenge + 2) AND  // äussere Schleife (Text durchsuchen)
          (I > 0) AND
          (Result = 0) DO
    BEGIN
      IF Rueckwaerts THEN
        J := Wortlaenge
      ELSE
        J := 1;
      WHILE (J < Wortlaenge + 1) AND             // innere Schleife (Wort durchsuchen)
            (J > 0) AND
            (Text[I + J - 1] = Wort[J]) DO
        IF Rueckwaerts THEN
          Dec(J)
        ELSE
          Inc(J);
      IF Rueckwaerts THEN
      BEGIN
        IF J = 0 THEN                            // das ganze Wort gefunden
          Result := I;
      END
      ELSE
        IF J = Wortlaenge + 1 THEN               // das ganze Wort gefunden
          Result := I;
      IF Rueckwaerts THEN
        Dec(I)
      ELSE
        Inc(I);
    END;
  END;
END;

// sucht ein Wort in einem Text vorwärts oder rückwärts ab der Startposition bis zur Endposition
FUNCTION PosX(Wort, Text: STRING; StartPosition, EndPosition: Integer; rueckwaerts: Boolean): Integer; OVERLOAD;
BEGIN
  IF EndPosition = 0 THEN
    IF rueckwaerts THEN
      Endposition := 1
    ELSE
      EndPosition := Length(Text);
  Result := PosX(Wort, Text, StartPosition, rueckwaerts);
  IF rueckwaerts THEN
  BEGIN
    IF Result < EndPosition THEN
      Result := 0;
  END
  ELSE
    IF Result > EndPosition THEN
      Result := 0;
END;

// sucht ein Wort aus einer Wortliste in einem Text vorwärts oder rückwärts ab der Startposition
FUNCTION PosX(Wortliste: TStrings; Text: STRING; StartPosition: Integer; Rueckwaerts: Boolean; VAR Laenge: Integer): Integer; OVERLOAD;

VAR I : Integer;
    Erg : Integer;

BEGIN
  Result := 0;
  Laenge := 0;
  FOR I := 0 TO Wortliste.Count - 1 DO
  BEGIN
    Erg := PosX(Wortliste.Strings[I], Text, StartPosition, Rueckwaerts);
    IF Erg > 0 THEN
      IF (Result = 0) OR
         ((Erg < Result) AND (NOT Rueckwaerts)) OR
         ((Erg > Result) AND Rueckwaerts) THEN
      BEGIN
        Result := Erg;
        Laenge := Length(Wortliste.Strings[I]);
      END;  
  END;
END;

// sucht das nächste Zeichen eines Textes das in einer Menge (nicht) enthalten ist, vorwärts oder rückwärts
FUNCTION PosX(Zeichenmenge: TZeichen; Text: STRING; StartPosition: Integer; Rueckwaerts, Zeichennichtvorhanden: Boolean): Integer; OVERLOAD;

VAR I, Textlaenge : Integer;

BEGIN
  Result := 0;                                   // nichts gefunden
  Textlaenge := Length(Text);
  IF StartPosition = 0 THEN                      // Startposition auf Anfang oder Ende setzen
    IF Rueckwaerts THEN
      StartPosition := Textlaenge
    ELSE
      StartPosition := 1;
  I := StartPosition;
  WHILE (I < Textlaenge + 1) AND
        (I > 0) AND
        (Result = 0) DO                          // sucht das nächste Zeichen
  BEGIN
    IF Zeichennichtvorhanden THEN
    BEGIN
      IF NOT (Text[I] IN Zeichenmenge) THEN
        Result := I;
    END
    ELSE
    BEGIN
      IF Text[I] IN Zeichenmenge THEN
        Result := I;
    END;
    IF Rueckwaerts THEN
      Dec(I)
    ELSE
      Inc(I);
  END;
END;

// Sucht Wort in Text ab der Position vorwärts oder rückwärts und prüft ob das Wort maskiert ist
// ist die Wortlänge größer 1 muß Wort neben dem zeichen Maske mindestens ein anderes Zeichen enthalten
FUNCTION PosX(Wort, Text: STRING; Position: Integer; rueckwaerts: Boolean; Maske: Char): Integer; OVERLOAD;
BEGIN
  REPEAT
    RESULT := PosX(Wort, Text, Position, rueckwaerts);  // Wort suchen
    IF Result > 0 THEN                                  // Wort gefunden
    BEGIN
      IF rueckwaerts THEN                               // falls weitergesucht werden muß
        Position := Result - 2                          // neue Position vor der Maske setzen
      ELSE
        IF (Length(Wort) = 1) AND                       // ist Wort ein Zeichen lang und
           (Wort[1] = Maske) THEN                       // ist Wort = Zeichen
          Position := Result + 2                        // muß 2 Schritte vorgesprungen werden
        ELSE
          Position := Result + 1;                       // nur ein Schritt
      IF rueckwaerts THEN                               // wird rückwärts gesucht
      BEGIN
        IF (Result > 1) AND
           (Text[Result - 1] = Maske) THEN              // muß das Zeichen vor der gefundenen Position geprüft werden
          Result := -1;
      END
      ELSE
        IF (Length(Wort) = 1) AND                       // ist Wort ein Zeichen lang und
           (Wort[1] = Maske) THEN                       // ist Wort = Zeichen
        BEGIN
          IF (Result < Length(Text)) AND
             (Text[Result + 1] = Maske) THEN            // muß das Zeichen hinter der gefundenen Position geprüft werden
            Result := -1;                               // Maskierung gefunden
        END
        ELSE                                            // ist die Wortlänge größer 1 oder Wort <> Maske
          IF (Result > 1) AND
             (Text[Result - 1] = Maske) THEN            // muß das Zeichen vor der gefundenen Position geprüft werden
            Result := -1;                               // Maskierung gefunden
    END;
  UNTIL Result > -1;                                    // das gefundene Wort ist maskiert also weitersuchen
END;

// sucht ein Wort in einem Text ab der Startposition  bis zur Endposition vorwärts oder rückwärts und prüft ob das Wort maskiert ist
// ist die Wortlänge größer 1 muß Wort neben dem zeichen Maske mindestens ein anderes Zeichen enthalten
FUNCTION PosX(Wort, Text: STRING; StartPosition, EndPosition: Integer; rueckwaerts: Boolean;  Maske: Char): Integer; OVERLOAD;
BEGIN
  IF EndPosition = 0 THEN
    IF rueckwaerts THEN
      Endposition := 1
    ELSE
      EndPosition := Length(Text);
  Result := PosX(Wort, Text, StartPosition, rueckwaerts, Maske);
  IF rueckwaerts THEN
  BEGIN
    IF Result < EndPosition THEN
      Result := 0;
  END
  ELSE
    IF Result > EndPosition THEN
      Result := 0;
END;

// modales Nachrichtenfenster aus der API (Application.MessageBox)
FUNCTION Nachrichtenfenster(Nachricht, Titel: STRING; Tasten, Icon: Longint): Integer;
BEGIN
{
---- Tasten ----
MB_ABORTRETRYIGNORE	  Abbrechen, Wiederholen, Ignorieren.
MB_OK	                OK. Das ist die Defaulteinstellung.
MB_OKCANCEL	          OK, Abbrechen
MB_RETRYCANCEL	      Wiederholen, Abbrechen
MB_YESNO	            Ja, Nein
MB_YESNOCANCEL	      Ja, Nein, Abbrechen

---- Icons ----
MB_ICONEXCLAMATION, MB_ICONWARNING 	   Ausrufungszeichen im gelben Dreieck
MB_ICONINFORMATION, MB_ICONASTERISK    kleines blaues i in einer SprechblaseMB_ICONQUESTION	                       Fragezeichen in einer Sprechblase
MB_ICONSTOP, MB_ICONERROR, MB_ICONHAND weißes Kreuz in einem roten Kreis
---- Rückgaben ----
IDOK	    1	Der Benutzer hat auf OK geklickt.
IDCANCEL	2	Der Benutzer hat auf Abbrechen geklickt.
IDABORT	  3	Der Benutzer hat auf Abbruch geklickt.
IDRETRY	  4	Der Benutzer hat auf Wiederholen geklickt.
IDIGNORE	5	Der Benutzer hat auf Ignorieren geklickt.
IDYES	    6	Der Benutzer hat auf Ja geklickt.
IDNO	    7	Der Benutzer hat auf Nein geklickt.
}
  Result := Application.MessageBox(PChar(Nachricht), PChar(Titel), Tasten OR Icon);
END;

// modales Nachrichtenfenster ohne Rückmeldung aus der API
PROCEDURE Meldungsfenster(Nachricht: STRING; Titel: STRING = '');
BEGIN
  Titel := Application.Title + ': ' + Titel;
  Application.MessageBox(PChar(Nachricht), PChar(Titel), MB_OK OR MB_ICONINFORMATION);
END;

// schneidet vom Komponentenname die Zahl am Ende ab
FUNCTION Komponentenname(Komponente: TComponent): STRING;

VAR Position : Integer;

BEGIN
  Position := PosX(['1', '2', '3', '4', '5', '6', '7', '8', '9'], Komponente.Name, 0, True, True);
  IF Position = 0 THEN
    Result := Komponente.Name
  ELSE
    Result := LeftStr(Komponente.Name, Position);
END;

// vertaucht die beiden Integerzahlen A und B
PROCEDURE SwapInteger(VAR A, B: Integer);

VAR Tausch: Integer;

BEGIN
  Tausch := A;
  A := B;
  B := Tausch;
END;

FUNCTION ErsetzeZeichen(Text: STRING; Zeichen: TZeichen; ErsatzZeichen: Char = '_'): STRING;

VAR I : Integer;

BEGIN
  FOR I := 1 TO Length(Text) DO
    IF Text[I] IN Zeichen THEN
      Text[I] := ErsatzZeichen;
  Result := Text;    
END;

end.

