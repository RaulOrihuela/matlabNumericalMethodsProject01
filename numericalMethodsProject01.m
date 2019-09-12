%==============================================================================
%PROGRAM SPECIFIC FUNCTIONS
%==============================================================================

function numericalMethodsProject01 ()
	menuOption = "helloWorld";
	while menuOption ~= "0"
		clc;
		fprintf("Equipo 5\nColebrook-White\n");
		fprintf("==================================================\n");
		colebrookWhite();
		menuOption = input("Presione enter para calcular nuevamente\nEscriba 0 para salir\n",'s');
	end
	clc;
end

%Colebrook White equation
function result = myFunction(x)
	global reynoldsNumber; global relativeRoughness;
	result = - 2 * log10(relativeRoughness/3.7 + 2.51/(reynoldsNumber * sqrt(x))) - 1/(sqrt(x));
end

%==============================================================================
%GENERAL MATH FUNCTIONS
%==============================================================================

%Used to find the relative error
function result = relativeError (calculated, expected)
	result = abs ((expected - calculated) / expected);
end

%==============================================================================
%BISECTION
%==============================================================================

%Used to find bounds for the next iteration
function [newLower, newUpper, middle] = compareBounds(lowerBound,upperBound)
	middle = (lowerBound + upperBound)/2;
	if myFunction(middle) == 0
        %Root is exacty in the middle
		newLower = middle;
		newUpper = middle;
	elseif myFunction(lowerBound) == 0
		%Root is exacty in the lower bound
		newLower = lowerBound;
		newUpper = lowerBound;
	elseif myFunction(upperBound) == 0
		%Root is exacty in the upper bound
        newLower = upperBound;
		newUpper = upperBound;
	elseif myFunction(middle) * myFunction(lowerBound) < 0
		%Root is in the first half of segment
        newLower = lowerBound;
		newUpper = middle;
    else
        %Root is in the second half of segment
        newLower = middle;
		newUpper = upperBound;
	end
end

%Searches for a root in defined interval
function bisection(maxError)
	%Setup
    fprintf("==================================================\n");
	fprintf("Aproximacion por metodo de Biseccion\n");
	boundsA = input("Escriba el limite inferior de busqueda\n");
	boundsB = input("Escriba el limite superior de busqueda\n");
	oldResult = boundsA;
	error = 1;
	%Until error is within threshold
	while error > maxError
		%Getting new bounds and current result
		[boundsA,boundsB,result] = compareBounds(boundsA,boundsB);
		%Calculating error
		error = relativeError(oldResult, result);
		oldResult = result;
		%In case the root is exact
        if boundsA == boundsB
			result = boundsA;
			error = 0;
        end
	end
	fprintf("==================================================\n");
	fprintf("Factor de friccion: %.8f\n", result);
	fprintf("Error relativo (Factor de friccion): %.8f\n", error);
end

%==============================================================================
%COLEBROOK WHITE
%==============================================================================

%Used to calculate kinematicViscocity (nu) using equation nu = mu/rho
%nu = kinematic viscocity, mu = dynamic viscosity, rho = fluid density
function result = kinematicViscosity(dynamicViscosity, fluidDensity)
	result = dynamicViscosity/fluidDensity;
end

%Used for calculating reynolds number using equation Re = (Q*D)/(nu*A)
%D/A is simplified as 4/(pi*D) since A is the cross section area pi*D*D/4 
%This results in getting the equation Re = (4*Q)/(pi*nu*D)
%Q = volumetric flow, D = inner diameter, nu = Kinematic viscocity
function result = reynoldsNumberPipe(volumetricFlow,kinematicViscosity,pipeDiameter)
	result = (4*volumetricFlow)/(pi*pipeDiameter*kinematicViscosity);
end

%Used for calculating relative roughness (e/D)
%e = pipe effective roughness, D = inner diameter
function result = Relative_Roughness(pipeRoughness, pipeDiameter)
	result = pipeRoughness / pipeDiameter;
end

%Used to get paramaters and forward them to other processing functions
function colebrookWhite()
	%Setup
	global reynoldsNumber; global relativeRoughness;
	fluidDensity = input("Escriba la densidad del fluido\n");
	dynamicViscosity = input("Escriba la viscosidad dinamica\n");
	pipeDiameter = input("Escriba el diametro interno de la tuberia\n");
	pipeRoughness = input("Escriba la rugosidad de la tuberia\n");
	volumetricFlow = input("Escriba el flujo volumetrico\n");
    
	%Calculating variables for Colebrook White equation
	reynoldsNumber = reynoldsNumberPipe(volumetricFlow,kinematicViscosity(dynamicViscosity, fluidDensity),pipeDiameter);
	relativeRoughness = Relative_Roughness(pipeRoughness, pipeDiameter);
    
	%Process data
	bisection(0.00001);
	fprintf("Numero de Reynolds: %.8f\n",reynoldsNumber);
	fprintf("Rugosidad relativa: %.8f\n",relativeRoughness);
	fprintf("==================================================\n");
end
