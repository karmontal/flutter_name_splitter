import spacy
import os
import json

MODEL_PATH = os.path.join(os.path.dirname(__file__), "trained_name_segmentor")
nlp = spacy.load(MODEL_PATH)

def split_names(input_text):
    names = input_text.strip().split("\n")
    results = []
    for name in names:
        doc = nlp(name)
        parts = {"FIRST_NAME": "", "FATHER_NAME": "", "GRANDFATHER_NAME": "", "LAST_NAME": ""}
        for ent in doc.ents:
            if ent.label_ in parts:
                parts[ent.label_] = ent.text
        results.append(parts)
    return json.dumps(results)

if __name__ == "__main__":
    sample = "كرم مفيد أبو سالم الطلاع\nلميس كرم عبد الودود الطلاع"
    print(split_names(sample))