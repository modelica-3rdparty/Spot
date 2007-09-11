package AC1_DC "AC 1-phase and DC components"
  extends Base.Icons.Library;


annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.03,
  width=0.4,
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
</html>
"));
end AC1_DC;
