require 'spec_helper'

describe Sorter do
  let!(:fixture_path) { File.dirname(__FILE__) + "/fixtures/" }
  let(:input_path)  { fixture_path + "myproject_2012-07-27_2012-10-10_performancedata.txt" }
  let(:test_sorted_path) { fixture_path + "myproject_2012-07-27_2012-10-10_performancedata.txt.sorted" }
  let(:sorted_path) { fixture_path + "test_result.txt.sorted" }
  let(:sorting_column) { 'Clicks' }

  before :each do
    FileUtils.rm_rf test_sorted_path
  end

  it 'should return sorted data' do
    output = Sorter.sort(input_path, sorting_column)
    expect(output).not_to be_empty
    expect(FileUtils.compare_file(test_sorted_path, sorted_path)).to be_truthy
  end
end
