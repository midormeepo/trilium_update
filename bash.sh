#!/bin/bash
set -e

# 拉取GitHub最新版本
release_url=$(curl -s "https://api.github.com/repos/Nriver/trilium-translation/releases/latest" | grep "browser_download_url.*trilium-cn-linux-x64-server.zip" | cut -d : -f 2,3 | tr -d \")
curl -L -o trilium.zip $release_url;

read -p "下载完成，开始安装？[y/n]: " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    # 停止trilium
    systemctl stop trilium
    # 删除原目录
    cd /opt
    rm -rf trilium
    # 解压文件
    unzip trilium.zip
    echo "解压完成。"
    echo "移动文件夹。"
    sudo mv trilium-linux-x64-server /opt/trilium
    echo "重启trilium……"
    systemctl start trilium 
    
    read -p "升级完成！是否删除压缩文件？[y/n]: " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        # 删除文件
        cd ~
        rm -f trilium.zip
        echo "删除完成。"
    fi
else
    echo "安装中止。"
fi
