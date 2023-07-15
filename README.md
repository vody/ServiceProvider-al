# Service Provider
It is an experiment to create a working dependency injection framework for AL

## How to use it?
### Create a service
```javascript
// Example of a service interface
interface IHttpClient
{
    procedure Get(Path: Text; var Response: HttpResponseMessage): Boolean
}

// Example of a service implementation
// IService interface should be implemented to enable registration with a service provider
codeunit 50101 MyHttpClient implements IHttpClient
{
    // IHttpClient
    procedure Get(Path: Text; var Response: HttpResponseMessage): Boolean
    begin
        exit(true)
    end;
}

// Example of a service registration
[EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', true, true)]
local procedure OnAfterLogin()
var
    ServiceProvider: Codeunit "Service Provider";
    MyHttpClient: Codeunit MyHttpClient;
begin
    ServiceProvider.AddService('IHttpClient',MyHttpClient);
end;

// Example of a service usage
local procedure GetExchangeRates()
var
    ServiceProvider: Codeunit "Service Provider";
    IHttpClient: Interface IHttpClient;
    Response: HttpResponseMessage;
begin
    IHttpClient := ServiceProvider.GetService('IHttpClient');
    IHttpClient.Get('https://example.com', Response);
end;
```

This will be perfect if it works, but it's not working, as the next line will throw an error:
```javascript
IHttpClient := ServiceProvider.GetService('IHttpClient');
```

`Cannot implicitly convert type 'Variant' to 'Interface IHttpClient (`ALAL0122)`. 
Do you know how to make it work?
