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
  NotifyObjectBase,
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
    /// <summary>
    /// 查询登陆用户个人信息
    /// </summary>
    /// <param name="Sender">客户端状态信息</param>
    /// <param name="InData">客户端发来的信息</param>
    /// <param name="OutData">反馈给客户端的信息</param>
    procedure cmd_QueryLoginUserInfo(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
  private
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

var
  MySrv: TMyServer;

procedure RunServer;
var
  RecvTunnel, SendTunnel: TCommunicationFrameworkServer;
  // MyServer: TMyServer;
begin
  DoStatus(TOSVersion.ToString);
  // 初始化数据库服务
  MyDM := TServerDM.Create;
  // 接收、发送通道初始化
  RecvTunnel := TCommunicationFramework_Server_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Server_CrossSocket.Create;

  // 通讯框架绑定端口
  MySrv := TMyServer.Create(RecvTunnel, SendTunnel);

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
  MySrv.UnRegisterCommand;
  // 监听器注册
  MySrv.RegisterCommand;

  try
    // 重要：服务线程刷新
    while True do
    begin
      MySrv.Progress;
      if MySrv.RecvTunnel.Count > 0 then
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
  // InData.
end;

procedure TMyServer.cmd_QueryLoginUserInfo(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
var
  tempStm: TMemoryStream64;
begin
  try
    tempStm := TMemoryStream64.Create;
    //查询数据
    tempStm := MyQuery('SELECT User_Auth.Login_Name, User_OP.OP_WaterInfo_Look, User_OP.OP_WaterInfo_Edit ' + 'FROM User_Auth ' + 'INNER JOIN User_OP ON User_OP.OP_ID = User_Auth.ID ' + 'WHERE User_Auth.Login_ID = ' + '''' + InData.Reader.ReadString + '''');
    tempStm.Position := 0;
    //效验发送数据完整性
    //DoStatus('未压缩 CRC32:' + TCipher.GenerateHashString(THashSecurity.hsCRC32, tempStm.Memory, tempStm.Size));
    //发送数据
    OutData.WriteStream(tempStm);
    tempStm.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end;

procedure TMyServer.cmd_Stream(Sender: TPeerClient; InData: TDataFrameEngine);
begin
  DoStatus(InData.Reader.ReadString);
end;

procedure TMyServer.cmd_Stream_Result(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
begin

end;

procedure OtherServerReponse(Sender: TNPostExecute);
var
  AuthIO: TVirtualAuthIO;
begin
  AuthIO := TVirtualAuthIO(Sender.Data1);

  // 在访问其他服务器的过程中，我们等待验证的用户可能已经断线，因此我们需要判断一下
  if not AuthIO.Online then
  begin
    AuthIO.Bye; // TVirtualAuthIO中的bye等同于Free，如果我们不Bye，会造成内存泄漏
    exit;
  end;
  //登陆验证过程
  if AuthQuery(AuthIO.UserID, AuthIO.Passwd) then
  begin
    AuthIO.Accept;
    DoStatus(AuthIO.UserID + '登录成功');
  end
  else
  begin
    AuthIO.Reject;
    DoStatus(AuthIO.UserID + '登录失败');
  end;
end;

procedure TMyServer.RegisterCommand;
begin
  inherited RegisterCommand;
  RecvTunnel.RegisterDirectConsole('cmd_Console').OnExecute := cmd_Console;
  RecvTunnel.RegisterDirectStream('cmd_Stream').OnExecute := cmd_Stream;
  RecvTunnel.RegisterStream('cmd_Stream_Result').OnExecute := cmd_Stream_Result;
  RecvTunnel.RegisterStream('cmd_QueryLoginUserInfo').OnExecute := cmd_QueryLoginUserInfo;
end;

procedure TMyServer.UnRegisterCommand;
begin
  inherited UnRegisterCommand;
  RecvTunnel.UnRegisted('cmd_Console');
  RecvTunnel.UnRegisted('cmd_Stream');
  RecvTunnel.UnRegisted('cmd_Stream_Result');
  RecvTunnel.UnRegisted('cmd_QueryLoginUserInfo');
end;

procedure TMyServer.UserAuth(Sender: TVirtualAuthIO);
begin
  inherited UserAuth(Sender);
  // 工作模式是延迟认证，在第二种模式中，我们什么都不用做，保存TVirtualAuthIO的实例，待认远程证完成，我们再反馈给客户端
  with ProgressEngine.PostExecuteC(3.0, OtherServerReponse) do
    Data1 := Sender;

end;

procedure TMyServer.UserLinkSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth);
begin
  inherited UserLinkSuccess(UserDefineIO);

end;

procedure TMyServer.UserLoginSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth);
var
  SQL: string;
begin
  inherited UserLoginSuccess(UserDefineIO);
  // 更新登陆时间
  SQL := 'UPDATE User_Auth SET User_Auth.Login_Count = User_Auth.Login_Count + 1 , User_Auth.Login_Time = NOW() WHERE User_Auth.Login_ID = ''' + UserDefineIO.UserID + '''';
  MyExec(SQL);
  //显示数据查询语句
  //DoStatus(SQL);
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

