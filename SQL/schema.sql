CREATE DATABASE IF NOT EXISTS Tokopee;
USE Tokopee;

CREATE TABLE IF NOT EXISTS Customers (
    CustomerID VARCHAR(25) PRIMARY KEY NOT NULL,
    CustomerName VARCHAR(50) NOT NULL,
    CustomerNumber VARCHAR(15) UNIQUE NOT NULL,
    CustomerCountry VARCHAR(50) NOT NULL,
    CustomerAddress VARCHAR(100) NOT NULL,

    CHECK(CustomerNumber REGEXP '^[0-9]+$')
);

CREATE TABLE IF NOT EXISTS Invoice (
    InvoiceID VARCHAR(10) PRIMARY KEY NOT NULL,
    InvoiceDate DATETIME NOT NULL,
    CustomerID VARCHAR(10) NOT NULL,

    CONSTRAINT FK_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Item (
    StockCode VARCHAR(10) PRIMARY KEY NOT NULL,
    StockDescription VARCHAR(100) NOT NULL,
    StockPrice FLOAT NOT NULL CHECK (StockPrice >= 0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0)
);

CREATE TABLE IF NOT EXISTS OrderedItem (
    InvoiceID VARCHAR(10) NOT NULL,
    StockCode VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    
    PRIMARY KEY (InvoiceID, StockCode),

    CONSTRAINT FK_InvoiceID
        FOREIGN KEY (InvoiceID)
        REFERENCES Invoice(InvoiceID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_StockCode
        FOREIGN KEY (StockCode)
        REFERENCES Item(StockCode)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);