require_relative './database_management'

class StoreMessage
  include DatabaseManagement

  def initialize(message_object)
    @user = message_object.chat.id
    @date = Time.at(message_object.date).strftime('%e %b %Y %k:%M')
    @message = message_object.text.to_s
  end

  def store_message
    date_and_message = "#{@date}: #{@message}"
    append_to_file(@user, date_and_message)
  end

  def delete_message(index)
    return if index.zero?

    entry_to_delete = file_to_array(@user)[index - 1]
    remove_from_file(@user, entry_to_delete)
  end

  def messages
    return unless file_exists?(@user)

    string_out = "\n"
    file_to_array(@user).each_with_index do |entry, i|
      string_out += "\n#{i + 1}. #{entry}\n"
    end
    string_out
  end
end
