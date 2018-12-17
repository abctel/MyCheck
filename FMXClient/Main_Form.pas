// convert pas to utf8 by ¥

unit Main_Form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,

  uBaseLog,
  uFuncCommon,
  uUIFunction,
  uComponentType,
  // uGPSLocation,
  uBaseHttpControl,
  DM_Form,
{$IFDEF ANDROID}
  Androidapi.Helpers,
{$ENDIF}
  MessageBoxFrame,
  PopupMenuFrame,
  ViewPictureListFrame,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyImage, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, IdBaseComponent, IdComponent, IdIPWatch,
  System.Notification, FMX.Objects, FMX.Gestures, System.Sensors,
  System.Sensors.Components, uBaseSkinControl, uSkinPanelType;

const
  Host = '127.0.0.1';
  Port = '1224';

type
  TfrmMain = class(TForm)
    pnlVirtualKeyBoard: TSkinFMXPanel;
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    { Private declarations }
  private
    FGestureManager: TGestureManager;
    // RemoteSrvOBJ: TRemoteServerDIOCPImpl;
    // RemoteSrv: IRemoteServer;
  public
    // FGPSLocation: TGPSLocation;

    // 登录
    procedure Login;
    // 退出登录
    procedure Logout;
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Main_Frame,
  Login_Frame;

{$R *.fmx}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

{$IFNDEF MSWINDOWS}
  FGestureManager := TGestureManager.Create(Self);
  Self.Touch.GestureManager := FGestureManager;
{$ENDIF}
{$IFDEF ANDROID}
  // Android 4.4.4及以上版本
  if (TOSVersion.Major > 4) or (TOSVersion.Major = 4) and
    (TOSVersion.Minor >= 4) and (TOSVersion.Build >= 4) then
  begin
    // Android下用了透明任务栏的模式
    // 顶部任务栏用Panel增高的方式
    uComponentType.IsAndroidIntelCPU := True;
  end;
{$ENDIF}
  // 在Windows平台下的模拟虚拟键盘控件
  SimulateWindowsVirtualKeyboardHeight := 160;
  IsSimulateVirtualKeyboardOnWindows := True;
  GlobalAutoProcessVirtualKeyboardControlClass := TSkinFMXPanel;
  GlobalAutoProcessVirtualKeyboardControl := pnlVirtualKeyBoard;
  GlobalAutoProcessVirtualKeyboardControl.Visible := False;

{$IFNDEF MSWINDOWS}
  pnlVirtualKeyBoard.SelfOwnMaterialToDefault.IsTransparent := True;
  pnlVirtualKeyBoard.Caption := '';
{$ENDIF}
  // 修复Android下的虚拟键盘隐藏和显示
  GetGlobalVirtualKeyboardFixer.StartSync(Self);
  // ===========================以下是服务端初始化==============================
  // RemoteSrvOBJ := TRemoteServerDIOCPImpl.Create;
  // RemoteSrv := RemoteSrvOBJ;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // FreeAndNil(FGPSLocation);
end;

procedure TfrmMain.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  FMX.Types.Log.d('OrangeUI TfrmMain.FormGesture');

  // if CurrentFrame=GlobalClipHeadFrame then
  // begin
  // GlobalClipHeadFrame.DoGesture(Sender,EventInfo,Handled);
  // end;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (Key = vkHardwareBack)
  // Windows下Escape键模拟返回键
    or (Key = vkEscape) then
  begin
    // 返回
    if (CurrentFrameHistroy.ToFrame <> nil)
    // 如果当前是登陆页面,不返回上一页
      and (CurrentFrameHistroy.ToFrame <> GlobalLoginFrame)
    // 如果当前是主页面,不返回上一页
      and (CurrentFrameHistroy.ToFrame <> GlobalMainFrame) then
    begin
      if CanReturnFrame(CurrentFrameHistroy) then
      begin
        HideFrame(CurrentFrameHistroy.ToFrame, hfcttBeforeReturnFrame);
        ReturnFrame(CurrentFrameHistroy);

        Key := 0;
        KeyChar := #0;
      end
      else
      begin
        // 表示当前Frame不允许返回
      end;
    end
    else
    begin
{$IFDEF ANDROID}
      // 程序退到后台挂起,需要引用Androidapi.Helpers单元
      FMX.Types.Log.d('OrangeUI moveTaskToBack');
      SharedActivity.moveTaskToBack(False);

      // 表示不关闭APP
      Key := 0;
      KeyChar := #0;
{$ENDIF}
    end;
  end;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  SkinThemeColor := $FF438DF5;

  // 加载上次登录的用户名和密码
  // GlobalManager.Load;
  //
  // 可以在此设置DIOCP端口访问服务
  try
    // RemoteSrvOBJ.setHost(Host);
    // RemoteSrvOBJ.setPort(StrToInt(Port));
    // RemoteSrvOBJ.open;
  except
    on E: Exception do
      // ShowMessage('服务器连接失败！Host:'+Host+' Port:'+Port);
      ShowMessage('服务器连接失败！');
  end;
  ShowFrame(TFrame(GlobalLoginFrame), TFrameLogin, frmMain, nil, nil, nil,
    Application, True, True, ufsefNone);
  GlobalLoginFrame.FrameHistroy := CurrentFrameHistroy;
  // 启动定位
  // FGPSLocation := TGPSLocation.Create;
  // FGPSLocation.GPSType := gtGCJ02;
  // FGPSLocation.StartLocation;

end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  CallSubFrameVirtualKeyboardHidden(Sender, Self, KeyboardVisible, Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  CallSubFrameVirtualKeyboardShown(Sender, Self, KeyboardVisible, Bounds);
end;

procedure TfrmMain.Login;
begin
  // 显示首页
  // GlobalMainFrame.pcMain.Prop.ActivePage := GlobalMainFrame.tsSpirit;
  // GlobalMainFrame.pcMainChange(GlobalMainFrame.pcMain);

end;

procedure TfrmMain.Logout;
begin

end;

end.
