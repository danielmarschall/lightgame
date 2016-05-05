program LightGame;

uses
  Forms,
  LightGameMain in 'LightGameMain.pas' {MainForm},
  LightGameAbout in 'LightGameAbout.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Light Game';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
