require_relative './database_management'
# include DatabaseManagement

class StateManager
  include DatabaseManagement
  extend DatabaseManagement

  def initialize(message_object, state_managed)
    @chat_id = message_object.chat.id
    @state_managed = state_managed
  end

  def state?
    contained_in_file?(@state_managed, @chat_id)
  end

  def true_state
    return if state?

    append_to_file(@state_managed, @chat_id)
  end

  def false_state
    remove_from_file(@state_managed, @chat_id)
  end

  def self.items_in_managed_state(state_managed)
    file_to_array(state_managed)
  end
end
