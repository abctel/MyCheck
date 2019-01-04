unit ClientDefine;

interface

const
  { ZServer4D端口信息 }
  /// <summary>
  /// 本地监听IP
  /// </summary>
  HostIP = '127.0.0.1';
  /// <summary>
  /// 接收端口
  /// </summary>
  RecvPort = 9816;
  /// <summary>
  /// 发送端口
  /// </summary>
  SendPort = 9815;
  /// <summary>
  /// 断线重连超时时间
  /// </summary>
  DelayTime = 5 * 60 * 1000;

type
    { 用户登陆信息 }
  TUserInfo = class
  public
    var_Login_Name: string;
    var_WaterInfo_Look: Boolean;
    var_WaterInfo_Edit: Boolean;
  end;

var
  UserInfo: TUserInfo;

implementation

end.

