CREATE DATABASE GlowCartDB;
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    Password NVARCHAR(100),
    Phone NVARCHAR(15),
    Location NVARCHAR(100),
    City NVARCHAR(50),
    Country NVARCHAR(50)
);
CREATE TABLE Admin (
    AdminID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE,
    Password NVARCHAR(50)
);

-- Insert default admin
INSERT INTO Admin (Username, Password) VALUES ('amna', 'amna123');
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Description NVARCHAR(MAX),
    Category NVARCHAR(50),  -- Makeup, Skincare, Haircare
    Price DECIMAL(10,2),
    InStock BIT,
    ImageURL NVARCHAR(MAX),
    SkinType NVARCHAR(50),  -- Optional: Oily, Dry, etc.
    SkinTone NVARCHAR(50),
    HairType NVARCHAR(50)
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    OrderDate DATETIME DEFAULT GETDATE(),
    Location NVARCHAR(100),
    Status NVARCHAR(50) DEFAULT 'Pending'  -- Pending, Delivered, Cancelled
);
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT
);
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT
);
CREATE TABLE UserPreferences (
    PreferenceID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    SkinType NVARCHAR(50),
    SkinTone NVARCHAR(50),
    HairType NVARCHAR(50)
);
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    PaymentMethod NVARCHAR(50), -- COD, Credit Card, etc.
    PaymentDate DATETIME DEFAULT GETDATE()
);
SELECT * FROM Users;

SELECT * FROM UserPreferences;

SELECT * FROM Cart;

ALTER TABLE Users
ADD SkinType NVARCHAR(50),
    SkinTone NVARCHAR(50),
    HairType NVARCHAR(50);

CREATE NONCLUSTERED INDEX idx_Category ON Products(Category);
CREATE NONCLUSTERED INDEX idx_SkinType ON Products(SkinType);
CREATE NONCLUSTERED INDEX idx_SkinTone ON Products(SkinTone);
CREATE NONCLUSTERED INDEX idx_HairType ON Products(HairType);

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 0;
CREATE TABLE carttwo (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_User FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

ALTER TABLE Orders
ADD DeliveryAddress NVARCHAR(255),
    PaymentMethod NVARCHAR(50);

ALTER TABLE OrderItems
ADD TotalPrice FLOAT;

SELECT * FROM OrderItems;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM Users;
SELECT * FROM Admin;

ALTER TABLE OrderItems
DROP CONSTRAINT FK__OrderItem__Produ__571DF1D5;

ALTER TABLE OrderItems
ADD CONSTRAINT FK__OrderItem__Produ__571DF1D5
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
ON DELETE CASCADE;

ALTER TABLE carttwo
DROP CONSTRAINT FK_Product;

ALTER TABLE carttwo
ADD CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE;

DECLARE @SkinType NVARCHAR(50) = 'Oily';
DECLARE @SkinTone NVARCHAR(50) = 'Fair';
DECLARE @HairType NVARCHAR(50) = 'Curly';

SELECT * FROM Products
WHERE StockQuantity > 0
AND Category = 'Skincare'
AND SkinType = @SkinType
AND SkinTone = @SkinTone
AND HairType = @HairType;


CREATE PROCEDURE GetProductsByPreference
    @SkinType NVARCHAR(50),
    @SkinTone NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Products
    WHERE StockQuantity > 0
    AND Category = 'Skincare'
    AND SkinType = @SkinType
    AND SkinTone = @SkinTone;
END
EXEC GetProductsByPreference @SkinType='Oily', @SkinTone='Fair';





-- Change Password length for Users and Admin
ALTER TABLE Users ALTER COLUMN Password NVARCHAR(255);
ALTER TABLE Admin ALTER COLUMN Password NVARCHAR(255);

-- Remove InStock (optional)
ALTER TABLE Products DROP COLUMN InStock;

-- Change TotalPrice datatype in OrderItems
ALTER TABLE OrderItems ALTER COLUMN TotalPrice DECIMAL(10,2);

-- Add UNIQUE constraint to UserPreferences.UserID (one preference per user)
ALTER TABLE UserPreferences
ADD CONSTRAINT UQ_UserPreferences_UserID UNIQUE (UserID);

-- Fix sample query (example for parameterized query in SQL Server style)
-- Use parameters in your application code, not hardcoded in SQL
SELECT * FROM Products
WHERE StockQuantity > 0
AND Category = 'Skincare'
AND SkinType = @SkinType
AND SkinTone = @SkinTone; 


INSERT INTO Products (ProductName, Category, Price, ImageURL, InStock, SkinType, SkinTone, HairType)
VALUES
('Hydrating Facial Cream', 'Skincare', 20.99, 'images/hydrating_cream.jpg', 1, 'Oily', 'Fair', NULL),
('Matte Foundation', 'Makeup', 15.50, 'images/matte_foundation.jpg', 1, NULL, 'Fair', NULL),
('Curl Defining Gel', 'Haircare', 12.00, 'images/curl_gel.jpg', 1, NULL, NULL, 'Curly'),
('Oil Control Toner', 'Skincare', 18.75, 'images/oil_control_toner.jpg', 1, 'Oily', 'Medium', NULL),
('Volumizing Shampoo', 'Haircare', 10.99, 'images/volumizing_shampoo.jpg', 1, NULL, NULL, 'Straight');

SELECT * FROM OrderItems;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM Users;
SELECT * FROM Admin;


EXEC sp_help UserPreferences;

ALTER TABLE Products ADD BrandName VARCHAR(255);

ALTER TABLE Products
ADD QuantityInStock INT DEFAULT 0;
