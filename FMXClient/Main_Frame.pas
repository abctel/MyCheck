unit Main_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  // --------OrangUI-----------
  uFuncCommon, uUIFunction, uSkinFireMonkeyControl, uSkinPanelType,
  uSkinFireMonkeyPanel,
  // --------ZServer4D---------

  // --------其它单元---------
  uSkinButtonType, uSkinFireMonkeyButton;

type
  TFrameMain = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnExit: TSkinFMXButton;
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalMainFrame: TFrameMain;

implementation

uses
  DB_Module;
{$R *.fmx}

procedure TFrameMain.btnExitClick(Sender: TObject);
begin
  HideFrame(Self, hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

end.

