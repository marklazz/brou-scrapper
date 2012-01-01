require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
#require 'akephalos'

module Brou
  class Scrapper
    include Capybara
    include Brou::Logger

    attr_accessor :agent, :conf, :storage

    def authenticate
      log "#authenticate"
      within "#formLogin" do
        fill_in 'userName', :with => @conf.username
        fill_in 'password', :with => @conf.password
      end
      find(:xpath, "//input[@type='submit']").click
      sleep(3)
    end

    def initialize(conf, storage)
      log "#initialize"
      self.conf = conf
      self.storage = storage
      Capybara.run_server = false
      Capybara.default_wait_time = 5
      Capybara.current_driver = :webkit
      Capybara.app_host = 'http://www.brou.com.uy'
    end

    def get_accounts
      log "#get_accounts"
      count = all(:xpath, "//form[@id='formCuentas']//tbody/tr").length
      log "account count = #{count}"
      result = (1 .. (count - 2)).inject([]) do |accounts, i|
        data = {}
        number, amount = all(:xpath, "//form[@id='formCuentas']//tbody/tr/td[3]")[i], all(:xpath, "//form[@id='formCuentas']//tbody/tr/td[4]")[i]
        log "#number #{number.text if number}, #account: #{amount.text if amount}"
        data[:number] = number.text if number
        data[:amount] = amount.text if amount
        accounts << data if @conf.accounts.include?(data[:number])
        accounts
      end
      result
    end

    def click_continue_if_present
      log "#click_continue_if_present"
      click_button 'Continuar'
    rescue
    end

    def close_session
      log "#close_session"
      find('#span_header_salir').click
    end

    def scrape
      setup_agent
      authenticate
      #sleep(4)
      click_continue_if_present
      #sleep(10)
      storage.save(get_accounts)
      close_session
    end

    def setup_agent
      log "#setup_agent"
      visit '/'
      click_link 'personas'
    end
  end
end
