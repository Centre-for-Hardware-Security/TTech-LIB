#include "verilogfactory.h"

void VerilogFactory::setName(std::string name) {
	_name = name;
}

void VerilogFactory::addIO(const std::string name, const std::string direction) {
	_ionames.push_back(name);
	_iodirs.push_back(direction);
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

	return tmp;
}

