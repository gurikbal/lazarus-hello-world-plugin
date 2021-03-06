{
    Delphi Foundation for creating plugins for Notepad++
    (Short: DFPN++)

    Copyright (C) 2009 Bastian Blumentritt

    This file is part of DFPN++.

    DFPN++ is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    DFPN++ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with DFPN++.  If not, see <http://www.gnu.org/licenses/>.
}

unit nppp_basefuncs;

interface

uses
  Windows,
  nppp_types;

type
  TNPPBaseFunctions = class(TObject)
  private
    FNPPHandle: HWND;
  protected
  public
    constructor Create;
    procedure setNPPHandle(pHandle: HWND);

    function getCurrentColumn: Integer;
    function getCurrentLangType: TNppLang;
    function getCurrentLine: Integer;
    function getCurrentWord: nppString;
    function getFullCurrentPath: nppString;
    function getWindowsVersion: TWinVer;
    function openFile(const pFileName: nppString): Boolean;
    procedure setCurrentLangType(pLangType: TNppLang);
  end;

implementation

uses
  nppp_consts;

{ TNPPBaseFunctions }

constructor TNPPBaseFunctions.Create;
begin
  inherited;
  FNPPHandle := 0;
end;

procedure TNPPBaseFunctions.setNPPHandle(pHandle: HWND);
begin
  FNPPHandle := pHandle;
end;

function TNPPBaseFunctions.getCurrentColumn: Integer;
begin
  Result := SendMessage(FNPPHandle, NPPM_GETCURRENTCOLUMN, 0, 0);
end;

/// Returns the language type of current Scintilla view document.
function TNPPBaseFunctions.getCurrentLangType: TNppLang;
var
  tI: PINT;
begin
  tI := new(PINT);
  SendMessage(FNPPHandle, NPPM_GETCURRENTLANGTYPE, 0, LPARAM(tI));
  Result := TNppLang(tI^);
  Dispose(tI);
end;

function TNPPBaseFunctions.getCurrentLine: Integer;
begin
  Result := SendMessage(FNPPHandle, NPPM_GETCURRENTLINE, 0, 0);
end;

/// getCurrentWord retrieves the word on which cursor is currently of current
/// Scintilla view document. Afterwards, the current word is selected.
function TNPPBaseFunctions.getCurrentWord: nppString;
var
  tS: nppString;
begin
  SetLength(tS, 800);
  SendMessage(FNPPHandle, NPPM_GETCURRENTWORD, 0, LPARAM(nppPChar(tS)));
  Result := nppPChar(tS);
end;

/// getFullCurrentPath returns the absolute path to the currently active
/// document.
function TNPPBaseFunctions.getFullCurrentPath: nppString;
var
  tS: nppString;
begin
  SetLength(tS, MAX_PATH);
  SendMessage(FNPPHandle, NPPM_GETFULLCURRENTPATH, MAX_PATH, LPARAM(nppPChar(tS)));
  Result := nppPChar(tS);
end;

/// getWindowsVersion returns an element of the enumaration TWinVer, indicating
/// the current Windows(tm) version
function TNPPBaseFunctions.getWindowsVersion: TWinVer;
begin
  Result := TWinVer(SendMessage(FNPPHandle, NPPM_GETWINDOWSVERSION, 0, 0));
end;

/// openFile tries to open specified file in editor. Returns TRUE on success,
/// FALSE otherwise.
function TNPPBaseFunctions.openFile(const pFileName: nppString): Boolean;
begin
  Result := (SendMessage(FNPPHandle, WM_DOOPEN, 0, LPARAM(nppPChar(pFileName))) <> 0);
end;

/// setCurrentLangType is used to set the language type of current Scintilla
/// view document
procedure TNPPBaseFunctions.setCurrentLangType(pLangType: TNppLang);
begin
  SendMessage(FNPPHandle, NPPM_SETCURRENTLANGTYPE, 0, LPARAM(pLangType));
end;

end.
