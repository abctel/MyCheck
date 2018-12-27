unit Templet_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  //--------OrangUI-----------
  uFuncCommon, uUIFunction, uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel,
  //--------ZServer4D---------

  //--------其它单元---------
  DB_Module, uSkinButtonType, uSkinFireMonkeyButton
;

type
  TFrameTemplet = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
  private
    { Private declarations }
  public
    { Public declarations }
    FrameHistroy:TFrameHistroy;
  end;

var
  GlobalTempletFrame: TFrameTemplet;

implementation

{$R *.fmx}

end.

