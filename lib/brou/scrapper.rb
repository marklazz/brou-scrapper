require 'capybara'
require 'capybara/dsl'
#require 'capybara/envjs'
require 'akephalos'

module Brou
  class Scrapper
    include Capybara

    attr_accessor :agent, :conf, :storage

    def authenticate
      log "#authenticate"
      fill_in 'userName', :with => @conf.username
      fill_in 'password', :with => @conf.password
      #puts find(:button).inspect
      click_button('button')
      #submit_form('formLogin')
      #page.evaluate_script("document.forms['formLogin'].submit()")
      #click_button('_eventId_ok')
      #find('button').click
#      within('#formLogin') do
        #page.find(:xpath, "//input[@type='submit']").click
      #end
      #find(:button).click
      #find_button('button').click
      #page.execute_script("document.forms['formLogin'].submit()")
    end

    def initialize(conf, storage)
      log "#initialize"
      self.conf = conf
      self.storage = storage
      Capybara.run_server = false
      Capybara.default_wait_time = 30
      #Capybara.javascript_driver = Capybara.current_driver = :akephalos
      #Capybara.current_driver = :akephalos
      #Capybara.javascript_driver = :envjs
      Capybara.current_driver = :selenium
      Capybara.app_host = 'http://www.brou.com.uy'
    end

    def get_accounts
      log "#get_accounts"
      count = all(:xpath, "//form[@id='formCuentas']//tbody/tr").length
      #count = all("#formCuentas tbody tr").length
      log "account count = #{count}"
      result = (1 .. (count - 2)).inject([]) do |accounts, i|
        data = {}
        number, amount = all(:xpath, "//form[@id='formCuentas']//tbody/tr/td[3]")[i], all(:xpath, "//form[@id='formCuentas']//tbody/tr/td[4]")[i]
        log "#number #{number}, #account: #{amount}"
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
      find('li.salir a').click
    end

    def log str
      print "#{str}\n"
    end

    def scrape
      setup_agent
      authenticate
      sleep(4)
      click_continue_if_present
      sleep(10)
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
