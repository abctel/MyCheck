unit Main_Form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  // --------OrangUI-----------
  uFuncCommon, uUIFunction,
  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework, CoreClasses, Cadencer,
  CommunicationFramework_Client_CrossSocket, CommunicationFramework_Client_ICS,
  CommunicationFramework_Client_Indy,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth,
  // --------其它单元---------
  Login_Frame, DB_Module;

type
  TFrmMain = class(TForm)
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RecvTunnel: TCommunicationFramework_Client_CrossSocket;
    SendTunnel: TCommunicationFramework_Client_CrossSocket;
    Client: TCommunicationFramework_DoubleTunnelClient_VirtualAuth;
    procedure DoStatusNear(AText: string; const ID: Integer);
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.DoStatusNear(AText: string; const ID: Integer);
begin
  GlobalLoginFrame.Memo1.Lines.Add(AText);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalLoginFrame), TFrameLogin, FrmMain, nil, nil, nil, Application, True, True, ufsefNone);
  GlobalLoginFrame.FrameHistroy := CurrentFrameHistroy;
  //DBM := TDBM.Create(nil);
  AddDoStatusHook(Self, DoStatusNear);

  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;

  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create(RecvTunnel, SendTunnel);

  Client.RegisterCommand;

    SendTunnel.Connect('127.0.0.1', 9815);
  RecvTunnel.Connect('127.0.0.1', 9816);

  while (not Client.RemoteInited) and (Client.Connected) do
  begin
    TThread.Sleep(10);
    Client.Progress;
  end;

  if Client.Connected then
  begin
    if Client.UserLogin('test','test') then
    begin
      DoStatus('成功');
      end else
      begin
      DoStatus('失败');
    end;
  end;

//
//  client.AsyncConnectP('127.0.0.1', 9816, 9815,
//    procedure(const cState: Boolean)
//    begin
//      if cState then
//      begin
//          // 嵌套式匿名函数支持
//        client.UserLoginP('test', 'test',
//          procedure(const lState: Boolean)
//          begin
//            if lState then
//            begin
//              client.TunnelLinkP(
//                procedure(const tState: Boolean)
//                begin
//                  if tState then
//                    DoStatus('double tunnel link success!')
//                  else
//                    DoStatus('double tunnel link failed!');
//                end)
//            end
//            else
//            begin
//              if lState then
//                DoStatus('login success!')
//              else
//                DoStatus('login failed!');
//            end;
//          end);
//      end
//      else
//      begin
//        if cState then
//          DoStatus('connected success!')
//        else
//          DoStatus('connected failed!');
//      end;
//    end);
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
Client.Progress;
end;

end.

