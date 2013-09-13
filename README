Installing:

    apt-get install libzmq-dev expat-dev libnet-ssleay-perl libnet-libidn-perl

    dzil listdeps | cpanm

As of writing this document, RTMAgent has a failing test case because
of a changed network configuration. Force install it with:

    cpanm -f WebService::RTMAgent

Install:

    dzil install

The config file is in `~/.rtbmrc` for historical reasons. This will
change in the future:

    [RTBM]
    ; Used by rtm-adder. Historical naming, will be placed
    ; into a generalised RTM section soon.
    api_key = 
    api_secret = 

    [Twitter]
    ; Used by twitter / main account (reading)
    consumer_key        = 
    consumer_secret     = 
    access_token        = 
    access_token_secret = 

    [TwitterSend]
    ; Used by twitter-send / @pjf_exobrain (writing)
    consumer_key        = 
    consumer_secret     = 
    access_token        =
    access_token_secret =

    [FourSquare]
    auth_token =

    [Beeminder]
    auth_token =

    [RTM-ADDER]
    ; Used by rtm-adder. Which 
    list = 

You need to also have a valid ~/.rtmagent file for RTM integration. I need to
write something which sets this up for you.

Command names may change.  But start with starting the routing
infrastructure:

    route.pl        # Start routing infrastructure

Start twitter TODO routing infrastructure:

    twitter         # Watches twitter
    twitter-send    # Allows sending messages to twitter
    rtm-adder       # Allows adding to RememberTheMilk
