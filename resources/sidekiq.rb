include Chef::Resource::ApplicationBase

attribute :role, :kind_of => [String, NilClass], :default => nil
attribute :namespace, :kind_of => String, :default => "sidekiq"
attribute :concurrency, :kind_of => Integer, :default => 25
attribute :redis_url, :kind_of => String, :default => "redis://localhost:6379/1"
attribute :rabbitmq_url, :kind_of => String, :default => "amqp://guest:guest@localhost/"
attribute :namespace, :kind_of => String, :default => "sidekiq"
attribute :mailer_default_url, :kind_of => String, :default => "medsensehq.com"
attribute :bundler, :kind_of => [TrueClass, FalseClass, NilClass], :default => nil
attribute :bundle_command, :kind_of => [String, NilClass], :default => "bundle"

def options(*args, &block)
  @options ||= Hash.new
  @options.update(options_block(*args, &block))
end
