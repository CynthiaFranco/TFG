#!/usr/bin/env python
# coding: utf-8

# ### Instalamos e importamos librerias necesarias

# In[1]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


# ### Importamos la base de datos
# 

# In[2]:


df=pd.read_excel('BDML.xlsx')
df.head()


# ### Definimos variables X e Y

# In[3]:


x=df.drop(['INT'], axis=1).values
y=df['INT'].values


# In[4]:


print(x)


# In[5]:


print(y)


# #### Dividimos el dataset en set de entramiento y set de prueba

# In[6]:


from sklearn.model_selection import train_test_split
x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.3,random_state=0)


# #### Entrenamos el modelo 

# In[7]:


from sklearn.linear_model import LinearRegression
ml=LinearRegression()
ml.fit(x_train,y_train)


# #### Creamos las predicciones con el set de prueba

# In[8]:


y_pred=ml.predict(x_test)
print(y_pred)


# #### Evaluamos el modelo

# In[9]:


from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
print('r2: ',r2_score(y_test,y_pred))
print('MAE: ',mean_absolute_error(y_test,y_pred))
print('MSE: ',mean_squared_error(y_test,y_pred))
print('RMSE: ',np.sqrt(mean_squared_error(y_test,y_pred)))


# #### Graficamos los resultados

# In[10]:


plt.figure(figsize=(8,8))
plt.scatter(y_test,y_pred, c='green')
plt.plot([y_test.min(), y_test.max()],[y_test.min(), y_test.max()], c='red')
plt.xlabel('Valor real')
plt.ylabel('Predicción')
plt.title('Regresion Lineal Multiple')


# #### Calculamos los errores de la predicción

# In[11]:


pred_y_df=pd.DataFrame({'Valor Real':y_test,'Valor Prediccion':y_pred,'Diferencia':y_test-y_pred})
pred_y_df[0:20]

