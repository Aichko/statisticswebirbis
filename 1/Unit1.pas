unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IniFiles, Data.DB,
  Data.Win.ADODB, Vcl.ComCtrls,
  RegExpr, UMessengge, ComObj, Vcl.Grids, Data.DBXMySQL, Data.SqlExpr,
  Vcl.DBGrids, Vcl.Menus, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ADOTable1: TADOTable;
    DBGrid1: TDBGrid;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Button4: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private

  public
    { Public declarations }
  end;

const
  col = 1100;

var
  Form1: TForm1;
  SearchRec: TSearchRec;
  Messengge: TMessengge;

implementation

{$R *.dfm}
// 1 ������ ��������� ������, ��������� ����������
procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
  f1: TextFile;
  a1, a2, a3, a4, a5, a: String;
begin
  AssignFile(f1, 'C:\Users\Svetyxa\Desktop\stat1\Win32\Debug\access.log'); //
  reset(f1);
  ProgressBar1.Max := col;
  Form1.ProgressBar1.Visible := true;
  for i := 1 to col do
  begin
    readln(f1, a);
    Form1.ProgressBar1.Position := Form1.ProgressBar1.Position + 1;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add
      ('insert ignore into stable(ip, date, url, code, size) values("' +
      Messengge.MyAddIp('^(.*?) ', a, i) + '", "' +
      Messengge.MyAddIp('- - \[(.*?) ', a, i) + '", "' +
      Messengge.MyAddIp('"(.*?)"', a, i) + '", "' +
      Messengge.MyAddIp('" (.*?) ', a, i) + '", "' +
      Messengge.MyAddIp('" \d+ (.*?)$', a, i) + '")');
    ADOQuery1.ExecSQL;
  end;
  CloseFile(f1);
  sleep(10);
  Form1.ProgressBar1.Visible := False;
end;
//������ 2 ������� �������
procedure TForm1.Button2Click(Sender: TObject);

begin
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select * from stable;');
  ADOQuery1.active := true;
  DBGrid1.Visible := true;
  Label1.caption := inttostr(DBGrid1.DataSource.DataSet.RecordCount);
end;
// 3 ������ ������� ������� ���� �� �������
procedure TForm1.Button3Click(Sender: TObject);
begin
  ADOQuery1.SQL.Clear;
  { ADOQuery1.SQL.Add
    ('create table IF NOT EXISTS stable (ip varchar(30), date varchar(30), url text, code varchar(10),size varchar(30))');
  } ADOQuery1.SQL.Add
    ('create table IF NOT EXISTS stable (ip varchar(30), date varchar(30), url text, code varchar(10),size varchar(30), PRIMARY KEY (ip,date,size))');
  ADOQuery1.ExecSQL;
end;
//4 ������ ������� �������
procedure TForm1.Button4Click(Sender: TObject);
begin
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('drop table stable;');
  ADOQuery1.ExecSQL;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    Ini.WriteInteger('Form', 'Top', Top);
    Ini.WriteInteger('Form', 'Left', Left);
    Ini.WriteString('Form', 'Caption', caption);
    Ini.WriteBool('Form', 'InitMax', WindowState = wsMaximized);
  finally
    Ini.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  // ����������� � ����
  ADOConnection1.ConnectionString :=
    'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Extended Properties="DSN=statistic;UID=root;DATABASE=statistic;PORT=3306";Initial Catalog=statistic';
  ADOConnection1.Connected := true;
  //
  Messengge := TMessengge.Create;
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    Top := Ini.ReadInteger('Form', 'Top', 100);
    Left := Ini.ReadInteger('Form', 'Left', 100);
    caption := Ini.ReadString('Form', 'Caption', 'New Form');
    if Ini.ReadBool('Form', 'InitMax', False) then
      WindowState := wsMaximized
    else
      WindowState := wsNormal;
  finally
    Ini.Free;
  end;
end;

end.
