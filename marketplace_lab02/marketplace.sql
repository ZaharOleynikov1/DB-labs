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