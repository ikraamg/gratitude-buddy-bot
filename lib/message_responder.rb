require_relative '../lib/state_manager.rb'
require_relative '../lib/store_message.rb'

class MessageResponder
  private

  # attr_reader :text
  # attr_reader :bot
  attr_reader :message_object
  attr_reader :chat_id

  def initialize(message_object)
    # @bot = bot
    @message_object = message_object
    @chat_id = message_object.chat.id
    # @text = message_object.text
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

  def start
    clear_operational_states
    user_on_shedule

    "Hi there!\nGreat to meet you #{message_object.from.first_name} 😁 \nI'm going to send you a little \
gratitude quote everyday. Get one immediately by typing /quote\nYou can write or view a gratitude entry by \
typing /write and /view\nIf you would like me to pause or re-start the quotes, you can \
reply with /stop and /start"
  end

  def help
    clear_operational_states
    "Here is a list of available commands:\n/start\n/stop\n/write\n/delete\n/view"
  end

  def stop
    clear_operational_states
    user_off_shedule
    "Your reminders are now paused. Catch you later, #{message_object.from.first_name}"
  end

  def write
    clear_operational_states
    write_state
    "What are you grateful for?\n(I will randomly remind you of this entry in the future to bring a \
smile to your face 🥳)\nTo cancel this entry type /cancel"
  end

  def cancel
    clear_operational_states
    'Cancelled Operation'
  end

  def view
    clear_operational_states
    "Here are your journal entries: #{StoreMessage.new(message_object).messages}"
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

      "I'm happy for you! I've saved your entry, if you would like to have a look at your entries \
you can send me /view"

    elsif in_delete_state?
      clear_operational_states
      StoreMessage.new(message_object).delete_message(message_object.text.to_i)

      'Entry deleted!'
    end
  end
end
# MessageResponder.new(message_object).start

#  def respond
#     @bot.api.send_message(chat_id: @chat_id, text: text_reply)
#   end
# append_to_file_without_duplicates('state_names', @state_managed)

# @@state_names = file_to_array('state_names')

#  def self.state_names
#     @@state_names
#   end

# def append_to_file_without_duplicates(file_name, entry)
#   append_to_file if contained_in_file?(file_name, entry)
# end
