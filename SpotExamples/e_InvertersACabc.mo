within SpotExamples;
package e_InvertersACabc "Inverters abc"
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
<p>Comparison of different three-phase rectifier and inverter models.</p>
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
<p>3-phase rectifier. Compare 'equation' and 'modular' version.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
      experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Tolerance=1e-005,
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
    Spot.ACabc.Sources.Voltage vAC(scType=Spot.Base.Types.sig, V_nom=100)
          annotation (extent=[-80,0; -60,20]);
    Spot.ACabc.Impedances.Inductor ind(r=0.05,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-50,0; -30,20]);
    Spot.ACabc.Sensors.PVImeter meterAC(abc=true,
      V_nom=100,
      S_nom=1e3,
      phasor=true,
      av=true)
      annotation (
            extent=[-20,0; 0,20]);
    Spot.ACabc.Inverters.Rectifier rectifier(rectifier(par=idealSC100V_10A))
      annotation (
            extent=[30,0; 10,20]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(
      V_nom=100,
      S_nom=1e3,
      av=true)
      annotation (
            extent=[40,0; 60,20]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0, V_nom=100)
      annotation (
            extent=[90,0; 70,20]);
    Spot.ACabc.Nodes.GroundOne grd1 annotation (extent=[-80,0; -100,20]);
    Spot.ACabc.Nodes.GroundOne grd2 annotation (extent=[90,0; 110,20]);
    Spot.Common.Thermal.BdCondV bdCond(m=3) annotation (extent=[10,20; 30,40]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(rectifier.DC, meterDC.term_p)
      annotation (points=[30,10; 40,10],
                                       style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, vDC.term)
      annotation (points=[60,10; 70,10],
                                       style(color=3, rgbcolor={0,0,255}));
    connect(vAC.term, ind.term_p) annotation (points=[-60,10; -50,10], style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(ind.term_n, meterAC.term_p) annotation (points=[-30,10; -20,10],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(meterAC.term_n, rectifier.AC) annotation (points=[0,10; 10,10],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
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
<p>3-phase inverter, feeding load at constant 100Hz with increasing amplitude.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
      experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Tolerance=1e-005,
        Algorithm="Lsodar"),
      experimentSetupOutput);
    inner Spot.System system(ini="tr", ref="inertial")
                        annotation (extent=[-100,80; -80,100]);
    Spot.ACabc.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0, V_nom=100)
      annotation (
            extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[-50,-20; -30,0]);
    Spot.ACabc.Inverters.Inverter inverter(redeclare
        Spot.ACabc.Inverters.Components.InverterEquation inverter(par=
            idealSC100V_10A) "equation, with losses")
      annotation (
            extent=[-20,-20; 0,0]);
    Spot.ACabc.Inverters.Select select(fType=Spot.Base.Types.par, f=100,
      uType=Spot.Base.Types.sig)  annotation (extent=[-20,20; 0,40]);
    Spot.ACabc.Sensors.PVImeter meterAC(
      abc=true,
      av=true,
      tcst=0.1,
      V_nom=100,
      S_nom=1e3,
      phasor=true)
      annotation (
            extent=[10,-20; 30,0]);
    Spot.ACabc.Loads.PQindLoad pqLoad(tcst=0.01, imax=1,
      V_nom=100,
      S_nom=1e3)                      annotation (extent=[40,-20; 60,0]);
    Spot.Blocks.Signals.TransientPhasor vCtrl(
      t_change=0.05,
      t_duration=0.05,
      a_ini=0)
         annotation (extent=[-50,40; -30,60]);
    Spot.Common.Thermal.BdCondV bdCond(m=3) annotation (extent=[-20,0; 0,20]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(vDC.term, meterDC.term_p)
      annotation (points=[-60,-10; -50,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (points=[-30,-10; -20,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, meterAC.term_p) annotation (points=[0,-10; 10,-10],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(select.theta_out, inverter.theta)
      annotation (points=[-16,20; -16,0],style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-4,20; -4,
          0],      style(color=74, rgbcolor={0,0,127}));
    connect(vCtrl.y, select.uPhasor) annotation (points=[-30,50; -4,50; -4,40],
        style(color=74, rgbcolor={0,0,127}));
    connect(meterAC.term_n, pqLoad.term) annotation (points=[30,-10; 40,-10],
        style(color=70, rgbcolor={0,130,175}));
    connect(inverter.heat, bdCond.heat)
      annotation (points=[-10,0; -10,0], style(color=42, rgbcolor={176,0,0}));
    connect(grd.term, vDC.neutral) annotation (points=[-80,-10; -80,-10], style(
          color=3, rgbcolor={0,0,255}));
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
</html>
"),   experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Tolerance=1e-005,
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
    Spot.ACabc.Inverters.Inverter inverter(redeclare
        Spot.ACabc.Inverters.Components.InverterEquation inverter(par=
            idealSC100V_10A) "equation, with losses")
      annotation (
            extent=[-30,-20; -10,0]);
    Spot.ACabc.Inverters.Select select(uType=Spot.Base.Types.sig)
                                  annotation (extent=[-30,20; -10,40]);
    Spot.ACabc.Sensors.PVImeter meterAC(
      av=true,
      tcst=0.1,
      V_nom=100,
      S_nom=1e3,
      phasor=true,
      abc=true)
      annotation (
            extent=[0,-20; 20,0]);
    Spot.ACabc.Impedances.Inductor ind(r=0.05,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[50,-20; 30,0]);
    Spot.ACabc.Sources.Voltage vAC(V_nom=100)
          annotation (extent=[80,-20; 60,0]);
    Spot.Blocks.Signals.TransientPhasor vCtrl(
      ph_fin=30*d2r,
      t_change=0.1,
      t_duration=0.1)
         annotation (extent=[-60,40; -40,60]);
    Spot.ACabc.Nodes.GroundOne grd  annotation (extent=[80,-20; 100,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=3) annotation (extent=[-30,0; -10,20]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(vDC.term, meterDC.term_p)
      annotation (points=[-70,-10; -60,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (points=[-40,-10; -30,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, meterAC.term_p) annotation (points=[-10,-10; 0,-10],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(meterAC.term_n, ind.term_n) annotation (points=[20,-10; 30,-10],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(ind.term_p, vAC.term) annotation (points=[50,-10; 60,-10],
                                                                     style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(select.theta_out, inverter.theta) annotation (points=[-26,20; -26,0],
               style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-14,20;
          -14,0],  style(color=74, rgbcolor={0,0,127}));
    connect(vCtrl.y, select.uPhasor) annotation (points=[-40,50; -14,50; -14,40],
        style(color=74, rgbcolor={0,0,127}));
    connect(vAC.neutral, grd.term)
      annotation (points=[80,-10; 80,-10],
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
<p>3-phase inverter based on AVERAGED switch-equation, feeding into grid with increasing phase.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   experiment(
        StopTime=0.2,
        NumberOfIntervals=1000,
        Algorithm="Dassl"),
      experimentSetupOutput);
    inner Spot.System system(ini="tr")
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
    Spot.ACabc.Inverters.InverterAverage inverter(par=idealSC100V_10A)
      annotation (
            extent=[-30,-20; -10,0]);
    Spot.ACabc.Inverters.Select select(uType=Spot.Base.Types.sig)
                                  annotation (extent=[-30,20; -10,40]);
    Spot.ACabc.Sensors.PVImeter meterAC(
      abc=true,
      av=true,
      tcst=0.1,
      V_nom=100,
      S_nom=1e3,
      phasor=true)
      annotation (
            extent=[0,-20; 20,0]);
    Spot.ACabc.Impedances.Inductor ind(r=0.05,
      V_nom=100,
      S_nom=1e3)
      annotation (
            extent=[50,-20; 30,0]);
    Spot.ACabc.Sources.Voltage vAC(V_nom=100)
          annotation (extent=[80,-20; 60,0]);
    Spot.Blocks.Signals.TransientPhasor vCtrl(
      ph_fin=30*d2r,
      t_change=0.1,
      t_duration=0.1)
         annotation (extent=[-60,40; -40,60]);
    Spot.ACabc.Nodes.GroundOne grd  annotation (extent=[80,-20; 100,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=1) annotation (extent=[-30,0; -10,20]);
    Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(vDC.term, meterDC.term_p)
      annotation (points=[-70,-10; -60,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (points=[-40,-10; -30,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, meterAC.term_p) annotation (points=[-10,-10; 0,-10],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(meterAC.term_n, ind.term_n) annotation (points=[20,-10; 30,-10],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(ind.term_p, vAC.term) annotation (points=[50,-10; 60,-10],
                                                                     style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=62,
        rgbfillColor={0,120,120},
        fillPattern=1));
    connect(select.theta_out, inverter.theta) annotation (points=[-26,20; -26,0],
               style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-14,20;
          -14,0],  style(color=74, rgbcolor={0,0,127}));
    connect(vCtrl.y, select.uPhasor) annotation (points=[-40,50; -14,50; -14,40],
        style(color=74, rgbcolor={0,0,127}));
    connect(vAC.neutral, grd.term)
      annotation (points=[80,-10; 80,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(inverter.heat, bdCond.heat)
      annotation (points=[-20,0; -20,0], style(color=42, rgbcolor={176,0,0}));
  end InverterAvToGrid;

end e_InvertersACabc;
