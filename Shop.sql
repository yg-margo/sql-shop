
/* ------------------------------------------------ */

-- == DDL операции == --

/* ------------------------------------------------ */

-- создание базы данных shop
CREATE SCHEMA `shop` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;

/*
отобразить все базы данных (bash)
show databases;
*/

/*
работать с указанной базой данных (bash)
(после выполнения этой команды вместо `shop`.`category` можно будет писать просто category)
use shop;
*/

-- создание таблицы "категория товаров"
CREATE TABLE `shop`.`category` (
  `id` INT NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `discount` TINYINT NOT NULL,
  PRIMARY KEY (`id`)
);

-- добавление нового столбца
ALTER TABLE `shop`.`category` ADD COLUMN `alias_name` VARCHAR(128) NULL AFTER `discount`;

-- посмотреть структуру таблицы
SHOW COLUMNS FROM category;

-- удалить таблицу имяБД имяТаблицы
DROP TABLE `shop`.`category`;

-- удалить базу данных имяБД
DROP DATABASE `shop`;

/*
добавляем внешний связанный ключ (ключевое слово CONSTRAINT)
таблица 'product' теперь будет иметь 'foreign key' (поле 'brand_id') связанный с таблицей 'brand' (поле 'id')
*/
ALTER TABLE `shop`.`product`
  ADD CONSTRAINT `fk_brand_product` -- ADD `col_name` VARCHAR(100) | CHANGE `col_name_old` `col_name_new` | MODIFY `col_name` VARCHAR(200)| DROP `col_name`
  FOREIGN KEY (`brand_id`)
  REFERENCES `shop`.`brand` (`id`)
  ON DELETE CASCADE -- CASCADE (при удалении родительского id - будут удалятся все дочерние связанные по ключу строки)
  ON UPDATE NO ACTION; -- RESTRICT | CASCADE | SET NULL | NO ACTION

/* ------------------------------------------------ */
/* ------------------------------------------------ */
/* ------------------------------------------------ */

-- == DML операции (CRUD) == --

/* ------------------------------------------------ */
/* ------------------------------------------------ */
/* ------------------------------------------------ */

-- == INSERT (CREATE операция) == --

/* ------------------------------------------------ */

INSERT INTO category (id, name, discount, alias_name) VALUES (3, 'Женская обувь', 10, NULL);

INSERT INTO category (id, name, discount, alias_name) VALUES (4, 'Мужская обувь', 15, 'man''s shoes');

INSERT INTO category (name, discount) VALUES ('Шляпы', 0);

-- Добавить новый бренд "Тетя Клава Company"
INSERT INTO category (name, discount) VALUES ('Тетя Клава Company', 0);

/* ------------------------------------------------ */
/* ------------------------------------------------ */
/* ------------------------------------------------ */

-- == SELECT (READ операция) == --

/* ------------------------------------------------ */

-- вывести все категории товаров
SELECT * FROM category;

/* ------------------------------------------------ */

-- == WHERE (СЕЛЕКТИВНЫЙ ПОИСК) == --

/* ------------------------------------------------ */

-- вывести категорию товаров с идентификатором, равным 3
SELECT * FROM category WHERE id = 3;

-- вывести категории товаров, у которых скидка не равна 0
SELECT * FROM category WHERE discount <> 0;

-- вывести категории товаров, у которых скидка больше 5
SELECT * FROM category WHERE discount > 5;

-- вывести категории товаров, у которых скидка больше 5 и меньше 15
SELECT * FROM category WHERE (discount > 5) AND (discount < 15);

-- вывести категории товаров, у которых скидка меньше 5 или больше или равен 10
SELECT * FROM category WHERE (discount < 5) OR (discount >= 10);

-- вывести категории товаров, у которых скидка не меньше 5
SELECT * FROM category WHERE NOT (discount < 5);

-- вывести категории товаров, у которых есть псевдоним
SELECT * FROM category WHERE alias_name IS NOT NULL;

-- вывести категории товаров, у которых нет псевдонима
SELECT * FROM category WHERE alias_name IS NULL;

-- вывести все поля из таблицы Категории у элементов с id 1 2 3
SELECT * FROM category WHERE id = 1 OR id = 2 OR id = 3;
SELECT * FROM category WHERE id >= 1 AND id <= 3;
SELECT * FROM category WHERE id IN (1, 2, 3);

/* ------------------------------------------------ */

-- == SELECT <столбец> (вывести только ВЫБРАННЫЕ ПОЛЯ) == --

/* ------------------------------------------------ */

-- вывести названя всех категорий товаров
SELECT name FROM category;

-- вывести названя и скидки товаров
SELECT discount, name  FROM category;

-- вывести все скидки
SELECT discount FROM category;

-- Получить название бренда с идентификатором 3
SELECT name FROM brand WHERE id = 3;

/* ------------------------------------------------ */

-- == DISTINCT (вывести только УНИКАЛЬНЫЕ ЗНАЧЕНИЯ указанных полей, повторы будут отброшены) == --

/* ------------------------------------------------ */

-- вывести все уникальные значения скидок
SELECT DISTINCT discount FROM category;

/* ------------------------------------------------ */

-- == ORDER BY (СОРТИРОВКА ПО ВОЗРАСТАНИЮ, прямой порядок, ASC по умолчанию, можно не указывать) == --

/* ------------------------------------------------ */

-- вывести все категории товаров, и отсортировать их по размеру скидки
SELECT * FROM category ORDER BY discount;

-- тоже самое
SELECT * FROM category ORDER BY discount ASC;

/*
Получить все категории товаров со скидкой < 10%, и отсортировать их по названию
Порядок слов важен: 1. WHERE, 2. ORDER BY, 3. ASC (можно не указывать)
*/
SELECT * FROM category WHERE discount < 10 ORDER BY name;

/* ------------------------------------------------ */

-- == ORDER BY + DESC (СОРТИРОВКА ПО УБЫВАНИЮ, обратный порядок, DESC надо указывать явно) == --

/* ------------------------------------------------ */

-- вывести все категории товаров, и отсортировать их по размеру скидки в обратном порядке
SELECT * FROM category ORDER BY discount DESC;

/*
вывести все категории товаров с ненулевой скидкой, и отсортировать их по размеру скидки в обратном порядке
Порядок слов важен: 1. WHERE, 2. ORDER BY, 3. DESC
*/
SELECT * FROM category WHERE discount <> 0 ORDER BY discount DESC;

/* ------------------------------------------------ */

-- == LIMIT (ЛИМИТЫ) == --

/* ------------------------------------------------ */

/*
LIMIT принимает 1 или 2 аргумента
Если аргумент 1 - это значит сколько всего надо вывести
Если аргумента 2 - это значит: пропусти столько и выведи столько (удобно для пагинации)
*/

-- вывести первые 2 категории товара
SELECT * FROM category LIMIT 2;

/*
вывести первые 2 категории товара со скидкой не равной нулю
Порядок слов важен: 1. WHERE, 2. LIMIT
*/
SELECT * FROM category WHERE discount <> 0 LIMIT 2;

-- Получить первые 2 типа товара
SELECT * FROM product_type LIMIT 2;

-- Вернуть 5 самых новых статей (с наибольшим id)
SELECT * FROM articles ORDER BY id DESC LIMIT 5;

/*
PAGINATION
Пагинация: условие - на каждой странице по 5 новостей
*/

-- Вернуть 5 самых новых статей, страница 1
SELECT * FROM articles ORDER BY id DESC LIMIT 0, 5;
-- Вернуть 5 самых новых статей, страница 2
SELECT * FROM articles ORDER BY id DESC LIMIT 5, 5;

/* ------------------------------------------------ */
/* ------------------------------------------------ */
/* ------------------------------------------------ */

-- == JOIN (Объединение таблиц) == --

/* ------------------------------------------------ */

/*
Операторы:
INNER JOIN (рекомендуется)
В запрос попадет только пересечение таблиц
LEFT JOIN / RIGHT JOIN
1. в запрос попадет вся первая таблица + пересечения с другими
2. в запрос попадет вся последняя таблица + пересечения с другими
Поля, для которых не нашлось соответствия, будут заполнены NULL
FULL OUTER JOIN
(в MySQL така команда отсутствует, но есть UNION)
В запрос попадет вообще всё, даже если какие-то поля не имеют соответствия в других таблицах
Поля, для которых не нашлось соответствия, будут заполнены NULL
UNION
Склеивание нескольких запросов в один ответ
*/

/* ------------------------------------------------ */

-- == INNER JOIN (результат: пересечение таблиц) == --

/* ------------------------------------------------ */

-- получаем единую таблицу (из 2х), в начале идет "product" , затем ее полям соответствует "category"
SELECT * FROM product
  INNER JOIN category ON product.category_id = category.id;

-- тот же запрос, но с выводом выборочных полей из объединенной таблицы (с уточнением какое поле из какой таблицы)
SELECT product.id, product.price, category.name FROM product
  INNER JOIN category ON product.category_id = category.id;

-- подобный запрос, но сперва идет "category" и к ней приклеивается "product"
SELECT * FROM category
  INNER JOIN product ON category.id = product.category_id;

-- подобный запрос, фильтруем по значению поля "discount" (эти ограничения действуют сразу на все объединяемые таблицы)
SELECT * FROM product
  INNER JOIN category ON product.category_id = category.id
  WHERE discount <= 5;

-- подобный запрос, фильтруем по значению поля "price"
SELECT * FROM product
  INNER JOIN category ON product.category_id = category.id
  WHERE price < 10000;

-- объединям сразу 4 таблицы (все, что естьЫ)
SELECT * FROM product
  INNER JOIN category ON category.id = product.category_id
  INNER JOIN brand ON brand.id = product.brand_id
  INNER JOIN product_type ON product_type.id = product.product_type_id;

-- тот же запрос, но с выводом только указанных полей
SELECT product.id, brand.name, product_type.name, category.name, product.price FROM product
  INNER JOIN category ON category.id = product.category_id
  INNER JOIN brand ON brand.id = product.brand_id
  INNER JOIN product_type ON product_type.id = product.product_type_id;

/*
тот же запрос, но с алиасами
в противном случае будет 3 столбца name, взятых из разных таблиц, c разным контентом
еще и фильтр по типу продукта добавили
*/
SELECT
  product.id as id,
  brand.name as brand,
  product_type.name as type,
  category.name as category,
  product.price as price
  FROM product
  INNER JOIN category ON category.id = product.category_id
  INNER JOIN brand ON brand.id = product.brand_id
  INNER JOIN product_type ON product_type.id = product.product_type_id
  WHERE product_type.id = 2;

/* ------------------------------------------------ */

-- == LEFT JOIN / RIGHT JOIN == --

/* ------------------------------------------------ */

-- в запрос попадет всё из "category" + пересечение с "product"
SELECT * FROM category
  LEFT JOIN product ON product.category_id = category.id;

-- тоже самое + фильтр, где только строки с NULL
SELECT * FROM category
  LEFT JOIN product ON product.category_id = category.id
  WHERE product.id is null;

/*
так выведет все поля только из "category" (без полей с NULL из "product")
по сути в этом запросе мы увидим все строки из "category", которым не нашлось соответствия в "product"
фильтрация "от обратного"
*/
SELECT category.* FROM category
  LEFT JOIN product ON product.category_id = category.id
  WHERE product.id is null;

-- тоже самое, только наоборот - увидим все строки из "product", которым не нашлось соответствия в "category"
SELECT * FROM category
  RIGHT JOIN product ON product.category_id = category.id
  WHERE product.id is null;

-- вывести все типы товаров, для которых нет ни одного товара в нашем интернет-магазине
SELECT product_type.* FROM product_type
  LEFT JOIN product ON product.pdoduct_type_id = product_type.id
  WHERE product.id is null;

-- вывести товары, которые не попали ни в один из заказов
SELECT product.* FROM `order`
  INNER JOIN order_products ON order_products.order_id = `order`.id
  RIGHT JOIN product ON order_products.product_id = product.id
  WHERE `order`.id is null;

/* ------------------------------------------------ */

-- == UNION (Объединение запросов) == --

/* ------------------------------------------------ */

-- 2 разных запроса, результаты которых объеденены в одном ответе
SELECT * FROM product_type WHERE id = 1
UNION
SELECT * FROM product_type WHERE id = 2;

/*
Эмуляция FULL OUTER JOIN в MySQL через UNION:
- сначала идут все заказы на товары
- затем заказы без товаров
- затем товары без заказов
*/
SELECT * FROM `order`
  LEFT JOIN order_products ON order_products.order_id = `order`.id
  LEFT JOIN product ON order_products.product_id = product.id
  UNION
  SELECT * FROM `order`
  INNER JOIN order_products ON order_products.order_id = `order`.id
  RIGHT JOIN product ON order_products.product_id = product.id
  WHERE `order`.id is null;

-- если FULL OUTER JOIN базой поддерживается (PostgreSQL, MSSQL), то такой же запрос выглядит так
SELECT * FROM `order`
  FULL OUTER JOIN order_products ON order_products.order_id = `order`.id
  FULL OUTER JOIN product ON order_products.product_id = product.id;

/* ------------------------------------------------ */
/* ------------------------------------------------ */
/* ------------------------------------------------ */

-- == Агрегирующие функции == --

/* ------------------------------------------------ */

/*
Агрегирующие функции позволяют вычислить некое собирательное значение
(сумма, среднее, количество, максимальное, минимальное)
для заданных групп строк по колонке
Примеры операторов-функций:
COUNT
SUM
MAX
MIN
Полный список функций, которые поддерживаются MySQL
https://dev.mysql.com/doc/refman/5.7/en/group-by-functions.html
*/

-- вернет количество всех строк
SELECT count(*) FROM product;

-- вернет количество строк прошедших через фильтр-селектор
SELECT count(*) FROM product WHERE product.price < 10000;

/*
вернет одну строку с 3-мя полями с вычисленными значениями по всем строкам,
данные берутся только из столбца "price"
*/
SELECT sum(price) as total_price, min(price) as min_price, max(price) as max_price FROM product;

/*
пример без агрегирующей функции
в этом случае в каждой строке поле "price" * поле "count" и возвращается как приклеенное новое поле "total_price"
вернет несколько строк, если их больше 1
*/
SELECT *, price * `count` as total_price FROM `order`
  INNER JOIN order_products ON order_products.order_id = `order`.id
  INNER JOIN product ON product.id = order_products.product_id
  WHERE `order`.id = 1;

/*
в этом случае агрегирующая функция суммирует сперва умноженные результаты
и возвращает итоговую единственную строку с общей суммой всех построчных выражений умножения 
*/
SELECT sum(price * `count`) as total_price FROM `order`
  INNER JOIN order_products ON order_products.order_id = `order`.id
  INNER JOIN product ON product.id = order_products.product_id
  WHERE `order`.id = 2;

/* ------------------------------------------------ */

-- == GROUP BY (ГРУППРИРОВКА по указанному полю) == --

/* ------------------------------------------------ */

/*
Eсли значение указанного поля повторяется в следующих строках, то происходит группировка (слияние).
2 обязательных правила для группировки:
1. Указать поле для группировки (оно же должно обязательно присутствовать и в SELECT как поле для вывода)
2. Для остальных выводимых полей обязательно использовать агрегирующую функцию
*/

/*
в этом запросе группировка проходит по полю "`order`.user_name"
для остальных полей - "price" и "count" - вызвана агрегирующая функция,
которая выводит результат в поле "total_price"
*/
SELECT `order`.user_name, sum(price * `count`) as total_price  FROM `order`
  INNER JOIN order_products ON order_products.order_id = `order`.id
  INNER JOIN product ON product.id = order_products.product_id
  GROUP BY `order`.user_name;

/*
этот запрос имеет на выходе 3 поля:
1. групприрует по имени
2. выводит максимальную стоимость одной единицы товара
3. выводит общее количество всех едениц товаров в заказе
*/
SELECT `order`.user_name, max(price) as max_price, sum(`count`) as total_count FROM `order`
  INNER JOIN order_products ON order_products.order_id = `order`.id
  INNER JOIN product ON product.id = order_products.product_id
  GROUP BY `order`.user_name;

/* ------------------------------------------------ */

-- == HAVING (это WHERE для результатов агрегирующих функций) == --

/* ------------------------------------------------ */

/*
HAVING используется в конце, после GROUP BY (вместо WHERE) для уточнения запроса.
Дело в том, что WHERE не может уточнять значения возвращаемые из агрегирующиx функций
(здесь это поля "max_price" и "order_count").
Использование WHERE для фильтации/уточнения "max_price" и "order_count" вызовет ошибку!
А HAVING может уточнять значения возвращаемые из агрегирующиx функций - он для этого и придуман.
*/

/*
этот запрос имеет на выходе 3 поля:
1. групприрует по имени
2. выводит максимальную стоимость одной единицы товара
3. выводит общее количество всех едениц товаров в заказе, если товаров >= 5
*/
SELECT `order`.user_name, max(price) as max_price, sum(`count`) as order_count FROM `order`
  INNER JOIN order_products ON order_products.order_id = `order`.id
  INNER JOIN product ON product.id = order_products.product_id
  -- WHERE user_name = 'Василий' -- выведет всех пользователей, с именем "Василий"
  -- WHERE user_name like 'В%' -- выведет всех пользователей, начинающихся на "В", % - дальше идет любая буква, одна или несколько
  GROUP BY `order`.user_name
  HAVING order_count >= 5;

/* ------------------------------------------------ */
/* ------------------------------------------------ */
/* ------------------------------------------------ */

-- == UPDATE (UPDATE операция) == --

/* ------------------------------------------------ */

-- в таблице Категории обновить значение поля Имя с "Шапки" на "Головные уборы" у элемента с id 5
UPDATE category SET name = 'Головные уборы' WHERE id = 5;

-- в таблице Категории обновить значение поля Скидки с 0 на 5 у элементов с id 2 и 5
UPDATE category SET discount = 3 WHERE id = 2 OR id = 5;

-- тоже самое, но короче и удобней
UPDATE category SET discount = 3 WHERE id IN ( 2 , 5 );

-- С помощью команды UPDATE заполнить alias_name для всех категорий

UPDATE category SET alias_name = 'women''s clothing' WHERE id = 1;

UPDATE category SET alias_name = 'man''s clothing' WHERE id = 2;

UPDATE category SET alias_name = 'women''s shoes' WHERE id = 3;

/* ------------------------------------------------ */

-- == TRANSACTION (транзакция - единый блок операций обновления) == --

/* ------------------------------------------------ */

INSERT INTO `shop`.`user_bank_account` (id, money, user_name) VALUES ('1', '100', 'Дмитрий');
INSERT INTO `shop`.`user_bank_account` (id, money, user_name) VALUES ('2', '200', 'Евгений');

SELECT * FROM `shop`.`user_bank_account`;

/*
TRANSACTION (транзакция)
Выполняется или весь блок команд обновления целиком (как единая команда) , или ни одной.
Свойства транзакции (ACID)
Atomicity - атомарность
Выполнится или весь блок команд или ни одной.
Consistency - согласованность
После окончания транзакции данные в базе должны отсаться в согласованном состоянии,
т.е. суммарное количество денег в банке после совершения операции-транзакции не должно измениться.
Isolation - изолированность
Если транзакция начала выполняться, то ничто не сможет ей помешать.
Если к одним данным приходит одновременно транзакция и др. sql-запрос,
то сначала полностью выполняется транзакция, а потом будут обрабатываться другие sql-запросы.
Durability - долговечность
Если после окончания транзакции произошел сбой,
то все изменения, что сделала транзакция, будут сохранены.
*/

-- В данной транзакции со счета Юзера1 спиывается 100 денег, и эти же 100 денег записываются на счет Юзера2
START TRANSACTION;
  UPDATE `shop`.`user_bank_account` SET money = money - 100 WHERE id = 1;
  UPDATE `shop`.`user_bank_account` SET money = money + 100 WHERE id = 2;
COMMIT;

/* ------------------------------------------------ */
/* ------------------------------------------------ */
/* ------------------------------------------------ */

-- == DELETE (DELETE операция) == --

/* ------------------------------------------------ */

-- удалить из таблицы Категории элемент с id 5
DELETE FROM category WHERE id = 5;

-- Удалить бренд с id 5
DELETE FROM category WHERE id = 5;