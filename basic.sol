pragma solidity >=0.4.16

contract SimpleStorage{
    unit storedData;
    function set(uint x) {
        storedData = x ;
    }
    function Get()public view returns (uint) {
        return storedData;
        
    }
}

contract Coin {
    address public minter;
    mapping(address => uint) public balance;
    //Events allow cients to recreate coins to an address;
    //conract change your declare 
    event Sent(address from, address to, uint amount);

    constructor(){
        minter = msg.sender;

    }

    function mint(address receiver, uint amount)public {
        require(msg.sender == minter);
        balances[receiver] += amount;

    }

    error  InsufficientBalance(uint requested, uint available );

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], InsufficientBalance(amount, balances[msg.sender]));
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.Sender, receiver, amount);        
    }

    function balances(address acount) external view returns (uint) {
        return balances[account];
    }
    
 }

 contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;

    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairPerson;


    mapping(address => Voter ) public voters;

    Proposal[] public proposals;

    constructor(bytes32[] memory proposalsNames) {
        chairPerson = msg.sender;
        voters[chairPerson].weight = 1;

        for(uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0,
            }));
        }
    }

    function giveRightToVote(address voter) external{
        require(msg.sender == chairPerson,);
        require(!voters[vote].voted,);
        require(voters[voter].weight ==0);
        voters[voter].weight = 1;

    }
    function delegate(address to) external {
        Voter Storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "you already voted");
        
        
    }


    //Making Payment 
    function contructPaymentMessage(contractAddress, amount) {
        return abi.soliditySH3(
            ["address", "uint256"],
            ["contractAddress, amount]
        );
    }

    function signMessage(messsage, callback) {
        web3.eth.personal.sign(
            "ox" + message.toString("hex")
            web3.eth.defaultAccount, callback
        );
    }
    //contractAddress is used to prevent cross-contract replay attacks 
    //amount , in wei, how much ether should be send 
    function signPayment(contractAddress, amount , callback){
        var message = contractPaymentMessage(contractAddress, amount);
        signMessage(message,callback);
    }
 }

 