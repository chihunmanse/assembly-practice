// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract GetterAndSetter {
    uint256 private number = 5;
    uint256[] private array = [1, 2, 3];
    mapping(address => uint256) private numberByAddress;

    constructor() {
        numberByAddress[msg.sender] = 100;
    }

    /*
     *  Getter
     */
    function getNumber() external view returns (uint256) {
        assembly {
            let _number := sload(number.slot)

            mstore(0x40, _number)

            return(0x40, 32)
        }
    }

    function getNumberOfArray(uint256 _index) external view returns (uint256) {
        assembly {
            mstore(0x40, array.slot)

            let slot := add(keccak256(0x40, 32), _index)

            let _number := sload(slot)

            mstore(0x40, _number)

            return(0x40, 32)
        }
    }

    function getMappingValue() external view returns (uint256) {
        assembly {
            mstore(0x40, caller())

            mstore(add(0x40, 32), numberByAddress.slot)

            let _value := sload(keccak256(0x40, 64))

            mstore(0x40, _value)

            return(0x40, 32)
        }
    }

    /*
     *  Setter
     */
    function setNumber(uint256 _number) external {
        assembly {
            sstore(number.slot, _number)
        }
    }

    function setNumberOfArray(uint256 _index, uint256 _number) external {
        assembly {
            let length := sload(array.slot)

            if lt(length, add(_index, 1)) {
                revert(0, 0)
            }

            mstore(0x40, array.slot)
            let slot := add(keccak256(0x40, 32), _index)

            sstore(slot, _number)
        }
    }

    function setMappingValue(uint256 _value) external {
        assembly {
            mstore(0x40, caller())

            mstore(add(0x40, 32), numberByAddress.slot)

            let slot := keccak256(0x40, 64)

            sstore(slot, _value)
        }
    }
}
