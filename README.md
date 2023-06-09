## Windows & Mac

## 依赖:

- curl

- Git

## 安装

参数：

```batch
b          -- 备份方案
r          -- 还原方案
092        -- 092方案 (默认: d-092 h ns z zh)
d-092      -- 切换为 092 词库
d-092k     -- 切换为 092K 词库
d-092p     -- 切换为 092P 词库
h          -- 切换为横排
v          -- 切换为竖排
s          -- 开启拆分提示
ns         -- 关闭拆分提示
d          -- 切换为 ` 反查
z          -- 切换为 z 反查
en         -- 切换为默认英文状态
zh         -- 切换为默认中文状态
clover     -- 添加四叶草拼音
unclover   -- 移除四叶草拼音
c          -- 清理 clone 项目
```

Windows搜索 `cmd` 右键以 `管理运行cmd` 后执行：

- 建议操作之前先使用参数 `b` 备份

- 默认只选了 `092` 参数，你可以自选参数加入下面命令后面（参数之间留空格）

- 第一次安装必须使用参数 `092`且参数 `092` 必须在最所有参数的最前面, `c` 参数必须在所有参数的最后面

```batch
curl -O https://raw.iqiq.io/mlzzz/092wb/main/windows-install.bat && call windows-install.bat 092
```

Mac 按 cmd + 空格 搜索 terminal 回车后执行：

```shell
curl -O https://raw.iqiq.io/mlzzz/092wb/main/macOS-install.sh && sh macOS-install.sh 092
```

Linux

打开 `终端`

第一步安装 `cURL`

Ubuntu / Debian / KylinUbuntu :

```shell
sudo apt install curl -y
```

Arch / Manjaro :

```shell
sudo pacman -S curl
```

第二步

```shell
curl -O https://raw.iqiq.io/mlzzz/092wb/main/linux-install.sh && bash linux-install.sh 092
```

例一：我想要使用 092 默认英文 我还想让它竖排显示并且开启拆分提示

使用参数：092 en v s

例二：我想使用092k

使用参数：092 d-092k

例三：

- 非首次安装092想切换为092k时直接使用 `d-09k`参数就能切换，同理如果你想回到默认的092词库用 `d-092`参数

例四：错误用法 

- 错：使用了参数 `092`  `zh` `h`  这3个参数。解 ：`092` 一个参数默认已经包含了后面的3个参数，详情请看 `参数` 092

- 错：后期切换词库使用 `092`  `d-092k` 这2个参数。解：后期切换词库使用 `d-092k` 

### TIPS：

- 某些切换开关之类的参数像 `v`和 `h` 之类的可以互相替代，如：当前是竖排显示我想切换为横排应该用`h`参数，但我用`v`参数也是一样的。

## 关于大字集的显示

建议安装宋天的字体, 本拆分字体已做了挂接

## 问与答

问: 怎么更新?

1. 整体更新
   重新执行一遍你的参数配置
   例: curl xxx 092 v s
2. 词库更新 & 还原
   重新执行一遍你的词库参数
   例: curl xxx d-092k  或 curl xxx d-092

## 变更日志
2023年06月04日
- 添加诗歌维护的092原版词库命名为092P
- 添加 Linux 脚本，支持主流 Linux 发行版
- 修复 Windows 脚本中 Git 下载源失效的问题
