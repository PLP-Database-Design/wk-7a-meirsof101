-- Question 1.: Write a SQL query to split a comma-separated string in a column into multiple rows.
-- This SQL query is designed to split a comma-separated string in a column into multiple rows.
-- It uses a helper table (Numbers) to generate a sequence of numbers that can be used to extract each product from the string.
-- Query 1 to identify the database.
USE salesDb; -- Replace with your database name

-- Query 2 to create the ProductDetail table.
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Query 3 to insert data into the ProductDetail table.
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Query 4 to create a Numbers table.
-- This table will be used to generate a sequence of numbers from 1 to 10.
CREATE TABLE Numbers (n INT);
INSERT INTO Numbers (n)
VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
-- Query 5 to split the Products column into multiple rows.
-- The SUBSTRING_INDEX function is used to extract each product from the comma-separated string.
-- This query will return each product in a separate row along with the corresponding OrderID and CustomerName.
SELECT 
    pd.OrderID,
    pd.CustomerName,
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(pd.Products, ',', n), 
            ',', -1
        )
    ) AS Product
FROM ProductDetail pd
JOIN Numbers ON n <= 1 + LENGTH(pd.Products) - LENGTH(REPLACE(pd.Products, ',', ''))
WHERE TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(pd.Products, ',', n), 
            ',', -1
        )
    ) <> '';

-- Question 2. 
-- Choose a database and create two tables: Orders and OrderProducts.
-- The Orders table will contain OrderID and CustomerName.
-- The OrderProducts table will contain OrderID, Product, and Quantity.
-- The OrderID in the OrderProducts table will be a foreign key referencing the Orders table.
-- Insert sample data into both tables.
-- Query 1 to identify the database.
USE hr; 
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
-- Query 2 to insert data into the Orders table.
-- The Orders table contains OrderID and CustomerName.
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Query 3 to create the OrderProducts table.
-- The OrderProducts table contains OrderID, Product, and Quantity.
-- The OrderID in the OrderProducts table is a foreign key referencing the Orders table.
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- Query 4 to insert data into the OrderProducts table.
-- The OrderProducts table contains OrderID, Product, and Quantity.
INSERT INTO OrderProducts (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Query 5 to retrieve data from both tables.
-- This query retrieves the OrderID, CustomerName, Product, and Quantity from both tables.
-- It uses a JOIN operation to combine the data based on the OrderID.
-- The result will show each order along with the products and their quantities though not violating the 2NF rule.

SELECT o.OrderID, o.CustomerName, p.Product, p.Quantity
FROM Orders o
JOIN OrderProducts p ON o.OrderID = p.OrderID;
