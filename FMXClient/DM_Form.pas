unit DM_Form;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Stan.Pool,
  FireDAC.FMXUI.Wait, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef;

type
  TDM = class(TDataModule)
    cdsMain: TClientDataSet;
    dsMain: TDataSource;
    FDQuery1: TFDQuery;
    FDManager1: TFDManager;
    FDConnection1: TFDConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
