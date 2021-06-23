#ifndef VERILOGFACTORY_H
#define VERILOGFACTORY_H

#include <sstream>
#include <string>
#include <vector>
#include <map>
#include <iostream>

class VerilogFactory {
	private:
		std::string _name;
		std::vector<std::string> _ionames;
		std::vector<std::string> _iodirs;
		std::vector<std::string> _iotypes;
		std::vector<int> _iowidths;

		std::vector<std::string> _varnames;   	// we used _varnames to keep registers names
		std::vector<int> _varwidths;    	// we used _varwidths to set registers width
		std::vector<bool> _varpipes;   		// we used _varpipes to track pipeline registers

    		std::vector<std::string> _varnames_1; // we used _varnames_1 to keep wires names
		std::vector<std::string> _varnames_2; // we used _varnames_2 to keep parameter keyword in verilog
		std::vector<int> _varwidths_1;        // we used _varwidths_1 to set wires width
		std::vector<int> _varwidths_2;        // we used _varwidths_2 to set parameters width

	public:
		VerilogFactory();
		void setName(const std::string name);
		void addIO(const std::string name, const std::string direction);
		void addIO(const std::string name, const std::string direction, int width);
		void addVar(const std::string name, int width, bool pipeline);      // include register
		void addWire(const std::string name, int width);     // include wire
		void addAssign(int width); 
		void addParameter(const std::string name, int width);     // include parameter

		void genTempVars(int pipeline, bool inputs);
	std::string BoothPipeline(int pipeline, int width1);
       
	std::string getModuleDefinition();
	std::string getIODefinition();
	std::string getInternalDefinition();       
    std::string getInternalDefinitionWire();  
    std::string getInternalDefinitionParameter(); 
    std::string getInternalDefinition_SetFirst_OperandSize_for_sbm_digitized();
    std::string getInternalDefinitionAssignSetMSB_as_m_over_3_minus_1();
    std::string getInternalDefinitionAssignSetMSB_as_m_times_2_over_3_minus_1(); 
    std::string getInternalDefinitionAssignSetMSB_as_m_minus_1_for_3_way_TCM(); 
    std::string getInternalDefinitionAssignSetLSB_as_m_over_3();
    std::string getInternalDefinitionAssignSetLSB_as_m_times_2_over_3(); 
    std::string getInternalDefinitionAssignSetMSB_as_m_over_4();
    std::string getInternalDefinitionAssignSetMSB_as_m_times_2_over_4();
    std::string getInternalDefinitionAssignSetMSB_as_m_times_3_over_4();
    std::string getInternalDefinitionAssignSetMSB_as_m_minus_1_for_4_way_TCM();
    std::string getInternalDefinitionAssignSetLSB_as_m_over_4();
    std::string getInternalDefinitionAssignSetLSB_as_m_times_2_over_4();
    std::string getInternalDefinitionAssignSetLSB_as_m_times_3_over_4();
    std::string getTempVars(int pipeline);
	std::string getResetStatement(bool partial);
	std::string getMulLogicSimple(int pipeline);
	std::string getMulLogicSchoolbook(int width1, int width2, int pipeline);
    std::string getMulLogic_2_Way_Karatsuba_Step_1(int width1, int width2, int pipeline);
    std::string getMulLogic_2_Way_Karatsuba_Step_2(int width1, int width2, int pipeline);
    std::string getMulLogic_2_Way_Karatsuba_Step_3(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_1(int width1, int width2, int pipeline); 
	std::string getMulLogic_3_Way_TCM_Step_2_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_2_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_2_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_3_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_3_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_3_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_3_part_4(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_4_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_4_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_4_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_5(int width1, int width2, int pipeline);
    std::string getMulLogic_3_Way_TCM_Step_6(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_1(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_2_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_2_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_2_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_3_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_3_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_3_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_3_part_4(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_4_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_4_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_4_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_4_part_4(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_4_part_5(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_5_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_5_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_5_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_5_part_4(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_6_part_1(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_6_part_2(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_6_part_3(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_7(int width1, int width2, int pipeline);
    std::string getMulLogic_4_Way_TCM_Step_8(int width1, int width2, int pipeline);
	std::string getMulLogic_Booth_Step_1(int width1, int width2, int count, int pipeline);
	std::string getMulLogic_Booth_Step_2(int width1, int width2, int pipeline);
	std::string getMulLogic_Booth_Step_3(int width1, int width2, int pipeline);
	std::string getMulLogic_Booth_Step_4(int width1, int width2, int pipeline);
	std::string getMulLogic_Booth_Step_5(int width1, int width2, int pipeline);
    std::string getMulLogic_sbm_digitized_FSM_sequential_logic(int width1, int width2, int digit_size, int pipeline);
    std::string getMulLogic_sbm_digitized_FSM_combinational_logic(int width1, int width2, int digit_size, int pipeline);
    std::string getMulLogic_multiplier_inside_sbm_digitized(int width1, int width2, int digit_size, int pipeline);

	static std::string scoper(const int level, const std::string text);
	
	std::map<int, std::string> snippet;
		enum {
			ALWAYS,
			ALWAYS_ASTERIK,			
			RESET0,
			RESET1,
			END,
			ELSEBEGIN,
			SIMPLE,
			ENDMODULE
		};
		
};

#endif
