USE DNNDemoDb
GO

-- при удалении папок придётся руками рекурсивно удалять все подпапки
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_Folders]') and OBJECTPROPERTY(id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE [dbo].[IgorKarpov_DocumentsExchangeModule_Folders]
		(
			[Id] int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			[ParentFolderId] int FOREIGN KEY REFERENCES [dbo].[IgorKarpov_DocumentsExchangeModule_Folders](Id),
			[Name] nvarchar(100) NOT NULL,
			[CreatorUserId] int NOT NULL FOREIGN KEY REFERENCES [dbo].[Users](UserID),
			[CreationDate] datetime NOT NULL
		)
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_Files]') and OBJECTPROPERTY(id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE [dbo].[IgorKarpov_DocumentsExchangeModule_Files]
		(
			[Id] int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			[ParentFolderId] int FOREIGN KEY REFERENCES [dbo].[IgorKarpov_DocumentsExchangeModule_Folders](Id) ON DELETE CASCADE,
			[OriginalName] nvarchar(MAX) NOT NULL,
			[ContentType] nvarchar(100) NOT NULL,
			[CreatorUserId] int NOT NULL FOREIGN KEY REFERENCES [dbo].[Users](UserID),
			[CreationDate] datetime NOT NULL
		)
	END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_FileVersions]') and OBJECTPROPERTY(id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE [dbo].[IgorKarpov_DocumentsExchangeModule_FileVersions]
		(
			[Id] int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
			[FileId] int NOT NULL FOREIGN KEY REFERENCES [dbo].[IgorKarpov_DocumentsExchangeModule_Files](Id) ON DELETE CASCADE,
			[LocalName] nvarchar(50) NOT NULL,
			[CreatorUserId] int NOT NULL FOREIGN KEY REFERENCES [dbo].[Users](UserID),
			[CreationDate] datetime NOT NULL
		)
	END
GO




INSERT INTO [dbo].[IgorKarpov_DocumentsExchangeModule_Folders] ([Name], [CreatorUserId], [CreationDate])
SELECT 'FullFolder1', 1, GETDATE()
UNION ALL
SELECT 'EmptyFolder2', 1, GETDATE()
UNION ALL
SELECT 'EmptyFolder3', 1, GETDATE()
	

INSERT INTO [dbo].[IgorKarpov_DocumentsExchangeModule_Files] ([OriginalName], [ParentFolderId], [ConcentType], [CreatorUserId], [CreationDate])
SELECT 'RootFile1', NULL, 'n/a', 1, GETDATE()
UNION ALL
SELECT 'RootFile2', NULL, 'n/a', 1, GETDATE()
UNION ALL
SELECT 'RootFile3', NULL, 'n/a', 1, GETDATE()	
UNION ALL
SELECT 'Subfile3', 5, 'n/a', 1, GETDATE()	



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_GetFolders]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[IgorKarpov_DocumentsExchangeModule_GetFolders]
GO

create procedure [dbo].[IgorKarpov_DocumentsExchangeModule_GetFolders]
	@ParentFolderId int
as
select Id,
	   ParentFolderId,
	   Name,
	   CreatorUserId,
	   folders.CreationDate,
	   'CreatorDisplayName' = [Users].DisplayName
from [IgorKarpov_DocumentsExchangeModule_Folders] folders
inner join [Users] on folders.[CreatorUserId] = [Users].[UserId]
where (@ParentFolderId IS NOT NULL and [ParentFolderId] = @ParentFolderId)
   or (@ParentFolderId IS NULL and [ParentFolderId] IS NULL)
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_GetFiles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[IgorKarpov_DocumentsExchangeModule_GetFiles]
GO

create procedure [dbo].[IgorKarpov_DocumentsExchangeModule_GetFiles]
	@ParentFolderId int
as
select files.Id,
	   ParentFolderId,
	   OriginalName,
	   ContentType,
	   files.CreatorUserId,
	   files.CreationDate,
	   'CreatorDisplayName' = [Users].DisplayName,
	   'LastVersionDate' = [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionDate](files.Id),
	   'LastVersionId' = [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionId](files.Id)
from [IgorKarpov_DocumentsExchangeModule_Files] files
inner join [Users] on files.[CreatorUserId] = [Users].[UserId]
where (@ParentFolderId IS NOT NULL and [ParentFolderId] = @ParentFolderId)
   or (@ParentFolderId IS NULL and [ParentFolderId] IS NULL)
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_AddFolder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[IgorKarpov_DocumentsExchangeModule_AddFolder]
GO


create procedure [dbo].[IgorKarpov_DocumentsExchangeModule_AddFolder]
	@parentFolderId int,
	@name nvarchar(MAX),
	@creatorUserId int
as
insert into [IgorKarpov_DocumentsExchangeModule_Folders] (
	ParentFolderId,
	Name,
	CreatorUserId,
	CreationDate
) 
values (
	@parentFolderId,
	@name,
	@creatorUserId,
	GETDATE()
)
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionDate]') and OBJECTPROPERTY(id, N'IsFunction') = 1)
    DROP FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionDate];
GO
CREATE FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionDate] (@fileId int)
RETURNS DateTime
AS
BEGIN
declare @creationDate DateTime
SELECT TOP (1) @creationDate = [CreationDate] 
	FROM [dbo].[IgorKarpov_DocumentsExchangeModule_FileVersions]
	WHERE [FileId] = @fileId
	ORDER BY [CreationDate] DESC
RETURN @creationDate
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionId]') and OBJECTPROPERTY(id, N'IsFunction') = 1)
    DROP FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionId];
GO
CREATE FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionId] (@fileId int)
RETURNS int
AS
BEGIN
declare @lastVersionId int
SELECT TOP (1) @lastVersionId = [Id] 
	FROM [dbo].[IgorKarpov_DocumentsExchangeModule_FileVersions]
	WHERE [FileId] = @fileId
	ORDER BY [CreationDate] DESC
RETURN @lastVersionId
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionLocalName]') and OBJECTPROPERTY(id, N'IsFunction') = 1)
    DROP FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionLocalName];
GO
CREATE FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileLastVersionLocalName] (@fileId int)
RETURNS nvarchar(50)
AS
BEGIN
declare @localName nvarchar(50)
SELECT TOP (1) @localName = [LocalName] 
	FROM [dbo].[IgorKarpov_DocumentsExchangeModule_FileVersions]
	WHERE [FileId] = @fileId
	ORDER BY [CreationDate] DESC
RETURN @localName
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_GetFileContentType]') and OBJECTPROPERTY(id, N'IsFunction') = 1)
    DROP FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileContentType];
GO
CREATE FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_GetFileContentType] (@fileId int)
RETURNS nvarchar(100)
AS
BEGIN
declare @contentType nvarchar(100)
SELECT TOP (1) @contentType = [ContentType] 
	FROM [dbo].[IgorKarpov_DocumentsExchangeModule_Files]
	WHERE [Id] = @fileId
	ORDER BY [CreationDate] DESC
RETURN @contentType
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_IsFileNameLocallyAvailable]') and OBJECTPROPERTY(id, N'IsFunction') = 1)
    DROP FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_IsOriginalFileNameLocallyAvailable];
GO
CREATE FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_IsOriginalFileNameLocallyAvailable]
	(@parentFolderId int, @targetFileName nvarchar(100))
RETURNS bit
AS
BEGIN
declare @matchesCount int
declare @isAvailable bit
SELECT @matchesCount = COUNT(*) 
	FROM [dbo].[IgorKarpov_DocumentsExchangeModule_Files]
	WHERE (@parentFolderId IS NOT NULL and [ParentFolderId] = @parentFolderId
			or @parentFolderId IS NULL and [ParentFolderId] IS NULL)
	  and [OriginalName] = @targetFileName
IF @matchesCount > 0
	set @isAvailable = 0
ELSE
	set @isAvailable = 1
RETURN @isAvailable
END
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IgorKarpov_DocumentsExchangeModule_IsFolderNameLocallyAvailable]') and OBJECTPROPERTY(id, N'IsFunction') = 1)
    DROP FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_IsFolderNameLocallyAvailable];
GO
CREATE FUNCTION [dbo].[IgorKarpov_DocumentsExchangeModule_IsFolderNameLocallyAvailable]
	(@parentFolderId int, @targetFolderName nvarchar(100))
RETURNS bit
AS
BEGIN
declare @matchesCount int
declare @isAvailable bit
SELECT @matchesCount = COUNT(*) 
	FROM [dbo].[IgorKarpov_DocumentsExchangeModule_Folders]
	WHERE (@parentFolderId IS NOT NULL and [ParentFolderId] = @parentFolderId
			or @parentFolderId IS NULL and [ParentFolderId] IS NULL)
	  and [Name] = @targetFolderName
IF @matchesCount > 0
	set @isAvailable = 0
ELSE
	set @isAvailable = 1
RETURN @isAvailable
END
GO

