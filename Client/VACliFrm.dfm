object AuthDoubleTunnelClientForm: TAuthDoubleTunnelClientForm
  Left = 0
  Top = 0
  Caption = 'Auth Double Tunnel Client'
  ClientHeight = 562
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TimeLabel: TLabel
    Left = 32
    Top = 184
    Width = 47
    Height = 13
    Caption = 'TimeLabel'
  end
  object Memo1: TMemo
    Left = 136
    Top = 62
    Width = 481
    Height = 188
    Lines.Strings = (
      'ZServer4D'#26159#19968#27454#26381#21153#22120#20013#38388#20214
      #27492'Demo'#20026#30331#24405#24335#21452#21521#27169#24335'('#25509#21475#22823#22411#35748#35777#21518#21488#30340#26041#27861')'
      '')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ConnectButton: TButton
    Left = 32
    Top = 94
    Width = 89
    Height = 35
    Caption = 'connect'
    TabOrder = 1
    OnClick = ConnectButtonClick
  end
  object HostEdit: TLabeledEdit
    Left = 136
    Top = 8
    Width = 121
    Height = 21
    EditLabel.Width = 65
    EditLabel.Height = 13
    EditLabel.Caption = 'host address '
    LabelPosition = lpLeft
    TabOrder = 2
    Text = '127.0.0.1'
  end
  object UserEdit: TLabeledEdit
    Left = 136
    Top = 35
    Width = 97
    Height = 21
    EditLabel.Width = 22
    EditLabel.Height = 13
    EditLabel.Caption = 'User'
    LabelPosition = lpLeft
    TabOrder = 3
    Text = 'test'
  end
  object PasswdEdit: TLabeledEdit
    Left = 288
    Top = 35
    Width = 97
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = 'Passwd'
    LabelPosition = lpLeft
    TabOrder = 4
    Text = 'test'
  end
  object AsyncConnectButton: TButton
    Left = 32
    Top = 135
    Width = 89
    Height = 35
    Caption = 'async connect'
    TabOrder = 5
    OnClick = AsyncConnectButtonClick
  end
  object fixedTimeButton: TButton
    Left = 32
    Top = 216
    Width = 89
    Height = 34
    Caption = 'Fixed time Sync'
    TabOrder = 6
    OnClick = fixedTimeButtonClick
  end
  object Edit1: TEdit
    Left = 56
    Top = 288
    Width = 321
    Height = 21
    TabOrder = 7
    Text = 'select * from orders'
  end
  object Button1: TButton
    Left = 424
    Top = 286
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 8
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 56
    Top = 416
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 9
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Edit2: TEdit
    Left = 56
    Top = 328
    Width = 321
    Height = 21
    TabOrder = 10
    Text = 'Edit2'
  end
  object Button2: TButton
    Left = 424
    Top = 326
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 11
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 56
    Top = 368
    Width = 321
    Height = 21
    TabOrder = 12
    Text = 'Edit3'
  end
  object Button3: TButton
    Left = 424
    Top = 366
    Width = 75
    Height = 25
    Caption = 'BatchStream'
    TabOrder = 13
    OnClick = Button3Click
  end
  object Edit4: TEdit
    Left = 392
    Top = 368
    Width = 26
    Height = 21
    TabOrder = 14
    Text = '10'
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 344
    Top = 48
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 648
    Top = 296
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 584
    Top = 296
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 584
    Top = 344
  end
  object con1: TFDConnection
    Params.Strings = (
      'Database=MyCheck'
      'User_Name=MyCheck'
      'Password=5333564Zyl'
      'Server=chuanqi.i066.com'
      'CharacterSet=utf8mb4'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 472
    Top = 448
  end
  object fdqry1: TFDQuery
    Connection = con1
    SQL.Strings = (
      
        'SELECT User_Auth.Login_Name, User_OP.OP_WaterInfo_Look, User_OP.' +
        'OP_WateInfo_Edit FROM User_Auth INNER JOIN User_OP ON User_OP.OP' +
        '_ID = User_Auth.ID WHERE User_Auth.Login_ID = '#39'abctel'#39)
    Left = 544
    Top = 448
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 584
    Top = 392
  end
end
