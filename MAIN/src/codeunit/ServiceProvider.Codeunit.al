

codeunit 50100 "Service Provider"
{
    SingleInstance = true;

    var
        [NonDebuggable]
        ServiceDictionary: Dictionary of [Text, Integer];
        ServiceArray: array[10] of Variant;
        ServiceArrayLastIndex: Integer;

    procedure AddService(InterfaceName: Text[250]; Service: Variant): Codeunit "Service Provider"
    var
        CallerModuleInfo: ModuleInfo;
    begin
        NavApp.GetCallerModuleInfo(CallerModuleInfo);
        exit(AddService(InterfaceName, ConvertModuleInfoToProvider(CallerModuleInfo), Service));
    end;

    [NonDebuggable]
    local procedure AddService(InterfaceName: Text[250]; Provider: Text; Service: Variant): Codeunit "Service Provider"
    var
        ServiceProvider: Codeunit "Service Provider";
    begin
        ServiceArrayLastIndex += 1;
        ServiceArray[ServiceArrayLastIndex] := Service;
        ServiceDictionary.Add(InterfaceName + Provider, ServiceArrayLastIndex);
        exit(ServiceProvider)
    end;

    procedure GetService(InterfaceName: Text[250]): Variant
    var
        CallerModuleInfo: ModuleInfo;
    begin
        NavApp.GetCallerModuleInfo(CallerModuleInfo);
        exit(GetService(InterfaceName, ConvertModuleInfoToProvider(CallerModuleInfo)))
    end;

    [NonDebuggable]
    procedure GetService(InterfaceName: Text[250]; Provider: Text): Variant
    var
        Index: Integer;
    begin
        if not ServiceDictionary.Get(InterfaceName + Provider, Index) then
            exit;
        exit(ServiceArray[Index])
    end;

    local procedure ConvertModuleInfoToProvider(ClientModuleInfo: ModuleInfo): Text
    begin
        exit(Format(ClientModuleInfo.PackageId, 0, 4).ToLower())
    end;
}