/* 
ISYS2120 Assignment 1 – Week 3 Progress

Situations:
(Negeen's Response)
•	A particular device was repaired twice. – This is allowed as the line connecting the Device entity type and the DoneTo relationship is a thin line, meaning a device can have any number of repairs greater than or equal to 0.
•	A particular device was never repaired. - This is allowed as the line connecting the Device entity type and the DoneTo relationship is a thin line, meaning a device can have any number of repairs greater than or equal to 0.
•	One repair fixed two devices. – This is not allowed as the line between the Repair entity type and the DoneTo relationship is thick and has an arrow, meaning a repair can be done to exactly 1 device.
•	A particular repair is not done on any device. - This is not allowed as the line between the Repair entity type and the DoneTo relationship is thick and has an arrow, meaning a repair can be done to exactly 1 device.
•	There is a device which is not a phone. - This is allowed as the line connecting the Device entity and the Phone entity, via the 'IsA' relationship, is a thin line. This means the device does not have to be a phone.)
•	A particular device was issued to three employees. – This is not allowed. According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow.
•	A particular employee was issued two devices. – This is allowed. The line between the Employee entity type and the IssuedTo relationship is a thin line, meaning an employee can be issued any number of devices.
•	A particular device was not issued to any employee. - According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow. Hence, this is allowed.
•	A particular employee has not been issued with any device. – The line between the Employee entity type and the IssuedTo relationship is a thin line, meaning an employee can be issued any number of devices, and thus, this is allowed.
•	A particular device was issued to one employee. – According to the ER diagram a Device entity type can be issued to at most 1 Employee entity type. This is because the line between Device and IssuedTo has an arrow. Hence, this is allowed.

(Aryan's Response)
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

CREATE TABLE Repair (
    FaultReport VARCHAR(800)
    StartDate DATE,
    EndDate DATE,
    RepairID INTEGER PRIMARY KEY,
    Cost FLOAT
)
CREATE TABLE Device (
    SerialNumber BIGINT,
    PurchaseDate DATE,
    DeviceID BIGINT PRIMARY KEY,
    PurchaseCost FLOAT,
    IsInstanceOf BIGINT REFERENCES Model(ModelNumber),
    UsedBy INTEGER [] REFERENCES Employee(EmpID)
)
CREATE TABLE Phone (
    Plan VARCHAR(30),
    Carrier VARCHAR(30),
    Number BIGINT
)
CREATE TABLE Model (
    Weight FLOAT,
    ModelNumber BIGINT PRIMARY KEY,
    Manufacturer VARCHAR(30) PRIMARY KEY,
    Description VARCHAR(30), 
    AllocatedTo VARCHAR(20) [] REFERENCES Department(Name)
    IsInstanceOf BIGINT [] REFERENCES Device(DeviceID)
)
CREATE TABLE Employee (
    PhoneNumbers BIGINT UNSIGNED [],
    HomeAddress VARCHAR(100),
    Name VARCHAR(30),
    EmpID INTEGER PRIMARY KEY,
    DateOfBirth DATE,
    WorksIn VARCHAR(20) REFERENCES Department(Name) 
    UsedBy BIGINT [] REFERENCES Device(DeviceID)
    IssuedTo 
)
CREATE TABLE Department (
    OfficeLocations VARCHAR(20) [],
    Budget INTEGER, 
    Name VARCHAR(20) PRIMARY KEY,
    AllocatedTo BIGINT [] REFERENCES Model(ModelNumber),
    WorksIn INTEGER [] REFERENCES Employee(EmpID)
)
CREATE TABLE Service (
    Owed FLOAT REFERENCES Repair(Cost),
    ServiceName VARCHAR(30),
    ABN BIGINT PRIMARY KEY, 
    Email VARCHAR(30)
)