# Vprofile Local setup

## Stack of Nginx, Tomcat, RabbitMQ, Memcache and MySQL services

VM setup order:&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp; ||
&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;||&nbspnbspnbspnbsp; User(s)-----> <Nginx.web01> <-------> <Tomcat.app01> 
1. db01: Database server                ||&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;&nbspnbspnbspnbsp;                                                    |
   - MySQL server (mariaDB SRV)         ||                                                  |
                                        ||                                                  |
2. mc01: Database Cache Memory          ||                               .------------------:
   - Memcache                           ||                               |
                                        ||                               |
3. rmq01: Message Broker                ||                               |
   - RabbitMq                           ||     <Memcache.mc01> <---------:---------> <RabbitMQ.rmq01>
                                        ||            |
4. app01: Application server            ||            |
   - Tomcat (only java)                 ||            |
                                        ||            :----------> <MySQL.db01>
5. web01: Web server                    ||
   - Nginx                              ||
