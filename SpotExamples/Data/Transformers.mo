within SpotExamples.Data;
package Transformers "Transformer example data"
  extends Spot.Base.Icons.SpecialLibrary;


record TrafoIdeal1ph "Ideal trafo, 1-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={15000,1400}
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=5e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50/3 "nom frequency";

  annotation (defaultComponentName="trafo15k_1400",
    Documentation(
    info="<html>
</html>
"));
end TrafoIdeal1ph;

record TrafoStray1ph "Trafo with ideal magnetic coupling, 1-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";
  parameter SIpu.Resistance[2] r={0.03,0.03} "{1,2}: resistance";
  parameter SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={15000,1400}
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=5e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50/3 "nom frequency";

  annotation (defaultComponentName="trafo15k_1400",
    Documentation(
    info="<html>
</html>
"));
end TrafoStray1ph;

record TrafoMag1ph "Trafo with magnetic coupling, 1-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";
  parameter SIpu.Resistance[2] r={0.03,0.03} "{1,2}: resistance";
  parameter SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance";
  parameter SIpu.Resistance redc=500 "resistance eddy current";
  parameter SIpu.Reactance xm=500 "mutual reactance";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={15000,1400}
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=5e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50/3 "nom frequency";

  annotation (defaultComponentName="trafo15k_1400",
    Documentation(
    info="<html>
</html>
"));
end TrafoMag1ph;

record TrafoSat1ph "Trafo with saturation, 1-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";
  parameter SIpu.Resistance[2] r={0.03,0.03} "{1,2}: resistance";
  parameter SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance";
  parameter SIpu.Resistance redc=500 "resistance eddy current";
  parameter SIpu.Reactance xm=500 "mutual reactance";
  parameter Real psi_sat(unit="pu")=1.5 "saturation flux";
  parameter SIpu.Reactance xm_sat=1 "mutual reactance saturated";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={15000,1400}
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=5e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50/3 "nom frequency";

  annotation (defaultComponentName="trafo15k_1400",
    Documentation(
    info="<html>
</html>
"));
end TrafoSat1ph;

record TrafoIdeal "Ideal trafo, 3-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";
  parameter SIpu.Resistance r_n1=1 "1: resistance neutral to grd";
  parameter SIpu.Resistance r_n2=1 "2: resistance neutral to grd";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={20,400}*1e3
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1000e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="trafo20k_400k",
    Documentation(
    info="<html>
</html>
"));
end TrafoIdeal;

record TrafoStray "Trafo with ideal magnetic coupling, 3-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";
  parameter SIpu.Resistance r_n1=1 "1: resistance neutral to grd";
  parameter SIpu.Resistance r_n2=1 "2: resistance neutral to grd";
  parameter SIpu.Resistance[2] r={0.005,0.005} "{1,2}: resistance";
  parameter SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance";
  parameter SIpu.Reactance[2] x0={x[1],x[2]} "{1,2}: stray reactance zero-comp";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={20,400}*1e3
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1000e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="trafo20k_400k",
    Documentation(
    info="<html>
</html>
"));
end TrafoStray;

record TrafoMag "Trafo with magnetic coupling, 3-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";
  parameter SIpu.Resistance r_n1=1 "1: resistance neutral to grd";
  parameter SIpu.Resistance r_n2=1 "2: resistance neutral to grd";
  parameter SIpu.Resistance[2] r={0.005,0.005} "{1,2}: resistance";
  parameter SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance";
  parameter SIpu.Reactance[2] x0={x[1],x[2]} "{1,2}: stray reactance zero-comp";
  parameter SIpu.Resistance redc=500 "resistance eddy current";
  parameter SIpu.Reactance xm=500 "mutual reactance";
  parameter SIpu.Reactance xm0=50 "mutual reactance zero";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={20,400}*1e3
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1000e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="trafo20k_400k",
    Documentation(
    info="<html>
</html>
"));
end TrafoMag;

record TrafoSat "Trafo with saturation, 3-phase, example"
  extends Spot.Base.Icons.Record;

  parameter SIpu.Voltage[:] v_tc1={-5, -2.5, 0, 2.5, 5}
      "1: v-levels tap-changer";
  parameter SIpu.Voltage[:] v_tc2={-5, -2.5, 0, 2.5, 5}
      "2: v-levels tap-changer";
  parameter SIpu.Resistance r_n1=1 "1: resistance neutral to grd";
  parameter SIpu.Resistance r_n2=1 "2: resistance neutral to grd";
  parameter SIpu.Resistance[2] r={0.005,0.005} "{1,2}: resistance";
  parameter SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance";
  parameter SIpu.Reactance[2] x0={x[1],x[2]} "{1,2}: stray reactance zero-comp";
  parameter SIpu.Resistance redc=500 "resistance eddy current";
  parameter SIpu.Reactance xm=500 "mutual reactance";
  parameter SIpu.Reactance xm0=50 "mutual reactance zero";
  parameter Real psi_sat(unit="pu")=1.5 "saturation flux";
  parameter SIpu.Reactance xm_sat=1 "mutual reactance saturated";

  parameter String units="pu" "SI | pu";
  parameter SI.Voltage[2] V_nom={20,400}*1e3
      "{prim,sec} nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1000e6 "nom Power (= base if pu)";
  parameter SI.ApparentPower f_nom=50 "nom frequency";

  annotation (defaultComponentName="trafo20k_400k",
    Documentation(
    info="<html>
</html>
"));
end TrafoSat;
  annotation (preferredView="info",
Documentation(info="<html>
<p>Note: a correct value for S_nom is only needed, if you choose input in pu-units. In this case the 'nominal' values are chosen as base-values. For SI-units S_nom is not used. Nevertheless it must be defined. V_nom however is used to define the winding ratio and voltage start values.</p>
</html>"));
end Transformers;
