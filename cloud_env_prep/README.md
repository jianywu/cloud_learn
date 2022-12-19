1. 更新软件，apt update -y; apt upgrade -y
2. 打开安全组，打开所需端口，一些端口只允许某些特定IP访问。
3. 关闭防火墙，apt install firewalld; systemctl stop firewalld;systemctl disable firewalld; 或者只放开某些端口。
4. 安装vnc需要的软件。
