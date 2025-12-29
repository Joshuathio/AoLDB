import pandas as pd
from faker import Faker
import random


# CONFIG


INPUT_CSV = "online_retail_data.csv"
OUTPUT_CSV = "online_retail_data_with_customer_cek.csv"

fake = Faker()

ANON_ID = "ANON"
ANON_PHONE = "000000000000"


# LOAD CSV

print("Loading CSV...")
df = pd.read_csv(INPUT_CSV)

# rapikan nama kolom
df.columns = df.columns.str.strip()

# rename Customer ID -> CustomerID
df = df.rename(columns={"Customer ID": "CustomerID"})


# HANDLE DATA KOSONG


# CustomerID kosong → ANON
df["CustomerID"] = df["CustomerID"].fillna(ANON_ID).astype(str)

# Country kosong → Unknown (aman untuk NOT NULL)
if "Country" in df.columns:
    df["Country"] = df["Country"].fillna("Unknown")

# CUSTOMER ID UNIK

unique_ids = df["CustomerID"].unique()
print(f"Total unique CustomerID (including ANON): {len(unique_ids)}")


# GENERATE DATA CUSTOMER

used_numbers = {ANON_PHONE}

customer_name = {}
customer_number = {}
customer_address = {}

for cid in unique_ids:
    if cid == ANON_ID:
        customer_name[cid] = "noname"
        customer_number[cid] = ANON_PHONE
        customer_address[cid] = "noaddress"
    else:
        
        while True:
            phone = ''.join(str(random.randint(0, 9)) for _ in range(12))
            if phone not in used_numbers:
                used_numbers.add(phone)
                break

        customer_name[cid] = fake.name()[:50]
        customer_number[cid] = phone
        customer_address[cid] = (
            fake.address()
            .replace("\n", " ")
            .replace(",", "")  
        )[:100]


# MAP KE DATAFRAME


df["CustomerName"] = df["CustomerID"].map(customer_name)
df["CustomerNumber"] = df["CustomerID"].map(customer_number)
df["CustomerAddress"] = df["CustomerID"].map(customer_address)

# SAVE CSV FINAL

df.to_csv(OUTPUT_CSV, index=False)

print("DONE!")
print(f"Saved as {OUTPUT_CSV}")
