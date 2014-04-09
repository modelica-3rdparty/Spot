within Spot.AC1_DC;

package Nodes "Nodes "
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
  model Ground "Ground, 1-phase"
    extends Ports.Port_p;
    annotation (defaultComponentName = "grd1",
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
<p>Zero voltage on both conductors of terminal.</p>
</html>"),   Icon(
        Line(points=[-90,0; -4,0], style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-4,60; 4,-60], style(
  color=10,
  fillColor=9,
  fillPattern=1))),
      Diagram(
  Line(points=[-80,0; -60,0], style(
            color=69,
            rgbcolor={0,128,255},
            thickness=2)),
  Rectangle(extent=[-60,20; -54,-20],style(
      color=10,
      fillColor=9,
      fillPattern=1))));

  equation
    term.pin.v = zeros(2);
  end Ground;

  model PolarityGround "Polarity grounding, 1-phase"
    extends Ports.Port_p;

    parameter Integer pol(min=-1,max=1)=-1 "grounding scheme" annotation(evaluate=true,
      choices(choice=1 "plus", choice=0 "symmetrical", choice=-1 "negative"));
    annotation (defaultComponentName = "polGrd1",
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
<p>Zero voltage depending on polarity choice.</p>
<pre>
  pol =  1     conductor 1 grounded (DC: positive)
  pol =  0     symmetrically grounded
  pol = -1     conductor 2 grounded (DC: negative)
</pre>
</html>"),   Icon(
        Line(points=[-50,0; -4,0], style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-4,60; 4,-60], style(
  color=10,
  fillColor=9,
  fillPattern=1)),
        Line(points=[-80,10; -50,0], style(
            color=3,
            rgbcolor={0,0,255},
            pattern=3)),
        Line(points=[-80,0; -50,0], style(
            color=3,
            rgbcolor={0,0,255},
            pattern=3)),
        Line(points=[-80,-10; -50,0], style(
            color=3,
            rgbcolor={0,0,255},
            pattern=3))),
      Diagram(
  Line(points=[-80,-4; -60,-4], style(
            color=3,
            rgbcolor={0,0,255},
            pattern=3,
            thickness=2)),
  Rectangle(extent=[-60,20; -54,-20],style(
      color=10,
      fillColor=9,
      fillPattern=1)),
  Line(points=[-80,4; -60,4], style(
            color=3,
            rgbcolor={0,0,255},
            pattern=3,
            thickness=2)),
  Line(points=[-80,0; -60,0], style(
            color=3,
            rgbcolor={0,0,255},
            pattern=3,
            thickness=2))));

  equation
    if pol==1 then
      term.pin[1].v = 0;
      term.pin[2].i = 0;
    elseif pol==-1 then
      term.pin[2].v = 0;
      term.pin[1].i = 0;
    else
      term.pin[1].v + term.pin[2].v = 0;
      term.pin[1].i = term.pin[2].i;
    end if;
  end PolarityGround;

  model GroundOne "Ground, one conductor"

    Base.Interfaces.Electric_p term
                               annotation (extent=[-110,-10; -90,10]);
    annotation (
      defaultComponentName="grdOne1",
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
<p>Zero voltage on terminal.</p>
</html>"),
  Icon(
   Text(
  extent=[-100,-90; 100,-130],
  string="%name",
  style(color=0)),
        Rectangle(extent=[-4,50; 4,-50], style(
  color=10,
  fillColor=9,
  fillPattern=1)),
        Line(points=[-90,0; -4,0],  style(color=3, rgbcolor={0,0,255}))),
  Diagram(Line(points=[-60,0; -80,0], style(
            color=69,
            rgbcolor={0,128,255},
            thickness=2)),
                       Rectangle(extent=[-60,20; -54,-20],
                                                         style(
  color=10,
  fillColor=9,
  fillPattern=1))));

  equation
    term.v = 0;
  end GroundOne;

  model BusBar "Busbar, 1-phase"

    output SI.Voltage v(stateSelect=StateSelect.never);
    Base.Interfaces.ElectricV_p term
      annotation (
          extent=[-7,-60; 7,60],  rotation=0,
        style(
          color=69,
          rgbcolor={0,128,255},
          fillColor=69,
          rgbfillColor={0,128,255}));
    annotation (defaultComponentName = "bus1",
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
  Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0)),
                 Rectangle(extent=[-10,80; 10,-80], style(
        color=3,
        rgbcolor={0,0,255},
        pattern=0,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1))),
      Diagram,
      Documentation(
              info="<html>
<p>Calculates difference voltage conductor 1 - conductor 2.</p>
</html>"));

  equation
    term.pin.i = zeros(2);
    v = term.pin[1].v - term.pin[2].v;
  end BusBar;

  model Electric_pn_p_n "Adaptor ElectricV[2] (vector) to Electric (scalar)."

    Base.Interfaces.ElectricV_p term_pn(final m=2) "vector pin {p,n}"
      annotation (extent=[-70,-10; -50,10]);
    Base.Interfaces.Electric_p term_p "scalar p"
        annotation (extent=[70,30; 50,50],  rotation=0);
    Base.Interfaces.Electric_n term_n "scalar n"
        annotation (extent=[50,-50; 70,-30],rotation=0);
    annotation (defaultComponentName = "pn_p_n",
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
  Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0)),
          Rectangle(extent=[-40,60; 40,-60], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Line(points=[-40,-10; -10,-10; -10,-40; 40,-40], style(color=3, rgbcolor={0,0,
                255})),
  Line(points=[-40,10; -10,10; -10,40; 40,40], style(color=3, rgbcolor={0,0,255}))),
      Documentation(
              info="<html>
</html>"),   Diagram(
  Line(points=[-40,5; 0,5; 0,40; 40,40],       style(color=3, rgbcolor={0,0,255})),
  Line(points=[-40,-5; 0,-5; 0,-40; 40,-40],       style(color=3, rgbcolor={0,0,
                255}))));

  equation
    term_pn.pin.v = {term_p.v, term_n.v};
    term_pn.pin.i + {term_p.i, term_n.i} = zeros(2);
  end Electric_pn_p_n;

  model Electric_abc_a_b_c "Adaptor ElectricV[3] (vector) to Electric (scalar)"

    Base.Interfaces.ElectricV_p term_abc(final m=3) "vector {a,b,c}"
      annotation (extent=[-70,-10; -50,10]);
    Base.Interfaces.Electric_n term_a "scalar a"
        annotation (extent=[50,30; 70,50]);
    Base.Interfaces.Electric_n term_b "scalar b"
        annotation (extent=[50,-10; 70,10]);
    Base.Interfaces.Electric_n term_c "scalar c"
        annotation (extent=[50,-50; 70,-30]);
      annotation (defaultComponentName = "abc_a_b_c",
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
          Rectangle(extent=[-40,60; 40,-60], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Line(points=[-40,10; -10,10; -10,40; 40,40], style(color=3, rgbcolor={0,0,255})),
  Line(points=[-40,-10; -10,-10; -10,-40; 40,-40], style(color=3, rgbcolor={0,0,
                255})),
        Line(points=[-40,0; 40,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
  Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0))),
          Documentation(info="<html>
</html>"),       Diagram(
  Line(points=[-40,5; 0,5; 0,40; 40,40],       style(color=3, rgbcolor={0,0,255})),
  Line(points=[-40,-5; 0,-5; 0,-40; 40,-40],       style(color=3, rgbcolor={0,0,
                255})),
        Line(points=[-40,0; 40,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1))));

  equation
    {term_a.v,term_b.v,term_c.v} = term_abc.pin.v;
    term_abc.pin.i + {term_a.i,term_b.i,term_c.i} = zeros(3);
  end Electric_abc_a_b_c;
end Nodes;
