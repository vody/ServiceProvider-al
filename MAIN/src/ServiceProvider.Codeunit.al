codeunit 50100 "Service Provider"
{
    SingleInstance = true;

    var
        TempService: Record Service temporary;
        ServiceCollection: array[10] of Variant;
        ServiceCollectionLastIndex: Integer;

    /// <summary>
    /// Tries to add service to current runtime and enable only caller to use it
    /// </summary>
    /// <param name="Service">Codeunit which implements IService interface</param>
    /// <returns>Indicates if system manages to add a new service</returns>
    procedure TryAddService(Service: Interface IService): Boolean
    var
        CallerModuleInfo: ModuleInfo;
    begin
        NavApp.GetCallerModuleInfo(CallerModuleInfo);
        exit(TryAddService(Service, CallerModuleInfo.Publisher, CallerModuleInfo.Id));
    end;

    /// <summary>
    /// Tries to add service to current runtime and enable spesific app to use it
    /// </summary>
    /// <param name="Service">Codeunit which implements IService interface</param>
    /// <param name="ClientModuleInfo">ModuleInfo of the app which will be allowed to use it</param>
    /// <returns>Indicates if system manages to add a new service</returns>
    procedure TryAddService(Service: Interface IService; ClientModuleInfo: ModuleInfo): Boolean
    begin
        exit(TryAddService(Service, ClientModuleInfo.Publisher, ClientModuleInfo.Id));
    end;

    /// <summary>
    /// Tries to add service to current runtime and enable all apps from spesific publisher to use it
    /// </summary>
    /// <param name="Service">Codeunit which implements IService interface</param>
    /// <param name="ClientPublisher">Client apps pusblisher</param>
    /// <returns>Indicates if system manages to add a new service</returns>
    procedure TryAddService(Service: Interface IService; ClientPublisher: Text[250]): Boolean
    var
        NullAppID: Guid;
    begin
        exit(TryAddService(Service, ClientPublisher, NullAppID));
    end;

    local procedure TryAddService(Service: Interface IService; ClientPublisher: Text[250]; ClientAppID: Guid): Boolean
    begin
        ServiceCollectionLastIndex += 1;
        ServiceCollection[ServiceCollectionLastIndex] := Service;
        TempService.Init();
        TempService.InterfaceName := Service.GetInterfaceName();
        TempService.ClientPublisher := ClientPublisher;
        TempService.ClientAppID := ClientAppID;
        TempService.Index := ServiceCollectionLastIndex;
        exit(TempService.Insert())
    end;

    /// <summary>
    /// Returns previusly added service to client
    /// </summary>
    /// <param name="InterfaceName">Name of the service interface to return</param>
    /// <returns>Service instance</returns>
    procedure GetService(InterfaceName: Text[250]): Variant
    var
        CallerModuleInfo: ModuleInfo;
        NullAppID: Guid;
    begin
        NavApp.GetCallerModuleInfo(CallerModuleInfo);
        if not TempService.Get(InterfaceName, CallerModuleInfo.Publisher, CallerModuleInfo.Id) then
            if not TempService.Get(InterfaceName, CallerModuleInfo.Publisher, NullAppID) then
                if not TempService.Get(InterfaceName, '', NullAppID) then
                    exit;

        exit(ServiceCollection[TempService.Index]);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnStartup()
    begin
    end;
}