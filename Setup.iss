; (De)Coder Script für InnoSetup
; Fehler bei Uninstallation: ReadOnly, Anwendung in Benutzung

[Setup]
AppName=LightGame
AppVerName=LightGame
AppVersion=1.0
AppCopyright=© Copyright 2009 - 2024 ViaThinkSoft
AppPublisher=ViaThinkSoft
AppPublisherURL=http://www.viathinksoft.de/
AppSupportURL=http://www.daniel-marschall.de/
AppUpdatesURL=http://www.viathinksoft.de/
DefaultDirName={autopf}\LightGame
DefaultGroupName=LightGame
UninstallDisplayIcon={app}\LightGame.exe
VersionInfoCompany=ViaThinkSoft
VersionInfoCopyright=© Copyright 2009 - 2024 ViaThinkSoft
VersionInfoDescription=LightGame Setup
VersionInfoTextVersion=1.0.0.0
VersionInfoVersion=1.
OutputDir=.
OutputBaseFilename=LightGameSetup
; Configure Sign Tool in InnoSetup at "Tools => Configure Sign Tools" (adjust the path to your SVN repository location)
; Name    = sign_single   
; Command = "C:\SVN\...\sign_single.bat" $f
SignTool=sign_single
SignedUninstaller=yes

[Languages]
Name: de; MessagesFile: "compiler:Languages\German.isl"

[Files]
; Allgemein
Source: "LightGame.exe"; DestDir: "{app}"; Flags: ignoreversion signonce

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

