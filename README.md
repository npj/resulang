# Resulang

Resulang is a simple DSL to help create html resumes. It can also be used to
create other kinds of documents with structured data. It works by separating
the data from the html template, which means the data could theoretically be
used to generate other kinds of output in the future, not just html.

## TODO: write tests

## Installation

    $ gem install resulang

## Usage

Once resulang is installed, create a new resulang app with:
```sh
resulang new my_resume
```

This will generate the basic structure of a resulang app as well as a few key files:

* `my_resume/data/resume.rb`
    
    This is where you define your resume.

* `my_resume/templates/resume.html.erb`

    This is where you write your resume html which has access to the data in
my_resume/data/resume.rb


A resume is broken into named sections. For example:
```ruby
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
```

A template for the above data might look like this:

```html
<html>
  <head>
    <title><%= sections[:personal].name %></title>
    <link rel="stylesheet" href="assets/css/style.css" />
  </head>
  <body>
    <div class="section">
      <%= render_section(:personal) %>
    </div>
    <div class="section">
      <%= render_section(:background) %>
    </div>
    <div class="section">
      <%= render_section(:skills) %>
    </div>
    <div class="section">
      <%= render_section(:hobbies) %>
    </div>
  </body>
</html>
```

`render_section(:section_name)` looks for a template partial named
`my_resume/templates/_section_name.html.erb`. A partial has direct access to
the data within the data section. For example, the partial for the "personal"
and "hobbies" sections might look like:

```html
<!-- my_resume/templates/_personal.html.erb -->
<div>Name: <%= name %></div>
<div>Phone: <%= phone %></div>
<div>Email: <%= email %></div>
<div><a href="<%= github %>" target="_blank"><%= github %></a></div>
```

```html
<!-- my_resume/templates/_hobbies.html.erb -->
<ul>
  <% info.points.each do |point| %>
    <li><%= point %></li>
  <% end %>
</ul>
```

The data in `resume.rb` needs to be defined, which is what the
`my_resume/data/sections` directory is for. Each section is a class that
inherits from `Resulang::Section`. A section class declares the fields a
section can have as well as their types. The `Personal` and `Hobbies` sections
would look like this:

```ruby
# my_resume/data/sections/personal.rb
class Personal < Resulang::Section
  string :name, :phone
  email  :email
  link   :github
end
```

```ruby
# my_resume/data/sections/hobbies.rb
class Hobbies < Resulang::Section
  pointlist :info
end
```

To easily view changes to the resume as you make them, you can run a local
server with:
```sh
resulang server
```

However, if you make any changes to the classes in `my_resume/data/sections`
you must restart the server.

You can put assets like images and stylesheets in directories off `my_resume`,
like `css` and `images` or `assets/css` and `assets/images`. These can be
referenced in `resume.html.erb`.

To generate a static html page, run:
```sh
resulang make
```

This will output `./resume.html`

Please see the `exmaples` directory of this project for a working example.
