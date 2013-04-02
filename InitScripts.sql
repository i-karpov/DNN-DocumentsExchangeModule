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
			[OriginalName] nvarchar(100) NOT NULL,
			[ConcentType] nvarchar(100) NOT NULL,
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
	

INSERT INTO [dbo].[IgorKarpov_DocumentsExchangeModule_Files] ([OriginalName], [ConcentType], [CreationDate])
SELECT 'RootFile1', 'n/a', GETDATE()
UNION ALL
SELECT 'RootFile2', 'n/a', GETDATE()
UNION ALL
SELECT 'RootFile3', 'n/a', GETDATE()			