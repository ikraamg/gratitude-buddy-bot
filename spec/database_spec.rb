require_relative '../lib/database_management'

RSpec.describe DatabaseManagement do
  include DatabaseManagement
  let(:test_file) { 'test_state' }
  let(:test_file2) { 'no_file' }
  let(:test_file3) { 'test_file3' }
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
    it "checks #append_to_file output from below to ensure that 'appended line' does not exist before we test
using the contained_in_file? method" do
      expect(contained_in_file?(test_file3, 'appended line')).not_to be true
    end

    it 'appends file and returns confirmation if no errors occured' do
      expect(append_to_file(test_file3, 'appended line')).to eq('appended')
    end

    it 'checks #append_to_file output from above with with contained_in_file method' do
      expect(contained_in_file?(test_file3, 'appended line')).to be true
    end
  end

  describe '#overwrite_file' do
    it "checks #overwrite_file output from below to ensure that 'test line2' does not exist before we test
using the contained_in_file? method" do
      expect(contained_in_file?(test_file3, 'test line2')).not_to be true
    end

    it 'overites file with an array and returns confirmation if no errors occured' do
      expect(overwrite_file(test_file3, ['test line2'])).to eq('overwritten')
    end

    it 'checks #overwrite_file output from above with with contained_in_file? method' do
      expect(contained_in_file?(test_file3, 'test line2')).to be true
    end
  end

  describe '#remove_from_file' do
    it "checks #remove_from_file output from below to ensure the'test line2' exists before we remove the entry
with with the contained_in_file? method" do
      expect(contained_in_file?(test_file3, 'test line2')).not_to be false
    end

    it 'removes entry from file and returns confirmation if no errors occured' do
      expect(remove_from_file(test_file3, 'test line2')).to eq('removed')
    end

    it 'checks #remove_from_file output from above with with contained_in_file? method' do
      expect(contained_in_file?(test_file3, test_file3)).to be false
    end

    it "returns 'not found' when the entry is not contained in file" do
      expect(remove_from_file(test_file3, 'test line2')).to eq('not found')
    end
  end
end
