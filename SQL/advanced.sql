-- Triggers
-- Create a trigger that automatically updates the inventory level
-- of a product whenever a transaction (sale or return)
-- involving that product is recorded.

-- Trigger for Sale
-- Subtract the ordered quantity from the corresponding item stock.

DELIMITER $$

CREATE TRIGGER CustomerOrder
AFTER INSERT ON OrderedItem
FOR EACH ROW
BEGIN
    UPDATE Item
    SET StockQuantity = StockQuantity - NEW.Quantity
    WHERE StockCode = NEW.StockCode;
END $$

DELIMITER ;

-- Trigger for Return
-- Calculate the difference between old and new quantity.
-- Add the returned quantity back to item stock.

DELIMITER $$

CREATE TRIGGER CustomerReturn
AFTER UPDATE ON OrderedItem
FOR EACH ROW
BEGIN
    DECLARE diff INT;
    
    SET diff = OLD.Quantity - NEW.Quantity;

    UPDATE Item
    SET StockQuantity = StockQuantity + diff
    WHERE StockCode = NEW.StockCode;

    END $$

DELIMITER ;



-- Stored Procedure
-- Create a stored procedure named GetCustomerInvoiceHistory
-- that accepts a CustomerID as input and returns a complete list of all invoices
-- (including the date and total value) belonging to that customer.

-- Procedure GetCustomerInvoiceHistory

DELIMITER $$

CREATE PROCEDURE GetCustomerInvoiceHistory
    (IN CustomerID VARCHAR(10))
BEGIN
    SELECT 
        inv.InvoiceID,
        inv.InvoiceDate,
        SUM(oi.Quantity * i.StockPrice) AS TotalValue
    FROM Invoice AS inv
    JOIN OrderedItem AS oi ON inv.InvoiceID = oi.InvoiceID
    JOIN Item AS it ON oi.StockCode = it.StockCode
    WHERE inv.CustomerID = CustomerID
    GROUP BY inv.InvoiceID, inv.InvoiceDate
    ORDER BY inv.InvoiceDate DESC;
END $$

DELIMITER ;