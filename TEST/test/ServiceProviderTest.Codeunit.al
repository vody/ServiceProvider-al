codeunit 50200 "ServiceProviderTest"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        ServiceProvider: Codeunit "Service Provider";

    [Test]
    procedure SimpleTest()
    var
        MyServiceCodeunit: Codeunit MyService;
        IMyService: Interface IMyService;
        ValueText: Text;
    begin
        // CURRENT STATE
        // ServiceProvider.SetService: add `MyServiceCodeunit` implementation of `IMyService` interface into Variant
        // MyServiceVariant := MyServiceCodeunit; // OK
        // MyServiceVariant := IMyService; // Runtime error: The requested operation is not supported.

        // ServiceProvider.GetService: return Variant into `IMyService` interface
        // IMyService := MyServiceVariant; // Cannot implicitly convert type 'Variant' to 'Interface IMyService'

        // [GIVEN] Service defined with initiated state and added to service provider
        ValueText := 'Some state';
        MyServiceCodeunit.SetValue(ValueText);
        ServiceProvider.AddService('IMyService', MyServiceCodeunit);
        // [WHEN] Getting service from service provider
        // IMyService := ServiceProvider.GetService('IMyService'); // Cannot implicitly convert type 'Variant' to 'Interface IMyService'
        // [THEN] Service provider was able to return service with a state as it was originally defined
        Assert.AreEqual(5, IMyService.GetValue(), ValueText);
    end;
}