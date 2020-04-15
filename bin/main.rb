#!/usr/bin/env ruby
require 'telegram/bot'
require 'dotenv/load'
require_relative '../lib/state_manager.rb'
require_relative '../lib/store_message.rb'
require_relative '../lib/message_responder.rb'

token = ENV['TELEGRAM_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message_object|
    chat_id = message_object.chat.id
    reply = case message_object.text
            when %r{^/start}
              MessageResponder.new(message_object).start
            when %r{^/help}
              MessageResponder.new(message_object).help
            when %r{^/stop}
              MessageResponder.new(message_object).stop
            when %r{^/write}
              MessageResponder.new(message_object).write
            when %r{^/cancel}
              MessageResponder.new(message_object).cancel
            when %r{^/view}
              MessageResponder.new(message_object).view
            when %r{^/quote}
              MessageResponder.new(message_object).quote
            when %r{^/delete}
              MessageResponder.new(message_object).delete
            else
              MessageResponder.new(message_object).journal_editor
            end
    reply ||= "OOPS, i didn't understand that, please try a using a command from /help"
    bot.api.send_message(chat_id: chat_id, text: reply)
    # logging
    puts message_object.from.first_name
  end
end
