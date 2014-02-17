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

unit Audioplay;

interface

USES MPlayer,
     SysUtils,             // für Fehlerbehandlung
     Dialogs,              // für Showmessage
     Messages,             // für WM_GRAPHNachricht
     DirectShow,           // für DirectShow
     DirectSound,          // für DirektSound_OK
     ActiveX,              // für CoUnInitialize ...
     Windows,              // für Infinite
     Sprachen,             // zum übersetzen der Meldungen
     AllgFunktionen;       // Meldungsfenster



PROCEDURE AudioplayerMCI_erzeugen(Player: TMediaPlayer);

PROCEDURE AudioplayerDS_erzeugen;

FUNCTION AudioplayerOeffnen(Name: STRING): Boolean;

PROCEDURE AudioPlayerPlay;

PROCEDURE AudioplayerPause;

PROCEDURE AudioplayerStop;

FUNCTION AudioplayerMode: TMPModes;

PROCEDURE AudioplayerPosition_setzen(Pos: Longint);

FUNCTION AudioplayerPosition_holen: Longint;

PROCEDURE AudioplayerClose;

VAR GraphName : STRING;
    Fehleranzeigen : Boolean;
    Audioplayer_OK : Boolean;
    DirectShowverwenden : Boolean;

implementation

CONST
  WM_GRAPHNachricht = WM_APP + 1;


VAR Audioplayer: TMediaPlayer;
    Audiofehler : Boolean;
    Graph : IGraphBuilder = NIL;
    MedienSteuerung : IMediaControl = NIL;
    VideoFenster : IVideoWindow  = NIL;
    Ereingis : IMediaEventEx = NIL;
    MedienPosition : IMediaSeeking = NIL;
    ROT_ID : Integer;

//--------------------- MCI Schnittstelle -----------------------------------

PROCEDURE AudioplayerMCI_erzeugen(Player: TMediaPlayer);
BEGIN
  Audioplayer := Player;
  DirectShowverwenden := False;
END;

PROCEDURE AudioplayerMCIClose;
BEGIN
  IF Audioplayer_OK THEN
  BEGIN
    TRY
      IF Audioplayer.Mode = mpPlaying THEN
        Audioplayer.Stop;
      Audioplayer.Close;
    EXCEPT
    END;
    Audioplayer_OK := False;
  END;
END;

FUNCTION AudioplayerMCIOeffnen(Name: STRING): Boolean;
BEGIN
  AudioplayerMCIClose;
  TRY
    Audioplayer.Filename := Name;
    Audioplayer.Open;
    Audiofehler := False;
  EXCEPT
    ON E: EAccessViolation DO
    BEGIN
      IF Fehleranzeigen THEN
        Meldungsfenster(Wortlesen(NIL, 'Meldung61', 'Die Audiodatei kann nicht wiedergegeben werden.') + Chr(13) +
                         Wortlesen(NIL, 'Meldung62', 'Windows meldet folgenden Fehler:') + ' ' + Chr(13) + E.Message);
      Audiofehler := True;
    END;
    ON E: EMCIDeviceError DO
    BEGIN
      IF Fehleranzeigen THEN
        Meldungsfenster(Wortlesen(NIL, 'Meldung61', 'Die Audiodatei kann nicht wiedergegeben werden.') + Chr(13) +
                         Wortlesen(NIL, 'Meldung62', 'Windows meldet folgenden Fehler:') + ' ' + Chr(13) + E.Message);
      Audiofehler := True;
    END
  ELSE
      IF Fehleranzeigen THEN
        Meldungsfenster(Wortlesen(NIL, 'Meldung61', 'Die Audiodatei kann nicht wiedergegeben werden.'));
    Audiofehler := True;
  END;
  IF NOT Audiofehler THEN
  BEGIN
    IF Audioplayer.DeviceID > 0 THEN
    BEGIN
      Audioplayer_OK := True;
      Result := True;
      Audioplayer.Timeformat := tfMilliseconds;
    END
    ELSE
    BEGIN
      TRY
        Audioplayer.Close;
      EXCEPT
      END;
      Audioplayer_OK := False;
      Result := False;
    END;
  END
  ELSE
  BEGIN
    Audioplayer_OK := False;
    Result := False;
  END;
END;

PROCEDURE AudioPlayerMCIPlay;
BEGIN
  IF Audioplayer_OK THEN
  BEGIN
    TRY
      Audioplayer.Play;
    EXCEPT
    END;
  END;
END;

PROCEDURE AudioplayerMCIPause;
BEGIN
  IF Audioplayer_OK THEN
  BEGIN
    TRY
      Audioplayer.Pause;
    EXCEPT
    END;
  END;
END;

PROCEDURE AudioplayerMCIStop;
BEGIN
  IF Audioplayer_OK THEN
  BEGIN
    TRY
      Audioplayer.Stop;
    EXCEPT
    END;
  END;
END;

FUNCTION AudioplayerMCIMode: TMPModes;
BEGIN
  IF Audioplayer_OK THEN
  BEGIN
    TRY
      Result := Audioplayer.Mode
    EXCEPT
      Result := mpNotReady;
    END;
  END
  ELSE
    Result := mpNotReady;
END;

PROCEDURE AudioplayerMCIPosition_setzen(Pos: Longint);
BEGIN
  IF Audioplayer_OK THEN
  BEGIN
    TRY
      Audioplayer.Position := Pos;
    EXCEPT
    END;
  END;
END;

FUNCTION AudioplayerMCIPosition_holen: Longint;
BEGIN
  IF Audioplayer_OK THEN
  BEGIN
    TRY
      Result := Audioplayer.Position;
    EXCEPT
      Result := 0;
    END;
  END
  ELSE
    Result := 0;
END;

//--------------------- DirectShow Schnittstelle ----------------------------

  //----------------------------------------------------------------------------
  // Enable Graphedit to connect with your filter graph
  //----------------------------------------------------------------------------
  function AddGraphToRot(Graph: IFilterGraph; out ID: integer): HRESULT;
  var
    Moniker: IMoniker;
    ROT    : IRunningObjectTable;
    wsz    : WideString;
  begin
    result := GetRunningObjectTable(0, ROT);
    if (result <> S_OK) then exit;
    wsz := format('FilterGraph %p pid %x',[pointer(graph),GetCurrentProcessId()]);
    result  := CreateItemMoniker('!', PWideChar(wsz), Moniker);
    if (result <> S_OK) then exit;
    result  := ROT.Register(0, Graph, Moniker, ID);
    Moniker := nil;
    ROT := nil;
  end;

  //----------------------------------------------------------------------------
  // Disable Graphedit to connect with your filter graph
  //----------------------------------------------------------------------------
  function RemoveGraphFromRot(ID: integer): HRESULT;
  var ROT: IRunningObjectTable;
  begin
    result := GetRunningObjectTable(0, ROT);
    if (result <> S_OK) then exit;
    result := ROT.Revoke(ID);
    ROT := nil;
  end;

PROCEDURE AudioplayerDS_erzeugen;
BEGIN
  IF DirektSound_OK THEN
    DirectShowverwenden := True;
  ROT_ID := -1;
END;

PROCEDURE AudioplayerDSClose;

VAR Filterstatus : TFilter_State;

BEGIN
  TRY
    TRY
      IF Assigned(Graph) THEN
      BEGIN
        IF ROT_ID > -1 THEN
          RemoveGraphFromRot(ROT_ID);
        IF Audioplayer_OK AND Assigned(MedienSteuerung) THEN
        BEGIN
          MedienSteuerung.GetState(Infinite, Filterstatus);
          IF Filterstatus = State_Running THEN
            MedienSteuerung.Stop;
        END;
        IF Assigned(MedienPosition) THEN
        BEGIN
          MedienPosition := NIL;
        END;
        IF Assigned(MedienSteuerung) THEN
        BEGIN
          MedienSteuerung := NIL;
        END;
        Graph := NIL;
      END;
    FINALLY
      CoUnInitialize;
    END;
  EXCEPT
  END;
  Audioplayer_OK := False;
END;

FUNCTION LadeGraph(Graph: IGraphBuilder; Name: STRING): Boolean;

VAR Storage : IStorage;
    PersistStream : IPersistStream;
    Stream : IStream;
    ArrayName : ARRAY [0..1024] OF WideChar;

BEGIN
  Result := False;
  StringToWideChar(Name, ArrayName, 1024);
  IF NOT Failed(StgIsStorageFile(@ArrayName)) THEN
    IF NOT Failed(StgOpenStorage(@ArrayName, NIL,STGM_TRANSACTED OR STGM_READ OR
                  STGM_SHARE_DENY_WRITE, NIL, 0, Storage)) THEN
      IF NOT Failed(Graph.QueryInterface(IID_IPersistStream, PersistStream)) THEN
        IF NOT Failed(Storage.OpenStream('ActiveMovieGraph', NIL,
                      STGM_READ or STGM_SHARE_EXCLUSIVE, 0, Stream)) THEN
          IF NOT Failed(PersistStream.Load(Stream)) THEN
            Result := True;
  IF Assigned(Stream) THEN
    Stream := NIL;
  IF Assigned(Storage) THEN
    Storage := NIL;
  IF Assigned(PersistStream) THEN
    PersistStream := NIL;
END;

FUNCTION RenderGraphvonDatei(Name: STRING): Boolean;

VAR PName : PWideChar;

BEGIN
  GetMem(PName, MAX_PATH + MAX_PATH);
  TRY
    MultiByteToWideChar(CP_ACP, 0, PChar(Name), -1, PName, MAX_PATH);
    IF Graph.RenderFile(PName, NIL) <> S_OK THEN
      Result := False
    ELSE
      Result := True;
  FINALLY
    FreeMem(PName, MAX_PATH + MAX_PATH);
  END;
END;

PROCEDURE Graphanzeigen;

VAR FilterEnum : IEnumFilters;
    Filter : IBaseFilter;
    FilterInfo : TFilterInfo;
    Text : STRING;

BEGIN
  Text := Wortlesen(NIL, 'Meldung63', 'eingefügte Filter:') + Chr(13);
  Graph.EnumFilters(FilterEnum);
  WHILE FilterEnum.Next(1, Filter, NIL) = S_OK DO
  BEGIN
    Filter.QueryFilterInfo(FilterInfo);
    Text := Text + Chr(13) + FilterInfo.achName;
  END;
  IF ROT_ID > -1 THEN
    RemoveGraphFromRot(ROT_ID);
  AddGraphToRot(Graph, ROT_ID);           // zum Testen mit Graphedit
  Meldungsfenster(Text);
END;

FUNCTION AudioplayerDSOeffnen(Name: STRING): Boolean;

VAR Groesse: int64;

BEGIN
  AudioplayerDSClose;
  TRY
    CoInitialize(NIL);
    CoCreateInstance(CLSID_FilterGraph, NIL, CLSCTX_INPROC, IID_IGraphBuilder, Graph);
    IF Assigned(Graph) THEN
    BEGIN
      Graph.QueryInterface(IID_IMediaControl, MedienSteuerung);
      Graph.QueryInterface(IID_IMediaSeeking, MedienPosition);
    END;
    IF (Graph = NIL) OR
       (MedienSteuerung = NIL) OR
       (MedienPosition = NIL) THEN
    BEGIN
      IF Fehleranzeigen THEN
        Meldungsfenster(Wortlesen(NIL, 'Meldung61', 'Die Audiodatei kann nicht wiedergegeben werden.') + Chr(13) +
                        Wortlesen(NIL, 'Meldung64', 'Die DirectShow-Schnittstelle von Windows konnte nicht initialisiert werden.'));
      Result := False;
      AudioplayerDSClose;
    END
    ELSE
    BEGIN
      IF GraphName <> '' THEN
      BEGIN
        IF NOT LadeGraph(Graph, GraphName) THEN
          IF Fehleranzeigen THEN
            Meldungsfenster(Wortlesen(NIL, 'Meldung65', 'Der Graph konnte nicht geladen werden.') + Chr(13) +
                            Wortlesen(NIL, 'Meldung66', 'Es wird versucht einen Graphen automatisch zu erstellen.'));
        IF Fehleranzeigen THEN
          Graphanzeigen;
      END;
      Result := RenderGraphvonDatei(Name);
      IF Fehleranzeigen THEN
        Graphanzeigen;
      IF Result THEN
      BEGIN
        Audioplayer_OK := True;
        MedienPosition.GetDuration(Groesse);
      END
      ELSE
      BEGIN
        IF Fehleranzeigen THEN
          Meldungsfenster(Wortlesen(NIL, 'Meldung61', 'Die Audiodatei kann nicht wiedergegeben werden.') + Chr(13) +
                          Wortlesen(NIL, 'Meldung67', 'Für die Datei wurden keine passenden Filter gefunden.'));
        AudioplayerDSClose;
      END;
    END;
  EXCEPT
    Result := False;
  END;
END;

PROCEDURE AudioPlayerDSPlay;
BEGIN
  TRY
    IF Audioplayer_OK AND (MedienSteuerung <> NIL) THEN
      MedienSteuerung.Run;
  EXCEPT
  END;
END;

PROCEDURE AudioplayerDSPause;
BEGIN
  TRY
    IF Audioplayer_OK AND (MedienSteuerung <> NIL) THEN
      MedienSteuerung.Pause;
  EXCEPT
  END;
END;

PROCEDURE AudioplayerDSStop;
BEGIN
  TRY
    IF Audioplayer_OK AND (MedienSteuerung <> NIL) THEN
      MedienSteuerung.Stop;
  EXCEPT
  END;
END;

FUNCTION AudioplayerDSMode: TMPModes;

VAR Filterstatus : TFilter_State;

BEGIN
  TRY
    IF Audioplayer_OK AND (MedienSteuerung <> NIL) THEN
    BEGIN
      MedienSteuerung.GetState(Infinite, Filterstatus);
      CASE Filterstatus OF
        State_Stopped : Result := mpStopped;
        State_Paused  : Result := mpPaused;
        State_Running : Result := mpPlaying;
      ELSE
        Result := mpNotReady;
      END;
    END
    ELSE
      Result := mpNotReady;
  EXCEPT
    Result := mpNotReady;
  END;
END;

PROCEDURE AudioplayerDSPosition_setzen(Pos: Longint);

VAR Position : Int64;

BEGIN
  TRY
    Position := Pos;
    Position := Position * 10000;
    IF Audioplayer_OK AND (MedienPosition <> NIL) THEN
      MedienPosition.SetPositions(Position, AM_SEEKING_AbsolutePositioning,
                                  Position, AM_SEEKING_NoPositioning);
  EXCEPT
  END;
END;

FUNCTION AudioplayerDSPosition_holen: Longint;

VAR Pos : Int64;

BEGIN
  TRY
    IF Audioplayer_OK AND (MedienPosition <> NIL) THEN
      MedienPosition.GetCurrentPosition(Pos)      // in 100 ns
    ELSE
      Pos := 0;  
    Result := Round(Pos / 10000);                  // zurückgeben im ms
  EXCEPT
    Result := -1;
  END;
END;

//--------------------- Allgemeine Funktionen ----------------------------

FUNCTION AudioplayerOeffnen(Name: STRING): Boolean;
BEGIN
  IF DirectShowverwenden THEN
    Result := AudioplayerDSOeffnen(Name)
  ELSE
    Result := AudioplayerMCIOeffnen(Name);
END;

PROCEDURE AudioPlayerPlay;
BEGIN
  IF DirectShowverwenden THEN
    AudioPlayerDSPlay
  ELSE
    AudioPlayerMCIPlay;
END;

PROCEDURE AudioplayerPause;
BEGIN
  IF DirectShowverwenden THEN
    AudioPlayerDSPause
  ELSE
    AudioPlayerMCIPause;
END;

PROCEDURE AudioplayerStop;
BEGIN
  IF DirectShowverwenden THEN
    AudioPlayerDSStop
  ELSE
    AudioPlayerMCIStop;
END;

FUNCTION AudioplayerMode: TMPModes;
BEGIN
  IF DirectShowverwenden THEN
    Result := AudioplayerDSMode
  ELSE
    Result := AudioplayerMCIMode;
END;

PROCEDURE AudioplayerPosition_setzen(Pos: Longint);
BEGIN
  IF DirectShowverwenden THEN
    AudioPlayerDSPosition_setzen(Pos)
  ELSE
    AudioPlayerMCIPosition_setzen(Pos);
END;

FUNCTION AudioplayerPosition_holen: Longint;
BEGIN
  IF DirectShowverwenden THEN
    Result := AudioplayerDSPosition_holen
  ELSE
    Result := AudioplayerMCIPosition_holen;
END;

PROCEDURE AudioplayerClose;
BEGIN
  IF DirectShowverwenden THEN
    AudioPlayerDSClose
  ELSE
    AudioPlayerMCIClose;
END;

end.
