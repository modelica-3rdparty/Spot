within Spot.ACabc;
package Loads "Loads"
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
height=0.44,
library=1,
autolayout=1),
    Documentation(info="<html>
<p>Load models with an optional input (if scType=signal):</p>
<pre>  p_set:     {active, reactive} power</pre>
</html>
"),
  Icon);

  model Zload "Impedance load, 3-phase abc"
    extends Partials.IndLoadBase;

    annotation (
      defaultComponentName="zLoad",
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
<p>Inductive load with impedance characteristic.<br>
Consumes the desired active and reactive power at <b>nominal</b> voltage.</p>
</html>
"),
  Icon(
    Text(
      extent=[-98,28; -18,-32],
      string="Z",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
  Diagram(
        Rectangle(extent=[-50,3; 30,-4], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,3; -50,-4],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-50,20; 30,13], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,20; -50,13], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-50,-13; 30,-20], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,-13; -50,-20],
                                           style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255}))));

  equation
    Z = (p0/(p0*p0))*V2_nom;
  end Zload;

  model PQindLoad "PQ inductive load, 3-phase abc"
    extends Partials.IndLoadBase;

    parameter SIpu.Current imax(unit="pu")=2 "maximum current";
    parameter SI.Time tcst=0.01 "time constant Z";
  protected
    Real v2 = v*v;
    annotation (
      defaultComponentName="pqLoad",
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
<p>Inductive load with constant characteristic.<br>
Consumes the desired active and reactive power independent of voltage.</p>
</html>"),
  Icon(
    Text(
      extent=[-96,36; 44,-24],
      string="p   q",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
  Diagram);

  initial equation
    der(Z) = {0, 0};

  equation
  //  der(Z) = ((p0/(p0*p0))*v2 - Z)/tcst;
    der(Z) = ((p0/(p0*p0))*v2*tanh(imax)/tanh(imax*v2/V2_nom) - Z)/tcst;
  end PQindLoad;

  model Yload "Admittance load, 3-phase abc"
    extends Partials.CapLoadBase;

    annotation (
      defaultComponentName="yLoad",
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
<p>Capacitive load with admittance characteristic.<br>
Consumes the desired active and reactive power at <b>nominal</b> voltage.</p>
</html>"),
  Icon(
    Text(
      extent=[-100,28; -20,-32],
          string="Y",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
  Diagram);

  equation
    Y = (p0/(p0*p0))*I2_nom;
  end Yload;

  model PQcapLoad "PQ capacitive load, 3-phase abc"
    extends Partials.CapLoadBase;

    parameter SIpu.Voltage vmax(unit="pu")=2 "maximum voltage";
    parameter SI.Time tcst=0.01 "time constant Y";
  protected
    Real i2 = i*i;
    annotation (
      defaultComponentName="pqLoad",
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
<p>Capacitive load with constant characteristic.<br>
Consumes the desired active and reactive power independent of voltage.</p>
</html>"),
  Icon(
    Text(
      extent=[-100,36; 40,-24],
      string="p   q",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
  Diagram);

  initial equation
    der(Y) = {0, 0};

  equation
  //  der(Y) = ((p0/(p0*p0))*i2 - Y)/tcst;
    der(Y) = ((p0/(p0*p0))*i2*tanh(vmax)/tanh(vmax*i2/I2_nom) - Y)/tcst;
  end PQcapLoad;

  model ZIPload "ZIP inductive load, 3-phase abc"
    extends Partials.IndLoadBase;

    parameter SIpu.Current imax(unit="pu")=2 "maximum current";
    parameter Real[2] aZ={1/3,1/3} "weight(power) impedance-dependent";
    parameter Real[2] aI={1/3,1/3} "weight(power) current-dependent";
    parameter Real[2] aP={1,1}-aZ-aI "weight(power) fixed";
    parameter SI.Time tcst=0.01 "time constant Z";
  protected
    SI.Power[2] p(start=p0_set);
    Real v2 = v*v;
    Real v2_pu = v2/V2_nom;
    annotation (
      defaultComponentName="zipLoad",
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
<p>Inductive load with characteristic depending on powers 0,1,2 of voltage or current.<br>
Consumes the desired active and reactive power at <b>nominal</b> voltage.</p>
</html>
"),
  Icon(
    Text(
      extent=[-80,26; 20,-34],
          string="ZIP",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
  Diagram);

  initial equation
    der(Z) = {0, 0};

  equation
    p =  diagonal(aZ*v2_pu + aI*sqrt(v2_pu) + aP)*p0;
  //  der(Z) = ((p/(p*p))*v2 - Z)/tcst;
    der(Z) = ((p/(p*p))*v2*tanh(imax)/tanh(imax*v2_pu) - Z)/tcst;
  end ZIPload;

  model FrequencyLoad "Frequency inductive load, 3-phase abc"
    extends Partials.IndLoadBase;

    parameter SIpu.Current imax(unit="pu")=2 "maximum current";
    parameter Real[2] af={1,1} "frequency sensitivity";
    parameter Real[2] aV={1,1} "voltage sensitivity";
    parameter SI.Time tcst=0.01 "time constant Z";
  protected
    final parameter Real[2] aw=af/(2*pi);
    SI.Power[2] p(start=p0_set);
    Real v2 = v*v;
    Real v2_pu = v2/V2_nom;
    annotation (
      defaultComponentName="freqLoad",
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
<p>Inductive load with frequency and voltage sensitive characteristic.<br>
Consumes the desired active and reactive power at <b>nominal</b> voltage.</p>
</html>"),
  Icon(
    Text(
      extent=[-100,26; -20,-34],
      string="f",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
  Diagram);

  initial equation
    der(Z) = {0, 0};

  equation
    p = diagonal({1,1} + aV*(sqrt(v2_pu)-1) + aw*(sum(omega) - system.omega_nom))*p0;
  //  der(Z) = ((p/(p*p))*v2 - Z)/tcst;
    der(Z) = ((p/(p*p))*v2*tanh(imax)/tanh(imax*v2_pu) - Z)/tcst;
  end FrequencyLoad;

  model DynamicLoad "Dynamic inductive load, 3-phase abc"
    extends Partials.IndLoadBase;

    parameter SIpu.Current imax(unit="pu")=2 "maximum current";
    parameter Real[2] as={0.5,1} "voltage exponent steady-state power";
    parameter Real[2] at={2,2} "voltage exponent transient power";
    parameter SI.Time[2] t_rec={60,60} "power recovery times";
    parameter SI.Time tcst=0.01 "time constant Z";
  protected
    SI.Power[2] p(start=p0_set);
    Real v2 = v*v;
    Real v2_pu = v2/V2_nom;
    Real[2] x;
    Real[2] vs;
    Real[2] vt;
    Real[2] xT;
    annotation (
      defaultComponentName="dynLoad",
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
<p>Inductive load with characteristic depending on dynamic state.<br>
Consumes the desired active and reactive power at steady state and <b>nominal</b> voltage.</p>
</html>"),
  Icon(
    Text(
      extent=[-70,28; 10,-32],
      string="dyn",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
  Diagram);

  initial equation
    if system.steadyIni then
      der(x) = {0,0};
    end if;
    der(Z) = {0, 0};

  equation
    vs = {v2_pu^(as[1]/2), v2_pu^(as[2]/2)};
    vt = {v2_pu^(at[1]/2), v2_pu^(at[2]/2)};
    xT = {x[1]/t_rec[1], x[2]/t_rec[2]};
    der(x) = diagonal(vs - vt)*p0 - xT;
    p =  diagonal(vt)*p0 + xT;
  //  der(Z) = ((p/(p*p))*v2 - Z)/tcst;
    der(Z) = ((p/(p*p))*v2*tanh(imax)/tanh(imax*v2_pu) - Z)/tcst;
  end DynamicLoad;

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
        height=0.23,
        library=1,
        autolayout=1));

    partial model LoadBase "Load base, 3-phase abc"
      extends Ports.Yport_p;
      extends Base.Units.Nominal;

      parameter Boolean stIni_en=true "enable steady-state initial equation"
                                                                           annotation(evaluate=true);
      parameter Base.Types.SourceType scType=Base.Types.par
        "p: parameter or signal"
        annotation(Evaluate=true);
      parameter SIpu.Power[2] p0_set(min=0)={sqrt(3),1}/2
        "{active, reactive} power, (start val if signal inp)" annotation(Dialog(enable=scType==Base.Types.par));
      parameter SIpu.Resistance r_n=0 "resistance neutral to grd";
      Modelica.Blocks.Interfaces.RealInput[2] p_set(min=0)
        "desired {active, reactive} power"                 annotation(extent=[-10,
            90; 10,110], rotation=-90);

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
</html>"),
        Diagram(Rectangle(extent=[70,20; 76,-20], style(
              color=10,
              fillColor=10,
              fillPattern=1))),
        Icon(
          Polygon(points=[-80,-60; -80,60; 80,0; -80,-60], style(
              color=70,
              rgbcolor={0,130,175},
              thickness=2,
              fillColor=7,
              rgbfillColor={255,255,255}))));
    protected
      outer System system;
      final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
      final parameter SI.Voltage S_base=Base.Precalculation.baseS(units, S_nom);
      final parameter SI.Voltage R_base=Base.Precalculation.baseR(units, V_nom, S_nom);
      final parameter SI.Resistance R_n=r_n*R_base;
      SI.AngularFrequency[2] omega;
      SI.Power[2] p0;

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
</html>"),
        Diagram,
        Icon);

    equation
      omega = der(term.theta);
      if scType == Base.Types.par then
        p0 =  p0_set*S_base;
      elseif scType == Base.Types.sig then
        p0 = p_set*S_base;
      end if;
      v_n = R_n*i_n "equation neutral to ground";
    end LoadBase;

    partial model IndLoadBase "Inductive load base, 3-phase abc"
      extends LoadBase(v(start=vstart), i(start=istart));

      parameter Real cpl(min=-0.5,max=1)=0
        "phase coupling x_m/x_s, (-1/2 < cpl < 1)";
      SI.MagneticFlux[3] psi(each stateSelect=StateSelect.prefer)
        "magnetic flux";
    protected
      final parameter Real[3,3] c=[1,cpl,cpl;cpl,1,cpl;cpl,cpl,1]/(1-cpl);
      final parameter Real V2_nom=V_nom*V_nom;
      final parameter Real[2] Zstart=(p0_set/(p0_set*p0_set*S_base))*V2_nom;
      final parameter SI.Voltage[3] vstart={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*V_nom;
      final parameter Real[3] istart=(diagonal(fill(Zstart[1],3))-skew(fill(Zstart[2]/sqrt(3),3)))*vstart/(Zstart*Zstart);
      SI.Impedance[2] Z(start=Zstart);
      annotation (
        Coordsys(
          extent=[-100,-100; 100,100],
          grid=[2,2],
          component=[20,20]),
        Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
        Documentation(info=
        "<html>
</html>
"),     Icon(Polygon(points=[-40,-45; -40,45; 80,0; -40,-45], style(
              color=70,
              rgbcolor={0,130,175},
              thickness=2,
              fillColor=70,
              rgbfillColor={0,130,175}))),
        Diagram);

    initial equation
      if steadyIni_t then
        der(psi) = omega[1]*j_abc(psi);
      end if;

    equation
      psi = Z[2]*c*i/system.omega_nom;
      if system.transientSim then
        der(psi) + omega[2]*j_abc(psi) + Z[1]*i = v;
      else
        omega[2]*j_abc(psi) + Z[1]*i = v;
      end if;
    end IndLoadBase;

    partial model CapLoadBase "Capacitive load base, 3-phase abc"
      extends LoadBase(v(start=vstart), i(start=istart));

      parameter Real beta(min=0)=0 "ratio b_pp/b_pg, (beta > 0)";
      SI.ElectricCharge[3] q(each stateSelect=StateSelect.prefer)
        "electric charge";
    protected
      final parameter Real[3,3] c=[1+2*beta,-beta,-beta;-beta,1+2*beta,-beta;-beta,-beta,1+2*beta]/(1+3*beta);
      final parameter Real I2_nom=(S_nom/V_nom)^2;
      final parameter SI.Admittance[2] Ystart=(p0_set/(p0_set*p0_set*S_base))*I2_nom;
      final parameter SI.Voltage[3] vstart={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*V_nom;
     final parameter SI.Current[3] istart=(diagonal(fill(Ystart[1],3))+skew(fill(Ystart[2]/sqrt(3),3)))*vstart;
      SI.Admittance[2] Y(start=Ystart);
      annotation (
        Coordsys(
          extent=[-100,-100; 100,100],
          grid=[2,2],
          component=[20,20]),
        Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
        Documentation(info=
        "<html>
</html>
"),     Icon(
          Polygon(points=[-40,44; -40,-44; -20,-36; -20,36; -40,44], style(
              pattern=0,
              fillColor=30,
              rgbfillColor={215,215,215})),
          Polygon(points=[-50,48; -50,-48; -40,-44; -40,44; -50,48], style(
              color=70,
              rgbcolor={0,130,175},
              fillColor=70,
              rgbfillColor={0,130,175})),
          Polygon(points=[-20,36; -20,-36; -10,-33; -10,33; -20,36], style(
              color=70,
              rgbcolor={0,130,175},
              fillColor=70,
              rgbfillColor={0,130,175}))),
        Diagram);

    initial equation
      if steadyIni_t then
        der(q) = omega[1]*j_abc(q);
      end if;

    equation
      q = Y[2]*c*v/system.omega_nom;
      if system.transientSim then
        der(q) + omega[2]*j_abc(q) + Y[1]*v = i;
      else
        omega[2]*j_abc(q) + Y[1]*v = i;
      end if;
    end CapLoadBase;
  end Partials;
end Loads;
