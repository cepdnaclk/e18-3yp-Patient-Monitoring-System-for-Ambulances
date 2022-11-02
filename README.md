___
# DELETE THIS INSTRUCTIONS AND ADD AN INTRODUCTION ABOUT YOUR PROJECT
___

# eYY-3yp-project-template

This is a sample repository you can use for your Embedded Systems project. Once you followed these instructions, remove the text and add a brief introduction to here.

### Enable GitHub Pages

You can put the things to be shown in GitHub pages into the _docs/_ folder. Both html and md file formats are supported. You need to go to settings and enable GitHub pages and select _main_ branch and _docs_ folder from the dropdowns, as shown in the below image.

![image](https://user-images.githubusercontent.com/11540782/98789936-028d3600-2429-11eb-84be-aaba665fdc75.png)

### Special Configurations

These projects will be automatically added into [https://projects.ce.pdn.ac.lk](). If you like to show more details about your project on this site, you can fill the parameters in the file, _/docs/index.json_

```
{
  "title": "This is the title of the project",
  "team": [
    {
      "name": "Team Member Name 1",
      "email": "email@eng.pdn.ac.lk",
      "eNumber": "E/yy/xxx"
    },
    {
      "name": "Team Member Name 2",
      "email": "email@eng.pdn.ac.lk",
      "eNumber": "E/yy/xxx"
    },
    {
      "name": "Team Member Name 3",
      "email": "email@eng.pdn.ac.lk",
      "eNumber": "E/yy/xxx"
    }
  ],
  "supervisors": [
    {
      "name": "Dr. Supervisor 1",
      "email": "email@eng.pdn.ac.lk"
    },
    {
      "name": "Supervisor 2",
      "email": "email@eng.pdn.ac.lk"
    }
  ],
  "tags": ["Web", "Embedded Systems"]
}
```

Once you filled this _index.json_ file, please verify the syntax is correct. (You can use [this](https://jsonlint.com/) tool).

### Page Theme

A custom theme integrated with this GitHub Page, which is based on [github.com/cepdnaclk/eYY-project-theme](https://github.com/cepdnaclk/eYY-project-theme). If you like to remove this default theme, you can remove the file, _docs/\_config.yml_ and use HTML based website.


## Introduction

There’s no existing system to monitor the patients while they are taken to the hospital by emergency vehicles in Sri Lanka. In some scenarios, due to the lack of facilities and resources, patients are transferred from one hospital to another hospital. This can be inconvenient for both parties; the patient and the hospital. It might be a risk to the patient’s life as well. Even after admitting to the hospital, it may take some time to arrange things for the patient and check the status of the patient. Other than the test results, the Status and the condition of the patient are normally conveyed by a guardian of the patient and there can be reliability issues in such information. 

These problems can be addressed separately by a real-time monitoring device for checking the status of the patient and a location tracking system for the ambulance which is connected to a cloud such that hospitals can get information and take decisions. As an example, they can monitor the real-time status of the patient (pulse rate, heart rate etc.) together with a summary report of the patient, and can get the predictions at which time a particular ambulance reaches their hospital. So that hospital staff will get enough time to do the necessary arrangements for that patient and allocate their staff appropriately. Not only that, when considering the emergency vehicle service side(ambulance) they can track the nearest available hospitals for this particular patient after submitting his/her pre-conditions. So, they can directly take patients to the appropriate hospitals without wasting the time. 


## Solution Architecture

![SolutionArchitecture drawio (1)](https://user-images.githubusercontent.com/99112218/199412680-61d7b28e-3bda-467c-bb43-d6518cc63e34.png)

## Hardware and Software Designs

Arduino UNO ATMega328P\
![arduino](https://user-images.githubusercontent.com/73444543/199441943-80e0843f-52c1-4531-886e-3c497bfedf9d.jpg)

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
