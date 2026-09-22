-- ============================================================
-- Project 3: SQL Data Analysis
-- Dataset: orders (1,200 rows)
-- Columns: OrderID, OrderDate, CustomerID, Product, Quantity,
--          UnitPrice, ShippingAddress, PaymentMethod,
--          OrderStatus, TrackingNumber, ItemsInCart,
--          CouponCode, ReferralSource, TotalPrice
-- ============================================================

-- 1. Basic SELECT + WHERE: filter rows by category
SELECT OrderID, Product, Quantity, TotalPrice
FROM orders
WHERE Product = 'Laptop';

-- 2. WHERE with a comparison operator: high-value orders
SELECT OrderID, Product, TotalPrice
FROM orders
WHERE TotalPrice > 2000;

-- 3. ORDER BY: sort by total price, highest first
SELECT OrderID, Product, TotalPrice
FROM orders
ORDER BY TotalPrice DESC;

-- 4. GROUP BY + COUNT: number of orders per product
SELECT Product, COUNT(*) AS OrderCount
FROM orders
GROUP BY Product
ORDER BY OrderCount DESC;

-- 5. GROUP BY + SUM: total revenue per product
SELECT Product, SUM(TotalPrice) AS TotalRevenue
FROM orders
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 6. GROUP BY + AVG: average order value by payment method
SELECT PaymentMethod, ROUND(AVG(TotalPrice), 2) AS AvgOrderValue
FROM orders
GROUP BY PaymentMethod
ORDER BY AvgOrderValue DESC;

-- 7. HAVING: filter on an aggregated value (can't do this with WHERE,
--    since WHERE runs before GROUP BY/aggregates are computed)
SELECT Product, COUNT(*) AS OrderCount, SUM(TotalPrice) AS Revenue
FROM orders
GROUP BY Product
HAVING SUM(TotalPrice) > 100000
ORDER BY Revenue DESC;

-- 8. WHERE + GROUP BY combined: referral sources for delivered orders only
SELECT ReferralSource, COUNT(*) AS Orders
FROM orders
WHERE OrderStatus = 'Delivered'
GROUP BY ReferralSource
ORDER BY Orders DESC;

-- 9. Percentage contribution per product (subquery for grand total)
SELECT Product,
       SUM(TotalPrice) AS Revenue,
       ROUND(100.0 * SUM(TotalPrice) / (SELECT SUM(TotalPrice) FROM orders), 2) AS PctOfTotalRevenue
FROM orders
GROUP BY Product
ORDER BY Revenue DESC;

-- 10. Monthly revenue trend (date bucketed to year-month)
SELECT strftime('%Y-%m', OrderDate) AS Month,
       COUNT(*) AS Orders,
       SUM(TotalPrice) AS Revenue
FROM orders
GROUP BY Month
ORDER BY Month;

-- 11. Order status breakdown with % of total orders
SELECT OrderStatus,
       COUNT(*) AS Orders,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS PctOfOrders
FROM orders
GROUP BY OrderStatus
ORDER BY Orders DESC;
