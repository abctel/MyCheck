program FMXClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main_Form in 'Main_Form.pas' {FrmMain},
  DB_Module in 'DB_Module.pas' {DataModule1: TDataModule},
  Templet_Frame in 'Templet_Frame.pas' {FrameTemplet: TFrame},
  Login_Frame in 'Login_Frame.pas' {FrameLogin: TFrame},
  Main_Frame in 'Main_Frame.pas' {FrameMain: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
