CREATE TABLE Deliveries (
	DeliveryNo NUMBER(6) PRIMARY KEY,
	OrderNo NUMBER(6) NOT NULL,
	SuppCode VARCHAR2(6) NOT NULL,
	DeliveryDate date,
	FOREIGN KEY (SuppCode) REFERENCES Suppliers(SuppCode),
	FOREIGN KEY (OrderNo) REFERENCES Orders(OrderNo)
);