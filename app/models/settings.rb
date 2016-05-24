require 'singleton'

class Settings
  include Singleton
  include MongoidBase

  @@instance ||= Settings.first_or_create()

  private_class_method :create
end