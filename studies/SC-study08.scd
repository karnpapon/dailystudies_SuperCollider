// from Eli Fieldsteel's lecture week 3


s.meter
s.plotTree

//________________________________
//_______| define Synth |_______//
//________________________________

(
SynthDef.new(\pureTone,{
	arg freq=50, amp, out=0, sig, gate=1;
	var env=1;
	env = EnvGen.kr(Env.adsr,gate, doneAction: 2);
	sig = SinOsc.ar(freq,0);
	sig = sig * env * 0.05;
	Out.ar(out,(sig)!2);
}).add;
)


(
SynthDef.new(\mySynth,{
	arg freq=50, amp=0.25, out=0, sig=0, gate=1, temp,saw=2;
	var env=1;
	env = EnvGen.kr(Env.adsr,gate, doneAction: 2);
	temp = SinOsc.ar(freq,0)*LFSaw.kr(saw,0);
	sig = sig + temp;
	sig = sig * env * amp;
	Out.ar(out,(sig)!2);
}).add;
)

x = Synth(\mySynth,[\freq, 56.midicps]);
x.set(\freq, 56.midicps*(rrand(0.9,1.01)));
x.set(\amp, 0.5);
x.set(\saw, rrand(1,12))

Env.adsr(0.1,0.25,0.125,0.25,0.25,-3).plot


//________________________________
//_______| iterations |_______//
//________________________________

(
e = {rrand(50,80)}!8; //define 8 iterations
~synth = e.collect{ //"collect" modified "e", while "do" isn't.
	arg noteNumber; //any name can be defined as arg since it always return item and index respectively.
	Synth(\pureTone,[\freq, noteNumber.midicps]); //8 note play simultaneously.
}
)

~synth[0].set(\gate, 0) //individual synthdef can be accessed through Array.

( //using do loop to iterate through every ~synth's Array, and then set gate to 0 to stop them.
~synth.do({
	arg i; //again, it can be any name.
	i.set(\gate ,0)
});
)


// impliment with Routine
// to gradually take out ~synth one by one every 1 sec.
(
Routine.new({
	 ~synth.do({
		arg i;
		i.set(\gate ,0);
		wait(1);
	});
}).play
)



