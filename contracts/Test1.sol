// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Test1 {
    uint256 private number = 5;
    mapping(address => uint256) public mappingNumbers;

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
    
}