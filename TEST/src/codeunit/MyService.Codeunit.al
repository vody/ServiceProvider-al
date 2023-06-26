codeunit 50201 "MyService" implements IMyService
{
    var
        GlobalValue: Text;

    procedure SetValue(NewValue: Text)
    begin
        GlobalValue := NewValue;
    end;

    procedure GetValue(): Text
    begin
        exit(GlobalValue)
    end;
}