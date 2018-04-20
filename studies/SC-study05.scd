
SerialPort.devices;

~port = SerialPort.new("/dev/tty.usbmodem1411", 115200);

~port.read;


30.do{~port.read.postln};


90.asAscii;
91.asAscii;


(
x = [];
30.do{x = x.add(~port.read)};
)

x;



x.collect(_.asAscii);
x;

~port.close;

// -----------------------------------------------------------------------------------------

// So quit the Arduino IDE and back in SuperCollider, let's re-instantiate our port object,
~port = SerialPort.new("/dev/tty.usbmodem1411", 115200);


(
x = [];
30.do{x = x.add(~port.read)};
x = x.collect(_.asAscii);
)


x.collect(_.class);

(
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read.asAscii;

	}.loop;
}).play
)

$a.isAlpha;
$4.isAlpha;



(
~charArray = [];
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a, {});

	}.loop;
}).play
)

// how to convert Char to digit.
[$4, $6, $1].collect(_.digit).convertDigits;


(
~charArray = [];
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a, {
			~val = ~charArray.collect(_.digit).convertDigits;
			~charArray = [];
		});
	}.loop;
}).play
)

~val;

~getValues.stop;

(
~r = Routine.new({
	{
		rrand(0,9).postln;
		0.25.wait;
	}.loop
}).play
)
~r.stop;

~r.stop;

(
~charArray = [];
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a, {
			~val = ~charArray.collect(_.digit).convertDigits;
			~charArray = [];
		});
	}.loop;
}).play
)


s.boot;

(
SynthDef.new(\saw, {
	arg cutoff=1000;
	var sig;
	sig = Saw.ar([50,51]);
	sig = RLPF.ar(sig, cutoff.lag(0.02), 0.25, 0.2);
	Out.ar(0, sig);
}).add;
)



~synth = Synth(\saw, [\cutoff, 200]);
~synth.set(\cutoff, 10000);
~synth.free;



~synth = Synth(\saw);
(
~control = Routine.new({
	{
		~synth.set(\cutoff, ~val.linexp(0,1023,80,4000));
		0.01.wait;
	}.loop
}).play
)


(
~control.stop;
~synth.free;
)
