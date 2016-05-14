rails g scaffold movie title duration director rating description:text

rails db:migrate

brew install imagemagick
Warning: imagemagick-6.9.2-4 already installed

gem "paperclip", "~> 5.0.0.beta1"

bundle

Movie model:

  has_attached_file :poster, styles: { medium: "400x600#" }
  validates_attachment_content_type :poster, content_type: /\Aimage\/.*\Z/

rails g paperclip movie poster

rails db:migrate

Movie form partial:

<%= form_for(movie, html: { multipart: true }) do |f| %>

  <div class="field">
    <%= f.label :image %>
    <%= f.file_field :image %>
  </div>


    def movie_params
      params.require(:movie).permit(:title, :duration, :director, :rating, :description, :poster)
    end

Poster will not show up. Change the view:

  <div class="field">
    <%= f.label :poster %>
    <%= f.file_field :poster %>
  </div>

Movie show page.

<%= image_tag @movie.poster.url(:medium) %>

Now you can see the uploaded movie poster.

Add:

/public/system/movies/posters

to .gitignore.

Use TB 4 with Rails 5

Add bootstrap gem to Gemfile.

gem 'bootstrap', '~> 4.0.0.alpha3'

bundle


@import "bootstrap";

to application.css.

Rename application.css to application.scss

Remove:

*= require_tree .
*= require_self

from application.scss. Use @import to import sass files. 



Add:

//= require bootstrap-sprockets

to application.js.

//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .


File to import not found or unreadable: bootstrap-sprockets

_header.html.erb in layouts folder.

Rails.application.routes.draw do
  resources :movies do
  	collection do
  		get 'search'
  	end
  end

  root 'movies#index'
end

<!DOCTYPE html>
<html>
  <head>
    <title>Fbuf</title>
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


Movies index page.

<div class="row">
  <% @movies.each do |movie| %>
    <div class="col-sm-6 col-md-3">
      <div class="thumbnail">
        <%= link_to (image_tag movie.poster.url(:medium), class: 'image'), movie %>
      </div>
    </div>
  <% end %>
</div>

http://upgrade-bootstrap.bootply.com/





