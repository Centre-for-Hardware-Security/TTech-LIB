#ifndef VERILOGFACTORY_H
#define VERILOGFACTORY_H

#include <string>
#include <vector>

class VerilogFactory {
	private:
		std::string _name;
		std::vector<std::string> _ionames;
		std::vector<std::string> _iodirs;
	public:
		void setName(const std::string name);
		void addIO(const std::string name, const std::string direction);
		std::string getModuleDefinition();
};

#endif
