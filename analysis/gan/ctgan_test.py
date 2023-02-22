from ctgan import CTGAN
from ctgan import load_demo
real_data = load_demo()

# Names of the columns that are discrete
discrete_columns = [
     'workclass',
     'education',
     'marital-status',
     'occupation',
     'relationship',
     'race',
     'sex',
     'native-country',
     'income'
]

m = CTGAN(epochs=25)
setattr(m,"_verbose",True)
m.fit(real_data, discrete_columns)

import pickle
with open("ctgan.pickle","wb") as out_stream:
        pickle.dump(m,out_stream)

#synthetic_data = m.sample(1000)

