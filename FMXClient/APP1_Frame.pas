// convert pas to utf8 by ¥

unit APP1_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uBaseLog,
  uTimerTask,

  uUIFunction,
  uFuncCommon,

  MessageBoxFrame,

  uSkinFireMonkeyPageControl, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel, uDrawPicture, uSkinImageList,
  System.Notification, uSkinPageControlType, uSkinSwitchPageListPanelType,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType,
  uSkinFireMonkeyListView, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, FMX.Edit,
  FMX.Controls.Presentation, uSkinFireMonkeyEdit;

type
  TMainAPP1 = class(TFrame)
    PnlToolbar: TSkinFMXPanel;
    SkinFMXListBox1: TSkinFMXListBox;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXEdit1: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
  public
    { Private declarations }
  public
    FrameHistroy: TFrameHistroy;
    destructor Destroy; override;
    { Public declarations }
  end;

var
  GlobalMainFrame: TMainAPP1;

implementation

uses
  FriendCircleCommonMaterialDataMoudle,
  Main_Form;

{$R *.fmx}
{ TFrameMain }

destructor TMainAPP1.Destroy;
begin

  inherited;
end;

end.
