class SimpleLinkRenderer < WillPaginate::LinkRenderer
  def to_html
    #links = @options[:page_links] ? windowed_links : []
    # previous/next buttons
    #links.unshift page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
    #links.push    page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
    prev_link = page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
    next_link = page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
    # html = links.join(@options[:separator])
    html = "#{prev_link} #{@collection.current_page} / #{@collection.total_pages} ページ #{next_link}"
    @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
  end
end
