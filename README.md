# zm-w0002

The zm-w0002 is a super-cheap outdoor security camera that you can [pick up on Amazon](http://amzn.to/2kwasCJ) in a 4-pack for $99.99.

![camera picture](https://images-na.ssl-images-amazon.com/images/I/71ecZB-nobL._SL300_.jpg)

I know what you're thinking... *Dude, you can't shake a stick at 4 weatherproof wifi cameras delivered to my door for $100.*  Unfortunately, you can.  These cameras are so cheap because Zmodo has removed every feature you might want to setup a *secure* locale *security* system and instead ships all of your data to their cloud service for later viewing on their proprietary mobile app.  Out of the box, these cameras will not work with *anything* other than the proprietary kitsch they're bundled with.

Luckily, it's powered by the popular and well documented HiSilicon Hi3518 SoC ([Datasheet](https://github.com/cilynx/zm-w0002/files/782566/Hi3518-Datasheet.pdf), [User Guide](https://github.com/cilynx/zm-w0002/files/782568/Hi3518-UserGuide.pdf)).

# Setup Services

According to the [Quick Start Guide](http://support.zmodo.com/assets/media/quick_user_guide_en/ZM-W0002-4_quick_guide.pdf), you're supposed to power up your cameras, then download the [MeShare App](http://surveillance.zmodo.com/meshare-app) ([iPhone](https://itunes.apple.com/us/app/meshare/id977910819?mt=8), [Android](https://play.google.com/store/apps/details?id=com.meshare&hl=en)) which will walk you through creating a [MeShare Account](https://user.meshare.com/user/login), transferring you network creds to your camera(s), and viewing your live streams on your phone.  There's no way I'm installing an app on my phone to access a "free" amorphous cloud service, nor am I sending my network creds or survalence data to said amorphous cloud service in the first place.  So, let's see what's really going on.

While in setup mode, the camera broadcasts a wifi hotspot called `ZMD_SAP`.  It assigns itself `192.168.10.1` and runs a DHCP server handing out addresses in the `192.168.10.2-100` range.  Connecting a machine to the network and scanning the host gives the following:

```
rcw@antec:~$ nmap -A -T4 192.168.10.1

Starting Nmap 7.40 ( https://nmap.org ) at 2017-02-14 18:04 PST
Nmap scan report for 192.168.10.1
Host is up (0.026s latency).
Not shown: 996 closed ports
PORT     STATE SERVICE   VERSION
4444/tcp open  krb524?
8000/tcp open  http-alt?
8086/tcp open  http      BusyBox httpd 1.13
|_http-title: User login authentication
8087/tcp open  http      BusyBox httpd 1.13
|_http-title: User login authentication
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 172.82 seconds
rcw@antec:~$ 
```
