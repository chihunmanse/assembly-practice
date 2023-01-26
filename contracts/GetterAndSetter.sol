// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract GetterAndSetter {
    uint256 private number = 5;
    uint256[] private array = [1, 2, 3];
    mapping(address => uint256) private numberByAddress;

    struct Struct {
        uint256 num1;
        uint256 num2;
        uint128 num3;
        uint128 num4;
    }

    Struct private numStruct = Struct(1, 2, 3, 4);

    mapping(uint256 => Struct) private structByNumber;

    constructor() {
        numberByAddress[msg.sender] = 100;
        structByNumber[5] = Struct(6, 7, 8, 9);
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

    function getStruct()
        external
        view
        returns (uint256 num1, uint256 num2, uint128 num3, uint128 num4)
    {
        assembly {
            let num34 := sload(add(numStruct.slot, 2))

            num1 := sload(numStruct.slot)
            num2 := sload(add(numStruct.slot, 1))
            num3 := and(num34, 0xffffffffffffffffffffffffffffffff)
            num4 := shr(128, num34)
        }
    }

    function getStructMapping(
        uint256 _index
    )
        external
        view
        returns (uint256 num1, uint256 num2, uint128 num3, uint128 num4)
    {
        Struct storage _numStruct = structByNumber[_index];

        assembly {
            num1 := sload(_numStruct.slot)
            num2 := sload(add(_numStruct.slot, 1))

            let w := sload(add(_numStruct.slot, 2))
            num3 := and(w, 0xffffffffffffffffffffffffffffffff)
            num4 := shr(128, w)
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

    function setStruct(
        uint256 _num1,
        uint256 _num2,
        uint128 _num3,
        uint128 _num4
    ) external {
        assembly {
            sstore(numStruct.slot, _num1)
            sstore(add(numStruct.slot, 1), _num2)

            let num34 := sload(add(numStruct.slot, 2))

            num34 := and(num34, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            num34 := or(num34, and(_num3, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))

            num34 := and(num34, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            num34 := or(
                num34,
                shl(128, and(_num4, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            )

            sstore(add(numStruct.slot, 2), num34)
        }
    }

    function setStructMapping(
        uint256 _index,
        uint256 _num1,
        uint256 _num2,
        uint128 _num3,
        uint128 _num4
    ) external {
        assembly {
            mstore(0x40, _index)

            mstore(add(0x40, 32), structByNumber.slot)

            let slot := keccak256(0x40, 64)

            sstore(slot, _num1)
            sstore(add(slot, 1), _num2)

            let num34 := sload(add(slot, 2))

            num34 := and(num34, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            num34 := or(num34, and(_num3, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))

            num34 := and(num34, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            num34 := or(
                num34,
                shl(128, and(_num4, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            )

            sstore(add(slot, 2), num34)
        }
    }
}
