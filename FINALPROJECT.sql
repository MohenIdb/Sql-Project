												---=== Project On ===---
												--- *Blood Bank Management System* ---
												---=== Presented By ===---
												---=== Md. Mohen Uddin ===---
												---=== Id: 1260941 ===---

USE master;
DECLARE @data_path nvarchar(256);
SET @data_path = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
      FROM master.sys.master_files
      WHERE database_id = 1 AND file_id = 1);
EXECUTE ('CREATE DATABASE BloodBankManagement 
ON PRIMARY(NAME = BloodBankManagement_data, FILENAME = ''' + @data_path + 'MyInventoryMgt_data.mdf'', SIZE = 16MB, MAXSIZE = Unlimited, FILEGROWTH = 2MB)
LOG ON (NAME = BloodBankManagement_log, FILENAME = ''' + @data_path + 'MyInventoryMgt_log.ldf'', SIZE = 10MB, MAXSIZE = 100MB, FILEGROWTH = 1MB)'
);
GO
---Create Schema---

--Create schema Blood
--Go

Use BloodBankManagement
Create table Patientinfo
(
PatientID int primary key,
PatientName varchar (40)not null,
ContactAddress varchar (100),
PhoneNo varchar (15) unique check (PhoneNo like '01%'),
Bloodgroup varchar (10) 
check (Bloodgroup like 'A(+ve)'  OR Bloodgroup like 'A(-ve)' OR 
		Bloodgroup like 'B(+ve)' OR Bloodgroup like 'B(-ve)' OR 
		Bloodgroup like 'AB(+ve)'OR Bloodgroup like 'AB(-ve)'OR 
		Bloodgroup like 'O(+ve)' OR Bloodgroup like 'O(-ve)') 
)
GO

Create table Donarinfo
(
DonarID int primary key identity,
DonarName varchar (40)not null,
ContactAddress varchar (100),
PhoneNo varchar (15) unique,
BloodGroup varchar (10),
LastDonationDate datetime,
DonarStatus varchar (20)
)
GO

Create Table Bloodbank
(
Bloodgroupid int primary key,
Bloodgroupname varchar (10)
)
GO

Create table Registration
(
Registrationid int identity,
PatientID int foreign key references Patientinfo(PatientID),
DonarID int foreign key references Donarinfo(DonarID),
Bloodgroupid int foreign key references Bloodbank(Bloodgroupid)
)
GO

Create table AuditDonarinfo
(
DonarID int primary key identity,
DonarName varchar (40)not null,
ContactAddress varchar (100),
PhoneNo varchar (15) unique,
BloodGroup varchar (10),
LastDonationDate datetime,
DonarStatus varchar (20),
Auditaction varchar (50),
Auditactiontime datetime
)
GO
				-------Sequence------
Use BloodBankManagement
Create Sequence sq_cust
As Bigint
Start with 1
increment by 1
GO
Insert Into  Patientinfo (PatientID,PatientName,ContactAddress,PhoneNo,Bloodgroup)
						Values(Next value for sq_cust,'Fahad','Chattagram','01822335159','B(+ve)'),
								(Next value for sq_cust,'Iqbal','Dhaka','01114001459','A(+ve)'),
									(Next value for sq_cust,'Iqram','Comilla','01922005333','A(-ve)'),
										(Next value for sq_cust,'Mahadi','Khulna','01722005444','B(-ve)'),
											(Next value for sq_cust,'Sarwar','Syleth','01622005551','O(-ve)'),
												(Next value for sq_cust,'Amdadul','Noakhali','01522005666','AB(+ve)'),
													(Next value for sq_cust,'Rafiq','Barishal','01422005777','O(+ve)'),
														(Next value for sq_cust,'Arosh','Rangpur','01322005888','AB(-ve)')
Go




			----- CRUD OPERATION-----
Insert Into  Donarinfo (DonarName,ContactAddress,PhoneNo,BloodGroup,LastDonationDate,DonarStatus)
				Values('Max','Chattagram','01952335159','B(+ve)',01/01/2021,'unable'),
						('Milton','Dhaka','01165481459','A(+ve)',10/01/2021,'Capable'),
							('Imran','Comilla','01998745333','A(-ve)',09/01/2021,'Capable'),
								('Marup','Khulna','01722154444','B(-ve)',08/01/2021,'Capable'),
									('Sam','Syleth','01636985551','O(-ve)',07/01/2021,'Capable'),
										('Alex','Noakhali','01574125666','AB(+ve)',01/01/2020,'Capable'),
											('Roman','Barishal','01426542777','O(+ve)',01/01/2021,'Unable'),
												('Alan','Rangpur','01354125888','AB(-ve)',01/01/2021,'Unable')
GO

Insert Into Bloodbank (Bloodgroupid,Bloodgroupname) Values (1,'A(+ve)'),(2,'A(-ve)'),(3,'B(+ve)'),(4,'B(-ve)'),
												(5,'AB(+ve)'),(6,'AB(-ve)'),(7,'O(+ve)'),(8,'O(-ve)')
GO

Insert Into Registration (PatientID,DonarID,Bloodgroupid)
						Values (1,1,1),(2,2,2),(3,3,3),(4,4,4),
									(5,5,5),(6,6,6),(7,7,7),(8,8,8)
GO


----Update----

Update Patientinfo Set PatientName='Mohin'
Where PatientID=5
GO

Update Donarinfo Set PhoneNo='01892938278'
Where DonarID=5
GO

------Delete Query-----

Delete From Patientinfo
Where PatientID=7
GO

Delete From Donarinfo
Where DonarID=3
GO

------Select Query-----

Select * From Patientinfo
Select * From Donarinfo
Select * From Bloodbank
Select * From Registration
select * from AuditDonarinfo
--------- join query,group by,having,order by-------

Select Bloodgroupname, count(Registrationid)
From Patientinfo
join Registration
On Patientinfo.PatientID=Registration.PatientID
Join Donarinfo
On Donarinfo.DonarID=Registration.DonarID
Join Bloodbank
On Bloodbank.Bloodgroupid=Registration.Bloodgroupid
Group by Bloodgroupname
Having count (Registrationid)>0
Order BY Bloodgroupname DESC

---Add Column---

Alter Table Donarinfo
Add Age varchar (10)
Go

--Delete Column--

Alter Table Donarinfo
Drop Column Age
Go

----Inner Join---

Select DonarName,PatientName
From Donarinfo
Inner Join Patientinfo
On Patientinfo.PatientID=Donarinfo.DonarID

----Right Join---

Select DonarName,PatientName
From Donarinfo
Right Join Patientinfo
On Patientinfo.PatientID=Donarinfo.DonarID

----Left Join---

Select DonarName,PatientName
From Donarinfo
Left Join Patientinfo
On Patientinfo.PatientID=Donarinfo.DonarID

----Full Join---

Select DonarName,PatientName
From Donarinfo
Full Join Patientinfo
On Patientinfo.PatientID=Donarinfo.DonarID

----Cross Join---

Select DonarName,PatientName
From Donarinfo
Cross Join Patientinfo

----- Self Join-----

Select *
From Patientinfo as a, Patientinfo as b
Where a.PatientID <> b.PatientID
Go

--Union Operator

Select PatientID from Patientinfo
Union
Select DonarID from Donarinfo
Order by PatientID;
Go		
---- case----

Select Bloodgroupid,Bloodgroupname,
	Case Bloodgroupid
		when 1 then 'Available'
		when 2 then 'less Available'
		when 3 then 'Available'
		when 4 then 'less Available'
		when 5 then 'Available'
		when 6 then 'Rare'
		Else 'Expensive'
	end as Avability
from Bloodbank
GO
------ clustered index ------

Create Clustered index cindex
On dbo.Registration (Registrationid)
GO

----- non clustered index -----

Create Nonclustered index ncindex 
On dbo.Bloodbank (Bloodgroupname)
GO

---- cast --------

Select [Today] = cast ('8-feb 2021 10:00AM' as datetime)
GO

---- convert --------

Select [Time] = convert (datetime,'8-feb 2021 10:00AM')
GO

----local Table-----

Create Table #Donor
(
Donorid Int Primary Key Identity,
DonorName varchar (30)
)
GO

----Global Table-----

Create Table ##Patient
(
PatientID Int Primary Key Identity,
PatientName varchar (30)
)
GO
	-----Scalar function ------

Create FUNCTION fn_Ability(@lastdonationdate datetime, @datedifference datetime) 

RETURNS varchar(255)
AS
BEGIN
	SET
		@datedifference=@lastdonationdate-GETDATE();
		IF @datedifference >='2021/10/10'
		RETURN'You are able to donate. '
		ELSE
		RETURN'Sorry! You are not able to donate. '	
	RETURN'Thank You'
END


GO

SELECT dbo.fn_Ability('2019/12/01','2020/02/12')

	---==== create view ----====

Create View vw_myview
As
Select PatientName,DonarName
From Patientinfo
Join Donarinfo
On Patientinfo.PatientID=Donarinfo.DonarID
Where PatientID=DonarID
GO

-----Store Procedure-----

Create Proc sp_myprocx
@patientid int,
@patientname varchar (40),
@contactaddress varchar (100),
@phoneno varchar (15),
@bloodgroup varchar (10),
@tablename varchar (20),
@operationname varchar (20)
As
BEGIN
		If (@tablename='Patientinfo' and @operationname= 'Insert')
			Begin
				Insert Into Patientinfo (PatientID,PatientName,ContactAddress,PhoneNo,Bloodgroup)
					Values (@patientid,@patientname,@contactaddress,@phoneno,@bloodgroup)
			End
		If (@tablename='Patientinfo' and @operationname= 'Update')
			Begin
				update Patientinfo set PatientName=@patientname, ContactAddress=@contactaddress, PhoneNo=@phoneno, Bloodgroup=@bloodgroup
				Where PatientID=@patientid
			End
		If (@tablename='Patientinfo' and @operationname= 'Delete')
			Begin
				Delete from Patientinfo
				Where PatientID=@patientid
			End
END

EXEC sp_myprocx 9,'Maxi','Aus','01815921497','B(+ve)','Patientinfo','Insert'
EXEC sp_myprocx 10,'Yash','Nz','01815924653','A(+ve)','Patientinfo','Insert'

EXEC sp_myprocx 1,'Smith','Aus','01817921497','B(+ve)','Patientinfo','Update'
EXEC sp_myprocx 7,'Willy','Nz','01819924653','A(+ve)','Patientinfo','Update'

EXEC sp_myprocx  7,'Willy','Nz','01819924653','A(+ve)','Patientinfo','Delete'
EXEC sp_myprocx 10,'Yash','Nz','01815924653','A(+ve)','Patientinfo','Delete'

Select * from Patientinfo

----Create Trigger After insert----
Create Trigger trg_mytrigger on dbo.Donarinfo
After Insert
AS 
Declare 
@donarid int,
@donarname varchar(40),
@contactaddress varchar (100),
@phoneno varchar (15),
@bloodgroup varchar (10),
@lastdonationdate datetime,
@donarstatus varchar (20),
@auditaction varchar (50),
@auditactiontime datetime

select @donarid=i.DonarID from inserted i;
select @donarname=i.DonarName from inserted i;
select @contactaddress=i.ContactAddress from inserted i;
select @phoneno=i.PhoneNo from inserted i;
select @bloodgroup=i.BloodGroup from inserted i;
select @lastdonationdate=i.LastDonationDate from inserted i;
select @donarstatus=i.DonarStatus from inserted i;
set @auditaction= 'inserted record------after insert trigger fired!!'
select @auditactiontime= getdate()

insert into AuditDonarinfo(DonarName,ContactAddress,PhoneNo,BloodGroup,LastDonationDate,DonarStatus,Auditaction,Auditactiontime)
				values(@donarname,@contactaddress,@phoneno,@bloodgroup,@lastdonationdate,@donarstatus,@auditaction,getdate());

Print 'after insert trigger fired!!'
GO

Insert Into Donarinfo (DonarName,ContactAddress,PhoneNo,BloodGroup,LastDonationDate,DonarStatus)
				Values('Rock','CTG','01999335159','B(+ve)','01/01/2021','unable')
Select * from Donarinfo
Select * from AuditDonarinfo
----Create Trigger After update----

Create Trigger trg_mytriggerupdate on dbo.Donarinfo
After Update
AS 
Declare 
@donarid int,
@donarname varchar(40),
@contactaddress varchar (100),
@phoneno varchar (15),
@bloodgroup varchar (10),
@lastdonationdate datetime,
@donarstatus varchar (20),
@auditaction varchar (50),
@auditactiontime datetime

select @donarid=i.DonarID from inserted i;
select @donarname=i.DonarName from inserted i;
select @contactaddress=i.ContactAddress from inserted i;
select @phoneno=i.PhoneNo from inserted i;
select @bloodgroup=i.BloodGroup from inserted i;
select @lastdonationdate=i.LastDonationDate from inserted i;
select @donarstatus=i.DonarStatus from inserted i;
set @auditaction= 'Updated record------after update trigger fired!!'
select @auditactiontime= getdate()

insert into AuditDonarinfo(DonarName,ContactAddress,PhoneNo,BloodGroup,LastDonationDate,DonarStatus,Auditaction,Auditactiontime)
				values(@donarname,@contactaddress,@phoneno,@bloodgroup,@lastdonationdate,@donarstatus,@auditaction,getdate());

Print 'after updated trigger fired!!'
GO

Update Donarinfo Set PhoneNo='01892938298'
Where DonarID=5
GO
Select * from Donarinfo
Select * from AuditDonarinfo

----Create Trigger After Delete----
Create Trigger trg_mytriggerdelete on dbo.Donarinfo
After Delete
AS 
Declare 
@donarid int,
@donarname varchar(40),
@contactaddress varchar (100),
@phoneno varchar (15),
@bloodgroup varchar (10),
@lastdonationdate datetime,
@donarstatus varchar (20),
@auditaction varchar (50),
@auditactiontime datetime

select @donarid=i.DonarID from deleted i;
select @donarname=i.DonarName from deleted i;
select @contactaddress=i.ContactAddress from deleted i;
select @phoneno=i.PhoneNo from deleted i;
select @bloodgroup=i.BloodGroup from deleted i;
select @lastdonationdate=i.LastDonationDate from deleted i;
select @donarstatus=i.DonarStatus from deleted i;
set @auditaction= 'deleted record------after delete trigger fired!!'
select @auditactiontime= getdate()

insert into AuditDonarinfo(DonarName,ContactAddress,PhoneNo,BloodGroup,LastDonationDate,DonarStatus,Auditaction,Auditactiontime)
				values(@donarname,@contactaddress,@phoneno,@bloodgroup,@lastdonationdate,@donarstatus,@auditaction,getdate());

print 'after delete trigger fired!!'
go

Delete From Donarinfo
Where DonarID=3
GO





