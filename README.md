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


### PROBLEM

What can happen if ambulance arrives late at the emergency case ?

What can we do while Ambulance is carrying the Patient ?

No system for real-time patient monitoring and updating

No location tracking or time prediction system

### EXISTING METHOD

Currently there are number of health monitoring systems available for ICU patients which can be used only when patient is on bed

System is wired

Huge in size

Monitoring particular disease only

### INTRODUCTION

Three main functions of the device

Patient health monitoring

Location tracking

Sending real time data to the hospital

### SOLUTION ARCHITECTURE
![SolutionArchitecture drawio (1)](https://user-images.githubusercontent.com/99112218/199411429-e50e5d45-6558-448d-8f7f-db9e2456b6d2.png)



### Hardware Components

Arduino UNO ATMega328P

GPS Modem (NEO6MV2)

ESP8266 Wifi Module

### Sensors

Pulse Rate Heartbeat Sensor Module

Temperature Sensor Module

Blood Pressure Sensor - GSR V1.1
