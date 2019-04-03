# Checklist:
# - Should this be inside a Active Record Transaction block?
# - Do we need to notify specific stakeholders about the database changes?
# - Any callbacks, emails or notifications triggered?
# - Appropriate prints and progress logs?
# - Performance issues and manual garbage collection required?

namespace :<%= file_name %> do
<% actions.each do |action| -%>
  desc "TODO"
  task <%= action %>: [:environment] do
    ActiveRecord::Base.transaction do


      # DO NOT REMOVE THIS PART. MARKS THE RAKE AS COMPLETE IN THE DATABASE
      RakeMigration.mark_complete(__FILE__)
    end
  end
<% end -%>
end
