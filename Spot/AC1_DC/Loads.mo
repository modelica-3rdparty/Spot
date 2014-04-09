within Spot.AC1_DC;

package Loads "Loads"
  model Rload "Resistance load, 1-phase"
    extends Partials.ResLoadBase;

  annotation (
    defaultComponentName="rLoad",
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
<p>Resistive load AC or DC with impedance characteristic.<br>
Consumes the desired power at <b>nominal</b> voltage.</p>
</html>"),   Icon(
  Text(
    extent=[-80,28; 0,-32],
          string="R",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128}))),
      Diagram);

  equation
    R = V2_nom/p0;
  end Rload;
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
<p>Different load models with an optional input:</p>
<pre>  p_set:     active or {active, reactive} power</pre>
<p>If p_set is <b>not</b> connected to a corresponding signal, parameter-values are relevant.</p>
</html>"),
  Icon);

  model ZloadAC "Impedance load AC, 1-phase"
    extends Partials.IndLoadBaseAC;

  annotation (
    defaultComponentName="zLoadAC",
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
<p>Inductive load AC with impedance characteristic.<br>
Consumes the desired active and reactive power at <b>nominal</b> voltage.</p>
</html>"),   Icon(
  Text(
    extent=[-98,28; -18,-32],
    string="Z",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128})),
  Text(
    extent=[-28,29; 52,-31],
          style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=10,
            rgbfillColor={128,128,128}),
          string="~")),
      Diagram);

  equation
    Z = (p0/(p0*p0))*V2_nom;
  end ZloadAC;

  model YloadAC "Admittance load AC, 1-phase"
    extends Partials.CapLoadBaseAC;

  annotation (
    defaultComponentName="yLoadAC",
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
<p>Capacitive load AC with admittance characteristic.<br>
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
            rgbfillColor={128,128,128})),
  Text(
    extent=[-28,29; 52,-31],
          string="~",
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=10,
            rgbfillColor={128,128,128}))),
      Diagram);

  equation
    Y = (p0/(p0*p0))*I2_nom;
  end YloadAC;

  model ZloadDC "Impedance load DC"
    extends Partials.IndLoadBaseDC;

  annotation (
    defaultComponentName="zLoadDC",
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
<p>Resistive-inductive load DC with impedance characteristic.<br>
Consumes the desired power at <b>nominal</b> voltage.</p>
</html>"),   Icon(
  Text(
    extent=[-98,28; -18,-32],
    string="Z",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128})),
  Text(
    extent=[-28,29; 52,-31],
          string="=",
          style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=10,
            rgbfillColor={128,128,128}))),
      Diagram);

  equation
    R = V2_nom/p0;
    L = t_RL*R;
  end ZloadDC;

  model PindLoadDC "Inductive load DC"
    extends Partials.IndLoadBaseDC;

    parameter SIpu.Current imax(unit="pu")=2 "maximum current";
    parameter SI.Time tcst=0.01 "time constant R";
  protected
    Real v2 = v*v;
  annotation (
    defaultComponentName="pLoadDC",
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
<p>Resistive-inductive load DC with constant characteristic.<br>
Consumes the desired power independent of voltage.</p>
</html>"),
      Icon(
  Text(
    extent=[-98,36; -18,-24],
          string="p",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128})),
  Text(
    extent=[-28,29; 52,-31],
          string="=",
          style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=10,
            rgbfillColor={128,128,128}))),
      Diagram);

  initial equation
    der(R) = 0;

  equation
  //  der(R) = (v2/p0 - R)/tcst;
    der(R) = ((v2/p0)*tanh(imax)/tanh(imax*v2/V2_nom) - R)/tcst;
    L = t_RL*R;
  end PindLoadDC;

  model PresLoadDC "P resistive load"
    extends Partials.ResLoadBase;

    parameter SIpu.Current imax(unit="pu")=2 "maximum current";
    parameter SI.Time tcst=0.01 "time constant R";
  protected
    Real v2 = v*v;
  annotation (
    defaultComponentName="pLoadDC",
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
<p>Resistive load DC with constant characteristic.<br>
Consumes the desired power independent of voltage.</p>
</html>"),
      Icon(
  Text(
    extent=[-80,36; 0,-24],
          string="p",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=10,
            rgbfillColor={128,128,128})),
  Text(
    extent=[-28,29; 52,-31],
          string="=",
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=10,
            rgbfillColor={128,128,128}))),
      Diagram);

  initial equation
    der(R) = 0;

  equation
  //  der(R) = (v2/p0 - R)/tcst;
    der(R) = ((v2/p0)*tanh(imax)/tanh(imax*v2/V2_nom) - R)/tcst;
  end PresLoadDC;

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

    partial model LoadBase "Load base, 1-phase"
      extends Base.Units.Nominal;
      extends Ports.Port_p;

      SI.Voltage v;
      SI.Current i;
    protected
      outer System system;
      final parameter SI.ApparentPower S_base=Base.Precalculation.baseS(units, S_nom);
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
        Icon(
          Polygon(points=[-80,-60; -80,60; 80,0; -80,-60], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255}))));

    equation
      term.pin[1].i + term.pin[2].i = 0;
      v = term.pin[1].v - term.pin[2].v;
      i = term.pin[1].i;
    end LoadBase;

    partial model ResLoadBase "Resistive load base, 1-phase"
      extends LoadBase(v(start=V_nom), i(start=V_nom/Rstart));

      parameter Base.Types.SourceType scType=Base.Types.par
        "p: parameter or signal"
        annotation(Evaluate=true);
      parameter SIpu.Power p0_set(min=0)=1 "power, (start val if signal inp)" annotation(Dialog(enable=scType==Base.Types.par));
      Modelica.Blocks.Interfaces.RealInput p_set(min=0) "desired power"
                                                           annotation(extent=[-10,
            90; 10,110], rotation=-90);
    protected
      final parameter SI.Voltage V2_nom=V_nom*V_nom;
      final parameter Real Rstart=V2_nom/(p0_set*S_base);
      SI.Power p0;
      SI.Resistance R(start=Rstart);
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
      if scType == Base.Types.par then
        p0 =  p0_set*S_base;
      elseif scType == Base.Types.sig then
        p0 = p_set*S_base;
      end if;
      R*i = v;
    end ResLoadBase;

    partial model LoadBaseAC "Load base AC, 1-phase"
      extends LoadBase;

      parameter Boolean stIni_en=true "enable steady-state initial equation"
        annotation(evaluate=true);
      parameter Base.Types.SourceType scType=Base.Types.par
        "p: parameter or signal"
        annotation(Evaluate=true);
      parameter SIpu.Power[2] p0_set(min=0)={1,1}/sqrt(2)
        "{active, reactive} power, (start val if signal inp)" annotation(Dialog(enable=scType==Base.Types.par));
      Modelica.Blocks.Interfaces.RealInput[2] p_set(min=0)
        "desired {active, reactive} power" annotation(extent=[-10,
            90; 10,110], rotation=-90);
    protected
      final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
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
      if scType == Base.Types.par then
        p0 =  p0_set*S_base;
      elseif scType == Base.Types.sig then
        p0 = p_set*S_base;
      end if;
    end LoadBaseAC;

                 partial model IndLoadBaseAC "Inductive load base AC, 1-phase"
                   extends LoadBaseAC(v(start=vstart), i(start=istart));

                   SI.MagneticFlux psi(stateSelect=StateSelect.prefer)
        "magnetic flux";
    protected
                   final parameter Real V2_nom=V_nom*V_nom;
                   final parameter Real[2] Zstart=(p0_set/(p0_set*p0_set*S_base))*V2_nom;
                   final parameter SI.Voltage vstart=cos(system.alpha0)*V_nom;
                   final parameter SI.Current istart=cos(system.alpha0-atan(Zstart[2]/Zstart[1]))*V_nom/sqrt(Zstart*Zstart);
                   SI.Impedance[2] Z(start=Zstart);
                   function atan=Modelica.Math.atan;
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
</html>"),
        Icon(Polygon(points=[-40,-45; -40,45; 80,0; -40,-45], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255}))),
        Diagram);

                 initial equation
                   if steadyIni_t then
                     der(psi) = 0;
                   end if;

                 equation
                   psi = Z[2]*i/system.omega_nom;
                   if system.transientSim then
                     der(psi) + Z[1]*i = v;
                   else
                     Z[1]*i = v;
                   end if;
                 end IndLoadBaseAC;

                 partial model CapLoadBaseAC "Capacitive load base AC, 1-phase"
                   extends LoadBaseAC(v(start=vstart), i(start=istart));

                   SI.ElectricCharge q(stateSelect=StateSelect.prefer)
        "electric charge";
    protected
                   final parameter Real I2_nom=(S_nom/V_nom)^2;
                   final parameter SI.Admittance[2] Ystart=(p0_set/(p0_set*p0_set*S_base))*I2_nom;
                   final parameter SI.Voltage vstart=cos(system.alpha0)*V_nom;
                   final parameter SI.Current istart=cos(system.alpha0+atan(Ystart[2]/Ystart[1]))*V_nom*sqrt(Ystart*Ystart);
                   SI.Admittance[2] Y(start=Ystart);
                   function atan=Modelica.Math.atan;
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
</html>"),                  Icon(
                       Polygon(points=[-40,44; -40,-44; -20,-36; -20,36; -40,44], style(
                           pattern=0,
                           fillColor=30,
                           rgbfillColor={215,215,215})),
                       Polygon(points=[-50,48; -50,-48; -40,-44; -40,44; -50,48], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255})),
                       Polygon(points=[-20,36; -20,-36; -10,-33; -10,33; -20,36], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255}))),
                     Diagram);

                 initial equation
                   if steadyIni_t then
                     der(q) = 0;
                   end if;

                 equation
                   q = Y[2]*v/system.omega_nom;
                   if system.transientSim then
                     der(q) + Y[1]*v = i;
                   else
                     Y[1]*v = i;
                   end if;
                 end CapLoadBaseAC;

    partial model LoadBaseDC "Inductive load base DC"
      extends LoadBase;

      parameter Boolean stIni_en=true "enable steady-state initial equation"
        annotation(evaluate=true);
      parameter Base.Types.SourceType scType=Base.Types.par
        "p: parameter or signal"
        annotation(Evaluate=true);
      parameter SIpu.Power p0_set(min=0)=1 "power, (start val if signal inp)" annotation(Dialog(enable=scType==Base.Types.par));
      Modelica.Blocks.Interfaces.RealInput p_set(min=0) "desired power"
                                                           annotation(extent=[-10,
            90; 10,110], rotation=-90);
    protected
      final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
      SI.Power p0;
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
        Icon(Polygon(points=[-40,-45; -40,45; 80,0; -40,-45], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255}))));

    equation
      if scType == Base.Types.par then
        p0 =  p0_set*S_base;
      elseif scType == Base.Types.sig then
        p0 = p_set*S_base;
      end if;
    end LoadBaseDC;

    partial model IndLoadBaseDC "Inductive load base DC"
      extends LoadBaseDC;

      parameter SI.Time t_RL=0.1 "R-L time constant";
    protected
      final parameter SI.Voltage V2_nom=V_nom*V_nom;
      final parameter Real Rstart=V2_nom/(p0_set*S_base);
      SI.Resistance R(start=Rstart);
      SI.Inductance L(start=t_RL*Rstart);
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
        Icon(Polygon(points=[-40,-45; -40,45; 80,0; -40,-45], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255}))));

    initial equation
      if steadyIni_t then
        der(L*i) = 0;
      end if;

    equation
      der(L*i) + R*i = v;
    end IndLoadBaseDC;
  end Partials;
end Loads;
