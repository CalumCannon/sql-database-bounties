require('pg')
require('pry-byebug')
class Bounty

  attr_accessor :name, :home_world, :favourite_weapon, :bounty_value
  attr_reader :id

  def initialize(options)
    @name = options['name']
    @home_world = options['home_world']
    @favourite_weapon = options['favourite_weapon']
    @bounty_value = options['bounty_value']
    @id = options['id'].to_i if options['id']
  end

  # save items
  def save
    # Connect
    db = PG.connect({dbname: 'bounties', host:'localhost'})
    # Prepare SQL string
    sql = "INSERT INTO bounties
        (
          name,
          home_world,
          favourite_weapon,
          bounty_value
        )
        VALUES ($1,$2,$3,$4)
        RETURNING id
        "
        db.prepare('save',sql)

        # Create a values array for my prepare statement
        values = [@name, @home_world, @favourite_weapon, @bounty_value]

    # Run
        @id = db.exec_prepared('save',values)[0]["id"].to_i
    # Close
    db.close
  end

  # Class Method delete all items
  def Bounty.delete_all
    # Connect to DB
    db = PG.connect({dbname:'bounties', host:'localhost'})
    # Prepare SQL string
    sql = "DELETE FROM bounties"
    db.prepare('delete_all', sql)
    # Run
    db.exec_prepared('delete_all')
    # Close debug
    db.close
  end

  # delete item
  def delete
    # connect db
    db = PG.connect({dbname:'bounties', host:'localhost'})
    # Prepare SQL string
    sql = "DELETE FROM bounties WHERE id = $1"
    db.prepare('delete', sql)
    # Run
    db.exec_prepared('delete',[@id])
    # Close
    db.close
  end

  # update
  def update
    db = PG.connect({dbname:'bounties',host:'localhost'})
    sql = "UPDATE bounties SET (name, home_world, favourite_weapon, bounty_value) = ($1,$2,$3,$4) WHERE id = $5"
    db.prepare('update',sql)
    values = [@name, @home_world, @favourite_weapon, @bounty_value, @id]
    db.exec_prepared('update',values)
    db.close
  end

  # FIND BY NAME
  def Bounty.find_by_name(name)
    db = PG.connect({dbname:'bounties',host:'localhost'})
    # sql = "SELECT $1 FROM bounties"
     sql = "SELECT * FROM bounties WHERE name = $1"
    db.prepare('find_by_name',sql)
    values = [name]
    found_bounty = db.exec_prepared('find_by_name',values)
    db.close
    # return found_bounty

    mapped_bounty = found_bounty[0]#.map { |bounty| Bounty.new(bounty) }

     if mapped_bounty == []
       return nil
     else
       return mapped_bounty
     end
  end

  # FIND BY ID
  def Bounty.find_by_id(id)
    db = PG.connect({dbname:'bounties',host:'localhost'})
    # sql = "SELECT FROM bounties WHERE id = $1"
    sql = "SELECT $1 FROM bounties"
    db.prepare('find_by_id',sql)
    values = [id]
    found_bounty = db.exec_prepared('find_by_id',values)
    db.close

    # binding.pry
    return new found_bounty
    # return found_bounty.map { |bounty| Bounty.new(bounty) }
  end



end
