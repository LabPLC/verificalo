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
end
