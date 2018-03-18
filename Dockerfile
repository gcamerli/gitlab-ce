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
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable

# Set zsh as default shell
RUN sudo chsh -s /usr/bin/zsh docker

# Set oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup RVM
RUN echo "[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm" >> $HOME/.zshrc

# Copy post install setup
COPY ./rvm_setup.sh .
COPY ./gdk_setup.sh .
