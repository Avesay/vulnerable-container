# Author: Julia Konarzewska
#
# Docker container running the Ubuntu image
# affected by CVE-2018-15473 (SSH Username Enumeration)
# and SNMPv1/v2 “Public Community Strings” vulnerabilities

FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
	    openssh-server \
        snmpd && \
    apt-get clean

RUN echo "agentAddress udp:161" > /etc/snmp/snmpd.conf && \
    echo "rocommunity public" >> /etc/snmp/snmpd.conf && \
    echo "rwcommunity public" >> /etc/snmp/snmpd.conf

RUN sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22 161/udp

ENTRYPOINT service ssh restart && service snmpd start && bash

