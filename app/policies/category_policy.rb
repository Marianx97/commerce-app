class CategoryPolicy < BasePolicy
  # Overriding parent method_missing because all actions do the same check
  def method_missing(m, *args, &block)
    Current.user.admin?
  end

  # def index
  #   Current.user.admin?
  # end

  # def new
  #   Current.user.admin?
  # end

  # def create
  #   Current.user.admin?
  # end

  # def edit
  #   Current.user.admin?
  # end

  # def update
  #   Current.user.admin?
  # end

  # def destroy
  #   Current.user.admin?
  # end
end
