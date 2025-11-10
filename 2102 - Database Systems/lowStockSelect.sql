SELECT StockNo, StoreCode, Quantity, Reorder, Price
FROM Stocks
WHERE Quantity < Reorder;