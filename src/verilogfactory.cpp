#include "verilogfactory.h"

VerilogFactory::VerilogFactory() {
	snippet[ALWAYS] = "always @(posedge clk) begin";
	snippet[RESET0] = "if (rst == 1\'b0) begin";
	snippet[RESET1] = "if (rst == 1\'b1) begin";
	snippet[END] = "end";
	snippet[ELSEBEGIN] = "else begin";
	snippet[ENDMODULE] = "endmodule";
}

void VerilogFactory::setName(std::string name) {
	_name = name;
}

void VerilogFactory::addIO(const std::string name, const std::string direction) {
	_ionames.push_back(name);
	_iodirs.push_back(direction);
	_iotypes.push_back("special");
	_iowidths.push_back(1);
}

void VerilogFactory::addIO(const std::string name, const std::string direction, int width) {
	_ionames.push_back(name);
	_iodirs.push_back(direction);
	_iotypes.push_back("regular");
	_iowidths.push_back(width);
}

void VerilogFactory::addVar(const std::string name, int width, bool pipeline) {
	_varnames.push_back(name);
	_varwidths.push_back(width);
	_varpipes.push_back(pipeline);
}

void VerilogFactory::addWire(const std::string name, int width) {
	_varnames_1.push_back(name);
	_varwidths_1.push_back(width);
}

void VerilogFactory::addAssign(int width) {

	_varwidths_1.push_back(width);     
}

void VerilogFactory::addParameter(const std::string name, int width) {
	_varnames_2.push_back(name);
	_varwidths_2.push_back(width);
}

std::string VerilogFactory::getModuleDefinition() {
	std::string tmp;

	tmp = "module " + _name + "(";
	// now print ios
	
	for (auto it = _ionames.begin(); it != _ionames.end(); it++) {
    		tmp = tmp + *it + ", ";
	}
	tmp.pop_back(); // this will remove the extra comma and whitespace
	tmp.pop_back();

	tmp = tmp + ");";

	return tmp;
}

std::string VerilogFactory::getIODefinition() {
	std::string tmp;

	auto i = _ionames.begin();
	auto j = _iodirs.begin();
	auto k = _iowidths.begin();

	while (i != _ionames.end()) {
		if ((*k)==1) { // single bit IO doesn't need size to be specified
			tmp = tmp + *j + " " + *i + ";\n";
		}
		else {
			int index = *k - 1;
			std::string range = " [" + std::to_string(index) + ":0] ";
			tmp = tmp + *j + range + *i + ";\n";
		}
	
		i++;
		j++;
		k++;
	}
	return tmp;
}

std::string VerilogFactory::getInternalDefinition() { // should not return pipeline registers, these are handled elsewhere
	std::string tmp;

	auto i = _varnames.begin();
	auto j = _varwidths.begin();
	auto k = _varpipes.begin();

	while (i != _varnames.end()) {
		if (*k == false) { // NOT a pipeline register
			if ((*j)==1) { // single bit IO doesn't need size to be specified
				tmp = tmp + "reg " + *i + ";\n";
			}
			else {
				int index = *j - 1;
				std::string range = " [" + std::to_string(index) + ":0] ";
				tmp = tmp + "reg " + range + *i + ";\n";
			}
		}
		i++;
		j++;
		k++;
	}
	return tmp;
}
 
std::string VerilogFactory::getInternalDefinitionWire() {
	std::string tmp;

	auto i = _varnames_1.begin();
	auto j = _varwidths_1.begin();

	while (i != _varnames_1.end()) {
		if ((*j)==1) { // single bit IO doesn't need size to be specified
			tmp = tmp + "wire " + *i + ";\n";
		}
		else {
			int index = *j - 1;
			std::string range = " [" + std::to_string(index) + ":0] ";
			tmp = tmp + "wire " + range + *i + ";\n";
		}
	
		i++;
		j++;
	}
	return tmp;
}

std::string VerilogFactory::getInternalDefinitionParameter() {
	std::string tmp;

	auto i = _varnames_2.begin();
	auto j = _varwidths_2.begin();

	while (i != _varnames_2.end()) {
		if ((*j)==1) { 
			int index = *j;
			std::string range = " = " + std::to_string(index);
			tmp = tmp + "parameter " + *i + range + ";\n";
		}
		else {
			int index = *j;
			std::string range = " = " + std::to_string(index);
			tmp = tmp + "parameter " + *i + range + ";\n";
		}
	
		i++;
		j++;
	}
	return tmp;
}

// Assign statement for 3-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetMSB_as_m_over_3_minus_1(){
   std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k-1);
	
  return tmp;    
}

// Assign statement for 3-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetMSB_as_m_times_2_over_3_minus_1(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k*2-1);
	
  return tmp;
}  

// Assign statement for 3-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetMSB_as_m_minus_1_for_3_way_TCM(){
   std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k*3-1);
	
  return tmp;    
}

// Assign statement for 3-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetLSB_as_m_over_3(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k);
	
  return tmp;
}

// Assign statement for 3-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetLSB_as_m_times_2_over_3(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k*2);
	
  return tmp;
}

// Assign statement for 4-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetMSB_as_m_over_4(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k-1);
	
  return tmp;
}

// Assign statement for 4-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetMSB_as_m_times_2_over_4(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string((*k*2)-1);
	
  return tmp;
}

// Assign statement for 4-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetMSB_as_m_times_3_over_4(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string((*k*3)-1);
	
  return tmp;
}

// Assign statement for 4-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetMSB_as_m_minus_1_for_4_way_TCM(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string((*k*4)-1);
	
  return tmp;
}

// Assign statement for 4-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetLSB_as_m_over_4(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k);
	
  return tmp;
}

// Assign statement for 4-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetLSB_as_m_times_2_over_4(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k*2);
	
  return tmp;
}

// Assign statement for 4-Way TCM
std::string VerilogFactory::getInternalDefinitionAssignSetLSB_as_m_times_3_over_4(){
  std::string tmp;
  
	auto k = _varwidths.begin();

			tmp = tmp + std::to_string(*k*3);
	
  return tmp;
}

std::string VerilogFactory::getResetStatement(bool pipe) { // if pipe is true, means pipeline registers must also be reset
	std::string tmp;

	auto i = _ionames.begin();
	auto j = _iodirs.begin();
	auto k = _iowidths.begin();

	while (i != _ionames.end()) {
		if ((*j) == "output reg") {
			tmp = tmp + *i + " <= " + std::to_string(*k) + "\'d0;\n";
		}

		i++;
		j++;
		k++;
	}

	auto l = _varnames.begin();
	auto m = _varwidths.begin();
	auto n = _varpipes.begin();

	while (l != _varnames.end()) {
		if (*n == true) { // meaning it is a pipeline reg
			if (pipe == 1 ) { // meaning I want to reset it
				tmp = tmp + *l + " <= " + std::to_string(*m) + "\'d0;\n";
			}
		}
		else {
			tmp = tmp + *l + " <= " + std::to_string(*m) + "\'d0;\n";
		}
	
		l++;
		m++;
		n++;
	}
	
	return tmp;
}

void VerilogFactory::genTempVars(int pipeline, bool inputs) { // this function creates the pipelining registers in the right lists. if inputs is true, the inputs are pipelined, otherwise outputs are
	std::string tmp;

	if (pipeline == 1) {
		return; // there is nothing to be done, no need to repeat vars
	}

	auto i = _ionames.begin();
	auto j = _iodirs.begin();
	auto k = _iotypes.begin();
	auto l = _iowidths.begin();
	int times = pipeline - 1;
	
	while (times != 0) {
		while (i != _ionames.end()) {
			if (inputs) {
				if (((*j) == "input") && ((*k) == "regular")) {
					tmp = *i + "_temp_" + std::to_string(times);
					addVar(tmp, *l, true); 
				}
			}
			else {
				if (((*j) == "output reg") && ((*k) == "regular")) {
					tmp = *i + "_temp_" + std::to_string(times);
					addVar(tmp, *l, true); 
				}

			}
	
			i++;
			j++;
			k++;
			l++;
		}

		times--;
		i = _ionames.begin();
		j = _iodirs.begin();
		k = _iotypes.begin();
		l = _iowidths.begin();
	}

	return;
}


std::string VerilogFactory::getTempVars(int pipeline) {
	std::string tmp;

	if (pipeline == 1) {
		return "// no pipeline vars"; // there is nothing to be done, no need to repeat vars
	}

	auto i = _varnames.begin();
	auto j = _varwidths.begin();
	auto k = _varpipes.begin();
	
	while (i != _varnames.end()) {
		if (*k == true) {
			int index = *j - 1;
			std::string range = "[" + std::to_string(index) + ":0]";
			tmp = tmp + "reg " + range + " " + *i + ";\n";
		}
	
		i++;
		j++;
		k++;
	}

	return tmp;
}

std::string VerilogFactory::getMulLogicSimple(int pipeline) {
	std::string tmp;

	if (pipeline == 1) {
		return "c <= a * b;"; // no pipelining
	}

	auto i = _ionames.begin();
	auto j = _iodirs.begin();
	auto k = _iotypes.begin();
	auto l = _iowidths.begin();
	int times = 1;
	
	while (times < pipeline) {
		while (i != _ionames.end()) {
			if (((*j) == "input") && ((*k) == "regular")) {
				if (times == 1) { // first time we assign from input to temp
					tmp = tmp + *i + "_temp_" + std::to_string(times) + " <= " + *i + ";\n";
				}
				else {
					tmp = tmp + *i + "_temp_" + std::to_string(times) + " <= " + *i + "_temp_" + std::to_string(times-1) + ";\n";
				}
			}
	
			i++;
			j++;
			k++;
			l++;
		}

		times++;
		i = _ionames.begin();
		j = _iodirs.begin();
		k = _iotypes.begin();
		l = _iowidths.begin();


	}

	times = pipeline - 1;
	tmp = tmp + "c <= a_temp_" + std::to_string(times) + " * b_temp_" + std::to_string(times) + ";\n";

	return tmp;
}

std::string VerilogFactory::getMulLogicSchoolbook(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {
		tmp = "if (count < " + std::to_string(width1) + ") begin\n";
		tmp = tmp + "\tif (b[count] == 1) begin\n";
		tmp = tmp + "\t\tc <= c + (a << count);\n";
		tmp = tmp + "\tend\n";
		tmp = tmp + "\tcount <= count + 1;\n";
		tmp = tmp + "end\n";
		return tmp; // no pipelining version
	}

	// here begins the pipeline version
	auto i = _ionames.begin();
	auto j = _iodirs.begin();
	auto k = _iotypes.begin();
	auto l = _iowidths.begin();
	int times = 1;
	
	while (times < pipeline) {
		while (i != _ionames.end()) {
			if (((*j) == "input") && ((*k) == "regular")) {
				if (times == 1) { // first time we assign from input to temp
					tmp = tmp + *i + "_temp_" + std::to_string(times) + " <= " + *i + ";\n";
				}
				else {
					tmp = tmp + *i + "_temp_" + std::to_string(times) + " <= " + *i + "_temp_" + std::to_string(times-1) + ";\n";
				}
			}
	
			i++;
			j++;
			k++;
			l++;
		}

		times++;
		i = _ionames.begin();
		j = _iodirs.begin();
		k = _iotypes.begin();
		l = _iowidths.begin();
	}

	times = pipeline - 1;
	std::string var1 = "a_temp_" + std::to_string(times);
	std::string var2 = "b_temp_" + std::to_string(times);

	tmp = tmp + "if (skip != " + std::to_string(pipeline -1) + ") skip <= skip + 1;\n";
	tmp = tmp + "else begin\n";
	tmp = tmp + "\tif (count < " + std::to_string(width1) + ") begin\n";
	tmp = tmp + "\t\tif (" + var2 + "[count] == 1) begin\n";
	tmp = tmp + "\t\t\tc <= c + (" + var1 + " << count);\n";
	tmp = tmp + "\t\tend\n";
	tmp = tmp + "\t\tcount <= count + 1;\n";
	tmp = tmp + "\tend\n";
	tmp = tmp + "end\n";

	return tmp;
}

std::string VerilogFactory::getMulLogic_2_Way_Karatsuba_Step_1(int width1, int width2, int pipeline) {
	std::string tmp;

	tmp = "if (rst) begin\n";
	tmp = tmp + "\tmul_a1c1 <= " + std::to_string(width1) + "'d0;\n";
	tmp = tmp + "\tcounter_a1c1 <= " + std::to_string(width1/2) + "'d0;\n";
	tmp = tmp + "end\n";
    
	tmp = tmp + "else if (counter_a1c1 < " + std::to_string(width1/2+1) + ") begin\n";
	tmp = tmp + "\tif (a[counter_a1c1] == 1'b1) begin\n";
	tmp = tmp + "\t\tmul_a1c1 <= mul_a1c1 ^ (c1 << counter_a1c1);\n";
	tmp = tmp + "\t\tcounter_a1c1 <= counter_a1c1 + 1;\n";
	tmp = tmp + "\tend\n";
	tmp = tmp + "\tcounter_a1c1 <= counter_a1c1 + 1;\n";
	tmp = tmp + "end\n";
	return tmp; 
}

std::string VerilogFactory::getMulLogic_2_Way_Karatsuba_Step_2(int width1, int width2, int pipeline) {
	std::string tmp;

	tmp = "if (rst) begin\n";
    	tmp = tmp + "\tmul_b1d1 <= " + std::to_string(width1) + "'d0;\n";
    	tmp = tmp + "\tcounter_b1d1 <= " + std::to_string(width1/2) + "'d0;\n";
    	tmp = tmp + "end\n";
    
	tmp = tmp + "else if (counter_b1d1 < " + std::to_string(width1/2+1) + ") begin\n";
	tmp = tmp + "\tif (b[counter_b1d1] == 1'b1) begin\n";
	tmp = tmp + "\t\tmul_b1d1 <= mul_a1c1 ^ (d1 << counter_b1d1);\n";
	tmp = tmp + "\t\tcounter_b1d1 <= counter_b1d1 + 1;\n";
	tmp = tmp + "\tend\n";
	tmp = tmp + "\tcounter_b1d1 <= counter_b1d1 + 1;\n";
	tmp = tmp + "end\n";
	return tmp;
}

std::string VerilogFactory::getMulLogic_2_Way_Karatsuba_Step_3(int width1, int width2, int pipeline) {
	std::string tmp;
	std::string regname = "c";

	if (pipeline > 1) { // ... but if pipelined assignments are to temporary reg
		regname = "c_temp_" + std::to_string(pipeline-1);
	}

	tmp = "if (rst) begin\n";
    	tmp = tmp + "\t" + regname + " = " + std::to_string(width1+width2) + "'d0;\n";
    	tmp = tmp + "\tmul_sum_a1b1_sum_c1d1 = " + std::to_string(width1+2) + "'d0;\n";
    	tmp = tmp + "\tcounter_sum_a1b1_c1d1 = " + std::to_string((width1/2)+2) + "'d0;\n";
    	tmp = tmp + "end\n";
    
	tmp = tmp + "else if (counter_sum_a1b1_c1d1 < " + std::to_string(width1/2+1) + ") begin\n";
	tmp = tmp + "\tif (sum_a1b1[counter_sum_a1b1_c1d1] == 1'b1) begin\n";
	tmp = tmp + "\t\tmul_sum_a1b1_sum_c1d1 = mul_sum_a1b1_sum_c1d1 ^ (sum_c1d1 << counter_sum_a1b1_c1d1);\n";
	tmp = tmp + "\t\tcounter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;\n";
	tmp = tmp + "\tend\n";
	tmp = tmp + "\tcounter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;\n";
	tmp = tmp + "end\n";
   
	tmp = tmp + regname + " = mul_sum_a1b1_sum_c1d1 - mul_b1d1 - mul_a1c1;\n";
    	tmp = tmp + regname + " = " + regname + " << " + std::to_string(width1/2) + ";\n";
    	tmp = tmp + regname + " = " + regname + " ^ (mul_a1c1 << " + std::to_string(width1) + ");\n";
    	tmp = tmp + regname + " = " + regname + " ^ mul_b1d1;\n";
        
	return tmp;
}

// 3_Way_TCM Step 1
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
		tmp = scoper(2, "if (rst) begin\n");
    		tmp = tmp + scoper(3, "d <= " + std::to_string(width1) + "'d0;\n");
    		tmp = tmp + scoper(3, "counter_d <= " + std::to_string(width1/3) + "'d0;\n");
    		tmp = tmp + scoper(2, "end\n");
    		
    		tmp = tmp + scoper(2, "else if (counter_d < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a2[counter_d] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "d <= d ^ (b2 << counter_d);\n");
		tmp = tmp + scoper(4, "counter_d <= counter_d + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_d <= counter_d + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		return tmp; // no pipelining version
	}
}

// 3_Way_TCM Step 2 (Part 1)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_2_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "e1_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_e1 <= " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(1, "else if (counter_e1 < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a1[counter_e1] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "e1_mul <= e1_mul ^ (b2 << counter_e1);\n");
    tmp = tmp + scoper(3, "counter_e1 <= counter_e1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_e1 <= counter_e1 + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 2 (Part 2)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_2_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "e2_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_e2 <= " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(1, "else if (counter_e2 < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a2[counter_e1] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "e2_mul <= e2_mul ^ (b1 << counter_e2);\n");
    tmp = tmp + scoper(3, "counter_e2 <= counter_e2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_e2 <= counter_e2 + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 2 (Part 3)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_2_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "e = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "e = e1_mul ^ e2_mul; \n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 3 (Part 1)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_3_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "f1_mul = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_f1 = " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_f1 < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a0[counter_f1] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "f1_mul = f1_mul ^ (b2 << counter_f1);\n");
    tmp = tmp + scoper(3, "counter_f1 = counter_f1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_f1 = counter_f1 + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 3 (Part 2)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_3_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) { 
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "f2_mul = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_f2 = " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n"); 
  
		tmp = tmp + scoper(1, "if (counter_f2 < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a1[counter_f2] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "f2_mul = f2_mul ^ (b1 << counter_f2);\n");
    tmp = tmp + scoper(3, "counter_f2 = counter_f2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_f2 = counter_f2 + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 3 (Part 3)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_3_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "f3_mul = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_f3 = " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n"); 
    
		tmp = tmp + scoper(2, "else if (counter_f3 < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a2[counter_f3] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "f3_mul = f3_mul ^ (b0 << counter_f3);\n");
    tmp = tmp + scoper(3, "counter_f3 = counter_f3 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_f3 = counter_f3 + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 3 (Part 4)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_3_part_4(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "f = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "f = f1_mul ^ f2_mul ^ f3_mul; \n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 4 (Part 1)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_4_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "g1_mul = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_g1 = " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_g1 < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a0[counter_g1] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "g1_mul = g1_mul ^ (b1 << counter_g1);\n");
    tmp = tmp + scoper(3, "counter_g1 = counter_g1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_g1 = counter_g1 + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 4 (Part 2)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_4_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "g2_mul = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_g2 = " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(1, "else if (counter_g2 < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a1[counter_g2] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "g2_mul = g2_mul ^ (b0 << counter_g2);\n");
    tmp = tmp + scoper(3, "counter_g2 = counter_g2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_g2 = counter_g2 + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 4 (Part 3)
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_4_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "g = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "g = g1_mul ^ g2_mul; \n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 5
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_5(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "h = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(3, "counter_h = " + std::to_string(width1/3) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_h < " + std::to_string(width1/3+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a0[counter_h] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "h = h ^ (b0 << counter_h);\n");
    tmp = tmp + scoper(3, "counter_h = counter_h + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_h = counter_h + 1;\n");
		tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version
   }
}

// 3_Way_TCM Step 6
std::string VerilogFactory::getMulLogic_3_Way_TCM_Step_6(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "temp = " + std::to_string(width1+width2) + "'d0;\n");
    tmp = tmp + scoper(3, "c = " + std::to_string(width1+width2) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "temp = h;\n");
		tmp = tmp + scoper(3, "temp = temp ^ (g << " + std::to_string(width1/3) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (f << " + std::to_string((width1/3)*2) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (e << " + std::to_string((width1/3)*3) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (d << " + std::to_string((width1/3)*4) + ");\n");
    tmp = tmp + scoper(3, "c = temp;\n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 1
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_d <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "d <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
    tmp = tmp + scoper(2, "else if (counter_d < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a3[counter_d] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "d <= d ^ (b3 << counter_d);\n");
    tmp = tmp + scoper(4, "counter_d <= counter_d + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_d <= counter_d + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 2 (Part 1)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_2_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_e1 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "e1_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_e1 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a2[counter_e1] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "e1_mul <= e1_mul ^ (b3 << counter_e1);\n");
    tmp = tmp + scoper(4, "counter_e1 <= counter_e1 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_e1 <= counter_e1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 2 (Part 2)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_2_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_e2 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "e2_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_e2 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a3[counter_e1] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "e2_mul <= e2_mul ^ (b2 << counter_e2);\n");
    tmp = tmp + scoper(4, "counter_e2 <= counter_e2 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_e2 <= counter_e2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 2 (Part 3)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_2_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "e <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "e <= e1_mul ^ e2_mul; \n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 3 (Part 1)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_3_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_f1 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "f1_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_f1 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a1[counter_f1] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "f1_mul <= f1_mul ^ (b3 << counter_f1);\n");
    tmp = tmp + scoper(4, "counter_f1 <= counter_f1 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_f1 <= counter_f1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 3 (Part 2)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_3_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_f2 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "f2_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_f2 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a2[counter_f2] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "f2_mul <= f2_mul ^ (b2 << counter_f2);\n");
    tmp = tmp + scoper(4, "counter_f2 <= counter_f2 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_f2 <= counter_f2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 3 (Part 3)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_3_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_f3 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "f3_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_f3 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a3[counter_f3] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "f3_mul <= f3_mul ^ (b1 << counter_f3);\n");
    tmp = tmp + scoper(4, "counter_f3 <= counter_f3 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_f3 <= counter_f3 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 3 (Part 4)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_3_part_4(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "f <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
    tmp = tmp + scoper(3, "f <= f1_mul ^ f2_mul ^ f3_mul; \n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 4 (Part 1)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_4_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_g1 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "g1_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_g1 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a0[counter_g1] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "g1_mul <= g1_mul ^ (b3 << counter_g1);\n");
    tmp = tmp + scoper(4, "counter_g1 <= counter_g1 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_g1 <= counter_g1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 4 (Part 2)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_4_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_g2 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "g2_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_g2 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a1[counter_g2] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "g2_mul <= g2_mul ^ (b2 << counter_g2);\n");
    tmp = tmp + scoper(4, "counter_g2 <= counter_g2 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_g2 <= counter_g2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 4 (Part 3)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_4_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_g3 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "g3_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_g3 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a2[counter_g3] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "g3_mul <= g3_mul ^ (b1 << counter_g3);\n");
    tmp = tmp + scoper(4, "counter_g3 <= counter_g3 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_g3 <= counter_g3 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 4 (Part 4)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_4_part_4(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_g4 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "g4_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_g4 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a3[counter_g4] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "g4_mul <= g4_mul ^ (b0 << counter_g4);\n");
    tmp = tmp + scoper(4, "counter_g4 <= counter_g4 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_g4 <= counter_g4 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 4 (Part 5)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_4_part_5(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "g <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "g <= g1_mul ^ g2_mul ^ g3_mul ^ g4_mul; \n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 5 (Part 1)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_5_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_h1 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "h1_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_h1 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a0[counter_h1] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "h1_mul <= h1_mul ^ (b2 << counter_h1);\n");
    tmp = tmp + scoper(4, "counter_h1 <= counter_h1 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_h1 <= counter_h1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 5 (Part 2)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_5_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_h2 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "h2_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_h2 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(2, "if (a1[counter_h2] == 1'b1) begin\n");
		tmp = tmp + scoper(3, "h2_mul <= h2_mul ^ (b1 << counter_h2);\n");
    tmp = tmp + scoper(3, "counter_h2 <= counter_h2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
		tmp = tmp + scoper(3, "counter_h2 <= counter_h2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 5 (Part 3)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_5_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_h3 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "h3_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_h3 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a2[counter_h3] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "h3_mul <= h3_mul ^ (b0 << counter_h3);\n");
    tmp = tmp + scoper(4, "counter_h3 <= counter_h3 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_h3 <= counter_h3 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 5 (Part 4)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_5_part_4(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "h <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "h <= h1_mul ^ h2_mul ^ h3_mul; \n");
   tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 6 (Part 1)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_6_part_1(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_i1 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "i1_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_i1 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a0[counter_i1] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "i1_mul <= i2_mul ^ (b1 << counter_i1);\n");
    tmp = tmp + scoper(4, "counter_i1 <= counter_i1 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_i1 <= counter_i1 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 6 (Part 2)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_6_part_2(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_i2 <= " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "i2_mul <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_i2 < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a1[counter_i2] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "i2_mul <= i2_mul ^ (b0 << counter_i2);\n");
    tmp = tmp + scoper(4, "counter_i2 <= counter_i2 + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_i2 <= counter_i2 + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 6 (Part 3)
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_6_part_3(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "i <= " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "i <= i1_mul ^ i2_mul; \n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 7
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_7(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "counter_j = " + std::to_string(width1/4) + "'d0;\n");
    tmp = tmp + scoper(3, "j = " + std::to_string(width1) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    
		tmp = tmp + scoper(2, "else if (counter_j < " + std::to_string(width1/4+1) + ") begin\n");
		tmp = tmp + scoper(3, "if (a0[counter_j] == 1'b1) begin\n");
		tmp = tmp + scoper(4, "j = j ^ (b0 << counter_j);\n");
    tmp = tmp + scoper(4, "counter_j = counter_j + 1;\n");
		tmp = tmp + scoper(3, "end\n");
		tmp = tmp + scoper(4, "counter_j = counter_j + 1;\n");
		tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// 4_Way_TCM Step 8
std::string VerilogFactory::getMulLogic_4_Way_TCM_Step_8(int width1, int width2, int pipeline) {
	std::string tmp;

	if (pipeline == 1) {  
    tmp = scoper(2, "if (rst) begin\n");
    tmp = tmp + scoper(3, "temp = " + std::to_string(width1+width2) + "'d0;\n");
    tmp = tmp + scoper(3, "c = " + std::to_string(width1+width2) + "'d0;\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(2, "else begin\n");
		tmp = tmp + scoper(3, "temp = j;\n");
		tmp = tmp + scoper(3, "temp = temp ^ (i << " + std::to_string(width1/4) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (h << " + std::to_string((width1/4)*2) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (g << " + std::to_string((width1/4)*3) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (f << " + std::to_string((width1/4)*4) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (e << " + std::to_string((width1/4)*5) + ");\n");
    tmp = tmp + scoper(3, "temp = temp ^ (d << " + std::to_string((width1/4)*6) + ");\n");
    tmp = tmp + scoper(3, "c = temp;\n");
    tmp = tmp + scoper(2, "end\n");
    return tmp; // no pipelining version
   }
}

// sbm_digitized FSM --< Sequential logic
std::string VerilogFactory::getMulLogic_sbm_digitized_FSM_sequential_logic(int width1, int width2, int digit_size, int pipeline) {
	std::string tmp;

	if (pipeline == 1){
    tmp = scoper(1, "if (rst == 1'b1) begin\n");
		tmp = tmp + scoper(2, "state <= ST_RUN;\n");
    tmp = tmp + scoper(2, "c <= " + std::to_string(width1+width2) + "'b0;\n");
    tmp = tmp + scoper(2, "counter_digits <= " + std::to_string(width2/digit_size) + "'b0;\n");
    tmp = tmp + scoper(2, "short_b <= " + std::to_string(digit_size) + "'b0;\n");
    tmp = tmp + scoper(2, "digit_mul_start <= 1'b0;\n");
    tmp = tmp + scoper(1, "end\n");
    tmp = tmp + scoper(1, "else begin\n");
		tmp = tmp + scoper(2, "state <= next_state;\n");
    tmp = tmp + scoper(2, "c <= next_c;\n");
    tmp = tmp + scoper(2, "counter_digits <= counter_digits_next;\n");
    tmp = tmp + scoper(2, "short_b <= short_b_next;\n");
    tmp = tmp + scoper(2, "digit_mul_start <= digit_mul_start_next;\n");
    tmp = tmp + scoper(1, "end\n");
    return tmp; // no pipelining version  
   }
}

// sbm_digitized FSM --< Combinational logic
std::string VerilogFactory::getMulLogic_sbm_digitized_FSM_combinational_logic(int width1, int width2, int digit_size, int pipeline) {
	std::string tmp;

	if (pipeline == 1){
    tmp = scoper(0, "always @ (*) begin \n");
		tmp = tmp + scoper(1, "next_state = state;\n");
    tmp = tmp + scoper(1, "next_c = c;\n");
    tmp = tmp + scoper(1, "digit_mul_start_next = digit_mul_start;\n");
    tmp = tmp + scoper(1, "local_rst = 0;\n");
    tmp = tmp + scoper(1, "counter_digits_next = counter_digits;\n");
    tmp = tmp + scoper(1, "short_b_next = short_b;\n");
		tmp = tmp + scoper(1, "tmp = tmp;\n");
    
    // First state
    tmp = tmp + scoper(1, "case (state)\n");
    tmp = tmp + scoper(2, "ST_RUN: begin\n");
    tmp = tmp + scoper(3, "tmp[" + std::to_string(width2-1) + ":0] = b[" + std::to_string(width2-1) + ":0];\n");
    tmp = tmp + scoper(3, "lower_addr = counter_digits_next*(" + std::to_string(digit_size) + ");\n");
    tmp = tmp + scoper(3, "short_b_next = tmp[lower_addr+:" + std::to_string(digit_size) + "];\n");
    tmp = tmp + scoper(3, "if (counter_digits_next < " + std::to_string(width2/digit_size) + ") begin\n");
    tmp = tmp + scoper(4, "digit_mul_start_next = 1'b1;\n");
    tmp = tmp + scoper(4, "next_state = ST_WAIT;\n");
    tmp = tmp + scoper(3, "end\n");
    tmp = tmp + scoper(3, "else begin \n");
    tmp = tmp + scoper(4, "next_state = ST_OFFSET;\n");
    tmp = tmp + scoper(3, "end\n");
    tmp = tmp + scoper(2, "end\n");
    
    // Second state
    tmp = tmp + scoper(2, "ST_WAIT: begin\n");
    tmp = tmp + scoper(3, "if (digit_mul_done == 1'b1) begin\n");
    tmp = tmp + scoper(4, "digit_mul_start_next = 1'b0;\n");
    tmp = tmp + scoper(4, "counter_digits_next = counter_digits_next +1;\n");
    tmp = tmp + scoper(4, "next_state = ST_OFFSET;\n");
    tmp = tmp + scoper(3, "end\n");
    tmp = tmp + scoper(3, "else begin \n");
    tmp = tmp + scoper(4, "next_state = ST_WAIT;\n");
    tmp = tmp + scoper(3, "end\n");
    tmp = tmp + scoper(2, "end\n");
    
    // Third state
    tmp = tmp + scoper(2, "ST_OFFSET: begin\n");
    tmp = tmp + scoper(3, "next_c = next_c + (short_c << "+ std::to_string(digit_size) + " *(counter_digits_next-1));\n");
    tmp = tmp + scoper(3, "next_state = ST_RST;\n");
    tmp = tmp + scoper(2, "end\n");
    
    // Fourth state
    tmp = tmp + scoper(2, "ST_RST: begin\n");
    tmp = tmp + scoper(3, "local_rst = 1'b1;\n");
    tmp = tmp + scoper(3, "next_state = ST_RUN;\n");
    tmp = tmp + scoper(2, "end\n");

    tmp = tmp + scoper(1, "endcase\n");
    tmp = tmp + scoper(0, "end\n");
    return tmp; // no pipelining version  
   }
}

// multiplier inside the sbm_digitized
std::string VerilogFactory::getMulLogic_multiplier_inside_sbm_digitized(int width1, int width2, int digit_size, int pipeline) {
	std::string tmp;

	if (pipeline == 1){
    
    // Multiplier module inside the digitized version
    
    tmp = scoper(0, "always @ (posedge clk) begin \n");
		tmp = tmp + scoper(1, "if ((rst == 1'b1) || (local_rst == 1'b1)) begin\n");
    tmp = tmp + scoper(2, "c <= {SHORTA+SHORTB { 1'b0}};\n");
    tmp = tmp + scoper(2, "count <= 12'd0;\n");
    tmp = tmp + scoper(2, "digit_mul_done <= 1'b0;\n");
		tmp = tmp + scoper(1, "end\n");
   
    tmp = tmp + scoper(1, "else begin\n");
    tmp = tmp + scoper(2, "if (digit_mul_start == 1'b1) begin\n");
    tmp = tmp + scoper(3, "if (count < SHORTB) begin\n");
    tmp = tmp + scoper(4, "if (b[count] == 1) begin\n");
    tmp = tmp + scoper(5, "c <= c + (a << count);\n");
		tmp = tmp + scoper(4, "end\n");
    tmp = tmp + scoper(5, "count <= count + 12'd1;\n");
    tmp = tmp + scoper(3, "end\n");
    tmp = tmp + scoper(3, "else begin\n");
    tmp = tmp + scoper(4, "digit_mul_done <= 1'b1;\n");
    tmp = tmp + scoper(3, "end\n");
    tmp = tmp + scoper(2, "end\n");
    tmp = tmp + scoper(1, "end\n");
    tmp = tmp + scoper(0, "end\n");
    return tmp; // no pipelining version  
   }
}

std::string VerilogFactory::scoper(const int level, const std::string text) {
	std::stringstream input(text);
	std::stringstream output;
	int i = 0;

	std::string tmp; // one string that has as many tabs as needed
	while (i!= level) {
		tmp = tmp + "\t";
		i++;
	}
	
	std::string to;
	bool again = false;
	while (std::getline(input,to,'\n')) {
		if (again) {
			output << std::endl;
			output << tmp << to;
		}
		else {
			again = true;
			output << tmp << to;
		}
	}
	
	return output.str();
}


