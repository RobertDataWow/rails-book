class BookPolicy < ApplicationPolicy
  def update?
    user_creator?
  end

  def destroy?
    user_creator?
  end
end
