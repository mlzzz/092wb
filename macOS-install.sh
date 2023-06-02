#!/bin/bash
echo "本次操作需要「管理员权限」，请输入密码"
sudo "$0" >/dev/null 2>&1
# debug
# set -x
# set -e
cd -- "$(dirname "$0")"
chmod +x "$0"
mkdir -p $HOME/Downloads/092DL_temp
Project_DL="$HOME/Downloads/092DL_temp"
cd $Project_DL

echo "检测安装环境"
if ! command -v git &>/dev/null; then
    echo "找不到 Git，请确保已经安装 Git。"
    exit
fi
echo "环境检测通过! \n执行下一步"

rime_dir="${HOME}/Library/Rime"
schema_file="${rime_dir}/092wb.schema.yaml"
default_file="$rime_dir/default.custom.yaml"
squirrel_file="$rime_dir/squirrel.custom.yaml"
extended_file="$rime_dir/092wb.extended.dict.yaml"

user="mlzzz"
repo="092wb"
mirrors=(
    https://ghproxy.com/https://github.com/
    https://hub.fgit.ml/
    https://kgithub.com/
    https://hub.fgit.gq/
    https://github.moeyy.xyz/https://github.com/
    https://hub.njuu.cf/
    https://hub.yzuu.cf/
    https://github.com.cnpmjs.org/
    https://github.com/
)

raw_mirrors=(
    https://ghproxy.com/https://raw.githubusercontent.com/
    https://raw.iqiq.io/
    https://raw.kgithub.com/
    https://ghp.quickso.cn/https://raw.githubusercontent.com/
    https://github.com/https://raw.githubusercontent.com/
)


clone_Project(){
  success=false
  for mirror in "${mirrors[@]}"; do
      echo "Trying to clone from $mirror$user/$repo.git"
  
      if [[ "$mirror" == *"//github.com/"* && "$mirror" == *"https"* ]]; then
          git clone "$mirror$user/$repo.git"
  
      else
          git clone "$mirror$user/$repo.git"
      fi
  
      if [ $? -eq 0 ]; then
          echo "克隆成功!\nClone success from $mirror$user/$repo.git"
          success=true
          break
      else
          echo "克隆失败，尝试下一个镜像地址\nClone failed from $mirror$user/$repo.git"
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
    wb_092
  elif [ "$1" = "en" ] || [ "$1" = "zh" ]; then
    en_zh_092
  elif [ "$1" = "h" ] || [ "$1" = "v" ]; then
    vh
  elif [ "$1" = "s" ] || [ "$1" = "ns" ]; then
    spelling
  elif [ "$1" = "d" ] || [ "$1" = "z" ]; then
    rk
  elif [ "$1" = "d-092k" ]; then
    switch_dicts_092k
  elif [ "$1" = "d-092" ]; then
    switch_dicts_092
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
    echo "Trying to curl from ${raw_mirror}${user}/${repo}"
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
sudo mkdir -p $rime_dir/build
sudo cp -rf $Project_DL/092wb/092/spelling/wb_spelling.*.bin $rime_dir/build
sudo cp -rf $Project_DL/092wb/092/* $rime_dir
sudo rm -rf ~/Library/Rime/weasel.custom.yaml
sudo rm -rf ~/Library/Rime/opencc/s2t.json
sudo chmod -R 777 /Library/Input\ Methods/Squirrel.app
sudo chmod -R 777 ~/Library/Rime
if [ ! -f ~/Library/Rime/build/wb_spelling.prism.bin ]; then
    sudo cp -rf $Project_DL/092wb/092/spelling/wb_spelling.*.bin ~/Library/Rime/build
fi
sudo xattr -rd im.rime.inputmethod.Squirrel /Library/Input\ Methods/Squirrel.app >/dev/null 2>&1
/usr/bin/sudo -u "${login_user}" /Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --install >/dev/null 2>&1
echo "092方案添加功成!"
sudo cp -rf $Project_DL/092wb/fonts/*.otf ~/Library/Fonts
echo "安装拆分字体成功!"
echo "已完成所有安装!"
echo "请「注销或退出登陆系统一次」，并在「设置-键盘-输入法」中添加「鼠须管」选项。"
}

Clear_Project_DL() {
sudo rm -rf $Project_DL
}

wb_092() {
  
  if [ -d "$Project_DL" ]; then
      echo "存在旧项目,准备更新"
      sudo rm -rf $Project_DL/092wb
  else
      echo "项目不存在,准备克隆"
  fi
  clone_Project
  install_squirrel
  base
}


en_zh_092() {
  echo "准备切换中英状态"
  # CRLF --> LF
  sed -i '' 's/\r//' "$schema_file"
  LINE="18"
  status="$(awk -F': ' 'NR=='"$LINE"' {print $2}' "$schema_file")"
  if [[ "$status" == "1" ]]; then
    sed -i '' "${LINE}s/1/0/" "$schema_file"
  else
    sed -i '' "${LINE}s/0/1/" "$schema_file"
  fi
  echo "切换成功"
}

install_squirrel() {
  # 禁用守护进程的所有检查
  sudo spctl --master-disable
  path=${0%/*}
  if [ ! -d "/Library/Input Methods/Squirrel.app" ]; then
    echo "检测到未安装鼠须管，执行全新安装"
    sudo cp -rf $Project_DL/092wb/app/Squirrel.app /Library/Input\ Methods/
    sudo cp -rf /Library/Input\ Methods/Squirrel.app/Contents/SharedSupport/* ~/Library/Rime
    sudo cp -rf /Library/Input\ Methods/Squirrel.app/Contents/SharedSupport ~/Library/Rime
    sudo rm -rf /Library/Input\ Methods/Squirrel.app/Contents/SharedSupport/build
    sudo rm -rf ~/Library/Rime/*
    echo "鼠须管安装成功！"
  else
    echo "检测到已装鼠须管，执行卸旧装新"
    login_user=$(/usr/bin/stat -f%Su /dev/console)
    squirrel_app_root="${DSTROOT}/Squirrel.app"
    squirrel_executable="${squirrel_app_root}/Contents/MacOS/Squirrel"
    # 禁用守护进程的所有检查
    sudo spctl --master-disable
    /Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --quit
    sudo rm -rf /Library/Input\ Methods/Squirrel.app
    sudo rm -rf ~/Library/Rime/*
    echo "已停用旧版"
    sudo cp -rf $Project_DL/092wb/app/Squirrel.app /Library/Input\ Methods/
    sudo cp -rf /Library/Input\ Methods/Squirrel.app/Contents/SharedSupport/* ~/Library/Rime
    sudo cp -rf /Library/Input\ Methods/Squirrel.app/Contents/SharedSupport ~/Library/Rime
    sudo rm -rf /Library/Input\ Methods/Squirrel.app/Contents/SharedSupport/build
    sudo rm -rf ~/Library/Rime/*
    echo "新鼠须管安装成功！"
  fi
}


vh () {
  # CRLF --> LF
  sed -i '' 's/\r//' "$squirrel_file"

  LINE="9"
  status="$(awk -F': ' 'NR=='"$LINE"' {print $2}' "$squirrel_file")"
  echo "准备切换横、竖排"
  if [[ "$status" == "true" ]]; then
    sed -i '' "${LINE}s/true/false/" "$squirrel_file"
    echo "切换为竖排成功"
  else
    sed -i '' "${LINE}s/false/true/" "$squirrel_file"
    echo "切换为横排成功"
  fi
}

spelling () {
  echo "准备切换拆分显隐"
  # CRLF --> LF
  sed -i '' 's/\r//' "$schema_file"
  LINE="23"
  status="$(awk -F': ' 'NR=='"$LINE"' {print $2}' "$schema_file")"
  if [[ "$status" == "1" ]]; then
    sed -i '' "${LINE}s/1/0/" "$schema_file"
    echo "关闭拆分"
  else
    sed -i '' "${LINE}s/0/1/" "$schema_file"
    echo "显示拆分"
  fi
}


dictionarys () {
  echo "准备切换词库"
  rm -rf $rime_dir/*.txt
  if [[ "$dict_dir" == "092" ]]; then
    sudo cp -rf $Project_DL/$dict_file_name.yaml "$rime_dir"
    LINE="9"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" == "#" ]]; then
      sed -i '' "${LINE}s/^#//" "$extended_file"
    fi

    LINE="10"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" == "#" ]]; then
      sed -i '' "${LINE}s/^#//" "$extended_file"
    fi
    
    LINE="11"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" != "#" ]]; then
      sed -i '' "${LINE}s/^/#/" "$extended_file"
    fi
    echo "词库切换成功"

  elif [[ "$dict_dir" == "dicts" ]]; then
    sudo cp -rf $Project_DL/$dict_file_name.yaml $rime_dir
    sed -i '' 's/\r//' "$extended_file"
    LINE="9"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" != "#" ]]; then
      sed -i '' "${LINE}s/^/#/" "$extended_file"
    fi
  
    LINE="10"
    status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$extended_file")"
    if [[ "$status" != "#" ]]; then
      sed -i '' "${LINE}s/^/#/" "$extended_file"
    fi
  
    sed -i '' -r "11s/^.+$/  \- ${dict_name}/" "$extended_file"

    sed -i '' 's/\r//' "$schema_file"
    LINE="32"
    status="$(awk -F': ' 'NR=='"$LINE"' {print $2}' "$schema_file")"
    if [[ "$status" == "1" ]]; then
      sed -i '' "${LINE}s/1/0/" "$schema_file"
    fi
    echo "词库切换成功"
  else
      echo "词库名不正确"
      exit
  fi
}


py_clover () {
  echo "准备添加 clover "
  sudo cp -rf $Project_DL/092wb/clover/* $rime_dir
  sed -i '' '10s/^#//' "$default_file"
  echo "成功添加"
}

rk () {
  echo 准备切换『\`』『z』反查
  # CRLF --> LF
  sed -i '' 's/\r//' "$schema_file"
  LINE="120"
  status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$schema_file")"
  if [[ "$status" == "#" ]]; then
    sed -i '' "${LINE}s/#//" "$schema_file"
  else
    sed -i '' "${LINE}s/^/#/" "$schema_file"
  fi

  LINE="144"
  status="$(awk -F"\"" 'NR=='"$LINE"' {print $2}' "$schema_file")"
  if [[ "$status" == "\`" ]]; then
    sed -i '' "${LINE}s/\`/z/" "$schema_file"
  else
    sed -i '' "${LINE}s/z/\`/" "$schema_file"
  fi
  
  LINE="174"
  status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$schema_file")"
  if [[ "$status" == "#" ]]; then
    sed -i '' "${LINE}s/#//" "$schema_file"
  else
    sed -i '' "${LINE}s/^/#/" "$schema_file"
  fi

  LINE="176"
  status="$(awk 'NR=='"$LINE"' {print substr($0,13,2)}' "$schema_file")"
  if [[ "$status" == "^z" ]]; then
    sed -i '' "${LINE}s/\^z/\^\`/" "$schema_file"
  else
    sed -i '' "${LINE}s/\^\`/\^z/" "$schema_file"
  fi

  LINE="177"
  status="$(awk 'NR=='"$LINE"' {print substr($0,13,2)}' "$schema_file")"
  if [[ "$status" == "^z" ]]; then
    sed -i '' "${LINE}s/\^z/\^\`/" "$schema_file"
  else
    sed -i '' "${LINE}s/\^\`/\^z/" "$schema_file"
  fi
  echo 切换成功
}


unclover () {
  echo "准备移除 clover "
  sudo rm -rf ~/Library/Rime/clover*.yaml
  sudo rm -rf ~/Library/Rime/sogou*.yaml
  sudo rm -rf ~/Library/Rime/THUOCL*.yaml
  sudo rm -rf ~/Library/Rime/build/clover*.yaml
  # CRLF --> LF
  sed -i '' 's/\r//' "$default_file"
  LINE="10"
  status="$(awk 'NR=='"$LINE"' {print substr($0,1,1)}' "$default_file")"
  if [[ "$status" == " " ]]; then
    sed -i '' "${LINE}s/^/#/" "$default_file"
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


backup(){


mkdir -p "$HOME/Desktop/鼠须管备份"
cp -rf "$HOME/Library/Rime" "$HOME/Desktop/鼠须管备份/"
echo "备份已完成\n备份位置：桌面/鼠须管备份"
exit

}

restore(){
backup_path="$HOME/Desktop/鼠须管备份"

rm -rf "$HOME/Library/Rime"
cp -rf "${backup_path}/Rime/" "$HOME/Library/Rime"
echo "恢复完成"

}

main "$@"

echo "准备重新布署"
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
echo "布署成功"
