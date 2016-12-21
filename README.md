[![Movie Review Rails 5 App](https://d2d8g20jj5tev4.cloudfront.net/rubyplus-screencast.png)](https://www.rubyplus.com/episodes/1-Movie-Review-Rails-5-App)

Integrating Twitter Bootstrap 4 with Rails 5

In this article, we will develop a movie database webapp using Twitter Bootstrap 4 and Rails 5. I upgraded the Movie Review app developed by Mackenzie Child using Twitter Bootstrap 3.2 and Rails 4.1 to the current versions of Twitter Bootstrap and Rails. To install Rails 5 RC1, run:

## Setup Movies Rails 5 App

```
gem install rails --pre
```

Generate a new Rails 5 project. Generate a movie scaffold.

```
rails g scaffold movie title duration director rating description:text
```

Migrate the database.

```
rails db:migrate
```

Install imagemagick. On Mac:

=======

Migrate the database.

```
rails db:migrate
```

Install imagemagick. On Mac:

```
brew install imagemagick
Warning: imagemagick-6.9.2-4 already installed
```


Add paperclip gem to Gemfile.

=======

Add paperclip gem to Gemfile.

```
gem "paperclip", "~> 5.0.0.beta1"
```

Run bundle.

Add the paperclip methods to the movie model:

```
has_attached_file :poster, styles: { medium: "400x600#" }
validates_attachment_content_type :poster, content_type: /\Aimage\/.*\Z/
```

You can upload a poster for a movie. Use the paperclip generator to create the file upload fields for movies table.

```
rails g paperclip movie poster
```

The generated migration will add:

```
t.string   "poster_file_name"
t.string   "poster_content_type"
t.integer  "poster_file_size"
t.datetime "poster_updated_at"
```


```
rails db:migrate
```

Movie form partial:

```
<%= form_for(movie, html: { multipart: true }) do |f| %>

  <div class="field">
    <%= f.label :image %>
    <%= f.file_field :image %>
  </div>


    def movie_params
      params.require(:movie).permit(:title, :duration, :director, :rating, :description, :poster)
    end
```

Poster will not show up. Change the view:

```
  <div class="field">
    <%= f.label :poster %>
    <%= f.file_field :poster %>
  </div>
```

Movie show page.

```
<%= image_tag @movie.poster.url(:medium) %>
```

Now you can see the uploaded movie poster.

Add:

```
/public/system/movies/posters
```

to .gitignore.


## Integrate Twitter Bootstrap 4 with Rails 5

Add bootstrap gem to Gemfile.

```
gem 'bootstrap', '~> 4.0.0.alpha3'
```

bundle

```
@import "bootstrap";
```

to application.css. Rename application.css to application.scss. Remove:

```
*= require_tree .
*= require_self
```

from application.scss. Use @import to import sass files. Add:

```
//= require bootstrap
```

to application.js. It will now look like this:

```
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require_tree .
```

Note: If you bootstrap-sprockets, you will get the error:

```
File to import not found or unreadable: bootstrap-sprockets
```

Only for Twitter Bootstrap 3, bootstrap-sprockets is used. Create a header partial in app/views/layout folder, `_header.html.erb`.

```
<nav class="navbar navbar-dark bg-inverse">
  <%= link_to "Movie Reviews", root_path, class: "navbar-brand" %>
  <ul class="nav navbar-nav">

    <li class="nav-item active">
      <a class="nav-link" href="movies/new">New Movie <span class="sr-only">(current)</span></a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#">About</a>
    </li>
  </ul>
  <form class="form-inline pull-xs-right">
    <input class="form-control" type="text" placeholder="Search">
    <button class="btn btn-success-outline" type="submit">Search</button>
  </form>
</nav>
```

Define the resources in the routes.rb.

```ruby
Rails.application.routes.draw do
  resources :movies do
  	collection do
  		get 'search'
  	end
  end

  root 'movies#index'
end
```

The layout file displays the header partial for the navigation and displays the content in a container.

```rhtml
<!DOCTYPE html>
<html>
  <head>
    <title>Film Buff</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
	<%= render 'layouts/header' %>
	<div class="container">
		<% flash.each do |name, msg| %>
			<%= content_tag(:div, msg, class: "alert alert-info") %>
		<% end %>
		<%= yield %>
	</div>
  </body>
</html>
```

Change the movies index page.

```rhtml
<div class="row">
  <% @movies.each do |movie| %>
    <div class="col-sm-6 col-md-3">
      <div class="thumbnail">
        <%= link_to (image_tag movie.poster.url(:medium), class: 'image'), movie %>
      </div>
    </div>
  <% end %>
</div>
```

You can now attach a movie poster when you create a movie. We now have the following issues:
<<<<<<< Updated upstream

1. The top portion of the movie poster is hidden behind the navigation.
2. The movie posters on the home page overlap.

To fix the overlap problem, change the css class used for the image.

```rhtml
<div class="row">
  <% @movies.each do |movie| %>
    <div class="col-sm-6 col-md-5">
      <div class="thumbnail">
        <%= link_to (image_tag movie.poster.url(:medium), class: 'image'), movie %>
      </div>
	  <hr/>
    </div>
  <% end %>
</div>
```

Refer the Twitter Bootstrap Grid System in the resources section of this article to learn more. To fix the navigation bar hiding the poster, add `navbar-fixed-top` to the header partial. It now looks like this:

```rhtml
<nav class="navbar navbar-dark bg-inverse navbar-fixed-top">
  <%= link_to "Movie Reviews", root_path, class: "navbar-brand" %>
  <ul class="nav navbar-nav">

    <li class="nav-item active">
      <a class="nav-link" href="movies/new">New Movie <span class="sr-only">(current)</span></a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#">About</a>
    </li>
  </ul>
  <form class="form-inline pull-xs-right">
    <input class="form-control" type="text" placeholder="Search">
    <button class="btn btn-success-outline" type="submit">Search</button>
  </form>
</nav>
```

We now have a simple movies database that can show all the movies in a nice grid and if you click on the movie poster, it will show the details of the movie. We have the following in our to do list.

1. The forms are not styled using Twitter Bootstrap 4. 
2. The active class is hard coded in the header partial for showing the current active tab. 

In order to select the current tab as the active tab, we need to make it dynamic by using a Rails helper. We will tackle these two issues in the next part of this series.

## Twitter Bootstrap Upgrade Tip

You can convert a given Twitter Bootstrap 3.x class to 4.x by using [Bootply](http://upgrade-bootstrap.bootply.com/ 'Bootply'). However, be careful, sometimes they old classes are not required at all. 


http://v4-alpha.getbootstrap.com/components/forms/

## Summary


In this article, you learned how to integrate Twitter Bootstrap 4 with Rails 5 apps. 

## References


rails g controller welcome about

get 'welcome/about', to: 'welcome#about', as: :about


Add some text to the about.html.erb. Change the static links in the header partial.

<li class="nav-item <%= active_class('movies', 'new') %>">
  <%= link_to '/movies/new', class: "nav-link" do %>
	New Movie
	<span class="sr-only"> <%= active_span('movies', 'new') %> </span>
  <% end %>	  
</li>	

<li class="nav-item <%= active_class('welcome', 'about') %>">
  <%= link_to about_path, class: 'nav-link' do %>
	About
	<span class="sr-only"> <%= active_span('welcome', 'about') %> </span>
  <% end %>
</li>


module ApplicationHelper
  def active_class(controller_name, action_name)    
    "active" if current_page?(controller: controller_name, action: action_name)
  end
  
  def active_span(controller_name, action_name)
    "(current)" if current_page?(controller: controller_name, action: action_name)
  end
end

Create a border and a box shadow around the page

In application.scss:

#wrapper {
  border: 1px #e4e4e4 solid;
  padding: 20px;
  border-radius: 4px;
  box-shadow: 0 0 6px #ccc;
  background-color: #fff;
}

In layout file:

<div id= 'wrapper' class="container">
  <% flash.each do |name, msg| %>
	<%= content_tag(:div, msg, class: "alert alert-info") %>
  <% end %>
  
  <%= yield %>
</div>
=======

1. The top portion of the movie poster is hidden behind the navigation.
2. The movie posters on the home page overlap.

To fix the overlap problem, change the css class used for the image.

```rhtml
<div class="row">
  <% @movies.each do |movie| %>
    <div class="col-sm-6 col-md-5">
      <div class="thumbnail">
        <%= link_to (image_tag movie.poster.url(:medium), class: 'image'), movie %>
      </div>
	  <hr/>
    </div>
  <% end %>
</div>
```

Refer the Twitter Bootstrap Grid System in the resources section of this article to learn more. To fix the navigation bar hiding the poster, add `navbar-fixed-top` to the header partial. It now looks like this:

```rhtml
<nav class="navbar navbar-dark bg-inverse navbar-fixed-top">
  <%= link_to "Movie Reviews", root_path, class: "navbar-brand" %>
  <ul class="nav navbar-nav">

    <li class="nav-item active">
      <a class="nav-link" href="movies/new">New Movie <span class="sr-only">(current)</span></a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#">About</a>
    </li>
  </ul>
  <form class="form-inline pull-xs-right">
    <input class="form-control" type="text" placeholder="Search">
    <button class="btn btn-success-outline" type="submit">Search</button>
  </form>
</nav>
```

We now have a simple movies database that can show all the movies in a nice grid and if you click on the movie poster, it will show the details of the movie. We have the following in our to do list.

1. The forms are not styled using Twitter Bootstrap 4. 
2. The active class is hard coded in the header partial for showing the current active tab. 

In order to select the current tab as the active tab, we need to make it dynamic by using a Rails helper. We will tackle these two issues in the next part of this series.

## Twitter Bootstrap Upgrade Tip

You can convert a given Twitter Bootstrap 3.x class to 4.x by using [Bootply](http://upgrade-bootstrap.bootply.com/ 'Bootply'). However, be careful, sometimes they old classes are not required at all. 

## Summary

In this article, you learned how to integrate Twitter Bootstrap 4 with Rails 5 apps. 

## References

[Create a border and a box shadow around the page](http://www.joomla-css.nl/en/create-your-own-joomla-3-template/modify-the-base-template/create-a-border-and-a-box-shadow 'Create a border and a box shadow around the page')
=======
[Twitter Bootstrap 4 Docs](http://getbootstrap.com/components/#navbar-fixed-top 'Twitter Bootstrap 4 Docs') 
[Twitter Bootstrap 3 with Rails 4](https://github.com/mackenziechild/movie_review 'Twitter Bootstrap 3 with Rails 4')
[Twitter Bootstrap Grid System](http://www.quackit.com/bootstrap/bootstrap_4/tutorial/bootstrap_grid_system.cfm 'Twitter Bootstrap Grid System')
