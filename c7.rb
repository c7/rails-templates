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

# Generate the RSpec files
generate :rspec

#====================
# APP
#====================

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
  
  def set_html_title(str="")
    unless str.blank?
      content_for :html_title do
       "&mdash; #{str} "
      end
    end
  end
end
}

file 'app/views/layouts/application.html.erb', 
%q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <title>Code7 Interactive <%= (html_title = yield :html_title) ? html_title : '&mdash; Default text here...' %></title>
    <%= stylesheet_link_tag 'reset-fonts-grids', 'content', :media => 'all', :cache => true %>
    <%= javascript_include_tag ['jquery', 'application'], :cache => true %>
  </head>
  <body class="<%= body_class %>">
    <div id="doc2" class="yui-t7">
      <div id="hd" role="banner">
        <img src="http://c7.se/images/logo.png" alt="Code7 Interactive"/>
      </div>
      <div id="bd">
        <%= render :partial => 'layouts/flashes' -%>
        <div class="yui-ge">
          <div role="main" class="yui-u first">
            <% if !current_user %>
              <%= link_to t(:register), new_account_path %> |
              <%= link_to t(:login), new_user_session_path %> |
            <% else %>
              <%= link_to t(:my_account), account_path %> |
              <%= link_to t(:logout), user_session_path, :method => :delete %>
            <% end %>
            <%= yield %>
    	    </div>
    	    <div class="yui-u" role="sidebar"><%= yield :sidebar %></div>
        </div>
      </div>
      <div id="ft" role="contentinfo">
        <p>
          <%= t(:footer) %> | 
          <%= pluralize User.logged_in.count, "user" %> <%= t(:currently_logged_in) %>
        </p>
      </div>
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
/* ====== Flash messages ====== */
#flash div {margin: 10px auto; padding: 5px;}
#flash_notice {background: #FFF6BF; border-top: 2px solid #FFD324; border-bottom: 2px solid #FFD324;}
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
generate :rspec_controller, "user_sessions"

run "rm app/helpers/user_sessions_helper.rb"


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
      flash[:notice] = t(:login_successful)
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = t(:logout_successful)
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
                         "last_login_ip:string current_login_ip:string " +
                         "perishable_token:string email:string"

# Remove the users layout, scaffold css and helper
run "rm app/views/layouts/users.html.erb"
run "rm public/stylesheets/scaffold.css"
run "rm app/helpers/users_helper.rb"

# Apply the User migration
rake "db:migrate"

# Make the user act as authentic:
file 'app/models/user.rb',
%q{class User < ActiveRecord::Base
  acts_as_authentic
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
end
}

file 'app/models/notifier.rb',
%q{class Notifier < ActionMailer::Base
  default_url_options[:host] = "c7.se"
  
  def password_reset_instructions(user)
    subject I18n.t(:password_reset_instructions)
    from I18n.t(:notifier_email)
    recipients user.email
    sent_on Time.now
    body :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
}

generate :rspec_controller, "password_resets"

file 'app/controllers/password_resets_controller.rb',
%q{class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
    render
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_url
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end
  
  def edit
    render
  end
 
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password successfully updated"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
 
  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:notice] = "We're sorry, but we could not locate your account." +
          "If you are having issues try copying and pasting the URL " +
          "from your email into your browser or restarting the " +
          "reset password process."
        redirect_to root_url
      end
    end
end
}

file 'app/views/notifier/password_reset_instructions.erb',
%q{A request to reset your password has been made.
If you did not make this request, simply ignore this email.
If you did make this request just click the link below:

<%= @edit_password_reset_url %>

If the above URL does not work try copying and pasting it into your browser.
If you continue to have problem please feel free to contact us.
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
%q{<% set_html_title(t(:forgot_password)) -%>
<h1><%= t(:forgot_password)%></h1>
 
<p><%= t(:forgot_password_instruction)%></p>
 
<% form_tag password_resets_path do %>
  <label><%= t(:email) %>:</label><br />
  <%= text_field_tag "email" %><br />
  <br />
  <%= submit_tag t(:reset_password) %>
<% end %>
}

file 'app/views/user_sessions/new.html.erb',
%q{<% set_html_title(t(:login)) -%>
<h1><%= t(:login) %></h1>
 
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
<%= form.label :email %><br />
<%= form.text_field :email %><br />
<br />
<%= form.label t(:password), form.object.new_record? ? nil : t(:change_password) %><br />
<%= form.password_field :password %><br />
<br />
<%= form.label t(:password_confirmation) %><br />
<%= form.password_field :password_confirmation %><br />
<br />
}

file 'app/views/users/edit.html.erb',
%q{<% set_html_title(t(:edit_my_account)) -%>
<h1><%= t(:edit_my_account) %></h1>
 
<% form_for @user, :url => account_path do |f| %>
  <%= f.error_messages %>
  <%= render :partial => "form", :object => f %>
  <%= f.submit t(:update) %>
<% end %>
 
<br /><%= link_to t(:my_profile), account_path %>
}

file 'app/views/users/new.html.erb',
%q{<% set_html_title(t(:register)) -%>
<h1><%= t(:register) %></h1>
 
<% form_for @user, :url => account_path do |f| %>
  <%= f.error_messages %>
  <%= render :partial => "form", :object => f %>
  <%= f.submit t(:register) %>
<% end %>
}

file 'app/views/users/show.html.erb',
%q{<% set_html_title(@user.login) -%>
<h1><%= @user.login %></h1>
<p>
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
  email: "Email"
  footer: "Footer text"
  forgot_password: "Forgot password?"
  forgot_password_instruction: "..."
  last_login_at: "Last login at"
  last_login_ip: "Last login ip"
  last_request_at: "Last request at"
  login: "Login"
  login_count: "Login count"
  login_successful: "Login successful!"
  logout: "Logout"
  logout_successful: "Logout successful!"
  must_be_logged_in_to_access: "Must be logged in to access"
  must_be_logged_out_to_access: "Must be logged out to access"
  my_account: "My account"
  my_profile: "My profile"
  notifier_email: "Code7 Notifier <noreply@c7.se>"
  password: "Password"
  password_confirmation: "Password confirmation"
  password_reset_instructions: "Password Reset Instructions"
  register: "Register"
  reset_password: "Reset password"
  update: "Update"
  update_password_and_log_me_in: "Update the password and log me in"
}

# Setup the authentication routes
route "map.resource :user_session"
route "map.resources :password_resets"
route "map.root :controller => 'user_sessions', :action => 'new'"

# Add all files and do the initial commit
git :add => ".", :commit => "-m 'Initial commit'"

# Finished!