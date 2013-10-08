# What is this?

Exobrain is a collection of agents which collect, classify, and act
upon data. They share a common bus for communication. Examples of
things that exobrain can currently do:

* Give you XP in HabitRPG when you update your beeminder goals
* Let others add items to your RememberTheMilk TODO lists via twitter
* Update beeminder by checking your inbox sizes using IMAP
* Reward you for responding to email

While the core of exobrain is currently written in Perl, the shared
message bus (0MQ) and packet format (JSON) are designed to make it
easy to connect components from other languages.

# How easy is this to use?

Not going to lie, it's pretty rough at the moment, as it's essentially
@pjf's personal-use software. Patches, or even a definitive list of
bugs and issues related to installation and use are very welcome.

# Installation

    apt-get install libzmq-dev expat-dev libnet-ssleay-perl \
        libnet-libidn-perl  libcrypt-ssleay-perl ubic

    dzil listdeps | cpanm

As of writing this document, RTMAgent has a failing test case because
of a changed network configuration. Force install it with:

    cpanm -f WebService::RTMAgent

Set up ubic (if you haven't already done so):

    ubic-admin setup

Install exobrain:

    dzil install

Copy the `exobrain` file into your ubic services:

    cp `which exobrain` ~/ubic/service

Now write a config file. It's `~/.rtbmrc` for historical reasons. This will
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

You can now start your exobrain. Start with the core:

    ubic start exobrain.core

To get some data flowing through your exobrain, you can try starting
the end-points:

    ubic start exobrain.source
    ubic start exobrain.sink

And to get intelligence, you can bring on-line the classifers:

    ubic start exobrain.classify

Of course, you can get *EVERYTHING* online in one go with just:

    ubic start exobrain

You probably won't use all the components, though, so it's recommended
that you only configure and switch on the ones you need.

# LICENSE

Same as Perl 5 itself.
