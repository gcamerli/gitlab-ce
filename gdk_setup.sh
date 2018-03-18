#/bin/sh
# ./gdk_setup.sh

# Set rvm
#
# $ rvm 2.3.6

# Install bundler
gem install bundler

# Setup GDK
gem install gitlab-development-kit
gdk init

# Change host
cd gitlab-development-kit
echo 0.0.0.0 > host

# Install foreman
gem install foreman

# Install gdk
gdk install

# Run Gitlab
#
# $ gdk run
