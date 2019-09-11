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
%SECANT
%==============================================================================

%Used to set bounds according to value of the function on those points
function [xn,xn_1] = realignBounds(current, past)
	if abs(myFunction(past)) <= abs(myFunction(current))
		xn = past;
		xn_1 = current;
	else
		xn = current;
		xn_1 = past;
	end
end

%Returns xn - f(xn)*[xn-1 - xn / f(xn-1) - f(xn)]
function result = secantApproximation(currentPoint, pastPoint)
	result = currentPoint - myFunction(currentPoint) *(pastPoint - currentPoint)/(myFunction(pastPoint) - myFunction(currentPoint));
end

%Searches for a root in defined interval
function secantMethod()
	%Setup
	fprintf("==================================================\n");
	fprintf("Aproximacion por metodo de secante\n");
	oldPoint = input("Escriba el valor de X0\n");
	currentPoint = input("Escriba el valor de X1\n");
	error = 1;
	%Until error is within threshold
	while error > 0.00001
		[currentPoint, oldPoint] = realignBounds(currentPoint, oldPoint);
		temp = secantApproximation(currentPoint, oldPoint);
		oldPoint = currentPoint;
		currentPoint = temp;
		%Calculating error
		error = relativeError(oldPoint, currentPoint);
	end
	fprintf("==================================================\n");
	fprintf("Factor de friccion: %.8f\n", currentPoint);
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
	secantMethod();
	fprintf("Numero de Reynolds: %.8f\n",reynoldsNumber);
	fprintf("Rugosidad relativa: %.8f\n",relativeRoughness);
	fprintf("==================================================\n");
end
