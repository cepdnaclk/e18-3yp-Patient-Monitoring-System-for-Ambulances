---
layout: home
permalink: index.html

# Please update this with your repository name and project title
repository-name: eYY-3yp-project-template
title: Project Template
---

[comment]: # "This is the standard layout for the project, but you can clean this and use your own template"

# Patient Monitoring System for Ambulances

---

## Team
-  e18022, D.I. Amarasinghe, [e18022@eng.pdn.ac.lk](mailto:name@email.com)
-  e18318, S.A.P. Sandunika, [e18318@eng.pdn.ac.lk](mailto:name@email.com)
-  e18354, K.K.D.R. Tharaka, [e18354@eng.pdn.ac.lk](mailto:name@email.com)

#### Table of Contents
1. [Introduction](#introduction)
2. [Solution Architecture](#solution-architecture )
3. [Hardware & Software Designs](#hardware-and-software-designs)
4. [Testing](#testing)
5. [Detailed budget](#detailed-budget)
6. [Conclusion](#conclusion)
7. [Links](#links)

## Introduction

There’s no existing system to monitor the patients while they are taken to the hospital by emergency vehicles in Sri Lanka. In some scenarios, due to the lack of facilities and resources, patients are transferred from one hospital to another hospital. This can be inconvenient for both parties; the patient and the hospital. It might be a risk to the patient’s life as well. Even after admitting to the hospital, it may take some time to arrange things for the patient and check the status of the patient. Other than the test results, the Status and the condition of the patient are normally conveyed by a guardian of the patient and there can be reliability issues in such information. 

These problems can be addressed separately by a real-time monitoring device for checking the status of the patient and a location tracking system for the ambulance which is connected to a cloud such that hospitals can get information and take decisions. As an example, they can monitor the real-time status of the patient (pulse rate, heart rate etc.) together with a summary report of the patient, and can get the predictions at which time a particular ambulance reaches their hospital. So that hospital staff will get enough time to do the necessary arrangements for that patient and allocate their staff appropriately. Not only that, when considering the emergency vehicle service side(ambulance) they can track the nearest available hospitals for this particular patient after submitting his/her pre-conditions. So, they can directly take patients to the appropriate hospitals without wasting the time. 


## Solution Architecture

![SolutionArchitecture drawio (1)](https://user-images.githubusercontent.com/99112218/199412680-61d7b28e-3bda-467c-bb43-d6518cc63e34.png)

## Hardware and Software Designs

Arduino UNO ATMega328P\
![arduino](https://user-images.githubusercontent.com/73444543/199441943-80e0843f-52c1-4531-886e-3c497bfedf9d.jpg)

Microcontroller is like brain of the system because it communicates with inputs and outputs and controls the entire operation of the system. Here we are using Arduino UNO ATMega328P as the Microcontroller. Reading longitude and latitude from GPS modem, reading health parameters of the patient, desplaying them on a user interfaces and send these data to the hospitals are the various functions of the Microcontroller.

ESP8266 Wifi Module\
 ![wifi](https://user-images.githubusercontent.com/73444543/199441973-f2b57172-b4e1-4b0e-ba53-34a7d887132b.jpg)

GPS Modem (NEO6MV2)\
 ![gps](https://user-images.githubusercontent.com/73444543/199442004-74162ede-0182-4212-aa7d-c7a19581b212.jpg)

Pulse Rate Heartbeat Sensor Module\
 ![heart](https://user-images.githubusercontent.com/73444543/199442031-8538eeda-180f-4f4a-8c4d-e06a6420a5a5.jpg)

Temperature Sensor Module - DS18B20\
![temp](https://user-images.githubusercontent.com/73444543/199442056-3605ccba-edb2-4250-b456-cc2aacf86f1b.jpg)

Blood Pressure Sensor -GSR V1.1\
![bp](https://user-images.githubusercontent.com/73444543/199442127-4407d716-b530-41c2-932e-04edda5111b5.jpg)

## Testing


Considering one device :

Data inputs : 

       pulse rate , heart rate , blood pressure - from a real person   
       GPS cordinates :  executing  a given script of GPS cordinates
       
Checking them via Web interface


## Detailed budget

![budget](https://user-images.githubusercontent.com/73444543/199421449-65e84ab8-a726-4def-80e9-6605ce814a81.png)

## Conclusion

Currently, there’s no system for real-time patient monitoring and updating the hospital from the ambulance exists. Normally medical officers/nurses in there will contact hospitals via mobile calls in critical situations which are not that reliable. And there’s no location tracking or time prediction system for ambulances that exists. Also, in case of finding a suitable hospital, ambulances prefer the nearest hospital or general hospital without considering the conditions or facilities available at the moment which will be caused previously mentioned issues. Considering the current situation regarding this matter, this project will be able to highly contribute to rebuilding this system.

## Links

- [Project Repository](https://github.com/cepdnaclk/e18-3yp-Patient-Monitoring-System-for-Ambulances)
- [Project Page](https://cepdnaclk.github.io/e18-3yp-Patient-Monitoring-System-for-Ambulances)
- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [University of Peradeniya](https://eng.pdn.ac.lk/)

[//]: # (Please refer this to learn more about Markdown syntax)
[//]: # (https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
