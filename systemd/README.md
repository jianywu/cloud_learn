# Example1: local_debug service
Can use service and target files to make sure some services will start every boot.
preset file used for auto enable services when start.

Target file is used for other services, like start after this target, or depend on this target.
Other simple ways without target file, will also automatically start after boot:
systemctl daemon-reload; systemctl restart local-debug; systemctl enable local-debug

# Example2: vncserver service:
put vncserver.service in dir: /etc/systemd/system/vncserver.service
systemctl daemon-reload; systemctl restart vncserver; systemctl enable vncserver
