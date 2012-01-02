require 'headless'
module Brou
  class Controller
    class << self
      include Brou::Logger
      attr_accessor :config, :storage, :old_content

      def init
        log "#init"
        self.config = Brou::Configuration.new
        self.storage = Brou::Storage.new
        self.old_content = storage.current_content
      end

      def scrapper
        log "#scrapper"
        @scrapper ||= Brou::Scrapper.new(self.config, self.storage)
      end

      def scrape_and_notify
        log "#scrape_and_notify"
        scrape_and_notify!
      rescue
      end

      def scrape_and_notify!
        log "#scrape_and_notify!"
        headless = Headless.new
        headless.start
        init
        scrapper.scrape
        headless.destroy
      rescue NotifyAmountChanged
        Brou::EmailNotifier.notify!(config.email, config.email_password, self.storage.current_content, old_content)
      end
    end
  end
end
