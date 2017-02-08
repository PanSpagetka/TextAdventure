class Game

  COMMANDS = ['-end', '-h', '-pi', '-draw']

  def initialize(world, player)
    @player = player
    @world = world
    player.moveNode(world.root)
  end

  def start
    text = 'You are in kitchen. You know nothing. Just like John Snow.'
    begin
      while @player.alive?
        begin
          #puts @world.activeNode.description
          input = prompt(text)
          text = ''
          text = processInput(input)
        rescue RuntimeError => e
          puts e.message
        end
      end
    rescue SystemExit => e
      puts 'GAME OVER'
    end
  end

private
  def prompt(text = '')
    print "#{text}\n>"
    gets.chomp
  end

  def processInput(input)
    return if input.empty?
    action, *params = input.downcase.split(' ')
    case
    when action.start_with?('-')
      processGameCommand(action, params)
    when @player.actions.include?(action)
      @player.handle(action.to_sym, *params)
    else
      return 'Uknown command. Type help for help...or type -end to quit this GAME.'
    end
  end

  def processGameCommand(cmd, params)
    case cmd
    when '-h'
      printHelp
    when '-pi'
      printInteractions
    when '-draw'
      drawGraph(@world.root)
    when '-end'
      raise SystemExit.new 'End game command'
    end

  end

  def printHelp
    print "These are availiable game commands #{COMMANDS}"
  end

  def printInteractions
    puts "You are in #{@player.parent.name}."
    puts "Items in room #{@player.parent.children.collect{ |i| i.name}}."
    puts "Your items #{@player.children.collect{ |c| puts c.name}}"
  end
end
