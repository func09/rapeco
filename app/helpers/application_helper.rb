module ApplicationHelper
  # @param [Hash<Symbol>] options
  # @option :size :thumb or large
  def photo_url_with_yum(yum, options = {:size => :thumb} )
    url = ''
    case yum.photo_service
    when 'twitpic'
      if options[:size] == :large
        url = yum.photo_url.sub(/(\w+)$/,'show/iphone/\1')
      else
        url = yum.photo_url.sub(/(\w+)$/,'show/thumb/\1')
      end
    when 'yfrog'
      if options[:size] == :large
        url = yum.photo_url.sub(/$/,':iphone')
      else
        url = yum.photo_url.sub(/$/,'.th.jpg')
      end
    when 'movapic'
      if options[:size] == :large
        if yum.photo_url =~ /(\w+)$/
          url = "http://image.movapic.com/pic/m_#{$1}.jpeg"
        end
      else
        if yum.photo_url =~ /(\w+)$/
          url = "http://image.movapic.com/pic/s_#{$1}.jpeg"
        end
      end
    end
    url
  rescue
    # [FIXME] 原因不明だけどたまにyum#photo_urlがnilな時があります
    # その場合は空文字を返す、もしくはNOIMAGE
    return ""
  end
end
