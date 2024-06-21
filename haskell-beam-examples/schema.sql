-- Create customer table
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) not null,
    last_name VARCHAR(50),
    email VARCHAR(100) unique,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create category table
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100)
);

-- Create product table
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) not null,
    category_id INT REFERENCES category(category_id),
    price DECIMAL(10, 2)
);

-- Create order table
CREATE TABLE "order" (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    order_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2)
);

-- Create order_item table
CREATE TABLE order_item (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES "order"(order_id),
    product_id INT REFERENCES product(product_id),
    quantity INT not null,
    unit_price DECIMAL(10, 2)
);

-- Insert sample data into customer table
INSERT INTO customer (first_name, last_name, email) VALUES
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com');

-- Insert sample data into category table
INSERT INTO category (category_name) VALUES
('Electronics'),
('Books');

-- Insert sample data into product table
INSERT INTO product (product_name, category_id, price) VALUES
('Laptop', 1, 999.99),
('Smartphone', 1, 499.99),
('Novel', 2, 19.99);

-- Insert sample data into order table
INSERT INTO "order" (customer_id, total_amount) VALUES
(1, 1519.98),
(2, 19.99);

-- Insert sample data into order_item table
INSERT INTO order_item (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 499.99),
(2, 3, 1, 19.99);
