#
# Cookbook:: kibana-bash
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.


execute 'wget' do
  cwd 'opt'
  command 'sudo wget https://download.elastic.co/kibana/kibana/kibana-4.5.3-linux-x64.tar.gz'
  action :run
end

execute 'tar' do
  cwd 'opt'
  command 'sudo tar -xzf kibana-4.5.3-linux-x64.tar.gz'
  action :run
end

execute 'move' do
  cwd 'opt'
  command 'sudo mv kibana-4.5.3-linux-x64 kibana'
  action :run
end

remote_file '/opt/kibana/config/kibana.yml' do
  action :delete
end

template '/opt/kibana/config/kibana.yml' do
  source 'kibana.yml.erb'
end

bash 'kibana -ruby' do
  code <<-EOH
  sudo apt-get install ruby -y
  sudo gem install package pleaserun
  sudo pleaserun -p systemd -v default /opt/kibana/bin/kibana -p 5601 -H 34.241.99.167 -e http://54.171.108.175:9200
  EOH
end

service 'kibana' do
  action :enable
end

service 'kibana' do
  action :start
end
