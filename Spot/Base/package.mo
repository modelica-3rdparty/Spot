within Spot;
package Base "Base"
  extends Icons.Base;

  constant String TableDir=classDirectory()+"Tables/"
  "Directory of example tables";

annotation (preferredView="info",
Documentation(info="<html>
<p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
</html>"));
end Base;
