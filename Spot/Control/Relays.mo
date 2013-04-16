within Spot.Control;
package Relays "Relays"
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
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
</html>"),
    Icon);
  block SwitchRelay "Relay for sequential switching "
    extends Base.Icons.Block0;

    parameter Integer n(min=1)=3 "number of signals";
    parameter Integer switched[:]=1:n "switched signals";
    parameter Boolean ini_state=true "initial state (closed true, open false)"
      annotation(choices(choice=true "closed", choice=false "open"));
    parameter SI.Time t_switch[:]={1} "switching time vector";
    Modelica.Blocks.Interfaces.BooleanOutput[n] y(start=fill(ini_state, n), fixed=true)
      "boolean state of switch (closed:true, open:false)"
      annotation (
            extent=[90, -10; 110, 10]);
  protected
    Integer cnt(start=1,fixed=true);
    annotation (defaultComponentName = "relay1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.01,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Allows choosing the phases that will be switched at defined time-events t_switch (finite length vector).</p>
<p>The switching sequence is one of
<pre>
  closed - open - closed - ...
  open - closed - open - ...
</pre></p>
</html>"),
      Icon(
     Text(
    extent=[-80,20; 80,-20],
    style(color=10),
          string="switch")),
      Diagram);

  algorithm
    when time > t_switch[cnt] then
      cnt := min(cnt + 1, size(t_switch, 1));
      for k in switched loop
        y[k] := not y[k];
      end for;
    end when;
  end SwitchRelay;

  block TapChangerRelay "Relay for setting tap-changer "
    extends Base.Icons.Block0;

    parameter Integer preset_1[:](min=0)={0}
      "1: index v-levels tap-chg, 0 is nom";
    parameter Integer preset_2[:](min=0)={0}
      "2: index v-levels tap-chg, 0 is nom";
    parameter SI.Time t_switch_1[:]={1} "1: switching times";
    parameter SI.Time t_switch_2[:]={1} "2:switching times";
    Modelica.Blocks.Interfaces.IntegerOutput tap_p
      "index of voltage level of tap changer 1"
      annotation (
            extent=[90,-50; 110,-30]);
    Modelica.Blocks.Interfaces.IntegerOutput tap_n
      "index of voltage level of tap changer 2"
      annotation (
            extent=[90,30; 110,50]);
  protected
    Integer cnt_1(start=1,fixed=true);
    Integer cnt_2(start=1,fixed=true);
    annotation (defaultComponentName = "tapRelay1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.01,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>The voltage level indices are pre-selected. They correspond to the index of the tap voltage levels
of the transformer model. Level 0 is nominal voltage.</p>
<p>The switching times can be chosen arbitrarily.</p>
</html>
"),   Icon(
        Text(
          extent=[50,50; 70,30],
          style(color=45, rgbcolor={255,128,0}),
          string="2"),
        Text(
          extent=[50,-30; 70,-50],
          string="1",
          style(color=45, rgbcolor={255,128,0})),
     Text(
    extent=[-80,20; 80,-20],
    style(color=10),
          string="tap")),
      Diagram);

  algorithm
    when time > t_switch_1[min(cnt_1, size(t_switch_1, 1))] then
      cnt_1 := cnt_1 + 1;
      tap_p := preset_1[min(cnt_1, size(preset_1, 1))];
    end when;
    when time > t_switch_2[min(cnt_2, size(t_switch_2, 1))] then
      cnt_2 := cnt_2 + 1;
      tap_n := preset_2[min(cnt_2, size(preset_2, 1))];
    end when;
  end TapChangerRelay;

  block TapChanger3Relay "Relay for setting tap-changer 3-winding transformer"
    extends Base.Icons.Block0;

    parameter Integer preset_1[:](min=0)={0}
      "1: index v-levels tap-chg, 0 is nom";
    parameter Integer preset_2a[:](min=0)={0}
      "2a: index v-levels tap-chg, 0 is nom";
    parameter Integer preset_2b[:](min=0)={0}
      "2b: index v-levels tap-chg, 0 is nom";
    parameter SI.Time t_switch_1[:]={1} "1: switching times";
    parameter SI.Time t_switch_2a[:]={1} "2a: switching times";
    parameter SI.Time t_switch_2b[:]={1} "2b: switching times";
    Modelica.Blocks.Interfaces.IntegerOutput tap_p
      "1: index of voltage level of tap changer"
      annotation (
            extent=[90,-50; 110,-30]);
    Modelica.Blocks.Interfaces.IntegerOutput[2] tap_n
      "2: indices of voltage level of tap changers {2a,2b}"
      annotation (
            extent=[90,30; 110,50]);
  protected
    Integer cnt_1(start=1,fixed=true);
    Integer cnt_2a(start=1,fixed=true);
    Integer cnt_2b(start=1,fixed=true);
    annotation (defaultComponentName = "tapRelay1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.01,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>The voltage level indices are pre-selected. They correspond to the index of the tap voltage levels
of the transformer model. Level 0 is nominal voltage.</p>
<p>The switching times can be chosen arbitrarily.</p>
</html>
"),   Icon(
        Text(
          extent=[50,50; 70,30],
          style(color=45, rgbcolor={255,128,0}),
          string="2"),
        Text(
          extent=[50,-30; 70,-50],
          string="1",
          style(color=45, rgbcolor={255,128,0})),
     Text(
    extent=[-80,20; 80,-20],
    style(color=10),
          string="tap")),
      Diagram);

  algorithm
    when time > t_switch_1[min(cnt_1, size(t_switch_1, 1))] then
      cnt_1 := cnt_1 + 1;
      tap_p := preset_1[min(cnt_1, size(preset_1, 1))];
    end when;
    when time > t_switch_2a[min(cnt_2a, size(t_switch_2a, 1))] then
      cnt_2a := cnt_2a + 1;
      tap_n[1] := preset_2a[min(cnt_2a, size(preset_2a, 1))];
    end when;
    when time > t_switch_2b[min(cnt_2b, size(t_switch_2b, 1))] then
      cnt_2b := cnt_2b + 1;
      tap_n[2] := preset_2b[min(cnt_2b, size(preset_2b, 1))];
    end when;
  end TapChanger3Relay;

  block Y_DeltaControl "Relay for Y-Delta topology switching "
    extends Base.Icons.Block0;

    parameter Boolean ini_state=true "initial state (Y true, D false)"
      annotation(choices(choice=true "Y", choice=false "Delta"));
    parameter SI.Time t_switch[:]={1} "switching time vector";
    Modelica.Blocks.Interfaces.BooleanOutput y(start=ini_state, fixed=true)
      "boolean state (Y-top: true, Delta-top: false)"
      annotation (
            extent=[90, -10; 110, 10]);
  protected
    Integer cnt(start=1,fixed=true);
    annotation (defaultComponentName = "relay1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.01,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Allows choosing Y or Delta-topology at defined time-events t_switch (finite length vector).</p>
<p>The switching sequence is one of
<pre>
  Y - Delta - Y - ...
  Delta - Y - Delta - ...
</pre></p>
</html>"),
      Icon(
     Text(
    extent=[-80,20; 80,-20],
    style(color=10),
          string="Y - D")),
      Diagram);

  algorithm
    when time > t_switch[cnt] then
      cnt := min(cnt + 1, size(t_switch, 1));
      y := not y;
    end when;
  end Y_DeltaControl;
end Relays;
