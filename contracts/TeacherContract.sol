// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
pragma experimental ABIEncoderV2;
import "./UniversityContract.sol";

contract TeacherContract {
    UniversityContract public universityContract; 
    constructor(address _universityContractAddress){
        universityContract = UniversityContract(_universityContractAddress);    
    }
    
    function _giveMark(uint _studentCode, uint _courseCode, uint _givenMark) public returns(uint){      
        address _teacherAddress = msg.sender;
        return universityContract._giveMark(_teacherAddress,_studentCode, _courseCode, _givenMark );
    }
}