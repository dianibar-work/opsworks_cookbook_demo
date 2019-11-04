directory '/tmp' do
  owner 'root'
  group 'root'
  mode '1777'
end

apt_repository 'nginx' do
  uri 'http://nginx.org/packages/ubuntu/'
  key 'ABF5BD827BD9BF62'
  components ['nginx']
end

package 'nginx' do
  version "1.10.2-1~#{node['lsb']['codename']}"
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
  only_if { File.exist?('/etc/nginx/conf.d/default.conf') }
end

execute 'test nginx config' do
  # this fails if the nginx config is invalid -- `service nginx start` does not, oddly enough
  command 'nginx -t -c /etc/nginx/nginx.conf'
end

service 'nginx' do
  action [:enable, :reload, :restart]
end
