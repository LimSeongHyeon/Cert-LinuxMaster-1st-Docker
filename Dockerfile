FROM rockylinux:8

# 기본 패키지 설치
RUN dnf -y update

# Enable EPEL repository (for some packages like bpftrace, etc.)
RUN dnf -y install epel-release

RUN dnf -y groupinstall "Development Tools"

# Basic Tools
RUN dnf -y install \
    sudo man man-pages bash-completion vim less wget curl which tar unzip util-linux hostname systemd procps-ng dump

# Networking
RUN dnf -y install \
    net-tools iproute iputils openssh openssh-clients rsync

# Hardware Utilities
RUN dnf -y install \
    pciutils usbutils

# Kernel & Module
RUN dnf -y install \
    kmod kernel-devel kernel-headers bpftool bpftrace bcc bcc-tools

# SELinux
RUN dnf -y install \
    libselinux-utils policycoreutils selinux-policy selinux-policy-devel selinux-policy-targeted setools-console checkpolicy

# Filesystem & Block
RUN dnf -y install \
    e2fsprogs xfsprogs mdadm lvm2 cryptsetup

# File Utilities
RUN dnf -y install \
    findutils cpio

# Scheduling
RUN dnf -y install \
    cronie crontabs at

# Logging & Security
RUN dnf -y install \
    rsyslog

# SSH & User Tools
RUN dnf -y install \
    passwd shadow-utils openssh-clients

# Compilation & Development
RUN dnf -y install \
    gcc make elfutils-libelf-devel

# Package Management
RUN dnf -y install \
    rpm dnf yum

# Additional utilities
RUN dnf -y install \
    mlocate

# Printer Utilities
RUN dnf -y install \
    cups cups-client cups-filesystem

# Web Service
RUN dnf -y install \
    httpd

RUN dnf clean all

# 시스템 타임존 설정 (선택)
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# 기본 rsyslog 설정파일이 없다면 생성
RUN [ ! -f /etc/rsyslog.conf ] && echo "\
\$ModLoad imuxsock\n\
\$ModLoad imklog\n\
*.info;mail.none;authpriv.none;cron.none /var/log/messages\n\
" > /etc/rsyslog.conf || true

# rsyslog 로그 디렉토리 생성
RUN mkdir -p /var/log

# 최종 업데이트 반영
RUN mandb
RUN updatedb
RUN dnf -y update

# rsyslog 시작 및 bash 진입
CMD ["sh", "-c", "rsyslogd && /bin/bash"]