require 'json'

class RenderJSON
  def initialize
    super
  end

  def self.instance
    @instance ||= RenderJSON.new
  end

  def open(path)
    @file = File.open(path, 'w')
  end

  def close
    @file.close
  end

  def render(**hash)
    @file.puts(hash.to_json)
  end
end
