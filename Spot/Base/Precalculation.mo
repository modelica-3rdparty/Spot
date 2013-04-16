within Spot.Base;
package Precalculation "Precalculation functions"
  extends Icons.Base;

  annotation (preferedView="info",
        Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]), Window(
x=0.05,
y=0.44,
width=0.31,
height=0.23,
library=1,
autolayout=1),
    Documentation(info="<html>
<p>Functions needed for the determination of coefficient-matrices from a set of phenomenological input parameters.</p>
<p><a href=\"Spot.UsersGuide.Introduction.Precalculation\">up users guide</a></p>
<p>The second part of this package has been written in honour of <b>I. M. Canay</b>, one of the important electrical engeneers of the 20th century. He understood, what he wrote, and his results were exact. The package is based on his ideas and formulated in full mathematical generality.</p>
<p>Literature:
<ul>
<li>Canay, I. M.: Modelling of Alternating-Current Machines Having Multiple Rotor Circuits.<br>
IEEE Transactions on Energy Conversion, Vol. 8, No. 2, June 1993.</li>
<li>Canay, I. M.: Determination of the Model Parameters of Machines from the Reactance Operators x_d(p), x_q(p).<br>
IEEE Transactions on Energy Conversion, Vol. 8, No. 2, June 1993.</li>
</ul></p>
</html>"));

function baseV "Base voltage"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage V_nom "nom voltage";
  output SI.Voltage V_base "base voltage";
annotation(Documentation(info="<html>
<p>Calculates base-voltage depending on the choice of units.</p>
<p>\"pu\":
<pre>
  V_base = V_nom
</pre>
\"SI\":
<pre>
  V_base = 1
</pre></p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    V_base := V_nom;
  elseif units == Base.Types.SI then
    V_base := 1;
  end if;
end baseV;

function baseI "Base current"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage V_nom "nom voltage";
  input SI.ApparentPower S_nom "apparent power";
  output SI.Current I_base "base current";
annotation(Documentation(info="<html>
<p>Calculates base-current depending on the choice of units.</p>
<p>\"pu\":
<pre>
  I_base = S_nom/V_nom;
</pre>
\"SI\":
<pre>
  I_base = 1;
</pre></p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    I_base := S_nom/V_nom;
  elseif units == Base.Types.SI then
    I_base := 1;
  end if;
end baseI;

function baseS "Base power"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.ApparentPower S_nom "apparent power";
  output SI.ApparentPower S_base "base power";
annotation(Documentation(info="<html>
<p>Calculates base-power depending on the choice of units.</p>
<p>\"pu\":
<pre>
  S_base = S_nom
</pre>
\"SI\":
<pre>
  S_base = 1
</pre></p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    S_base := S_nom;
  elseif units == Base.Types.SI then
    S_base := 1;
  end if;
end baseS;

function baseR "Base resistance"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage V_nom "nom voltage";
  input SI.ApparentPower S_nom "apparent power";
  input Integer scale=1 "scaling factor topology (Y:1, Delta:3)";
  output SI.Resistance R_base "base resistance";
annotation (Documentation(info="<html>
<p>Calculates base-resistance depending on the choice of units.</p>
<p>\"pu\":
<pre>
  R_base = V_nom*V_nom/S_nom
</pre>
\"SI\":
<pre>
  R_base = 1
</pre></p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    R_base := scale*V_nom*V_nom/S_nom;
  elseif units == Base.Types.SI then
    R_base := scale;
  end if;
end baseR;

function baseL "Base inductance"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage V_nom "nom voltage";
  input SI.ApparentPower S_nom "apparent power";
  input SI.AngularFrequency omega_nom "angular frequency";
  output SI.Inductance L_base "base inductance";
annotation (Documentation(info="<html>
<p>Calculates base-inductance depending on the choice of units.</p>
<p>\"pu\":
<pre>
  L_base = V_nom*V_nom/(S_nom*omega_nom)
</pre>
\"SI\":
<pre>
  L_base = 1
</pre>
Note: in contrast to 'baseRL' and 'baseGC' there is NO conversion of reactance X to inductance L.<br>
Therefore the SI-value is 1 and not 1/omega_nom. The function is needed for DC-machines which use L as input instead of X.</p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    L_base := V_nom*V_nom/(S_nom*omega_nom);
  elseif units == Base.Types.SI then
    L_base := 1;
  end if;
end baseL;

function baseRL "Base resistance and inductance"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage V_nom "nom voltage";
  input SI.ApparentPower S_nom "apparent power";
  input SI.AngularFrequency omega_nom "angular frequency";
  input Integer scale=1 "scaling factor topology (Y:1, Delta:3)";
  output Real[2] RL_base "base {resistance, inductance}";
annotation (Documentation(info="<html>
<p>Calculates base-resistance and -inductance depending on the choice of units (fist component is R, second is L).</p>
<p>\"pu\":
<pre>
  RL_base = (V_nom*V_nom/S_nom)*{1, 1/omega_nom}
</pre>
\"SI\":
<pre>
  RL_base = {1, 1/omega_nom} (converts reactance X to inductance L!)
</pre></p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    RL_base := scale*(V_nom*V_nom/S_nom)*{1, 1/omega_nom};
  elseif units == Base.Types.SI then
    RL_base := scale*({1, 1/omega_nom});
  end if;
end baseRL;

function baseGC "Base conductance and capacitance"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage V_nom "nom voltage";
  input SI.ApparentPower S_nom "apparent power";
  input SI.AngularFrequency omega_nom "angular frequency";
  input Integer scale=1 "scaling factor topology (Y:1, Delta:3)";
  output Real[2] GC_base "base {conductance, capacitance}";
annotation (Documentation(info="<html>
<p>Calculates base-conductance and -capacitance depending on the choice of units (fist component is G, second is C).</p>
<p>\"pu\":
<pre>
  GC_base = (S_nom/V_nom*V_nom)*{1, 1/omega_nom}
</pre>
\"SI\":
<pre>
  GC_base = {1, 1/omega_nom} (converts susceptance B to capacitance C!)
</pre></p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    GC_base := (S_nom/(V_nom*V_nom))*{1, 1/omega_nom}/scale;
  elseif units == Base.Types.SI then
    GC_base := {1, 1/omega_nom}/scale;
  end if;
end baseGC;

function baseTrafoV "Base voltage transformers"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage[:] V_nom "nom voltage {prim, sec} or {prim, sec1, sec2}";
  output SI.Voltage[size(V_nom,1)] V_base
      "base voltage {prim,sec} or {prim, sec1, sec2}";
annotation(Documentation(info="<html>
<p>Calculates transformer base-voltage depending on the choice of units.</p>
<p>\"pu\":
<pre>
  V_base[k] = V_nom[k], k=1,2
</pre>
\"SI\":
<pre>
  V_base[k] = 1,    k=1,2
</pre></p>
</html>
"));

algorithm
  if units == Base.Types.pu then
    V_base := V_nom;
  elseif units == Base.Types.SI then
    V_base := ones(size(V_nom,1));
  end if;
end baseTrafoV;

function baseTrafoRL "Base resistance and inductance transformers"
  extends Icons.Function;

  input Base.Types.Units units "SI or pu";
  input SI.Voltage[:] V_nom "nom voltage {prim, sec} or {prim, sec1, sec2}";
  input SI.ApparentPower S_nom "apparent power";
  input SI.AngularFrequency omega_nom "angular frequency";
  output Real[size(V_nom,1), 2] RL_base "base [prim res, prim ind; sec res, sec ind] or
   [prim res, prim ind; sec1 res, sec1 ind; sec2 res, sec2 ind]";
annotation (Documentation(info="<html>
<p>Calculates transformer base-resistance and -inductance depending on the choice of units (first index: primary, secondary, second index: R, L).<br>
The secondary side is winding-reduced to the primary, as the equations are written in reduced form.</p>
<p>\"pu\":
<pre>
  RL_base = [V_nom[1]^2/S_nom          ] * [1, 1/omega_nom]
           [(V_nom[2]^2/S_nom)/W_nom^2]
</pre>
\"SI\":
<pre>
  RL_base[k] = [1        ] * [1, 1/omega_nom]
              [1/W_nom^2]
</pre></p>
<p>The winding ratio <tt>W_nom</tt> is given by the nominal voltages:
<pre>  W_nom = V_nom[2]/V_nom[1]</pre></p>
</html>"));

algorithm
  if units == Base.Types.pu then
    RL_base := fill(V_nom[1]^2/S_nom, size(V_nom,1), 1)*[1, 1/omega_nom];
  elseif units == Base.Types.SI then
    RL_base := [(fill(V_nom[1],size(V_nom,1))./ V_nom).^2]*[1, 1/omega_nom];
  end if;
end baseTrafoRL;

function machineDCser "Calculates coefficients of DC-machine series excited"
  extends Icons.Function;

  input AC1_DC.Machines.Parameters.DCser p "parameters DC machine series";
  output AC1_DC.Machines.Coefficients.DCser c "coefficients DC machine series";
  protected
  final parameter SI.AngularVelocity w_el_nom=p.pp*p.rpm_nom*Types.rpm2w;
  final parameter SI.Resistance R_base=baseR(p.units, p.V_nom, p.S_nom)
      "base resistance";
  final parameter SI.Inductance L_base=baseL(p.units, p.V_nom, p.S_nom, w_el_nom)
      "base resistance";
annotation(Documentation(info="<html>
</html>
"));

algorithm
  c.L := (p.l_fd + p.l_q)*L_base;
  c.R := {p.r_fd, p.r_q}*R_base;
  c.L_md := (p.V_nom^2/p.S_nom - sum(c.R))/w_el_nom;
end machineDCser;

function machineDCpar "Calculates coefficients of DC-machine parallel excited"
  extends Icons.Function;

  input AC1_DC.Machines.Parameters.DCpar p "parameters DC machine parallel";
  output AC1_DC.Machines.Coefficients.DCpar c
      "coefficients DC machine parallel";
  protected
  final parameter SI.AngularVelocity w_el_nom=p.pp*p.rpm_nom*Types.rpm2w;
  final parameter SI.Resistance R_base=baseR(p.units, p.V_nom, p.S_nom)
      "base resistance";
  final parameter SI.Inductance L_base=baseL(p.units, p.V_nom, p.S_nom, w_el_nom)
      "base resistance";
  SI.AngularFrequency w_el_lim;
annotation(Documentation(info="<html>
</html>
"));

algorithm
  c.L := {p.l_fd, p.l_q}*L_base;
  c.R := {p.r_fd, p.r_q}*R_base;
  w_el_lim := w_el_nom/(1 - c.R[2]*p.S_nom/p.V_nom^2);
  c.L_md := (c.R[1]/w_el_lim)*(p.V_nom/p.Vf_nom);
end machineDCpar;

function machineDCpm "Calculates coefficients of DC-machine permanent magnet"
  extends Icons.Function;

  input AC1_DC.Machines.Parameters.DCpm p "parameters DC machine pm";
  output AC1_DC.Machines.Coefficients.DCpm c "coefficients DC machine pm";
  protected
  final parameter SI.AngularVelocity w_el_nom=p.pp*p.rpm_nom*Types.rpm2w;
  final parameter SI.Resistance R_base=baseR(p.units, p.V_nom, p.S_nom)
      "base resistance";
  final parameter SI.Inductance L_base=baseL(p.units, p.V_nom, p.S_nom, w_el_nom)
      "base resistance";
annotation(Documentation(info="<html>
</html>
"));

algorithm
  c.L := p.l_aq*L_base;
  c.R := p.r_aq*R_base;
  c.Psi_pm := (p.V_nom - c.R*p.S_nom/p.V_nom)/w_el_nom;
end machineDCpm;

function machineAsyn "Calculates coefficient matrices of asynchronous machine"
  extends Icons.Function;

  input ACdqo.Machines.Parameters.Asynchron p "parameters asynchronous machine";
  input Integer n_r "number of rotor circuits";
  input Integer scale=1 "scaling factor topology (Y:1, Delta:3)";
  output ACdqo.Machines.Coefficients.Asynchron c(n_r=n_r)
      "coefficient matrices asynchronous machine";
  protected
  final parameter SI.AngularFrequency omega_nom=2*pi*p.f_nom;
  final parameter Real[2] RL_base=baseRL(p.units, p.V_nom, p.S_nom, omega_nom, scale)
      "base resistance inductance";

  SI.Angle[n_r] Tc "time constant closed-loop";
  SI.Angle[n_r] To "time constant open-loop";
  SI.Resistance[n_r+1] zr;
  SI.Reactance[n_r+1,n_r+1] zx;

annotation(Documentation(info="<html>
See also equivalent circuit on 'Diagram layer' of
<a href=\"Data.Parameters.Asynchron\">Data.Parameters.Asynchron</a> !</p>
</html>
"));

algorithm
  if p.transDat then
    if p.use_xtr then
      assert(size(p.tc,1) == size(p.xtr,1), "size of tc and xtr must be equal!");
    else
      assert(size(p.tc,1) == size(p.to,1), "size of tc and to must be equal!");
    end if;
    Tc := omega_nom*p.tc;
    To := if p.use_xtr then T_open(p.x, p.xtr, Tc) else omega_nom*p.to;
    (zr, zx) := z_fromTransDat(n_r, Tc, To, p.x, p.xsig_s, p.r_s, 0, 0, 0, false);
  else
    (zr, zx) := z_fromEqCirc(n_r, p.x, p.xsig_s, p.r_s, zeros(n_r-1), p.xsig_r, p.r_r);
  end if;

//  c.L_s := {p.x, p.x, p.x_o}*RL_base[2];
  c.L_s := {zx[n_r+1,n_r+1], zx[n_r+1,n_r+1], p.x_o}*RL_base[2];
  c.L_r := zx[1:n_r,1:n_r]*RL_base[2];
  c.L_m := zx[n_r+1,1:n_r]*RL_base[2];
  c.R_s := p.r_s*RL_base[1];
  c.R_r := zr[1:end-1]*RL_base[1];
  c.R_n := p.r_n*RL_base[1];
  if n_r == 1 then
    c.R_m := diagonal(c.R_r)*[1/c.L_r[1,1]]*c.L_m;
  else
    c.R_m := diagonal(c.R_r)*Modelica.Math.Matrices.inv(c.L_r)*c.L_m;
  end if;
end machineAsyn;

function machineSyn3rd
    "Calculates coefficient matrices of synchronous machine, 3rd order"
  extends Icons.Function;

  input ACdqo.Machines.Parameters.Synchron3rd p
      "parameters synchronous machine 3rd order";
  input Integer scale=1 "scaling factor topology (Y:1, Delta:3)";
  output ACdqo.Machines.Coefficients.Synchron3rd c
      "coefficient matrices synchronous machine 3rd order";
  final parameter SI.AngularFrequency omega_nom=2*pi*p.f_nom;
  protected
  final parameter Real[2] RL_base=baseRL(p.units, p.V_nom, p.S_nom, omega_nom, scale)
      "base resistance inductance";
annotation (Documentation(info="<html>
See also equivalent circuit on 'Diagram layer' of
<a href=\"Data.Parameters.Synchron3rd\">Data.Parameters.Synchron3rd</a> !</p>
</html>"));

algorithm
  c.L_s := {p.x_d, p.x_q, p.x_o}*RL_base[2];
  c.R_s := p.r_s*RL_base[1];
  c.R_n := p.r_n*RL_base[1];
  c.Psi_pm := p.psi_pm*(p.V_nom/omega_nom);
  c.omega_nom := omega_nom;
end machineSyn3rd;

function machineSyn "Calculates coefficient matrices of synchronous machine"
  extends Icons.Function;

  input ACdqo.Machines.Parameters.Synchron p "parameters synchronous machine";
  input Integer n_d "number of rotor circuits d-axis";
  input Integer n_q "number of rotor circuits q-axis";
  input Integer scale=1 "scaling factor topology (Y:1, Delta:3)";
  output ACdqo.Machines.Coefficients.Synchron c(n_d=n_d, n_q=n_q)
      "coefficient matrices synchronous machine";

  protected
  final parameter SI.AngularFrequency omega_nom=2*pi*p.f_nom;
  final parameter Real[2] RL_base=baseRL(p.units, p.V_nom, p.S_nom, omega_nom, scale)
      "base resistance inductance";
  final parameter SI.Current If_base=(p.x_d - p.xsig_s)*p.If_nom;
  final parameter Real if0_pu= if p.units=="pu" then p.if0 else p.if0/If_base;
  final parameter SI.Angle alpha_if0=(p.if0_deg + 180)*d2r
      "mathematical sign convention";

  SI.Angle[n_d] Tc_d "time constant closed-loop d-axis";
  SI.Angle[n_q] Tc_q "time constant closed-loop q-axis";
  SI.Angle[n_d] To_d "time constant open-loop d-axis";
  SI.Angle[n_q] To_q "time constant open-loop q-axis";
  SI.Resistance[n_d+1] zr_d;
  SI.Resistance[n_q+1] zr_q;
  SI.Reactance[n_d+1,n_d+1] zx_d;
  SI.Reactance[n_q+1,n_q+1] zx_q;
annotation (Documentation(info="<html>
See also equivalent circuit on 'Diagram layer' of
<a href=\"Data.Parameters.Synchron\">Data.Parameters.Synchron</a> !</p>
</html>"));

algorithm
  c.Psi_pm := p.psi_pm*(p.V_nom/omega_nom);
  if p.transDat then
    if p.use_xtr then
      assert(size(p.tc_d,1) == size(p.xtr_d,1), "size of tc_d and xtr_d must be equal!");
      assert(size(p.tc_q,1) == size(p.xtr_q,1), "size of tc_q and xtr_q must be equal!");
    else
      assert(size(p.tc_d,1) == size(p.to_d,1), "size of tc_d and to_d must be equal!");
      assert(size(p.tc_q,1) == size(p.to_q,1), "size of tc_q and to_q must be equal!");
    end if;
    Tc_d := omega_nom*p.tc_d;
    Tc_q := omega_nom*p.tc_q;
    To_d := if p.use_xtr then T_open(p.x_d, p.xtr_d, Tc_d) else omega_nom*p.to_d;
    To_q := if p.use_xtr then T_open(p.x_q, p.xtr_q, Tc_q) else omega_nom*p.to_q;
    if p.use_if0 and p.excite==1 then
      (zr_d, zx_d) := z_fromTransDat(n_d, Tc_d, To_d, p.x_d, p.xsig_s, p.r_s, if0_pu, alpha_if0, p.tol, true);
    else
      (zr_d, zx_d) := z_fromTransDat(n_d, Tc_d, To_d, p.x_d, p.xsig_s, p.r_s, 0, 0, p.tol, false);
    end if;
      (zr_q, zx_q) := z_fromTransDat(n_q, Tc_q, To_q, p.x_q, p.xsig_s, p.r_s, 0, 0, p.tol, false);
  else
    if p.use_if0 and p.excite==1 then
      (zr_d, zx_d) := z_fromEqCirc(n_d, p.x_d, p.xsig_s, p.r_s, p.xm_d, p.xsig_rd, p.r_rd);
    else
      (zr_d, zx_d) := z_fromEqCirc(n_d, p.x_d, p.xsig_s, p.r_s, zeros(n_d-1), p.xsig_rd, p.r_rd);
    end if;
      (zr_q, zx_q) := z_fromEqCirc(n_q, p.x_q, p.xsig_s, p.r_s, zeros(n_q-1), p.xsig_rq, p.r_rq);
  end if;

//  c.L_s := {p.x_d, p.x_q, p.x_o}*RL_base[2];
  c.L_s := {zx_d[n_d+1,n_d+1], zx_q[n_q+1,n_q+1], p.x_o}*RL_base[2];
  c.L_rd := zx_d[1:n_d,1:n_d]*RL_base[2];
  c.L_rq := zx_q[1:n_q,1:n_q]*RL_base[2];
  c.L_md := zx_d[n_d+1,1:n_d]*RL_base[2];
  c.L_mq := zx_q[n_q+1,1:n_q]*RL_base[2];
  c.R_s := p.r_s*RL_base[1];
  c.R_rd := zr_d[1:end-1]*RL_base[1];
  c.R_rq := zr_q[1:end-1]*RL_base[1];
  c.R_n := p.r_n*RL_base[1];
  c.wf := omega_nom*c.L_md[1]*p.If_nom/p.V_nom;
  c.Vf_nom := if p.excite==1 then (c.R_rd[1]/(c.wf*c.wf))*p.If_nom else 0;
  c.omega_nom := omega_nom;
end machineSyn;

function polyCoef "Calculates polynome coefficients from time constants"
  extends Icons.Function;
  input SI.Angle[:] T "time constant";
  output Real[size(T,1)] a "coefficients of polynome";
  protected
  parameter Integer n=size(T,1);

annotation (Documentation(info="<html>
<p>This function is related to <a href=\"Spot.Base.Math.polyCoefReal\">Math.polyCoefReal</a>, but modified for polynomes of the form
<pre>  product(1 + p*T[k]), k in 1:n</pre>
with real time constants <tt>T</tt>. It calculates the <tt>n</tt> coefficients of the powers 1:n of <tt>p</tt>
<pre>  a[k] for k in 1:n</pre>i.e. the constant factor 1 is omitted.</p>
<p>See also <a href=\"Spot.Base.Precalculation.polyTime\">polyTime</a></p>
</html>"));

algorithm
  a := fill(0, n);
  for k in 1:n loop
    a[1:k] := cat(1, {a[1] + T[k]}, a[2:k] + a[1:k-1]*T[k]);
  end for;
end polyCoef;

function polyTime "Calculates time constants from polynome coefficients"

  extends Icons.Function;

  input Real[:] a "coefficients of polynome";
  output SI.Angle[size(a,1)] T "time constant";
  output Boolean Tisreal "true if all time constants real";
  protected
  constant Real eps=Modelica.Constants.eps;
  parameter Integer n=size(a,1);
  Real[n, n] A;
  Real[n,2] lam "2nd index=1:2, real and imaginary part";
  function eigenValues = Modelica.Math.Matrices.eigenValues;
  function sortDown = Base.Math.sortDown;

annotation(Documentation(info="<html>
<p>This function is related to <a href=\"Spot.Base.Math.polyRoots\">Math.polyRoots</a>, but modified for polynomes of the form
<pre>  product(1 + p*T[k]), k in 1:n</pre>
It determines first the root vector <pre>  r[k] = -1/T[k], k in 1:n</p> and herefrom <tt>T</tt>. The time constants are sorted in descending order.</p>
<p>A boolean variable <tt>Tisreal</tt> indicates whether all time constants are real or not.</p>
<p>See also <a href=\"Spot.Base.Precalculation.polyCoef\">polyCoef</a></p>
</html>
"));

algorithm
  A[1, 1:n] := -cat(1, a[n-1:-1:1], {1})/a[n];
  A[2:n,1:n-1] := diagonal(ones(n-1));
  A[2:n,n] := zeros(n-1);
  lam := eigenValues(A);
  Tisreal := max(abs(lam[:, 2])) < eps;
  T := -ones(n)./lam[n:-1:1,1];
  T := sortDown(T);
end polyTime;

function x_transient
    "Calculates x_transient from x, T_closed, and T_open, forward transform"
  extends Icons.Function;

  input Real x(unit="pu") "total or syn reactance";
  input SI.Angle[:] Tc "time constant closed-loop";
  input SI.Angle[size(Tc,1)] To "time constant open-loop";
  output SIpu.Reactance[size(Tc,1)] xtr(unit="pu") "transient reactance";
  protected
  parameter Integer n=size(Tc,1);
  Real[n] y;
  Real[n-1] Tc_p;

annotation (Documentation(info="<html>
</html>"));

algorithm
  if n==0 then
    xtr:=fill(0, 0);
  elseif n==1 then
    y[1] := -(Tc[1] - To[1])/Tc[1];
    xtr[1] := x/(1 + y[1]);
  else
    for j in 1:n loop
      Tc_p := fill(Tc[j], n - 1) - cat(1, Tc[1:j - 1], Tc[j + 1:n]);
      y[j] := -product(fill(Tc[j], n) - To)/(Tc[j]*product(Tc_p));
    end for;
    xtr[1] := x/(1 + y[1]);
  end if;
  for j in 2:n loop
    xtr[j] := x*xtr[j - 1]/(x + xtr[j - 1]*y[j]);
  end for;
end x_transient;

function T_closed
    "Calculates T_closed from x, x_transient, and T_open, backward transform"
  extends Icons.Function;

  input SIpu.Reactance x(unit="pu") "total or syn reactance";
  input SIpu.Reactance[:] xtr(unit="pu") "transient reactance";
  input SI.Angle[size(xtr,1)] To "time constant open-loop";
  output SI.Angle[size(xtr,1)] Tc "time constant closed-loop";
  protected
  parameter Integer n=size(xtr,1);
  Real[n] y;
  Real[n] ac;
  Real[n-1,n] A;

annotation(Documentation(info="<html>
<p>Algorithm not implemented</p>
</html>"));

algorithm
  // not implemented
end T_closed;

function T_open
    "Calculates T_open from x, x_transient, and T_closed, backward transform"
  extends Icons.Function;

  input SIpu.Reactance x(unit="pu") "total or syn reactance";
  input SIpu.Reactance[:] xtr(unit="pu") "transient reactance";
  input SI.Angle[size(xtr,1)] Tc "time constant closed-loop";
  output SI.Angle[size(xtr,1)] To "time constant open-loop";
  protected
  parameter Integer n=size(xtr,1);
  Real[n] y;
  Real[n] ac;
  Real[n-1,n] A;
  Boolean Treal;
annotation (Documentation(info="<html>
</html>"));

algorithm
  if n ==0 then
  To := fill(0,0);
  else
  y := x./xtr;
  y := y - cat(1, {1}, y[1:end-1]);
  ac := polyCoef(Tc);
  for j in 1:n loop
    A[:,j] := polyCoef(cat(1, Tc[1:j-1], Tc[j+1:n]));
  end for;
  (To, Treal) := polyTime(ac*x/xtr[n] - cat(1, A*y, {0}));
  end if;
end T_open;

function i_field "Calculates complex field current"
  extends Icons.Function;

  input SIpu.Reactance[:] xm2_n(unit="pu") "approximate value of xm[2:n]";
  input Real[:] x_opt "additional input arguments";
  output Real dif2 "i_f*conjugate(i_f)";
  output Boolean result "true if Tsig real and convergence tol-ok";
  protected
  Integer n=size(xm2_n,1) + 1;
//x_opt collects the following 9 variables:
  Real[n] ac = x_opt[1:n];
  Real[n] ao = x_opt[n+1:2*n];
  Real[n] Tc = x_opt[2*n+1:3*n];
  Real[n] To = x_opt[3*n+1:4*n];
  Real xsig_s = x_opt[4*n+1];
  Real xm_s = x_opt[4*n+2];
  Real r_s = x_opt[4*n+3];
  Real[2] i_f0 = x_opt[4*n+4:4*n+5];
  Real tol = x_opt[4*n+6];

  Real qs;
  Real Tsig_s;
  Real[n] Tsig;
  Real[n] xsig;

  Types.Complex re=Types.re_unit;
  Types.Complex im=Types.im_unit;
  Types.Complex[n] Qsig;
  Types.Complex[n] Qo;
  Types.Complex[n] Qc;
  Types.Complex dif;
annotation(Documentation(info="<html>
<p>Calculates the complex field-current i_f, and outputs dif2 which is defined as follows:
<pre>
  i_f   complex field-current for actual impedance-parameters
  i_f0  desired (measured) field-current at nominal voltage /_ 0deg.
  di_f = i_f - i_f0            (complex difference)
  dif2 = di_f*conjugate(di_f)  (square of absolute value of difference)
</pre>
<p>The difference dif2 is used in order to determine the coupling terms xm[2:n] by a minimum-principle.</p>
</html>"));

algorithm
  qs :=xsig_s/(xm_s);
  Tsig_s := xsig_s/r_s;
  (Tsig, xsig, result) := Tsig_xsig(n, ac, ao, xsig_s, cat(1, {0}, xm2_n, {xm_s}), true, tol);

  for k in 1:n loop
    Qsig[k,:,:] := re + im*Tsig[k];
    Qc[k,:,:] := re + im*Tc[k];
    Qo[k,:,:] := re + im*To[k];
  end for;

  dif := -im*Tsig_s*Tsig[1]*Complex.prodC(Qsig[2:n,:,:])*
         Complex.invC(xsig[1]*(qs*Complex.prodC(Qo) + (1 + qs)*im*Tsig_s*Complex.prodC(Qc))) -
         (re*i_f0[1] + im*i_f0[2]);
  dif2 := Complex.detC(dif);
end i_field;

function Tsig_xsig "Calculates Tsig and xsig"
  extends Icons.Function;

  input Integer n "transient order";
  input Real[n] ac "polynome coefficient closed loop";
  input Real[n] ao "polynome coefficient open loop";
  input SIpu.Reactance xsig_s(unit="pu") "leakage reactance stator";
  input SIpu.Reactance[n+1] xm(unit="pu") "coupling reactance";
  input Boolean field "field winding yes/no";
  input Real tol "tolerance, iterative solution";
  output SI.Angle[n] Tsig "sig-time constants";
  output SIpu.Reactance[n] xsig(unit="pu") "leakage reactance rotor";
  output Boolean result "true if Tsig real and convergence tol-ok";
  protected
  final parameter Integer n1=n-1;
  constant Integer maxiter=10;
  Integer iter;
  Real qs;
  Real qm;
  Real qsm;
  Real[n] asig;
  Real[n] asig0;
  Real[n] bsig;
  Real[n] gsig;
  Real[n,n] A;
  Real[n,n] B;
  Real[n,n] C;
  Real[n] asig_prx;
  Real[n] gsig_prx;
  Real dasig;
  Real dgsig;
  function inv = Modelica.Math.Matrices.inv;

annotation (Documentation(info="<html>
<p>Calculates rotor leakage reactance xsig and corresponding time constants Tsig.</p>
<p>If transient order n &gt  3, the coefficients xm[2:n-2] are assumed to be 0.<br>
A different choice is not meaningful, as long as we only have 2 parameters (complex field-current) to fit.</p>
</html>"));

algorithm
  iter := 0;
  qs := xsig_s/xm[n+1];
  qm := xm[n]/xm[n+1];
  qsm :=(xsig_s + xm[n+1])/(xm[n+1]*xm[n+1]);

  bsig := qsm*(ao - ac);
  if not field then
    asig := ac - qs*(ao - ac);
    (Tsig, result) := polyTime(asig);
    for j in 1:n loop
      B[j,1] := Tsig[j];
      B[j,2:n] := polyCoef(cat(1, Tsig[1:j-1], Tsig[j+1:n]))*Tsig[j];
    end for;
    gsig := bsig*inv(B);
  elseif field then
    asig := ac - (qs + qm + qs*qm)*(ao - ac);
    (Tsig, result) :=polyTime(asig);
    if n < 3 then
      for j in 1:n loop
        B[j,1] := Tsig[j];
        B[j,2:n] := polyCoef(cat(1, Tsig[1:j-1], Tsig[j+1:n]))*Tsig[j];
      end for;
      gsig := bsig*inv(B);
    else
      dgsig := 1 + tol;
      dasig := 1 + tol;
      asig0 := asig;
      gsig :=zeros(n);
      while (dgsig > tol or dasig > tol) and iter < maxiter and result loop
        iter := iter + 1;
        gsig_prx := gsig;
        asig_prx := asig;
        for j in 1:n loop
          B[j,1] := Tsig[j];
          B[j,2:n] := polyCoef(cat(1, Tsig[1:j-1], Tsig[j+1:n]))*Tsig[j];
        end for;
        for j in 1:n1 loop
          C[j,1:2] := Tsig[j]*Tsig[n]*{0, 1};
          C[j,3:n] := polyCoef(cat(1, Tsig[1:j-1], Tsig[j+1:n1]))*Tsig[j]*Tsig[n];
        end for;
        C[n,1:n] :=zeros(n);
        A := B + xm[n1]*gsig[n]*C;
        A[n,:] := A[n, :] + xm[n1]*gsig*C;
        gsig :=(bsig + xm[n1]*gsig[n]*gsig*C)*inv(A);
        asig := asig0 - xm[n1]*gsig[1:n1]*B[1:n1,:];
        (Tsig, result) := polyTime(asig);
        dgsig := sum(abs(gsig - gsig_prx))/sum(abs(gsig));
        dasig := sum(abs(asig - asig_prx))/sum(abs(asig));
      end while;
      if iter == maxiter then
        result := false;
      end if;
    end if;
  end if;
  xsig := ones(n)./gsig;
end Tsig_xsig;

function z_fromTransDat "Calculates impedance matrix z from transient data"
  extends Icons.Function;

  input Integer n "transient order";
  input SI.Angle[n] Tc "time constant closed-loop";
  input SI.Angle[n] To "time constant open-loop";
  input SIpu.Reactance x(unit="pu") "total or syn reactance";
  input SIpu.Reactance xsig_s(unit="pu") "leakage reactance stator";
  input SIpu.Resistance r_s "resistance stator";
  input SIpu.Current if0(unit="pu") "field current";
  input SI.Angle alpha_if0
      "angle field current (sign: mathematical convention)";
  input Real tol "tolerance, iterative solution";
  input Boolean field "field winding yes/no";
  output SIpu.Resistance[n+1] zr(unit="pu") "impedance matrix resistive";
  output SIpu.Reactance[n+1,n+1] zx(unit="pu") "impedance matrix reactive";
  protected
  Real[n] ac;
  Real[n] ao;
  Real[n+1] xm;
  Real[n] Tsig;
  Real[n] xsig;
  Boolean result;
  function fminSearch = Base.Math.fminSearch;

annotation(Documentation(info="<html>
<p>See also analog circuit on 'Diagram layer' of 'CoefSynchron' and 'CoefAsynchron'!</p>
</html>"));

algorithm
  if n==0 then
    zr := {r_s};
    zx := [x];
  else
    ac := polyCoef(Tc);
    ao := polyCoef(To);
    xm := cat(1, zeros(n), {x - xsig_s});
    if field and n>1 then //minimises deviation from desired i_f
///// possible start-values:
      if n==2 then
        xm[n] := 0.06;
      elseif n>2 then
        xm[n-1:n] := {0.02,0.04};
      end if;
///// may be eliminated after modification of fminSearch!
      (xm[2:n],) := fminSearch(xm[2:n],
      cat(1, ac, ao, Tc, To, {xsig_s}, {xm[n+1]}, {r_s}, if0*{cos(alpha_if0),sin(alpha_if0)}, {tol}));
    end if;

    (Tsig, xsig, result) := Tsig_xsig(n, ac, ao, xsig_s, xm, field, tol);
    assert(result, "Tsig and xsig may be false, no convergence, or complex time-constants");

    zr := cat(1, xsig./Tsig, {r_s});
    zx := diagonal(cat(1, xsig, {xsig_s}));

    for k in 2:n+1 loop
      zx[1:k,1:k] := zx[1:k,1:k] + fill(xm[k], k, k);
    end for;
  end if;
end z_fromTransDat;

function z_fromEqCirc "Calculates impedance matrix z from equivalent circuit"
  extends Icons.Function;

  input Integer n "transient order";
  input SIpu.Reactance x(unit="pu") "total or syn reactance";
  input SIpu.Reactance xsig_s(unit="pu") "leakage reactance stator";
  input SIpu.Resistance r_s(unit="pu") "resistance stator";
  input SIpu.Reactance[n-1] xm2_n(unit="pu") "coupling reactance";
  input SIpu.Reactance[n] xsig_r(unit="pu") "leakage reactance rotor";
  input SIpu.Resistance[n] r_r(unit="pu") "resistance rotor";
  output SIpu.Resistance[n+1] zr(unit="pu") "impedance matrix resistive";
  output SIpu.Reactance[n+1,n+1] zx(unit="pu") "impedance matrix reactive";

annotation (Documentation(info="<html>
<p>See also analog circuit on 'Diagram layer' of 'CoefSynchron' and 'CoefAsynchron'!</p>
</html>"));

algorithm
  zr := cat(1, r_r, {r_s});
  zx := diagonal(cat(1, xsig_r, {xsig_s}));
    for k in 2:n loop
      zx[1:k,1:k] := zx[1:k,1:k] + fill(xm2_n[k-1], k, k);
    end for;
  zx := zx + fill(x - xsig_s, n+1, n+1);
end z_fromEqCirc;

function equiCircuit "Calculates equivalent circuit from transient data"
  extends Icons.Function;

  input Integer n "transient order";
  input SI.Angle[n] Tc "time constant closed-loop";
  input SI.Angle[n] To "time constant open-loop";
  input SIpu.Reactance x(unit="pu") "total or syn reactance";
  input SIpu.Reactance xsig_s(unit="pu") "leakage reactance stator";
  input SIpu.Resistance r_s(unit="pu") "resistance stator";
  input SIpu.Current if0(unit="pu") "field current";
  input SI.Angle alpha_if0
      "angle field current (sign: mathematical convention)";
  input Real tol "tolerance, iterative solution";
  input Boolean field "field winding yes/no";
  output SIpu.Resistance[n] r_r(unit="pu") "resistance rotor";
  output SIpu.Reactance[n] xsig_r(unit="pu") "leakage reactance rotor";
  output SIpu.Reactance[n+1] xm(unit="pu") "coupling reactance";
  protected
  Real[n] ac;
  Real[n] ao;
  Real[n] Tsig;
  Real dif;
  Boolean result;
  function fminSearch = Base.Math.fminSearch;

annotation (Documentation(info="<html>
<p>This function is added for completeness. It is not used in the machine models.</p>
<p>See also analog circuit on 'Diagram layer' of 'CoefSynchron' and 'CoefAsynchron'!</p>
</html>"));

algorithm
  xm := cat(1, zeros(n), {x - xsig_s});
  if n==0 then
    r_r := fill(0,0);
    xsig_r := fill(0,0);
  else
    ac := polyCoef(Tc);
    ao := polyCoef(To);
    if field and n>1 then //minimises deviation from desired i_f
///// possible start-values:
      if n==2 then
        xm[n] := 0.06;
      elseif n>2 then
        xm[n-1:n] := {0.02,0.04};
      end if;
///// may be eliminated after modification of fminSearch!
      (xm[2:n], dif) := fminSearch(xm[2:n],
      cat(1, ac, ao, Tc, To, {xsig_s}, {xm[n+1]}, {r_s}, if0*{cos(alpha_if0),sin(alpha_if0)}, {tol}));
    end if;

    (Tsig, xsig_r, result) := Tsig_xsig(n, ac, ao, xsig_s, xm, field, tol);
    assert(result, "Tsig and xsig may be false, no convergence, or complex time-constants");

    for k in 1:n loop
      r_r[k] := xsig_r[k]/Tsig[k];
    end for;
  end if;
end equiCircuit;

function transientData "Calculates transient data from equivalent circuit"
  extends Icons.Function;

  input Integer n "transient order";
  input SIpu.Reactance x(unit="pu") "total or syn reactance";
  input SIpu.Reactance xsig_s(unit="pu") "leakage reactance stator";
  input SIpu.Resistance r_s(unit="pu") "resistance stator";
  input SIpu.Reactance[n-1] xm2_n(unit="pu") "coupling reactance";
  input SIpu.Reactance[n] xsig_r(unit="pu") "leakage reactance rotor";
  input SIpu.Resistance[n] r_r(unit="pu") "resistance rotor";
  output SI.Angle[n] Tc "time constant closed-loop";
  output SI.Angle[n] To "time constant open-loop";
  output SIpu.Reactance[n] xtr(unit="pu") "transient reactance";
  protected
  constant Real eps=Modelica.Constants.eps;
  Real[n+1] xm;
  Real[n+1,n+1] X;
  Real[n,n] X11;
  Real[n,n] X11ac;
  Real[n] sRinv;
  Real[n,2] lam "2nd index=1:2, real and imaginary part";
  function eigenValues = Modelica.Math.Matrices.eigenValues;
  function sortDown = Base.Math.sortDown;

annotation (Documentation(info="<html>
<p>This function is added for completeness. It is not used in the machine models.</p>
<p>See also analog circuit on 'Diagram layer' of 'CoefSynchron' and 'CoefAsynchron'!</p>
</html>"));

algorithm
  xm := cat(1, {0}, xm2_n, {x - xsig_s});

  X := diagonal(cat(1, xsig_r, {xsig_s}));
  for k in 2:n+1 loop
    X[1:k,1:k] := X[1:k,1:k] + xm[k]*ones(k,k);
  end for;

  X11 := diagonal(xsig_r);
  for k in 2:n loop
    X11[1:k,1:k] := X11[1:k,1:k] + xm[k]*ones(k,k);
  end for;
  X11 := X11 + xm[n+1]*ones(n,n);

  X11ac := transpose(X[n+1:n+1, 1:n])*transpose(X[1:n, n+1:n+1])/X[n + 1, n + 1];
  sRinv := ones(n)./sqrt(r_r);

  lam := eigenValues(diagonal(sRinv)*X11*diagonal(sRinv));
  To := sortDown(lam[:,1]);
  lam := eigenValues(diagonal(sRinv)*(X11 - X11ac)*diagonal(sRinv));
  Tc := sortDown(lam[:,1]);
  assert(max(abs(lam[:,2])) < eps, "spectrum open-loop is not real!");
  assert(max(abs(lam[:,2])) < eps,  "spectrum closed-loop is not real!");
  xtr := x_transient(x, Tc, To);
end transientData;
end Precalculation;
