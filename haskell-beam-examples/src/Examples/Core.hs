{-# LANGUAGE TypeApplications #-}
module Examples.Core where

import Database.Beam
import Database.PostgreSQL.Simple
import Examples.Model
import Database.Beam.Postgres
import GHC.Int
import Data.Text (Text)

getConn :: ConnectInfo
getConn = defaultConnectInfo { connectHost = "localhost"
                             , connectUser = "tushar"
                                , connectPassword = "1234"
                                , connectDatabase = "sample_beam"
                            }

-- Fetch all columns from the customer table
-- SELECT * FROM customer;
fetchCustomerQ :: IO [Customer]
fetchCustomerQ =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ all_ (_customer db)

-- Fetch only the first name and email of customers
-- SELECT first_name, email FROM customer;
fetchFirstNameEmailQ :: IO [(Text, Text)]
fetchFirstNameEmailQ =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ do
                c <- all_ (_customer db)
                pure (_firstName c , _email c)

-- Fetch customers who have 'Doe' as their last name
-- SELECT * FROM customer WHERE last_name = 'Doe';
fetchCustomerByLastNameQ :: Text -> IO [Customer]
fetchCustomerByLastNameQ lastName =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ do
                c <- all_ (_customer db)
                guard_ (_lastName c ==. just_ (val_ lastName))
                pure c

-- Fetch all products ordered by price in descending order
-- SELECT * FROM product ORDER BY price DESC;
fetchProductOrderByPriceQ :: IO [Product]
fetchProductOrderByPriceQ =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ orderBy_ (desc_ . _price) $ all_ (_product db)

-- Fetch the top 5 most expensive products
-- SELECT * FROM product ORDER BY price DESC LIMIT 5;
fetchTop5ExpensiveProductsQ :: IO [Product]
fetchTop5ExpensiveProductsQ =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ orderBy_ (desc_ . _price) $ limit_ 5 $ all_ (_product db)

-- Fetch order count of the tabale
-- SELECT COUNT(*) FROM "order";
fetchOrderCount :: IO [Int32]
fetchOrderCount =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $
                aggregate_ (\_ -> as_ @Int32 countAll_) (all_ (_order db))

-- Fetch the total number of orders for each customer
-- SELECT customer_id, COUNT(order_id) AS order_count
-- FROM "order"
-- GROUP BY customer_id;
fetchTotalOrdersPerCustomer :: IO [(CustomerId, Int32)]
fetchTotalOrdersPerCustomer =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $
                aggregate_ (\o -> (group_ (_customerIdForOrder o), as_ @Int32 countAll_)) (all_ (_order db))

-- Find customers who have placed orders worth more than $500
-- SELECT first_name, last_name
-- FROM customer
-- WHERE customer_id IN (
--    SELECT customer_id
--    FROM "order"
--    WHERE total_amount > 500
-- );
fetchCustomersWithOrdersOver500 :: IO [( Text, Maybe Text)]
fetchCustomersWithOrdersOver500 =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ do
                c <- all_ (_customer db)
                o <- all_ (_order db)
                guard_ (CustomerId (_customerId c) ==. _customerIdForOrder o)
                guard_ (_totalAmount o >. val_ 500)
                pure (_firstName c, _lastName c)

fetchCustomersWithOrdersOver500UsingSubQuery :: IO [(Customer,Order)]
fetchCustomersWithOrdersOver500UsingSubQuery =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ do
                filter_ (\(c,o) -> CustomerId (_customerId c) ==. _customerIdForOrder o) $ do
                  c <- all_ (_customer db)
                  o <- filter_ (\o -> _totalAmount o >. 500) (all_ (_order db))
                  pure (c,o)

-- Get a list of all orders with customer names and product details
-- SELECT o.order_id, c.first_name, c.last_name, p.product_name, oi.quantity, oi.unit_price
-- FROM "order" o
-- JOIN customer c ON o.customer_id = c.customer_id
-- JOIN order_item oi ON o.order_id = oi.order_id
-- JOIN product p ON oi.product_id = p.product_id;
fetchOrderWithCustomerProduct :: IO [(Customer,Order,Product)]
fetchOrderWithCustomerProduct =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ do
                c <- all_ (_customer db)
                o <- join_ (_order db)
                    (\o -> _customerIdForOrder o ==. CustomerId (_customerId c))
                oi <- join_ (_orderItem db)
                    (\oi -> _orderIdForOrderItem oi ==. OrderId (_orderId o))
                p  <- join_ (_product db)
                    (\p -> _productIdForOrderItem oi ==. ProductId (_productId p))
                pure (c,o,p)

-- Fetch CustomerDetails with orders
-- SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.total_amount
-- FROM customer c
-- LEFT JOIN "order" o ON c.customer_id = o.customer_id;
fetchCustomersWithOrders :: IO [(Customer,Maybe Order)]
fetchCustomersWithOrders =
    withConnect getConn $ \conn ->
        runBeamPostgres conn $ runSelectReturningList $
            select $ do
                c <- all_ (_customer db)
                o <- leftJoin_ (all_ (_order db)) (\o -> _customerIdForOrder o `references_` c)
                pure (c,o)