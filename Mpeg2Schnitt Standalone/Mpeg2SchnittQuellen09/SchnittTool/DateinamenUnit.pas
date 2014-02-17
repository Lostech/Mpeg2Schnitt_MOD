unit DateinamenUnit;

interface

USES SysUtils,
     AllgFunktionen, AllgVariablen;

FUNCTION Verzeichnisnamenbilden(Verzeichnisname, Quelldateiname, Projektname: STRING; HProjektname: STRING = 'kein Projekt'): STRING;
FUNCTION Dateinamenbilden(Dateiname, Quelldateiname, Projektname: STRING; HProjektname: STRING = 'kein Projekt'; Schnittpunkteeinzelnschneiden: Boolean = False): STRING;

implementation

FUNCTION Verzeichnisnamenbilden(Verzeichnisname, Quelldateiname, Projektname: STRING; HProjektname: STRING = 'kein Projekt'): STRING;
BEGIN
  IF HProjektname <> 'kein Projekt' THEN
    Projektname := HProjektname;
  IF Projektname = '' THEN
    Projektname := Quelldateiname;
  Result := VariablenersetzenText(Verzeichnisname, ['$VideoDirectory#', ExtractFilePath(Quelldateiname), '$ProjectDirectory#', ExtractFilePath(Projektname),
                                                    '$VideoName#', ChangeFileExt(ExtractFileName(Quelldateiname), ''), '$ProjectName#', ChangeFileExt(ExtractFileName(Projektname), '')]);
  Result := VariablenentfernenText(Result);
  Result := doppeltePathtrennzeichen(Result);
  IF (Result = '') OR (Result = '\') THEN                                       // ist kein Zielverzeichnis definiert
    Result := ExtractFilePath(Quelldateiname);                                  // wird das Quellverzeichnis benutzt
END;

FUNCTION Dateinamenbilden(Dateiname, Quelldateiname, Projektname: STRING; HProjektname: STRING = 'kein Projekt'; Schnittpunkteeinzelnschneiden: Boolean = False): STRING;
BEGIN
  IF HProjektname <> 'kein Projekt' THEN
    Projektname := HProjektname;
  IF Projektname = '' THEN
    Projektname := Quelldateiname;
  Result := VariablenersetzenText(Dateiname, ['$VideoName#', ChangeFileExt(ExtractFileName(Quelldateiname), ''), '$ProjectName#', ChangeFileExt(ExtractFileName(Projektname), '')]);
  Result := VariablenentfernenText(Result);
  IF Result = '' THEN                                                           // ist kein Zieldateiname definiert
    Result := ChangeFileExt(ExtractFileName(Projektname), '');                  // wird der Projektname bzw. der Quelldateiname genommen
  IF Schnittpunkteeinzelnschneiden THEN
    Result := DateinamePlusEins(Result, ArbeitsumgebungObj.SchnittpunkteeinzelnFormat, True);
END;

end.
