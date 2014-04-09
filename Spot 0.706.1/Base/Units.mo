within Spot.Base;
package Units "Units and nominal"
  extends Icons.Base;


partial model Nominal "Units and nominal values"

  parameter Base.Types.Units units=Types.pu "SI | pu"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Voltage V_nom(final min=0)=1 "nom Voltage (= base if pu)"
    annotation(Evaluate=true, Dialog(group="Nominal", enable=units==Types.pu));
  parameter SI.ApparentPower S_nom(final min=0)=1 "nom Power (= base if pu)"
    annotation(Evaluate=true, Dialog(group="Nominal", enable=units==Types.pu));
  annotation (
    Documentation(info="<html>
<p>'Nominal' values that are used to define 'base'-values in the case where input is in 'pu'-units</p>
<p>The parameter 'units' allows choosing between SI ('Amp Volt') and pu ('per unit') for input-parameters of components and output-variables of meters.<br>
The default setting is 'pu'.</p>
<p>pu ('per unit'):</p>
<pre>
  V_base = V_nom
  S_base = S_nom
  R_base = V_nom*V_nom/S_nom
  I_base = S_nom/V_nom
</pre>
<p>SI ('Amp Volt'):</p>
<pre>
  V_base = 1
  S_base = 1
  R_base = 1
  I_base = 1
</pre>
<p>Note that the choice between SI and pu does <b>not</b> affect state- and connector variables.
These remain <b>always</b> in SI-units. It only affects input of parameter values and output variables.</p>
</html>
"));
end Nominal;

partial model NominalAC "Units and nominal values AC"
  extends Nominal;

  parameter SI.Frequency f_nom=system.f_nom "nom frequency"
  annotation(Evaluate=true, Dialog(group="Nominal"), choices(choice=50 "50 Hz", choice=60 "60 Hz"));
  protected
  outer System system;
  annotation (
    Documentation(info="<html>
<p>Same as 'Nominal', but with additional parameter 'nominal frequency'.</p>
</html>
"));
end NominalAC;

partial model NominalDC "Units and nominal values DC"
  extends Nominal;

  parameter SIpu.AngularVelocity_rpm rpm_nom=system.rpm_nom "nom r.p.m."
    annotation(Evaluate=true, Dialog(group="Nominal"), choices(
    choice=3000 "3000 rpm",
    choice=3600 "3600 rpm",
    choice=1500 "1500 rpm",
    choice=1800 "1800 rpm"));
  protected
  outer System system;
  annotation (
    Documentation(info="<html>
<p>Same as 'Nominal', but with additional parameter 'nominal rpm'.</p>
</html>
"));
end NominalDC;

partial model NominalVI "Nominal values"

  parameter SI.Voltage V_nom(final min=0)=1 "nom Voltage"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Current I_nom(final min=0)=1 "nom Current"
    annotation(Evaluate=true, Dialog(group="Nominal"));

  annotation (
    Documentation(info="<html>
<p>Nominal values without units choice (see also 'Nominal').</p>
</html>
"));
end NominalVI;

record NominalData "Units and nominal data"
  extends Base.Icons.Record;
  extends Nominal;
end NominalData;

record NominalDataTrafo "Units and nominal data transformer"
  extends Base.Icons.Record;

  parameter Base.Types.Units units=Types.pu "SI | pu"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Voltage[:] V_nom(final min={0,0})={1,1}
      "{prim,sec} nom Voltage (= base if pu)"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.ApparentPower S_nom(final min=0)=1 "nom Power (= base if pu)"
    annotation(Evaluate=true, Dialog(group="Nominal",enable=units==Types.pu));
  parameter SI.Frequency f_nom=system.f_nom "nom frequency"
    annotation(Evaluate=true, Dialog(group="Nominal"), choices(choice=50 "50 Hz", choice=60 "60 Hz"));
  protected
  outer System system;
  annotation (
    Documentation(info="<html>
<p>'Nominal' values for transformers. Same as 'NominalAC, but with two components for voltage: {primary, secondary}. The winding ratio is indirectly defined through the voltage ratio.</p>
</html>"));
end NominalDataTrafo;

record NominalDataAC "Units and nominal data AC"
  extends NominalData;
  parameter SI.Frequency f_nom=50 "nom frequency"
  annotation(Evaluate=true, Dialog(group="Nominal"), choices(choice=50 "50 Hz", choice=60 "60 Hz"));
end NominalDataAC;

record NominalDataDC "Units and nominal data DC"
  extends NominalData;
  parameter SIpu.AngularVelocity_rpm rpm_nom=3000 "nom r.p.m."
    annotation(Evaluate=true, Dialog(group="Nominal"), choices(
    choice=3000 "3000 rpm",
    choice=3600 "3600 rpm",
    choice=1500 "1500 rpm",
    choice=1800 "1800 rpm"));
end NominalDataDC;

record NominalDataVI "Units and nominal data"
  extends Base.Icons.Record;
  extends NominalVI;
end NominalDataVI;
  annotation (preferredView="info",
Documentation(info="<html>
</html>
"));
end Units;
