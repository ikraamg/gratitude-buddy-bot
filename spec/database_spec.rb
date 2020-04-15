require_relative '../lib/database_management'

RSpec.describe DatabaseManagement do
  include DatabaseManagement
  let(:test_file) { 'test_state' }
  let(:test_file2) { 'no_file' }
  let(:test_line) { 296_643_681 }
  let(:test_line2) { 'not found' }

  describe '#file_exists?' do
    it 'returns true if file exists' do
      expect(file_exists?(test_file)).to be true
    end
    it 'returns false if file does not exist' do
      expect(file_exists?(test_file2)).not_to be true
    end
  end

  describe '#file_to_array' do
    it 'returns correct array from file contents' do
      expect(file_to_array(test_file)).to eql([test_line.to_s])
    end
  end

  describe '#contained_in_file?' do
    it 'returns true if item is contained if file' do
      expect(contained_in_file?(test_file, test_line)).to be true
    end
    it 'returns false if item is not contained in file' do
      expect(contained_in_file?(test_file, test_line2)).not_to be true
    end
  end

  describe '#append_to_file' do
    it 'appends file and returns confirmation if no errors occured' do
      expect(append_to_file('new_file', 'test line')).to eq('appended')
    end
  end

  describe '#overwrite_file' do
    it 'overites file with an array and returns confirmation if no errors occured' do
      expect(overwrite_file('new_file', ['test line'])).to eq('overwritten')
    end
  end

  describe '#remove_from_file' do
    it 'removes entry from file and returns confirmation if no errors occured' do
      expect(remove_from_file('new_file', 'test line')).to eq('removed')
    end
    it "returns 'not found' when the entry is not contained if file" do
      expect(remove_from_file('new_file', 'test line')).to eq('not found')
    end
  end
end
