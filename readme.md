10-bar truss 
===

簡介
---

十桿衍架(10-bar truss) 由十個長桿件組成並且有6 個端點，其中第
5、6 號端點為固定端。所有桿件的截面皆為圓形，桿件1 到桿件6 的截面半徑同為r1 且長度為9.14 m；桿件7 到桿件8 的截面半徑同為r2。
![10-bar truss](/Latex/Pic/10_bar_truss.jpg "10-bar truss")

端點4 及端點5 各有一向下的外力F = 1.0 × 10−7 N，在所有桿件的
應力不超過降伏應力且端點2 的位移小於0.02 m 的條件下，求桿件截面
半徑r1 與r2 的值，使得十桿衍架整體重量為最輕。

使用Matlab程式進行有線元素分析的計算，並搭配Matlab提供的fmincon函數進行最佳化得到最佳值與最佳解。

---

檔案介紹
---
此專案包含Matlab程式檔案及[Latex報告檔案](/Latex/)，以下僅針對Matlab相關文件進行說明。

### [Hw.m](/Hw.m)
此專案的主函式為 `Hw.m`，此函式包含最佳化函式 `fmincon`的呼叫指令以及已知的相關參數，如桿件長度、密度、楊式模數(Young's Modulus)及降伏應力(Yield Stress)。

為了不使此種固定常數分散於各函式間造成修改及維護的不便，於主函式中以全域變數 `Global`方式定義並設定初始值，其餘副函式則可直接使用所需的常數。

執行後的結果 `fval`為計算出的最小重量；陣列`r`為此重量所對應的$r_1$及$r_2$值

### [obj.m](/obj.m)
`function f = obj(r)`
此副函式為最佳化的**目標函數**

將$r_1$及$r_2$代入並計算十桿衍架的重量總和並存於 `f`中。

### [nonlcon.m](/nonlcon.m)
`function [ g,geq ] = nonlcon(r)`
此副函式為最佳化的**非線性拘束條件**

拘束條件包含
- $|\sigma_i| \leq \sigma_y$
- $\Delta s_2 \leq 0.02$

其中 $\sigma_i$為桿件1~桿件10的應力，因此所有拘束條件共有11個並存於`g(i)`。

為了判斷所代入的`r`是否符合拘束條件，需進行有限元素分析取得端點2位移以及各桿件應力，因此進入此副函式後會先將`r1`與`r2`代入`finiteElementMethod`並執行有線元素分析。

### [finiteElementMethod.m](/finiteElementMethod.m)
`function [ disp, stress] = finiteElementMethod( r1,r2 )`
此副函式為進行**有限元素分析**的計算並回傳各DOF位移及各桿件應力

由 `nonlcon`呼叫此副函式並傳入不同的 `r1`與 `r2`數值，經過有線元素分析後取得各端點的x,y方向位移 `disp`，以及桿件1~桿件10的應力值 `stress`並回傳至 `nonlcon.m`進行拘束條件的判斷。

---
更多計算細節及結果請參閱[報告檔案](/Latex/main.pdf)