BDR::Application.routes.draw do
  resources :tips
  
  match '/' => redirect('/tips')
  match '/admin' => "Admin#index"
  match '/admin/add_admin' => "Admin#add_admin", :as => "add_admin"
  match '/admin/save_ldap' => "Admin#save_ldap", :as => "save_ldap"
  match '/admin/:id' => "Admin#destroy", :as => "delete_admin"
  match '/login' => "Application#login"
  match '/logout' => "Application#logout"
end
