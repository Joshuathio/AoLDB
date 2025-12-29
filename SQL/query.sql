-- Query 1: New Product
-- Add a new, never-before-seen product to the database.

INSERT INTO Item (StockCode, StockDescription, StockPrice, StockQuantity)
VALUES ('12345', 'LIMITED EDITION LAPTOP', 17.50, 100);



-- Query 2: Customer Order
-- Write the series of statements required for an existing customer
-- to order two different products in a single transaction.

START TRANSACTION;

-- Create a new invoice
INSERT INTO Invoice (InvoiceID, InvoiceDate, CustomerID)
VALUES ('123456', NOW(), '13085.0');

-- Insert ordered items for the invoice
INSERT INTO OrderedItem (InvoiceID, StockCode, Quantity)
VALUES 
    ('123456', '85048', 5), 
    ('123456', '22041', 8); 

-- Update stock quantities after order placement
UPDATE Item AS i
JOIN OrderedItem AS oi
    ON i.StockCode = oi.StockCode
SET i.StockQuantity = i.StockQuantity - oi.Quantity
WHERE i.StockCode = '85048'
OR i.StockCode = '22041';

COMMIT;



-- Query 3: Customer Return
-- Write the statements required to process a return
-- for one of the items from the order you created above.

START TRANSACTION;

-- Reduce quantity of the returned item
UPDATE OrderedItem
SET Quantity = Quantity - 1
WHERE InvoiceID = '123456'
AND StockCode = '85048';

-- Restore stock for the returned item
UPDATE Item
SET StockQuantity = StockQuantity + 1
WHERE StockCode = '85048';

-- Remove ordered item if there is no stock left
DELETE FROM OrderedItem
WHERE InvoiceID = '123456'
AND StockCode = '85048'
AND Quantity = 0;

COMMIT;



-- Query 4: Analytical Report
-- Write a query to find the top 10 customers by total money spent.

SELECT 
    cs.CustomerID,
    cs.CustomerName,
    SUM(oi.Quantity * it.StockPrice) AS TotalSpent
FROM Customers cs
JOIN Invoice inv ON cs.CustomerID = inv.CustomerID
JOIN OrderedItem oi ON inv.InvoiceID = oi.InvoiceID
JOIN Item it ON oi.StockCode = it.StockCode
GROUP BY cs.CustomerID, cs.CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;



-- Query 5: Analytical Report
-- Write a query to identify the month
-- with the highest total sales revenue in the year 2011.

SELECT 
    MONTHNAME(inv.InvoiceDate) AS Month,
    SUM(oi.Quantity * it.StockPrice) AS Revenue
FROM Invoice inv
JOIN OrderedItem oi ON inv.InvoiceID = oi.InvoiceID
JOIN Item it ON oi.StockCode = it.StockCode
WHERE YEAR(inv.InvoiceDate) = 2011
GROUP BY MONTH(inv.InvoiceDate), MONTHNAME(inv.InvoiceDate)
ORDER BY Revenue DESC