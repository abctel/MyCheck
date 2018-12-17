unit ServerDefine;

interface

const
  { ZServer4D�˿���Ϣ }
  /// <summary>
  /// ���ؼ���IP
  /// </summary>
  HostIP = '0.0.0.0';
  /// <summary>
  /// ���ն˿�
  /// </summary>
  RecvPort = 9815;
  /// <summary>
  /// ���Ͷ˿�
  /// </summary>
  SendPort = 9816;
  /// <summary>
  /// Http�˿�
  /// </summary>
  HttpPort = 9814;
  /// <summary>
  /// ����������ʱʱ��
  /// </summary>
  DelayTime = 5 * 60 * 1000;

  { ���ݿ�������Ϣ }
  /// <summary>
  /// ���ӳ�����
  /// </summary>
  ConnDefName = 'MyConMySQL';
  /// <summary>
  /// ���ݿ����ͣ����磺MySQL��MSSQL��
  /// </summary>
  ConnDriverID = 'MySQL';
  /// <summary>
  /// ���ݿ�����
  /// </summary>
  ConnDatabase = 'mycheck';
  /// <summary>
  /// ���ݿ�����˺�
  /// </summary>
  ConnUserName = 'root';
  /// <summary>
  /// ���ݿ��������
  /// </summary>
  ConnPassword = 'haosql';
  /// <summary>
  /// ���ݿ����IP
  /// </summary>
  ConnServer = '127.0.0.1';
  /// <summary>
  /// ���ݿ���ʶ˿�
  /// </summary>
  ConnPort = '3306';
  /// <summary>
  /// ���ݿ��ַ���
  /// </summary>
  ConnCharacterSet = 'utf8mb4';

implementation

end.
