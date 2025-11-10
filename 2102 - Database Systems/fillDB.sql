/*  Insert data into table Stores  */

Insert into Stores
  (StoreCode, Location, Supervisor)
  values
  ('TYP', 'Typing Pool', 'Mavis Grant');

Insert into Stores
  (StoreCode, Location, Supervisor)
  values
  ('LEG', 'Legal Clerks Office', 'James Phillips');

Insert into Stores
  (StoreCode, Location, Supervisor)
  values
  ('IT', 'I.T. Department', 'Steve Evans');

Insert into Stores
  (StoreCode, Location, Supervisor)
  values
  ('WORK', 'Workshop', 'Fred Reed');

Insert into Stores
  (StoreCode, Location, Supervisor)
  values
  ('CENT', 'Central Stores', 'June Simmonds');
  
/*  Insert data into table Stocks  */

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (102, 'CENT', 'A4 headed paper', 17, 'Ream', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (103, 'CENT', 'Photocopying paper', 30, 'Ream', 30);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (104, 'TYP', 'Coloured paper', 13, 'Ream', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (105, 'TYP', 'Sticky labels', 45, 'Box', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (106, 'CENT', 'Sellotape', 21, 'Roll', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (107, 'CENT', 'Drawing pins', 37, 'Box', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (108, 'CENT', 'Staples', 11, 'Box', 15);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (109, 'CENT', 'Window envelopes', 22, 'Box', 15);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (110, 'LEG', 'Large envelopes', 8, 'Box', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (111, 'CENT', 'Black ballpoints', 6, 'Box 24', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (112, 'LEG', 'Coloured pens', 17, 'Box 24', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (113, 'CENT', 'HB pencils', 22, 'Box 24', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (114, 'CENT', 'Fluorescent markers', 2, 'Box 6', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Reorder)
  values
  (115, 'CENT', '12 inch rulers', 23, 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (116, 'IT', '3.5 in. floppy disks', 14, 'Box 10', 20);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (117, 'IT', '5.25 in. floppy disks', 32, 'Box 10', 20);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Reorder)
  values
  (118, 'IT', 'Toner cartridges', 7, 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Reorder)
  values
  (119, 'TYP', 'FX-100 printer ribbon', 25, 20);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Reorder)
  values
  (121, 'CENT', 'Tipp-ex bottles', 35, 20);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Reorder)
  values
  (122, 'TYP', 'Typewriter ribbons', 16, 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (123, 'TYP', 'Audio cassettes', 8, 'Box 10', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (124, 'IT', 'Anti-static wipes', 18, 'Box 50', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (126, 'LEG', 'Sealing wax', 9, 'Box', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (127, 'LEG', 'Red binding ribbon', 13, 'Roll', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (128, 'LEG', 'A3 cream notary paper', 21, 'Ream', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (129, 'LEG', 'Coloured ink', 22, 'Bottle', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (130, 'WORK', '8 x 1 inch wood screws', 8, 'Box', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (131, 'WORK', '10 x 1 inch wood screws', 13, 'Box', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (132, 'WORK', '13 amp electrical wire', 22, 'Roll', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (134, 'WORK', 'Electrical solder', 11, 'Roll', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (135, 'WORK', 'White spirit', 6, 'Bottle', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (137, 'WORK', 'Masking tape', 8, 'Roll', 10);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (138, 'WORK', 'Door hinges', 24, 'Pair', 5);

insert into Stocks
  (StockNo, StoreCode, Description, Quantity, Units, Reorder)
  values
  (139, 'WORK', 'Angle brackets', 18, 'Pair', 6);
  
/*  Insert data into table Suppliers  */

insert into Suppliers
  (SuppCode, SuppName, Street, Town, PostCode, TelNo, FaxNo)
  values
  ('S1', 'TKG Tools Ltd.', '7 High Street', 'Swansea',
   'SA7  2WG', '0792 77221', '0792 77227');

insert into Suppliers
  (SuppCode, SuppName, Street, Town, PostCode, TelNo, FaxNo)
  values
  ('S2', 'I.T. Supplies (Wales)', '3 Marlborough Ave.', 'Cardiff',
   'CF1  1IT', '0222 67890', '0222 67899');

insert into Suppliers
  (SuppCode, SuppName, Street, Town, County, PostCode, TelNo, FaxNo)
  values
  ('S3', 'Fastorder Stationers', 'Riverside View', 'Newport', 'Gwent',
   'NP1  7XJ', '0633 89898', '0633 89899');

insert into Suppliers
  (SuppCode, SuppName, Street, Town, County, PostCode, TelNo)
  values
  ('S4', 'Office Matters', '20 Berrick Street', 'Bridgend',
   'Mid Glam.', 'CF38 3BB', '0656 134872');

insert into Suppliers
  (SuppCode, SuppName, Street, Town, PostCode, TelNo, FaxNo)
  values
  ('S5', 'Legal Services Ltd.', 'Westway Road', 'London',
   'N8  8PA', '081 333 1246', '081 333 5490');

insert into Suppliers
  (SuppCode, SuppName, Street, Town, PostCode, TelNo, FaxNo)
  values
  ('S6', 'Business Systems Ltd.','155 Stradleigh Place', 'London',
   'E10 6LL', '081 535 3535', '081 535 3355');
   
/*  Insert data into table SupplyItems  */

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 166, 102, 4.11);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 277, 102, 4.15);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 233, 103, 3.25);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 338, 103, 3.05);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S2', 36, 103, 2.98);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S6', 411, 103, 3.19);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S2', 43, 104, 5.15);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 406, 104, 5.22);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 234, 105, 4.85);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 253, 105, 4.83);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 668, 106, 0.45);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 472, 107, 0.47);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 583, 108, 0.42);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 392, 109, 2.15);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 117, 109, 2.18);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 1011, 110, 2.65);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 304, 110, 2.57);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S5', 564, 111, 2.58);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 293, 111, 2.59);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 1030, 111, 2.42);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 280, 112, 3.65);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 191, 113, 1.97);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 112, 113, 2.05);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 199, 114, 1.89);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 267, 115, 0.25);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 137, 115, 0.22);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 242, 116, 13.05);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S6', 441, 116, 12.99);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S2', 38, 116, 12.85);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 202, 117, 11.55);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S6', 426, 117, 11.49);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S2', 42, 117, 11.38);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S2', 30, 118, 33.25);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S6', 430, 118, 32.99);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S6', 462, 119, 23.99);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S2', 62, 119, 24.53);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 159, 121, 0.84);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 219, 121, 0.81);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 340, 122, 6.19);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 763, 122, 6.25);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 772, 123, 8.65);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 151, 123, 8.58);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 130, 124, 4.95);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S6', 418, 124, 5.09);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 518, 124, 5.35);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S5', 552, 126, 7.99);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S5', 558, 127, 6.47);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S5', 561, 128, 7.85);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 390, 128, 7.99);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S5', 556, 129, 3.75);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S4', 205, 129, 3.48);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S3', 184, 129, 3.65);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 677, 130, 2.85);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 766, 131, 1.35);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 572, 132, 1.84);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 388, 134, 1.59);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 521, 135, 0.98);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 518, 137, 0.49);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 588, 138, 2.14);

insert into SupplyItems
  (SuppCode, CatNo, StockNo, Price)
  values
  ('S1', 642, 139, 2.85);
  
/*  Alters Stocks table to include supplier details  */

update Stocks
  set (SuppCode, Price) =
    (select distinct SuppCode, Price
     from SupplyItems
     where Price =
       (select  min(Price)
       from SupplyItems
       where Stocks.StockNo = SupplyItems.StockNo)
     and Stocks.StockNo = SupplyItems.StockNo);
	 
/* insert a few example orders */

insert into orders
  (suppcode, orderdate, authority, totcost)
  values
  ('S4', date(), 'Admin', 32.90);

insert into orderitems
  (orderno, stockno, qtyord)
  values
  (1, 108, 10);

insert into orderitems
  (orderno, stockno, qtyord)
  values
  (1, 111, 10);

insert into orderitems
  (orderno, stockno, qtyord)
  values
  (1, 106, 10);

insert into orders
  (suppcode, orderdate, authority, totcost)
  values
  ('S2', date(), 'Admin', 242.30);

insert into orderitems
  (orderno, stockno, qtyord)
  values
  (2, 116, 10);
 
insert into orderitems
  (orderno, stockno, qtyord)
  values
  (2, 117, 10);