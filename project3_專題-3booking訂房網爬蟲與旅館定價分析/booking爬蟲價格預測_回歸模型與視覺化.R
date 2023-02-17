

#install.packages("openxlsx")
library(openxlsx)

data_price=read.xlsx(file.choose() ,sheet = "price")#BookingDec29.xlsx
data_score=read.xlsx(file.choose() ,sheet = "score")

library(ggplot2)
library(dplyr)

str(data_price)
str(data_score)
summary(data_price)
summary(data_score)

'''
drop duplicate
'''
unique(data_score$旅館名稱)
duplicated(data_score)
data_score = data_score[!duplicated(data_score) , ]
'''
資料屬性轉換:
將資料轉換成正確格式
數值 > as.numeric
文字 > as.character
'''

data_score$總分 = as.numeric(data_score$總分)
data_score$員工素質 = as.numeric(data_score$員工素質)
data_score$設施 = as.numeric(data_score$設施)
data_score$清潔程度 = as.numeric(data_score$清潔程度)
data_score$舒適程度 = as.numeric(data_score$舒適程度)
data_score$性價比 = as.numeric(data_score$性價比)
data_score$住宿地點 = as.numeric(data_score$住宿地點)
data_score$免費.WiFi = as.numeric(data_score$免費.WiFi)

'''
錯誤資料修正
'''
data_score$星級[data_score$星級 == 8] = 0
data_score$星級[data_score$星級 == 6] = 0

data_score$星級 = as.character(data_score$星級)

'''
評分(人數)太少的資料刪除 :
-296 : AJ Residence 安捷國際公寓酒店
'''
pos = which((data_score$旅館名稱 =="AJ Residence 安捷國際公寓酒店" )== T)
data_score = data_score[-pos,]

''' 總評分與子項目總覽 '''
#####
library(colorspace)    
#df1 = ggplot(data_score  ,aes(x= data_score$總分,fill =data_score$星級 ) ) 
df1 = ggplot(data_score  ,aes(x= `總分`) ) 
a1 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3" ) + theme_bw() 
#a1 = df1 + geom_bar(fill ="turquoise3")+scale_x_binned() + theme_bw() 
a1
#
df1 = ggplot(data_score  ,aes(x= `員工素質`  ) ) 
a2 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3") + theme_bw() +xlim(c(6,10))
#a2 =df1 + geom_bar()+scale_x_binned() + theme_bw()
a2
#
df1 = ggplot(data_score  ,aes(x= `設施`  ) ) 
a3 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3") + theme_bw()
#a3 = df1 + geom_bar()+scale_x_binned() + theme_bw()
#
df1 = ggplot(data_score  ,aes(x= `清潔程度`  ) ) 
a4 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3") + theme_bw()
#a4 = df1 + geom_bar()+scale_x_binned() + theme_bw()
#
df1 = ggplot(data_score  ,aes(x= `舒適程度`  ) ) 
a5 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3") + theme_bw()
#a5 = df1 + geom_bar()+scale_x_binned() + theme_bw()
#
df1 = ggplot(data_score  ,aes(x= `性價比`  ) ) 
a6 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3") + theme_bw()
#a6 = df1 + geom_bar()+scale_x_binned() + theme_bw()
#
df1 = ggplot(data_score  ,aes(x= `住宿地點`  ) ) 
a7 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3") + theme_bw()
#a7 = df1 + geom_bar()+scale_x_binned() + theme_bw()
df1 = ggplot(data_score  ,aes(x= `免費.WiFi`  ) ) 
a8 = df1 + geom_histogram(binwidth = 0.25,fill ="turquoise3") + theme_bw()
#a8 = df1 + geom_bar()+scale_x_binned() + theme_bw()


#install.packages("ggpubr")
library(ggpubr)
ggarrange(a1,a2,a3,a4,a5,a6,a7,a8, 
          ncol = 2, nrow = 4)

summ = apply(data_score[2:9], 2 , function(x){sd(x,na.rm = T)})#應用函數,可針對矩陣列/欄執行function運算
summ

'''
常態分布
library(nortest)
shapiro.test()
pearson.test()
'''

'''
shapiro.test(data_score$總分)
ggplot(data_score , aes(sample=data_score$總分)) + stat_qq() + stat_qq_line()


shapiro.test(data_score$員工素質)
ggplot(data_score , aes(sample=data_score$員工素質)) + stat_qq() + stat_qq_line()

shapiro.test(data_score$設施)
ggplot(data_score , aes(sample=data_score$設施)) + stat_qq() + stat_qq_line()

shapiro.test(data_score$清潔程度)
ggplot(data_score , aes(sample=data_score$清潔程度)) + stat_qq() + stat_qq_line()

shapiro.test(data_score$舒適程度)
ggplot(data_score , aes(sample=data_score$舒適程度)) + stat_qq() + stat_qq_line()

shapiro.test(data_score$性價比)
ggplot(data_score , aes(sample=data_score$性價比)) + stat_qq() + stat_qq_line()

shapiro.test(data_score$住宿地點)
ggplot(data_score , aes(sample=data_score$住宿地點)) + stat_qq() + stat_qq_line()

shapiro.test(data_score$免費.WiFi)
ggplot(data_score , aes(sample=data_score$免費.WiFi)) + stat_qq() + stat_qq_line()

'''

#install.packages("GGally")
library(GGally)
score = data_score[1:11]
ggpairs(score1[2:11])
ggpairs(score[c(2,11)])

'''
清除離群值
'''
score[order(score$總分),]
score[(score$總分)<7,]
score1 = score[(score$總分)>=7,]
ggplot(score , aes(y=score$總分) ) + geom_boxplot()
ggplot(score1 , aes(y=score1$員工素質) ) + geom_boxplot()

ggpairs(score1[c(2,11)])
shapiro.test(score1$總分)
#
ggplot(score1 , aes(x=`總分`,face="bold") ) + geom_bar(fill = "turquoise3") +theme_classic() 
ggplot(score1 , aes(sample=score1$總分)) + stat_qq() + stat_qq_line()


mytheme = theme_bw(base_size = 14)

df1 = ggplot(score1  ,aes(x= `總分`) ) 
a1 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))      

df1 = ggplot(score1  ,aes(x= `員工素質`  ) ) 
a2 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))

df1 = ggplot(score1 ,aes(x= `設施`  ) ) 
a3 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))
#
df1 = ggplot(score1 ,aes(x= `清潔程度`  ) ) 
a4 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))
#
df1 = ggplot(score1  ,aes(x= `舒適程度`  ) ) 
a5 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))
#
df1 = ggplot(score1  ,aes(x= `性價比`  ) ) 
a6 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))
#
df1 = ggplot(score1  ,aes(x= `住宿地點`  ) ) 
a7 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))

df1 = ggplot(score1 ,aes(x= `免費.WiFi`  ) ) 
a8 = df1 + geom_histogram(binwidth = 0.2,fill ="turquoise3",col ="black") + mytheme +xlim(c(7,10))
#library(ggpubr)
ggarrange(a1,a2,a3,a4,a5,a6,a7,a8, 
          ncol = 2, nrow = 4)

summ = apply(score1[2:9], 2 , function(x){sd(x,na.rm = T)})#應用函數,可針對矩陣列/欄執行function運算
summ

'''
各項目相關性
'''
#library(GGally)
ggpairs(score1[c(2:9)])
mytheme = theme_bw(base_size = 13)
#df1 = ggplot(data_score  ,aes(x= data_score$總分 ,y= data_score$員工素質 ,col = `星級`) ) 
df1 = ggplot(score1  ,aes(y= `總分` ,x= `員工素質` ) ) 
b1 = df1 + geom_point() +geom_smooth(method = lm ,se =T)+mytheme
#
df1 = ggplot(score1  ,aes(y= `總分` ,x= `設施` ) ) 
b2 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme
#
df1 = ggplot(score1  ,aes(y= `總分` ,x= `清潔程度`) ) 
b3 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme
#
df1 = ggplot(score1  ,aes(y= `總分` ,x= `舒適程度` ) ) 
b4 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme
#
df1 = ggplot(score1 ,aes(y= `總分` ,x= `性價比` ) ) 
b5 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme
#
df1 = ggplot(score1  ,aes(y= `總分` ,x= `住宿地點` ) ) 
b6 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme
#
df1 = ggplot(score1  ,aes(y= `總分` ,x= `免費.WiFi` ) ) 
b7 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

mytheme = theme_bw(base_size = 20)
df1 = ggplot(score1  ,aes(x= `總分`,fill =`星級` ) ) 
b8 = df1 + geom_histogram(binwidth = 0.2,col ="black") + mytheme +xlim(c(7,10))      
b8

ggarrange(b1,b2,b3,b4,b5,b6,b7, 
          ncol = 2, nrow = 4)

###############################
###############################


'''
清除只有一筆的一星級飯店資料
'''
score1[which((score1$星級 ==1)==T),]
score1 = score1[-which((score1$星級 ==1)==T),]

ggpairs(score1[c(2:9,11)])

library(ggsignif)

m1<-aov( 總分 ~星級 , data=score1)
summary(m1)

#######
pair_t = geom_signif(comparisons = list(c(1,2),c(2,3),c(3,4),c(4,5)),  y_position = c(9, 9.25,9.5,9.75), map_signif_level = TRUE)
meanpoint = stat_summary(fun.y=mean, geom="point", shape=16, size=2, col='darkblue') 
df1 = ggplot(score1  ,aes(x= `星級`   ) ) 
c = df1 + geom_bar() +mytheme 
c
#######

df1 = ggplot(score1  ,aes(x= `星級` ,y= `總分`,col = `星級`  ) ) 
c1 = df1 + geom_boxplot() + pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

df1 = ggplot(score1  ,aes(x= `星級` ,y= `員工素質`,col = `星級` ) ) 
c2 = df1 + geom_boxplot() + pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

df1 = ggplot(score1  ,aes(x= `星級` ,y= `設施` ,col = `星級`) ) 
c3 = df1 + geom_boxplot()+ pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

df1 = ggplot(score1  ,aes(x= `星級` ,y= `清潔程度`,col = `星級` ) ) 
c4 = df1 + geom_boxplot()+ pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

df1 = ggplot(score1  ,aes(x= `星級` ,y= `舒適程度` ,col = `星級`) ) 
c5 = df1 + geom_boxplot() + pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

df1 = ggplot(score1  ,aes(x= `星級` ,y= `性價比` ,col = `星級` ) ) 
c6 = df1 + geom_boxplot() + pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

df1 = ggplot(score1  ,aes(x= `星級` ,y= `住宿地點`,col = `星級` ) ) 
c7 = df1 + geom_boxplot() + pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

df1 = ggplot(score1  ,aes(x= `星級` ,y= `免費.WiFi`,col = `星級` ) ) 
c8 = df1 + geom_boxplot() + pair_t +meanpoint +mytheme +guides(col =F)+ylim(7,10)

ggarrange(c1,c2,c3,c4,c5,c6,c7,c8, 
          ncol = 2, nrow = 4)
'''
價格資料清洗
test1
抓取房間人數為2、每間旅館最低價格
'''
data_price$人數 = as.integer(data_price$人數)
data_price$目前價格 = as.integer(data_price$目前價格)
data_price$原始價格 = as.integer(data_price$原始價格)

price = data_price[data_price$人數==2 ,]
#data_test1 %>% group_by(旅館名稱) %>% summarize(test1=min(目前價格,na.rm = T)) 

price_min = summarize(group_by(price,旅館名稱), minprice =min(目前價格,na.rm = T))
price_mean = summarize(group_by(price,旅館名稱), meanprice =mean(目前價格,na.rm = T))
price_min$minprice =as.integer( price_min$minprice)
price_mean$meanprice =as.integer( price_mean$meanprice)

ps_r = right_join(price,score1 )
is.na(ps_r$minprice)
ps_in = inner_join(price_min,price_mean)
ps_in = inner_join(ps_in,score1)

######
######價格資料不成常態分佈
shapiro.test(ps_in$minprice)
shapiro.test(ps_in$meanprice)
ggplot(ps_in, aes( x = ps_in$meanprice )) + geom_histogram()  
ggplot(ps_in, aes( x = ps_in$minprice )) + geom_histogram()  
ggplot(ps_in , aes(sample=ps_in$minprice)) + stat_qq() + stat_qq_line()
ggplot(ps_in , aes(sample=ps_in$meanprice)) + stat_qq() + stat_qq_line()

######價格取對數轉換 轉換成常態分布
ps_in$minpricelog = log1p(ps_in$minprice)
mytheme = theme_bw(base_size = 18)
ggplot(ps_in, aes(x=`minprice` )) +geom_histogram(fill = "turquoise3",col = "black")+ mytheme
ggplot(ps_in, aes(x=`minpricelog` )) +geom_histogram(fill = "turquoise3",col = "black")+ mytheme
ggplot(ps_in, aes(x=`minprice` )) +geom_density(fill = "turquoise3",col = "black")+ mytheme
ggplot(ps_in, aes(x=`minpricelog` )) +geom_density(fill = "turquoise3",col = "black")+ mytheme

shapiro.test(ps_in$minpricelog)
ggplot(ps_in , aes(sample=ps_in$minpricelog)) + stat_qq() + stat_qq_line()

#星級與價格相關性
pair_t = geom_signif(comparisons = list(c(1,2),c(2,3),c(3,4),c(4,5)),  y_position = c(9, 9.25,9.5,9.75), map_signif_level = TRUE)

ggplot(ps_in,aes(y=minpricelog, x=`星級`, fill = `星級`))+geom_point()
ggplot(ps_in,aes(y=minpricelog, x=`星級`, fill = `星級`))+geom_boxplot() +mytheme +pair_t

#價格與評價相關性
mytheme = theme_bw(base_size = 13)

df1 = ggplot(ps_in1  ,aes(y= `minpricelog` ,x= `員工素質` ) ) 
b1 = df1 + geom_point() +geom_smooth(method = lm ,se =T)+mytheme

df1 = ggplot(ps_in1  ,aes(y= `minpricelog` ,x= `設施` ) ) 
b2 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

df1 = ggplot(ps_in1 ,aes(y= `minpricelog` ,x= `清潔程度`) ) 
b3 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

df1 = ggplot(ps_in1 ,aes(y= `minpricelog` ,x= `舒適程度` ) ) 
b4 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

df1 = ggplot(ps_in1 ,aes(y= `minpricelog` ,x= `性價比` ) ) 
b5 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

df1 = ggplot(ps_in1  ,aes(y= `minpricelog` ,x= `住宿地點` ) ) 
b6 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

df1 = ggplot(ps_in1  ,aes(y= `minpricelog` ,x= `免費.WiFi` ) ) 
b7 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

df1 = ggplot(ps_in1  ,aes(y= `minpricelog` ,x= `最近大眾距離` ) ) 
b8 = df1 + geom_point()+geom_smooth(method = lm ,se =T)+mytheme

ggarrange(b1,b2,b3,b4,b5,b6,b7,b8,
          ncol = 2, nrow = 4)


######複回歸模型:價格與評價相關性(尚未刪除NA值)
ps_in1 =ps_in[,c(4:12,14)]
model1 = lm(ps_in1$minpricelog~.,data = ps_in1 )
summary(model1)

model1 = lm(ps_in1$minpricelog~舒適程度+性價比+住宿地點,data = ps_in1 )
summary(model1)# display results

confint(object = model1,level = 0.95)# 95% CI for the coefficients
exp(coef(model1)) # exponentiated coefficients
exp(confint(model1)) # 95% CI for exponentiated coefficients


########模型診斷 
#install.packages("ggfortify")
library(ggfortify)

autoplot(model1)+mytheme
shapiro.test(model1$residuals)
ggplot(model1,aes(x=model1$residuals))+geom_histogram()
ggplot(ps_in,aes(x=ps_in$minprice))+geom_histogram()
ggplot(ps_in , aes(sample=ps_in$minprice)) + stat_qq() + stat_qq_line()
##########ANOVA
anova(model1)

#######殘差分析

predict(model1, type="response") # predicted values
residuals(model1, type="deviance") # residuals 

#expm1(x) 將資料轉換回價格

expm1(ps_in1$minpricelog)

'''
刪除缺值(wifi: NA)
'''

na_list = which(is.na(ps_in1$免費.WiFi)==T)
ps_in4 = ps_in1[-na_list,]

#build full model
modelall = lm(minpricelog~.,data = ps_in4 )
full<-formula(modelall)

summary(modelall)# display results
#build a null model with only the intercept term

model0<-lm(minpricelog~1,data=ps_in4)
summary(model0)
#stepwise regression
step(model0,direction = "both",scope = full)
step(modelall,direction = "backward",scope = full)

model1 = lm(minpricelog~舒適程度+性價比+住宿地點+員工素質+最近大眾距離,data = ps_in4 )
summary(model1)# display results

########模型診斷 
autoplot(model1)
shapiro.test(model1$residuals)
ggplot(model1,aes(x=model1$residuals))+geom_histogram()
ggplot(model1,aes(sample=model1$residuals)) + stat_qq() + stat_qq_line()
