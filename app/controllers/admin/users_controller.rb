class Admin::UsersController < AdminController
  active_scaffold :user do |config|
  end
end
