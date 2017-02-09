$:.unshift './lib/'
require 'require_all'
require 'pry'
require_all 'lib'

world = World.new
world.get_world


player = Player.new(nil, {:name => 'Pepa'})
game = Game.new(world, player)
game.start
