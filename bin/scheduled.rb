#!/usr/bin/env ruby
# frozen_string_literal: true

require 'telegram/bot'
require_relative '../lib/entries.rb'
file_data = File.read('quotes.txt').split("\n")

token = '1231002234:AAGAlG8tDpS6M7JOe9WNeEJWvCQVglvLJV0'

token = '1231002234:AAGAlG8tDpS6M7JOe9WNeEJWvCQVglvLJV0'

loop do
  users = Entries.users
  # users = [1_147_048_017, 296_643_681]
  i = 0
  while i < users.size
    user = users[i].to_i

    Telegram::Bot::Client.run(token) do |bot|
      bot.api.send_message(chat_id: user, text: "Quote of the day:\n#{file_data[rand(1...file_data.size)]}")
    end
    p user
    i += 1
  end
  sleep(14_400)
end
