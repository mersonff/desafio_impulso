# frozen_string_literal: true

SimpleCov.start do
  add_filter %r{^/spec/}
  add_filter %r{^/config/}

  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  add_group "Jobs", "app/jobs"
end
