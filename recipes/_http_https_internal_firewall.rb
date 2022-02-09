networks = ['137.229.0.0/16','199.165.64.0/18','172.16.0.0/10','10.0.0.0/8']
networks.each do |network|
  firewall_rule "HTTP from #{network}" do
    port 80
    source network
    command :allow
  end
  firewall_rule "HTTPS from #{network}" do
    port 443
    source network
    command :allow
  end
end
