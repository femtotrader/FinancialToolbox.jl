using FinancialToolbox
if !(VERSION.major == 0 && VERSION.minor <= 6)
    using Test, Dates
else
    using Base.Test
end
function yearFractionTester(StartDate, EndDate, MatlabResults, TestToll = 1e-14)
    for i = 0:FinancialToolbox.currMaxImplemented
        @test(abs(MatlabResults[i+1] - yearfrac(StartDate, EndDate, i)) < TestToll)
    end
    return
end

StartDate = Date(1992, 12, 14);
EndDate = Date(1996, 2, 28);
@test(-yearfrac(StartDate, StartDate, 0) == 0)
@test(-yearfrac(StartDate, EndDate, 0) == yearfrac(EndDate, StartDate, 0))
MatlabResults = [3.20821917808219; 3.20555555555556; 3.25277777777778; 3.20821917808219; 3.20555555555556; 3.20555555555556; 3.20555555555556; 3.20821917808219; 3.20821917808219; 3.25277777777778; 3.20821917808219; 3.20555555555556; 3.20765027322409];
yearFractionTester(StartDate, EndDate, MatlabResults);

EndDate2 = Date(1996, 2, 29);
MatlabResults2 = [3.21095890410959; 3.20833333333333; 3.25555555555556; 3.21095890410959; 3.20833333333333; 3.20833333333333; 3.20833333333333; 3.21095890410959; 3.21095890410959; 3.25555555555556; 3.21095890410959; 3.20833333333333; 3.21038251366122];
yearFractionTester(StartDate, EndDate2, MatlabResults2);

EndDate3 = Date(2026, 2, 28);
MatlabResults3 = [33.2301369863014; 33.2055555555556; 33.6916666666667; 33.2301369863014; 33.2055555555556; 33.2055555555556; 33.2055555555556; 33.2082191780822; 33.2301369863014; 33.6916666666667; 33.2301369863014; 33.2055555555556; 33.2080844374580];
TestToll = 1e-13;
yearFractionTester(StartDate, EndDate3, MatlabResults3, TestToll);

StartDate2 = Date(1992, 2, 29);
EndDate4 = Date(1996, 2, 29);
MatlabResults4 = [3.99180327868852; 4; 4.05833333333333; 4.00273972602740; 3.99722222222222; 4; 4; 4; 3.99180327868852; 4.05833333333333; 4.00273972602740; 4; 4]
yearFractionTester(StartDate2, EndDate4, MatlabResults4);

StartDate3 = Date(1992, 3, 30);
EndDate5 = Date(1996, 12, 31);
MatlabResults5 = [4.75890410958904; 4.75000000000000; 4.82500000000000; 4.75890410958904; 4.75000000000000; 4.75000000000000; 4.75000000000000; 4.75616438356164; 4.75890410958904; 4.82500000000000; 4.75890410958904; 4.75000000000000; 4.75409836065569]
yearFractionTester(StartDate3, EndDate5, MatlabResults5);

StartDate4 = Date(1992, 3, 31);
EndDate6 = Date(1996, 12, 30);
MatlabResults6 = [4.75342465753425; 4.75000000000000; 4.81944444444445; 4.75342465753425; 4.75000000000000; 4.75000000000000; 4.75000000000000; 4.75068493150685; 4.75342465753425; 4.81944444444445; 4.75342465753425; 4.75000000000000; 4.74863387978144]
yearFractionTester(StartDate4, EndDate6, MatlabResults6);

@test_throws(ErrorException, yearfrac(StartDate, EndDate3, FinancialToolbox.currMaxImplemented + 1));
@test_throws(ErrorException, yearfrac(StartDate, EndDate3, -1));

@test(daysact(Date(1992, 12, 14), Date(1992, 12, 13)) == -1)

##Excel test
@test(fromExcelNumberToDate(33952) == Date(1992, 12, 14))

println("Test Dates Passed")
