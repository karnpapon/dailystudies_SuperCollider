// STUDY00
// ------------------------------------------------


f = { "Function esfsdfsdvaluated".postln; };
f.value;
f.value;
f.value;

f = { "Evaluating...".postln; 2 + 3; };
f.value;

f = { 3.0.rand; };    // Here it's a Function

f.value


(
s = { SinOsc.ar(440, 0, 0.2);
};
)

s.plot

// ar = audio rate (freq,start,amp )
// kr =  control rate(cps, phase (where cps start) ,mul-L,mul-R)
// 2PI = 1 cycle
// PI = half cycle
(
a = { var ampOsc;
    ampOsc = SinOsc.kr(0.5, pi, 0.25, 0.25);
    SinOsc.ar(240, 0, ampOsc);
};
)

a.play
a.plot

{ [SinOsc.ar(240, 1, 0.2), SinOsc.ar(242, 0, 0.2)] }.play;

(
n = { var freq = [[440,426],[660,880],[230,260]].choose;
	SinOsc.ar(freq, 0, 0.2)
};
)

// Pan2.ar(input,paning-position)
{Pan2.ar(n, SinOsc.kr(0.5))}.play

{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.play;

// Mix.new() and Mix() are the same.
{ Mix.new([SinOsc.ar(440, 0, 0.2), Saw.ar(660, 0.2)]).postln }.play;

(
{
    var a, b;
    a = [SinOsc.ar(440, 0, 0.2), Saw.ar(662, 0.2)];
    b = [SinOsc.ar(442, 0, 0.2), Saw.ar(660, 0.2)];
    Mix([a, b]).postln;
}.play;
)

// Mix.fill(number of time for manipulating function per cps, function)
(
    var n = 16;
    {
        Mix.fill(n, { arg index;
		var amp = SinOsc.kr(0.25,0,0.5,0.5); // 0.25 = speed, 0 = starting point
            var freq;
            index.postln;
		    freq = 440 + index*[9,6.5,0.5,6.66,0.23].choose;
            freq.postln;
            SinOsc.ar(freq , 0, amp / n)
        })
    }.play;
)

// plot can recieve arg (duration), default is 0.01s
{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.plot(0.1);

// SynthDef require Out(bus number index, UGens)
SynthDef.new("tuts", { Out.ar(0, SinOsc.ar(440,0,0.2)) }).play;

// if UGens is Array, the 1st array will be declared arg in this study uses 0 = left, and the next array will be previous + 1, which is 0 + 1, equal righ Channel.
(
SynthDef.new("tutorial-SinOsc-stereo", { var outArray;
    outArray = [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)];
    Out.ar(0, outArray)
}).play;
)

x = { SinOsc.ar(660, 0, 0.2) }.play;
y = SynthDef.new("tutorial-SinOsc", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).play;
x.free;    // free just x
y.free;    // free just y


// use .add to make a copies of SynthDef later, without overhead compiling or sending unit generators, basically says this saving in CPU( only a pointer ???).
SynthDef.new("tutorial-PinkNoise", { Out.ar(0, PinkNoise.ar(0.3)) }).add;

x = Synth.new("tutorial-PinkNoise");
y = Synth.new("tutorial-PinkNoise");
x.free;
y.free;

// SynthDef use Rand for randomness for individual var, .rand cannot random note for different assigned  var.
SynthDef("tutorial-Rand", { Out.ar(0, SinOsc.ar(Rand(440, 660), 0, 0.2)) }).add;
x = Synth("tutorial-Rand");
y = Synth("tutorial-Rand");
z = Synth("tutorial-Rand");
x.free; y.free; z.free;



(
SynthDef("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)

// arg can be manipulated by declaring arg in SynthDef first and use ["name-of-declared-args", number] to change it.
x = Synth("tutorial-args");                // no args, so default values
y = Synth("tutorial-args", ["freq", 660]);        // change freq
z = Synth("tutorial-args", ["freq", 880, "out", 1]);    // change freq and output channel
x.free; y.free; z.free;

'this' === \this;

// ------------------------------------------------
// NOTE:
// - Cannot assign var beside "a" and "s", in other words variable with more than single letters,still have no idea why.