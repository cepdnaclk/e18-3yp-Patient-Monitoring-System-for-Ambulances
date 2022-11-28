from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import sys
import random
from datetime import datetime
import time

myMQTTClient = AWSIoTMQTTClient("group19_device2")

myMQTTClient.configureEndpoint("a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com",8883)
myMQTTClient.configureCredentials("./AmazonRootCA1.pem","./6b5b2783043f690ffff3d3ebf01b5bace6e1875748ca6c89867ddf5063e0ce11-private.pem.key","./6b5b2783043f690ffff3d3ebf01b5bace6e1875748ca6c89867ddf5063e0ce11-certificate.pem.crt")

myMQTTClient.connect()
print("Client Connected")

topic = "/3yp/group19/patient2"
print("Patient 2")

for i in range(40):
    now = datetime.now()    
    current_time = now.strftime("%H:%M:%S")
    value = random.randint(5300,5500)
    msg = "patient 2 "+str(current_time)+": Value "+str(i+1)+" = "+str(value)
    myMQTTClient.publish(topic,msg,0)
    print("patient 2 "+str(current_time)+": Value "+str(i+1)+" sent. ("+str(value)+")")
    time.sleep(3)

myMQTTClient.disconnect()
print("Client Disonnected")
