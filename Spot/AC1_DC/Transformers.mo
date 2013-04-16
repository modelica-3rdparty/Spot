within Spot.AC1_DC;

package Transformers "Transformers 1-phase "
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
<p>One-phase transformer models in different abstraction levels.</p>
</html>
"),
  Icon);

  model TrafoIdeal "Ideal transformer, 1-phase"
    extends Partials.TrafoIdealBase;

  annotation (
    defaultComponentName="trafo",
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
<p>Ideal magnetic coupling, no stray-impedance, zero magnetisation current.</p>
</html>
"),   Icon,
      Diagram);

  equation
    i1 + i2 = 0;
    v1 = v2;
  end TrafoIdeal;

  model TrafoStray "Ideal magnetic coupling transformer, 1-phase"
    extends Partials.TrafoStrayBase;

  annotation (
    defaultComponentName="trafo",
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
<p>Stray-impedance, but ideal magnetic coupling, i.e. zero magnetisation current.</p>
<p>SI-input: values for stray and coupling impedances winding dependent.</p>
<pre>
  r[k] = R[k]
  x[k] = omega_nom*L[k]
</pre>
<p>pu-input: values for stray and coupling impedances winding-reduced to primary side.</p>
<pre>
  r[k] = R[k]/R_nom[k]
  x[k] = omega_nom*L[k]/R_nom[k]
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
</html>
"),   Icon(Rectangle(extent=[-10,62; 10,-62], style(
      color=30,
      rgbcolor={215,215,215},
      fillColor=30,
      rgbfillColor={215,215,215}))),
      Diagram);

  equation
    i1 + i2 = 0;
    sum(L)*der(i1) + sum(R)*i1 = v1 - v2;
  end TrafoStray;

  model TrafoMag "Magnetic coupling transformer, 1-phase"
    extends Partials.TrafoMagBase;

    SI.Voltage v0;
    SI.Current imag;
    SI.Current iedc;
  Real psi0 "unsaturated flux";
  annotation (
    defaultComponentName="trafo",
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
<p>Stray-impedance and resistance, with non-ideal magnetic coupling, i.e. non-zero magnetisation current
and eddy current losses.</p>
<p>SI-input: values for stray and coupling impedances winding dependent.</p>
<pre>
  r[k] = R[k]
  x[k] = omega_nom*L[k]
  redc = Redc
  xm   = omega_nom*Lm
</pre>
<p>pu-input: values for stray and coupling impedances winding-reduced to primary side.</p>
<pre>
  r[k] = R[k]/R_nom[k]
  x[k] = omega_nom*L[k]/R_nom[k]
  redc = Redc/sqrt(R_nom[1]*R_nom[2])
  xm = omega_nom*Lm/sqrt(R_nom[1]*R_nom[2])
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
</html>
"),   Icon(
  Rectangle(extent=[-10,62; 10,-62], style(
      color=30,
      rgbcolor={215,215,215},
      fillColor=30,
      rgbfillColor={215,215,215})),
  Line(points=[-20,62; -20,-62], style(
            color=69,
            rgbcolor={0,128,255},
            pattern=3,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
  Line(points=[20,62; 20,-62], style(
            color=69,
            rgbcolor={0,128,255},
            pattern=3,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
  Ellipse(extent=[-22,62; -18,58], style(
            color=69,
            rgbcolor={0,128,255},
            fillColor=69,
            rgbfillColor={0,128,255})),
  Ellipse(extent=[18,-58; 22,-62], style(
            color=69,
            rgbcolor={0,128,255},
            fillColor=69,
            rgbfillColor={0,128,255}))),
      Diagram);

  equation
    i1 + i2 = imag + iedc;
    Redc*iedc = v0;
  psi0 = Lm*imag;
    L[1]*der(i1) + R[1]*i1 = v1 - v0;
    L[2]*der(i2) + R[2]*i2 = v2 - v0;
    Lm*der(imag) = v0;
  end TrafoMag;

  model TrafoSat "Saturation transformer, 1-phase"
    extends Partials.TrafoSatBase;

    SI.Voltage v0;
    SI.Current imag;
    SI.Current iedc;
  protected
    Real psi0 "unsaturated flux";
    Real g;
    function der_sat = Common.IronSaturation.der_saturationAnalytic;
  annotation (
    defaultComponentName="trafo",
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
<p>Stray-impedance and resistance, with non-ideal magnetic coupling, i.e. non-zero magnetisation current, eddy current losses and saturation.</p>
<p>SI-input: values for stray and coupling impedances winding dependent.</p>
<pre>
  r[k] = R[k]
  x[k] = omega_nom*L[k]
  redc = Redc
  xm   = omega_nom*Lm
  xm_sat = omega_nom*Lm_sat,  saturation value of inductance
  psi_sat, pu saturation value of flux (no SI-value!)
</pre>
<p>pu-input: values for stray and coupling impedances winding-reduced to primary side.</p>
<pre>
  r[k] = R[k]/R_nom[k]
  x[k] = omega_nom*L[k]/R_nom[k]
  redc = Redc/sqrt(R_nom[1]*R_nom[2])
  xm = omega_nom*Lm/sqrt(R_nom[1]*R_nom[2])
  xm_sat = omega_nom*Lm_sat/sqrt(R_nom[1]*R_nom[2]),  saturation value of inductance
  psi_sat, pu saturation value of flux
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
</html>
"),   Icon(
  Rectangle(extent=[-10,62; 10,-62], style(
      color=30,
      rgbcolor={215,215,215},
      fillColor=30,
      rgbfillColor={215,215,215})),
  Line(points=[-20,62; -20,-62], style(
            color=69,
            rgbcolor={0,128,255},
            pattern=3,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
  Line(points=[20,62; 20,-62], style(
            color=69,
            rgbcolor={0,128,255},
            pattern=3,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
  Ellipse(extent=[-22,62; -18,58], style(
            color=69,
            rgbcolor={0,128,255},
            fillColor=69,
            rgbfillColor={0,128,255})),
  Ellipse(extent=[18,-58; 22,-62], style(
            color=69,
            rgbcolor={0,128,255},
            fillColor=69,
            rgbfillColor={0,128,255})),
  Line(points=[-15,-40; -11,-10; -7,10; -5,20; -1,30; 5,36; 15,40], style(
      color=0,
      rgbcolor={0,0,0},
      thickness=2,
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1))),
      Diagram(
  Line(points=[-15,-30; -11,0; -7,20; -5,30; -1,40; 5,46; 15,50],   style(
      color=0,
      rgbcolor={0,0,0},
      thickness=2,
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1)),
  Line(points=[-15,-50; -11,-20; -7,0; -5,10; -1,20; 5,26; 15,30],  style(
      color=0,
      rgbcolor={0,0,0},
      thickness=2,
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1))));

  equation
    i1 + i2 = imag + iedc;
    Redc*iedc = v0;
    psi0 = Lm*imag;
    g = scalar(der_sat({psi0}/psi_nom, c_sat));

    L[1]*der(i1) + R[1]*i1 = v1 - v0;
    L[2]*der(i2) + R[2]*i2 = v2 - v0;
    g*der(psi0) = v0;
  end TrafoSat;

  model Trafo3Stray "Ideal magnetic coupling transformer, 1-phase"
    extends Partials.Trafo3StrayBase;

  annotation (
    defaultComponentName="trafo",
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
<p>Stray-impedance, but ideal magnetic coupling, i.e. zero magnetisation current.</p>
<p>SI-input: values for stray and coupling impedances winding dependent.</p>
<pre>
  r[k] = R[k]
  x[k] = omega_nom*L[k]
</pre>
<p>pu-input: values for stray and coupling impedances winding-reduced to primary side.</p>
<pre>
  r[k] = R[k]/R_nom[k]
  x[k] = omega_nom*L[k]/R_nom[k]
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
</html>
"),   Icon(Rectangle(extent=[-10,62; 10,-62], style(
      color=30,
      rgbcolor={215,215,215},
      fillColor=30,
      rgbfillColor={215,215,215}))),
      Diagram);

  equation
    i1 + i2a + i2b = 0;
    L[1]*der(i1) + R[1]*i1 = v1 - v0;
    L[2]*der(i2a) + R[2]*i2a = v2a - v0;
    L[3]*der(i2b) + R[3]*i2b = v2b - v0;
  end Trafo3Stray;

  package Partials "Partial models"
    extends Base.Icons.Partials;
    annotation (
      Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]), Window(
        x=0.05,
        y=0.44,
        width=0.31,
        height=0.32,
        library=1,
        autolayout=1));

    partial model TrafoIdealBase "Base for ideal transformer, 1-phase"
      extends Ports.PortTrafo_p_n(w1(start=w1_set), w2(start=w2_set));

      Modelica.Blocks.Interfaces.IntegerInput tap_p "1: index of voltage level"
        annotation (
      extent=[-50,90; -30,110],   rotation=-90);
      Modelica.Blocks.Interfaces.IntegerInput tap_n "2: index of voltage level"
        annotation (extent=[30,90; 50,110], rotation=-90);
      parameter Boolean dynTC=false "enable dynamic tap-changing" annotation(evaluate=true);

      replaceable parameter Parameters.TrafoIdeal1ph par "trafo parameter"
                                annotation (extent=[-80,60; -60,80]);
    protected
      outer System system;
      constant Real tc=0.01 "time constant tap-chg switching";
      final parameter SI.Voltage[2] V_base=Base.Precalculation.baseTrafoV(par.units, par.V_nom);
      final parameter Real[2, 2] RL_base=Base.Precalculation.baseTrafoRL(par.units, par.V_nom, par.S_nom, 2*pi*par.f_nom);
      final parameter Real W_nom=par.V_nom[2]/par.V_nom[1]
        annotation(Evaluate=true);
      final parameter Real[:] W1=cat(1, {1}, par.v_tc1*V_base[1]/par.V_nom[1])   annotation(evaluate=true);
      final parameter Real[:] W2=cat(1, {1}, par.v_tc2*V_base[2]/par.V_nom[2])*W_nom   annotation(evaluate=true);
      Real w1_set=if cardinality(tap_p)==0 then W1[1] else W1[1 + tap_p]
        "1: set voltage ratio to nominal primary";
      Real w2_set=if cardinality(tap_n)==0 then W2[1] else W2[1 + tap_n]
        "2: set voltage ratio to nominal primary";
      annotation (
        Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
        Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
        Icon(
    Ellipse(
    extent=[-80,60; 40,-60], style(
        color=3,
        rgbcolor={44,0,255},
        fillColor=7,
        rgbfillColor={255,255,255})),
    Ellipse(
    extent=[-40,60; 80,-60], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
    Ellipse(extent=[-80,60; 40,-60], style(color=3, rgbcolor={0,0,255})),
    Text(
      extent=[-120,80; -80,40],
      string="1",
      style(color=0,rgbcolor={0,0,0},fillPattern=1)),
    Text(
      extent=[80,80; 120,40],string="2",style(color=0,rgbcolor={0,0,0},
          fillPattern =                                                            1)),
                                 Line(points=[-80,0; -40,0], style(
        color=42,
        rgbcolor={176,0,0},
        thickness=2)), Line(points=[40,0; 80,0], style(
        color=42,
        rgbcolor={176,0,0},
        thickness=2))),
        Diagram(
    Rectangle(extent=[-20,60; -14,-60], style(color=10,fillColor=10,
          fillPattern =                                                         1)),
    Rectangle(extent=[14,60; 20,-60], style(color=10,fillColor=10,
          fillPattern =                                                         1))),
        Documentation(
        info="<html>
<p>Terminology (formal, the models are symmetric).<br>
&nbsp; - index 1 (term_p)     \"primary\"<br>
&nbsp; - index 2 (term_n)     \"secondary\"</p>
<p>Transformer ratio.<br>
The winding ratio is determined indirectly by the choice of nominal voltages.<br>
It may be &gt  or &lt  1.</p>
<p>Tap changers.<br>
For constant transformer ratio no tap changer input needed.<br>
For variable transformer ratio tap changer input needed.</p>
<p>The sequence of the parameters</p>
<pre>  v_tc     tc voltage levels v_tc[1], v_tc[2], v_tc[3], ...</pre>
<p>must be defined in accordance with the input-signals of </p>
<pre>  tap     index of tap voltage levels, v_tc[tap]</pre>
<p>Set <tt>dynTC = true</tt> if tap-index changes during simulation.</p>
</html>
"),     DymolaStoredErrors);

    initial equation
      if dynTC then
        w1 = w1_set;
        w2 = w2_set;
      end if;

    equation
      if dynTC then
        der(w1) + (w1 - w1_set)/tc = 0;
        der(w2) + (w2 - w2_set)/tc = 0;
      else
        w1 = w1_set;
        w2 = w2_set;
      end if;
    end TrafoIdealBase;

    partial model TrafoStrayBase
      "Base for ideal magnetic coupling transformer, 1-phase"
      extends TrafoIdealBase(redeclare replaceable parameter
          Spot.AC1_DC.Transformers.Parameters.TrafoStray1ph par)
        annotation (extent=[-80,60; -60,80]);
    protected
      final parameter SI.Resistance[2] R=par.r.*RL_base[:, 1];
      final parameter SI.Inductance[2] L=par.x.*RL_base[:, 2];
      annotation (
        Coordsys(
    extent=[-100,-100; 100,100],
    grid=[2,2],
    component=
      [20, 20]),
        Window(
    x=0.45,
          y=0.01,
          width=0.44,
    height=0.65),
        Documentation(
        info="<html>
<p>Precalculation of coefficients for ideal magnetic coupling transformer</p>
</html>"),
        Icon,
        Diagram(
       Rectangle(extent=[-26,60; -20,-60],style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=30,
        rgbfillColor={215,215,215})),
       Rectangle(extent=[20,60; 26,-60],  style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=30,
        rgbfillColor={215,215,215}))));
    end TrafoStrayBase;

    partial model TrafoMagBase
      "Base for magnetic coupling transformer, 1-phase"
      extends TrafoStrayBase(redeclare replaceable parameter
          Spot.AC1_DC.Transformers.Parameters.TrafoMag1ph par)
        annotation (extent=[-80,60; -60,80]);
    protected
      final parameter SI.Resistance[2] RL12_base = sqrt((RL_base[1,:].*RL_base[2,:]));
      final parameter SI.Resistance Redc=par.redc*RL12_base[1];
      final parameter SI.Inductance Lm=par.xm*RL12_base[2];
      annotation (
        Coordsys(
    extent=[-100,-100; 100,100],
    grid=[2,2],
    component=
      [20, 20]),
        Window(
    x=0.45,
          y=0.01,
          width=0.44,
    height=0.65),
        Documentation(
        info="<html>
<p>Precalculation of coefficients for magnetic coupling trafo transformer</p>
</html>"),
        Icon,
        Diagram(
    Line(points=[-30,60; -30,-60], style(
        color=3,
        rgbcolor={0,0,255},
        pattern=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[30,60; 30,-60], style(
        color=3,
        rgbcolor={0,0,255},
        pattern=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1))));
    end TrafoMagBase;

    partial model TrafoSatBase "Base for saturation transformer, 1-phase"
      extends TrafoMagBase(redeclare replaceable parameter
          Spot.AC1_DC.Transformers.Parameters.TrafoSat1ph par)
        annotation (extent=[-80,60; -60,80]);
    protected
     final parameter Real xratio=par.xm_sat/par.xm;
      final parameter Real[3] c_sat={1-xratio,(1-xratio)/(par.psi_sat-xratio),xratio};
      final parameter SI.MagneticFlux psi_nom=sqrt(2)*par.V_nom[1]/(2*pi*par.f_nom)
        "amplitude!";
      annotation (
        Coordsys(
    extent=[-100,-100; 100,100],
    grid=[2,2],
    component=
      [20, 20]),
        Window(
    x=0.45,
          y=0.01,
          width=0.44,
    height=0.65),
        Documentation(
        info="<html>
<p>Precalculation of coefficients for saturation transformer</p>
</html>"),
        Icon,
        Diagram(
    Line(points=[-15,-40; -11,-10; -7,10; -5,20; -1,30; 5,36; 15,40], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2,
        fillColor=30,
        rgbfillColor={215,215,215},
        fillPattern=1))));
    end TrafoSatBase;

    partial model Trafo3IdealBase "Base for ideal transformer, 1-phase"
      extends Ports.PortTrafo_p_n_n(
        w1(start=w1_set,fixed=true),
        w2a(start=w2a_set,fixed=true),
        w2b(start=w2b_set,fixed=true));

      parameter Boolean dynTC=false "enable dynamic tap-changing" annotation(evaluate=true);
      Modelica.Blocks.Interfaces.IntegerInput tap_p "1: index of voltage level"
        annotation (
      extent=[-50,90; -30,110],   rotation=-90);
      Modelica.Blocks.Interfaces.IntegerInput[2] tap_n
        "2: indices of voltage levels"
        annotation (extent=[30,90; 50,110], rotation=-90);

      replaceable parameter Parameters.Trafo3Ideal1ph par "trafo parameter"
                                annotation (extent=[-80,60; -60,80]);
    protected
      outer System system;
      constant Real tc=0.01 "time constant tap-chg switching";
      final parameter SI.Voltage[3] V_base=Base.Precalculation.baseTrafoV(par.units, par.V_nom);
      final parameter Real[3, 2] RL_base=Base.Precalculation.baseTrafoRL(par.units, par.V_nom, par.S_nom, 2*pi*par.f_nom);
      final parameter Real Wa_nom=par.V_nom[2]/par.V_nom[1]
        annotation(Evaluate=true);
      final parameter Real Wb_nom=par.V_nom[3]/par.V_nom[1]
        annotation(Evaluate=true);
      final parameter Real[:] W1=cat(1, {1}, par.v_tc1*V_base[1]/par.V_nom[1])   annotation(evaluate=true);
      final parameter Real[:] W2a=cat(1, {1}, par.v_tc2a*V_base[2]/par.V_nom[2])*Wa_nom
                                                                                       annotation(evaluate=true);
      final parameter Real[:] W2b=cat(1, {1}, par.v_tc2b*V_base[3]/par.V_nom[3])*Wb_nom annotation(evaluate=true);
      Real w1_set=if cardinality(tap_p)==0 then W1[1] else W1[1 + tap_p]
        "1: set voltage ratio to nominal primary";
      Real w2a_set=if cardinality(tap_n[1])==0 then W2a[1] else W2a[1 + tap_n[1]]
        "2a: set voltage ratio to nominal primary";
      Real w2b_set=if cardinality(tap_n[2])==0 then W2b[1] else W2b[1 + tap_n[2]]
        "2b: set voltage ratio to nominal primary";
      annotation (
        Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
        Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
        Icon(
    Ellipse(
    extent=[-80,60; 40,-60], style(
        color=3,
        rgbcolor={44,0,255},
        fillColor=7,
        rgbfillColor={255,255,255})),
    Ellipse(
    extent=[-40,60; 80,-60], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
    Ellipse(extent=[-80,60; 40,-60], style(color=3, rgbcolor={0,0,255})),
    Text(
      extent=[-120,80; -80,40],
      string="1",
      style(color=0,rgbcolor={0,0,0},fillPattern=1)),
    Text(
      extent=[80,20; 120,-20],
                             string="2",style(color=0,rgbcolor={0,0,0},
          fillPattern =                                                            1)),
                                 Line(points=[-80,0; -40,0], style(
        color=42,
        rgbcolor={176,0,0},
        thickness=2)), Line(points=[40,0; 80,0], style(
        color=42,
        rgbcolor={176,0,0},
        thickness=2)),
    Text(
      extent=[80,100; 120,60],
      style(color=0,rgbcolor={0,0,0},fillPattern=1),
            string="a"),
    Text(
      extent=[80,-60; 120,-100],
      style(color=0,rgbcolor={0,0,0},fillPattern=1),
            string="b")),
        Diagram(
    Rectangle(extent=[-20,60; -14,-60], style(color=10,fillColor=10,
          fillPattern =                                                         1)),
    Rectangle(extent=[14,60; 20,-60], style(color=10,fillColor=10,
          fillPattern =                                                         1))),
        Documentation(
        info="<html>
<p>Terminology (formal).<br>
&nbsp; - index 1 (term_p)     \"primary\"<br>
&nbsp; - index 2a (term_na)     \"secondary a\"<br>
&nbsp; - index 2b (term_nb)     \"secondary b\"</p>
<p>Transformer ratio.<br>
The winding ratio is determined indirectly by the choice of nominal voltages.<br>
It may be &gt  or &lt  1.</p>
<p>Tap changers.<br>
For constant transformer ratio no tap changer input needed.<br>
For variable transformer ratio tap changer input needed.</p>
<p>The sequence of the parameters</p>
<pre>  v_tc     tc voltage levels v_tc[1], v_tc[2], v_tc[3], ...</pre>
<p>must be defined in accordance with the input-signals of </p>
<pre>  tap     index of tap voltage levels, v_tc[tap]</pre>
<p>Set <tt>dynTC = true</tt> if tap-index changes during simulation.</p>
</html>
"),     DymolaStoredErrors);

    initial equation
      if dynTC then
        w1 = w1_set;
        w2a = w2a_set;
        w2b = w2b_set;
      end if;

    equation
      if dynTC then
        der(w1) + (w1 - w1_set)/tc = 0;
        der(w2a) + (w2a - w2a_set)/tc = 0;
        der(w2b) + (w2b - w2b_set)/tc = 0;
      else
        w1 = w1_set;
        w2a = w2a_set;
        w2b = w2b_set;
      end if;
    end Trafo3IdealBase;

    partial model Trafo3StrayBase
      "Base for ideal magnetic coupling transformer, 1-phase"
      extends Trafo3IdealBase(redeclare replaceable parameter
          Spot.AC1_DC.Transformers.Parameters.Trafo3Stray1ph par)
        annotation (extent=[-80,60; -60,80]);
    protected
      final parameter SI.Resistance[3] R=par.r.*RL_base[:, 1];
      final parameter SI.Inductance[3] L=par.x.*RL_base[:, 2];
      annotation (
        Coordsys(
    extent=[-100,-100; 100,100],
    grid=[2,2],
    component=
      [20, 20]),
        Window(
    x=0.45,
          y=0.01,
          width=0.44,
    height=0.65),
        Documentation(
        info="<html>
<p>Precalculation of coefficients for ideal magnetic coupling 3-winding transformer</p>
</html>"),
        Icon,
        Diagram(
       Rectangle(extent=[-26,60; -20,-60],style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=30,
        rgbfillColor={215,215,215})),
       Rectangle(extent=[20,60; 26,-60],  style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=30,
        rgbfillColor={215,215,215}))));
    end Trafo3StrayBase;
  end Partials;

package Parameters "Parameter data for interactive use"
  extends Base.Icons.Base;

  annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.41,
  width=0.4,
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Records containing parameters of the corresponding components.</p>
</html>"),
    Icon);

record TrafoIdeal1ph "Parameters for ideal transformer, 1-phase"
  parameter SIpu.Voltage[:] v_tc1=fill(1, 0) "1: v-levels tap-changer"
                              annotation(Dialog(group="Options"));
  parameter SIpu.Voltage[:] v_tc2=fill(1, 0) "2: v-levels tap-changer"
                              annotation(Dialog(group="Options"));
  extends Base.Units.NominalDataTrafo;
  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
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
end TrafoIdeal1ph;

record TrafoStray1ph
      "Parameters for ideal magnetic coupling transformer, 1-phase"
  extends TrafoIdeal1ph;
  parameter SIpu.Resistance[2] r={0.05,0.05} "{1,2}: resistance";
  parameter SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
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
end TrafoStray1ph;

record TrafoMag1ph "Parameters for magnetic coupling transformer, 1-phase"
  extends TrafoStray1ph;
  parameter SIpu.Resistance redc=500 "resistance eddy current";
  parameter SIpu.Reactance xm=500 "mutual reactance";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
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
end TrafoMag1ph;

record TrafoSat1ph "Parameters for saturation transformer, 1-phase"
  extends TrafoMag1ph;
  parameter Real psi_sat(unit="pu")=1.5 "saturation flux";
  parameter SIpu.Reactance xm_sat=1 "mutual reactance saturated";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
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
end TrafoSat1ph;

record Trafo3Ideal1ph "Parameters for ideal transformer, 1-phase"
  parameter SIpu.Voltage[:] v_tc1=fill(1, 0) "1: v-levels tap-changer"
                              annotation(Dialog(group="Options"));
  parameter SIpu.Voltage[:] v_tc2a=fill(1, 0) "2a: v-levels tap-changer"
                              annotation(Dialog(group="Options"));
  parameter SIpu.Voltage[:] v_tc2b=fill(1, 0) "2b: v-levels tap-changer"
                              annotation(Dialog(group="Options"));
  extends Base.Units.NominalDataTrafo(V_nom={1,1,1}
          "{prim,sec_a,sec_b} nom Voltage (= base if pu)");
  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
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
end Trafo3Ideal1ph;

record Trafo3Stray1ph
      "Parameters for ideal magnetic coupling transformer, 1-phase"
  extends Trafo3Ideal1ph;
  parameter SIpu.Resistance[3] r={0.05,0.05,0.05} "{1,2a,2b}: resistance";
  parameter SIpu.Reactance[3] x={0.05,0.05,0.05} "{1,2a,2b}: stray reactance";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
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
end Trafo3Stray1ph;

end Parameters;
end Transformers;
