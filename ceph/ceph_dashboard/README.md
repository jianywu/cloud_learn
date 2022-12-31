#!/bin/bash

# prometheus
打开prometheus监控模块的9283端口。
```bash
ceph mgr module enable prometheus
```

# grafana
模板ID 5336是ceph OSD。
https://grafana.com/grafana/dashboards/5336-ceph-osd-single/
模板ID 5342是ceph pools。
https://grafana.com/grafana/dashboards/5342-ceph-pools/
模板ID 7056或2842是ceph cluster。
https://grafana.com/grafana/dashboards/7056-ceph-cluster/
https://grafana.com/grafana/dashboards/2842-ceph-cluster/
