unit uNutzerliste;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql57conn, sqldb, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    EDevice: TEdit;
    ETime: TEdit;
    EUser: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FData : TStringList;
    function  GetCurrentUserName : String;
    function  GetHostName : String;
    function  GetMemoText : String;
    procedure SaveData;
    procedure GetDataFromEnv;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


function TForm1.GetCurrentUserName : String;
const maxLen = 254;
  var userName:String;
      userNameLen : DWORD;
begin
  userNameLen := maxLen - 1;
  SetLength( userName, userNameLen );
  GetUsername( PChar(userName), usernameLen );
  SetLength( userName, usernameLen );
  result := username;
end;

function  TForm1.GetHostName : String;
const maxLen = 254;
  var hostname:String;
      nameLen : DWORD;
begin
  nameLen := maxLen - 1;
  SetLength( hostname, nameLen );
  GetComputername( PChar(hostname), nameLen );
  SetLength( hostname, nameLen );
  result := hostname;
end;

function TForm1.GetMemoText : String;
var i:integer;
begin
  result := '';
  for i:=0 to Memo1.Lines.Count-1 do
    result := result + Memo1.Lines[i] + ' ';
  result := trim( result );
end;

procedure TForm1.SaveData;
var filename, s : String;
begin
  s := QuotedStr( EDevice.Text ) + ';' +
       QuotedStr( ETime.Text ) + ';' +
       QuotedStr( EUser.Text ) + ';' +
       QuotedStr( GetMemoText );

  filename := ChangeFileExt( Application.ExeName, '.dat' );
  if FileExists( filename ) then FData.LoadFromFile( filename );
  FData.Add( s );
  FData.SaveToFile( filename );
end;

procedure TForm1.GetDataFromEnv;
begin
  EDevice.Text := GetHostname;
  ETime.Text   := DateTimeToStr( Now );
  EUser.Text   := GetCurrentUserName; //'Benutzername';



end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  close;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Memo1.SetFocus;;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SaveData;
  FreeAndNIL( FData );
  CloseAction := caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FData := TStringList.Create;
  GetDataFromEnv;
end;

end.

