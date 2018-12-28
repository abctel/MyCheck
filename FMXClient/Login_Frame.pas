unit Login_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  // --------OrangUI��ѡ-----------
  uFuncCommon, uUIFunction, MessageBoxFrame,
  // --------������Ԫ---------
  DB_Module,
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

{$R *.fmx}

procedure TFrameLogin.SkinFMXButton1Click(Sender: TObject);
begin
  while (not DBM.Client.RemoteInited) and (DBM.Client.Connected) do
  begin
    TThread.Sleep(10);
    DBM.Client.Progress;
  end;

    if DBM.Client.Connected then
  begin
    if DBM.Client.UserLogin('abctel', '53335641') then
      ShowMessageBoxFrame(GlobalLoginFrame, '��¼�ɹ�', '', TMsgDlgType.mtInformation, ['ȷ��'], nil)
    else
      ShowMessageBoxFrame(GlobalLoginFrame, '��¼ʧ��', '', TMsgDlgType.mtInformation, ['ȷ��'], nil);

  end;

end;

end.

