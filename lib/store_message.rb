class StoreMessage
  def initialize(message_object, message)
    @user = message_object.chat.id
    @date = Time.at(message_object.date).strftime('%e %b %Y %k:%M')
    @message = message
  end

  # def store_message
  #   f = File.new("./db/#{@user}", 'a')
  #   f.write("#{@message}\n")
  #   f.close
  # end

  def store_message
    f = File.new("./db/#{@user}", 'a')
    f.write("#{@date}: #{@message}")
    f.close
  end

  def self.get_messages(user)
    string_out = "\n"
    entries = File.read("./db/#{user}").split("\n") if File.file?("./db/#{user}")
    entries.each do |entry|
      string_out += "\n#{entry}\n\n"
    end
    string_out
  end

  # def self.get_messages_with_date(user)
  #   File.read("./db/#{user}").split("\n") if File.file?("./db/#{user}")
  # end
end

# StoreMessage.new(296_643_681, 'hi there!').store_message
# p StoreMessage.get_messages(296_643_681)
