/*  Create Supplies, Orders and Deliveries clusters  */

/*create cluster SupplyData
  (SuppCode varchar2(4));
	
create cluster OrderData
  (OrderNo number(6));

create cluster DeliveryData
  (DelivNo number(6));
*/

/*  Create cluster indices  */

/*create index SupplyDataKey
  on cluster SupplyData;

create index OrderDataKey
  on cluster OrderData;

create index DelivDataKey
  on cluster DeliveryData; 
*/
/*  Create course table Stores  */

create table Stores
  (StoreCode   varchar2(6) not null primary key,
   Location    varchar2(24),
   Supervisor  varchar2(24));
   
/*  Create course table Stocks  */

create table Stocks
  (StockNo      number(6) not null primary key,
   StoreCode    varchar2(6) not null, 
   Description  varchar2(24),
   Quantity     number(6),
   Units        varchar2(12),
   Reorder      number(6),
   Price 		number(6,2),
   SuppCode 	varchar2(6),
   foreign key (StoreCode)
     references Stores(StoreCode));
	 
/*  Create course table Suppliers  */

create table Suppliers
  (SuppCode  varchar2(4) not null primary key,
   SuppName  varchar2(30),
   Street    varchar2(24),
   Town      varchar2(16),
   County    varchar2(16),
   PostCode  varchar2(10),
   TelNo     varchar2(16),
   FaxNo     varchar2(16));
  
/*  Create course table SupplyItems  */

create table SupplyItems
  (SuppCode  varchar2(4) not null,
   CatNo     number(6) not null,
   StockNo   number(6),
   Price     number(6,2),
   primary key (SuppCode, CatNo),
   foreign key (SuppCode)
     references Suppliers(SuppCode),
   foreign key (StockNo)
     references Stocks(StockNo));
  
/*  Create course table Orders  */

create table Orders
  (OrderNo    integer primary key AUTOINCREMENT,
   SuppCode   varchar2(4) not null,
   OrderDate  date,
   Authority  varchar2(24),
   TotCost    number(8,2),
   foreign key (SuppCode)
     references Suppliers(SuppCode));
  
/*  Create course table OrderItems  */

create table OrderItems
  (OrderNo  number(6) not null,
   StockNo  number(6) not null,
   QtyOrd   number(6),
   primary key (OrderNo, StockNo),
   foreign key (OrderNo) 
     references Orders(OrderNo),
   foreign key (StockNo) 
     references Stocks(StockNo));