// convert pas to utf8 by ¥

unit Main_Frame;

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
  uSkinFireMonkeyListView;

type
  TFrameMain = class(TFrame)
    PnlToolbar: TSkinFMXPanel;
    SkinFMXListView1: TSkinFMXListView;
  public
    { Private declarations }
  public
    FrameHistroy: TFrameHistroy;
    destructor Destroy; override;
    { Public declarations }
  end;

var
  GlobalMainFrame: TFrameMain;

implementation

uses
  FriendCircleCommonMaterialDataMoudle,
  Main_Form;

{$R *.fmx}
{ TFrameMain }

destructor TFrameMain.Destroy;
begin

  inherited;
end;

end.
