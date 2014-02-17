{-----------------------------------------------------------------------------------
Diese Unit implementiert das ThemeHandling.

Copyright (C) 2005  Thomas Urlings
 Homepage: n/a
 E-Mail:

Es gelten die Lizenzbestimmungen von Mpeg2Schnitt.

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

-------------------------------------------------------------------------------------- }
unit ThemeHandling;

interface

uses Windows;

type
  TUxTheme = class
  private
    procedure Init;
    procedure Clear;
  public
    SetWindowTheme: function(hwnd: HWND; pszSubAppName: LPCWSTR; pszSubIdList: LPCWSTR): HRESULT; stdcall;
    IsThemeActive: function: BOOL; stdcall;
    IsAppThemed: function: BOOL; stdcall;
    constructor Create;
    destructor Destroy; override;
    function IsThemed: Boolean;
    procedure DisableWindowTheme(hwnd: HWND);
  end;

implementation

{------------------------------------------------------------------------------}
{- TUxTheme Implementation ----------------------------------------------------}
{------------------------------------------------------------------------------}
var UxDllHandle: THandle = 0;     // pseudoStatic Value

constructor TUxTheme.Create;
begin
  Init;
end;

destructor TUxTheme.Destroy;
begin
  Clear;
end;

procedure TUxTheme.Init;
const
  themelib = 'uxtheme.dll';
begin
  if UxDllHandle = 0 then
  begin
    UxDllHandle := LoadLibrary(themelib);
    SetWindowTheme := GetProcAddress(UxDllHandle, 'SetWindowTheme');
    IsThemeActive := GetProcAddress(UxDllHandle, 'IsThemeActive');
    IsAppThemed := GetProcAddress(UxDllHandle, 'IsAppThemed');
  end;
end;

procedure TuxTheme.Clear;
begin
  if UxDllHandle <> 0 then begin
    FreeLibrary(UxDllHandle);
    UxDllHandle := 0;
    SetWindowTheme := nil;
  end;
end;

function TUxTheme.IsThemed: Boolean;
begin
  if UxDllHandle <> 0 then
    IsThemed := IsAppThemed
  else
    IsThemed := FALSE;
end;

procedure TUxTheme.DisableWindowTheme(hwnd: HWND);
begin
  if IsThemed then SetWindowTheme(hwnd, '','');
end;
{- TUxTheme Implementation End ------------------------------------------------}


initialization
  UxDllHandle := 0;


end.
