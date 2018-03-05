// STUDY01
// ------------------------------------------------

(
	SynthDef(\instrument1,{ arg envStart = 0;
		var sineout, sineout2, amp, sig, sig1, sig2, env;
		env = EnvGen.kr(
			Env.new([envStart,1,0],[3,3],'lin'), //drawing envelope (level,time,curve).
			doneAction:2 //remove ended instrument from stacklists(use plotTree to see the lists).
		);
		amp = SinOsc.kr({ExpRand(0.25,12)}!8).range(0.1); // exclaimation mark = "dup()", use after curly brackets to effect scoped function.
		sineout = SinOsc.ar([440,450,540,345]); //created 4 outputs (depends on freqnumber's array) at the background.
		sineout2 = SinOsc.ar({ExpRand(500,1200)}!8); //for complex sinewave.
		sig = sineout * amp * env;
		sig1 = Mix.new(sig)*0.25;  //Mix will boils down multi-outputs to single channel.
		sig2 = Splay.ar(sig)*0.25; //Splay spread arbitrary array across stereo field.
		Out.ar(0,sig1); // if first arg = array, overlapped output will be occured(BETTER NOT USE arrays in Out UGen with Mix,it's OKAY outside SynthDef because SynthDef requires Out.ar to send output).
	}).add;
)
// ExpRand, choose when "Synth" was created, this means we can get random val every evaluation.
// exprand, pick a value when "SynthDef" is compiled, this means we get identical (random)number every evaluation.

s.plotTree //show stacklists.
s.meter

x = Synth(\instrument1, [envStart: 0]);
x.set(\envStart, 1); //not working, have no idea why...

x.free;
s.freeAll;

s.stop


// ------------------------------------------------
// NOTE:
// -
