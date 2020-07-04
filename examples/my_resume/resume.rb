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
    pointlist :info
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
    things %{foo bar baz qux}
  end

  hobbies do
    info do
      point 'Reading about Haskell'
      point 'Evangelizing monads'
      point 'Making beer'
    end
  end
end