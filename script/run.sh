#!/bin/sh
# ./run.sh

docker run -it -h gitlab.example.com -p 3000:3000 --name gitlab-ce gitlab-ce zsh

# Test in a web browser
#
# Access to <http://gitlab.example.com:3000>
#
# login: root
# pwd: 5iveL!fe
