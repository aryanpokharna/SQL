/* 
ISYS2120 Assignment 1

• Aryan Pokharna - SID
• Negeen Daudi - 500508121
*/

CREATE TABLE Repair (
    FaultReport VARCHAR(800)
    StartDate DATE,
    EndDate DATE,
    RepairID INTEGER PRIMARY KEY,
    Cost FLOAT,
    ServiceABN BIGINT REFERENCES Service(ABN) NOT NULL,
    DeviceRepaired BIGINT REFERENCES Device(DeviceID) NOT NULL
);
CREATE TABLE Device (
    SerialNumber BIGINT,
    PurchaseDate DATE,
    DeviceID BIGINT PRIMARY KEY,
    PurchaseCost FLOAT,
    ModelNumber BIGINT REFERENCES Model(ModelNumber) NOT NULL, -- NOT NULL cos its exactly 1
    Manufacturer VARCHAR(30) REFERENCES Model(Manufacturer) NOT NULL, 
    Employee INTEGER REFERENCES Employee(EmpID) 
);
CREATE TABLE UsedBy ( 
    DeviceID BIGINT REFERENCES Device(DeviceID),
    EmpID INTEGER REFERENCES Employee(EmpID),
    PRIMARY KEY (DeviceID, EmpID)
);
CREATE TABLE Phone (
    Plan VARCHAR(30),
    Carrier VARCHAR(30),
    Number BIGINT
);
CREATE TABLE Model (
    Weight FLOAT,
    ModelNumber BIGINT,
    Manufacturer VARCHAR(30),
    Description VARCHAR(30), 
    PRIMARY KEY (ModelNumber, Manufacturer)
);
CREATE TABLE AllocatedTo (
    DepartmentName VARCHAR(20) REFERENCES Department(Name),
    MaxNumber INTEGER,
    --CONSTRAINT Model FOREIGN KEY (ModelNumber, Manufacturer) REFERENCES Model(ModelPK), -- i think this works
    ModelNumber BIGINT REFERENCES Model(ModelNumber),
    Manufacturer VARCHAR(30) REFERENCES Model(Manufacturer),
    PRIMARY KEY (ModelNumber, Manufacturer, DepartmentName)
);
CREATE TABLE Employee (
    HomeAddress VARCHAR(100),
    Name VARCHAR(30),
    EmpID INTEGER PRIMARY KEY,
    DateOfBirth DATE,
    Department VARCHAR(20) REFERENCES Department(Name) 
);
CREATE TABLE PhoneNumbers ( -- how they did multivalue attributes in lecture
    PhoneNumber BIGINT,
    Employee INTEGER REFERENCES Employee(EmpID),
    PRIMARY KEY (PhoneNumber, Employee)
);
CREATE TABLE Department (
    Budget INTEGER, 
    Name VARCHAR(20) PRIMARY KEY,
    WorksIn INTEGER [] REFERENCES Employee(EmpID)
);
CREATE TABLE OfficeLocations (
    Location VARCHAR(20),
    DepartmentName VARCHAR(20) REFERENCES Department(Name),
    PRIMARY KEY (Location, DepartmentName)
);
CREATE TABLE Service (
    Owed FLOAT REFERENCES Repair(Cost),
    ServiceName VARCHAR(30),
    ABN BIGINT PRIMARY KEY, 
    Email VARCHAR(30)
);


/*
Situations:

•	A particular device was repaired twice. ALLOWED
    This is allowed as the line connecting the Device entity type and the DoneTo relationship is a thin line, meaning a device can have any number of repairs greater than or equal to 0.

•	A particular device was never repaired. ALLOWED
    This is allowed as the line connecting the Device entity type and the DoneTo relationship is a thin line, meaning a device can have any number of repairs greater than or equal to 0.

•	One repair fixed two devices. PREVENTED
    This is not allowed as the line between the Repair entity type and the DoneTo relationship is thick and has an arrow, meaning a repair can be done to exactly 1 device.

•	A particular repair is not done on any device. PREVENTED
    This is not allowed as the line between the Repair entity type and the DoneTo relationship is thick and has an arrow, meaning a repair can be done to exactly 1 device.

•   There is a device which is not a phone. ALLOWED
    Looking to the IsA hierarchy, there is no 'total' annotation to suggest that every device (superclass) must be a subclass entity. Hence, this is allowed. 

•	A particular device was issued to three employees. PREVENTED
    This is not allowed. According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow.

•	A particular employee was issued two devices. ALLOWED
    The line between the Employee entity type and the IssuedTo relationship is a thin line, meaning an employee can be issued any number of devices, and thus, this is allowed.

•	A particular device was not issued to any employee. ALLOWED
    According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow. Hence, this is allowed.

•	A particular employee has not been issued with any device. ALLOWED
    The line between the Employee entity type and the IssuedTo relationship is a thin line, meaning an employee can be issued any number of devices, and thus, this is allowed.

•	A particular device was issued to one employee. ALLOWED
    According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow. Hence, this is allowed.

•	A particular device was used by three employees. 
    - True. The ER diagram allows this. The line between Device entity type and UsedBy relationship is a thin line, implying that a device can be used by any number of employees greater than or equal to 0.

•	A particular employee used two devices. 
    - True. The ER diagram allows this. The line between Employee entity type and UsedBy relationship is a thin line, implying that an employee can use any number of devices greater than or equal to 0.

•	A particular device was not used by any employee. 
    - True. The ER diagram allows this. The line between Device entity type and UsedBy relationship is a thin line, implying that a device can be used by any number of employees greater than or equal to 0.

•	A particular employee has not used any device. 
    - True. The ER diagram allows this. The line between Employee entity type and UsedBy relationship is a thin line, implying that an employee can use any number of devices greater than or equal to 0.

•	A particular device was used by one employee. 
    - True. The ER diagram allows this. The line between Device entity type and UsedBy relationship is a thin line, implying that a device can be used by any number of employees, greater than or equal to 0.

•	Two models were allocated to the same department. 
    - True. The ER diagram allows this. The line between Department entity type and AllocatedTo relationship is a thin line, implying that a department can have any number of models allocated to it, greater than or equal to 0.

•	A particular model was allocated to three departments. 
    - True. The ER diagram allows this. The line between Model entity type and AllocatedTo relationship is a thin line, implying that a model can be allocated to any number of departments, greater than or equal to 0.

•	A particular department has not had any model allocated to it. 
    - True. The ER diagram allows this. The line between Department entity type and AllocatedTo relationship is a thin line, implying that a department can have any number of models allocated to it, greater than or equal to 0.
    
•	A particular model has not been allocated to any department. 
    - True. The ER diagram allows this. The line between Model entity type and AllocatedTo relationship is a thin line, implying that a model can be allocated to any number of departments, greater than or equal to 0.

*/