module AnswersHelper
  def gmap? (o)
    return false unless o.lat || o.lon
    true
  end

  def gmap (o)
    return unless gmap?(o)
    gmap = 'http://maps.google.com/?daddr='
    gmap += o.lat.to_s + ','
    gmap += o.lon.to_s + '&z=15'
    gmap
  end
  
  def related? (a)
    return true if related(a).count > 0
    false
  end
  
  def related (a)
    [ a.related_1, a.related_2, a.related_3, a.related_4,
      a.related_5 ].compact
  end

  def parent_category?
    return false unless request.referer
    category_url = url_for({ controller: 'answers', 
                             action: 'category',
                             category_url: @answer.category.url })
    if request.referer.match(/#{Regexp.escape(category_url)}\z/)
      return true
    end
    false
  end

  def parent_search?
    return false unless request.referer
    search_url = url_for({ controller: 'answers', action: 'search' }) + '?'
    if request.referer.match(/#{Regexp.escape(search_url)}/)
      return true
    end
    false
  end
end
