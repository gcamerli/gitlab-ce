FROM base/archlinux:latest

LABEL maintainer="Gius. Camerlingo <gcamerli@gmail.com>"

# Container name
ENV NAME=gitlab-ce

# Set environment variables
ENV TERM=xterm

# Update and install packages
RUN pacman -Syu --noconfirm base-devel \
	redis \
	icu \
	npm \
	yarn \
	ed \
	cmake \
	openssh \
	git \
	go \
	re2 \
	unzip \
	vim \
	zsh \
	curl \
	autogen \
	yasm \
	xorg-server \
	xterm 

# Set no password for docker user
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create a new user
RUN useradd -ms /bin/zsh docker
USER docker
ENV HOME=/home/docker
WORKDIR $HOME

# Install package-query and yaourt
RUN git clone https://aur.archlinux.org/package-query.git
WORKDIR $HOME/package-query/
RUN makepkg --noconfirm -si
WORKDIR $HOME
RUN git clone https://aur.archlinux.org/yaourt.git
WORKDIR $HOME/yaourt/
RUN makepkg --noconfirm -si
WORKDIR $HOME
RUN rm -rf package-query/ yaourt/

# Install postgresql
RUN yaourt --noconfirm -S postgresql-9.6

# Install RVM
RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN curl -sSL https://get.rvm.io | bash -s stable

# Set zsh as default shell
RUN sudo chsh -s /usr/bin/zsh docker

# Set oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup RVM
RUN echo "[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm" >> $HOME/.zshrc

# Setup RVM
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN bash -l -c "rvm install 2.3.6"

# Setup GDK
RUN bash -l -c "gem install bundler"
RUN bash -l -c "gem install gitlab-development-kit"
RUN bash -l -c "gdk init"

WORKDIR $HOME/gitlab-development-kit
RUN echo 0.0.0.0 > host

# Install foreman
RUN bash -l -c "gem install foreman"

# Install GDK
RUN bash -l -c "gdk install"

# Run GDK
ENTRYPOINT ["gdk run"]
