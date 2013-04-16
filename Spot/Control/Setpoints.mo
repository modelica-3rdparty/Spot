package Setpoints "Setpoints of generators"
  extends Base.Icons.Library;

  annotation (Documentation(info="<html>
</html>"));

block Set_w_p_v "Constant setpoints w, p, v for generation"

  Modelica.Blocks.Interfaces.RealOutput[3] setpts
      "setpoints {speed, power, voltage} pu"
    annotation (
          extent=[90,-10; 110,10],    rotation=0);
  protected
  parameter SIpu.AngularVelocity w_set(unit="pu", fixed=false)=1
      "setpt turbine speed pu";
  parameter SIpu.Power p_set(unit="pu", fixed=false)=1 "setpt turbine power pu";
  parameter SIpu.Voltage v_set(unit="pu", fixed=false)=1
      "setpt exciter voltage pu";
  annotation (defaultComponentName = "setpts1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
<p>The speed-, power-, and voltage setpoints setpts[1:3] are determined by the corresponding setpoint-parameters.<br>
With attribute 'fixed=false' these are fixed at steady-state initialisation.<br>
They depend on the chosen (initial) system-frequency f0, the initial terminal voltage and the initial active power.<br>
The setpoints are kept constant during simulation.</p>
</html>
"), Icon(
     Rectangle(extent=[0,80; 80,-80],     style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255})),
     Text(
    extent=[-60,-90; 140,-130],
    string="%name",
    style(color=0)),
        Rectangle(extent=[20,76; 60,-76], style(
            color=52,
            rgbcolor={230,250,180},
            fillColor=52,
            rgbfillColor={230,250,180})),
   Text(
  extent=[0,80; 80,40],
        string="w",
          style(
            color=10,
            rgbcolor={95,95,95},
            thickness=2)),
   Text(
  extent=[0,20; 80,-20],
        string="p",
          style(
            color=10,
            rgbcolor={95,95,95},
            thickness=2)),
   Text(
  extent=[0,-40; 80,-80],
        string="v",
          style(
            color=10,
            rgbcolor={95,95,95},
            thickness=2))),
    Diagram);

equation
  setpts[1] = w_set;
  setpts[2] = p_set;
  setpts[3] = v_set;
end Set_w_p_v;

block SetVariable_w_p_v "Variable setpoints w, p, v for generation"

  Modelica.Blocks.Interfaces.RealInput setpt_w "setpoint turbine speed pu"
    annotation (
          extent=[-30,50; -10,70],    rotation=0);
  Modelica.Blocks.Interfaces.RealInput setpt_p "setpoint turbine power pu"
    annotation (
          extent=[-30,-10; -10,10],   rotation=0);
  Modelica.Blocks.Interfaces.RealInput setpt_v "setpoint exciter voltage pu"
    annotation (
          extent=[-30,-70; -10,-50],  rotation=0);
  Modelica.Blocks.Interfaces.RealOutput[3] setpts
      "setpoints {speed, power, voltage} pu"
    annotation (
          extent=[90,-10; 110,10],    rotation=0);
  protected
  parameter SIpu.AngularVelocity w_set(unit="pu", fixed=false)=1
      "setpt turbine speed pu";
  parameter SIpu.Power p_set(unit="pu", fixed=false)=1 "setpt turbine power pu";
  parameter SIpu.Voltage v_set(unit="pu", fixed=false)=1
      "setpt exciter voltage pu";
  annotation (defaultComponentName = "setpts1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
<p>The speed-, power-, and voltage setpoints setpts[1:3] are are taken from inputs set_w, setpt_p, set_v.<br>
The setpoint parameters with attribute 'fixed=false' are fixed at steady-state initialisation and represent the steady-state initial values.<br>
They depend on the chosen (initial) system-frequency f0, the initial terminal voltage and the initial active power.</p>
</html>
"), Icon(
     Rectangle(extent=[0,80; 80,-80],     style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255})),
     Text(
    extent=[-60,-90; 140,-130],
    string="%name",
    style(color=0)),
   Text(
  extent=[0,80; 80,40],
        string="w",
          style(
            color=10,
            rgbcolor={95,95,95},
            thickness=2)),
   Text(
  extent=[0,20; 80,-20],
        string="p",
          style(
            color=10,
            rgbcolor={95,95,95},
            thickness=2)),
   Text(
  extent=[0,-40; 80,-80],
        string="v",
          style(
            color=10,
            rgbcolor={95,95,95},
            thickness=2))),
    Diagram);

initial equation
  setpts[1] = w_set;
  setpts[2] = p_set;
  setpts[3] = v_set;

equation
  setpts[1] = setpt_w;
  setpts[2] = setpt_p;
  setpts[3] = setpt_v;
end SetVariable_w_p_v;

block Set_w_p "Set-points for generation"

  parameter SIpu.AngularVelocity w_set(unit="pu", fixed=true)=1
      "setpoint turbine speed pu";
  Modelica.Blocks.Interfaces.RealInput setpt_p "setpoint turbine power pu"
    annotation (
          extent=[-30,-10; -10,10],   rotation=0);
  Modelica.Blocks.Interfaces.RealOutput[2] setpts "setpoints {speed, power} pu"
    annotation (
          extent=[90,-10; 110,10],    rotation=0);
  annotation (defaultComponentName = "setpts1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
<p>The speed setpoint setpts[1] is directly determined by the parameter w_set with attribute 'fixed=true'.<br>
The power setpoint setpts[2] is taken from input setpt_p.</p>
</html>
"), Icon(
     Rectangle(extent=[0,80; 80,-80],     style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255})),
     Text(
    extent=[-60,-90; 140,-130],
    string="%name",
    style(color=0)),
   Text(
  extent=[0,80; 80,40],
        string="w",
          style(color=10, rgbcolor={95,95,95})),
   Text(
  extent=[0,20; 80,-20],
        string="p",
          style(color=10, rgbcolor={95,95,95}))),
    Diagram);

equation
  setpts[1] = w_set;
  setpts[2] = setpt_p;
end Set_w_p;
end Setpoints;
