unit ServerDM;

interface

uses
  System.SysUtils, System.classes,
  // �Զ���
  ServerDefine,

  // FireDAC
  FireDAC.Comp.Client, FireDAC.Stan.Consts, FireDAC.Stan.Def, FireDAC.Phys.MySQL,
  FireDAC.Stan.Pool, FireDAC.Stan.Intf, FireDAC.DApt, FireDAC.Stan.Async,
  FireDAC.Stan.StorageXML, FireDAC.Stan.StorageJSON, FireDAC.Stan.Storage,
  FireDAC.Stan.StorageBin,
  // ZServer4D
  MemoryStream64, PascalStrings, DoStatusIO, CoreCipher;

type
  TServerDM = class(TDataModule)
    conServer: TFDConnection;
    conQuery: TFDQuery;
    conManager: TFDManager;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDStanStorageBinLink1:TFDStanStorageBinLink;
    FDStanStorageXMLLink1: TFDStanStorageXMLLink;
  public
    constructor Create;
    destructor destroy; override;
  end;

var
  MyDM: TServerDM;
  /// <summary>
  /// ���ݿ��ѯ��
  /// </summary>
  /// <param name="ASQL">��Ҫ��ѯ�����</param>
  /// <returns>MemoryStream64���ݼ�����</returns>

function MyQuery(ASQL: SystemString): TMemoryStream64;

/// <summary>
/// ���ݿ�ִ����
/// </summary>
/// <param name="ASQL">��Ҫִ�е����</param>
procedure MyExec(ASQL: SystemString);

/// <summary>
/// ��½��ѯ��
/// </summary>
/// <param name="LoginName">�û��˺�</param>
/// <param name="LoginPass">�û�����</param>
/// <returns></returns>

function AuthQuery(LoginName, LoginPass: string): Boolean;

implementation

{ TServerDM }

constructor TServerDM.Create;
begin
  try
    // ͳһע��
    conManager := TFDManager.Create(nil);
    conServer := TFDConnection.Create(nil);
    FDPhysMySQLDriverLink1 := TFDPhysMySQLDriverLink.Create(nil);
    conQuery := TFDQuery.Create(nil);
    // ����FDManager������Ϣ
    with conManager.ConnectionDefs.AddConnectionDef do
    begin
      Name := ConnDefName;
      Params.DriverID := ConnDriverID;
      Params.Database := ConnDatabase;
      Params.UserName := ConnUserName;
      Params.Password := ConnPassword;
      Params.Values['Server'] := ConnServer;
      Params.Values['Port'] := ConnPort;
      Params.Values['CharacterSet'] := ConnCharacterSet;
      Params.Pooled := True;
      Apply;
    end;
    conManager.Active := True;
    // ����FDConnect������Ϣ
    conServer.ConnectionDefName := ConnDefName;

    // �����̳߳��Ƿ񴴽��ɹ�
    with conServer do
    begin
      Connected := True;
      if Connected then
        DoStatus('���ݿ����ӳش����ɹ�')
      else
        DoStatus('���ݿ����ӳش���ʧ��');
    end;

    // ����FDQuery������Ϣ
    with conQuery do
    begin
      Connection := conServer;
      ResourceOptions.StoreItems := [siData, siMeta, siDelta];
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

destructor TServerDM.destroy;
begin
  inherited;
  // ͳһ�ͷ�
  conQuery.Free;
  conServer.Free;
  conManager.Free;
  MyDM.Free;
end;

function MyQuery(ASQL: SystemString): TMemoryStream64;
begin
  try
    Result := TMemoryStream64.Create;
    with MyDM.conQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ASQL);
      DoStatus(ASQL);
      Open;
      //Data.DataView.
      // TFDStorageFormat.sfBinaryΪStream���ļ���ʽ���÷����ж��ָ�ʽ��ѡ
      SaveToStream(Result, TFDStorageFormat.sfBinary);
      DoStatus(FieldByName('Login_Name').AsString);
      Result.Position := 0;
      //Ч�����ݰ�
      DoStatus('δѹ�� CRC32:' + TCipher.GenerateHashString(THashSecurity.hsCRC32, Result.Memory, Result.Size));
      Close;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure MyExec(ASQL: SystemString);
begin
  try
    with MyDM.conQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ASQL);
      ExecSQL;
      Close;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

function AuthQuery(LoginName, LoginPass: string): Boolean;
begin
  try
    with MyDM.conQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT User_Auth.ID, User_OP.OP_WaterInfo_Look, ' + 'User_OP.OP_WaterInfo_Edit, User_Auth.Login_ID, ' + 'User_Auth.Login_Pass, User_Auth.Login_Name, ' + 'User_Auth.Login_Time, User_Auth.Reg_Time, ' + 'User_Auth.Login_Count FROM User_Auth ' + 'INNER JOIN User_OP ON User_Auth.ID = User_OP.OP_ID WHERE ' + 'User_Auth.Login_ID = ' + '''' + LoginName + '''' + ' AND ' + 'User_Auth.Login_Pass = ' + '''' + LoginPass + '''' + '');
      // DoStatus(SQL);
      Open;
      if RecordCount > 0 then
      begin
        Result := True;
      end
      else
      begin
        Result := False;
      end;
      Close;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

end.

