table 50100 Service
{
    Access = Internal;
    TableType = Temporary;

    fields
    {
        field(1; InterfaceName; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(2; ClientPublisher; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(3; ClientAppID; Guid)
        {
            DataClassification = SystemMetadata;
        }
        field(4; Index; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; InterfaceName, ClientPublisher, ClientAppID)
        {
            Clustered = true;
        }
    }
}