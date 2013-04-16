within Spot.ACdqo;
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
<p>Contains faults (shorts) phase to phase and phase to ground.</p>
<p>Terminology:</p>
<p><tt><b>Fault_*</b></tt>, example: <tt><b>Fault_abC</b></tt>:</p>
<p><tt>A B C </tt> denote a phase with (additional) fault to ground,<br>
<tt>a b c </tt> denote a phase with no fault to ground</p>
</html>"),
    Icon);

  model Short_ABC "a, b, c to ground short, 3-phase dqo"
    extends Partials.FaultBase;

    Real[3] s;
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
"),   Icon(
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
    v_pos = v_abc[n_phRef] > 0;

    {v,i} = if on then {epsR*s,s} else {s,epsG*s};
  end Short_ABC;

                model Fault_bc "b to c fault, 3-phase dqo"
    extends Partials.Fault_pp(final n_ph=1);

                annotation (defaultComponentName = "fault_bc",
                  Coordsys(
                      extent=[-100,-100; 100,100],
                      grid=[2,2],
                      component=[20,20]),
                  Window(
                      x=0.45,
                      y=0.01,
                      width=0.44,
                      height=0.65),
                  Documentation(
                          info="<html>
<p>Connect to 'fault'-terminal of faulted line.</p>
</html>
"),               Icon(
                      Ellipse(extent=[-30,60; -10,40], style(
                        color=0,
                        rgbcolor={0,0,0},
                        fillColor=61,
                        rgbfillColor={0,255,128})),
                      Ellipse(extent=[-30,20; -10,0], style(
                        color=0,
                        rgbcolor={0,0,0},
                        fillColor=1,
                        rgbfillColor={255,0,0})),
                      Ellipse(extent=[-30,-20; -10,-40], style(
                        color=0,
                        rgbcolor={0,0,0},
                        fillColor=1,
                        rgbfillColor={255,0,0}))));
                end Fault_bc;

  model Fault_ca "c to a fault, 3-phase dqo"
    extends Partials.Fault_pp(final n_ph=2);

  annotation (defaultComponentName = "fault_ca",
    Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Connect to 'fault'-terminal of faulted line.</p>
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
          fillColor=61,
          rgbfillColor={0,255,128})),
        Ellipse(extent=[-30,-20; -10,-40], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=1,
          rgbfillColor={255,0,0}))));
  end Fault_ca;

  model Fault_ab "a to b fault, 3-phase dqo"
    extends Partials.Fault_pp(final n_ph=3);

  annotation (defaultComponentName = "fault_ab",
    Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Connect to 'fault'-terminal of faulted line.</p>
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
          fillColor=61,
          rgbfillColor={0,255,128}))));
  end Fault_ab;

  model Fault_abc "a to b to c fault, 3-phase dqo"
    extends Partials.FaultBase;

    parameter Integer n_ph=1 "double connected phase, 2=(1-2,2-3)";
    replaceable Common.Switching.Short fault_pp1(
      v=v_abc[m_ph[1]] - v_abc[n_ph],
      i=i_abc[m_ph[1]],
      final on=on,
      final epsR=epsR,
      final epsG=epsG) "fault model" annotation (extent=[-60,-20; -20,20], choices(
         choice(redeclare Spot.Common.Switching.Short fault_pp1
            "short with small resistance"),
         choice(redeclare Spot.Common.Switching.Fault fault_pp1
            "fault with arc-model")));
    replaceable Common.Switching.Short fault_pp2(
      v=v_abc[m_ph[2]] - v_abc[n_ph],
      i=i_abc[m_ph[2]],
      final on=on,
      final epsR=epsR,
      final epsG=epsG) "fault model" annotation (extent=[20,-20; 60,20], choices(
         choice(redeclare Spot.Common.Switching.Short fault_pp2
            "short with small resistance"),
         choice(redeclare Spot.Common.Switching.Fault fault_pp2
            "fault with arc-model")));
  protected
    final parameter Integer[2] m_ph=pair[n_ph, :];
  annotation (defaultComponentName = "fault_abc",
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
<p>Connect to 'fault'-terminal of faulted line.</p>
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
        Rectangle(extent=[-40,-70; 0,-80], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=61,
          rgbfillColor={0,255,128}))),
    Diagram);

  equation
    v_pos = v_abc[n_phRef] > 0;
    i[3] = epsG*v[3];
  //  sum(i_abc) = epsG*sum(v_abc);
  end Fault_abc;

  model Fault_A "a to ground fault, 3-phase dqo"
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
  Ellipse(extent=[-30,60; -10,40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,20; -10,0], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,-20; -10,-40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128}))));
  end Fault_A;

  model Fault_B "b to ground fault, 3-phase dqo"
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
  Ellipse(extent=[-30,60; -10,40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,20; -10,0], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,-20; -10,-40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128}))));
  end Fault_B;

  model Fault_C "c to ground fault, 3-phase dqo"
    extends Partials.Fault_pg(final n_ph=3);

    annotation (defaultComponentName = "fault_C",
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
  Ellipse(extent=[-30,60; -10,40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,20; -10,0], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,-20; -10,-40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_C;

  model Fault_bC "b to c to ground fault, 3-phase dqo"
    extends Partials.Fault_ppg(final n_ph=1);

    annotation (defaultComponentName = "fault_bC",
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
  Ellipse(extent=[-30,60; -10,40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,20; -10,0], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,-20; -10,-40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_bC;

  model Fault_cA "c to a to ground fault, 3-phase dqo"
    extends Partials.Fault_ppg(final n_ph=2);

    annotation (defaultComponentName = "fault_cA",
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
  Ellipse(extent=[-30,60; -10,40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0})),
  Ellipse(extent=[-30,20; -10,0], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=61,
            rgbfillColor={0,255,128})),
  Ellipse(extent=[-30,-20; -10,-40], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))));
  end Fault_cA;

  model Fault_aB "a to b to ground fault, 3-phase dqo"
    extends Partials.Fault_ppg(final n_ph=3);

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
            fillColor=61,
            rgbfillColor={0,255,128}))));
  end Fault_aB;

  model Fault_Abc "b to a, c to a, a to ground fault, 3-phase dqo"
    extends Partials.Fault_pppg(final n_ph=1);

    annotation (defaultComponentName = "fault_Abc",
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
"),   Icon);
  end Fault_Abc;

  model Fault_aBc "a to b, c to b, b to ground fault, 3-phase dqo"
    extends Partials.Fault_pppg(final n_ph=2);

    annotation (defaultComponentName = "fault_aBc",
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
"),   Icon);
  end Fault_aBc;

  model Fault_abC "a to c, b to c, c to ground fault, 3-phase dqo"
    extends Partials.Fault_pppg(final n_ph=3);

    annotation (defaultComponentName = "fault_abC",
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
"),   Icon);
  end Fault_abC;

  package Partials "Partial models"
    extends Base.Icons.Partials;
    annotation (
          Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]), Window(
  x=0.05,
  y=0.44,
  width=0.31,
  height=0.26,
  library=1,
  autolayout=1));

    partial model FaultBase "Line fault base, 3-phase dqo"
      extends Ports.Port_f;

      parameter SI.Time t_on=0.1 "approx time fault on";
      parameter SIpu.Angle_deg phi_on(min=0)=0 "voltage phase angle fault on";
      parameter Integer n_phRef(min=1,max=3)=1 "of reference phase"
                                                            annotation(choices(
        choice=1 "phase a",
        choice=2 "phase b",
        choice=3 "phase c"));
      parameter SI.Resistance epsR=1e-4 "resistance 'fault'";
      parameter SI.Conductance epsG=1e-4 "conductance 'no fault'";
      SI.Voltage[3] v "voltage";
      SI.Current[3] i "current";
      SI.Voltage[3] v_abc(each stateSelect=StateSelect.never)
        "voltage phase a, b, c";
      SI.Current[3] i_abc(each stateSelect=StateSelect.never)
        "current phase a, b, c";
    protected
      constant Integer[3, 2] pair=[2, 3; 3, 1; 1, 2];
      discrete SI.Angle theta_zero(start=Modelica.Constants.inf, fixed=true);
      Boolean on(final start=false, fixed=true);
      Boolean v_pos(start=true, fixed=true);
      Boolean first(start=true, fixed=true);
      Real[3,3] Park = Base.Transforms.park(term.theta[2]);
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
<p>The small parameter epsG is used to define voltage on the faulted line in particular when the line is disconnected from its sources. For disconnecting switches with zero 'open' conductivity, epsG can not be set to zero.</p>
<p>Terminology:<br>
- lower case a, b, c:     shorted phase to phase<br>
- upper case A, B, C:     shorted phase to ground</p>
</html>
"),     Diagram,
        Icon(
          Rectangle(
            extent=[-40,80; 40,-80], style(
              color=62,
              rgbcolor={0,120,120},
              thickness=2,
              gradient=0,
              fillColor=9,
              rgbfillColor={175,175,175},
              fillPattern=1)),
          Line(
       points=[38,78; 2,-12; 38,12; 2,-78],    style(color=6, thickness=
         2))));

    equation
      v = term.v;
      term.i = i;
      v = Park*v_abc;
      i_abc = transpose(Park)*i;

      when time > t_on and edge(v_pos) and pre(first) then
        theta_zero = sum(term.theta);
        first = false;
      end when;
      on = sum(term.theta) > pre(theta_zero) + 2*pi*phi_on/360;
    end FaultBase;

    partial model Fault_pp "Two-phase fault, 3-phase dqo"
      extends FaultBase(final n_phRef=n_ph);

      parameter Integer n_ph(min=1,max=3)=1 "faulted pair"
                                       annotation (extent=[-20,-20; 20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pp
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pp
              "fault with arc-model")));
      replaceable Common.Switching.Short fault_pp(
        final v=v_abc[m_ph[1]] - v_abc[m_ph[2]],
        final i=i_abc[m_ph[1]],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[-20,-20; 20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pp
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pp
              "fault with arc-model")));
    //extends Common.Switching.Partials.FaultBase
    protected
      final parameter Integer[2] m_ph=pair[n_ph, :];

    equation
      v_pos = v_abc[m_ph[1]] - v_abc[m_ph[2]] > 0;
      i_abc[n_ph] = epsG*v_abc[n_ph];
      sum(i_abc[m_ph]) = epsG*sum(v_abc[m_ph]);
    end Fault_pp;

    partial model Fault_pg "One-phase to ground fault, 3-phase dqo"
      extends FaultBase(final n_phRef=n_ph);

      parameter Integer n_ph(min=1,max=3)=1 "faulted phase" annotation(choices(
        choice=1 "phase a",
        choice=2 "phase b",
        choice=3 "phase c"));
      replaceable Common.Switching.Short fault_pg(
        final v=v_abc[n_ph],
        final i=i_abc[n_ph],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model"
           annotation (extent=[-20,-20; 20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pg
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pg
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
           annotation (extent=[-20,-20; 20,20]);
    protected
      final parameter Integer[2] m_ph=pair[n_ph, :];
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
        Icon(
     Rectangle(extent=[-40,-70; 0,-80], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0},
              fillPattern=1))));

    equation
      v_pos = v_abc[n_phRef] > 0;
      i_abc[m_ph] = epsG*v_abc[m_ph];
    end Fault_pg;

    partial model Fault_ppg "Two-phase to ground fault, 3-phase dqo"
      extends FaultBase(final n_phRef=n_ph);

      parameter Integer n_ph(min=1,max=3)=1 "faulted pair" annotation(choices(
        choice=1 "phase bc",
        choice=2 "phase ca",
        choice=3 "phase ab"));
      replaceable Common.Switching.Short fault_pp(
        final v=v_abc[m_ph[1]] - v_abc[m_ph[2]],
        final i=i_abc[m_ph[1]],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[-60,-20; -20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pp
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pp
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
      replaceable Common.Switching.Short fault_pg(
        final v=v_abc[m_ph[2]],
        final i=sum(i_abc[m_ph]),
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[20,-20; 60,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pg
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pg
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
    protected
      final parameter Integer[2] m_ph=pair[n_ph, :];
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
        Icon(
     Rectangle(extent=[-40,-70; 0,-80], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0}))));

    equation
      v_pos = v_abc[m_ph[1]] - v_abc[m_ph[2]] > 0;
      i_abc[n_ph] = epsG*v_abc[n_ph];
    end Fault_ppg;

    partial model Fault_pppg "Three-phase to ground fault, 3-phase dqo"
      extends FaultBase;

      parameter Integer n_ph(min=1,max=3)=1 "which phase to ground" annotation(choices(
        choice=1 "phase a",
        choice=2 "phase b",
        choice=3 "phase c"));
      replaceable Common.Switching.Short fault_pp1(
        final v=v_abc[m_ph[1]] - v_abc[n_ph],
        final i=i_abc[m_ph[1]],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[-80,-20; -40,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pp1
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pp1
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
      replaceable Common.Switching.Short fault_pp2(
        final v=v_abc[m_ph[2]] - v_abc[n_ph],
        final i=i_abc[m_ph[2]],
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[-20,-20; 20,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pp2
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pp2
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
      replaceable Common.Switching.Short fault_pg(
        final v=v_abc[n_ph],
        final i=sum(i_abc),
        final on=on,
        final epsR=epsR,
        final epsG=epsG) "fault model" annotation (extent=[40,-20; 80,20], choices(
           choice(redeclare Spot.Common.Switching.Short fault_pg
              "short with small resistance"),
           choice(redeclare Spot.Common.Switching.Fault fault_pg
              "fault with arc-model")));
    //  extends Common.Switching.Partials.FaultBase
    protected
      final parameter Integer[2] m_ph=pair[n_ph, :];
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
        Icon(
          Ellipse(
          extent=[-30,60; -10,40], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0})),
          Ellipse(
          extent=[-30,20; -10,0], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0})),
          Ellipse(
          extent=[-30,-20; -10,-40], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0})),
          Rectangle(
            extent=[-40,-70; 0,-80], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=1,
              rgbfillColor={255,0,0}))));

    equation
      v_pos = v_abc[n_ph] > 0;
    end Fault_pppg;
  end Partials;

end Faults;
