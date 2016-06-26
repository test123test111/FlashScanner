if(!_global.com)
{
   _global.com=new Object();
}
if(!_global.com.jeroenwijering)
{
   _global.com.jeroenwijering=new Object();
}
if(!_global.com.jeroenwijering.players)
{
   _global.com.jeroenwijering.players=new Object();
}
if(!_global.com.jeroenwijering.players.PlayerController)
{
   register1=function(cfg, fed)
   {
      super(cfg,fed);
      this.playerSO=SharedObject.getLocal("com.jeroenwijering.players","/");
   };
   com.jeroenwijering.players.PlayerController=function(cfg, fed)
   {
      super(cfg,fed);
      this.playerSO=SharedObject.getLocal("com.jeroenwijering.players","/");
   };
   com.jeroenwijering.players.PlayerController extends com.jeroenwijering.players.AbstractController
   register2=register1.prototype;
   register2.startMCV=function(mar)
   {
      if(!(mar==undefined))
      {
            this.registeredModels=mar;
      }
      this.itemsPlayed=0;
      if(this.config.shuffle=="true")
      {
            this.randomizer=new com.jeroenwijering.utils.Randomizer(this.feeder.feed);
            this.currentItem=this.randomizer.pick();
      }
      else
      {
            this.currentItem=0;
      }
      this.sendChange("item",this.currentItem);
      if(this.config.autostart=="muted")
      {
            this.sendChange("volume",0);
      }
      else
      {
            this.sendChange("volume",this.config.volume.valueOf());
      }
      if(this.config.usecaptions=="false")
      {
            this.config.clip.captions._visible=false;
            this.config.clip.controlbar.cc.icn._alpha=40;
      }
      if(this.config.useaudio=="false")
      {
            this.config.clip.audio.setStop();
            this.config.clip.controlbar.au.icn._alpha=40;
      }
      if(this.config.autostart=="false")
      {
            this.sendChange("pause",this.feeder.feed[this.currentItem].start);
            this.isPlaying=false;
      }
      else
      {
            this.sendChange("start",this.feeder.feed[this.currentItem].start);
            this.isPlaying=true;
      }
   };
   register2.setPlaypause=function()
   {
      if(this.isPlaying==true)
      {
            this.isPlaying=false;
            this.sendChange("pause");
      }
      else
      {
            this.isPlaying=true;
            this.sendChange("start");
      }
   };
   register2.setPrev=function()
   {
      if(this.currentItem==0)
      {
            this.setPlayitem(this.feeder.feed.length-1);
      }
      else
      {
            this.setPlayitem(this.currentItem-1);
      }
   };
   register2.setNext=function()
   {
      if(this.currentItem==this.feeder.feed.length-1)
      {
            this.setPlayitem(0);
      }
      else
      {
            this.setPlayitem(this.currentItem+1);
      }
   };
   register2.setStop=function()
   {
      this.sendChange("pause",0);
      this.sendChange("stop");
      this.sendChange("item",this.currentItem);
      this.isPlaying=false;
   };
   register2.setScrub=function(prm)
   {
      if(this.isPlaying==true)
      {
            this.sendChange("start",prm);
      }
      else
      {
            this.sendChange("pause",prm);
      }
   };
   register2.setPlayitem=function(itm)
   {
      if(!(itm==this.currentItem))
      {
            !(itm>this.feeder.feed.length-1)?null:this.feeder.feed.length-1;
            if(!(this.feeder.feed[this.currentItem].file==this.feeder.feed[itm].file))
            {
               this.sendChange("stop");
            }
            this.currentItem=itm;
            this.sendChange("item",itm);
      }
      this.sendChange("start",this.feeder.feed[itm].start);
      this.currentURL=this.feeder.feed[itm].file;
      this.isPlaying=true;
   };
   register2.setGetlink=function(idx)
   {
      if(this.feeder.feed[idx].link==undefined)
      {
            this.setPlaypause();
      }
      else
      {
            getUrl(this.feeder.feed[idx].link,this.config.linktarget);
      }
   };
   register2.setComplete=function()
   {
      this.itemsPlayed=this.itemsPlayed+1;
      if(this.feeder.feed[this.currentItem].type=="rtmp"||!(this.config.streamscript==undefined))
      {
            this.sendChange("stop");
      }
      if(this.config.repeat=="false"||this.config.repeat=="list"&&!(this.itemsPlayed<this.feeder.feed.length))
      {
            this.sendChange("pause",0);
            this.isPlaying=false;
            this.itemsPlayed=0;
      }
      else
      {
            register2=undefined;
            if(this.config.shuffle=="true")
            {
               register2=this.randomizer.pick();
            }
            else
            {
               if(this.currentItem==this.feeder.feed.length-1)
               {
                  register2=0;
               }
               else
               {
                  register2=this.currentItem+1;
               }
            }
            this.setPlayitem(register2);
      }
   };
   register2.setFullscreen=function()
   {
      if(Stage.displayState=="normal"&&this.config.usefullscreen=="true")
      {
            Stage.displayState="fullScreen";
      }
      else
      {
            if(Stage.displayState=="fullScreen"&&this.config.usefullscreen=="true")
            {
               Stage.displayState="normal";
            }
            else
            {
               if(!(this.config.fsbuttonlink==undefined))
               {
                  this.sendChange("stop");
                  getUrl(this.config.fsbuttonlink,this.config.linktarget);
               }
            }
      }
   };
   register2.setCaptions=function()
   {
      if(this.config.usecaptions=="true")
      {
            this.config.usecaptions="false";
            this.config.clip.captions._visible=false;
            this.config.clip.controlbar.cc.icn._alpha=40;
      }
      else
      {
            this.config.usecaptions="true";
            this.config.clip.captions._visible=true;
            this.config.clip.controlbar.cc.icn._alpha=100;
      }
      this.playerSO.data.usecaptions=this.config.usecaptions;
      this.playerSO.flush();
   };
   register2.setAudio=function()
   {
      if(this.config.useaudio=="true")
      {
            this.config.useaudio="false";
            this.config.clip.audio.setStop();
            this.config.clip.controlbar.au.icn._alpha=40;
      }
      else
      {
            this.config.useaudio="true";
            this.config.clip.audio.setStart();
            this.config.clip.controlbar.au.icn._alpha=100;
      }
      this.playerSO.data.useaudio=this.config.useaudio;
      this.playerSO.flush();
   };
   register2.setVolume=function(prm)
   {
      if(prm<0)
      {
            prm=0;
      }
      else
      {
            if(prm>100)
            {
               prm=100;
            }
      }
      if(prm==0)
      {
            if(this.muted==true)
            {
               this.muted=false;
               this.sendChange("volume",this.config.volume);
            }
            else
            {
               this.muted=true;
               this.sendChange("volume",0);
            }
      }
      else
      {
            this.sendChange("volume",prm);
            this.config.volume=prm;
            this.playerSO.data.volume=this.config.volume;
            this.playerSO.flush();
            this.muted=false;
      }
   };
}
