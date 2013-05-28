class ProjectManager < UL::Sentence
  object :new_project do |attrs|
    @new_project = Project.new
    @new_project.safe_attributes = attrs
  end

  object :existing_project do |project_id|
    @project = Project.find(project_id)
  end

  object :for_parent_project,
    require: [:new_project] do |parent_id|
    return unless parent_id.present?
    parent = Project.find_by_id(parent_id.to_i)
    unless @new_project.allowed_parents.include?(parent)
      @new_project.errors.add :parent_id, :invalid
    end
    #...
  end

  conditions :if_admin_or_has_permission do
    unless subject.admin? || can_create_project?
      raise PermissionDenied.new('You do not have permissions to create project')
    end
  end

  verb :create, require:  [:new_project] do
    @new_project.save
  end

  post_action :add_self_to_members_if_not_admin,
    require: [:create] do
    unless subject.admin?
      @member = Member.new(:user => User.current,
                           :roles => [@role])
      @new_project.members << @member
    end
  end

  private

  def can_create_project(role)
    @role = Role.givable.find_by_id(Setting.new_project_user_role_id.to_i) || Role.givable.first
  end
end
