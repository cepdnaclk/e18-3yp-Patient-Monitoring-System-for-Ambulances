import time

def customCallback(client,userdata,message):
    print(message.payload)
    
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient

myMQTTClient = AWSIoTMQTTClient("group19_hospital1")
myMQTTClient.configureEndpoint("a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com",8883)
myMQTTClient.configureCredentials("./AmazonRootCA1.pem","./6b5b2783043f690ffff3d3ebf01b5bace6e1875748ca6c89867ddf5063e0ce11-private.pem.key","./6b5b2783043f690ffff3d3ebf01b5bace6e1875748ca6c89867ddf5063e0ce11-certificate.pem.crt")

myMQTTClient.connect()
print("Client Connected")
print("Hospital 1")
patient = input("Which patient(1/2) ? ")

myMQTTClient.subscribe("/3yp/group19/patient"+patient,1,customCallback)
print("waiting for the callback, Click to continue...")
x = input()

myMQTTClient.unsubscribe("/3yp/group19/patient"+patient)
print("Client unsubscribed")

myMQTTClient.disconnect()
print("Client disconnected")
