# Resulang

Resulang is a simple tool for creating html resumes. It can also be used to
create other kinds of documents with structured data. It works by separating
the data from the html template, which means the data could theoretically be
used to generate other kinds of output in the future, not just html.

## TODO: write tests

## Installation

    $ gem install resulang

## Usage

Once resulang is installed, create a new resulang app with:
```sh
bundle exec resulang new my_resume --sections one two three
```

This will generate the basic structure of a resulang app as well as a few key files:

* `my_resume/resume.yaml`
    
    This is where you put your resume data.

* `my_resume/templates/resume.html.erb`

    This is where you write your resume html which has access to the data in
my_resume/resume.yaml


A resume is broken into named sections. For example:
```yaml
  personal:
    name: Peter Brindisi
    phone: 555-555-5555
    email: superduperprivate@example.com
    github: https://github.com/npj

  background:
    description: >-
      I am a guy that does things. Things are awesome and they are also cool.

  skills:
    things: ['foo', 'bar', 'baz', 'qux']

  hobbies:
    points:
      - Reading about Haskell
      - Evangelizing monads
      - Making beer
```

A template for the above data might look like this:

```html
<html>
  <head>
    <title><%= sections.personal.name %></title>
    <link rel="stylesheet" href="css/style.css" />
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
  <% points.each do |point| %>
    <li><%= point %></li>
  <% end %>
</ul>
```

To easily view changes to the resume as you make them, you can run a local
server with:
```sh
bundle exec resulang server
```

You can put assets like images and stylesheets in directories off `my_resume`,
like `css` and `images` or `assets/css` and `assets/images`. These can be
referenced in `resume.html.erb`.

To generate a static html page, run:
```sh
bundle exec resulang make
```

This will output `./resume.html`

Please see the `examples` directory of this project for a working example.
