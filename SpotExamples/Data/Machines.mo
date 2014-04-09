within SpotExamples.Data;
package Machines "Machine example data"
  extends Spot.Base.Icons.SpecialLibrary;


record DCser1500V_1p5MVA "DC machine series excited, example"
  extends Spot.Base.Icons.Record;

  parameter Integer pp=2 "pole-pair nb";
  parameter SIpu.Inductance l_fd=0.15 "inductance field (d-axis)";
  parameter SIpu.Resistance r_fd=0.01 "resistance field (d-axis)";
  parameter SIpu.Inductance l_q=0.5 "inductance armature+ (q-axis)";
  parameter SIpu.Resistance r_q=0.05 "resistance armature+ (q-axis)";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=1500 "nom Voltage";
  parameter SI.ApparentPower S_nom=1.5e6 "nom Power";
  parameter SIpu.AngularVelocity_rpm rpm_nom=1500 "nom r.p.m.";

  annotation (defaultComponentName="DCs1500_1p5M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end DCser1500V_1p5MVA;

record DCpar1500V_1p5MVA "DC machine parallel excited, example"
  extends Spot.Base.Icons.Record;

  parameter Integer pp=2 "pole-pair nb";
  parameter SIpu.Inductance l_fd=100*pi "inductance field (d-axis)";
  parameter SIpu.Resistance r_fd=100 "resistance field (d-axis)";
  parameter SIpu.Inductance l_q=0.5 "inductance armature+ (q-axis)";
  parameter SIpu.Resistance r_q=0.05 "resistance armature+ (q-axis)";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=1500 "nom Voltage";
  parameter SI.ApparentPower S_nom=1.5e6 "nom Power";
  parameter SIpu.AngularVelocity_rpm rpm_nom=1500 "nom r.p.m.";
  parameter SI.Voltage Vf_nom=1500 "nom field voltage";

  annotation (defaultComponentName="DCp1500_1p5M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end DCpar1500V_1p5MVA;

record DCpm100V_1kVA "DC machine permanent magnet excited, example"
  extends Spot.Base.Icons.Record;

  parameter Integer pp=2 "pole-pair nb";
  parameter SIpu.Inductance l_aq=0.5 "inductance armature (q-axis)";
  parameter SIpu.Resistance r_aq=0.05 "resistance armature (q-axis)";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=100 "nom Voltage";
  parameter SI.ApparentPower S_nom=1e3 "nom Power";
  parameter SIpu.AngularVelocity_rpm rpm_nom=1500 "nom r.p.m.";

  annotation (defaultComponentName="DCpm100_1k",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end DCpm100V_1kVA;

record BLDC100V_1kVA
    "BLDC machine (= synchronous pm, 3rd order model), example pu-units"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=2 "excitation (2:pm)"
    annotation(Evaluate=true);
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.2
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=0.4 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=0.4 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.05 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=100*sqrt(3/2)/2 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1e3 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=60 "nom frequency";

  annotation (defaultComponentName="bldc100_1k",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
<p>The relation between source DC voltage V_dc and nominal 3-phase voltage of the synchronous machine V_nom is given by
<pre>  V_nom = V_dc*sqrt(3/2)/2</pre>
Note that V_nom is only used, if impedance values x and r are given in pu.<br>
f_nom is needed to relate impedance x and inductance L values.</p>
</html>
"), Icon,
    Diagram);
end BLDC100V_1kVA;

record BLDC100V_1kVA_SI
    "BLDC machine (= synchronous pm, 3rd order model), example SI-units"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=2 "excitation (2:pm)"
    annotation(Evaluate=true);
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.2
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=1.5 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.5 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.375 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.1875 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter String units=Spot.Base.Types.SI "SI | pu";
  parameter SI.Voltage V_nom=100*sqrt(3/2)/2 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1e3 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=60 "nom frequency";

  annotation (defaultComponentName="bldc100_1k_SI",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
<p>The relation between source DC voltage V_dc and nominal 3-phase voltage of the synchronous machine V_nom is given by
<pre>  V_nom = V_dc*sqrt(3/2)/2</pre>
Note that V_nom is only used, if impedance values x and r are given in pu.<br>
f_nom is needed to relate impedance x and inductance L values.</p>
</html>
"), Icon,
    Diagram);
end BLDC100V_1kVA_SI;

record Asynchron400V_30kVA "Asynchronous machine, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=8 "pole-pair number";
  parameter SIpu.Reactance x=3 "total reactance d- and q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.04 "resistance stator";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter Boolean transDat=true "use transient data";
  parameter Boolean use_xtr=true "use t_closed and x_transient?";
  parameter SIpu.Reactance[:] xtr={0.196667}
      "transient reactance {xtr', xtr'', ..}";
  parameter SI.Time[:] tc={0.0130419}
      "time constant closed-loop {tc', tc'', ..}";
  parameter SI.Time[:] to={0.198944} "time constant open-loop {to', to'', ..}";

// the corresponding equivalent circuit data are:
  parameter SIpu.Reactance xsig_s=0.1 "leakage reactance stator";
  parameter SIpu.Reactance[:] xsig_r={0.1} "leakage reactance rotor";
  parameter SIpu.Resistance[size(xsig_r,1)] r_r={0.04} "resistance rotor";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=400 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=30e3 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=50 "nom frequency";

  annotation (defaultComponentName="asyn400_30k",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end Asynchron400V_30kVA;

record Asynchron3kV_1p5MVA "Asynchronous machine, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  parameter SIpu.Reactance x=2.8 "total reactance d- and q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.02 "resistance stator";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter Boolean transDat=true "use transient data";
  parameter Boolean use_xtr=true "use t_closed and x_transient?";
  parameter SIpu.Reactance[:] xtr={0.1, 0.075}
      "transient reactance {xtr', xtr'', ..}";
  parameter SI.Time[:] tc={0.014, 0.4e-3}
      "time constant closed-loop {tc', tc'', ..}";
  parameter SI.Time[:] to={0.4, 2.8e-3}
      "time constant open-loop {to', to'', ..}";

// the corresponding equivalent circuit data are:
  parameter SIpu.Reactance xsig_s=0.05 "leakage reactance stator";
  parameter SIpu.Reactance[:] xsig_r={0.0529633, 0.0481803}
      "leakage reactance rotor";
  parameter SIpu.Resistance[size(xsig_r,1)] r_r={0.0234304, 0.580595}
      "resistance rotor";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=3000 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1.5e6 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=50 "nom frequency";

  annotation (defaultComponentName="asyn3k_1p5M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end Asynchron3kV_1p5MVA;

record Synchron3rd_pm400V_30kVA
    "Synchronous machine pm, 3rd order model, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=2 "excitation (2:pm)"
    annotation(Evaluate=true);
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.1
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=0.4 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=0.4 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.03 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=400 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=30e3 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=50 "nom frequency";

  annotation (defaultComponentName="syn3rdpm400_30k",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end Synchron3rd_pm400V_30kVA;

record Synchron_pm400V_30kVA "Synchronous machine pm, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=2 "excitation (2:pm)"
    annotation(Evaluate=true);
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.1
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=0.4 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=0.4 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.03 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter Boolean transDat=true "use transient data";
  parameter Boolean use_xtr=true "use x_transient and t_closed?";
  parameter SIpu.Reactance[:] xtr_d={0.142857}
      "trans reactance d-axis {xtr_d', xtr_d'', ..}";
  parameter SIpu.Reactance[:] xtr_q={0.142857}
      "trans reactance q-axis {xtr_q', xtr_q'', ..}";
  parameter SI.Time[:] tc_d={0.00994718}
      "time constant closed-loop d-axis {tc_d', tc_d'', ..}";
  parameter SI.Time[:] tc_q={0.00994718}
      "time constant closed-loop q-axis {tc_q', tc_q'', ..}";
  parameter SI.Time[:] to_d={0.0278521}
      "time constant open-loop d-axis {to_d', to_d'', ..}";
  parameter SI.Time[:] to_q={0.0278521}
      "time constant open-loop q-axis {to_q', to_q'', ..}";
  parameter Boolean use_if0=false "induced field current and phase available?";
  parameter SIpu.Current if0=0 "induced field current at v_s=Vnom/0deg";
  parameter SIpu.Angle_deg if0_deg=0
      "angle(if0) at v_s=Vnom/0deg (sign: i_f behind v_s)";
  parameter Real tol=1e-6 "tolerance precalculation";

// the corresponding equivalent circuit data are:
  parameter SIpu.Reactance xsig_s=0.1 "leakage reactance armature";
  parameter SIpu.Reactance[:] xsig_rd={0.05}
      "leakage reactance rotor d-axis {f, D, ..}";
  parameter SIpu.Reactance[:] xsig_rq={0.05}
      "leakage reactance rotor q-axis {Q1, ..}";
  parameter SIpu.Reactance[size(xsig_rd,1)-1] xm_d=fill(0, 0)
      "coupling-reactance d-axis {xm1, ..}";
  parameter SIpu.Resistance[size(xsig_rd,1)] r_rd={0.04}
      "resistance rotor d-axis {f, D, ..}";
  parameter SIpu.Resistance[size(xsig_rq,1)] r_rq={0.04}
      "resistance rotor q-axis {Q1, ..}";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=400 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=30e3 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=50 "nom frequency";
  parameter SI.Current If_nom=0 "nom field current (V=V_nom at open term)";

  annotation (defaultComponentName="synpm400_30k",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Icon,
    Documentation(
          info="<html>
</html>
"), Diagram,
    DymolaStoredErrors);
end Synchron_pm400V_30kVA;

record Synchron3rd_pm560V_100kVA "Synchronous machine 3rd order pm, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=2 "excitation (2:pm)"
    annotation(Evaluate=true);
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.1
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=0.4 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=0.4 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.03 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=560 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=100e3 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=400 "nom frequency";

  annotation (defaultComponentName="syn3rdpm560_100k",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Icon,
    Documentation(
          info="<html>
</html>
"), Diagram,
    DymolaStoredErrors);
end Synchron3rd_pm560V_100kVA;

record Synchron_pm560V_100kVA "Synchronous machine pm, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=2 "excitation (2:pm)"
    annotation(Evaluate=true);
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.1
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=0.4 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=0.4 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.03 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter Boolean transDat=true "use transient data";
  parameter Boolean use_xtr=true "use x_transient and t_closed?";
  parameter SIpu.Reactance[:] xtr_d={0.142857}
      "trans reactance d-axis {xtr_d', xtr_d'', ..}";
  parameter SIpu.Reactance[:] xtr_q={0.142857}
      "trans reactance q-axis {xtr_q', xtr_q'', ..}";
  parameter SI.Time[:] tc_d={0.0132629}
      "time constant closed-loop d-axis {tc_d', tc_d'', ..}";
  parameter SI.Time[:] tc_q={0.0132629}
      "time constant closed-loop q-axis {tc_q', tc_q'', ..}";
  parameter SI.Time[:] to_d={0.0371362}
      "time constant open-loop d-axis {to_d', to_d'', ..}";
  parameter SI.Time[:] to_q={0.0371362}
      "time constant open-loop q-axis {to_q', to_q'', ..}";
  parameter Boolean use_if0=false "induced field current and phase available?";
  parameter SIpu.Current if0=0 "induced field current at v_s=Vnom/0deg";
  parameter SIpu.Angle_deg if0_deg=0
      "angle(if0) at v_s=Vnom/0deg (sign: i_f behind v_s)";
  parameter Real tol=1e-6 "tolerance precalculation";

// the corresponding equivalent circuit data are:
  parameter SIpu.Reactance xsig_s=0.1 "leakage reactance armature";
  parameter SIpu.Reactance[:] xsig_rd={0.05}
      "leakage reactance rotor d-axis {f, D, ..}";
  parameter SIpu.Reactance[:] xsig_rq={0.05}
      "leakage reactance rotor q-axis {Q1, ..}";
  parameter SIpu.Reactance[size(xsig_rd,1)-1] xm_d=fill(0, 0)
      "coupling-reactance d-axis {xm1, ..}";
  parameter SIpu.Resistance[size(xsig_rd,1)] r_rd={0.03}
      "resistance rotor d-axis {f, D, ..}";
  parameter SIpu.Resistance[size(xsig_rq,1)] r_rq={0.03}
      "resistance rotor q-axis {Q1, ..}";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=560 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=100e3 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=400 "nom frequency";
  parameter SI.Current If_nom=0 "nom field current (V=V_nom at open term)";

  annotation (defaultComponentName="synpm560_100k",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Icon,
    Documentation(
          info="<html>
</html>
"), Diagram,
    DymolaStoredErrors);
end Synchron_pm560V_100kVA;

record Synchron3rd20kV_1200MVA "Synchronous machine, 3rd order model, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";
  final parameter Integer excite=1 "excitation (1:electric)"
    annotation(Evaluate=true);
  final parameter SIpu.MagneticFlux psi_pm(unit="pu")=0
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=2.29 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.95 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.004 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=20e3 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1200e6 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=50 "nom frequency";

  annotation (defaultComponentName="syn20k_1200M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Icon,
    Documentation(
          info="<html>
</html>
"), Diagram,
    DymolaStoredErrors);
end Synchron3rd20kV_1200MVA;

record Synchron20kV_1200MVA "Synchronous machine, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";
  final parameter Integer excite=1 "excitation (1:electric)"
    annotation(Evaluate=true);
  final parameter SIpu.MagneticFlux psi_pm(unit="pu")=0
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=2.29 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.95 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.004 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter Boolean transDat=true "use transient data";
  parameter Boolean use_xtr=true "use x_transient and t_closed?";
  parameter SIpu.Reactance[:] xtr_d={0.361123, 0.283696}
      "trans reactance d-axis {xtr_d', xtr_d'', ..}";
  parameter SIpu.Reactance[:] xtr_q={0.464817, 0.303593}
      "trans reactance q-axis {xtr_q', xtr_q'', ..}";
  parameter SI.Time[:] tc_d={0.93133, 0.0253919}
      "time constant closed-loop d-axis {tc_d', tc_d'', ..}";
  parameter SI.Time[:] tc_q={0.270197, 0.041458}
      "time constant closed-loop q-axis {tc_q', tc_q'', ..}";
  parameter SI.Time[:] to_d={5.94309, 0.0321197}
      "time constant open-loop d-axis {to_d', to_d'', ..}";
  parameter SI.Time[:] to_q={1.207780, 0.0595723}
      "time constant open-loop q-axis {to_q', to_q'', ..}";
  parameter Boolean use_if0=true "induced field current and phase available?";
  parameter SIpu.Current if0=0.286 "induced field current at v_s=Vnom/0deg";
  parameter SIpu.Angle_deg if0_deg=-56
      "angle(if0) at v_s=Vnom/0deg (sign: i_f behind v_s)";
  parameter Real tol=1e-6 "tolerance precalculation";

// the corresponding equivalent circuit data are:
  parameter SIpu.Reactance xsig_s=0.2 "leakage reactance armature";
  parameter SIpu.Reactance[:] xsig_rd={0.1294, 0.03498}
      "leakage reactance rotor d-axis {f, D, ..}";
  parameter SIpu.Reactance[:] xsig_rq={0.3948, 0.1527}
      "leakage reactance rotor q-axis {Q1, ..}";
  parameter SIpu.Reactance[size(xsig_rd,1)-1] xm_d={0.05965}
      "coupling-reactance d-axis {xm1, ..}";
  parameter SIpu.Resistance[size(xsig_rd,1)] r_rd={1.321e-3, 14.38e-3}
      "resistance rotor d-axis {f, D, ..}";
  parameter SIpu.Resistance[size(xsig_rq,1)] r_rq={7.037e-3, 20.38e-3}
      "resistance rotor q-axis {Q1, ..}";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=20e3 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=1200e6 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=50 "nom frequency";
  parameter SI.Current If_nom=8000 "nom field current (V=V_nom at open term)";

  annotation (defaultComponentName="syn20k_1200M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Icon,
    Documentation(
          info="<html>
</html>
"), Diagram,
    DymolaStoredErrors);
end Synchron20kV_1200MVA;

record Synchron3rd60Hz26kV_720MVA
    "Synchronous machine, 3rd order model, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";
  final parameter Integer excite=1 "excitation (1:electric)"
    annotation(Evaluate=true);
  final parameter SIpu.MagneticFlux psi_pm(unit="pu")=0
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=1.9 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.77 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.005 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=26e3 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=720e6 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=60 "nom frequency";

  annotation (defaultComponentName="syn3rd60Hz26k_720M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end Synchron3rd60Hz26kV_720MVA;

record Synchron60Hz26kV_720MVA "Synchronous machine, example"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";
  final parameter Integer excite=1 "excitation (1:electric)"
    annotation(Evaluate=true);
  final parameter SIpu.MagneticFlux psi_pm(unit="pu")=0
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=1.9 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.77 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.005 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter Boolean transDat=true "use transient data";
  parameter Boolean use_xtr=true "use x_transient and t_closed?";
  parameter SIpu.Reactance[:] xtr_d={0.3290, 0.253}
      "trans reactance d-axis {xtr_d', xtr_d'', ..}";
  parameter SIpu.Reactance[:] xtr_q={0.436, 0.2730}
      "trans reactance q-axis {xtr_q', xtr_q'', ..}";
  parameter SI.Time[:] tc_d={0.7158, 0.02058}
      "time constant closed-loop d-axis {tc_d', tc_d'', ..}";
  parameter SI.Time[:] tc_q={0.2134, 0.03320}
      "time constant closed-loop q-axis {tc_q', tc_q'', ..}";
  parameter SI.Time[:] to_d={4.164, 0.02658}
      "time constant open-loop d-axis {to_d', to_d'', ..}";
  parameter SI.Time[:] to_q={0.9307, 0.04936}
      "time constant open-loop q-axis {to_q', to_q'', ..}";
  parameter Boolean use_if0=true "induced field current and phase available?";
  parameter SIpu.Current if0=0.835428 "induced field current at v_s=Vnom/0deg";
  parameter SIpu.Angle_deg if0_deg=-102.618
      "angle(if0) at v_s=Vnom/0deg (sign: i_f behind v_s)";
  parameter Real tol=1e-6 "tolerance precalculation";

// the corresponding equivalent circuit data are:
  parameter SIpu.Reactance xsig_s=0.17 "leakage reactance armature";
  parameter SIpu.Reactance[:] xsig_rd={0.1294, 0.03498}
      "leakage reactance rotor d-axis {f, D, ..}";
  parameter SIpu.Reactance[:] xsig_rq={0.3948, 0.1527}
      "leakage reactance rotor q-axis {Q1, ..}";
  parameter SIpu.Reactance[size(xsig_rd,1)-1] xm_d={0.05965}
      "coupling-reactance d-axis {xm1, ..}";
  parameter SIpu.Resistance[size(xsig_rd,1)] r_rd={1.321e-3, 14.38e-3}
      "resistance rotor d-axis {f, D, ..}";
  parameter SIpu.Resistance[size(xsig_rq,1)] r_rq={7.037e-3, 20.38e-3}
      "resistance rotor q-axis {Q1, ..}";

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=26e3 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=720e6 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=60 "nom frequency";
  parameter SI.Current If_nom=1800 "nom field current (V=V_nom at open term)";

   annotation (defaultComponentName="syn60Hz26k_720M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Icon,
    Documentation(
          info="<html>
</html>
"), Diagram,
    DymolaStoredErrors);
end Synchron60Hz26kV_720MVA;

record SynchronIso20kV_500MVA
    "Synchronous machine (isotropic), 3rd order model"
  extends Spot.Base.Icons.Record;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";
  final parameter Integer excite=1 "excitation (1:electric)"
    annotation(Evaluate=true);
  final parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.2
      "magnetisation (V/V_nom at open term at omega_nom)";
  parameter SIpu.Reactance x_d=1.6 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.6 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.01 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  parameter String units=Spot.Base.Types.pu "SI | pu";
  parameter SI.Voltage V_nom=20e3 "nom Voltage (= base if pu)";
  parameter SI.ApparentPower S_nom=500e6 "nom Power (= base if pu)";
  parameter SI.Frequency f_nom=50 "nom frequency";

  annotation (defaultComponentName="syn3rd20k_500M",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [20, 20]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon,
    Diagram);
end SynchronIso20kV_500MVA;
  annotation (preferedView="info",
Documentation(info="<html>
<p>Note: a correct value for S_nom is only needed, if you choose input in pu-units. In this case the 'nominal' values are chosen as base-values. For SI-units S_nom is not used. Nevertheless it must be defined. V_nom however is used to define voltage start values.</p>
</html>"));
end Machines;
