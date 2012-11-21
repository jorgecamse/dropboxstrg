module Dropboxstrg
  class Param < ActiveRecord::Base

    attr_accessible :akey, :asecret

    belongs_to :user, :class_name => Dropboxstrg.user_class
  end
end
