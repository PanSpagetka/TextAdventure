class Game
  require 'player'
  require 'pry'

  GAME_ACTIONS = ['end']
  def initialize
    @player = Player.new
  end

  def start
    welcome
    while @player.alive?
      input = prompt('What you gonna do?')
      loop do
        process_player_input(input)
        break if @player.error_message.empty?
        input = prompt(@player.error_message)
      end

      print_status
    end
    puts "Oh, you died. That's bad..."
  end

  def prompt(text = '')
    print "#{text}\n>"
    gets.chomp
  end

  private

  def print_status
    puts "You are at map coordinates [#{@player.x}, #{@player.y}]"
  end

  def process_player_input(input)
    action, *params = input.downcase.split(' ')
    #binding.pry
    if GAME_ACTIONS.include?(action)
      case action
      when 'end'
        @player.suicide
      end
    else
      @player.send(action, *params)
    end
  end

  def ask_question(text)
    puts text
    prompt
  end

  def evaluate_ansver(ansver)
    if ansver == 'n' || ansver == 'no'
      false
    else
      true
    end
  end

  def welcome
    ansver = ask_question("Hey, are you alive?")
    if evaluate_ansver(ansver)
      prompt("Fine, lets get started!")
    else
      puts 'OK'
      @player.suicide
    end
  end
end
