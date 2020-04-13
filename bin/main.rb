#!/usr/bin/env ruby
require 'telegram/bot'
load './lib/entries.rb'
load './lib/write.rb'
load './lib/store_message.rb'
file_data = File.read('./db/quotes.txt').split("\n")

token = '1231002234:AAGAlG8tDpS6M7JOe9WNeEJWvCQVglvLJV0'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    chat_id = message.chat.id
    case message.text
    when %r{^/start}
      sent_message = bot.api.send_message(chat_id: chat_id, text: "Hi there!\nGreat to meet you #{message.from.first_name} 😁 \nI'm going to send you a little gratitude quote everyday.\nIf you would like me to pause/re-start the reminders, you can reply with /stop and /start")
      # bot.api.send_message(chat_id: chat_id, text: "Quote of the day:\n#{file_data[rand(1...file_data.size)]}")
      Entries.new(chat_id)
      puts message.from.first_name

    when %r{^/stop}
      bot.api.send_message(chat_id: chat_id, text: "Your reminders are now paused. Catch you later, #{message.from.first_name}")

      Entries.new(chat_id).remove_user(chat_id)

    when %r{^/write}
      bot.api.send_message(chat_id: chat_id, text: "What happy thoughts would you like to journal?\n(I will randomly remind you of this event in the future to bring a smile to your face 😇)\n ")

      Write.new(chat_id)

    when %r{^/cancel}
      Write.new(chat_id).remove_user(chat_id)

      bot.api.send_message(chat_id: chat_id, text: 'New-Entry Cancelled ')

    when %r{^/view}
      bot.api.send_message(chat_id: chat_id, text: " Here are the entries: #{StoreMessage.get_messages(chat_id)}")
      StoreMessage.get_messages(chat_id)

    else
      if Write.in_write_state?(chat_id)
        Write.new(chat_id).remove_user(chat_id)
        StoreMessage.new(chat_id, message.text).store_message
        bot.api.send_message(chat_id: chat_id, text: "I'm happy for you! I've saved your entry, if you would like to have a look at your entries you can send me /view")
      end
    end
  end
end
