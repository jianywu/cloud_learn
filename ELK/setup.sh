set -x
# Add user and group for ES
groupadd -g 2888 elasticsearch && useradd -u 2888 -g 2888 -r -m -s /bin/bash elasticsearch
# mkdir
mkdir /data/esdata /data/eslogs /apps -pv
# untar elasticsearch.tgz, softlink to /apps/elasticsearch, change /apps is better
chown elasticsearch.elasticsearch /data /apps -R

echo "other manual steps see README.md"