CREATE TABLE Modules (
	ModuleCode CHAR(6) PRIMARY KEY,
	ModuleTitle VARCHAR2(50) NOT NULL
);

CREATE TABLE Students (
	StudentNo NUMBER(6) CHECK (StudentNo >= 1 AND StudentNo <= 1000),
	Taking CHAR(6),
	FOREIGN KEY (Taking) REFERENCES Modules(ModuleCode)
);