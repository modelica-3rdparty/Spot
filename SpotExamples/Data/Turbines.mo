within SpotExamples.Data;
package Turbines "Turbine example data"
  extends Spot.Base.Icons.SpecialLibrary;


   record SteamTurboGroup1200MW "Steam turbo-group, example"
     extends Spot.Base.Icons.Record;

     parameter SI.Inertia[size(P_nom,1)] J_turb={19300,182000,182000,182000}
      "inertia turbines";
     parameter SI.Inertia J_gen=62000 "inertia generator";
     parameter SI.Inertia[:] J_aux={460,830} "inertia auxiliaries";
     parameter SIpu.Stiffness[size(J_turb,1)+size(J_aux,1)] stiff={260,355,750,750,750,220}*1e6
      "stiffness shafts";

     parameter SIpu.AngularVelocity_rpm rpm_nom=3000 "nom r.p.m. turbines";
     parameter SI.Power[:] P_nom={480e6,240e6,240e6,240e6} "nom power turbines";

     annotation (defaultComponentName="turboGrp1200M",
       Coordsys(
   extent=[-100,-100; 100,100],
   grid=[2,2],
   component=
     [20, 20]),
       Window(
   x=0.45,
         y=0.01,
         width=0.44,
   height=0.65),
       Documentation(
       info="<html>
</html>
"),    Icon,
       Diagram);
   end SteamTurboGroup1200MW;

record GasTurbineGear "Small GT with gear, example"
  extends Spot.Base.Icons.Record;

  parameter SI.Inertia J_turb=28.5 "inertia turbine";
  parameter SI.Inertia J_comp=34.3 "inertia compressor";
  parameter SI.Inertia[2] J_gear1={0.43,8.6} "inertias gear1";
  parameter SI.Inertia[2] J_gear2={2.9,134} "inertias gear2";
  parameter SI.Inertia J_acc=4.6 "inertia accessory";
  parameter SI.Inertia J_cpl=34 "inertia coupling";
  parameter SI.Inertia J_gen=2150 "inertia generator";
  parameter Real[3] ratio={15057,5067,1500} "gear ratio";
  parameter SIpu.Stiffness[6] stiff_sh={2.278,3.83,71,1909.8,180,143.5}*1e6
      "stiffness shafts";
  parameter SIpu.Stiffness stiff_cpl=91.16*1e6 "stiffness coupling";

  parameter SIpu.AngularVelocity_rpm rpm_nom=15057 "nom r.p.m. turbine";
  parameter SI.Power[:] P_nom={1.2, -0.2}*7e6 "nom power {turbine, compressor}";

  annotation (defaultComponentName="GTgear",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end GasTurbineGear;

record HydroTurbine "Hydro turbine, example"
  extends Spot.Base.Icons.Record;

  parameter SI.Inertia J_turb=1000 "inertia turbines";
  parameter SI.Inertia J_shaft=5 "inertia shaft";
  parameter SI.Inertia J_gen=500 "inertia generator";
  parameter SIpu.Stiffness stiff=281e6 "stiffness shaft";

  parameter SIpu.AngularVelocity_rpm rpm_nom=3000 "nom r.p.m. turbine";
  parameter SI.Power P_nom=20e6 "nom power turbine";

  annotation (defaultComponentName="hydro",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end HydroTurbine;

record Diesel "Diesel, example"
  extends Spot.Base.Icons.Record;

  parameter SI.Inertia J_turb=20 "inertia diesel";
  parameter SI.Inertia J_gen=20 "inertia generator";
  parameter SIpu.Stiffness stiff=1e6 "stiffness shaft";

  parameter SIpu.AngularVelocity_rpm rpm_nom=1500 "nom r.p.m. Diesel";
  parameter SI.Power P_nom=100e3 "nom power diesel";

  annotation (defaultComponentName="diesel",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end Diesel;

record WindTurbineGear "Wind turbine with gear, example"
  extends Spot.Base.Icons.Record;

  parameter SI.Inertia J_turb=10 "inertia turbine";
  parameter SI.Inertia[3] J_gear={0.3,0.1,0.03} "inertias gear";
  parameter SI.Inertia J_gen=0.5 "inertia generator";
  parameter Real ratio[3]={1,6,42} "gear ratio";
  parameter SIpu.Stiffness[2] stiff_sh={16,1}*1e4 "stiffness shafts";

  parameter SIpu.AngularVelocity_rpm rpm_nom=10 "nom r.p.m. turbine";
  parameter SI.Power P_nom=30e3 "nom power turbine";

  annotation (defaultComponentName="windTurb",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end WindTurbineGear;
   annotation (preferedView="info",
 Documentation(info="<html>
</html>"));
end Turbines;
