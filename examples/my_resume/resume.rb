structure do
  section :personal do
    string :name, :phone
    email :email
    link :github
  end

  section :background do
    string :description
  end

  section :skills do
    list :things
  end

  section :hobbies do
    list :points
  end

  section :other do
    list :things do
      string :name, :description
    end
  end
end

data do
  personal do
    name 'Peter Brindisi'
    phone '555-555-5555'
    email 'superduperprivate@example.com'
    github 'https://github.com/npj'
  end

  background do
    description <<-DESCRIPTION
      I am a guy that does things. Things are awesome and they are also cool.
    DESCRIPTION
  end

  skills do
    thing %{foo bar baz qux}
  end

  hobbies do
    point 'Reading about Haskell'
    point 'Evangelizing monads'
    point 'Making beer'
  end

  other do
    thing do
      name 'foo'
      description 'foo desc'
    end

    thing do
      name 'bar'
      description 'bar desc'
    end

    thing do
      name 'baz'
      description 'baz desc'
    end
  end
end