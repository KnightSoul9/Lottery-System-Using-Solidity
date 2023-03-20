//SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.5.0 <0.9.0;

contract Lottery{
 address public manager;
 address payable[] public participants;//because we have to pay the winner back
 uint randNonce = 0; 
 constructor(){
    manager=msg.sender;//making the manager the owner of the contract 
 }
 receive() external payable{
     require(msg.value == 1 ether);
     participants.push(payable(msg.sender));
 }  
 //Function to get balance present in the contract 
 function getBalance() public view returns(uint){
    require(msg.sender==manager);
    return address(this).balance;
 }
// Function to generate random number
  function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,participants.length)));
    }
// Selecting the winner and sending the win amount in the winner account 
 function selectWinner() public {
    require(msg.sender==manager);
    require(participants.length>=3);
    uint r=random();
    address payable winner;
    uint index = r % participants.length;
    winner = participants[index];
    winner.transfer(getBalance());
    participants = new address payable[](0);
 }
}
