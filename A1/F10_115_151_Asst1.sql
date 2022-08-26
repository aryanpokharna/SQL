/* 
ISYS2120 Assignment 1

• Aryan Pokharna - 500503791
• Negeen Daudi - 500508121
*/

CREATE TABLE Service (
    Owed FLOAT,
    ServiceName VARCHAR(30),
    ABN BIGINT PRIMARY KEY, 
    Email VARCHAR(30)
);
CREATE TABLE Model (
    Weight FLOAT,
    ModelNumber BIGINT,
    Manufacturer VARCHAR(30),
    Description VARCHAR(30), 
    PRIMARY KEY (ModelNumber, Manufacturer)
);
CREATE TABLE Department (
    Budget INTEGER, 
    Name VARCHAR(20) PRIMARY KEY
);
CREATE TABLE Employee (
    HomeAddress VARCHAR(100),
    Name VARCHAR(30),
    EmpID INTEGER PRIMARY KEY,
    DateOfBirth DATE,
    Department VARCHAR(20) REFERENCES Department(Name) 
);
CREATE TABLE WorksIn (
    Department VARCHAR(20) REFERENCES Department(Name),
    Employee INTEGER REFERENCES Employee(EmpID),
    Fraction FLOAT,
    PRIMARY KEY (Department, Employee)
);
CREATE TABLE Device (
    SerialNumber BIGINT,
    PurchaseDate DATE,
    DeviceID BIGINT PRIMARY KEY,
    PurchaseCost FLOAT,
    Employee INTEGER REFERENCES Employee(EmpID), -- Employee the device is issued to (IssuedTo)
    ModelNumber BIGINT, 
    Manufacturer VARCHAR(30),
    FOREIGN KEY (ModelNumber, Manufacturer) REFERENCES Model(ModelNumber, Manufacturer) -- Model of Device (IsInstanceOf)
);
CREATE TABLE Repair (
    FaultReport VARCHAR(800),
    StartDate DATE,
    EndDate DATE,
    RepairID INTEGER PRIMARY KEY,
    Cost FLOAT,
    ServiceABN BIGINT REFERENCES Service(ABN) NOT NULL, -- Service which did the repair (DoneBy)
    DeviceRepaired BIGINT REFERENCES Device(DeviceID) NOT NULL -- Device which was repaired (DoneTo)
);
CREATE TABLE UsedBy ( 
    DeviceID BIGINT REFERENCES Device(DeviceID),
    EmpID INTEGER REFERENCES Employee(EmpID),
    PRIMARY KEY (DeviceID, EmpID)
);
CREATE TABLE Phone (
    DeviceID BIGINT REFERENCES Device(DeviceID),
    Plan VARCHAR(30),
    Carrier VARCHAR(30),
    Number BIGINT,
    PRIMARY KEY (DeviceID)
);
CREATE TABLE AllocatedTo (
    DepartmentName VARCHAR(20) REFERENCES Department(Name),
    MaxNumber INTEGER,
    ModelNumber BIGINT,
    Manufacturer VARCHAR(30),
    FOREIGN KEY (ModelNumber, Manufacturer) REFERENCES Model(ModelNumber, Manufacturer),
    PRIMARY KEY (ModelNumber, Manufacturer, DepartmentName)
);
CREATE TABLE PhoneNumbers ( 
    PhoneNumber BIGINT,
    Employee INTEGER REFERENCES Employee(EmpID),
    PRIMARY KEY (PhoneNumber, Employee)
);
CREATE TABLE OfficeLocations (
    Location VARCHAR(20),
    DepartmentName VARCHAR(20) REFERENCES Department(Name),
    PRIMARY KEY (Location, DepartmentName)
);

/*
Situations:

•	A particular device was repaired twice. ALLOWED
    This is allowed as the line connecting the Device entity type and the DoneTo relationship is a thin line, meaning a device can have any number of repairs greater than or equal to 0.
    The SQL code allows this as the Repair table has the attribute DeviceRepaired which is a foreign key and hence two repairs may reference the same device.

•	A particular device was never repaired. ALLOWED
    This is allowed as the line connecting the Device entity type and the DoneTo relationship is a thin line, meaning a device can have any number of repairs greater than or equal to 0.
    The SQL code allows this occur because when a device instance is created, there are no attributes in the Device table which link it a repair. Hence, a device will have 0 repaires until it is referenced by a repair.

•	One repair fixed two devices. PREVENTED
    This is not allowed as the line between the Repair entity type and the DoneTo relationship is thick and has an arrow, meaning a repair can be done to exactly 1 device.
    The SQL code does not allow this as each repair instance has an attribute DeviceRepaired which references ONE device. Two records with the same RepairID and DeviceRepaired is not allowed as RepairID is the PK.

•	A particular repair is not done on any device. PREVENTED
    This is not allowed as the line between the Repair entity type and the DoneTo relationship is thick and has an arrow, meaning a repair can be done to exactly 1 device.
    The SQL code uses NOT NULL for the DeviceRepaired attribute, hence a repair must reference a device.

•   There is a device which is not a phone. ALLOWED
    Looking to the IsA hierarchy, there is no 'total' annotation to suggest that every device (superclass) must be a subclass entity. Hence, this is allowed. 
    In SQL there is no code which stops someone from creating a device instance which is not referenced by a phone instance. Hence a there can be a device which is not a phone.

•	A particular device was issued to three employees. PREVENTED
    This is not allowed. According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow.
    The SQL code does not allow this as each device instance has an attribute Employee which references ONE employee. Three records with the same DeviceID and Employee are not allowed as DeviceID is the PK.

•	A particular employee was issued two devices. ALLOWED
    The line between the Employee entity type and the IssuedTo relationship is a thin line, meaning an employee can be issued any number of devices, and thus, this is allowed.
    This is allowed with the SQL code as there is no UNIQUE or PK contraint which stops two devices referencing the same Employee.

•	A particular device was not issued to any employee. ALLOWED
    According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow. Hence, this is allowed.
    Because the Employee atrribute of the Device entity type does not have a NOT NULL constraint, it is possible that a device is not issued to any employee.

•	A particular employee has not been issued with any device. ALLOWED
    The line between the Employee entity type and the IssuedTo relationship is a thin line, meaning an employee can be issued any number of devices, and thus, this is allowed.
    The SQL code allows this occur because when an Employee instance is created, there are no attributes in the Employee table which link it a device. Hence, an Employee will have 0 devices issued to them until they are referenced by a device.

•	A particular device was issued to one employee. ALLOWED
    According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow. Hence, this is allowed.
    The Device table has an Employee atrribute which references an Employee instance, if this atrribute is not null then a device is issued to the employee referenced by the attribute.

•	A particular device was used by three employees. 
    - True. The ER diagram allows this. The line between Device entity type and UsedBy relationship is a thin line, implying that a device can be used by any number of employees greater than or equal to 0.
    This is allowed because the table called UsedBy was created to represent this many-to-many relationship. It allows 3 records to be entered with the same DeviceID but varying EmpID's seeing as the PK is a composite key (DeviceID, EmpID).

•	A particular employee used two devices. 
    - True. The ER diagram allows this. The line between Employee entity type and UsedBy relationship is a thin line, implying that an employee can use any number of devices greater than or equal to 0.
    This is allowed because the table called UsedBy was created to represent this many-to-many relationship. It allows 2 records to be entered with the same EmpID but varying DeviceID's seeing as the PK is a composite key (DeviceID, EmpID).

•	A particular device was not used by any employee. 
    - True. The ER diagram allows this. The line between Device entity type and UsedBy relationship is a thin line, implying that a device can be used by any number of employees greater than or equal to 0.
    The SQL code allows this occur because when a Device instance is created, there are no attributes in the Device table which link it a UsedBy instance. Hence, a Device will not be used by any employees until it is referenced in the UsedBy table.

•	A particular employee has not used any device. 
    - True. The ER diagram allows this. The line between Employee entity type and UsedBy relationship is a thin line, implying that an employee can use any number of devices greater than or equal to 0.
    Same logic as above but vice versa.

•	A particular device was used by one employee. 
    - True. The ER diagram allows this. The line between Device entity type and UsedBy relationship is a thin line, implying that a device can be used by any number of employees, greater than or equal to 0.
    The SQL code allows this as there can be a single entry in the UsedBy table referencing one device and one employee.

•	Two models were allocated to the same department. 
    - True. The ER diagram allows this. The line between Department entity type and AllocatedTo relationship is a thin line, implying that a department can have any number of models allocated to it, greater than or equal to 0.
    This is allowed because the table called AllocatedTo was created to represent this many-to-many relationship. It allows 2 records to be entered with the same ModelNumber and  Manufacturer but varying DepartmentNames's seeing as the PK is a composite key (ModelNumber, Manufacturer, DepartmentName).

•	A particular model was allocated to three departments. 
    - True. The ER diagram allows this. The line between Model entity type and AllocatedTo relationship is a thin line, implying that a model can be allocated to any number of departments, greater than or equal to 0.
    Same logic as the previous situation, 3 entries can reference the same model but differing departments.

•	A particular department has not had any model allocated to it. 
    - True. The ER diagram allows this. The line between Department entity type and AllocatedTo relationship is a thin line, implying that a department can have any number of models allocated to it, greater than or equal to 0.
    The SQL code allows this occur because when a Department instance is created, there are no attributes in the Department table which link it a AllocatedTo instance. Hence, a Department will not be allocated any models until it is referenced in the AllocatedTo table.

•	A particular model has not been allocated to any department. 
    - True. The ER diagram allows this. The line between Model entity type and AllocatedTo relationship is a thin line, implying that a model can be allocated to any number of departments, greater than or equal to 0.
    Same logic as above but vice versa.

*/