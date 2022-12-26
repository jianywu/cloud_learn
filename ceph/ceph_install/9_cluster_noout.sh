#!/bin/bash

ceph osd set noout
ceph -s
ceph osd set noout

