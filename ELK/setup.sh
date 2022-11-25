set -x
groupadd -g 2888 elasticsearch && useradd -u 2888 -g 2888 -r -m -s /bin/bash elasticsearch
mkdir /data/esdata /data/eslogs /apps -pv
chown elasticsearch.elasticsearch /data /apps -R

echo "other manual steps see README.md"