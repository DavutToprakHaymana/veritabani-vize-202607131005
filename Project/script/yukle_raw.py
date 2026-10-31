import psycopg2

conn = psycopg2.connect(host="localhost", port=5432,
                        dbname="postgres", user="postgres",
                        password="1234")
cur = conn.cursor()

cur.execute("DROP TABLE IF EXISTS raw_qa")
cur.execute("""
CREATE TABLE raw_qa (
    id            text,
    system_prompt text,
    question      text,
    answer        text,
    category      text,
    flagged       boolean,
    is_duplicate  boolean,
    parent        text,
    child_of      text
)""")

with open("data/raw/uwp_raw.csv", encoding="utf-8") as f:
    cur.copy_expert("""COPY raw_qa (id, system_prompt, question, answer, category,
                      flagged, is_duplicate, parent, child_of)
                      FROM STDIN WITH (FORMAT csv, HEADER true)""", f)

conn.commit()
cur.execute("SELECT COUNT(*) FROM raw_qa")
print("Ham satir:", cur.fetchone()[0])   # 7250 olmali
conn.close()