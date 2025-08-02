// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
contract Storage{
    uint256 private value;
    function set_value(uint256 _value) public {
        value=_value;
    }
    function get_value() public view returns(uint256){
        return value;
    }
    function increment_value() public{
        value++;
    }
    function decrement_value() public {
        value--;
    }
}