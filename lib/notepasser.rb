require "notepasser/version"
require "notepasser/init_db"
require "camping"
require "pry"

Camping.goes :Notepasser

module Notepasser

end

module Notepasser::Models
  class User < Base
    has_many :messages
  end

  class Message < Base
    belongs_to :user
  end
end

module Notepasser::Controllers
  class NewuserController < R '/users'
    def create_user
    username = Notepasser::Models::User.create
      [:user, :user_id].each do |t|
        username[t] = @input[t]
      end
    username.save
    {create_user => username}.to_json
    end
  end

  class UserController < R '/users/(\d+)'
    def user(user_id)
      user = Notepasser::Models::User.find(user_id)
    end

    def delete(user_id)
      user = Notepasser::Models::User.destroy(user_id)
    end
  end

  class NewmessageController < R '/msg/new'
    def create_msg
    msg = Notepasser::Models::Message.create
    [:message, :message_id, :user_id, :receive_id].each do |m|
      msg[m] = @input[m]
     end
     msg.save
     {create_msg => msg}.to_json
  end

  class MessageController < R '/msg/(\d+)'
    def messages(message_id)
      msg = Notepasser::Models::Message.find(message_id)
      msg.to_json
    end

    def delete(message_id)
      msg = Notepasser::Models::Message.find(message_id)
      msg.destroy
    end

end
