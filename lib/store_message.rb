require_relative './database_management'

class StoreMessage
  include DatabaseManagement

  def initialize(message_object)
    @user = message_object.chat.id
    @date = Time.at(message_object.date).strftime('%e %b %Y %k:%M')
    @message = message_object.text.to_s
  end

  def store_message
    date_and_message = "#{@date}: #{@message}\n"
    append_to_file(@user, date_and_message)
  end

  def messages
    return unless file_exists?(@user)

    string_out = "\n"
    file_to_array(@user).each do |entry|
      string_out += "\n#{entry}\n"
    end
    string_out
  end
end

# StoreMessage.new(296_643_681, 'hi there!').store_message