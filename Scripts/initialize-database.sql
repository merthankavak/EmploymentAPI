-- IMPORTANT: Make sure to adjust the following information according to your setup.
-- This script assumes you're using Windows Authentication and Azure Data Studio.

-- To create the EmploymentDB database with Windows Authentication, 
-- connect to your SQL Server instance using Azure Data Studio.

-- 1. Open Azure Data Studio.
-- 2. Connect to your SQL Server instance using Windows Authentication.
-- 3. Open a new query window and execute this script.

-- This script creates the EmploymentDB database and related objects.
-- The paths for data and log files should be adjusted based on your system.

USE [master]
GO
/****** Object:  Database [EmploymentDB]    Script Date: 20.08.2023 18:38:28 ******/
CREATE DATABASE [EmploymentDB]
 CONTAINMENT = NONE
 ON  PRIMARY 

-- NOTE: Please make sure to adjust the FILENAME paths below to match your environment.
-- If the paths are incorrect, replace them with the appropriate paths.

( NAME = N'EmploymentDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EmploymentDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'EmploymentDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EmploymentDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [EmploymentDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EmploymentDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EmploymentDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EmploymentDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EmploymentDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EmploymentDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EmploymentDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [EmploymentDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [EmploymentDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EmploymentDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EmploymentDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EmploymentDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [EmploymentDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EmploymentDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EmploymentDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EmploymentDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EmploymentDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [EmploymentDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EmploymentDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EmploymentDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EmploymentDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [EmploymentDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EmploymentDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [EmploymentDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EmploymentDB] SET RECOVERY FULL 
GO
ALTER DATABASE [EmploymentDB] SET  MULTI_USER 
GO
ALTER DATABASE [EmploymentDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [EmploymentDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EmploymentDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [EmploymentDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [EmploymentDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [EmploymentDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'EmploymentDB', N'ON'
GO
ALTER DATABASE [EmploymentDB] SET QUERY_STORE = OFF
GO
USE [EmploymentDB]
GO
/****** Object:  Schema [EmploymentSchema]    Script Date: 20.08.2023 18:38:28 ******/
CREATE SCHEMA [EmploymentSchema]
GO
/****** Object:  Table [EmploymentSchema].[Auth]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EmploymentSchema].[Auth](
	[Email] [nvarchar](50) NOT NULL,
	[PasswordHash] [varbinary](max) NOT NULL,
	[PasswordSalt] [varbinary](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EmploymentSchema].[Posts]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EmploymentSchema].[Posts](
	[PostId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PostTitle] [nvarchar](255) NOT NULL,
	[PostContent] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EmploymentSchema].[UserJobInfo]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EmploymentSchema].[UserJobInfo](
	[UserId] [int] NULL,
	[JobTitle] [nvarchar](50) NULL,
	[Department] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [EmploymentSchema].[Users]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EmploymentSchema].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Gender] [nvarchar](50) NULL,
	[Active] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [EmploymentSchema].[UserSalary]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EmploymentSchema].[UserSalary](
	[UserId] [int] NULL,
	[Salary] [decimal](18, 4) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spLoginConfirmation_Get]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [EmploymentSchema].[spLoginConfirmation_Get]
    /* TutorialAppSchema.spLoginConfirmation_Get @Email = test@test.com */
    @Email NVARCHAR(50)
AS
BEGIN
    SELECT [Auth].[PasswordHash],
        [Auth].[PasswordSalt]
    FROM EmploymentSchema.Auth AS Auth
    WHERE Auth.Email = @Email
END
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spPost_Delete]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [EmploymentSchema].[spPost_Delete]
    @PostId INT,
    @UserId INT
AS
BEGIN
    DELETE FROM EmploymentSchema.Posts 
    WHERE PostId = @PostId
        AND UserId = @UserId
END
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spPost_Upsert]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [EmploymentSchema].[spPost_Upsert]
    @UserId INT,
    @PostTitle NVARCHAR(255),
    @PostContent NVARCHAR(MAX),
    @PostId INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT *
    FROM EmploymentSchema.Posts
    WHERE PostId = @PostId)
        BEGIN
        INSERT INTO EmploymentSchema.Posts
            (
            [UserId],
            [PostTitle],
            [PostContent],
            [CreatedAt],
            [UpdatedAt]
            )
        VALUES
            (
                @UserId,
                @PostTitle,
                @PostContent,
                GETDATE(),
                GETDATE()
            )
    END
    ELSE
        BEGIN
        UPDATE EmploymentSchema.Posts 
            SET PostTitle = @PostTitle,
                PostContent = @PostContent,
                UpdatedAt = GETDATE()
            WHERE PostId = @PostId
    END

END
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spPosts_Get]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [EmploymentSchema].[spPosts_Get]

    @UserId INT = NULL,
    @SearchParam NVARCHAR(MAX) = NULL,
    @PostId INT = NULL
AS
BEGIN
    SELECT [Posts].[PostId],
        [Posts].[UserId],
        [Posts].[PostTitle],
        [Posts].[PostContent],
        [Posts].[CreatedAt],
        [Posts].[UpdatedAt]

    FROM EmploymentSchema.Posts AS Posts
    WHERE Posts.UserId = ISNULL(@UserId,UserId)
        AND
        Posts.PostId = ISNULL(@PostId, PostId)
        AND
        (@SearchParam IS NULL
        OR Posts.PostTitle LIKE '%' + @SearchParam + '%'
        OR Posts.PostContent LIKE '%' + @SearchParam + '%')

END
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spPosts_Upsert]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [EmploymentSchema].[spPosts_Upsert]
    @UserId INT,
    @PostTitle NVARCHAR(255),
    @PostContent NVARCHAR(MAX),
    @PostId INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT *
    FROM EmploymentSchema.Posts
    WHERE @PostId = @PostId)
        BEGIN
        INSERT INTO EmploymentSchema.Posts
            (
            [UserId],
            [PostTitle],
            [PostContent],
            [CreatedAt],
            [UpdatedAt]
            )
        VALUES
            (
                @UserId,
                @PostTitle,
                @PostContent,
                GETDATE(),
                GETDATE()
            )
    END
    ELSE
        BEGIN
        UPDATE EmploymentSchema.Posts 
            SET PostTitle = @PostTitle,
                PostContent = @PostContent,
                UpdatedAt = GETDATE()
            WHERE PostId = @PostId
    END

END
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spRegister_Upsert]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [EmploymentSchema].[spRegister_Upsert]
    @Email NVARCHAR(50),
    @PasswordHash VARBINARY(MAX),
    @PasswordSalt VARBINARY(MAX)
AS
BEGIN
    IF NOT EXISTS (SELECT *
    FROM EmploymentSchema.Auth
    WHERE Email = @Email)
        BEGIN
        INSERT INTO EmploymentSchema.Auth
            (
            [Email],
            [PasswordHash],
            [PasswordSalt]
            )
        VALUES
            (
                @Email,
                @PasswordHash,
                @PasswordSalt
            )
    END
    ELSE
        BEGIN
        UPDATE EmploymentSchema.Auth 
            SET @PasswordHash = @PasswordHash,
                @PasswordSalt = @PasswordSalt
            WHERE Email = @Email
    END
END

GO
/****** Object:  StoredProcedure [EmploymentSchema].[spUser_Delete]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [EmploymentSchema].[spUser_Delete]
    @UserId INT
AS
BEGIN
    DELETE FROM EmploymentSchema.Users WHERE UserId = @UserId

    DELETE FROM EmploymentSchema.UserSalary WHERE UserId = @UserId

    DELETE FROM EmploymentSchema.UserJobInfo WHERE UserId = @UserId
END
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spUser_Upsert]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [EmploymentSchema].[spUser_Upsert]
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@Email NVARCHAR(50),
	@Gender NVARCHAR(50),
	@JobTitle NVARCHAR(50),
	@Department NVARCHAR(50),
    @Salary DECIMAL(18, 4),
	@Active BIT = 1,
	@UserId INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM EmploymentSchema.Users WHERE UserId = @UserId)
        BEGIN
        IF NOT EXISTS (SELECT * FROM EmploymentSchema.Users WHERE Email = @Email)
            BEGIN
                DECLARE @OutputUserId INT

                INSERT INTO EmploymentSchema.Users(
                    [FirstName],
                    [LastName],
                    [Email],
                    [Gender],
                    [Active]
                ) VALUES (
                    @FirstName,
                    @LastName,
                    @Email,
                    @Gender,
                    @Active
                )

                SET @OutputUserId = @@IDENTITY

                INSERT INTO EmploymentSchema.UserSalary(
                    UserId,
                    Salary
                ) VALUES (
                    @OutputUserId,
                    @Salary
                )

                INSERT INTO EmploymentSchema.UserJobInfo(
                    UserId,
                    Department,
                    JobTitle
                ) VALUES (
                    @OutputUserId,
                    @Department,
                    @JobTitle
                )
            END
        END
    ELSE 
        BEGIN
            UPDATE EmploymentSchema.Users 
                SET FirstName = @FirstName,
                    LastName = @LastName,
                    Email = @Email,
                    Gender = @Gender,
                    Active = @Active
                WHERE UserId = @UserId

            UPDATE EmploymentSchema.UserSalary
                SET Salary = @Salary
                WHERE UserId = @UserId

            UPDATE EmploymentSchema.UserJobInfo
                SET Department = @Department,
                    JobTitle = @JobTitle
                WHERE UserId = @UserId
        END
END
GO
/****** Object:  StoredProcedure [EmploymentSchema].[spUsers_Get]    Script Date: 20.08.2023 18:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [EmploymentSchema].[spUsers_Get]
    @UserId INT = NULL,
    @Active BIT = NULL

AS
BEGIN
    IF OBJECT_ID('tempdb..#AverageDeptSalary', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #AverageDeptSalary
    END

    SELECT UserJobInfo.Department, AVG(UserSalary.Salary) AvgSalary
    INTO #AverageDeptSalary
    FROM EmploymentSchema.Users AS Users
        LEFT JOIN EmploymentSchema.UserSalary AS UserSalary
        ON UserSalary.UserId = Users.UserId
        LEFT JOIN EmploymentSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
    GROUP BY UserJobInfo.Department

    CREATE CLUSTERED INDEX cix_AverageDeptSalary_Department ON #AverageDeptSalary(Department)

    SELECT [Users].[UserId],
        [Users].[FirstName],
        [Users].[LastName],
        [Users].[Email],
        [Users].[Gender],
        [Users].[Active],
        [UserSalary].[Salary],
        [UserJobInfo].JobTitle,
        UserJobInfo.Department,
        AvgSalary.AvgSalary

    FROM EmploymentSchema.Users AS Users
        LEFT JOIN EmploymentSchema.UserSalary AS UserSalary
        ON UserSalary.UserId = Users.UserId
        LEFT JOIN EmploymentSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
        LEFT JOIN #AverageDeptSalary AS AvgSalary
        ON AvgSalary.Department = UserJobInfo.Department

    WHERE Users.UserId = ISNULL(@UserId,Users.UserId)
        AND ISNULL(Users.Active,0)  = ISNULL(@Active,ISNULL(Users.Active,0))
END
GO
USE [master]
GO
ALTER DATABASE [EmploymentDB] SET  READ_WRITE 
GO
