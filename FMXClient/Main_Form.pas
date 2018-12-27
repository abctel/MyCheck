unit Main_Form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  //--------OrangUI-----------
  uFuncCommon, uUIFunction,
  //--------ZServer4D---------

  //--------其它单元---------
  Login_Frame
  ;

type
  TFrmMain = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.FormShow(Sender: TObject);
begin
   ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,FrmMain,nil,nil,nil,Application,True,True,ufsefNone);
   GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.
