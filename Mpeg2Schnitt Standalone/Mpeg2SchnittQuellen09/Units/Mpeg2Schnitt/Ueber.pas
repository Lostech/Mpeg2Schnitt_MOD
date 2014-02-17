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

unit Ueber;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, Dialogs, Menus, StrUtils, ComCtrls, ShellApi,
     Textanzeigefenster,                // zur Lizenzanzeige
     Sprachen,                          // ändern der Sprache
     IniFiles,                          // für TIniFile
     AllgFunktionen,                    // für absolutPathAppl
     DatenTypen,                        // Datentypen
     AllgVariablen;                     // Programmeinstellungen

type
  TUeberFenster = class(TForm)
    OKTaste: TButton;
    akzeptiert: TCheckBox;
    Lizenzvertrag: TButton;
    Sprachbox: TComboBox;
    ProgramIcon: TImage;
    ProgrammName_: TLabel;
    Copyright_: TLabel;
    Internet_: TLabel;
    EMail_: TLabel;
    Programmname: TLabel;
    Copyright: TLabel;
    Internetseite: TLabel;
    E_Mail: TLabel;
    Version_: TLabel;
    Versi: TLabel;
    Sprache_: TLabel;
    TextRichEdit: TRichEdit;
    Komponenten: TButton;
    procedure OKTasteClick(Sender: TObject);
    procedure LizenzvertragClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SprachboxChange(Sender: TObject);
    procedure InternetseiteClick(Sender: TObject);
    procedure E_MailClick(Sender: TObject);
    procedure KomponentenClick(Sender: TObject);
  private
    { Private declarations }
    LizenzText : ARRAY[1..21] OF STRING;
    DankeText : ARRAY[1..21] OF STRING;
    FLizensiert : Boolean;
    FLizenzanzeigen : Boolean;
    FSpracheanzeigen : Boolean;
    FUNCTION Textattribute(Text: STRING; Textfeld: TRichEdit): STRING;
    PROCEDURE Sprachelesen;
    FUNCTION VersionNamelesen: STRING;
    FUNCTION Versionlesen: STRING;
  public
    { Public declarations }
    PROPERTY Lizensiert: Boolean WRITE FLizensiert;
    PROPERTY Lizenzanzeigen: Boolean WRITE FLizenzanzeigen;
    PROPERTY Spracheanzeigen: Boolean WRITE FSpracheanzeigen;
    PROPERTY VersionName : STRING READ VersionNamelesen;
    PROPERTY VersionNr: STRING READ Versionlesen;
    PROCEDURE Spracheaendern(Spracheladen: TSprachen);
  end;

var
  UeberFenster: TUeberFenster;

implementation
                                              
{$R *.dfm}

procedure TUeberFenster.FormCreate(Sender: TObject);

VAR VerAnzahl,
    Laenge : LongWord;
    Puffer,
    Info,
    Trans : Pointer;

begin
  VerAnzahl := GetFileVersionInfoSize(PChar(Application.ExeName), VerAnzahl);
  IF VerAnzahl > 0 THEN
  BEGIN
    Puffer := AllocMem(VerAnzahl);
    GetFileVersionInfo(PChar(Application.ExeName), 0, VerAnzahl, Puffer);
    VerQueryValue(Puffer, '\VarFileInfo\Translation', Trans, Laenge);
    IF VerQueryValue(Puffer, PChar(Format('\StringFileInfo\%.4x%.4x\%s',
                    [LoWord(LongInt(Trans^)), HiWord(LongInt(Trans^)), 'InternalName'])),
                     Info, Laenge) THEN
      Programmname.Caption := PChar(Info);
    IF VerQueryValue(Puffer, PChar(Format('\StringFileInfo\%.4x%.4x\%s',
                    [LoWord(LongInt(Trans^)), HiWord(LongInt(Trans^)), 'FileVersion'])),
                     Info, Laenge) THEN
      Versi.Caption := PChar(Info);
    IF VerQueryValue(Puffer, PChar(Format('\StringFileInfo\%.4x%.4x\%s',
                    [LoWord(LongInt(Trans^)), HiWord(LongInt(Trans^)), 'LegalCopyright'])),
                     Info, Laenge) THEN
      Copyright.Caption := PChar(Info);
    IF VerQueryValue(Puffer, PChar(Format('\StringFileInfo\%.4x%.4x\%s',
                    [LoWord(LongInt(Trans^)), HiWord(LongInt(Trans^)), 'Internet'])),
                     Info, Laenge) THEN
      Internetseite.Caption := PChar(Info);
    IF VerQueryValue(Puffer, PChar(Format('\StringFileInfo\%.4x%.4x\%s',
                    [LoWord(LongInt(Trans^)), HiWord(LongInt(Trans^)), 'E-Mail'])),
                     Info, Laenge) THEN
      E_Mail.Caption := PChar(Info);
    FreeMem(Puffer, VerAnzahl);
    Versi.Caption := LeftStr(Versi.Caption, PosX('.', Versi.Caption, 0, True) - 1);
  END
  ELSE
  BEGIN
    Programmname.Caption := 'Mpeg2Schnitt/SchnittTool';
    Versi.Caption := '';
    Copyright.Caption := '(2003) Martin Dienert';
    Internetseite.Caption := 'www.mdienert.de/mpeg2schnitt';
    E_Mail.Caption := 'm.dienert@gmx.de';
  END;
  FLizensiert := False;
  FLizenzanzeigen := True;
  FSpracheanzeigen := True;
  LizenzText[1] := '$Bold#$Underline#License note:$/Underline#$/Bold#';
  LizenzText[2] := '$#';
  LizenzText[3] := 'Mpeg2Schnitt comes with ABSOLUTELY NO WARRANTY.';
  LizenzText[4] := 'This is free software, and you are welcome to redistribute it under certain conditions.';
  LizenzText[5] := 'See the License for more details.';
  LizenzText[6] := 'The software may be used only for personal, not commercial purposes deviating by';
  LizenzText[7] := 'the license contract for the sourcecode.';
  LizenzText[8] := 'The supposing of the license applies also to the IndexTool and the SchnittTool.';
  LizenzText[9] := '$#';
  LizenzText[10] := '$Bold#$Underline#Lizenzhinweis:$/Underline#$/Bold#';
  LizenzText[11] := '$#';
  LizenzText[12] := 'Für Mpeg2Schnitt besteht KEINERLEI GARANTIE.';
  LizenzText[13] := 'Mpeg2Schnitt ist freie Software, die Sie unter bestimmten Bedingungen weitergeben dürfen.';
  LizenzText[14] := 'Weitere Informationen im Lizenzvertrag. Eine nicht offizielle Übersetzung der Lizenz ';
  LizenzText[15] := 'ist auf dieser Seite zu finden: http://www.gnu.de/gpl-ger.html';
  LizenzText[16] := 'Abweichend vom Lizenzvertrag darf die Software nur für persönliche, nicht gewerbliche';
  LizenzText[17] := 'Zwecke benutzt werden.';
  LizenzText[18] := 'Das Annehmen der Lizenz gilt auch für das IndexTool und das SchnittTool.';
  LizenzText[19] := '$#';
  LizenzText[20] := 'Zum Entfernen der Software einfach das Programm und alle dazugehörigen Dateien löschen.';
  LizenzText[21] := 'Es werden KEINE Einträge in der Registry oder irgendwelchen Systemdateien gemacht.';

  DankeText[1] := '$Bold#$Underline#Danksagung$/Underline#$/Bold#';
  DankeText[2] := '$#';
  DankeText[3] := 'Danke an alle die an der Entwicklung dieses Programms aktiv mitgewirkt haben.';
  DankeText[4] := 'In das Programm sind Ideen und Vorschläge aus dem DVDTechnics Forum eingeflossen.';
  DankeText[5] := '$Italic#(http://forum.dvbtechnics.info)$/Italic#';
  DankeText[6] := '$#';
  DankeText[7] := '$Bold#Thomas Urlings$/Bold#';
  DankeText[8] := '$Tab#Alphablend Unit, Skins Unit, RedoUndo Unit, Audioskew, AlphaSpeedBtn,';
  DankeText[9] := '$Tab#Videoplaythread und einige Bugfixes';
  DankeText[10] := '$#';
  DankeText[11] := '$Bold#Igor Feldhaus$/Bold#';
  DankeText[12] := '$Tab#Schnittsuche Unit, Grundlagen des SchnittTools (ProjektTool)';
  DankeText[13] := '$#';
  DankeText[14] := '$Bold#Michael Vinther$/Bold#';
  DankeText[15] := '$Tab#mpeg2lib.dll auf der Basis von Mpeg2Decode der MSSG-Group';
  DankeText[16] := '$#';
  DankeText[17] := '$Bold#Erik Unger, Ivo Steinmann und Tim Baumgarten$/Bold#';
  DankeText[18] := '$Tab#DirectDraw Unit, DirectSound Unit, DirectXGraphics Unit';
  DankeText[19] := '$#';
  DankeText[20] := '$Bold#Henri Gourvest$/Bold#';
  DankeText[21] := '$Tab#DirectShow Unit';
end;

procedure TUeberFenster.FormShow(Sender: TObject);
begin
  IF (ArbeitsumgebungObj.DialogeSchriftart <> '') AND
     (ArbeitsumgebungObj.DialogeSchriftgroesse > 0) THEN
  BEGIN
    Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
    Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
    Internetseite.Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
    Internetseite.Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
    E_Mail.Font.Name := ArbeitsumgebungObj.DialogeSchriftart;
    E_Mail.Font.Size := ArbeitsumgebungObj.DialogeSchriftgroesse;
  END;
  IF FLizensiert THEN
  BEGIN
    akzeptiert.Checked := True;
    akzeptiert.Enabled := False;
    Sprache_.Visible := False;
    Sprachbox.Visible := False;
  END
  ELSE
  BEGIN
    IF Assigned(SprachenListe) AND
       (SprachenListe.Count > 0) THEN
      Sprachbox.Items.Assign(SprachenListe);
    Sprachbox.ItemIndex := Sprachbox.Items.IndexOf(aktuelleSprache);
  END;
  IF FLizenzanzeigen THEN
  BEGIN
    IF FLizensiert THEN
    BEGIN
      Lizenzvertrag.Visible := True;
      TextRichEdit.Height := 230;
    END;
  END
  ELSE
  BEGIN
    Lizenzvertrag.Visible := False;
    TextRichEdit.Height := 270;
  END;
  Sprachelesen;
end;

procedure TUeberFenster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IF akzeptiert.Checked THEN
    ModalResult := mrOK
  ELSE
    ModalResult := mrCancel;
end;

procedure TUeberFenster.SprachboxChange(Sender: TObject);
begin
  IF Sprachbox.ItemIndex > -1 THEN
  BEGIN
    Sprachdateiname := TDateiListeneintrag(SprachenListe.Objects[Sprachbox.ItemIndex]).Dateiname;
    aktuelleSprache := TDateiListeneintrag(SprachenListe.Objects[Sprachbox.ItemIndex]).Name;
    Sprachelesen;
  END;
end;

procedure TUeberFenster.OKTasteClick(Sender: TObject);
begin
  IF akzeptiert.Checked THEN
    ModalResult := mrOK
  ELSE
    ModalResult := mrCancel;
end;

procedure TUeberFenster.LizenzvertragClick(Sender: TObject);
begin
  Application.CreateForm(TTextfenster, Textfenster);
  Textfenster.Caption := Wortlesen(NIL,'Lizenzvertrag', 'Lizenzvertrag');
  Textfenster.Text.Lines.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Lizenz.txt');
  Textfenster.ShowModal;
  Textfenster.Free;
end;

PROCEDURE TUeberFenster.Sprachelesen;

VAR Spracheladenfreigeben : Boolean;

BEGIN
  IF NOT Assigned(Spracheladen) THEN
  BEGIN
    Spracheladen := Sprachobjekterzeugen('', '', '', False);
    Spracheladenfreigeben := True;
  END
  ELSE
    Spracheladenfreigeben := False;
  TRY
    Spracheaendern(Spracheladen);
  FINALLY
    IF Spracheladenfreigeben THEN
      Sprachobjektfreigeben(Spracheladen);
  END;
END;

FUNCTION TUeberFenster.Textattribute(Text: STRING; Textfeld: TRichEdit): STRING;

VAR Ende : Boolean;
    Position0,
    Position1,
    Position2 : Integer;
    Variable : STRING;

BEGIN
  Result := '';
  IF NOT ((Text = '$#') OR (Text = '')) THEN
  BEGIN
    Ende := False;
    Position0 := 1;
    WHILE NOT Ende DO
    BEGIN
      Ende := True;
      Position1 := Position0;
      Position2 := Variablesuchen(Text, Position1);  // Position1: Anfang der Variablen
      IF Position2 > 0 THEN
      BEGIN                                          // Variable gefunden
        Ende := False;
        IF Position1 > Position0 THEN
          Textfeld.SelText := Copy(Text, Position0, Position1 - Position0); // Abschnitt zwischen den Variablen kopieren
        Position0 := Position1 + Position2;          // Position0: Ende der Variablen
        Variable := Copy(Text, Position1, Position2);
        IF Variable = '$Bold#' THEN
        BEGIN
          Textfeld.SelAttributes.Style := Textfeld.SelAttributes.Style + [fsBold];
        END
        ELSE
        IF Variable = '$/Bold#' THEN
        BEGIN
          Textfeld.SelAttributes.Style := Textfeld.SelAttributes.Style - [fsBold];
        END
        ELSE
        IF Variable = '$Italic#' THEN
        BEGIN
          Textfeld.SelAttributes.Style := Textfeld.SelAttributes.Style + [fsItalic];
        END
        ELSE
        IF Variable = '$/Italic#' THEN
        BEGIN
          Textfeld.SelAttributes.Style := Textfeld.SelAttributes.Style - [fsItalic];
        END
        ELSE
        IF Variable = '$Underline#' THEN
        BEGIN
          Textfeld.SelAttributes.Style := Textfeld.SelAttributes.Style + [fsUnderline];
        END
        ELSE
        IF Variable = '$/Underline#' THEN
        BEGIN
          Textfeld.SelAttributes.Style := Textfeld.SelAttributes.Style - [fsUnderline];
        END
        ELSE
        IF Pos('$Color', Variable) = 1 THEN
        BEGIN
          IF Variable = '$ColorStandard#' THEN
            Textfeld.SelAttributes.Color := Textfeld.DefAttributes.Color
          ELSE
            Textfeld.SelAttributes.Color := StrToIntDef(Copy(Variable, 7, Length(Variable) - 7), 0);
        END
        ELSE
        IF Variable = '$Tab#' THEN
        BEGIN
          Textfeld.SelText := Chr(9);
        END;
      END;
    END;
    IF Length(Text) + 1 > Position0 THEN
      Textfeld.SelText := Copy(Text, Position0, Length(Text) - Position0 + 1); // Rest nach der letzten Variablen kopieren
  END;
  Textfeld.Lines.Add('');
END;

procedure TUeberFenster.InternetseiteClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PCHar(Internetseite.Caption), nil, nil, SW_ShowNormal);
end;

procedure TUeberFenster.E_MailClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PCHar('mailto:' + E_Mail.Caption + '?subject=Mpeg2Schnitt'), nil, nil, SW_ShowNormal);
end;

FUNCTION TUeberFenster.VersionNamelesen: STRING;
BEGIN
  Result := Programmname.Caption;
END;

FUNCTION TUeberFenster.Versionlesen: STRING;
BEGIN
  Result := Programmname.Caption + '   ' + Version_.Caption + ' ' + Versi.Caption{ + ' Alpha'};
END;

PROCEDURE TUeberFenster.Spracheaendern(Spracheladen: TSprachen);

VAR I : Integer;
    HString : STRING;
    Komponente : TComponent;
    Textvorhanden : Boolean;

BEGIN
  Caption := Wortlesen(Spracheladen, 'UeberFenster', Caption);
  FOR I := 0 TO ComponentCount - 1 DO
  BEGIN
    Komponente := Components[I];
    IF Komponente IS TButton THEN             // in der Unit StdCtrls
    BEGIN
      TButton(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TButton(Komponente).Caption);
      TButton(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TButton(Komponente).Hint);
    END;
    IF Komponente IS TBitBtn THEN             // in der Unit Buttons
    BEGIN
      TBitBtn(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TBitBtn(Komponente).Caption);
      TBitBtn(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TBitBtn(Komponente).Hint);
    END;
    IF Komponente IS TCheckBox THEN           // in der Unit StdCtrls
    BEGIN
      TCheckBox(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TCheckBox(Komponente).Caption);
      TCheckBox(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TCheckBox(Komponente).Hint);
    END;
{    IF Komponente IS TRadioButton THEN
    BEGIN
      TRadioButton(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TRadioButton(Komponente).Caption);
      TRadioButton(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TRadioButton(Komponente).Hint);
    END;   }
    IF Komponente IS TLabel THEN              // in der Unit StdCtrls
    BEGIN
      TLabel(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TLabel(Komponente).Caption);
      TLabel(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TLabel(Komponente).Hint);
    END;
{    IF Komponente IS TMenuItem THEN           // in der Unit Menus
      IF Komponente.Name <> '' THEN
      BEGIN
        TMenuItem(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TMenuItem(Komponente).Caption);
        TMenuItem(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TMenuItem(Komponente).Hint);
      END;
    IF Komponente IS TGroupBox THEN           // in der Unit StdCtrls
    BEGIN
      TGroupBox(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TGroupBox(Komponente).Caption);
      TGroupBox(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TGroupBox(Komponente).Hint);
    END;
    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      TTabSheet(Komponente).Caption := Wortlesen(Spracheladen, Komponente.Name, TTabSheet(Komponente).Caption);
      TTabSheet(Komponente).Hint := Wortlesen(Spracheladen, Komponente.Name + '_Hint', TTabSheet(Komponente).Hint);
    END;    }
  END;
  I := 1;
  TextRichEdit.Clear;
  TextRichEdit.SelAttributes := TextRichEdit.DefAttributes;
  IF FLizenzanzeigen THEN
    HString := 'Lizenzhinweis'
  ELSE
    HString := 'Danke';
  Textvorhanden := Schluesselwortvorhanden(Spracheladen, HString + IntToStr(1));
  IF Textvorhanden THEN
    WHILE Schluesselwortvorhanden(Spracheladen, HString + IntToStr(I)) DO
    BEGIN
      Textattribute(Wortlesen(Spracheladen, HString + IntToStr(I), ''), TextRichEdit);
      Inc(I);
    END
  ELSE
    IF FLizenzanzeigen THEN
      WHILE I < High(LizenzText) + 1 DO
      BEGIN
        Textattribute(LizenzText[I], TextRichEdit);
        Inc(I);
      END
    ELSE
      WHILE I < High(DankeText) + 1 DO
      BEGIN
        Textattribute(DankeText[I], TextRichEdit);
        Inc(I);
      END;
END;

procedure TUeberFenster.KomponentenClick(Sender: TObject);

VAR I : Integer;
    Komponente : TComponent;
    Liste : TStringList;

begin
  Liste := TStringList.Create;
  TRY
  FOR I := 0 TO ComponentCount - 1 DO
  BEGIN
    Komponente := Components[I];
{    IF Komponente IS TAlphaSpeedBtn THEN      // in der Unit AlphaBlend
    BEGIN
      Informationen.Lines.Add('TAlphaSpeedBtn - ' + Komponente.Name + '=' + TAlphaSpeedBtn(Komponente).Caption);
    END
    ELSE   }
    IF Komponente IS TSpeedButton THEN        // in der Unit Buttons
    BEGIN
      Liste.Add('TSpeedButton - ' + Komponente.Name + '=' + TSpeedButton(Komponente).Caption);
    END
    ELSE
    IF Komponente IS TBitBtn THEN             // in der Unit Buttons
    BEGIN
      Liste.Add('TBitBtn - ' + Komponente.Name + '=' + TBitBtn(Komponente).Caption);
    END
    ELSE  
    IF Komponente IS TButton THEN             // in der Unit StdCtrls
    BEGIN
      Liste.Add('TButton - ' + Komponente.Name + '=' + TButton(Komponente).Caption);
    END
    ELSE
    IF Komponente IS TCheckBox THEN           // in der Unit StdCtrls
    BEGIN
      Liste.Add('TCheckBox - ' + Komponente.Name + '=' + TCheckBox(Komponente).Caption);
    END
    ELSE
    IF Komponente IS TRadioButton THEN
    BEGIN
      Liste.Add('TRadioButton - ' + Komponente.Name + '=' + TRadioButton(Komponente).Caption);
    END
    ELSE  
    IF Komponente IS TLabel THEN              // in der Unit StdCtrls
    BEGIN
      Liste.Add('TLabel - ' + Komponente.Name + '=' + TLabel(Komponente).Caption);
    END
    ELSE
    IF Komponente IS TMenuItem THEN           // in der Unit Menus
    BEGIN
      IF Komponente.Name <> '' THEN
      BEGIN
        Liste.Add('TMenuItem - ' + Komponente.Name + '=' + TMenuItem(Komponente).Caption);
      END;
    END
    ELSE  
    IF Komponente IS TGroupBox THEN           // in der Unit StdCtrls
    BEGIN
      Liste.Add('TGroupBox - ' + Komponente.Name + '=' + TGroupBox(Komponente).Caption);
    END
    ELSE
    IF Komponente IS TTabSheet THEN           // in der Unit ComCtrls
    BEGIN
      Liste.Add('TTabSheet - ' + Komponente.Name + '=' + TTabSheet(Komponente).Caption);
    END
    ELSE
    IF Komponente IS TPanel THEN              // in der Unit ExtCtrls
    BEGIN
      Liste.Add('TPanel - ' + Komponente.Name + '=' + TPanel(Komponente).Caption);
    END
    ELSE  
{    IF Komponente IS TAction THEN             // in der Unit ActnList
    BEGIN
      Liste.Add('TAction - ' + Komponente.Name + '=' + TAction(Komponente).Caption);
    END
    ELSE  }
    IF Komponente IS TTrackBar THEN           // in der Unit ComCtrls
    BEGIN
      Liste.Add('TTrackBar - ' + Komponente.Name + '=' + TTrackBar(Komponente).Hint);
    END
    ELSE
    IF Komponente IS TEdit THEN               // in der Unit StdCtrls
    BEGIN
      Liste.Add('TEdit - ' + Komponente.Name + '=' + TEdit(Komponente).Hint);
    END;
  END;
  Liste.Sort;
  Liste.SaveToFile('D:\Delphi-Projekte\Mpeg2Schnitt095\Komponentennamen-Ueber.txt');
  FINALLY
    Liste.Free;
  END;
end;

end.

