unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  // --------OrangUI��ѡ-----------
  uFuncCommon, uUIFunction, MessageBoxFrame, WaitingFrame,
  // --------������Ԫ---------
  MemoryStream64, CoreCipher,
  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework, CoreClasses, Cadencer,
  CommunicationFramework_Client_CrossSocket, CommunicationFramework_Client_ICS,
  CommunicationFramework_Client_Indy,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    FDMemTable1: TFDMemTable;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    RecvTunnel: TCommunicationFramework_Client_CrossSocket;
    SendTunnel: TCommunicationFramework_Client_CrossSocket;
  public
    { Public declarations }
    Client: TCommunicationFramework_DoubleTunnelClient_VirtualAuth;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  tempDFE: TDataFrameEngine;
begin
  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;

  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create(RecvTunnel, SendTunnel);
  Client.AsyncConnectP('127.0.0.1', '9816', '9815',
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // �첽��¼����
        Client.UserLoginP('abctel', '123',
          procedure(const cState: Boolean)
          begin
            if cState then
            begin
              // �첽���˫ͨ���Ƿ񴴽��ɹ�
              Client.TunnelLinkP(
                procedure(const sState: Boolean)
                begin
                  if sState then
                  begin
                   DoStatus('��¼�ɹ�');
                  end;
                end);
            end;
          end);
      end;
    end);






























//  Client1.AsyncConnectP('127.0.0.1', '9816', '9815',
//    procedure(const cState: Boolean)
//    begin
//      if cState then
//      begin
//        // �첽��¼����
//        Client1.UserLoginP('abctel', '5333564',
//          procedure(const cState: Boolean)
//          begin
//            if cState then
//            begin
//              // �첽���˫ͨ���Ƿ񴴽��ɹ�
//                procedure(const sState: Boolean)
//                begin
//                  if sState then
//                  begin
//                    // ��ȡ�û�����
//                    tempDFE1 := TDataFrameEngine.Create;
//
//                    tempDFE1.WriteString('abctel');
//                    Client1.SendTunnel.SendStreamCmdP
//                      ('cmd_QueryLoginUserInfo', tempDFE1,
//                      procedure(Sender: TPeerIO; ResultData: TDataFrameEngine)
//                      var
//                        tempSTM: TMemoryStream64;
//                      begin
//                        tempSTM := TMemoryStream64.Create;
//                          ResultData.Reader.ReadStream(tempSTM);
//                          tempSTM.Position := 0;
//                          // DoStatus(tempSTM.ReadString.Text);
//                          FDMemTable1.LoadFromStream(tempSTM,
//                            TFDStorageFormat.sfJSON);
//                          DoStatus(FDMemTable1.FieldByName('Login_Name')
//                            .AsString);
//                          DoStatus('CRC32:' + TCipher.GenerateHashString
//                            (THashSecurity.hsCRC32, tempSTM.Memory,
//                            tempSTM.Size));
//                          tempSTM.Free;
//
//
//                      end);
//
//                    // //���صȴ�״̬
//                    HideWaitingFrame;
//                    // //ShowMessageBoxFrame(FrmMain, '��¼�ɹ�', '', TMsgDlgType.mtInformation, ['ȷ��'], nil);
//                    // //�ͷ�ԭ������
//                    // uFuncCommon.FreeAndNil(GlobalMainFrame);
//                    //
//                    // //����������
//                    // HideFrame(Self, hfcttBeforeReturnFrame);
//                    // ShowFrame(TFrame(GlobalMainFrame), TFrameMain, FrmMain, nil, nil, nil, Application, True, True, ufsefDefault);
//                    // GlobalMainFrame.FrameHistroy := CurrentFrameHistroy;
//                  end;
//                end);
//            end;
//          end);
//      end;
//
//    end);
end;

end.

