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
        "Kitchen, with table in the middle of the room. There is entrance to empty room. Very creepy looking door",
       "contains"=>
        [{"name"=>"table",
          "type"=>"item",
          "description"=>"Magnificent wooden table",
          "movable"=>false,
          "contains"=>
           [{"name"=>"dinner",
             "type"=>"item",
             "description"=>"Mashed potatoes with onion and bacon. It seems to be hot. Hmmm yummy",
             "eatable"=>true,
             "on_eat"=>
               Proc.new do
                  findNodeWithName('key', self).moveNode(parent.parent)
                  puts "Something got stuck between your teeth...its hard...better spit it out on floor! And it's key!"
               end,
             "contains"=>
              [{"name"=>"key",
                "type"=>"item",
                "hidden"=>true,
                "description"=>"Key. Key to what? My heart? Probably not..."}]},
            {"name"=>"fork", "type"=>"item",
              "short_description" => 'fork. No knife, no spoon, just fork',
              "description"=>"Silver fork"}]},
         {"name"=>"chair",
          "type"=>"item",
          "description"=>"Creaky old wooden chair" ,
          "contains"=>[{"name"=>"paper", "type"=>"item", "description"=>"Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn"}]},
         {"name"=>"empty room", "type"=>"room",
           "description"=>"This empty room looks empty. There is entrance from kitchen. You can see blood trail",
           "contains"=>
            [{"name"=>"trail", "type"=>"item",
              'movable'=>false,
              "description"=>"Dry blood trail. More brown than red. Leads to the stairs"},
              {"name"=>"stairs",
              "type"=>'room',
              "description"=>'This stairs leads down and down and light coming from empty room is fading. Blood trail continue. At the end is entrance to some room, maybe to cellar?',
              "contains"=>
               [{"name"=>"cellar",
                 "type"=>'room',
                 "description"=>'Old dusty cellar, only entrance leads to the stairs',
                 "contains"=>
                 [{"name"=>"body",
                   "type"=>"item",
                   "short_description"=>"body laying in the middle of the room in blood",
                   "description"=>"Body of dead women. Week ago beautiful women. She has beed stabed, multiple times",
                   "eatable"=>true,
                   "on_eat"=>Proc.new {  puts "Oh you sick motherfucker! What are you doing?...It's raw and taste is bitter. Probably caused by stress before death." },}]}]}]},
         {"name"=>"door",
          "type"=>"item",
          "description"=>"The door is closed. Arent they smiling? Probably leads to somewhere",
          "on_open"=>
            Proc.new do
              self.description = 'The Door is open. Leads to from kitchen to bedroom. Definitely smiling'
              puts "You are opening door! Such exciting. Very dangerous. Wow. This door leads to bedroom."
            end,
          "on_close"=>
            Proc.new do
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
             "description"=>"Bedroom, in the middle of room is very small bed. In corner is stone altair, it's old, very old",
             "on_enter"=>
                Proc.new do
                 puts "You have that strange kind of feeling. You should have never go enter this room!"
                 self.on_enter = nil
                end,
             "contains"=>
             [{"name"=>"bed",
               "type"=>"item",
               "movable"=>false,
               "description"=>"Little child bed",
               "contains"=>
               [{"name"=> "doll",
                 "type"=>"item",
                 "short_description"=>"creepy doll",
                 "description"=>"She is a bit cute, but much more creepy",
                 "contains"=>
                  [{"name"=>"knife",
                    "type"=>"item",
                    "short_description"=>"bloody knife",
                    "description"=>"Knife. bloody butcher knife. You can kill someone with this"}]
                 }]},
               {"name"=>"altair",
                 "type"=>"item",
                 "movable"=>false,
                 "description"=>"Stone altair, with stone tentacles",
                 'on_put'=>
                 Proc.new do |item|
                   if item.name == 'body'
                     puts "You offered sacrifice to Old Gods and escape this nightmare. You are back in your world. But did you really escape?"
                     raise SystemExit.new 'You WIN!'
                   else
                     puts "Your offering wasn't accepted. You died. Think before you act!"
                     raise SystemExit.new 'GAME OVER!'
                   end
                 end}]
          }]
        }]
      }
    }
  end
end
