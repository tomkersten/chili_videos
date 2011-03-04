ActionController::Routing::Routes.draw do |map|
  map.resources :videos, :name_prefix => 'project_', :path_prefix => '/projects/:project_id', :collection => {:upload_complete => :get}
end
