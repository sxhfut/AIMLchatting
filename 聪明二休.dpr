program OperatorChat;

uses
  Forms,
  UDebug in 'UDebug.pas' {DebugForm},
  UPatternMatcher in 'UPatternMatcher.pas',
  UAIMLLoader in 'UAIMLLoader.pas',
  UVariables in 'UVariables.pas',
  UTemplateProcessor in 'UTemplateProcessor.pas',
  UElementFactory in 'UElementFactory.pas',
  UElements in 'UElements.pas',
  UChat in 'UChat.pas' {Chat},
  UBotLoader in 'UBotLoader.pas',
  ULogging in 'ULogging.pas',
  UUtils in 'UUtils.pas';

{$R *.RES}
begin


  Application.Initialize;

  Log:=TLog.Create;
  PatternMatcher:=TPatternMatcher.Create;
  TemplateProcessor:=TTemplateProcessor.Create;
  Memory:=Tmemory.create;
  AIMLLoader:=TAIMLLoader.create;
  BotLoader:=TBotLoader.Create;
  Preprocessor:=TSimpleSubstituter.create;
  //ElementFactory:=TElementFactory.Create; {auto create when loading units}
  //TBotloaderThread.Create(false);

  Application.Title := '´ÏÃ÷¶þÐÝ';
  Application.CreateForm(TChat, Chat);
  Application.CreateForm(TDebugForm, DebugForm);
  Application.Run;


  PatternMatcher.Free;
  TemplateProcessor.Free;

  Memory.Free;
  AIMLLoader.Free;
  BotLoader.Free;
  ElementFactory.Free;
  log.Free;
  preprocessor.Free;

end.
