import random
from datetime import datetime, timedelta

import mysql.connector
from faker import Faker
from dotenv import load_dotenv
import os

load_dotenv()


def generate_user_record(fake: Faker) -> tuple:
    name = fake.name()
    email = fake.email()
    return name, email, datetime.now()


def generate_order_record(*args) -> tuple:
    user_id = random.randint(1, 1000000)
    order_total = round(random.uniform(10.0, 1000.0), 2)
    return user_id, order_total, datetime.now()-timedelta(days=random.randint(0, 365))


def generate_product_record(fake: Faker) -> tuple:
    name = fake.word().title()
    price = round(random.uniform(5.0, 500.0), 2)
    category = fake.word().title()
    return name, price, category


def generate_order_items_record(*args) -> tuple:
    order_id = random.randint(1, 1000000)
    product_id = random.randint(1, 1000000)
    quantity = random.randint(1, 10)
    return order_id, product_id, quantity


def insert_smth(
    host: str,
    user: str,
    password: str,
    database: str,
    insert_query: str,
    generate_func: callable,
    total_rows: int = 1_000_000,
    batch_size: int = 10_000
) -> None:
    connection = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )
    cursor = connection.cursor()

    fake = Faker()

    for k in range(0, total_rows, batch_size):
        batch = [generate_func(fake) for _ in range(batch_size)]
        cursor.executemany(insert_query, batch)
        connection.commit()
        print(f"Inserted {min(k + batch_size, total_rows)} / {total_rows} rows")

    cursor.close()
    connection.close()
    print("✅ Data insertion complete!")


if __name__ == "__main__":
    for query, func in [
        ("""INSERT INTO users (name, email, created_at) VALUES (%s, %s, %s)""", generate_user_record),
        ("""INSERT INTO orders (user_id, order_total, order_date) VALUES (%s, %s, %s)""", generate_order_record),
        ("""INSERT INTO products (name, price, category) VALUES (%s, %s, %s)""", generate_product_record),
        ("""INSERT INTO order_items (order_id, product_id, quantity) VALUES (%s, %s, %s)""", generate_order_items_record)
    ]:
        insert_smth(
            host="localhost",
            user="root",
            password=os.getenv("PASS"),
            database="HW2",
            insert_query=query,
            generate_func=func,
            total_rows=1000000,
            batch_size=100000
        )
