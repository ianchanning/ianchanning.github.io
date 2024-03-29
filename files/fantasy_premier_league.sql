IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'fantasy_premier_league')
	DROP DATABASE [fantasy_premier_league]
GO

CREATE DATABASE [fantasy_premier_league]  ON (NAME = N'fantasy_premier_league_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\fantasy_premier_league_Data.MDF' , SIZE = 3, FILEGROWTH = 10%) LOG ON (NAME = N'fantasy_premier_league_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\fantasy_premier_league_Log.LDF' , SIZE = 3, FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'fantasy_premier_league', N'autoclose', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'bulkcopy', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'trunc. log', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'torn page detection', N'true'
GO

exec sp_dboption N'fantasy_premier_league', N'read only', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'dbo use', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'single', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'autoshrink', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'ANSI null default', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'recursive triggers', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'ANSI nulls', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'concat null yields null', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'cursor close on commit', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'default to local cursor', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'quoted identifier', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'ANSI warnings', N'false'
GO

exec sp_dboption N'fantasy_premier_league', N'auto create statistics', N'true'
GO

exec sp_dboption N'fantasy_premier_league', N'auto update statistics', N'true'
GO

use [fantasy_premier_league]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_action_score_tbl_action]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_action_score] DROP CONSTRAINT FK_tbl_action_score_tbl_action
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_fixture_tbl_gameweek]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_fixture] DROP CONSTRAINT FK_tbl_fixture_tbl_gameweek
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_phase_tbl_gameweek]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_phase] DROP CONSTRAINT FK_tbl_phase_tbl_gameweek
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_phase_tbl_gameweek1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_phase] DROP CONSTRAINT FK_tbl_phase_tbl_gameweek1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_player_price_tbl_gameweek]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_player_price] DROP CONSTRAINT FK_tbl_player_price_tbl_gameweek
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_player_injury_tbl_injury]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_player_injury] DROP CONSTRAINT FK_tbl_player_injury_tbl_injury
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_action_score_tbl_position]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_action_score] DROP CONSTRAINT FK_tbl_action_score_tbl_position
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_player_tbl_position]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_player] DROP CONSTRAINT FK_tbl_player_tbl_position
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_fixture_tbl_team]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_fixture] DROP CONSTRAINT FK_tbl_fixture_tbl_team
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_fixture_tbl_team1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_fixture] DROP CONSTRAINT FK_tbl_fixture_tbl_team1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_player_tbl_team]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_player] DROP CONSTRAINT FK_tbl_player_tbl_team
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_match_tbl_fixture]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_match] DROP CONSTRAINT FK_tbl_match_tbl_fixture
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_match_detail_tbl_player]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_match_detail] DROP CONSTRAINT FK_tbl_match_detail_tbl_player
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_player_injury_tbl_player]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_player_injury] DROP CONSTRAINT FK_tbl_player_injury_tbl_player
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_player_price_tbl_player]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_player_price] DROP CONSTRAINT FK_tbl_player_price_tbl_player
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_selected_player_tbl_player]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_selected_player] DROP CONSTRAINT FK_tbl_selected_player_tbl_player
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_tbl_match_detail_tbl_match]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_match_detail] DROP CONSTRAINT FK_tbl_match_detail_tbl_match
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnc_calc_total]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnc_calc_total]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spr_insert_match_detail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spr_insert_match_detail]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spr_insert_match]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spr_insert_match]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spr_insert_selected_player]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spr_insert_selected_player]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_match_detail]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_match_detail]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_match]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_match]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_player_injury]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_player_injury]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_player_price]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_player_price]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_selected_player]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_selected_player]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_action_score]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_action_score]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_fixture]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_fixture]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_phase]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_phase]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_player]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_player]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[csv_fixture]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[csv_fixture]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[csv_match]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[csv_match]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[csv_match_detail]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[csv_match_detail]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[csv_player]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[csv_player]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[csv_selected_player]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[csv_selected_player]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[gw25]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[gw25]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[phase]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[phase]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[select_tbl_score]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[select_tbl_score]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_action]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_action]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_gameweek]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_gameweek]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_injury]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_injury]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_position]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_position]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_team]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_team]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[xls_team]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[xls_team]
GO

if not exists (select * from master.dbo.syslogins where loginname = N'ANNEMIE\Ann  Van Steen')
	exec sp_grantlogin N'ANNEMIE\Ann  Van Steen'
	exec sp_defaultdb N'ANNEMIE\Ann  Van Steen', N'master'
	exec sp_defaultlanguage N'ANNEMIE\Ann  Van Steen', N'us_english'
GO

if not exists (select * from master.dbo.syslogins where loginname = N'ANNEMIE\ian')
	exec sp_grantlogin N'ANNEMIE\ian'
	exec sp_defaultdb N'ANNEMIE\ian', N'master'
	exec sp_defaultlanguage N'ANNEMIE\ian', N'us_english'
GO

if not exists (select * from master.dbo.syslogins where loginname = N'ANNEMIE\maria')
	exec sp_grantlogin N'ANNEMIE\maria'
	exec sp_defaultdb N'ANNEMIE\maria', N'master'
	exec sp_defaultlanguage N'ANNEMIE\maria', N'us_english'
GO

exec sp_addsrvrolemember N'ANNEMIE\ian', sysadmin
GO

if not exists (select * from dbo.sysusers where name = N'ANNEMIE\Ann  Van Steen' and uid < 16382)
	EXEC sp_grantdbaccess N'ANNEMIE\Ann  Van Steen', N'ANNEMIE\Ann  Van Steen'
GO

if not exists (select * from dbo.sysusers where name = N'ANNEMIE\maria' and uid < 16382)
	EXEC sp_grantdbaccess N'ANNEMIE\maria', N'ANNEMIE\maria'
GO

if not exists (select * from dbo.sysusers where name = N'fpl_user' and uid > 16399)
	EXEC sp_addrole N'fpl_user'
GO

if not exists (select * from dbo.sysusers where name = N'fpl_support' and uid > 16399)
	EXEC sp_addrole N'fpl_support'
GO

exec sp_addrolemember N'fpl_support', N'ANNEMIE\Ann  Van Steen'
GO

exec sp_addrolemember N'fpl_user', N'ANNEMIE\maria'
GO

CREATE TABLE [dbo].[csv_fixture] (
	[Home Team] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Away Team] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fixture Date] [smalldatetime] NULL ,
	[Gameweek] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[csv_match] (
	[Fixture Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Home Score] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Away Score] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[csv_match_detail] (
	[match_detail_id] [int] IDENTITY (1, 1) NOT NULL ,
	[Col001] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col002] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col003] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col004] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col005] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col006] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col007] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col008] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col009] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col010] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col011] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col012] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[csv_player] (
	[ID] [int] NOT NULL ,
	[Position] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Player] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Team] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Points] [int] NULL ,
	[Cost] [float] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[csv_selected_player] (
	[Col001] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Player] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Captain] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Team] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Points] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Gameweek] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cost now] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cost paid] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cost at last deadline] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Next opponent] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Home Away] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[gw25] (
	[Col001] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col002] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col003] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col004] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col005] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col006] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col007] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col008] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col009] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col010] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col011] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col012] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[phase] (
	[Col001] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col002] [int] NULL ,
	[Col003] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[select_tbl_score] (
	[action_type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[position_type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[score_value] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_action] (
	[action_key] [int] IDENTITY (1, 1) NOT NULL ,
	[action_type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_gameweek] (
	[gameweek_key] [int] IDENTITY (1, 1) NOT NULL ,
	[gameweek_num] [int] NOT NULL ,
	[gameweek_start_date] [smalldatetime] NULL ,
	[gameweek_end_date] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_injury] (
	[injury_key] [int] IDENTITY (1, 1) NOT NULL ,
	[injury_type] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_position] (
	[position_key] [int] IDENTITY (1, 1) NOT NULL ,
	[position_type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[position_code] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_team] (
	[team_key] [int] IDENTITY (1, 1) NOT NULL ,
	[team_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[team_ground_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[team_code] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[team_manager_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[team_chairman_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[fpl_team_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[xls_team] (
	[Team] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F6] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F7] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F8] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F9] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F10] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F11] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F12] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F13] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F14] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F15] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F16] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F17] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F18] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F19] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F20] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[F21] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_action_score] (
	[score_key] [int] IDENTITY (1, 1) NOT NULL ,
	[action_key] [int] NULL ,
	[position_key] [int] NULL ,
	[score_value] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_fixture] (
	[fixture_key] [int] IDENTITY (1, 1) NOT NULL ,
	[team_home_key] [int] NOT NULL ,
	[team_away_key] [int] NOT NULL ,
	[fixture_date] [smalldatetime] NOT NULL ,
	[gameweek_key] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_phase] (
	[phase_key] [int] IDENTITY (1, 1) NOT NULL ,
	[phase_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[phase_first_gameweek_key] [int] NULL ,
	[phase_last_gameweek_key] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_player] (
	[player_key] [int] IDENTITY (1, 1) NOT NULL ,
	[player_first_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[player_last_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[position_key] [int] NOT NULL ,
	[injury_key] [int] NULL ,
	[team_key] [int] NOT NULL ,
	[points_last_season_value] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_match] (
	[match_key] [int] IDENTITY (1, 1) NOT NULL ,
	[fixture_key] [int] NULL ,
	[team_home_score] [int] NULL ,
	[team_away_score] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_player_injury] (
	[player_injury_key] [int] IDENTITY (1, 1) NOT NULL ,
	[player_key] [int] NULL ,
	[injury_key] [int] NULL ,
	[injury_description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[return_date] [smalldatetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_player_price] (
	[player_price_key] [int] IDENTITY (1, 1) NOT NULL ,
	[player_key] [int] NULL ,
	[gameweek_key] [int] NOT NULL ,
	[price_value] [money] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_selected_player] (
	[squad_key] [int] IDENTITY (1, 1) NOT NULL ,
	[player_key] [int] NULL ,
	[substitute_flag] [bit] NOT NULL ,
	[captain_flag] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_match_detail] (
	[match_detail_key] [int] IDENTITY (1, 1) NOT NULL ,
	[match_key] [int] NULL ,
	[player_key] [int] NULL ,
	[player_minute_count] [int] NULL ,
	[player_goal_score_count] [int] NULL ,
	[player_assist_count] [int] NULL ,
	[player_goal_concede_count] [int] NULL ,
	[player_penalty_save_count] [int] NULL ,
	[player_penalty_miss_count] [int] NULL ,
	[player_yellow_card_count] [int] NULL ,
	[player_red_card_count] [int] NULL ,
	[player_save_count] [int] NULL ,
	[player_bonus_count] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[csv_match_detail] WITH NOCHECK ADD 
	CONSTRAINT [PK_csv_match_detail] PRIMARY KEY  CLUSTERED 
	(
		[match_detail_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_action] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_action] PRIMARY KEY  CLUSTERED 
	(
		[action_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_gameweek] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_gameweek] PRIMARY KEY  CLUSTERED 
	(
		[gameweek_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_injury] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_injury] PRIMARY KEY  CLUSTERED 
	(
		[injury_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_position] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_position] PRIMARY KEY  CLUSTERED 
	(
		[position_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_team] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_team] PRIMARY KEY  CLUSTERED 
	(
		[team_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_action_score] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_score] PRIMARY KEY  CLUSTERED 
	(
		[score_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_fixture] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_fixture] PRIMARY KEY  CLUSTERED 
	(
		[fixture_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_phase] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_phase] PRIMARY KEY  CLUSTERED 
	(
		[phase_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_player] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_player] PRIMARY KEY  CLUSTERED 
	(
		[player_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_match] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_match] PRIMARY KEY  CLUSTERED 
	(
		[match_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_player_injury] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_player_injury] PRIMARY KEY  CLUSTERED 
	(
		[player_injury_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_player_price] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_player_price] PRIMARY KEY  CLUSTERED 
	(
		[player_price_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_selected_player] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_squad] PRIMARY KEY  CLUSTERED 
	(
		[squad_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_match_detail] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_match_detail] PRIMARY KEY  CLUSTERED 
	(
		[match_detail_key]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_action_score] ADD 
	CONSTRAINT [FK_tbl_action_score_tbl_action] FOREIGN KEY 
	(
		[action_key]
	) REFERENCES [dbo].[tbl_action] (
		[action_key]
	),
	CONSTRAINT [FK_tbl_action_score_tbl_position] FOREIGN KEY 
	(
		[position_key]
	) REFERENCES [dbo].[tbl_position] (
		[position_key]
	)
GO

ALTER TABLE [dbo].[tbl_fixture] ADD 
	CONSTRAINT [FK_tbl_fixture_tbl_gameweek] FOREIGN KEY 
	(
		[gameweek_key]
	) REFERENCES [dbo].[tbl_gameweek] (
		[gameweek_key]
	),
	CONSTRAINT [FK_tbl_fixture_tbl_team] FOREIGN KEY 
	(
		[team_home_key]
	) REFERENCES [dbo].[tbl_team] (
		[team_key]
	),
	CONSTRAINT [FK_tbl_fixture_tbl_team1] FOREIGN KEY 
	(
		[team_away_key]
	) REFERENCES [dbo].[tbl_team] (
		[team_key]
	)
GO

ALTER TABLE [dbo].[tbl_phase] ADD 
	CONSTRAINT [FK_tbl_phase_tbl_gameweek] FOREIGN KEY 
	(
		[phase_first_gameweek_key]
	) REFERENCES [dbo].[tbl_gameweek] (
		[gameweek_key]
	),
	CONSTRAINT [FK_tbl_phase_tbl_gameweek1] FOREIGN KEY 
	(
		[phase_last_gameweek_key]
	) REFERENCES [dbo].[tbl_gameweek] (
		[gameweek_key]
	)
GO

ALTER TABLE [dbo].[tbl_player] ADD 
	CONSTRAINT [FK_tbl_player_tbl_position] FOREIGN KEY 
	(
		[position_key]
	) REFERENCES [dbo].[tbl_position] (
		[position_key]
	),
	CONSTRAINT [FK_tbl_player_tbl_team] FOREIGN KEY 
	(
		[team_key]
	) REFERENCES [dbo].[tbl_team] (
		[team_key]
	)
GO

ALTER TABLE [dbo].[tbl_match] ADD 
	CONSTRAINT [FK_tbl_match_tbl_fixture] FOREIGN KEY 
	(
		[fixture_key]
	) REFERENCES [dbo].[tbl_fixture] (
		[fixture_key]
	)
GO

ALTER TABLE [dbo].[tbl_player_injury] ADD 
	CONSTRAINT [FK_tbl_player_injury_tbl_injury] FOREIGN KEY 
	(
		[injury_key]
	) REFERENCES [dbo].[tbl_injury] (
		[injury_key]
	),
	CONSTRAINT [FK_tbl_player_injury_tbl_player] FOREIGN KEY 
	(
		[player_key]
	) REFERENCES [dbo].[tbl_player] (
		[player_key]
	)
GO

ALTER TABLE [dbo].[tbl_player_price] ADD 
	CONSTRAINT [FK_tbl_player_price_tbl_gameweek] FOREIGN KEY 
	(
		[gameweek_key]
	) REFERENCES [dbo].[tbl_gameweek] (
		[gameweek_key]
	),
	CONSTRAINT [FK_tbl_player_price_tbl_player] FOREIGN KEY 
	(
		[player_key]
	) REFERENCES [dbo].[tbl_player] (
		[player_key]
	)
GO

ALTER TABLE [dbo].[tbl_selected_player] ADD 
	CONSTRAINT [FK_tbl_selected_player_tbl_player] FOREIGN KEY 
	(
		[player_key]
	) REFERENCES [dbo].[tbl_player] (
		[player_key]
	)
GO

ALTER TABLE [dbo].[tbl_match_detail] ADD 
	CONSTRAINT [FK_tbl_match_detail_tbl_match] FOREIGN KEY 
	(
		[match_key]
	) REFERENCES [dbo].[tbl_match] (
		[match_key]
	),
	CONSTRAINT [FK_tbl_match_detail_tbl_player] FOREIGN KEY 
	(
		[player_key]
	) REFERENCES [dbo].[tbl_player] (
		[player_key]
	)
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE [dbo].[spr_insert_match] 

AS

INSERT INTO [dbo].[tbl_match] (fixture_key, team_home_score, team_away_score)
SELECT 	  [cm].[Fixture Key] AS [fixture_key]
	, [cm].[Home Score] AS [team_home_score]
	, [cm].[Away Score] AS [team_away_score]
FROM 	[dbo].[csv_match] [cm]
WHERE 	[cm].[Fixture Key] > 
	(
		SELECT MAX(fixture_key) 
		FROM [dbo].[tbl_match]
	)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
CREATE PROCEDURE dbo.spr_insert_selected_player 
AS
	INSERT INTO dbo.tbl_selected_player
	SELECT p.player_key, 
	CASE 
		WHEN SP.Col001 > 11 THEN 1
		ELSE 0
	END,
	CASE
		WHEN SP.Captain = 1 THEN 1
		ELSE 0
	END
	FROM dbo.tbl_player [P],
		dbo.csv_selected_player [SP]
	WHERE P.player_last_name = SP.Player

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE [dbo].[spr_insert_match_detail]

AS
INSERT INTO tbl_match_detail (match_key
			,player_key
			,player_minute_count
			,player_goal_score_count
			,player_assist_count
			,player_goal_concede_count
			,player_penalty_save_count
			,player_penalty_mISs_count
			,player_yellow_card_count
			,player_red_card_count
			,player_save_count
			,player_bonus_count)
SELECT [m].[match_key]
	,[p].[player_key]
	,[cmd1].[Col002]
	,[cmd1].[Col003]
	,[cmd1].[Col004]
	,[cmd1].[Col005]
	,[cmd1].[Col006]
	,[cmd1].[Col007]
	,[cmd1].[Col008]
	,[cmd1].[Col009]
	,[cmd1].[Col010]
	,[cmd1].[Col011]
 
FROM [dbo].[tbl_match] [m]
	,[dbo].[tbl_fixture] [f]
	,[dbo].[tbl_player] [p]
	,[dbo].[csv_match_detail] [cmd1]
	,[dbo].[csv_match_detail] [cmd2]
	,[dbo].[csv_match_detail] [cmd3]
WHERE [m].[fixture_key] = [f].[fixture_key]
	AND [f].[team_home_key] = (SELECT [team_key] FROM [tbl_team] WHERE [fpl_team_name] = SUBSTRING([cmd3].[Col001],0,charindex('-',[cmd3].[Col001])-3))--cmd].[home team
	AND [f].[team_away_key] = (SELECT [team_key] FROM [tbl_team] WHERE [fpl_team_name] = SUBSTRING([cmd3].[Col001],charindex('-',[cmd3].[Col001])+4,charindex(':',[cmd3].[Col001])-(1 + charindex('-',[cmd3].[Col001])+4)))--cmd].[away team
	AND [p].[player_last_name] = [cmd1].[Col001]
	AND [p].[team_key] = (SELECT [team_key] FROM [tbl_team] WHERE [fpl_team_name] = [cmd2].[Col001])

	AND LEN([cmd2].[Col002]) < 1 -- Minor fix as Tab delimited input has non null columns after team name
	AND [cmd2].[Col001] IS NOT NULL
	AND [cmd2].[match_detail_id] < [cmd1].[match_detail_id]
	AND [cmd2].[match_detail_id] > [cmd1].[match_detail_id] - 15
	AND NOT charindex('-', [cmd2].[Col001]) > 0
	
	AND [cmd3].[Col002] IS NULL
	AND [cmd3].[Col001] IS NOT NULL
	AND [cmd3].[match_detail_id] < [cmd1].[match_detail_id]
	AND [cmd3].[match_detail_id] > [cmd1].[match_detail_id] - 35
	AND charindex('-', [cmd3].[Col001]) > 0
	
	AND [cmd1].[Col002] IS NOT NULL
	AND [cmd1].[Col001] IS NOT NULL
	
ORDER BY [m].[match_key]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE  FUNCTION dbo.fnc_calc_total 
	(@position_key int,
	@minutes int, 
	@goals_scored int,
	@assists int,
	@goals_conceded int,
	@penalties_saved int,
	@penalties_missed int,
	@yellow_cards int,
	@red_cards int,
	@saves int,
	@bonus int)
RETURNS int
AS
BEGIN
	DECLARE @total int

	/* -- Debug Parameters
	SELECT @position_key = 3,
	@minutes = 90, 
	@goals_scored = 0,
	@assists = 0,
	@goals_conceded = 2,
	@penalties_saved = 0,
	@penalties_missed = 0,
	@yellow_cards = 0,
	@red_cards = 0,
	@saves = 0,
	@bonus = 0
	*/


	DECLARE @score_table TABLE
	(
		action_type nvarchar(200),
		score_value int
	)
	
	INSERT INTO @score_table
	SELECT a.action_type, [as].score_value
	FROM tbl_action a,
		tbl_action_score [as]
	WHERE [as].position_key = @position_key
		AND a.action_key = [as].action_key

 
	--For playing in a game
	SELECT 	@total = score_value from @score_table where action_type = 'playing'
	--For playing at least 60 minutes in a game (includes playing points mentioned above)
	SET 	@total = @total + (@minutes / 60)  * (select score_value from @score_table where action_type = 'playing bonus')
	--For each goal scored
	SET 	@total = @total + @goals_scored * (select score_value from @score_table where action_type = 'goal')
	--For each goal assist
	SET 	@total = @total + @assists * (select score_value from @score_table where action_type = 'assist')
	--For conceding 0 goals (must also play at least 60 minutes)
	IF( @goals_conceded = 0  AND @minutes >= 60 )
	BEGIN

	SET 	@total = @total + (select score_value from @score_table where action_type = 'clean sheet')

	END
	--For every 2 goals conceded
	ELSE
	BEGIN

	SET 	@total = @total + (@goals_conceded / 2) * (select score_value from @score_table where action_type = 'goal conceded')

	END
	--For every 3 shot saves
	SET 	@total = @total + (@saves / 3) * (select score_value from @score_table where action_type = 'save')
	--For every penalty save
	SET 	@total = @total + @penalties_saved * (select score_value from @score_table where action_type = 'penalty save')
	--For every penalty miss
	SET 	@total = @total + @penalties_missed * (select score_value from @score_table where action_type = 'penalty miss')
	--Bonus points for the best players in a match
	SET 	@total = @total + @bonus * (select score_value from @score_table where action_type = 'bonus')
	--For every yellow card
	SET 	@total = @total + @yellow_cards * (select score_value from @score_table where action_type = 'yellow card')
	--For every red card (includes any yellow card points)
	IF ( @red_cards > 0 )
	SET 	@total = @total + @red_cards * (select score_value from @score_table where action_type = 'red card') - @yellow_cards * (select score_value from @score_table where action_type = 'yellow card')

	RETURN @total
--	eg.
--	DECLARE @sum AS int
--	SELECT @sum = @p1 + @P2
--	RETURN @sum
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

