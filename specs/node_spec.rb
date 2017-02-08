$:.unshift './lib/'
require 'require_all'
require_all 'lib'

describe Node do
  let(:world) { World.new }
  let(:root) { world.loadFromYAML('specs/world.yaml') }

  it 'search node' do
    x = root.findNodeWithName('dinner', root)
    expect(x.name == 'dinner')
  end
end
