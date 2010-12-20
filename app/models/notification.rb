#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
#
class Notification < ActiveRecord::Base

  belongs_to :recipient, :class_name => 'User'
  belongs_to :actor, :class_name => 'Person'
  belongs_to :target, :polymorphic => true

  def self.for(recipient, opts={})
    self.where(opts.merge!(:recipient_id => recipient.id)).order('created_at desc')
  end

  def self.notify(recipient, target, actor)
    if target.respond_to? :notification_type
      if action = target.notification_type(recipient, actor)
        create(:target => target,
               :action => action,
               :actor => actor,
               :recipient => recipient)
       end
    end
  end
end
