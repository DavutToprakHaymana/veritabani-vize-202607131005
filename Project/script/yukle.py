import psycopg2

conn = psycopg2.connect(host="localhost", port=5432,
                        dbname="postgres", user="postgres",
                        password="1234")
cur = conn.cursor()

cur.execute("DROP TABLE IF EXISTS qa_clean")
cur.execute("""
CREATE TABLE qa_clean (
    id                text,
    question          text,
    answer            text,
    source_section    text,
    topic             text,
    question_length   integer,
    answer_length     integer,
    question_words    integer,
    answer_words      integer,
    paraphrase_count  integer,
    is_empty_question boolean,
    is_empty_answer   boolean
)""")

with open("data/clean/qa_clean.csv", encoding="utf-8") as f:
    cur.copy_expert("COPY qa_clean FROM STDIN WITH (FORMAT csv, HEADER true)", f)

conn.commit()
cur.execute("SELECT COUNT(*) FROM qa_clean")
print("Yuklenen satir:", cur.fetchone()[0])   # 1450 olmali
conn.close()