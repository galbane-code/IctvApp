import json
import re
import socket
from threading import Thread
from selenium.webdriver.support import expected_conditions as EC
from selenium import webdriver
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
from selenium.webdriver.support.wait import WebDriverWait

class Server:
    """
    Fiber Test Server that handles all the clients for the ICTV App.
    """
    def __init__(self):

        self.json_result = {}
        self.server_socket_tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.tcp_port_number = 12000
        self.sever_buffer_size = 1024

    def run_server(self):
        """
        This method runs until manual interrupt.
        :return:
        """
        while True:
            self.run_tcp_socket()


    def run_tcp_socket(self):
        """"
        This function connects clients to a TCP socket, gets their address for the test.
        """
        self.server_socket_tcp.bind(("", self.tcp_port_number))
        threads = []
        while True:
            self.server_socket_tcp.listen(4)
            connection_socket, client_address = self.server_socket_tcp.accept()
            newthread = ClientThread(connection_socket,self.sever_buffer_size)
            newthread.start()
            threads.append(newthread)

        for t in threads:
            t.join()




class ClientThread(Thread):
    """
    Fiber Test clientThread that handles each client separately.
    """
    def __init__(self, connect,sever_buffer_size):
        Thread.__init__(self)
        self.connect = connect
        self.sever_buffer_size = sever_buffer_size
        self.json_result = {}


    def run(self):
        """
        overRun for the run function in the Thread.
        """
        while True:
            bytes_address = self.connect.recv(self.sever_buffer_size)

            full_address = bytes_address.decode("utf-8")
            full_address = full_address.split(",")

            city = full_address[0]
            address = re.findall("[\u0590-\u05fe]+", full_address[1])
            num = re.findall("\d+", full_address[1])[0]
            if len(address) > 1:
                temp_address = ""
                for i in range(len(address)):
                    if i == len(address) - 1:
                        temp_address += address[i]
                    else:
                        temp_address += address[i] + " "

                address = temp_address
            else:
                address = address[0]

            self.fiber_selenuim_test(city, address, num)
            data = json.dumps(self.json_result)
            self.connect.sendall(bytes(data, encoding="utf-8"))
            self.connect.close()

    def fiber_selenuim_test(self, city, address, number):
        """
        the Fiber test using selenium package and saves the json to be send.
        """
        dict_to_json = {}
        driver = webdriver.Chrome(executable_path="C:\\chromedriver.exe")
        try:
            driver.get("https://www.partner.co.il/globalassets/global/fiberinternet/index.html")
            delay = 1
            try:
                myElem = WebDriverWait(driver, delay).until(EC.presence_of_element_located((By.ID, 'IdOfMyElement')))
            except TimeoutException:
                time.sleep(0.05)

            searcher_city = driver.find_element_by_xpath('//*[@id="AfibersLeadCity"]')
            searcher_city.click()
            searcher_city.send_keys(city)
            searcher_city.send_keys(Keys.TAB)
            time.sleep(0.8)
            searcher_city = driver.find_element_by_xpath('//*[@id="installationStree"]')
            time.sleep(0.8)
            searcher_city.send_keys(address)
            searcher_city.send_keys(Keys.TAB)
            searcher_city = driver.find_element_by_xpath('//*[@id="houseNum"]')
            searcher_city.send_keys(number)
            searcher_city = driver.find_element_by_xpath('//*[@id="sendBtn"]')
            searcher_city.click()
            searcher_city = driver.find_element_by_xpath('//*[@id="details-for-connection"]/h3')
            time.sleep(0.5)
            searcher_city = driver.find_element_by_xpath('//*[@id="AfibersSectionLead"]/div[2]/div/div[1]/h3/span')
            time.sleep(0.9)
            final_text = searcher_city.text
            if (final_text == "כבר הגענו אליך!"):
                dict_to_json["partner"] = "True"
            else:
                dict_to_json["partner"] = "Flase"

        except:
            dict_to_json["partner"] = "UnAvailable"

        try:
            driver.get("https://cellcom.co.il/sale/internet/300_2/")
            delay = 1.8
            try:
                myElem = WebDriverWait(driver, delay).until(EC.presence_of_element_located((By.ID, 'IdOfMyElement')))
            except TimeoutException:
                time.sleep(0.05)

            searcher_city = driver.find_element_by_xpath('//*[@id="city"]')
            searcher_city.send_keys(city)
            searcher_city.send_keys(Keys.ENTER)
            searcher_city = driver.find_element_by_xpath('//*[@id="street"]')
            time.sleep(0.7)
            searcher_city.send_keys(address)
            time.sleep(0.7)
            searcher_city.send_keys(Keys.ENTER)
            searcher_city = driver.find_element_by_xpath('//*[@id="home"]')
            searcher_city.send_keys(number)
            searcher_city.send_keys(Keys.ENTER)
            time.sleep(1.4)
            searcher_city = driver.find_element_by_xpath(
                '//*[@id="epi-page-container"]/div[1]/div/div/div/div[3]/div[1]/h1[2]')
            final_text = searcher_city.text
            if (final_text == "מעולה, יש לכם תשתית סיבים מוכנה בבניין!"):
                dict_to_json["cellcom"] = "True"
            else:
                dict_to_json["cellcom"] = "Flase"


        except:
            dict_to_json["cellcom"] = "UnAvailable"

        try:
            driver.get("https://www.bezeq.co.il/internetandphone/internet/bfiber/")
            delay = 0.5
            try:
                myElem = WebDriverWait(driver, delay).until(EC.presence_of_element_located((By.ID, 'IdOfMyElement')))
            except TimeoutException:
                time.sleep(0.05)
            searcher_city = driver.find_element_by_xpath('//*[@id="6a09c243-8935-4e1a-a537-5f9e5eb25c99"]')
            searcher_city.send_keys(city)
            searcher_city.send_keys(Keys.TAB)
            searcher_city = driver.find_element_by_xpath('//*[@id="7da2b7a6-05fc-481a-bd65-1ba99d9a1afd"]')
            time.sleep(0.9)
            searcher_city.send_keys(address)
            time.sleep(0.4)
            searcher_city.send_keys(Keys.TAB)
            searcher_city = driver.find_element_by_xpath('//*[@id="9b6a754a-8f9d-4cf1-8bfc-386f74ba6be7"]')
            searcher_city.send_keys(number)
            searcher_city = driver.find_element_by_xpath(
                '//*[@id="productPage2019"]/section[1]/div[1]/div/div[2]/div/div/div/div/div/div[2]/div[1]/div[2]/div[2]/button/span')
            searcher_city.click()
            time.sleep(1.2)
            searcher_city = driver.find_element_by_xpath(
                '//*[@id="productPage2019"]/section[1]/div[1]/div/div[2]/div/div/div/div/div/div[2]/div[3]/div[1]/h2')

            final_text = searcher_city.text
            if (final_text == "אנחנו כבר אצלכם"):
                dict_to_json["bezeq"] = "True"
            else:
                dict_to_json["bezeq"] = "Flase"

        except:
            dict_to_json["bezeq"] = "UnAvailable"

        try:
            driver.get(
                "https://www.unlimited.net.il/%D7%A4%D7%A8%D7%99%D7%A1%D7%AA-%D7%A1%D7%99%D7%91%D7%99%D7%9D-%D7%90%D7%95%D7%A4%D7%98%D7%99%D7%99%D7%9D/")
            delay = 0.5
            try:
                myElem = WebDriverWait(driver, delay).until(EC.presence_of_element_located((By.ID, 'IdOfMyElement')))
            except TimeoutException:
                time.sleep(0.05)

            searcher_city = driver.find_element_by_xpath('//*[@id="input_1_3"]')
            searcher_city.send_keys(city)
            searcher_city.send_keys(Keys.ENTER)
            time.sleep(1.2)
            searcher_city.send_keys(Keys.TAB)
            searcher_city = driver.find_element_by_xpath('//*[@id="input_1_4"]')
            searcher_city.send_keys(address)
            searcher_city.send_keys(Keys.ENTER)
            time.sleep(1.2)
            searcher_city.send_keys(Keys.TAB)
            searcher_city = driver.find_element_by_xpath('//*[@id="input_1_6"]')
            time.sleep(0.4)
            searcher_city.send_keys(number)
            searcher_city.send_keys(Keys.ENTER)
            searcher_city = driver.find_element_by_xpath('//*[@id="gform_submit_button_1"]')
            searcher_city.click()
            searcher_city = driver.find_element_by_xpath('//*[@id="be_in_touch"]/div/div/header/h2')
            final_text = searcher_city.text.split("\n")[0]

            if (final_text == "איזה כיף הכתובת מחוברת"):

                dict_to_json["unlimited"] = "True"
            else:
                dict_to_json["unlimited"] = "Flase"

        except:
            dict_to_json["unlimited"] = "UnAvailable"

        self.json_result = dict_to_json

if __name__ == "__main__":
    server = Server()
    server.run_server()