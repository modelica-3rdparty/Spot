within Spot.Base;
package Interfaces "Interfaces "
  extends Icons.Base;

    annotation (preferedView="info",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Window(
        x=0,
        y=0.55,
        width=0.15,
        height=0.41,
        library=1,
        autolayout=1),
      Documentation(info="<html>
<p><a href=\"Spot.UsersGuide.Introduction.Interfaces\">up users guide</a></p>
</html>
"));

  connector Electric_p "Electric terminal ('positive')"
    extends Connectors.Electric;
    annotation (defaultComponentName = "term_p",
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Documentation(info="<html>
</html>
"),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Icon(Rectangle(extent=[-100, 100; 100, -100], style(color=73, fillColor=
            73))),
  Diagram(Rectangle(extent=[0,50; 100,-50], style(
          color=73,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
          Text(
      extent=[-120,120; 100,60],
      string="%name",
        style(color=3, rgbcolor={0,0,255}))));
  end Electric_p;

  connector Electric_n "Electric terminal ('negative')"
    extends Connectors.Electric;
    annotation (defaultComponentName = "term_n",
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Documentation(info="<html>
</html>"),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Icon(Rectangle(extent=[-100, 100; 100, -100], style(color=73, fillColor=7))),
  Diagram(Rectangle(extent=[-100,50; 0,-50],       style(color=73,
          fillColor=7)),
          Text(
      extent=[-100,120; 120,60],
      string="%name",
        style(color=3, rgbcolor={0,0,255}))));
  end Electric_n;

  connector ElectricV_p "Electric vector terminal ('positive')"
    parameter Integer m(final min=1)=2 "number of single contacts";
    Connectors.Electric[m] pin "vector of single contacts";
  annotation (defaultComponentName = "term_p",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Documentation(info="<html>
<p>Electric connector with a vector of 'pin's, positive.</p>
</html>
"), Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(Polygon(points=[-120,0; 0,-120; 120,0; 0,120; -120,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
                    Text(
        extent=[-60,60; 60,-60],
        style(
          color=7,
          pattern=0,
          fillPattern=0),
          string="%m")),
    Diagram(Text(
        extent=[-120,120; 100,60],
        string="%name",
          style(color=3, rgbcolor={0,0,255})),
        Polygon(points=[-20,0; 40,-60; 100,0; 40,60; -20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
                    Text(
        extent=[-10,50; 90,-50],
        style(
          color=7,
          pattern=0,
          fillPattern=0),
          string="%m")));
  end ElectricV_p;

  connector ElectricV_n "Electric vector terminal ('negative')"
    parameter Integer m(final min=1)=2 "number of single contacts";
    Connectors.Electric[m] pin "vector of single contacts";
  annotation (defaultComponentName = "term_n",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Documentation(info="<html>
<p>Electric connector with a vector of 'pin's, negative.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(Polygon(points=[-120,0; 0,-120; 120,0; 0,120; -120,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
         Text(
        extent=[-60,60; 60,-60],
        style(
          pattern=0,
          thickness=2,
          fillPattern=0),
          string="%m")),
    Diagram(Text(
        extent=[-100,120; 120,60],
        string="%name",
          style(color=3, rgbcolor={0,0,255})),
        Polygon(points=[-100,0; -40,-60; 20,0; -40,60; -100,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
                           Text(
        extent=[-90,50; 10,-50],
        style(
          pattern=0,
          thickness=2,
          fillPattern=0),
          string="%m")));
  end ElectricV_n;

  connector ACabc_p "AC terminal, 3-phase abc ('positive')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_p",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Documentation(info="<html>
<p>AC connector with vector variables in abc-representation, positive.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(Ellipse(extent=[-100,100; 100,-100], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175})),
         Text(
        extent=[-60,60; 60,-60],
        style(color=7, fillPattern=0),
          string="abc")),
    Diagram(Text(
        extent=[-120,120; 100,60],
        string="%name",
          style(color=70, rgbcolor={0,130,175})),
            Ellipse(extent=[0,50; 100,-50], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175})),
                          Text(
        extent=[12,40; 90,-40],
        style(
          color=7,
          pattern=0,
          fillPattern=0),
          string="abc")));
  end ACabc_p;

  connector ACabc_n "AC terminal, 3-phase abc ('negative')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_n",
    Coordsys(
      extent=[-100, -100; 100, 100],
     grid=[2, 2],
       component=[20, 20]),
    Documentation(info="<html>
<p>AC connector with vector variables in abc-representation, negative.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(Ellipse(extent=[-100,100; 100,-100], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=7,
            rgbfillColor={255,255,255})),
       Text(
      extent=[-60,60; 60,-60],
          string="abc",
          style(
            color=70,
            rgbcolor={0,130,175},
            fillPattern=0))),
    Diagram(
          Text(
      extent=[-100,120; 120,60],
      string="%name",
          style(color=70, rgbcolor={0,130,175})),
            Ellipse(extent=[-100,50; 0,-50], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=7,
            rgbfillColor={255,255,255})),
                 Text(
      extent=[-90,40; -10,-40],
          string="abc",
          style(
            color=70,
            rgbcolor={0,130,175},
            fillPattern=0))));
  end ACabc_n;

  connector ACdqo_p "AC terminal, 3-phase dqo ('positive')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_p",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Documentation(info="<html>
<p>AC connector with vector variables in dqo-representation, positive.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(Ellipse(extent=[-100, 100; 100, -100], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
         Text(
        extent=[-60, 60; 60, -60],
        style(color=7, fillPattern=0),
          string="dqo")),
    Diagram(Ellipse(extent=[0,50; 100,-50], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
                          Text(
        extent=[12,40; 90,-40],
        style(
          color=7,
          pattern=0,
          fillPattern=0),
          string="dqo"),
            Text(
        extent=[-120,120; 100,60],
          string="%name",
          style(color=62, rgbcolor={0,120,120}))));
  end ACdqo_p;

  connector ACdqo_n "AC terminal, 3-phase dqo ('negative')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_n",
    Coordsys(
      extent=[-100, -100; 100, 100],
     grid=[2, 2],
       component=[20, 20]),
    Documentation(info="<html>
<p>AC connector with vector variables in dqo-representation, negative.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(Ellipse(extent=[-100, 100; 100, -100], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=7,
            rgbfillColor={255,255,255})),
       Text(
      extent=[-60, 60; 60, -60],
          string="dqo",
          style(
            color=62,
            rgbcolor={0,120,120},
            fillPattern=0))),
    Diagram(Ellipse(extent=[-100,50; 0,-50], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=7,
            rgbfillColor={255,255,255})),
                 Text(
      extent=[-90,40; -10,-40],
          string="dqo",
          style(
            color=62,
            rgbcolor={0,120,120},
            fillPattern=0)),
          Text(
      extent=[-100,120; 120,60],
      string="%name",
          style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,100,100}))));
  end ACdqo_n;

  connector Rotation_p "Rotational flange ('positive') "
    extends Connectors.Rotation;
  annotation (defaultComponentName = "flange_p",
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
<p>Mechanical rotational connector (also electro-mechanical), positive.</p>
</html>
"), Icon(Ellipse(extent=[-100, 100; 100, -100], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={95,95,95}))),
    Diagram(Ellipse(extent=[0,50; 100,-50],        style(color=0, fillColor=
              10)),
            Text(
        extent=[-120,120; 100,60],
        string="%name",
          style(color=10, rgbcolor={95,95,95}))));
  end Rotation_p;

  connector Rotation_n "Rotational flange ('negative') "
    extends Connectors.Rotation;
  annotation (defaultComponentName = "flange_n",
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
<p>Mechanical rotational connector (also electro-mechanical), negative.</p>
</html>
"), Icon(Ellipse(extent=[-100, 100; 100, -100], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255}))),
    Diagram(Ellipse(extent=[-100,50; 0,-50],       style(color=0, fillColor=7)),
            Text(
        extent=[-100,120; 120,60],
        string="%name",
          style(color=10, rgbcolor={95,95,95}))));
  end Rotation_n;

  connector Translation_p "Translational flange ('positive') "
    extends Connectors.Translation;
  annotation (defaultComponentName = "flange_p",
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
<p>Mechanical translational connector (also electro-mechanical), positive.</p>
</html>"),
    Icon(Rectangle(extent=[-100, 100; 100, -100], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={95,95,95}))),
    Diagram(Rectangle(extent=[0,50; 100,-50],        style(color=0, fillColor=
             10)),
            Text(
        extent=[-120,120; 100,60],
        string="%name",
          style(color=10, rgbcolor={95,95,95}))));
  end Translation_p;

  connector Translation_n "Translational flange ('negative')"
    extends Connectors.Translation;
  annotation (defaultComponentName = "flange_n",
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
<p>Mechanical translational connector (also electro-mechanical), negative.</p>
</html>"),
    Icon(Rectangle(extent=[-100, 100; 100, -100], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255}))),
    Diagram(Rectangle(extent=[-100,50; 0,-50],       style(color=0, fillColor=
             7)),
            Text(
        extent=[-100,120; 120,60],
        string="%name",
          style(color=10, rgbcolor={95,95,95}))));
  end Translation_n;

  connector Thermal_p "Thermal heat port ('positive')"
    extends Connectors.Thermal;

  annotation (defaultComponentName = "heat_p",
    Diagram(
         Rectangle(extent=[0,50; 100,-50], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
                              Text(
          extent=[-120,120; 100,60],
          string="%name",
          style(color=42, rgbcolor={176,0,0}))),
    Icon(Rectangle(extent=[-100,100; 100,-100], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0}))),
    Documentation(info="<html>
</html>
"),   Coordsys(extent=[-100,-100; 100,100]));
  end Thermal_p;

  connector Thermal_n "Thermal heat port ('negative')"
    extends Connectors.Thermal;

  annotation (defaultComponentName = "heat_n",
    Documentation(info="<html>
</html>
"), Diagram(
      Rectangle(extent=[-100,50; 0,-50], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=7,
            rgbfillColor={255,255,255})),
                              Text(
          extent=[-100,120; 120,60],
          string="%name",
          style(color=42, rgbcolor={176,0,0}))),
    Icon(
      Rectangle(extent=[-100, 100; 100, -100], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Coordsys(extent=[-100,-100; 100,100]));
  end Thermal_n;

  connector ThermalV_p "Thermal vector heat port ('positive')"
    parameter Integer m(final min=1) = 1 "number of single heat-ports";
    Connectors.Thermal[m] port "vector of single heat ports";

  annotation (defaultComponentName = "heat_p",
    Diagram(                  Text(
          extent=[-120,120; 100,60],
          string="%name",
          style(color=42, rgbcolor={176,0,0})),
        Polygon(points=[-20,0; 40,-60; 100,0; 40,60; -20,0], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
                    Text(
        extent=[-10,50; 90,-50],
        style(
          color=30,
          pattern=0,
          fillPattern=0),
          string="%m")),
    Icon(Polygon(points=[-120,0; 0,-120; 120,0; 0,120; -120,0], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
                    Text(
        extent=[-60,60; 60,-60],
        style(
          color=7,
          pattern=0,
          fillPattern=0),
          string="%m")),
    Documentation(info="<html>
<p>Thermal connector with a vector of 'port's, positive.</p>
</html>
"),   Coordsys(extent=[-100,-100; 100,100]));
  end ThermalV_p;

  connector ThermalV_n "Thermal vector heat port ('negative')"
    parameter Integer m(final min=1) = 1 "number of single heat-ports";
    Connectors.Thermal[m] port "vector of single heat ports";

  annotation (defaultComponentName = "heat_n",
    Documentation(info="<html>
<p>Thermal connector with a vector of 'port's, negative.</p>
</html>
"), Diagram(                  Text(
          extent=[-100,120; 120,60],
          string="%name",
          style(color=42, rgbcolor={176,0,0})),
        Polygon(points=[-100,0; -40,-60; 20,0; -40,60; -100,0], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Text(
        extent=[-90,50; 10,-50],
          string="%m",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillPattern=0))),
    Icon(Polygon(points=[-120,0; 0,-120; 120,0; 0,120; -120,0], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Text(
        extent=[-60,60; 60,-60],
          string="%m",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillPattern=0))),
      Coordsys(extent=[-100,-100; 100,100]));
  end ThermalV_n;

  partial model AddHeat "Additional heat port"

    SI.CelsiusTemperature T "Temperature of conductor";
    SI.HeatFlowRate Q_flow "Dissipated heat of conductor";
    Base.Interfaces.Thermal_n heat "heat port"
    annotation (extent=[-10, 90; 10, 110], rotation=90,Documentation(info="<html>
  <pre>
  Adds a scalar heat port to the component.
  The port collects the total heat dissipated by the component.
  </pre>
  </html>"),
           Diagram);

  equation
      T = heat.T;
      Q_flow = -heat.Q_flow;

      annotation (Diagram, Documentation(info="<html>
<p>Adds a heat-port to an electrical component.</p>
<p>Copper data at 20degC.</p>
<pre>
  rho_m = 8960 kg/m^3:     density
  c_p = 382.3 J/(kg.K):    specific heat
  rho = 1.673e-8 Ohm.m:    specific resistance
</pre>
</html>"));
  end AddHeat;

  partial model AddHeatV "Additional vector heat port"

    parameter Integer m_heat(final min=1) = 1 "number of heat conductors";
    SI.CelsiusTemperature[m_heat] T "Temperature of heat conductors";
    SI.HeatFlowRate[m_heat] Q_flow "Dissipated heat of conductors";
    Base.Interfaces.ThermalV_n heat(final m=m_heat) "vector heat port"
    annotation (extent=[-10, 90; 10, 110], rotation=90,Documentation(info="<html>
  <pre>
  Adds a vector heat port to the component.
  Each port-component collects the heat dissipated by one conductor of the device.
  </pre>
  </html>"),
           Diagram);

  equation
      T = heat.port.T;
      Q_flow = -heat.port.Q_flow;

      annotation (Diagram, Documentation(info="<html>
<p>Adds a vector heat-port to an electrical component.</p>
<p>Copper data at 20degC.</p>
<pre>
  rho_m = 8960 kg/m^3:     density
  c_p = 382.3 J/(kg.K):    specific heat
  rho = 1.673e-8 Ohm.m:    specific resistance
</pre>
</html>"));
  end AddHeatV;

  connector Position "Position reference"
    SI.Position s;

  annotation (defaultComponentName = "position",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Icon(Polygon(points=[-100, 0; -40, 40; 40, 40; 100, 0; 40, -40; -40, -40;
             -100, 0], style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255})), Text(
          extent=[-60,30; 60,-30],
          string="pos",
          style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1))),
    Diagram(Polygon(points=[-60,0; -20,20; 20,20; 60,0; 20,-20; -20,-20; -60,0], style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255})),             Text(
        extent=[-110,120; 110,60],
        string="%name",
          style(color=78, rgbcolor={120,0,120}))),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>System position reference.<br>
Used in extended 'System' for sending/receiving position.</p>
<pre>
  s:        position
</pre>
</html>            "));
  end Position;

  model SenderPos "Sender of position"

    Position sendPos            annotation (extent=[-60,-100; 60,20], style(
          color=78, rgbcolor={120,0,120}));
  annotation (defaultComponentName = "position",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Icon(                    Polygon(points=[-100,-100; 0,100; 100,-100; 100,
              -100; -100,-100], style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255})),
       Text(
      extent=[-100,-100; 100,-140],
            string="%name",
          style(color=78, rgbcolor={120,0,120}))),
    Diagram,
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>Contains system position reference.<br>
Needed within certain models to establish the connection to extended 'system' for sending/receiving position-data.</p>
<p>Used for example in rail vehicles.</p>
</html>
 "));
  end SenderPos;

  connector Frequency "Weighted frequency"
    flow SI.Time H;
    flow Real H_w;

  annotation (defaultComponentName = "frequency",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Icon(Ellipse(extent=[-80,80; 80,-80], style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)), Text(
          extent=[-60,30; 60,-30],
          string="freq",
          style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1))),
    Diagram(                         Text(
        extent=[-110,120; 110,60],
        string="%name",
          style(color=78, rgbcolor={120,0,120})), Ellipse(extent=[-40,40; 40,
              -40], style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1))),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>System frequency reference.<br>
Used in 'System' for sending/receiving weighted frequency-data.</p>
<pre>
  H:        weight, i.e. inertia constant of machine (dimension time)
  H_omega:  weighted angular frequency H*omega
</pre>
</html>"));
  end Frequency;

  model SenderFreq "Sender of weighted frequency"

    Frequency sendFreq          annotation (extent=[-60,-92; 60,28], style(
          color=78, rgbcolor={120,0,120}));
    annotation (defaultComponentName = "sendFreq",
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
<p>Contains system frequency reference.<br>
Needed within certain models to establish the connection to 'system' for sending/receiving weighted frequency-data.</p>
<p>Used in generator models.</p>
</html>
"),   Icon(
       Text(
      extent=[-100,-100; 100,-140],
            string="%name",
          style(color=78, rgbcolor={120,0,120})),
                             Polygon(points=[-100,-100; 0,100; 100,-100; 100,-100;
                -100,-100], style(
            color=78,
            rgbcolor={120,0,120},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram);
  end SenderFreq;

  package Connectors "Naked connectors"
  extends Base.Icons.Partials;
    annotation (preferedView="info",
  Documentation(info="<html>
</html>"));

  connector Electric "Electric terminal"
    SI.Voltage v "connector voltage";
    flow SI.Current i "current directed into the component";

  annotation (Documentation(info="<html>
<p>Electric  connector with scalar variables.</p>
<pre>
  v:        voltage
  i:        current
</pre>
</html>
"), Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon,
    Diagram);
  end Electric;

  connector AC3ph "AC terminal, 3-phase"
    Types.ReferenceAngle[2] theta "{relative angle, reference angle}";
    SI.Voltage[3] v "connector voltage";
    flow SI.Current[3] i "current directed into the component";

  annotation (Documentation(info="<html>
<p>AC 3-phase connector with vector variables of dimension 3.</p>
<pre>
  theta[2]:  {relative angle, reference angle}
  v[3]:      voltage vector
  i[3]:      current vector
</pre>
<p>The following relations hold between absolute and relative angle\\frequency:</p>
<pre>
  theta[1]\\der(theta[1]):  angle\\angular_frequency in frame rotating with reference angle theta[2]
  theta[2]\\der(theta[2]):  angle\\angular_frequency of rotating reference frame
</pre>
<p>Therefore the absolute quantities are given by:</p>
<pre>
  theta_abs = theta[1] + theta[2]:  absolute angle
  der(theta_abs) = omega_abs:       absolute angular frequency
</pre>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon,
    Diagram);
  end AC3ph;

  connector Rotation "Rotational flange"
    SI.Angle phi "connector rotation angle";
    flow SI.Torque tau "cut torque directed into the component";

  annotation (Documentation(info="<html>
<p>Mechanical rotational connector (also electro-mechanical).</p>
<pre>
  phi:      angle
  tau:      torque
</pre>
</html>"),
    Icon,
    Diagram);
  end Rotation;

  connector Translation "Translational flange"
    SI.Position s "connector position";
    flow SI.Force f "cut force directed into the component";

  annotation (Documentation(info="<html>
<p>Mechanical translational connector (also electro-mechanical).</p>
<pre>
  s:        position
  f:        force
</pre>
</html>"),
    Icon,
    Diagram);
  end Translation;

  connector Thermal "Thermal heat-port"
    SI.Temperature T "port temperature";
    flow SI.HeatFlowRate Q_flow "heat flow rate directed into the component";

  annotation (Documentation(info="<html>
<p>Thermal connector with scalar variables.</p>
<pre>
  T:        temperature
  Q_flow:   heat flow rate
</pre>
</html>
"), Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon,
    Diagram);
  end Thermal;
  //  annotation 11;
  end Connectors;

end Interfaces;
