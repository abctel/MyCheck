unit VACliFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  CommunicationFramework, DoStatusIO, CoreClasses, DataFrameEngine,
  FireDAC.Stan.Intf,
  CoreCipher, CommunicationFramework_Client_CrossSocket,
  CommunicationFrameworkDoubleTunnelIO, Cadencer, MemoryStream64,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth, Data.DB, Vcl.Grids,
  Vcl.DBGrids,
  Datasnap.DBClient, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageBin, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.DApt;

type
  TAuthDoubleTunnelClientForm = class(TForm)
    Memo1: TMemo;
    ConnectButton: TButton;
    HostEdit: TLabeledEdit;
    Timer1: TTimer;
    UserEdit: TLabeledEdit;
    PasswdEdit: TLabeledEdit;
    AsyncConnectButton: TButton;
    TimeLabel: TLabel;
    fixedTimeButton: TButton;
    Edit1: TEdit;
    Button1: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDMemTable1: TFDMemTable;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    Edit2: TEdit;
    Button2: TButton;
    Edit3: TEdit;
    Button3: TButton;
    Edit4: TEdit;
    con1: TFDConnection;
    fdqry1: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure ConnectButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AsyncConnectButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure fixedTimeButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoStatusNear(AText: string; const ID: Integer);
    procedure cmd_ChangeCaption(Sender: TPeerClient; InData: TDataFrameEngine);
    procedure cmd_GetClientValue(Sender: TPeerClient;
      InData, OutData: TDataFrameEngine);
    procedure cmd_Stream_Over(Sender: TPeerClient; InData: TDataFrameEngine);
  public
    { Public declarations }
    RecvTunnel: TCommunicationFramework_Client_CrossSocket;
    SendTunnel: TCommunicationFramework_Client_CrossSocket;
    Client: TCommunicationFramework_DoubleTunnelClient_VirtualAuth;
    ask: TCommunicationFramework_DoubleTunnelClient;
  end;

var
  AuthDoubleTunnelClientForm: TAuthDoubleTunnelClientForm;

implementation

{$R *.dfm}

procedure TAuthDoubleTunnelClientForm.DoStatusNear(AText: string;
  const ID: Integer);
begin
  Memo1.Lines.Add(AText);
end;

procedure TAuthDoubleTunnelClientForm.fixedTimeButtonClick(Sender: TObject);
begin
  // 高速同步，不经过Progress触发
  // 这样干是将时间的延迟率降低到最小
  Client.SendTunnel.SyncOnResult := True;
  Client.SyncCadencer;
  Client.SendTunnel.WaitP(1000,
    procedure(const cState: Boolean)
    begin
      // 因为打开了SyncOnResult后，匿名函数会出现嵌套死锁
      // 我们现在关闭它，以保证匿名函数的嵌套执行
      Client.SendTunnel.SyncOnResult := False;
    end);
end;

procedure TAuthDoubleTunnelClientForm.FormCreate(Sender: TObject);
begin
  AddDoStatusHook(self, DoStatusNear);

  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create
    (RecvTunnel, SendTunnel);

  Client.RegisterCommand;

  // 注册可以由服务器发起的通讯指令
  Client.RecvTunnel.RegisterDirectStream('ChangeCaption').OnExecute :=
    cmd_ChangeCaption;
  Client.RecvTunnel.RegisterStream('GetClientValue').OnExecute :=
    cmd_GetClientValue;
  Client.RecvTunnel.RegisterDirectStream('cmd_Stream_Over').OnExecute :=
    cmd_Stream_Over;
end;

procedure TAuthDoubleTunnelClientForm.FormDestroy(Sender: TObject);
begin
  DisposeObject(Client);
  DeleteDoStatusHook(self);
end;

procedure TAuthDoubleTunnelClientForm.Timer1Timer(Sender: TObject);
begin
  Client.Progress;
  TimeLabel.Caption := Format('sync time:%f',
    [Client.CadencerEngine.UpdateCurrentTime]);
end;

procedure TAuthDoubleTunnelClientForm.cmd_ChangeCaption(Sender: TPeerClient;
InData: TDataFrameEngine);
begin
  Caption := InData.Reader.ReadString;
end;

procedure TAuthDoubleTunnelClientForm.cmd_GetClientValue(Sender: TPeerClient;
InData, OutData: TDataFrameEngine);
begin
  OutData.WriteString('getclientvalue:abc');
end;

procedure TAuthDoubleTunnelClientForm.cmd_Stream_Over(Sender: TPeerClient;
InData: TDataFrameEngine);
var
  i: Integer;
  Stm: TMemoryStream64;
begin
  Stm := TMemoryStream64.Create;
  DoStatus('收到服务器反馈的内容' + Sender.UserDefine.BigStreamBatchList.Count.ToString);
  for i := 0 to Sender.UserDefine.BigStreamBatchList.Count - 1 do
  begin
    Stm := Sender.UserDefine.BigStreamBatchList[i]^.Source;
    DoStatus(Stm.ReadString);
  end;
end;

procedure TAuthDoubleTunnelClientForm.ConnectButtonClick(Sender: TObject);
begin
  SendTunnel.Connect(HostEdit.Text, 9815);
  RecvTunnel.Connect(HostEdit.Text, 9816);

  // 检查双通道是否都已经成功链接，确保完成了对称加密等等初始化工作
  while (not Client.RemoteInited) and (Client.Connected) do
  begin
    TThread.Sleep(10);
    Client.Progress;
  end;

  if Client.Connected then
  begin
    // 嵌套式匿名函数支持
    Client.UserLoginP(UserEdit.Text, PasswdEdit.Text,
      procedure(const State: Boolean)
      begin
        if State then
          Client.TunnelLinkP(
            procedure(const State: Boolean)
            begin
              DoStatus('double tunnel link success!');
            end)
      end);
  end;
end;

procedure TAuthDoubleTunnelClientForm.AsyncConnectButtonClick(Sender: TObject);
begin
  // 方法2，异步式双通道链接
  Client.AsyncConnectP(HostEdit.Text, 9816, 9815,
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // 嵌套式匿名函数支持
        Client.UserLoginP(UserEdit.Text, PasswdEdit.Text,
          procedure(const lState: Boolean)
          begin
            if lState then
            begin
              Client.TunnelLinkP(
                procedure(const tState: Boolean)
                begin
                  if tState then
                    DoStatus('double tunnel link success!')
                  else
                    DoStatus('double tunnel link failed!');
                end)
            end
            else
            begin
              if lState then
                DoStatus('login success!')
              else
                DoStatus('login failed!');
            end;
          end);
      end
      else
      begin
        if cState then
          DoStatus('connected success!')
        else
          DoStatus('connected failed!');
      end;
    end);

end;

procedure TAuthDoubleTunnelClientForm.Button1Click(Sender: TObject);
var
  SendDe, ResultDE: TDataFrameEngine;
  Stm: TMemoryStream64;
begin
  SendDe := TDataFrameEngine.Create;
  ResultDE := TDataFrameEngine.Create;
  Stm := TMemoryStream64.Create;
  SendDe.WriteString(Edit1.Text);
  Client.SendTunnel.WaitSendStreamCmd('cmd_Stream_Result', SendDe,
    ResultDE, 5000);
  ResultDE.Reader.ReadStream(Stm);
  Stm.Position := 0;
  DoStatus('未解压 CRC32:' + TCipher.GenerateHashString(THashSecurity.hsCRC32,
    Stm.Memory, Stm.Size));
  FDMemTable1.LoadFromStream(Stm, TFDStorageFormat.sfBinary);
  DisposeObject([SendDe, ResultDE, Stm]);
end;

procedure TAuthDoubleTunnelClientForm.Button2Click(Sender: TObject);
begin
  Client.SendTunnel.SendDirectConsoleCmd('cmd_Console', Edit2.Text);
end;

procedure TAuthDoubleTunnelClientForm.Button3Click(Sender: TObject);
var
  i: Integer;
  Stm: TMemoryStream64;
begin
  try
    Client.ClearBatchStream;
    for i := 1 to StrToInt(Edit4.Text) do
    begin
      Stm := TMemoryStream64.Create;
      Stm.Position := 0;
      Stm.WriteString(Edit3.Text + ':' + i.ToString);
      Client.PostBatchStream(Stm, True);
    end;
    Client.SendTunnel.SendDirectStreamCmd('cmd_Stream');
    Client.ClearBatchStream;
  except
    on E: Exception do
      DoStatus(E.ClassName + ': ' + E.Message);

  end;
end;

end.
