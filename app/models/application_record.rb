class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.latest_update_str
    last_modified = all.order(:updated_at).last
    last_modified.nil? ? 'nil' : last_modified.updated_at.to_s
  end
end
