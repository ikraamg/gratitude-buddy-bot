#!/usr/bin/env ruby
require 'telegram/bot'
require 'dotenv/load'
require_relative '../lib/message_responder.rb'

token = ENV['TELEGRAM_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message_object|
    reply = case message_object.text
            when %r{^/}
              begin
                MessageResponder.new(message_object).send(message_object.text[1..6])
              rescue StandardError
                MessageResponder.default_reply
              end
            else
              MessageResponder.new(message_object).journal_editor
            end

    reply ||= MessageResponder.default_reply
    bot.api.send_message(chat_id: message_object.chat.id, text: reply)

    # logging
    puts message_object.from.first_name
  end
end
