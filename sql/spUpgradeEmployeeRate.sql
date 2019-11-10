CREATE PROCEDURE spUpgradeEmployeeRate
AS
BEGIN
DECLARE @BUSINESSENTITYID Int
DECLARE @GroupName nvarchar(50)
DECLARE EmployeeCursor CURSOR FOR SELECT E.BUSINESSENTITYID, D.GroupName FROM My_Employee e INNER JOIN
(SELECT BusinessEntityID, DepartmentID FROM My_EmployeeDepartmentHistory WHERE EndDate is null) edh
on (e.BusinessEntityID = edh.BusinessEntityID)
INNER JOIN My_Department d on (d.DepartmentID = edh.DepartmentID)
INNER JOIN
AdventureWorksDB.HumanResources.EmployeePayHistory eph
on (e.BusinessEntityID = eph.BusinessEntityID)
INNER JOIN
(select BusinessEntityID, max(ModifiedDate) as ModifiedDate
from AdventureWorksDB.HumanResources.EmployeePayHistory
group by BusinessEntityID) eph1
on (eph.BusinessEntityID = eph1.BusinessEntityID and eph.ModifiedDate = eph1.ModifiedDate)
FOR UPDATE OF My_EmployeePayRateHistory
Open EmployeeCursor
        Fetch Next From EmployeeCursor INTO @BUSINESSENTITYID, @GroupName
              
        WHILE @@FETCH_STATUS = 0
          /**
           *  increase the salary hour rate of the employee by 10% if the group name is “Inventory Management” and “Quality Assurance”;
           *  15% if the group name is ‘Manufacturing’
           *  20% if the group name is ‘Sales and Marketing’ and ‘Research and Development’.
           */
          IF @GroupName  = 'Inventory Management' Or @GroupName  = 'Inventory Management'
               PRINT @BUSINESSENTITYID
          ELSE IF @GroupName  = 'Manufacturing'
               PRINT @BUSINESSENTITYID
          ELSE IF @GroupName  = 'Inventory Management' Or @GroupName  = 'Inventory Management'
               PRINT @BUSINESSENTITYID
           Fetch Next From EmployeeCursor INTO @BUSINESSENTITYID, @GroupName
Close EmployeeCursor
Deallocate EmployeeCursor
END
