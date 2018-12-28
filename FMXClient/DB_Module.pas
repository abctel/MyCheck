unit DB_Module;

interface

uses
  System.SysUtils, System.Classes,
  // --------OrangUI自选-----------
  // uFuncCommon, uUIFunction,

  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework,
  CoreClasses,Cadencer,
  CommunicationFramework_Client_CrossSocket,
  CommunicationFramework_Client_ICS, CommunicationFramework_Client_Indy,
  CommunicationFrameworkDoubleTunnelIO_VirtualAuth,
  // --------其它单元---------
  // Login_Frame,
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

  public
    { Public declarations }
    RecvTunnel: TCommunicationFramework_Client_CrossSocket;
    SendTunnel: TCommunicationFramework_Client_CrossSocket;
    Client: TCommunicationFramework_DoubleTunnelClient_VirtualAuth;
  end;

var
  DBM: TDBM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TDBM.DataModuleCreate(Sender: TObject);
begin
  RecvTunnel := TCommunicationFramework_Client_CrossSocket.Create;
  SendTunnel := TCommunicationFramework_Client_CrossSocket.Create;

  Client := TCommunicationFramework_DoubleTunnelClient_VirtualAuth.Create(RecvTunnel, SendTunnel);

  Client.RegisterCommand;

  client.AsyncConnectP('127.0.0.1', 9816, 9815,
    procedure(const cState: Boolean)
    begin
      if cState then
        begin
          // 嵌套式匿名函数支持
          client.UserLoginP('test', 'test',
            procedure(const lState: Boolean)
            begin
              if lState then
                begin
                  client.TunnelLinkP(
                    procedure(const tState: Boolean)
                    begin
                      if tState then
                          DoStatus('double tunnel link success!')
                      else
                          DoStatus('double tunnel link failed!');
                    end)
                end
              else
                begin
                  if lState then
                      DoStatus('login success!')
                  else
                      DoStatus('login failed!');
                end;
            end);
        end
      else
        begin
          if cState then
              DoStatus('connected success!')
          else
              DoStatus('connected failed!');
        end;
    end);
end;

end.

