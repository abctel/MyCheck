unit DB_Module;

interface

uses
  System.SysUtils, System.Classes, uSkinScrollControlType, uSkinScrollBoxType, uSkinLabelType, uSkinEditType, uSkinPanelType,
  uSkinMaterial, uSkinButtonType;

type
  TDataModule1 = class(TDataModule)
    bdmReturnButton: TSkinButtonDefaultMaterial;
    pnlToolBarMaterial: TSkinPanelDefaultMaterial;
    edtHelpTextMaterial: TSkinEditDefaultMaterial;
    pnlBlackCaptionLeftMarginPanelMaterial: TSkinPanelDefaultMaterial;
    btnBlueColorButtonMaterial: TSkinButtonDefaultMaterial;
    lblNoticeTypeLabelMaterial: TSkinLabelDefaultMaterial;
    sbDefaultColorBackgroundScrollBoxMaterial: TSkinScrollBoxDefaultMaterial;
    btnRedColorButtonMaterial: TSkinButtonDefaultMaterial;
    pnlInputBlackCaptionPanelMaterial: TSkinPanelDefaultMaterial;
    btnOrangeRedBorderWhiteBackButtonMaterial: TSkinButtonDefaultMaterial;
    edtInputEditHasHelpTextMaterial: TSkinEditDefaultMaterial;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
