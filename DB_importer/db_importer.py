import pandas as pd
import glob
from sqlalchemy import create_engine

# Importing and merging the files
data_path = glob.glob('C:/Users/Widiatmoko Azis F/Documents/_WAF Docs/SMACCs Study/SMACCs Thesis/2. PROCESSING/Working_Data/*.txt')
df = pd.concat(pd.read_csv(f, sep = "\t", header = None) for f in data_path)
df.columns = ['osm_id', 'link_dir', 'date_time', 'speed_kmph', 'unique_entries']

# Converting date_time format 
df['date_time'] = df['date_time'].astype('datetime64[ns]')

# Drop missing values (Na = not available data)
df = df.dropna(axis = 0)

# Connecting postgreSQL to python 
# Engine configuration for postgreSQL, 
# see for more detail: https://docs.sqlalchemy.org/en/14/core/engines.html
conn_string = 'postgresql+psycopg2://postgres:1234@localhost/thesis'

# Perform to_sql to convert df to SQL
db = create_engine(conn_string)
conn = db.connect()

print('Your data will be converted, Please wait...')
# Change the name of the table every run!
df.to_sql('network_speed_2021-22', con=conn, if_exists='replace', index=False)

print('Your data is in the database!')
