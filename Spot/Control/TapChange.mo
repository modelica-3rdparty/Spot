package TapChange "Tap changers"
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
<p>Here one could add an updated version of
<ul>
<li>TCULContinuous</li>
<li>TCULDiscrete</li>
</ul>
<p>the tap-change-under-load controllers from the ObjectStab library.<br>
(See ObjetStab.Network.Controllers).</p>
</html>"),
    Icon);

end TapChange;
