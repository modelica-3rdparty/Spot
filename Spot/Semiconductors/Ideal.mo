within Spot.Semiconductors;
package Ideal "Custom models"
  extends Base.Icons.Library;

annotation (preferedView="info",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.05,
y=0.41,
width=0.4,
height=0.32,
library=1,
autolayout=1),
    Documentation(info="<html>
<p>Ideal semiconductor models (default choice).</p>
</html>
"),
  Icon);

record SCparameter "Ideal semiconductor parameters"
  extends Base.Units.NominalDataVI;

  parameter Real[2] eps(final min={0,0}, unit="pu")={1e-4,1e-4}
      "{resistance 'on', conductance 'off'}";
  parameter SI.Voltage Vf(final min=0)=0 "forward threshold-voltage" annotation(Evaluate=true);
  parameter SI.Heat Hsw_nom=0 "switching loss at V_nom, I_nom (av on off)"
    annotation(Evaluate=true);
  parameter Real[:] cT_loss=fill(0,0) "{cT1,cT2,...} T-coef thermal losses"
    annotation(Evaluate=true);
  parameter SI.Temp_K T0_loss=300 "reference T for cT_loss expansion"
    annotation(Dialog(enable=size(cT_loss,1)>0), Evaluate=true);
  annotation (
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
<p>The small parameters epsR and epsG are given in dimensionless units. This allows to work with deault values also in cases where the exact semiconductor data are missing. A resonable (approximate) value for <tt>Z_nom</tt> is needed for scaling.
<pre>
  epsR = (dV/dI)/Z_nom at I_nom
  Z_nom = V_nom/I_nom
</pre></p>
<p>Thermal losses are proportional to the forward drop voltage V, which may depend on temperature.<br>
The temperature dependence is given by
<pre>  V(T) = Vf*(1 + cT[1]*(T - T0) + cT[2]*(T - T0)^2 + ...)</pre>
where <tt>Vf</tt> denotes the parameter value. With input <tt>cT</tt> empty,  no temperature dependence of losses is calculated.</p>
<p>The switching losses are approximated by
<pre>  h = hSw_nom*v*i/S_nom,   S_nom = V_nom*I_nom</pre>
where <tt>q</tt> denotes the dissipated heat per switching operation at nominal voltage and current, averaged over 'on' and 'off'.<br>
A generalisation to powers of i and v is straightforward.</p>
</html>"),
    Diagram,
    Icon);
end SCparameter;

partial model IdealCharacteristic "Ideal diode characteristic"
  extends Partials.ComponentBase;

  parameter Ideal.SCparameter par "ideal with forward Vf"
 annotation (extent=[-80,-80; -60,-60]);
  protected
  Boolean on;
  Real s "auxiliary variable";
  SI.Voltage V "forward threshold voltage";
  SI.Current i_sc = i*par.V_nom/par.I_nom "current scaled to voltage";
  function loss = Spot.Base.Math.taylor "spec loss function of temperature";

annotation (
  Coordsys(
    extent=
   [-100, -100; 100, 100],
    grid=
 [2, 2],
    component=
      [20, 20]),
  Window(
    x=0.45,
      y=0.01,
      width=
  0.44,
    height=
   0.65),
  Documentation(
        info="<html>
</html>
"),
  Diagram,
  Icon);

equation
  V = if size(par.cT_loss,1)==0 then par.Vf else par.Vf*loss(T - par.T0_loss, par.cT_loss);
  {v,i_sc} = if on then {par.eps[1]*s + (1 - par.eps[1])*V,s - (1 - par.eps[2])*V} else {s,par.eps[2]*s};
end IdealCharacteristic;

model Diode "Diode"
  extends IdealCharacteristic;

  annotation (defaultComponentName = "diode1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
<p>Ideal Diode with forward threshold voltage <tt>Vf_d</tt>.</p>
</html>"),
    Icon(
Polygon(points=[40,0; -40,40; -40,-40; 40,0],     style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[-90,0; -40,0],   style(color=3, rgbcolor={0,0,255})),
Line(points=[40,0; 90,0], style(color=3, rgbcolor={0,0,255})),
Line(points=[40,40; 40,-40],   style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
    Diagram);
equation
  on = s > V;
end Diode;

model Thyristor "Thyristor"
  extends IdealCharacteristic;

  Modelica.Blocks.Interfaces.BooleanInput gate "true:on, false: off"
    annotation (
          extent=[50,90; 70,110],   rotation=-90);
  annotation (defaultComponentName = "thyristor1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
</html>
"), Icon(
Polygon(points=[20, 0; -60, 40; -60, -40; 20, 0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[-90, 0; -60, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[20, 0; 90, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[20, 40; 20, -40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[20,0; 60,40; 60,90], style(
              color=5,
              rgbcolor={255,0,255},
              pattern=3))),
      Diagram);

equation
  on = s > V and (pre(on) or gate);
end Thyristor;

model SCswitch "Semiconductor switch"
  extends IdealCharacteristic;

  Modelica.Blocks.Interfaces.BooleanInput gate "true:on, false: off"
    annotation (
          extent=[50,90; 70,110],   rotation=-90);
  annotation (defaultComponentName = "GTO1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
<p>Ideal semiconductor switch with forward threshold voltage <tt>Vf_s</tt>.<br>
(Equivalent to ideal GTO or IGBT).</p>
</html>"),
    Icon(
Polygon(points=[20, 0; -60, 40; -60, -40; 20, 0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[-90, 0; -60, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[20, 0; 90, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[20, 40; 20, -40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[20,0; 60,40; 60,90], style(color=5, rgbcolor={255,0,255}))),
      Diagram);

equation
  on = s > V and gate;
end SCswitch;

model SCswitch_Diode "Semiconductor switch with reverse Diode"
  extends Partials.ComponentBase;

  parameter SCparameter par "ideal with forward Vf"
                                        annotation (extent=[-80,-80; -60,-60]);
  Modelica.Blocks.Interfaces.BooleanInput gate "true:on, false: off"
    annotation (
          extent=[50,90; 70,110],   rotation=-90);
  protected
  Real s "auxiliary variable";
  SI.Voltage V "forward threshold voltage";
  SI.Current i_sc = i*par.V_nom/par.I_nom "current scaled to voltage";
  function loss = Spot.Base.Math.taylor "spec loss function of temperature";

  annotation (defaultComponentName = "GTO_D1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
<p>Ideal semiconductor switch with forward threshold voltage <tt>Vf_s</tt> and reverse Diode with forward threshold voltage <tt>Vf_d</tt>.<br>
(Equivalent to ideal GTO or IGBT with reverse Diode).</p>
</html>"),
    Icon(
Polygon(points=[30, 40; -40, 70; -40, 10; 30, 40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[-90, 0; -60, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[60, 0; 90, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[30, 70; 30, 10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Polygon(points=[-30, -40; 40, -10; 40, -70; -30, -40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[30, 40; 60, 40; 60, -40; 40, -40], style(color=3, rgbcolor={0,0,
                255})),
Line(points=[-40, 40; -60, 40; -60, -40; -30, -40], style(color=3, rgbcolor={0,
                0,255})),
        Line(points=[30,40; 60,70; 60,90], style(color=5, rgbcolor={255,0,255}))),
      Diagram);

equation
  V = if size(par.cT_loss,1)>0 then par.Vf*loss(T -par.T0_loss, par.cT_loss) else par.Vf;
  if gate then
    if s > V then
      {v, i_sc} = {par.eps[1]*s + (1 - par.eps[1])*V,s - (1 - par.eps[2])*V};
    elseif s < -V then
      {v, i_sc} = {par.eps[1]*s - (1 - par.eps[1])*V,s + (1 - par.eps[2])*V};
    else
      {v, i_sc} = {s,par.eps[2]*s};
    end if;
  else
    {v, i_sc} = if s < - V then {par.eps[1]*s - (1 - par.eps[1])*V, s + (1 - par.eps[2])*V} else {s,par.eps[2]*s};
  end if;
end SCswitch_Diode;

end Ideal;
