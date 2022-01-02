// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
pragma experimental ABIEncoderV2;
import "./UniversityContract.sol";

contract Controller {
    UniversityContract public universityContract;
  
    constructor(address _universityContractAddress){
        universityContract = UniversityContract(_universityContractAddress);    
    }

 
}