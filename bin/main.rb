#!/usr/bin/env ruby
# rubocop: disable Metrics/BlockLength
require 'telegram/bot'
require 'dotenv/load'
require_relative '../lib/state_manager.rb'
require_relative '../lib/store_message.rb'
file_data = File.read('./db/quotes.txt').split("\n")

token = ENV['TELEGRAM_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message_object|
    # MessageResponder.new(bot, message_object).respond
    reply_text = "OOPS, i didn't understand that, please try a using a command from /help"
    chat_id = message_object.chat.id
    case message_object.text
    when %r{^/start}

      reply_text = "Hi there!\nGreat to meet you #{message_object.from.first_name} 😁 \nI'm going to send you a little \
      gratitude quote everyday. Get one immediately by typing /quote\nYou can write or view a gratitude entry by \
      typing /write and /view\nIf you would like me to pause or re-start the quotes, you can \
      reply with /stop and /start"

      StateManager.new(message_object, 'users').true_state
      StateManager.new(message_object, 'writers').false_state
      StateManager.new(message_object, 'deleters').false_state

    when %r{^/stop}
      reply_text = "Your reminders are now paused. Catch you later, #{message_object.from.first_name}"

      StateManager.new(message_object, 'users').false_state
      StateManager.new(message_object, 'writers').false_state
      StateManager.new(message_object, 'deleters').false_state

    when %r{^/write}

      reply_text = "What are you grateful for?\n(I will randomly remind you of this entry in the future to bring a \
      smile to your face 🥳)\nTo cancel this entry type /cancel"

      StateManager.new(message_object, 'writers').true_state
      StateManager.new(message_object, 'deleters').false_state

    when %r{^/cancel}

      reply_text = 'Cancelled Operation'

      StateManager.new(message_object, 'writers').false_state
      StateManager.new(message_object, 'deleters').false_state

    when %r{^/view}
      reply_text = " Here are your journal entries: #{StoreMessage.new(message_object).messages}"

      StateManager.new(message_object, 'writers').false_state
      StateManager.new(message_object, 'deleters').false_state

    when %r{^/quote}
      reply_text = (file_data[rand(1...file_data.size)]).to_s

      StateManager.new(message_object, 'writers').false_state
      StateManager.new(message_object, 'deleters').false_state

    when %r{^/delete}

      reply_text = "Reply with the journal entry number to delete: #{StoreMessage.new(message_object).messages}"

      StateManager.new(message_object, 'deleters').true_state

    else
      if StateManager.new(message_object, 'writers').state?
        StateManager.new(message_object, 'writers').false_state
        StoreMessage.new(message_object).store_message
        reply_text = "I'm happy for you! I've saved your entry, if you would like to have a look at your entries \
        you can send me /view"

      elsif StateManager.new(message_object, 'deleters').state?
        StateManager.new(message_object, 'deleters').false_state
        StoreMessage.new(message_object).delete_message(message_object.text.to_i)

        reply_text = 'Entry deleted!'
      end
    end
    bot.api.send_message(chat_id: chat_id, text: reply_text)
    # logging
    puts message_object.from.first_name
  end
end
# rubocop: enable Metrics/BlockLength
