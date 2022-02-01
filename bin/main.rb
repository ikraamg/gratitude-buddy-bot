#!/usr/bin/env ruby
require 'telegram/bot'
require 'dotenv/load'
require_relative '../lib/message_responder.rb'

token = ENV['TELEGRAM_API_KEY']
retry_attempts = 0
p "server started"
begin
  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message_object|
      next unless message_object.class == Telegram::Bot::Types::Message

      reply = case message_object.text
              when %r{^/}
                begin
                  MessageResponder.new(message_object).send(message_object.text[1..20])
                rescue StandardError
                  MessageResponder.default_reply
                end
              else
                MessageResponder.new(message_object).journal_editor
              end

      reply ||= MessageResponder.default_reply
      begin
        if (reply.length > 4096)
          while reply.length > 4096
            response = reply.slice!(0..4095)
            bot.api.send_message(chat_id: message_object.chat.id, text: response)
          end
        end
        bot.api.send_message(chat_id: message_object.chat.id, text: reply)
      rescue StandardError => e
        puts 'failed for this user with:'
        puts e
      end

      # logging
      puts message_object.from.first_name
    end
  end
rescue StandardError => e
  sleep(5)
  puts e

  retry_attempts += 1
  puts "Erroy no: #{retry_attempts}, retrying connection to Telegram API"
  retry unless retry_attempts > 5
end
