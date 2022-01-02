// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
pragma experimental ABIEncoderV2;
import "./UniversityContract.sol";
contract StudentContract {
    UniversityContract public universityContract;
    
    constructor(address _universityContractAddress){
        universityContract = UniversityContract(_universityContractAddress);       
    }

    function _getMyCourses() public view returns (string[] memory) {
     return universityContract._getMyCourses(msg.sender);
    }

    
    function getAllMarks()public view returns (UniversityContract.Mark[] memory){
        address studentAddress = msg.sender;
        return universityContract.getAllMarks(studentAddress);
    }
} 