; (De)Coder Script für InnoSetup
; Fehler bei Uninstallation: ReadOnly, Anwendung in Benutzung

[Setup]
AppName=LightGame
AppVerName=LightGame
AppVersion=1.0
AppCopyright=© Copyright 2009 - 2018 ViaThinkSoft.
AppPublisher=ViaThinkSoft
AppPublisherURL=http://www.viathinksoft.de/
AppSupportURL=http://www.daniel-marschall.de/
AppUpdatesURL=http://www.viathinksoft.de/
DefaultDirName={pf}\LightGame
DefaultGroupName=LightGame
UninstallDisplayIcon={app}\LightGame.exe
VersionInfoCompany=ViaThinkSoft
VersionInfoCopyright=© Copyright 2009 - 2018 ViaThinkSoft.
VersionInfoDescription=LightGame Setup
VersionInfoTextVersion=1.0.0.0
VersionInfoVersion=1.
OutputBaseFilename=LightGameSetup
Compression=zip/9

[Languages]
Name: de; MessagesFile: "compiler:Languages\German.isl"

[Files]
; Allgemein
Source: "LightGame.exe"; DestDir: "{app}"

[Folders]
Name: "{group}\Webseiten"; Languages: de

[Icons]
; Allgemein
Name: "{group}\LightGame"; Filename: "{app}\LightGame.exe"
; Deutsch
Name: "{group}\Deinstallieren"; Filename: "{uninstallexe}"
Name: "{group}\Webseiten\Daniel Marschall"; Filename: "https://www.daniel-marschall.de/"
Name: "{group}\Webseiten\ViaThinkSoft"; Filename: "https://www.viathinksoft.de/"
Name: "{group}\Webseiten\Projektseite auf ViaThinkSoft"; Filename: "https://www.viathinksoft.de/projects/lightgame"

[Run]
Filename: "{app}\LightGame.exe"; Description: "LightGame"; Flags: nowait postinstall skipifsilent

[Code]
function InitializeSetup(): Boolean;
begin
  if CheckForMutexes('LightGameSetup')=false then
  begin
    Createmutex('LightGameSetup');
    Result := true;
  end
  else
  begin
    Result := False;
  end;
end;

