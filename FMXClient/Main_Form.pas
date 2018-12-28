unit Main_Form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  // --------OrangUI-----------
  uFuncCommon, uUIFunction,
  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework, CoreClasses, Cadencer,
  CommunicationFramework_Client_CrossSocket, CommunicationFramework_Client_ICS,
  CommunicationFramework_Client_Indy,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth
  // --------其它单元---------
  ;

type
  TFrmMain = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
Login_Frame, DB_Module;
{$R *.fmx}

procedure TFrmMain.FormShow(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalLoginFrame), TFrameLogin, FrmMain, nil, nil, nil,
    Application, True, True, ufsefNone);
  GlobalLoginFrame.FrameHistroy := CurrentFrameHistroy;
  DBM := TDBM.Create(nil);


end;

end.
