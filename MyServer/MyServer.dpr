program MyServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  DoStatusIO,
  CoreClasses,
  PascalStrings,
  MemoryStream64,
  DataFrameEngine,
  CoreCipher,
  Utils.Utils,
  CommunicationFramework,
  CommunicationFramework_Server_CrossSocket,
  CommunicationFrameworkDoubleTunnelIO,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth,
  ServerDefine in 'ServerDefine.pas',
  ServerDM in 'ServerDM.pas';

type
  TMyServer = class(TCommunicationFramework_DoubleTunnelService_VirtualAuth)
  protected
    /// <summary>
    /// 用户登陆验证过程
    /// </summary>
    /// <param name="Sender">虚拟验证接口</param>
    procedure UserAuth(Sender: TVirtualAuthIO); override;
    /// <summary>
    /// 用户登录成功状态
    /// </summary>
    /// <param name="UserDefineIO">通过该IO获得登录成功用户的信息</param>
    procedure UserLoginSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth); override;
    /// <summary>
    /// 用户通道链接成功状态
    /// </summary>
    /// <param name="UserDefineIO">通过该IO获得链接成功用户的信息</param>
    procedure UserLinkSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth); override;
    /// <summary>
    /// 用户断开链接后状态
    /// </summary>
    /// <param name="UserDefineIO">通过该IO获得断开成功用户的信息</param>
    procedure UserOut(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth); override;
  private
    procedure cmd_Console(Sender: TPeerClient; InData: SystemString);
    /// <summary>
    /// 这是一个不返回数据的Stream通讯器
    /// </summary>
    /// <param name="Sender">客户端状态信息</param>
    /// <param name="InData">客户端发来的信息</param>
    procedure cmd_Stream(Sender: TPeerClient; InData: TDataFrameEngine);
    /// <summary>
    /// 这是一个返回数据的Stream通讯器
    /// </summary>
    /// <param name="Sender">客户端状态信息</param>
    /// <param name="InData">客户端发来的信息</param>
    /// <param name="OutData">反馈给客户端的信息</param>
    procedure cmd_Stream_Result(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
  public
    /// <summary>
    /// 注册通讯器
    /// </summary>
    procedure RegisterCommand; override;
    /// <summary>
    /// 卸载注册的通讯器
    /// </summary>
    procedure UnRegisterCommand; override;
  end;

procedure RunServer;
var
  RecvTunnel, SendTunnel: TCommunicationFrameworkServer;
  MyServer: TMyServer;
begin
  DoStatus(TOSVersion.ToString);
  // 初始化数据库服务
  MyDM := TServerDM.Create;
  // 接收、发送通道初始化
  RecvTunnel := TCommunicationFramework_Server_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Server_CrossSocket.Create;

  // 通讯框架绑定端口
  MyServer := TMyServer.Create(RecvTunnel, SendTunnel);

  // 接收、发送通道端口绑定并确认监听地址工作模式
  if RecvTunnel.StartService(HostIP, RecvPort) then
    DoStatus('监听 RecvTunnel 地址 %s 的端口：' + RecvPort.ToString + ' 成功', [TranslateBindAddr(HostIP)])
  else
    DoStatus('监听 RecvTunnel 地址 %s 的端口：' + RecvPort.ToString + ' 失败', [TranslateBindAddr(HostIP)]);

  if SendTunnel.StartService(HostIP, SendPort) then
    DoStatus('监听 SendTunnel 地址 %s 的端口：' + SendPort.ToString + ' 成功', [TranslateBindAddr(HostIP)])
  else
    DoStatus('监听 SendTunnel 地址 %s 的端口：' + SendPort.ToString + ' 失败', [TranslateBindAddr(HostIP)]);

  // 取消监听器注册
  MyServer.UnRegisterCommand;
  // 监听器注册
  MyServer.RegisterCommand;

  try
    // 重要：服务线程刷新
    while True do
    begin
      MyServer.Progress;
      if MyServer.RecvTunnel.Count > 0 then
        CoreClasses.CheckThreadSynchronize
      else
        CoreClasses.CheckThreadSynchronize(10);
    end;
    MyDM.Destroy;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end;

{ TMyServer }

procedure TMyServer.cmd_Console(Sender: TPeerClient; InData: SystemString);
begin
  DoStatus(InData);
end;

procedure TMyServer.cmd_Stream(Sender: TPeerClient; InData: TDataFrameEngine);
begin
  DoStatus(InData.Reader.ReadString);

end;

procedure TMyServer.cmd_Stream_Result(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
begin

end;

procedure TMyServer.RegisterCommand;
begin
  inherited RegisterCommand;
  RecvTunnel.RegisterDirectConsole('cmd_Console').OnExecute := cmd_Console;
  RecvTunnel.RegisterDirectStream('cmd_Stream').OnExecute := cmd_Stream;
  RecvTunnel.RegisterStream('cmd_Stream_Result').OnExecute := cmd_Stream_Result;
end;

procedure TMyServer.UnRegisterCommand;
begin
  inherited UnRegisterCommand;
  RecvTunnel.UnRegisted('cmd_Console');
  RecvTunnel.UnRegisted('cmd_Stream');
  RecvTunnel.UnRegisted('cmd_Stream_Result');
end;

procedure TMyServer.UserAuth(Sender: TVirtualAuthIO);
begin
  inherited UserAuth(Sender);
//  if AuthQuery(Sender.UserID, Sender.Passwd) then
//  begin
//    Sender.Accept;
//    DoStatus(Sender.UserID + '登录成功');
//  end
//  else
//  begin
//    Sender.Reject;
//    DoStatus(Sender.UserID + '登录失败');
//  end;
     Sender.Accept;
end;

procedure TMyServer.UserLinkSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth);
begin
  inherited UserLinkSuccess(UserDefineIO);

end;

procedure TMyServer.UserLoginSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth);
var
SQL:string;
begin
  inherited UserLoginSuccess(UserDefineIO);
  SQL:='UPDATE auth_user SET Login_Count = Login_Count + 1 , Login_Time = NOW() WHERE Login_Name = '''+UserDefineIO.UserID+'''';
  MyExec(SQL);
  DoStatus(SQL);
end;

procedure TMyServer.UserOut(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth);

begin
  inherited UserOut(UserDefineIO);

end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    RunServer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

