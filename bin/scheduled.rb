#!/usr/bin/env ruby
require 'telegram/bot'
require_relative '../lib/state_manager.rb'
require 'dotenv/load'

token = ENV['TELEGRAM_API_KEY']

file_data = File.read('./db/quotes.txt').split("\n")

loop do
  users = StateManager.items_in_managed_state('users')

  users.each do |user|
    Telegram::Bot::Client.run(token) do |bot|
      bot.api.send_message(chat_id: user, text: "Quote of the day:\n#{file_data[rand(1...file_data.size)]}")
    end

    p user
    sleep(1)
  end

  puts Time.now
  sleep(14_400)
end
