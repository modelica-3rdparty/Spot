within ;
package Spot "Power-systems SPOT"
  extends Base.Icons.Library;
  import SI = Modelica.SIunits;
  import SIpu = Spot.Base.Types;
  import Modelica.Constants.pi;
  import Spot.Base.Types.d2r;
  import Spot.Base.TableDir;



package UsersGuide "Users Guide"


  package Introduction "Introduction"
    class Concept "Concept"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Concept of the Library</font></h3>
<p>Modelica is an equation-based simulation language. Theory of electro-technical devices and calculation-methods have been strongly influenced by the earlier use of
analogue computers, leading to a 'diagrammatic' model description. In contrast to this tradition, models within this library are based on a clear set of equations rather than on a set of diagrams. In
this sense the library has a didactic intention.</p>
<p>We distinguish AC three-phase systems from all other systems, mainly AC one-phase and DC systems. The three-phase system represents a very important and widespread, but special case, that deserves a special treatment. (The question whether to treat all AC-systems independent of phase-number within a common frame, or to consider the three-phase case as a special one needs to be answered on a more technical basis).</p>
<p>AC systems are periodically driven systems. An inherent limitation for efficient integration of such systems is the necessary small step size. It is always limited by a fraction of the period. This is the reason why different methods are used for different simulation purposes. Transient simulation in full generality can be performed for smaller systems. The simulation of large systems is normally restricted to 'power-flow' approximation. It corresponds to an infinitely fast electrical response as it replaces differential by algebraic equations. The different methods have also lead to different simulation tools.</p>
<p>It is one of the purposes of this library to treat both cases within one common framework and to bring the power-flow approximation closer to the general case. To this purpose we need a transformed representation of the standard electrical equations. It allows the separation of the trivial non-perturbed sinusoidal dynamics of the system from it's non-trivial transient behaviour. The transformed equations contain a steady-state or power-flow limit, obtained by choosing a synchronously rotating reference system and omitting the time-derivative.</p>
<p>The present implementation leads to a considerable increase of simulation speed for linear or linearised symmetric systems, compared to the direct representation. This is not (yet) the case for nonlinear systems or when sources containing harmonics are present.</p>
<p>As the electric equations are valid in reference systems with arbitrary angular orientation, the standard cases 'inertial' (non-rotating) and 'synchronous' (rotating with electrical frequency) system can simply be obtained by an appropriate parameter choice.</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Concept;

    class System "System"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">System Component</font></h3>
<p>The model <a href=\"Spot.System\"><b>System</b></a> represents a global reference for the following purposes:</p>
<p>It allows choosing</p>
<ul>
<li> nominal frequency (default 50 or 60 Hertz)
<li> actual system frequency or initial system frequency, depending on frequency type</li>
<li> frequency type: parameter, signal, or average (machine-dependent) system frequency</li>
<li> lower and upper limit-frequencies</li>
<li> common phase angle for AC-systems</li>
<li> reference frame for AC-systems (inertial or synchronous systems)</li>
<li> transient or steady-state initialisation and simulation modes</li>
</ul>
<p>It provides</p>
<ul>
<li> the system angular-frequency system.omega<br>
<li> the system angle system.theta by integration of
<pre> der(system.theta) = system.omega </pre>
     This angle defines the orientation of a synchronously rotating electrical coordinate system.<br>
     It can be used by source-models (voltage, power, generator, inverter). See 'Interfaces', 'reference connectors'.</li>
</ul>
<p><b>Note</b>: Each model using <b>System</b> must use it with an
<b>inner</b> declaration and instance name <b>system</b>
in order that it can be accessed from all objects in the model.<br>
When dragging the 'System' from the package browser into the diagram layer,
declaration and instance name are automatically generated.</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end System;

    class Units "Units"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Units SI and pu</font></h3>
<p>Electric parameters can be defined either in SI or in pu ('per unit') units. Meters allow this choice for output-signals.<br>
Note that 'pu' only affects input-output and precalculation whereas the model equations always refer to SI.</p>
<p>The relation between values in SI- and pu-units is given by:</p>
<pre>  value_pu = value_SI/base_SI</pre>
<p>Base values are defined by nominal values in case of pu-units.<br>
As independent base-values (for electrical quantities) we use voltage and apparent power</p>
<pre>  V_base, S_base</pre>
<p>from which other values are deduced according to the relation</p>
<pre>
  I_base*V_base = S_base
  R_base*I_base = V_base
</pre>
<p>The relation between inductance L and impedance X or capacitance C and susceptance B involving a frequency according to</p>
<pre>
  omega*L = X
  omega*C = B
</pre>
<p>is always based on the nominal angular frequency</p>
<pre>  omega = omega_nom</pre>
<p><b>Norms, amplitudes and effective values, an example</b> (voltage 400 | 230 V)</p>
<p>abc-representation:</p>
<pre>
  v_abc  = {v_a, v_b, v_c}    voltage vector, phase to neutral
 |v_abc| = sqrt(v_abc*v_abc)  voltage three-phase norm
</pre>
<p>dqo-representation:</p>
<pre>
  v_dqo  = {v_d, v_q, v_o}    voltage vector, phase to neutral
 |v_dqo| = sqrt(v_dqo*v_dqo)  voltage three-phase norm
</pre>
<p>relation abc to dqo:</p>
<pre>
  v_dqo  = P*v_abc            P: orthogonal <a href=\"Spot.UsersGuide.Introduction.Transforms\">transform</a> abc to dqo
  vpp_dq  = P*(v_b - v_c), .. definition phase to phase voltage dq
 |v_abc| = |v_dqo|            as P orthogonal
</pre>
<table border=1 cellspacing=0 cellpadding=4>
<tr> <th></th> <th></th> <th><b>pu</b></th> <th><b>V</b></th> </tr>
<tr><td>Three-phase norm</td><td>|v_abc|</td><td><b>1</b></td><td><b>400</b></td></tr>
<tr><td>Single-phase amplitude</td><td>ampl (v_a), ..</td><td>sqrt(2/3)</td> <td>326</td> </tr>
<tr><td>Single-phase effective</td><td>eff (v_a), ..</td><td><b>1/sqrt(3)</b></td><td><b>230</b></td></tr>
<tr><td>Phase to phase amplitude</td><td>ampl (v_b - v_c), ..</td><td>sqrt(2)</td><td>565</td></tr>
<tr><td>Phase to phase effective</td><td>eff (v_b - v_c), ..</td><td><b>1</b></td><td><b>400</b></td></tr>
<tr><td>Three-phase norm</td><td>|v_dqo|</td><td><b>1</b></td><td><b>400</b></td> </tr>
<tr><td>Phase to phase dq-norm</td><td>|vpp_dq|</td><td>sqrt(2)</td><td>565</td></tr>
</table>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Units;

    class Frequency "Frequency"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">System and Autonomous Frequency</font></h3>
<p>The frequency concept must fulfil several conditions.</p>
<ul>
<li>First it should provide a common system frequency (50 | 60 Hz) that is either<br>
    (i) parameter specified, or more generally supplied as an input signal<br>
    (ii) a dynamical variable of the model, determined by the involved generators feeding the network.</li>
<li>Second it should allow handling several subsystems, each with autonomous frequency, within one common model.</li>
<li>Third it must allow both transient and steady-state simulation, and related to that the definition of rotating reference systems.</li>
</ul>
<p>A <b>system angular-frequency</b> omega is provided by the component 'System'. We have three choices:</p>
<p>a) <b>Parameter</b> system frequency.</p>
<p>a) <b>Signal</b> system angular frequency through signal input.</p>
<p>b) <b>Average</b> system angular frequency, obtained as weighted average over involved generators.</p>
<p>The corresponding <b>system-angle</b> theta is obtained by integrating</p>
<pre>  der(theta) = omega</pre>
<p>and is used within the sources (voltage- or power-sources, and inverters).<br>
Note: within a variable-frequency concept, <tt>theta</tt> can not be replaced by <tt>omega*time</tt>.</p>
<p>We distinguish two main cases:</p>
<p>A) Case <b>network</b>-frequency.<br>
All sources within a network-backbone have system-frequency (fType='sys').</p>
<p>B) Case <b>autonomous</b> frequency, independent of network frequency.<br>
The sources within a network-backbone have either parameter- or signal-frequency (fType='par' or 'sig').<br>
Frequency-independent sub-systems within one model can therefore easily be defined.</p>
<p>Note:<br>
<tt>&nbsp; &nbsp; <b>omega</b></tt> is used for electrical angular frequency,<br>
<tt>&nbsp; &nbsp; <b>w</b></tt> is used for mechanical angular frequency.</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Frequency;

    class Transforms "Transforms"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Coordinate Transforms</font></h3>
<p>We consider the current and voltage signals <tt>i</tt> and <tt>v</tt> of the three-phase system as abstract signal vectors that can be represented in different reference frames.<br>
In the following <tt>s</tt> is used for either <tt>i</tt> or <tt>v</tt>.<br>
We distinguish between an 'absolute' system (<tt>s_abc</tt>) and a manifold of transformed systems (<tt>s_abc_theta</tt> and <tt>s_dqo_theta</tt>) depending on a transformation angle <tt>theta</tt>.
<pre>
  s_abc           signals of phase a, b, c (R, S, T) in inertial frame 'abc'
  s_abc_theta     signals relative to a transformed frame 'abc'
  s_dqo_theta     signals relative to a transformed frame 'dqo'
</pre>
<p></p>
The relation between absolute and relative signals is given by orthogonal transforms
<a href=\"Spot.Base.Transforms.rotation_abc\">R_abc</a> and <a href=\"Spot.Base.Transforms.park\">P</a> according to the following transformation formula</p>
<pre>
  s_abc_theta = R_abc'*s_abc,  s_abc = R_abc*s_abc_theta
  s_dqo_theta = P*s_abc,       s_abc = P'*s_dqo_theta
</pre>
<p>where ' denotes 'transposed'. <tt>R_abc</tt> and <tt>P</tt> obey the orthogonality condition</p>
<pre>
  R_abc' = inverse(R_abc)
  P' = inverse(P)
</pre>
<p>Both R_abc and P depend on an angle <tt>theta</tt>.P can be factorised into a constant, angle independent matrix P0 and an angle-dependent rotation <a href=\"Spot.Base.Transforms.rotation_dqo\">R_dqo</a></p>
<pre>  P(theta) = R_dqo'(theta)*P0</pre>
<p>As the choice of <tt>theta</tt> is arbitrary, <tt>R_abc</tt> and <tt>P</tt> do not define one specific but a whole manifold
of abc- and dqo-systems.</p>
<p>Particular choices of practical importance are</p>
<ul>
<li> theta is the rotor angle of a machine, synchronous machine (Park) or asynchronous machine</li>
<li> theta is defined through
<pre>der(theta) = omega</pre>
     by the frequency omega of a source or a system-frequency</li>
<li> theta = 0<br>
     The resulting 'abc'-system is identical to the inertial (absolute) 'abc'-system.<br>
     (In the present context this is interpreted as abc(theta=0))<br>
     The resulting 'dqo'-system is traditionally called 'alpha-beta-gamma' system<br>
     (In the present context this is interpreted as dqo(theta=0))</li>
</ul>
<p>As a consequence of the orthogonality of <tt>R</tt> and <tt>P</tt> we obtain the invariance of power under all transforms</p>
<pre>  p = v_abc*i_abc = v_abc_theta*i_abc_theta = v_dqo_theta*i_dqo_theta</pre>
<p>The main difference between the transforms <tt>R_abc</tt> and <tt>P</tt> is the following:<br>
Whereas <tt>R_abc</tt> leaves impedance matrices of symmetrical systems invariant, P0 and P diagonalise these matrices. We have</p>
<pre>
         [xs, xm, xm]         [xs, xm, xm]
  R_abc'*[xm, xs, xm]*R_abc = [xm, xs, xm]
         [xm, xm, xs]         [xm, xm, xs]

         [xs, xm, xm]         [x, 0, 0 ]
       P*[xm, xs, xm]*P'    = [0, x, 0 ]     with
         [xm, xm, xs]         [0, 0, x0]

       x  = xs - xm       stray reactance (dq-components)
       x0 = xs + 2*xm     zero-reactance (o-component)
</pre>
<p>The 1:2 components of <tt>s_dqo_theta</tt> signals can be interpreted as <b>phasors</b> with respect to the frequency</p>
<pre>  omega = der(theta).</pre>They are equivalent to the corresponding complex representation.
<p>Historically <tt>P</tt> was introduced by <b>Park</b> in the context of synchronous machines.<br>
Here it is used in a generalised sense. Nevertheless we call it 'Park-transform'.</p>
<p><b>Note</b>: packages ACabc and ACdqo use v and i for the transformed variables.
<pre>
  ACabc: v = v_abc_theta, i = i_abc_theta
  ACdqo  v = v_dqo_theta, i = i_dqo_theta
</pre></p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Transforms;

    class Interfaces "Interfaces"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Interfaces and Ports</font></h3>
<p>Most connector-types exist as <b>pair</b>. Exceptions are the connectors for position and frequency (see <a href=\"Spot.Base.Interfaces\">Base.Interfaces</a>)<br>
We use consistently the indices <b>_p</b> for 'positive' and <b>_n</b> for 'negative' connectors, for all types, electrical, mechanical and thermal.<br>
Both connector types are physically identical. The only difference is the icon, filled for _p, empty for _n.</p>
<p>This choice allows a graphical definition of the positive direction in two-terminal components, from _p to _n.<br>
The sign of internal flow-variables is defined with respect to this direction.<br>
For one-terminal components an internal positive flow corresponds to an in-flow at _p and an out-flow at _n terminals.</p>
<p>Instances of electrical connectors are named 'term' for terminal, except in special cases.<br>
Instances of mechanical connectors are named 'flange' both for rotational and translational connectors.</p>
<p>We distinguish the following electrical connectors *)</p>
<pre>
  standard connectors 'Electric':  scalar variables v, i,                 square icon
  standard connectors 'ElectricV': vector-pin, pin variables v, i,        square rotated45 icon
  reference connectors 'ACabc':    theta[2], vector-variables v[3], i[3], circular icon
  reference connectors 'ACdqo':    theta[2], vector-variables v[3], i[3], circular icon
</pre>
<p>Standard electric connectors are used for <b>one-phase and DC systems</b>.<br>
<p>Reference connectors are needed for <b>three-phase systems</b>, representing a particularly important special case. They contain <tt>theta</tt> additionally to the variables <tt>v</tt> and <tt>i</tt>:
<pre>
  theta[1]:         relative angle (used in initial equations)
  theta[2]:         reference-angle (used in dynamical equations)
   with
  theta[1]+theta[2] = theta_root
</pre>
Each connected network-part contains a root-node, providing a frequency <tt>omega_root</tt> and by integration an angle <tt>theta_root</tt>. Only sources (voltage, power, generator, inverter) represent potential roots.<br>
The system parameter <tt>ref</tt> then allows running a model in an inertial or a synchronous reference frame.
<pre>
  theta = {theta_root, 0}     if ref = \"inertial\"
  theta = {0, theta_root}     if ref = \"synchron\"
</pre>
As <tt>theta</tt> is <b>transmitted</b> through all connections, a connected network part uses a <b>common</b> reference.<br>
The electric variables <tt>v</tt> and <tt>i</tt> refer to a coordinate system with angular orientation <tt>theta[2]</tt>. (see also <a href=\"Spot.UsersGuide.Introduction.Transforms\">Transforms</a>).
<p><b>Basic</b> one-, two-, and three-<b>ports</b> are defined, also using the indexing _p and _n.</p>
<pre>
  two-ports 'Port_p_n': no conservation of flow-variable (current)
  two-ports 'Port_pn':  conservation of flow variable (current_p + current_n = 0)
</pre>
<p><b>Special ports</b> are defined for 3-phase Y- or Delta-topology, and also for
switchable
Y_Delta-topology.</p>
<p>_____<br>*) The reason for this choice is the following:<br>
For three-phase systems it is useful to consider both voltage and current as abstract signal-vectors, which may be represented in different reference frames, related by appropriate transforms. It is natural and meaningful to transform vectors, whereas it is unnatural to transform 'pins', 'contacts' and the like.</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Interfaces;

    class Precalculation "Precalculation"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Precalculation</font></h3>
<p>This part of the library is a bit hidden, contained in the package 'Base.Precalculation'. The main purpose of this collection of functions is to determine coefficient matrices of electric model equations from standard measurement data or from equivalent circuit diagram data, in particular for electrical AC machines.</p>
<p>There are several different methods used for specifying machines.</p>
<ol>
<li>Specification of main reactance, transient reactance, open-loop time-constants</li>
<li>Specification of main reactance, closed-loop time-constants, open-loop time-constants</li>
<li>Specification of the analogue circuit diagram reactances and resistances</li>
<li>Direct specification of the impedance and resistance matrix</li>
</ol>
<p>The provided functions allow obtaining 4 from 1 or 2 or 3.
</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Precalculation;

    class Initialisation "Initialisation"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Transient and Steady-State Initialisation of three-phase models</font></h3>
<p>Periodically driven systems tend towards a periodic solution after some time, if the systems are damped. For certain applications it is desirable or even necessary, to start the model already in a periodic state.</p>
<p>The standard <b>steady-state</b> initial equation of an inductive and a capacitive device (for simplicity with constant coefficient matrices L and C) in an arbitrary reference frame (defined by <tt>theta[2]</tt>) is given by the dual equations</p>
<pre>
  der(i) = omega[1]*J*i;
  der(v) = omega[1]*J*v;
</pre>
<p>where</p>
<pre>
  omega[1] = der(theta[1])

      [ 0, -1,  1]
  J = [ 1,  0, -1] /sqrt(3)  (abc-representation)
      [-1,  1,  0]

      [ 0, -1,  0]
  J = [ 1,  0,  0]           (dqo-representation)
      [ 0,  0,  0]
</pre>
<p>Each model-component contains these initial equations in conditional form. The desired case can be selected by an appropriate choice of the parameter 'ini' in 'system'. When choosing transient initialisation, no specific initial equations are defined.</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Initialisation;

    class Simulation "Simulation"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Transient and Steady-State Simulation of three-phase models</font></h3>
<p>The terms 'transient' and 'steady-state' simulation of three-phase systems always refer to the <b>electrical</b> equations within a model. Other equations are not affected. The steady-state simulation is a meaningful approximation, if dynamic time-constants of electrical components are short compared to other time-constants as for example mechanical or thermal ones.</p>

<p>The standard <b>transient</b> form of an inductive and a capacitive device (for simplicity with constant coefficient matrices L and C) is given by the dual equations</p>
<pre>
  L*der(i) + omega[2]*L*J*i + R*i = v
  C*der(v) + omega[2]*C*J*v + G*v = i
</pre>
<p>where</p>
<pre>
  omega[2] = der(theta[2])

      [ 0, -1,  1]
  J = [ 1,  0, -1] /sqrt(3)  (abc-representation)
      [-1,  1,  0]

      [ 0, -1,  0]
  J = [ 1,  0,  0]           (dqo-representation)
      [ 0,  0,  0]
</pre>
<p>The simulation of a model in steady-state must assume a <b>synchronous</b> reference frame, i.e.
<pre>  theta[1]=0</pre></p>
<p>The <b>steady-state</b> approximation is then obtained from the above by setting the time-derivative der = 0.</p>
<pre>
  omega[2]*L*J*i + R*i = v
  omega[2]*C*J*v + G*v = i
</pre>
<p>It is obvious that going from transient to steady-state mode, differential equations are replaced by
algebraic ones.</p>
<p>As each model-component contains both types of equations, transient and steady, the desired case can be selected by an appropriate choice of the parameter 'sim' in 'system'.</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Simulation;

    class Visualisation "Visualisation"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Visualisation</font></h3>
<p>Power transfer in electric networks is strongly dependent on phase relations.
Therefore a rough dynamical visualisation of phasors and power flow is often useful.</p>
<p>For models in dqo-representation, phasors are directly obtained as first two components of voltage and current (dq-components).<br>
In abc-representation phasors are obtained by an appropriate
<a href=\"Spot.UsersGuide.Introduction.Transforms\">transform</a>.</p>
<p>Models using visualisation should be <b>synchronised with realtime</b><br>(ExperimentSetup/Realtime: Synchronize with realtime,<br>ExperimentSetup/Compiler: Microsoft VisualC++ with DDE).</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Visualisation;

    class Examples "Examples"

        annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Introductory Examples</font></h3>
<p>Each of the introductory examples points out one specific aspect of specifying and simulating a model.<br>
The examples are based on most elementary configurations. A meter is added for convenience.</p>
<ul>
<li><a href=\"SpotExamples.a_Introduction.Units\">Units</a><br>
    Alternative use of SI and pu ('per unit') units.</li>
<li><a href=\"SpotExamples.a_Introduction.Frequency\">Frequency</a><br>
    Uncoupled parts with system and with autonomous frequency.</li>
<li><a href=\"SpotExamples.a_Introduction.ReferenceInertial\">ReferenceInertial</a> <br>
    Inertial reference system (non-rotating).</li>
<li><a href=\"SpotExamples.a_Introduction.ReferenceSynchron\">ReferenceSynchron</a> <br>
   Synchronous reference system (rotating).</li>
<li><a href=\"SpotExamples.a_Introduction.InitialSteadyState\">InitialSteadyState</a><br>
    Steady-state initialisation.</li>
<li><a href=\"SpotExamples.a_Introduction.SimulationTransient\">SimulationTransient</a><br>
    Electrical equations in transient mode.</li>
<li><a href=\"SpotExamples.a_Introduction.SimulationSteadyState\">SimulationSteadyState</a><br>
    Electrical equations in steady-state mode.</li>
<li><a href=\"SpotExamples.a_Introduction.Display\">Display</a><br>
    Displays voltage and current phasors as well as active and reactive power flow.</li>
<li><a href=\"SpotExamples.a_Introduction.Tables\">Tables</a><br>
    Use of tables.</li>
</ul>
<p><b>All examples</b> see <a href=\"Spot.UsersGuide.Examples\">here</a>.</p>
<p><a href=\"Spot.UsersGuide.Introduction\">up</a></p>
</html>"));
    end Examples;

    annotation (Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Introduction</font></h3>
<p>The detailed <b>theoretical basis</b> of SPOT is published in the separate package <b>'SpotTheory'.</b></p>
<p><a href=\"Spot.UsersGuide\">up</a></p>
</html>"));
  end Introduction;

  class Overview "Overview"

    annotation (Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Overview over library content</font></h3>

<font color=\"#008000\">
<p>Note: 'abc' and 'dqo' denote different representations of the same physical models. See UsersGuide.Introduction.<br>
You may work with a reduced library according to your needs:</p>
<p>- You may copy Spot and remove ACabc, DrivesACabc and GenerationACabc<br>
- You may also remove instead ACdqo, DrivesACdqo and GenerationACdqo (less recommended!)<br>
- The corresponding packages in SpotExamples should then also be removed.</p>
</font>

<ul>
<li><a href=\"Spot.System\"><b>System</b></a><br>
Represents a global reference for the choice of system parameters and simulation modes.</li><br><br>

<li><a href=\"Spot.Base\"><b>Base</b></a><br>
Contains coefficient records, complex functions, icons, interfaces, mathematical- and precalculation-functions, transforms, type declarations mainly for alternative SI | pu types, and some rudimentary components for visualisation.</li><br><br>

<li><a href=\"Spot.AC1_DC\"><b>AC1_DC</b></a>, <a href=\"Spot.ACabc\"><b>ACabc</b></a>, <a href=\"Spot.ACdqo\"><b>ACdqo</b></a><br>
These three packages exhibit essentially the same structure. They contain the elementary electrical components for one-phase or DC and for three-phase AC applications.<br><br>
AC one-phase and DC components are modelled as two-conductor components, although the elementary impedances exist also in a one-conductor version. Sources, loads, shunts and the like therefore have one single electric connector, similar to their three-phase relatives. This also contributes to a more homogeneous appearance of the library, both for single components and for complete models. Yet it has also physical reasons, as for example a finite line impedance can only be defined using a pair-conductor.<br><br>
ACabc and ACdqo are complementary packages, treating identical three-phase components, one in abc-, the other in dqo-representation. Both declaration and equation part of the models keep an identical or analogous structure as far as possible.<br>
All AC models use connectors, containing the reference angles theta[1:2]. The angles are needed within the packages ACabc and ACdqo, theta[1] in the initial equations, theta[2] in the dynamical equations.</li><br><br>

<li><a href=\"Spot.Common\"><b>Common</b></a><br>
Common components: auxiliary blocks (multiplexers, special signals and transforms), simple idealised functions for iron-saturation, plasma-arcs of breakers or faults, a collection of ideal semiconductor components and modules, and kernel models for switches and breakers.</li><br><br>

<li><a href=\"Spot.Control\"><b>Control</b></a><br>
This package should <b>not</b> be considered as an exhaustive collection of control-components for power-systems. It contains elementary versions allowing the simulation of generators, drives and inverters:<br>
exciters for synchronous machines (generators), turbine governors, ignition tables and PWM-modulation for inverters, relays, setpoints and tap-change control (<i>presently still empty!</i>).</li><br><br>

<li><a href=\"Spot.DrivesACabc\"><b>AC-Drives abc</b></a>, <a href=\"Spot.DrivesACdqo\"><b>AC-Drives dqo</b></a>, <a href=\"Spot.DrivesDC\"><b>DC-Drives</b></a><br>
Contains AC-drives with asynchronous and synchronous machines, both with abc and dqo electric terminals, and DC-drives with electric and permanent magnet excitation.</li><br><br>

<li><a href=\"Spot.GenerationACabc\"><b>AC-Generation abc</b></a>, <a href=\"Spot.GenerationACdqo\"><b>AC-Generation dqo</b></a><br>
Contains generation packages with synchronous generators and turbines, both with abc and dqo electric terminals. Some of the models should be considered as example-models, as for example the turbo-group models.</li><br><br>

<li><a href=\"Spot.Mechanics\"><b>Mechanics</b></a><br>
Contains elementary mechanical components, both translational and rotational, that are needed for simulation of power-stations and rail vehicles.<br>
In addition it contains examples of turbo-groups and default-models for turbine torque.</li><br><br>
<li><a href=\"SpotExamples\"><b>Examples</b></a><br>
Introductory examples, example models for testing single components, drives, inverters, transformation, generation, transmission precalculation and some example data. Details are found under 'Examples'.</li><br><br>
</ul>
<p><a href=\"Spot.UsersGuide\">up</a></p>
</html>"));
  end Overview;

  class Examples "Examples"

      annotation (Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Package SpotExamples</font></h3>
<li><a href=\"SpotExamples.Data\"><b>Data</b></a><br>
Contains data records for breakers, lines, machines, transformers, and turbines.</li>
<p><a href=\"SpotExamples.a_Introduction\"><b>Introductory examples</b></a><br>
Each of the introductory examples points out one particular aspect of specifying and simulating a model.
The examples are based on most elementary configurations. A meter is added for convenience.
<a href=\"Spot.UsersGuide.Introduction.Examples\">details</a></p>
<p><a href=\"SpotExamples.b_AC1_DC\"><b>AC1_DC</b></a>,
   <a href=\"SpotExamples.c_ACabc\"><b>ACabc</b></a>,
   <a href=\"SpotExamples.c_ACdqo\"><b>ACdqo</b></a><br>
These packages provide small and simple test models, intended for testing custom components. The component inside the red rectangle may be replaced by a user defined version of similar type. The user is responsible for choosing reasonable parameter values.</p>
<p><a href=\"SpotExamples.d_DrivesACabc\"><b>AC Drives abc</b></a><br>
AC machines, terminals in abc-representation, containing electrical and mechanical motor models with optional gear.</p>
<ul>
<li><a href=\"SpotExamples.d_DrivesACabc.ASMcharacteristic\">ASMcharacteristic</a>  Asynchronous machine: characteristic torque vs slip.</li>
<li><a href=\"SpotExamples.d_DrivesACabc.ASM_Y_D\">ASM_Y_D</a>  AC asynchronous motor with switchable topology.</li>
<li><a href=\"SpotExamples.d_DrivesACabc.ASMav\">ASMav</a>  AC asynchronous motor with fixed topology. Time-average inverter.</li>
<li><a href=\"SpotExamples.d_DrivesACabc.ASM\">ASM</a>  AC asynchronous motor with fixed topology. Modulated inverter.</li>
<li><a href=\"SpotExamples.d_DrivesACabc.SM_ctrlAv\">SM_ctrlAv</a>  AC synchronous motor, current controlled. Time-average inverter.</li>
<li><a href=\"SpotExamples.d_DrivesACabc.SM_ctrl\">SM_ctrl</a>  AC synchronous motor, current controlled. Modulated inverter.</li>
</ul>
<p><a href=\"SpotExamples.d_DrivesACdqo\"><b>AC Drives dqo</b></a><br>
AC machines, terminals in dqo-representation, containing electrical and mechanical motor models with optional gear.</p>
<ul>
<li><a href=\"SpotExamples.d_DrivesACdqo.ASMcharacteristic\">ASMcharacteristic</a>  Asynchronous machine: characteristic torque vs slip.</li>
<li><a href=\"SpotExamples.d_DrivesACdqo.ASM_Y_D\">ASM_Y_D</a>  AC asynchronous motor with switchable topology.</li>
<li><a href=\"SpotExamples.d_DrivesACdqo.ASMav\">ASMav</a>  AC asynchronous motor with fixed topology. Time-average inverter.</li>
<li><a href=\"SpotExamples.d_DrivesACdqo.ASM\">ASM</a>  AC asynchronous motor with fixed topology. Modulated inverter.</li>
<li><a href=\"SpotExamples.d_DrivesACdqo.SM_ctrlAv\">SM_ctrlAv</a>  AC synchronous motor, current controlled. Time-average inverter.</li>
<li><a href=\"SpotExamples.d_DrivesACdqo.SM_ctrl\">SM_ctrl</a>  AC synchronous motor, current controlled. Modulated inverter.</li>
</ul>
<p><a href=\"SpotExamples.d_DrivesDC\"><b>DC Drives</b></a><br>
DC machines, containing electrical and mechanical motor models with optional gear.</p>
<ul>
<li><a href=\"SpotExamples.d_DrivesDC.DCmotor_ser\">DCmotor_ser</a>  DC motor series excited.</li>
<li><a href=\"SpotExamples.d_DrivesDC.DCmotor_par\">DCmotor_par</a>  DC motor parallel excited.</li>
<li><a href=\"SpotExamples.d_DrivesDC.DCmotor_pm\">DCmotor_pm</a>  DC motor permanent magnet excited.</li>
<li><a href=\"SpotExamples.d_DrivesDC.BLDC\">BLDC</a>  BLDC brushless DC motor (permanent magnet excited synchronous machine).</li>
<li><a href=\"SpotExamples.d_DrivesDC.DCcharSpeed\">DCcharSpeed</a>  DC motor: characteristic torque vs speed.</li>
<li><a href=\"SpotExamples.d_DrivesDC.BLDCcharSpeed\">BLDCcharSpeed</a>  BLDC motor: characteristic torque vs speed..</li>
</ul>
<p><a href=\"SpotExamples.e_InvertersAC1_DC\"><b>Inverters one-phase</b></a><br>
One-phase passive rectifier, controlled inverter and chopper in compact and modular implementation.</p>
<ul>
<li><a href=\"SpotExamples.e_InvertersAC1_DC.Rectifier\">Rectifier</a> Rectifier one-phase.</li>
<li><a href=\"SpotExamples.e_InvertersAC1_DC.InverterToLoad\">InverterToLoad</a> Inverter one-phase feeding load.</li>
<li><a href=\"SpotExamples.e_InvertersAC1_DC.InverterToGrid\">InverterToGrid</a> Modulated inverter one-phase coupled to grid.</li>
<li><a href=\"SpotExamples.e_InvertersAC1_DC.InverterAvToGrid\">InverterAvToGrid</a> Time-average inverter one-phase coupled to grid.</li>
<li><a href=\"SpotExamples.e_InvertersAC1_DC.Chopper\">Chopper</a> Chopper with load.</li>
</ul>
<p><a href=\"SpotExamples.e_InvertersACabc\"><b>Inverters abc</b></a><br>
Three-phase passive rectifier and controlled inverter abc in compact and modular implementation.</p>
<ul>
<li><a href=\"SpotExamples.e_InvertersACabc.Rectifier\">Rectifier</a> Rectifier abc.</li>
<li><a href=\"SpotExamples.e_InvertersACabc.InverterToLoad\">InverterToLoad</a> Inverter abc feeding load.</li>
<li><a href=\"SpotExamples.e_InvertersACabc.InverterToGrid\">InverterToGrid</a> Modulated inverter abc coupled to grid.</li>
<li><a href=\"SpotExamples.e_InvertersACabc.InverterAvToGrid\">InverterAvToGrid</a> Time-average inverter abc coupled to grid.</li>
</ul>
<p><a href=\"SpotExamples.e_InvertersACdqo\"><b>Inverters dqo</b></a><br>
Three-phase passive rectifier and controlled inverter dqo in compact and modular implementation.</p>
<ul>
<li><a href=\"SpotExamples.e_InvertersACdqo.Rectifier\">Rectifier</a> Rectifier dqo.</li>
<li><a href=\"SpotExamples.e_InvertersACdqo.InverterToLoad\">InverterToLoad</a> Inverter dqo feeding load.</li>
<li><a href=\"SpotExamples.e_InvertersACdqo.InverterToGrid\">InverterToGrid</a> Modulated inverter dqo coupled to grid.</li>
<li><a href=\"SpotExamples.e_InvertersACdqo.InverterAvToGrid\">InverterAvToGrid</a> Time-average inverter dqo coupled to grid.</li>
</ul>
<p><a href=\"SpotExamples.f_TransformationAC1ph\"><b>Transformation one-phase</b></a><br>
The concept for tap changer control is based on a transformer model with parameter-specified tap voltage-levels.<br>
The control part is treated as a separate component.</p>
<ul>
<li><a href=\"SpotExamples.f_TransformationAC1ph.OnePhase\">OnePhase</a>  One-phase transformers.</li>
<li><a href=\"SpotExamples.f_TransformationAC1ph.TapChanger\">TapChanger</a>  Tap changer control of one-phase transformers.</li>
</ul>
<p><a href=\"SpotExamples.f_TransformationACabc\"><b>Transformation abc</b></a><br>
Three-phase transformers show phase shifts for Delta/Y topology primary/secondary.<br>
The concept for tap changer control is based on a transformer model with parameter-specified tap voltage-levels.<br>
The control part is treated as a separate component.</p>
<ul>
<li><a href=\"SpotExamples.f_TransformationACabc.PhaseShifts\">PhaseShifts</a>  Topology dependent phase shifts of transformers.</li>
<li><a href=\"SpotExamples.f_TransformationACabc.TapChanger\">TapChanger</a>  Tap changer control.</li>
</ul>
<p><a href=\"SpotExamples.f_TransformationACdqo\"><b>Transformation dqo</b></a><br>
Three-phase transformers show phase shifts for Delta/Y topology primary/secondary.<br>
The concept for tap changer control is based on a transformer model with parameter-specified tap voltage-levels.<br>
The control part is treated as a separate component.</p>
<ul>
<li><a href=\"SpotExamples.f_TransformationACdqo.PhaseShifts\">PhaseShifts</a>  Topology dependent phase shifts of transformers.</li>
<li><a href=\"SpotExamples.f_TransformationACdqo.TapChanger\">TapChanger</a>  Tap changer control.</li>
</ul>
<p><a href=\"SpotExamples.g_GenerationACabc\"><b>Generation abc</b></a><br>
A series of examples intended for a better understanding of synchronous generator models, with an additional asynchronous generator. Electric terminal in abc-representation.</p>
<ul>
<li><a href=\"SpotExamples.g_GenerationACabc.Vsource\">Vsource</a>  Voltage (norm and phase) source.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.PVsource\">PVsource</a>  Active power and voltage (norm) source.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.PQsource\">PQsource</a>  Power (active and
  reactive) source.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.PowerAngle\">PowerAngle</a>  Generator without mechanical part, running at fixed power angle</li>
<li><a href=\"SpotExamples.g_GenerationACabc.TurbineGenerator\">TurbineGenerator</a>  Turbo-generator, in an 'unpacked' version.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.TurbineGeneratorLine\">TurbineGeneratorLine</a>  Turbo-generator with line, in an 'unpacked' version.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.TurboGeneratorLine\">TurboGeneratorLine</a>  Turbo-generator with line.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.GenOrder3and7\">GenOrder3and7</a>  Differences between low- and high-order electric models.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.TurboGroupGenerator\">TurboGroupGenerator</a>  Interaction between electrical and mechanical part.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.TieLine\">TieLine</a>  Interaction between machines.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.WindGeneratorLine\">WindGeneratorLine</a>  Asynchronous wind generator on line.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.Islanding\">Islanding</a>  Fast turbine with pm-generator in islanding configuration.</li>
<li><a href=\"SpotExamples.g_GenerationACabc.LocalGeneration\">Local generation</a>  Current-controlled pm-generator.</li>
</ul>
<p><a href=\"SpotExamples.g_GenerationACdqo\"><b>Generation dqo</b></a><br>
A series of examples intended for a better understanding of synchronous generator models, with an additional asynchronous generator. Electric terminal in dqo-representation.</p>
<ul>
<li><a href=\"SpotExamples.g_GenerationACdqo.Vsource\">Vsource</a>  Voltage (norm and phase) source.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.PVsource\">PVsource</a>  Active power and voltage (norm) source.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.PQsource\">PQsource</a>  Power (active and
  reactive) source.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.PowerAngle\">PowerAngle</a>  Generator without mechanical part, running at fixed power angle</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.TurbineGenerator\">TurbineGenerator</a>  Turbo-generator, in an 'unpacked' version.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.TurbineGeneratorLine\">TurbineGeneratorLine</a>  Turbo-generator with line, in an 'unpacked' version.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.TurboGeneratorLine\">TurboGeneratorLine</a>  Turbo-generator with line.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.GenOrder3and7\">GenOrder3and7</a>  Differences between low- and high-order electric models.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.TurboGroupGenerator\">TurboGroupGenerator</a>  Interaction between electrical and mechanical part.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.TieLine\">TieLine</a>  Interaction between machines.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.WindGeneratorLine\">WindGeneratorLine</a>  Asynchronous wind generator on line.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.Islanding\">Islanding</a>  Fast turbine with pm-generator in islanding configuration.</li>
<li><a href=\"SpotExamples.g_GenerationACdqo.LocalGeneration\">Local generation</a>  Current-controlled pm-generator.</li>
</ul>
<p><a href=\"SpotExamples.h_TransmissionACdqo\"><b>Transmission</b></a><br>
Shows basic principles and configurations.</p>
<ul>
<li><a href=\"SpotExamples.h_TransmissionACdqo.PowerTransfer\">PowerTransfer</a> Power flow
  and phase angle.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.VoltageStability\">VoltageStability</a>  Voltage stability.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.RXline\">RXline</a>  Lumped line model.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.PIline\">PIline</a>  Distributed line model.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.FaultRXline\">FaultRXline</a>  Single lumped line model with fault on line.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.FaultPIline\">FaultPIline</a>  Single distributed line model with fault on line.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.DoubleRXline\">DoubleRXline</a>  Double lumped line model with fault on one line.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.DoublePIline\">DoublePIline</a>  Double distributed line model with fault on one line.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.DoubleRXlineTG\">DoubleRXlineTG</a>  Turbo-generator and double lumped line model with fault on one line.</li>
<li><a href=\"SpotExamples.h_TransmissionACdqo.DoublePIlineTG\">DoublePIlineTG</a>  Turbo-generator and double distributed line model with fault on one line.</li>
</ul>
<p><a href=\"SpotExamples.p_Precalculation\"><b>Precalculation</b></a><br>
Calculation of Z-matrix from transient data or from equivalent circuit data.</p>
<p><a href=\"Spot.UsersGuide\">up</a></p>
</html>"));
  end Examples;

  class ReleaseNotes "Release notes"


  class Version_0_706_1 "Version 0.706.1"

      annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Version 0.706.1 (2014 April 9)</font></h3>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
<p>
A simple clean up version of the latest (undocumented) version 0.706 (2007 June). Annotations were cleaned up in order to get it to work properly with Modelica tools that follow the Modelica Specification.</p>

<p>
This version still uses the <em>Modelica Standard Library 2.2.2</em>.
</p>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
</html>"));
  end Version_0_706_1;

  class Version_0_705 "Version 0.705"

      annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Version 0.705 (2007 May 1)</font></h3>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
<p>
The following <b>changes</b> have been performed in the <b>Spot 0.705</b> library:
</p>
<ul>
<li>Restructuring of package 'Inverters' (1-phase, abc and dqo).</li>
<li>Packages 'Semiconductors' and 'Inverters' (in AC1_DC, ACabc, ACdqo) now contain heat losses due to forward voltage drop. Switching losses are included in time-average inverters, but are still missing in modulated inverters. Machine models contain winding losses.</li>
<li>Current controlled synchronous and asynchronous machines have been added.</li>
<li>Contains some auxiliary components, in particular thermal boundaries.</li>
</ul>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
</html>"));
  end Version_0_705;

  class Version_0_606 "Version 0.606"

      annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Version 0.606 (2006 June 26)</font></h3>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
<p>
The following <b>changes</b> have been performed in the <b>Spot 0.606</b> library:
</p>
<ul>
<li>Change of grounding concept for sources and machines (intuitively easier to understand):<br>
unconnected neutral is 'isolated neutral' (before: 'ideally grounded')</li>
<li>Inverters: introduced minimal switch-on time to avoid numerically singular cases. Some modification of example parameters.</li>
<li>Added thermal versions of three-phase rectifiers and inverters (preliminary versions!).</li>
</ul>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
</html>"));
  end Version_0_606;

  class Version_0_605 "Version 0.605"

      annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Version 0.605 (2006 May 01)</font></h3>
<p>Version 0.605 is not fully compatible with version 0.506.</p>
<p>
The following <b>changes</b> have been performed in the <b>Spot 0.605</b> library:
</p>
<ul>
<li>Restructuring and completion of library</li>
</ul>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
</html>"));
  end Version_0_605;

  class Version_0_506 "Version 0.506"

      annotation (Documentation(info="<html>
<h3><font color=\"#008000\">Version 0.506 (2005 June 01)</font></h3>
<p> This is the actual state of the SPOT library in development.</p>
<p><a href=\"Spot.UsersGuide.ReleaseNotes\">up</a></p>
</html>"));
  end Version_0_506;
    annotation (Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Release Notes</font></h3>
<h3><font color=\"#008000\">Actual version 0.705 (2007 May 1)</font></h3>
<p>Releases:</p>
<ul>
<li> <a href=\"Spot.UsersGuide.ReleaseNotes.Version_0_706_1\">Version 0.706.1</a> (2014 April 9)</li>
<li> <a href=\"Spot.UsersGuide.ReleaseNotes.Version_0_705\">Version 0.705</a> (2007 May 1)</li>
<li> <a href=\"Spot.UsersGuide.ReleaseNotes.Version_0_606\">Version 0.606</a> (2006 June 26)</li>
<li> <a href=\"Spot.UsersGuide.ReleaseNotes.Version_0_605\">Version 0.605</a> (2006 May 01)</li>
<li> <a href=\"Spot.UsersGuide.ReleaseNotes.Version_0_506\">Version 0.506</a> (2005 June 01)</li>
</ul>
<p><a href=\"Spot.UsersGuide\">up</a></p>
</html>"));
  end ReleaseNotes;

  class Contact "Contact"

    annotation (Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Contact</font></h3>
<dl>
<dt>Author of the power systems library 'SPOT':</dt><br>
<dd>Hans J&uuml;rg Wiesmann<br>
    Dr.sc.nat, dipl.phys. ETH<br>
    1973-2004: Corporate Research, ABB Switzerland<br><br>
<dt>Address:</dt><br>
<dd>Hans J&uuml;rg Wiesmann<br>
    CH-8607 Seegr&auml;ben (Z&uuml;rich)<br><br>
    email: <A HREF=\"mailto:hj.wiesmann@bluewin.ch\">hj.wiesmann@bluewin.ch</A></dd>
</dl>
<p><a href=\"Spot.UsersGuide\">up</a></p>
</html>"));
  end Contact;

  class ModelicaLicense "Modelica license"

    annotation (Documentation(info="<html>
<h3><font color=\"#008000\" size=5>The Modelica License
(Version 1.1 of June 30, 2000) </font></h3>
<p>Redistribution and use in source and binary forms, with or without
modification are permitted, provided that the following conditions are met:</p>
<ol>
<li>The author and copyright notices in the source files, these license conditions and the disclaimer below are (a) retained and (b) reproduced in the documentation provided with the distribution.</li>
<li>Modifications of the original source files are allowed, provided that a prominent notice is inserted in each changed file and the accompanying documentation, stating how and when the file was modified, and provided
that the conditions under (1) are met.</li>
<li>It is not allowed to charge a fee for the original version or a modified version of the software, besides a reasonable fee for distribution and support. Distribution in aggregate with other (possibly commercial) programs as part of a larger (possibly commercial) software distribution is permitted, provided that it is not advertised as a product of your own.</li>
</ol>
<h4><font color=\"#008000\">Disclaimer</font></h4>
<p>The software (sources, binaries, etc.) in their original or in a modified form are provided \"as is\" and the copyright holders assume no responsibility for its contents what so ever. Any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose are <b>disclaimed</b>. <b>In no event</b> shall the copyright holders, or any party who modify and/or redistribute the package, <b>be liable</b> for any direct, indirect, incidental, special, exemplary, or consequential damages, arising in any way out of the use of this software, even if advised of the possibility of such damage.</p>
<p><a href=\"Spot.UsersGuide\">up</a></p>
</html>"));
  end ModelicaLicense;
  annotation (DocumentationClass=true, Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Users Guide to the Modelica Power Systems Library SPOT</font></h3>
<p>The library is a Modelica package providing components to model
<br><b>power systems</b> both in <b>transient</b> and <b>steady-state</b> mode.</p>
<p>This package contains the <b>users guide</b> to the library.</p>
<p><a href=\"Spot\">up</a></p>
</html>"));
end UsersGuide;


  model System "System reference"

    parameter SI.Frequency f_nom=50 "nom frequency"
     annotation(Evaluate=true, Dialog(group="System"), choices(choice=50 "50 Hz", choice=60 "60 Hz"));
    parameter SI.Frequency f=f_nom "frequency (initial if fType='average') "
     annotation(Evaluate=true, Dialog(group="System"));
    parameter Base.Types.FreqType fType="par" "f: parameter, signal, average"
      annotation(Evaluate=true, Dialog(group="System"), choices(
       choice="par" "parameter",
       choice="sig" "signal (omega)",
       choice="ave" "average"));
    parameter SI.Frequency[2] f_lim={0.5*f_nom, 2*f_nom} "limit frequencies"
     annotation(Evaluate=true, Dialog(group="System",enable=fType==Base.Types.ave));
    parameter SI.Angle alpha0=0 "phase angle"
     annotation(Evaluate=true, Dialog(group="System"));
    parameter Base.Types.RefFrame ref="synchron" "reference frame (3-phase)"
      annotation(Evaluate=true, Dialog(group="System", enable=sim==Base.Types.tr), choices(
        choice="synchron",
        choice="inertial"));
    parameter Base.Types.Mode ini="st"
    "transient or steady-state initialisation"
     annotation(Evaluate=true, Dialog(group="Mode", enable=sim==Base.Types.tr), choices(
       choice="tr" "transient",
       choice="st" "steady"));

    parameter Base.Types.Mode sim="tr" "transient or steady-state simulation"
     annotation(Evaluate=true, Dialog(group="Mode"), choices(
       choice="tr" "transient",
       choice="st" "steady"));
    final parameter SI.AngularFrequency omega_nom=2*pi*f_nom
    "nom angular frequency"   annotation(Evaluate=true);
    final parameter SIpu.AngularVelocity_rpm rpm_nom=60*f_nom "nom r.p.m."
      annotation(Evaluate=true, Dialog(group="Nominal"));
    final parameter Boolean synRef=if transientSim then ref=="synchron" else true
      annotation(Evaluate=true);

    final parameter Boolean steadyIni = ini=="st"
    "steady state initialisation of electric equations"   annotation(Evaluate=true);
    final parameter Boolean transientSim = sim=="tr"
    "transient mode of electric equations"   annotation(Evaluate=true);
    final parameter Boolean steadyIni_t = steadyIni and transientSim
      annotation(Evaluate=true);

    SI.Time initime;
    SI.Angle theta(final start=0, final fixed=true, stateSelect=StateSelect.always);
    SI.AngularFrequency omega(final start=2*pi*f);
    Modelica.Blocks.Interfaces.RealInput omega_inp(min=0)
    "system ang frequency (optional, fType=sig)"
      annotation (Placement(transformation(
        origin={100,0},
        extent={{-10,-10},{10,10}},
        rotation=180)));
    Spot.Base.Interfaces.Frequency receiveFreq
    "receives weighted frequencies from generators"
     annotation (Placement(transformation(extent={{-96,64},{-64,96}}, rotation=
            0)));

  equation
    when initial() then
      initime = time;
    end when;
    if fType == Spot.Base.Types.par then
      omega = 2*pi*f;
    elseif fType == Spot.Base.Types.sig then
      omega = omega_inp;
    elseif fType == Spot.Base.Types.ave then
      omega = if initial() then 2*pi*f else receiveFreq.H_w/receiveFreq.H;
      when (omega < 2*pi*f_lim[1]) or (omega > 2*pi*f_lim[2]) then
        terminate("FREQUENCY EXCEEDS BOUNDS!");
      end when;
    end if;
    der(theta) = omega;
    annotation (
    preferedView="info",
    defaultComponentName="system",
    defaultComponentPrefixes="inner",
    missingInnerMessage="No \"system\" component is defined.
    Drag Spot.ACbase.System into the top level of your model.",
    Window(
      x=0.13,
      y=0.1,
      width=0.81,
      height=0.83),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,60}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,100},{100,60}},
          lineColor={215,215,215},
          textString =                        "%name"),
        Text(
          extent={{-100,50},{100,20}},
          lineColor={0,0,127},
          textString =                        "f_nom=%f_nom"),
        Text(
          extent={{-100,-20},{100,10}},
          lineColor={0,0,127},
          textString=
               "f:%fType"),
        Text(
          extent={{-100,-30},{100,-60}},
          lineColor={0,120,120},
          textString=
               "%ref"),
        Text(
          extent={{-100,-70},{100,-100}},
          lineColor={176,0,0},
          textString =                           "ini:%ini  sim:%sim")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Documentation(info="<html>
<p>The model <b>System</b> represents a global reference for the following purposes:</p>
<p>It allows the choice of </p>
<ul>
<li> nominal frequency (default 50 or 60 Hertz, but arbitrary positive choice allowed)
<li> system frequency or initial system frequency, depending on frequency type</li>
<li> frequency type: parameter, signal, or average (machine-dependent) system frequency</li>
<li> lower and upper limit-frequencies</li>
<li> common phase angle for AC-systems</li>
<li> synchronous or inertial reference frame for AC-3phase-systems</li>
<li> transient or steady-state initialisation and simulation modes<br>
     For 'transient' initialisation no specific initial equations are defined.<br>
     This case allows also to use Dymola's steady-state initialisation, that is DIFFERENT from ours.<br>
     <b>Note:</b> the parameter 'sim' only affects AC three-phase components.</li>
</ul>
<p>It provides</p>
<ul>
<li> the system angular-frequency omega<br>
     For frequency-type 'parameter' this is simply a parameter value.<br>
     For frequency-type 'signal' it is a positive input signal.<br>
     For frequency-type 'average' it is a weighted average over the relevant generator frequencies.
<li> the system angle theta by integration of
<pre> der(theta) = omega </pre><br>
     This angle allows the definition of a rotating electrical <b>coordinate system</b><br>
     for <b>AC three-phase models</b>.<br>
     Root-nodes defining coordinate-orientation will choose a reference angle theta_ref (connector-variable theta[2]) according to the parameter <tt>ref</tt>:<br><br>
     <tt>theta_ref = theta if ref = \"synchron\"</tt> (reference frame is synchronously rotating with theta).<br>
     <tt>theta_ref = 0 if ref = \"inertial\"</tt> (inertial reference frame, not rotating).<br>

     where<br>
     <tt>theta = 1 :</tt> reference frame is synchronously rotating.<br>
     <tt>ref=0 :</tt> reference frame is at rest.<br>
     Note: Steady-state simulation is only possible for <tt>ref = \"synchron\"</tt>.<br><br>
     <tt>ref</tt> is determined by the parameter <tt>refFrame</tt> in the following way:

     </li>
</ul>
<p><b>Note</b>: Each model using <b>System</b> must use it with an <b>inner</b> declaration and instance name <b>system</b> in order that it can be accessed from all objects in the model.<br>When dragging the 'System' from the package browser into the diagram layer, declaration and instance name are automatically generated.</p>
<p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
</html>"));
  end System;

annotation (preferedView="info",
  Window(
    x=0.02,
    y=0.01,
    width=0.2,
    height=0.57,
    library=1,
    autolayout=1),
  version="0.706.1",
  versionDate="2014-04-09",
  preferedView="text",
  Settings(NewStateSelection=true),
  Documentation(info="<html>
<h3><font color=\"#000080\" size=5>Modelica Power Systems Library SPOT</font></h3>
<p>The library is a Modelica package providing components to model<br>
<b>power systems</b> both in <b>transient</b> and <b>steady-state</b> mode.</p>
<p>The Users Guide to the library is <a href=\"Spot.UsersGuide\"><b>here</b></a>.</p>
<p>Copyright &copy; 2004-2007, H.J. Wiesmann.</p>
<p><i>The Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b>
<a href=\"Modelica://Modelica.UsersGuide.ModelicaLicense\">here</a>.</i></p>
</html>"),
  uses(Modelica(version="3.2.1")));
end Spot;
