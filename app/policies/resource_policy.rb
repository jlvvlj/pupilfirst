class ResourcePolicy < ApplicationPolicy
  def show?
    scope.where(id: record.id).exists?
  end

  def download?
    show?
  end

  def scope
    Pundit.policy_scope!(user, Resource.left_joins(:level))
  end

  class Scope < Scope
    def resolve
      # Public resources for everyone.
      resources = scope.where(level_id: nil, startup_id: nil)

      current_founder = user&.current_founder

      # Return public resources if current founder does not have active subscription...
      return resources unless current_founder.present? && current_founder.subscription_active?

      startup = current_founder.startup

      return resources if startup.dropped_out?

      # ...plus resources for the startup...
      resources = resources.or(scope.where(startup: startup))

      # ...plus resources based on the startup's course...
      resources = resources.or(scope.where('levels.course_id = ?', startup.course.id))

      # ...plus resources based on targets (for cloned courses)
      resources.or(scope.where(id: target_resource_ids(startup.course)))
    end

    def target_resource_ids(course)
      allowed_target_ids = course.levels.map do |level|
        level.target_groups.map do |target_group|
          target_group.targets.pluck(:id)
        end
      end
      TargetResource.where(target_id: allowed_target_ids.flatten).pluck(:resource_id)
    end
  end
end
