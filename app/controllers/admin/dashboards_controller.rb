class Admin::DashboardsController < AdminController
  def show
    @stats = {
      :yums_count => Yum.count,
    }
    @reports = Yum.find(:all, :conditions => ['not_yummy_image = ? AND report_count > ? AND created_at >= ?', false, 0, 3.days.ago])
  end
  
end
