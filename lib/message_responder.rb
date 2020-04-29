require_relative '../lib/state_manager.rb'
require_relative '../lib/store_message.rb'

class MessageResponder
  private

  attr_reader :message_object
  attr_reader :chat_id

  def initialize(message_object)
    @message_object = message_object
    @chat_id = message_object.chat.id
  end

  def clear_operational_states
    StateManager.new(message_object, 'writers').false_state
    StateManager.new(message_object, 'deleters').false_state
  end

  def user_on_shedule
    StateManager.new(message_object, 'users').true_state
  end

  def user_off_shedule
    StateManager.new(message_object, 'users').false_state
  end

  def write_state
    StateManager.new(message_object, 'writers').true_state
  end

  def delete_state
    StateManager.new(message_object, 'deleters').true_state
  end

  def in_write_state?
    StateManager.new(message_object, 'writers').state?
  end

  def in_delete_state?
    StateManager.new(message_object, 'deleters').state?
  end

  public

  def self.default_reply
    "Oops, I didn't understand that. Please try sending me one of the commands from /help"
  end

  def start
    clear_operational_states
    user_on_shedule

    "Hi there!\nGreat to meet you #{message_object.from.first_name} 😁\n\nI'm going to send you a little \
gratitude quote everyday.\nGet one immediately by typing /quote\n\nYou can write or view a gratitude entries by \
typing /write and /view\n\nIf you would like me to pause the notifications, you can \
reply with /stop.\n\nFor a full list of commands, send me /help

If you have any suggestions on how I can be improved, please find my details with /dev"
  end

  def dev
    "Hi! I am 👤 Ikraam Ghoor, the creator of this bot.
I am a freelance developer and engineer.
Feel free to contact me or send me suggestions:

- Telegram: https://t.me/ConsultIkraam
- Github: https://github.com/ikraamg
- Twitter: https://twitter.com/GhoorIkraam
- LinkedIn: https://linkedin.com/isghoor
- Email: consult.ikraam@gmail.com"
  end

  def help
    clear_operational_states
    "Here is a list of available commands:
/start - enable notifications
/stop - stop notifications
/write - make an entry
/view - view all your entries
/delete - delete and entry
/cancel - cancel writing or deleting
/quote - send a quote
/dev - info on my developer"
  end

  def stop
    clear_operational_states
    user_off_shedule
    "Your reminders are now paused, you can send me /start to continue them.
Catch you later, #{message_object.from.first_name}"
  end

  def write
    clear_operational_states
    write_state
    "What are you grateful for in this moment?😊\nTo cancel this entry type /cancel"
  end

  def cancel
    clear_operational_states
    'Cancelled previous operation'
  end

  def view
    clear_operational_states
    "Here are your journal entries: #{StoreMessage.new(message_object).messages}
If you would like to remove one, type /delete"
  end

  def quote
    clear_operational_states
    file_data = File.read('./db/quotes.txt').split("\n")
    file_data[rand(1...file_data.size)].to_s
  end

  def delete
    clear_operational_states
    delete_state
    "Reply with the journal entry number to delete: #{StoreMessage.new(message_object).messages}"
  end

  def journal_editor
    if in_write_state?
      clear_operational_states
      StoreMessage.new(message_object).store_message

      "I'm happy for you!
I've saved your entry, if you would like to have a look at your entries, you can send me /view"

    elsif in_delete_state?
      clear_operational_states
      StoreMessage.new(message_object).delete_message(message_object.text.to_i)

      "Deleted! #{view}"
    end
  end
end
