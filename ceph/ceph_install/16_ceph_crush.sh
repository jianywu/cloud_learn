#!/bin/bash

# 修改第0个osd的weight
ceph osd crush reweight osd.0 1.5
ceph osd getcrushmap -o /data/ceph/crushmap-v1
# 转为文本，方便阅读
crushtool -d /data/ceph/crushmap-v1 > /data/ceph/crushmap-v1.txt

# 修改crushmap-v1.txt，比如max_size从10修改为8
crushtool -c /data/ceph/crushmap-v1.txt -o /data/ceph/crushmap-v2
ceph osd setcrushmap -i /data/ceph/crushmap-v2
ceph osd crush rule dump
ceph osd getcrushmap -o /data/ceph/crushmap-v3
crushtool -d crushmap-v3 > crushmap-v3.txt

crushtool -c crushmap-v3.txt -o crushmap-v4
ceph osd setcrushmap -i /data/ceph/crushmap-v4

# 建ssd pool
ceph osd pool create magedu-ssdpool 32 32 magedu_ssd_rule
ceph pg ls-by-pool magedu-ssdpool | awk '{print $1,$2,$15}'

# S3 usage
radosgw-admin user create --uid="user1" --display-name="user1"
#记录下用户的key
            #"user": "user1",
            #"access_key": "Z4JPCATOSZ46AR197954",
            #"secret_key": "MHXR4RSoMHhmZdxo69ARlotHJlwgCHh2c6Cqg1VC"
apt-cache madison s3cmd
apt install s3cmd -y
s3cmd --help
s3cmd --configure
cat /root/.s3cfg

# 创建bucket
s3cmd mb s3://mybucket
s3cmd mb s3://css
s3cmd mb s3://images

wget https://img1.jcloudcs.com/portal/brand/2021/fl1-2.jpg
s3cmd put fl1-2.jpg s3://test-s3cmd/
s3cmd put fl1-2.jpg s3://images/jpg/
s3cmd ls s3://images/
s3cmd ls s3://images/jpg/
s3cmd get s3://images/fl1-2.jpg /tmp/
ceph osd pool stats

# crush
ceph osd crush reweight osd.10 1.5

{
        "Version": "2012-10-17",
        "Statement": [{
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": [
                        "arn:aws:s3:::images/*"
                ]
        }]
}

