// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint public num;

    function setVars(uint _num) public payable {
        num = _num;
    }
}

contract A {
    uint public num;
    address public sender;

    // store the address of contract B
    constructor(address _owner) {
        sender = _owner;
    }

    function setValue(uint _num) public payable {
        // make a delegatecall to interact with contract B
        (bool success, bytes memory returndata) = sender.delegatecall(
            abi.encodeWithSelector(
                B.setVars.selector,
                _num
            )
        );

        // check whether success is true or false
        require(success, "Delegate call to ContractB failed");
    }
}
