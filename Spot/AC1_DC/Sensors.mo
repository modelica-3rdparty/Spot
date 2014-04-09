within Spot.AC1_DC;

package Sensors "Sensors n-phase or DC"
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
<p>Sensors directly output terminal signals (voltage, current, power).</p>
<p>Meters allow choosing base-units for output variables.</p>
</html>"), Icon);

  model VdiffSensor "Voltage difference sensor, 1-phase"
    extends Partials.Sensor1Base;

    Modelica.Blocks.Interfaces.RealOutput v(redeclare type SignalType = SI.Voltage)
      "difference voltage 'plus' - 'minus'"
    annotation (
          extent=[-10,90; 10,110],   rotation=90);
    annotation (defaultComponentName = "Vsensor1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
  Rectangle(extent=[-20, 24; 20, 20], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175}))),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>"),
      Diagram);

  equation
    v = term.pin[1].v - term.pin[2].v;
  end VdiffSensor;

  model IdiffSensor "Current difference sensor, 1-phase"
    extends Partials.Sensor2Base;

    Modelica.Blocks.Interfaces.RealOutput i(redeclare type SignalType = SI.Current)
      "current ('plus' - 'minus')/2, term_p to term_n"
      annotation (
            extent=[-10, 90; 10, 110], rotation=90);
    annotation (defaultComponentName = "Isensor1",
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
</html>"),   Icon(
  Ellipse(extent=[-20,20; 20,-20], style(color=10, rgbcolor={135,135,135})),
  Line(points=[0, 20; 0, 90], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175}))),
      Diagram);

  equation
    i = 0.5*(term_p.pin[1].i - term_p.pin[2].i);
  end IdiffSensor;

  model Vsensor "Voltage sensor, 1-phase"
    extends Partials.Sensor1Base;

    Modelica.Blocks.Interfaces.RealOutput[2] v(redeclare type SignalType = SI.Voltage)
      "voltage 'plus' and 'minus'-to-ground"
    annotation (
          extent=[-10,90; 10,110],   rotation=90);
    annotation (defaultComponentName = "Vsensor1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
  Rectangle(extent=[-20, 24; 20, 20], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-20,50; 20,70],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-20,40; 20,60],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175}))),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>"),
      Diagram);

  equation
    v = term.pin.v;
  end Vsensor;

  model Isensor "Current sensor, 1-phase"
    extends Partials.Sensor2Base;

    Modelica.Blocks.Interfaces.RealOutput[2] i(redeclare type SignalType = SI.Current)
      "current 'plus' and 'minus', term_p to term_n"
      annotation (
            extent=[-10, 90; 10, 110], rotation=90);
    annotation (defaultComponentName = "Isensor1",
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
</html>"),   Icon(
  Ellipse(extent=[-20,20; 20,-20], style(color=10, rgbcolor={135,135,135})),
  Line(points=[0, 20; 0, 90], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-20,50; 20,70],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-20,40; 20,60],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175}))),
      Diagram);

  equation
    i = term_p.pin.i;
  end Isensor;

  model Psensor "Power sensor, 1-phase"
    extends Partials.Sensor2Base;

    Modelica.Blocks.Interfaces.RealOutput p(redeclare type SignalType = SI.Power)
      "power, term_p to term_n"
      annotation (
            extent=[-10, 90; 10, 110], rotation=90);
   annotation (defaultComponentName = "Psensor1",
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
      Icon(
  Ellipse(extent=[-20,20; 20,-20], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
  Line(points=[0,0; 20,0], style(color=3, rgbcolor={0,0,255}))),
      Diagram);

  equation
    p = term_p.pin.v*term_p.pin.i;
  end Psensor;

  model Vmeter "Voltage meter, 1-phase"
    extends Partials.Meter1Base(final S_nom=1);

    output SIpu.Voltage v(stateSelect=StateSelect.never);
    output SIpu.Voltage v0(stateSelect=StateSelect.never);
  protected
    SIpu.Voltage[2] v_ab(each stateSelect=StateSelect.never);
    final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);
    annotation (defaultComponentName = "Vmeter1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
     Rectangle(extent=[-20, 24; 20, 20], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-15,45; 15,59],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-15,35; 15,49],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175}))),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals both in SI-units or in 'pu'.
Use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variables:</p>
<pre>
  v      difference voltage 'plus' - 'minus'
  v0     average voltage ('plus' + 'minus')/2
</pre>
</html>"),   Diagram);

  equation
    v_ab = term.pin.v/V_base;

    v = v_ab[1] - v_ab[2];
    v0 = (v_ab[1] + v_ab[2])/2;
  end Vmeter;

  model Imeter "Current meter, 1-phase"
    extends Partials.Meter2Base;

    output SIpu.Current i(stateSelect=StateSelect.never);
    output SIpu.Current i0(stateSelect=StateSelect.never);
  protected
    SIpu.Current[2] i_ab(each stateSelect=StateSelect.never);
    final parameter SI.Current I_base=Base.Precalculation.baseI(units, V_nom, S_nom);
    annotation (defaultComponentName = "Imeter1",
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
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals both in SI-units or in 'pu'.
Use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variables:</p>
<pre>
  i     current term_p to term_n, ('plus' - 'minus')/2</pre>
  i0    sum current term_p to term_n, 'plus' + 'minus'
</html>"),
      Icon(
     Ellipse(extent=[-20, 20; 20, -20], style(color=10, rgbcolor={135,135,135})),
      Line(
   points=[-15,45; 15,59],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-15,35; 15,49],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175}))));

  equation
    i_ab = term_p.pin.i/I_base;

    i = (i_ab[1] - i_ab[2])/2;
    i0 = (i_ab[1] + i_ab[2]);
  end Imeter;

  model Pmeter "Power meter, 1-phase"

    parameter Boolean av=false "time average power"
                                   annotation(Evaluate=true,Dialog(group="Options"));
    parameter SI.Time tcst(min=1e-9)=1 "average time-constant"
                                                    annotation(Evaluate=true, Dialog(group="Options",enable=av));
    extends Partials.Meter2Base(final V_nom=1);

    output SIpu.Power p(stateSelect=StateSelect.never);
    output SIpu.Power p_av=pav if av;
  protected
    outer System system;
    final parameter SI.ApparentPower S_base=Base.Precalculation.baseS(units, S_nom);
    SIpu.Power pav;
    annotation (defaultComponentName = "Pmeter1",
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
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals both in SI-units or in 'pu'.
Use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variable:</p>
<pre>  p     power term_p to term_n</pre>
</html>"),
      Icon(
  Ellipse(extent=[-20,20; 20,-20], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
  Line(points=[0,0; 20,0], style(color=3, rgbcolor={0,0,255}))));

  initial equation
    if av then
      pav = p;
    end if;

  equation
    p = (term_p.pin.v*term_p.pin.i)/S_base;
    if av then
      der(pav) = (p - pav)/tcst;
    else
      pav = 0;
    end if;
  end Pmeter;

  model PVImeter "Power-voltage-current meter, 1-phase"

    parameter Boolean av=false "time average power"
                                   annotation(Evaluate=true,Dialog(group="Options"));
    parameter SI.Time tcst(min=1e-9)=1 "average time-constant"
                                                    annotation(Evaluate=true, Dialog(group="Options",enable=av));
    extends Partials.Meter2Base;
    output SIpu.Power p(stateSelect=StateSelect.never);
    output SIpu.Power p_av=pav if av;
    output SIpu.Voltage v(stateSelect=StateSelect.never);
    output SIpu.Voltage v0(stateSelect=StateSelect.never);
    output SIpu.Current i(stateSelect=StateSelect.never);
    output SIpu.Current i0(stateSelect=StateSelect.never);
  protected
    outer System system;
    final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);
    final parameter SI.Current I_base=Base.Precalculation.baseI(units, V_nom, S_nom);
    SIpu.Power pav;
    SIpu.Voltage[2] v_ab;
    SIpu.Current[2] i_ab;
    annotation (defaultComponentName = "PVImeter1",
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
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals both in SI-units or in 'pu'.
Use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variables:</p>
<pre>
  p     power term_p to term_n
  v     difference voltage 'plus' - 'minus'
  v0    average voltage ('plus' + 'minus')/2
  i     current term_p to term_n, ('plus' - 'minus')/2</pre>
  i0    sum current term_p to term_n, 'plus' + 'minus'
</pre>
</html>"),
      Icon(
  Ellipse(extent=[-20,20; 20,-20], style(color=10, rgbcolor={135,135,135})),
  Ellipse(extent=[-8,8; 8,-8], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
  Line(points=[0,0; 20,0], style(color=3, rgbcolor={0,0,255})),
      Line(
   points=[-15,45; 15,59],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175})),
      Line(
   points=[-15,35; 15,49],
                        style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=9,
            rgbfillColor={175,175,175}))));

  initial equation
    if av then
      pav = p;
    end if;

  equation
    v_ab = term_p.pin.v/V_base;
    i_ab = term_p.pin.i/I_base;
    v = v_ab[1] - v_ab[2];
    v0 = (v_ab[1] + v_ab[2])/2;
    i = (i_ab[1] - i_ab[2])/2;
    i0 = (i_ab[1] + i_ab[2]);
    p = v_ab*i_ab;
    if av then
      der(pav) = (p - pav)/tcst;
    else
      pav = 0;
    end if;
  end PVImeter;

  model Efficiency "Power sensor, 3-phase dqo"
    extends Partials.Sensor2Base;

    Base.Interfaces.ThermalV_p heat(m=m) "vector heat port"
    annotation (extent=[-10,90; 10,110],     rotation=270);
    parameter Boolean dir_in=true "direction" annotation(evaluate=true, choices(
      choice=true "points into the component",
      choice=false "point out of the component"));
    parameter Integer m(final min=1)=1 "dimension of heat port";
    parameter Boolean av=false "time average efficiency" annotation(evaluate=true,Dialog(group="Options"));
    parameter SI.Time tcst(min=1e-9)=1 "average time-constant"
      annotation(Evaluate=true, Dialog(group="Options",enable=av));
    parameter SI.Temperature T_amb=300 "ambient temperature";
    output Real eta "efficiency";
  protected
    SI.Power p "total el power, term_p to term_n";
    SI.HeatFlowRate q "total heat flow 'in'";
    SI.Power pav(start=1);
    SI.HeatFlowRate qav(start=1);

    annotation (
      defaultComponentName="efficiency",
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
<p>Measures the electric power <tt>p</tt> flowing from 'term_p' to 'term_n' and the total heat inflow <tt>q</tt> at term 'heat'. The efficiency eta in % is then defined by
<pre>
  eta = 100*(p - q)/p     if arrow points into the measured component and q &lt  abs(p)
  eta = 100*p/(p + q)     if arrow points out of the measured component and q &lt  abs(p)
  eta = 0                 else
</pre>
Positive values of eta indicate powerflow in direction of arrow,
negative values of eta indicate powerflow against direction of arrow.</p>
<p>Note: Take care about the above definitions if approximations are used in measured components.<br>
In problematic cases use power sensors electrical and mechanical.</p>
</html>"),
  Icon(Ellipse(extent=[-20,20; 20,-20], style(
          color=42,
          rgbcolor={176,0,0},
          fillColor=42,
          rgbfillColor={176,0,0})), Line(points=[0,0; 20,0], style(color=3,
              rgbcolor={0,0,255}))),
  Diagram);

  initial equation
    if av then
      pav = p;
      qav = q;
    end if;

  equation
    heat.port.T = fill(T_amb, heat.m);
    p = term_p.pin.v*term_p.pin.i;
    q = sum(heat.port.Q_flow);

    if av then
      der(pav) = (p - pav)/tcst;
      der(qav) = (q - qav)/tcst;
    else
      pav = p;
      qav = q;
    end if;

    if qav < abs(pav) then
      if dir_in then
        eta = if pav > 0 then 100*(pav - qav)/pav else -100*pav/(pav - qav);
      else
        eta = if pav > 0 then 100*pav/(pav + qav) else -100*(pav + qav)/pav;
      end if;
    else
      eta = 0;
    end if;
  end Efficiency;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    partial model Sensor1Base "Sensor Base, 1-phase"
      extends Ports.Port_p;

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
</html>"),
        Icon(
          Ellipse(
          extent=[-70,70; 70,-70], style(
              color=7,
              rgbcolor={255,255,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
        Line(
     points=[-88,0; 40,0], style(color=3, rgbcolor={0,0,255})),
        Line(
     points=[0,20; 0,90], style(color=10, rgbcolor={135,135,135}))));

    equation
      term.pin.i = zeros(2);
    end Sensor1Base;

    partial model Sensor2Base "Sensor Base, 1-phase"
      extends Ports.Port_pn;

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
</html>"),
        Icon(
          Ellipse(
          extent=[-70,70; 70,-70], style(
              color=7,
              rgbcolor={255,255,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
        Line(
     points=[0,20; 0,90], style(color=10, rgbcolor={135,135,135})),
        Line(
     points=[-88,0; -20,0], style(color=3, rgbcolor={0,0,255})),
        Line(
     points=[0,0; 88,0], style(color=3, rgbcolor={0,0,255})),
        Line(
     points=[30,20; 70,0; 30,-20], style(color=3, rgbcolor={0,0,255}))));

    equation
      term_p.pin.v = term_n.pin.v;
    end Sensor2Base;

    partial model Meter1Base "Meter base 1 terminal, 1-phase"
      extends Sensor1Base;
      extends Base.Units.Nominal;

      annotation (
        Coordsys(
          extent=
         [-100, -100; 100, 100],
          grid=
       [2, 2],
          component=
            [40, 40]),
        Window(
          x=
    0.45, y=
    0.01, width=
        0.44,
          height=
         0.65),
        Documentation(
              info="<html>
</html>"),
        Icon(Ellipse(extent=[-70,70; 70,-70], style(color=10, rgbcolor={135,135,
                  135}))),
        Diagram);
    end Meter1Base;

    partial model Meter2Base "Meter base 2 terminal, 1-phase"
      extends Sensor2Base;
      extends Base.Units.Nominal;

      annotation (Icon(
             Ellipse(extent=[-70,70; 70,-70], style(color=10, rgbcolor={135,135,
                  135}))));
    end Meter2Base;

    annotation (
          Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]), Window(
  x=0.05,
  y=0.44,
  width=0.31,
  height=0.23,
  library=1,
  autolayout=1));
  end Partials;
end Sensors;
