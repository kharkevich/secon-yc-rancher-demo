#cloud-config
write_files:
  - content: |
          net.ipv4.ip_forward = 1
    path: /etc/sysctl.d/98-ip-forward.conf

runcmd:
  - [ 'iptables', '-t', 'nat', '-A', 'POSTROUTING', '-o', 'eth0', '-j', 'MASQUERADE' ]
  - [ 'iptables-save' ]
  - [ 'sysctl', '-p', '/etc/sysctl.d/98-ip-forward.conf' ]
