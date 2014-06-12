module ActiveAdminHelper
  def self.included (dsl)
    
  end

  def pct (x, y)
    if y > 0
      (x.to_f / y) * 100 
    else
      0
    end
  end

  def stats (x, y = nil)
    if y != nil
      '<td>' + x.to_s + '</td><td>' + pct(x.to_i, y.to_i).to_s + '</td>'
    else
      '<td>' + x.to_s + '</td><td>100.0</td>'
    end
  end  
end
