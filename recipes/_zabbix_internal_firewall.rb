networks = ['137.229.0.0/16','199.165.64.0/18','172.16.0.0/10','10.0.0.0/8']
networks.each do |network|
  firewall_rule "Zabbix Port 10050 from #{network}" do
    port 10050
    source network
    command :allow
  end
  firewall_rule "Zabbix Port 10051 from #{network}" do
    port 10051
    source network
    command :allow
  end
end
