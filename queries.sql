CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    join_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0) 
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 1), 
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);
-- Insert data into Customers table
INSERT INTO customers (name, email)
VALUES 
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');
-- Insert data into Products table
INSERT INTO products (product_name, price)
VALUES 
('Laptop', 999.99),
('Smartphone', 499.99);
-- Insert data into Orders table
INSERT INTO Orders (customer_id) VALUES 
(1), 
(2);
-- Insert data into Order_Items
INSERT INTO Order_Items (order_id,product_id, quantity) VALUES
(1,1, 1),  
(1,2, 2); 

-- Jane Smith: 3 Laptops
INSERT INTO Order_Items (order_id, product_id, quantity) VALUES
(2, 1, 3); 
-- Part 1: Basic Queries
-- 1. List all customers sorted by join_date (newest first).
SELECT * FROM Customers
ORDER BY join_date DESC;
-- 2. Find all orders placed in January 2023.
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-31';
-- 3. Calculate the total revenue from all orders.
SELECT SUM(oi.quantity * p.price) AS total_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id;
-- Part 2: Joins and Relationships
-- 4. Show all orders with customer names and order dates.
SELECT c.name AS customer_name, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
-- 5. List products that have never been ordered:
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 6. top-spending customer (total spent across all orders).
SELECT c.name AS customer_name, SUM(oi.quantity * p.price) AS total_spent
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;
-- Part 3: Data Manipulation
-- 7. Update the price of "Laptop" to 899.99:
UPDATE Products
SET price = 899.99
WHERE product_name = 'Laptop';
SELECT* from products;
-- 8. Delete all orders placed before 2023-01-02.
DELETE FROM Orders
WHERE order_date < '2023-01-02';
-- 9. Add a new product "Headphones" priced at 149.99:
INSERT INTO Products (product_name, price)
VALUES ('Headphones', 149.99);
SELECT*from products;

-- Part 4: Advanced Challenges
-- 10.Calculate the average order value per customer:
SELECT c.name AS customer_name, AVG(oi.quantity * p.price) AS average_order_value
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id;
-- 11. Find products ordered more than 2 times in total:
SELECT p.product_name
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id
HAVING SUM(oi.quantity) > 2;
-- 12. Create an index to optimize querying orders by customer_id.ALTER
CREATE INDEX idx_customer_id ON Orders (customer_id);
SHOW INDEXES FROM Orders;