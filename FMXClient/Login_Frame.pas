unit Login_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  //--------OrangUI-----------
  uFuncCommon, uUIFunction, uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel,
  //--------ZServer4D---------

  //--------其它单元---------
  DB_Module, uSkinButtonType, uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit
;

type
  TFrameLogin = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    edtUserName: TSkinFMXEdit;
    edtPassWord: TSkinFMXEdit;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
  private
    { Private declarations }
  public
    { Public declarations }
    FrameHistroy:TFrameHistroy;
  end;

var
  GlobalLoginFrame: TFrameLogin;

implementation

{$R *.fmx}

end.

