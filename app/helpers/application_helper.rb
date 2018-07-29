module ApplicationHelper
  def full_title page_title = ""
    base_title = t "e_learning"
    page_title.empty? ? base_title : (page_title + " | " + base_title)
  end

  def active path_now
    if path_now.eql? request.path
      Settings.class_css.active
    else
      return if path_now.eql? root_path
      Settings.class_css.active if path_now.in? request.path
    end
  end

  def get_status lesson_log
    if lesson_log.saved?
      [t(".status0"), Settings.table.status.s0]
    elsif lesson_log.pass?
      [t(".status2"), Settings.table.status.s2]
    elsif lesson_log.pass.nil?
      [t(".status1"), Settings.table.status.s1]
    else
      [t(".status3"), Settings.table.status.s3]
    end
  end
end
