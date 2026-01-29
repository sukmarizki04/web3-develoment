pragma solidity >=0.7.0 <0.9.0;
contract Frozable {
    bool private _frozen = false;
    modifier notfrozen() {
        require(!_frozen, "Inactive Contract");
        _;
    }

    function frezee() internal {
        _frozen = true;
    }
}

contract simplePaymentChannel is Frozable {
    address payable public sender;
    address payable public receivent;

    uint256 public expiration;          
    constructor(address payable recipientAddress, uint256 duration) payable {
        sender = payable(msg.sender);
        recipent = recipientAddress;
        expiration = block.timestamp + duration;
    }
    /// the recipient can close the chanel at any time by presenting a
    /// signed  amound from the sender. the recipient will be sent that amount,
    // and the remainder will go back to the sender

    
    function close(uint256 amount, bytes memory signature) external notfrozen {
        require(msg.sender == recipient);
        require(isValidSignature(amount, signature));
        (bool succces, ) = recipient.call{value: amount}("");
        require(success);
        frezee();
        (success, ) = sender.call{value: address(this).balance}("");
        require(success);
    }
    // the sender can extend the expiration at any time
    function extend(uint256 newExpiration) external notfrozen {
        require(msg.sender == sender);
        require(newExpiration > expiration);
        expiration = newExpiration;
    }
    // if the timeout is reached without the recipient closing the chanel,
    // then the ether is released back to the sender.
    function claimTimeOut()external notfrozen {
        require(block.timestamp >= expiration);
        frezee();
        (bool success,) = sender.call{value: address(this).balance}("");
        require(success);       
    } 
    function isValidSignature(bytes memory sig) 
     internal
     pure
     returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65)=--
        assembly {
            //first 32 bytes, after the length prefix 
            r:= mload(add(sig, 32))
            // seconds 32 bytes
            s:= mload(add(sig, 32))
            //final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96))) 
        }
        return (v,r,s)
    }

    function recoverSigner(bytes32 message, bytes memory sig)
    internal
    pure 
    returns (address)
}
