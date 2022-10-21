/-  *app-store-action, *app-store-data
/+  default-agent, dbug, app-store
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      =cur-info
      =cur-data
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this      .
    default   ~(. (default-agent this %|) bowl)
++  on-init
  ^-  (quip card _this)
  =.  state  [%0 ['' '' ''] [[~ ~ ~] ~ ~]]
  `this
::
::  how to make it so that it reverts to the previous state before changes?
::  if it fails the test of %- ^cur-data.
::  apply analogously to  dev-server.
++  on-save   
  ?>  =((^cur-data cur-data.state) cur-data.state)
  !>(state)
++  on-load   
  |=  old=vase
  ^-  (quip card _this)
  =/  state-0  !<(state-0 old)
  ?>  =((^cur-data cur-data.state-0) cur-data.state-0)
  `this(state state-0)
::  
::  on-poke is for subscribing to Developers AND OTHER STUFF
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?>  ?=(%app-store-cur-action mark)
  =/  act  !<(cur-action vase)  
  ?-    -.act
      %sub    
    =/  dev-name-wire  /(scot %p +.act)
    ~&  "%cur-server: subscribing to {(scow %p +.act)}"
    :_  this
    [%pass dev-name-wire %agent [+.act %dev-server] %watch /dev-update]~
  ::  
      %unsub
    =/  dev-name-wire  /(scot %p +.act)
    ~&  "%cur-server: unsubscribing from {(scow %p +.act)}" 
    =/  new-cur-data  (unsub:cur:app-store [cur-data.state dev-name.act])
    =/  new-cur-page  
      ^-  cur-page  %-  some
      :+  our.bowl  
      `^cur-info`cur-info.state 
      `^cur-data`new-cur-data
    :_  this(cur-data.state new-cur-data)
    :~  
      [%pass dev-name-wire %agent [+.act %dev-server] %leave ~]
      [%give %fact [/cur-page]~ %app-store-cur-page !>(`cur-page`new-cur-page)]
    ==
  ::
      %cur-info
    ~&  "%cur-server: adding title to curator page"
    =/  new-cur-page  
      ^-  cur-page  %-  some
      :+  our.bowl  
      `^cur-info`+.act  
      `^cur-data`cur-data.state
    :_  this(cur-info.state +.act)
    [%give %fact [/cur-page]~ %app-store-cur-page !>(`cur-page`new-cur-page)]~
  ::
    ::  when receiveing a poke for entering cur-choice, 
    ::  should it be asserted that curchoice be subset of cur-data
    ::  or not if thats already defined in sur file
  ::
      %select  
    ~&  "%cur-server: adding cur-choice to curator page"
    =/  new-cur-data  (select:cur:app-store [cur-data.state act])
    =/  new-cur-page  
      ^-  cur-page  %-  some
      :+  our.bowl  
      `^cur-info`cur-info.state  
      `^cur-data`new-cur-data
    :_  this(cur-data.state new-cur-data)
    [%give %fact [/cur-page]~ %app-store-cur-page !>(`cur-page`new-cur-page)]~
  ::
      %cats
    ~&  "%cur-server: changing categories"
    =/  new-cur-data  (^cur-data cur-data.state(cat-set.cur-choice cat-set.act))
    `this(cur-data new-cur-data)
    ::  cur-choice should also be sent to subscribers after %choose
  == 
::  
++  on-arvo   on-arvo:default
::
::  on-watch is for receiving Users' subscription requests
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =([%cur-page ~] path)
  ~&  "%cur-server: received subscription request"
  =/  cur-page  ^-  cur-page  %-  some
  :+  our.bowl  
    `^cur-info`cur-info.state
    `^cur-data`cur-data.state
  :_  this
  [%give %fact ~ %app-store-cur-page !>(`^cur-page`cur-page)]~
::  
++  on-leave  on-leave:default
++  on-peek   on-peek:default
::
::  changes, and deletes of app pages should be forwarded to changes of cur-choice
::  adding app pages should not be forwarded to changes of cur-choice
::  on-agent is for receiving subscriptions updates from Developers AND OTHER STUFF(?)
++  on-agent  
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  =/  dev-name-tape  (trip `@t`-.wire)
  ?+    -.sign  (on-agent:default wire sign)
      %watch-ack
    ?~  p.sign
      ~&  "%cur-server: subscribe to {dev-name-tape} succeeded"
      `this
    ~&  "%cur-server: subscribe to {dev-name-tape} failed"
    `this
  ::
      %kick
    ~&  "%cur-server: got kick from {dev-name-tape}, resubscribing..."
    =/  dev-name  `@p`(slav %p -.wire)
    :_  this
    [%pass wire %agent [dev-name %dev-server] %watch /dev-update]~
  ::
      %fact
    =/  dev-update  !<(dev-update q.cage.sign)
    ~&  "%cur-server: received dev update from {dev-name-tape}"
    =/  dev-name  `@p`(slav %p -.wire)
    ?~  dev-update  `this  ::dev-server currently never sends dev-update
    ?>  (check-dev-data:cur:app-store [dev-name dev-data.u.dev-update])  
    ?-    -.change.u.dev-update
        %init
      =/  new-cur-data  (init:cur:app-store [cur-data.state dev-name dev-update])
      `this(cur-data.state new-cur-data)
    ::  
        %add
      =/  new-cur-data  (add:cur:app-store [cur-data.state dev-name dev-update])
      `this(cur-data.state new-cur-data)
    ::  
        %edit  :: IF IS VS IS NOT IN CUR CHOICE SHOULD I SEND TO USR
      =/  new-cur-data  (edit:cur:app-store [cur-data.state dev-name dev-update])
      =/  new-cur-page  
        ^-  cur-page  %-  some
        :+  our.bowl  
        `^cur-info`cur-info.state
        `^cur-data`new-cur-data  
      :_  this(cur-data.state new-cur-data)
      [%give %fact [/cur-page]~ %app-store-cur-page !>(`^cur-page`new-cur-page)]~
    ::  
        %del
      =/  new-cur-data  (del:cur:app-store [cur-data.state dev-name dev-update])
      =/  new-cur-page  
        ^-  cur-page  %-  some
        :+  our.bowl  
        `^cur-info`cur-info.state  
        `^cur-data`new-cur-data  
      :_  this(cur-data.state new-cur-data)
      [%give %fact [/cur-page]~ %app-store-cur-page !>(`^cur-page`new-cur-page)]~
    ::  
        %usr-visit
      =/  new-cur-data  (usr-visit:cur:app-store [cur-data.state dev-name dev-update])
      =/  new-cur-page  
        ^-  cur-page  %-  some
        :+  our.bowl  
        `^cur-info`cur-info.state 
        `^cur-data`new-cur-data  
      :_  this(cur-data.state new-cur-data)
      [%give %fact [/cur-page]~ %app-store-cur-page !>(`^cur-page`new-cur-page)]~
    ::
        %wipe  `this
    ==
  ==
::
++  on-fail   on-fail:default
--

