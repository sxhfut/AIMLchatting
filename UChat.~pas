unit UChat;
{用户界面}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, UBotloader,UUtils, XPMan, jpeg;

type
  TChat = class(TForm)
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    XPManifest1: TXPManifest;
    Image1: TImage;
    // the 'main' method, sends user input for matching & processing the result
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RichEdit1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    _LoaderThread:TBotLoaderThread;
    _SentenceSplitter:TStringTokenizer;
    Procedure Add(s:string);
    { Private declarations }
  public
    Procedure AddUserInput(s:string);
    Procedure AddBotReply(s:string);
    Procedure AddLogMessage(s:string);
    { Public declarations }
  end;

var
  Chat: TChat;

implementation
Uses
  UPatternMatcher,UTemplateProcessor,UVariables,ULogging,LibXMLParser;

  Procedure TChat.Add(s:string);
    begin
      RichEdit1.Lines.Add(s);
      RichEdit1.SelStart:=Length(RichEdit1.TExt);
      SendMessage(RichEdit1.Handle,EM_SCROLLCARET,0,0);
    end;
  Procedure TChat.AddUserInput(s:string);
    var name:string;
    begin

      RichEdit1.SelStart:=Length(RichEdit1.TExt);
      with RichEdit1.SelAttributes do begin
          Color := clMaroon;
          Style := [];
      end;
      //Add('> '+s);
      name:=Memory.getVar('name');
      if name='' then name:='用户';
      Add(name + '说：'+s) ;
      Log.chatlog(name,s);
    end;
  Procedure TChat.AddBotReply(s:string);
    begin
      if s='' then exit;
      RichEdit1.SelStart:=Length(RichEdit1.TExt);
      with RichEdit1.SelAttributes do begin
          Color := clBlack;
          Style := [];
      end;
      Add('聪明二休说： '+s);
      if Memory.GetProp('name')<>'' then
       Log.Chatlog(Memory.GetProp('name'),s)
      else
       Log.Chatlog('机器人',s);
    end;
  Procedure TChat.AddLogMessage(s:string);
    begin
      RichEdit1.SelStart:=Length(RichEdit1.TExt);
      with RichEdit1.SelAttributes do begin
          Color := clBlue;
          Style := [];
      end;
      Add(s);
    end;
{$R *.DFM}

procedure TChat.Button1Click(Sender: TObject);
var
  reply:string;
  Match:TMatch;
  input:String;
  i:integer;
begin
  input:=Memo1.Text;
  AddUserInput(input);
  Memory.setVar('input',input);
  input:=Trim(ConvertWS(Preprocessor.process(' '+input+' '),true));

  _SentenceSplitter.SetDelimiter(SentenceSplitterChars); {update, if we're still loading}
  _SentenceSplitter.Tokenize(input);

  for i:=0 to _SentenceSplitter._count-1 do begin
    input:=Trim(_SentenceSplitter._tokens[i]);
    Match:=PatternMatcher.MatchInput(input);
    reply:=TemplateProcessor.Process(match);
    match.free;
  end;

  AddBotReply(reply);
  //AddLogMessage('Nodes traversed: '+inttostr(PatternMatcher._matchfault));
  Add('');
  reply:=PreProcessor.process(reply);
  _SentenceSplitter.SetDelimiter(SentenceSplitterChars);
  _SentenceSplitter.Tokenize(reply);

  Memory.setVar('that',_SentenceSplitter.GetLast);
  Memo1.Clear;
end;

procedure TChat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.TErminate;
end;

procedure TChat.FormCreate(Sender: TObject);
begin
  Log.Log('系统正在启动...');
  Log.Flush;
  Log.Log(' ');
  Log.Flush;
   _LoaderThread:=TBotLoaderThread.Create(true);
  //BotLoader.load('startup.xml');
  _LoaderThread.Resume;
  _SentenceSplitter:=TStringTokenizer.Create(SentenceSplitterChars);
  Log.Log('聪明二休说： 我是聪明二休，有谁和我聊天？');
  Log.Flush;
end;

procedure TChat.RichEdit1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  SendMessage(RichEdit1.Handle,EM_LINESCROLL,0,-(WheelDelta div 120)*Mouse.WheelScrollLines);
  handled:=true;
end;

end.
