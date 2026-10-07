import sqlite3
from pathlib import  Path
import pandas as pd


def get_connection(database_path="task2_sales.db"):
    """Create and return a SQLite database connection."""
    return sqlite3.connect(database_path)


def run_query(database_path, query, params=None):
    """Run a SQL query and return the result as a DataFrame."""
    connection = get_connection(database_path)

    try:
        return pd.read_sql_query(
            query,
            connection,
            params=params
        )
    finally:
        connection.close()


def execute_query(database_path, query, params=None):
    """Execute INSERT, UPDATE, DELETE or DDL queries."""
    connection = get_connection(database_path)

    try:
        connection.execute(query, params or ())
        connection.commit()
    finally:
        connection.close()
