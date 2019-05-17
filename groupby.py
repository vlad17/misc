

import pandas as pd

import sys

if __name__ != "__main__":
    print("should be run as script")
    sys.exit(1)

if len(sys.argv) != 2:
    print("usage: python groupby.py account.csv")
    sys.exit(1)

account_file = sys.argv[1]

df = pd.read_csv(account_file)

df["Transaction Date"] = pd.to_datetime(df["Transaction Date"])

payment_period = df[df["Amount"] > 0]["Transaction Date"]

prev = payment_period.iloc[1]
curr = payment_period.iloc[0]

print("most recent payment period", prev, curr)

mrpp = df[(df["Transaction Date"] < curr) & (df["Transaction Date"] > prev)]
spend = mrpp[mrpp["Amount"] < 0]

spends = spend.groupby("Category")["Amount"].sum().sort_values()
spends = pd.DataFrame({"usd": spends, "frac": spends / spends.sum()})


tot = spends.sum() # add as a row

spends = spends[spends["frac"] > 0.01] # add as misc row

print(spends.to_string(formatters={"frac": "{:.0%}".format}))
print("total", "{:.2f}".format(tot["usd"]))

print()
print(spends.index[0])
print(mrpp[mrpp["Category"] == spends.index[0]].sort_values("Amount")[["Transaction Date", "Description","Amount"]].head())
print()
print(spends.index[1])
print(mrpp[mrpp["Category"] == spends.index[1]].sort_values("Amount")[["Transaction Date", "Description","Amount"]].head())

# TODO enable interactive drilldown (i.e., as above)
# TODO monthly stacked line plot for the mix
# TODO per-catgory line plot for monthly spend (total usd)
# TODO would be nice to have a general interface for it.
