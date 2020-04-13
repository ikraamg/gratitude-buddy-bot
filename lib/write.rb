# frozen_string_literal: true

require_relative 'entries.rb'

class Write < Entries
  @@file = './db/write_state.txt'

  def initialize(user)
    @user = user
    @file = './db/write_state.txt'
    @@users = update_array(@user, @file)
  end

  def self.in_write_state?(user)
    current_users = File.read('./db/write_state.txt').split("\n")
    puts current_users
    return true if current_users.include? user.to_s
  end
end

# puts Write.in_write_state?(296_643_681)
# puts Write.new(296_643_681)
# puts Write.new(296_643_681).remove_user(296_643_681)
