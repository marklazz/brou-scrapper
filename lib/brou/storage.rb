module Brou
  class Storage
    attr_accessor :content

    FILENAME = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'cache.html' )

    def amount_changed?(old_content)
      old_content && self.content != old_content
    end

    def current_content
      IO.readlines(FILENAME)[0] if File.exists?(FILENAME)
    end

    def save(accounts)
      self.content, old_content = serialized_accounts(accounts), current_content
      File.delete(FILENAME) if old_content
      write!

      raise NotifyAmountChanged if amount_changed?(old_content)
    end

    def serialized_accounts(accounts)
      accounts.inject("<p>") do |res, data|
        res += "#{data[:number]}: #{data[:amount]}<br/>"
      end.concat("</p>")
    end

    def write!
      aFile = File.new(FILENAME, "w")
      aFile.write(self.content)
      aFile.close
    end
  end
end
