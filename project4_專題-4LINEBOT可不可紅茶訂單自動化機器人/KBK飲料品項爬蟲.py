# -*- coding: utf-8 -*-
"""
Created on Tue Jan 17 00:10:21 2023

@author: user
"""

import requests as req
from bs4 import BeautifulSoup as bf
import pandas as pd

beverage_name =[]
beverage_price =[]
beverage_price1 =[]
beverage_price2 =[]
beverage_detail =[]
price = []

#t = soup.find_all(class_="menu-item__price")
#t[0].text
for i in range(1):
    response = req.get("https://www.kebuke.com/menu/")
    soup = bf(response.text, "html.parser")

    for name in soup.find_all(class_="menu-item__name"):
        
        print(name.text[13:17])
        #熟成紅茶
        beverage_name.append(name.text[13:17])
            
        print(name.text[13:17])

    for price in soup.find_all(class_="menu-item__price"):
        
        print(price.text[13:24])
        price = price.text[13:24]
        #中：30 / 大：35
        if "/" in price :
            beverage_price1.append(price[:price.find("/")])
            beverage_price2.append(price[price.find("/")+1:])
        
        else :
            beverage_price1.append(price)
            beverage_price2.append("NA")
            
    for detail in soup.find_all(class_="menu-item__desc"):
        
        beverage_detail.append(detail.text[13:])
        

        dict1={"品名":beverage_name,"價格1":beverage_price1,"價格2":beverage_price2,"介紹":beverage_detail}
        dict2 = pd.DataFrame(dict1)
        dict2.to_excel("可不可爬蟲飲料菜單2.xlsx")##存檔
 


