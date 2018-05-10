unit UStatistic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, JPEG,
  Data.DB, Data.Win.ADODB, RegExpr, UMessengge, ComObj, Vcl.Grids,
  Data.DBXMySQL, Data.SqlExpr, Vcl.ComCtrls, Vcl.Samples.Gauges, Vcl.DBGrids,
  Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.Series,
  VclTee.TeeProcs, VclTee.Chart, VclTee.DBChart, Vcl.DBCtrls;

type
  TForm2 = class(TForm)
    Menu: TPanel;
    Head: TPanel;
    Title_1: TLabel;
    Title_2: TLabel;
    Statistic: TLabel;
    Diagramm: TLabel;
    Updatebase: TLabel;
    Exit: TLabel;
    Icon1_Statistic: TImage;
    Icon2_Diag: TImage;
    Icon3_Update: TImage;
    Icon4_Exit: TImage;
    ADOConnection1: TADOConnection;
    DataSource1: TDataSource;
    Body: TPanel;
    ProgressBar1: TProgressBar;
    Parametrs: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Calendar: TDateTimePicker;
    Calendar1: TDateTimePicker;
    Query: TPanel;
    Uniq: TCheckBox;
    PDF: TCheckBox;
    Countbutton: TPanel;
    IQuery: TLabel;
    IValue: TLabel;
    IQuery1: TLabel;
    IValue1: TLabel;
    IQuery2: TLabel;
    IValue2: TLabel;
    IQuery3: TLabel;
    IValue3: TLabel;
    Diagrammpanel: TPanel;
    Label3: TLabel;
    DBChart1: TDBChart;
    Updatediagram: TLabel;
    DBGrid1: TDBGrid;
    ADOQuery1: TADOQuery;
    ComboBox1: TComboBox;
    Series1: TBarSeries;
    Series2: TBarSeries;
    Series3: TBarSeries;
    Series4: TBarSeries;
    Series5: TBarSeries;
    Series6: TBarSeries;
    Series7: TBarSeries;
    Series8: TBarSeries;
    Series9: TBarSeries;
    Series10: TBarSeries;
    Series11: TBarSeries;
    Series12: TBarSeries;
    procedure FormActivate(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure UpdatebaseClick(Sender: TObject);
    procedure StatisticClick(Sender: TObject);
    procedure HeadMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CalendarChange(Sender: TObject);
    procedure CountbuttonMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CountbuttonMouseLeave(Sender: TObject);
    procedure CountbuttonClick(Sender: TObject);
    procedure DiagrammClick(Sender: TObject);
    procedure StatisticMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure StatisticMouseLeave(Sender: TObject);
    procedure UpdatediagramClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    f1: TextFile;
    day, month, year, day1, month1, year1, variable, variable1: string;
    i: Integer;
    ExlApp: Variant;
    openexcel: boolean;
  end;

const
  xlExcel9795 = $0000002B;
  xlExcel8 = 56;

var
  Form2: TForm2;
  Messengge: TMessengge;

implementation

{$R *.dfm}

uses UAuthorization, UInterface;

procedure TForm2.FormActivate(Sender: TObject);
begin
  Form1.hide;
  Messengge := TMessengge.Create;
  ADOConnection1.Connected := false;
  ADOConnection1.ConnectionString :=
    'Provider=MSDASQL.1;Password=1234;Persist Security Info=True;User ID=root;Extended Properties="DSN=statistic;UID=root;PWD=1234;DATABASE=statistic;PORT=3306;";Initial Catalog=statistic';
  ADOConnection1.Connected := true;
  ADOQuery1.active := true;
end;

procedure TForm2.StatisticClick(Sender: TObject);
begin
  Parametrs.visible := true;
  Query.visible := false;
  Diagrammpanel.visible := false;
  Deletevalue;
end;

procedure TForm2.CountbuttonClick(Sender: TObject);
begin
  Deletevalue;
  Query.visible := true;

  if year = '2015' then
    year := 'year2015'
  else if year = '2016' then
    year := 'year2016'
  else if year = '2017' then
    year := 'year2017'
  else
    year := 'year2018';

  if year1 = '2015' then
    year1 := 'year2015'
  else if year1 = '2016' then
    year1 := 'year2016'
  else if year1 = '2017' then
    year1 := 'year2017'
  else
    year1 := 'year2018';

  if year = year1 then
  begin
    if IValue.Caption = '0' then
    begin
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('select count(*) from  ' + year +
        ' WHERE (date between "' + variable + '" and "' + variable1 +
        '") and code=200 ;');
      ADOQuery1.open;
      IValue.Caption := inttostr(ADOQuery1.Fields[0].AsInteger);
    end;

    if (Uniq.Checked = false) and (PDF.Checked = true) then
    begin
      if IValue1.Caption = '0' then
      begin
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select count(*) from ' + year +
          ' WHERE (url like ''%pdf%'') and (date between "' + variable +
          '" and "' + variable1 + '") and code=200;');
        ADOQuery1.open;
        IValue1.Caption := inttostr(ADOQuery1.Fields[0].AsInteger);
      end;
    end;

    if (Uniq.Checked = true) and (PDF.Checked = false) then
    begin
      if IValue2.Caption = '0' then
      begin
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select count(DISTINCT (ip)) from ' + year +
          ' WHERE (date between "' + variable + '" and "' + variable1 +
          '") and code=200;');
        ADOQuery1.open;
        IValue2.Caption := inttostr(ADOQuery1.Fields[0].AsInteger);
      end;
    end;

    if (Uniq.Checked = true) and (PDF.Checked = true) then
    begin
      if IValue3.Caption = '0' then
      begin
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select count(DISTINCT (ip)) from ' + year +
          ' WHERE (url like ''%pdf%'') and (date between "' + variable +
          '" and "' + variable1 + '") and (code=200);');
        ADOQuery1.open;
        IValue3.Caption := inttostr(ADOQuery1.Fields[0].AsInteger);
      end;
    end;
  end;
end;

procedure TForm2.CalendarChange(Sender: TObject);
begin
  Deletevalue;
  IValue.Caption := '0';
  IValue1.Caption := '0';
  IValue2.Caption := '0';
  IValue3.Caption := '0';
  day := formatdatetime('dd', (Calendar.Date));
  month := formatdatetime('mm', (Calendar.Date));
  year := formatdatetime('yyyy', (Calendar.Date));
  variable := year + '-' + month + '-' + day;
  if Calendar1.Checked = false then
  begin
    if Length(inttostr(strtoint(day))) = 1 then
      day1 := '0' + inttostr(strtoint(day) + 1)
    else
      day1 := inttostr(strtoint(day) + 1);
    month1 := month;
    year1 := year;
    variable1 := year1 + '-' + month1 + '-' + day1;
  end
  else
  begin
    day1 := formatdatetime('dd', (Calendar1.Date));
    month1 := formatdatetime('mm', (Calendar1.Date));
    year1 := formatdatetime('yyyy', (Calendar1.Date));
    variable1 := year1 + '-' + month1 + '-' + day1;
  end;
end;

procedure TForm2.DiagrammClick(Sender: TObject);
begin
  Parametrs.visible := false;
  Query.visible := false;
  Diagrammpanel.visible := true;
  Deletevalue;
  DBChart1.visible := false;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
var
cl:integer;
begin
  DBChart1.visible := true;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select * from diagramm;');
  DBChart1.Series[0].YValues.ValueSource := 'january';
  DBChart1.Series[0].Title := '������';
  DBChart1.Series[1].YValues.ValueSource := 'february';
  DBChart1.Series[1].Title := '�������';
  DBChart1.Series[2].YValues.ValueSource := 'march';
  DBChart1.Series[2].Title := '����';
  DBChart1.Series[3].YValues.ValueSource := 'april';
  DBChart1.Series[3].Title := '������';
  DBChart1.Series[4].YValues.ValueSource := 'may';
  DBChart1.Series[4].Title := '���';
  DBChart1.Series[5].YValues.ValueSource := 'june';
  DBChart1.Series[5].Title := '����';
  DBChart1.Series[6].YValues.ValueSource := 'jule';
  DBChart1.Series[6].Title := '����';
  DBChart1.Series[7].YValues.ValueSource := 'august';
  DBChart1.Series[7].Title := '������';
  DBChart1.Series[8].YValues.ValueSource := 'september';
  DBChart1.Series[8].Title := '��������';
  DBChart1.Series[9].YValues.ValueSource := 'october';
  DBChart1.Series[9].Title := '�������';
  DBChart1.Series[10].YValues.ValueSource := 'november';
  DBChart1.Series[10].Title := '������';
  DBChart1.Series[11].YValues.ValueSource := 'december';
  DBChart1.Series[11].Title := '�������';

  case ComboBox1.ItemIndex of
    0:
      begin

        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select * from diagramm where id=1;');
        ADOQuery1.open;
        DBChart1.Title.Text.Clear;
        DBChart1.Title.Text.Add('���������� ��������� �� 2015 ���');
        Updatediagram.visible := false;
      end;
    1:
      begin

        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select * from diagramm where id=2;');
        ADOQuery1.open;
        DBChart1.Title.Text.Clear;
        DBChart1.Title.Text.Add('���������� ��������� �� 2016 ���');
        Updatediagram.visible := false;
      end;
    2:
      begin
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select * from diagramm where id=3;');
        ADOQuery1.open;
        DBChart1.Title.Text.Clear;
        DBChart1.Title.Text.Add('���������� ��������� �� 2017 ���');
        Updatediagram.visible := false;
      end;
    3:
      begin

        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select * from diagramm where id=4;');
        ADOQuery1.open;
        DBChart1.Title.Text.Clear;
        DBChart1.Title.Text.Add('���������� ��������� �� 2018 ���');
        Updatediagram.visible := true;
      end;
    4:
      begin

        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select * from diagramm where id=5;');
        ADOQuery1.open;
        DBChart1.Title.Text.Clear;
        DBChart1.Title.Text.Add
          ('���������� ��������� �� ������� �� ���� ������');
        Updatediagram.visible := false;

      end;
  end;

end;

// ����������
procedure TForm2.UpdatediagramClick(Sender: TObject);
var
  jan, feb, mar, apr, May, jun, jul, aug, sep, oct, nov, dec, summ1: string;
  summ, row, col, b: Integer;
begin
  Deletevalue;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-01-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  jan := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-02-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  feb := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-03-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  mar := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-04-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  apr := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-05-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  May := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-06-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  jun := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-07-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  jul := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-08-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  aug := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-09-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  sep := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-10-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  oct := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-11-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  nov := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    ('select count(*) from year2018 where date like ''%2018-12-%'';');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  dec := inttostr(ADOQuery1.Fields[0].AsInteger);

  summ1 := inttostr(summ);
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('update diagramm set January = if(January <> "' + jan +
    '", January + "' + jan + '",January),February = if(February <> "' + feb +
    '", February + "' + feb + '",February),March = if(March <> "' + mar +
    '", March + "' + mar + '",March),April = if(April <> "' + apr +
    '", April + "' + apr + '",April),May = if(May <> "' + May + '", May + "' +
    May + '",May),June = if(June <> "' + jun + '", June + "' + jun +
    '",June),Jule = if(Jule <> "' + jul + '", Jule + "' + jul +
    '",Jule),August = if(August <> "' + aug + '", August + "' + aug +
    '",August),September = if(September <> "' + sep + '", September + "' + sep +
    '",September),October = if(October <> "' + oct + '", October + "' + oct +
    '",October),November = if(November <> "' + nov + '", November + "' + nov +
    '",November),December = if(December <> "' + dec + '", December + "' + dec +
    '",December), summ ="' + summ1 + '" where id = 4;');
  ADOQuery1.execsql;

  // ����� �� �������
  summ := 0;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(january) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  jan := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(february) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  feb := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(march) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  mar := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(april) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  apr := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(may) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  May := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(june) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  jun := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(jule) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  jul := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(august) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  aug := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(september) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  sep := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(october) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  oct := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(november) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  nov := inttostr(ADOQuery1.Fields[0].AsInteger);

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select SUM(december) FROM diagramm where year<>0;');
  ADOQuery1.open;
  summ := summ + ADOQuery1.Fields[0].AsInteger;
  summ1 := inttostr(summ);
  dec := inttostr(ADOQuery1.Fields[0].AsInteger);
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('update diagramm set January = if(January <> "' + jan +
    '", January + "' + jan + '",January),February = if(February <> "' + feb +
    '", February + "' + feb + '",February),March = if(March <> "' + mar +
    '", March + "' + mar + '",March),April = if(April <> "' + apr +
    '", April + "' + apr + '",April),May = if(May <> "' + May + '", May + "' +
    May + '",May),June = if(June <> "' + jun + '", June + "' + jun +
    '",June),Jule = if(Jule <> "' + jul + '", Jule + "' + jul +
    '",Jule),August = if(August <> "' + aug + '", August + "' + aug +
    '",August),September = if(September <> "' + sep + '", September + "' + sep +
    '",September),October = if(October <> "' + oct + '", October + "' + oct +
    '",October),November = if(November <> "' + nov + '", November + "' + nov +
    '",November),December = if(December <> "' + dec + '", December + "' + dec +
    '",December), summ ="' + summ1 + '" where id = 5;');
  ADOQuery1.execsql;

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select * from diagramm');
  ADOQuery1.active := true;
  DBGrid1.Columns[0].Width := 210;
  for b := 1 to 12 do
    DBGrid1.Columns.Items[b].Width := 55;

  if openexcel = false then
  begin
    ExlApp := CreateOleObject('Excel.Application'); // ������� ������ Excel
    ExlApp.visible := false; // ������ ���� Excel ���������
    if FileExists('Statistic.xls') then
      ExlApp.Workbooks.open(getcurrentdir + '\Statistic.xls')
    else
    begin
      ExlApp.Workbooks.Add; // ������� ����� ��� ��������
      ExlApp.Worksheets[1].Name := '���������� �������� �� �����';
    end;
    ExlApp.DisplayAlerts := false; // ��������� ��� �������������� Excel
    openexcel := true;
  end;

  ExlApp.Workbooks[1].Sheets.Item[1].Activate;
  for row := 0 to DBGrid1.DataSource.DataSet.RecordCount - 1 do
  begin
    for col := 0 to DBGrid1.Columns.Count - 1 do
    begin
      ExlApp.Workbooks[1].Worksheets[1].cells[1, col + 1].value :=
        DBGrid1.Columns[col].Title.Caption;
      ExlApp.Workbooks[1].Worksheets[1].cells[row + 2, col + 1].value :=
        DBGrid1.DataSource.DataSet.Fields[col].AsString;
    end;
    DBGrid1.DataSource.DataSet.Next;
  end;
end;

procedure TForm2.UpdatebaseClick(Sender: TObject);
var
  Date, a, a1, a2, a21, a22, a23, a3, a4, a5, year: string;
begin
  Deletevalue;
  Parametrs.visible := false;
  Query.visible := false;
  Diagrammpanel.visible := false;

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add
    (' delete from year2018 where date like where date >=''2018-01-01'' and date <=''2018-12-31'';');
  ADOQuery1.execsql;

  AssignFile(f1, 'C:\Users\EldarNikel\Desktop\�����\Apache-2.4_queriesa.log');
  reset(f1);
  a23 := Messengge.MyAddIp('\w{3}\/(\d{4}.*?)', a);
  if a23 = '2018' then
  begin
    repeat
      readln(f1, a);
      a1 := Messengge.MyAddIp('alias: (.*?) ', a);
      a21 := Messengge.MyAddIp('\[(.*?)\/\w{3}\/', a);
      a22 := Messengge.MyAddIp('\/(\w{3}.*?)\/\d{4}', a);
      if a22 = 'Jan' then
        a22 := '01'
      else if a22 = 'Feb' then
        a22 := '02'
      else if a22 = 'Mar' then
        a22 := '03'
      else if a22 = 'Apr' then
        a22 := '04'
      else if a22 = 'May' then
        a22 := '05'
      else if a22 = 'Jun' then
        a22 := '06'
      else if a22 = 'Jul' then
        a22 := '07'
      else if a22 = 'Aug' then
        a22 := '08'
      else if a22 = 'Sep' then
        a22 := '09'
      else if a22 = 'Oct' then
        a22 := '10'
      else if a22 = 'Nov' then
        a22 := '11'
      else
        a22 := '12';
      a2 := a23 + '-' + a22 + '-' + a21;
      a3 := Messengge.MyAddIp('"(.*?)" (200|400|403|501|40|206)', a);
      a4 := Messengge.MyAddIp('\w" (.*?) (\w|-)', a);
      a5 := Messengge.MyAddIp('" \d{3} (.*?) "', a);
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('insert into year2018(ip,date,url,code,size) values("' +
        a1 + '", "' + a2 + '", "' + a3 + '", "' + a4 + '", "' + a5 + '")');
      ADOQuery1.execsql;
    until eof(f1);
  end;
  showmessage('���������� ���������');
  CloseFile(f1);
  // insert into year2018(ip,date,url,code,size) select ip,date,url,code,size from stable1 where date >='2018-01-01' and date <='2018-12-31'
end;

// ���������
procedure TForm2.StatisticMouseLeave(Sender: TObject);
begin
  FakeButton_MouseLeave(Sender);
end;

procedure TForm2.StatisticMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  FakeButton_MouseMove(Sender);
end;

procedure TForm2.HeadMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

procedure TForm2.CountbuttonMouseLeave(Sender: TObject);
begin
  ButtonAuthorizationLeave;
end;

procedure TForm2.CountbuttonMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ButtonAuthorizationMove;
end;

procedure TForm2.ExitClick(Sender: TObject);
var
  active: boolean;
begin
  Form1.close;
  ADOConnection1.Connected := false;
  if openexcel = true then
  begin
    try
      // ������ xls 97-2003 ���� ���������� 2003 Excel
      ExlApp.Workbooks[1].saveas(getcurrentdir + '\Statistic.xls', xlExcel9795);
    except
      // ������ xls 97-2003 ���� ���������� 2007-2010 Excel
      ExlApp.Workbooks[1].saveas(getcurrentdir + '\Statistic.xls', xlExcel8);
    end;
    ExlApp.Quit; // ��������� ���������� Excel
    ExlApp := Unassigned; // ������� ���������� ������
  end;

end;

end.
