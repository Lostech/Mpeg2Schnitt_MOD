{-----------------------------------------------------------------------------------
Diese Unit implementiert verschiedene Algorithmen um Aktionen rückgänging zu machen
und sie zu wiederholen.

Copyright (C) 2005  Thomas Urlings
 Homepage: n/a
 E-Mail:

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

unit UndoRedo;

interface

TYPE
  TSetLongIntUndoProc = procedure(value: LongInt; fUndo: Boolean = false) of object;

  TBasicUndo = CLASS
  private
    strCaption: String;
  protected
    constructor Create(_strCaption: String);
    procedure Execute; virtual; abstract;
    function Invert: TBasicUndo; virtual; abstract;
  public
    property Caption: String read strCaption write strCaption;
  end;

  TLongIntUndo = CLASS(TBasicUndo)
  private
    UndoProc : TSetLongIntUndoProc;
    newValue, oldValue : LongInt;
  public
    constructor Create(_strCaption: String; _UndoProc: TSetLongIntUndoProc;
                       _oldValue, _newValue: LongInt); overload;
    procedure Execute; override;
    function Invert: TBasicUndo; override;
  end;

VAR
    UndoObject : TBasicUndo; // enthält die Undo-Aktion
    RedoObject : TBasicUndo; // ein Redo-Object ist immer ein invertiertes Undo

    procedure SetUndoRedo(var storage: TBasicUndo; newUndo: TBasicUndo; FreeOld: Boolean);
    procedure SetUndo(newUndo:TBasicUndo; FreeOld: Boolean = True);
    procedure SetRedo(newRedo:TBasicUndo; FreeOld: Boolean = True);
    procedure DoUndo;
    procedure DoRedo;

implementation

{Basisklasse, für allgemeine Methoden}
constructor TBasicUndo.Create(_strCaption: String);
begin
  strCaption := _strCaption;
end;

{Common LongInt Undo}
constructor TLongIntUndo.Create(_strCaption: String;
                                _UndoProc: TSetLongIntUndoProc;
                                _oldValue, _newValue: LongInt);
begin
  inherited Create(_strCaption);
  UndoProc := _UndoProc;
  newValue := _newValue;
  oldValue := _oldValue;
end;

procedure TLongIntUndo.Execute;
begin
  UndoProc(oldValue,false); // dabei kein Undo Objekt erzeugen
end;

function TLongIntUndo.Invert: TBasicUndo;
var I:LongInt;
begin
  I := newValue;
  newValue := oldValue;
  oldValue := I;
  Invert := self;
end;

{Undo Methoden}

procedure SetUndoRedo(var storage: TBasicUndo; newUndo: TBasicUndo; FreeOld: Boolean);
begin
  if (storage <> newUndo) AND FreeOld then
    storage.Free;
  storage := newUndo;
end;

{ wird von jeder Routine aufgerufen, die ein Undo-Object erzeugt
  evtl. altes UndoObject muß gelöscht werden, wenn gewünscht (default)
  evtl. altes RedoObject muß gelöscht werden
  MenuItems müssen angepasst werden.}
procedure SetUndo(newUndo:TBasicUndo; FreeOld: Boolean = True);
begin
  SetUndoRedo(undoObject,newUndo,FreeOld);
  SetUndoRedo(redoObject,nil,True);
end;

{ wird nur innerhalb der Undo-Routinen verwendet
  ein evtl. Redo Object wird gelöscht, aber es sollte eigentlich keines da sein.
  MenuItems müssen angepasst werden.}
procedure SetRedo(newRedo:TBasicUndo; FreeOld: Boolean = True);
begin
  SetUndoRedo(redoObject,newRedo,FreeOld);
end;

{ kann nur aufgerufen werden, wenn ein UndoObject existiert}
procedure DoUndo;
var u : TBasicUndo;
begin
  undoObject.Execute;
  u := undoObject;
  SetUndo(nil,False); // undoObject nicht löschen!
  SetRedo(u.Invert);
end;

procedure DoRedo;
var u : TBasicUndo;
begin
  redoObject.Execute;
  u := redoObject;
  setRedo(nil, False); // damit u nicht in setUndo gelöscht wird!
  setUndo(u.Invert);
end;

initialization
//  SetUndo(nil); // Init des Undo/Redo

end.
