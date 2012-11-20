#
# Cookbook Name:: application_ruby
# Provider:: sidekiq

action :before_compile do
  new_resource.symlink_before_migrate.update({"sidekiq.yml" => "config/sidekiq.yml"})

  unless new_resource.restart_command
    new_resource.restart_command do
      execute "/etc/init.d/sidekiq-#{new_resource.name} hup" do
        user "root"
      end
    end
  end
end

action :before_deploy do
  results = search(:node, "role:#{new_resource.role} AND chef_envrionment:#{node.chef_environment} NOT hostname:#{node['hostname']}")
  if results.length == 0
    if node['roles'].include?(new_resource.role)
      results << node
    end
  end
  Chef::Log.warn("No node with role #{new_resource.role}") unless results.any?

  template "#{new_resource.application.path}/shared/sidekiq.yml" do
    source "sidekiq.yml.erb"
    cookbook "application_ruby"
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables.update(:env => new_resource.environment_name,
                    :hosts => results.sort_by { |r| r.name },
                    :namespace => new_resource.namespace,
                    :concurrency => new_resource.concurrency,
                    :options => new_resource.options)
  end
end

action :before_migrate do

end

action :before_symlink do

end

action :before_restart do
  new_resource = @new_resource

  runit_service "sidekiq-#{new_resource.name}" do
    template_name "sidekiq"
    owner new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group

    cookbook 'application_ruby'
    options(:app => new_resource,
            :bundler => new_resource.bundler,
            :bundle_command => new_resource.bundle_command,
            :redis_url => new_resource.redis_url,
            :namespace => new_resource.namespace,
            :rails_env => new_resource.environment_name)
    run_restart false
  end
end

action :after_restart do

end
