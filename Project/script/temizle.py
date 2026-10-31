import pandas as pd, glob, os

f = glob.glob("data/raw/*")[0]
try:
    df = pd.read_json(f)
except ValueError:
    df = pd.read_json(f, lines=True)

p = df[df["Parent"] == True].copy()      # yalnizca ozgun satirlar

# her ana soru icin yeniden ifade sayisi
kids = df[df["Parent"] != True].groupby("child_of").size()
p["paraphrase_count"] = p["ID"].map(kids).fillna(0).astype(int)

# bos metinleri sil degil, isaretle
p["question"] = p["question"].str.strip()
p["answer"] = p["answer"].str.strip()
p["is_empty_question"] = p["question"] == ""
p["is_empty_answer"] = p["answer"] == ""

# category: "sol | sag" -> iki sutun, kucuk harf
parts = p["category"].str.split(r"\s*\|\s*", n=1, expand=True)
p["source_section"] = parts[0].str.strip().str.lower()
p["topic"] = parts[1].str.strip().str.lower()

# sayisal sutunlar (turetilmis)
p["question_length"] = p["question"].str.len()
p["answer_length"] = p["answer"].str.len()
p["question_words"] = p["question"].str.split().str.len()
p["answer_words"] = p["answer"].str.split().str.len()

cols = ["ID", "question", "answer", "source_section", "topic",
        "question_length", "answer_length", "question_words", "answer_words",
        "paraphrase_count", "is_empty_question", "is_empty_answer"]
os.makedirs("data/clean", exist_ok=True)
p[cols].to_csv("data/clean/qa_clean.csv", index=False)

print("Ana satir:", len(p))
print("Bos soru:", p["is_empty_question"].sum(), "| Bos cevap:", p["is_empty_answer"].sum())
print(p["paraphrase_count"].value_counts())
print(p["topic"].value_counts())
print(p[p["ID"].duplicated(keep=False)][["ID", "question"]])
print(p[p["paraphrase_count"] == 8][["ID", "question"]])
import pandas as pd, glob
f = [x for x in glob.glob("data/raw/*") if not x.endswith(".csv")][0]
try:
    df = pd.read_json(f)
except ValueError:
    df = pd.read_json(f, lines=True)
df.to_csv("data/raw/uwp_raw.csv", index=False)
print(df.shape)