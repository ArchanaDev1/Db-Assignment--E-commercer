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
(1,1, 1),  -- 1 Laptop
(1,2, 2);  -- 2 Smartphones

-- Jane Smith: 3 Laptops
INSERT INTO Order_Items (order_id, product_id, quantity) VALUES
(2, 1, 3);  -- 3 Laptops


SELECT*from Customers;
SELECT*from Products;
SELECT*from Orders ;
SELECT*from Order_Items ;