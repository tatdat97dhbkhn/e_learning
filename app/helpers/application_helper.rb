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

  def finished_lesson_log lesson_log
    status = lesson_log.pass
    return if status || status == false
    true
  end

  def get_status lesson_log
    if lesson_log.saved?
      [t(".status0"), Settings.table.status.s0]
    elsif lesson_log.pass?
      [t(".status2"), Settings.table.status.s2]
    elsif finished_lesson_log lesson_log
      [t(".status1"), Settings.table.status.s1]
    else
      [t(".status3"), Settings.table.status.s3]
    end
  end

  def sub_answer_field form
    sub_address = form.object.answers.build
    form.fields_for :answers, sub_address,
      child_index: "hello" do |builder|
      render "answer_fields", f: builder
    end
  end
  
  def decide_action
    if Settings.action.restore.in? request.path
      t ".restore"
    else
      t ".delete"
    end
  end

  def decide_answer question_log
    return if finished_lesson_log question_log.lesson_log ||
      !question_log.answer.correct
    Settings.glyphicon.ok
  end

  def status_lesson_log lesson_log
    if finished_lesson_log lesson_log
      edit_lesson_log_path lesson_log
    else
      url_for lesson_log
    end
  end
end
