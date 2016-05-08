unit UVariables;
{变量处理}

interface
uses classes,UPatternMatcher;
type
  TMemory=class
    vars:TStringList;
    props:TStringList;
    bot_ID:string;   
    //Match:TMatch;
    constructor create;
    destructor Destroy; override;
    procedure setVar(name,value:string); overload; virtual;
    procedure setVar(name:string;index:integer;value:string); overload; virtual;
    function getVar(name:string):string; overload; virtual;
    function getVar(name:string;index:integer):string; overload; virtual;
    procedure ClearVars;


    function getProp(name:string):string;
    procedure setProp(name,value:string);

    Procedure Save;
    Procedure Load;

    function unDelimitChinese(s:string):string;
  end;
var Memory:Tmemory;
implementation
uses sysutils,ULogging;
  constructor TMemory.Create;
    begin
      inherited Create;
      vars:=TStringList.Create;
      vars.Duplicates:=dupError;
      vars.Sorted:=False;
      Props:=TStringList.Create;
      Props.Duplicates:=dupError;
      Props.Sorted:=False;
    end;
  destructor TMemory.Destroy;
    begin
      Save;
      vars.Free;
      inherited Destroy;
    end;

  function TMemory.unDelimitChinese(s:string):string;
    //中文字符处理完后的去空格处理
    var
      i:longint;
    begin
      result:=s;
      i:=1;
      while i<length(result)-1 do
        begin
          if ord(result[i]) in [$81..$FF] then //GB 码
            if result[i+2]=' ' then
              begin
                delete(result,i+2,1);
                dec(i);
              end
            else
              inc(i);
          inc(i);
        end;
      result:=Trim(result);
    end;

  procedure TMemory.setVar(name,value:string);
    //设置变量值
    begin
      setVar(name,0,value);
    end;
  procedure TMemory.setVar(name:string;index:integer;value:string);
    //设置带索引的变量值
    begin
      name:=name+'['+inttostr(index)+']';
      vars.values[name]:=unDelimitChinese(value);  //变量存入前应进行中文去空格处理
    end;

  function TMemory.getVar(name:string):string;
    //获取变量值
    begin
      result:=getVar(name,0);  //索引默认为0
    end;
  function TMemory.getVar(name:string;index:integer):string;
    //获取带索引的变量值
    begin
      name:=name+'['+inttostr(index)+']';
      result:=vars.Values[name];
    end;
  procedure TMemory.setprop(name,value:string);
    begin
      props.values[name]:=value;
    end;
  function TMemory.getProp(name:string):string;
    begin
      result:=props.Values[name];
    end;
  procedure TMemory.ClearVars;
    //清除所有变量
    begin
      vars.Clear;
    end;

  Procedure TMemory.Save;
    //保存所有变量
    var filename:string;
    begin
      filename:=bot_id+'.variables';
      Log.Log('variables','正在保存机器人 '+bot_id+' 的变量');
      try
        Vars.SaveToFile(filename);
      except
        Log.Log('variables','错误：不能保存变量');
      end;
    end;
  Procedure TMemory.Load;
    //加载变量
    var
      filename:string;
    begin
      filename:=bot_id+'.variables';
      if fileexists(filename) then begin  //文件存在则加载
      //  Log.Log('variables','正在加载机器人 '+bot_id+' 的变量');
        Vars.LoadFromFile(filename);
      end;
    end;

end.
