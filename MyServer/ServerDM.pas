unit ServerDM;

interface

uses
  System.SysUtils, System.classes,
  // 自定义
  ServerDefine,

  // FireDAC
  FireDAC.Comp.Client, FireDAC.Stan.Consts, FireDAC.Stan.Def, FireDAC.Phys.MySQL,
  FireDAC.Stan.Pool, FireDAC.Stan.Intf, FireDAC.DApt, FireDAC.Stan.Async,
  // ZServer4D
  MemoryStream64, PascalStrings, DoStatusIO;

type
  TServerDM = class(TDataModule)
    conServer: TFDConnection;
    conQuery: TFDQuery;
    conManager: TFDManager;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
  public
    constructor Create;
    destructor destroy; override;
  end;

var
  MyDM: TServerDM;
  /// <summary>
  /// 数据库查询器
  /// </summary>
  /// <param name="ASQL">需要查询的语句</param>
  /// <returns>MemoryStream64数据集类型</returns>

function MyQuery(ASQL: SystemString): TMemoryStream64;

/// <summary>
/// 数据库执行器
/// </summary>
/// <param name="ASQL">需要执行的语句</param>
procedure MyExec(ASQL:SystemString);

/// <summary>
/// 登陆查询器
/// </summary>
/// <param name="LoginName">用户账号</param>
/// <param name="LoginPass">用户密码</param>
/// <returns></returns>

function AuthQuery(LoginName, LoginPass: string): Boolean;

implementation

{ TServerDM }

constructor TServerDM.Create;
begin
  try
    // 统一注册
    conManager := TFDManager.Create(nil);
    conServer := TFDConnection.Create(nil);
    FDPhysMySQLDriverLink1 := TFDPhysMySQLDriverLink.Create(nil);
    conQuery := TFDQuery.Create(nil);
    // 设置FDManager连接信息
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
    // 设置FDConnect连接信息
    conServer.ConnectionDefName := ConnDefName;

    // 测试线程池是否创建成功
    conServer.Connected := True;
    if conServer.Connected then
      DoStatus('数据库连接池创建成功')
    else
      DoStatus('数据库连接池创建失败');
     conServer.Connected := False;
    // 设置FDQuery连接信息

    conQuery.Connection := conServer;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

destructor TServerDM.destroy;
begin
  inherited;
  // 统一释放
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
      Open;
      // TFDStorageFormat.sfBinary为Stream的文件格式，该方法有多种格式可选
      SaveToStream(Result, TFDStorageFormat.sfBinary);
      Result.Position := 0;
      Close;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure MyExec(ASQL:SystemString);
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
      SQL.Add('SELECT `auth_user`.`Login_Name`, `auth_user`.`Login_Pass` FROM `auth_user` WHERE `auth_user`.`Login_Name` = ' + '''' + LoginName + '''' + ' AND `auth_user`.`Login_Pass` = ' + '''' + LoginPass + '''');
      DoStatus(SQL);
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

