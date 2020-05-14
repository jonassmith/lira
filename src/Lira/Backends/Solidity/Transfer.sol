/**
 * MIT License
 *
 * Copyright (c) 2019 eToroX Labs
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

pragma solidity ^0.6.4;


contract ifWithin {
    uint128 _memoryExpressionRefs;
    uint _timeInitiated;
    uint _timeWithin;
    uint _time;


    function activate() {
        _timeInitiated = now;
    }

    function execute() {


        if (_timeInitiated + _timeWithin>= now) {
            //  The new plan is to use two bits to set the value of the memExp:
            //  one if the memExp is evaluated to true, and one for false:
            //  The empty value 00 would then indicate that the value of this
            //  memExp has not yet been determined. The value 11 would be an invalid
            //  value, 01 would be false, and 10 true.

            // Check if exp is true
            if(exp &&
              // and has not already been true
              _memoryExpressionRefs & (1 << ((exp.count - 1) * 2)) == 1 &&
              _memoryExpressionRefs & (1 << ((exp.count - 1) * 2 - 1)) == 0) {
                _memoryExpressionRefs.push(0x3 ** (2 * exp.count));
                {c1}
            }
            // Check if exp is false
            if(!exp  &&
              // And has not already been true
              _memoryExpressionRefs & (1 << ((exp.count - 1) * 2)) == 0 &&
              _memoryExpressionRefs & (1 << ((exp.count - 1) * 2 - 1)) == 1) {
                uint256 tempMemExpRefs;
                tempMemExpRefs = 0x1 << (2 * exp.count);
                _memoryExpressionRefs = _memoryExpressionRefs | tempMemExpRefs;
            }
        }
        else {
          {c2}
        }

    }
}

contract Erc20 {

  // Datastructures holding internal state
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256)) allowed; // provider2spender2balance

  // Events
  event TransferEvent(address indexed _from, address indexed _to, uint256 _value);
  event ApprovalEvent(address indexed _owner, address indexed _spender, uint256 _value);

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;

  function Erc20(string _name, string _symbol, uint8 _decimals, uint256 _initialSupply){
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    totalSupply = _initialSupply;
  }

  function transfer(address _to, uint256 _value) returns (bool success){
    // Check if the sufficient balance is present
    if (balanceOf[msg.sender] < _value) return false;

     // check for overflow
    if (balanceOf[_to] + _value < balanceOf[_to]) return false;

    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    TransferEvent(msg.sender, _to, _value);

    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
    // Check if the sufficient balance is present
    if (balanceOf[msg.sender] < _value) return false;

    // Check if msg.sender has been approved to transfer from _from
    if (allowed[_from][msg.sender] < _value) throw;

    // Check for overflow
    if (balanceOf[_to] + _value < balanceOf[_to]) return false;

    // Transfer the tokens and subtract from the allowance
    allowed[_from][msg.sender] -= _value;
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    TransferEvent(msg.sender, _to, _value);

    return true;
  }

  function approve(address _spender, uint256 _value) returns (bool success){
    allowed[msg.sender][_spender] = _value;
    ApprovalEvent(msg.sender, _spender, _value);
    return true;
  }
}
