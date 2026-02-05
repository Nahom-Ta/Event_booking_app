import sqlite3
from pathlib import Path


agent_db = Path(r"C:\Users\hp\EventBookingApp\event_agent\db.sqlite3")
backend_db = Path(r"C:\Users\hp\EventBookingApp\event_booking_backend\db.sqlite3")


def main() -> None:
    conn = sqlite3.connect(agent_db)
    row = conn.execute(
        "SELECT sql FROM sqlite_master WHERE type='table' AND name='message'"
    ).fetchone()
    conn.close()

    if not row or not row[0]:
        print("NO_MESSAGE_TABLE")
        return

    schema = row[0]
    print(schema)

    conn2 = sqlite3.connect(backend_db)
    exists = conn2.execute(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='message'"
    ).fetchone()

    if not exists:
        conn2.execute(schema)
        conn2.commit()
        print("CREATED")
    else:
        print("EXISTS")
    conn2.close()


if __name__ == "__main__":
    main()