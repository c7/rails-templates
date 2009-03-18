# c7.rb
# from Peter Hellberg (http://c7.se)
# based on Suspenders by Thoughtbot

#====================
# CLEANUP
#====================

# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -f public/javascripts/*"

#====================
# GEMS
#====================

gem "authlogic"
gem 'sqlite3-ruby', :lib => 'sqlite3'
gem 'right_aws'
gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => 'http://gems.github.com'
gem 'rspec', :lib => false, :version => ">= 1.2.0" 
gem 'rspec-rails', :lib => false, :version => ">= 1.2.0" 
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com', :version => '~> 2.3.5'

# Install all the gems, as root
rake "gems:install", :sudo => true

#====================
# APP
#====================

file 'app/views/page/index.html.erb',
%q{<% content_for :sidebar do %> 
<ul class="nav">
  <li>Navigation item 1</li>
  <li>Navigation item 2</li>
  <li>Navigation item 3</li>
</ul>
<% end -%>
<h1>Page#index</h1>
<p>Find me in app/views/page/index.html.erb</p>
}

file 'app/views/layouts/_flashes.html.erb', 
%q{<div id="flash">
  <% flash.each do |key, value| -%>
    <div id="flash_<%= key %>"><%=h value %></div>
  <% end unless flash.empty? -%>
</div>
}

file 'app/helpers/application_helper.rb', 
%q{module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
end
}

file 'app/views/layouts/application.html.erb', 
%q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <title>TITLE</title>
    <%= stylesheet_link_tag 'reset-fonts-grids', 'content', :media => 'all', :cache => true %>
    <%= javascript_include_tag ['jquery', 'application'], :cache => true %>
  </head>
  <body class="<%= body_class %>">
    <div id="doc2" class="yui-t7">
      <div id="hd" role="banner">
        <img src="http://c7.se/images/logo.png" alt="Code7 Interactive"/>
      </div>
      <div id="bd">
        <div class="yui-gf">
          <div role="sidebar" class="yui-u first">
    	      <%= yield :sidebar %>
    	    </div>
          <div role="main" class="yui-u">
            <%= pluralize User.logged_in.count, "user" %> <%= t(:currently_logged_in) %><br /> 
            <!-- This based on last_request_at, if they were active < 10 minutes they are logged in -->
            <br />

            <% if !current_user %>
              <%= link_to t(:register), new_account_path %> |
              <%= link_to t(:login), new_user_session_path %> |
            <% else %>
              <%= link_to t(:my_account), account_path %> |
              <%= link_to t(:logout), user_session_path, :method => :delete, :confirm => t(:sure_you_want_to_logout) %>
            <% end %>
          
    	      <%= render :partial => 'layouts/flashes' -%>
            <%= yield %>
    	    </div>
        </div>
      </div>
      <div id="ft" role="contentinfo"><p><%= t(:footer) %></p></div>
    </div>
  </body>
</html>
}

# ====================
# FINALIZE
# ====================

# Setup the javascripts
inside('public/javascripts/') do
  run "curl -# -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > jquery.js"
end

file 'public/javascripts/application.js', 
%q{(function($){
  // Implementation
})(jQuery);
}

inside('public/stylesheets/') do
  # Download the YUI Reset, Fonts and Grids CSS
  run "curl -# -L http://yui.yahooapis.com/2.7.0/build/reset-fonts-grids/reset-fonts-grids.css > reset-fonts-grids.css"
end

# Based on the content.css from OOCSS 
file 'public/stylesheets/content.css',
%q{/* **************** CONTENT OBJECTS ***************** */
body {border-top:8px solid #7CAF3C;}
/* ====== Default spacing ====== */
h1, h2, h3, h4, h5, h6, ul, ol,dl, p, ul {padding:10px 0;}
pre{margin: 10px;}
table h1,table h2,table h3, table h4, table h5, table h6, table p, table ul, table ol, table dl {padding:0;}
/* ====== Elements ====== */
em{font-style: italic;}
strong{font-weight:bold;}
hr{border: 5px solid #BCBCBC; border-width: 0 0 5px 0; margin: 20px 20px 0 20px;}
code{color:#0B8C8F;}
/* ====== Headings ====== */
/* .h1-.h6 classes should be used to maintain the semantically appropriate heading levels - NOT for use on non-headings */
h1, .h1{font-size:196%;  font-weight:normal; font-style: normal; color:#7CAF3C;}
h2, .h2{font-size:167%; font-weight:normal; font-style: normal; color:#2F5C1A;}
h3, .h3{font-size:146.5%; font-weight:normal; font-style: normal; color:#7CAF3C;}
h4, .h4{font-size:123.1%; font-weight:normal; font-style: normal; color: #333;}
h5, .h5{font-size:108%; font-weight:bold; font-style: normal; color:#2F5C1A;}
h6, .h6{font-size:108%; font-weight:normal;  font-style: italic; color:#333;}
/* if additional headings are needed they should be created via additional classes, never via location dependant styling */
.category{font-size:108%; font-weight:normal; font-style: normal; text-transform:uppercase; color: #333;}
.category a{color: #333;}
.important a{font-weight:bold;}
/* links */
a { color: #036; font-weight:bold;text-decoration: none }
a:focus, a:hover { text-decoration: underline }
a:visited { color:#005a9c; }
/* heading links */
h1 a, .h1 a, 
h2 a, .h2 a,
h3 a, .h3 a, 
h4 a, .h4 a{color:#036; font-weight:normal;display:block;} 
h5 a, .h5 a{color:#993300; font-weight:normal;display:block;}
h6 a, .h6 a{color:#404040; font-weight:normal;display:block;}
.h1 a:visited, h1 a:visited{color:#036;} 
.h2 a:visited, h2 a:visited{color:#036;}  /* #829e00 */
.h3 a:visited, h3 a:visited{color:#036;} 
.h4 a:visited, h4 a:visited{color:#036;} 
.h5 a:visited, h5 a:visited{color:#993300;}
.h6 a:visited, h6 a:visited{color:#404040;}
}


# Initialize git repo
git :init

# Ignore some files
file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

# Create some blank ignore files 
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

# Save a copy of the database.yml
run "cp config/database.yml config/example_database.yml"

#====================
# AUTHENTICATION
#====================

##
## Create the UserSession model and the UserSessions controller
##

generate :session, "user_session"
generate :controller, "user_sessions"

# Fill the user sessions controller with default content
file 'app/controllers/user_sessions_controller.rb',
%q{class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
}

##
## Create and setup the User model
## 

# Generate the User scaffolding
generate :rspec_scaffold, "user login:string crypted_password:string " + 
                         "password_salt:string persistence_token:string " +
                         "login_count:integer last_request_at:datetime " + 
                         "last_login_at:datetime current_login_at:datetime " +
                         "last_login_ip:string current_login_ip:string"

# Remove the users layout
run "rm app/views/layouts/users.html.erb"

# Apply the User migration
rake "db:migrate"

# Make the user act as authentic:
file 'app/models/user.rb',
%q{class User < ActiveRecord::Base
  acts_as_authentic
end
}

##
## Create the UsersController
##

route "map.resource :account, :controller => 'users'"
route "map.resources :users"

file 'app/controllers/users_controller.rb',
%q{class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = t(:account_registered)
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:account_updated)
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
}

file 'app/controllers/application_controller.rb',
%q{# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
 
class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = t(:must_be_logged_in_to_access)
        redirect_to new_user_session_url
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = t(:must_be_logged_out_to_access)
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
}

##
## Add the views related to Authlogic
##

file 'app/views/password_resets/edit.html.erb',
%q{<h1>Change My Password</h1>
 
<% form_for @user, :url => password_reset_path, :method => :put do |f| %>
  <%= f.error_messages %>
  <%= f.label :password %><br />
  <%= f.password_field :password %><br />
  <br />
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation %><br />
  <br />
  <%= f.submit t(:update_password_and_log_me_in) %>
<% end %>
}

file 'app/views/password_resets/new.html.erb',
%q{<h1><%= t(:forgot_password)%></h1>
 
<p><%= t(:forgot_password_instruction)%></p>
 
<% form_tag password_resets_path do %>
  <label><%= t(:email) %>:</label><br />
  <%= text_field_tag "email" %><br />
  <br />
  <%= submit_tag t(:reset_password) %>
<% end %>
}

file 'app/views/user_sessions/new.html.erb',
%q{<h1><%= t(:login) %></h1>
 
<% form_for @user_session, :url => user_session_path do |f| %>
  <%= f.error_messages %>
  <%= f.label :login %><br />
  <%= f.text_field :login %><br />
  <br />
  <%= f.label :password %><br />
  <%= f.password_field :password %><br />
  <br />
  <%= f.check_box :remember_me %><%= f.label :remember_me %><br />
  <br />
  <%= f.submit t(:login) %>
<% end %>
}


file 'app/views/users/_form.erb',
%q{<%= form.label t(:login) %><br />
<%= form.text_field :login %><br />
<br />
<%= form.label t(:password), form.object.new_record? ? nil : t(:change_password) %><br />
<%= form.password_field :password %><br />
<br />
<%= form.label t(:password_confirmation) %><br />
<%= form.password_field :password_confirmation %><br />
<br />
}

file 'app/views/users/edit.html.erb',
%q{<h1><%= t(:edit_my_account) %></h1>
 
<% form_for @user, :url => account_path do |f| %>
  <%= f.error_messages %>
  <%= render :partial => "form", :object => f %>
  <%= f.submit t(:update) %>
<% end %>
 
<br /><%= link_to t(:my_profile), account_path %>
}

file 'app/views/users/new.html.erb',
%q{<h1><%= t(:register) %></h1>
 
<% form_for @user, :url => account_path do |f| %>
  <%= f.error_messages %>
  <%= render :partial => "form", :object => f %>
  <%= f.submit t(:register) %>
<% end %>
}

file 'app/views/users/show.html.erb',
%q{<p>
  <b><%= t(:login) %>:</b>
  <%=h @user.login %>
</p>
 
<p>
  <b><%= t(:login_count) %>:</b>
  <%=h @user.login_count %>
</p>
 
<p>
  <b><%= t(:last_request_at) %>:</b>
  <%=h @user.last_request_at %>
</p>
 
<p>
  <b><%= t(:last_login_at) %>:</b>
  <%=h @user.last_login_at %>
</p>
 
<p>
  <b><%= t(:current_login_at) %>:</b>
  <%=h @user.current_login_at %>
</p>
 
<p>
  <b><%= t(:last_login_ip) %>:</b>
  <%=h @user.last_login_ip %>
</p>
 
<p>
  <b><%= t(:current_login_ip) %>:</b>
  <%=h @user.current_login_ip %>
</p>
 
 
<%= link_to t(:edit), edit_account_path %>
}

file 'config/locales/en.yml',
%q{en:
  account_registered: "Account registered"
  account_updated: "Account updated!"
  change_password: "Change password"
  currently_logged_in: "currently logged in"
  current_login_at: "Current login at"
  current_login_ip: "Current login ip"
  edit: "Edit"
  edit_my_account: "Edit my account"
  footer: "Footer text"
  last_login_at: "Last login at"
  last_login_ip: "Last login ip"
  last_request_at: "Last request at"
  login: "Login"
  login_count: "Login count"
  logout: "Logout"
  must_be_logged_in_to_access: "Must be logged in to access"
  must_be_logged_out_to_access: "Must be logged out to access"
  my_account: "My account"
  my_profile: "My profile"
  password: "Password"
  password_confirmation: "Password confirmation"
  register: "Register"
  sure_you_want_to_logout: "Are you sure you want to logout?"
  update: "Update"
}

# Setup the authentication routes
route "map.resource :user_session"
route "map.root :controller => 'user_sessions', :action => 'new'"

# Add all files and do the initial commit
git :add => ".", :commit => "-m 'Initial commit'"

# Finished!