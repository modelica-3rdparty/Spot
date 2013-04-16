within Spot.Base;
package Types "Additional types for power systems"
  extends Icons.Base;

 annotation (preferedView="info",
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65,
    library=1,
    autolayout=1),
  Invisible=true,
  Documentation(info="<html>
</html>
"));

  constant Real d2r = pi/180 "conversion degree to radian";
  constant Real rpm2w = pi/30 "conversion rev per minute to radian/s";

  type Color = Integer[3] (min=0, max=255) "RGB color" annotation (choices(
      choice={255,0,0} "{255, 000, 000 }  red",
      choice={255,255,0} "{255, 255, 000}  yellow",
      choice={0,255,0} "{000, 255, 000}  green",
      choice={0,255,255} "{000, 255, 255}  cyan",
      choice={0,0,255} "{000, 000, 255}  blue",
      choice={255,0,255} "{255, 000, 255}  magenta",
      choice={0,0,0} "{000, 000, 000}  black",
      choice={95,95,95} "{095, 095, 095}  dark grey",
      choice={175,175,175} "{175, 175, 175}  grey",
      choice={255,255,255} "{255, 255, 255}  white"));

  type Complex = Real[2, 2] "matrix representation of complex number"
    annotation (Documentation(info="<html>
<p>Complex number <tt>(x + jy)</tt>, considered as an element of an algebra, and represented by the real 2x2 matrix z:</p>
<pre>
  z = [x, -y]
      [y,  x]
</pre>
<p>The following relations hold for</p>
<pre>
- complex conjugate:   transpose(z)
- addition:            z1 + z2
- multiplication:      z1*z2
- inverse:             transpose(z)/det(z)
- absolute value:      sqrt(det(z))
</pre>
<p>where <tt>det(z)</tt> denotes the determinant of matrix z.</p>
<p><b>Example:</b></p>
<p>The linear differential equation with constant coefficients for a real scalar current I and voltage V
<pre>  L*dI/dt + R*I = V</pre>
is mapped by Fourier-transform to the algebraic equation
<pre>  (R + j*omega*L)*i = v</pre>
with complex i and v, if for simplicity only one frequency term is assumed. Using
<pre>
  Complex Z =  R*re_unit + omega*L*im_unit (complex impedance)
  Complex i = i1*re_unit + i2*im_unit      ('current phasor')
  Complex v = v1*re_unit + v2*im_unit      ('voltage phasor')
</pre>
the equation finally becomes
<pre>  Z*i = v</pre></p>
</html>"));
    constant Complex re_unit=[1,0;0,1] "matrix representation of real unit";
    constant Complex im_unit=[0,-1;1,0]
    "matrix representation of imaginary unit";

//type Units = enumeration(SI, pu) "unit choice";
  type Units = String "unit choice" annotation(choices(
    choice=Spot.Base.Types.SI "SI",
    choice=Spot.Base.Types.pu "pu"), Documentation(info="<html>
<p><pre>
  SI:  parameters in SI
  pu:  parameters in pu
</pre></p>
</html>"));
    constant Units SI="SI" "SI units";
    constant Units pu="pu" "pu units";

//type FreqType = enumeration(sys, par, sig, ave) "frequency type";
  type FreqType = String "frequency type" annotation(choices(
     choice=Spot.Base.Types.sys "system",
     choice=Spot.Base.Types.par "parameter",
     choice=Spot.Base.Types.sig "signal (omega)"), Documentation(info=
                   "<html>
<p><pre>
  sys:  source has system frequency
  par:  system or source has paramter frequency
  sig:  system or source has signal frequency
  ave:  system has averaged frequency (over involved generators)
</pre></p>
</html>"));
    constant FreqType par="par" "parameter frequency";
    constant FreqType sig="sig" "signal frequency";
    constant FreqType ave="ave" "average frequency";
    constant FreqType sys="sys" "system frequency";

//type SourceType = enumeration(par, sig) "source type";
  type SourceType = String "source type" annotation (choices(
     choice=Spot.Base.Types.par "parameter",
     choice=Spot.Base.Types.sig "signal"), Documentation(info=
                   "<html>
<p><pre>
  par:  parameter
  sig:  signal
</pre></p>
</html>"));

//type IniType = enumeration(v_alpha, v_p, v_q, p_q, none) "initialisation type";
  type IniType = String "initialisation type"
    annotation(choices(
     choice=Spot.Base.Types.v_alpha "voltage and phase angle ('slack')",
     choice=Spot.Base.Types.v_p "voltage and active power",
     choice=Spot.Base.Types.v_q "voltage and reactive power",
     choice=Spot.Base.Types.p_q "active and reactive power",
     choice=Spot.Base.Types.none "no initial condition"), Documentation(info=
                   "<html>
<p><pre>
  v_alpha:  terminal voltage and phase angle ('slack')
  v_p:      terminal voltage and active power
  v_q:      terminal voltage and reactive power
  p_q:      terminal active and reactive power
  none:     no initial condition
</pre></p>
</html>"));
    constant IniType v_alpha="v_alpha" "voltage and phase";
    constant IniType v_p="v_p" "voltage and active power";
    constant IniType v_q="v_q" "voltage and reactive power";
    constant IniType p_q="p_q" "active and reactive power";
    constant IniType none="none" "no initial condition";

//type Mode = enumeration(tr, st) "simulation and initialisation mode";
  type Mode = String "simulation and initialisation mode" annotation (choices(
     choice=Spot.Base.Types.tr "transient",
     choice=Spot.Base.Types.st "steady"), Documentation(info=
                   "<html>
<p><pre>
  tr:  transient
  st:  steady state
</pre></p>
</html>"));
    constant Mode tr= "tr" "transient mode";
    constant Mode st= "st" "steady state mode";

//type Mode = enumeration(syn, inert) "reference frame";
  type RefFrame = String "reference frame" annotation (choices(
   choice=Spot.Base.Types.syn "synchronous",
   choice=Spot.Base.Types.inert "inertial"), Documentation(info=
                 "<html>
<p><pre>
  syn:   synchronous (rotating)
  inert: inertial (not rotating)
</pre></p>
</html>"));
    constant RefFrame syn= "syn" "synchronous";
    constant RefFrame inert= "inert" "inertial";

  type ReferenceAngle "reference angle"
    extends Modelica.SIunits.Angle;

    function equalityConstraint
      input ReferenceAngle[2] theta_p;
      input ReferenceAngle[2] theta_n;
      output Real[0] residue;
    algorithm
      assert(abs(theta_p[1] - theta_n[1]) < Modelica.Constants.eps, "theta[1] term_p and term_n not equal!");
      assert(abs(theta_p[2] - theta_n[2]) < Modelica.Constants.eps, "theta[2] term_p and term_n not equal!");
    end equalityConstraint;

  annotation (Documentation(info="<html>
<p>Type ReferenceAngle specifies the variable-type that contains relative frequency and angular orientation of a rotating electrical reference system.
<pre>
  theta_p[1]     angle relative to reference-system
  theta_p[2]     reference angle, defining reference-system

  der(theta[1])  relative frequency in reference-system with orientation theta[2]
  der(theta[1] + theta[2])  absolute frequency
</pre></p>
</html>"));
  end ReferenceAngle;

// alternative '"SI"' or '"pu"' units:
  type AngularVelocity = Real(final quantity="AngularVelocity", unit="rad/s | pu");
  type AngularVelocity_rpm = Real (final quantity="AngularVelocity", final unit = "rev/min");
  type Voltage = Real (final quantity="Voltage", unit="V | pu");
  type Current = Real (final quantity="Current", unit="A | pu");
  type ApparentPower = Real (final quantity="ApparentPower", unit="VA | pu");
  type Resistance = Real (
      final quantity="Resistance",
      unit="Ohm | pu",
      final min=0);
  type Reactance = Real (final quantity="Reactance", unit="Ohm | pu");
  type Impedance = Real (final quantity="Impedance", unit="Ohm | pu");
  type Inductance = Real (final quantity="Inductance", unit="H | pu");
  type Conductance = Real (
      final quantity="Conductance",
      unit="S | pu",
      final min=0);
  type Susceptance = Real (
      final quantity="Susceptance",
      unit="S | pu",
      min=0);
  type Admittance = Real (
      final quantity="Admittance",
      unit="S | pu",
      min=0);
  type Resistance_km = Real (
      final quantity="Resistance_per_km",
      unit="Ohm/km | pu/km",
      min=0);
  type Reactance_km = Real (final quantity="Reactance_per_km",
      unit="Ohm/km | pu/km",
      min=0);
  type Conductance_km = Real (
      final quantity="Conductance_per_km",
      unit="S/km | pu/km",
      min=0);
  type Susceptance_km = Real (
      final quantity="Susceptance_per_km",
      unit="S/km | pu/km",
      min=0);
  type MagneticFlux = Real (final quantity="MagneticFlux", unit="Wb | pu");

  type Energy = Real (final quantity="Energy", unit="J | pu");
  type Power = Real (final quantity="Power", unit="W | pu");
  type Torque = Real (final quantity="Torque", unit="Nm | pu");

  type Stiffness = Real (final quantity="Stiffness", final unit="N", final min=0);
  type TorsionStiffness = Real (final quantity="TorsionStiffness", final unit="N.m/rad", final min=0);
  type Angle_deg = Real (final quantity="Angle", final unit="deg");
  type Length_km = Real (final quantity="Length", final unit="km");
  type Charge_Ah = Real (final quantity="ElectricCharge", final unit="Ah");

  type Percent = Real(final quantity="Percent",final unit="%");
end Types;
