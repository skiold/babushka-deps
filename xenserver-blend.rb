meta :iptables_port do
  accepts_list_for :port_name
  accepts_list_for :proto
  template {
    met? {
      iptables_rules = shell 'iptables --list'
      iptables_rules =~ /^ACCEPT.*#{proto} dpt:#{port_name}/
    }
    meet {
      chain = if grep %r{RH-Firewall-1-INPUT}, '/etc/sysconfig/iptables'
        "RH-Firewall-1-INPUT"
      else
        "INPUT"
      end
      shell "iptables -I #{chain} 10 -m state --state NEW " \
            "-m #{proto} -p #{proto} --dport #{port_name} -j ACCEPT"
      shell '/sbin/service iptables save'
    }
  }
end

dep 'ntp.iptables_port' do
  port_name 'ntp'
  proto 'udp'
end

dep 'snmp.iptables_port' do
  port_name 'snmp'
  proto 'udp'
end
