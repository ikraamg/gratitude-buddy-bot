#!/usr/bin/env ruby
require 'telegram/bot'
require_relative '../lib/state_manager.rb'
require 'dotenv/load'

file_data = File.read('./db/quotes.txt').split("\n")

def send_message(message, user)
  apikey = ENV['TELEGRAM_API_KEY']
  Telegram::Bot::Client.run(apikey) do |bot|
    bot.api.send_message(chat_id: user, text: message)
  end
end

loop do
  users = StateManager.items_in_managed_state('users')

  users.each do |user|
    send_message("Quote of the day:\n#{file_data[rand(0...file_data.size)]}", user)
    sleep(1)
  end
  sleep(28_800)

  users = StateManager.items_in_managed_state('users')

  users.each do |user|
    send_message("What were you grateful for today? 😊\nSend /write to log an entry", user)
    sleep(1)
  end
  sleep(28_800)

  users = StateManager.items_in_managed_state('users')

  users.each do |user|
    next unless File.file?("./db/#{user}.txt")

    user_entries = File.read("./db/#{user}.txt").split("\n")
    send_message("A past entry from your gratitude journal 🥳:\n #{user_entries[rand(0...user_entries.size)]}", user)
    sleep(1)
  end

  sleep(28_800)
end
