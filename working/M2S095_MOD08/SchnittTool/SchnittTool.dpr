program SchnittTool;



uses
  Forms,
  Controls,
  StdCtrls,
  IniFiles,
  SysUtils,
  SchnittToolHauptfenster in 'SchnittToolHauptfenster.pas' {Hauptprogramm},
  Dateipuffer in 'Dateipuffer.pas',
  Mpeg2Unit in 'Mpeg2Unit.pas',
  ProtokollUnit in 'ProtokollUnit.pas',
  Sprachen in '..\Units\Mpeg2Schnitt\Sprachen.pas',
  WinEnde in '..\Units\WinEnde.pas',
  Ueber in '..\Units\Mpeg2Schnitt\Ueber.pas' {UeberFenster},
  Textanzeigefenster in '..\Units\Mpeg2Schnitt\Textanzeigefenster.pas' {Textfenster},
  ProjektUnit in 'ProjektUnit.pas',
  SchneidenUnit in 'SchneidenUnit.pas',
  DatenTypen in 'DatenTypen.pas',
  DateienUnit in 'DateienUnit.pas',
  Mauladenspeichern in '..\Units\Mpeg2Schnitt\Mauladenspeichern.pas',
  SchnittUnit in 'SchnittUnit.pas',
  KapitelUnit in 'KapitelUnit.pas',
  MarkenUnit in 'MarkenUnit.pas',
  AusgabeUnit in 'AusgabeUnit.pas',
  Kommandozeile in 'Kommandozeile.pas',
  DateinamenUnit in 'DateinamenUnit.pas',
  AusgabeDatenTypen in 'AusgabeDatenTypen.pas',
  ScriptUnit in 'ScriptUnit.pas',
  AudioschnittUnit in 'AudioschnittUnit.pas',
  AudioIndexUnit in 'AudioIndexUnit.pas',
  SchnittTypenUnit in 'SchnittTypenUnit.pas',
  VideoschnittUnit in 'VideoschnittUnit.pas',
  VideoHeaderUnit in 'VideoHeaderUnit.pas',
  DateiStreamUnit in '..\Units\Mpeg2Schnitt\DateiStreamUnit.pas',
  AllgFunktionen in '..\Units\Mpeg2Schnitt\AllgFunktionen.pas',
  AlphaBlend in '..\Units\Mpeg2Schnitt\AlphaBlend.pas',
  Skins in '..\Units\Mpeg2Schnitt\Skins.pas',
  AllgVariablen in 'AllgVariablen.pas';

{$R *.res}

VAR IniFile : TIniFile;

begin
  Application.Initialize;
  Application.Title := 'SchnittTool';
  Application.CreateForm(THauptprogramm, Hauptprogramm);
  Application.CreateForm(TUeberFenster, UeberFenster);
  Application.CreateForm(TTextfenster, Textfenster);
  Application.HintHidePause:=10000;
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Mpeg2Schnitt.ini');
  IF NOT IniFile.ReadBool('Allgemein', 'Lizenzakzeptiert', False) THEN
  BEGIN
    IF UeberFenster.ShowModal = mrOK THEN
    BEGIN
      IniFile.WriteBool('Allgemein', 'Lizenzakzeptiert', True);
      IniFile.Free;
      UeberFenster.akzeptiert.Enabled := False;
      Hauptprogramm.Spracheeinlesen;
      Hauptprogramm.Initialisieren;
//      IF NOT Hauptprogramm.keineOberflaeche THEN
        Application.Run;
    END
    ELSE
      IniFile.Free;
  END
  ELSE
  BEGIN
    IniFile.Free;
    UeberFenster.akzeptiert.Checked := True;
    UeberFenster.akzeptiert.Enabled := False;
    Hauptprogramm.Spracheeinlesen;
    Hauptprogramm.Initialisieren;
    IF NOT Hauptprogramm.keineOberflaeche THEN
      Application.Run;
  END;
end.

