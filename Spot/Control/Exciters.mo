within Spot.Control;
package Exciters "Generator Exciters "
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
  height=0.24,
  library=1,
  autolayout=1),
Documentation(info="<html>
</html>
"), Icon);

  block ExciterSimple "Simple exciter for constant field voltage"

    parameter Boolean par=true "v_f parameter or initialised?"   annotation(evaluate=true,
      choices(choice=true "parameter", choice=false "initialised"));
    parameter SIpu.Voltage v_f(unit="pu", fixed=par)=1 "exciter voltage"
                                                              annotation(Dialog(enable=par));
    Modelica.Blocks.Interfaces.RealInput termVoltage[3](redeclare type
        SignalType =
          SIpu.Voltage, final unit="pu") "terminal voltage pu"
      annotation (
            extent=[-70,-110; -50,-90],   rotation=90);
    Modelica.Blocks.Interfaces.RealOutput fieldVoltage(redeclare type
        SignalType =
          SIpu.Voltage, final unit="pu") "field voltage pu"
      annotation (
            extent=[50,-110; 70,-90],   rotation=-90);
    annotation (defaultComponentName = "exciter",
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
<p>Constant excitation-voltage.</p>
<p><tt>fieldVoltage=1</tt> corresponds to <tt>norm(v)=1 pu</tt> at open generator terminals.</p>
</html>
"),   Icon(
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
          string="v_f_set",
          style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=77,
            rgbfillColor={127,0,255}))));

  equation
    fieldVoltage = v_f;
  end ExciterSimple;

  block ExciterConst "Exciter for constant field voltage"
    extends Partials.ExciterBase;

    annotation (defaultComponentName = "exciter",
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
<p>Constant excitation-voltage (setpoint value).</p>
<p><tt>fieldVoltage=1</tt> corresponds to <tt>norm(v)=1 pu</tt> at open generator terminals.</p>
</html>
"),   Icon(
     Text(
    extent=[-60,34; 60,-26],
    style(color=10),
          string="const")),
      Diagram);

  equation
    connect(setptVoltage, limiter.u)
      annotation (points=[-100,0; 48,0], style(color=74, rgbcolor={0,0,127}));
  end ExciterConst;

  block Exciter1st "Exciter first order"
    extends Partials.ExciterBase;

    parameter Real k=50 "gain";
    parameter SI.Time t=0.005 "time constant voltage regulator";
  protected
    outer System system;
    final parameter Integer initType=if system.steadyIni then
           Modelica.Blocks.Types.Init.SteadyState else
           Modelica.Blocks.Types.Init.NoInit;
    Blocks.Math.Norm norm(final n=3, n_eval=3)
      annotation (
            extent=[-70,-80; -50,-60], rotation=90);
    Modelica.Blocks.Math.Add delta_voltage(k1=+1, k2=-1)
      annotation (
            extent=[-70,-10; -50,10]);
    Modelica.Blocks.Continuous.TransferFunction voltageReg(b={k}, a={t,1},
      initType=initType)
      annotation (
            extent=[-30,-10; -10,10]);
    annotation (defaultComponentName = "exciter",
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
<p>First order control of excitation-voltage.</p>
<p><tt>fieldVoltage=1</tt> corresponds to <tt>norm(v)=1 pu</tt> at open generator terminals.</p>
</html>
"),   Icon(
     Text(
    extent=[-60, 34; 60, -26],
    string="1st",
    style(color=10))),
      Diagram);

  equation
    connect(setptVoltage, delta_voltage.u1)  annotation (points=[-100,0; -80,0;
          -80,6; -72,6], style(color=74, rgbcolor={0,0,127}));
    connect(termVoltage, norm.u) annotation (points=[-60,-100; -60,-80], style(
          color=74, rgbcolor={0,0,127}));
    connect(norm.y, delta_voltage.u2) annotation (points=[-60,-60; -60,-40; -80,
          -40; -80,-6; -72,-6], style(color=74, rgbcolor={0,0,127}));
    connect(delta_voltage.y, voltageReg.u)
      annotation (points=[-49,0; -32,0], style(color=74, rgbcolor={0,0,127}));
    connect(voltageReg.y, limiter.u)
      annotation (points=[-9,0; 48,0], style(color=74, rgbcolor={0,0,127}));
  end Exciter1st;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    annotation (Documentation(info="<html>
</html>"));

  partial block ExciterBase "Exciter base"
    extends Base.Icons.Block1;

    parameter SIpu.Voltage[2] v_f_minmax(unit="pu")={0, 3}
        "{min,max} exciter voltage";
    protected
    outer System system;
    public
    Modelica.Blocks.Interfaces.RealInput setptVoltage(redeclare type SignalType
          =
          SIpu.Voltage, final unit="pu") "setpoint norm of terminal voltage pu"
      annotation (
            extent=[-110,-10; -90,10],    rotation=0);
    Modelica.Blocks.Interfaces.RealInput termVoltage[3](redeclare type
          SignalType =
          SIpu.Voltage, final unit="pu") "terminal voltage pu"
      annotation (
            extent=[-70,-110; -50,-90],   rotation=90);
    Modelica.Blocks.Interfaces.RealOutput fieldVoltage(redeclare type
          SignalType =
          SIpu.Voltage, final unit="pu") "field voltage pu"
      annotation (
            extent=[50,-110; 70,-90],   rotation=-90);
    Modelica.Blocks.Nonlinear.Limiter limiter(uMin=v_f_minmax[1],uMax=v_f_minmax[2])
      annotation (
            extent=[50,-10; 70,10]);
    annotation (defaultComponentName = "exciter",
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
</html>"),
      Icon,
      Diagram);

  equation
    connect(limiter.y, fieldVoltage) annotation (points=[71,0; 80,0; 80,-80; 60,
            -80; 60,-100], style(color=74, rgbcolor={0,0,127}));
  end ExciterBase;
  end Partials;
end Exciters;
