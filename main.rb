$:.unshift './lib/'
require 'require_all'
require 'pry'
require_all 'lib'

#g = Game.new
#g.start
world = World.new
#root = world.loadFromYAML('data/world.yaml')
root = world.get_world
#drawGraph(world.root)
#world.root.children[0].children[0].moveNode(world.root.children[1])
#drawGraph(world.root)
#x = world.root.findNodeWithName('paper', world.root)
#x
#drawGraph(world.root)

player = Player.new(nil, {:name => 'Pepa'})
game = Game.new(world, player)
game.start
