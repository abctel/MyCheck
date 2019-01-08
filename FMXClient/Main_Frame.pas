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
  uSkinFireMonkeyMultiColorLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinItems;

type
  TFrameMain = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnExit: TSkinFMXButton;
    pnlContent: TSkinFMXPanel;
    pnlMain: TSkinFMXPanel;
    lvMain: TSkinFMXListView;
    dspCYGN: TSkinFMXItemDesignerPanel;
    SkinFMXImage2: TSkinFMXImage;
    SkinFMXLabel5: TSkinFMXLabel;
    dspHeader: TSkinFMXItemDesignerPanel;
    lblHCaption: TSkinFMXLabel;
    dspTotal: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblPrice: TSkinFMXLabel;
    lblNum: TSkinFMXLabel;
    lblNum1: TSkinFMXLabel;
    lblPrice1: TSkinFMXLabel;
    procedure btnExitClick(Sender: TObject);
    procedure lvMainClickItem(AItem: TSkinItem);
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
    //ShowMessageBoxFrame(FrmMain, UserInfo.var_Login_Name, UserInfo.var_Login_Name, TMsgDlgType.mtError, ['确定'], nil);
    //对用户资料进行赋值操作

    //clab_Wellcome.Properties.ColorTextCollection.Items[1].Text := UserInfo.var_Login_Name;


  except
    on E: Exception do
      DoStatus(E.ClassName + ': ' + E.Message);
  end;
end;

procedure TFrameMain.lvMainClickItem(AItem: TSkinItem);
begin
  case AItem.Index of

    4:
      begin
        DBM.Client.SendTunnel.SendDirectConsoleCmd('cmd_Console', 'INSERT INTO Water_Info(Project_Num) VALUES(' + '''123456''' + ');');
        ShowMessageBoxFrame(FrmMain, AItem.Index.ToString, AItem.Index.ToString, TMsgDlgType.mtError, ['确定'], nil);
      end;
  end;

end;

end.

