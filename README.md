# ssh-tunnel-server

## Variables
```
# Source ports list
SOURCE_PORTS="22 80"
# Remote ports (a kind of prefix), example (calculation): $REMOTE_PORTS + $SOURCE_PORT = 10022
REMOTE_PORTS=10000
# Remote server bind to (e.g 0.0.0.0)
REMOTE_BIND=localhost
REMOTE_HOST=remote.example.com
REMOTE_USER=robot
```
## Initial (master) server setup
Use root or other fully privileged user account (with sudo)
```sh
git clone https://github.com/1it/ssh-tunnel-server.git
```
```sh
cd ssh-tunnel-server; SOURCE_PORTS="22 80" REMOTE_HOST="remote.example.com" ./server-bootstrap.sh
```

## Initial client setup
```sh
git clone https://github.com/1it/ssh-tunnel-server.git
```
```sh
cd ssh-tunnel-server; ./client-bootstrap.sh
```
You will see the ssh-rsa key line in script stdout and this message:
```
Put this key to your master server; Press Ctrl+C to continue
```
So, copy this line and paste it to the master server's /home/robot/.ssh/authorized_keys file.
And that's all.
You can check that the cron-job file created:
```sh
cat /etc/cron.d/ssh-tunnel
*/5 * * * * robot /home/$REMOTE_USER/ssh-tunnel start
```
To manually stop the tunnel:
```sh
cd /home/robot; ./ssh-tunnel stop
```
