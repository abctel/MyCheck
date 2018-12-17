unit DM_Form;

interface

uses
  System.UITypes, System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.FMXUI.Wait,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  MessageBoxFrame, DoStatusIO, DataFrameEngine,
  CommunicationFramework, CommunicationFramework_Client_CrossSocket,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth, FMX.Types,
  FireDAC.VCLUI.Wait;

type
  TDM = class(TDataModule)
    cdsMain: TClientDataSet;
    dsMain: TDataSource;
    Timer1: TTimer;
    procedure DataModuleDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    RecvTunnel: TCommunicationFramework_Client_CrossSocket;
    SendTunnel: TCommunicationFramework_Client_CrossSocket;
    procedure DoStatusNear(AText: string; const ID: Integer);
  public
    { Public declarations }
    Client: TCommunicationFramework_DoubleTunnelClient_VirtualAuth;
  end;

var
  DM: TDM;

implementation

uses
  Main_Form;
{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}
{ MyClient }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  AddDoStatusHook(Self, DoStatusNear);

  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;

  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create
    (RecvTunnel, SendTunnel);

  RecvTunnel.Connect('127.0.0.1', 9816);
  SendTunnel.Connect('127.0.0.1', 9815);

  if Client.Connected then
  begin
    if Client.UserLogin('abctel', '5333564') then
    begin
      DoStatus('登录成功');
    end
    else
    begin
      DoStatus('登录失败');
    end;
  end;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  DeleteDoStatusHook(Self);
  Client.Free;
end;

procedure TDM.DoStatusNear(AText: string; const ID: Integer);
begin
  ShowMessageBoxFrame(frmMain, AText, '', TMsgDlgType.mtInformation,
    ['确定'], nil);
end;

procedure TDM.Timer1Timer(Sender: TObject);
begin
  Client.Progress;
end;

end.
