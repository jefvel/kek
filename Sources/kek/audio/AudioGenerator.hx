package kek.audio;

class Notes {
    public static inline var C0 = 16.35;
    public static inline var CS0 = 17.32;
    public static inline var D0 =	18.35;
    public static inline var DS0 = 19.45;
    public static inline var E0 =	20.60;
    public static inline var F0	 =21.83;
    public static inline var FS0=23.12;
    public static inline var G0	 =24.50;
    public static inline var GS0=25.96;
    public static inline var A0	 =27.50;
    public static inline var AS0=29.14;
    public static inline var B0	 =30.87;
    public static inline var C1	 =32.70;
    public static inline var CS1=34.65;
    public static inline var D1	 =36.71;
    public static inline var DS1=38.89;
    public static inline var E1	 =41.20;
    public static inline var F1	 =43.65;
    public static inline var FS1=46.25;
    public static inline var G1	 =49.00;
    public static inline var GS1=51.91;
    public static inline var A1	 =55.00;
    public static inline var AS1=58.27;
    public static inline var B1	 =61.74;
    public static inline var C2	 =65.41;
    public static inline var CS2=69.30;
    public static inline var D2	 =73.42;
    public static inline var DS2=77.78;
    public static inline var E2	 =82.41;
    public static inline var F2	 =87.31;
    public static inline var FS2=92.50;
    public static inline var G2	 =98.00;
    public static inline var GS2=103.83;
    public static inline var A2	 =110.00;
    public static inline var AS2=116.54;
    public static inline var B2	 =123.47;
    public static inline var C3	 =130.81;
    public static inline var CS3=138.59;
    public static inline var D3	 =146.83;
    public static inline var DS3=155.56;
    public static inline var E3	 =164.81;
    public static inline var F3	 =174.61;
    public static inline var FS3=185.00;
    public static inline var G3	 =196.00;
    public static inline var GS3=207.65;
    public static inline var A3	 =220.00;
    public static inline var AS3=233.08;
    public static inline var B3	 =246.94;
    public static inline var C4	 =261.63;
    public static inline var CS4=277.18;
    public static inline var D4	 =293.66;
    public static inline var DS4=311.13;
    public static inline var E4	 =329.63;
    public static inline var F4	 =349.23;
    public static inline var FS4=369.99;
    public static inline var G4	 =392.00;
    public static inline var GS4=415.30;
    public static inline var A4	 =440.00;
    public static inline var AS4=466.16;
    public static inline var B4	 =493.88;
    public static inline var C5	 =523.25;
    public static inline var CS5=554.37;
    public static inline var D5	 =587.33;
    public static inline var DS5=622.25;
    public static inline var E5	 =659.25;
    public static inline var F5	 =698.46;
    public static inline var FS5=739.99;
    public static inline var G5	 =783.99;
    public static inline var GS5=830.61;
    public static inline var A5	 =880.00;
    public static inline var AS5=932.33;
    public static inline var B5	 =987.77;
    public static inline var C6	 =1046.50;
    public static inline var CS6=1108.73;
    public static inline var D6	 =1174.66;
    public static inline var DS6=1244.51;
    public static inline var E6	 =1318.51;
    public static inline var F6	 =1396.91;
    public static inline var FS6=1479.98;
    public static inline var G6	 =1567.98;
    public static inline var GS6=1661.22;
    public static inline var A6	 =1760.00;
    public static inline var AS6=1864.66;
    public static inline var B6	 =1975.53;
    public static inline var C7	 =2093.00;
    public static inline var CS7=2217.46;
    public static inline var D7	 =2349.32;
    public static inline var DS7=2489.02;
    public static inline var E7	 =2637.02;
    public static inline var F7	 =2793.83;
    public static inline var FS7=2959.96;
    public static inline var G7	 =3135.96;
    public static inline var GS7=3322.44;
    public static inline var A7	 =3520.00;
    public static inline var AS7=3729.31;
    public static inline var B7	 =3951.07;
    public static inline var C8	 =4186.01;
    public static inline var CS8=4434.92;
    public static inline var D8	 =4698.63;
    public static inline var DS8=4978.03;
    public static inline var E8	 =5274.04;
    public static inline var F8	 =5587.65;
    public static inline var FS8=5919.91;
    public static inline var G8	 =6271.93;
    public static inline var GS8=6644.88;
    public static inline var A8	 =7040.00;
    public static inline var AS8=7458.62;
    public static inline var B8	 =7902.13;
}

class AudioGenerator {
	public var SamplesPerSecond(default, set):Int;
	public var BPM(default, set):Float;
	
	function set_SamplesPerSecond(sps:Int) {
		SamplesPerSecond = sps;
		return SamplesPerSecond;
	}
	
	function set_BPM(bpm:Float) {
		BPM = bpm;
		return bpm;
	}
}
