// STUDY03
// ------------------------------------------------------------------------


// ------------------------------------------------------------------------
//init server
// ------------------------------------------------------------------------

s.boot;
s.reboot
s.plotTree;
s.free
s.scope;
s.meter;
s.meter.view.alwaysOnTop = true;
s.scope.view.alwaysOnTop = true;



(
SynthDef.new(\simplesin,{
	arg freq=440, amp=0.3, dur=8;
	var oscFreq = freq + SinOsc.kr(Rand(0.01,0.3),0,Rand(0,0));
	var env = EnvGen.kr(Env([0,1,0],[dur/2,dur/2],[3,-3]),doneAction:2);
	var out = HPF.ar(LPF.ar(Pulse.ar(oscFreq,env)*amp*env,freq),freq);
	Out.ar(0,out!2);
}).add;
)

Synth.new(\simplesin);

//see env.
{EnvGen.kr(Env([0,1,0],[8/2,8/2],[3,-3]),doneAction:2)}.plot(8);

s.freeAll



// ------------------------------------------------------------------------
// NOTE:
// - Coded by Eric Fairbanks.
// - cannot get plotTree's window alwaysOnTop = true, have no idea why (also scope).
