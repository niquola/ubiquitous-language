# This is just example of UL decomposition
# for redmine ProjectsController logic

result = user.as(ProjectManager)
.create
.new_project(params[:project])
.for_parent_project(params[:project][:parent_id])
.if_user_admin_or_has_permission('project#create')
.add_self_to_members_if_not_admin

result.project.should be_valid

result = user.as(ProjectManager)
.copy
.existing_project(params[:project_id])
.for_parent_project(params[:project][:parent_id])
.if_user_admin_or_has_permission_create_projects
.add_self_to_members_if_not_admin

result.project
result.new_project

result = user.as(ProjectViewer)
.view
.existing_project(project_id)
.with_users
.with_visible_subprojects
.with_news(5)
.with_trackers
.with_total_hours_if_allowed
.with_rss_key

result.total_hours
