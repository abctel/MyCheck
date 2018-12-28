unit Login_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  // --------OrangUI自选-----------
  uFuncCommon, uUIFunction, MessageBoxFrame,
  // --------其它单元---------
  DB_Module,
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

{$R *.fmx}

procedure TFrameLogin.SkinFMXButton1Click(Sender: TObject);
begin
  while (not DBM.Client.RemoteInited) and (DBM.Client.Connected) do
  begin
    TThread.Sleep(10);
    DBM.Client.Progress;
  end;
  if DBM.Client.Connected then
  begin
      // 嵌套式匿名函数支持
    DBM.Client.UserLoginP(edtUserName.Text, edtPassWord.Text,
      procedure(const State: Boolean)
      begin
        if State then
          DBM.Client.TunnelLinkP(
            procedure(const State: Boolean)
            begin
              DoStatus('double tunnel link success!');
            end)
      end);
  end;
//  if DBM.Client.Connected then
//  begin
////    if DBM.Client.UserLogin('abctel', '53335641') then
//
////    DBM.Client.UserLoginP('abctel', '53335641',
////      procedure(const cState: Boolean)
////      begin
////        if cState then
////        begin
////
////          DBM.Client.TunnelLinkP(
////            procedure(const sState: Boolean)
////            begin
////              if sState then
////              begin
////                ShowMessageBoxFrame(GlobalLoginFrame, '登录成功', '', TMsgDlgType.mtInformation, ['确定'], nil);
////              end
////              else
////              begin
////                ShowMessageBoxFrame(GlobalLoginFrame, '网络错误，请检查网络后重新再试！', '', TMsgDlgType.mtInformation, ['确定'], nil);
////                Exit;
////              end;
////            end);
////        end
////        else
////        begin
////        if cState then
////        begin
////           ShowMessageBoxFrame(GlobalLoginFrame, '登录成功', '', TMsgDlgType.mtInformation, ['确定'], nil);
////        end;
////          ShowMessageBoxFrame(GlobalLoginFrame, '账号或密码错误，请重新再试！', '', TMsgDlgType.mtInformation, ['确定'], nil);
////          Exit;
////        end;
////      end);
//
//
//        // 嵌套式匿名函数支持
//
//  end
//  else
//  begin
//    ShowMessageBoxFrame(GlobalLoginFrame, '网络错误，请检查网络后重新再试！', '', TMsgDlgType.mtInformation, ['确定'], nil);
//    Exit;
//  end;

end;

end.

