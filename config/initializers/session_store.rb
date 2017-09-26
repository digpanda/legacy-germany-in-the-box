Rails.application.config.session_store :redis_store, servers: {
  host: 'localhost',
  port: 6379,
  db: 0,
  password: ENV['redis_secret'],
  namespace: 'session'
}, expires_in: 300.minutes
