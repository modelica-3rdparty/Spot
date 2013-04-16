within Spot.AC1_DC;

package Ports "Strandard electric ports"
  extends Base.Icons.Base;

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
<p>Electrical ports with connectors Base.Interfaces.ElectricV:</p>
<p>The index notation <tt>_p_n</tt> and <tt>_pn</tt> is used for</p>
<pre>
  _p_n:     no conservation of current
  _pn:      with conservation of current
</pre>
</html>
"));

  partial model Port_p "One port, 'positive'"

    Base.Interfaces.ElectricV_p term(final m=2) "positive terminal"
  annotation (extent=[-110, -10; -90, 10]);
    annotation (
            Icon(
       Text(
      extent=[-100,-90; 100,-130],
      string="%name",
      style(color=0))),
      Documentation(info="<html></html>"),
                  Diagram);
  end Port_p;

  partial model Port_n "One port, 'negative'"

    Base.Interfaces.ElectricV_n term(final m=2) "negative terminal"
  annotation (extent=[90,-10; 110,10]);
    annotation (
            Icon(
       Text(
      extent=[-100,-90; 100,-130],
      string="%name",
      style(color=0))),
      Documentation(info="<html></html>"),
                  Diagram);
  end Port_n;

  partial model Port_f "One port, 'fault'"

    Base.Interfaces.ElectricV_p term(final m=2) "fault terminal"
  annotation (extent=[-10,-110; 10,-90], rotation=90);
    annotation (
            Icon(
       Text(
      extent=[-100,130; 100,90],
      string="%name",
      style(color=0))),
      Documentation(info="<html></html>"),
                  Diagram);
  end Port_f;

  partial model Port_p_n "Two port"

    Base.Interfaces.ElectricV_p term_p(final m=2) "positive terminal"
  annotation (extent=[-110, -10; -90, 10]);
    Base.Interfaces.ElectricV_n term_n(final m=2) "negative terminal"
  annotation (extent=[90, -10; 110, 10]);
    annotation (
  Icon(Text(
      extent=[-100,-90; 100,-130],
      string="%name",
      style(color=0))),
  Documentation(info="<html>
</html>"),
  Diagram);

  end Port_p_n;

  partial model Port_pn "Two port, 'current_in = current_out'"
    extends Port_p_n;

    annotation (
  Icon,
  Documentation(info="<html>
</html>"),
  Diagram);

  equation
    term_p.pin.i + term_n.pin.i = zeros(2);
  end Port_pn;

  partial model Port_p_n_f "Three port"
    extends Port_p_n;

    Base.Interfaces.ElectricV_n term_f(final m=2) "fault terminal"
                                         annotation (extent=[-10,90; 10,110], rotation=90);
    annotation (
  Icon,
  Documentation(info="<html>
</html>"),
  Diagram);
  end Port_p_n_f;

  partial model PortTrafo_p_n "Two port for transformers"
    extends Port_p_n;

    SI.Voltage v1 "voltage 1";
    SI.Current i1 "current 1";

    SI.Voltage v2 "voltage 2";
    SI.Current i2 "current 2";
  protected
    Real w1 "1: voltage ratio to nominal";
    Real w2 "2: voltage ratio to nominal";
    annotation (
  Icon,
  Documentation(info="<html>
<p>Contains voltage and current scaling.</p>
<p>Below</p>
<pre>  term, v, i, w</pre>
<p>denote either the primary or secondary side</p>
<pre>
  term_p, v1, i1, w1
  term_n, v2, i2, w2
</pre>
<p>Definitions</p>
<pre>
  v:     scaled voltage across conductor
  i:     scaled current through conductor
  w:     voltage ratio to nominal (any value, but common for primary and secondary)
</pre>
<p>Relations</p>
<pre>
  v = (term.pin[1].v - term.pin[2].v)/w
  term.pin[1].i = i/w;
</pre>
</html>
"),
  Diagram);

  equation
    term_p.pin[1].i + term_p.pin[2].i = 0;
    term_n.pin[1].i + term_n.pin[2].i = 0;

    v1 = (term_p.pin[1].v - term_p.pin[2].v)/w1;
    term_p.pin[1].i = i1/w1;
    v2 = (term_n.pin[1].v - term_n.pin[2].v)/w2;
    term_n.pin[1].i = i2/w2;
  end PortTrafo_p_n;

  partial model PortTrafo_p_n_n "Three port for 3-winding transformers"

    Base.Interfaces.ElectricV_p term_p(final m=2) "positive terminal"
  annotation (extent=[-110, -10; -90, 10]);
    Base.Interfaces.ElectricV_n term_na(final m=2) "negative terminal a"
  annotation (extent=[90,30; 110,50]);
    Base.Interfaces.ElectricV_n term_nb(final m=2) "negative terminal b"
  annotation (extent=[90,-50; 110,-30]);

    SI.Voltage v1 "voltage 1";
    SI.Current i1 "current 1";

    SI.Voltage v2a "voltage 2a";
    SI.Current i2a "current 2a";

    SI.Voltage v2b "voltage 2b";
    SI.Current i2b "current 2b";

    SI.Voltage v0;
  protected
    Real w1 "1: voltage ratio to nominal";
    Real w2a "2a: voltage ratio to nominal";
    Real w2b "2b: voltage ratio to nominal";
    annotation (
  Icon(Text(
      extent=[-100,-90; 100,-130],
      string="%name",
      style(color=0))),
  Documentation(info="<html>
<p>Contains voltage and current scaling.</p>
<p>Below</p>
<pre>  term, v, i, w</pre>
<p>denote either the primary or secondary_a or secondary_b side</p>
<pre>
  term_p, v1, i1, w1
  term_na, v2a, i2a, w2a
  term_nb, v2b, i2b, w2b
</pre>
<p>Definitions</p>
<pre>
  v:     scaled voltage across conductor
  i:     scaled current through conductor
  w:     voltage ratio to nominal (any value, but common for primary and secondary)
</pre>
<p>Relations</p>
<pre>
  v = (term.pin[1].v - term.pin[2].v)/w
  term.pin[1].i = i/w;
</pre>
</html>
"),
  Diagram);

  equation
    term_p.pin[1].i + term_p.pin[2].i = 0;
    term_na.pin[1].i + term_na.pin[2].i = 0;
    term_nb.pin[1].i + term_nb.pin[2].i = 0;

    v1 = (term_p.pin[1].v - term_p.pin[2].v)/w1;
    term_p.pin[1].i = i1/w1;
    v2a = (term_na.pin[1].v - term_na.pin[2].v)/w2a;
    term_na.pin[1].i = i2a/w2a;
    v2b = (term_nb.pin[1].v - term_nb.pin[2].v)/w2b;
    term_nb.pin[1].i = i2b/w2b;
  end PortTrafo_p_n_n;

end Ports;
