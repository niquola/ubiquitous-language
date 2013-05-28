class ProjectViewer < UL::Sentence
  attr_reader :project

  object :existing_project do |project_id|
    @project = Project.find(project_id)
  end

  attr_reader :users_by_role
  post_action :with_users_by_role,
    require: :existing_project do
    @users_by_role = @project.users_by_role
  end

  attr_reader :news
  post_action :with_news,
    require: :existing_project do |limit|
    @news = @project.news
    .limit(limit)
    .includes(:author, :project)
    .reorder("#{News.table_name}.created_on DESC").all
  end

  attr_reader :trackers
  post_action :with_trackers,
    require: :existing_project do |limit|
    @trackers = @project.rolled_up_trackers
  end

  post_action :with_total_hours_if_allowed,
    require: :existing_project do
    if subject.allowed_to?(:view_time_entries, @project)
      cond = @project.project_condition(Setting.display_subprojects_issues?)
      @total_hours = TimeEntry.visible.sum(:hours, :include => :project, :conditions => cond).to_f
    end
  end
end
