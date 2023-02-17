# -*- coding: utf-8 -*-
"""
Created on Thu Dec 15 15:45:41 2022

@author: user
"""

'''
google 圖片爬蟲教學
重複搜尋不同關鍵字並下仔圖片，結合滾動卷軸下載更多圖檔
'''
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import requests as req
from bs4 import BeautifulSoup as bf
import time
import os
from selenium.webdriver.common.by import By
from selenium.webdriver.support.select import Select   # 使用 Select 對應下拉選單
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException # 遇到廣告可以跳過

options = Options()
options.add_argument("--disable-notifications")
 
driver = webdriver.Chrome('./chromedriver', chrome_options=options)
###進入google圖片搜尋網址
driver.get("https://www.google.com.tw/imghp?hl=zh-TW&tab=ri&authuser=0&ogbl")


'''
步驟:
    1.典籍搜尋框框
    2.輸入搜尋文字
    3.輸入enter
    4.滾動卷軸置底
    5.進入標籤img ,class=""下載屬性src 的網址清單並儲存
    6.回到搜尋頁面repeat(回上一頁or輸入網址)
    
遇到亂碼
可以使用.encoding = "utf-8"
driver.encoding = "utf-8"
google 圖片的標籤都是img
'''
###a 點擊搜尋框、輸入文字
a = driver.find_element(By.XPATH, '/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input')   
a.click() 
input_text ="梅西"
a.send_keys(input_text)
### 點擊Enter
a.send_keys(Keys.ENTER)

####視窗最大化
driver.maximize_window()

###
###b 滾動卷軸 滾動到底五次
### driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
for i in range(1,6):
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(2)

###往上捲至頂
driver.execute_script("window.scrollTo(0, -document.body.scrollHeight);")
time.sleep(10)

###
###找到每一個圖片xpath

b = driver.find_element(By.XPATH, '//*[@id="islrg"]/div[1]/div[409]/a[1]/div[1]/img') 

'''
使用timesleep
讓網頁讀取一下...
'''
b = driver.find_element(By.XPATH, '//*[@id="islrg"]/div[1]/div[1]/a[1]/div[1]/img') 
###點擊第一張圖讓網頁重新讀取
b.click()
time.sleep(10)
b.click()
time.sleep(10)

result_list=[]
input_text


####找到每一張圖xpath，點擊進入另一個網頁html，找到高清圖片xpath並儲存圖片src，圖片img通常由src儲存
for i in range(1,50):
    try :
    
        b = driver.find_element(By.XPATH, f'//*[@id="islrg"]/div[1]/div[{i}]/a[1]/div[1]/img') 
        b.click()
        time.sleep(0.6)
        e = driver.find_element(By.XPATH,'//*[@id="Sva75c"]/div[2]/div/div[2]/div[2]/div[2]/c-wiz/div[2]/div[1]/div[1]/div[2]/div/a/img')
        result_list.append(e.get_attribute('src'))
        print(e.get_attribute('src'))
    
    except NoSuchElementException:
        pass
        

###進入每一張圖片src連結並下載圖片
for index, link in enumerate(result_list):
         
    if not os.path.exists("images"):
        os.mkdir("images")  # 建立資料夾
        
    try:
        
        img = req.get(link,stream = True)  # 下載圖片
         
        with open("images\\" + input_text + str(index+1) + ".jpg", "wb") as file:  # 開啟資料夾及命名圖片檔
            file.write(img.content)  # 寫入圖片的二進位碼
    
    except :
        pass




