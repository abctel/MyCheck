unit DB_Module;

interface

uses
  System.SysUtils, System.Classes,
  // --------OrangUI自选-----------
  //uFuncCommon, uUIFunction,

  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework,
  CommunicationFramework_Client_CrossSocket,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth,
  // --------其它单元---------
  //Login_Frame,
  // --------三方控件单元---------
  uSkinScrollControlType, uSkinScrollBoxType, uSkinLabelType, uSkinEditType,
  uSkinPanelType, uSkinMaterial, uSkinButtonType;

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
    procedure DataModuleCreate(Sender: TObject);
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

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TDBM.DataModuleCreate(Sender: TObject);
begin
  AddDoStatusHook(Self, DoStatusNear);

  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;

  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create(RecvTunnel, SendTunnel);

  RecvTunnel.Connect('127.0.0.1', 9816);
  SendTunnel.Connect('127.0.0.1', 9815);
end;

procedure TDBM.DoStatusNear(AText: string; const ID: Integer);
begin
  //GlobalLoginFrame.Memo1.lines.add(AText);
end;

end.

