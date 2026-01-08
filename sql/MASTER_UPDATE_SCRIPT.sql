-- ============================================================================
-- MASTER UPDATE SCRIPT FOR TILLDBWeb_Prod
-- ============================================================================
-- 
-- This script combines all database updates:
-- 1. Adds new fields to existing tables
-- 2. Creates catMassHealthServiceLevels table
-- 3. Updates spApp_DataImportFromTILLDB_Cat procedure
-- 4. Updates spApp_DataImportFromTILLDB_People procedure
-- 
-- Database: TILLDBWeb_Prod
-- Schema: dbo
-- 
-- IMPORTANT: 
-- 1. Execute this script against TILLDBWeb_Prod database
-- 2. Test in a non-production environment first!
-- 3. Backup the database before making changes
-- 4. Review all changes before executing
-- ============================================================================

USE TILLDBWeb_Prod;
GO

PRINT '';
PRINT '============================================================================';
PRINT 'MASTER UPDATE SCRIPT - Starting Execution';
PRINT '============================================================================';
PRINT '';

-- ============================================================================
-- SECTION 1: ADD NEW FIELDS TO EXISTING TABLES
-- ============================================================================

PRINT 'SECTION 1: Adding new fields to existing tables...';
PRINT '';

GO

-- ============================================================================
-- Table: catStaffEmailAddresses
-- New Fields: 2
-- ============================================================================
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'catStaffEmailAddresses' 
    AND COLUMN_NAME = 'CityTown'
)
BEGIN
    ALTER TABLE dbo.catStaffEmailAddresses
    ADD CityTown NVARCHAR(50) NULL;
    PRINT 'Added column CityTown to catStaffEmailAddresses';
END
ELSE
BEGIN
    PRINT 'Column CityTown already exists in catStaffEmailAddresses';
END
GO

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'catStaffEmailAddresses' 
    AND COLUMN_NAME = 'Location'
)
BEGIN
    ALTER TABLE dbo.catStaffEmailAddresses
    ADD Location NVARCHAR(80) NULL;
    PRINT 'Added column Location to catStaffEmailAddresses';
END
ELSE
BEGIN
    PRINT 'Column Location already exists in catStaffEmailAddresses';
END
GO

-- ============================================================================
-- Table: tblPeopleClientsDayServices
-- New Fields: 3
-- ============================================================================
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleClientsDayServices' 
    AND COLUMN_NAME = 'LevelUpdatedWhen'
)
BEGIN
    ALTER TABLE dbo.tblPeopleClientsDayServices
    ADD LevelUpdatedWhen NVARCHAR(10) NULL;
    PRINT 'Added column LevelUpdatedWhen to tblPeopleClientsDayServices';
END
ELSE
BEGIN
    PRINT 'Column LevelUpdatedWhen already exists in tblPeopleClientsDayServices';
END
GO

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleClientsDayServices' 
    AND COLUMN_NAME = 'LevelUpdatedWho'
)
BEGIN
    ALTER TABLE dbo.tblPeopleClientsDayServices
    ADD LevelUpdatedWho NVARCHAR(30) NULL;
    PRINT 'Added column LevelUpdatedWho to tblPeopleClientsDayServices';
END
ELSE
BEGIN
    PRINT 'Column LevelUpdatedWho already exists in tblPeopleClientsDayServices';
END
GO

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleClientsDayServices' 
    AND COLUMN_NAME = 'MassHealthServiceLevel'
)
BEGIN
    ALTER TABLE dbo.tblPeopleClientsDayServices
    ADD MassHealthServiceLevel NVARCHAR(25) NULL;
    PRINT 'Added column MassHealthServiceLevel to tblPeopleClientsDayServices';
END
ELSE
BEGIN
    PRINT 'Column MassHealthServiceLevel already exists in tblPeopleClientsDayServices';
END
GO

-- ============================================================================
-- Table: tblPeopleDayAttendance
-- New Fields: 1
-- ============================================================================
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleDayAttendance' 
    AND COLUMN_NAME = 'MassHealthServiceLevel'
)
BEGIN
    ALTER TABLE dbo.tblPeopleDayAttendance
    ADD MassHealthServiceLevel NVARCHAR(25) NULL;
    PRINT 'Added column MassHealthServiceLevel to tblPeopleDayAttendance';
END
ELSE
BEGIN
    PRINT 'Column MassHealthServiceLevel already exists in tblPeopleDayAttendance';
END
GO

-- ============================================================================
-- Table: tblPeopleScheduledStaffChanges
-- New Fields: 4
-- ============================================================================
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleScheduledStaffChanges' 
    AND COLUMN_NAME = 'AddMidInitial'
)
BEGIN
    ALTER TABLE dbo.tblPeopleScheduledStaffChanges
    ADD AddMidInitial NVARCHAR(1) NULL;
    PRINT 'Added column AddMidInitial to tblPeopleScheduledStaffChanges';
END
ELSE
BEGIN
    PRINT 'Column AddMidInitial already exists in tblPeopleScheduledStaffChanges';
END
GO

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleScheduledStaffChanges' 
    AND COLUMN_NAME = 'CurrentMidinitial'
)
BEGIN
    ALTER TABLE dbo.tblPeopleScheduledStaffChanges
    ADD CurrentMidinitial NVARCHAR(1) NULL;
    PRINT 'Added column CurrentMidinitial to tblPeopleScheduledStaffChanges';
END
ELSE
BEGIN
    PRINT 'Column CurrentMidinitial already exists in tblPeopleScheduledStaffChanges';
END
GO

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleScheduledStaffChanges' 
    AND COLUMN_NAME = 'DeleteMidInitial'
)
BEGIN
    ALTER TABLE dbo.tblPeopleScheduledStaffChanges
    ADD DeleteMidInitial NVARCHAR(1) NULL;
    PRINT 'Added column DeleteMidInitial to tblPeopleScheduledStaffChanges';
END
ELSE
BEGIN
    PRINT 'Column DeleteMidInitial already exists in tblPeopleScheduledStaffChanges';
END
GO

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'tblPeopleScheduledStaffChanges' 
    AND COLUMN_NAME = 'NewMidInitial'
)
BEGIN
    ALTER TABLE dbo.tblPeopleScheduledStaffChanges
    ADD NewMidInitial NVARCHAR(1) NULL;
    PRINT 'Added column NewMidInitial to tblPeopleScheduledStaffChanges';
END
ELSE
BEGIN
    PRINT 'Column NewMidInitial already exists in tblPeopleScheduledStaffChanges';
END
GO

-- ============================================================================
-- Script Complete
-- ============================================================================
PRINT '';
PRINT '============================================================================';
PRINT 'All new fields have been processed.';
PRINT 'Please verify the changes before using in production.';
PRINT '============================================================================';
GO


-- ============================================================================
-- SECTION 2: CREATE catMassHealthServiceLevels TABLE
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'SECTION 2: Creating catMassHealthServiceLevels table...';
PRINT '';

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'catMassHealthServiceLevels'
)
BEGIN
    CREATE TABLE dbo.[catMassHealthServiceLevels]
    (
        [MassHealthServiceLevel] NVARCHAR(25) NOT NULL,
        CONSTRAINT [PK_catMassHealthServiceLevels] PRIMARY KEY ([MassHealthServiceLevel])
    );
    PRINT '  Table catMassHealthServiceLevels created successfully.';
END
ELSE
BEGIN
    PRINT '  Table catMassHealthServiceLevels already exists.';
END
GO

PRINT '';
PRINT 'SECTION 2 Complete: catMassHealthServiceLevels table created';
PRINT '';

-- ============================================================================
-- SECTION 3: UPDATE spApp_DataImportFromTILLDB_Cat PROCEDURE
-- ============================================================================

PRINT '============================================================================';
PRINT 'SECTION 3: Updating spApp_DataImportFromTILLDB_Cat procedure...';
PRINT '';

ALTER PROCEDURE [dbo].[spApp_DataImportFromTILLDB_Cat]
 [dbo].[spApp_DataImportFromTILLDB_Cat]

as

begin

    if (1 = 0)

    begin

        exec dbo.TransferDataBetweenDatabasesWithDynamicMapping 'TILLDB',

                                                                'tblPeopleClientsCLOServices',

                                                                'TILLWebDB_DEV',

                                                                'tblPeopleClientsCLOServices';

        exec [dbo].[spApp_DataImportFromTILLDB_Cat];

    end;



    delete from dbo.appParameters;

    delete from dbo.[catAddressMatchCodes];

    delete from dbo.[catAutismGeneralDiagnoses];

    delete from dbo.[catAutismReferralReasons];

    delete from dbo.[catBowlingLeagues];

    delete from dbo.[catClientSubcategories];

    delete from dbo.[catClusters];

    delete from dbo.[catContractDirectors];

    delete from dbo.[catCounties];

    delete from dbo.[catDDSAreasAndRegions];

    delete from dbo.[catDepartments];

    delete from dbo.[catDonationSolicitationTypes];

    delete from dbo.[catDTAOffices];

    delete from dbo.[catExpirationTriggers];

    delete from dbo.[catFamilyRelationships];

    delete from dbo.[catFillInNames];

    delete from dbo.[catGenders];

    delete from dbo.[catInterestedPartyCategories];

    delete from dbo.[catLegalStatus];

    delete from dbo.[catMonthAbbreviations];

    delete from dbo.[catMonths];

    delete from dbo.[catMassHealthServiceLevels];

    delete from dbo.[catRaces];

    delete from dbo.[catReferralSource];

    delete from dbo.[catSalutations];

    delete from dbo.[catSeverityRates];

    delete from dbo.[catSkills];

    delete from dbo.[catStaffEmailAddresses];

    delete from dbo.[catStateAbbreviations];

    delete from dbo.[catUserPermissions];



    insert into dbo.appParameters

    (

        ParameterName,

        ParameterValue

    )

    select ParameterName,

           ParameterValue

    from ext.appParameters;



    insert into dbo.[catAddressMatchCodes]

    (

        [MatchCode],

        [Description]

    )

    select [MatchCode],

           [Description]

    from ext.[catAddressMatchCodes];



    insert into dbo.[catAutismGeneralDiagnoses]

    (

        [ID],

        [GeneralDiagnosis]

    )

    select [ID],

           [GeneralDiagnosis]

    from ext.[catAutismGeneralDiagnoses];



    insert into dbo.[catAutismReferralReasons]

    (

        [ID],

        [ReasonForReferral]

    )

    select [ID],

           [ReasonForReferral]

    from ext.[catAutismReferralReasons];



    insert into dbo.[catBowlingLeagues]

    (

        [LeagueName]

    )

    select [LeagueName]

    from ext.[catBowlingLeagues];



    insert into dbo.[catClientSubcategories]

    (

        [Subcategory]

    )

    select [Subcategory]

    from ext.[catClientSubcategories];



    insert into dbo.[catClusters]

    (

        [ClusterID],

        [ClusterName],

        [ClusterManagerLastName],

        [ClusterManagerFirstName],

        [ClusterManagerMiddleInitial],

        [ClusterManagerDID],

        [ClusterManagerCell],

        [ClusterDirectorLastName],

        [ClusterDirectorFirstName],

        [ClusterDirectorMiddleInitial],

        [ClusterDirectorDID],

        [ClusterEmergencyCell]

    )

    select [ClusterID],

           [ClusterName],

           [ClusterManagerLastName],

           [ClusterManagerFirstName],

           [ClusterManagerMiddleInitial],

           [ClusterManagerDID],

           [ClusterManagerCell],

           [ClusterDirectorLastName],

           [ClusterDirectorFirstName],

           [ClusterDirectorMiddleInitial],

           [ClusterDirectorDID],

           [ClusterEmergencyCell]

    from ext.[catClusters];



    insert into dbo.[catContractDirectors]

    (

        [DirectorName]

    )

    select [DirectorName]

    from ext.[catContractDirectors];



    insert into dbo.[catCounties]

    (

        [State],

        [CityTown],

        [County]

    )

    select [State],

           [CityTown],

           [County]

    from ext.[catCounties];



    insert into dbo.[catDDSAreasAndRegions]

    (

        [CityTown],

        [Area],

        [Region]

    )

    select [CityTown],

           [Area],

           [Region]

    from ext.[catDDSAreasAndRegions];



    insert into dbo.[catDepartments]

    (

        [DeptName],

        [UseCode]

    )

    select [DeptName],

           [UseCode]

    from ext.[catDepartments];



    insert into dbo.[catDepartments]

    (

        [DeptName],

        [UseCode]

    )

    select 'Expirations Reporting',

           1;



    insert into dbo.[catDonationSolicitationTypes]

    (

        [SolType]

    )

    select [SolType]

    from ext.[catDonationSolicitationTypes];



    insert into dbo.[catDTAOffices]

    (

        [DTAOffice]

    )

    select [DTAOffice]

    from ext.[catDTAOffices];





    set identity_insert dbo.[catExpirationTriggers] on;

    insert into dbo.[catExpirationTriggers]

    (

        [ID],

        [Program],

        [Section],

        [FieldName],

        [Abbreviation],

        [Red],

        [Green],

        [Units]

    )

    select [ID],

           [Program],

           [Section],

           [FieldName],

           [Abbreviation],

           [Red],

           [Green],

           [Units]

    from ext.[catExpirationTriggers];

    set identity_insert dbo.[catExpirationTriggers] off;





    insert into dbo.[catFamilyRelationships]

    (

        [Relationship]

    )

    select [Relationship]

    from ext.[catFamilyRelationships];



    insert into dbo.[catFillInNames]

    (

        [Category],

        [WhoGetsIt],

        [EmailAddress],

        [PhoneNumber]

    )

    select [Category],

           [WhoGetsIt],

           [EmailAddress],

           [PhoneNumber]

    from ext.[catFillInNames];



    insert into dbo.[catGenders]

    (

        [Gender],

        [Description]

    )

    select [Gender],

           [Description]

    from ext.[catGenders];



    insert into dbo.[catInterestedPartyCategories]

    (

        [Category]

    )

    select [Category]

    from ext.[catInterestedPartyCategories];



    insert into dbo.[catLegalStatus]

    (

        [LegalStatus]

    )

    select [LegalStatus]

    from ext.[catLegalStatus];



    insert into dbo.[catMonthAbbreviations]

    (

        [MonthNum],

        [MonthID],

        [MonthName]

    )

    select [MonthNum],

           [MonthID],

           [MonthName]

    from ext.[catMonthAbbreviations];



    insert into dbo.[catMonths]

    (

        [MonthNum],

        [MonthID],

        [MonthName]

    )

    select [MonthNum],

           [MonthID],

           [MonthName]

    from ext.[catMonths];



    insert into dbo.[catMassHealthServiceLevels]

    (

        [MassHealthServiceLevel]

    )

    select [MassHealthServiceLevel]

    from ext.[catMassHealthServiceLevels];



    insert into dbo.[catRaces]

    (

        [Race],

        [FederalOMBDescription]

    )

    select [Race],

           [FederalOMBDescription]

    from ext.[catRaces];



    insert into dbo.[catReferralSource]

    (

        [ID],

        [ReferralSource]

    )

    select [ID],

           [ReferralSource]

    from ext.[catReferralSource];



    insert into dbo.[catSalutations]

    (

        [Salutation]

    )

    select [Salutation]

    from ext.[catSalutations];



    insert into dbo.[catSeverityRates]

    (

        [Severity],

        [MedicaidRate],

        [LowScore],

        [HighScore]

    )

    select [Severity],

           [MedicaidRate],

           [LowScore],

           [HighScore]

    from ext.[catSeverityRates];



    insert into dbo.[catSkills]

    (

        [SkillID],

        [Skill]

    )

    select [SkillID],

           [Skill]

    from ext.[catSkills];



    insert into dbo.[catStaffEmailAddresses]

    (

        [UserLoginAccount],

        [EmailAddress],

        [Password],

        [Cluster],

        [UserActive],

        [CityTown],

        [Location]

    )

    select [UserLoginAccount],

           [EmailAddress],

           [Password],

           [Cluster],

           [UserActive],

           [CityTown],

           [Location]

    from ext.[catStaffEmailAddresses];



    insert into dbo.[catStateAbbreviations]

    (

        [StateAbbrev],

        [StateName]

    )

    select [StateAbbrev],

           [StateName]

    from ext.[catStateAbbreviations];



    insert into dbo.[catUserPermissions]

    (

        [Action],

        [User]

    )

    select [Action],

           [User]

    from ext.[catUserPermissions];





    update dbo.catUserPermissions

    set [User] = [User] + '@tillinc.net'





end;




GO

PRINT '';
PRINT 'SECTION 3 Complete: spApp_DataImportFromTILLDB_Cat procedure updated';
PRINT '';

-- ============================================================================
-- SECTION 4: UPDATE spApp_DataImportFromTILLDB_People PROCEDURE  
-- ============================================================================

PRINT '============================================================================';
PRINT 'SECTION 4: Updating spApp_DataImportFromTILLDB_People procedure...';
PRINT '';

ALTER PROCEDURE [dbo].[spApp_DataImportFromTILLDB_People]
 [dbo].[spApp_DataImportFromTILLDB_People]

as

begin

    if (1 = 0)

    begin

        exec dbo.TransferDataBetweenDatabasesWithDynamicMapping 'TILLDB'

                                                              , 'tblPeopleClientsCLOServices'

                                                              , 'TILLWebDB_DEV'

                                                              , 'tblPeopleClientsCLOServices';

        exec [dbo].[spApp_DataImportFromTILLDB_People];

    end;



    truncate table [tblChangeLog];

    delete from dbo.tblPeopleClientsAdultCoaching;

    delete from dbo.[tblPeopleClientsAdultCompanion];

    delete from dbo.[tblPeopleClientsAFCServices];

    delete from dbo.tblPeopleClientsAutismServices;

    delete from dbo.tblPeopleClientsCLOServices;

    delete from dbo.[tblPeopleClientsCommunityConnectionsServices];

    delete from dbo.[tblPeopleClientsDayServices];

    delete from dbo.[tblPeopleClientsDemographics];

    delete from dbo.[tblPeopleClientsDiagnoses];

    delete from dbo.[tblPeopleClientsGeneralFamilySupportServices];

    delete from dbo.[tblPeopleClientsIHBCServices];

    delete from dbo.[tblPeopleClientsIndividualSupportServices];

    delete from dbo.[tblPeopleClientsNHDay];

    delete from dbo.[tblPeopleClientsNHRes];

    delete from dbo.[tblPeopleClientsPCAServicesContactNotes];

    delete from dbo.[tblPeopleClientsPCAServices];

    delete from dbo.[tblPeopleClientsPhotos];

    delete from dbo.[tblPeopleClientsResidentialServices];

    delete from dbo.[tblPeopleClientsRespiteServices];

    delete from dbo.[tblPeopleClientsSharedLivingServices];

    delete from dbo.[tblPeopleClientsSHCServices];

    delete from dbo.[tblPeopleClientsSpringboardServices];

    delete from dbo.[tblPeopleClientsSTRATTUSServices];

    delete from dbo.[tblPeopleClientsTransportationServices];

    delete from dbo.[tblPeopleClientsTRASEServices];

    delete from dbo.[tblPeopleClientsVendors];

    delete from dbo.[tblPeopleClientsVocationalServices];

    delete from dbo.[tblPeopleConsultants];

    delete from dbo.[tblPeopleDayAttendance];

    delete from dbo.[tblPeopleDonors];

    delete from dbo.[tblPeopleFamily];

    delete from dbo.[tblPeopleScheduledStaffChanges];

    delete from dbo.[tblPeopleStaffSupervisors];

    delete from dbo.[tblPhoneDirectory];

    delete from dbo.tblMemos;

    delete from dbo.tblTILLContracts;

    delete from dbo.tblFiles

    delete from dbo.tblPeople;



    insert into dbo.[tblPhoneDirectory]

    (

        [Department]

      , [Location]

      , [LocationDetail]

      , [LastName]

      , [FirstName]

      , [EmailAddress]

      , [JobTitle]

      , [InternalExtension]

      , [HasPhoneOnDesktop]

      , [ExternalPhoneNumber]

      , [ADLoginID]

      , [GetFromTILLDB]

    )

    select [Department]

         , [Location]

         , [LocationDetail]

         , [LastName]

         , [FirstName]

         , [EmailAddress]

         , [JobTitle]

         , [InternalExtension]

         , [HasPhoneOnDesktop]

         , [ExternalPhoneNumber]

         , '' as [ADLoginID]

         , '' as [GetFromTILLDB]

    from ext.[tblPhoneDirectory];





    insert into dbo.[tblPeople]

    (

        [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [RecordLastViewedDate]

      , [RecordLastViewedBy]

      , [Salutation]

      , [LastName]

      , [FirstName]

      , [MiddleInitial]

      , [CompanyOrganization]

      , [Title]

      , [FamiliarGreeting]

      , [PhysicalAddress]

      , [PhysicalCity]

      , [PhysicalState]

      , [PhysicalZIP]

      , [PhysicalAddressValidated]

      , [CongressionalDistrict]

      , [MailingAddress]

      , [MailingCity]

      , [MailingState]

      , [MailingZIP]

      , [MailingAddressValidated]

      , [HomePhone]

      , [WorkPhone]

      , [MobilePhone]

      , [EmailAddress]

      , [OfficeCityTown]

      , [OfficeLocationName]

      , [GPSuperCode]

      , [ManagerSuperCode]

      , [StaffTitle]

      , [Department]

      , [SigningAuthority]

      , [ContractStaff]

      , [ContractOwner]

      , [DID]

      , [HasPhoneOnDesktop]

      , [StaffExtPhone]

      , [StaffPositionIsOpen]

      , [IsClient]

      , [NumFamily]

      , [IsClientDay]

      , [DayLocation]

      , [IsClientRes]

      , [ResLocation]

      , [IsClientTrans]

      , [IsClientVocat]

      , [VocLocation]

      , [IsClientSHC]

      , [IsClientSharedLiving]

      , [IsClientAFC]

      , [IsCilentCLO]

      , [CLOLocation]

      , [IsClientIndiv]

      , [IsClientAdultComp]

      , [IsClientAdultCoach]

      , [IsClientNHDay]

      , [IsClientNHRes]

      , [IsClientAutism]

      , [IsClientPCA]

      , [IsClientIHBC]

      , [IsClientSpring]

      , [IsClientTRASE]

      , [IsClientSTRATTUS]

      , [IsClientCommunityConnections]

      , [IsClientGeneralFS]

      , [IsFamilyGuardian]

      , [IsDonor]

      , [NumDonations]

      , [IsInterestedParty]

      , [IsStaff]

      , [StaffLocation]

      , [IsConsultant]

      , [IsDeceased]

      , [DeceasedDate]

      , [DirectoryOnly]

      , [ClientCompletelyInactive]

      , [ClientCompletelyInactiveDate]

      , [PersonCompletelyInactive]

      , [InterestedPartyCategory]

      , [InterestedPartyInactive]

      , [TILLEGram]

      , [NoMailings]

      , [NoSolicitations]

      , [GoGreen]

      , [Comment]

      , [ErrorMessages]

      , [FlagForDeletion]

    )

    select [IndexedName]

         , [RecordAddedDate]

         , [RecordAddedBy]

         , [RecordLastViewedDate]

         , [RecordLastViewedBy]

         , [Salutation]

         , [LastName]

         , [FirstName]

         , [MiddleInitial]

         , [CompanyOrganization]

         , [Title]

         , [FamiliarGreeting]

         , [PhysicalAddress]

         , [PhysicalCity]

         , [PhysicalState]

         , [PhysicalZIP]

         , [PhysicalAddressValidated]

         , [CongressionalDistrict]

         , [MailingAddress]

         , [MailingCity]

         , [MailingState]

         , [MailingZIP]

         , [MailingAddressValidated]

         , [HomePhone]

         , [WorkPhone]

         , [MobilePhone]

         , [EmailAddress]

         , [OfficeCityTown]

         , [OfficeLocationName]

         , [GPSuperCode]

         , [ManagerSuperCode]

         , [StaffTitle]

         , [Department]

         , [SigningAuthority]

         , [ContractStaff]

         , [ContractOwner]

         , [DID]

         , [HasPhoneOnDesktop]

         , [StaffExtPhone]

         , [StaffPositionIsOpen]

         , [IsClient]

         , [NumFamily]

         , [IsClientDay]

         , [DayLocation]

         , [IsClientRes]

         , [ResLocation]

         , [IsClientTrans]

         , [IsClientVocat]

         , [VocLocation]

         , [IsClientSHC]

         , [IsClientSharedLiving]

         , [IsClientAFC]

         , [IsCilentCLO]

         , [CLOLocation]

         , [IsClientIndiv]

         , [IsClientAdultComp]

         , [IsClientAdultCoach]

         , [IsClientNHDay]

         , [IsClientNHRes]

         , [IsClientAutism]

         , [IsClientPCA]

         , [IsClientIHBC]

         , [IsClientSpring]

         , [IsClientTRASE]

         , [IsClientSTRATTUS]

         , [IsClientCommunityConnections]

         , [IsClientGeneralFS]

         , [IsFamilyGuardian]

         , [IsDonor]

         , [NumDonations]

         , [IsInterestedParty]

         , [IsStaff]

         , [StaffLocation]

         , [IsConsultant]

         , [IsDeceased]

         , [DeceasedDate]

         , [DirectoryOnly]

         , [ClientCompletelyInactive]

         , [ClientCompletelyInactiveDate]

         , [PersonCompletelyInactive]

         , [InterestedPartyCategory]

         , [InterestedPartyInactive]

         , [TILLEGram]

         , [NoMailings]

         , [NoSolicitations]

         , [GoGreen]

         , [Comment]

         , [ErrorMessages]

         , [FlagForDeletion]

    from ext.[tblPeople];



    insert into dbo.[tblPeopleClientsAdultCoaching]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [CaseManager]

      , [FundingSource]

      , [Provider]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [CaseManager]

         , [FundingSource]

         , [Provider]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsAdultCoaching] a

        inner join dbo.tblPeople             p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsAdultCompanion]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [CaseManager]

      , [FundingSource]

      , [Provider]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [CaseManager]

         , [FundingSource]

         , [Provider]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsAdultCompanion] a

        inner join dbo.tblPeople              p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsAFCServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [Portion]

      , [CaseManager]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [Portion]

         , [CaseManager]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsAFCServices] a

        inner join dbo.tblPeople           p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsAutismServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Age]

      , [DDSArea]

      , [DateOfReferral]

      , [ReasonForReferral]

      , [GeneralDiagnosis]

      , [Diagnosis]

      , [GeneralReferralSource]

      , [ReferralSource]

      , [SupportBrokerLastName]

      , [SupportBrokerFirstName]

      , [SupportBrokerMiddleInitial]

      , [CurrentAutismWaiverClient]

      , [AutismWaiverStartDate]

      , [AutismWaiverEndDate]

      , [FormerAutismWaiverClient]

      , [Comments]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [Age]

         , [DDSArea]

         , [DateOfReferral]

         , [ReasonForReferral]

         , [GeneralDiagnosis]

         , [Diagnosis]

         , [GeneralReferralSource]

         , [ReferralSource]

         , [SupportBrokerLastName]

         , [SupportBrokerFirstName]

         , [SupportBrokerMiddleInitial]

         , [CurrentAutismWaiverClient]

         , [AutismWaiverStartDate]

         , [AutismWaiverEndDate]

         , [FormerAutismWaiverClient]

         , [Comments]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsAutismServices] a

        inner join dbo.tblPeople              p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsCLOServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [Funding]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [Portion]

      , [RoomAndBoard]

      , [RNHoursAtResidence]

      , [LPNHoursAtResidence]

      , [Section8]

      , [WaitListSection8]

      , [WaitListSection8Date]

      , [DateInspected]

      , [Section8Review]

      , [PassFail]

      , [ResidentialRate]

      , [ClientContribution]

      , [HousingAuthorityCaseManager]

      , [HousingAuthorityOffice]

      , [HousingAuthorityAddress]

      , [HousingAuthorityCity]

      , [HousingAuthorityState]

      , [HousingAuthorityZIP]

      , [HousingAuthorityPhone]

      , [HousingAuthorityPhoneExtension]

      , [HousingAuthorityEmail]

      , [LeaseBegins]

      , [LeaseEnds]

      , [RecertificationMonth]

      , [HousingAuthorityFunds]

      , [HousingAuthorityWorkInProgress]

      , [HousingAuthorityCurrentRent]

      , [HousingAuthorityNextYearRent]

      , [HousingAuthorityPermissionLetter]

      , [DateLastRentIncrease]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [Funding]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [Portion]

         , [RoomAndBoard]

         , [RNHoursAtResidence]

         , [LPNHoursAtResidence]

         , [Section8]

         , [WaitListSection8]

         , [WaitListSection8Date]

         , [DateInspected]

         , [Section8Review]

         , [PassFail]

         , [ResidentialRate]

         , [ClientContribution]

         , [HousingAuthorityCaseManager]

         , [HousingAuthorityOffice]

         , [HousingAuthorityAddress]

         , [HousingAuthorityCity]

         , [HousingAuthorityState]

         , [HousingAuthorityZIP]

         , [HousingAuthorityPhone]

         , [HousingAuthorityPhoneExtension]

         , [HousingAuthorityEmail]

         , [LeaseBegins]

         , [LeaseEnds]

         , [RecertificationMonth]

         , [HousingAuthorityFunds]

         , [HousingAuthorityWorkInProgress]

         , [HousingAuthorityCurrentRent]

         , [HousingAuthorityNextYearRent]

         , [HousingAuthorityPermissionLetter]

         , [DateLastRentIncrease]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsCLOServices] a

        inner join dbo.tblPeople           p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsCommunityConnectionsServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Bowlers]

      , [BowlingTeam]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [Bowlers]

         , [BowlingTeam]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsCommunityConnectionsServices] a

        inner join dbo.tblPeople                            p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsDayServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [LocationName]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [Profile]

      , [Severity]

      , [IntensityLevel]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [Funding]

      , [STMBillingNumber]

      , [ICD10Code]

      , [DMRWrapHours]

      , [MMARSLine]

      , [Rate]

      , [MedicaidRate]

      , [DMRAnnual]

      , [MedicaidAnnual]

      , [MCBAmount]

      , [MRCAmount]

      , [OtherFundingAmount]

      , [Annual]

      , [ScoreVision]

      , [ScoreAuditory]

      , [ScoreMobility]

      , [ScoreCommunication]

      , [ScoreEating]

      , [ScoreToileting]

      , [ScoreMedical]

      , [ScoreHyperactivity]

      , [ScoreLearning]

      , [ScoreSocial]

      , [ScoreNoncompliance]

      , [ScoreSelfInjury]

      , [ScoreAggression]

      , [ScoreTotal]

      , [ScoresUpdatedWhen]

      , [ScoresUpdatedWho],
           [LevelUpdatedWhen],
           [LevelUpdatedWho],
           [MassHealthServiceLevel],
           [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [LocationName]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [Profile]

         , [Severity]

         , [IntensityLevel]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [Funding]

         , [STMBillingNumber]

         , [ICD10Code]

         , [DMRWrapHours]

         , [MMARSLine]

         , [Rate]

         , [MedicaidRate]

         , [DMRAnnual]

         , [MedicaidAnnual]

         , [MCBAmount]

         , [MRCAmount]

         , [OtherFundingAmount]

         , [Annual]

         , [ScoreVision]

         , [ScoreAuditory]

         , [ScoreMobility]

         , [ScoreCommunication]

         , [ScoreEating]

         , [ScoreToileting]

         , [ScoreMedical]

         , [ScoreHyperactivity]

         , [ScoreLearning]

         , [ScoreSocial]

         , [ScoreNoncompliance]

         , [ScoreSelfInjury]

         , [ScoreAggression]

         , [ScoreTotal]

         , [ScoresUpdatedWhen]

         , [ScoresUpdatedWho],
           [LevelUpdatedWhen],
           [LevelUpdatedWho],
           [MassHealthServiceLevel],
           [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsDayServices] a

        inner join dbo.tblPeople           p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsDemographics]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [LegalName]

      , [CountyOfResidence]

      , [SocialSecurityNumber]

      , [Gender]

      , [Race]

      , [DateOfBirth]

      , [Age]

      , [MaritalStatus]

      , [LegalStatus]

      , [GuardianshipPapersOnFile]

      , [VisuallyImpaired]

      , [HearingImpaired]

      , [UsesWheelchair]

      , [UsesWalker]

      , [DateISP]

      , [DateConsentFormsSigned]

      , [DateBMMExpires]

      , [DateBMMAccessSignedHRC]

      , [DateBMMAccessSigned]

      , [DateSPDAuthExpires]

      , [DateSPDSignedHRC]

      , [DateSPDSigned]

      , [DateSignaturesDueBy]

      , [AllSPDSignaturesReceived]

      , [ActiveDayServices]

      , [ActiveResidentialServices]

      , [ActiveTransportationServices]

      , [ActiveVocationalServices]

      , [ActiveIHBS]

      , [ActiveSHC]

      , [ActiveSharedLiving]

      , [ActiveAFC]

      , [ActiveCLO]

      , [ActiveIndivSupport]

      , [ActiveAdultComp]

      , [ActiveAdultCoach]

      , [ActiveNHDay]

      , [ActiveNHRes]

      , [ActiveAutismServices]

      , [ActivePCA]

      , [ActiveSpringboard]

      , [ActiveTRASE]

      , [ActiveSTRATTUS]

      , [ActiveCommunityConnections]

      , [ActiveGeneralFS]

      , [ClientCompletelyInactive]

      , [ClientID]

      , [MedicaidNumber]

      , [MedicaidLastCertDate]

      , [MedicareNumber]

      , [SSAMonthlyAmount]

      , [SSABenefitsLetterDate]

      , [SSIMonthlyAmount]

      , [SSPMonthlyAmount]

      , [Pension]

      , [OOPExpenses]

      , [WdlPercent]

      , [ResidentialWaiver]

      , [AdultSupportsWaiver]

      , [CommunityLivingWaiver]

      , [DualEligible]

      , [WaiverClient]

      , [WaiverType]

      , [OtherBenefits]

      , [OtherMonthlyAmount]

      , [RepresentativePayee]

      , [RepPayeeIsTILL]

      , [RepPayeeIsClient]

      , [RepPayeeAddress]

      , [RepPayeeCity]

      , [RepPayeeState]

      , [RepPayeeZIP]

      , [RepPayeeReportDate]

      , [RepPayeePhone]

      , [RepPayeeAddressValidated]

      , [OtherInsurance]

      , [Bank]

      , [BankAccountNumber]

      , [BankTypeOfAccount]

      , [BankRoutingNumber]

      , [BankAddress]

      , [BankCity]

      , [BankState]

      , [BankZIP]

      , [BankPhoneNumber]

      , [PlaceOfBirth]

      , [Mother]

      , [MotherStatus]

      , [MotherDateOfBirth]

      , [MotherDateOfDeath]

      , [Father]

      , [FatherStatus]

      , [FatherDateOfBirth]

      , [FatherDateOfDeath]

      , [Siblings]

      , [BCStatus]

      , [SSCardStatus]

      , [FoodStampsEligible]

      , [FoodStamps]

      , [FoodStampsCardNumber]

      , [FoodStampsAmount]

      , [FoodStampsOffice]

      , [SNAPAgencyID]

      , [FoodStampsLastCertDate]

      , [FoodStampsNextCertDate]

      , [FoodStampsComments]

      , [Employer]

      , [EmployerAddress]

      , [EmployerCity]

      , [EmployerState]

      , [EmployerZIP]

      , [EmployerPhone]

      , [EmployerSupervisorName]

      , [FinancialNotes]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [LegalName]

         , [CountyOfResidence]

         , [SocialSecurityNumber]

         , [Gender]

         , [Race]

         , [DateOfBirth]

         , [Age]

         , [MaritalStatus]

         , [LegalStatus]

         , [GuardianshipPapersOnFile]

         , [VisuallyImpaired]

         , [HearingImpaired]

         , [UsesWheelchair]

         , [UsesWalker]

         , [DateISP]

         , [DateConsentFormsSigned]

         , [DateBMMExpires]

         , [DateBMMAccessSignedHRC]

         , [DateBMMAccessSigned]

         , [DateSPDAuthExpires]

         , [DateSPDSignedHRC]

         , [DateSPDSigned]

         , [DateSignaturesDueBy]

         , [AllSPDSignaturesReceived]

         , [ActiveDayServices]

         , [ActiveResidentialServices]

         , [ActiveTransportationServices]

         , [ActiveVocationalServices]

         , [ActiveIHBS]

         , [ActiveSHC]

         , [ActiveSharedLiving]

         , [ActiveAFC]

         , [ActiveCLO]

         , [ActiveIndivSupport]

         , [ActiveAdultComp]

         , [ActiveAdultCoach]

         , [ActiveNHDay]

         , [ActiveNHRes]

         , [ActiveAutismServices]

         , [ActivePCA]

         , [ActiveSpringboard]

         , [ActiveTRASE]

         , [ActiveSTRATTUS]

         , [ActiveCommunityConnections]

         , [ActiveGeneralFS]

         , a.[ClientCompletelyInactive]

         , [ClientID]

         , [MedicaidNumber]

         , [MedicaidLastCertDate]

         , [MedicareNumber]

         , [SSAMonthlyAmount]

         , [SSABenefitsLetterDate]

         , [SSIMonthlyAmount]

         , [SSPMonthlyAmount]

         , [Pension]

         , [OOPExpenses]

         , [WdlPercent]

         , [ResidentialWaiver]

         , [AdultSupportsWaiver]

         , [CommunityLivingWaiver]

         , [DualEligible]

         , [WaiverClient]

         , [WaiverType]

         , [OtherBenefits]

         , [OtherMonthlyAmount]

         , [RepresentativePayee]

         , [RepPayeeIsTILL]

         , [RepPayeeIsClient]

         , [RepPayeeAddress]

         , [RepPayeeCity]

         , [RepPayeeState]

         , [RepPayeeZIP]

         , [RepPayeeReportDate]

         , [RepPayeePhone]

         , [RepPayeeAddressValidated]

         , [OtherInsurance]

         , [Bank]

         , [BankAccountNumber]

         , [BankTypeOfAccount]

         , [BankRoutingNumber]

         , [BankAddress]

         , [BankCity]

         , [BankState]

         , [BankZIP]

         , [BankPhoneNumber]

         , [PlaceOfBirth]

         , [Mother]

         , [MotherStatus]

         , [MotherDateOfBirth]

         , [MotherDateOfDeath]

         , [Father]

         , [FatherStatus]

         , [FatherDateOfBirth]

         , [FatherDateOfDeath]

         , [Siblings]

         , [BCStatus]

         , [SSCardStatus]

         , [FoodStampsEligible]

         , [FoodStamps]

         , [FoodStampsCardNumber]

         , [FoodStampsAmount]

         , [FoodStampsOffice]

         , [SNAPAgencyID]

         , [FoodStampsLastCertDate]

         , [FoodStampsNextCertDate]

         , [FoodStampsComments]

         , [Employer]

         , [EmployerAddress]

         , [EmployerCity]

         , [EmployerState]

         , [EmployerZIP]

         , [EmployerPhone]

         , [EmployerSupervisorName]

         , [FinancialNotes]

    from ext.[tblPeopleClientsDemographics] a

        inner join dbo.tblPeople            p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsDiagnoses]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [1-ADHD]

      , [1-AdjustmentDisorder]

      , [1-AnxietyDisorders]

      , [1-AspergersSyndrome]

      , [1-AutismSpectrum]

      , [1-BipolarDisorder]

      , [1-ConductDisorder]

      , [1-Dementia]

      , [1-Depression]

      , [1-DisruptiveBehaviorDisorder]

      , [1-EatingDisorder]

      , [1-IntermittentExplosiveDisorder]

      , [1-LearningDisability]

      , [1-MoodDisorder]

      , [1-OCD]

      , [1-OppositionalDefiantDisorder]

      , [1-PDD]

      , [1-Pica]

      , [1-Psychosis]

      , [1-PTSD]

      , [1-ReactiveAttachmentDisorder]

      , [1-RettsSyndrome]

      , [1-Schizophrenia]

      , [1-SleepDisorder]

      , [1-Other]

      , [1-OtherDetail]

      , [2-IntellectualDisability]

      , [2-PersonalityDisorders]

      , [2-Other]

      , [2-OtherDetail]

      , [3-ABI]

      , [3-AlzheimersDisease]

      , [3-Arthritis]

      , [3-Cancer]

      , [3-CerebralPalsy]

      , [3-CerebrovascularAccident]

      , [3-CongenitalHeartDisease]

      , [3-COPD]

      , [3-DandyWalker]

      , [3-DecubitusUlcers]

      , [3-Diabetes]

      , [3-DownSyndrome]

      , [3-Dysphagia]

      , [3-FeedingTube]

      , [3-FetalAlcoholSyndrome]

      , [3-FragileX]

      , [3-Hemiplegia]

      , [3-HIV]

      , [3-Hydrocephalus]

      , [3-Hypertension]

      , [3-Lymphoma]

      , [3-Microcephalus]

      , [3-MultipleSclerosis]

      , [3-MuscularDystrophy]

      , [3-NonCongenitalHeartDisease]

      , [3-Paraplegia]

      , [3-PeriventricularLeukomylasia]

      , [3-PraderWilliSyndrome]

      , [3-Quadriplegia]

      , [3-ReactiveAirwayDisorder]

      , [3-Seizures]

      , [3-SpinaBifida]

      , [3-SpinalCordInjury]

      , [3-TBI]

      , [3-ThyroidConditions]

      , [3-WilliamsSyndrome]

      , [3-Other]

      , [3-OtherDetail]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [1-ADHD]

         , [1-AdjustmentDisorder]

         , [1-AnxietyDisorders]

         , [1-AspergersSyndrome]

         , [1-AutismSpectrum]

         , [1-BipolarDisorder]

         , [1-ConductDisorder]

         , [1-Dementia]

         , [1-Depression]

         , [1-DisruptiveBehaviorDisorder]

         , [1-EatingDisorder]

         , [1-IntermittentExplosiveDisorder]

         , [1-LearningDisability]

         , [1-MoodDisorder]

         , [1-OCD]

         , [1-OppositionalDefiantDisorder]

         , [1-PDD]

         , [1-Pica]

         , [1-Psychosis]

         , [1-PTSD]

         , [1-ReactiveAttachmentDisorder]

         , [1-RettsSyndrome]

         , [1-Schizophrenia]

         , [1-SleepDisorder]

         , [1-Other]

         , [1-OtherDetail]

         , [2-IntellectualDisability]

         , [2-PersonalityDisorders]

         , [2-Other]

         , [2-OtherDetail]

         , [3-ABI]

         , [3-AlzheimersDisease]

         , [3-Arthritis]

         , [3-Cancer]

         , [3-CerebralPalsy]

         , [3-CerebrovascularAccident]

         , [3-CongenitalHeartDisease]

         , [3-COPD]

         , [3-DandyWalker]

         , [3-DecubitusUlcers]

         , [3-Diabetes]

         , [3-DownSyndrome]

         , [3-Dysphagia]

         , [3-FeedingTube]

         , [3-FetalAlcoholSyndrome]

         , [3-FragileX]

         , [3-Hemiplegia]

         , [3-HIV]

         , [3-Hydrocephalus]

         , [3-Hypertension]

         , [3-Lymphoma]

         , [3-Microcephalus]

         , [3-MultipleSclerosis]

         , [3-MuscularDystrophy]

         , [3-NonCongenitalHeartDisease]

         , [3-Paraplegia]

         , [3-PeriventricularLeukomylasia]

         , [3-PraderWilliSyndrome]

         , [3-Quadriplegia]

         , [3-ReactiveAirwayDisorder]

         , [3-Seizures]

         , [3-SpinaBifida]

         , [3-SpinalCordInjury]

         , [3-TBI]

         , [3-ThyroidConditions]

         , [3-WilliamsSyndrome]

         , [3-Other]

         , [3-OtherDetail]

    from ext.[tblPeopleClientsDiagnoses] a

        inner join dbo.tblPeople         p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsGeneralFamilySupportServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Age]

      , [Diagnosis]

      , [ReferralSource]

      , [DDSAreaOffice]

      , [ServiceProvided]

      , [ManagerLastName]

      , [ManagerFirstName]

      , [ManagerMiddleInitial]

      , [Comments]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [Age]

         , [Diagnosis]

         , [ReferralSource]

         , [DDSAreaOffice]

         , [ServiceProvided]

         , [ManagerLastName]

         , [ManagerFirstName]

         , [ManagerMiddleInitial]

         , [Comments]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsGeneralFamilySupportServices] a

        inner join dbo.tblPeople                            p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsIHBCServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Age]

      , [ManagedCareEntity]

      , [HOTherapist]

      , [HNMonitor]

      , [AuthBegins]

      , [AuthEnds]

      , [Diagnosis]

      , [Axis1]

      , [ReferralSource]

      , [Comments]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [Age]

         , [ManagedCareEntity]

         , [HOTherapist]

         , [HNMonitor]

         , [AuthBegins]

         , [AuthEnds]

         , [Diagnosis]

         , [Axis1]

         , [ReferralSource]

         , [Comments]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsIHBCServices] a

        inner join dbo.tblPeople            p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsIndividualSupportServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [CostCenter]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [CaseManager]

      , [FundingSource]

      , [Provider]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [CostCenter]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [CaseManager]

         , [FundingSource]

         , [Provider]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsIndividualSupportServices] a

        inner join dbo.tblPeople                         p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsNHDay]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [Funding]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [Rate]

      , [DMRAnnual]

      , [IntensityLevel]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [Funding]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [Rate]

         , [DMRAnnual]

         , [IntensityLevel]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsNHDay] a

        inner join dbo.tblPeople     p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsNHRes]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [StartDate]

      , [EndDate]

      , [Funding]

      , [ResidentialRate]

      , [RoomAndBoard]

      , [ChargesForCare]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [Portion]

      , [CaseManager]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [StartDate]

         , [EndDate]

         , [Funding]

         , [ResidentialRate]

         , [RoomAndBoard]

         , [ChargesForCare]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [Portion]

         , [CaseManager]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsNHRes] a

        inner join dbo.tblPeople     p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsPCAServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Age]

      , [ConsumerNumber]

      , [BillingCode]

      , [ARPlusNumber]

      , [Billing]

      , [IntakeAssessment]

      , [IntakeApplicationReceived]

      , [IntakeApprovedDate]

      , [AnnualAssessment]

      , [AnnualReminderSent]

      , [AnnualFormsSigned]

      , [SkillsTrainerLastName]

      , [SkillsTrainerFirstName]

      , [SkillsTrainerMiddleInitial]

      , [Surrogate]

      , [PANumber]

      , [DateOfServiceStart]

      , [DateOfServiceEnd]

      , [NoChange]

      , [DayHoursApproved]

      , [NightHoursApproved]

      , [VacationHoursApproved]

      , [RNAssigned]

      , [OtherHealthInsurance]

      , [OtherHealthInsuranceContact]

      , [OtherHealthInsurancePhone]

      , [Comment]

      , [PresentingDisability]

      , [NurseNotes]

      , [ICD9Code]

      , [ICD10Code]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [Age]

         , [ConsumerNumber]

         , [BillingCode]

         , [ARPlusNumber]

         , [Billing]

         , [IntakeAssessment]

         , [IntakeApplicationReceived]

         , [IntakeApprovedDate]

         , [AnnualAssessment]

         , [AnnualReminderSent]

         , [AnnualFormsSigned]

         , [SkillsTrainerLastName]

         , [SkillsTrainerFirstName]

         , [SkillsTrainerMiddleInitial]

         , [Surrogate]

         , [PANumber]

         , [DateOfServiceStart]

         , [DateOfServiceEnd]

         , [NoChange]

         , [DayHoursApproved]

         , [NightHoursApproved]

         , [VacationHoursApproved]

         , [RNAssigned]

         , [OtherHealthInsurance]

         , [OtherHealthInsuranceContact]

         , [OtherHealthInsurancePhone]

         , a.[Comment]

         , [PresentingDisability]

         , [NurseNotes]

         , [ICD9Code]

         , [ICD10Code]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsPCAServices] a

        inner join dbo.tblPeople           p

            on a.IndexedName = p.IndexedName;



    set identity_insert tblPeopleClientsPCAServicesContactNotes on;

    insert into dbo.[tblPeopleClientsPCAServicesContactNotes]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordNumber]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [DateOfEntry]

      , [Staff]

      , [ContactType]

      , [BillCode]

      , [Units]

      , [Activity]

      , [Comments]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordNumber]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [DateOfEntry]

         , [Staff]

         , [ContactType]

         , [BillCode]

         , [Units]

         , [Activity]

         , [Comments]

    from ext.[tblPeopleClientsPCAServicesContactNotes] a

        inner join dbo.tblPeople                       p

            on a.IndexedName = p.IndexedName;

    set identity_insert tblPeopleClientsPCAServicesContactNotes off;



    insert into dbo.[tblPeopleClientsPhotos]

    (

        PeopleGUID

      , [IndexedName]

      , [ClientPhoto]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , [ClientPhoto]

    from ext.[tblPeopleClientsPhotos] a

        inner join dbo.tblPeople      p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsResidentialServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [RNHoursAtResidence]

      , [LPNHoursAtResidence]

      , [Section8]

      , [WaitListSection8]

      , [WaitListSection8Date]

      , [DateInspected]

      , [PassFail]

      , [Section8Review]

      , [IntensityLevel]

      , [ResidentialRate]

      , [ClientContribution]

      , [Funding]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [Portion]

      , [RoomAndBoard]

      , [PSSAmount]

      , [PSSStartDate]

      , [PSSEndDate]

      , [PSSHours]

      , [PSSRate]

      , [HousingAuthorityCaseManager]

      , [HousingAuthorityOffice]

      , [HousingAuthorityAddress]

      , [HousingAuthorityCity]

      , [HousingAuthorityState]

      , [HousingAuthorityZIP]

      , [HousingAuthorityPhone]

      , [HousingAuthorityPhoneExtension]

      , [HousingAuthorityEmail]

      , [LeaseBegins]

      , [LeaseEnds]

      , [RecertificationMonth]

      , [HousingAuthorityFunds]

      , [HousingAuthorityWorkInProgress]

      , [HousingAuthorityCurrentRent]

      , [HousingAuthorityNextYearRent]

      , [HousingAuthorityPermissionLetter]

      , [DateLastRentIncrease]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [RNHoursAtResidence]

         , [LPNHoursAtResidence]

         , [Section8]

         , [WaitListSection8]

         , [WaitListSection8Date]

         , [DateInspected]

         , [PassFail]

         , [Section8Review]

         , [IntensityLevel]

         , [ResidentialRate]

         , [ClientContribution]

         , [Funding]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [Portion]

         , [RoomAndBoard]

         , [PSSAmount]

         , [PSSStartDate]

         , [PSSEndDate]

         , [PSSHours]

         , [PSSRate]

         , [HousingAuthorityCaseManager]

         , [HousingAuthorityOffice]

         , [HousingAuthorityAddress]

         , [HousingAuthorityCity]

         , [HousingAuthorityState]

         , [HousingAuthorityZIP]

         , [HousingAuthorityPhone]

         , [HousingAuthorityPhoneExtension]

         , [HousingAuthorityEmail]

         , [LeaseBegins]

         , [LeaseEnds]

         , [RecertificationMonth]

         , [HousingAuthorityFunds]

         , [HousingAuthorityWorkInProgress]

         , [HousingAuthorityCurrentRent]

         , [HousingAuthorityNextYearRent]

         , [HousingAuthorityPermissionLetter]

         , [DateLastRentIncrease]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsResidentialServices] a

        inner join dbo.tblPeople                   p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsRespiteServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [RNHoursAtResidence]

      , [LPNHoursAtResidence]

      , [Section8]

      , [WaitListSection8]

      , [WaitListSection8Date]

      , [DateInspected]

      , [PassFail]

      , [IntensityLevel]

      , [ResidentialRate]

      , [ClientContribution]

      , [Funding]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [Portion]

      , [PSSAmount]

      , [PSSStartDate]

      , [PSSEndDate]

      , [PSSHours]

      , [PSSRate]

      , [HousingAuthorityCaseManager]

      , [HousingAuthorityOffice]

      , [HousingAuthorityAddress]

      , [HousingAuthorityCity]

      , [HousingAuthorityState]

      , [HousingAuthorityZIP]

      , [HousingAuthorityPhone]

      , [HousingAuthorityPhoneExtension]

      , [HousingAuthorityEmail]

      , [LeaseBegins]

      , [LeaseEnds]

      , [RecertificationMonth]

      , [HousingAuthorityFunds]

      , [HousingAuthorityWorkInProgress]

      , [HousingAuthorityCurrentRent]

      , [HousingAuthorityNextYearRent]

      , [HousingAuthorityPermissionLetter]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [RNHoursAtResidence]

         , [LPNHoursAtResidence]

         , [Section8]

         , [WaitListSection8]

         , [WaitListSection8Date]

         , [DateInspected]

         , [PassFail]

         , [IntensityLevel]

         , [ResidentialRate]

         , [ClientContribution]

         , [Funding]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [Portion]

         , [PSSAmount]

         , [PSSStartDate]

         , [PSSEndDate]

         , [PSSHours]

         , [PSSRate]

         , [HousingAuthorityCaseManager]

         , [HousingAuthorityOffice]

         , [HousingAuthorityAddress]

         , [HousingAuthorityCity]

         , [HousingAuthorityState]

         , [HousingAuthorityZIP]

         , [HousingAuthorityPhone]

         , [HousingAuthorityPhoneExtension]

         , [HousingAuthorityEmail]

         , [LeaseBegins]

         , [LeaseEnds]

         , [RecertificationMonth]

         , [HousingAuthorityFunds]

         , [HousingAuthorityWorkInProgress]

         , [HousingAuthorityCurrentRent]

         , [HousingAuthorityNextYearRent]

         , [HousingAuthorityPermissionLetter]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsRespiteServices] a

        inner join dbo.tblPeople               p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsSharedLivingServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [CostCenter]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [Portion]

      , [CaseManager]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [CostCenter]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [Portion]

         , [CaseManager]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsSharedLivingServices] a

        inner join dbo.tblPeople                    p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsSHCServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [Portion]

      , [CaseManager]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [Portion]

         , [CaseManager]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsSHCServices] a

        inner join dbo.tblPeople           p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsSpringboardServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CustomerID]

      , [Age]

      , [DateJoined]

      , [DateTerminated]

      , [ReasonForTermination]

      , [BeginBillingDate]

      , [GroupCode]

      , [LeaderIndexedName]

      , [Leader]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CustomerID]

         , [Age]

         , [DateJoined]

         , [DateTerminated]

         , [ReasonForTermination]

         , [BeginBillingDate]

         , [GroupCode]

         , [LeaderIndexedName]

         , [Leader]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsSpringboardServices] a

        inner join dbo.tblPeople                   p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsSTRATTUSServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsSTRATTUSServices] a

        inner join dbo.tblPeople                p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsTransportationServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Company]

      , [PhoneNumber]

      , [RouteNumber]

      , [FundingSource]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [DDSFunding]

      , [Comments]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [Company]

         , [PhoneNumber]

         , [RouteNumber]

         , [FundingSource]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [DDSFunding]

         , [Comments]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsTransportationServices] a

        inner join dbo.tblPeople                      p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsTRASEServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [School]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [School]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsTRASEServices] a

        inner join dbo.tblPeople             p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsVendors]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [ResidentialVendor]

      , [ResVendorAddress]

      , [ResVendorCity]

      , [ResVendorState]

      , [ResVendorZIP]

      , [ResidentialVendorPhoneNumber]

      , [ResVendorLocation]

      , [LivingWithParentOrGuardian]

      , [LivingIndependently]

      , [DayVendor]

      , [DayVendorAddress]

      , [DayVendorCity]

      , [DayVendorState]

      , [DayVendorZIP]

      , [DayVendorPhoneNumber]

      , [DayVendorLocation]

      , [PCPName]

      , [PCPOffice]

      , [PCPAddress]

      , [PCPCity]

      , [PCPState]

      , [PCPZIP]

      , [PCPPhoneNumber]

      , [PCPFaxNumber]

      , [PCPEmailAddress]

      , [PCPHospitalAffiliation]

      , [PCPNPI]

      , [OtherService1]

      , [OtherService1Name]

      , [OtherService1Address]

      , [OtherService1City]

      , [OtherService1State]

      , [OtherService1ZIP]

      , [OtherService1Phone]

      , [OtherService1Fax]

      , [OtherService2]

      , [OtherService2Name]

      , [OtherService2Address]

      , [OtherService2City]

      , [OtherService2State]

      , [OtherService2ZIP]

      , [OtherService2Phone]

      , [OtherService2Fax]

      , [OtherService3]

      , [OtherService3Name]

      , [OtherService3Address]

      , [OtherService3City]

      , [OtherService3State]

      , [OtherService3ZIP]

      , [OtherService3Phone]

      , [OtherService3Fax]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [ResidentialVendor]

         , [ResVendorAddress]

         , [ResVendorCity]

         , [ResVendorState]

         , [ResVendorZIP]

         , [ResidentialVendorPhoneNumber]

         , [ResVendorLocation]

         , [LivingWithParentOrGuardian]

         , [LivingIndependently]

         , [DayVendor]

         , [DayVendorAddress]

         , [DayVendorCity]

         , [DayVendorState]

         , [DayVendorZIP]

         , [DayVendorPhoneNumber]

         , [DayVendorLocation]

         , [PCPName]

         , [PCPOffice]

         , [PCPAddress]

         , [PCPCity]

         , [PCPState]

         , [PCPZIP]

         , [PCPPhoneNumber]

         , [PCPFaxNumber]

         , [PCPEmailAddress]

         , [PCPHospitalAffiliation]

         , [PCPNPI]

         , [OtherService1]

         , [OtherService1Name]

         , [OtherService1Address]

         , [OtherService1City]

         , [OtherService1State]

         , [OtherService1ZIP]

         , [OtherService1Phone]

         , [OtherService1Fax]

         , [OtherService2]

         , [OtherService2Name]

         , [OtherService2Address]

         , [OtherService2City]

         , [OtherService2State]

         , [OtherService2ZIP]

         , [OtherService2Phone]

         , [OtherService2Fax]

         , [OtherService3]

         , [OtherService3Name]

         , [OtherService3Address]

         , [OtherService3City]

         , [OtherService3State]

         , [OtherService3ZIP]

         , [OtherService3Phone]

         , [OtherService3Fax]

    from ext.[tblPeopleClientsVendors] a

        inner join dbo.tblPeople       p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleClientsVocationalServices]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [CityTown]

      , [Location]

      , [StartDate]

      , [EndDate]

      , [TerminationReason]

      , [Funding]

      , [ContractNumber]

      , [ActivityCode]

      , [ContractNumber2]

      , [ActivityCode2]

      , [Rate]

      , [DMRAnnual]

      , [IntensityLevel]

      , [Inactive]

      , [DateInactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [CityTown]

         , [Location]

         , [StartDate]

         , [EndDate]

         , [TerminationReason]

         , [Funding]

         , [ContractNumber]

         , [ActivityCode]

         , [ContractNumber2]

         , [ActivityCode2]

         , [Rate]

         , [DMRAnnual]

         , [IntensityLevel]

         , [Inactive]

         , [DateInactive]

    from ext.[tblPeopleClientsVocationalServices] a

        inner join dbo.tblPeople                  p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleConsultants]

    (

        PeopleGUID

      , [IndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [Department]

      , [SpringboardGroupCode1]

      , [SpringboardGroupCode2]

      , [SpringboardGroupCode3]

      , [Inactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , a.[Department]

         , [SpringboardGroupCode1]

         , [SpringboardGroupCode2]

         , [SpringboardGroupCode3]

         , [Inactive]

    from ext.[tblPeopleConsultants] a

        inner join dbo.tblPeople    p

            on a.IndexedName = p.IndexedName;



    insert into dbo.[tblPeopleDayAttendance]

    (

        PeopleGUID

      , [IndexedName]

      , [LastName]

      , [FirstName]

      , [MiddleInitial]

      , [City]

      , [Loc]

      , [ClientID]

      , [Prf]

      , [Sev]

      , [Rate]

      , [Fund]

      , [SpecialFundingCode]

      , [STM]

      , [IsDeceased]

      , [CostCenter]

      , [WeekEnding]

      , [CodeMO]

      , [HrsMO]

      , [UnitsMO]

      , [WhereMO]

      , [CodeTU]

      , [HrsTU]

      , [UnitsTU]

      , [WhereTU]

      , [CodeWE]

      , [HrsWE]

      , [UnitsWE]

      , [WhereWE]

      , [CodeTH]

      , [HrsTH]

      , [UnitsTH]

      , [WhereTH]

      , [CodeFR]

      , [HrsFR]

      , [UnitsFR]

      , [WhereFR],

      [MassHealthServiceLevel]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[LastName]

         , a.[FirstName]

         , a.[MiddleInitial]

         , [City]

         , [Loc]

         , [ClientID]

         , [Prf]

         , [Sev]

         , [Rate]

         , [Fund]

         , [SpecialFundingCode]

         , [STM]

         , a.[IsDeceased]

         , [CostCenter]

         , [WeekEnding]

         , [CodeMO]

         , [HrsMO]

         , [UnitsMO]

         , [WhereMO]

         , [CodeTU]

         , [HrsTU]

         , [UnitsTU]

         , [WhereTU]

         , [CodeWE]

         , [HrsWE]

         , [UnitsWE]

         , [WhereWE]

         , [CodeTH]

         , [HrsTH]

         , [UnitsTH]

         , [WhereTH]

         , [CodeFR]

         , [HrsFR]

         , [UnitsFR]

         , [WhereFR],
           [MassHealthServiceLevel]
    FROM ext.[tblPeopleDayAttendance] a

        inner join dbo.tblPeople      p

            on a.IndexedName = p.IndexedName;



    set identity_insert dbo.[tblPeopleDonors] on;

    insert into dbo.[tblPeopleDonors]

    (

        PeopleGUID

      , [IndexedName]

      , [Index]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [DateOfDonation]

      , [DateReceived]

      , [DateThankYou]

      , [DonationType]

      , [SolicitationType]

      , [AppealCode]

      , [IsGrant]

      , [IsRestricted]

      , [DonationFrom]

      , [DonationFrom1Salutation]

      , [DonationFrom1FirstName]

      , [DonationFrom1LastName]

      , [DonationFrom2Salutation]

      , [DonationFrom2FirstName]

      , [DonationFrom2LastName]

      , [DonationFromCompany]

      , [Description]

      , [Amount]

      , [Inactive]

    )

    select p.PeopleGUID

         , p.[IndexedName]

         , [Index]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [DateOfDonation]

         , [DateReceived]

         , [DateThankYou]

         , [DonationType]

         , [SolicitationType]

         , [AppealCode]

         , [IsGrant]

         , [IsRestricted]

         , [DonationFrom]

         , [DonationFrom1Salutation]

         , [DonationFrom1FirstName]

         , [DonationFrom1LastName]

         , [DonationFrom2Salutation]

         , [DonationFrom2FirstName]

         , [DonationFrom2LastName]

         , [DonationFromCompany]

         , [Description]

         , [Amount]

         , [Inactive]

    from ext.[tblPeopleDonors]   a

        inner join dbo.tblPeople p

            on a.IndexedName = p.IndexedName;

    set identity_insert dbo.[tblPeopleDonors] off;



    insert into dbo.[tblPeopleFamily]

    (

        PeopleGUID

      , [IndexedName]

      , [ClientIndexedName]

      , [RecordAddedDate]

      , [RecordAddedBy]

      , [ClientLastName]

      , [ClientFirstName]

      , [ClientMiddleInitial]

      , [Relationship]

      , [Guardian]

      , [PrimaryContact]

      , [Surrogate]

      , [RepPayee]

      , [Inactive]

    )

    select p.PeopleGUID

         , a.[IndexedName]

         , a.[ClientIndexedName]

         , a.[RecordAddedDate]

         , a.[RecordAddedBy]

         , [ClientLastName]

         , [ClientFirstName]

         , [ClientMiddleInitial]

         , [Relationship]

         , [Guardian]

         , [PrimaryContact]

         , [Surrogate]

         , [RepPayee]

         , [Inactive]

    from ext.[tblPeopleFamily]   a

        inner join dbo.tblPeople p

            on a.IndexedName = p.IndexedName;



    set identity_insert dbo.[tblPeopleScheduledStaffChanges] on;

    insert into dbo.[tblPeopleScheduledStaffChanges]

    (

        [RecNum]

      , [Action]

      , [DateOfChange]

      , [OfficeCityTown]

      , [OfficeLocationName]

      , [CurrentFirstName]

      , [CurrentLastName]

      , [NewFirstName]

      , [NewLastName]

      , [Cancelled]

      , [Applied]

      , [AddFirstName]

      , [AddLastName]

      , [AddOfficeCityTown]

      , [AddOfficeLocationName]

      , [AddJobTitle]

      , [AddDepartment]

      , [AddDID]

      , [AddHasPhone]

      , [AddExtPhone]

      , [AddEmailAddress],
        [AddMidInitial],
        [DeleteFirstName]

      , [DeleteLastName]

      , [DeleteIndexedName]

    )

    select [RecNum]

         , [Action]

         , [DateOfChange]

         , [OfficeCityTown]

         , [OfficeLocationName]

         , [CurrentFirstName]

         , [CurrentLastName]

         , [NewFirstName]

         , [NewLastName]

         , [Cancelled]

         , [Applied]

         , [AddFirstName]

         , [AddLastName]

         , [AddOfficeCityTown]

         , [AddOfficeLocationName]

         , [AddJobTitle]

         , [AddDepartment]

         , [AddDID]

         , [AddHasPhone]

         , [AddExtPhone]

         , [AddEmailAddress],
        [AddMidInitial],
        [DeleteFirstName]

         , [DeleteLastName]

         , [DeleteIndexedName],
           [CurrentMidinitial],
           [DeleteMidInitial],
           [NewMidInitial]
    FROM ext.[tblPeopleScheduledStaffChanges];

    set identity_insert dbo.[tblPeopleScheduledStaffChanges] off;



    insert into dbo.[tblPeopleStaffSupervisors]

    (

        [SUPERVISORCODE_I]

      , [SUPERVISORNAME]

      , [SUPEMPLID]

      , [LASTNAME]

      , [FIRSTNAME]

      , [INDEXEDNAME]

      , [LOCATION]

      , [STAFFCOUNT]

      , PeopleGUID

    )

    select [SUPERVISORCODE_I]

         , [SUPERVISORNAME]

         , [SUPEMPLID]

         , a.[LASTNAME]

         , a.[FIRSTNAME]

         , a.[INDEXEDNAME]

         , [LOCATION]

         , [STAFFCOUNT]

         , p.PeopleGUID

    from ext.[tblPeopleStaffSupervisors] a

        left join dbo.tblPeople          p

            on a.INDEXEDNAME = p.IndexedName;





    set identity_insert dbo.[tblChangeLog] on;

    insert into dbo.[tblChangeLog]

    (

        [ID]

      , [ChangeDate]

      , [ChangeUser]

      , PeopleGUID

      , [ClientIndexedName]

      , [ChangedField]

      , [ChangedValue]

    )

    select [ID]

         , [ChangeDate]

         , [ChangeUser]

         , p.PeopleGUID

         , [ClientIndexedName]

         , [ChangedField]

         , [ChangedValue]

    from ext.[tblChangeLog]     a

        left join dbo.tblPeople p

            on a.ClientIndexedName = p.IndexedName;



    set identity_insert dbo.[tblChangeLog] off;





end;




GO

PRINT '';
PRINT '============================================================================';
PRINT 'MASTER UPDATE SCRIPT - Execution Complete';
PRINT '============================================================================';
PRINT '';
PRINT 'All updates have been applied:';
PRINT '  - New fields added to existing tables';
PRINT '  - catMassHealthServiceLevels table created';
PRINT '  - spApp_DataImportFromTILLDB_Cat procedure updated';
PRINT '  - spApp_DataImportFromTILLDB_People procedure updated';
PRINT '';
PRINT 'Please verify the changes before using in production.';
PRINT '============================================================================';
GO
