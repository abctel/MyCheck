unit Main_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  // --------OrangUI-----------
  uFuncCommon, uUIFunction, uSkinFireMonkeyControl, uSkinPanelType,
  uSkinFireMonkeyPanel, MessageBoxFrame,
  // --------ZServer4D---------
  DoStatusIO,
  // --------其它单元---------
  uSkinButtonType, uSkinFireMonkeyButton, uDrawPicture, uSkinImageList,
  uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinFireMonkeyListView, uSkinMultiColorLabelType,
  uSkinFireMonkeyMultiColorLabel;

type
  TFrameMain = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnExit: TSkinFMXButton;
    pnlContent: TSkinFMXPanel;
    pnlListImg: TSkinFMXPanel;
    pnlMain: TSkinFMXPanel;
    ilpListImg: TSkinFMXImageListPlayer;
    SkinImageList1: TSkinImageList;
    SkinFMXListView1: TSkinFMXListView;
    SkinFMXPanel1: TSkinFMXPanel;
    clab_Wellcome: TSkinFMXMultiColorLabel;
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
    constructor Create(AOwner: TComponent); override;
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalMainFrame: TFrameMain;

implementation

uses
  DB_Module, Main_Form, ClientDefine;
{$R *.fmx}

procedure TFrameMain.btnExitClick(Sender: TObject);
begin
  // 隐藏当前页
  HideFrame(Self, hfcttBeforeReturnFrame);
  // 返回上一页
  ReturnFrame(Self.FrameHistroy);

end;

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;
  try
    ShowMessageBoxFrame(FrmMain, UserInfo.var_Login_Name, UserInfo.var_Login_Name, TMsgDlgType.mtError, ['确定'], nil);
    clab_Wellcome.Properties.ColorTextCollection.Items[1].Text := UserInfo.var_Login_Name;
//    clab_Wellcome.Properties.ColorTextCollection.Items[1].Text := 'dd';

  except
    on E: Exception do
      DoStatus(E.ClassName + ': ' + E.Message);
  end;
end;

end.

