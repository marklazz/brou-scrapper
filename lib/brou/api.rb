require 'gmail'

module Brou
  class Api
    class << self
      attr_accessor :config, :storage, :old_content

      def init
        self.config = Brou::Configuration.new
        self.storage = Brou::Storage.new
        self.old_content = storage.current_content
      end

      def notify!
        gmail = Gmail.new(config.email, config.email_password)
        gmail.deliver do
          to "#{Brou::Api.config.email}@gmail.com"
          subject "BROU: Amount changed!"
          text_part do
            body "New:\n#{Brou::Api.storage.current_content}\n\nOld:\n#{Brou::Api.old_content}\n"
          end
        end
        gmail.logout
      end

      def scrape_and_notify
        scrape_and_notify!
      rescue
      end

      def scrape_and_notify!
        self.init
        Brou::Scrapper.new(self.config, self.storage).scrape
      rescue NotifyAmountChanged
        notify!
      end
    end
  end
end
