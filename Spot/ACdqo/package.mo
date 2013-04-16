within Spot;
package ACdqo "AC 3-phase components in dqo-representation"
  extends Base.Icons.Library;
import Spot.Base.Transforms.j_dqo;


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
end ACdqo;
