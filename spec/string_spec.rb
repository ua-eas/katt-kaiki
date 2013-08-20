# Description: This RSpec function will create a filename and path that should 
#              be safe to use.
#
# Original Date: August 20, 2011

require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'string')

# Public: Testing my String monkeypatch(es)
#
# Returns nothing.
describe 'String' do
  it 'should create a file-safe String' do
    s = '2012-03-18 16:47:01 -0700' # comes from Time.now
    s.file_safe.should == '2012-03-18-16-47-01--0700'

    t = '/home/sam/code/kaikifs'
    t.file_safe.should == '_home_sam_code_kaikifs'
  end
end
