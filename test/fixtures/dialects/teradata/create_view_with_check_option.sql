CREATE VIEW DBC.ZonesVX
AS
    SELECT Zones.ZoneName (NAMED ZoneName),
        DB1.DatabaseName (NAMED RootName),
        Zones.RootType (NAMED RootType),
        DB2.DatabaseName (NAMED ZoneDBAName),
        DB3.DatabaseName (NAMED CreatorName),
        Zones.CreateTimeStamp (NAMED CreateTimeStamp)
    FROM DBC.Zones
        LEFT OUTER JOIN DBC.Dbase DB1
        ON DBC.Zones.ZoneRootID = DB1.DatabaseID
        LEFT OUTER JOIN DBC.Dbase DB2
        ON DBC.Zones.ZoneDBAId = DB2.DatabaseID
        LEFT OUTER JOIN DBC.Dbase DB3
        ON DBC.Zones.CreateUID = DB3.DatabaseID
    WHERE DB3.DatabaseId = TD_AUTHID
WITH CHECK OPTION;