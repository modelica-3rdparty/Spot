within SpotExamples.Data;
package Lines "Line example data"
  extends Spot.Base.Icons.SpecialLibrary;

  annotation (preferedView="info",
Documentation(info="<html>
<p>Some examples of standard-types.<br>
Exact data for specific cases still have to be determined.</p>
<p>Note: correct values for V_nom and S_nom are only needed, if you choose input in pu-units. In this case the 'nominal' values are chosen as base-values. For SI-units the values are not used. Nevertheless they must be defined.</p>
</html>"));

  record OHline15kV1ph "Overhead RX-line 15kV 1-phase rail, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km[2] r={3e-3,3e-3} "resistance/km";
    parameter SIpu.Reactance_km x=2e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=5e-3 "reactance/km zero-comp";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=15e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50/3 "nom frequency";

  annotation (defaultComponentName="OH15kV1ph",
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
</html>
"));
  end OHline15kV1ph;

  record OHline_15kV1ph "Overhead PI-line 15kV 1-phase rail, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km[2] r={3e-3,3e-3} "resistance/km";
    parameter SIpu.Reactance_km x=2e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=5e-3 "reactance/km zero-comp";
    parameter SIpu.Conductance g_pg=1e-10 "shunt conductance/km ph-grd";
    parameter SIpu.Conductance g_pp=1e-10 "shunt conductance/km ph_ph";
    parameter SIpu.Susceptance_km b_pg=0.02e-3 "susceptance/km ph-grd";
    parameter SIpu.Susceptance_km b_pp=0.02e-3 "susceptance/km ph-ph";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50/3 "nom frequency";

  annotation (defaultComponentName="OH_15kV1ph",
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
</html>
"));
  end OHline_15kV1ph;

record OHline132kV1ph "Overhead PI-line 132kV 1-phase rail, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Resistance_km[2] r={1.2e-3,1.2e-3} "resistance/km";
  parameter SIpu.Reactance_km x=1e-3 "reactance/km";
  parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
  parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
  parameter SI.ApparentPower f_nom=50/3 "nom frequency";

annotation (defaultComponentName="OH132kV1ph",
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
</html>"));
end OHline132kV1ph;

record OHline_132kV1ph "Overhead PI-line 132kV 1-phase rail, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Resistance_km[2] r={1.2e-3,1.2e-3} "resistance/km";
  parameter SIpu.Reactance_km x=1e-3 "reactance/km";
  parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";
  parameter SIpu.Conductance g_pg=1e-10 "shunt conductance/km ph-grd";
  parameter SIpu.Conductance g_pp=1e-10 "shunt conductance/km ph_ph";
  parameter SIpu.Susceptance_km b_pg=0.05e-3 "susceptance/km ph-grd";
  parameter SIpu.Susceptance_km b_pp=0.05e-3 "susceptance/km ph-ph";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
  parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
  parameter SI.ApparentPower f_nom=50/3 "nom frequency";

annotation (defaultComponentName="OH_132kV1ph",
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
</html>"));
end OHline_132kV1ph;

  record Cable132kVDC "Cable RX-line 132kV DC, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km[2] r={0.65e-3,0.65e-3} "resistance/km";
    parameter SIpu.Reactance_km x=0.8e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="C132kVDC",
      Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]),
      Icon,
      Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
      Documentation(
        info="<html>
</html>"));
  end Cable132kVDC;

  record Cable_132kVDC "Cable PI-line 132kV DC, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km[2] r={0.65e-3,0.65e-3} "resistance/km";
    parameter SIpu.Reactance_km x=0.08e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";
    parameter SIpu.Conductance g_pg=1e-10 "shunt conductance/km ph-grd";
    parameter SIpu.Conductance g_pp=1e-10 "shunt conductance/km ph_ph";
    parameter SIpu.Susceptance_km b_pg=0.003 "susceptance/km ph-grd";
    parameter SIpu.Susceptance_km b_pp=0.003 "susceptance/km ph-ph";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="C_132kVDC",
      Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]),
      Documentation(
        info="<html>
</html>"),
      Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65));
  end Cable_132kVDC;

  record OHline132kV "Overhead RX-line 132kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=1.2e-3 "resistance/km";
    parameter SIpu.Reactance_km x=3e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=9e-3 "reactance/km zero-comp";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="OH132kV",
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
</html>"));
  end OHline132kV;

  record OHline_132kV "Overhead PI-line 132kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=1.2e-3 "resistance/km";
    parameter SIpu.Reactance_km x=3e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=9e-3 "reactance/km zero-comp";
    parameter SIpu.Conductance g_pg=1e-10 "shunt conductance/km ph-grd";
    parameter SIpu.Conductance g_pp=1e-10 "shunt conductance/km ph_ph";
    parameter SIpu.Susceptance_km b_pg=0.05e-3 "susceptance/km ph-grd";
    parameter SIpu.Susceptance_km b_pp=0.05e-3 "susceptance/km ph-ph";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="OH_132kV",
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
</html>"));
  end OHline_132kV;

  record OHline400kV "Overhead RX-line 400kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=0.02e-3 "resistance/km";
    parameter SIpu.Reactance_km x=0.25e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=0.75e-3 "reactance/km zero-comp";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=400e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="OH400kV",
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
</html>"));
  end OHline400kV;

  record OHline_400kV "Overhead PI-line 400kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=0.02e-3 "resistance/km";
    parameter SIpu.Reactance_km x=0.25e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=0.75e-3 "reactance/km zero-comp";
    parameter SIpu.Conductance g_pg=1e-10 "shunt conductance/km ph-grd";
    parameter SIpu.Conductance g_pp=1e-10 "shunt conductance/km ph_ph";
    parameter SIpu.Susceptance_km b_pg=0.003e-3 "susceptance/km ph-grd";
    parameter SIpu.Susceptance_km b_pp=0.003e-3 "susceptance/km ph-ph";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=400e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="OH_400kV",
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
</html>"));
  end OHline_400kV;

  record Cable132kV "Cable RX-line 132kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=0.65e-3 "resistance/km";
    parameter SIpu.Reactance_km x=0.8e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="C132kV",
      Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]),
      Icon,
      Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
      Documentation(
        info="<html>
</html>"));
  end Cable132kV;

  record Cable_132kV "Cable PI-line 132kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=0.65e-3 "resistance/km";
    parameter SIpu.Reactance_km x=0.08e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";
    parameter SIpu.Conductance g_pg=1e-10 "shunt conductance/km ph-grd";
    parameter SIpu.Conductance g_pp=1e-10 "shunt conductance/km ph_ph";
    parameter SIpu.Susceptance_km b_pg=0.003 "susceptance/km ph-grd";
    parameter SIpu.Susceptance_km b_pp=0.003 "susceptance/km ph-ph";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=132e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="C_132kV",
       Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]),
      Documentation(
        info="<html>
</html>"),
      Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65));
  end Cable_132kV;

  record Cable400kV "Cable RX-line 400kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=0.05e-3 "resistance/km";
    parameter SIpu.Reactance_km x=0.085e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=400e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="C400kV",
      Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]),
      Icon,
      Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
      Documentation(
        info="<html>
</html>"));
  end Cable400kV;

  record Cable_400kV "Cable PI-line 400kV 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SIpu.Resistance_km r=0.05e-3 "resistance/km";
    parameter SIpu.Reactance_km x=0.085e-3 "reactance/km";
    parameter SIpu.Reactance_km x0=3e-3 "reactance/km zero-comp";
    parameter SIpu.Conductance g_pg=1e-10 "shunt conductance/km ph-grd";
    parameter SIpu.Conductance g_pp=1e-10 "shunt conductance/km ph_ph";
    parameter SIpu.Susceptance_km b_pg=0.025 "susceptance/km ph-grd";
    parameter SIpu.Susceptance_km b_pp=0.025 "susceptance/km ph-ph";

    parameter String units="pu" "SI | pu";
    parameter SI.Voltage V_nom=400e3 "nom Voltage (= base)";
    parameter SI.ApparentPower S_nom=100e6 "nom Power (= base)";
    parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="C_400kV",
      Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]),
      Documentation(
        info="<html>
</html>"),
      Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65));
  end Cable_400kV;
end Lines;
