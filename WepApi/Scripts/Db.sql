USE [master]
GO
/****** Object:  Database [Deneme]    Script Date: 15.01.2021 00:08:32 ******/
CREATE DATABASE [Deneme]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Deneme', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Deneme.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Deneme_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Deneme_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Deneme] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Deneme].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Deneme] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Deneme] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Deneme] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Deneme] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Deneme] SET ARITHABORT OFF 
GO
ALTER DATABASE [Deneme] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Deneme] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Deneme] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Deneme] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Deneme] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Deneme] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Deneme] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Deneme] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Deneme] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Deneme] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Deneme] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Deneme] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Deneme] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Deneme] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Deneme] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Deneme] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Deneme] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Deneme] SET RECOVERY FULL 
GO
ALTER DATABASE [Deneme] SET  MULTI_USER 
GO
ALTER DATABASE [Deneme] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Deneme] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Deneme] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Deneme] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Deneme] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Deneme', N'ON'
GO
USE [Deneme]
GO
/****** Object:  Table [dbo].[Blogs]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BlogDescription] [nvarchar](max) NULL,
	[UserName] [nvarchar](50) NULL,
	[InstertDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_Blogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Blogs] ADD  CONSTRAINT [DF_Blogs_InstertDate]  DEFAULT (getdate()) FOR [InstertDate]
GO
/****** Object:  StoredProcedure [dbo].[check_code]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[check_code]
	@Code NVARCHAR(8),
	@IsValid INT OUT
AS
BEGIN
	-- Kod kontrolü için gerekli algoritma
	-- [generate_codes] ile üretilen her kod [check_code] ile doğrulanabilmelidir.
	-- Bu aşamada kod bir tabloda aranmayacaktır!

	DECLARE @i INT = 0
	DECLARE @a INT = 0
    
	DECLARE @CharactersToUse VARCHAR(23) = 'ACDEFGHKLMNPRTXYZ234579'

	DECLARE @Char CHAR(1) = ''
	DECLARE @CodeChar CHAR(1) = ''

	WHILE @a < LEN(@Code)
	BEGIN
		SELECT @a = @a + 1

		SET @CodeChar = ''

		SET @CodeChar = SUBSTRING(@Code,@a,1)

		WHILE @i < LEN(@CharactersToUse)
		BEGIN
			SELECT @i = @i + 1

			SET @Char = ''

			SET @Char = SUBSTRING(@CharactersToUse,@i,1)

			IF @Code = @CodeChar
			BEGIN
				SET @IsValid = 1
				BREAK
			END	
		END	
	END
END
GO
/****** Object:  StoredProcedure [dbo].[generate_codes]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[generate_codes]
AS
BEGIN
	DECLARE @i INT = 0
	DECLARE @CharactersToUse VARCHAR(24) = 'ACDEFGHKLMNPRTXYZ234579'
	DECLARE @stringLength INT = 8

	DECLARE @Characters VARCHAR(100) = ''
	DECLARE @Count INT = 0

	DECLARE @string VARCHAR(8) = ''

	WHILE @i < 1000
	BEGIN

		SET @Characters = ''
		SET @Count = 0
		SET @string = ''

		IF LEN(@CharactersToUse) > 0
		BEGIN
			WHILE CHARINDEX(@CharactersToUse,' ') > 0
			BEGIN
				SET @CharactersToUse = REPLACE(@CharactersToUse,' ','')
			END

			WHILE @Count <= @StringLength
			BEGIN
				SET @String = @String + SUBSTRING(@CharactersToUse,CAST(ABS(CHECKSUM(NEWID())) * RAND(@Count) AS INT) % LEN(@CharactersToUse) + 1,1)
				SET @Count = @Count + 1
			END
		END
		ELSE
		BEGIN
			WHILE @Count <= @StringLength
			BEGIN
				SET @String = @String + SUBSTRING(@Characters,CAST(ABS(CHECKSUM(NEWID())) * RAND(@Count) AS INT) % LEN(@Characters) + 1,1)
				SET @Count = @Count + 1
			END
		END
		
		SET @i = @i + 1

		DECLARE @IsValid INT

		EXEC check_code @String,@IsValid OUTPUT

		IF @IsValid = 0
		BEGIN
			SET @i = @i

			SELECT 'a'
		END
		ELSE	
		BEGIN
			SELECT @String
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BlogDelete]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BlogDelete]
	@Id INT
AS
BEGIN
	DELETE
	FROM dbo.Blogs
	WHERE Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BlogGet]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BlogGet]
AS
BEGIN
	SELECT
		*
	FROM dbo.Blogs
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BlogGetById]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BlogGetById]
	@Id INT
AS
BEGIN
	SELECT
		*
	FROM dbo.Blogs
	WHERE Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BlogInsert]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BlogInsert]
	@BlogDescription NVARCHAR(MAX),
	@UserName NVARCHAR(50)
AS
BEGIN
	INSERT INTO dbo.Blogs
	(
	    BlogDescription,
	    UserName
	)
	VALUES
	(   @BlogDescription,
	    @UserName
	)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BlogUpdate]    Script Date: 15.01.2021 00:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BlogUpdate]
	@Id INT,
	@BlogDescription NVARCHAR(MAX)
AS
BEGIN
	UPDATE dbo.Blogs SET
	    BlogDescription = @BlogDescription,
		UpdateDate = GETDATE()
	WHERE Id = @Id
END
GO
USE [master]
GO
ALTER DATABASE [Deneme] SET  READ_WRITE 
GO
