within Spot.AC1_DC;

package Faults "Line-faults "
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
<p> Contains faults (shorts) conductor to conductor and conductor to ground.</p>
<p> Terminology:</p>
<p><tt><b>Fault_*</b></tt>, example: <tt><b>Fault_Ab</b></tt>:</p>
<p><tt>A B</tt> denote a conductor with (additional) fault to ground,<br>
<tt>a b</tt> denote a conductor with no fault to ground</p>
<p>(The notation <tt>_pp</tt> ('phase-to-phase'), <tt>_pg</tt> ('phase-to-ground') etc is chosen in analogy to three-phase faults.)</p>
</html>
"), Icon);

  model Short_ABC "a, b, c to ground short, 3-phase abc"
    extends Partials.FaultBase;

    Real[2] s;
    annotation (
      defaultComponentName="short_ABC",
    Coordsys(
  extent=[-100,-100; 100,100],
  grid=[2,2],
  component=[40,40]),
    Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
    Documentation(
      info="<html>
<p>Fault acts on 'term' and connected terminals.</p>
<p>This all-phase short to ground acts directly on the non-transformed variables v and i.<br>
The transformation to inertial abc is only needed to determine the correct phase-angle.</p>
</html>
"), Icon(
  Ellipse(extent=[-30,60; -10,40], style(
    color=0,
    rgbcolor={0,0,0},
    fillColor=1,
    rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,20; -10,0], style(
    color=0,
    rgbcolor={0,0,0},
    fillColor=1,
    rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,-20; -10,-40], style(
    color=0,
    rgbcolor={0,0,0},
    fillColor=1,
    rgbfillColor={255,0,0})),
    Rectangle(
      extent=[-40,-70; 0,-80], style(
        color=0,
        rgbcolor={0,0,0},
        fillColor=1,
        rgbfillColor={255,0,0}))),
    Diagram);

  equation
    {v,i} = if on then {epsR*s,s} else {s,epsG*s};
  end Short_ABC;

  model Fault_ab "a to b fault, 1-phase"
    extends Partials.Fault_pp;

    annotation (defaultComponentName = "fault_ab",
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
<p>Connect to 'fault'-terminal of faulted line.</p>
</html>
"),   Icon(
  Ellipse(extent=[-30,50; -10,30],   style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,-10; -10,-30], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_ab;

  model Fault_A "a to ground fault, 1-phase"
    extends Partials.Fault_pg(final n_ph=1);

    annotation (defaultComponentName = "fault_A",
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
<p>Connect to 'fault'-terminal of faulted line.</p>
</html>
"),   Icon(
  Ellipse(extent=[-30,-10; -10,-30],
                                   style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,50; -10,30],   style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_A;

  model Fault_B "b to ground fault, 1-phase"
    extends Partials.Fault_pg(final n_ph=2);

    annotation (defaultComponentName = "fault_B",
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
<p>Connect to 'fault'-terminal of faulted line.</p>
</html>
"),   Icon(
  Ellipse(extent=[-30,50; -10,30], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,-10; -10,-30], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_B;

  model Fault_Ab "b to a to ground fault, 1-phase"
    extends Partials.Fault_ppg(final n_ph=1);

    annotation (defaultComponentName = "fault_Ab",
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
<p>Connect to 'fault'-terminal of faulted line.</p>
</html>
"),   Icon(
  Ellipse(extent=[-30,-10; -10,-30], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,50; -10,30],   style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_Ab;

  model Fault_aB "a to b to ground fault, 1-phase"
    extends Partials.Fault_ppg(final n_ph=2);

    annotation (defaultComponentName = "fault_aB",
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
<p>Connect to 'fault'-terminal of faulted line.</p>
</html>
"),   Icon(
  Ellipse(extent=[-30,-10; -10,-30], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,50; -10,30],   style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_aB;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    partial model FaultBase "Line fault base, 1-phase"
      extends Ports.Port_f;

      parameter SI.Frequency f=system.f_nom "frequency (when fault occurs)";
      parameter SI.Time t_on=0.1 "approx time fault on";
      parameter SIpu.Angle_deg phi_on(min=0)=0 "voltage phase angle fault on";
      parameter SI.Resistance epsR=1e-4 "resistance 'fault'";
      parameter SI.Conductance epsG=1e-4 "conductance 'no fault'";
      SI.Voltage[2] v;
      SI.Current[2] i;
      Boolean on(final start=false, fixed=true);
    protected
      outer System system;
      constant Integer[2] pair={2, 1};
      discrete SI.Angle t_zero(start=Modelica.Constants.inf, fixed=true);
      Boolean v_pos(start=true, fixed=true);
      Boolean first(start=true, fixed=true);
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
<p>The small parameter epsG is used to define voltage on the faulted line in particular when the line is disconnected from its sources. For disconnecting switches with zero 'open' conductivity, epsG can not be set to zero.</p>
<p>Terminology:<br>
- lower case p, n:     shorted conductor to conductor<br>
- upper case P, N:     shorted conductor to ground</p>
</html>"),
        Diagram,
        Icon(
          Rectangle(
            extent=[-40,80; 40,-80], style(
              color=3,
              rgbcolor={0,0,255},
              gradient=0,
              fillColor=9,
              rgbfillColor={175,175,175},
              fillPattern=1)),
          Line(
       points=[38,78; 2,-12; 38,12; 2,-78],    style(color=6, thickness=
         2))));

    equation
      v = term.pin.v;
      term.pin.i = i;

      v_pos = v[1] - v[2] > 0;
      when time > t_on and edge(v_pos) and pre(first) then
        t_zero = time;
        first = false;
      end when;
      on = time > pre(t_zero) + phi_on/(360*f);
    end FaultBase;

    partial model Fault_pp "Conductor to conductor fault, 1-phase"
      extends FaultBase;

      replaceable Common.Switching.Short fault_pp(
        final v=v[1] - v[2],
        final i=i[1],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[-20,-20; 20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pp
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pp
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
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
</html>
"),     Icon(
     Rectangle(extent=[-40,-70; 0,-80], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=61,
              rgbfillColor={0,255,128},
              fillPattern=1))));

    equation
      sum(i) = epsG*sum(v);
    end Fault_pp;

    partial model Fault_pg "Conductor to ground fault, 1-phase"
      extends FaultBase;

      parameter Integer n_ph(min=1,max=2)=1 "faulted phase" annotation(choices(
        choice=1 "phase a1",
        choice=2 "phase a2"));
      replaceable Common.Switching.Short fault_pg(
        final v=v[n_ph],
        final i=i[n_ph],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[-20,-20; 20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pg
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pg
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
           annotation (extent=[-20,-20; 20,20]);

    protected
      final parameter Integer m_ph=pair[n_ph];
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
</html>
"),     Icon(
     Rectangle(extent=[-40,-70; 0,-80], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0},
              fillPattern=1))));

    equation
      i[m_ph] = epsG*v[m_ph];
    end Fault_pg;

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
    partial model Fault_ppg "Conductor to conductor to ground fault, 1-phase"
      extends FaultBase;

      parameter Integer n_ph(min=1,max=2)=1 "which phase to ground" annotation(choices(
        choice=1 "phase a1",
        choice=2 "phase a2"));
      replaceable Common.Switching.Short fault_pp(
        final v=v[m_ph] - v[n_ph],
        final i=i[m_ph],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[-60,-20; -20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pp
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pp
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
      replaceable Common.Switching.Short fault_pg(
        final v=v[n_ph],
        final i=sum(i),
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[20,-20; 60,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pg
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pg
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
    protected
      final parameter Integer m_ph=pair[n_ph];
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
</html>
"),     Icon(
     Rectangle(extent=[-40,-70; 0,-80], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0},
              fillPattern=1))));

    end Fault_ppg;

  end Partials;

end Faults;
