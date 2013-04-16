within Spot.Control;
package Governors "Turbine Governors "
  extends Base.Icons.Library;

  annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.44,
  width=0.31,
  height=0.28,
  library=1,
  autolayout=1),
Documentation(info="<html>
</html>
"), Icon,
    Diagram);
  block GovernorSimple "Simple governor for constant turbine power"

    parameter Boolean par=true "p parameter or initialised?"   annotation(evaluate=true,
      choices(choice=true "parameter", choice=false "initialised"));
    parameter SIpu.Power p(unit="pu", fixed=par)=1 "turbine power"
                                                annotation(Dialog(enable=par));
    Modelica.Blocks.Interfaces.RealInput speed(redeclare type SignalType =
          SIpu.AngularVelocity, final unit="pu") "speed of turbine pu"
      annotation (
            extent=[-70,-110; -50,-90],   rotation=90);
    Modelica.Blocks.Interfaces.RealOutput power(redeclare type SignalType =
          SIpu.Power, final unit="pu") "power of turbine pu"
      annotation (
            extent=[50,-110; 70,-90],   rotation=-90);
    annotation (defaultComponentName = "governor",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
     Text(
    extent=[-52,32; 48,-28],
    string="simp",
    style(color=10, thickness=2)),
       Rectangle(extent=[-80,60; 80,-60],   style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=7,
            rgbfillColor={255,255,255})),
     Text(
    extent=[-52,32; 48,-28],
    string="simp",
    style(color=10, thickness=2)),
       Text(
      extent=[-100,140; 100,100],
      string="%name",
      style(color=0))),
      Documentation(
              info="<html>
<p>Constant excitation-voltage.</p>
<p><tt>fieldVoltage=1</tt> corresponds to <tt>norm(v)=1 pu</tt> at open generator terminals.</p>
</html>
"),   Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Diagram(
  Rectangle(extent=[0,20; 20,0],   style(color=10, rgbcolor={95,95,95})),
  Line(points=[20,10; 60,10; 60,10; 60,-100],
                                         style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=77,
            rgbfillColor={127,0,255})),
  Text(
    extent=[0,20; 20,0],
          string="p_set",
          style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=77,
            rgbfillColor={127,0,255}))));

  equation
    power = p;
  end GovernorSimple;

  block GovernorConst "Governor for constant turbine power"
    extends Partials.GovernorBase;

    annotation (defaultComponentName = "governor",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
     Text(
    extent=[-52,32; 48,-28],
    style(color=10, thickness=2),
          string="const")),
      Documentation(
              info="<html>
<p>Constant turbine power (setpoint value).</p>
</html>
"),   Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Diagram);

  initial equation
    setptSpeed = speed;

  equation
    connect(setptPower, limiter.u)  annotation (points=[-100,-40; -26,-40; -26,
          0; 48,0],
                 style(color=74, rgbcolor={0,0,127}));
  end GovernorConst;

  block Governor1st "Governor first order"
    extends Partials.GovernorBase;

    parameter Real k=20 "Gain";
    parameter Real t=5 "time constant speed regulator";
  protected
    outer System system;
    final parameter Integer initType=if system.steadyIni then
           Modelica.Blocks.Types.Init.SteadyState else
           Modelica.Blocks.Types.Init.NoInit;
    Modelica.Blocks.Math.Add delta_speed(k2=-1)
                                   annotation (extent=[-70,-10; -50,10]);
    Modelica.Blocks.Continuous.TransferFunction speedReg(
      b={k},
      a={t,1},
      initType=initType)
              annotation (extent=[-30,-10; -10,10]);
    Modelica.Blocks.Math.Add delta_power
                            annotation (extent=[10,-10; 30,10]);
    annotation (defaultComponentName = "governor",
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
<p>First order control of turbine power.</p>
</html>
"),   Icon(
     Text(
    extent=[-60, 34; 60, -26],
    string="1st",
    style(color=10))),
      Diagram);

  equation
    connect(setptSpeed, delta_speed.u1)  annotation (points=[-100,40; -80,40;
          -80,6; -72,6], style(color=74, rgbcolor={0,0,127}));
    connect(speed, delta_speed.u2) annotation (points=[-60,-100; -60,-80; -80,
          -80; -80,-6; -72,-6],
                           style(color=74, rgbcolor={0,0,127}));
    connect(delta_speed.y, speedReg.u)
      annotation (points=[-49,0; -32,0], style(color=74, rgbcolor={0,0,127}));
    connect(speedReg.y, delta_power.u1) annotation (points=[-9,0; 0,0; 0,6; 8,6],
        style(color=74, rgbcolor={0,0,127}));
    connect(setptPower, delta_power.u2)  annotation (points=[-100,-40; 0,-40; 0,
          -6; 8,-6], style(color=74, rgbcolor={0,0,127}));
    connect(delta_power.y, limiter.u)
      annotation (points=[31,0; 48,0], style(color=74, rgbcolor={0,0,127}));
  end Governor1st;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    annotation (Documentation(info="<html>
</html>"));

  partial block GovernorBase "Governor base"
    extends Base.Icons.Block1;

    parameter SIpu.Power[2] p_minmax(unit="pu")={0,2} "{min,max} turbine power";
    protected
    outer System system;
    public
    Modelica.Blocks.Interfaces.RealInput setptPower(redeclare type SignalType
          =
          SIpu.Power, final unit="pu") "setpoint power pu"
      annotation (
            extent=[-110,-50; -90,-30],   rotation=0);
    Modelica.Blocks.Interfaces.RealInput setptSpeed(redeclare type SignalType
          =
          SIpu.AngularVelocity, final unit="pu") "setpoint speed pu"
      annotation (
            extent=[-110,30; -90,50],     rotation=0);
    Modelica.Blocks.Interfaces.RealInput speed(redeclare type SignalType =
          SIpu.AngularVelocity, final unit="pu") "turbine speed pu"
      annotation (
            extent=[-70,-110; -50,-90],   rotation=90);
    Modelica.Blocks.Interfaces.RealOutput power(redeclare type SignalType =
          SIpu.Power, final unit="pu") "turbine power pu"
      annotation (
            extent=[50,-110; 70,-90],   rotation=-90);
    Modelica.Blocks.Nonlinear.Limiter limiter(uMin=p_minmax[1], uMax=p_minmax[2])
      annotation (
            extent=[50,-10; 70,10]);
    annotation (defaultComponentName = "governor",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
</html>"),
        Diagram);

  equation
    connect(limiter.y, power)   annotation (points=[71,0; 80,0; 80,-80; 60,-80;
            60,-100],  style(color=74, rgbcolor={0,0,127}));
  end GovernorBase;
  end Partials;
end Governors;
