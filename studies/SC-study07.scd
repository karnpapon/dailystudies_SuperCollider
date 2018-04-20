s.reboot;
s.quit;
s.freeAll;
s.meter;
FreqScope.new;
Stethoscope(s, 2);

// Granular Synthesis - microsound in the Roadsian sense

~b1 = Buffer.read(s, "/Users/mac/Desktop/2.wav");
~b1.bufnum;

GrainBuf.ar();
GrainFM.ar();
GrainSin.ar();

(
{
	var singrain1, singrain2, sfgrain, env;
	env = EnvGen.kr(Env.new([0,1,1,0],[0.01,0.01,0.01], -4));
	singrain1 = (SinOsc.ar(200,0,XLine.kr(1.0, 0.0001, 0.05))) * env;
	singrain2 = (FSinOsc.ar(400, 0.0, Line.kr(1.0,0,0.05).squared)) * env;
	sfgrain = (PlayBuf.ar(2, ~b1.bufnum, BufRateScale.kr(~b1.bufnum))) * env;

	[singrain1, singrain2, sfgrain]
}.plot(0.1, s);
)

(
SynthDef.new(\sinegrain, {
	arg pan, freq, amp;
	var grain, env;
	grain = SinOsc.ar(freq, 0, amp);
	env = XLine.kr(1.001, 0.001, 0.1, doneAction: 2)-0.001;
	grain = grain * env;
	Out.ar(0, Pan2.ar(grain, pan));
}).add;
)

{XLine.kr(1.001, 0.001, 0.1, doneAction: 2)-0.001}.plot(0.25);

Synth.new(\sinegrain, [\freq, rrand(100, 2000), \amp, exprand(0.05, 0.1), \pan, 1.0.rand2]);

(
SynthDef.new(\sfgrain, {
	arg pan=0.0, startPos=0.0, amp=0.1, dur=0.4;
	var grain, env, buf;
	buf = ~b1.bufnum;
	env = EnvGen.kr(Env.perc(0.01,dur), doneAction: 2);
	grain = PlayBuf.ar(2, buf, BufRateScale.kr(buf), 1, BufFrames.ir(buf)*startPos);
	grain = grain * env;
	Out.ar(0, Pan2.ar(grain, pan));
}).add;
)

Synth.new(\sfgrain, [\startPos, rrand(0.0, 1.0), \amp, exprand(0.05, 0.1), \pan, 1.0.rand2]);


// 100 random sinewave grains.
(
{
	100.do{
		arg i;
		Synth.new(\sinegrain, [\freq, rrand(100, 2000), \amp, exprand(0.05, 0.1), \pan, 1.0.rand2]);
		0.01.wait;
	};
}.fork;
)

// 200 random sinewave grains, lowering density over time.
(
{
	200.do{
		arg i;
		var timeprop = (i/199.0);
		Synth.new(\sinegrain, [
			\freq, exprand(100, 5000-(20*i)),
			\amp, exprand(0.05, 0.1),
			\pan, 1.0.rand2
		]);
		rrand((timeprop*0.1).max(0.01), timeprop*0.3).wait;
	};
}.fork;
)

// 200 random grains from a buffer, lowering density over time.
(
{
	200.do{
		arg i;
		var timeprop = (i/199.0)**3;

		Synth.new(\sfgrain, [
			\startPos, rrand(0.0, 1.0),
			\amp, exprand(0.05, 0.1),
			\pan, 1.0.rand2
		]);
		rrand((timeprop*0.1).max(0.01), timeprop*0.3).wait;
	};
}.fork;
)

(
var w, slid, lastval;

lastval=0.0;

w=Window("My Window", Rect(100,500,200,200));
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=Slider(w,Rect(10,10,150,10)); //a basic slider object

slid.action_({lastval= slid.value;}); //this is the callback- the function is called whenever you move the slider

{
inf.do{
		arg i;
		var prop, timestart, timeend;

		prop = (i % 100) / 100;
		timestart= prop * 0.2;
		timeend= prop * (0.2);

	Synth(\sfgrain,[
			\startPos,rrand(timestart,timeend),
			\amp, exprand(0.005,0.1),
			\pan, lastval.rand2,
			\dur, 0.1+(lastval*0.5)]);
	//max in this to avoid ever going near 0.0 wait time, which would crash the computer!
	// if lastval*0.2 < 0.0 it results 0.01
	((lastval*0.2).max(0.01)).wait
};
}.fork;


w.front;
)

(
SynthDef.new(\grainsintest, {
	arg grain = 0.05, freq = 300, pan = 0;
	Out.ar(0, GrainSin.ar(2, Impulse.kr(30), grain, freq, pan));
}).add;
)

a = Synth.new(\grainsintest, [\grain, 0.025, \freq, 500]);

a.set(\grain , 0.4);
a.set(\freq, 100);



// --------------------------------------------------------