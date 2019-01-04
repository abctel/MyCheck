unit DB_Module;

interface

uses
  System.SysUtils, System.Classes,
  // --------OrangUI自选-----------
  // uFuncCommon, uUIFunction,

  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework, CoreClasses, Cadencer,
  CommunicationFramework_Client_CrossSocket, CommunicationFramework_Client_ICS,
  CommunicationFramework_Client_Indy, PascalStrings,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth,
  // --------其它单元---------
  // Login_Frame,
  // --------三方控件单元---------
  uSkinScrollControlType, uSkinScrollBoxType, uSkinLabelType, uSkinEditType,
  uSkinPanelType, uSkinMaterial, uSkinButtonType, FMX.Types, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin;

type
  TDBM = class(TDataModule)
    bdmReturnButton: TSkinButtonDefaultMaterial;
    pnlToolBarMaterial: TSkinPanelDefaultMaterial;
    edtHelpTextMaterial: TSkinEditDefaultMaterial;
    pnlBlackCaptionLeftMarginPanelMaterial: TSkinPanelDefaultMaterial;
    btnBlueColorButtonMaterial: TSkinButtonDefaultMaterial;
    lblNoticeTypeLabelMaterial: TSkinLabelDefaultMaterial;
    sbDefaultColorBackgroundScrollBoxMaterial: TSkinScrollBoxDefaultMaterial;
    btnRedColorButtonMaterial: TSkinButtonDefaultMaterial;
    pnlInputBlackCaptionPanelMaterial: TSkinPanelDefaultMaterial;
    btnOrangeRedBorderWhiteBackButtonMaterial: TSkinButtonDefaultMaterial;
    edtInputEditHasHelpTextMaterial: TSkinEditDefaultMaterial;
    Timer1: TTimer;
    mtbl_Main: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
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
  DBM: TDBM;
//  var_Login_Name: string;
//  var_WaterInfo_Look: Boolean;
//  var_WaterInfo_Edit: Boolean;

implementation

uses
  Login_Frame, ClientDefine;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TDBM.DataModuleDestroy(Sender: TObject);
begin
  DisposeObject(Client);
  DeleteDoStatusHook(GlobalLoginFrame);
  DisposeObject(UserInfo);
end;

procedure TDBM.DataModuleCreate(Sender: TObject);
begin
  UserInfo := TUserInfo.Create;
  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;

  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create(RecvTunnel, SendTunnel);

  AddDoStatusHook(GlobalLoginFrame, DoStatusNear);
end;

procedure TDBM.DoStatusNear(AText: string; const ID: Integer);
begin
  GlobalLoginFrame.Memo1.Lines.Add(AText);
end;

procedure TDBM.Timer1Timer(Sender: TObject);
begin
  Client.Progress;
end;

end.

