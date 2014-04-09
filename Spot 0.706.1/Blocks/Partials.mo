within Spot.Blocks;
package Partials "Partial models"
  extends Base.Icons.Partials;


  partial block SO
    extends Base.Icons.Block0;

    Modelica.Blocks.Interfaces.RealOutput y "output signal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    annotation (
      Documentation(
              info="<html>
</html>"));
  end SO;

  partial block MO
    extends Base.Icons.Block0;

    Modelica.Blocks.Interfaces.RealOutput[n] y "output signal-vector"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    parameter Integer n=1 "dim of output signal-vector";
    annotation (
      Documentation(
              info="<html>
</html>"));
  end MO;

  partial block SISO
    extends Base.Icons.Block0;

    Modelica.Blocks.Interfaces.RealInput u "input signal"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
            rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput y "output signal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    annotation (
      Documentation(
              info="<html>
</html>"));
  end SISO;

  partial block MISO
    extends Base.Icons.Block0;

    Modelica.Blocks.Interfaces.RealInput[n] u "input signal-vector"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
            rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput y "output signal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    parameter Integer n=1 "dim of input signal-vector";
    annotation (
      Documentation(
              info="<html>
</html>"));
  end MISO;

  partial block MIMO
    extends Base.Icons.Block0;

    Modelica.Blocks.Interfaces.RealInput u[nin] "input signal-vector"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
            rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput y[nout] "output signal vector"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    parameter Integer nin=1 "dim of input signal-vector";
    parameter Integer nout=1 "dim of output signal-vector";
    annotation (
      Documentation(
              info="<html>
</html>"));
  end MIMO;
  annotation (Documentation(info="<html>
</html>"));
end Partials;
