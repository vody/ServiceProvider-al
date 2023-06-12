# Service Provider
It is an experiment to create a working dependency injection framework for AL

## How to use it?
### Create a service
```javascript
// Example of an service interface
interface IHttpClient
{
    procedure Get(Path: Text; var Response: HttpResponseMessage): Boolean
}

// Example of a service implementation
// IService interface should be implemented to enables registration with a service provider
codeunit 50101 MyHttpClient implements IHttpClient, IService
{
    // IHttpClient
    procedure Get(Path: Text; var Response: HttpResponseMessage): Boolean
    begin
        exit(true)
    end;

    // IService
    procedure GetInterfaceName(): Text[250]
    begin
        exit('IHttpClient')
    end;
}

// Example of a service registration
[EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', true, true)]
local procedure OnAfterLogin()
var
    ServiceProvider: Codeunit "Service Provider";
    MyHttpClient: Codeunit MyHttpClient;
begin
    ServiceProvider.TryAddService(MyHttpClient);
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

This will be perfect if it works, but it's not working as the next line will throw an error:
```javascript
IHttpClient := ServiceProvider.GetService('IHttpClient');
```

`Cannot implicitly convert type 'Variant' to 'Interface IHttpClient (`ALAL0122)`. 
Maybe you know how to make it work?

Of course, you can write a conversion function, but this destroys the whole idea.