{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE DeriveGeneric #-}
module Examples.Model where

import Data.Text (Text)
import Data.Time (UTCTime)
import Database.Beam
import GHC.Int
import Data.Scientific


data CustomerT f = Customer {
    _customerId :: Columnar f Int32
  , _firstName  :: Columnar f Text
  , _lastName   :: Columnar f (Maybe Text)
  , _email      :: Columnar f Text
  , _createdAt  :: Columnar f UTCTime
} deriving (Generic,Beamable)

data CategoryT f = Category {
    _categoryId :: Columnar f Int32
  , _categoryName :: Columnar f Text
} deriving (Generic,Beamable)

data ProductT f = Product {
    _productId :: Columnar f Int32
  , _productName :: Columnar f Text
  , _categoryIdForProduct :: PrimaryKey CategoryT f
  , _price :: Columnar f Scientific
} deriving (Generic,Beamable)

data OrderT f = Order {
    _orderId :: Columnar f Int32
  , _customerIdForOrder :: PrimaryKey CustomerT f
  , _orderDate :: Columnar f UTCTime
  , _totalAmount :: Columnar f Scientific
} deriving (Generic,Beamable)

data OrderItemT f = OrderItem {
    _orderItemId :: Columnar f Int32
  , _orderIdForOrderItem :: PrimaryKey OrderT f
  , _productIdForOrderItem :: PrimaryKey ProductT f
  , _quantity :: Columnar f Int32
  , _unitPrice :: Columnar f Scientific
} deriving (Generic,Beamable)

type Category = CategoryT Identity
type CategoryId = PrimaryKey CategoryT Identity

type Customer = CustomerT Identity
type CustomerId = PrimaryKey CustomerT Identity

type Product = ProductT Identity
type ProductId = PrimaryKey ProductT Identity

type Order = OrderT Identity
type OrderId = PrimaryKey OrderT Identity

type OrderItem = OrderItemT Identity
type OrderItemId = PrimaryKey OrderItemT Identity

deriving instance Show Product
deriving instance Eq Product

deriving instance Show ProductId
deriving instance Eq ProductId

deriving instance Show Order
deriving instance Eq Order

deriving instance Show OrderId
deriving instance Eq OrderId

deriving instance Show OrderItem
deriving instance Eq OrderItem

deriving instance Show OrderItemId
deriving instance Eq OrderItemId

deriving instance Show Customer
deriving instance Eq Customer
deriving instance Show CustomerId
deriving instance Eq CustomerId

deriving instance Show Category
deriving instance Eq Category
deriving instance Show CategoryId
deriving instance Eq CategoryId

instance Table CustomerT where
    data PrimaryKey CustomerT f = CustomerId (Columnar f Int32)
        deriving (Generic,Beamable)
    primaryKey = CustomerId . _customerId

instance Table CategoryT where
    data PrimaryKey CategoryT f = CategoryId (Columnar f Int32)
        deriving (Generic,Beamable)
    primaryKey = CategoryId . _categoryId

instance Table ProductT where
    data PrimaryKey ProductT f = ProductId (Columnar f Int32)
        deriving (Generic,Beamable)
    primaryKey = ProductId . _productId

instance Table OrderT where
    data PrimaryKey OrderT f = OrderId (Columnar f Int32)
        deriving (Generic,Beamable)
    primaryKey = OrderId . _orderId

instance Table OrderItemT where
    data PrimaryKey OrderItemT f = OrderItemId (Columnar f Int32)
        deriving (Generic,Beamable)
    primaryKey = OrderItemId . _orderItemId

-- Database


-- database Structure
data Db f = Db {
    _customer :: f (TableEntity CustomerT)
  , _category :: f (TableEntity CategoryT)
  , _product :: f (TableEntity ProductT)
  , _order :: f (TableEntity OrderT)
  , _orderItem :: f (TableEntity OrderItemT)
} deriving (Generic,Database be)

db :: DatabaseSettings be Db
db = defaultDbSettings `withDbModification` dbModification {
    _customer = setEntityName "customer" <> modifyTableFields tableModification {
        _customerId = "customer_id"
      , _firstName  = "first_name"
      , _lastName   = "last_name"
      , _email      = "email"
      , _createdAt  = "created_at"
    }
  , _category = setEntityName "category" <> modifyTableFields tableModification {
        _categoryId = "category_id"
      , _categoryName = "category_name"
  }
  , _product = setEntityName "product" <> modifyTableFields tableModification {
        _productId = "product_id"
      , _productName = "product_name"
      , _categoryIdForProduct = CategoryId "category_id"
      , _price = "price"
  }
  , _order = setEntityName "order" <> modifyTableFields tableModification {
        _orderId = "order_id"
      , _customerIdForOrder = CustomerId "customer_id"
      , _orderDate = "order_date"
      , _totalAmount = "total_amount"
  }
  , _orderItem = setEntityName "order_item" <> modifyTableFields tableModification {
        _orderItemId = "order_item_id"
      , _orderIdForOrderItem = OrderId "order_id"
      , _productIdForOrderItem = ProductId "product_id"
      , _quantity = "quantity"
      , _unitPrice = "unit_price"
  }
}

{-
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
-}
