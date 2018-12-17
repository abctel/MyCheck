program MyAPP;

uses
  System.StartUpCopy,
  FMX.Forms,
  Login_Frame in 'Login_Frame.pas' {FrameLogin: TFrame} ,
  Main_Form in 'Main_Form.pas' {frmMain} ,
  APP1_Frame in 'APP1_Frame.pas' {MainAPP1: TFrame} ,
  FriendCircleCommonMaterialDataMoudle
    in 'FriendCircleCommonMaterialDataMoudle.pas' {dmFriendCircleCommonMaterial: TDataModule} ,
  Logs_Frame in 'Logs_Frame.pas' {FrameLogs: TFrame} ,
  Main_Frame in 'Main_Frame.pas' {FrameMain: TFrame} ,
  DM_Form in 'DM_Form.pas' {DM: TDataModule};

// SimpleMsgPack in '..\Common\SimpleMsgPack.pas',
// uRawTcpClientCoderImpl in '..\Common\uRawTcpClientCoderImpl.pas',
// uStreamCoderSocket in '..\Common\uStreamCoderSocket.pas',
// uICoderSocket in '..\Common\uICoderSocket.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmFriendCircleCommonMaterial,
    dmFriendCircleCommonMaterial);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TDM, DM);
  Application.Run;

end.
