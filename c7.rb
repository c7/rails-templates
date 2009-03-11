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

gem 'sqlite3-ruby', :lib => 'sqlite3'
gem 'right_aws'
gem 'mocha', :version => '>= 0.9.2'
gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com', :version => '>= 2.0.5'
gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :version => '>= 1.1.3'
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
    	      <%= render :partial => 'layouts/flashes' -%>
            <%= yield %>
    	    </div>
        </div>
      </div>
      <div id="ft" role="contentinfo"><p>Footer text.</p></div>
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
h1, h2, h3, h4, h5, h6, ul, ol,dl, p, ul {padding:10px;}
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

# Add all files and do the initial commit
git :add => ".", :commit => "-m 'initial commit'"

# Generate the page controller
generate :controller, "page index -s"

# Setup the root route
route "map.root :controller => 'page'"

# Commit the added page controller
git :add => ".", :commit => "-m 'adding page controller'"