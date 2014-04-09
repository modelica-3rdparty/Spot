# Spot

Free library providing components to model power systems both in transient and steady-state mode.

## Library description

Modelica is an equation-based simulation language. Theory of electro-technical devices and calculation-methods have been strongly influenced by the earlier use of analogue computers, leading to a 'diagrammatic' model description. In contrast to this tradition, models within this library are based on a clear set of equations rather than on a set of diagrams. In this sense the library has a didactic intention.

We distinguish AC three-phase systems from all other systems, mainly AC one-phase and DC systems. The three-phase system represents a very important and widespread, but special case, that deserves a special treatment. (The question whether to treat all AC-systems independent of phase-number within a common frame, or to consider the three-phase case as a special one needs to be answered on a more technical basis).

AC systems are periodically driven systems. An inherent limitation for efficient integration of such systems is the necessary small step size. It is always limited by a fraction of the period. This is the reason why different methods are used for different simulation purposes. Transient simulation in full generality can be performed for smaller systems. The simulation of large systems is normally restricted to 'power-flow' approximation. It corresponds to an infinitely fast electrical response as it replaces differential by algebraic equations. The different methods have also lead to different simulation tools.

It is one of the purposes of this library to treat both cases within one common framework and to bring the power-flow approximation closer to the general case. To this purpose we need a transformed representation of the standard electrical equations. It allows the separation of the trivial non-perturbed sinusoidal dynamics of the system from it's non-trivial transient behaviour. The transformed equations contain a steady-state or power-flow limit, obtained by choosing a synchronously rotating reference system and omitting the time-derivative.

The present implementation leads to a considerable increase of simulation speed for linear or linearised symmetric systems, compared to the direct representation. This is not (yet) the case for nonlinear systems or when sources containing harmonics are present.

As the electric equations are valid in reference systems with arbitrary angular orientation, the standard cases 'inertial' (non-rotating) and 'synchronous' (rotating with electrical frequency) system can simply be obtained by an appropriate parameter choice.

### Commercial successor "Electric Power Library"

There is a completely new and commercial [Electric Power Library](http://www.modelon.com/products/modelica-libraries/electrical-power-library/) available which is developed by the original author of the `Spot` library in cooperation with [Modelon](http://www.modelon.com).

## Current release

Download [Spot v0.706.1 (2014-04-09)](../../archive/v0.706.1.zip)

#### Release notes

* [Version v0.706.1 (2014-04-09)](../../archive/v0.706.1.zip)
 * Clean-up release removing illegal annotatons and upgrading to MSL 3.2.1
 * Be aware that there are still several issues with this library which might
   lead to several errors and warnings in the tool.

* [Version v0.706 (2007-09-11)](../../archive/v0.706.zip)
 * Structure improved.

## License

This Modelica package is free software and the use is completely at your own risk;
it can be redistributed and/or modified under the terms of the [Modelica License 1.1](https://modelica.org/licenses/ModelicaLicense1.1).

## Development and contribution
Author: [HansJ&uuml;rg Wiesmann](hj.wiesmann@bluewin.ch)

You may report any issues with using the [Issues](../../issues) button.

Contributions in shape of [Pull Requests](../../pulls) are always welcome.
