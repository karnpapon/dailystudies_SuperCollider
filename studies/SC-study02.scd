// STUDY02
// ------------------------------------------------

(
	SynthDef.new(\itersynth,{
		arg count, freq = 40;
		var sig, sum, temp, env;
		sum = 0;
		env = EnvGen.kr(
			Env.perc(0.01,2.5,1,-2), // start,release,level,curve.
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
		sum = sum * 0.1 * env; // mul 0.1 to prevent clipping.
		Out.ar(0,sum);
	}).add
);

Pbind(\instrument, \itersynth, \freq,
		Pseq(
			[
			50,54,61,50,54,61,50,54,61,50,54,61,
			50,54,61,50,54,61,50,54,61,50,54,61,
			49,52,59,49,52,59,49,52,59,49,52,59,
			49,52,59,49,52,59,49,52,59,49,52,59
			]
			.midicps, inf), \dur, 0.25
	).play;

Pbind(\instrument, \itersynth, \freq, Pseq([50,54,61],inf)*200, \dur,2).play;

s.free

Synth.new(\itersynth, [\freq,50.midicps]); // D
Synth.new(\itersynth, [\freq,54.midicps]); // F#
Synth.new(\itersynth, [\freq,61.midicps]); // C#
Synth.new(\itersynth, [\freq,49.midicps]); // C#
Synth.new(\itersynth, [\freq,52.midicps]); // E
Synth.new(\itersynth, [\freq,59.midicps]); // B

s.boot
s.plotTree;
s.free
s.scope

// ------------------------------------------------
// NOTE:
// - cannot use other letters for plotTree, only s ???;
