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
  DoStatusIO,
  // --------�����ؼ���Ԫ---------
  uSkinButtonType, uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel;

type
  TFrameLogin = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    edtUserName: TSkinFMXEdit;
    edtPassWord: TSkinFMXEdit;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    Memo1: TMemo;
    procedure SkinFMXButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalLoginFrame: TFrameLogin;

implementation

uses
  Main_Form;

{$R *.fmx}

procedure TFrameLogin.SkinFMXButton1Click(Sender: TObject);
begin
//��ʾ�ȴ�״̬
  ShowWaitingFrame(Self, '��¼��...');
  // �첽���ӷ����
  DBM.Client.AsyncConnectP('127.0.0.1', 9816, 9815,
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // �첽��¼����
        DBM.Client.UserLoginP('abctel', '53335641',
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
                  //���صȴ�״̬
                    HideWaitingFrame;
                    //ShowMessageBoxFrame(FrmMain, '��¼�ɹ�', '', TMsgDlgType.mtInformation, ['ȷ��'], nil);
                    //�ͷ�ԭ������
                    uFuncCommon.FreeAndNil(GlobalMainFrame);

                    //����������
                    HideFrame(Self, hfcttBeforeReturnFrame);
                    ShowFrame(TFrame(GlobalMainFrame), TFrameMain, FrmMain, nil, nil, nil, Application, True, True, ufsefNone);
                    GlobalMainFrame.FrameHistroy := CurrentFrameHistroy;
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

