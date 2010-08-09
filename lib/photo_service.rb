module PhotoService
  
  def self.find_in_text(text)
    photo = nil
    SERVICES.each do |service|
      if text =~ service::REGEXP
        photo = service.new($1)
      end
    end
    return photo
  end
  
  def self.get_instance(service_name, url)
    klass = "PhotoService::#{service_name.classify}".constantize
    klass.new(url)
  end
  
  class Base
    
    SERVICE_NAME = 'base'
    REGEXP = //
    
    attr_accessor :url
    attr_accessor :service_name
    
    def initialize(url)
      @url = url
      @service_name = self.class::SERVICE_NAME
    end
    
    def valid?
      !!@url.match(self.class::REGEXP)
    end
    
    # @param [String] size 'thumb' or 'large'. default is 'thumb'
    def image_url(size = 'thumb')
      return ''
    end
    
  end
  
  class Twitpic < Base
    SERVICE_NAME = 'twitpic'
    REGEXP = /(http:\/\/twitpic\.com\/[a-zA-Z0-9]{6})/
    
    # urlから画像URLを探す
    # @param [String] size 'thumb' or 'large'. default is 'thumb'
    def image_url(size = 'thumb')
      case size.to_s
      when 'thumb'
        url = self.url.sub(/(\w+)$/,'show/thumb/\1')
      when 'large'
        url = self.url.sub(/(\w+)$/,'show/iphone/\1')
      end
    end
    
  end
  
  class Yfrog < Base
    SERVICE_NAME = 'yfrog'
    REGEXP = /(http:\/\/yfrog\.com\/[a-zA-Z0-9]+)/
    
    # urlから画像URLを探す
    # @param [String] size 'thumb' or 'large'. default is 'thumb'
    def image_url(size = 'thumb')
      case size.to_s
      when 'thumb'
        url = self.url.sub(/$/,':iphone')
      when 'large'
        url = self.url.sub(/$/,':iphone')
      end
    end
    
  end
  
  class Movapic < Base
    SERVICE_NAME = 'movapic'
    REGEXP = /(http:\/\/movapic\.com\/pic\/[a-zA-Z0-9]+)/
    
    # urlから画像URLを探す
    # @param [String] size 'thumb' or 'large'. default is 'thumb'
    def image_url(size = 'thumb')
      case size.to_s
      when 'thumb'
        if self.url =~ /(\w+)$/
          url = "http://image.movapic.com/pic/s_#{$1}.jpeg"
        end
      when 'large'
        if self.url =~ /(\w+)$/
          url = "http://image.movapic.com/pic/m_#{$1}.jpeg"
        end
      end
    end
    
  end
  
  SERVICES = [Twitpic,Yfrog,Movapic]
  
end
