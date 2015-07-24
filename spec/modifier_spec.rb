require 'spec_helper'

describe Modifier do
  let!(:fixture_path) { File.dirname(__FILE__) + "/fixtures/" }
  let(:input_path)  { fixture_path + "myproject_2012-07-27_2012-10-10_performancedata.txt" }
  let(:output_path) { fixture_path + "myproject_2012-07-27_2012-10-10_performancedata_0.txt" }
  let(:test_output_path) { fixture_path + "test_result.txt" }
  let(:test_output_path_write) { fixture_path + "test_result_0.txt" }
  let(:modification_factor) { 1 }
  let(:cancellaction_factor) { 0.4 }

  before :each do
    FileUtils.rm_rf test_output_path_write
  end

  it 'should return correct output file' do
    modifier = Modifier.new(modification_factor, cancellaction_factor)
    modifier.modify(test_output_path, input_path)
    expect(FileUtils.compare_file(test_output_path_write, output_path)).to be_truthy
  end
end
