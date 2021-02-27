/****** Object:  Database UNKNOWN    Script Date: 11/13/2020 4:53:40 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE UNKNOWN
GO
CREATE DATABASE UNKNOWN
GO
ALTER DATABASE UNKNOWN
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_cb2_dw
;

/* Drop table revenueanalysis.FactRevenue */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'revenueanalysis.FactRevenue') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE revenueanalysis.FactRevenue 
;


/* Drop table revenueanalysis.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'revenueanalysis.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE revenueanalysis.DimCustomer 
;

/* Create table revenueanalysis.DimCustomer */
CREATE TABLE revenueanalysis.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerName]  nvarchar(100)   NOT NULL
,  [CustomerAddress]  varchar(100)   NOT NULL
,  [CustomerCity]  varchar(50)   NOT NULL
,  [CustomerState]  char(2)   NOT NULL
,  [CustomerZip]  varchar(20)   NOT NULL
,  [CustomerEmail]  varchar(200)  DEFAULT 'N/A' NOT NULL
,  [SourceType]  nvarchar(30)  DEFAULT 'None' NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_revenueanalysis.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT revenueanalysis.DimCustomer ON
;
INSERT INTO revenueanalysis.DimCustomer (CustomerKey, CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerZip, CustomerEmail, SourceType, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1 , 'No Customer', 'None', 'None', 'NA', 'None', 'None', '', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT revenueanalysis.DimCustomer OFF
;


/* Drop table revenueanalysis.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'revenueanalysis.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE revenueanalysis.DimDate 
;

/* Create table revenueanalysis.DimDate */
CREATE TABLE revenueanalysis.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_revenueanalysis.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


INSERT INTO revenueanalysis.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;


/* Drop table revenueanalysis.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'revenueanalysis.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE revenueanalysis.DimProduct 
;

/* Create table revenueanalysis.DimProduct */
CREATE TABLE revenueanalysis.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  varchar(50)   NOT NULL
,  [IsActive]  bit  DEFAULT 1 NOT NULL
,  [SourceType]  varchar(30)  DEFAULT 'None' NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_revenueanalysis.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT revenueanalysis.DimProduct ON
;
INSERT INTO revenueanalysis.DimProduct (ProductKey, ProductID, ProductName, IsActive, SourceType, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 1, '', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT revenueanalysis.DimProduct OFF
;


/* Create table revenueanalysis.FactRevenue */
CREATE TABLE revenueanalysis.FactRevenue (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [Quantity]  int   NOT NULL
,  [TotalPriceAmount]  money   NOT NULL
,  [UnitPrice]  money   NOT NULL
,  [UnitCost]  money   NOT NULL
,  [TotalCostAmount]  money   NOT NULL
,  [SourceType]  nvarchar   NOT NULL
, CONSTRAINT [PK_revenueanalysis.FactRevenue] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID],[SourceType] )
) ON [PRIMARY]
;


ALTER TABLE revenueanalysis.FactRevenue ADD CONSTRAINT
   FK_revenueanalysis_FactRevenue_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES revenueanalysis.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE revenueanalysis.FactRevenue ADD CONSTRAINT
   FK_revenueanalysis_FactRevenue_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES revenueanalysis.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE revenueanalysis.FactRevenue ADD CONSTRAINT
   FK_revenueanalysis_FactRevenue_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES revenueanalysis.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
