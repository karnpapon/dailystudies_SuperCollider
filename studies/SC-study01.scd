{16.do({{LFSaw.ar(Rand(220,880), 0 ,0.05)}.play; 0.2.wait;})}.fork;


{ LFSaw.ar(SinOsc.ar(XLine.kr(1, 10, 4), 0, 20, 800), 0, 0.05) }.play;

{ SinOsc.ar(800, SinOsc.ar(XLine.kr(1, 1000, 9), 0, 2pi), 0.25) }.play;


(
SynthDef(\sinewave,{|freq = 440|
var output = SinOsc.ar(freq, 0 ,0.1);
Out.ar([0,1], output);
}).send;
)

x = Synth(\sinewave)

x.set(\freq, 440)