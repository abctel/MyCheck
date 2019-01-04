unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  // --------其它单元---------
  MemoryStream64, CoreCipher,
  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework, CoreClasses, Cadencer,
  CommunicationFramework_Client_CrossSocket, CommunicationFramework_Client_ICS,
  CommunicationFramework_Client_Indy,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    FDMemTable1: TFDMemTable;
    Button2: TButton;
    Timer1: TTimer;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
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
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.DoStatusNear(AText: string; const ID: Integer);
begin
  Memo1.Lines.Add(AText);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;

  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create(RecvTunnel, SendTunnel);
  AddDoStatusHook(Self, DoStatusNear);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  tempDFE: TDataFrameEngine;
begin

  Client.AsyncConnectP('127.0.0.1', 9816, 9815,
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // 异步登录操作
        Client.UserLoginP('abctel', '5333564',
          procedure(const cState: Boolean)
          begin
            if cState then
            begin
              // 异步检查双通道是否创建成功
              Client.TunnelLinkP(
                procedure(const sState: Boolean)
                begin
                  if sState then
                  begin
                  //获取用户资料
                    tempDFE := TDataFrameEngine.Create;

                    tempDFE.WriteString('abctel');
                    Client.SendTunnel.SendStreamCmdP('cmd_QueryLoginUserInfo', tempDFE,
                      procedure(Sender: TPeerIO; ResultData: TDataFrameEngine)
                      var
                        tempSTM: TMemoryStream64;
                      begin
                        tempSTM := TMemoryStream64.Create;

                        try
                          ResultData.Reader.ReadStream(tempSTM);
                          tempSTM.Position := 0;
                       // DoStatus(tempSTM.ReadString.Text);
                          FDMemTable1.LoadFromStream(tempSTM, TFDStorageFormat.sfJSON);
                          DoStatus(FDMemTable1.FieldByName('Login_Name').AsString);
                          DoStatus('CRC32:' + TCipher.GenerateHashString(THashSecurity.hsCRC32, tempSTM.Memory, tempSTM.Size));
                          tempSTM.Free;
                        except
                          on E: Exception do
                            DoStatus(E.ClassName + ': ' + E.Message);
                        end;

                      end);

//                  //隐藏等待状态
                        //HideWaitingFrame;
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
                   // HideWaitingFrame;
                    //ShowMessageBoxFrame(FrmMain, '登录失败', '网络错误，请检查网络后重新再试！', TMsgDlgType.mtError, ['确定'], nil);
                    Exit;
                  end;
                end);
            end
            else
            begin
              //隐藏等待状态
              //HideWaitingFrame;
             // ShowMessageBoxFrame(FrmMain, '登录失败', '账号或密码错误，请重新再试！', TMsgDlgType.mtError, ['确定'], nil);
              Exit;
            end;
          end);
      end
      else
      begin
      //隐藏等待状态
        //HideWaitingFrame;
        //ShowMessageBoxFrame(GlobalLoginFrame, '登录失败', '网络错误，请检查网络后重新再试！', TMsgDlgType.mtError, ['确定'], nil);
        Exit;
      end;

    end);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Client.Connect('127.0.0.1',9816,9815);
Client.UserLogin('abctel','5333564');
//Client.TunnelLink
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Client.Progress;
end;

end.

