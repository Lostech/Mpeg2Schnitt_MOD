unit MarkenUnit;

interface

USES StdCtrls,
     Sprachen,
     AllgVariablen;

FUNCTION Zeileeinfuegen(Text: STRING; Art: Integer = 0): Integer;
PROCEDURE Loeschen;

VAR Markenliste : TMemo;

implementation

FUNCTION Zeileeinfuegen(Text: STRING; Art: Integer = 0): Integer;
BEGIN
  Result := 0;
//        ListenIndex := TextfenstermarkierteZeile(MarkenListe);
{        MarkenListe.Lines.Insert(ListenIndex, Text);
            Inc(ListenIndex);
}
END;

PROCEDURE Loeschen;
BEGIN
END;

end.
 