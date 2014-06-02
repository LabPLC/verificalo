ActiveAdmin.register Answer do
  menu(priority: 2)
  permit_params(:category_id, :contact_id, :url, :title, :body, 
                :related_1_id, :related_2_id, :related_3_id, :related_4_id, :related_5_id)
end
