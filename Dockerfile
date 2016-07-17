#
# Based on work from kdelfour/cloud9-docker
#
FROM cloud9/ws-default
MAINTAINER j7an <github.com/j7an/cloud9-workspace>

# Install base
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs python2.7 python2.7-dev

# Install Cloud9 as ubuntu user
RUN su ubuntu -c "git clone https://github.com/c9/core.git /home/ubuntu/cloud9"
WORKDIR /home/ubuntu/cloud9
RUN su ubuntu -c "scripts/install-sdk.sh"

# Tweak standlone.js conf
RUN su ubuntu -c "sed -i -e 's_127.0.0.1_0.0.0.0_g' /home/ubuntu/cloud9/configs/standalone.js"

# Fix PTY
RUN su ubuntu -c "C9_DIR=$HOME/.c9"
RUN su ubuntu -c 'PATH="$C9_DIR/node/bin/:$C9_DIR/node_modules/.bin:$PATH"'
RUN su ubuntu -c "cd $C9_DIR"
RUN su ubuntu -c "nvm install node"
RUN su ubuntu -c "npm install pty.js"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports.
EXPOSE 80
EXPOSE 3000
