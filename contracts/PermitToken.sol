// SPDX-License-Identifier: GPL-3.0
pragma solidity ^ 0.8.7;



contract PermitToken {

 function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }


function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    

    string public name = "GaslessGaslessPermit Approval Token";
    string public symbol = "GAT";
    string public version = "1";
    uint256 public totalSupply;

    mapping(address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    mapping(address=>uint) public nonceArr;

    function balanceOfAccount(address _account)external view returns(uint){
        return balanceOf[_account];
    }

    event Transfer(address _holder, address _destination, uint _amount);

    function transferFrom(address _holder, address _spender, uint _amount)external returns(bool){
        require(balanceOf[_holder]>=_amount,"Holder does not have sufficient balance");
        if(_holder!=msg.sender && allowance[_holder][msg.sender]!=type(uint128).max){
            require(allowance[_holder][msg.sender]>=_amount);
            allowance[_holder][msg.sender] = sub(allowance[_holder][msg.sender], _amount);
        balanceOf[_holder] = sub(balanceOf[_holder], _amount);
        balanceOf[_spender] = add(balanceOf[_spender], _amount);
        }
        emit Transfer(_holder,_spender,_amount);
        return true;
    }

    

    
    function mint(address _reciever, uint _amount) external payable{
        balanceOf[_reciever] = add(balanceOf[_reciever], _amount);
        totalSupply = add(totalSupply, _amount);
        emit Transfer(address(0), _reciever, _amount);
    }

    function burn(address _burner, uint _amount) external payable{
        require(balanceOf[_burner]>=_amount);
        require(_burner!=msg.sender);

        balanceOf[_burner] = sub(balanceOf[_burner], _amount);
        totalSupply = sub(totalSupply, _amount);
        emit Transfer(_burner, address(0), _amount);
    }

bytes32 public DOMAIN_SEPARATOR = keccak256(
    abi.encode(
        keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
        keccak256(bytes(name)),
        keccak256(bytes(version)),
        80001,//Testnet chainID
        address(this)
));

    function permit(address _holder, address _spender, uint nonce, uint deadline, bool allowed, uint8 v, bytes32 r, bytes32 s)external{
        bytes32 conditions =
            keccak256(abi.encodePacked(
               hex"1901",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode( keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                                     _holder,
                                     _spender,
                                     nonce,
                                     deadline,
                                     allowed))
        ));

        require(_holder != address(0));
        require(_holder == ecrecover(conditions, v, r, s));
        require(deadline == 0 || block.timestamp <= deadline);
        require(nonce == nonceArr[_holder]++);
        uint _amount = allowed ? type(uint256).max : 0;
        allowance[_holder][_spender] = _amount;

    }


    
}