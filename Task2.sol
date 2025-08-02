// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract multi_send {
    address[] ethereum_addresses;
    constructor(address[] memory _ethereum_addresses) {
        require(
            _ethereum_addresses.length > 0,
            "At least one address required"
        );
        for (uint256 i = 0; i < _ethereum_addresses.length; i++) {
            ethereum_addresses.push(_ethereum_addresses[i]);
        }
    }
    function send_ether() public payable {
        require(msg.value > 0, "Send some ether to distribute");
        uint256 equal_balance = msg.value;
        equal_balance = equal_balance / ethereum_addresses.length;
        for (uint256 i = 0; i < ethereum_addresses.length; i++) {
            payable(ethereum_addresses[i]).transfer(equal_balance);
        }
    }
    function getbalance(
        uint256 eth_address_array_index
    ) public view returns (uint256) {
        return ethereum_addresses[eth_address_array_index].balance;
    }
}
// Ethereum Addresses in remix
// ["0x17F6AD8Ef982297579C203069C1DbfFE4348c372","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]
