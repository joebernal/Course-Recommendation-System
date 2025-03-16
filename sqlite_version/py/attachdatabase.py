import sqlite3

# Open connection to main database and attach second database
conn = sqlite3.connect('csdegreecourses.db')
conn.execute("ATTACH DATABASE 'csugecourses.db' AS db2")

# Get list of tables from second database
cursor = conn.execute("SELECT name FROM db2.sqlite_master WHERE type='table' AND name != 'sqlite_sequence'")
table_names = [t[0] for t in cursor.fetchall()]

# Copy tables from second database to main database
for table_name in table_names:
    # Check if table already exists in main database
    cursor = conn.execute("SELECT count(*) FROM sqlite_master WHERE type='table' AND name=?", (table_name,))
    if cursor.fetchone()[0] == 0:
        # Create table in main database
        cursor.execute("CREATE TABLE main.{} AS SELECT * FROM db2.{}".format(table_name, table_name))

# Commit changes and close connection
conn.commit()
conn.close()