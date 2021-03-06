
/****** Object:  UserDefinedFunction [dbo].[CSVToTable]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CSVToTable] 
( 
	@StringInput VARCHAR(Max) 
)
RETURNS @OutputTable TABLE ( [String] VARCHAR(64) )
AS
BEGIN

    DECLARE @String    VARCHAR(64)

    WHILE LEN(@StringInput) > 0
    BEGIN
        SET @String      = LEFT(@StringInput, 
                                ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1),
                                LEN(@StringInput)))
        SET @StringInput = SUBSTRING(@StringInput,
                                     ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0),
                                     LEN(@StringInput)) + 1, LEN(@StringInput))

        INSERT INTO @OutputTable ( [String] )
        VALUES ( @String )
    END
    
    RETURN
END



GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END







GO
/****** Object:  Table [dbo].[AgentUsers]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AgentUsers](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[UserName] [nvarchar](150) NOT NULL,
	[Token] [nvarchar](max) NULL,
	[PartnerId] [int] NULL,
	[ProductId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_AgentUsers] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AssignedPartner]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AssignedPartner](
	[UserId] [int] NOT NULL,
	[PartnerId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
 CONSTRAINT [PK_AssignedPartner] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PartnerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AssignedRole]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AssignedRole](
	[UserId] [int] NOT NULL,
	[Role] [varchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
 CONSTRAINT [PK_AssignedRole] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[Role] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AuditLog](
	[AuditId] [bigint] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[AuditAt] [datetime] NOT NULL,
	[KeyValues] [nvarchar](250) NOT NULL,
	[OldValues] [nvarchar](max) NULL,
	[NewValues] [nvarchar](max) NULL,
	[RowState] [varchar](20) NOT NULL,
	[UserAgent] [varchar](100) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
 CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Benefit]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Benefit](
	[BenefitId] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[SeqNo] [int] NULL,
 CONSTRAINT [PK_Benefit] PRIMARY KEY CLUSTERED 
(
	[BenefitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Claim]    Script Date: 2/18/2020 3:17:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Claim](
	[ClaimId] [int] NOT NULL,
	[ClaimNumber] [varchar](50) NOT NULL,
	[PartnerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[BusinessId] [int] NOT NULL,
	[UnderWriterId] [int] NULL,
	[PolicyId] [int] NULL,
	[InsuredId] [int] NULL,
	[NotifierId] [int] NULL,
	[CoverStartDate] [date] NULL,
	[CoverEndDate] [date] NULL,
	[CoverAmount] [numeric](18, 2) NULL,
	[RevisedCoverAmount] [numeric](18, 2) NULL,
	[DateOfIncident] [date] NULL,
	[DateNotified] [date] NULL,
	[DocumentCompleteDate] [date] NULL,
	[ReminderDueDate] [date] NULL,
	[ReminderComment] [nvarchar](250) NULL,
	[UWReviewRequired] [bit] NULL,
	[ApprovedAmount] [numeric](18, 2) NULL,
	[Decision] [varchar](20) NULL,
	[RejectionReason] [varchar](70) NULL,
	[ReviewBy] [int] NULL,
	[ReviewDate] [datetime] NULL,
	[ConfirmedBy] [int] NULL,
	[ConfirmedDate] [datetime] NULL,
	[UWSentDate] [date] NULL,
	[UWExternalRef] [varchar](50) NULL,
	[UWStatus] [varchar](50) NULL,
	[UWAdviceDate] [date] NULL,
	[UWAdviceFrom] [varchar](50) NULL,
	[UWAdviceRef] [varchar](50) NULL,
	[UWApprovedAmount] [numeric](18, 2) NULL,
	[UWDecision] [varchar](20) NULL,
	[UWRejectionReason] [varchar](70) NULL,
	[UWReviewBy] [int] NULL,
	[UWReviewDate] [datetime] NULL,
	[UWConfirmedBy] [int] NULL,
	[UWConfirmedDate] [datetime] NULL,
	[UWRefundPending] [bit] NULL,
	[ClaimPaidInPart] [bit] NULL,
	[PaymentTATDetails] [nvarchar](50) NULL,
	[PaymentDueDate] [date] NULL,
	[ClosureReason] [varchar](70) NULL,
	[ClosureDate] [date] NULL,
	[ClaimStatus] [varchar](30) NOT NULL,
	[StatusCreated] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_Claim] PRIMARY KEY CLUSTERED 
(
	[ClaimId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ClaimDocument]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClaimDocument](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[ClaimId] [int] NOT NULL,
	[DocumentType] [varchar](100) NOT NULL,
	[FilePath] [nvarchar](250) NOT NULL,
	[FileName] [nvarchar](200) NOT NULL,
	[OrgFileName] [nvarchar](60) NOT NULL,
	[Comments] [nvarchar](1000) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_ClaimDocument] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ClaimIncident]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClaimIncident](
	[IncidentId] [int] IDENTITY(1,1) NOT NULL,
	[ClaimId] [int] NOT NULL,
	[DateOfDeath] [date] NOT NULL,
	[LocationOfIncident] [nvarchar](250) NULL,
	[IncidentType] [varchar](50) NULL,
	[DaysFromIncident] [int] NULL,
	[HospitalName] [nvarchar](150) NULL,
	[HospitalWard] [nvarchar](50) NULL,
	[HospitalLocation] [nvarchar](250) NULL,
	[CauseOfIncident] [varchar](1000) NULL,
	[Note] [nvarchar](1000) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_ClaimIncident] PRIMARY KEY CLUSTERED 
(
	[IncidentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ClaimNote]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClaimNote](
	[NoteId] [int] IDENTITY(1,1) NOT NULL,
	[ClaimId] [int] NOT NULL,
	[Note] [nvarchar](1000) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_ClaimNote] PRIMARY KEY CLUSTERED 
(
	[NoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ClaimPayment]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClaimPayment](
	[PaymentId] [int] IDENTITY(1,1) NOT NULL,
	[ClaimId] [int] NOT NULL,
	[PaymentMethod] [varchar](50) NOT NULL,
	[PayeeType] [varchar](50) NOT NULL,
	[PayeeId] [int] NULL,
	[PayeeName] [nvarchar](250) NULL,
	[Amount] [numeric](18, 2) NOT NULL,
	[IssuedDate] [date] NULL,
	[IssuedBy] [varchar](100) NULL,
	[ReceivedPayeeDate] [date] NULL,
	[PayeeComment] [nvarchar](250) NULL,
	[NameOnCheque] [nvarchar](150) NULL,
	[ChequeNumber] [nvarchar](50) NULL,
	[ChequeAddress] [nvarchar](250) NULL,
	[DateOnCheque] [date] NULL,
	[AccountName] [nvarchar](150) NULL,
	[AccountNumber] [nvarchar](50) NULL,
	[SendingBank] [nvarchar](150) NULL,
	[ReceivingBank] [nvarchar](150) NULL,
	[TransactionRef] [nvarchar](50) NULL,
	[BankIdentificationNumber] [nvarchar](50) NULL,
	[WalletName] [nvarchar](150) NULL,
	[WalletNumber] [nvarchar](50) NULL,
	[VoidPayment] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_ClaimPayment] PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Client]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Client](
	[ClientId] [int] NOT NULL,
	[ClientType] [varchar](50) NOT NULL,
	[Relationship] [varchar](50) NOT NULL,
	[AgeAtCreationDate] [int] NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NULL,
	[MobileNo] [nvarchar](50) NULL,
	[AccountNo] [nvarchar](50) NULL,
	[DateofBirth] [date] NULL,
	[Gender] [varchar](30) NULL,
	[MaritalStatus] [varchar](30) NULL,
	[PersonalIdType] [varchar](30) NULL,
	[PersonalId] [nvarchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[Email] [varchar](100) NULL,
	[Location] [nvarchar](150) NULL,
	[Language] [varchar](10) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[Communication] [varchar](10) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Configuration](
	[ConfigId] [int] IDENTITY(1,1) NOT NULL,
	[ConfigType] [varchar](50) NOT NULL,
	[ConfigName] [varchar](200) NOT NULL,
	[ConfigValue] [varchar](100) NULL,
	[Description] [varchar](225) NULL,
	[SeqNo] [int] NULL,
	[IsSystemConfig] [bit] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED 
(
	[ConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoverFormula]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoverFormula](
	[CoverId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[FromAmount] [numeric](18, 2) NOT NULL,
	[ToAmount] [numeric](18, 2) NOT NULL,
	[CoverAmount] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_CoverFormula] PRIMARY KEY CLUSTERED 
(
	[CoverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LineOfBusiness]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LineOfBusiness](
	[BusinessId] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[UnderWriterId] [int] NULL,
	[SeqNo] [int] NULL,
 CONSTRAINT [PK_LineOfBusiness] PRIMARY KEY CLUSTERED 
(
	[BusinessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NirvoyClient]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NirvoyClient](
	[ClientId] [int] NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[MobileNumber] [nvarchar](50) NOT NULL,
	[Age] [int] NOT NULL,
	[PersonalIdType] [varchar](30) NULL,
	[PersonalId] [nvarchar](50) NULL,
	[BeneName] [nvarchar](150) NOT NULL,
	[BeneMobileNumber] [nvarchar](50) NULL,
	[BeneAge] [int] NULL,
	[BeneRelationship] [varchar](50) NOT NULL,
	[LoanAmount] [numeric](18, 2) NULL,
	[DeviceOwnership] [varchar](20) NOT NULL,
	[AcceptsTerms] [bit] NOT NULL,
	[ThirdPartyAuthorized] [bit] NOT NULL,
	[SubscriptionChannel] [varchar](50) NOT NULL,
	[AgentMobileNumber] [nvarchar](50) NULL,
	[EntrySource] [varchar](30) NOT NULL,
	[Status] [varchar](30) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_NirvoyClient] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Partner]    Script Date: 2/18/2020 3:17:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Partner](
	[PartnerId] [int] NOT NULL,
	[PartnerCode] [varchar](50) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[CountryId] [int] NULL,
	[SeqNo] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_Partner] PRIMARY KEY CLUSTERED 
(
	[PartnerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Policy]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Policy](
	[PolicyId] [int] NOT NULL,
	[PolicyNumber] [varchar](50) NOT NULL,
	[PartnerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[BenefitId] [int] NOT NULL,
	[PolicyStart] [date] NOT NULL,
	[PolicyEnd] [date] NULL,
	[SalesReference] [varchar](50) NOT NULL,
	[ContributionExtRef] [varchar](50) NULL,
	[ExternalId] [varchar](50) NOT NULL,
	[LoanAmount] [numeric](18, 2) NULL,
	[CoverStartDate] [date] NULL,
	[TermMonths] [int] NULL,
	[CoverEndDate] [date] NULL,
	[AccountNo] [varchar](50) NULL,
	[Category] [nvarchar](150) NULL,
	[OfficerId] [varchar](50) NULL,
	[OfficerName] [nvarchar](250) NULL,
	[CentreLocation] [nvarchar](250) NULL,
	[Cycle] [nvarchar](100) NULL,
	[RequestedEndDate] [date] NULL,
	[EndReason] [varchar](50) NULL,
	[EntrySource] [varchar](30) NULL,
	[PolicyStatus] [varchar](30) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_Policy] PRIMARY KEY CLUSTERED 
(
	[PolicyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PolicyAsset]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PolicyAsset](
	[AssetId] [int] IDENTITY(1,1) NOT NULL,
	[PolicyId] [int] NOT NULL,
	[AssetType] [varchar](30) NOT NULL,
	[AssetValue] [numeric](18, 2) NOT NULL,
	[AssetDescription] [nvarchar](250) NULL,
	[AssetCount] [int] NULL,
	[BusinessDescription] [nvarchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[Location] [nvarchar](150) NULL,
	[PostalCode] [nvarchar](20) NULL,
	[StructureType] [varchar](30) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_PolicyAsset] PRIMARY KEY CLUSTERED 
(
	[AssetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PolicyClient]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PolicyClient](
	[PCId] [int] IDENTITY(1,1) NOT NULL,
	[PolicyId] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
 CONSTRAINT [PK_PolicyClient] PRIMARY KEY CLUSTERED 
(
	[PCId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PolicyNote]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PolicyNote](
	[NoteId] [int] IDENTITY(1,1) NOT NULL,
	[PolicyId] [int] NOT NULL,
	[Note] [nvarchar](1000) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_PolicyNote] PRIMARY KEY CLUSTERED 
(
	[NoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductId] [int] NOT NULL,
	[PartnerId] [int] NOT NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[ExternalId] [varchar](50) NULL,
	[SeqNo] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductBenefit]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductBenefit](
	[PBId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[BenefitId] [int] NOT NULL,
	[CoverageType] [varchar](50) NULL,
	[DefaultAssetType] [varchar](100) NULL,
	[DisableAssetType] [bit] NULL,
	[SeqNo] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_ProductBenefit] PRIMARY KEY CLUSTERED 
(
	[PBId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductBusiness]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductBusiness](
	[PLBId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[BusinessId] [int] NOT NULL,
	[SeqNo] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_ProductBusiness] PRIMARY KEY CLUSTERED 
(
	[PLBId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductConfig]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductConfig](
	[PCId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ConfigType] [varchar](50) NOT NULL,
	[ConfigName] [varchar](150) NOT NULL,
	[ConfigValue] [varchar](150) NULL,
	[SeqNo] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_ProductConfig] PRIMARY KEY CLUSTERED 
(
	[PCId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RecordHistory]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RecordHistory](
	[HistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[HistoryType] [varchar](50) NOT NULL,
	[KeyValue] [int] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
 CONSTRAINT [PK_RecordHistory] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SystemCodeMax]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SystemCodeMax](
	[TableName] [varchar](100) NOT NULL,
	[Period] [varchar](20) NOT NULL,
	[MaxNumber] [int] NOT NULL,
	[UpdatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_SystemCodeMax] PRIMARY KEY CLUSTERED 
(
	[TableName] ASC,
	[Period] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SystemCodePattern]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SystemCodePattern](
	[TableName] [varchar](100) NOT NULL,
	[Period] [varchar](10) NOT NULL,
	[IdPattern] [varchar](250) NULL,
	[CodePattern] [varchar](250) NULL,
	[StartNumber] [smallint] NOT NULL,
	[Increment] [smallint] NOT NULL,
	[Padding] [smallint] NULL,
	[PaddingChar] [char](1) NULL,
	[YearLength] [smallint] NULL,
	[MasterTable] [varchar](100) NULL,
 CONSTRAINT [PK_SystemCodePattern] PRIMARY KEY CLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UnderWriter]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnderWriter](
	[UnderWriterId] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_UnderWriter] PRIMARY KEY CLUSTERED 
(
	[UnderWriterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserLogTracker]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserLogTracker](
	[LogedId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[LogInAt] [datetime] NOT NULL,
	[LogOutAt] [datetime] NULL,
	[IsLive] [bit] NULL,
	[IPAddress] [varchar](20) NOT NULL,
	[UserAgent] [varchar](100) NULL,
 CONSTRAINT [PK_UserLogTracker] PRIMARY KEY CLUSTERED 
(
	[LogedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NULL,
	[PasswordHash] [binary](64) NOT NULL,
	[PasswordSalt] [binary](128) NOT NULL,
	[UserType] [varchar](50) NOT NULL,
	[Organization] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedIP] [varchar](20) NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedIP] [varchar](20) NULL,
	[RowVersion] [smallint] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[GetAllDates]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAllDates]
(
	@StartDate DATETIME,
	@EndDate DATETIME
)
Returns Table
As
Return
(
	SELECT DATEADD(day, Dates.num, @StartDate) As DummyDate

	FROM (

		SELECT b10.i + b9.i + b8.i + b7.i + b6.i + b5.i + b4.i + b3.i + b2.i + b1.i + b0.i num

		FROM (SELECT 0 i UNION ALL SELECT 1) b0

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 2) b1

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 4) b2

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 8) b3

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 16) b4

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 32) b5

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 64) b6

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 128) b7

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 256) b8

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 512) b9

		CROSS JOIN (SELECT 0 i UNION ALL SELECT 1024) b10

	) Dates

	WHERE Dates.num <= DATEDIFF(day, @StartDate, @EndDate)
	--ORDER BY Dates.num
)
--Select * From GetAllDates('01/01/2010','12/31/2010') Order By DummyDate







GO
/****** Object:  UserDefinedFunction [dbo].[UserAccess]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UserAccess] 
( 
	@UserId INT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT PartnerId FROM AssignedPartner WHERE UserId = @UserId
)






GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, 1, 1, CAST(N'2019-03-29T20:15:07.697' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, 2, 1, CAST(N'2019-03-29T20:15:07.697' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, 3, 1, CAST(N'2019-03-29T20:15:07.697' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, 4, 1, CAST(N'2019-03-29T20:15:07.697' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, 5, 1, CAST(N'2019-03-29T20:15:07.697' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, 6, 1, CAST(N'2019-03-29T20:15:07.697' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, 1, 1, CAST(N'2019-04-10T04:25:51.213' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, 2, 1, CAST(N'2019-04-10T04:25:51.213' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, 3, 1, CAST(N'2019-04-10T04:25:51.213' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, 4, 1, CAST(N'2019-04-10T04:25:51.213' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, 5, 1, CAST(N'2019-04-10T04:25:51.213' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, 6, 1, CAST(N'2019-04-10T04:25:51.213' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (3, 6, 2, CAST(N'2019-07-12T09:27:23.877' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (4, 1, 1, CAST(N'2019-08-05T10:33:11.713' AS DateTime), N'202.53.168.33')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (5, 4, 1, CAST(N'2019-08-07T18:11:58.313' AS DateTime), N'202.53.168.33')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (6, 4, 1, CAST(N'2019-08-07T18:12:19.737' AS DateTime), N'202.53.168.33')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (7, 4, 1, CAST(N'2019-08-07T18:12:30.890' AS DateTime), N'202.53.168.33')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (8, 4, 1, CAST(N'2019-08-07T18:12:42.717' AS DateTime), N'202.53.168.33')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (9, 6, 2, CAST(N'2019-10-27T13:41:06.073' AS DateTime), N'202.53.168.33')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (11, 3, 2, CAST(N'2019-12-29T11:11:32.473' AS DateTime), N'62.151.176.243')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (12, 3, 2, CAST(N'2019-12-29T11:17:44.360' AS DateTime), N'62.151.176.243')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (13, 3, 2, CAST(N'2019-12-29T11:18:03.783' AS DateTime), N'62.151.176.243')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (14, 3, 2, CAST(N'2019-12-29T11:18:21.640' AS DateTime), N'62.151.176.243')
GO
INSERT [dbo].[AssignedPartner] ([UserId], [PartnerId], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (15, 3, 2, CAST(N'2019-12-29T11:18:42.040' AS DateTime), N'62.151.176.243')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, N'MGPP Claim Review Approver', 1, CAST(N'2019-03-29T20:15:07.690' AS DateTime), N'127.0.0.1')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, N'MGPP Claims Administrator', 1, CAST(N'2019-03-29T20:15:07.690' AS DateTime), N'127.0.0.1')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, N'MGPP Customer Services', 1, CAST(N'2019-03-29T20:15:07.690' AS DateTime), N'127.0.0.1')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, N'MGPP Read Only', 1, CAST(N'2019-03-29T20:15:07.690' AS DateTime), N'127.0.0.1')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, N'MGPP UW Review Approver', 1, CAST(N'2019-03-29T20:15:07.690' AS DateTime), N'127.0.0.1')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, N'MGPP Claim Review Approver', 1, CAST(N'2019-04-10T04:25:51.210' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, N'MGPP Claims Administrator', 1, CAST(N'2019-04-10T04:25:51.210' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, N'MGPP Customer Services', 1, CAST(N'2019-04-10T04:25:51.210' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, N'MGPP Read Only', 1, CAST(N'2019-04-10T04:25:51.210' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[AssignedRole] ([UserId], [Role], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, N'MGPP UW Review Approver', 1, CAST(N'2019-04-10T04:25:51.210' AS DateTime), N'192.168.1.44')
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (1, N'GP VTS', 1)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (2, N'Nirvoy Life', 2)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (3, N'GP Tracking', 3)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (4, N'Protection Plus- Credit Card', 4)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (5, N'Protection Plus- Debit Card', 5)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (6, N'Life & Liability', 6)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (7, N'Life & Livestock', 7)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (8, N'Life & Property', 8)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (9, N'Flood & Cyclone', 9)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (10, N'Life & PA', 10)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (11, N'Asset Only Fire', 11)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (12, N'Life, Liability & Asset (Partial)', 12)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (13, N'Life, Liability & Asset (Full)', 13)
GO
INSERT [dbo].[Benefit] ([BenefitId], [Name], [SeqNo]) VALUES (14, N'Asset With Flood & Cyclone', 14)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, N'CL-0000000001', 6, 9, 3, 2, 1, 1, NULL, CAST(N'2019-07-14' AS Date), CAST(N'2021-01-14' AS Date), CAST(40000.00 AS Numeric(18, 2)), CAST(35000.00 AS Numeric(18, 2)), CAST(N'2019-07-14' AS Date), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-14T16:26:41.143' AS DateTime), 3, CAST(N'2019-07-14T16:26:41.207' AS DateTime), N'103.240.248.250', 3, CAST(N'2019-07-14T16:34:08.420' AS DateTime), N'103.240.248.250', 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, N'CL-0000000002', 6, 9, 3, 2, 4, 7, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-25T16:42:47.887' AS DateTime), 3, CAST(N'2019-07-25T16:42:47.993' AS DateTime), N'116.58.205.172', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, N'CL-0000000003', 6, 9, 1, 1, 4, 7, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-25T19:02:25.543' AS DateTime), 3, CAST(N'2019-07-25T19:02:25.600' AS DateTime), N'116.58.205.172', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, N'CL-0000000004', 6, 9, 1, 1, 4, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-26T13:19:11.450' AS DateTime), 3, CAST(N'2019-07-26T13:19:11.530' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, N'CL-0000000005', 6, 9, 3, 2, 4, 7, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-26T13:33:18.200' AS DateTime), 3, CAST(N'2019-07-26T13:33:18.227' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, N'CL-0000000006', 6, 9, 1, 1, 6, 12, 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-30T03:12:14.580' AS DateTime), 3, CAST(N'2019-07-30T03:12:14.623' AS DateTime), N'43.245.122.211', 3, CAST(N'2019-07-30T03:12:57.343' AS DateTime), N'43.245.122.211', 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, N'CL-0000000007', 6, 9, 1, 1, 4, 7, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-30T03:18:43.000' AS DateTime), 3, CAST(N'2019-07-30T03:18:43.000' AS DateTime), N'43.245.122.211', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, N'CL-0000000008', 6, 9, 1, 1, 4, 7, 8, CAST(N'2019-07-25' AS Date), CAST(N'2020-07-25' AS Date), CAST(150000.00 AS Numeric(18, 2)), CAST(100000.00 AS Numeric(18, 2)), CAST(N'2019-07-28' AS Date), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-30T03:22:13.183' AS DateTime), 3, CAST(N'2019-07-30T03:22:13.183' AS DateTime), N'43.245.122.211', 3, CAST(N'2019-07-30T03:23:40.000' AS DateTime), N'43.245.122.211', 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, N'CL-0000000009', 6, 9, 1, 1, 4, 7, 8, CAST(N'2019-07-25' AS Date), CAST(N'2020-07-25' AS Date), CAST(120000.00 AS Numeric(18, 2)), CAST(100000.00 AS Numeric(18, 2)), CAST(N'2019-07-29' AS Date), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-30T03:26:14.010' AS DateTime), 3, CAST(N'2019-07-30T03:26:14.010' AS DateTime), N'43.245.122.211', 3, CAST(N'2019-07-30T03:27:41.000' AS DateTime), N'43.245.122.211', 1)
GO
INSERT [dbo].[Claim] ([ClaimId], [ClaimNumber], [PartnerId], [ProductId], [BusinessId], [UnderWriterId], [PolicyId], [InsuredId], [NotifierId], [CoverStartDate], [CoverEndDate], [CoverAmount], [RevisedCoverAmount], [DateOfIncident], [DateNotified], [DocumentCompleteDate], [ReminderDueDate], [ReminderComment], [UWReviewRequired], [ApprovedAmount], [Decision], [RejectionReason], [ReviewBy], [ReviewDate], [ConfirmedBy], [ConfirmedDate], [UWSentDate], [UWExternalRef], [UWStatus], [UWAdviceDate], [UWAdviceFrom], [UWAdviceRef], [UWApprovedAmount], [UWDecision], [UWRejectionReason], [UWReviewBy], [UWReviewDate], [UWConfirmedBy], [UWConfirmedDate], [UWRefundPending], [ClaimPaidInPart], [PaymentTATDetails], [PaymentDueDate], [ClosureReason], [ClosureDate], [ClaimStatus], [StatusCreated], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (10, N'CL-0000000010', 6, 9, 1, 1, 4, 7, 8, CAST(N'2019-07-25' AS Date), CAST(N'2020-07-25' AS Date), CAST(90000.00 AS Numeric(18, 2)), CAST(20000.00 AS Numeric(18, 2)), CAST(N'2019-07-29' AS Date), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Registered', CAST(N'2019-07-30T11:43:52.440' AS DateTime), 3, CAST(N'2019-07-30T11:43:52.490' AS DateTime), N'43.245.122.211', 3, CAST(N'2019-07-30T11:47:04.443' AS DateTime), N'43.245.122.211', 1)
GO
SET IDENTITY_INSERT [dbo].[ClaimIncident] ON 

GO
INSERT [dbo].[ClaimIncident] ([IncidentId], [ClaimId], [DateOfDeath], [LocationOfIncident], [IncidentType], [DaysFromIncident], [HospitalName], [HospitalWard], [HospitalLocation], [CauseOfIncident], [Note], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, 1, CAST(N'2019-07-14' AS Date), N'Motijheel', N'Accident', 0, NULL, NULL, NULL, N'', NULL, 3, CAST(N'2019-07-14T16:35:19.853' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ClaimIncident] OFF
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, N'Primary Insured', N'Unknown', 29, N'Karim', N'Ahmed', N'0917456789', N'123456789', CAST(N'1990-07-04' AS Date), N'Male', N'Married', N'National Id Card', N'456789456789', N'156, Boro Mogbazar', N'karim@gmail.com', N'Dhaka', N'Bengali', N'1235', N'SMS', 3, CAST(N'2019-07-14T03:52:40.130' AS DateTime), N'103.240.248.250', 3, CAST(N'2019-07-14T16:30:36.333' AS DateTime), N'103.240.248.250', 2)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, N'Nominee', N'Spouse', 20, N'Jamila', N'Begum', N'01737894561', N'456789456789', CAST(N'1999-02-09' AS Date), N'Female', N'Married', N'National Id Card', N'789456123', N'156, Boro Mogbazar', N'jamila@gmail.com', N'Dhaka', NULL, N'1235', NULL, 3, CAST(N'2019-07-14T15:52:40.130' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, N'Primary Insured', N'Unknown', 29, N'Rahim', N'Sarwar', N'01798456789', N'789456123123', CAST(N'1989-07-25' AS Date), N'Male', N'Married', N'National Id Card', N'789456123', N'Wari', N'rahim@gmail.coom', N'Dhaka', N'Bengali', N'1267', N'SMS', 3, CAST(N'2019-07-14T16:03:38.330' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, N'Nominee', N'Parent', 40, N'Abdus', N'Sattar', N'01798456123', N'456789123456', CAST(N'1979-04-03' AS Date), N'Male', N'Married', N'National Id Card', N'78951278914', N'Wari', NULL, N'Dhaka', NULL, N'1267', NULL, 3, CAST(N'2019-07-14T16:03:38.330' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, N'Primary Insured', N'Unknown', 30, N'Abul', N'Hosain', N'1234567890', N'45678906789', CAST(N'1989-03-01' AS Date), N'Male', N'Married', N'National Id Card', N'98765432123456', N'Dhaka', NULL, N'Dhaka', NULL, NULL, NULL, 2, CAST(N'2019-07-18T14:52:58.340' AS DateTime), N'43.245.120.111', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, N'Beneficiary', N'Parent', 29, N'Naser', N'Haider', N'34567890', N'234567890', CAST(N'1990-07-11' AS Date), N'Male', N'Married', N'National Id Card', N'34567890', N'Dhaka', NULL, N'Dhaka', NULL, NULL, NULL, 2, CAST(N'2019-07-18T14:52:58.340' AS DateTime), N'43.245.120.111', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, N'Primary Insured', N'Unknown', 39, N'Shain', N'Mia', N'01934567898', N'01658929349301', CAST(N'1980-03-13' AS Date), N'Male', N'Married', N'National Id Card', N'123456789345678', N'House: 01, Road: 01, Topkhana Road', NULL, N'Khulna', N'Bengali', N'2345', N'SMS', 3, CAST(N'2019-07-25T16:03:56.937' AS DateTime), N'116.58.205.172', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, N'Nominee', N'Spouse', 25, N'Renuka', N'Begum', N'0192345678456', NULL, CAST(N'1993-11-02' AS Date), N'Female', N'Married', N'Birth Certificate', N'09876542345678', N'House: 01, Road: 01, Topkhana Road', NULL, N'Khulna', NULL, N'2345', NULL, 3, CAST(N'2019-07-25T04:03:56.937' AS DateTime), N'116.58.205.172', 3, CAST(N'2019-07-30T03:26:39.950' AS DateTime), N'43.245.122.211', 3)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, N'Notifier', N'Unknown', 25, N'Renuka', NULL, N'0192345678456', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Renuka', NULL, NULL, NULL, NULL, 3, CAST(N'2019-07-26T13:33:18.227' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (10, N'Primary Insured', N'Unknown', 33, N'Abdur', N'Rahman', N'019234567', N'1643268901', CAST(N'1985-11-04' AS Date), N'Male', N'Married', N'National Id Card', N'234567890567', N'House01, Road:01, Sector 03', NULL, N'Manikgonj', N'Bengali', N'2345', N'SMS', 3, CAST(N'2019-07-29T22:29:29.633' AS DateTime), N'43.245.121.221', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (11, N'Nominee', N'Spouse', 19, N'Rubina', N'Begum', N'091526743', N'57923265901', CAST(N'1999-10-04' AS Date), N'Female', N'Married', N'National Id Card', N'987654323456', N'House01, Road:01, Sector 03', NULL, N'Manikgonj', N'Bengali', N'2345', NULL, 3, CAST(N'2019-07-29T22:29:29.633' AS DateTime), N'43.245.121.221', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (12, N'Primary Insured', N'Unknown', 30, N'Masaddek', N'Ali', N'091456789', N'123456701', CAST(N'1989-06-20' AS Date), N'Male', N'Married', N'National Id Card', N'456789567897', N'House 01, Road: 01, Section: 01, Manikdi', NULL, N'Patuakhali', N'Bengali', N'5678', N'SMS', 3, CAST(N'2019-07-30T03:07:27.643' AS DateTime), N'43.245.122.211', 3, CAST(N'2019-07-30T03:12:57.373' AS DateTime), N'43.245.122.211', 2)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (13, N'Nominee', N'Spouse', 24, N'Aleya', N'Begum', N'019345678956', N'456785601', CAST(N'1994-11-24' AS Date), N'Female', N'Married', N'Birth Certificate', N'34567890-654', N'House 01, Road: 01, Section: 01, Manikdi', NULL, N'Patuakhli', NULL, N'5678', N'SMS', 3, CAST(N'2019-07-30T03:07:27.643' AS DateTime), N'43.245.122.211', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (14, N'Primary Insured', N'Unknown', 29, N'Rahim', N'Sarwar', N'01798456789', N'789456123123', CAST(N'1989-07-25' AS Date), N'Male', N'Married', N'National Id Card', N'789456123', N'Wari', N'rahim@gmail.coom', N'Dhaka', N'Bengali', N'1267', N'SMS', 9, CAST(N'2019-10-27T11:09:10.757' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Client] ([ClientId], [ClientType], [Relationship], [AgeAtCreationDate], [FirstName], [LastName], [MobileNo], [AccountNo], [DateofBirth], [Gender], [MaritalStatus], [PersonalIdType], [PersonalId], [Address], [Email], [Location], [Language], [PostalCode], [Communication], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (15, N'Nominee', N'Parent', 40, N'Abdus', N'Sattar', N'01798456123', N'456789123456', CAST(N'1979-04-03' AS Date), N'Male', N'Married', N'National Id Card', N'78951278914', N'Wari', NULL, N'Dhaka', NULL, N'1267', NULL, 9, CAST(N'2019-10-27T11:09:10.757' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[Configuration] ON 

GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, N'AssetType', N'Combined', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, N'AssetType', N'Equipment', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, N'AssetType', N'Livestock', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, N'AssetType', N'Machinery', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, N'AssetType', N'Property', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, N'AssetType', N'Refurbishment', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, N'AssetType', N'Stock', N'7', NULL, 7, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, N'AssetType', N'Vehicle', N'8', NULL, 8, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, N'AssetType', N'Other', N'9', NULL, 9, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (10, N'Gender', N'Male', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (11, N'Gender', N'Female', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (12, N'Gender', N'Not Disclosed', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (14, N'MaritalStatus', N'Common Law', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (15, N'MaritalStatus', N'Divorced', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (16, N'MaritalStatus', N'Married', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (17, N'MaritalStatus', N'Separated', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (18, N'MaritalStatus', N'Single', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (19, N'MaritalStatus', N'Single Parent', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (20, N'MaritalStatus', N'Unknown', N'7', NULL, 7, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (21, N'MaritalStatus', N'Widowed', N'8', NULL, 8, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (22, N'PersonalIdType', N'National Id Card', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (23, N'PersonalIdType', N'Birth Certificate', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (24, N'PersonalIdType', N'Drivers Licence', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (25, N'PersonalIdType', N'Passport Id', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (26, N'PersonalIdType', N'Other', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (36, N'ClientType', N'Secondary Insured', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (37, N'ClientType', N'Beneficiary', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (38, N'ClientType', N'Nominee', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (39, N'ClientType', N'Income Generating', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (40, N'Relationship', N'Spouse', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (41, N'Relationship', N'Parent', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (42, N'Relationship', N'Child', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (43, N'Relationship', N'Sibling', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (44, N'Relationship', N'Other', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (52, N'StructureType', N'First Class', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (53, N'StructureType', N'Second Class', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (54, N'PolicyStatus', N'Active', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (55, N'PolicyStatus', N'Ended', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (56, N'ClaimStatus', N'Registered', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (57, N'ClaimStatus', N'Documents Incomplete', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (58, N'ClaimStatus', N'Awaiting Claim Validation', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (59, N'ClaimStatus', N'Awaiting UW Decision', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (60, N'ClaimStatus', N'Awaiting Payment', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (61, N'ClaimStatus', N'Closed', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (62, N'ClientType', N'Primary Insured', N'0', NULL, 0, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (63, N'EndReason', N'Cancelled By Client', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (64, N'EndReason', N'Cancelled By Partner', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (65, N'EndReason', N'Cancelled Internally', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (66, N'EndReason', N'Claimed In Full', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (67, N'EndReason', N'Lapsed', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (68, N'EndReason', N'Life Claim', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (69, N'AssignedRoles', N'MGPP Read Only', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (70, N'AssignedRoles', N'MGPP Customer Services', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (71, N'AssignedRoles', N'MGPP Claims Administrator', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (72, N'AssignedRoles', N'MGPP UW Review Approver', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (73, N'AssignedRoles', N'MGPP Claim Review Approver', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (74, N'ClosureReason', N'Admitted for less time than policy requires', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (75, N'ClosureReason', N'Claimant/Partner not interested in claim', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (76, N'ClosureReason', N'Created in error', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (77, N'ClosureReason', N'Duplicate', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (78, N'ClosureReason', N'Enquiry - Not a claim', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (79, N'ClosureReason', N'Invalid - Insured unregistered', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (80, N'ClosureReason', N'Invalid - No cover', N'7', NULL, 7, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (81, N'ClosureReason', N'Invalid - Not insured at time of incident', N'8', NULL, 8, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (82, N'ClosureReason', N'Invalid - Same month of enrolment', N'9', NULL, 9, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (83, N'ClosureReason', N'Late notification of claim', N'10', NULL, 10, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (84, N'ClosureReason', N'Not admitted to hospital', N'11', NULL, 11, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (85, N'ClosureReason', N'Provisionally closed', N'12', NULL, 12, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (86, N'ClosureReason', N'Rejected - Claim Review', N'13', NULL, 13, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (87, N'ClosureReason', N'Rejected - UW Review', N'14', NULL, 14, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (88, N'ClosureReason', N'Required documents unavailable', N'15', NULL, 15, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (89, N'ClosureReason', N'Waiting period', N'16', NULL, 16, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (90, N'IncidentType', N'Accident', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (91, N'IncidentType', N'Financial Change', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (92, N'IncidentType', N'Illness', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (93, N'IncidentType', N'Maternity', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (94, N'IncidentType', N'Medical Procedure', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (95, N'IncidentType', N'Natural Disaster', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (96, N'IncidentType', N'Other', N'7', NULL, 7, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (97, N'IncidentType', N'Victim of Crime', N'8', NULL, 8, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (98, N'CauseOfIncident', N'Abdominal Pain', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (99, N'CauseOfIncident', N'Abortion', N'2', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (100, N'CauseOfIncident', N'Abrasions', N'3', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (101, N'CauseOfIncident', N'Acquisition', N'4', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (102, N'CauseOfIncident', N'Acute Coronary Syndrome', N'5', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (103, N'CauseOfIncident', N'Acute Haemorrhagic Pancreatitis', N'6', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (104, N'CauseOfIncident', N'Acute Haemorrhagic Shock', N'7', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (105, N'CauseOfIncident', N'Acute Myocardial Infarction', N'8', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (106, N'CauseOfIncident', N'Acute Pancreatitis', N'9', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (107, N'CauseOfIncident', N'Acute Pulmonary Arrest', N'10', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (108, N'CauseOfIncident', N'Acute Pulmonary Congestion', N'11', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (109, N'CauseOfIncident', N'Acute Pulmonary Failure', N'12', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (110, N'CauseOfIncident', N'Acute Respiratory Arrest', N'13', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (111, N'CauseOfIncident', N'Acute Respiratory Distress Syndrome', N'14', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (112, N'CauseOfIncident', N'Acute Respiratory Failure', N'15', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (113, N'CauseOfIncident', N'AIDS', N'16', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (114, N'CauseOfIncident', N'Alcoholic Liver Disease', N'17', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (115, N'CauseOfIncident', N'Allergy', N'18', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (116, N'CauseOfIncident', N'Amnesia', N'19', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (117, N'CauseOfIncident', N'Amputation', N'20', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (118, N'CauseOfIncident', N'Anaemia', N'21', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (119, N'CauseOfIncident', N'Animal Attack', N'22', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (120, N'CauseOfIncident', N'Appendicitis', N'23', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (121, N'CauseOfIncident', N'Appendix Operation', N'24', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (122, N'CauseOfIncident', N'Armed Robbery', N'25', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (123, N'CauseOfIncident', N'Arrhythmia', N'26', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (124, N'CauseOfIncident', N'Arson', N'27', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (125, N'CauseOfIncident', N'Arthritis', N'28', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (126, N'CauseOfIncident', N'Asphyxia', N'29', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (127, N'CauseOfIncident', N'Assault', N'30', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (128, N'CauseOfIncident', N'Assault With Weapon', N'31', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (129, N'CauseOfIncident', N'Asthma', N'32', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (130, N'CauseOfIncident', N'Asthmatic Attack', N'33', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (131, N'CauseOfIncident', N'Avalanche', N'34', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (132, N'CauseOfIncident', N'Bankruptcy', N'35', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (133, N'CauseOfIncident', N'Benign Prostatic Hyperplasia', N'36', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (134, N'CauseOfIncident', N'Bleeding', N'37', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (135, N'CauseOfIncident', N'Blood Dyscrasia', N'38', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (136, N'CauseOfIncident', N'Blood Problem', N'39', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (137, N'CauseOfIncident', N'Body Pains', N'40', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (138, N'CauseOfIncident', N'Boil', N'41', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (139, N'CauseOfIncident', N'Bone Cancer', N'42', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (140, N'CauseOfIncident', N'Brain Herniation', N'43', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (141, N'CauseOfIncident', N'Brain Tumour', N'44', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (142, N'CauseOfIncident', N'Brainstem Failure', N'45', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (143, N'CauseOfIncident', N'Breast Cancer', N'46', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (144, N'CauseOfIncident', N'Breast Carcinoma', N'47', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (145, N'CauseOfIncident', N'Bronchial Asthma', N'48', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (146, N'CauseOfIncident', N'Broncho Pneumonia', N'49', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (147, N'CauseOfIncident', N'Bronchogenic Cancer', N'50', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (148, N'CauseOfIncident', N'Burglary', N'51', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (149, N'CauseOfIncident', N'Burns', N'52', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (150, N'CauseOfIncident', N'Buruli Ulcer', N'53', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (151, N'CauseOfIncident', N'Cancer', N'54', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (152, N'CauseOfIncident', N'Cancer Of The Breast', N'55', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (153, N'CauseOfIncident', N'Cancer Of The Colon', N'56', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (154, N'CauseOfIncident', N'Cancer Of The Liver', N'57', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (155, N'CauseOfIncident', N'Cancer Of The Lung', N'58', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (156, N'CauseOfIncident', N'Cancer Of The Nose', N'59', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (157, N'CauseOfIncident', N'Cancer Of The Ovary', N'60', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (158, N'CauseOfIncident', N'Cancer Of The Pancreas', N'61', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (159, N'CauseOfIncident', N'Carcinoma', N'62', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (160, N'CauseOfIncident', N'Cardiac Arrest', N'63', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (161, N'CauseOfIncident', N'Cardiac Arrhythmia', N'64', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (162, N'CauseOfIncident', N'Cardiac Dysrhythmia', N'65', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (163, N'CauseOfIncident', N'Cardiac Failure', N'66', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (164, N'CauseOfIncident', N'Cardio Pulmonary Arrest', N'67', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (165, N'CauseOfIncident', N'Cardio Pulmonary Failure', N'68', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (166, N'CauseOfIncident', N'Cardio Respiratory Arrest', N'69', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (167, N'CauseOfIncident', N'Cardio Respiratory Failure', N'70', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (168, N'CauseOfIncident', N'Cardio Vascular Accident', N'71', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (169, N'CauseOfIncident', N'Cardiogenic Shock', N'72', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (170, N'CauseOfIncident', N'Cardiomegaly', N'73', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (171, N'CauseOfIncident', N'Cardiovascular Arrest', N'74', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (172, N'CauseOfIncident', N'Cardiovascular Disease', N'75', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (173, N'CauseOfIncident', N'Cellulitis', N'76', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (174, N'CauseOfIncident', N'Cerebral Bleed', N'77', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (175, N'CauseOfIncident', N'Cerebral Contusion', N'78', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (176, N'CauseOfIncident', N'Cerebral Haemorrhage', N'79', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (177, N'CauseOfIncident', N'Cerebral Palsy', N'80', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (178, N'CauseOfIncident', N'Cerebral Problem', N'81', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (179, N'CauseOfIncident', N'Cerebral Vascular Accident', N'82', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (180, N'CauseOfIncident', N'Cerebrovascular Accident', N'83', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (181, N'CauseOfIncident', N'Cerebrovascular Disease', N'83', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (182, N'CauseOfIncident', N'Cervical Cancer', N'84', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (183, N'CauseOfIncident', N'Chemical', N'85', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (184, N'CauseOfIncident', N'Chest Complications', N'86', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (185, N'CauseOfIncident', N'Chest Infection', N'87', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (186, N'CauseOfIncident', N'Chest Pain', N'88', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (187, N'RejectionReason', N'Admitted for less time than policy requires', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (188, N'RejectionReason', N'Age limit', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (189, N'RejectionReason', N'Condition is not a permanent disability', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (190, N'RejectionReason', N'Document forged', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (191, N'RejectionReason', N'Employee retrenched during probation', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (192, N'RejectionReason', N'Employee was on contract', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (193, N'RejectionReason', N'Hospital not accredited', N'7', NULL, 7, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (194, N'RejectionReason', N'Invalid - Not insured at time of incident', N'8', NULL, 8, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (195, N'RejectionReason', N'Invalid - Not registered for insurance', N'9', NULL, 9, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (196, N'RejectionReason', N'Invalid - Same month of enrolment', N'10', NULL, 10, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (197, N'RejectionReason', N'Late notification of claim', N'11', NULL, 11, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (198, N'RejectionReason', N'Not admitted to hospital', N'12', NULL, 12, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (199, N'RejectionReason', N'Other - See notes', N'13', NULL, 13, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (200, N'RejectionReason', N'Policy exclusions - See notes', N'14', NULL, 14, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (201, N'RejectionReason', N'Pre-existing condition', N'15', NULL, 15, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (202, N'RejectionReason', N'Self-inflicted injury or damage', N'16', NULL, 16, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (203, N'RejectionReason', N'Stock/business not covered', N'17', NULL, 17, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (204, N'RejectionReason', N'Suspected fraud', N'18', NULL, 18, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (205, N'RejectionReason', N'Waiting period', N'19', NULL, 19, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (206, N'DocumentType', N'Accident Report', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (207, N'DocumentType', N'Admission Form', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (208, N'DocumentType', N'Affidavit', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (209, N'DocumentType', N'Amortization Schedule', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (210, N'DocumentType', N'Appointment Letter', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (211, N'DocumentType', N'Bank Statement', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (212, N'DocumentType', N'Birth Certificate', N'7', NULL, 7, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (213, N'DocumentType', N'Burial Permit', N'8', NULL, 8, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (214, N'DocumentType', N'Claim Form', N'9', NULL, 9, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (215, N'DocumentType', N'Coroner Report', N'10', NULL, 10, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (216, N'DocumentType', N'Death Certificate', N'11', NULL, 11, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (217, N'DocumentType', N'Discharge Form', N'12', NULL, 12, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (218, N'DocumentType', N'Driver Licence', N'13', NULL, 13, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (219, N'DocumentType', N'Employment Verification', N'14', NULL, 14, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (220, N'DocumentType', N'Excuse Duty Form', N'15', NULL, 15, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (221, N'DocumentType', N'Field Inspector Report', N'16', NULL, 16, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (222, N'DocumentType', N'Fire Department Report', N'17', NULL, 17, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (223, N'DocumentType', N'Hospital Audit Form', N'18', NULL, 18, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (224, N'DocumentType', N'Identity Document', N'19', NULL, 19, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (225, N'DocumentType', N'Insurance Document', N'20', NULL, 20, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (226, N'DocumentType', N'Letter Of Attestation', N'21', NULL, 21, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (227, N'DocumentType', N'Loan Documents', N'22', NULL, 22, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (228, N'DocumentType', N'Loan Officer Report', N'23', NULL, 23, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (229, N'DocumentType', N'Marriage Certificate', N'24', NULL, 24, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (230, N'DocumentType', N'Medical Declaration Form', N'25', NULL, 25, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (231, N'DocumentType', N'Medical Report', N'26', NULL, 26, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (232, N'DocumentType', N'Mortuary Receipt', N'27', NULL, 27, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (233, N'DocumentType', N'Other', N'28', NULL, 28, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (234, N'DocumentType', N'Ownership Document', N'29', NULL, 29, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (235, N'DocumentType', N'Passport', N'30', NULL, 30, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (236, N'DocumentType', N'Patients Bill', N'31', NULL, 31, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (237, N'DocumentType', N'Payslip', N'32', NULL, 32, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (238, N'DocumentType', N'Photograph', N'33', NULL, 33, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (239, N'DocumentType', N'Police Report', N'34', NULL, 34, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (240, N'DocumentType', N'Repayment Schedule', N'35', NULL, 35, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (241, N'DocumentType', N'Retrenchment Letter', N'36', NULL, 36, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (242, N'DocumentType', N'Salary Verification', N'37', NULL, 37, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (243, N'DocumentType', N'SIM Card Receipt', N'38', NULL, 38, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (244, N'DocumentType', N'Stock Declaration', N'39', NULL, 39, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (245, N'UnderwriterStatus', N'Awaiting MM registration', N'1', NULL, 1, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (246, N'UnderwriterStatus', N'Conducting investigations', N'2', NULL, 2, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (247, N'UnderwriterStatus', N'Delayed - Awaiting funds', N'3', NULL, 3, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (248, N'UnderwriterStatus', N'Delayed - Awaiting premium', N'4', NULL, 4, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (249, N'UnderwriterStatus', N'Pending claim approval', N'5', NULL, 5, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (250, N'UnderwriterStatus', N'Pending payment approval', N'6', NULL, 6, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Configuration] ([ConfigId], [ConfigType], [ConfigName], [ConfigValue], [Description], [SeqNo], [IsSystemConfig], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (251, N'UnderwriterStatus', N'Requested for more documents', N'7', NULL, 7, 0, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[Configuration] OFF
GO
INSERT [dbo].[Country] ([CountryId], [Name]) VALUES (1, N'Bangladesh')
GO
INSERT [dbo].[Country] ([CountryId], [Name]) VALUES (2, N'South Africa')
GO
SET IDENTITY_INSERT [dbo].[CoverFormula] ON 

GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (1, 6, CAST(30000.00 AS Numeric(18, 2)), CAST(50000.00 AS Numeric(18, 2)), CAST(5000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (2, 6, CAST(50001.00 AS Numeric(18, 2)), CAST(100000.00 AS Numeric(18, 2)), CAST(10000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (3, 6, CAST(100001.00 AS Numeric(18, 2)), CAST(200000.00 AS Numeric(18, 2)), CAST(20000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (4, 6, CAST(200001.00 AS Numeric(18, 2)), CAST(300000.00 AS Numeric(18, 2)), CAST(30000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (5, 6, CAST(300001.00 AS Numeric(18, 2)), CAST(400000.00 AS Numeric(18, 2)), CAST(40000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (6, 6, CAST(400001.00 AS Numeric(18, 2)), CAST(500000.00 AS Numeric(18, 2)), CAST(50000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (7, 6, CAST(500001.00 AS Numeric(18, 2)), CAST(600000.00 AS Numeric(18, 2)), CAST(60000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (8, 6, CAST(600001.00 AS Numeric(18, 2)), CAST(700000.00 AS Numeric(18, 2)), CAST(70000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (9, 6, CAST(700001.00 AS Numeric(18, 2)), CAST(800000.00 AS Numeric(18, 2)), CAST(80000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (10, 6, CAST(800001.00 AS Numeric(18, 2)), CAST(900000.00 AS Numeric(18, 2)), CAST(90000.00 AS Numeric(18, 2)))
GO
INSERT [dbo].[CoverFormula] ([CoverId], [ProductId], [FromAmount], [ToAmount], [CoverAmount]) VALUES (11, 6, CAST(900001.00 AS Numeric(18, 2)), CAST(1000000.00 AS Numeric(18, 2)), CAST(100000.00 AS Numeric(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[CoverFormula] OFF
GO
INSERT [dbo].[LineOfBusiness] ([BusinessId], [Name], [UnderWriterId], [SeqNo]) VALUES (1, N'Asset', 1, 1)
GO
INSERT [dbo].[LineOfBusiness] ([BusinessId], [Name], [UnderWriterId], [SeqNo]) VALUES (2, N'Credit Life', 2, 2)
GO
INSERT [dbo].[LineOfBusiness] ([BusinessId], [Name], [UnderWriterId], [SeqNo]) VALUES (3, N'Life', 2, 3)
GO
INSERT [dbo].[LineOfBusiness] ([BusinessId], [Name], [UnderWriterId], [SeqNo]) VALUES (4, N'Accidental Death', 2, 4)
GO
INSERT [dbo].[LineOfBusiness] ([BusinessId], [Name], [UnderWriterId], [SeqNo]) VALUES (5, N'Disability', 2, 5)
GO
INSERT [dbo].[LineOfBusiness] ([BusinessId], [Name], [UnderWriterId], [SeqNo]) VALUES (6, N'Hospitalisation', 2, 6)
GO
INSERT [dbo].[NirvoyClient] ([ClientId], [Name], [MobileNumber], [Age], [PersonalIdType], [PersonalId], [BeneName], [BeneMobileNumber], [BeneAge], [BeneRelationship], [LoanAmount], [DeviceOwnership], [AcceptsTerms], [ThirdPartyAuthorized], [SubscriptionChannel], [AgentMobileNumber], [EntrySource], [Status], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, N'User Name', N'+8801701528524', 29, N'National Id Card', N'89475487454', N'Bene Name', N'+8801703548524', 20, N'Spouse', NULL, N'Owner', 1, 1, N'Self Registration', NULL, N'External', N'Registered', 4, CAST(N'2019-09-18T13:01:46.440' AS DateTime), N'169.254.200.74', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[NirvoyClient] ([ClientId], [Name], [MobileNumber], [Age], [PersonalIdType], [PersonalId], [BeneName], [BeneMobileNumber], [BeneAge], [BeneRelationship], [LoanAmount], [DeviceOwnership], [AcceptsTerms], [ThirdPartyAuthorized], [SubscriptionChannel], [AgentMobileNumber], [EntrySource], [Status], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, N'User Name', N'+8801781528524', 29, N'National Id Card', N'89475487454', N'Bene Name', N'+8801703548524', 20, N'Spouse', NULL, N'Owner', 1, 1, N'Self Registration', NULL, N'External', N'Registered', 4, CAST(N'2019-09-18T13:58:46.627' AS DateTime), N'169.254.200.74', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[NirvoyClient] ([ClientId], [Name], [MobileNumber], [Age], [PersonalIdType], [PersonalId], [BeneName], [BeneMobileNumber], [BeneAge], [BeneRelationship], [LoanAmount], [DeviceOwnership], [AcceptsTerms], [ThirdPartyAuthorized], [SubscriptionChannel], [AgentMobileNumber], [EntrySource], [Status], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, N'Salima Jahan Nila', N'8801719400370', 62, N'National Id Card', N'264423245', N'Alinor', N'8801712356789', 42, N'Parent', NULL, N'Legal User', 1, 1, N'Self Registration', NULL, N'Portal', N'Registered', 4, CAST(N'2020-01-26T15:51:08.403' AS DateTime), N'37.111.202.227', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Partner] ([PartnerId], [PartnerCode], [Name], [CountryId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, N'PAT-19-00001', N'GrameenPhone', 1, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Partner] ([PartnerId], [PartnerCode], [Name], [CountryId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, N'PAT-19-00002', N'Jamuna Bank', 1, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Partner] ([PartnerId], [PartnerCode], [Name], [CountryId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, N'PAT-19-00003', N'Ghashful', 1, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Partner] ([PartnerId], [PartnerCode], [Name], [CountryId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, N'PAT-19-00004', N'National Development Programme', 1, 4, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Partner] ([PartnerId], [PartnerCode], [Name], [CountryId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, N'PAT-19-00005', N'Hello Paisa Bangladesh', 2, 5, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Partner] ([PartnerId], [PartnerCode], [Name], [CountryId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, N'PAT-19-00006', N'Demo Bank', 1, 6, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Policy] ([PolicyId], [PolicyNumber], [PartnerId], [ProductId], [BenefitId], [PolicyStart], [PolicyEnd], [SalesReference], [ContributionExtRef], [ExternalId], [LoanAmount], [CoverStartDate], [TermMonths], [CoverEndDate], [AccountNo], [Category], [OfficerId], [OfficerName], [CentreLocation], [Cycle], [RequestedEndDate], [EndReason], [EntrySource], [PolicyStatus], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, N'BDG-0000000001', 6, 9, 6, CAST(N'2019-07-14' AS Date), NULL, N'DhkMog123', NULL, N'123456789', CAST(100000.00 AS Numeric(18, 2)), CAST(N'2019-07-14' AS Date), 18, CAST(N'2021-01-14' AS Date), N'123456789', N'SME', N'Demo12', N'Mustafiz', N'Mogbazar', NULL, NULL, NULL, NULL, N'Active', 3, CAST(N'2019-07-14T15:52:40.127' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Policy] ([PolicyId], [PolicyNumber], [PartnerId], [ProductId], [BenefitId], [PolicyStart], [PolicyEnd], [SalesReference], [ContributionExtRef], [ExternalId], [LoanAmount], [CoverStartDate], [TermMonths], [CoverEndDate], [AccountNo], [Category], [OfficerId], [OfficerName], [CentreLocation], [Cycle], [RequestedEndDate], [EndReason], [EntrySource], [PolicyStatus], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, N'BDG-0000000002', 6, 9, 12, CAST(N'2019-07-14' AS Date), CAST(N'2019-07-14' AS Date), N'DemoMotijheel123', NULL, N'789456123123', CAST(250000.00 AS Numeric(18, 2)), CAST(N'2019-07-14' AS Date), 12, CAST(N'2020-07-14' AS Date), N'789456123123', N'SME', N'Demo45', N'Shahrtiar', N'Wari, Old Dhaka', NULL, CAST(N'2019-07-14' AS Date), N'Lapsed', NULL, N'Ended', 3, CAST(N'2019-07-14T16:03:38.330' AS DateTime), N'103.240.248.250', 3, CAST(N'2019-07-14T16:12:37.270' AS DateTime), N'103.240.248.250', 1)
GO
INSERT [dbo].[Policy] ([PolicyId], [PolicyNumber], [PartnerId], [ProductId], [BenefitId], [PolicyStart], [PolicyEnd], [SalesReference], [ContributionExtRef], [ExternalId], [LoanAmount], [CoverStartDate], [TermMonths], [CoverEndDate], [AccountNo], [Category], [OfficerId], [OfficerName], [CentreLocation], [Cycle], [RequestedEndDate], [EndReason], [EntrySource], [PolicyStatus], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, N'BDG-0000000003', 3, 6, 6, CAST(N'2019-07-17' AS Date), CAST(N'2019-07-18' AS Date), N'dfghjk', NULL, N'23456789', CAST(12345678.00 AS Numeric(18, 2)), CAST(N'2019-07-18' AS Date), 12, CAST(N'2020-07-18' AS Date), N'34567890', NULL, NULL, NULL, NULL, NULL, CAST(N'2019-07-18' AS Date), N'Lapsed', NULL, N'Ended', 2, CAST(N'2019-07-18T14:52:58.337' AS DateTime), N'43.245.120.111', 2, CAST(N'2019-07-18T14:54:21.117' AS DateTime), N'43.245.120.111', 1)
GO
INSERT [dbo].[Policy] ([PolicyId], [PolicyNumber], [PartnerId], [ProductId], [BenefitId], [PolicyStart], [PolicyEnd], [SalesReference], [ContributionExtRef], [ExternalId], [LoanAmount], [CoverStartDate], [TermMonths], [CoverEndDate], [AccountNo], [Category], [OfficerId], [OfficerName], [CentreLocation], [Cycle], [RequestedEndDate], [EndReason], [EntrySource], [PolicyStatus], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, N'BDG-0000000004', 6, 9, 12, CAST(N'2019-07-25' AS Date), NULL, N'Aminbazar013', NULL, N'01658929349301', CAST(200000.00 AS Numeric(18, 2)), CAST(N'2019-07-25' AS Date), 12, CAST(N'2020-07-25' AS Date), N'01658929349301', N'SME', N'DEMO112', N'Saiful Islam', N'Aminbazar Super market, Khulna', NULL, NULL, NULL, NULL, N'Active', 3, CAST(N'2019-07-25T16:03:56.930' AS DateTime), N'116.58.205.172', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Policy] ([PolicyId], [PolicyNumber], [PartnerId], [ProductId], [BenefitId], [PolicyStart], [PolicyEnd], [SalesReference], [ContributionExtRef], [ExternalId], [LoanAmount], [CoverStartDate], [TermMonths], [CoverEndDate], [AccountNo], [Category], [OfficerId], [OfficerName], [CentreLocation], [Cycle], [RequestedEndDate], [EndReason], [EntrySource], [PolicyStatus], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, N'BDG-0000000005', 6, 9, 12, CAST(N'2019-07-29' AS Date), NULL, N'Manikgonj011', NULL, N'1643268901', CAST(200000.00 AS Numeric(18, 2)), CAST(N'2019-07-29' AS Date), 12, CAST(N'2020-07-29' AS Date), N'1643268901', N'SME', N'DemoBank122', N'ABC', N'Manikgonj', NULL, NULL, NULL, NULL, N'Active', 3, CAST(N'2019-07-29T22:29:29.630' AS DateTime), N'43.245.121.221', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Policy] ([PolicyId], [PolicyNumber], [PartnerId], [ProductId], [BenefitId], [PolicyStart], [PolicyEnd], [SalesReference], [ContributionExtRef], [ExternalId], [LoanAmount], [CoverStartDate], [TermMonths], [CoverEndDate], [AccountNo], [Category], [OfficerId], [OfficerName], [CentreLocation], [Cycle], [RequestedEndDate], [EndReason], [EntrySource], [PolicyStatus], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, N'BDG-0000000006', 6, 9, 12, CAST(N'2019-07-30' AS Date), NULL, N'Manikdi011', NULL, N'123456701', CAST(200000.00 AS Numeric(18, 2)), CAST(N'2019-07-30' AS Date), 12, CAST(N'2020-07-30' AS Date), N'123456701', N'SME', N'DemoBank012', N'Ali Haider', N'Manikdi', NULL, NULL, NULL, NULL, N'Active', 3, CAST(N'2019-07-30T03:07:27.637' AS DateTime), N'43.245.122.211', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Policy] ([PolicyId], [PolicyNumber], [PartnerId], [ProductId], [BenefitId], [PolicyStart], [PolicyEnd], [SalesReference], [ContributionExtRef], [ExternalId], [LoanAmount], [CoverStartDate], [TermMonths], [CoverEndDate], [AccountNo], [Category], [OfficerId], [OfficerName], [CentreLocation], [Cycle], [RequestedEndDate], [EndReason], [EntrySource], [PolicyStatus], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, N'BDG-0000000007', 6, 9, 12, CAST(N'2019-07-14' AS Date), CAST(N'2019-07-14' AS Date), N'DemoMotijheel123', NULL, N'789456143123', CAST(250000.00 AS Numeric(18, 2)), CAST(N'2019-07-14' AS Date), 12, CAST(N'2020-07-14' AS Date), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'External', N'Active', 9, CAST(N'2019-10-27T11:09:10.750' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[PolicyAsset] ON 

GO
INSERT [dbo].[PolicyAsset] ([AssetId], [PolicyId], [AssetType], [AssetValue], [AssetDescription], [AssetCount], [BusinessDescription], [Address], [Location], [PostalCode], [StructureType], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, 2, N'Property', CAST(500000.00 AS Numeric(18, 2)), N'Business Property', 0, N'Grocery Store/Pharmacy', N'Shantinogor', N'Dhaka', N'1256', N'Second Class', 3, CAST(N'2019-07-14T16:03:38.330' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[PolicyAsset] ([AssetId], [PolicyId], [AssetType], [AssetValue], [AssetDescription], [AssetCount], [BusinessDescription], [Address], [Location], [PostalCode], [StructureType], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, 4, N'Property', CAST(250000.00 AS Numeric(18, 2)), N'Business Property', 0, N'Clothes/RMG/Shoe', N'New Market, Khulna', N'Khulna', N'2345', N'First Class', 3, CAST(N'2019-07-25T16:03:56.927' AS DateTime), N'116.58.205.172', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[PolicyAsset] ([AssetId], [PolicyId], [AssetType], [AssetValue], [AssetDescription], [AssetCount], [BusinessDescription], [Address], [Location], [PostalCode], [StructureType], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, 5, N'Property', CAST(400000.00 AS Numeric(18, 2)), N'Business Property', 0, N'Confectionary/Sweets Shop/Restaurant', N'Manikgonj Sadar', N'Manikgonj', N'2345', N'First Class', 3, CAST(N'2019-07-29T22:29:29.623' AS DateTime), N'43.245.121.221', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[PolicyAsset] ([AssetId], [PolicyId], [AssetType], [AssetValue], [AssetDescription], [AssetCount], [BusinessDescription], [Address], [Location], [PostalCode], [StructureType], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, 6, N'Property', CAST(500000.00 AS Numeric(18, 2)), N'Business Property', 0, N'Grocery Store/Pharmacy', N'Holding 156, Manikdi Sadar', N'Patuakhli', N'5678', N'First Class', 3, CAST(N'2019-07-30T03:07:27.637' AS DateTime), N'43.245.122.211', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[PolicyAsset] ([AssetId], [PolicyId], [AssetType], [AssetValue], [AssetDescription], [AssetCount], [BusinessDescription], [Address], [Location], [PostalCode], [StructureType], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, 7, N'Property', CAST(500000.00 AS Numeric(18, 2)), N'Business Property', 0, N'Grocery Store/Pharmacy', N'Shantinogor', N'Dhaka', N'1256', N'Second Class', 9, CAST(N'2019-10-27T11:09:10.750' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[PolicyAsset] OFF
GO
SET IDENTITY_INSERT [dbo].[PolicyClient] ON 

GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (1, 1, 1)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (2, 1, 2)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (3, 2, 3)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (4, 2, 4)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (5, 3, 5)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (6, 3, 6)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (7, 4, 7)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (8, 4, 8)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (9, 5, 10)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (10, 5, 11)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (11, 6, 12)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (12, 6, 13)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (13, 7, 14)
GO
INSERT [dbo].[PolicyClient] ([PCId], [PolicyId], [ClientId]) VALUES (14, 7, 15)
GO
SET IDENTITY_INSERT [dbo].[PolicyClient] OFF
GO
SET IDENTITY_INSERT [dbo].[PolicyNote] ON 

GO
INSERT [dbo].[PolicyNote] ([NoteId], [PolicyId], [Note], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, 2, N'Wrong information inserted thats why want to end this policy', 3, CAST(N'2019-07-14T16:12:37.297' AS DateTime), N'103.240.248.250', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[PolicyNote] ([NoteId], [PolicyId], [Note], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, 3, N'fhghjdlkfs', 2, CAST(N'2019-07-18T14:54:21.150' AS DateTime), N'43.245.120.111', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[PolicyNote] OFF
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, 1, N'PRO-19-00001', N'GP VTS', NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, 1, N'PRO-19-00002', N'Nirvoy Life', NULL, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, 1, N'PRO-19-00003', N'GP Tracking', NULL, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, 2, N'PRO-19-00004', N'Protection Plus- Credit Card', NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, 2, N'PRO-19-00005', N'Protection Plus- Debit Card', NULL, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, 3, N'PRO-19-00006', N'MSME Composite Product Insurance', NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, 4, N'PRO-19-00007', N'MSME Composite Product Insurance', NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, 5, N'PRO-19-00008', N'Hello Protect Bangladesh', NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Product] ([ProductId], [PartnerId], [ProductCode], [Name], [ExternalId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, 6, N'PRO-19-00009', N'Stapled Insurance Product', NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ProductBenefit] ON 

GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, 1, 1, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, 2, 2, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, 3, 3, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, 4, 4, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, 5, 5, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, 6, 6, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, 6, 7, N'Asset', NULL, NULL, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, 6, 8, N'Asset', NULL, NULL, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, 6, 9, N'Asset', NULL, NULL, 4, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (10, 7, 6, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (11, 7, 7, N'Asset', NULL, NULL, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (12, 7, 8, N'Asset', NULL, NULL, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (13, 7, 9, N'Asset', NULL, NULL, 4, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (14, 8, 10, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (15, 9, 6, NULL, NULL, NULL, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (16, 9, 11, N'Asset', N'Property', 1, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (17, 9, 12, N'Asset', N'Property', 1, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (18, 9, 13, N'Asset', N'Property', 1, 4, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBenefit] ([PBId], [ProductId], [BenefitId], [CoverageType], [DefaultAssetType], [DisableAssetType], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (19, 9, 14, N'Asset', N'Property', 1, 5, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ProductBenefit] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductBusiness] ON 

GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, 1, 4, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, 1, 5, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, 2, 3, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, 3, 3, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, 6, 1, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, 6, 2, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, 6, 3, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, 8, 4, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, 8, 3, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (10, 4, 2, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (11, 4, 3, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (12, 5, 2, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (13, 5, 3, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (14, 7, 1, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (15, 7, 2, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (16, 7, 3, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (17, 9, 1, 1, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (18, 9, 2, 2, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductBusiness] ([PLBId], [ProductId], [BusinessId], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (19, 9, 3, 3, 1, 1, CAST(N'2018-11-26T21:12:44.807' AS DateTime), N'192.168.1.104', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ProductBusiness] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductConfig] ON 

GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, 9, N'BusinessDescription', N'Tiles/Sanitary/Ceramics', NULL, 1, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, 9, N'BusinessDescription', N'Motor Auto Parts/Workshop (Shop)', NULL, 2, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, 9, N'BusinessDescription', N'Motor Auto Parts/Workshop (W)', NULL, 3, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, 9, N'BusinessDescription', N'Grocery Store/Pharmacy', NULL, 4, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, 9, N'BusinessDescription', N'Clothes/RMG/Shoe', NULL, 5, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, 9, N'BusinessDescription', N'Confectionary/Sweets Shop/Restaurant', NULL, 6, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, 9, N'BusinessDescription', N'Shoe/Bag Manufacturing', NULL, 7, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, 9, N'BusinessDescription', N'Metal/Used Manufacturing', NULL, 8, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, 9, N'BusinessDescription', N'Mobile Accessories/Electric Appliance', NULL, 9, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (10, 9, N'BusinessDescription', N'Imitation Jewelry/Cosmetics', NULL, 10, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (11, 9, N'BusinessDescription', N'Furniture Manufacturing', NULL, 11, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (12, 9, N'BusinessDescription', N'Plywood/Wood/Plastic Board', NULL, 12, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (13, 9, N'BusinessDescription', N'Plastic Recycling/Plastic Bottle Factory', NULL, 13, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (14, 9, N'BusinessDescription', N'Toys/Gift Item Business', NULL, 14, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (15, 9, N'BusinessDescription', N'Backer Factory', NULL, 15, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (16, 9, N'CauseOfIncident', N'Fire', NULL, 1, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (17, 9, N'CauseOfIncident', N'Flood', NULL, 2, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (18, 9, N'CauseOfIncident', N'Cyclone', NULL, 3, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (19, 9, N'DocumentType', N'Death Certificate', NULL, 1, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (20, 9, N'DocumentType', N'Discharge Form', NULL, 2, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (21, 6, N'BusinessDescription', N'Building Home/House Construction', NULL, 1, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (22, 6, N'BusinessDescription', N'Grocery/General Store/Confectionary/Tea-Betel Leaf Stall', NULL, 2, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (23, 6, N'BusinessDescription', N'Paddy-Rice Business', NULL, 3, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (24, 6, N'BusinessDescription', N'Readymade Garments', NULL, 4, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (25, 6, N'BusinessDescription', N'Cloth Business/Boutique/Tailoring', NULL, 5, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (26, 6, N'BusinessDescription', N'Workshop Business', NULL, 6, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (27, 6, N'BusinessDescription', N'Iron Business', NULL, 7, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (28, 6, N'BusinessDescription', N'Pharmacy', NULL, 8, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (29, 6, N'BusinessDescription', N'Dealer Shop-Seeds, Pesticide, Fertilizer, Livestock-Poultry-Fishery Food, Vaccine', NULL, 9, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (30, 6, N'BusinessDescription', N'Raw Material/Stocking Business', NULL, 10, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (31, 6, N'BusinessDescription', N'Hotel Business', NULL, 11, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (32, 6, N'BusinessDescription', N'Decorator/Generator/Dish Cable Business', NULL, 12, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (33, 6, N'BusinessDescription', N'Scrap Business', NULL, 13, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (34, 6, N'BusinessDescription', N'Sanitary Business', NULL, 14, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (35, 6, N'BusinessDescription', N'Wood Business', NULL, 15, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (36, 6, N'BusinessDescription', N'Furniture Business', NULL, 16, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (37, 6, N'BusinessDescription', N'Shoe-Sandal Shop', NULL, 17, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (38, 6, N'BusinessDescription', N'Fuel/Food Oil Business', NULL, 18, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (39, 6, N'BusinessDescription', N'Oil Mill', NULL, 19, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (40, 6, N'BusinessDescription', N'Fruit Shop', NULL, 20, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (41, 6, N'BusinessDescription', N'Gas Cylinder Business', NULL, 21, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (42, 6, N'BusinessDescription', N'Bedding/Blanket/Mattress/Foam/Pillow', NULL, 22, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (43, 6, N'BusinessDescription', N'Colour/Paint Business', NULL, 23, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (44, 6, N'BusinessDescription', N'Crockeries Business', NULL, 24, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (45, 6, N'BusinessDescription', N'Cosmetics Shop', NULL, 25, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (46, 6, N'BusinessDescription', N'Handloom', NULL, 26, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (47, 6, N'BusinessDescription', N'Mobile Servicing Shop/Electric Material Repairing Shop', NULL, 27, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (48, 6, N'BusinessDescription', N'Poultry Farm', NULL, 28, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (49, 6, N'BusinessDescription', N'Livestock', NULL, 29, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (50, 7, N'BusinessDescription', N'Building Home/House Construction', NULL, 1, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (51, 7, N'BusinessDescription', N'Grocery/General Store/Confectionary/Tea-Betel Leaf Stall', NULL, 2, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (52, 7, N'BusinessDescription', N'Paddy-Rice Business', NULL, 3, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (53, 7, N'BusinessDescription', N'Readymade Garments', NULL, 4, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (54, 7, N'BusinessDescription', N'Cloth Business/Boutique/Tailoring', NULL, 5, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (55, 7, N'BusinessDescription', N'Workshop Business', NULL, 6, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (56, 7, N'BusinessDescription', N'Iron Business', NULL, 7, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (57, 7, N'BusinessDescription', N'Pharmacy', NULL, 8, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (58, 7, N'BusinessDescription', N'Dealer Shop-Seeds, Pesticide, Fertilizer, Livestock-Poultry-Fishery Food, Vaccine', NULL, 9, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (59, 7, N'BusinessDescription', N'Raw Material/Stocking Business', NULL, 10, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (60, 7, N'BusinessDescription', N'Hotel Business', NULL, 11, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (61, 7, N'BusinessDescription', N'Decorator/Generator/Dish Cable Business', NULL, 12, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (62, 7, N'BusinessDescription', N'Scrap Business', NULL, 13, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (63, 7, N'BusinessDescription', N'Sanitary Business', NULL, 14, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (64, 7, N'BusinessDescription', N'Wood Business', NULL, 15, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (65, 7, N'BusinessDescription', N'Furniture Business', NULL, 16, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (66, 7, N'BusinessDescription', N'Shoe-Sandal Shop', NULL, 17, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (67, 7, N'BusinessDescription', N'Fuel/Food Oil Business', NULL, 18, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (68, 7, N'BusinessDescription', N'Oil Mill', NULL, 19, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (69, 7, N'BusinessDescription', N'Fruit Shop', NULL, 20, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (70, 7, N'BusinessDescription', N'Gas Cylinder Business', NULL, 21, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (71, 7, N'BusinessDescription', N'Bedding/Blanket/Mattress/Foam/Pillow', NULL, 22, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (72, 7, N'BusinessDescription', N'Colour/Paint Business', NULL, 23, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (73, 7, N'BusinessDescription', N'Crockeries Business', NULL, 24, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (74, 7, N'BusinessDescription', N'Cosmetics Shop', NULL, 25, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (75, 7, N'BusinessDescription', N'Handloom', NULL, 26, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (76, 7, N'BusinessDescription', N'Mobile Servicing Shop/Electric Material Repairing Shop', NULL, 27, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (77, 7, N'BusinessDescription', N'Poultry Farm', NULL, 28, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ProductConfig] ([PCId], [ProductId], [ConfigType], [ConfigName], [ConfigValue], [SeqNo], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (78, 7, N'BusinessDescription', N'Livestock', NULL, 29, 1, 1, CAST(N'2017-04-02T00:06:31.350' AS DateTime), N'192.168.1.1', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ProductConfig] OFF
GO
SET IDENTITY_INSERT [dbo].[RecordHistory] ON 

GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (1, N'ClaimStatus', 1, N'Registered', 3, CAST(N'2019-07-14T16:26:41.200' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (2, N'ClaimUpdate', 1, N'Claim Creation', 3, CAST(N'2019-07-14T16:26:41.200' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (3, N'ClaimUpdate', 1, N'Insured Details', 3, CAST(N'2019-07-14T16:30:36.333' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (4, N'ClaimUpdate', 1, N'Update Cover Details', 3, CAST(N'2019-07-14T16:34:08.427' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (5, N'ClaimUpdate', 1, N'Line Of Business Details', 3, CAST(N'2019-07-14T16:35:19.853' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (6, N'ClaimUpdate', 2, N'Claim Creation', 3, CAST(N'2019-07-25T16:42:48.023' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (7, N'ClaimStatus', 2, N'Registered', 3, CAST(N'2019-07-25T16:42:48.023' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (8, N'ClaimUpdate', 2, N'Claim Insured Added', 3, CAST(N'2019-07-25T16:42:48.023' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (9, N'ClaimUpdate', 2, N'Claim Notifier Added', 3, CAST(N'2019-07-25T16:42:48.023' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (10, N'ClaimUpdate', 3, N'Claim Creation', 3, CAST(N'2019-07-25T19:02:25.630' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (11, N'ClaimStatus', 3, N'Registered', 3, CAST(N'2019-07-25T19:02:25.630' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (12, N'ClaimUpdate', 3, N'Claim Insured Added', 3, CAST(N'2019-07-25T19:02:25.630' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (13, N'ClaimUpdate', 3, N'Claim Notifier Added', 3, CAST(N'2019-07-25T19:02:25.630' AS DateTime), N'116.58.205.172')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (14, N'ClaimStatus', 4, N'Registered', 3, CAST(N'2019-07-26T13:19:11.517' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (15, N'ClaimUpdate', 4, N'Claim Creation', 3, CAST(N'2019-07-26T13:19:11.513' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (16, N'ClaimUpdate', 5, N'Claim Creation', 3, CAST(N'2019-07-26T13:33:18.227' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (17, N'ClaimStatus', 5, N'Registered', 3, CAST(N'2019-07-26T13:33:18.227' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (18, N'ClaimUpdate', 5, N'Claim Insured Added', 3, CAST(N'2019-07-26T13:33:18.227' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (19, N'ClaimUpdate', 5, N'Claim Notifier Added', 3, CAST(N'2019-07-26T13:33:18.227' AS DateTime), N'103.240.248.250')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (20, N'ClaimUpdate', 6, N'Claim Creation', 3, CAST(N'2019-07-30T03:12:14.653' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (21, N'ClaimStatus', 6, N'Registered', 3, CAST(N'2019-07-30T03:12:14.653' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (22, N'ClaimUpdate', 6, N'Claim Insured Added', 3, CAST(N'2019-07-30T03:12:14.653' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (23, N'ClaimUpdate', 6, N'Claim Notifier Added', 3, CAST(N'2019-07-30T03:12:14.653' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (24, N'ClaimUpdate', 6, N'Insured Details', 3, CAST(N'2019-07-30T03:12:57.370' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (25, N'ClaimUpdate', 7, N'Claim Creation', 3, CAST(N'2019-07-30T03:18:43.000' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (26, N'ClaimStatus', 7, N'Registered', 3, CAST(N'2019-07-30T03:18:43.000' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (27, N'ClaimUpdate', 7, N'Claim Insured Added', 3, CAST(N'2019-07-30T03:18:43.000' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (28, N'ClaimUpdate', 7, N'Claim Notifier Added', 3, CAST(N'2019-07-30T03:18:43.000' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (29, N'ClaimUpdate', 8, N'Claim Creation', 3, CAST(N'2019-07-30T03:22:13.183' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (30, N'ClaimStatus', 8, N'Registered', 3, CAST(N'2019-07-30T03:22:13.183' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (31, N'ClaimUpdate', 8, N'Claim Insured Added', 3, CAST(N'2019-07-30T03:22:13.183' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (32, N'ClaimUpdate', 8, N'Claim Notifier Added', 3, CAST(N'2019-07-30T03:22:13.183' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (33, N'ClaimUpdate', 8, N'Notifier Details', 3, CAST(N'2019-07-30T03:22:39.030' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (34, N'ClaimUpdate', 8, N'Update Cover Details', 3, CAST(N'2019-07-30T03:23:40.003' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (35, N'ClaimUpdate', 9, N'Claim Creation', 3, CAST(N'2019-07-30T03:26:14.010' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (36, N'ClaimStatus', 9, N'Registered', 3, CAST(N'2019-07-30T03:26:14.010' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (37, N'ClaimUpdate', 9, N'Claim Insured Added', 3, CAST(N'2019-07-30T03:26:14.010' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (38, N'ClaimUpdate', 9, N'Claim Notifier Added', 3, CAST(N'2019-07-30T03:26:14.010' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (39, N'ClaimUpdate', 9, N'Notifier Details', 3, CAST(N'2019-07-30T03:26:39.950' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (40, N'ClaimUpdate', 9, N'Update Cover Details', 3, CAST(N'2019-07-30T03:27:41.000' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (41, N'ClaimUpdate', 10, N'Claim Creation', 3, CAST(N'2019-07-30T11:43:52.517' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (42, N'ClaimStatus', 10, N'Registered', 3, CAST(N'2019-07-30T11:43:52.517' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (43, N'ClaimUpdate', 10, N'Claim Insured Added', 3, CAST(N'2019-07-30T11:43:52.517' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (44, N'ClaimUpdate', 10, N'Claim Notifier Added', 3, CAST(N'2019-07-30T11:43:52.517' AS DateTime), N'43.245.122.211')
GO
INSERT [dbo].[RecordHistory] ([HistoryId], [HistoryType], [KeyValue], [Description], [CreatedBy], [CreatedAt], [CreatedIP]) VALUES (45, N'ClaimUpdate', 10, N'Update Cover Details', 3, CAST(N'2019-07-30T11:47:04.460' AS DateTime), N'43.245.122.211')
GO
SET IDENTITY_INSERT [dbo].[RecordHistory] OFF
GO
INSERT [dbo].[SystemCodeMax] ([TableName], [Period], [MaxNumber], [UpdatedAt]) VALUES (N'Claim', N'Auto', 10, CAST(N'2019-07-30T11:43:52.443' AS DateTime))
GO
INSERT [dbo].[SystemCodeMax] ([TableName], [Period], [MaxNumber], [UpdatedAt]) VALUES (N'Client', N'Auto', 15, CAST(N'2019-10-27T11:09:10.687' AS DateTime))
GO
INSERT [dbo].[SystemCodeMax] ([TableName], [Period], [MaxNumber], [UpdatedAt]) VALUES (N'Country', N'Auto', 2, CAST(N'2018-11-26T21:51:43.210' AS DateTime))
GO
INSERT [dbo].[SystemCodeMax] ([TableName], [Period], [MaxNumber], [UpdatedAt]) VALUES (N'NirvoyClient', N'Auto', 4, CAST(N'2020-01-26T15:51:08.293' AS DateTime))
GO
INSERT [dbo].[SystemCodeMax] ([TableName], [Period], [MaxNumber], [UpdatedAt]) VALUES (N'Partner', N'Auto', 6, CAST(N'2018-11-26T21:51:43.210' AS DateTime))
GO
INSERT [dbo].[SystemCodeMax] ([TableName], [Period], [MaxNumber], [UpdatedAt]) VALUES (N'Policy', N'Auto', 7, CAST(N'2019-10-27T11:09:10.677' AS DateTime))
GO
INSERT [dbo].[SystemCodeMax] ([TableName], [Period], [MaxNumber], [UpdatedAt]) VALUES (N'Product', N'Auto', 9, CAST(N'2018-11-26T21:51:43.210' AS DateTime))
GO
INSERT [dbo].[SystemCodePattern] ([TableName], [Period], [IdPattern], [CodePattern], [StartNumber], [Increment], [Padding], [PaddingChar], [YearLength], [MasterTable]) VALUES (N'Claim', N'Auto', N'CL-{Number}', N'CL-{Number}', 1, 1, 10, N'0', 2, N'')
GO
INSERT [dbo].[SystemCodePattern] ([TableName], [Period], [IdPattern], [CodePattern], [StartNumber], [Increment], [Padding], [PaddingChar], [YearLength], [MasterTable]) VALUES (N'Partner', N'Auto', N'PAT-{Year}-{Number}', N'PAT-{Year}-{Number}', 1, 1, 5, N'0', 2, N'')
GO
INSERT [dbo].[SystemCodePattern] ([TableName], [Period], [IdPattern], [CodePattern], [StartNumber], [Increment], [Padding], [PaddingChar], [YearLength], [MasterTable]) VALUES (N'Policy', N'Auto', N'BDG-{Number}', N'BDG-{Number}', 1, 1, 10, N'0', 2, N'')
GO
INSERT [dbo].[SystemCodePattern] ([TableName], [Period], [IdPattern], [CodePattern], [StartNumber], [Increment], [Padding], [PaddingChar], [YearLength], [MasterTable]) VALUES (N'Product', N'Auto', N'PRO-{Year}-{Number}', N'PRO-{Year}-{Number}', 1, 1, 5, N'0', 2, N'')
GO
INSERT [dbo].[UnderWriter] ([UnderWriterId], [Name]) VALUES (1, N'Pragati General')
GO
INSERT [dbo].[UnderWriter] ([UnderWriterId], [Name]) VALUES (2, N'Pragati Life')
GO
SET IDENTITY_INSERT [dbo].[UserLogTracker] ON 

GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (1, 3, CAST(N'2019-07-13T11:06:32.950' AS DateTime), NULL, 1, N'103.67.159.143', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (2, 3, CAST(N'2019-07-13T11:07:42.420' AS DateTime), NULL, 1, N'103.67.159.143', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (3, 3, CAST(N'2019-07-13T13:31:53.133' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (4, 3, CAST(N'2019-07-13T13:41:30.870' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (5, 2, CAST(N'2019-07-14T11:56:09.730' AS DateTime), NULL, 1, N'27.147.203.105', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (6, 2, CAST(N'2019-07-14T12:01:53.383' AS DateTime), NULL, 1, N'27.147.203.105', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (7, 2, CAST(N'2019-07-14T12:04:07.223' AS DateTime), NULL, 1, N'27.147.203.105', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (8, 3, CAST(N'2019-07-14T15:36:13.937' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (9, 3, CAST(N'2019-07-14T15:37:24.513' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (10, 3, CAST(N'2019-07-14T17:48:13.810' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (11, 3, CAST(N'2019-07-14T17:50:08.693' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (12, 3, CAST(N'2019-07-14T17:50:16.830' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (13, 3, CAST(N'2019-07-14T17:58:39.023' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (14, 2, CAST(N'2019-07-15T15:30:58.423' AS DateTime), NULL, 1, N'103.203.92.18', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (15, 3, CAST(N'2019-07-17T13:10:16.820' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (16, 3, CAST(N'2019-07-17T13:55:35.390' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (17, 2, CAST(N'2019-07-18T14:33:54.440' AS DateTime), NULL, 1, N'43.245.120.111', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (18, 3, CAST(N'2019-07-18T16:39:49.077' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (19, 3, CAST(N'2019-07-19T13:29:48.893' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (20, 3, CAST(N'2019-07-20T12:43:56.110' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (21, 3, CAST(N'2019-07-20T15:59:04.820' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (22, 3, CAST(N'2019-07-22T14:31:36.290' AS DateTime), NULL, 1, N'221.120.103.14', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (23, 3, CAST(N'2019-07-23T09:06:19.880' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (24, 3, CAST(N'2019-07-23T09:14:21.953' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (25, 3, CAST(N'2019-07-24T18:07:18.007' AS DateTime), NULL, 1, N'221.120.103.14', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (26, 3, CAST(N'2019-07-24T19:12:33.513' AS DateTime), NULL, 1, N'116.58.203.102', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (27, 3, CAST(N'2019-07-24T20:46:04.853' AS DateTime), NULL, 1, N'221.120.103.14', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (28, 3, CAST(N'2019-07-25T13:08:34.340' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (29, 3, CAST(N'2019-07-25T13:43:10.257' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (30, 3, CAST(N'2019-07-25T13:50:23.813' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (31, 3, CAST(N'2019-07-25T14:04:59.263' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (32, 3, CAST(N'2019-07-25T15:26:11.337' AS DateTime), NULL, 1, N'116.58.205.172', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (33, 3, CAST(N'2019-07-25T15:29:32.500' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (34, 3, CAST(N'2019-07-25T15:43:21.970' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (35, 2, CAST(N'2019-07-25T15:44:14.630' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (36, 2, CAST(N'2019-07-25T16:08:39.317' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (37, 3, CAST(N'2019-07-25T19:59:18.300' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (38, 3, CAST(N'2019-07-26T11:39:04.153' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (39, 3, CAST(N'2019-07-26T11:49:09.953' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (40, 2, CAST(N'2019-07-26T12:20:45.860' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (41, 3, CAST(N'2019-07-26T12:26:12.610' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (42, 3, CAST(N'2019-07-26T13:36:41.937' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (43, 3, CAST(N'2019-07-26T17:17:36.987' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (44, 3, CAST(N'2019-07-26T22:59:41.610' AS DateTime), NULL, 1, N'116.58.202.209', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (45, 3, CAST(N'2019-07-27T15:21:08.180' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (46, 3, CAST(N'2019-07-28T00:09:23.417' AS DateTime), NULL, 1, N'116.58.202.104', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (47, 3, CAST(N'2019-07-28T00:19:05.780' AS DateTime), NULL, 1, N'116.58.202.104', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (48, 3, CAST(N'2019-07-28T00:33:04.103' AS DateTime), NULL, 1, N'116.58.202.104', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (49, 3, CAST(N'2019-07-28T10:19:31.963' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (50, 3, CAST(N'2019-07-28T10:20:08.017' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (51, 3, CAST(N'2019-07-28T10:20:08.013' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (52, 3, CAST(N'2019-07-28T10:20:46.993' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (53, 3, CAST(N'2019-07-28T10:21:56.040' AS DateTime), NULL, 1, N'45.251.231.32', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (54, 3, CAST(N'2019-07-28T12:44:55.380' AS DateTime), NULL, 1, N'118.179.73.56', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (55, 2, CAST(N'2019-07-28T12:49:24.223' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (56, 3, CAST(N'2019-07-28T12:49:52.923' AS DateTime), NULL, 1, N'118.179.73.56', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (57, 2, CAST(N'2019-07-28T12:49:54.367' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (58, 2, CAST(N'2019-07-28T13:43:40.210' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (59, 3, CAST(N'2019-07-28T14:16:21.927' AS DateTime), NULL, 1, N'202.56.5.249', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (60, 3, CAST(N'2019-07-28T15:29:58.643' AS DateTime), NULL, 1, N'202.51.184.70', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (61, 2, CAST(N'2019-07-28T15:33:06.390' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (62, 3, CAST(N'2019-07-28T16:12:23.830' AS DateTime), NULL, 1, N'202.51.184.70', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (63, 2, CAST(N'2019-07-28T16:15:43.677' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (64, 2, CAST(N'2019-07-28T16:19:40.983' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (65, 3, CAST(N'2019-07-28T17:35:37.307' AS DateTime), NULL, 1, N'103.67.156.179', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (66, 3, CAST(N'2019-07-28T18:45:06.843' AS DateTime), NULL, 1, N'103.240.248.250', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (67, 3, CAST(N'2019-07-29T16:42:09.093' AS DateTime), NULL, 1, N'122.144.8.85', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (68, 3, CAST(N'2019-07-29T22:22:58.673' AS DateTime), NULL, 1, N'43.245.121.221', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (69, 3, CAST(N'2019-07-30T00:30:23.583' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (70, 3, CAST(N'2019-07-30T02:34:12.173' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (71, 3, CAST(N'2019-07-30T02:35:24.030' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (72, 3, CAST(N'2019-07-30T02:36:25.137' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (73, 3, CAST(N'2019-07-30T02:41:03.653' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (74, 3, CAST(N'2019-07-30T02:42:21.180' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (75, 3, CAST(N'2019-07-30T02:45:48.933' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (76, 3, CAST(N'2019-07-30T02:51:19.370' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (77, 3, CAST(N'2019-07-30T02:52:49.287' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (78, 3, CAST(N'2019-07-30T02:58:33.127' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (79, 3, CAST(N'2019-07-30T03:03:53.213' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (80, 3, CAST(N'2019-07-30T10:35:03.133' AS DateTime), NULL, 1, N'43.245.122.211', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (81, 3, CAST(N'2019-08-04T17:48:24.307' AS DateTime), NULL, 1, N'117.58.246.246', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (82, 3, CAST(N'2019-08-05T00:08:46.837' AS DateTime), NULL, 1, N'103.130.114.138', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (83, 2, CAST(N'2019-08-05T09:52:55.250' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (84, 2, CAST(N'2019-08-05T09:54:09.750' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (85, 1, CAST(N'2019-08-05T10:09:21.530' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (86, 4, CAST(N'2019-08-05T10:29:38.923' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (87, 1, CAST(N'2019-08-05T10:32:47.057' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (88, 4, CAST(N'2019-08-05T10:33:20.217' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (89, 1, CAST(N'2019-08-05T10:36:03.620' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (90, 2, CAST(N'2019-08-05T10:36:09.600' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (91, 4, CAST(N'2019-08-05T10:36:16.763' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (92, 2, CAST(N'2019-08-05T10:36:40.777' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (93, 4, CAST(N'2019-08-05T11:50:03.720' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (94, 3, CAST(N'2019-08-05T11:56:34.617' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (95, 4, CAST(N'2019-08-05T11:56:59.127' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (96, 2, CAST(N'2019-08-05T11:57:29.780' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (97, 3, CAST(N'2019-08-05T18:22:22.447' AS DateTime), NULL, 1, N'116.58.203.55', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (98, 2, CAST(N'2019-08-06T12:49:12.177' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (99, 4, CAST(N'2019-08-06T12:49:38.487' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (100, 4, CAST(N'2019-08-07T12:16:02.603' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (101, 1, CAST(N'2019-08-07T15:50:18.010' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (102, 1, CAST(N'2019-08-07T15:56:41.707' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (103, 1, CAST(N'2019-08-07T16:28:01.897' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (104, 5, CAST(N'2019-08-07T16:47:31.683' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (105, 6, CAST(N'2019-08-07T17:02:50.800' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (106, 7, CAST(N'2019-08-07T17:03:24.107' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (107, 8, CAST(N'2019-08-07T17:03:45.487' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (108, 4, CAST(N'2019-08-07T17:28:28.823' AS DateTime), NULL, 1, N'202.56.5.249', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (109, 4, CAST(N'2019-08-07T17:31:29.117' AS DateTime), NULL, 1, N'202.56.5.249', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (110, 1, CAST(N'2019-08-07T18:07:55.227' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (111, 2, CAST(N'2019-08-07T18:08:06.480' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (112, 4, CAST(N'2019-08-07T18:08:24.013' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (113, 5, CAST(N'2019-08-07T18:09:08.837' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (114, 6, CAST(N'2019-08-07T18:09:41.240' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (115, 1, CAST(N'2019-08-07T18:09:52.040' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (116, 4, CAST(N'2019-08-07T18:10:58.220' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (117, 1, CAST(N'2019-08-07T18:11:06.903' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (118, 1, CAST(N'2019-08-07T18:11:35.287' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (119, 8, CAST(N'2019-08-07T18:13:01.940' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (120, 4, CAST(N'2019-08-08T16:03:38.410' AS DateTime), NULL, 1, N'202.56.5.249', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (121, 3, CAST(N'2019-08-31T13:13:47.830' AS DateTime), NULL, 1, N'103.67.157.169', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (122, 1, CAST(N'2019-09-15T12:29:46.827' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (123, 3, CAST(N'2019-09-17T16:59:57.167' AS DateTime), NULL, 1, N'118.179.73.56', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (124, 1, CAST(N'2019-09-18T09:52:52.530' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (125, 1, CAST(N'2019-09-18T09:58:35.613' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (126, 4, CAST(N'2019-09-18T11:31:24.910' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (127, 4, CAST(N'2019-09-18T13:56:54.103' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (128, 1, CAST(N'2019-09-19T11:21:40.700' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (129, 1, CAST(N'2019-09-19T11:25:24.287' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (130, 3, CAST(N'2019-09-19T14:26:40.083' AS DateTime), NULL, 1, N'202.51.184.70', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (131, 3, CAST(N'2019-09-19T17:01:20.270' AS DateTime), NULL, 1, N'103.120.202.125', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (132, 3, CAST(N'2019-09-22T21:03:39.623' AS DateTime), NULL, 1, N'118.179.73.56', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (133, 1, CAST(N'2019-09-23T10:07:22.353' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (134, 3, CAST(N'2019-09-23T12:42:43.653' AS DateTime), NULL, 1, N'116.58.204.214', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (135, 1, CAST(N'2019-10-14T13:43:27.657' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (136, 4, CAST(N'2019-10-17T14:44:52.620' AS DateTime), NULL, 1, N'37.111.204.214', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (137, 3, CAST(N'2019-10-17T14:45:36.880' AS DateTime), NULL, 1, N'37.111.204.214', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (138, 2, CAST(N'2019-10-27T10:30:18.743' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (139, 9, CAST(N'2019-10-27T13:39:33.813' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (140, 2, CAST(N'2019-10-27T13:40:25.727' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (141, 9, CAST(N'2019-10-27T13:41:16.660' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (142, 3, CAST(N'2019-12-03T13:40:37.673' AS DateTime), NULL, 1, N'202.51.184.70', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (143, 3, CAST(N'2019-12-03T16:41:06.503' AS DateTime), NULL, 1, N'37.111.205.144', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (144, 2, CAST(N'2019-12-03T20:00:09.897' AS DateTime), NULL, 1, N'203.76.148.2', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (145, 3, CAST(N'2019-12-11T15:35:31.600' AS DateTime), NULL, 1, N'119.30.32.111', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (146, 4, CAST(N'2019-12-11T17:57:01.500' AS DateTime), NULL, 1, N'119.30.39.233', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (147, 2, CAST(N'2019-12-26T15:08:58.920' AS DateTime), NULL, 1, N'103.113.12.21', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (148, 3, CAST(N'2019-12-26T15:10:11.113' AS DateTime), NULL, 1, N'103.113.12.21', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (149, 2, CAST(N'2019-12-26T15:29:47.643' AS DateTime), NULL, 1, N'37.111.197.192', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (150, 3, CAST(N'2019-12-26T15:32:44.753' AS DateTime), NULL, 1, N'37.111.197.192', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (151, 2, CAST(N'2019-12-26T15:34:16.417' AS DateTime), NULL, 1, N'37.111.197.192', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (152, 10, CAST(N'2019-12-26T15:37:00.657' AS DateTime), NULL, 1, N'37.111.197.192', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (153, 2, CAST(N'2019-12-26T15:37:29.650' AS DateTime), NULL, 1, N'37.111.197.192', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (154, 3, CAST(N'2019-12-29T11:07:09.490' AS DateTime), NULL, 1, N'62.151.176.243', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (155, 2, CAST(N'2019-12-29T11:09:04.570' AS DateTime), NULL, 1, N'62.151.176.243', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (156, 2, CAST(N'2019-12-30T14:38:42.993' AS DateTime), NULL, 1, N'119.30.32.218', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (157, 3, CAST(N'2019-12-30T14:39:48.560' AS DateTime), NULL, 1, N'119.30.32.218', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (158, 11, CAST(N'2019-12-30T14:41:02.320' AS DateTime), NULL, 1, N'119.30.32.218', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (159, 11, CAST(N'2019-12-30T15:03:23.610' AS DateTime), NULL, 1, N'115.127.70.154', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (160, 12, CAST(N'2019-12-30T16:58:02.897' AS DateTime), NULL, 1, N'119.30.38.48', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (161, 12, CAST(N'2019-12-30T16:58:15.340' AS DateTime), NULL, 1, N'119.30.38.48', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (162, 12, CAST(N'2019-12-31T12:06:52.350' AS DateTime), NULL, 1, N'119.30.38.85', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (163, 15, CAST(N'2020-01-06T18:12:47.967' AS DateTime), NULL, 1, N'103.132.187.81', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (164, 2, CAST(N'2020-01-15T15:19:59.273' AS DateTime), NULL, 1, N'182.160.122.221', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (165, 2, CAST(N'2020-01-15T15:42:49.460' AS DateTime), NULL, 1, N'175.29.124.82', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (166, 4, CAST(N'2020-01-15T15:52:10.770' AS DateTime), NULL, 1, N'182.160.122.221', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (167, 2, CAST(N'2020-01-15T16:07:03.070' AS DateTime), NULL, 1, N'175.29.124.82', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (168, 3, CAST(N'2020-01-23T15:48:08.633' AS DateTime), NULL, 1, N'202.51.184.70', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (169, 3, CAST(N'2020-01-23T15:48:37.370' AS DateTime), NULL, 1, N'202.51.184.70', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (170, 1, CAST(N'2020-01-26T09:41:59.427' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (171, 2, CAST(N'2020-01-26T09:43:08.560' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (172, 4, CAST(N'2020-01-26T09:43:17.840' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (173, 4, CAST(N'2020-01-26T14:39:55.960' AS DateTime), NULL, 1, N'37.111.202.227', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (174, 2, CAST(N'2020-02-04T15:52:11.787' AS DateTime), NULL, 1, N'118.67.220.46', N'Windows')
GO
INSERT [dbo].[UserLogTracker] ([LogedId], [UserId], [LogInAt], [LogOutAt], [IsLive], [IPAddress], [UserAgent]) VALUES (175, 1, CAST(N'2020-02-16T10:52:58.550' AS DateTime), NULL, 1, N'202.53.168.33', N'Windows')
GO
SET IDENTITY_INSERT [dbo].[UserLogTracker] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (1, N'ablmamuntue@yahoo.com', N'Md Abdullah', N'Al Mamun', 0xF40DF1CDDE2C5D5B3250EEF57428D53314C0D179EFA1791D29DEB1AD6CE5A05D30F9792BCB6F3B599392221729D6CA4BB7AA068536DA880D3A4E2FFFF1E00F64, 0xD4B9D6AE1892C257803059639FDB5FC1D73ADC3BDD34202E3895FE52ABE60FEFFE2E1D64017CEF54ECC2E57B1E7F31BE79D88C2B3787300C6028F3E0166868AF4305FBB2CDEB874C6C5FA769AA907848DAFE2FD0A086C6B6B2A39F98FD74E03E6E4B36ED3B0FA882B62B38FC155AA6F9731472E4F0A06EF519ADCDF133BBA7AF, N'SuperAdmin', NULL, 1, 1, CAST(N'2019-03-20T10:36:16.217' AS DateTime), N'169.254.200.74', 1, CAST(N'2019-07-12T15:52:06.047' AS DateTime), N'127.0.0.1', 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (2, N'tayobur.rahman@microinspire.com', N'Tayobur', N'Rahman', 0xCC65DAA286525C7E4A1308319294ED7A08DC2FA5AB2A962B449090343BE43B31FF4591753ADC8CC52E6031E2AFDA74613D063938A84356BF513AE4F2C60E5307, 0x493443C0BCFA2D1F1F3469E5237E70BAC5785AA8372B5488EA315A5711C22D33A93D47BEDB872180F3C6736F5B7D438FD25206B3B9CC4A84E782AC9A7292483FC416BA4E52D08F5F8BDE04F8730C941D9C9CE3194852436CDF2FC9EE7602BC6EC9CD4455054B8E83426C62242A9A905C687DC0E883B015319B29D763107AD3A4, N'Admin', NULL, 1, 1, CAST(N'2019-04-08T05:53:02.457' AS DateTime), N'169.254.200.74', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (3, N'uat@user.com', N'Demo', N'User', 0x87996DB3C85DB99BAE598ADAF7A248A4820EB33A33DBB8F2F636AB91BE87CC9B7CB2DF466F9EFCF52BFA3B9DDCE841D2881870BBC242D236F8754E226AEB9407, 0x0B6431A4E6B92AEB0898ABC57B5FF0E1AEFC86A9F458B8A4C77B8515B93A78FA954B456DBD24027F23530F8892CBA68655F1C4D2B938B999FAFAE65BA78D2FCED402483186332D29B1F082D3EF9842FC0831F72805D7D5F9265EA3469F3407429175B4BA850C594D53BCE79A19C857976D8B06A782209CB57F8BD43F2D2AF6DB, N'Standard', 6, 1, 2, CAST(N'2019-07-12T09:26:41.150' AS DateTime), N'127.0.0.1', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (4, N'nirvoy@demo.com', N'Nirvoy', N'Demo', 0xAF677A42C5C917CA8AEB4CB0BD54FE6855226099B77ED93B3B9C6C31E09E2533DB170C333B0C09C28EF2F8A0103B9935C42C89757763E702B2DBBFCB50E518AA, 0x55D796D8C9526B0FC414063EE4A5268AAF44E3C1EFBC1A7D9E1294276F12EC4D2CE5A2D3FCFE4EAEA0DA0332AB2DDF451B4C6BDD880AA6AB2FB1A46D75CE24E5FA838A12935AF763C796DE5504432B30A841D0D65BF96A4E219F348053C3BFF670D473D191F2D152908B860BF26D4470FA18948094161FE39DA95BEF2FD731BE, N'Nirvoy', 1, 1, 1, CAST(N'2019-08-05T10:14:48.793' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (5, N'hasancse1983@gmail.com', N'A.T.M Rafiul', N'Hassan', 0xCCFF4804B941A7856BB5D913D97A48311FB5B741386E5BFA2C2879A8773687F77EE50E51F4D60C1EEC375551C6DE57060541A8081CFAECB2EF425BF14A457D6C, 0xA24F2CC402D6CDD848A9EFFA7A8815C0F420FD99C408BD2F158BCA570213A26EE1F0651ADB576FA6C393DDFF16B48F9AC7AA54112DAF42FA01D1D152A1D3D17B5B3FA2C8A8DED090EADD8C512DA7CC1FAD2B130DB155530A3888E8B4CC2C8145C18425C5DE3615D11F9063FDFEF8230FEA6396C504C0004D7D3CEBD6CD30CC4C, N'Admin', 4, 1, 1, CAST(N'2019-08-07T16:37:23.843' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (6, N'ndpkatakhali@gmail.com', N'Md. Sazidul', N'Islam', 0x55FD70714B78E55EF823A7A343A4A697CC16221ED289F72B8244E25ACF62BA9FF857593A905FD7D915CDB01084D904D211B7DAFF6232A659230742733728B2F3, 0xFFDFB566FC24E1F7BD52F61B65891EB94BA168F2DB06FB3F7E8E3C41E4674BD90B519D3D5BE9E17F28D7E2E7A9D02B22B912C37E1E985ECAF03CCA347E993D3ADC259E285B5069F353D39FC49CF4E039B2BFF3113381A52D12CCAACE2F88D7D96603809ECFFEF1F9F2200C0B56B029113BE035A0EF47B016B5B09D55347D0AFE, N'Standard', 4, 1, 1, CAST(N'2019-08-07T16:39:25.713' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (7, N'ndpsaydabad@gmail.com', N'Md. Mahmudul', N'Hasan', 0x4F7BD1DF8D67983DDAF5E4A24727409FC79C83BAE5FDA86C0BD9C62CB966C9CDD145CF97834D1A0CFCF3D5788B34AABF24139D4BE54D13259FC6D6C138BBE2D7, 0x264BCBB00ED0859062F9791E1397228915320E502364B4CA04CDDD9D758097E0C089BAD719F35AEB2FE83581FE164C98FDA5BC9E3A332E1F763B22FA1F036601FE59D164DC72A83D612DCE3AA9D3F3EC344E23F2C72F58FC3A526EBAB36640B4EECB02D51CE278C4C59262812160CE9AC2A1C452BA0E2F3D06B5532E58A7E770, N'Standard', 4, 1, 1, CAST(N'2019-08-07T16:40:53.283' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (8, N'ndpbagbari@gmail.com', N'Md. Sanowar', N'Hossain', 0x5645FB3495D834B30AAC97C6CD873781A93039B948210AAE8B6192DDE3A79C51C71D1C6E43EE79C5F00FCA33B5EA311AB3AA5C8C0A5623D3B4561E475A167769, 0x029A3290CD027930ADE81CB65AE7E6BAD86EA4CA48D0BBB8960F49A3B8BDA28D79FB4425340D2F1247BC21A14B198112DED154740710048A0A39CBCD939F30ECB174D4EE6A4D3E93CEF26766C402CDD0C27B4B84A0975A6F9CCA6F3C4070924934D8CAF12880741B2AE1DD1E2F114D860DFAAC344140D839C53C90F72A0133B6, N'Standard', 4, 1, 1, CAST(N'2019-08-07T16:42:12.943' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (9, N'bankasia@api.com', N'Bank', N'Asia', 0x60153B0A325B951A6ACF827140D624882DF33C7C8947E9A7A52189A87DBB4CE76D72C4ADD957E81108D739D4171AE9CEE83CDA935B877217509500BE7A6350DC, 0x5C86C318E051A87A3CEEC73562D3DFBA2E34C18D52B4D6D3234B23F95C6B862959BA6F0DB26E35F00BA56A057B82F7E8120E9E072A1B0F4E88FE3C642E700A60CB51E937B6592F3EC0582BDA78F4F35E4118145E2E44E995C1746FC1F1F64D6A33A63F1FCE87F6C8E358A14FCA69B7B4C34332F8B87B8A7C098F260D9AFF8E93, N'Standard', 6, 1, 2, CAST(N'2019-10-27T10:51:45.700' AS DateTime), N'202.53.168.33', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (10, N'mostafizur.rahaman@microinspire.com', N'Mostafizur', N'Rahaman', 0xC9D584FA332EF215827091C223840FF61B2AB1A28D1887A98F24EA27DD425A963BA1E98A76548F2828E2061446A6050F9B3DC8802E5C6C75A0C2A051730FD979, 0x3F1069AEA6EE6BB6894A4CC8404854E48B1AFB5E70D003B53F29E8D125699874823DAA79DB7D53C80B525FCC86606FC5D42E7DB0B8A7E2FC074725D36E1088EFBC295AE42435BFC06876F6B666223B9DE8F4FF141BB9B5E076D4E792CF7E42B31FBDE055699F9ABBC5DADEAAD65EBCC4E79DF36CAC34B202D2B991E3809C9FBA, N'Admin', NULL, 1, 2, CAST(N'2019-12-26T15:36:11.887' AS DateTime), N'37.111.197.192', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (11, N'zafor@ghashful-bd.org', N'Md. Abu Zafor', N'Sarder', 0x60CB4F03300E3DA7788CF6C0AB82116A25220C0511F0569DA6F5CCB76C688678746C7EEF49D8CC2CD848BB03CDF9C2FB94DFF49B2033A6831261A3D571BC750E, 0x2AC37C9EECA2275A41FC8B185E597F47B108AC7C0479E36CB46D4AD5BD49F482685D26A67C2FB0ED57EC6B8678A46A434EFE363889E7DC1DC8BEFE8DB505D5FB9A9BF1BE59C23B70134132D8FD4541A4A8B1216D5D198BCFA637ABA568812B7B2F40E02EE588CF672AD07D174455E572549F800A9EC09D3F019932489E17C92B, N'Admin', 3, 1, 2, CAST(N'2019-12-29T11:11:04.977' AS DateTime), N'62.151.176.243', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (12, N'ghashfulbr05@gmail.com', N'Mirza Javed', N'Jahangir', 0x7CFD08C26428AF838F6996BE806C3791DA2A2A35085B2B24578D44F76F1E155C838F84AFB227605329337949E812680AD42A6B7D6E6B15C17495DBAFD89D7921, 0x7D4B83F57880861AF9293CF32FA37BBF1695FC0F12C22870377ACAB6A521F8142763AAED168899BB8E0ED98DE91DA09390909B30F8EC248783FC08FD0E3E805C4B9E54226761D7825F07065125E952A92FA92D59A4EB69F3B90A8D8F29AE435AC75407206F1632CA07BD96C4794068F3D567A2F2DC5087BBD8B9D1A1BF1BAE59, N'Standard', 3, 1, 2, CAST(N'2019-12-29T11:12:47.893' AS DateTime), N'62.151.176.243', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (13, N'ghashfulbr12@gmail.com', N'Abul Kalam', N'Azad', 0x962C3D3AC2F5B2887D082C6A5F683FD012756E679215AC6E1F43C5A40709D7B689A3E5E3114C70278B7A4916DD55FEFF903D96D4E12DA0CF9408053DBCF0CEE8, 0xC5F29A00F09F20153F9E138950C37BBC3867A0276A9E976A6D3BCE16D5A4D46326CA52E15D53CCEC3268AD1CD2AA2E889CC68C2FFF1D9D77AC25B0AF476C30F6EAFABC4610E31A8FBC62EAFCC1F34C6095AF4FFF5D39637D1C3609C49C945EAC91760DD56B36904520FADEFD9A699170A268B27B3C4F5041B47E6C57393527DA, N'Standard', 3, 1, 2, CAST(N'2019-12-29T11:15:27.643' AS DateTime), N'62.151.176.243', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (14, N'ghashfulbr23@gmail.com', N'Md. Mosliur', N'Rahman', 0x9E8086FE538155A8D871B8CAB5FE18EB6BD80EE61E49B1CDC35E4ED344C5248BDA6E1C5A371DF79B50A7D1987E24DFF3C532E99CE45EEA7F3E72E0F59B886A75, 0x20024E4A3E8407D12EA1DF3B616DFB3C0773E91C0CB5494AE978378BEAA870B20A8160C9BFFF335D4648FDD687FA4B3D49590A9F4BB20349052B3695D2B05B32CF6F103C0CF84C69F49F129333760A85EEAA0649611B358ABF604345943AC09AB649FE037C48713B9B7A49086477458752150FD7B76984EB8AA42CABA735C0FF, N'Standard', 3, 1, 2, CAST(N'2019-12-29T11:16:21.990' AS DateTime), N'62.151.176.243', NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [Email], [FirstName], [LastName], [PasswordHash], [PasswordSalt], [UserType], [Organization], [IsActive], [CreatedBy], [CreatedAt], [CreatedIP], [UpdatedBy], [UpdatedAt], [UpdatedIP], [RowVersion]) VALUES (15, N'ghashfulbr25@gmail.com', N'Md. Shahinuzzaman', NULL, 0x9A1265FE8F2E606BF2ABC519695CFD31E2223574F05A66BF4AF11B2F996A8D83D553DF8D5DF573165C33983E687B97EC2F31196125E218161815F3B4E5656496, 0x3B199E2E8B7B43AB03BC3883545BE53A30EEFF7993D3D2A83C8F11F9A1838AD51E62CC542B048F7E1D767B815E9873626499265DA2B3F6FE75233B9CCC94B086A07DCB314D5282C8192991E7F04B2069C276A8999FF0130A14DED3AFE276DE45CF0AF6C0DBB8919472EE125049D243F253F8E9DDFEAAA8CB3F6CD68624E5252C, N'Standard', 3, 1, 2, CAST(N'2019-12-29T11:17:03.777' AS DateTime), N'62.151.176.243', NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Claim]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Claim] ON [dbo].[Claim]
(
	[ClaimNumber] ASC,
	[PartnerId] ASC,
	[ProductId] ASC,
	[BusinessId] ASC,
	[InsuredId] ASC,
	[NotifierId] ASC,
	[ClaimStatus] ASC,
	[ReviewBy] ASC,
	[ConfirmedBy] ASC,
	[UWReviewBy] ASC,
	[UWConfirmedBy] ASC,
	[StatusCreated] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ClaimDocument]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ClaimDocument] ON [dbo].[ClaimDocument]
(
	[ClaimId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ClaimIncident]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ClaimIncident] ON [dbo].[ClaimIncident]
(
	[ClaimId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ClaimNote]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ClaimNote] ON [dbo].[ClaimNote]
(
	[ClaimId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ClaimPayment]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ClaimPayment] ON [dbo].[ClaimPayment]
(
	[ClaimId] ASC,
	[PayeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Client]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Client] ON [dbo].[Client]
(
	[ClientType] ASC,
	[FirstName] ASC,
	[LastName] ASC,
	[PersonalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Partner]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Partner] ON [dbo].[Partner]
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Policy]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Policy] ON [dbo].[Policy]
(
	[PartnerId] ASC,
	[ProductId] ASC,
	[BenefitId] ASC,
	[ExternalId] ASC,
	[PolicyNumber] ASC,
	[PolicyStatus] ASC,
	[SalesReference] ASC,
	[ContributionExtRef] ASC,
	[PolicyStart] ASC,
	[PolicyEnd] ASC,
	[CreatedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PolicyAsset]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_PolicyAsset] ON [dbo].[PolicyAsset]
(
	[PolicyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PolicyClient]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_PolicyClient] ON [dbo].[PolicyClient]
(
	[PolicyId] ASC,
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PolicyNote]    Script Date: 2/18/2020 3:17:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_PolicyNote] ON [dbo].[PolicyNote]
(
	[PolicyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Users]    Script Date: 2/18/2020 3:17:45 AM ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [IX_Users] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Claim]  WITH CHECK ADD  CONSTRAINT [FK_Claim_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([PartnerId])
GO
ALTER TABLE [dbo].[Claim] CHECK CONSTRAINT [FK_Claim_Partner]
GO
ALTER TABLE [dbo].[Claim]  WITH CHECK ADD  CONSTRAINT [FK_Claim_Policy] FOREIGN KEY([PolicyId])
REFERENCES [dbo].[Policy] ([PolicyId])
GO
ALTER TABLE [dbo].[Claim] CHECK CONSTRAINT [FK_Claim_Policy]
GO
ALTER TABLE [dbo].[Claim]  WITH CHECK ADD  CONSTRAINT [FK_Claim_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[Claim] CHECK CONSTRAINT [FK_Claim_Product]
GO
ALTER TABLE [dbo].[ClaimDocument]  WITH CHECK ADD  CONSTRAINT [FK_ClaimDocument_Claim] FOREIGN KEY([ClaimId])
REFERENCES [dbo].[Claim] ([ClaimId])
GO
ALTER TABLE [dbo].[ClaimDocument] CHECK CONSTRAINT [FK_ClaimDocument_Claim]
GO
ALTER TABLE [dbo].[ClaimIncident]  WITH CHECK ADD  CONSTRAINT [FK_ClaimIncident_Claim] FOREIGN KEY([ClaimId])
REFERENCES [dbo].[Claim] ([ClaimId])
GO
ALTER TABLE [dbo].[ClaimIncident] CHECK CONSTRAINT [FK_ClaimIncident_Claim]
GO
ALTER TABLE [dbo].[ClaimNote]  WITH CHECK ADD  CONSTRAINT [FK_ClaimNote_Claim] FOREIGN KEY([ClaimId])
REFERENCES [dbo].[Claim] ([ClaimId])
GO
ALTER TABLE [dbo].[ClaimNote] CHECK CONSTRAINT [FK_ClaimNote_Claim]
GO
ALTER TABLE [dbo].[ClaimPayment]  WITH CHECK ADD  CONSTRAINT [FK_ClaimPayment_Claim] FOREIGN KEY([ClaimId])
REFERENCES [dbo].[Claim] ([ClaimId])
GO
ALTER TABLE [dbo].[ClaimPayment] CHECK CONSTRAINT [FK_ClaimPayment_Claim]
GO
ALTER TABLE [dbo].[Partner]  WITH CHECK ADD  CONSTRAINT [FK_Partner_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Partner] CHECK CONSTRAINT [FK_Partner_Country]
GO
ALTER TABLE [dbo].[Policy]  WITH CHECK ADD  CONSTRAINT [FK_Policy_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([PartnerId])
GO
ALTER TABLE [dbo].[Policy] CHECK CONSTRAINT [FK_Policy_Partner]
GO
ALTER TABLE [dbo].[Policy]  WITH CHECK ADD  CONSTRAINT [FK_Policy_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[Policy] CHECK CONSTRAINT [FK_Policy_Product]
GO
ALTER TABLE [dbo].[PolicyAsset]  WITH CHECK ADD  CONSTRAINT [FK_PolicyAsset_Policy] FOREIGN KEY([PolicyId])
REFERENCES [dbo].[Policy] ([PolicyId])
GO
ALTER TABLE [dbo].[PolicyAsset] CHECK CONSTRAINT [FK_PolicyAsset_Policy]
GO
ALTER TABLE [dbo].[PolicyClient]  WITH CHECK ADD  CONSTRAINT [FK_PolicyClient_Client] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[PolicyClient] CHECK CONSTRAINT [FK_PolicyClient_Client]
GO
ALTER TABLE [dbo].[PolicyClient]  WITH CHECK ADD  CONSTRAINT [FK_PolicyClient_Policy] FOREIGN KEY([PolicyId])
REFERENCES [dbo].[Policy] ([PolicyId])
GO
ALTER TABLE [dbo].[PolicyClient] CHECK CONSTRAINT [FK_PolicyClient_Policy]
GO
ALTER TABLE [dbo].[PolicyNote]  WITH CHECK ADD  CONSTRAINT [FK_PolicyNote_Policy] FOREIGN KEY([PolicyId])
REFERENCES [dbo].[Policy] ([PolicyId])
GO
ALTER TABLE [dbo].[PolicyNote] CHECK CONSTRAINT [FK_PolicyNote_Policy]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([PartnerId])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Partner]
GO
ALTER TABLE [dbo].[ProductBenefit]  WITH CHECK ADD  CONSTRAINT [FK_ProductBenefit_Benefit] FOREIGN KEY([BenefitId])
REFERENCES [dbo].[Benefit] ([BenefitId])
GO
ALTER TABLE [dbo].[ProductBenefit] CHECK CONSTRAINT [FK_ProductBenefit_Benefit]
GO
ALTER TABLE [dbo].[ProductBenefit]  WITH CHECK ADD  CONSTRAINT [FK_ProductBenefit_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[ProductBenefit] CHECK CONSTRAINT [FK_ProductBenefit_Product]
GO
ALTER TABLE [dbo].[ProductBusiness]  WITH CHECK ADD  CONSTRAINT [FK_ProductBusiness_LineOfBusiness] FOREIGN KEY([BusinessId])
REFERENCES [dbo].[LineOfBusiness] ([BusinessId])
GO
ALTER TABLE [dbo].[ProductBusiness] CHECK CONSTRAINT [FK_ProductBusiness_LineOfBusiness]
GO
ALTER TABLE [dbo].[ProductBusiness]  WITH CHECK ADD  CONSTRAINT [FK_ProductBusiness_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[ProductBusiness] CHECK CONSTRAINT [FK_ProductBusiness_Product]
GO
ALTER TABLE [dbo].[ProductConfig]  WITH CHECK ADD  CONSTRAINT [FK_ProductConfig_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[ProductConfig] CHECK CONSTRAINT [FK_ProductConfig_Product]
GO
/****** Object:  StoredProcedure [dbo].[ClaimSearch]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ClaimSearch]
	@UserId INT,
	@ClaimNumber VARCHAR(50),
	@PartnerId INT,
	@ProductId INT,
	@BusinessId INT,
	@PolicyNumber VARCHAR(50),
	@InsuredFirstName NVARCHAR(100),
	@InsuredLastName NVARCHAR(100),
	@ExternalId VARCHAR(50),	
	@NotifierLocation NVARCHAR(250),
	@ClaimStatus VARCHAR(30),
	@ConfirmationRequired BIT
AS
BEGIN
	SELECT CL.ClaimId, CL.ClaimNumber, PA.[Name] AS PartnerName, PT.[Name] AS ProductName,
		LB.[Name] AS LineOfBusiness, PO.ExternalId, CLI.FirstName AS InsuredFirstName, CLI.LastName AS InsuredLastName,
		CL.DateOfIncident, CL.DateNotified, CL.ClaimStatus, PO.PolicyNumber
	FROM Claim AS CL
		INNER JOIN UserAccess(@UserId) AS UA ON CL.PartnerId = UA.PartnerId
		LEFT JOIN [Partner] AS PA ON CL.PartnerId = PA.PartnerId
		LEFT JOIN Product AS PT ON CL.ProductId = PT.ProductId
		LEFT JOIN LineOfBusiness AS LB ON CL.BusinessId = LB.BusinessId
		LEFT JOIN [Policy]  AS PO ON CL.PolicyId = PO.PolicyId
		LEFT JOIN Client AS CLI ON CL.InsuredId = CLI.ClientId
	WHERE (CASE WHEN @PartnerId = -1 OR @PartnerId = CL.PartnerId THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN @ProductId = -1 OR @ProductId = CL.ProductId THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN @BusinessId = -1 OR @BusinessId = CL.BusinessId THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN ISNULL(@ClaimNumber, '') = '' OR @ClaimNumber = CL.ClaimNumber THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN ISNULL(@PolicyNumber, '') = '' OR @PolicyNumber = PO.PolicyNumber THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN ISNULL(@InsuredFirstName, '') = '' OR CLI.FirstName LIKE '%' + @InsuredFirstName + '%' THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN ISNULL(@InsuredLastName, '') = '' OR CLI.LastName LIKE '%' + @InsuredLastName + '%' THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN ISNULL(@ExternalId, '') = '' OR @ExternalId = PO.ExternalId THEN 1 ELSE 0 END) = 1
	AND (CASE WHEN ISNULL(@ClaimStatus, '') = '' OR @ClaimStatus = CL.ClaimStatus THEN 1 ELSE 0 END) = 1
	--AND (CASE WHEN ISNULL(@NotifierLocation, '') = '' OR @NotifierLocation = CL.NotifierLocation THEN 1 ELSE 0 END) = 1
	--AND (CASE WHEN @ConfirmationRequired IS NULL OR @ConfirmationRequired = CL.ConfirmationRequired THEN 1 ELSE 0 END) = 1
END






GO
/****** Object:  StoredProcedure [dbo].[GetClaim]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetClaim]	
	@ClaimId INT
AS
BEGIN
	--Claim
	SELECT CL.*, PT.[Name] AS PartnerName, PR.[Name] AS ProductName,
		LB.[Name] AS BusinessName, UW.[Name] AS UnderWriterName, PO.PolicyNumber,
		PO.ExternalId, CLI.FirstName AS InsuredFirstName, CLI.LastName As InsuredLastName,
		UR.FirstName + ' ' + UR.LastName AS ReviewByName,
		UC.FirstName + ' ' + UC.LastName AS ConfirmedByName,
		UUR.FirstName + ' ' + UUR.LastName AS UWReviewByName,
		UUC.FirstName + ' ' + UUC.LastName AS UWConfirmedByName,
		PO.CoverStartDate AS CoverStartDatePO, PO.CoverEndDate AS CoverEndDatePO, PO.LoanAmount
	FROM Claim AS CL
		LEFT JOIN [Policy] AS PO ON CL.PolicyId = PO.PolicyId
		LEFT JOIN [Partner] AS PT ON CL.PartnerId = PT.PartnerId
		LEFT JOIN Product AS PR ON CL.ProductId = PR.ProductId
		LEFT JOIN LineOfBusiness AS LB ON CL.BusinessId = LB.BusinessId
		LEFT JOIN UnderWriter AS UW ON CL.UnderWriterId = UW.UnderWriterId
		LEFT JOIN Client AS CLI ON CL.InsuredId = CLI.ClientId
		LEFT JOIN Users AS UR ON CL.ReviewBy = UR.UserId
		LEFT JOIN Users AS UC ON CL.ConfirmedBy = UC.UserId
		LEFT JOIN Users AS UUR ON CL.UWReviewBy = UUR.UserId
		LEFT JOIN Users AS UUC ON CL.UWConfirmedBy = UUC.UserId		
	WHERE CL.ClaimId = @ClaimId
END

--EXEC GetClaim @ClaimId = 1




GO
/****** Object:  StoredProcedure [dbo].[GetClaims]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetClaims]	
	@ClaimId INT
AS
BEGIN
	--Claim
	EXEC GetClaim @ClaimId = @ClaimId
	--Insured
	SELECT CLI.* FROM Client AS CLI
		INNER JOIN Claim AS CL ON CLI.ClientId = CL.InsuredId
	WHERE CL.ClaimId = @ClaimId
	--Notifier
	SELECT CLI.* FROM Client AS CLI
		INNER JOIN Claim AS CL ON CLI.ClientId = CL.NotifierId
	WHERE CL.ClaimId = @ClaimId
	--Incident
	SELECT * FROM ClaimIncident WHERE ClaimId = @ClaimId
	--Documents
	SELECT CD.*, US.FirstName + ' ' + US.LastName AS CreatedByName
		FROM ClaimDocument AS CD
	LEFT JOIN Users AS US ON CD.CreatedBy = US.UserId
	WHERE CD.ClaimId = @ClaimId
	--Claim Payment
	SELECT * FROM ClaimPayment WHERE ClaimId = @ClaimId
	--Claim Notes
	SELECT CN.*, US.FirstName + ' ' + US.LastName AS CreatedByName
		FROM ClaimNote AS CN
	LEFT JOIN Users AS US ON CN.CreatedBy = US.UserId
	WHERE CN.ClaimId = @ClaimId
	--PayeeNames
	SELECT CLI.ClientId, CLI.ClientType, RTRIM(CLI.FirstName + ' ' + ISNULL(CLI.LastName, '')) AS ClientName
		FROM Client AS CLI
	INNER JOIN PolicyClient AS PC ON CLI.ClientId = PC.ClientId
	INNER JOIN [Policy] AS PO ON PC.PolicyId = PO.PolicyId
	INNER JOIN Claim AS CL ON PO.PolicyId = CL.PolicyId
	WHERE CL.ClaimId = @ClaimId
	--Cover Formula
	SELECT CF.* FROM CoverFormula AS CF
		INNER JOIN Claim AS CL ON CF.ProductId = CL.ProductId
	WHERE CL.ClaimId = @ClaimId
END

--EXEC GetClaims @ClaimId = 1




GO
/****** Object:  StoredProcedure [dbo].[GetDashBoard]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetDashBoard]
	@UserId INT
AS
BEGIN
	SELECT POL.NewPolicy, POL.TotalPolicy, CLM.NewClaim, CLM.TotalClaim
	FROM
	(
		SELECT 1 AS ComId, COUNT(*) AS TotalPolicy, NewPolicy = SUM(CASE WHEN PO.PolicyStatus = 'Active' THEN 1 ELSE 0 END)
			FROM [Policy] AS PO	
		INNER JOIN UserAccess(@UserId) AS UA ON PO.PartnerId = UA.PartnerId
	) AS POL
	LEFT JOIN 
	(
		SELECT 1 AS ComId, COUNT(*) AS TotalClaim, NewClaim = SUM(CASE WHEN CL.ClaimStatus = 'Registered' THEN 1 ELSE 0 END)
			FROM [Claim] AS CL	
		INNER JOIN UserAccess(@UserId) AS UA ON CL.PartnerId = UA.PartnerId
	) AS CLM ON POL.ComId = CLM.ComId
END
GO
/****** Object:  StoredProcedure [dbo].[MakeSystemCode]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[MakeSystemCode]
	@P_TableName AS VARCHAR(100),
	@P_Date AS VARCHAR(20),
	@P_AddNumber AS SMALLINT = 1,
	@P_ClientDate AS DATETIME,
	@P_Prefix AS VARCHAR(50) = '',
	@P_Suffix AS VARCHAR(50) = ''	
AS
BEGIN
	DECLARE @IdPattern VARCHAR(250),
		@CodePattern VARCHAR(250),
		@Period VARCHAR(10),
		@StartNumber SMALLINT,
		@Increment SMALLINT,
		@Padding SMALLINT,
		@PaddingChar CHAR(1),
		@YearLength SMALLINT,
		@MasterTable VARCHAR(100),
		@DatePeriod VARCHAR(20),
		@MaxNumber BIGINT,
		@SystemId VARCHAR(250),
		@SystemCode VARCHAR(250)
		
	SELECT @IdPattern = IdPattern,
		@CodePattern = CodePattern,
		@Period = [Period],
		@StartNumber = StartNumber,
		@Increment = Increment,
		@Padding = Padding,
		@PaddingChar = PaddingChar,
		@YearLength = YearLength,
		@MasterTable = MasterTable
		FROM SystemCodePattern 
	WHERE TableName = @P_TableName
	
	IF(@IdPattern IS NULL) SET @IdPattern = ''
	IF(@CodePattern IS NULL) SET @CodePattern = ''
	IF(@Period IS NULL) SET @Period = 'Auto'
	IF(@StartNumber IS NULL) SET @StartNumber = 1
	IF(@Increment IS NULL) SET @Increment = 1
	IF(@Padding IS NULL) SET @Padding = 0
	IF(@PaddingChar IS NULL) SET @PaddingChar = '0'
	IF(@YearLength IS NULL) SET @YearLength = 2
	IF(@MasterTable IS NULL) SET @MasterTable = ''	 

	IF(@Period = 'Auto') SET @DatePeriod = 'Auto'
	IF(@Period = 'Yearly') SET @DatePeriod = DATEPART(YEAR, @P_Date)
	IF(@Period = 'Monthly') SET @DatePeriod = DATEPART(YEAR, @P_Date) + '-' + DATENAME(MONTH, @P_Date)
	IF(@Period = 'Daily') SET @DatePeriod = @P_Date
	
	UPDATE  SystemCodeMax        
		SET MaxNumber = MaxNumber + (@P_AddNumber * @Increment),
		UpdatedAt = @P_ClientDate
	WHERE  TableName = @P_TableName	
	AND  [Period] = @DatePeriod

	IF (@@ROWCOUNT <= 0)
	BEGIN
		INSERT INTO SystemCodeMax(TableName, [Period], MaxNumber, UpdatedAt)        
		VALUES (@P_TableName, @DatePeriod, @StartNumber + ((@P_AddNumber - 1) * @Increment), @P_ClientDate)
	END
	--Variables {Prefix}-{Year}-{Month}-{Day}-{Number}-{Suffix}
	SELECT @MaxNumber =  MaxNumber
		FROM SystemCodeMax
	WHERE TableName = @P_TableName AND [Period] = @DatePeriod
	

	SET @SystemId = REPLACE(@IdPattern, '{Year}', RIGHT(DATEPART(YEAR, @P_Date), @YearLength))
	SET @SystemId = REPLACE(@SystemId, '{Month}', REPLACE(STR(DATEPART(MONTH, @P_Date), 2), SPACE(1), '0'))
	SET @SystemId = REPLACE(@SystemId, '{Day}', REPLACE(STR(DATEPART(DAY, @P_Date), 2), SPACE(1), '0'))
	SET @SystemId = REPLACE(@SystemId, '{Prefix}', @P_Prefix)
	SET @SystemId = REPLACE(@SystemId, '{Suffix}', @P_Suffix)

	IF(@Padding > 0 AND @Padding > LEN(@MaxNumber))
		SET @SystemId = REPLACE(@SystemId, '{Number}', REPLACE(STR(@MaxNumber, @Padding), SPACE(1), @PaddingChar))
	ELSE
		SET @SystemId = REPLACE(@SystemId, '{Number}', @MaxNumber)


	SET @SystemCode = REPLACE(@CodePattern, '{Year}', RIGHT(DATEPART(YEAR, @P_Date), @YearLength))
	SET @SystemCode = REPLACE(@SystemCode, '{Month}', REPLACE(STR(DATEPART(MONTH, @P_Date), 2), SPACE(1), '0'))
	SET @SystemCode = REPLACE(@SystemCode, '{Day}', REPLACE(STR(DATEPART(DAY, @P_Date), 2), SPACE(1), '0'))
	SET @SystemCode = REPLACE(@SystemCode, '{Prefix}', @P_Prefix)
	SET @SystemCode = REPLACE(@SystemCode, '{Suffix}', @P_Suffix)

	IF(@Padding > 0 AND @Padding > LEN(@MaxNumber))
		SET @SystemCode = REPLACE(@SystemCode, '{Number}', REPLACE(STR(@MaxNumber, @Padding), SPACE(1), @PaddingChar))
	ELSE
		SET @SystemCode = REPLACE(@SystemCode, '{Number}', @MaxNumber)

	IF(@MasterTable <> '')
	BEGIN
		UPDATE  SystemCodeMax        
			SET MaxNumber = MaxNumber + (@P_AddNumber * @Increment),
			UpdatedAt = @P_ClientDate
		WHERE  TableName = @MasterTable
		AND  [Period] = @DatePeriod

		IF (@@ROWCOUNT <= 0)
		BEGIN
			INSERT INTO SystemCodeMax(TableName, [Period], MaxNumber, UpdatedAt)        
			VALUES (@MasterTable, @DatePeriod, @StartNumber + ((@P_AddNumber - 1) * @Increment), @P_ClientDate)
		END

		SELECT @MaxNumber =  MaxNumber
			FROM SystemCodeMax
		WHERE TableName = @MasterTable AND [Period] = @DatePeriod
	END

	SELECT CONCAT(@MaxNumber, '%', @SystemId, '%', @SystemCode) AS SystemCode

END

--EXEC MakeSystemCode 'DemoTable', '2012-12-10', 1, '2012-12-10 16:08:40.137'

GO
/****** Object:  StoredProcedure [dbo].[PolicySearch]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PolicySearch]
	@UserId INT,
	@ExternalId VARCHAR(50),
	@PolicyNumber VARCHAR(50),
	@FirstName NVARCHAR(100),
	@LastName NVARCHAR(100),
	@PersonalId NVARCHAR(50),
	@PartnerId INT,
	@ProductId INT,
	@SalesReference VARCHAR(50),
	@PolicyStatus VARCHAR(30),
	@ContributionExtRef VARCHAR(50)
AS
BEGIN
	SELECT PO.PolicyId, PO.PolicyNumber, PO.ExternalId, CLI.FirstName, CLI.LastName,
		CLI.MobileNo, PT.[Name] AS ProductName, PO.PolicyStart, PO.PolicyEnd
	FROM [Policy] AS PO	
		LEFT JOIN Product AS PT ON PO.ProductId = PT.ProductId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.FirstName, Cl.LastName, CL.MobileNo, CL.PersonalId
				FROM PolicyClient AS PC
			LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
			WHERE CL.ClientType = 'Primary Insured'
		) AS CLI ON PO.PolicyId = CLI.PolicyId
		INNER JOIN UserAccess(@UserId) AS UA ON PO.PartnerId = UA.PartnerId
	WHERE (CASE WHEN @PartnerId = -1 OR @PartnerId = PO.PartnerId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN @ProductId = -1 OR @ProductId = PO.ProductId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@FirstName, '') = '' OR CLI.FirstName LIKE '%' + @FirstName + '%' THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@LastName, '') = '' OR CLI.LastName LIKE '%' + @LastName + '%' THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@ExternalId, '') = '' OR @ExternalId = PO.ExternalId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@PolicyNumber, '') = '' OR @PolicyNumber = PO.PolicyNumber THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@PersonalId, '') = '' OR @PersonalId = CLI.PersonalId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@SalesReference, '') = '' OR @SalesReference = PO.SalesReference THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@PolicyStatus, '') = '' OR @PolicyStatus = PO.PolicyStatus THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@ContributionExtRef, '') = '' OR @ContributionExtRef = PO.ContributionExtRef THEN 1 ELSE 0 END) = 1
END







GO
/****** Object:  StoredProcedure [dbo].[RPTClaimDetails]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[RPTClaimDetails]
	@UserId INT,	
	@PartnerId INT,
	@ProductId INT,	
	@ClaimStatus VARCHAR(50),	
	@FromDate VARCHAR(15),
	@ToDate VARCHAR(15)
AS
BEGIN
	SELECT CR.Name AS PartnerCountry, PA.[Name] AS [Partner], PT.[Name] AS Product,
		CLN.Location AS NotifierLocation, CL.DateNotified, UR.Name AS Underwriter,
		LB.[Name] AS LineOfBusiness, PO.ExternalId, PO.PolicyNumber, CL.ClaimNumber,
		POC.FirstName AS PolicyFirstName, POC.LastName AS PolicyLastName,
		CLI.FirstName AS InsuredFirstName, CLI.LastName AS InsuredLastName,
		CLI.Gender AS InsuredGender, CLI.DateofBirth AS InsuredDateofBirth,
		CLI.AgeAtCreationDate AS InsuredAgeAtIncident, POB.FirstName AS BeneficiaryFirstName, POB.LastName AS BeneficiaryLastName,
		CIN.IncidentType, CIN.CauseOfIncident, CIN.Note AS Details,
		CL.CoverStartDate, CL.CoverEndDate, CL.DateOfIncident, CIN.DateOfDeath, CIN.LocationOfIncident,
		CIN.HospitalName, CIN.HospitalWard, CIN.HospitalLocation, CL.CoverAmount, CL.RevisedCoverAmount,
		CL.ClaimStatus, CL.CreatedAt AS Registered, DocumentsIncomplete = (CASE WHEN CL.DocumentCompleteDate IS NULL THEN 0 ELSE 1 END),
		CL.DocumentCompleteDate AS DateCompleteDocReceived, CL.ReviewDate AS DateClaimReviewed, USR.FirstName + ' ' + USR.LastName AS ClaimReviewedBy,
		CL.ConfirmedDate AS DateClaimReviewConfirmed, USC.FirstName + ' ' + USC.LastName AS ClaimConfirmedBy, CL.ApprovedAmount AS ClaimReviewAmount,
		CL.Decision AS ClaimReviewDecision, CL.RejectionReason AS ClaimReviewRejectionReason,
		CL.UWReviewDate AS DateUWReviewed, USU.FirstName + ' ' + USU.LastName AS UWReviewedBy,
		CL.UWConfirmedDate AS DateUWReviewConfirmed, USUC.FirstName + ' ' + USUC.LastName AS UWConfirmedBy,
		CL.UWApprovedAmount AS UWApprovedAmount, CL.UWDecision, CL.UWRejectionReason AS UWDecisionRejectionReason,
		CL.ClosureReason, CL.ClosureDate AS DateClosed
	FROM Claim AS CL
		INNER JOIN UserAccess(@UserId) AS UA ON CL.PartnerId = UA.PartnerId
		LEFT JOIN [Partner] AS PA ON CL.PartnerId = PA.PartnerId
		LEFT JOIN Product AS PT ON CL.ProductId = PT.ProductId
		LEFT JOIN LineOfBusiness AS LB ON CL.BusinessId = LB.BusinessId
		LEFT JOIN UnderWriter AS UR ON CL.UnderWriterId = UR.UnderWriterId
		LEFT JOIN [Policy]  AS PO ON CL.PolicyId = PO.PolicyId
		LEFT JOIN ClaimIncident AS CIN ON CL.ClaimId = CIN.ClaimId
		LEFT JOIN Client AS CLI ON CL.InsuredId = CLI.ClientId
		LEFT JOIN Client AS CLN ON CL.NotifierId = CLN.ClientId
		LEFT JOIN Country AS CR ON PA.CountryId = CR.CountryId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.FirstName, Cl.LastName
				FROM PolicyClient AS PC
			LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
			WHERE CL.ClientType = 'Primary Insured'
		) AS POC ON PO.PolicyId = POC.PolicyId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.FirstName, Cl.LastName
				FROM PolicyClient AS PC
			LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
			WHERE CL.ClientType = 'Beneficiary'
		) AS POB ON PO.PolicyId = POB.PolicyId
		LEFT JOIN Users AS USR ON CL.ReviewBy = USR.UserId
		LEFT JOIN Users AS USC ON CL.ConfirmedBy = USC.UserId
		LEFT JOIN Users AS USU ON CL.UWReviewBy = USU.UserId
		LEFT JOIN Users AS USUC ON CL.UWConfirmedBy = USUC.UserId
	WHERE (CASE WHEN @PartnerId = -1 OR @PartnerId = CL.PartnerId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN @ProductId = -1 OR @ProductId = CL.ProductId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN @ClaimStatus = 'All' OR @ClaimStatus = CL.ClaimStatus THEN 1 ELSE 0 END) = 1
		AND (CASE 
			WHEN @FromDate IS NULL OR @ToDate IS NULL THEN 1
			WHEN CL.StatusCreated BETWEEN @FromDate AND @ToDate THEN 1
		ELSE 0 END) = 1
END



GO
/****** Object:  StoredProcedure [dbo].[RPTClaimPayments]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RPTClaimPayments]
	@UserId INT,	
	@PartnerId INT,
	@ProductId INT,		
	@FromDate VARCHAR(15),
	@ToDate VARCHAR(15)
AS
BEGIN
	SELECT CR.Name AS PartnerCountry, PA.[Name] AS [Partner], PT.[Name] AS Product,
		UR.Name AS Underwriter, LB.[Name] AS LineOfBusiness, PO.ExternalId, PO.PolicyNumber, PO.PolicyStart,
		CL.ClaimNumber, POC.FirstName AS PolicyFirstName, POC.LastName AS PolicyLastName,
		CLI.FirstName AS InsuredFirstName, CLI.LastName AS InsuredLastName,
		CLI.Gender AS InsuredGender, CLI.DateofBirth AS InsuredDateofBirth, CL.CoverStartDate, CL.CoverEndDate,
		CL.CoverAmount, CL.RevisedCoverAmount, CL.DateNotified, CL.DateOfIncident, CIN.IncidentType, CIN.CauseOfIncident,
		CL.ApprovedAmount AS ClaimReviewAmount, CL.UWApprovedAmount, CL.DocumentCompleteDate AS DateCompleteDocReceived, CL.ClaimStatus,
		CL.ReviewDate AS DateClaimApprovedOrRejected, CL.Decision, CL.RejectionReason, CL.ClosureReason, CL.ClosureDate,
		CP.PaymentMethod, CP.Amount AS PaymentAmount, CP.TransactionRef AS PaymentReference, CP.AccountName, CP.AccountNumber,
		CP.BankIdentificationNumber, CP.ReceivingBank, CP.SendingBank, CP.WalletName, CP.WalletNumber,
		CP.NameOnCheque, CP.ChequeNumber, CP.ChequeAddress, CP.ReceivedPayeeDate AS PaymentReceivedByClaimsTeam,
		CP.IssuedDate AS PaymentIssueDate, CP.IssuedBy AS PaymentIssuedBy, CP.PayeeComment,
		CP.PayeeType, PayeeName = (CASE WHEN CP.PayeeId IS NULL THEN CP.PayeeName ELSE RTRIM(CLP.FirstName + ' ' + ISNULL(CLP.LastName, '')) END),
		CLP.Relationship AS PayeeRelationship, CLP.MobileNo AS PayeeMobileNumber, CLP.Email AS PayeeEmailAddress, CLP.Gender AS PayeeGender,
		CLP.PersonalIdType AS PayeeIdentificationType, CLP.PersonalId AS PayeeIdentificationNumber,
		CLP.[Address] AS PayeeAddress, CLP.Location AS PayeeLocation, CLP.PostalCode AS PayeePostalCode
	FROM Claim AS CL
		INNER JOIN UserAccess(@UserId) AS UA ON CL.PartnerId = UA.PartnerId
		LEFT JOIN [Partner] AS PA ON CL.PartnerId = PA.PartnerId
		LEFT JOIN Product AS PT ON CL.ProductId = PT.ProductId
		LEFT JOIN LineOfBusiness AS LB ON CL.BusinessId = LB.BusinessId
		LEFT JOIN UnderWriter AS UR ON CL.UnderWriterId = UR.UnderWriterId
		LEFT JOIN [Policy]  AS PO ON CL.PolicyId = PO.PolicyId
		INNER JOIN ClaimPayment AS CP ON CL.ClaimId = CP.ClaimId
		LEFT JOIN ClaimIncident AS CIN ON CL.ClaimId = CIN.ClaimId
		LEFT JOIN Client AS CLI ON CL.InsuredId = CLI.ClientId
		LEFT JOIN Client AS CLP ON CP.PayeeId = CLP.ClientId
		LEFT JOIN Country AS CR ON PA.CountryId = CR.CountryId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.FirstName, Cl.LastName
				FROM PolicyClient AS PC
			LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
			WHERE CL.ClientType = 'Primary Insured'
		) AS POC ON PO.PolicyId = POC.PolicyId
	WHERE (CASE WHEN @PartnerId = -1 OR @PartnerId = CL.PartnerId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN @ProductId = -1 OR @ProductId = CL.ProductId THEN 1 ELSE 0 END) = 1
		AND (CASE 
			WHEN @FromDate IS NULL OR @ToDate IS NULL THEN 1
			WHEN CP.IssuedDate BETWEEN @FromDate AND @ToDate THEN 1
		ELSE 0 END) = 1
END


GO
/****** Object:  StoredProcedure [dbo].[RPTClient]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RPTClient]
	@UserId INT,
	@PartnerId INT,
	@ProductId INT,	
	@NonInsured VARCHAR(3),
	@Criteria VARCHAR(50),
	@FromDate VARCHAR(15),
	@ToDate VARCHAR(15)
AS
BEGIN
	SELECT PO.PolicyNumber, PO.ExternalId, PAT.[Name] AS PartnerName,
		PT.ProductCode, PT.[Name] AS ProductName, PO.PolicyStart, PO.PolicyEnd,
		CLI.ClientType, CLI.PersonalIdType, CLI.PersonalId, CLI.FirstName, CLI.LastName, CLI.MobileNo,
		CLI.Relationship, CLI.AccountNo, CLI.DateofBirth, CLI.AgeAtCreationDate, CLI.Gender, CLI.MaritalStatus,
		CLI.[Address], CLI.[Location], CLI.PostalCode, CLI.Email, CLI.[Language], CLI.Communication
	FROM [Policy] AS PO
		LEFT JOIN [Partner] AS PAT ON PO.PartnerId = PAT.PartnerId
		LEFT JOIN Product AS PT ON PO.ProductId = PT.ProductId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.*
				FROM PolicyClient AS PC
			INNER JOIN Client AS CL ON PC.ClientId = CL.ClientId			
		) AS CLI ON PO.PolicyId = CLI.PolicyId
		INNER JOIN UserAccess(@UserId) AS UA ON PO.PartnerId = UA.PartnerId
	WHERE PO.PartnerId = @PartnerId
		AND (CASE WHEN @ProductId = -1 OR @ProductId = PO.ProductId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN @NonInsured = 'Yes' OR CLI.ClientType = 'Primary Insured' OR CLI.ClientType = 'Secondary Insured' THEN 1 ELSE 0 END) = 1
		AND (CASE 
			WHEN @Criteria = 'All' THEN 1
			WHEN @FromDate IS NULL OR @ToDate IS NULL THEN 1
			WHEN @Criteria = 'Client Created' AND CLI.CreatedAt BETWEEN @FromDate AND @ToDate THEN 1
			WHEN @Criteria = 'Client Association Started' AND PO.PolicyStart BETWEEN @FromDate AND @ToDate THEN 1
			WHEN @Criteria = 'Client Association Ended' AND PO.PolicyEnd BETWEEN @FromDate AND @ToDate THEN 1
		ELSE 0 END) = 1
END

--EXEC RPTClient @UserId = 1, @PartnerId = 3, @ProductId = -1, @NonInsured = 'Yes', @Criteria = 'Client Created', @FromDate = '2019-Jan-01', @ToDate = '2019-Dec-01'
--EXEC RPTClient @UserId = 1, @PartnerId = 3, @ProductId = -1, @NonInsured = 'Yes', @Criteria = 'All', @FromDate = NULL, @ToDate = NULL





GO
/****** Object:  StoredProcedure [dbo].[RPTCover]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RPTCover]
	@UserId INT,
	@PartnerId INT,
	@ProductId INT,
	@Criteria VARCHAR(50),	
	@FromDate VARCHAR(15),
	@ToDate VARCHAR(15)
AS
BEGIN
	SELECT * FROM [Partner]
END

--EXEC RPTCover @UserId = 1, @PartnerId = 3, @ProductId = -1, @Criteria = 'Cover Created - All', @FromDate = '2019-Jan-01', @ToDate = '2019-Dec-01'






GO
/****** Object:  StoredProcedure [dbo].[RPTCWT]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RPTCWT]
	@UserId INT,	
	@PartnerId INT,
	@ProductId INT	
AS
BEGIN
	SELECT PA.[Name] AS [Partner], PT.[Name] AS Product,
		CLI.Relationship AS InsuredRelationship,
		CLI.Gender AS InsuredGender, CLI.DateofBirth AS InsuredDateofBirth, CLI.AgeAtCreationDate AS InsuredAge,
		CL.DateNotified, LB.[Name] AS LineOfBusiness, CIN.CauseOfIncident, CIN.IncidentType,
		UR.Name AS Underwriter, CR.Name AS PartnerCountry, CL.DateOfIncident, CIN.DateOfDeath,
		CL.ClaimNumber, CL.DocumentCompleteDate AS DateCompleteDocReceived, CL.ReviewDate AS DateClaimVerificationComplete,
		CL.UWSentDate AS DateSentCompleteToUW, CL.ConfirmedDate AS DateClaimApprovedOrRejected, CL.ClaimStatus,
		CL.CoverAmount, CP.Amount AS ClaimAmountPaid,
		CP.IssuedDate AS DateClaimPaid, CP.ReceivedPayeeDate AS DateClaimPaymentReceivedByPayee,
		CL.ApprovedAmount AS AdminApprovedAmount, CL.UWApprovedAmount,
		CL.RejectionReason, CL.ClosureReason
	FROM Claim AS CL
		INNER JOIN UserAccess(@UserId) AS UA ON CL.PartnerId = UA.PartnerId
		LEFT JOIN [Partner] AS PA ON CL.PartnerId = PA.PartnerId
		LEFT JOIN Product AS PT ON CL.ProductId = PT.ProductId
		LEFT JOIN LineOfBusiness AS LB ON CL.BusinessId = LB.BusinessId
		LEFT JOIN UnderWriter AS UR ON CL.UnderWriterId = UR.UnderWriterId
		LEFT JOIN ClaimIncident AS CIN ON CL.ClaimId = CIN.ClaimId
		LEFT JOIN Client AS CLI ON CL.InsuredId = CLI.ClientId
		LEFT JOIN Country AS CR ON PA.CountryId = CR.CountryId
		INNER JOIN ClaimPayment AS CP ON CL.ClaimId = CP.ClaimId
	WHERE (CASE WHEN @PartnerId = -1 OR @PartnerId = CL.PartnerId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN @ProductId = -1 OR @ProductId = CL.ProductId THEN 1 ELSE 0 END) = 1
END





GO
/****** Object:  StoredProcedure [dbo].[RPTPartner]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RPTPartner]
	@UserId INT,	
	@PartnerId INT,
	@ProductId INT,	
	@BenefitId INT,
	@SalesReference VARCHAR(100),
	@Criteria VARCHAR(50),	
	@FromDate VARCHAR(15),
	@ToDate VARCHAR(15)
AS
BEGIN
	SELECT PO.ExternalId, PO.SalesReference, PAT.[Name] AS PartnerName,
		PT.ProductCode, PT.[Name] AS ProductName, BF.Name AS BenefitSubscribed, PO.PolicyNumber,
		PO.CreatedAt AS PolicyCreateDate, PO.PolicyStart, PO.PolicyEnd, PO.EndReason AS PolicyEndReason,
		POP.FirstName AS PrimaryInsuredFirstName, POP.LastName AS PrimaryInsuredLastName, POP.DateofBirth AS PrimaryInsuredDateOfBirth,
		POP.Gender AS PrimaryInsuredGender, POP.MaritalStatus AS PrimaryInsuredMaritalStatus, POP.PersonalIdType AS PrimaryInsuredIDType, POP.PersonalId AS PrimaryInsuredIDNumber,
		POS.FirstName AS SecondaryInsuredFirstName, POS.LastName AS SecondaryInsuredLastName, POS.DateofBirth AS SecondaryInsuredDateOfBirth,
		POS.Relationship AS SecondaryInsuredRelationship, POS.Gender AS SecondaryInsuredGender, POS.MaritalStatus AS SecondaryInsuredMaritalStatus,
		POB.FirstName AS BeneficiaryFirstName, POB.LastName AS BeneficiaryLastName, POB.DateofBirth AS BeneficiaryDateOfBirth,
		POB.Relationship AS BeneficiaryRelationship, POB.Gender AS BeneficiaryGender,
		PO.CoverStartDate, PO.CoverEndDate, PO.LoanAmount,
		PA.AssetType, PA.AssetDescription, PA.[Address] AS AssetAddress, PA.Location AS AssetLocation,
		PA.PostalCode AS AssetPostalCode, PA.AssetValue, PA.AssetCount, PA.BusinessDescription, PA.StructureType
	FROM [Policy] AS PO
		LEFT JOIN [Partner] AS PAT ON PO.PartnerId = PAT.PartnerId
		LEFT JOIN Product AS PT ON PO.ProductId = PT.ProductId
		LEFT JOIN Benefit AS BF ON PO.BenefitId = BF.BenefitId
		INNER JOIN UserAccess(@UserId) AS UA ON PO.PartnerId = UA.PartnerId
		LEFT JOIN PolicyAsset AS PA ON PO.PolicyId = PA.PolicyId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.FirstName, CL.LastName, CL.DateofBirth,
				CL.Gender, CL.MaritalStatus, CL.PersonalIdType, CL.PersonalId
				FROM PolicyClient AS PC
			LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
			WHERE CL.ClientType = 'Primary Insured'
		) AS POP ON PO.PolicyId = POP.PolicyId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.FirstName, CL.LastName, CL.DateofBirth,
				CL.Gender, CL.MaritalStatus, CL.Relationship
				FROM PolicyClient AS PC
			LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
			WHERE CL.ClientType = 'Secondary Insured'
		) AS POS ON PO.PolicyId = POS.PolicyId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.FirstName, CL.LastName, CL.DateofBirth,
				CL.Gender, CL.MaritalStatus, CL.Relationship
				FROM PolicyClient AS PC
			LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
			WHERE CL.ClientType = 'Beneficiary'
		) AS POB ON PO.PolicyId = POB.PolicyId
	WHERE PO.PartnerId = @PartnerId
		AND (CASE WHEN @ProductId = -1 OR @ProductId = PO.ProductId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN @BenefitId = -1 OR @BenefitId = PO.BenefitId THEN 1 ELSE 0 END) = 1
		AND (CASE WHEN ISNULL(@SalesReference, '') = '' OR @SalesReference = PO.SalesReference THEN 1 ELSE 0 END) = 1
		AND (CASE 
			WHEN @Criteria = 'All' THEN 1
			WHEN @FromDate IS NULL OR @ToDate IS NULL THEN 1
			WHEN @Criteria = 'Policy Created' AND PO.CreatedAt BETWEEN @FromDate AND @ToDate THEN 1
			WHEN @Criteria = 'Policy Started' AND PO.PolicyStart BETWEEN @FromDate AND @ToDate THEN 1
			WHEN @Criteria = 'Policy Ended' AND PO.PolicyEnd BETWEEN @FromDate AND @ToDate THEN 1
		ELSE 0 END) = 1
END





GO
/****** Object:  StoredProcedure [dbo].[RPTPayment]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RPTPayment]
	@UserId INT,
	@PartnerId INT,
	@ProductId INT,
	@PaymentStatus VARCHAR(50),
	@Criteria VARCHAR(50),	
	@FromDate VARCHAR(15),
	@ToDate VARCHAR(15)
AS
BEGIN
	SELECT * FROM [Partner]
END





GO
/****** Object:  StoredProcedure [dbo].[RPTPolicy]    Script Date: 2/18/2020 3:17:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RPTPolicy]
	@UserId INT,
	@PartnerId INT,
	@ProductId INT,	
	@Criteria VARCHAR(50),
	@FromDate VARCHAR(15),
	@ToDate VARCHAR(15)
AS
BEGIN
	SELECT PO.ExternalId, PAT.[Name] AS PartnerName,
		PT.ProductCode, PT.[Name] AS ProductName, BF.Name AS BenefitSubscribed,
		PO.PolicyNumber,
		PO.CreatedAt AS PolicyCreateDate, PO.PolicyStart AS PolicyStartDate, PO.PolicyEnd AS PolicyEndDate, PO.RequestedEndDate AS PolicyRequestEndDate, PO.EndReason AS PolicyEndReason,
		CLI.FirstName AS ClientFirstName, CLI.LastName AS ClientLastName, PO.SalesReference
	FROM [Policy] AS PO
		LEFT JOIN [Partner] AS PAT ON PO.PartnerId = PAT.PartnerId
		LEFT JOIN Product AS PT ON PO.ProductId = PT.ProductId
		LEFT JOIN
		(
			SELECT PC.PolicyId, CL.*
				FROM PolicyClient AS PC
			INNER JOIN Client AS CL ON PC.ClientId = CL.ClientId			
		) AS CLI ON PO.PolicyId = CLI.PolicyId
		LEFT JOIN Benefit AS BF ON PO.BenefitId = BF.BenefitId
		INNER JOIN UserAccess(@UserId) AS UA ON PO.PartnerId = UA.PartnerId
	WHERE PO.PartnerId = @PartnerId
		AND (CASE WHEN @ProductId = -1 OR @ProductId = PO.ProductId THEN 1 ELSE 0 END) = 1
		AND (CASE 
			WHEN @Criteria = 'All' THEN 1
			WHEN @FromDate IS NULL OR @ToDate IS NULL THEN 1
			WHEN @Criteria = 'Policy Created' AND PO.CreatedAt BETWEEN @FromDate AND @ToDate THEN 1
			WHEN @Criteria = 'Policy Started' AND PO.PolicyStart BETWEEN @FromDate AND @ToDate THEN 1
			WHEN @Criteria = 'Policy Ended' AND PO.PolicyEnd BETWEEN @FromDate AND @ToDate THEN 1
		ELSE 0 END) = 1
END

--EXEC RPTPolicy @UserId = 1, @PartnerId = 3, @ProductId = -1, @Criteria = 'All', @FromDate = NULL, @ToDate = NULL



GO
