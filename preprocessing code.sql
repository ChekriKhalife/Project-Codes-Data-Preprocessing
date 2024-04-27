CREATE DATABASE olist;
Use olist;

-- Creation of 'category_name_translation' table
CREATE TABLE category_name_translation (
  product_category_name VARCHAR(100) NOT NULL,
  product_category_name_english VARCHAR(100) NOT NULL,
  PRIMARY KEY (product_category_name)
);


-- Creation of 'products' table with constraints and ON DELETE CASCADE
CREATE TABLE products (
  product_id VARCHAR(32) NOT NULL,
  product_category_name VARCHAR(100),
  product_name_length INT NOT NULL,
  product_description_length INT,
  product_photos_qty INT,
  product_weight_g FLOAT,
  product_length_cm FLOAT,
  product_height_cm FLOAT,
  product_width_cm FLOAT,
  PRIMARY KEY (product_id),
  FOREIGN KEY (product_category_name) REFERENCES category_name_translation(product_category_name) ON DELETE CASCADE,
  CHECK (CHAR_LENGTH(product_id) = 32)
);

-- Create Customers Table with constraints and ON DELETE CASCADE
CREATE TABLE customers (
  customer_perorder_id VARCHAR(32) NOT NULL,
  customer_unique_id VARCHAR(32) NOT NULL,
  customer_zip_code_prefix INT NOT NULL,
  customer_city VARCHAR(50) NOT NULL,
  customer_state VARCHAR(2) NOT NULL,
  PRIMARY KEY (customer_perorder_id),
  CHECK (CHAR_LENGTH(customer_perorder_id) = 32),
  CHECK (CHAR_LENGTH(customer_unique_id) = 32)
);

-- Create Orders Table with constraints and ON DELETE CASCADE
CREATE TABLE orders (
  order_id VARCHAR(32) NOT NULL,
  customer_perorder_id VARCHAR(32) NOT NULL,
  order_status VARCHAR(15) NOT NULL,
  order_purchase_timestamp DATETIME NOT NULL,
  order_approved_at DATETIME,
  order_delivered_carrier_date DATETIME,
  order_delivered_customer_date DATETIME,
  order_estimated_delivery_date DATETIME NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_perorder_id) REFERENCES customers(customer_perorder_id) ON DELETE CASCADE,
  CHECK (CHAR_LENGTH(order_id) = 32),
  CHECK (CHAR_LENGTH(customer_perorder_id) = 32),
  CHECK (order_approved_at IS NULL OR (order_approved_at > order_purchase_timestamp AND order_approved_at < order_delivered_carrier_date)),
  CHECK (order_delivered_carrier_date IS NULL OR (order_delivered_carrier_date > order_purchase_timestamp AND order_delivered_carrier_date < order_delivered_customer_date))
);

-- Create Sellers Table with constraints and ON DELETE CASCADE
CREATE TABLE sellers (
  seller_id VARCHAR(32) NOT NULL,
  seller_zip_code_prefix INT NOT NULL,
  seller_city VARCHAR(50) NOT NULL,
  seller_state VARCHAR(2) NOT NULL,
  PRIMARY KEY (seller_id),
  CHECK (CHAR_LENGTH(seller_id) = 32)
);

-- Create Order Items Table with 'ON DELETE CASCADE' and length checks
CREATE TABLE order_items (
  order_id VARCHAR(32) NOT NULL,
  item_number INT NOT NULL,
  product_id VARCHAR(32) NOT NULL,
  seller_id VARCHAR(32) NOT NULL,
  shipping_limit_date DATETIME NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  freight_value DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (order_id, item_number),
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  FOREIGN KEY (seller_id) REFERENCES sellers(seller_id) ON DELETE CASCADE,
  CHECK (CHAR_LENGTH(order_id) = 32),
  CHECK (CHAR_LENGTH(product_id) = 32),
  CHECK (CHAR_LENGTH(seller_id) = 32)
);

-- Create Order Payments Table with 'ON DELETE CASCADE' and length check
CREATE TABLE order_payments (
  order_id VARCHAR(32) NOT NULL,
  payment_sequential INT NOT NULL,
  payment_type VARCHAR(15) NOT NULL,
  payment_installments INT NOT NULL,
  payment_value DECIMAL(10, 2),
  PRIMARY KEY (order_id, payment_sequential),
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  CHECK (CHAR_LENGTH(order_id) = 32)
);

-- Create Order Reviews Table with constraints
CREATE TABLE order_reviews (
  review_id VARCHAR(32) NOT NULL,
  order_id VARCHAR(32) NOT NULL,
  review_score INT NOT NULL,
  review_comment_title VARCHAR(255),
  processed_titles VARCHAR(255),
  review_comment_message TEXT,
  processed_messages TEXT,
  review_creation_date DATETIME NOT NULL,
  review_answer_timestamp DATETIME,
  PRIMARY KEY (review_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  CHECK (CHAR_LENGTH(review_id) = 32),
  CHECK (CHAR_LENGTH(order_id) = 32),
  CHECK (review_score BETWEEN 1 AND 5)
);
SELECT * from category_name_translation;
SELECT * from products;
SELECT * from customers;