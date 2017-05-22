<p align="center">
  <img width=100 height=100 src="https://github.com/128keaton/Heat/blob/master/app/assets/images/logo-alt.png">
</p>

<h1 align="center">Heat</h1>
<h2 align="center"> A mobile-first, multi-staged product management system</h2>

[![Build Status](https://travis-ci.org/128keaton/Heat.svg?branch=master)](https://travis-ci.org/128keaton/Heat)
[![codebeat badge](https://codebeat.co/badges/4a1d1bfb-62b3-4481-a853-843b71e2cc8b)](https://codebeat.co/projects/github-com-128keaton-heat-master)

### Getting Started:

#### Prerequisites:

* Ruby

* Rails 

#### Basic Setup:

1. Download (or clone) the repository: `git clone https://github.com/128keaton/Heat/`

2. Run the appropriate Rails commands: `bundle install && rake db:migrate`

3. Setup [Devise](https://github.com/plataformatec/devise) appropriately: `mv config/initializers/devise.example.rb config/initializers/devise.rb`

4. Go: `rails s`

#### Docker Compose:

(for Ubuntu 14.04+)

1. Download Docker:

  ```
   $ sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
   $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   $ sudo apt-get update && sudo apt-get install docker-ce
  ```

2. Download Docker Compose: 
```
curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

3. Clone this repository somewhere safe: `cd ~/Documents/ && git clone https://github.com/128keaton/Heat/`

4. Go: `docker-compose up --build`
   

### Known Issues:
* Using Google OAuth, sometimes you have to login *twice*.


### Screenshots:
#### Clean
<p align="center">
  <img src="https://github.com/128keaton/Heat/blob/master/app/assets/screenshots/1.png">
</p>

#### Interactive
<p align="center">
  <img src="https://github.com/128keaton/Heat/blob/master/app/assets/screenshots/notification.gif">
</p>
