class TokyoTyrantSweeper

  def initialize(host = 'localhost', port = 1978, options = {})
    @host = host
    @port = port
    @options = options
  end

  def list
    %x{ tcrmgr list #{@host}:#{@port} }.split(/\n/)
  end

  def find(keyword)
    %x{ tcrmgr list #{@host}:#{@port} | grep #{keyword} }.split(/\n/)
  end
  
  def sweep(keyword)
    find(keyword).each do |key|
      %x{ tcrmgr out #{@host}:#{@port} '#{key}' }
    end
  end
  
end
