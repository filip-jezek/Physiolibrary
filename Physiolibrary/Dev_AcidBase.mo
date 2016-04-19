within Physiolibrary;
package Dev_AcidBase

  package Proteins
  model ProteinBalance
        extends Physiolibrary.Icons.Proteins;
    Protein_synthesis synthesis
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    Protein_degradation degradation
      annotation (Placement(transformation(extent={{80,20},{100,40}})));
    Chemical.Components.Substance Proteins(solute_start=0.001448)
      annotation (Placement(transformation(extent={{-42,20},{-22,40}})));
    Chemical.Sensors.MolarFlowMeasure molarFlowMeasure
      annotation (Placement(transformation(extent={{-76,20},{-56,40}})));
    Modelica.Blocks.Math.Gain Albumin_charge_at_pH1(k=12)
        "Charge of new created albumin is fitted by Figge-fencl model. The total charge must be zero, thus exact amount of hydrogen ions has to be created together. They are then balanced by bicarbonate."
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-50,-10})));
    Chemical.Sources.UnlimitedSolutePumpOut unlimitedSolutePump(
        useSoluteFlowInput=true)
      annotation (Placement(transformation(extent={{-18,-52},{-38,-32}})));
    Chemical.Interfaces.ChemicalPort_a port_a
      annotation (Placement(transformation(extent={{-10,-106},{10,-86}})));
    Chemical.Sensors.MolarFlowMeasure molarFlowMeasure1
      annotation (Placement(transformation(extent={{50,20},{70,40}})));
    Modelica.Blocks.Math.Gain Albumin_charge_at_pH2(k=12)
        "Charge of new created albumin is fitted by Figge-fencl model. The total charge must be zero, thus exact amount of hydrogen ions has to be created together. They are then balanced by bicarbonate."
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={42,-8})));
    Chemical.Sources.UnlimitedSolutePump unlimitedSolutePump1(useSoluteFlowInput=true)
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={28,-42})));
    Chemical.Components.Substance HCO3(solute_start=0.0245)
      annotation (Placement(transformation(extent={{-58,-90},{-38,-70}})));
     // parameter Real a(fixed = false);

    Chemical.Sensors.ConcentrationMeasure concentrationMeasure
      annotation (Placement(transformation(extent={{2,40},{22,20}})));
    Physiomodel.Proteins.ProteinDivision proteinDivision
      annotation (Placement(transformation(extent={{16,56},{36,76}})));
  equation
   // HCO3.q_out.conc = 24.5;

    connect(synthesis.q_out, molarFlowMeasure.q_in) annotation (Line(
        points={{-80,30},{-80,30},{-76,30}},
        color={107,45,134},
        thickness=1));
    connect(Proteins.q_out, molarFlowMeasure.q_out) annotation (Line(
        points={{-32,30},{-32,30},{-56,30}},
        color={107,45,134},
        thickness=1));
    connect(molarFlowMeasure.molarFlowRate, Albumin_charge_at_pH1.u)
      annotation (Line(points={{-66,22},{-66,-10},{-62,-10}}, color={0,0,127}));
    connect(Albumin_charge_at_pH1.y, unlimitedSolutePump.soluteFlow)
      annotation (Line(points={{-39,-10},{-32,-10},{-32,-38}}, color={0,0,127}));
    connect(degradation.q_in, molarFlowMeasure1.q_out) annotation (Line(
        points={{80,30},{76,30},{70,30}},
        color={107,45,134},
        thickness=1));
    connect(molarFlowMeasure1.molarFlowRate, Albumin_charge_at_pH2.u)
      annotation (Line(points={{60,22},{60,-8},{54,-8}}, color={0,0,127}));
    connect(Albumin_charge_at_pH2.y, unlimitedSolutePump1.soluteFlow)
      annotation (Line(points={{31,-8},{24,-8},{24,-38}}, color={0,0,127}));
    connect(unlimitedSolutePump1.q_out, port_a) annotation (Line(
        points={{18,-42},{18,-42},{0,-42},{0,-96}},
        color={107,45,134},
        thickness=1));
    connect(unlimitedSolutePump.q_in, port_a) annotation (Line(
        points={{-18,-42},{0,-42},{0,-96}},
        color={107,45,134},
        thickness=1));
    connect(HCO3.q_out, port_a) annotation (Line(
        points={{-48,-80},{0,-80},{0,-96}},
        color={107,45,134},
        thickness=1));
    connect(Proteins.q_out, concentrationMeasure.q_in) annotation (Line(
        points={{-32,30},{-10,30},{12,30}},
        color={107,45,134},
        thickness=1));
    connect(concentrationMeasure.q_in, molarFlowMeasure1.q_in) annotation (Line(
        points={{12,30},{32,30},{50,30}},
        color={107,45,134},
        thickness=1));
    connect(concentrationMeasure.concentration, proteinDivision.totalProteins)
      annotation (Line(points={{12,38},{12,38},{12,66},{16,66}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}})));
  end ProteinBalance;

  model Protein_synthesis
  //  parameter Physiolibrary.Types.MassFlowRate  SynthesisBasic "10 mg/min";
    parameter Physiolibrary.Types.MolarFlowRate SynthesisBasic = 2.75753e-09
        "10 mg/min";
    parameter Real[:,3] data =  {{ 20.0,  3.0,  0.0}, { 28.0,  1.0,  -0.2}, { 40.0,  0.0,  0.0}}
        "COPEffect";
  Physiolibrary.Blocks.Interpolation.Curve c(
    x=data[:, 1],
    y=data[:, 2],
    slope=data[:, 3],
    Xscale=101325/760);

  Physiolibrary.Chemical.Interfaces.ChemicalPort_b q_out annotation (extent=[
        -10,-110; 10,-90], Placement(transformation(extent={{90,-10},{110,10}})));

    Physiolibrary.Types.Pressure COP "Colloid osmotic pressure";
  //  Physiolibrary.Types.AmountOfSubstance  synthetizedAmount(start=0);
  //  Physiolibrary.Types.Mass  synthetizedMass(start=0);
  //protected
  //  constant Physiolibrary.Types.Time sec=1;
  //  constant Physiolibrary.Types.Volume ghostPlasmaVol=3.02e-3
  //    "Strange dependence derived from original HumMod";
  equation
    COP =  q_out.conc * Modelica.Constants.R * 310.15;
    c.u=COP;
    q_out.q = -SynthesisBasic * c.val;

  //TODO: state
  //der(synthetizedAmount) = -q_out.q;
  //  ProteinsMass2AmountOfSubstance(synthetizedMass,ghostPlasmaVol) = synthetizedAmount;
   annotation (
      defaultComponentName="synthesis",
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={Rectangle(
            extent={{-100,-50},{100,50}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-50},{90,50}},
            lineColor={0,0,255},
            textString="%name")}),  Diagram(coordinateSystem(preserveAspectRatio=true,
                     extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics));
  end Protein_synthesis;

  model Protein_degradation
  //  parameter Physiolibrary.Types.MassFlowRate  DegradationBasic "10 mg/min";
  //  parameter Real[:,3] data =  {{ 0.00,  0.0,  0.0}, { 0.07,  1.0,  40.0}, { 0.09,  6.0,  0.0}}
  //    "ProteinEffect";
     parameter Physiolibrary.Types.MolarFlowRate DegradationBasic = 2.75753e-09
        "10 mg/min";
     parameter Real[:,3] data =  {{ 0.00,  0.0,  0.0}, { 1.45,  1.0,  1.59}, { 1.97,  6.0,  0.0}}
        "ProteinEffect";

  Physiolibrary.Blocks.Interpolation.Curve c(
    x=data[:, 1],
    y=data[:, 2],
    slope=data[:, 3]);
  Physiolibrary.Chemical.Interfaces.ChemicalPort_a q_in annotation (Placement(
        transformation(extent={{-100,0},{-60,40}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));

  //  Physiolibrary.Types.AmountOfSubstance  degradedAmount(start=0);
  //  Physiolibrary.Types.Mass  degradedMass(start=0);
  //protected
  //  constant Physiolibrary.Types.Time sec=1;
  //  constant Physiolibrary.Types.Volume ghostPlasmaVol=3.02e-3
  //    "Strange dependence derived from original HumMod";
  equation
  //  ProteinsMassConcentration2Concentration(c.u*1000) = q_in.conc;
    c.u = q_in.conc;
    q_in.q = DegradationBasic * c.val;
  //  q_in.q =ProteinsMass2AmountOfSubstance(DegradationBasic*c.val*sec,ghostPlasmaVol)/sec;

  //TODO: state
  //der(degradedAmount) = q_in.q;
  //  ProteinsMass2AmountOfSubstance(degradedMass,ghostPlasmaVol) = degradedAmount;
   annotation (
      defaultComponentName="degradation",
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={Rectangle(
            extent={{-100,-50},{100,50}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-88,-50},{100,50}},
            lineColor={0,0,255},
            textString="%name")}),  Diagram(coordinateSystem(preserveAspectRatio=true,
                     extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics));
  end Protein_degradation;

  end Proteins;

  model AcidBase_border_flux

    Chemical.Components.Substance HCO3(solute_start=0.0245)
      annotation (Placement(transformation(extent={{18,0},{38,20}})));
    Proteins.ProteinBalance proteinBalance
      annotation (Placement(transformation(extent={{0,80},{20,100}})));
  equation
    connect(proteinBalance.port_a, HCO3.q_out) annotation (Line(
        points={{10,80.4},{10,80.4},{10,24},{10,10},{28,10}},
        color={107,45,134},
        thickness=1));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
              -100,-100},{100,100}})));
  end AcidBase_border_flux;

  package Buffer_systems

    model Buffer_HCO3

      Chemical.Components.Substance Co2_aq(solute_start=0.0001)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      Chemical.Components.Substance Water(solute_start=55)
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Chemical.Components.Substance Hco3(solute_start=0.0245)
        annotation (Placement(transformation(extent={{0,20},{20,40}})));
      Chemical.Components.Substance H_plus(solute_start=1e-10)
        annotation (Placement(transformation(extent={{0,-20},{20,0}})));
      Chemical.Components.ChemicalReaction chemicalReaction(
        nS=2,
        nP=2,
        K=4.47e-7)
        annotation (Placement(transformation(extent={{-26,4},{-6,24}})));
    equation
      connect(Co2_aq.q_out, chemicalReaction.substrates[2]) annotation (Line(
          points={{-50,30},{-40,30},{-40,28},{-32,28},{-32,14.5},{-26,14.5}},
          color={107,45,134},
          thickness=1));
      connect(Water.q_out, chemicalReaction.substrates[1]) annotation (Line(
          points={{-50,-10},{-32,-10},{-32,13.5},{-26,13.5}},
          color={107,45,134},
          thickness=1));
      connect(Hco3.q_out, chemicalReaction.products[2]) annotation (Line(
          points={{10,30},{4,30},{-2,30},{-2,14.5},{-6,14.5}},
          color={107,45,134},
          thickness=1));
      connect(H_plus.q_out, chemicalReaction.products[1]) annotation (Line(
          points={{10,-10},{4,-10},{4,-8},{0,-8},{0,13.5},{-6,13.5}},
          color={107,45,134},
          thickness=1));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}})));
    end Buffer_HCO3;

    model buffers

    end buffers;
  end Buffer_systems;
end Dev_AcidBase;
