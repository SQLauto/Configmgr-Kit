SELECT CIDM.ManufacturerName,CIDM.ModelName, CICI.ContentSourcePath, CIDCI.DriverDate, CIDCI.DriverClass, CIDCI.DriverVersion, CIDCI.DriverProvider
  FROM v_CI_DriverModels CIDM
  join vCI_ConfigurationItems CICI on CIDM.CI_UniqueID=CICI.CI_UniqueID
  join v_CI_DriversCIs CIDCI on CIDM.CI_UniqueID=CIDCI.CI_UniqueID
  Order by CIDM.ManufacturerName,CIDM.ModelName