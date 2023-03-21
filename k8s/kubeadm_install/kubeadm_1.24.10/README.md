# kubecolor install:
https://github.com/hidetatz/kubecolor
wget https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz
tar xvf kubecolor_0.0.25_Linux_x86_64.tar.gz
chmod 777 kubecolor
sudo cp kubecolor /usr/local/bin/


# Add in ~/.bash_aliases
k='kubecolor'
ks='kubecolor -n kube-system'

. ~/.bash_aliases
scp ~/.bash_aliases k8s-node01:~/.bash_aliases
