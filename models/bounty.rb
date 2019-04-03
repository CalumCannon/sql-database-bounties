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
      # RETURNS AS A STRING - using to_i to convert back to INT
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
    # Connect
    db = PG.connect({dbname:'bounties',host:'localhost'})

    # Prepare SQL string
    sql = "SELECT * FROM bounties WHERE name = $1"
    db.prepare('find_by_name',sql)
    values = [name]

    # Run SQL
    result = db.exec_prepared('find_by_name',values)

    # Close
    db.close

    # Select found object from array
    bounty = result[0]

     if bounty == []
       return nil
     else
       return Bounty.new(bounty)
     end
  end

  # FIND BY ID
  def Bounty.find_by_id(id)
    # Connect
    db = PG.connect({dbname:'bounties',host:'localhost'})

    # Prepare
    sql = "SELECT * FROM bounties WHERE id = $1"
    db.prepare('find_by_id',sql)
    values = [id]

    # Run
    returned_result = db.exec_prepared('find_by_id',values)

    # Close
    db.close
    bounty = returned_result[0]

    

    return new bounty

  end



end
