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

// ------------------------------------------------------------------------
// Init Buffers.
// ------------------------------------------------------------------------

d = Dictionary.new;
(
	d.add(\i -> PathName("/Users/mac/Desktop/bufbas/").entries.collect({
		arg pt;
		Buffer.read(s, pt.fullPath); //get samples assigned to d[\i].
		Buffer.numChannels
	   });
	);
)

// ------------------------------------------------------------------------
//Create Buffers.
// ------------------------------------------------------------------------

(
	SynthDef.new(\bufplay,{
		arg buf = 0, rate = 1, amp = 1, out = 0;
		var sig;
		sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf)*rate, doneAction: 2);
		sig = sig * amp;
		Out.ar(~fxSendBus,sig);
	}).add
)

~b01 = Buffer.read(s, "/Users/mac/Desktop/bufbas/LinnKick01.aif");
~b01.numChannels; //check MONO or STEREO;
~b01.query; //check info;


Synth.new(\bufplay, [\buf, d[\i]]); //quickly check signal.


// ------------------------------------------------------------------------
//Create Synth.
// ------------------------------------------------------------------------

(
	SynthDef.new(\mysynth,{
		arg out, count, freq = 40, release;
		var sig, sum, temp, env;
		sum = 0;
		env = EnvGen.kr(
			Env.perc(0.01,release,1,-2),
			doneAction: 2
			);
		5.do{
			temp = SinOsc.ar(
				freq * Rand(1,1.02),
				{Rand(0.0,1.0)}!2,
				{Rand(0.05,0.25)}!2
			);
			sum = sum + temp;
		};
		sum = sum * 0.25 * env;
		Out.ar( ~fxSendBus,sum);
	}).add
);

// ------------------------------------------------------------------------
// Create fx section
// ------------------------------------------------------------------------

(
	SynthDef(\distFiltDelay, {|out = 0, in, amp = 0.25, wet = 1.5, tempo = 0.25, cutoff = 1000, leftDelay = 2, rightDelay = 4|
			var inSig = In.ar(in, 2);
			tempo = tempo * [leftDelay, rightDelay] / 2;
			inSig = inSig + (HPF.ar(DelayN.ar(inSig, tempo, tempo), cutoff) * wet);
			inSig = inSig + (GVerb.ar(inSig, 30, 6) * 0.1);
			Out.ar(out, inSig * amp);
		}).add;
) //distFiltDelay by Schemawound.


x = Synth.new(\distFiltDelay, [\in, ~fxSendBus]);
~fxSendBus = Bus.audio(s, 1);
~fxSendBus.index;

// ------------------------------------------------------------------------
// Create Pdef.
// ------------------------------------------------------------------------

(
Pdef(
	\bufplayer,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([0.25, 0.5, 0.5, 0.5, 0.125, 0.25, 0.125, 1.0], inf),
		\buf, Pseq(d[\i], inf)
	)).stop// evals AFTER! Pdef NOT Pbind, otherwise .stop will not works!!
)

(
Pdef(
	\instru1, //define Pdef.
	Pbind(
		\instrument, \mysynth,
		\dur, Pwhite(0.5, 1.5, inf), //Pwhite random value between 0.0 ~ 1.0
		\harmonic, Pexprand(1.01,[3.3,2.01,1.01].choose, inf),
		\midinote, Prand([20,40,50,64,53], inf), // \midinote is available only if arg "freq" is defined. see more: Pbind in help file
		\release, Prand([10,20,15]/2, inf) //
	)).stop;
) //Pdef can be re-evaluated without duplication UGens.

// ------------------------------------------------------------------------
// NOTE:
// - cannot evals 2 defined Pdef simultaneously (figuer it out later then).
