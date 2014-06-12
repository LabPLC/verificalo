module ActiveAdminHelper
  def self.included(dsl)
  end

  def pct (x, y)
    (x.to_f / y) * 100    
  end 
end 
