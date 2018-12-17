object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
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
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 136
    Top = 16
  end
end
