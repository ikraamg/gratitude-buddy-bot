#!/usr/bin/env ruby
require 'telegram/bot'
require 'dotenv/load'
require_relative '../lib/state_manager.rb'
require_relative '../lib/store_message.rb'
file_data = File.read('./db/quotes.txt').split("\n")

token = ENV['TELEGRAM_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    chat_id = message.chat.id
    case message.text
    when %r{^/start}
      bot.api.send_message(chat_id: chat_id, text: "Hi there!\nGreat to meet you #{message.from.first_name} 😁 \nI'm going to send you a little gratitude quote everyday. Get one immediately by typing /quote\nYou can write or view a gratitude entry by typing /write and /view\nIf you would like me to pause or re-start the quotes, you can reply with /stop and /start")

      StateManager.new(message, 'users').true_state
      StateManager.new(message, 'writers').false_state

      # logging
      puts message.from.first_name

    when %r{^/stop}
      bot.api.send_message(chat_id: chat_id, text: "Your reminders are now paused. Catch you later, #{message.from.first_name}")

      StateManager.new(message, 'users').false_state
      StateManager.new(message, 'writers').false_state

    when %r{^/write}
      bot.api.send_message(chat_id: chat_id, text: "What are you grateful for?\n(I will randomly remind you of this entry in the future to bring a smile to your face 🥳)\nTo cancel this entry type /cancel")

      # Write.new(chat_id)
      StateManager.new(message, 'writers').true_state

    when %r{^/cancel}
      StateManager.new(message, 'writers').false_state

      bot.api.send_message(chat_id: chat_id, text: 'New-Entry Cancelled ')
      StateManager.new(message, 'writers').false_state

    when %r{^/view}
      bot.api.send_message(chat_id: chat_id, text: " Here is your journal entries: #{StoreMessage.new(message).messages}")
      StateManager.new(message, 'writers').false_state

    when %r{^/quote}
      bot.api.send_message(chat_id: chat_id, text: (file_data[rand(1...file_data.size)]).to_s)
      StateManager.new(message, 'writers').false_state
    else
      if StateManager.new(message, 'writers').state?
        StateManager.new(message, 'writers').false_state
        StoreMessage.new(message).store_message
        bot.api.send_message(chat_id: chat_id, text: "I'm happy for you! I've saved your entry, if you would like to have a look at your entries you can send me /view")
      end
    end
  end
end
