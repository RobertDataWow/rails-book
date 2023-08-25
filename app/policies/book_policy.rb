class BookPolicy < ApplicationPolicy
  def update?
    user_creator?
  end

  def destroy?
    user_creator?
  end

  def user_creator?
    record.user == user
  end
end
