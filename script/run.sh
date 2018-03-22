#!/bin/sh
# ./run.sh

docker run -d -h gitlab.example.com \
	-p 3000:3000 -p 2222:22 \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    -e GITLAB_OMNIBUS_CONFIG="external_url 'http://gitlab.example.com:3000'; gitlab_rails['gitlab_shell_ssh_port']=2222;" \
	--name gitlab gitlab-ce

# Test in a web browser
#
# Access to <http://localhost:3000>
#
# login: root
# pwd: 5iveL!fe
