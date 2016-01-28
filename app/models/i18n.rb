class I18n
  class << self
    def create_method(name)
      define_method(name) { puts "Nice!  I'm #{name}" }
    end
  end
end