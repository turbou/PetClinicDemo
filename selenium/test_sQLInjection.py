# Generated by Selenium IDE
import pytest
import time
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

class TestSQLInjection():
  def setup_method(self, method):
    self.driver = webdriver.Remote(command_executor='http://selenium:4444/wd/hub', desired_capabilities=DesiredCapabilities.CHROME)
    self.vars = {}
  
  def teardown_method(self, method):
    self.driver.quit()
  
  def test_sQLInjection(self):
    self.driver.get("http://build:8001/")
    self.driver.set_window_size(1920, 1057)
    self.driver.find_element(By.CSS_SELECTOR, "li:nth-child(3) span:nth-child(2)").click()
    self.driver.find_element(By.NAME, "lastName").click()
    self.driver.find_element(By.NAME, "lastName").send_keys("Davis")
    self.driver.find_element(By.CSS_SELECTOR, ".btn:nth-child(1)").click()
  
