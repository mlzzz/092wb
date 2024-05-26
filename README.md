# 092五笔

## 简介:
>092输入法即09输入法第二代，由「行走的风景」发明，以其惊人的词组离散能力和高速输入成绩，震惊跟打界。可惜因风景、狂练等老一辈高手名宿的退隐，〇九大法又略显式微。后又有小友、凌风等年轻高手脱颖而出，再现中兴之象。
## 功能&跨平台支持
|功能|快捷键|说明|windows|Mac|Linux|Android|iOS|
|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
|拆分显隐|Ctrl + Shift + H|显示拆分|✔|✔|✔|✔|
|注解|Ctrl + Shift + J|显示拆分、编码、拼音|✔|✔|✔|✔|
|超集|Ctrl + Shift + U|生僻字|✔|✔|✔|✔|
|繁简|Ctrl + Shift + F||✔|✔|✔|✔|✔|
|Emoji|Ctrl + Shift + M|:smile:|✔|✔|✔|✔|
|大写金额|R大写+数字|大写|✔|✔|✔|✔|✔|
|拼音反查|z键|反查五笔编码|✔|✔|✔|✔|✔|
|特殊符号|zi+编码|特殊符号|✔|✔|✔|✔|✔|
|重复上屏|z键|重复上一次输入|✔|✔|✔|✔|✔|
|撤销上屏|Alt + Backspace||✔|✔|✔|✔|✔|
|上屏注释|Ctrl + Shift + Return||✔|✔|✔|✔|✔|
|日期|date|日期|✔|✔|✔|✔|✔|
|星期|week|星期|✔|✔|✔|✔|✔|
|时间|time|系统时间|✔|✔|✔|✔|✔|
|农历|nl|农历|✔|✔|✔|✔|✔|
|全角|Shift + Space||✔|✔|✔|✔|✔|
|英文标点|Shift + .|中文下输入英文标点|✔|✔|✔|✔|✔|
|2 3选重|；‘|分号、引号|✔|✔|✔|✔|✔|
|1-10选重|数字|数字1-10|✔|✔|✔|✔|✔|
|切换方案|Ctrl + Shift + `|任意大写|✔|✔|✔|✔|✔|

## 下载地址：
 + [永硕E盘](http://092wb.ys168.com/)

## 东风破
```shell
curl -fsSL https://mirror.ghproxy.com/https://raw.githubusercontent.com/rime/plum/master/rime-install | bash
# or
curl -fsSL https://mirror.ghproxy.com/https://raw.githubusercontent.com/rime/plum/master/rime-install | bash
```

```shell
cd plum
```

安装或更新所有文件
```shell
bash rime-install mlzzz/092wb@releases:recipes/full
```

安装或更新所有词库文件
```shell
bash rime-install mlzzz/092wb@releases:recipes/all_dicts
```

安装或更新opencc
```shell
bash rime-install mlzzz/092wb@releases:recipes/opencc
```

安装或更新拆分
```shell
bash rime-install mlzzz/092wb@releases:recipes/spelling
```

第三方Rime前端，需在plum之用法前加上rime_frontend或rime_dir参数。 安装或更新所有文件
```shell
rime_frontend=fcitx-rime bash rime-install mlzzz/092wb@releases:recipes/full
```

或
```shell
rime_dir="$HOME/.config/fcitx/rime" bash rime-install mlzzz/092wb@releases:recipes/full
```
