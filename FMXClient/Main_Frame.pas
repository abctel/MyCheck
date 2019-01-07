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
  // --------������Ԫ---------
  uSkinButtonType, uSkinFireMonkeyButton, uDrawPicture, uSkinImageList,
  uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinFireMonkeyListView, uSkinMultiColorLabelType,
  uSkinFireMonkeyMultiColorLabel, uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel;

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
  // ���ص�ǰҳ
  HideFrame(Self, hfcttBeforeReturnFrame);
  // ������һҳ
  ReturnFrame(Self.FrameHistroy);

end;

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;
  try
    //ShowMessageBoxFrame(FrmMain, UserInfo.var_Login_Name, UserInfo.var_Login_Name, TMsgDlgType.mtError, ['ȷ��'], nil);
    //���û����Ͻ��и�ֵ����

    //clab_Wellcome.Properties.ColorTextCollection.Items[1].Text := UserInfo.var_Login_Name;


  except
    on E: Exception do
      DoStatus(E.ClassName + ': ' + E.Message);
  end;
end;

end.

