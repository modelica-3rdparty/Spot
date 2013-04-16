within Spot.Blocks;
package Math "Auxiliary blocks"
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
</html>"),
    Icon);
block Integrator "Integral of input-signal"
  extends Partials.SISO(y(start=y_ini, fixed=true));

  parameter Real y_ini=0 "initial value";

  annotation (
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Window(
      x=0.29,
      y=0.05,
      width=0.53,
      height=0.54),
    Documentation(info="<html>
<p/>Calculates:
<pre>  y_ini + Integral dt u</pre>
</html>
"), Icon(
   Text(
  extent=[-70,40; 90,-40],
  style(color=10),
          string="dt u"),
        Line(points=[-61,31; -59,41; -55,45; -49,47], style(
            color=10,
            rgbcolor={135,135,135},
            thickness=2)),
        Line(points=[-61,-31; -63,-41; -67,-45; -73,-47], style(
            color=10,
            rgbcolor={135,135,135},
            thickness=2)),
        Line(points=[-61,31; -61,-31], style(
            color=10,
            rgbcolor={135,135,135},
            thickness=2))),
    Diagram);
equation
  der(y) = u;
end Integrator;

  block TimeAverage "Time average of input signal"
    extends Partials.MIMO(final nin=n, final nout=n);

    parameter Integer n=1 "dim of input/output signal";
    parameter SI.Time tcst(min=Modelica.Constants.eps)=1 "memory time constant";
    annotation (defaultComponentName = "time_av",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Calculates the time-average of the input-signal u with exponential memory function (first order transfer function with initial condition).</p>
<p>This block does NOT need the delay operator. It may be replaced by something more specific in context with inverters/modulation.</p>
</html>
"),   Icon(
     Text(
    extent=[-80,40; 80,-40],
    style(color=10),
          string="(...)"),
     Text(
    extent=[-80,80; 80,40],
    style(color=10),
          string="_____")),
      Diagram);

  initial equation
    y = u;

  equation
    der(y) = (u - y)/tcst;
  end TimeAverage;

  block TimeAvInterval "Time average over interval of input signal"
    extends Partials.MIMO(final nin=n, final nout=n);

    parameter Integer n=1 "dim of input/output signal";
    parameter SI.Time tcst(min=1e-9)=1 "average time";
  protected
    Real[n] U(start=zeros(n), fixed=true, each stateSelect=StateSelect.always);
    annotation (defaultComponentName = "time_avI",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Calculates the time-average of the input-signal u over the interval {time - tau, time}.</p>
<p>This block needs the delay operator!</p>
</html>
"),   Icon(
     Text(
    extent=[-80,80; 80,40],
    style(color=10),
          string="_____"),
     Text(
    extent=[-80,40; 80,-40],
    style(color=10),
          string="[...]")),
      Diagram);

  equation
    der(U) = u;
    y = (U - delay(U, tcst))/tcst;
  end TimeAvInterval;

  block ComponentAverage "Component average of input signal"
    extends Partials.MISO;

    annotation (defaultComponentName = "average",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
     Text(
    extent=[-80,40; 80,-40],
    style(color=10),
          string="av(..)")),
      Documentation(
              info="<html>
<p>Calculates the average over the components of the input-signal u.</p>
</html>"),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Diagram);

  algorithm
    y := sum(u)/n;
  end ComponentAverage;

  block Norm "Norm of input signal"
    extends Partials.MISO(n=3);

    parameter Integer n_eval(
      min=2,
      max=3) = 2 "dim of evaluated input signal u[1:n_eval]";
    annotation (defaultComponentName = "norm",
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
<p>Allows in particular to calculate the dqo-norm (n_eval=3) or dq-norm (n_eval=2) of the input signal.</p>
</html>
"),   Icon(
     Text(
    extent=[-80,40; 80,-40],
    string="|u|",
    style(color=10))),
      Diagram);

  equation
    y = sqrt(u[1:n_eval]*u[1:n_eval]);
  end Norm;

  block ToPolar "Rotation of input signal-vector"
    extends Partials.MIMO(final nin=2, final nout=2);

    parameter Integer sig(min=-1, max=1)=1 "+u or -u as input"
                                           annotation(Evaluate=true);
  protected
    function atan2=Modelica.Math.atan2;
    annotation (defaultComponentName = "toPolar",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-70,36; 80,-44],
    style(color=10),
          string="polar >")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>Converts Euclidean {u[1], u[2]} to  polar {y[1], y[2]} coordinates, where
<pre>
  y[1]     absolute value
  y[2]     argument, phase
</pre></p>
<p>The phase <tt>y[2]</tt> is continuous in the interval
<pre>  -pi &lt  phi &lt = +pi</pre></p>
</html>"),
      Diagram);

  equation
    y[1] = sqrt(u*u);
    y[2] = atan2(sig*u[2], sig*u[1]);
  end ToPolar;

  block ToPolarR "Rotation of input signal-vector"
    extends Partials.MIMO(final nin=2, final nout=2);

    parameter Integer sig(min=-1, max=1)=1 "+u or -u as input"
                                           annotation(Evaluate=true);
  protected
    SI.Angle alpha(stateSelect=StateSelect.always);
    SI.AngularVelocity omega;
    function atan2=Modelica.Math.atan2;
    function atanV=Base.Math.atanVarCut;
    function angVelocity=Base.Math.angVelocity;
    annotation (defaultComponentName = "toPolar",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-70,36; 80,-44],
          style(color=43, rgbcolor={255,85,85}),
          string="polar >")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>Converts Euclidean {u[1], u[2]} to  polar {y[1], y[2]} coordinates, where
<pre>
  y[1]     absolute value
  y[2]     argument, phase
</pre></p>
<p>The phase <tt>y[2]</tt> is continuous on the whole real axis
<pre>  -inf &lt  phi &lt  +inf</pre></p>
</html>"),
      Diagram);

  initial equation
    alpha =  atan2(sig*u[2], sig*u[1]); // leads to troubles with GNU-compiler.

  equation
    omega =  angVelocity(u, der(u));
    der(alpha) = omega;
    y[1] = sqrt(u*u);
    y[2] = atanV(sig*u, alpha);
  end ToPolarR;

  block FromPolar "Rotation of input signal-vector"
    extends Partials.MIMO(final nin=2, final nout=2);

    annotation (defaultComponentName = "fromPolar",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-80,36; 70,-44],
    style(color=10),
          string="< polar")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>Converts polar {u[1], u[2]} to Euclidean {y[1], y[2]} coordinates, where
<pre>
  u[1]     absolute value
  u[2]     argument, phase
</pre></p>
</html>
"),   Diagram);

  equation
    y = u[1]*{cos(u[2]), sin(u[2])};
  end FromPolar;
end Math;
