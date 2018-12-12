unit ServerDefine;

interface

const
  { ZServer4D端口信息 }
  /// <summary>
  /// 本地监听IP
  /// </summary>
  HostIP = '0.0.0.0';
  /// <summary>
  /// 接收端口
  /// </summary>
  RecvPort = 9815;
  /// <summary>
  /// 发送端口
  /// </summary>
  SendPort = 9816;
  /// <summary>
  /// Http端口
  /// </summary>
  HttpPort = 9814;
  /// <summary>
  /// 断线重连超时时间
  /// </summary>
  DelayTime = 5 * 60 * 1000;

  { 数据库配置信息 }
  /// <summary>
  /// 连接池名称
  /// </summary>
  ConnDefName = 'MyConMySQL';
  /// <summary>
  /// 数据库类型，例如：MySQL，MSSQL等
  /// </summary>
  ConnDriverID = 'MySQL';
  /// <summary>
  /// 数据库名称
  /// </summary>
  ConnDatabase = 'mycheck';
  /// <summary>
  /// 数据库访问账号
  /// </summary>
  ConnUserName = 'root';
  /// <summary>
  /// 数据库访问密码
  /// </summary>
  ConnPassword = 'haosql';
  /// <summary>
  /// 数据库访问IP
  /// </summary>
  ConnServer = '127.0.0.1';
  /// <summary>
  /// 数据库访问端口
  /// </summary>
  ConnPort = '3306';
  /// <summary>
  /// 数据库字符集
  /// </summary>
  ConnCharacterSet = 'utf8mb4';

implementation

end.
