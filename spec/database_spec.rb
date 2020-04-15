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
end
