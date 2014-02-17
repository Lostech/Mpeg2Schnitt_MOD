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
