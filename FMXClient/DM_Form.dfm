object DM: TDM
  OldCreateOrder = False
  Height = 480
  Width = 580
  object cdsMain: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 8
  end
  object dsMain: TDataSource
    DataSet = cdsMain
    Left = 56
    Top = 8
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 128
    Top = 216
  end
  object FDManager1: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 264
    Top = 216
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=mycheck'
      'User_Name=root'
      'Password=haosql'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 256
    Top = 304
  end
end
