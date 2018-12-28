unit Login_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  // --------OrangUI自选-----------
  uFuncCommon, uUIFunction, MessageBoxFrame, WaitingFrame,
  // --------其它单元---------
  DB_Module, Main_Frame,
  // --------ZServer4D---------
  DoStatusIO,
  // --------三方控件单元---------
  uSkinButtonType, uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel;

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
    Memo1: TMemo;
    procedure SkinFMXButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalLoginFrame: TFrameLogin;

implementation

uses
  Main_Form;

{$R *.fmx}

procedure TFrameLogin.SkinFMXButton1Click(Sender: TObject);
begin
//显示等待状态
  ShowWaitingFrame(Self, '登录中...');
  // 异步连接服务端
  DBM.Client.AsyncConnectP('127.0.0.1', 9816, 9815,
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // 异步登录操作
        DBM.Client.UserLoginP('abctel', '53335641',
          procedure(const cState: Boolean)
          begin
            if cState then
            begin
              // 异步检查双通道是否创建成功
              DBM.Client.TunnelLinkP(
                procedure(const sState: Boolean)
                begin
                  if sState then
                  begin
                  //隐藏等待状态
                    HideWaitingFrame;
                    //ShowMessageBoxFrame(FrmMain, '登录成功', '', TMsgDlgType.mtInformation, ['确定'], nil);
                    //释放原主界面
                    uFuncCommon.FreeAndNil(GlobalMainFrame);

                    //进入主界面
                    HideFrame(Self, hfcttBeforeReturnFrame);
                    ShowFrame(TFrame(GlobalMainFrame), TFrameMain, FrmMain, nil, nil, nil, Application, True, True, ufsefNone);
                    GlobalMainFrame.FrameHistroy := CurrentFrameHistroy;
                  end
                  else
                  begin
                  //隐藏等待状态
                    HideWaitingFrame;
                    ShowMessageBoxFrame(FrmMain, '登录失败', '网络错误，请检查网络后重新再试！', TMsgDlgType.mtError, ['确定'], nil);
                    Exit;
                  end;
                end);
            end
            else
            begin
              //隐藏等待状态
              HideWaitingFrame;
              ShowMessageBoxFrame(FrmMain, '登录失败', '账号或密码错误，请重新再试！', TMsgDlgType.mtError, ['确定'], nil);
              Exit;
            end;
          end);
      end
      else
      begin
      //隐藏等待状态
        HideWaitingFrame;
        ShowMessageBoxFrame(GlobalLoginFrame, '登录失败', '网络错误，请检查网络后重新再试！', TMsgDlgType.mtError, ['确定'], nil);
        Exit;
      end;

    end);
end;

end.

