services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "11"
      RAM_SIZE: "6G"
      DISK_SIZE: "100G"
      DISK2_SIZE: "1.5T"
      CPU_CORES: "4"
      LANGUAGE: "Chinese"
      USERNAME: "yuchanns"
      PASSWORD: ${WINDOWS_PASSWORD}
      DHCP: "Y"
      GPU: "Y"
    device_cgroup_rules:
      - 'c *:* rwm'
    devices:
      - /dev/kvm
      - /dev/net/tun
      - /dev/vhost-net
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006
      - 3389:3389/tcp
      - 3389:3389/udp
    volumes:
      - ./storage:/storage
      - ./win11.iso:/boot.iso
      - ./shared:/shared
      - ./storage2:/storage2
    restart: always
    stop_grace_period: 2m
    networks:
      router:
        ipv4_address: 10.9.60.192
    blkio_config:
      device_read_bps:
        - path: /dev/nvme0n1
          rate: "150mb"
      device_write_bps:
        - path: /dev/nvme0n1
          rate: "60mb"
      device_write_iops:
        - path: /dev/nvme0n1
          rate: 1000

networks:
  router:
    external: true
