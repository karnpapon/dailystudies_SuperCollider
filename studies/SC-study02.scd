// STUDY02
// ------------------------------------------------------------------------


// ------------------------------------------------------------------------
//init server
// ------------------------------------------------------------------------

s.reboot
s.plotTree;
s.free
s.scope;
s.meter;

// ------------------------------------------------------------------------
//Create Synth.
// ------------------------------------------------------------------------
(
	SynthDef.new(\itersynth,{
		arg out, count, freq = 40;
		var sig, sum, temp, env;
		sum = 0;
		env = EnvGen.kr(
			Env.perc(0.01,1.75,1,-2), // start,release,level,curve.
			doneAction: 2
			);
		10.do{ //iter 10 times (".do" better not to replace 10 with any arg because 10 is "Collect" type, not Int).
			temp = VarSaw.ar(
				freq * Rand(1,1.02), //narrowed random lenght (between 1 ~ 1.02) to keep note accurate.
				{Rand(0.0,1.0)}!2,  //random phase to avoid "hard-pop" sound(cause it's 10 wave play simultaneously).
				{Rand(0.005,0.05)}!2 // random its "Brightness(Width)" and "!2" to make it stereo.
			);
			sum = sum + temp; // summed up varied 10 waves.
		};
		sum = sum * 0.025 * env; // mul 0.1 to prevent clipping.
		Out.ar( ~fxSendBus,sum);
	}).add
);

//test Synth.
Synth.new(\itersynth, [\freq,50.midicps]); // D
Synth.new(\itersynth, [\freq,54.midicps]); // F#
Synth.new(\itersynth, [\freq,61.midicps]); // C#
Synth.new(\itersynth, [\freq,49.midicps]); // C#
Synth.new(\itersynth, [\freq,52.midicps]); // E
Synth.new(\itersynth, [\freq,59.midicps]); // B


//define server Bus in-out.
s.options.numAudioBusChannels; //show Bus Channels;
s.options.numOutputBusChannels = 4; //assign Output Bus = 4
s.options.numInputBusChannels = 4; //assign Input Bus = 4
//so private automatically assigned to channel is 6,
// since [0,1,2,3] assigned to Output, and [4,5] to Input.


// ------------------------------------------------------------------------
//create fx section
// ------------------------------------------------------------------------
(
	SynthDef.new(\filter, {
		arg in, out = 0;
		var sig;
		sig = In.ar(in, 2);
		sig = DFM1.ar(sig, 1000, 0.2, 1,0, 0.0005);
		Out.ar(out, sig);
		}).add;
)

(
	SynthDef(\distFiltDelay, {|out = 0, in, amp = 0.25, wet = 2, tempo = 0.25, cutoff = 500, leftDelay = 2, rightDelay = 4|
			var inSig = In.ar(in, 2);
			tempo = tempo * [leftDelay, rightDelay] / 2;
			inSig = inSig + (HPF.ar(DelayN.ar(inSig, tempo, tempo), cutoff) * wet);
			inSig = inSig + (GVerb.ar(inSig, 30, 6) * 0.1);
			Out.ar(out, inSig * amp);
		}).add;
) //distFiltDelay by Schemawound.


x = Synth.new(\distFiltDelay, [\in, ~fxSendBus]); //recieve input in Bus channel 6.
y = Synth.new(\itersynth, [\out, ~fxSendBus]); //send output to Bus channel 6.
// "Action in order" is matter

s.freeAll;

// ------------------------------------------------------------------------
// Bus config section.
// ------------------------------------------------------------------------

~fxSendBus = Bus.audio(s, 1); //make global bus variable;
~insBus = Bus.audio(s, 1); //make instrument bus variable;
~fxSendBus.index; //show Bus index num.


// ------------------------------------------------------------------------
// Test Pattern Section.
// ------------------------------------------------------------------------

(
Pbind(\instrument, \itersynth,\freq,
		Pseq(
			[
			50,54,61,50,54,61,
			50,54,61,50,54,61,
			50,54,61,50,54,61,
			50,54,61,50,54,61,
			49,52,59,49,52,59,
			49,52,59,49,52,59,
			49,52,59,49,52,59,
			49,52,59,49,52,59
			]
			.midicps, inf), \dur, 0.25
).play;
)

s.freeAll;

(
Pbind(\instrument, \itersynth,\freq,
		Pseq([50].midicps), \dur, 0.5
).play;
)


Pbind(\instrument, \itersynth, \freq, Pseq([50,54,61],inf)*200, \dur,2).play;

// ------------------------------------------------------------------------
// NOTE:
// - cannot use other letters for plotTree, only s ???;
// - Pbind can send to ~fxSendBus, cool!!.
