require "rubygems"
require "bundler/setup"
require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

class PoroClient
  def self.run(message_count = 100)
    message_count.times do
      Sidekiq::Client.push(
        'class' => 'PoroWorker',
        'args' => [rand]
      )
    end
  end
end

class PoroWorker
  include Sidekiq::Worker

  def perform(args)
    puts args
  end
end
