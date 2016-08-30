unit LightGameMain;

(*
  TODO for the future:
  Predefined Levels...
  Undo...
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, System.UITypes;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Image1: TImage;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Newgame1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Cleargrid1: TMenuItem;
    Designmode1: TMenuItem;
    N2: TMenuItem;
    Save1: TMenuItem;
    Loadgrid1: TMenuItem;
    N3: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    procedure Panel1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Newgame1Click(Sender: TObject);
    procedure Cleargrid1Click(Sender: TObject);
    procedure Loadgrid1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Designmode1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  protected const
    SIZE_X = 5;
    SIZE_Y = 5;
    RANDOM_STEPS = 1000;
    ONCOLOR = clYellow;
    OFFCOLOR = clSilver;
  private
    FStartTime: TDateTime;
    FMoves: integer;
    function GetDesignMode: boolean;
    procedure SetDesignMode(const Value: boolean);
  protected
    GameGrid: array[0..SIZE_X-1, 0..SIZE_Y-1] of boolean;
    property DesignMode: boolean read GetDesignMode write SetDesignMode;
    procedure ResetCounter;
    procedure IncCounter;
    procedure ToggleSingle(x, y: integer);
    procedure RedrawGrid;
    procedure RandomMove(PreferLights: boolean=true; redraw: boolean=true);
    procedure Draw(x, y: integer; redraw: boolean=true);
    procedure ClearGrid(redraw: boolean=true);
    function LightsOut: boolean;
    procedure LoadGame(FileName: string);
    procedure SaveGame(FileName: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  LightGameAbout, IniFiles, DateUtils;

{ TMainForm }

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.ClearGrid(redraw: boolean=true);
var
  x, y: integer;
begin
  for x := 0 to SIZE_X - 1 do
    for y := 0 to SIZE_Y - 1 do
      GameGrid[x][y] := false;
  if redraw then RedrawGrid;
end;

procedure TMainForm.Cleargrid1Click(Sender: TObject);
begin
  ClearGrid;
  ResetCounter;
end;

procedure TMainForm.Designmode1Click(Sender: TObject);
resourcestring
  LNG_CLEARGRID = 'Clear grid?';
begin
  if DesignMode then
  begin
    if MessageDlg(LNG_CLEARGRID, mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      ClearGrid;
    end;
  end;
  ResetCounter;
end;

procedure TMainForm.Draw(x, y: integer; redraw: boolean=true);
begin
  ToggleSingle(x, y);

  if not DesignMode then
  begin
    ToggleSingle(x-1, y);
    ToggleSingle(x+1, y);
    ToggleSingle(x, y-1);
    ToggleSingle(x, y+1);
  end;

  if redraw then RedrawGrid;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Randomize;

  ClientWidth := Image1.Width;
  ClientHeight := Image1.Height;

  ClearGrid;
end;

function TMainForm.GetDesignMode: boolean;
begin
  result := Designmode1.Checked;
end;

procedure TMainForm.IncCounter;
begin
  Inc(FMoves);
  if FMoves = 1 then FStartTime := Now;
  Timer1Timer(Timer1);
end;

function TMainForm.LightsOut: boolean;
var
  x, y: integer;
begin
  result := true;
  for x := 0 to SIZE_X - 1 do
  begin
    for y := 0 to SIZE_Y - 1 do
    begin
      if GameGrid[x][y] then
      begin
        result := false;
        Exit;
      end;
    end;
  end;
end;

procedure TMainForm.Loadgrid1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    LoadGame(OpenDialog1.FileName);
  end;
  ResetCounter;
end;

procedure TMainForm.Newgame1Click(Sender: TObject);
var
  i, RandomSteps: integer;
begin
  DesignMode := false;
  RandomSteps := Random(RANDOM_STEPS);
  for i := 0 to RandomSteps - 1 do
  begin
    RandomMove(true, false);
  end;
  RedrawGrid;
  ResetCounter;
end;

procedure TMainForm.Panel1Click(Sender: TObject);
resourcestring
  LNG_WIN = 'Congratulations! You solved the puzzle in %d moves in %.2d:%.2d min.';
var
  x, y, idx: integer;
  secs: integer;
begin
  idx := TPanel(Sender).Tag-1;

  x := idx div SIZE_X;
  y := idx mod SIZE_Y;

  Draw(x, y);

  if not DesignMode then IncCounter;

  RedrawGrid;

  if LightsOut and not DesignMode then
  begin
    secs := SecondsBetween(Now, FStartTime);
    ShowMessageFmt(LNG_WIN, [FMoves, secs div 60, secs mod 60]);
  end;
end;

procedure TMainForm.RandomMove(PreferLights: boolean=true; redraw: boolean=true);
var
  x, y: integer;
begin
  if not PreferLights then
  begin
    x := Random(SIZE_X);
    y := Random(SIZE_Y);
    Draw(x, y, redraw);
  end
  else
  begin
    if LightsOut then
    begin
      x := Random(SIZE_X);
      y := Random(SIZE_Y);
      Draw(x, y, redraw);
    end
    else
    begin
      repeat
        x := Random(SIZE_X);
        y := Random(SIZE_Y);
      until GameGrid[x][y];
      Draw(x, y, redraw);
    end;
  end;
end;

procedure TMainForm.RedrawGrid;
var
  x, y, idx, c: integer;
  p: TPanel;
  comp: TComponent;
begin
  idx := 0;
  for x := Low(GameGrid) to High(GameGrid) do
  begin
    for y := Low(GameGrid[x]) to High(GameGrid[x]) do
    begin
      Inc(idx);

      p := nil;
      for c := 0 to ComponentCount - 1 do
      begin
        comp := Components[c];
        if (comp is TPanel) and (comp.Tag = idx) then
        begin
          p := TPanel(comp);
        end;
      end;

      if Assigned(p) then
      begin
        if GameGrid[x][y] then
        begin
          p.Color := ONCOLOR;
        end
        else
        begin
          p.Color := OFFCOLOR;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.ResetCounter;
begin
  FStartTime := 0;
  FMoves := 0;
  Timer1Timer(Timer1);
end;

procedure TMainForm.Save1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    SaveGame(SaveDialog1.FileName);
  end;
end;

procedure TMainForm.LoadGame(FileName: string);
var
  ini: TMemIniFile;
  x, y: integer;
  s: string;
begin
  ini := TMemIniFile.Create(FileName);
  try
    for x := 0 to SIZE_X - 1 do
    begin
      for y := 0 to SIZE_Y - 1 do
      begin
        begin
          s := IntToStr(x) + ',' + IntToStr(y);              { do not localize }
          GameGrid[x][y] := ini.ReadBool('Grid', s, false);  { do not localize }
        end;
      end;
    end;
  finally
    ini.Free;
  end;
  RedrawGrid;
end;

procedure TMainForm.SaveGame(FileName: string);
var
  ini: TMemIniFile;
  x, y: integer;
  s: string;
begin
  ini := TMemIniFile.Create(FileName);
  try
    for x := 0 to SIZE_X - 1 do
    begin
      for y := 0 to SIZE_Y - 1 do
      begin
        begin
          s := IntToStr(x) + ',' + IntToStr(y);      { do not localize }
          ini.WriteBool('Grid', s, GameGrid[x][y]);  { do not localize }
        end;
      end;
    end;
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure TMainForm.SetDesignMode(const Value: boolean);
begin
  Designmode1.Checked := Value;
  Designmode1Click(Designmode1);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
resourcestring
  LNG_MOVES = '%d moves';
var
  secs: integer;
begin
  label1.Visible := FMoves > 0;
  Label2.Visible := FMoves > 0;

  Label1.Caption := Format(LNG_MOVES, [FMoves]);

  secs := SecondsBetween(Now, FStartTime);
  Label2.Caption := Format('%.2d:%.2d', [secs div 60, secs mod 60]);
end;

procedure TMainForm.ToggleSingle(x, y: integer);
begin
  if (x < 0) or (x >= SIZE_X) then exit;
  if (y < 0) or (y >= SIZE_Y) then exit;

  GameGrid[x][y] := not GameGrid[x][y];
end;

end.
