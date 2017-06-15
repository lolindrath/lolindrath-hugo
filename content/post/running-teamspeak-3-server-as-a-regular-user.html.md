---
title: Running Teamspeak 3 Server As a Regular User
date: 2014-05-28T09:59:00Z
tags:
comments: true
published: true
tags:
  - linux
---

In my previous article on [How to run Teamspeak3 on](http://lolindrath.com/2013/07/03/running-a-teamspeak-3-server-on-digital-ocean/) [Digital Ocean](https://www.digitalocean.com/?refcode=d7c77f58d8de) the instructions have you create a teamspeak3 user and change ownership of the files. I noticed in some of the comments over there that people noticed it was running as root, not the greatest thing for security.

I noticed my server was also running as root, here's how to fix it if you used my instructions:

Shut down Teamspeak:

```bash
sudo service teamspeak3 stop
```

Remove the `/etc/init.d/teamspeak3` soft link:

```bash
sudo rm /etc/init.d/teamspeak3
```

Now edit `/etc/init.d/teamspeak3` and set the contents to this:

```bash
#!/bin/sh

su -c "/usr/local/teamspeak3/ts3server_startscript.sh $@" teamspeak3
```

Set the file to be executable:

```bash
sudo chmod u+x /etc/init.d/teamspeak3
```

Fix permissions, many of the Teamspeak files are probably owned by root now which would prevent the server from starting:

```bash
sudo chown -R teamspeak3:teamspeak3 /usr/local/teamspeak3
```

Start the server back up:

```bash
sudo service teamspeak3 start
```

Use your client software to connect and make sure everything is operating properly and you're done.

