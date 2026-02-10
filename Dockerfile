FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ---------- Base packages ----------
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    git \
    vim \
    net-tools \
    tzdata \
    software-properties-common \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    x11-apps \
    xfce4 \
    xfce4-goodies \
    xubuntu-icon-theme \
    tigervnc-standalone-server \
    novnc \
    websockify \
    python3-pip \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# ---------- Install ttyd (NO prompt) ----------
RUN apt-get update && apt-get install -y ttyd && rm -rf /var/lib/apt/lists/*

# ---------- Python tools ----------
RUN pip3 install --no-cache-dir gdown

# ---------- X authority ----------
RUN touch /root/.Xauthority

# ---------- Expose ports ----------
EXPOSE 5901
EXPOSE 6080
EXPOSE 7681

# ---------- Runtime command ----------
CMD bash -c "\
vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
ttyd -p 7681 bash && \
tail -f /dev/null"
