#!/bin/bash
chmod +x "$0"
echo "本次操作需要「管理员权限」，请输入密码"
sudo -v >/dev/null 2>&1
#sudo -i >/dev/null 2>&1
#set -x
# set -e

System_DL=$(ls -F $HOME | grep "下载\|Downloads" | sed 's/\///g')
mkdir -p "$HOME"/"$System_DL"/092DL_temp
Project_DL="$HOME/$System_DL/092DL_temp"
# cd $Project_DL

rime_dir="${HOME}/.local/share/fcitx5/rime"
schema_file="$rime_dir/092wb.schema.yaml"
default_file="$rime_dir/default.custom.yaml"
extended_file="$rime_dir/092wb.extended.dict.yaml"
conf_file="$HOME/.config/fcitx5/conf/classicui.conf"
Fcitx5_Rime_Package="fcitx5-rime"
xprofile="$HOME/.xprofile"

user="mlzzz"
repo="092wb"
mirrors=(
  "https://ghproxy.com/https://github.com/"
  "https://hub.fgit.ml/"
  "https://kgithub.com/"
  "https://hub.fgit.gq/"
  "https://github.moeyy.xyz/https://github.com/"
  "https://hub.njuu.cf/"
  "https://hub.yzuu.cf/"
  "https://github.com.cnpmjs.org/"
  "https://github.com/"
)

raw_mirrors=(
  "https://ghproxy.com/https://raw.githubusercontent.com/"
  "https://raw.iqiq.io/"
  "https://raw.kgithub.com/"
  "https://ghp.quickso.cn/https://raw.githubusercontent.com/"
  "https://github.com/https://raw.githubusercontent.com/"
)

Check_Linux() {
  if [[ "$os_name" == "Ubuntu" ]] || [[ "$os_name" == "Ubuntu Kylin" ]] || [[ "$os_name" == "Debian GNU/Linux" ]] || [[ "$os_name" == "Deepin" ]]; then
    Get_Debian_DE
  elif [[ "$os_name" == "Manjaro Linux" ]] || [[ "$os_name" == "Arch Linux" ]]; then
    Get_Arch_DE
  else
    echo "不支持的发行版"
    exit 1
  fi
}

# arch 系
install_arch_package() {
  if ! pacman -Qi git >/dev/null 2>&1; then
    echo "检测到未安装 Git, 准备安装"
    yes | sudo pacman -Syu
    yes | sudo pacman -S git
  else
    echo "检测到已安装 Git"
  fi
  echo "正在安装 fcitx5-rime"
  if [[ ("$os_name" == "Manjaro Linux" || "$os_name" == "Arch Linux") && ("$DesktopEnv" == "Xfce" || "$DesktopEnv" == "KDE" || "$DesktopEnv" == "GNOME") ]]; then
  yes | sudo pacman -Syu
  yes | sudo pacman -S fcitx5 $Fcitx5_Rime_Package fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-material-color --needed
  # 包含 qdbus 布署
  yes | sudo pacman -S qt5-tools --needed
  Check_xprofile
  else
    echo
    exit
  fi
}

# debian 系
install_debian_package() {
  if ! dpkg -s git >/dev/null 2>&1; then
    echo "检测到未安装 Git, 准备安装"
    yes | sudo apt-get update 
    yes | sudo apt-get install git
    export PATH=$PATH:/usr/bin/
  else
    echo "检测到已安装 Git"
  fi

  echo "正在安装 fcitx5-rime"
  if [[ "$os_name" == "Ubuntu Kylin" ]] && [[ "$DesktopEnv" == "UKUI" ]]; then
    sudo apt update -y
    sudo apt install $Fcitx5_Rime_Package fcitx5 fcitx5-configtool fcitx5-material-color -y
    sudo apt install qdbus-qt5 -y
    Check_xprofile
    mkdir -p ~/.config/autostart/ && ln -s /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
  elif [[ ("$os_name" == "Ubuntu" || "$os_name" == "Debian GNU/Linux") && ("$DesktopEnv" == "Xfce" || "$DesktopEnv" == "KDE" || "$DesktopEnv" == "GNOME" || "$DesktopEnv" == "DDE") ]]; then
    sudo apt update -y
    sudo apt install $Fcitx5_Rime_Package fcitx5 fcitx5-configtool fcitx5-material-color -y
    sudo apt install qdbus-qt5 -y
    Check_xprofile
    mkdir -p ~/.config/autostart/ && ln -s /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
  elif [[ "$os_name" == "Deepin" ]] && [[ "$DesktopEnv" == "DDE" ]]; then
    sudo apt update -y
    sudo apt install $Fcitx5_Rime_Package fcitx5 fcitx5-config-qt fcitx5-material-color -y
    sudo apt install qdbus-qt5 -y
    Check_xprofile
    mkdir -p ~/.config/autostart/ && ln -s /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
  else
    echo "不支持"
    exit
  fi
}

Check_xprofile() {
  if [[ ! -f $xprofile ]]; then
    touch $xprofile
  fi
  if [[ $(grep "GTK_IM_MODULE=fcitx5" "$xprofile") == "" ]]; then
    echo 'export GTK_IM_MODULE=fcitx5' >>"$xprofile"
  fi
  if [[ $(grep "QT_IM_MODULE=fcitx5" "$xprofile") == "" ]]; then
    echo 'export QT_IM_MODULE=fcitx5' >>"$xprofile"
  fi
  if [[ $(grep "XMODIFIERS=@im=fcitx" "$xprofile") == "" ]]; then
    echo 'export XMODIFIERS=@im=fcitx' >>"$xprofile"
  fi
}

# 获取发行版名称
Get_OS_Release() {
  if [ -f /etc/os-release ]; then
    os_name=$(cat /etc/os-release | grep "^NAME=" | awk -F '"' '{print $2}')
    echo "系统：$os_name"
    Check_Linux
  else
    echo "无法检测 Linux 发行版"
    exit 1
  fi
}

# 检测桌面环境
Get_Debian_DE() {
  if pgrep -l "gnome-session" >/dev/null; then
    echo "桌面环境是 GNOME"
    DesktopEnv="GNOME"
    install_debian_package
  elif pgrep -l "plasma" >/dev/null; then
    echo "桌面环境是 KDE Plasma"
    DesktopEnv="KDE"
    install_debian_package
  elif pgrep -l "xfce4-session" >/dev/null; then
    echo "桌面环境是 Xfce"
    DesktopEnv="Xfce"
    install_debian_package
  elif pgrep -l "ukui-session" >/dev/null; then
    echo "桌面环境是 UKUI"
    DesktopEnv="UKUI"
    install_debian_package
  elif pgrep -l "startdde" >/dev/null; then
    echo "桌面环境是 DDE"
    DesktopEnv="DDE"
    install_debian_package
  else
    echo "不支持的桌面环境"
    exit
  fi
}

Get_Arch_DE() {
  if pgrep -l "gnome-session" >/dev/null; then
    echo "桌面环境是 GNOME"
    DesktopEnv="GNOME"
    install_arch_package
  elif pgrep -l "plasma" >/dev/null; then
    echo "桌面环境是 KDE Plasma"
    DesktopEnv="KDE"
    install_arch_package
  elif pgrep -l "xfce4-session" >/dev/null; then
    echo "桌面环境是 Xfce"
    DesktopEnv="Xfce"
    install_arch_package
  else
    echo "不支持的桌面环境"
    exit
  fi
}


clone_Project() {
  success=false
  for mirror in "${mirrors[@]}"; do
    echo "Trying to clone from $mirror$user/$repo.git"

    if [[ "$mirror" == *"//github.com/"* && "$mirror" == *"https"* ]]; then
      git clone "$mirror$user/$repo.git" "$Project_DL/$repo"

    else
      git clone "$mirror$user/$repo.git" "$Project_DL/$repo"
    fi

    if [ $? -eq 0 ]; then
      echo -e "克隆成功!\nClone success from $mirror$user/$repo.git"
      success=true
      break
    else
      echo -e "克隆失败，尝试下一个镜像地址\nClone failed from $mirror$user/$repo.git"
    fi
  done

  if ! $success; then
    echo "所有镜像下载失败! 请检查网络."
    exit 1
  fi
}

main() {
  if [ -z "$1" ]; then
    echo "命令中的参数不能为空"
    sleep 3
    exit 1
  elif [ "$1" = "b" ]; then
    backup
  elif [ "$1" = "r" ]; then
    restore
  elif [ "$1" = "092" ]; then
    Get_OS_Release
    wb_092
  elif [ "$1" = "en" ] || [ "$1" = "zh" ]; then
    en_zh_092
  elif [ "$1" = "h" ] || [ "$1" = "v" ]; then
    vh
  elif [ "$1" = "s" ] || [ "$1" = "ns" ]; then
    spelling
  elif [ "$1" = "d" ] || [ "$1" = "z" ]; then
    rk
  elif [ "$1" = "d-092" ]; then
    switch_dicts_092
  elif [ "$1" = "d-092k" ] || [ "$1" = "d-092K" ]; then
    switch_dicts_092k
  elif [ "$1" = "d-092p" ] || [ "$1" = "d-092P" ]; then
    switch_dicts_092p
  elif [ "$1" = "clover" ]; then
    py_clover
  elif [ "$1" = "unclover" ]; then
    unclover
  elif [ "$1" = "c" ]; then
    Clear_Project_DL
  else
    echo "非法参数，请输入正确的命令。"
    sleep 3
    exit 1
  fi

  shift

  [ -n "$1" ] && main "$@"
}

download_dicts() {
  success=false
  for mirror in $raw_mirrors; do
    echo "Trying to curl from ${raw_mirrors}${user}/${repo}"
    if [ "$mirror" = "https://raw.githubusercontent.com/" ]; then
      curl -o "$Project_DL/$dict_file_name.yaml" -L "${mirror}${user}/${repo}/main/${dict_dir}/${dict_file_name}.yaml"
    else
      curl -o "$Project_DL/$dict_file_name.yaml" -L --insecure "${mirror}${user}/${repo}/main/${dict_dir}/${dict_file_name}.yaml"
    fi

    if [ $? -eq 0 ]; then
      echo "curl success from ${mirror}${user}/${repo}"
      success=true
      break
    else
      echo "curl failed from ${mirror}${user}/${repo}"
    fi
  done

  if ! $success; then
    echo "所有镜像下载失败! 请检查网络."
    exit 1
  fi
}

base() {
  if [ -d "$HOME"/.local/share/fcitx5/rime ]; then
    sudo rm -rf "$HOME"/.local/share/fcitx5/rime
  fi
  sudo mkdir -p "$rime_dir"/build
  sudo cp -rf $Project_DL/$repo/092/spelling/wb_spelling.*.bin $rime_dir/build
  sudo cp -rf $Project_DL/$repo/092/* $rime_dir
  if [ ! -d ~/.local/share/fcitx5/themes ]; then
    sudo mkdir ~/.local/share/fcitx5/themes
  fi
  sudo cp -rf $Project_DL/$repo/themes/* $HOME/.local/share/fcitx5/themes
  sudo rm -rf $rime_dir/weasel.custom.yaml
  sudo rm -rf $rime_dir/squirrel.custom.yaml
  sudo rm -rf $rime_dir/opencc/s2t.json
  sudo chmod -R 777 $rime_dir
  if [ ! -f $rime_dir/build/wb_spelling.prism.bin ]; then
    sudo cp -rf $Project_DL/$repo/092/spelling/wb_spelling.*.bin $rime_dir/build
  fi

  echo "092方案添加功成!"
  if [ ! -d $HOME/.local/share/fonts/ ]; then
    mkdir $HOME/.local/share/fonts
  fi

  if [ -f $HOME/.local/share/fonts/092etymon.otf ]; then
    rm -rf $HOME/.local/share/fonts/092etymon.otf
  fi

  sudo cp -rf $Project_DL/$repo/fonts/*.otf $HOME/.local/share/fonts
  echo "正在刷新字体缓存, 请耐心等待..."
  sudo fc-cache -f -v >/dev/null 2>&1
  echo "安装拆分字体成功!"
  echo "已完成所有安装!"
  echo "请「注销或退出登陆系统一次」，并在「设置」中添加「中州韵」选项。"
}


Clear_Project_DL() {
  sudo rm -rf $Project_DL
}

wb_092() {
  echo "环境检测"
  if command -v git >/dev/null 2>&1 ; then
    echo "环境检测通过"
  else
    echo "未安装 Git"
    exit
  fi

  if [ -d "$Project_DL" ]; then
    echo "存在旧项目,准备更新"
    sudo rm -rf $Project_DL/$repo
  else
    echo "项目不存在,准备克隆"
  fi
  clone_Project
  base
}

en_zh_092() {
  echo "准备切换中英状态"
  # CRLF --> LF
  sed -i 's/\r//' "$schema_file"
  LINE="18"
  status="$(awk -F': ' 'NR=='"$LINE"' {print $2}' "$schema_file")"
  if [[ "$status" == "1" ]]; then
    sed -i "${LINE}s/1/0/" "$schema_file"
  else
    sed -i "${LINE}s/0/1/" "$schema_file"
  fi
  echo "切换成功"
}

vh() {
  if [ ! -f "$conf_file" ]; then
    mkdir -p "$HOME/.config/fcitx5/conf" && touch "$conf_file"
    echo "Vertical Candidate List=False" >>"$conf_file"
  fi

  echo "准备切换横、竖排"
  while read -r line; do
    if [[ "$line" == *"Vertical Candidate List=False"* || "$line" == *"Vertical Candidate List=True"* ]]; then
      status=$(echo "$line" | awk -F '=' '{print $2}')
      if [[ "$status" == "True" ]]; then
        sed -i 's/\(Vertical Candidate List=\)True/\1False/gI' "$conf_file"
      else
        sed -i 's/\(Vertical Candidate List=\)False/\1True/gI' "$conf_file"
      fi
      echo "切换为竖排成功"
    fi
  done <"$conf_file"
  kill `ps -A | grep fcitx5 | awk '{print $1}'` && fcitx5& >/dev/null 2>&1 &
  #fcitx5-remote -r
}

spelling() {
  echo "准备切换拆分显隐"
  # CRLF --> LF
  sed -i 's/\r//' "$schema_file"
  LINE="23"
  status="$(awk -F': ' 'NR=='"$LINE"' {print $2}' "$schema_file")"
  if [[ "$status" == "1" ]]; then
    sed -i "${LINE}s/1/0/" "$schema_file"
    echo "关闭拆分"
  else
    sed -i "${LINE}s/0/1/" "$schema_file"
    echo "显示拆分"
  fi
}

dictionarys() {
  echo "准备切换词库"
  rm -rf $rime_dir/*.txt
  if [[ "$dict_dir" == "092" ]]; then
    sudo cp -rf $Project_DL/$dict_file_name.yaml "$rime_dir"
    LINE="9"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" == "#" ]]; then
      sed -i "${LINE}s/^#//" "$extended_file"
    fi

    LINE="10"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" == "#" ]]; then
      sed -i "${LINE}s/^#//" "$extended_file"
    fi

    LINE="11"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" != "#" ]]; then
      sed -i "${LINE}s/^/#/" "$extended_file"
    fi
    echo "词库切换成功"

  elif [[ "$dict_dir" == "dicts" ]]; then
    sudo cp -rf $Project_DL/$dict_file_name.yaml $rime_dir
    sed -i 's/\r//' "$extended_file"
    LINE="9"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" != "#" ]]; then
      sed -i "${LINE}s/^/#/" "$extended_file"
    fi

    LINE="10"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" != "#" ]]; then
      sed -i "${LINE}s/^/#/" "$extended_file"
    fi

    sed -i -r "11s/^.+$/  \- ${dict_name}/" "$extended_file"

    sed -i 's/\r//' "$schema_file"
    LINE="32"
    status="$(awk -F': ' 'NR=='"$LINE"' {print $2}' "$schema_file")"
    if [[ "$status" == "1" ]]; then
      sed -i "${LINE}s/1/0/" "$schema_file"
    fi
    echo "词库切换成功"
  else
    echo "词库名不正确"
    exit
  fi
}

py_clover() {
  echo "准备添加 clover "
  sudo cp -rf $Project_DL/$repo/clover/* $rime_dir
  sed -i '10s/^#//' "$default_file"
  echo "成功添加"
}

rk() {
  echo 准备切换『\`』『z』反查
  # CRLF --> LF
  sed -i 's/\r//' "$schema_file"
  LINE="120"
  status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$schema_file")"
  if [[ "$status" == "#" ]]; then
    sed -i "${LINE}s/#//" "$schema_file"
  else
    sed -i "${LINE}s/^/#/" "$schema_file"
  fi

  LINE="144"
  status="$(awk -F"\"" 'NR=='"$LINE"' {print $2}' "$schema_file")"
  if [[ "$status" == "\`" ]]; then
    sed -i "${LINE}s/\`/z/" "$schema_file"
  else
    sed -i "${LINE}s/z/\`/" "$schema_file"
  fi

  LINE="174"
  status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$schema_file")"
  if [[ "$status" == "#" ]]; then
    sed -i "${LINE}s/#//" "$schema_file"
  else
    sed -i "${LINE}s/^/#/" "$schema_file"
  fi

  LINE="176"
  status="$(awk 'NR=='"$LINE"' {print substr($0,13,2)}' "$schema_file")"
  if [[ "$status" == "^z" ]]; then
    sed -i "${LINE}s/\^z/\^\`/" "$schema_file"
  else
    sed -i "${LINE}s/\^\`/\^z/" "$schema_file"
  fi

  LINE="177"
  status="$(awk 'NR=='"$LINE"' {print substr($0,13,2)}' "$schema_file")"
  if [[ "$status" == "^z" ]]; then
    sed -i "${LINE}s/\^z/\^\`/" "$schema_file"
  else
    sed -i "${LINE}s/\^\`/\^z/" "$schema_file"
  fi
  echo 切换成功
}

unclover() {
  echo "准备移除 clover "
  sudo rm -rf ~/Library/Rime/clover*.yaml
  sudo rm -rf ~/Library/Rime/sogou*.yaml
  sudo rm -rf ~/Library/Rime/THUOCL*.yaml
  sudo rm -rf ~/Library/Rime/build/clover*.yaml
  # CRLF --> LF
  sed -i 's/\r//' "$default_file"
  LINE="10"
  status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$default_file")"
  if [[ "$status" == " " ]]; then
    sed -i "${LINE}s/^/#/" "$default_file"
  fi
  echo "移除成功"
}

switch_dicts_092() {
  dict_dir="092"
  dict_file_name="092wb.dict"
  dict_name="092wb"
  if [ -e $Project_DL/$dict_file_name.yaml ]; then
    echo "旧 $dict_file_name.yaml 存在"
    rm -rf $Project_DL/$dict_file_name.yaml
  else
    echo "旧 $dict_file_name.yaml 不存在，准备下载"
  fi
  download_dicts
  dictionarys
}

switch_dicts_092k() {
  dict_dir="dicts"
  dict_file_name="092K.dict"
  dict_name="092K"
  if [ -e $Project_DL/$dict_file_name.yaml ]; then
    echo "旧 $dict_file_name.yaml 存在"
    rm -rf $Project_DL/$dict_file_name.yaml
  else
    echo "旧 $dict_file_name.yaml 不存在，准备下载"
  fi
  download_dicts
  dictionarys
}

switch_dicts_092p() {
  dict_dir="dicts"
  dict_file_name="092P.dict"
  dict_name="092P"
  if [ -e $Project_DL/$dict_file_name.yaml ]; then
    echo "旧 $dict_file_name.yaml 存在"
    rm -rf $Project_DL/$dict_file_name.yaml
  else
    echo "旧 $dict_file_name.yaml 不存在，准备下载"
  fi
  download_dicts
  dictionarys
}

backup() {
  mkdir -p "$HOME/Desktop/中州韵备份"
  cp -rf "$rime_dir" "$HOME/Desktop/中州韵备份/"
  echo -e "备份已完成\n备份位置：桌面/中州韵备份"
  exit

}

restore() {
  backup_path="$HOME/Desktop/鼠须管备份"

  rm -rf "$rime_dir"
  cp -rf "${backup_path}/Rime/" "$HOME/Library/Rime"
  echo "恢复完成"
}

main "$@"

echo "准备重新布署"
qdbus org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.SetConfig "fcitx://config/addon/rime/deploy" "" >/dev/null 2>&1 &
echo "布署成功"
