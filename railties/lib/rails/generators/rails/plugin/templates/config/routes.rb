# frozen_string_literal: true
<% if mountable? -%>
<%= camelized_modules %>::Engine.routes.draw do
<% else -%>
Rails.application.routes.draw do
<% end -%>
end
