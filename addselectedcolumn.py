import sqlite3

# Open connection
conn = sqlite3.connect('csdegreecourses.db')
cursor = conn.cursor()

# Get the list of tables
cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name != 'sqlite_sequence'")
csdegreecourses_tables = [t[0] for t in cursor.fetchall()]

# Loop through each table and add a column named "selected" with a default value of 0
for table_name in csdegreecourses_tables:
    # Check if the column "selected" already exists
    cursor.execute(f"PRAGMA table_info({table_name})")
    columns = [col[1] for col in cursor.fetchall()]  # Column names are in the second field

    if "selected" not in columns:  # Only add column if it doesn't exist
        cursor.execute(f"ALTER TABLE {table_name} ADD COLUMN selected INTEGER DEFAULT 0;")
        print(f"Added 'selected' column to {table_name}.")
    else:
        print(f"'selected' column already exists in {table_name}, skipping.")

# Commit and close
conn.commit()
conn.close()

