unit Login_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  // --------OrangUI自选-----------
  uFuncCommon, uUIFunction, MessageBoxFrame, WaitingFrame,
  // --------其它单元---------
  DB_Module, Main_Frame,
  // --------ZServer4D---------
  DoStatusIO, DataFrameEngine, CommunicationFramework, MemoryStream64,
  CoreCipher,
  // --------三方控件单元---------
  uSkinButtonType, uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Rtti, FMX.Grid.Style,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.Grid,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON;

type
  TFrameLogin = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    edtUserName: TSkinFMXEdit;
    edtPassWord: TSkinFMXEdit;
    btnLogin: TSkinFMXButton;
    pnlUserName: TSkinFMXPanel;
    pnlPassWord: TSkinFMXPanel;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    Memo1: TMemo;
    pnlLogo: TSkinFMXPanel;
    edtLogo: TSkinFMXEdit;
    imgLogo: TSkinFMXImage;
    DataSource1: TDataSource;
    FDMemTable1: TFDMemTable;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
    procedure UserLogin;
  public
    { Public declarations }
    FrameHistroy: TFrameHistroy;
  end;

var
  GlobalLoginFrame: TFrameLogin;

implementation

uses
  Main_Form, ClientDefine;

{$R *.fmx}

procedure TFrameLogin.btnLoginClick(Sender: TObject);
begin
  if edtUserName.Text = '' then
  begin
    ShowMessageBoxFrame(FrmMain, '登录失败', '账号为空，请输入您的账号！', TMsgDlgType.mtError, ['确定'], nil);
    Exit;
  end;
  if edtPassWord.Text = '' then
  begin
    ShowMessageBoxFrame(FrmMain, '登录失败', '密码为空，请输入您的账号！', TMsgDlgType.mtError, ['确定'], nil);
  end
  else
  begin
    UserLogin;
  end;

end;

procedure TFrameLogin.UserLogin;
var
  tempDFE: TDataFrameEngine;
begin
//显示等待状态
  ShowWaitingFrame(Self, '登录中...');
  // 异步连接服务端
  DBM.Client.AsyncConnectP(HostIP, RecvPort, SendPort,
    procedure(const cState: Boolean)
    begin
      if cState then
      begin
        // 异步登录操作
        DBM.Client.UserLoginP(edtUserName.Text, edtPassWord.Text,
          procedure(const cState: Boolean)
          begin
            if cState then
            begin
              // 异步检查双通道是否创建成功
              DBM.Client.TunnelLinkP(
                procedure(const sState: Boolean)
                begin
                  if sState then
                  begin
                  //获取用户资料
                    tempDFE := TDataFrameEngine.Create;

                    tempDFE.WriteString(edtUserName.Text);
                    DBM.Client.SendTunnel.SendStreamCmdP('cmd_QueryLoginUserInfo', tempDFE,
                      procedure(Sender: TPeerIO; ResultData: TDataFrameEngine)
                      var
                        tempSTM: TMemoryStream64;
                      begin
                        tempSTM := TMemoryStream64.Create;

                        try
                          ResultData.Reader.ReadStream(tempSTM);
                          tempSTM.Position := 0;
                       // DoStatus(tempSTM.ReadString.Text);
                          FDMemTable1.LoadFromStream(tempSTM, TFDStorageFormat.sfJSON);
                          DoStatus(FDMemTable1.FieldByName('Login_Name').AsString);
                          DoStatus('CRC32:' + TCipher.GenerateHashString(THashSecurity.hsCRC32, tempSTM.Memory, tempSTM.Size));
                          tempSTM.Free;
                        except
                          on E: Exception do
                            DoStatus(E.ClassName + ': ' + E.Message);
                        end;

                      end);

//                  //隐藏等待状态
                        HideWaitingFrame;
//                    //ShowMessageBoxFrame(FrmMain, '登录成功', '', TMsgDlgType.mtInformation, ['确定'], nil);
//                    //释放原主界面
//                    uFuncCommon.FreeAndNil(GlobalMainFrame);
//
//                    //进入主界面
//                    HideFrame(Self, hfcttBeforeReturnFrame);
//                    ShowFrame(TFrame(GlobalMainFrame), TFrameMain, FrmMain, nil, nil, nil, Application, True, True, ufsefDefault);
//                    GlobalMainFrame.FrameHistroy := CurrentFrameHistroy;
                  end
                  else
                  begin
                  //隐藏等待状态
                    HideWaitingFrame;
                    ShowMessageBoxFrame(FrmMain, '登录失败', '网络错误，请检查网络后重新再试！', TMsgDlgType.mtError, ['确定'], nil);
                    Exit;
                  end;
                end);
            end
            else
            begin
              //隐藏等待状态
              HideWaitingFrame;
              ShowMessageBoxFrame(FrmMain, '登录失败', '账号或密码错误，请重新再试！', TMsgDlgType.mtError, ['确定'], nil);
              Exit;
            end;
          end);
      end
      else
      begin
      //隐藏等待状态
        HideWaitingFrame;
        ShowMessageBoxFrame(GlobalLoginFrame, '登录失败', '网络错误，请检查网络后重新再试！', TMsgDlgType.mtError, ['确定'], nil);
        Exit;
      end;

    end);

end;

end.

