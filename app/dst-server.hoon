/-  *app-store-action, *app-store-data, spider
/+  default-agent, dbug, app-store, sig
=,  clay
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  ~
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
  =.  state  ~
  `this
::  
++  on-save  !>(state)
++  on-load   
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
::  
::  on-poke is for receiving pokes from
++  on-poke 
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark   (on-poke:default mark vase)    
      %app-store-dst-action
    =/  act  !<(dst-action vase)
    ?+    -.act    (on-poke:default mark vase)
        ::  sending a signature from distributor ship to dev-server
        %sign  
      ?>  =(src.bowl our.bowl)
      ~&  "%dst-server: sending signature to %dev-server"
      =/  signature  (sign:sig [our.bowl now.bowl key.act])
      :_  this
      [%pass /sent-sig %agent [dev-name.key.act %dev-server] %poke %app-store-dst-action !>([%sent-sig key.act signature])]~
  ::
        %send-data
      ?>  =(src.bowl our.bowl)
      ~&  "%dst-server: getting docket data"
      =/  app-name  `@t`app-name.key.act
      =/  hash  .^(@uvI %cz /(scot %p our.bowl)/(scot %tas app-name)/(scot %da now.bowl))
      =/  docket  .^(docket %cx /(scot %p our.bowl)/(scot %tas app-name)/(scot %da now.bowl)/desk/docket-0)
      :_  this
      [%pass /send-sig %agent [dev-name.key.act %dev-server] %poke %app-store-dst-action !>([%sent-data key.act docket hash])]~
    ==
  ==
::
++  on-arvo   on-arvo:default
++  on-watch  on-watch:default  
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--

