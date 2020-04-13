#!/usr/bin/env ruby
# frozen_string_literal: true

require 'telegram/bot'
load './lib/entries.rb'
load './lib/write.rb'
file_data = File.read('./db/quotes.txt').split("\n")

token = '1231002234:AAGAlG8tDpS6M7JOe9WNeEJWvCQVglvLJV0'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    message_id = message.chat.id
    case message.text
    when %r{^/start}
      sent_message = bot.api.send_message(chat_id: message_id, text: "Hi there!\nGreat to meet you #{message.from.first_name} 😁 \nI'm going to send you a little gratitude quote everyday.\nIf you would like me to pause/re-start the reminders, you can reply with /stop and /start")
      # bot.api.send_message(chat_id: message_id, text: "Quote of the day:\n#{file_data[rand(1...file_data.size)]}")
      # puts sent_message.text
      Entries.new(message_id)
      # puts message.from.first_name

    when %r{^/stop}
      bot.api.send_message(chat_id: message_id, text: "Your reminders are now paused. Catch you later, #{message.from.first_name}")

      Entries.new(message_id).remove_user(message_id)

    when %r{^/write}
      bot.api.send_message(chat_id: message_id, text: "What happy thoughts would you like to journal?\n(I will randomly remind you of this event in the future to bring a smile to your face 😇)\n ")

      Write.new(message_id)

    when %r{^/cancel}
      Write.new(message_id).remove_user(message_id)

      bot.api.send_message(chat_id: message_id, text: 'New-Entry Cancelled ')

    else
      puts Write.in_write_state?(message_id)
    end
  end
end
