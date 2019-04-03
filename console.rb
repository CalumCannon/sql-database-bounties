require('pry-byebug')
require_relative('models/bounty.rb')

bounty1 = Bounty.new({
  'name' => 'Blorgarg the Destroyer',
  'home_world' => 'Xen07e3749',
  'favourite_weapon' => 'BFG',
  'bounty_value' => '89976'
  })

bounty1.save()

  bounty2 = Bounty.new({
    "name" => "Flimflaps",
    'home_world' => 'Kertron 9',
    'favourite_weapon' => 'Katana',
    'bounty_value' => '3442'
    })

bounty2.save()

# bounty2.delete()

bounty1.home_world = ""

bounty1.update()

find_by_name = Bounty.find_by_name('Blorgarg the Destroyer');
# find_by_id = Bounty.find_by_id('2');

 # p find_by_id
p find_by_name

# Bounty.delete_all
