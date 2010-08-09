class Admin::CommentsController < AdminController
  active_scaffold :comment do |config|
    #config.columns = [:id, :title, :body, :type, :published_at, :hidden, :impotant]
    #config.create.columns.exclude :id
    #config.update.columns.exclude :id
    #config.columns[:type].form_ui = :select
    #config.columns[:type].options = {:options => Notice::TYPES}
  end
end
