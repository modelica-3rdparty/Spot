within Spot;
package Base "Base"
  extends Icons.Base;


annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.03,
  width=0.4,
  height=0.27,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
</html>"),
  Diagram);
  constant String TableDir=classDirectory()+"Tables/"
  "Directory of example tables";
end Base;
