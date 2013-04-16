within Spot.Base;
package Visualise "Elementary visualisers"
  extends Icons.Base;

  annotation (preferedView="info",
Documentation(info="<html>
<p><a href=\"Spot.UsersGuide.Introduction.Visualisation\">up users guide</a></p>
</html>
"));

  model Bar "Bar"

    parameter Base.Types.Color color={0,0,0};
    input Real x annotation(Hide=false);
    annotation (Icon(
      Rectangle(extent=[0,0; 1,1], style(
            rgbcolor={95,95,95},
            rgbfillColor={255,255,255})),
      Rectangle(extent=[0,0; 1, DynamicState(0.5, x)], style(
            color=10,
            fillColor=10,
            rgbcolor=color,
            rgbfillColor=color))),
      Coordsys(
           extent=[0, 0; 1, 1],
           grid=[0.01, 0.01],
           component=[1, 1]));
  end Bar;

  model Needle "Centered needle"

    parameter Base.Types.Color color={0,0,0};
    input Real x;
    input Real y;
    final Real[2,2] needle=[0,0; x,y] annotation(Hide=false);
    annotation (
      Icon(Line(points=DynamicState([0,0; 1,0],needle), style(
           color=10,
           rgbcolor=color, thickness=2))),
      Coordsys(
           extent=[-1, -1; 1, 1],
           grid=[0.02, 0.02],
           component=[2, 2]));
  end Needle;

  model DoubleNeedle "Centered double needle"

    parameter Base.Types.Color color1={255,0,0};
    parameter Base.Types.Color color2={0,0,255};
    input Real x1;
    input Real y1;
    input Real x2;
    input Real y2;
  protected
    final Real[2,2] needle1=[{0,x1},{0,y1}] annotation(Hide=false);
    final Real[2,2] needle2=[{0,x2},{0,y2}] annotation(Hide=false);
    annotation (
      Icon(Line(points=DynamicState([0,0; 0.5,0],needle1), style(
           color=10,
           rgbcolor=color1, thickness=2)),
           Line(points=DynamicState([0,0; 0.5,0],needle2), style(
           color=10,
           rgbcolor=color2, thickness=2))),
      Coordsys(
           extent=[-1, -1; 1, 1],
           grid=[0.02, 0.02],
           component=[2, 2]),
      Diagram);
  end DoubleNeedle;
end Visualise;
