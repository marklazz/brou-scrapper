module Brou
  class Controller
    class << self
      attr_accessor :config, :storage, :old_content

      def init
        self.config = Brou::Configuration.new
        self.storage = Brou::Storage.new
        self.old_content = storage.current_content
      end

      def scrape_and_notify
        scrape_and_notify!
      rescue
      end

      def scrape_and_notify!
        self.init
        Brou::Scrapper.new(self.config, self.storage).scrape
      rescue NotifyAmountChanged
        Brou::EmailNotifier.notify!(config.email, config.email_password, self.storage.current_content, old_content)
      end
    end
  end
end
