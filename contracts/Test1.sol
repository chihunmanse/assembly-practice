// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Test1 {
    uint256 private number = 5;
    mapping(address => uint256) public mappingNumbers;

    error RevertTest();

    bytes32 public hashWord;

    function getNumber() external view returns(uint256) {
        return number;
    }

    function getNumberYul() external view returns(uint256) {
        assembly {
            let _number := sload(number.slot)

            let ptr := mload(0x40)

            mstore(ptr, _number)

            return(ptr, 0x20)
        }
    }

    function setNumber(uint256 _number) external {
        number = _number;
    }

    function setNumberYul(uint _number) external { 
        assembly { 
            let slot := number.slot 
            
            sstore(slot, _number) 
        } 
    }

    function revertTest() external {
        revert RevertTest();
    }

    function revertTestYul() external {
        bytes4 errorSelector = RevertTest.selector;

        assembly {
            mstore(0x00, errorSelector)
            revert(0x00, 0x04)
        }
    }
    
}