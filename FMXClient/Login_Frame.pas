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
  DoStatusIO, DataFrameEngine, CommunicationFramework,
  // --------三方控件单元---------
  uSkinButtonType, uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameLogin = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    edtUserName: TSkinFMXEdit;
    edtPassWord: TSkinFMXEdit;
    btnLogin: TSkinFMXButton;
    pnlUserName: TSkinFMXPanel;
    pnlPassWord: TSkinFMXPanel;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    Memo1: TMemo;
    pnlLogo: TSkinFMXPanel;
    edtLogo: TSkinFMXEdit;
    imgLogo: TSkinFMXImage;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
    procedure UserLogin;
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalLoginFrame: TFrameLogin;

implementation

uses
  Main_Form, ClientDefine;

{$R *.fmx}

procedure TFrameLogin.btnLoginClick(Sender: TObject);
begin
  if edtUserName.Text = '' then
  begin
    ShowMessageBoxFrame(FrmMain, '登录失败', '账号为空，请输入您的账号！', TMsgDlgType.mtError, ['确定'], nil);
    Exit;
  end;
  if edtPassWord.Text = '' then
  begin
    ShowMessageBoxFrame(FrmMain, '登录失败', '密码为空，请输入您的账号！', TMsgDlgType.mtError, ['确定'], nil);
  end
  else
  begin
    UserLogin;
  end;

end;

procedure TFrameLogin.UserLogin;
var
  tempStm: TDataFrameEngine;
begin
//显示等待状态
  ShowWaitingFrame(Self, '登录中...');
  // 异步连接服务端
  DBM.Client.AsyncConnectP(HostIP, RecvPort, SendPort,
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // 异步登录操作
        DBM.Client.UserLoginP(edtUserName.Text, edtPassWord.Text,
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
                  //获取用户资料
                    tempStm := TDataFrameEngine.Create;
                    tempStm.WriteString(edtUserName.Text);
                    DBM.Client.SendTunnel.SendStreamCmdP('cmd_QueryLoginUserInfo', tempStm,
                      procedure(Sender: TPeerIO; ResultData: TDataFrameEngine)
                      begin
                        DoStatus('1');
                        DoStatus(ResultData.Reader.ReadString);
                      end);
                    tempStm.Free;








//                  //隐藏等待状态
                    HideWaitingFrame;
//                    //ShowMessageBoxFrame(FrmMain, '登录成功', '', TMsgDlgType.mtInformation, ['确定'], nil);
//                    //释放原主界面
//                    uFuncCommon.FreeAndNil(GlobalMainFrame);
//
//                    //进入主界面
//                    HideFrame(Self, hfcttBeforeReturnFrame);
//                    ShowFrame(TFrame(GlobalMainFrame), TFrameMain, FrmMain, nil, nil, nil, Application, True, True, ufsefDefault);
//                    GlobalMainFrame.FrameHistroy := CurrentFrameHistroy;
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

