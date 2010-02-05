###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Joel Grand-Guillaume 2009 
#    Copyright Camptocamp SA
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 Afero of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

@modules = false
@test_result = false
# Before do
#     # Initiate vars used to stored object used trought the tests
# end


##############################################################################
#           Scenario: install_and_run_base_module_quality
##############################################################################

##############################################################################
Given /^I want to run the quality tests provided by base_module_quality on installed module$/ do
  @modules=IrModuleModule.find(:all,:domain=>[['name','=','base_module_quality']])
  @modules.should be_true
end
##############################################################################
When /^I insall the base_module_quality$/ do
  res = IrModuleModule.install_modules(@modules)
  res.should be_true
end
##############################################################################
And /^run the quality check on every installed module$/ do
  @modules=IrModuleModule.find(:all,:domain=>[['state','=','installed']])
  @modules.should be_true
  @test_result=IrModuleModule.run_base_quality_test(@modules)
  @test_result.should be_true
end
##############################################################################
Then /^I should have a report on every module$/ do
  @modules.count.should == @test_result.count
end
##############################################################################
Then /^all module, except (\w+), should have a final score greater than (.*) percent$/ do |except_module,percent|
  @test_result.each do |test_case|
    if not test_case.name == except_module:
      test_case.final_score.to_f.should > percent.to_f/100
    end
  end
end
##############################################################################
And /^here is a summary \(Not implemented yet\.\.\)$/ do
  @test_result.each do |test_case|
    output= ModuleQualityCheck.get_formatted_results(test_case)
    # TODO Improve the output to appear into the test result...
    # Don't find how to do it
    # print output
  end
end
