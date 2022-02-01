// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Owned.sol";

contract Faucet is Owned {
    uint public numOfFunders;
    mapping(address => bool) private funders;
    mapping(uint => address) private lutFunders;

    modifier limitWithdraw(uint withdrawAmount) {
        require(
            withdrawAmount < 1000000000000000000,
            "Cannot withdraw more than 0.1 ether"
        );
        _;
    }
 
    receive() external payable {}

    function addFunds() external payable {
        address funder = msg.sender;

        if (!funders[funder]) {
            uint index = numOfFunders++;
            funders[funder] = true;
            lutFunders[index] = funder;
        }
    }

    function withdraw(uint withdrawAmount) external limitWithdraw(withdrawAmount) {
        payable(msg.sender).transfer(withdrawAmount);

    }

    function getAllFunders() external view returns (address[] memory) {
        address[] memory _funders = new address[](numOfFunders);

        for (uint i = 0; i < numOfFunders; i++) {
            _funders[i] = lutFunders[i];
        }

        return _funders;
    }

    function getFunderAtIndex(uint8 index) external view returns(address) {
        return lutFunders[index];
    }
}