{----------------------------------------------------------------------------------------------
Diese Unit dem Beenden von Windows aus einem Programm herraus.

 Martin Dienert
 Homepage: http:www.mdienert.de/mpeg2schnitt/
 E-Mail:   meinmpeg2schnitt@gmx.de

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

unit WinEnde;

interface

USES Classes, Windows, SysUtils;

Type
  TWinType = (wtWindows95, wtWindowsNT, wtWin32s, wtUnknown);

function WindowsType: TWinType;
{ Gibt den Windowstype zurück.
      Windows 95 = wtWindows95; Windows NT = wtWindowsNT;
      Windows 3.11 = wtWin32s; Unbekannt = wtUnknown              }


function WindowsBeenden(EndeType: Word): boolean;
{ Beendet Windows.
  Endetypen: EWX_LOGOFF	=
             EWX_POWEROFF =
             EWX_REBOOT	=
             EWX_SHUTDOWN =                                       }

implementation

function WindowsType: TWinType;

var VersionInfo: TOSVersionInfo;

begin
  Result:=wtUnknown;
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  case VersionInfo.dwPlatformId of
    VER_PLATFORM_WIN32S        : Result:=wtWin32s;
    VER_PLATFORM_WIN32_WINDOWS : Result:=wtWindows95;
    VER_PLATFORM_WIN32_NT      : Result:=wtWindowsNT;
  end;
end;

function WindowsBeenden(EndeType: Word): boolean;

var Flags      : word;
    TPPrev,
    TP         : TTokenPrivileges;
    Token      : THandle;
    dwRetLen   : DWord;

begin
  Result := False;
  Flags := EndeType or EWX_FORCE;
  if WindowsType<>wtWindowsNT then
    ExitWindowsEx(Flags, 0)
  else
  if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,Token) then
  begin
    TP.PrivilegeCount:=1;
    if LookupPrivilegeValue(Nil, 'SeShutdownPrivilege', TP.Privileges[0].LUID) then
    begin
      TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      dwRetLen := 0;
      if AdjustTokenPrivileges(Token, False, TP, SizeOf(TPPrev), TPPrev, dwRetLen) then
      BEGIN
        Result:=ExitWindowsEx(Flags, 0);
        TP.Privileges[0].Attributes := 0;
        dwRetLen := 0;
        AdjustTokenPrivileges(Token, False, TP, SizeOf(TPPrev), TPPrev, dwRetLen)
      END;
    end;
    CloseHandle(Token);
  end;
end;

end.
