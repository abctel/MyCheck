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
  DoStatusIO, DataFrameEngine, CommunicationFramework,
  // --------�����ؼ���Ԫ---------
  uSkinButtonType, uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage;

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
  tempStm: TDataFrameEngine;
begin
//��ʾ�ȴ�״̬
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
                  //��ȡ�û�����
                    tempStm := TDataFrameEngine.Create;
                    tempStm.WriteString(edtUserName.Text);
                    DBM.Client.SendTunnel.SendStreamCmdP('cmd_QueryLoginUserInfo', tempStm,
                      procedure(Sender: TPeerIO; ResultData: TDataFrameEngine)
                      begin
                        DoStatus('1');
                        DoStatus(ResultData.Reader.ReadString);
                      end);
                    tempStm.Free;








//                  //���صȴ�״̬
                    HideWaitingFrame;
//                    //ShowMessageBoxFrame(FrmMain, '��¼�ɹ�', '', TMsgDlgType.mtInformation, ['ȷ��'], nil);
//                    //�ͷ�ԭ������
//                    uFuncCommon.FreeAndNil(GlobalMainFrame);
//
//                    //����������
//                    HideFrame(Self, hfcttBeforeReturnFrame);
//                    ShowFrame(TFrame(GlobalMainFrame), TFrameMain, FrmMain, nil, nil, nil, Application, True, True, ufsefDefault);
//                    GlobalMainFrame.FrameHistroy := CurrentFrameHistroy;
                  end
                  else
                  begin
                  //���صȴ�״̬
                    HideWaitingFrame;
                    ShowMessageBoxFrame(FrmMain, '��¼ʧ��', '�����������������������ԣ�', TMsgDlgType.mtError, ['ȷ��'], nil);
                    Exit;
                  end;
                end);
            end
            else
            begin
              //���صȴ�״̬
              HideWaitingFrame;
              ShowMessageBoxFrame(FrmMain, '��¼ʧ��', '�˺Ż�����������������ԣ�', TMsgDlgType.mtError, ['ȷ��'], nil);
              Exit;
            end;
          end);
      end
      else
      begin
      //���صȴ�״̬
        HideWaitingFrame;
        ShowMessageBoxFrame(GlobalLoginFrame, '��¼ʧ��', '�����������������������ԣ�', TMsgDlgType.mtError, ['ȷ��'], nil);
        Exit;
      end;

    end);

end;

end.

