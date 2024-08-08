# Base image
FROM ubuntu:20.04

# Install required packages
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    xrdp \
    tightvncserver \
    wget \
    novnc \
    websockify \
    supervisor

# Set up XRDP
RUN echo "xfce4-session" > ~/.xsession

# Install noVNC
RUN mkdir -p /opt/novnc/utils/websockify && \
    wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz | tar xz --strip-components=1 -C /opt/novnc && \
    wget -qO- https://github.com/novnc/websockify/archive/refs/tags/v0.9.0.tar.gz | tar xz --strip-components=1 -C /opt/novnc/utils/websockify

# Configure VNC server
RUN mkdir ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Create a supervisor config file
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose necessary ports
EXPOSE 6080 5901 3389

CMD ["/usr/bin/supervisord"]
