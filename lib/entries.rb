class Entries
  attr_reader :user, :file
  @@users = []
  @@file = './db/users.txt'

  def initialize(user)
    @user = user
    @file = './db/users.txt'
    @@users = update_array(@user, @file)
  end

  def self.users
    @@users = File.read(@@file).split("\n")
  end

  def remove_user(usr)
    usrs = File.read(@file).split("\n")
    usrs.delete(usr.to_s)
    f = File.new(@file, 'w')
    usrs.each do |item|
      f.write("#{item}\n")
    end
    f.close
  end

  private

  def update_array(user, file)
    current_users = File.read(file).split("\n")
    unless current_users.include? user.to_s
      f = File.new(file, 'a')
      f.write("#{user}\n")
      f.close
    end
    current_users
  end

  # def store_entry(user, data)
  #   entry_data[user.to_sym][Time.new.strftime('%Y%m%d%H%M%S').to_s.to_sym.to_sym] = data
  # end

  # def get_entry(user, time_stamp)
  #   entry_data[user.to_sym][time_stamp]
  # end
  # private
end

# iks = Entries.new('Ikraam')
# print Entries.users

# //////////////////////////////////
# puts Entries.new.store_entry('ikraam', 'blah blah')

# # entry_data = { ikraam: {} }
# entry_data = Hash.new(0)

# # p entry_data

# entry_data[:ikraam][Time.new.strftime('%Y%m%d%H%M%S').to_s.to_sym] = 'hi there'

# sleep(1)

# entry_data[:ikraam][Time.new.strftime('%Y%m%d%H%M%S').to_s.to_sym] = 'hi there 2'

# sleep(1)

# entry_data[:ikraam][Time.new.strftime('%Y%m%d%H%M%S').to_s.to_sym] = 'hi there 3'

# p entry_data

# entry_loc = entry_data[:ikraam].keys.grep /2020041121/
