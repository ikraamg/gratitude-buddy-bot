class StoreMessage
  def initialize(user, message)
    @user = user
    @message = message
  end

  def store_message
    # file_location =
    f = File.new("./db/#{@user}", 'a')
    f.write("#{@message}\n")
    f.close
  end

  def self.get_messages(user)
    File.read("./db/#{user}").split("\n")
  end
end

# StoreMessage.new(296_643_681, 'hi there!').store_message
# p StoreMessage.get_messages(296_643_681)
