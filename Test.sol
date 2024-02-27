// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleContract {
    uint256 public value;

    constructor() {
        value = 0;
    }

    function setValue(uint256 _newValue) public {
        assert(_newValue <= 100000000); 
        require(                       
            _newValue <= 100000000
        );
        value = _newValue;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}