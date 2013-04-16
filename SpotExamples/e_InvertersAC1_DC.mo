within SpotExamples;
package e_InvertersAC1_DC "Inverters 1 phase and DC"
  extends Spot.Base.Icons.Examples;
  annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.41,
  width=0.4,
  height=0.42,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Comparison of different one-phase rectifier and inverter models.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"), Icon);

  model Rectifier "Rectifier"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
<p>1-phase rectifier. Compare 'equation' and 'modular' version.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Algorithm="Lsodar"),
      experimentSetupOutput);
    inner Spot.System system(ini="tr", ref="inertial")
                        annotation (extent=[-100,80; -80,100]);
    Spot.Blocks.Signals.TransientPhasor transPh(
      t_change=0.1,
      t_duration=0.1,
      a_ini=2,
      a_fin=1)
         annotation (extent=[-100,20; -80,40]);
    Spot.AC1_DC.Sources.ACvoltage vAC(scType=Spot.Base.Types.sig, V_nom=100,
      pol=0)
          annotation (extent=[-80,0; -60,20]);
    Spot.AC1_DC.Impedances.Inductor ind(r={0.05,0.05},
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-50,0; -30,20]);
    Spot.AC1_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-20,0; 0,20]);
    Spot.AC1_DC.Inverters.Rectifier rectifier(rectifier(par=idealSC100V_10A))
      annotation (
            extent=[30,0; 10,20]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[40,0; 60,20]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0, V_nom=100)
      annotation (
            extent=[90,0; 70,20]);
    Spot.AC1_DC.Nodes.GroundOne grd1 annotation (extent=[-80,0; -100,20]);
    Spot.AC1_DC.Nodes.GroundOne grd2 annotation (extent=[90,0; 110,20]);
    Spot.Common.Thermal.BdCondV bdCond(m=2) annotation (extent=[10,20; 30,40]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(vAC.term, ind.term_p)
      annotation (points=[-60,10; -50,10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(ind.term_n, meterAC.term_p)
      annotation (points=[-30,10; -20,10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, vDC.term)
      annotation (points=[60,10; 70,10],
                                       style(color=3, rgbcolor={0,0,255}));
    connect(meterAC.term_n, rectifier.AC)
      annotation (points=[0,10; 10,10],style(color=3, rgbcolor={0,0,255}));
    connect(rectifier.DC, meterDC.term_p)
      annotation (points=[30,10; 40,10],
                                       style(color=3, rgbcolor={0,0,255}));
    connect(transPh.y, vAC.vPhasor)
                                  annotation (points=[-80,30; -64,30; -64,20],
        style(color=74, rgbcolor={0,0,127}));
    connect(grd1.term, vAC.neutral)
      annotation (points=[-80,10; -80,10], style(color=3, rgbcolor={0,0,255}));
    connect(vDC.neutral, grd2.term)
      annotation (points=[90,10; 90,10], style(color=3, rgbcolor={0,0,255}));
    connect(rectifier.heat, bdCond.heat)
      annotation (points=[20,20; 20,20], style(color=42, rgbcolor={176,0,0}));
  end Rectifier;

  model InverterToLoad "Inverter to load"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
<p>1-phase inverter, feeding load at constant 100Hz with increasing amplitude.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Algorithm="Lsodar"),
      experimentSetupOutput);
    inner Spot.System system(ini="tr", ref="inertial")
                        annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Sources.DCvoltage vDC(V_nom=100)
      annotation (
            extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-50,-20; -30,0]);
    Spot.AC1_DC.Inverters.Inverter inverter(redeclare
        Spot.AC1_DC.Inverters.Components.InverterEquation inverter(par=
            idealSC100V_10A) "equation, with losses")
      annotation (
            extent=[-20,-20; 0,0]);
    Spot.AC1_DC.Inverters.Select select(fType=Spot.Base.Types.par, f=100,
      uType=Spot.Base.Types.sig)   annotation (extent=[-20,20; 0,40]);
    Spot.AC1_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[10,-20; 30,0]);
    Spot.AC1_DC.ImpedancesOneTerm.Inductor ind(x=0.5, r=0.5,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[40,-20; 60,0]);
    Spot.Blocks.Signals.TransientPhasor vCtrl(
      t_change=0.05,
      t_duration=0.05,
      ph_fin=30*d2r,
      a_ini=1.05,
      a_fin=1.05)
         annotation (extent=[-50,40; -30,60],  rotation=0);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=2) annotation (extent=[-20,0; 0,20]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(vDC.term, meterDC.term_p)
      annotation (points=[-60,-10; -50,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (points=[-30,-10; -20,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, meterAC.term_p)
      annotation (points=[0,-10; 10,-10],
                                        style(color=3, rgbcolor={0,0,255}));
    connect(meterAC.term_n, ind.term)
      annotation (points=[30,-10; 40,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(select.theta_out, inverter.theta)
      annotation (points=[-16,20; -16,0],style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-4,20; -4,
          0],      style(color=74, rgbcolor={0,0,127}));
    connect(vCtrl.y, select.uPhasor) annotation (points=[-30,50; -4,50; -4,40],
        style(color=74, rgbcolor={0,0,127}));
    connect(grd.term, vDC.neutral)
      annotation (points=[-80,-10; -80,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.heat, bdCond.heat)
      annotation (points=[-10,0; -10,0], style(color=42, rgbcolor={176,0,0}));
  end InverterToLoad;

  model InverterToGrid "Inverter to grid"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
<p>3-phase inverter, feeding into grid with increasing phase. Compare 'switch', 'equation' and 'modular' version.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
      experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Algorithm="Lsodar"),
      experimentSetupOutput);
    inner Spot.System system(ini="tr", ref="inertial")
                        annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0,
      V_nom=100,
      v0=2)
      annotation (
            extent=[-90,-20; -70,0]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-60,-20; -40,0]);
    Spot.AC1_DC.Inverters.Inverter inverter(redeclare
        Spot.AC1_DC.Inverters.Components.InverterEquation inverter(par=
            idealSC100V_10A) "equation, with losses")
      annotation (
            extent=[-30,-20; -10,0]);
    Spot.AC1_DC.Inverters.Select select(uType=Spot.Base.Types.sig)
                                   annotation (extent=[-30,20; -10,40]);
    Spot.AC1_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[0,-20; 20,0]);
    Spot.AC1_DC.Impedances.Inductor ind(r={0.05,0.05},
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[50,-20; 30,0]);
    Spot.AC1_DC.Sources.ACvoltage vAC(V_nom=100)
          annotation (extent=[80,-20; 60,0]);
    Spot.Blocks.Signals.TransientPhasor vCtrl(
      ph_fin=30*d2r,
      t_change=0.1,
      t_duration=0.1,
      a_ini=1,
      a_fin=1)
         annotation (extent=[-60,40; -40,60]);
    Spot.AC1_DC.Nodes.GroundOne grd  annotation (extent=[80,-20; 100,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=2) annotation (extent=[-30,0; -10,20]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(vAC.term, ind.term_p)
      annotation (points=[60,-10; 50,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(vDC.term, meterDC.term_p)
      annotation (points=[-70,-10; -60,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(meterAC.term_n, ind.term_n)
      annotation (points=[20,-10; 30,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(select.theta_out, inverter.theta) annotation (points=[-26,20; -26,0],
               style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-14,20;
          -14,0],  style(color=74, rgbcolor={0,0,127}));
    connect(vCtrl.y, select.uPhasor) annotation (points=[-40,50; -14,50; -14,40],
        style(color=74, rgbcolor={0,0,127}));
    connect(vAC.neutral, grd.term)
      annotation (points=[80,-10; 80,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (points=[-40,-10; -30,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, meterAC.term_p)
      annotation (points=[-10,-10; 0,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(inverter.heat, bdCond.heat)
      annotation (points=[-20,0; -20,0], style(color=42, rgbcolor={176,0,0}));
  end InverterToGrid;

  model InverterAvToGrid "Inverter to grid"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
<p>1-phase inverter based on AVERAGED switch-equation, feeding into grid with increasing phase.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
      experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Algorithm="Lsodar"),
      experimentSetupOutput);
    inner Spot.System system(ini="tr", ref="inertial")
                        annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0,
      V_nom=100,
      v0=2)
      annotation (
            extent=[-90,-20; -70,0]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-60,-20; -40,0]);
    Spot.AC1_DC.Inverters.InverterAverage inverter(par=idealSC100V_10A)
      annotation (
            extent=[-30,-20; -10,0]);
    Spot.AC1_DC.Inverters.Select select(uType=Spot.Base.Types.sig)
                                   annotation (extent=[-30,20; -10,40]);
    Spot.AC1_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[0,-20; 20,0]);
    Spot.AC1_DC.Impedances.Inductor ind(r={0.05,0.05},
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[50,-20; 30,0]);
    Spot.AC1_DC.Sources.ACvoltage vAC(V_nom=100)
          annotation (extent=[80,-20; 60,0]);
    Spot.Blocks.Signals.TransientPhasor vCtrl(
      ph_fin=30*d2r,
      t_change=0.1,
      t_duration=0.1)
         annotation (extent=[-60,40; -40,60]);
    Spot.AC1_DC.Nodes.GroundOne grd  annotation (extent=[80,-20; 100,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=1) annotation (extent=[-30,0; -10,20]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(vAC.term, ind.term_p)
      annotation (points=[60,-10; 50,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(vDC.term, meterDC.term_p)
      annotation (points=[-70,-10; -60,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(meterAC.term_n, ind.term_n)
      annotation (points=[20,-10; 30,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(select.theta_out, inverter.theta) annotation (points=[-26,20; -26,0],
               style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-14,20;
          -14,0],  style(color=74, rgbcolor={0,0,127}));
    connect(vCtrl.y, select.uPhasor) annotation (points=[-40,50; -14,50; -14,40],
        style(color=74, rgbcolor={0,0,127}));
    connect(vAC.neutral, grd.term)
      annotation (points=[80,-10; 80,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (points=[-40,-10; -30,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, meterAC.term_p)
      annotation (points=[-10,-10; 0,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(inverter.heat, bdCond.heat)
      annotation (points=[-20,0; -20,0], style(color=42, rgbcolor={176,0,0}));
  end InverterAvToGrid;

  model Chopper "Chopper"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
<p>One quadrant chopper.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Algorithm="Lsodar"),
      experimentSetupOutput);
    inner Spot.System system(ini="tr", ref="inertial")
                        annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Sources.DCvoltage vDC(V_nom=100)
          annotation (extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sensors.PVImeter meterDCin(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-40,-20; -20,0]);
    Spot.AC1_DC.Inverters.Chopper chopper(chopper(par=idealSC100V_10A))
      annotation (
            extent=[-10,-20; 10,0]);
    Spot.AC1_DC.Sensors.PVImeter meterDCout(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[20,-20; 40,0]);
    Spot.Blocks.Signals.Transient vDCoutCtrl(
      t_change=0,
      t_duration=0.2,
      s_ini=0,
      s_fin=0.7)                             annotation (extent=[-40,20; -20,40]);
    Spot.AC1_DC.ImpedancesOneTerm.Inductor load(x=0.5, r=0.5,
      V_nom=100,
      S_nom=1e3)
      annotation (extent=[60,-20; 80,0]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=2) annotation (extent=[-10,0; 10,20]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(grd.term, vDC.neutral) annotation (points=[-80,-10; -80,-10], style(
          color=3, rgbcolor={0,0,255}));
    connect(vDC.term, meterDCin.term_p) annotation (points=[-60,-10; -40,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(meterDCin.term_n, chopper.DCin) annotation (points=[-20,-10; -10,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(chopper.DCout, meterDCout.term_p)
      annotation (points=[10,-10; 20,-10], style(color=3, rgbcolor={0,0,255}));
    connect(meterDCout.term_n, load.term)
      annotation (points=[40,-10; 60,-10], style(color=3, rgbcolor={0,0,255}));
    connect(vDCoutCtrl.y, chopper.uDC) annotation (points=[-20,30; 6,30; 6,0],
        style(color=74, rgbcolor={0,0,127}));
    connect(chopper.heat, bdCond.heat)
      annotation (points=[0,0; 0,0], style(color=42, rgbcolor={176,0,0}));
  end Chopper;

end e_InvertersAC1_DC;
