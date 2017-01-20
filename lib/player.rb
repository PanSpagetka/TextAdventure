class Player
  attr_accessor :hit_points, :attack_power
  attr_accessor :x, :y
  attr_reader :name, :error_message


  MAX_HIT_POINTS = 100

  @available_actions = ['suicide', 'go']

  def initialize(name = 'Fred')
    @hit_points        = MAX_HIT_POINTS
    @attack_power      = 1
    @x, @y             = 0, 0
    @name              = name
  end

  def alive?
    @hit_points > 0
  end

  def hurt(amount)
    @hit_points -= amount
  end

  def heal(amount)
    @hit_points += amount
    @hit_points = [@hit_points, MAX_HIT_POINTS].min
  end

  def print_status
    puts "*" * 80
    puts "HP: #{@hit_points}/#{MAX_HIT_POINTS}"
    puts "AP: #{@attack_power}"
    puts "*" * 80
  end

  def suicide
    @hit_points = 0
  end

  def available_actions

  end

  def go(*direction)
    case direction[0]
    when 'up'
      @y += 1
    when 'down'
      @y -= 1
    when 'left'
      @x -= 1
    when 'right'
      @x += 1
    when nil
      @error_message = 'Where?'
    end

  end

  def method_missing(method_name, *arguments, &_block)
    puts "Unknown action. \n #{method_name} arguments: #{arguments}"
  end
end
