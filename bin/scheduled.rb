#!/usr/bin/env ruby
require 'telegram/bot'
require_relative '../lib/entries.rb'
require 'dotenv/load'
file_data = File.read('./db/quotes.txt').split("\n")

token = ENV['TELEGRAM_API_KEY']

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
    sleep(1)
    i += 1
  end
  puts Time.now
  sleep(14_400)
end
