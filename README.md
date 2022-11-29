## Introduction

There’s no existing system to monitor the patients while they are taken to the hospital by emergency vehicles in Sri Lanka. In some scenarios, due to the lack of facilities and resources, patients are transferred from one hospital to another hospital. This can be inconvenient for both parties; the patient and the hospital. It might be a risk to the patient’s life as well. Even after admitting to the hospital, it may take some time to arrange things for the patient and check the status of the patient. Other than the test results, the Status and the condition of the patient are normally conveyed by a guardian of the patient and there can be reliability issues in such information. 

These problems can be addressed separately by a real-time monitoring device for checking the status of the patient and a location tracking system for the ambulance which is connected to a cloud such that hospitals can get information and take decisions. As an example, they can monitor the real-time status of the patient (pulse rate, heart rate etc.) together with a summary report of the patient, and can get the predictions at which time a particular ambulance reaches their hospital. So that hospital staff will get enough time to do the necessary arrangements for that patient and allocate their staff appropriately. Not only that, when considering the emergency vehicle service side(ambulance) they can track the nearest available hospitals for this particular patient after submitting his/her pre-conditions. So, they can directly take patients to the appropriate hospitals without wasting the time. 


## Solution Architecture
![SolutionArchitecture drawio (3)](https://user-images.githubusercontent.com/73444543/204417087-dc541348-8a63-48ff-ae67-7f2a7f0a0d86.png)


## Hardware and Software Designs
### Hardware Components
ATMega328P\
![atmega](https://user-images.githubusercontent.com/73444543/204417187-1f38e246-e0ea-4cc5-a818-8c29cbd5d98b.jpg)


Microcontroller is like brain of the system because it communicates with inputs and outputs and controls the entire operation of the system. Here we are using ATMega328P as the Microcontroller. Reading longitude and latitude from GPS modem, reading health parameters of the patient, desplaying them on a user interfaces and send these data to the cloud are the various functions of the Microcontroller.

ESP8266 Wifi Module\
 ![wifi](https://user-images.githubusercontent.com/73444543/199441973-f2b57172-b4e1-4b0e-ba53-34a7d887132b.jpg)

The ESP8266 WiFi Module is a self contained SOC with integrated TCP/IP protocol stack that can give any microcontroller access to your WiFi network. The ESP8266 is capable of either hosting an application or offloading all WiFi networking functions from another application processor.

GPS Modem (NEO6MV2)\
 ![gps](https://user-images.githubusercontent.com/73444543/199442004-74162ede-0182-4212-aa7d-c7a19581b212.jpg)

Main function of GPS modem is provide longitude and latitude of the ambulance to the Microcontroller. It receives data from satellite and transfer them into Microcontroller through serial communication. As ambulance moves along the way from patient’s home to hospital, the co- ordinates of ambulance location will change and these variations are given to Microcontroller.

Heart Rate Oxygen Pulse Sensor Module\
![bpm](https://user-images.githubusercontent.com/73444543/204417296-e6cda821-8f3d-4506-a4fd-d3d5342bab45.jpg)

MAX30100 is a multipurpose sensor used for multiple applications. It is a heart rate monitoring sensor along with a pulse oximeter. The sensor comprises two Light Emitting Diodes, a photodetector, and a series of low noise signal processing devices to detect heart rate and to perform pulse oximetry.

Temperature Sensor Module - DS18B20\
![temp](https://user-images.githubusercontent.com/73444543/199442056-3605ccba-edb2-4250-b456-cc2aacf86f1b.jpg)

DS18B20 digital temperature sensor works on a single bus and it has 64-bit ROM to store the serial number of component. It can get quite a few DS18B20 sensors connected to a single bus in parallel. With a microcontroller, you can control so many DS18B20 sensors that are distributed around a wide range.

## Circuit Diagram
![cicuit diagram](https://user-images.githubusercontent.com/73444543/204421503-0e8982d4-ff6d-4d79-807e-af54e95d36df.png)

## UI Design 
### Mobile Application
![1](https://user-images.githubusercontent.com/73444543/204421741-097ead06-a8a0-42b7-9909-e57f2a42749c.jpeg) ![2](https://user-images.githubusercontent.com/73444543/204421756-5044ca8f-5539-4fd2-b548-d2fb9653f210.jpeg) ![3](https://user-images.githubusercontent.com/73444543/204421865-6246a490-6792-408c-a3ea-ab60dfa75b5d.jpeg) ![4](https://user-images.githubusercontent.com/73444543/204421896-f72edcda-189b-4d0e-97a7-b8929cb37fd3.jpeg) ![5](https://user-images.githubusercontent.com/73444543/204421907-ea42e1c7-7321-4937-9499-7467ccd4c7ee.jpeg) ![6](https://user-images.githubusercontent.com/73444543/204422174-d54a3402-d738-479d-ab6f-304f281294c5.jpeg)

### Web Site
![11](https://user-images.githubusercontent.com/73444543/204422296-5a30311c-bf57-4a55-996f-d5d61a02d51a.jpeg)
 ![12](https://user-images.githubusercontent.com/73444543/204422309-84cb99e1-f864-49a1-9c4f-e5c02b12adcd.jpeg) \
![13](https://user-images.githubusercontent.com/73444543/204422321-a20edf16-2f6c-4c07-8dac-eb6b77541fa5.jpeg)
 ![14](https://user-images.githubusercontent.com/73444543/204422332-05087242-e46a-4c22-b2f7-2df2d15c888b.jpeg)

## Testing

![test](https://user-images.githubusercontent.com/73444543/204421340-10ca4bd6-b77f-43df-8702-fe169283b12f.png)
     
Considering one device :

Data inputs : 

       pulse rate , heart rate , oxygen saturation - from a real person   
       GPS cordinates :  executing  a given script of GPS cordinates
       
Checking them via Web interface


## Detailed budget

![budget](https://user-images.githubusercontent.com/73444543/204418293-f63bbda2-6c6b-4211-9783-63418ee9a4c4.png)


## Conclusion

Currently, there’s no system for real-time patient monitoring and updating the hospital from the ambulance exists. Normally medical officers/nurses in there will contact hospitals via mobile calls in critical situations which are not that reliable. And there’s no location tracking or time prediction system for ambulances that exists. Also, in case of finding a suitable hospital, ambulances prefer the nearest hospital or general hospital without considering the conditions or facilities available at the moment which will be caused previously mentioned issues. Considering the current situation regarding this matter, this project will be able to highly contribute to rebuilding this system.
