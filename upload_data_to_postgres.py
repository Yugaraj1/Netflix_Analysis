#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import sqlalchemy as sal
from sqlalchemy import create_engine


# In[ ]:


df = pd.read_csv(r"C:\Users\61403\Desktop\Projects\Netflix\archive\netflix_titles.csv")


# In[ ]:


df.info()


# In[ ]:


df.isna().sum()


# In[ ]:


df.rename(columns={'cast': 'casts'}, inplace=True)


# In[ ]:


engine = create_engine('database_name://Username:Password@localhost:5432/Database_name')


# In[ ]:


df.to_sql(
    name='netflix_table', 
    con=engine,
    if_exists='append',
    index=False
)


# In[ ]:




