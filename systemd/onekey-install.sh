# NOTE: systemd file name use hyphen -, but shell scripts use underscore _.
set -x

echo "dependency test: network-online and  need to be active, otherwise, change to other dependency targets."
systemctl status network-online.target
systemctl status multi-user.target

echo "copy files to target directories."
\cp local-debug.service /etc/systemd/system/local-debug.service
\cp local-debug-ready.target /etc/systemd/system/local-debug-ready.target
\cp 39-local-debug.preset /usr/lib/systemd/system-preset/39-local-debug.preset
mkdir -pv /apps/local_debug
\cp local_debug.sh /apps/local_debug/local_debug.sh

systemctl daemon-reload

# Can comment those parts, it is expected to be enabled automatically after reboot.
echo "local test without restart"
systemctl start local-debug
systemctl enable local-debug
sleep 5
systemctl status local-debug
systemctl status local-debug-ready.target

echo "local debug service install finish."
