unit ClientDefine;

interface

const
  { ZServer4D�˿���Ϣ }
  /// <summary>
  /// ���ؼ���IP
  /// </summary>
  HostIP = '127.0.0.1';
  /// <summary>
  /// ���ն˿�
  /// </summary>
  RecvPort = 9816;
  /// <summary>
  /// ���Ͷ˿�
  /// </summary>
  SendPort = 9815;
  /// <summary>
  /// ����������ʱʱ��
  /// </summary>
  DelayTime = 5 * 60 * 1000;

type
    { �û���½��Ϣ }
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

