from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import sys
import random
from datetime import datetime
import time

value1 = 42
value2 = 61
value3 = 58
value4 = 83

deviceID = str(input("Device ID: "));
hospitalID = "001"
outTopic = ""
inTopic = "Device_"+deviceID

rideFLAG = False

def changeHospital(hospital):
    global outTopic
    outTopic = "/AmbulanceProject/Hospital_" + hospital + "/" + deviceID;

def startRide(newHospital):
    global outTopic
    global rideFLAG
    changeHospital(newHospital)
    myMQTTClient.publish(outTopic, "Active", 0)
    rideFLAG = True

def stopRide():
    global rideFLAG
    global hospitalID
    changeHospital(hospitalID)
    rideFLAG = False

def checkMsg(msgType,receivedMsg):
    global rideFLAG
    print(msgType)
    print(receivedMsg)
    if msgType == "start":
        print("Started the ride")
        if rideFLAG==False:
            startRide(receivedMsg)
    elif msgType == "stop":
        print("Stopped the ride")
        stopRide();
    elif msgType == "change":
        print("Changed the hospital")
        changeHospital(receivedMsg);
    else:
        print("Msg received")
        print(receivedMsg)

def customCallback(client,userdata,message):
    msgType,receivedMsg = (str(message.payload.decode("UTF-8"))).split(":")
    checkMsg(msgType,receivedMsg)

myMQTTClient = AWSIoTMQTTClient("group19_device1")

myMQTTClient.configureEndpoint("a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com",8883)
myMQTTClient.configureCredentials("./AmazonRootCA1.pem","./6b5b2783043f690ffff3d3ebf01b5bace6e1875748ca6c89867ddf5063e0ce11-private.pem.key","./6b5b2783043f690ffff3d3ebf01b5bace6e1875748ca6c89867ddf5063e0ce11-certificate.pem.crt")

myMQTTClient.connect()
print("Client Connected")

myMQTTClient.subscribe(inTopic,1,customCallback)

while(True):
    if rideFLAG==True:
        msg = "{'temperature':" + "{:.4f}".format(value1) +",'heart rate':"+ "{:.4f}".format(value2) +",'pulse rate':"+ "{:.4f}".format(value3) +",'oxygen saturation':"+ "{:.4f}".format(value4) +"}"
        myMQTTClient.publish(outTopic,msg,0)
        print(outTopic)
        value1 = value1 + 0.243;
        value2 = value2 + 0.3578;
        value3 = value3 + 0.1259;
        value4 = value4 + 0.5346;
        time.sleep(2)

myMQTTClient.unsubscribe(inTopic)
print("Client unsubscribed")

myMQTTClient.disconnect()
print("Client Disonnected")
