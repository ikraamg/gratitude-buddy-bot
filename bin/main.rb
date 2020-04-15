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
    case message_object.text
    when %r{^/start}
      reply_text = MessageResponder.new(message_object).start

    when %r{^/help}
      reply_text = MessageResponder.new(message_object).help

    when %r{^/stop}
      reply_text = MessageResponder.new(message_object).stop

    when %r{^/write}
      reply_text = MessageResponder.new(message_object).write

    when %r{^/cancel}
      reply_text = MessageResponder.new(message_object).cancel

    when %r{^/view}
      reply_text = MessageResponder.new(message_object).view

    when %r{^/quote}
      reply_text = MessageResponder.new(message_object).quote

    when %r{^/delete}
      reply_text = MessageResponder.new(message_object).delete

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
    reply_text ||= "OOPS, i didn't understand that, please try a using a command from /help"
    bot.api.send_message(chat_id: chat_id, text: reply_text)
    # logging
    puts message_object.from.first_name
  end
end
