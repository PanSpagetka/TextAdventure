require 'yaml'

class World

  attr_accessor :root, :activeNode

  def loadFromYAML(path)
    world = YAML.load_file(path)
    klass = Object::const_get(world['root']['type'].capitalize)
    @root = klass.new(nil, world['root'])
    @activeNode = @root
  end

  def get_world
    klass = Object::const_get(world['root']['type'].capitalize)
    @root = klass.new(nil, world['root'])
    @activeNode = @root
  end

  def world
    {"root"=>
      {"type"=>"room",
       "name"=>"kitchen",
       "description"=>
        "Kitchen, table with chair in the middle. There is entrance to living room. Also there are very creepy looking door",
       "contains"=>
        [{"name"=>"table",
          "type"=>"item",
          "description"=>"Wooden table with dinner and fork. No knife, no spoon, just fork. Fork on the table",
          "movable"=>false,
          "contains"=>
           [{"name"=>"dinner",
             "type"=>"item",
             "description"=>"Mashed potatoes with onion and bacon. It seems to be hot. Hmmm yummy",
             "eatable"=>true,
             "on_eat"=>Proc.new {  puts "Something got stuck between your teeth...its hard...better spit it out! And it's key!" },
             "contains"=>
              [{"name"=>"key",
                "type"=>"item",
                "description"=>"Key. Key to what? My heart? Probably not..."}]},
            {"name"=>"fork", "type"=>"item", "description"=>"Silver fork"}]},
         {"name"=>"chair",
          "type"=>"item",
          "description"=>"Wooden chair, bit old. Paper lies on it" ,
          "contains"=>[{"name"=>"paper", "type"=>"item", "description"=>"Urguath a valeash"}]},
         {"name"=>"living room", "type"=>"room", "description"=>"this living room looks empty"},
         {"name"=>"door",
          "type"=>"item",
          "description"=>"The door is closed. Arent they smiling? Probably leads to somewhere",
          "on_open"=>Proc.new do
              self.description = 'The Door is open. Leads to from kitchen to bedroom. Definitely smiling'
              puts "You are opening door! Such exciting. Very dangerous. Wow. This door leads to bedroom."
            end,
          "on_close"=>Proc.new do
              self.description = 'The Door is closed. Leads to from kitchen to bedroom'
              puts "You are closing door! Not really as exciting as opening."
            end,
          "movable"=>false,
          "enterable"=>true,
          "openable"=>true,
          "open"=>false,
          "locked"=>true,
          "leadsto"=>["bedroom", "kitchen"],
          "contains"=>
           [{"name"=>"bedroom",
             "type"=>"room",
             "description"=>"Bedroom, in the middle of room is very small bed",
             "on_enter"=>Proc.new do
                 puts "You have that strange kind of feeling. You should have never go enter this room!"
                 self.on_enter = nil
               end,
             "contains"=>
             [{"name"=>"bed",
               "type"=>"item",
               "description"=>"Bed with a little doll inside. She is cute, but also creepy. With big butcher knife on her little body",
               "contains"=>
               [{"name"=> "doll",
                 "type"=>"item",
                 "description"=>"Creepy doll",
                 "contains"=>
                  [{"name"=>"knife",
                    "type"=>"item",
                    "description"=>"Knife. Blody knife."}]
                 }]
               }]
          }]
        }]
      }
    }
  end
end
