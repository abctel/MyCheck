unit Login_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  // --------OrangUI��ѡ-----------
  uFuncCommon, uUIFunction, MessageBoxFrame, WaitingFrame,
  // --------������Ԫ---------
  DB_Module, Main_Frame,
  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework, MemoryStream64,
  CoreCipher,
  // --------�����ؼ���Ԫ---------
  uSkinButtonType, uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Rtti, FMX.Grid.Style,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.Grid,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON;

type
  TFrameLogin = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    edtUserName: TSkinFMXEdit;
    edtPassWord: TSkinFMXEdit;
    btnLogin: TSkinFMXButton;
    pnlUserName: TSkinFMXPanel;
    pnlPassWord: TSkinFMXPanel;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    Memo1: TMemo;
    pnlLogo: TSkinFMXPanel;
    edtLogo: TSkinFMXEdit;
    imgLogo: TSkinFMXImage;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
    procedure UserLogin;
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalLoginFrame: TFrameLogin;

implementation

uses
  Main_Form, ClientDefine;

{$R *.fmx}

procedure TFrameLogin.btnLoginClick(Sender: TObject);
begin
  if edtUserName.Text = '' then
  begin
    ShowMessageBoxFrame(FrmMain, '��¼ʧ��', '�˺�Ϊ�գ������������˺ţ�', TMsgDlgType.mtError, ['ȷ��'], nil);
    Exit;
  end;
  if edtPassWord.Text = '' then
  begin
    ShowMessageBoxFrame(FrmMain, '��¼ʧ��', '����Ϊ�գ������������˺ţ�', TMsgDlgType.mtError, ['ȷ��'], nil);
  end
  else
  begin
    UserLogin;
  end;

end;

procedure TFrameLogin.UserLogin;
var
  tempDFE: TDataFrameEngine;
begin
  // ��ʾ�ȴ�״̬
  ShowWaitingFrame(Self, '��¼��...');
  // �첽���ӷ����
  DBM.Client.AsyncConnectP(HostIP, RecvPort, SendPort,
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // �첽��¼����
        DBM.Client.UserLoginP(edtUserName.Text, edtPassWord.Text,
          procedure(const cState: Boolean)
          begin
            if cState then
            begin
              // �첽���˫ͨ���Ƿ񴴽��ɹ�
              DBM.Client.TunnelLinkP(
                procedure(const sState: Boolean)
                begin
                  if sState then
                  begin
                    // ��ȡ�û�����
                    tempDFE := TDataFrameEngine.Create;
                    tempDFE.WriteString(edtUserName.Text);
                    DBM.Client.SendTunnel.SendStreamCmdP('cmd_QueryLoginUserInfo', tempDFE,
                      procedure(Sender: TPeerIO; ResultData: TDataFrameEngine)
                      var
                        tempSTM: TMemoryStream64;
                      begin
                        tempSTM := TMemoryStream64.Create;

                        try
                          ResultData.Reader.ReadStream(tempSTM);
                          tempSTM.Position := 0;
                          //��ȡ���������ݿ���Ϣ
                          DBM.mtbl_Main.LoadFromStream(tempSTM, TFDStorageFormat.sfBinary);
                          //�ֽ����ݼ��еĸ�����Ϣ
                          UserInfo.var_Login_Name := DBM.mtbl_Main.FieldByName('Login_Name').AsString;
                          UserInfo.var_WaterInfo_Look := DBM.mtbl_Main.FieldByName('OP_WaterInfo_Look').AsBoolean;
                          UserInfo.var_WaterInfo_Edit := DBM.mtbl_Main.FieldByName('OP_WaterInfo_Edit').AsBoolean;
                          tempSTM.Free;
                          // Ч�����ݰ���С
                          //Memo1.Lines.Add('CRC32:' + TCipher.GenerateHashString(THashSecurity.hsCRC32, tempSTM.Memory, tempSTM.Size));

                          // ���صȴ�״̬
                          HideWaitingFrame;
                          //ShowMessageBoxFrame(FrmMain, '��¼�ɹ�', '', TMsgDlgType.mtInformation, ['ȷ��'], nil);
                          // �ͷ�ԭ������
                          uFuncCommon.FreeAndNil(GlobalMainFrame);

                          // ����������
                          HideFrame(Self, hfcttBeforeReturnFrame);
                          ShowFrame(TFrame(GlobalMainFrame), TFrameMain, FrmMain, nil, nil, nil, Application, True, True, ufsefDefault);
                          GlobalMainFrame.FrameHistroy := CurrentFrameHistroy;
                        except
                          on E: Exception do
                            DoStatus(E.ClassName + ': ' + E.Message);
                        end;

                      end);
                    tempDFE.Free;

                  end
                  else
                  begin
                    // ���صȴ�״̬
                    HideWaitingFrame;
                    ShowMessageBoxFrame(FrmMain, '��¼ʧ��', '�����������������������ԣ�', TMsgDlgType.mtError, ['ȷ��'], nil);
                    Exit;
                  end;
                end);
            end
            else
            begin
              // ���صȴ�״̬
              HideWaitingFrame;
              ShowMessageBoxFrame(FrmMain, '��¼ʧ��', '�˺Ż�����������������ԣ�', TMsgDlgType.mtError, ['ȷ��'], nil);
              Exit;
            end;
          end);
      end
      else
      begin
        // ���صȴ�״̬
        HideWaitingFrame;
        ShowMessageBoxFrame(GlobalLoginFrame, '��¼ʧ��', '�����������������������ԣ�', TMsgDlgType.mtError, ['ȷ��'], nil);
        Exit;
      end;

    end);

end;

end.

