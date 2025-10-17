-- Part 1. Создание базы данных
-- Напишите скрипт part1.sql, создающий базу данных и таблицы, описанные выше в разделе входные данные. (+)

-- Также внесите в скрипт процедуры, позволяющие импортировать и экспортировать данные для каждой таблицы из файлов/в файлы с расширением .csv и .tsv.
-- В качестве параметра каждой процедуры для импорта из csv файла указывается разделитель. (Готов импорт для tsv, но надо разобраться с пробелами в имени и фамилии)

-- В каждую из таблиц внесите как минимум по 5 записей. По мере выполнения задания вам потребуются новые данные, чтобы проверить все варианты работы. Эти новые данные также должны быть добавлены в этом скрипте.
-- Некоторые тестовые данные могут быть найдены в папке datasets. (Не делал)

-- Если для добавления данных в таблицы использовались csv или tsv файлы, они также должны быть выгружены в GIT репозиторий. (Когда будет репозиторий)


CREATE TABLE IF NOT EXISTS PersonalInformation ( -- нужно разобраться с пробелами в имени и фамилии
	Customer_ID BIGINT PRIMARY KEY,
	Customer_Name VARCHAR NOT NULL CHECK (Customer_Name ~ '^[A-ZА-ЯЁ][a-zа-яё-]+$'),
	Customer_Surname VARCHAR NOT NULL CHECK (Customer_Surname ~ '^[A-ZА-ЯЁ][a-zа-яё-]+$'), 
	Customer_Primary_Email VARCHAR NOT NULL CHECK (Customer_Primary_Email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$'),
	Customer_Primary_Phone VARCHAR NOT NULL CHECK (Customer_Primary_Phone ~ '^\+7[0-9]{10}$')
);

CREATE TABLE IF NOT EXISTS Cards (
	Customer_Card_ID BIGINT PRIMARY KEY,
	Customer_ID BIGINT NOT NULL REFERENCES PersonalInformation(Customer_ID)
);

CREATE TABLE IF NOT EXISTS SKUGroup (
	Group_ID BIGINT PRIMARY KEY,
	Group_Name VARCHAR NOT NULL CHECK (Group_Name ~ '^[A-ZА-ЯЁa-zа-яё0-9\s\-,.:;!?''"()$@%#&*+=/\\]+$')
);

CREATE TABLE IF NOT EXISTS ProductGrid (
	SKU_ID BIGINT PRIMARY KEY,
	SKU_Name VARCHAR NOT NULL CHECK (SKU_Name ~ '^[A-ZА-ЯЁa-zа-яё0-9\s\-,.:;!?''"()$@%#&*+=/\\]+$'), 
	Group_ID BIGINT NOT NULL REFERENCES SKUGroup(Group_ID)
);

CREATE TABLE IF NOT EXISTS Stores (
	Transaction_Store_ID BIGINT NOT NULL,
	SKU_ID BIGINT NOT NULL REFERENCES ProductGrid(SKU_ID),
	SKU_Purchase_Price DECIMAL NOT NULL,
	SKU_Retail_Price DECIMAL NOT NULL
);

CREATE TABLE IF NOT EXISTS Transactions (
	Transaction_ID BIGINT PRIMARY KEY,
	Customer_Card_ID BIGINT NOT NULL REFERENCES Cards(Customer_Card_ID),
	Transaction_Summ DECIMAL NOT NULL,
	Transaction_DateTime TIMESTAMP NOT NULL CHECK (TO_CHAR(Transaction_DateTime, 'DD.MM.YYYY HH24:MI:SS'::TEXT) ~ '^[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}$'),
	Transaction_Store_ID BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS Checks (
	Transaction_ID BIGINT NOT NULL REFERENCES Transactions(Transaction_ID),
	SKU_ID BIGINT NOT NULL REFERENCES ProductGrid(SKU_ID),
	SKU_Amount DECIMAL NOT NULL,
	SKU_Summ DECIMAL NOT NULL,
	SKU_Summ_Paid DECIMAL NOT NULL,
	SKU_Discount DECIMAL NOT NULL
);

CREATE TABLE IF NOT EXISTS DateOfAnalysisFormation (
	Analysis_Formation TIMESTAMP PRIMARY KEY CHECK (TO_CHAR(Analysis_Formation, 'DD.MM.YYYY HH24:MI:SS'::TEXT) ~ '^[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}$')
);

CREATE OR REPLACE PROCEDURE prc_import(table_name VARCHAR, path VARCHAR, delimiter VARCHAR)
LANGUAGE plpgsql AS
$$
BEGIN
    EXECUTE FORMAT('COPY %s FROM %L WITH DELIMITER %L CSV', table_name, path, delimiter);
END;
$$;

SET dataset_path.const TO 'C:\Users\3svet\Desktop\Retail\database\';
SET datestyle = 'ISO, DMY';

CALL prc_import('PersonalInformation', current_setting('dataset_path.const')||'Personal_Data.tsv', E'\t');
CALL prc_import('Cards', current_setting('dataset_path.const')||'Cards.tsv', E'\t');
CALL prc_import('SKUGroup', current_setting('dataset_path.const')||'Groups_SKU.tsv', E'\t');
CALL prc_import('ProductGrid', current_setting('dataset_path.const')||'SKU.tsv', E'\t');
CALL prc_import('Stores', current_setting('dataset_path.const')||'Stores.tsv', E'\t');
CALL prc_import('Transactions', current_setting('dataset_path.const')||'Transactions.tsv', E'\t');
CALL prc_import('Checks', current_setting('dataset_path.const')||'Checks.tsv', E'\t');
CALL prc_import('DateOfAnalysisFormation', current_setting('dataset_path.const')||'Date_Of_Analysis_Formation.tsv', E'\t');





DROP TABLE IF EXISTS PersonalInformation CASCADE;
DROP TABLE IF EXISTS Cards CASCADE;
DROP TABLE IF EXISTS Checks CASCADE;
DROP TABLE IF EXISTS DateOfAnalysisFormation CASCADE;
DROP TABLE IF EXISTS ProductGrid CASCADE;
DROP TABLE IF EXISTS SKUGroup CASCADE;
DROP TABLE IF EXISTS Stores CASCADE;
DROP TABLE IF EXISTS Transactions CASCADE;
DROP PROCEDURE IF EXISTS prc_import(table_name VARCHAR, path VARCHAR);

select * from PersonalInformation;
select * from Cards;
select * from SKUGroup;
select * from ProductGrid;
select * from Stores;
select * from Transactions;
select * from Checks;
select * from DateOfAnalysisFormation;
