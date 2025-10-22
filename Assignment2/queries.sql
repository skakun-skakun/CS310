USE HW2;

SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM order_items;

-- EXPLAIN ANALYZE
SELECT u.username, o.order_id, p.name, oi.quantity, p.price
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id IN (
    SELECT order_id FROM orders WHERE order_total > 100
)
AND p.category IN (
	SELECT category FROM products WHERE price > 50
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_total ON orders(order_total);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- EXPLAIN ANALYZE
WITH filtered_orders AS (
    SELECT order_id
    FROM orders
    WHERE order_total > 100
),
filtered_products AS (
    SELECT product_id
    FROM products
    WHERE price > 50
)
SELECT
       u.username, o.order_id, p.name, oi.quantity, p.price
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id IN (SELECT order_id FROM filtered_orders)
  AND p.product_id IN (SELECT product_id FROM filtered_products);