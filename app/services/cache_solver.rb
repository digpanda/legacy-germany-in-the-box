require 'stringio'

# redirect output to StringIO objects
stdout, stderr = StringIO.new, StringIO.new
$stdout, $stderr = stdout, stderr

# output is captured
puts 'foo'
warn 'bar'

# restore normal output
$stdout, $stderr = STDOUT, STDERR

class CacheSolver
  attr_reader :resources

  def initialize(resources)
    @resources = resources
  end

  def solve(&block)
    return read_cache if read_cache

    # the outputs occurs here for now
    data = block.call

    write_cache(data)
    read_cache
    ""
  end

  private

  def read_cache
    Rails.cache.fetch(cache_key)
  end

  def write_cache(data)
    Rails.cache.write(cache_key, data)
  end

  def cache_key
    @cache_key ||= begin
      resources.map do |resource|
        if resource.respond_to?(:id)
          resource.id.to_s
        elsif resource.nil?
          'nil'
        else
          resource.to_s
        end
      end.join('-')
    end
  end

end
