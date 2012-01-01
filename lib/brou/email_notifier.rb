require 'gmail'
module Brou::EmailNotifier
  extend self

  def notify!(email, password, current_content, old_content)
    gmail = Gmail.new(email, password)
    gmail.deliver do
      to "#{email}@gmail.com"
      subject "BROU: Amount changed!"
      html_part do
        content_type 'text/html; charset=UTF-8'
        body %Q(
            <p>
              <h1>New:</h1>
              <p>
                #{current_content}
              </p>
              <h1>Old:</h1>
              <p>
                #{old_content}
              </p>
            </p>)
      end
    end
    gmail.logout
  end
end
