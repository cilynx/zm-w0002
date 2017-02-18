# zm-w0002

The zm-w0002 is a super-cheap outdoor security camera that you can [pick up on Amazon](http://amzn.to/2kwasCJ) in a 4-pack for $99.99.

![camera picture](https://images-na.ssl-images-amazon.com/images/I/71ecZB-nobL._SL300_.jpg)

I know what you're thinking... *Dude, you can't shake a stick at 4 weatherproof wifi cameras delivered to my door for $100.*  Unfortunately, you can.  These cameras are so cheap because Zmodo has removed every feature you might want to setup a *secure* locale *security* system and instead ships all of your data to their cloud service for later viewing on their proprietary mobile app.  Out of the box, these cameras will not work with *anything* other than the proprietary kitsch they're bundled with.

Luckily, it's powered by the popular and well documented HiSilicon Hi3518 SoC ([Datasheet](https://github.com/cilynx/zm-w0002/files/782566/Hi3518-Datasheet.pdf), [User Guide](https://github.com/cilynx/zm-w0002/files/782568/Hi3518-UserGuide.pdf)).

# Setup Services

According to the [Quick Start Guide](http://support.zmodo.com/assets/media/quick_user_guide_en/ZM-W0002-4_quick_guide.pdf), you're supposed to power up your cameras, then download the [MeShare App](http://surveillance.zmodo.com/meshare-app) ([iPhone](https://itunes.apple.com/us/app/meshare/id977910819?mt=8), [Android](https://play.google.com/store/apps/details?id=com.meshare&hl=en)) which will walk you through creating a [MeShare Account](https://user.meshare.com/user/login), transferring you network creds to your camera(s), and viewing your live streams on your phone.  There's no way I'm installing an app on my phone to access a "free" amorphous cloud service, nor am I sending my network creds or survalence data to said amorphous cloud service in the first place.  So, let's see what's really going on.

While in setup mode, the camera broadcasts a wifi hotspot called `ZMD_SAP`.  It assigns itself `192.168.10.1` and runs a DHCP server handing out addresses in the `192.168.10.2-100` range.  Connecting a machine to the network and scanning the camera gives the following:

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

I haven't figured out what's going on with `4444` yet and we'll talk about `8000` later.  For now, let's focus on the two httpd servers running on `8086` and `8087`.

## 8086

Pulling up `192.168.10.1:8086` in a browser gives us a tidy little web form, with the requisite spelling error on the `Concle` button. 

![8086-form](https://cloud.githubusercontent.com/assets/6083980/23090803/8b6df1c2-f55b-11e6-867a-9fa671c7daf8.png)

It looks like it's asking for numerical input, so I figured I'd feed it some non-numeric strings and see what happens.

![8086-success](https://cloud.githubusercontent.com/assets/6083980/23090804/8b6f1994-f55b-11e6-90cd-22f03a431325.png)

Success!  We'll see later that this form updates a conf file on the filesystem with what appears to be no validation whatsoever.  I need to do a little exploring here to see if I can exploit this form to start `telnetd` (which is available on the system, just not running by default) and avoid tearing the rest of my cameras apart to access their serial consoles.

## 8087

Pulling `192.168.10.1:8087` in a brower gives us another tidy little web form, once again with the `Concle` button.

![8087-form](https://cloud.githubusercontent.com/assets/6083980/23090806/8b70befc-f55b-11e6-8df5-25a59d7ee49a.png)

Now this looks more interesting.  I setup a little lab network without any uplink and attempted to connect.  I'm not sure what `USERID` or `CLIENT_COUNT` are about, but I figured the lack of input validation wouldn't care if I left them blank.

![8087-failure](https://cloud.githubusercontent.com/assets/6083980/23090807/8b72ad66-f55b-11e6-92b9-8290448dc9fc.png)

Surprise! It failed.  Sad.  I guess we need some values after all.  Let's try `foo` and `bar` as before.

![8087-success](https://cloud.githubusercontent.com/assets/6083980/23090805/8b70292e-f55b-11e6-939d-ad292d2a04dd.png)

Success!  I haven't yet found which files this updates, but at this point, the camera will stop broadcasting `ZMD_SAP` and will join your provided network, asking for an address over DHCP.  Keep in mind that these cameras only have 2.4GHz radios ([RTL8188EUS](http://www.realtek.com/search/default.aspx?keyword=rtl8188) to be exact), so they will not see your 5GHz networks.  If all went well and it successfully joined your network, the camera will now switch from setup mode to production mode.

# Production Services
