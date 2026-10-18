INSERT INTO users (fuul_name, email, phone, role)
SELECT
    'Пользователь ' || g,
    'lab_user_' || LPAD(g::TEXT, 3, '0') || '@example.com',
    '+7' || LPAD(g::TEXT, 10, '0'),
    CASE
        WHEN g <= 20 THEN 'seller'
        ELSE 'customer'
    END
FROM GENERATE_SERIES(1, 120) AS g;

INSERT INTO categories (name)
VALUES
	('Электроника'),
	('Дом и быт'),
	('Книги'),
	('Одежда'),
	('Спорт');

INSERT INTO categories (parent_id, name)
VALUES (
	(SELECT id
	FROM categories
	WHERE name = 'Электроника'),
	'Телефоны'
)

INSERT INTO categories (parent_id, name)
VALUES (
	(SELECT id
	FROM categories
	WHERE name = 'Дом и быт'),
	'Спальня'
)

INSERT INTO categories (parent_id, name)
VALUES (
	(SELECT id
	FROM categories
	WHERE name = 'Книги'),
	'Программирование'
)

INSERT INTO categories (parent_id, name)
VALUES (
	(SELECT id
	FROM categories
	WHERE name = 'Спорт'),
	'Тренажеры'
)

INSERT INTO sellers (user_id, store_name, description)
SELECT
    u.id,
    'Магазин №' || u.id,
    'Описание магазина №' || u.id
FROM users AS u
WHERE u.role = 'seller';

INSERT INTO addresses (user_id, city, street, house, apartment)
SELECT
    u.id,
    CASE
        WHEN u.id % 3 = 0 THEN 'Казань'
        WHEN u.id % 3 = 1 THEN 'Москва'
        ELSE 'Санкт-Петербург'
    END,
    CASE
        WHEN u.id % 2 = 0 THEN 'Ленина'
        ELSE 'Мира'
    END,
    (1 + u.id % 100)::TEXT,
    (1 + u.id % 200)::TEXT
FROM users AS u;

INSERT INTO products (
    seller_id,
    category_id,
    title,
    description,
    price,
    is_active
)
SELECT
    ((n - 1) % 20) + 1,
    ((n - 1) % 9) + 1,
    'Товар ' || n,
    'Описание товара ' || n,
    (100 + n)::DECIMAL(10,2),
    CASE
        WHEN n % 10 = 0 THEN FALSE
        ELSE TRUE
    END
FROM generate_series(1, 1200) AS gs(n);

INSERT INTO stock (
    product_id,
    quantity
)
SELECT
    id,
    1 + id % 100
FROM products;

INSERT INTO carts (user_id)
SELECT id
FROM users;

INSERT INTO cart_items (
    cart_id,
    product_id,
    quantity
)
SELECT
    c.id,
    p.id,
    1 + c.id % 3
FROM carts AS c
JOIN products AS p
    ON p.id BETWEEN (1000 + (c.id - 1) * 2 + 1)
                AND (1000 + c.id * 2);

INSERT INTO orders (
    user_id,
    status,
    total_amount
)
SELECT
    ((n - 1) % 120) + 1,
    CASE
        WHEN n % 4 = 0 THEN 'completed'
        WHEN n % 4 = 1 THEN 'pending'
        WHEN n % 4 = 2 THEN 'shipped'
        ELSE 'cancelled'
    END,
    0
FROM generate_series(1, 1000) AS gs(n);

INSERT INTO order_item (
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.id,
    p.id,
    2,
    p.price
FROM orders AS o
JOIN products AS p
    ON p.id = 1001 + ((o.id - 1) % 1200);

INSERT INTO payments (order_id, amound, status)
SELECT
    id,
    total_amount,
    'paid'
FROM orders
WHERE total_amount > 0;

INSERT INTO deliveries (
    order_id,
    address_id,
    delivery_status,
    delivery_date
)
SELECT
    o.id,
    a.id,
    'delivered',
    NOW()
FROM orders AS o
JOIN addresses AS a
    ON a.user_id = o.user_id;

INSERT INTO reviews (
    user_id,
    product_id,
    score,
    comment
)
SELECT
    u.id,
    p.id,
    3 + (u.id % 3),
    'Отзыв на товар'
FROM users AS u
JOIN products AS p
    ON p.id = 1001 + ((u.id - 1) % 1200);



SELECT DISTINCT
    title,
    price
FROM products
ORDER BY price;



SELECT
    id,
    title,
    price,
    is_active
FROM products
WHERE (price > 500 AND price < 1000)
   OR is_active = FALSE
ORDER BY price DESC;



SELECT
    id,
    title,
    price
FROM products
WHERE price BETWEEN 300 AND 700
ORDER BY price;

SELECT
    id,
    title,
    price
FROM products
WHERE price IN (150, 200, 300, 500)
ORDER BY price;

SELECT
    id,
    title,
    price
FROM products
WHERE title LIKE 'Товар%'
ORDER BY id
LIMIT 10;

SELECT
    id,
    title,
    description
FROM products
WHERE description IS NULL;



SELECT
    id,
    title,
    price,
    is_active
FROM products
ORDER BY
    is_active ASC,
    price DESC
LIMIT 20;



SELECT id, title, price
FROM products
ORDER BY id
LIMIT 10 OFFSET 0;

SELECT id, title, price
FROM products
ORDER BY id
LIMIT 10 OFFSET 10;

SELECT id, title, price
FROM products
ORDER BY id
LIMIT 10 OFFSET 20;