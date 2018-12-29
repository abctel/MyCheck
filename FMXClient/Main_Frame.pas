unit Main_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  // --------OrangUI-----------
  uFuncCommon, uUIFunction, uSkinFireMonkeyControl, uSkinPanelType,
  uSkinFireMonkeyPanel,
  // --------ZServer4D---------

  // --------������Ԫ---------
  uSkinButtonType, uSkinFireMonkeyButton, uDrawPicture, uSkinImageList, uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType, uSkinListViewType, uSkinFireMonkeyListView;

type
  TFrameMain = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnExit: TSkinFMXButton;
    pnlContent: TSkinFMXPanel;
    pnlListImg: TSkinFMXPanel;
    pnlMain: TSkinFMXPanel;
    ilpListImg: TSkinFMXImageListPlayer;
    SkinImageList1: TSkinImageList;
    SkinFMXListView1: TSkinFMXListView;
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalMainFrame: TFrameMain;

implementation

uses
  DB_Module;
{$R *.fmx}

procedure TFrameMain.btnExitClick(Sender: TObject);
begin
//���ص�ǰҳ
  HideFrame(Self, hfcttBeforeReturnFrame);
  //������һҳ
  ReturnFrame(Self.FrameHistroy);

end;

end.

