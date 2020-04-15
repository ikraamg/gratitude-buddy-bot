require_relative '../lib/state_manager.rb'

RSpec.describe StateManager do
  describe '#state?' do

    it 'find if the state is true for the managed state' do
       expect(StateManager.new().state).to eql(arr.each { |x| puts x })
    end

  end