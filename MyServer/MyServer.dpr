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
    /// �û���½��֤����
    /// </summary>
    /// <param name="Sender">������֤�ӿ�</param>
    procedure UserAuth(Sender: TVirtualAuthIO); override;
    /// <summary>
    /// �û���¼�ɹ�״̬
    /// </summary>
    /// <param name="UserDefineIO">ͨ����IO��õ�¼�ɹ��û�����Ϣ</param>
    procedure UserLoginSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth); override;
    /// <summary>
    /// �û�ͨ�����ӳɹ�״̬
    /// </summary>
    /// <param name="UserDefineIO">ͨ����IO������ӳɹ��û�����Ϣ</param>
    procedure UserLinkSuccess(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth); override;
    /// <summary>
    /// �û��Ͽ����Ӻ�״̬
    /// </summary>
    /// <param name="UserDefineIO">ͨ����IO��öϿ��ɹ��û�����Ϣ</param>
    procedure UserOut(UserDefineIO: TPeerClientUserDefineForRecvTunnel_VirtualAuth); override;
  private
    procedure cmd_Console(Sender: TPeerClient; InData: SystemString);
    /// <summary>
    /// ����һ�����������ݵ�StreamͨѶ��
    /// </summary>
    /// <param name="Sender">�ͻ���״̬��Ϣ</param>
    /// <param name="InData">�ͻ��˷�������Ϣ</param>
    procedure cmd_Stream(Sender: TPeerClient; InData: TDataFrameEngine);
    /// <summary>
    /// ����һ���������ݵ�StreamͨѶ��
    /// </summary>
    /// <param name="Sender">�ͻ���״̬��Ϣ</param>
    /// <param name="InData">�ͻ��˷�������Ϣ</param>
    /// <param name="OutData">�������ͻ��˵���Ϣ</param>
    procedure cmd_Stream_Result(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
    /// <summary>
    /// ��ѯ��½�û�������Ϣ
    /// </summary>
    /// <param name="Sender">�ͻ���״̬��Ϣ</param>
    /// <param name="InData">�ͻ��˷�������Ϣ</param>
    /// <param name="OutData">�������ͻ��˵���Ϣ</param>
    procedure cmd_QueryLoginUserInfo(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
  private
  public
    /// <summary>
    /// ע��ͨѶ��
    /// </summary>
    procedure RegisterCommand; override;
    /// <summary>
    /// ж��ע���ͨѶ��
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
  // ��ʼ�����ݿ����
  MyDM := TServerDM.Create;
  // ���ա�����ͨ����ʼ��
  RecvTunnel := TCommunicationFramework_Server_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Server_CrossSocket.Create;

  // ͨѶ��ܰ󶨶˿�
  MySrv := TMyServer.Create(RecvTunnel, SendTunnel);

  // ���ա�����ͨ���˿ڰ󶨲�ȷ�ϼ�����ַ����ģʽ
  if RecvTunnel.StartService(HostIP, RecvPort) then
    DoStatus('���� RecvTunnel ��ַ %s �Ķ˿ڣ�' + RecvPort.ToString + ' �ɹ�', [TranslateBindAddr(HostIP)])
  else
    DoStatus('���� RecvTunnel ��ַ %s �Ķ˿ڣ�' + RecvPort.ToString + ' ʧ��', [TranslateBindAddr(HostIP)]);

  if SendTunnel.StartService(HostIP, SendPort) then
    DoStatus('���� SendTunnel ��ַ %s �Ķ˿ڣ�' + SendPort.ToString + ' �ɹ�', [TranslateBindAddr(HostIP)])
  else
    DoStatus('���� SendTunnel ��ַ %s �Ķ˿ڣ�' + SendPort.ToString + ' ʧ��', [TranslateBindAddr(HostIP)]);

  // ȡ��������ע��
  MySrv.UnRegisterCommand;
  // ������ע��
  MySrv.RegisterCommand;

  try
    // ��Ҫ�������߳�ˢ��
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
    //��ѯ����
    tempStm := MyQuery('SELECT User_Auth.Login_Name, User_OP.OP_WaterInfo_Look, User_OP.OP_WaterInfo_Edit ' + 'FROM User_Auth ' + 'INNER JOIN User_OP ON User_OP.OP_ID = User_Auth.ID ' + 'WHERE User_Auth.Login_ID = ' + '''' + InData.Reader.ReadString + '''');
    tempStm.Position := 0;
    //Ч�鷢������������
    //DoStatus('δѹ�� CRC32:' + TCipher.GenerateHashString(THashSecurity.hsCRC32, tempStm.Memory, tempStm.Size));
    //��������
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

  // �ڷ��������������Ĺ����У����ǵȴ���֤���û������Ѿ����ߣ����������Ҫ�ж�һ��
  if not AuthIO.Online then
  begin
    AuthIO.Bye; // TVirtualAuthIO�е�bye��ͬ��Free��������ǲ�Bye��������ڴ�й©
    exit;
  end;
  //��½��֤����
  if AuthQuery(AuthIO.UserID, AuthIO.Passwd) then
  begin
    AuthIO.Accept;
    DoStatus(AuthIO.UserID + '��¼�ɹ�');
  end
  else
  begin
    AuthIO.Reject;
    DoStatus(AuthIO.UserID + '��¼ʧ��');
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
  // ����ģʽ���ӳ���֤���ڵڶ���ģʽ�У�����ʲô��������������TVirtualAuthIO��ʵ��������Զ��֤��ɣ������ٷ������ͻ���
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
  // ���µ�½ʱ��
  SQL := 'UPDATE User_Auth SET User_Auth.Login_Count = User_Auth.Login_Count + 1 , User_Auth.Login_Time = NOW() WHERE User_Auth.Login_ID = ''' + UserDefineIO.UserID + '''';
  MyExec(SQL);
  //��ʾ���ݲ�ѯ���
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

